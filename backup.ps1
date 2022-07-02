Import-Module ./BackupFileSystem.psm1

Copy-DirTreeRecursively `
    -SourcePath "c:\temp\source1" `
    -DestinationPath "c:\temp\source2" `
    -LogPath "backup.log"

Read-Host "done.  press enter to close"