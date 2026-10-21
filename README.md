## Getting Familiar with the Environment

Before you begin, read the <a href="https://github.com/checkpointsw-devsec/DemoLab-Guides/blob/main/PlayBooks/Shared-Books/TechPoint_Environment.md" target="_blank" rel="noopener noreferrer">Environment-description (open in a new Tab)</a>. It explains how to connect to the lab environment and how to use it.

Preparing the Lab

All objects and policy packages for the lab are provided as Ansible playbooks in the GitHub repository.

Before you start a Lab Guide, open the **Policy-Package.md** file in that playbook’s folder and follow the instructions in it.

**for example:**
<p style="text-align: center"><img width="228" height="404" alt="Example of a Policy-Package.md file in a playbook folder" src="https://github.com/user-attachments/assets/f0643b60-7d7b-4920-8ccf-b62c86b4522b" /></p>


The scripts and Ansible code needed for the lab must also be copied (mirrored) to the lab’s GitLab server. The next section shows how.

Sync the Code from GitHub to GitLab
Open a PowerShell window.
Go to the folder that contains the script and run it:

```
cd C:\Users\student\Downloads
Unblock-File -Path .\Sync-LabCodeToGitLab.ps1
.\Sync-LabCodeToGitLab.ps1

```

By default, the script updates existing projects and does not delete anything.

Optional: Delete and Recreate Existing Projects

If you want to delete the matching projects and recreate them from scratch, run the script with these parameters instead:

```
.\Sync-LabCodeToGitLab.ps1 -RecreateExisting -Confirm:$false
```
