Import-Module ./BackupFileSystem.psm1

Copy-DirTreeRecursively `
    -SourcePath "C:\temp\source1" `
    -DestinationPath "C:\temp\dest1" `
    -LogPath "backup.log"

Read-Host "done.  press enter to close"