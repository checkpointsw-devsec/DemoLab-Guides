# DemoLab Guides

## Contents

- [DemoLab Guides](#demolab-guides)
  - [Contents](#contents)
  - [Getting Familiar with the Environment](#getting-familiar-with-the-environment)
    - [Preparing the Lab](#preparing-the-lab)
    - [Sync the Code from GitHub to GitLab](#sync-the-code-from-github-to-gitlab)
  - [PlayBooks](#playbooks)
    - [AI-Workshop](#ai-workshop)
    - [SD-WAN](#sd-wan)
  - [More Information: AWX and GitLab](#more-information-awx-and-gitlab)

## Getting Familiar with the Environment

Before you begin, read the <a href="https://github.com/checkpointsw-devsec/DemoLab-Guides/blob/main/PlayBooks/Shared-Books/TechPoint_Environment.md" target="_blank" rel="noopener noreferrer">Environment-description (open in a new Tab)</a>. It explains how to connect to the lab environment and how to use it.

### Preparing the Lab
<details>
<summary><b>Preparing the Lab</b> (click to expand)</summary>

All objects and policy packages for the lab are provided as Ansible playbooks in the GitHub repository.

Before you start a Lab Guide, open the **Policy-Package.md** file in that playbook’s folder and follow the instructions in it.

**for example:**

<div align="center">
  <img width="228" height="404" alt="Example of a Policy-Package.md file in a playbook folder" src="https://github.com/user-attachments/assets/f0643b60-7d7b-4920-8ccf-b62c86b4522b" />
</div>

The scripts and Ansible code needed for the lab must also be copied (mirrored) to the lab’s GitLab server. The next section shows how.
</details>

### Sync the Code from GitHub to GitLab

<details>
<summary><b>Sync the Code from GitHub to GitLab</b> (click to expand)</summary>

Open a PowerShell window.
Go to the folder that contains the script and run it:

```
cd C:\Users\student\Downloads
Unblock-File -Path .\Sync-LabCodeToGitLab.ps1
.\Sync-LabCodeToGitLab.ps1

```

By default, the script updates existing projects and does not delete anything.

**Optional: Delete and Recreate Existing Projects**

If you want to delete the matching projects and recreate them from scratch, run the script with these parameters instead:

```
.\Sync-LabCodeToGitLab.ps1 -RecreateExisting -Confirm:$false
```
</details>

## PlayBooks

### AI-Workshop

<details>
<summary><b>AI-Workshop – Workforce AI Security and AI Agent Security</b> (click to expand)</summary>

**Preparation:** [Policy-Package.md](PlayBooks/AI-Workshop/Policy-Package.md)

**Lab 1 – Workforce AI Security:** [Lab1-Guide.md](PlayBooks/AI-Workshop/Lab1-Guide.md)

- [Create a test Tenant in Check Point Portal](PlayBooks/AI-Workshop/Lab1-Guide.md#create-a-test-tenant-in-check-point-portal)
- [Create trust between your Lab Management server and the tenant](PlayBooks/AI-Workshop/Lab1-Guide.md#create-trust-between-your-lab-management-server-and-the-tenant)
- [Lab exercise 2: Enabling the Software Blades and features](PlayBooks/AI-Workshop/Lab1-Guide.md#lab-exercise-2-enabling-the-software-blades-and-features)
- [Lab exercise 3: Setting Up the Policies](PlayBooks/AI-Workshop/Lab1-Guide.md#lab-exercise-3-setting-up-the-policies)
- [Lab exercise 4: Testing the effectiveness of Workforce AI](PlayBooks/AI-Workshop/Lab1-Guide.md#lab-exercise-4-testing-the-effectiveness-of-workforce-ai)

**Lab 2 – AI Agent Security with MCP Detection and Visibility:** [Lab2-Guide.md](PlayBooks/AI-Workshop/Lab2-Guide.md)

- [Introduction](PlayBooks/AI-Workshop/Lab2-Guide.md#introduction)
- [Accessing the Lab](PlayBooks/AI-Workshop/Lab2-Guide.md#accessing-the-lab)
- [Initial Setup](PlayBooks/AI-Workshop/Lab2-Guide.md#initial-setup)
- [Lab exercise 1: Configure MCP Detection and Visibility](PlayBooks/AI-Workshop/Lab2-Guide.md#lab-exercise-1-configure-mcp-detection-and-visibility)
- [Lab exercise 2: Configure AI Agent Security and detect Prompt Injection](PlayBooks/AI-Workshop/Lab2-Guide.md#lab-exercise-2-configure-ai-agent-security-and-detect-prompt-injection)
- [Summary](PlayBooks/AI-Workshop/Lab2-Guide.md#summary)
- [Reference Material](PlayBooks/AI-Workshop/Lab2-Guide.md#reference-material)

**Lab code:** [Lab-Code/AI-Workshop](Lab-Code/AI-Workshop)

</details>

### SD-WAN

<details>
<summary><b>SD-WAN with Smart-1 Unified Management – Hands-On Lab</b> (click to expand)</summary>

**Lab Guide:** [SD-WAN-OnPrem-Lab-Guide.md](PlayBooks/SD-WAN/SD-WAN-OnPrem-Lab-Guide.md)

**Contents**

- [What you will learn](PlayBooks/SD-WAN/SD-WAN-OnPrem-Lab-Guide.md#what-you-will-learn)
- [How SD-WAN works in 60 seconds](PlayBooks/SD-WAN/SD-WAN-OnPrem-Lab-Guide.md#how-sd-wan-works-in-60-seconds)
- [Before you start](PlayBooks/SD-WAN/SD-WAN-OnPrem-Lab-Guide.md#before-you-start)
- [Part 0: Get familiar with the environment](PlayBooks/SD-WAN/SD-WAN-OnPrem-Lab-Guide.md#part-0-get-familiar-with-the-environment)
- [EA Part 0: Enable SD-WAN Blade on the Gateway Objects](PlayBooks/SD-WAN/SD-WAN-OnPrem-Lab-Guide.md#ea-part-0-enable-sd-wan-blade-on-the-gateway-objects)
- [Part 1: Prepare gateway networking](PlayBooks/SD-WAN/SD-WAN-OnPrem-Lab-Guide.md#part-1-prepare-gateway-networking)
- [Part 2: Enable SD-WAN on hq-exl and branch-gw](PlayBooks/SD-WAN/SD-WAN-OnPrem-Lab-Guide.md#part-2-enable-sd-wan-on-hq-exl-and-branch-gw)
- [Part 3: Create the SD-WAN Policy](PlayBooks/SD-WAN/SD-WAN-OnPrem-Lab-Guide.md#part-3-create-the-sd-wan-policy)
- [Part 4: Configure VPN and Access Control for the overlay](PlayBooks/SD-WAN/SD-WAN-OnPrem-Lab-Guide.md#part-4-configure-vpn-and-access-control-for-the-overlay)
- [Part 5: Install and validate](PlayBooks/SD-WAN/SD-WAN-OnPrem-Lab-Guide.md#part-5-install-and-validate)
- [Part 6: Backhaul Verification](PlayBooks/SD-WAN/SD-WAN-OnPrem-Lab-Guide.md#part-6-backhaul-verification)
- [Part 7: Change Tunnel Peering by using circuits](PlayBooks/SD-WAN/SD-WAN-OnPrem-Lab-Guide.md#part-7-change-tunnel-peering-by-using-circuits)
- [Part 8: Fail over](PlayBooks/SD-WAN/SD-WAN-OnPrem-Lab-Guide.md#part-8-fail-over)
- [Optional challenges](PlayBooks/SD-WAN/SD-WAN-OnPrem-Lab-Guide.md#optional-challenges)
- [Cheat sheet](PlayBooks/SD-WAN/SD-WAN-OnPrem-Lab-Guide.md#cheat-sheet)
- [Reference](PlayBooks/SD-WAN/SD-WAN-OnPrem-Lab-Guide.md#reference)

**Lab code:** [Lab-Code/SD-WAN](Lab-Code/SD-WAN)

</details>

## More Information: AWX and GitLab

If you need help with the tools used to run the lab code, see:

- [AWX.md](PlayBooks/Shared-Books/AWX.md) – how to work with Projects, Job Templates, Workflows and Jobs in AWX, and how to review job output.
- [GitLab.md](PlayBooks/Shared-Books/GitLab.md) – day-to-day GitLab and Git tasks for keeping Ansible playbooks, roles and inventories in the lab GitLab.
