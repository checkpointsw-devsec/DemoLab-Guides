## Getting familiar with the environment
<a href="https://github.com/checkpointsw-devsec/DemoLab-Guides/blob/main/PlayBooks/Shared-Books/TechPoint_Environment.md" target="_blank" rel="noopener noreferrer">Environment-description (open in a new Tab)</a>

From the HQ-Win10 Client you have prepared SSH sessions to connect gateways with ssh.

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

