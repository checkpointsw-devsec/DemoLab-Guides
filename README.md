## Getting familiar with the environment
please find in following document how to connect and use the environment:
<a href="https://github.com/checkpointsw-devsec/DemoLab-Guides/blob/main/PlayBooks/Shared-Books/TechPoint_Environment.md" target="_blank" rel="noopener noreferrer">Environment-description (open in a new Tab)</a>

All objects and Policy packages are prepared in this github repository as ansible playbooks.
 
before starting with the Lab-guide please first follow the instructions in Policy-Package.md of each PlayBook. for eg:

 
<img width="456" height="809" alt="image" src="https://github.com/user-attachments/assets/f0643b60-7d7b-4920-8ccf-b62c86b4522b" />

as part of the Lab the necessary scipts and ansible code has to be mirrored to the lab github. 

## sync codebase from github to gitlab
please open a powershell windows and run following code:
```
Unblock-File -Path C:\Users\student\Downloads\Sync-LabCodeToGitLab.ps1
C:\Users\student\Downloads\Sync-LabCodeToGitLab.ps1

```

Existing projects are updated without deletion. If you deliberately want to delete and recreate the matching projects, run:
```
.\Sync-LabCodeToGitLab.ps1 -RecreateExisting -Confirm:$false
```

