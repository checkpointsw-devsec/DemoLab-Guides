## start with the Environment document
[Environment-description:](https://github.com/checkpointsw-devsec/DemoLab-Guides/blob/main/PlayBooks/Shared-Books/TechPoint_Environment.md)

## sync codebase from github to gitlab
start powershell 
```
cd C:\Users\student\Downloads
Unblock-File -Path ".\Sync-LabCodeToGitLab.ps1"
.\Sync-LabCodeToGitLab.ps1
```

Existing projects are updated without deletion. If you deliberately want to delete and recreate the matching projects, run:
```
.\Sync-LabCodeToGitLab.ps1 -RecreateExisting -Confirm:$false
```

