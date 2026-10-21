## Getting familiar with the environment
please find in following document how to connect and use the environment:


All objects and Policy packages are prepared in this github repository as ansible playbooks.
 
before starting with the Lab-guide please first follow the instructions in Policy-Package.md of each PlayBook. for eg:

 
<img width="456" height="809" alt="image" src="https://github.com/user-attachments/assets/f0643b60-7d7b-4920-8ccf-b62c86b4522b" />

as part of the Lab the necessary scipts and ansible code has to be mirrored to the lab github. 

## sync codebase from github to gitlab
please open a powershell windows and run following code:

Existing projects are updated without deletion. If you deliberately want to delete and recreate the matching projects, run:
```
.\Sync-LabCodeToGitLab.ps1 -RecreateExisting -Confirm:$false
```



## Getting Familiar with the Environment

Before you begin, read the <a href="https://github.com/checkpointsw-devsec/DemoLab-Guides/blob/main/PlayBooks/Shared-Books/TechPoint_Environment.md" target="_blank" rel="noopener noreferrer">Environment-description (open in a new Tab)</a>. It explains how to connect to the lab environment and how to use it.

Preparing the Lab

All objects and policy packages for the lab are provided as Ansible playbooks in the GitHub repository.

Before you start a Lab Guide, open the **Policy-Package.md** file in that playbook’s folder and follow the instructions in it.

<img width="456" height="809" alt="Example of a Policy-Package.md file in a playbook folder" src="https://github.com/user-attachments/assets/f0643b60-7d7b-4920-8ccf-b62c86b4522b" />

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
