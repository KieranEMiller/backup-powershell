Import-Module ./BackupFileSystem.psm1

#export all of the contents of SourcePath to a CSV
Export-DirTreeRecursively `
    -SourcePath "C:\temp\source1" `
	-ExportCsvPath "c:\temp\dest_document.csv" `
    -LogPath "backup_export.log"

#copy all of the contents of SourcePath to DestinationPath
Copy-DirTreeRecursively `
    -SourcePath "C:\temp\source1" `
    -DestinationPath "C:\temp\dest1" `
    -LogPath "backup_copy.log"

Read-Host "done.  press enter to close"