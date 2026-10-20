# GitLab Daily Workflow Guide 

Day-to-day GitLab and Git tasks for people who keep their **Ansible playbooks, roles, and inventories** in the lab GitLab and run them from **AWX**.

> Companion to `awx-lab-user-guide.md`. GitLab holds the code; AWX is the runner that syncs and executes it.

---

## Table of Contents

1. [Conventions](#1-conventions)
2. [One-Time Setup](#2-one-time-setup)
3. [The Daily Loop](#3-the-daily-loop)
4. [Branches and Commits](#4-branches-and-commits)
5. [Merge Requests](#5-merge-requests)
6. [Staying in Sync and Resolving Conflicts](#6-staying-in-sync-and-resolving-conflicts)
7. [Undoing Things](#7-undoing-things)
8. [If You Committed a Secret](#8-if-you-committed-a-secret)
9. [Tags and Releases](#9-tags-and-releases)
10. [GitLab CI/CD Basics](#10-gitlab-cicd-basics)
11. [Connecting GitLab to AWX](#11-connecting-gitlab-to-awx)
12. [Issues, Labels, and Boards](#12-issues-labels-and-boards)
13. [Repository Hygiene](#13-repository-hygiene)
14. [Roles and Protected Branches](#14-roles-and-protected-branches)
15. [Using the GitLab API and `glab` CLI](#15-using-the-gitlab-api-and-glab-cli)
16. [Troubleshooting](#16-troubleshooting)
17. [Security Rules](#17-security-rules)
18. [Cheat Sheet](#18-cheat-sheet)

---

## 1. Conventions

Use the same conventions everywhere so a shared lab stays readable.

| Item | Convention | Example |
|---|---|---|
| Repo name | lowercase, hyphens, purpose-based | `web-deploy-playbooks` |
| Personal sandbox repo | `<username>-<purpose>` | `alice-ansible-sandbox` |
| Default branch | `main` (protected) | |
| Feature branch | `<username>/<short-description>` | `alice/add-nginx-handler` |
| Issue-linked branch | `<issue#>-<short-description>` | `42-fix-ntp-config` |
| Tag | Semantic version, `v` prefix | `v1.2.0` |
| Commit message | Short imperative subject, optional body | `Add nginx restart handler` |

Rules of thumb:

- **Never commit directly to `main`.** Work on a branch and open a Merge Request (MR).
- **One MR = one logical change.** Small MRs get reviewed faster.
- **Keep Git history clean enough to read**, not perfect.

---

## 2. One-Time Setup

### 2.1 Identify yourself

```bash
git config --global user.name  "Your Name"
git config --global user.email "your.name@example.com"   # use the email on your GitLab profile

# Sensible defaults
git config --global init.defaultBranch main
git config --global pull.rebase true          # keep history linear on pull
git config --global fetch.prune true          # drop deleted remote branches locally
git config --global push.autoSetupRemote true # first push sets upstream automatically
git config --global rerere.enabled true       # remember conflict resolutions
```

### 2.2 Authenticate: SSH (recommended)

Use an SSH key **protected by a passphrase** and load it into `ssh-agent` for the session.

```bash
# 1. Create the key (you will be asked for a passphrase: set one)
ssh-keygen -t ed25519 -C "your.name@lab"

# 2. Load it for this session
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# 3. Show the PUBLIC key and copy it
cat ~/.ssh/id_ed25519.pub
```

In GitLab: **avatar → Preferences → SSH Keys → Add new key**. Paste the `.pub` content only, give it a title, and **set an expiry date**.

Test it (replace the host with your lab GitLab host):

```bash
ssh -T git@gitlab.lab.example
# Expected: "Welcome to GitLab, @yourname!"
```

> Never share, copy to other machines, e-mail, or commit your **private** key (`id_ed25519`, no `.pub`).

### 2.3 Authenticate: HTTPS (only if SSH is not possible)

- Create a **Personal Access Token**: **avatar → Preferences → Access Tokens**. Choose the **minimum scopes** (`read_repository`, plus `write_repository` only if you push) and a **short expiry**.
- Do **not** put the token in the clone URL, a `.env` file, a dotfile, or a shell startup script.
- Use an OS-keychain-backed credential helper (macOS Keychain, Windows Credential Manager) so the token is stored encrypted.
- **Never** use `git config credential.helper store`: it writes the token in plaintext to `~/.git-credentials`.

### 2.4 Trust the lab certificate (if GitLab uses an internal CA)

```bash
git config --global http.https://gitlab.lab.example/.sslCAInfo /path/to/lab-ca.pem
```

> **Do not** run `git config http.sslVerify false` or set `GIT_SSL_NO_VERIFY=true`. Fix the trust chain instead.

### 2.5 Clone a project

```bash
git clone git@gitlab.lab.example:<group>/<project>.git
cd <project>
git remote -v            # confirm the remote points to the lab GitLab
```

Only use the lab GitLab as a remote for lab code. **Do not add GitHub or other external remotes** to lab repositories, and do not push lab, customer, or internal material to external services.

---

## 3. The Daily Loop

```text
┌─► git switch main && git pull          (get latest)
│   git switch -c alice/my-change        (new branch)
│   ...edit playbooks...
│   git status / git diff                (review what changed)
│   git add <files> && git commit        (save a snapshot)
│   git push                             (publish branch)
│   Open Merge Request ─► CI runs ─► review ─► merge
└── AWX syncs the project ─► run the template
```

Step by step:

```bash
# 1. Start from the latest main
git switch main
git pull

# 2. Create a working branch
git switch -c alice/add-nginx-handler

# 3. Edit files, then check what changed
git status
git diff                      # unstaged changes
git diff --staged             # staged changes

# 4. Stage and commit
git add playbooks/deploy_web.yml roles/webserver/handlers/main.yml
git commit -m "Add nginx restart handler"

# 5. Push the branch (first push creates it on GitLab)
git push
```

GitLab prints a link in the terminal after the push, so click it to open the Merge Request page.

**Tips**

- Commit small and often; push at least at the end of each work session.
- Use `git add -p` to stage only the parts of a file you intend to commit.
- Run `git status` before every commit to avoid adding stray files.

---

## 4. Branches and Commits

### 4.1 Common branch commands

| Task | Command |
|---|---|
| List local branches | `git branch` |
| List all incl. remote | `git branch -a` |
| Create + switch | `git switch -c <branch>` |
| Switch | `git switch <branch>` |
| Rename current | `git branch -m <new-name>` |
| Delete local (merged) | `git branch -d <branch>` |
| Delete local (force) | `git branch -D <branch>` |
| Delete remote branch | `git push origin --delete <branch>` |
| Clean up after merge | `git switch main && git pull && git branch -d <branch>` |

### 4.2 Writing good commit messages

```text
Add nginx restart handler

Restart nginx only when the vhost template changes, instead of on
every run. Fixes unnecessary downtime during idempotent runs.

Closes #42
```

- **Subject:** ≤ 50 characters, imperative ("Add", "Fix", "Remove"), no trailing period.
- **Body:** explain *why*, wrap at ~72 characters.
- **Link issues:** `Closes #42` / `Refs #42` (GitLab closes the issue when the MR merges into the default branch).

### 4.3 Inspecting history

```bash
git log --oneline --graph --decorate -20     # compact history
git log -p -- playbooks/deploy_web.yml       # changes to one file
git blame playbooks/deploy_web.yml           # who changed each line
git show <commit>                            # one commit in detail
git diff main...HEAD                         # what my branch adds vs main
```

---

## 5. Merge Requests

### 5.1 Create an MR

**Option A: from the link printed after `git push`.**
**Option B: GitLab UI:** *Code → Merge requests → New merge request*.
**Option C: with push options (no browser):**

```bash
git push -o merge_request.create \
         -o merge_request.target=main \
         -o merge_request.title="Add nginx restart handler" \
         -o merge_request.remove_source_branch
```

### 5.2 A good MR

| Field | Guidance |
|---|---|
| **Title** | Same style as a commit subject. Prefix with `Draft:` while unfinished |
| **Description** | *What* changed, *why*, *how you tested it* (e.g. AWX job link, check-mode result) |
| **Assignee / Reviewer** | Yourself as assignee; pick a teammate as reviewer |
| **Labels** | `playbook`, `role`, `inventory`, `docs`, `bug`, etc. |
| **Linked issue** | `Closes #42` |
| **Options** | ☑ *Delete source branch when merged*, ☑ *Squash commits* (optional, keeps `main` tidy) |

Useful description template:

```markdown
## What
Adds a handler to restart nginx only when the vhost template changes.

## Why
Avoids unnecessary restarts on every run. Closes #42.

## How I tested
- AWX job #1234 (Check mode, limit `web01`): no unexpected changes
- AWX job #1235 (Run, limit `web01`): changed=1, failed=0

## Checklist
- [ ] No secrets in the diff
- [ ] Playbook is idempotent
- [ ] `ansible-lint` passes
```

### 5.3 Reviewing someone else's MR

1. Open **Changes** and read the diff (toggle *inline / side-by-side*).
2. Click the **+** next to a line to leave a comment; use **Start a review** to batch comments, then **Submit review**.
3. Use **Suggest change** in a comment to propose an exact edit that the author can apply with one click.
4. Check the **pipeline** result (see [section 10](#10-gitlab-cicd-basics)).
5. Look specifically for:
   - hardcoded passwords, tokens, keys, or internal-only data
   - `validate_certs: false` / disabled TLS verification
   - missing `no_log: true` on secret-handling tasks
   - overly broad `hosts: all`, or `become` where not needed
   - destructive tasks without guards or check-mode support
6. **Approve** when satisfied, or **Request changes**.

### 5.4 Resolving review feedback

- Make the change locally, commit, and `git push`. The MR updates automatically.
- Click **Resolve thread** on comments you've addressed.
- Prefer new commits over force-pushing while a review is in progress.

### 5.5 Merging

- Merge requires: green pipeline, required approvals, all threads resolved (depending on project settings).
- Choose **Merge when pipeline succeeds** to merge automatically once CI is green.
- After the merge: switch to `main`, `git pull`, delete your local branch.
- **Then re-sync the AWX project** (or rely on *Update Revision on Launch* / a webhook) so AWX sees the new commit.

---

## 6. Staying in Sync and Resolving Conflicts

### 6.1 Keep your branch current

```bash
git fetch origin                    # download updates, change nothing locally
git switch alice/add-nginx-handler
git rebase origin/main              # replay your commits on top of latest main
# or, if you prefer merge commits:
git merge origin/main
```

If you rebased a branch you've **already pushed**, update the remote with:

```bash
git push --force-with-lease
```

> Use `--force-with-lease` (never plain `--force`), and **only on your own feature branches**, never on `main` or someone else's branch.

### 6.2 Resolve a conflict

```bash
git rebase origin/main
# Git stops: "CONFLICT (content): Merge conflict in playbooks/deploy_web.yml"

git status                       # see conflicted files
# Edit the file; look for the markers:
#   <<<<<<< HEAD
#   (their / main version)
#   =======
#   (your version)
#   >>>>>>> your commit
# Keep the correct result and DELETE the markers.

git add playbooks/deploy_web.yml
git rebase --continue            # (or: git commit, if you used merge)

# Changed your mind?
git rebase --abort
```

After resolving, **re-test** (check-mode job in AWX) before pushing.

---

## 7. Undoing Things

| Situation | Command |
|---|---|
| Discard unstaged edits in a file | `git restore <file>` |
| Unstage a file (keep edits) | `git restore --staged <file>` |
| Fix the last commit message | `git commit --amend` *(only if not pushed or only on your own branch)* |
| Add a forgotten file to last commit | `git add <file> && git commit --amend --no-edit` |
| Undo last commit, keep changes staged | `git reset --soft HEAD~1` |
| Undo last commit, keep changes unstaged | `git reset HEAD~1` |
| Throw away last commit **and** changes | `git reset --hard HEAD~1` ⚠️ destructive |
| Safely undo a commit already on `main` | `git revert <commit>` (creates a new "undo" commit) |
| Save work-in-progress temporarily | `git stash push -m "wip"` then later `git stash pop` |
| Copy one commit to another branch | `git cherry-pick <commit>` |
| Find "lost" commits | `git reflog` |

Rules:

- **On shared branches (`main`), use `git revert`, not `reset`.**
- `reset --hard` and `clean -fd` delete work with no undo, so check `git status` first.
- Lost something? `git reflog` usually has it for a while.

---

## 8. If You Committed a Secret

A password, API key, token, or private key in Git is **compromised the moment it's pushed**, even if you delete it in the next commit.

Do this, in order:

1. **Revoke / rotate the secret immediately** at its source (change the password, revoke the token or key). This is the step that actually fixes the problem.
2. **Tell the lab admin** so they can check for exposure and purge cached copies on the GitLab server.
3. **Remove it from history** (the secret stays in old commits otherwise):

   ```bash
   # Requires git-filter-repo
   git filter-repo --replace-text <(printf 'THE_LEAKED_VALUE==>***REMOVED***\n')
   git push --force-with-lease --all
   ```

   Coordinate first: everyone with a clone must re-clone or reset afterwards.
4. **Check AWX:** delete any job output that printed the value, and update the AWX *Credential* with the new secret.
5. **Prevent a repeat:** add the file to `.gitignore`, enable secret detection in CI ([section 10.4](#104-secret-detection)), and use AWX Credentials instead of files.

Files that should **never** be committed: `.env`, `*.pem`, `*.key`, `id_*`, `*.pfx`, `.vault_pass`, `~/.git-credentials`, anything holding tokens or customer data.

---

## 9. Tags and Releases

Tags let AWX (and people) point at a **stable, known-good version** of your playbooks.

```bash
git switch main && git pull
git tag -a v1.2.0 -m "Stable web deploy playbooks"
git push origin v1.2.0

git tag                       # list tags
git push origin --delete v1.2.0   # delete a remote tag (only if truly needed)
```

In GitLab: **Deploy → Releases → New release** to attach release notes to a tag.

In AWX, set the project's **Source Control Branch/Tag/Commit** to `v1.2.0` to make runs reproducible. Use `main` for development and a tag for "known good".

---

## 10. GitLab CI/CD Basics

CI runs automatically on pushes and MRs, defined by `.gitlab-ci.yml` in the repo root.

### 10.1 Minimal pipeline for Ansible content

```yaml
stages:
  - lint
  - test

default:
  image: registry.lab.example/ci/ansible-lint:1.0.0   # use a pinned image from the approved registry

yamllint:
  stage: lint
  script:
    - yamllint .
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH

ansible-lint:
  stage: lint
  script:
    - ansible-lint
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH

syntax-check:
  stage: test
  script:
    - ansible-playbook --syntax-check -i localhost, playbooks/*.yml
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH
```

> Pin image and tool versions. Don't pull random public images into the pipeline; use the image source approved for the lab.

### 10.2 Viewing pipelines and job logs

- **Build → Pipelines**: list of all runs with status (passed / failed / running).
- Click a pipeline → click a **job** to open its log.
- On the MR page, the pipeline widget shows the result; click it for details.
- **Retry** (🔄) a failed job after fixing the cause or for flaky runners; **Cancel** to stop a running one.
- **Lint** your `.gitlab-ci.yml`: **Build → Pipeline editor** validates it as you type.

Read failed logs from the **bottom up**: the last red lines usually show the real error.

### 10.3 CI/CD variables (for non-AWX secrets)

**Settings → CI/CD → Variables → Add variable**

| Option | Use |
|---|---|
| **Masked** (and *hidden* where available) | Always on for secrets, so they're hidden in job logs |
| **Protected** | Only exposed to protected branches/tags |
| **Environment scope** | Limit to a specific environment |

Never `echo` a variable, run `env`/`printenv`, or enable debug tracing (`CI_DEBUG_TRACE`) in jobs that handle secrets. Do not put secrets in `.gitlab-ci.yml` itself. Where the lab has a secrets manager integration, prefer that over plain variables.

### 10.4 Secret detection

Add GitLab's built-in scanner, if available in your edition and enabled for the lab:

```yaml
include:
  - template: Security/Secret-Detection.gitlab-ci.yml
```

Treat a finding as a real incident: follow [section 8](#8-if-you-committed-a-secret).

---

## 11. Connecting GitLab to AWX

### 11.1 Give AWX **read-only** access to the repo

Pick one (preferred first):

| Method | How |
|---|---|
| **Deploy key (SSH)** | Project → **Settings → Repository → Deploy keys**. Add a public key, leave **write access** *unticked*. Store the matching private key in an AWX *Source Control* credential |
| **Deploy token (HTTPS)** | Project → **Settings → Repository → Deploy tokens**. Scope **`read_repository`** only, set an expiry. Put username + token in an AWX *Source Control* credential |

Never reuse your personal SSH key or personal access token for AWX. Use a dedicated, read-only, expiring credential, so access can be revoked without affecting a person.

### 11.2 Create the AWX project

AWX → **Resources → Projects → Add**

- **Source Control Type:** Git
- **URL:** `git@gitlab.lab.example:<group>/<project>.git` (SSH) or the HTTPS URL, **without** credentials in it
- **Branch/Tag/Commit:** `main` or a release tag, e.g. `v1.2.0`
- **Credential:** the read-only *Source Control* credential from above

More detail: *AWX Lab User Guide → Projects*.

### 11.3 The change-to-run flow

```text
Branch ─► Commit ─► Push ─► MR ─► CI green ─► Review ─► Merge to main
                                                          │
                                         AWX project sync (manual / on launch / webhook)
                                                          │
                              Check-mode job ─► Review output ─► Run job
```

Test an unmerged branch in AWX by pointing a **personal sandbox project** at your feature branch (`<username>-` prefixed). Point back to `main` or a tag for shared templates.

### 11.4 Optional: trigger AWX from GitLab (webhooks)

In AWX, open a **Job Template** or **Workflow Template**:
1. Tick **Enable Webhook**, choose service **GitLab**.
2. AWX shows a **Webhook URL** and **Webhook Key**.

In GitLab: project → **Settings → Webhooks**
- **URL:** the AWX webhook URL
- **Secret token:** the AWX webhook key
- **Trigger:** *Push events* (filter to the branch you care about) or *Merge request events*
- ☑ **Enable SSL verification**

Notes:
- Use webhooks on **dev/sandbox** templates, and prefer *Check* mode or an *Approval* node before anything that changes real systems.
- Treat the webhook key as a secret; if it leaks, regenerate it in AWX and update GitLab.

---

## 12. Issues, Labels, and Boards

| Task | Where |
|---|---|
| Report a bug / request a change | **Plan → Issues → New issue** |
| Track progress visually | **Plan → Issue boards** (columns by label, e.g. *To do / Doing / Review / Done*) |
| Group related work | **Milestones** |
| Reference things | `#42` (issue), `!17` (merge request), `@username`, `~label` |
| Close via MR | Put `Closes #42` in the MR description or a commit message |

Good issue template:

```markdown
**Summary**
Short description of the problem or request.

**Steps / context**
Template, inventory, host(s), AWX job link.

**Expected vs actual**

**Acceptance criteria**
- [ ] ...
```

> Don't paste secrets, customer data, or full unredacted job output into issues or comments.

---

## 13. Repository Hygiene

### 13.1 `.gitignore` for Ansible repos

```gitignore
# Secrets and keys: never commit
.env
*.pem
*.key
*.pfx
id_rsa*
id_ed25519*
.vault_pass*
*.retry

# Local / generated
.ansible/
*.log
__pycache__/
.venv/
.idea/
.vscode/
```

### 13.2 What belongs in the repo

| ✅ Commit | ❌ Don't commit |
|---|---|
| Playbooks, roles, templates | Passwords, tokens, private keys, certs |
| `collections/requirements.yml`, `roles/requirements.yml` | Customer data, production configs, support-ticket content |
| Inventory **structure** and non-secret group vars | Large binaries, VM images, ISO files |
| `README.md`, docs, CI config | Job output dumps with sensitive values |

### 13.3 Good README basics

Purpose, how to run (which AWX template), required credentials *(by name, never values)*, variables, and an owner/contact.

### 13.4 Optional: `CODEOWNERS`

```text
# .gitlab/CODEOWNERS
/playbooks/   @team-ops
/inventory/   @alice
```

Lets GitLab suggest or require the right approvers.

### 13.5 Keep repos healthy

- Archive or delete abandoned sandbox repos (**Settings → General → Advanced**).
- Delete merged branches (enable *Delete source branch*).
- Don't commit large files; if a repo gets heavy, ask the admin about Git LFS.

---

## 14. Roles and Protected Branches

### 14.1 Project roles (summary)

| Role | Typical abilities |
|---|---|
| **Guest** | View issues, comment |
| **Reporter** | Read code, manage issues |
| **Developer** | Push to feature branches, create MRs, run pipelines |
| **Maintainer** | Merge to protected branches, manage settings, tokens, webhooks |
| **Owner** | Everything, including deleting the project |

Ask for the **lowest role that lets you do your job**. Don't request Maintainer/Owner just for convenience.

### 14.2 Protect `main`

**Settings → Repository → Protected branches**

- **Allowed to merge:** Maintainers (or Developers + Maintainers on small sandboxes)
- **Allowed to push:** *No one* (forces all changes through MRs)
- **Allow force push:** *off*

**Settings → Merge requests** (recommended)
- ☑ Pipelines must succeed
- ☑ All threads must be resolved
- ☑ Require at least 1 approval
- ☑ Delete source branch by default

### 14.3 Protected tags

**Settings → Repository → Protected tags**: restrict who can create `v*` tags so release versions can't be changed casually.

---

## 15. Using the GitLab API and `glab` CLI

Both are optional but handy for scripting and quick checks.

### 15.1 Keep tokens out of files

```bash
# Load the token for THIS shell session only (not echoed, not saved to history)
read -rs -p "GitLab token: " GITLAB_TOKEN; echo
export GITLAB_TOKEN
export GITLAB_HOST="gitlab.lab.example"
```

- Use a token with **minimum scopes** and a **short expiry**.
- Don't persist it in `.env`, dotfiles, or `~/.bashrc`/`~/.zshrc`.
- Some CLIs write the token to a config file on login. Prefer the environment variable, or the CLI's keyring option if your version supports it.
- Don't disable TLS verification; trust the lab CA instead.

### 15.2 `glab` examples

```bash
glab mr create --fill --target-branch main     # open an MR from the current branch
glab mr list --assignee=@me                    # my MRs
glab mr view 17                                # show MR details
glab mr checkout 17                            # check out someone's MR locally
glab ci status                                 # status of the current branch's pipeline
glab ci view                                   # interactive pipeline view
glab issue list --assignee=@me
glab issue create --title "NTP role fails on RHEL 9"
```

### 15.3 Plain API examples (`curl`)

Token goes in the **header**, never in the URL:

```bash
# Latest pipelines for a project
curl -sS --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
  "https://${GITLAB_HOST}/api/v4/projects/<PROJECT_ID>/pipelines?per_page=5"

# Open merge requests
curl -sS --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
  "https://${GITLAB_HOST}/api/v4/projects/<PROJECT_ID>/merge_requests?state=opened"
```

---

## 16. Troubleshooting

| Symptom | Likely cause | Fix |
|---|---|---|
| `Permission denied (publickey)` | Key not added to GitLab, not loaded in agent, or wrong key used | `ssh-add -l` to list loaded keys; `ssh-add ~/.ssh/id_ed25519`; check the key is under *Preferences → SSH Keys*; `ssh -vT git@gitlab.lab.example` for details |
| `Host key verification failed` | Server host key changed or not trusted yet | Verify the fingerprint with the admin before accepting; don't blindly edit `known_hosts` |
| `SSL certificate problem: unable to get local issuer certificate` | Internal CA not trusted | Configure `http.<url>.sslCAInfo` (see 2.4). **Don't** disable verification |
| `remote: HTTP Basic: Access denied` | Wrong/expired token or password, missing scope | Create a new token with the right scope; update the credential helper entry |
| `! [rejected] ... (fetch first)` or `non-fast-forward` | Remote has commits you don't | `git pull --rebase`, then push again |
| `remote: GitLab: You are not allowed to push code to protected branches` | Pushing to `main` | Push to a feature branch and open an MR |
| Merge button disabled | Failing pipeline, unresolved threads, missing approval, or conflicts | Check the MR's status box; fix each item |
| MR shows conflicts | `main` moved on | Rebase or merge `origin/main` into your branch ([section 6](#6-staying-in-sync-and-resolving-conflicts)) |
| Pipeline stuck on "pending" | No available runner / wrong runner tags | Check **Settings → CI/CD → Runners**; ask the admin |
| Pipeline fails on `ansible-lint` | Rule violations | Read the log; fix or (with justification) add a targeted `# noqa` / config exception |
| AWX project sync fails | Wrong URL/branch, bad or expired deploy key/token | Check the AWX project sync job output, the deploy key/token status in GitLab, and the branch name |
| AWX doesn't see my latest change | Not merged, or project not re-synced | Merge, then sync the project (or enable *Update Revision on Launch*) |
| Accidentally committed to `main` locally | Forgot to branch | `git branch alice/my-change` (saves the commit), `git reset --hard origin/main`, `git switch alice/my-change` |
| Pushed to wrong branch | Typo or wrong upstream | `git branch -vv`; fix upstream with `git push -u origin <branch>` |

---

## 17. Security Rules

1. **No secrets in Git.** Never commit passwords, tokens, API keys, private keys, `.env` files, or Vault passwords, in code, variables, CI files, issues, or MR comments. Use **AWX Credentials** and **masked, protected CI/CD variables**.
2. **Tokens stay out of files and URLs.** No PATs in `.env`, dotfiles, shell startup scripts, clone URLs, or `?private_token=` query strings. Load them into the current shell session only, with minimal scope and short expiry.
3. **SSH keys are passphrase-protected,** loaded via `ssh-agent`, and never shared or committed. Set expiry dates on keys and tokens.
4. **TLS verification stays on.** No `http.sslVerify false`, `GIT_SSL_NO_VERIFY`, `curl -k`, or `validate_certs: false`.
5. **Least privilege.** Request the lowest GitLab role you need; AWX gets a dedicated **read-only** deploy key/token, never a person's credentials.
6. **Protect `main`.** MR-only changes, passing pipelines, and review before merge. No force-push to shared branches.
7. **Keep code and data in lab-controlled systems.** Use only the lab GitLab as a remote. Don't mirror or push lab code, customer data, configurations, or support-ticket content to external Git hosts, paste services, or unapproved tools.
8. **Review dependencies.** Check the licence of any new collection/role/package before adding it (no GPL in proprietary modules), and pin versions.
9. **Leaked a secret?** Rotate first, tell the admin, then clean history ([section 8](#8-if-you-committed-a-secret)).
10. **When unsure whether something can be shared externally, default to *no* and ask.**

---

## 18. Cheat Sheet

### Daily commands

| I want to… | Command |
|---|---|
| Get latest `main` | `git switch main && git pull` |
| New branch | `git switch -c alice/<change>` |
| See what changed | `git status` · `git diff` · `git diff --staged` |
| Stage specific parts | `git add -p` |
| Commit | `git commit -m "Imperative subject"` |
| Push | `git push` |
| Open MR from CLI | `git push -o merge_request.create -o merge_request.target=main` |
| Update my branch with `main` | `git fetch && git rebase origin/main` |
| Update remote after rebase | `git push --force-with-lease` *(own branch only)* |
| Stash work | `git stash push -m "wip"` / `git stash pop` |
| Undo local edit | `git restore <file>` |
| Undo pushed commit on `main` | `git revert <commit>` |
| Tag a release | `git tag -a v1.2.0 -m "msg" && git push origin v1.2.0` |
| Clean up after merge | `git switch main && git pull && git branch -d <branch>` |

### Before pushing

- [ ] `git status`: only intended files are staged
- [ ] `git diff --staged`: no secrets, no debug leftovers
- [ ] Playbook tested in AWX (check mode first, small `limit`)
- [ ] Commit message is clear; issue linked if relevant

### Before merging

- [ ] Pipeline is green
- [ ] At least one reviewer approved
- [ ] All threads resolved
- [ ] No secrets, no disabled TLS verification, `no_log: true` where needed
- [ ] AWX project will pick up the new commit (sync / webhook / update on launch)

### Where things live in GitLab

| I want… | Go to |
|---|---|
| My SSH keys / tokens | **Avatar → Preferences → SSH Keys / Access Tokens** |
| Merge requests | **Code → Merge requests** |
| Pipelines | **Build → Pipelines** |
| CI variables | **Settings → CI/CD → Variables** |
| Deploy keys / tokens | **Settings → Repository → Deploy keys / Deploy tokens** |
| Protected branches/tags | **Settings → Repository** |
| Webhooks | **Settings → Webhooks** |
| Issues / boards | **Plan → Issues / Issue boards** |

> Menu names vary slightly between GitLab versions. If something isn't where this guide says, use the search box at the top of the GitLab page.
