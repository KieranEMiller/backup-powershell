function Copy-DirTreeRecursively {
	#[CmdletBinding()]
	param(
		[Parameter(Mandatory=$true, Position=0)]
		[string]$SourcePath,
		
		[Parameter(Mandatory=$true, Position=1)]
		[string]$DestinationPath,
		
		[string]$LogPath = ""
    )

	if([string]::IsNullOrEmpty($SourcePath)) {
		throw "missing argument parameter sourcePath.  you must specify a valid source path to copy from"
	}
	
	if([string]::IsNullOrEmpty($DestinationPath)) {
		throw "missing argument parameter destPath.  you must specify a valid destination path to copy to"
	}
	Log $LogPath ("config source: {0}" -f $SourcePath)
	Log $LogPath ("config destination: {0}" -f $DestinationPath)
	Log $LogPath ("logging to: {0}" -f $LogPath)
	
	

}
Export-ModuleMember -Function Copy-DirTreeRecursively


function Log($path, $msg) 
{
    $logMsg = "{0}: {1}" -f (Get-Date).ToString("yyyyMMdd_HHmmssfff"), $msg
    
    Write-Host $logMsg
	
	if(![string]::IsNullOrEmpty($path)) {
		Add-content $path -value $logMsg
	}
}