# AWX Lab User Guide

How to work with **Projects, Job Templates, Workflows, and Jobs** on the shared AWX lab VM, and how to review job output.

> **Audience:** all lab users.
> **Rule of thumb:** this VM is shared. Prefix everything you create with your username, test small (`limit` + check mode), and clean up after yourself.

---

## Table of Contents

1. [Core Concepts](#1-core-concepts)
2. [Shared-Lab Ground Rules](#2-shared-lab-ground-rules)
3. [Projects](#3-projects)
4. [Job Templates](#4-job-templates)
5. [Workflows](#5-workflows)
6. [Launching and Managing Jobs](#6-launching-and-managing-jobs)
7. [Reviewing Job Output](#7-reviewing-job-output)
8. [Troubleshooting Cheat Sheet](#8-troubleshooting-cheat-sheet)
9. [Security Rules](#9-security-rules)
10. [Admin Notes](#10-admin-notes)
11. [Quick Reference](#11-quick-reference)

---

## 1. Core Concepts

| Object | What it is | Analogy |
|---|---|---|
| **Organization** | Top-level container for users, teams, and resources | A company / tenant |
| **Team** | A group of users that share permissions | A department |
| **Inventory** | The hosts and groups Ansible runs against | The target list |
| **Credential** | Stored login, SSH key, token, or vault secret (encrypted by AWX) | A key ring |
| **Project** | A link to a Git repo (or local path) containing playbooks | The code |
| **Execution Environment (EE)** | Container image that runs the playbook (Ansible + collections) | The runtime |
| **Job Template** | Saved "recipe": *this playbook* + *this inventory* + *these credentials* | A saved command |
| **Workflow Job Template** | A chain/graph of templates, syncs, approvals, and logic | A pipeline |
| **Job** | One execution of a job template (has its own output) | One run |
| **Workflow Job** | One execution of a workflow (contains child jobs) | One pipeline run |

**Typical flow:**

```
Git repo ──► Project ──┐
Inventory ─────────────┼──► Job Template ──► Job ──► Output / Events
Credentials ───────────┘         │
                                 └──► used as a node in a Workflow Job Template
```

---

## 2. Shared-Lab Ground Rules

### 2.1 Naming convention

Prefix every object you create so others can tell what is yours:

```
<username>-<purpose>-<detail>

alice-webserver-deploy          (job template)
alice-lab-playbooks             (project)
alice-patch-and-reboot-wf       (workflow)
```

Shared / team-owned objects use a team prefix instead (`team-net-...`). Do **not** rename or edit objects that do not carry your name.

### 2.2 Do and don't

| ✅ Do | ❌ Don't |
|---|---|
| Use **Limit** to target one or two hosts while testing | Run against `all` while testing |
| Run **Check mode** (dry run) first when available | Run destructive playbooks without a dry run |
| Use stored **Credentials** in AWX | Paste passwords/keys into playbooks, surveys, or extra vars |
| Delete your test templates/projects when finished | Leave dozens of old test objects behind |
| Check the **Jobs** list before launching big runs (avoid collisions) | Cancel jobs you did not start |
| Ask an admin for a role if you lack permissions | Share your account or ask for admin "for convenience" |

### 2.3 Permissions (RBAC) in short

Access is granted by **role** on each object. Users get the least access they need.

| Role | Can do |
|---|---|
| **Read** | See the object |
| **Execute** | Launch a template/workflow |
| **Use** | Attach the object (inventory, credential, project) to a template |
| **Update** | Sync a project / inventory source |
| **Admin** | Edit and delete the object, manage its permissions |

If a button is greyed out or missing, you most likely lack the needed role. Ask the lab admin; do not work around it.

---

## 3. Projects

A **Project** tells AWX where your playbooks live. In this lab, projects should be Git-based.

### 3.1 Recommended repo layout

```
my-lab-playbooks/
├── playbooks/
│   ├── ping.yml
│   └── deploy_web.yml
├── roles/
│   └── webserver/
├── collections/
│   └── requirements.yml      # collections AWX installs on project sync
├── roles/
│   └── requirements.yml      # roles AWX installs on project sync (optional)
└── README.md
```

> AWX only installs `collections/requirements.yml` / `roles/requirements.yml` during **project sync**. If a collection is missing at runtime, check this file first (or use a custom EE).

### 3.2 Create a project

1. **Resources → Projects → Add**
2. Fill in:
   - **Name:** `<username>-<repo-purpose>`
   - **Organization:** your organization
   - **Execution Environment:** the lab default unless told otherwise
   - **Source Control Type:** `Git`
   - **Source Control URL:** your repo URL (HTTPS or SSH)
   - **Source Control Branch/Tag/Commit:** e.g. `main` (leave blank for default branch)
   - **Source Control Credential:** a stored credential, for private repos
3. **Options** (tick as needed):
   - ☑ **Clean**: remove local modifications before updating
   - ☑ **Delete**: wipe the working copy before updating
   - ☑ **Update Revision on Launch**: always pull the latest commit before each job *(great for dev, slower for big repos)*
4. **Save**. AWX starts an initial sync automatically.

### 3.3 Check project status

On **Resources → Projects**, look at the **Status** column:

| Status | Meaning | Action |
|---|---|---|
| ✅ Successful | Synced; playbooks available | None |
| 🟡 Running / Pending | Sync in progress | Wait |
| ❌ Failed | Sync failed (bad URL, credential, branch, network, collections) | Click the project's **Jobs** tab and read the sync output ([section 7](#7-reviewing-job-output)) |
| ⚪ Never updated | Not synced yet | Click the 🔄 sync icon |

### 3.4 Updating after you push to Git

AWX does **not** see new commits until the project syncs. Either:
- Click the **🔄 Sync** icon on the project, or
- Enable **Update Revision on Launch**, or
- Set a **Schedule** on the project to sync periodically.

> Playbook not in the dropdown? Sync the project, then make sure the file is in the repo (not just local) and ends in `.yml`/`.yaml`.

### 3.5 Project housekeeping

- Delete projects you no longer use (this removes their local checkouts from the VM).
- Don't point many projects at the same giant repo; use one project and several templates.

---

## 4. Job Templates

A **Job Template** is a reusable definition of *how to run a playbook*.

### 4.1 Create a job template

1. **Resources → Templates → Add → Add job template**
2. Fill in the key fields:

| Field | Guidance |
|---|---|
| **Name** | `<username>-<what-it-does>` |
| **Job Type** | `Run` (real run) or `Check` (dry run, no changes) |
| **Inventory** | Lab inventory (or yours). Required unless *Prompt on launch* is ticked |
| **Project** | Your project |
| **Playbook** | Pick from the dropdown (populated after a successful sync) |
| **Execution Environment** | Default unless you need special collections |
| **Credentials** | Machine credential (SSH) + any others needed (cloud, vault, network) |
| **Limit** | Host/group pattern, e.g. `web01` or `webservers:&dev` |
| **Verbosity** | `0 Normal` by default; raise to `1–3` for debugging |
| **Forks** | Parallel hosts; keep low in the lab (e.g. 5) |
| **Job Slicing** | Leave at 1 unless you know why |
| **Timeout** | Set a sane limit (e.g. 600 s) so stuck jobs don't hog the lab |

3. **Options:**
   - ☐ **Privilege Escalation**: tick for `become: true` tasks
   - ☐ **Provisioning Callbacks**: normally off
   - ☐ **Enable Webhook**: off unless integrating with Git
   - ☐ **Concurrent Jobs**: allow only if the playbook is safe to run in parallel
   - ☐ **Enable Fact Storage**: enable if you use cached facts
4. **Extra Variables:** non-secret defaults only, in YAML/JSON.

> ⚠️ **Never put passwords, tokens, or keys in Extra Variables, surveys, or playbooks.** Use a **Credential**. See [section 9](#9-security-rules).

### 4.2 Prompt on launch

Tick *Prompt on launch* next to a field (inventory, limit, credentials, verbosity, job type, extra vars, etc.) when users should choose a value at run time. For lab templates, **Limit** and **Job Type** are the best candidates.

### 4.3 Surveys (user-friendly input forms)

Use a **Survey** to ask for inputs safely:

1. Open the template → **Survey** tab → **Add**
2. Set **Question**, **Answer variable name**, **Type** (text, integer, multiple choice, etc.), default, and required flag
3. Toggle the survey **On**

Notes:
- Survey answers become extra variables in the playbook.
- Use the **Password** question type only for values that must be hidden in the UI, and still prefer a **Credential** for real secrets.

### 4.4 Playbook tips for shared use

```yaml
---
- name: Example safe-by-default playbook
  hosts: all
  gather_facts: true
  become: true

  tasks:
    - name: Show which host and user we are
      ansible.builtin.debug:
        msg: "Running on {{ inventory_hostname }} as {{ ansible_user_id }}"

    - name: Task that handles a secret (hide it from job output)
      ansible.builtin.command: /usr/local/bin/do-something
      environment:
        SERVICE_TOKEN: "{{ service_token }}"   # injected via an AWX credential, not hardcoded
      no_log: true
      changed_when: false
```

- Use `no_log: true` on tasks that touch secrets, so they never appear in output or the API.
- Make playbooks **idempotent** and support `--check` where possible.
- Use `ansible.builtin.debug` and `ansible.builtin.assert` liberally; they make output readable.

### 4.5 Launching a template

- **Templates →** click the 🚀 **Launch** icon, or open the template and click **Launch**.
- If prompts are enabled, a wizard appears (inventory, credentials, limit, variables, survey, **Preview**). Review the Preview, then **Launch**.
- You are taken straight to the job's **Output** page.

### 4.6 Managing templates

| Task | How |
|---|---|
| Copy a template | **Templates →** ⧉ **Copy** icon (then rename it with your prefix) |
| Schedule it | Template → **Schedules** tab → **Add** |
| Notify on result | Template → **Notifications** tab (email/Slack, if an admin configured it) |
| See past runs | Template → **Jobs** tab |
| Delete | Template → **Delete** (past job history is kept until cleanup) |

---

## 5. Workflows

A **Workflow Job Template** chains multiple steps into one pipeline with branching logic.

### 5.1 Node types

| Node type | Use |
|---|---|
| **Job Template** | Run a playbook |
| **Project Sync** | Pull latest code first |
| **Inventory Source Sync** | Refresh dynamic inventory |
| **Workflow Job Template** | Nest another workflow |
| **Approval** | Pause until a human approves or denies (with timeout) |

### 5.2 Link types (the logic)

| Link | Runs the next node when… |
|---|---|
| 🟢 **On Success** | the previous node succeeded |
| 🔴 **On Failure** | the previous node failed |
| 🔵 **Always** | the previous node finished, no matter the result |

**Convergence** (a node with several parents) can be set to **Any** (run when any parent link fires) or **All** (wait until all parent links fire).

### 5.3 Example workflow

```
[Project Sync] ──success──► [Inventory Sync] ──success──► [Deploy App]
                                                             │   │
                                                   success ◄─┘   └─► failure
                                                      │               │
                                                [Smoke Test]     [Rollback]
                                                      │               │
                                                      └──── always ───┘
                                                              ▼
                                                         [Notify / Report]
```

### 5.4 Create a workflow

1. **Resources → Templates → Add → Add workflow template**
2. Name it `<username>-<purpose>-wf`, choose organization, optionally inventory, extra vars, and survey
3. **Save**, then the **Visualizer** opens
4. Click **Start**, choose the first node (e.g. *Project Sync* or a Job Template)
5. Hover a node → **+** to add the next node, choose the link type (Success / Failure / Always)
6. Use the node's **Edit** (✏️) to override inventory, limit, credentials, or variables for that step
7. **Save** the visualizer

### 5.5 Passing data between steps

Use `set_stats` in a playbook to pass values to later nodes:

```yaml
- name: Publish a value to downstream workflow nodes
  ansible.builtin.set_stats:
    data:
      deployed_version: "{{ app_version }}"
    per_host: false
```

Downstream job templates receive `deployed_version` as an extra variable (make sure their *Prompt on launch → Variables* or the playbook accepts it).

### 5.6 Workflow tips

- Build and test each job template **on its own** before adding it to a workflow.
- Always put a **failure path** (rollback/notify) around risky steps.
- Add an **Approval** node before destructive or wide-scope steps.
- Keep workflows shallow; avoid nesting beyond one level for readability.
- Name nodes clearly (via the underlying template names), since the visualizer shows them.

---

## 6. Launching and Managing Jobs

### 6.1 Job statuses

| Status | Meaning |
|---|---|
| **New / Pending** | Created, waiting in the queue |
| **Waiting** | Waiting for capacity or a dependency (e.g. project sync) |
| **Running** | Executing now |
| **Successful** | Finished; no failed or unreachable hosts |
| **Failed** | Playbook ran, but at least one task/host failed |
| **Error** | The job couldn't run properly: platform-level issue (missing EE image, project/inventory problem, credential/connection to controller node, etc.) |
| **Canceled** | Stopped by a user |

> **Failed ≠ Error.** *Failed* is usually your playbook or target host. *Error* is usually the platform, EE, or setup, so read the **Details** and the start of the output.

### 6.2 Where to find jobs

- **Views → Jobs**: all jobs you can see (filter by status, type, name)
- **Template → Jobs tab**: runs of that template
- **Project / Inventory → Jobs tab**: sync runs
- **Dashboard**: recent job statuses at a glance

### 6.3 Job actions

| Action | Where | Notes |
|---|---|---|
| **Relaunch** | Job page / jobs list | "Relaunch on **all** hosts" or "on **failed** hosts only" |
| **Cancel** | Running job | Only cancel your own jobs |
| **Delete** | Finished job | Removes its output |
| **Download output** | Output page | Plain text `.txt` of stdout |

### 6.4 Scheduling

Template (or project/inventory) → **Schedules** → **Add**. Set start date/time, time zone, and repeat frequency. Review the **Occurrences** preview before saving. Disable or delete schedules you no longer need; they keep running otherwise.

### 6.5 Using the CLI / API (optional)

Create a **Personal Access Token** in the UI (**Users → your user → Tokens → Add**; scope *Write* if launching). Keep it **out of files and shell history**; load it into the current session only:

```bash
# Prompt for the token (not echoed, not saved to history)
read -rs -p "AWX token: " CONTROLLER_OAUTH_TOKEN; echo
export CONTROLLER_OAUTH_TOKEN
export CONTROLLER_HOST="https://awx.lab.example"      # replace with the lab URL
```

If the lab uses an internal/self-signed CA, point your tools at the CA bundle (e.g. `export REQUESTS_CA_BUNDLE=/path/to/lab-ca.pem`). **Do not disable TLS verification.**

Using the `awx` CLI:

```bash
awx job_templates list --name "alice-webserver-deploy"
awx job_templates launch <TEMPLATE_ID> --limit web01 --monitor    # follow output live
awx jobs list --status failed
awx jobs stdout <JOB_ID>                                            # full output
```

Using the REST API with `curl` (token goes in the header, never in the URL):

```bash
# Launch
curl -sS -X POST \
  -H "Authorization: Bearer ${CONTROLLER_OAUTH_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{"limit": "web01"}' \
  "${CONTROLLER_HOST}/api/v2/job_templates/<TEMPLATE_ID>/launch/"

# Plain-text output of a job
curl -sS -H "Authorization: Bearer ${CONTROLLER_OAUTH_TOKEN}" \
  "${CONTROLLER_HOST}/api/v2/jobs/<JOB_ID>/stdout/?format=txt"
```

Revoke tokens you no longer need.

---

## 7. Reviewing Job Output

Open any job from **Views → Jobs** (or straight after launching). The job page has these areas.

### 7.1 Job page layout

| Area | What you get |
|---|---|
| **Header** | Job name, status, who launched it, start/finish time, elapsed time |
| **Output tab** | Live/streamed Ansible output, host & task counters, search, filters |
| **Details tab** | Template, project, **revision (commit)**, inventory, credentials, limit, job type, verbosity, launched-by, extra vars, execution node, EE |
| **Relaunch / Cancel / Delete / Download** | Actions for the job |

Start with **Details** when something is odd: confirm it ran the *right commit*, *right inventory*, *right limit*, and *right credentials*.

### 7.2 The Output tab

- **Counters at the top**: Plays, Tasks, Hosts, Elapsed. Host counts are split into *OK / Changed / Failed / Unreachable / Skipped*.
- **Output pane**: standard Ansible stdout; expand/collapse each play and task with the arrows.
- **Search / Filter**: filter by host, task name, stdout text, or event type (e.g. failed events only).
- **Follow / Scroll controls**: auto-follow a running job, or jump to the end.
- **Click a task line** (or a host event) to open the **event details** panel, which shows the raw JSON result: `stdout`, `stderr`, `msg`, `rc`, `diff`, timing, etc. This is usually the fastest route to the real error.
- **Download**: saves the full text output for sharing or offline grep.

### 7.3 Reading Ansible output

```
PLAY [Example safe-by-default playbook] ****************************************

TASK [Gathering Facts] *********************************************************
ok: [web01]
fatal: [web02]: UNREACHABLE! => {"msg": "Failed to connect to the host via ssh..."}

TASK [Show which host and user we are] *****************************************
ok: [web01] => {"msg": "Running on web01 as root"}

PLAY RECAP *********************************************************************
web01   : ok=2  changed=0  unreachable=0  failed=0  skipped=0  rescued=0  ignored=0
web02   : ok=0  changed=0  unreachable=1  failed=0  skipped=0  rescued=0  ignored=0
```

| Result word | Meaning |
|---|---|
| `ok` | Task ran; no change was needed |
| `changed` | Task ran and changed something |
| `skipped` | `when:` condition was false |
| `failed` / `fatal` | Task failed on that host |
| `UNREACHABLE` | Could not connect (SSH, DNS, firewall, wrong credential/user) |
| `rescued` | A failure was handled by a `rescue:` block |
| `ignored` | A failure was ignored by `ignore_errors: true` |

**Always read the PLAY RECAP first** (bottom of output), then scroll up to the first `fatal`/`failed` line for the actual cause. Later failures are often just consequences of the first.

### 7.4 Step-by-step: investigate a failed job

1. **Status** at the top: Failed, Error, or Canceled?
2. **Details tab**: check project revision, inventory, limit, credentials, job type (Run vs Check).
3. **Output tab → filter to failed events** (or jump to the PLAY RECAP).
4. Find the **first** failed/unreachable task and click it to open the event JSON; read `msg`, `stderr`, `rc`.
5. **Fix** the cause (playbook, variable, credential, host, network).
6. **Re-run** with **Relaunch → on failed hosts** (or relaunch with a tighter `limit`).
7. Need more detail? Relaunch with **Verbosity 1–3** (see below).

### 7.5 Verbosity levels

| Level | Name | Use for |
|---|---|---|
| 0 | Normal | Day-to-day |
| 1 | Verbose | Show task results/more module output |
| 2 | More verbose | Show connection details, task paths |
| 3 | Debug | Connection/plugin debugging |
| 4 | Connection debug | SSH-level debugging (very noisy) |
| 5 | WinRM debug | Windows/WinRM troubleshooting |

> Higher verbosity can print **sensitive values**. Keep `no_log: true` on secret-handling tasks, avoid sharing verbose output outside the lab, and delete debug jobs when done.

### 7.6 Reviewing a Check-mode (dry run) job

- Launch with **Job Type: Check**.
- `changed` in check mode means *"would change"*; `ok` means *"already correct"*.
- Tasks that can't simulate (e.g. some `command`/`shell`) are skipped unless the playbook declares `check_mode: false` or `check_mode: true`.
- Review the **diff** output (if the playbook uses `--diff`/`diff: true`) before running for real.

### 7.7 Reviewing workflow output

1. Open the **Workflow Job** from **Views → Jobs** (type = *Workflow job*).
2. The **Visualizer-style view** shows each node with its status colour (green = success, red = failed, grey = not run/skipped, blue = running, orange/yellow = approval waiting).
3. Click a node → **View job** (or node details) to open that child job's own **Output**.
4. The **Details** tab of the workflow shows the overall status, who launched it, and the combined extra vars (including values passed via `set_stats`).
5. Check approval nodes: *Approved / Denied / Timed out* appears in the node and the **Activity Stream**.

Workflow status rule of thumb: the workflow fails if a node fails **and no failure/always link handles it**.

### 7.8 Reviewing project and inventory syncs

- **Project sync failed?** Resources → Projects → project → **Jobs** → open the failed *Source Control Update*. Typical causes: wrong URL/branch, bad Git credential, no network access to the Git host, invalid `requirements.yml`.
- **Inventory sync failed?** Resources → Inventories → inventory → **Sources** → source → **Jobs**. Typical causes: source credential invalid, plugin/collection missing in EE, API unreachable.

### 7.9 Other places to look

| Where | What it tells you |
|---|---|
| **Views → Activity Stream** | Who created/changed/launched/deleted what, and when (great in a shared lab) |
| **Dashboard** | Success/fail trend and recent jobs |
| **Administration → Instance Groups / Instances** *(admin)* | Capacity, running vs queued jobs |
| **Details → Execution node & EE** | Which node/image actually ran the job |
| **Notifications** | Email/Slack summaries of results (if configured) |

### 7.10 Output retention

Old jobs are removed by AWX's cleanup process (see [Admin Notes](#10-admin-notes)). **Download** any output you need to keep before it expires, and don't store sensitive output in shared folders.

---

## 8. Troubleshooting Cheat Sheet

| Symptom | Likely cause | What to check / do |
|---|---|---|
| Playbook missing from dropdown | Project not synced, wrong path, wrong branch | Sync the project; verify branch and file path |
| Project sync **Failed** | Bad URL/branch, Git credential, network, bad requirements file | Project → Jobs → sync output |
| Job status **Error** immediately | EE image can't be pulled/started, project not ready, platform issue | Job **Details** and the first lines of output; tell an admin if it's EE/platform |
| `UNREACHABLE! ... Permission denied` | Wrong SSH user/key/password in credential | Check the Machine credential and the inventory host vars (`ansible_user`) |
| `UNREACHABLE! ... Connection timed out` | Host down, firewall, wrong IP/DNS | Ping/SSH from a lab host; check inventory |
| `Missing sudo password` / `become` failure | Privilege escalation not enabled or no become password/credential | Tick **Privilege Escalation**; add become details to the credential |
| `ERROR! couldn't resolve module/action` | Collection missing from the EE | Add to `collections/requirements.yml` and re-sync, or ask for a custom EE |
| Job stuck in **Pending/Waiting** | Capacity full, another sync running, concurrency disabled | Check **Views → Jobs** for running jobs; wait or ask an admin |
| Job ran on wrong hosts | Limit/inventory wrong or prompted differently | **Details → Inventory, Limit** |
| Variable undefined | Wrong var name, missing survey/extra var, precedence override | Check extra vars, survey var names, inventory/group vars |
| Template "Launch" disabled | You lack **Execute** role, or required fields (inventory/credentials) missing | Check role; fill required prompts |
| Workflow stops early | A node failed with no failure/always link | Open the failed node's job; add a failure path |
| Secrets visible in output | Task missing `no_log` | Add `no_log: true`, delete the job, rotate the exposed secret, tell the lab admin |

---

## 9. Security Rules

These apply to everyone on the shared lab VM.

1. **No hardcoded secrets.** Never put passwords, API keys, tokens, or private keys in playbooks, repos, Extra Variables, surveys, inventories, or `.env` files. Use **AWX Credentials**; for external secret systems, ask an admin about credential lookups (e.g. a vault integration).
2. **Don't commit secrets to Git**, including `.env`, `*.pem`, `*.key`, and `.vault_pass`. Use Ansible Vault (with a Vault credential in AWX) only if the lab admin has approved it.
3. **Keep tokens out of files and URLs.** Load personal tokens into your shell session only (see [6.5](#65-using-the-cli--api-optional)); never use `?token=` in URLs; never save them in dotfiles or shell startup scripts.
4. **TLS verification stays on.** Do not set `validate_certs: false`, `verify_ssl=false`, or `curl -k`. Trust the lab CA instead.
5. **Hide secrets in output:** use `no_log: true`; don't use high verbosity on tasks that handle secrets.
6. **Least privilege.** Request only the roles you need; don't share accounts; don't ask for admin access just to get around a missing permission.
7. **Confidential data stays in the lab.** Do not paste customer data, production configs, support-ticket content, or internal source code into lab playbooks, job output, or any external service. When unsure whether something may be shared externally, assume **no** and ask.
8. **Don't use unapproved external endpoints** (public services, third-party AI APIs, etc.) from playbooks unless approved.
9. **Don't add third-party collections/roles casually.** Check the license (no GPL in proprietary modules) and ask the admin before adding new dependencies to shared EEs.
10. **Leaked a secret?** Treat it as compromised: rotate it immediately, delete the affected job output, and notify the lab admin.

---

## 10. Admin Notes

For lab administrators.

### 10.1 Suggested RBAC layout

| Group | Role on shared objects | Notes |
|---|---|---|
| Lab users team | *Read / Use* on shared inventory & credentials, *Execute* on shared templates | Users never see the raw secret, only use it |
| Per-user / per-team | *Admin* on their own prefixed projects/templates | Self-service within the sandbox |
| Auditors | *Auditor* (system-wide read-only) | Review jobs and activity stream |
| Lab admins | *Admin* | Keep this group small |

- Integrate with **LDAP/SSO (SAML/OIDC)** where possible; avoid local shared accounts.
- Avoid granting *System Administrator* to regular users.
- Review role assignments periodically and remove access for people who have left or changed teams.

### 10.2 Housekeeping (Management Jobs)

Under **Administration → Management Jobs**, schedule:

| Job | Suggested use |
|---|---|
| **Cleanup Job Details** | Delete job history/output older than N days (e.g. 30) |
| **Cleanup Activity Stream** | Trim old audit entries per retention policy |
| **Cleanup Expired Sessions / Tokens** | Remove stale auth data |

Also keep an eye on VM disk usage (project checkouts, job artifacts, container images, Postgres size).

### 10.3 Capacity and fairness

- Set sensible default **Forks** and **Timeout** values in shared templates.
- Use **Instance Groups** and **Concurrent Jobs** limits to prevent one user from starving others.
- Consider a naming-based clean-up policy: remove unused `<username>-*` objects after N days of inactivity.

### 10.4 Security and operations

- Keep AWX reachable only on the internal lab network; no direct public exposure.
- Use TLS on the AWX web endpoint.
- Back up the AWX database and encryption secrets; test restores.
- Store admin and integration credentials in an approved secrets manager, not in files on the VM.
- Pin and review **Execution Environment** images; rebuild them regularly for updates.

---

## 11. Quick Reference

### Where things live in the UI

| I want to… | Go to |
|---|---|
| Add/sync a Git repo | **Resources → Projects** |
| Create a playbook run recipe | **Resources → Templates → Add job template** |
| Build a pipeline | **Resources → Templates → Add workflow template** |
| Store a password/key/token | **Resources → Credentials** |
| Manage hosts | **Resources → Inventories** |
| See all runs | **Views → Jobs** |
| See who did what | **Views → Activity Stream** |
| See schedules | **Views → Schedules** |

### Pre-launch checklist

- [ ] Project is **Successful** and on the right branch/commit
- [ ] Right **Inventory** and **Credentials**
- [ ] **Limit** set to a small target for testing
- [ ] **Check mode** run done first (if the change is risky)
- [ ] No secrets in vars/surveys; `no_log: true` on sensitive tasks
- [ ] Timeout set; nobody else is running something that conflicts

### Post-run checklist

- [ ] Read **PLAY RECAP** (failed/unreachable should be 0)
- [ ] Confirm `changed` counts match your expectation
- [ ] Relaunch on **failed hosts** only if needed
- [ ] Download output if you need to keep it
- [ ] Delete test jobs/templates/projects you no longer need

