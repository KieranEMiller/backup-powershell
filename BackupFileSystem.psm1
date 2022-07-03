function Copy-DirTreeRecursively {
	param(
		[Parameter(Mandatory=$true, Position=0)]
		[string]$SourcePath,
		
		[Parameter(Mandatory=$true, Position=1)]
		[string]$DestinationPath,
		
		[string]$LogPath = ""
    )

	#throws an exception when either path is invalid
	ValidateAndDocumentInputParameters $SourcePath $DestinationPath $LogPath

	$paths = `
		Get-ChildItem $SourcePath -Recurse -Force -ErrorVariable +FailedItems `
		| Foreach-Object { `
			CopyRelative $LogPath $_ $SourcePath $DestinationPath `
		} 
	
	$FailedItems `
		| Foreach-Object { `
			Log $LogPath ("ERROR: failed to process: {0}" -f $_.CategoryInfo) `
		} 

	#optional example: only look up files that were modified or created in the last X days
	<#
	$rootDir = Get-ChildItem $PATH_TARGET_BASE_DIR -Recurse | `
		where { `
			$_.LastWriteTime -ge (Get-Date).AddDays($LOOKBACK_PERIOD) `
			-OR $_.CreationTime -ge (Get-Date).AddDays($LOOKBACK_PERIOD) `
	}#>
}
Export-ModuleMember -Function Copy-DirTreeRecursively

function CopyRelative($logPath, $path, $sourcePathRoot, $destinationPath)
{
	try {
		$localPath = GetRelativePath $path $sourcePathRoot $destinationPath

		Log $logPath ("copy `t{0}`tto`t{1}" -f $path.FullName, $localPath)
		Copy-Item $path.FullName -Destination $localPath -Force
	}
	catch [System.Exception] {
		$errMsg = $_
		Log $logPath ("ERROR: failed to copy {0}: {1}" -f $path.FullName, $errMsg)
	}
}

function ValidateAndDocumentInputParameters($SourcePath, $DestinationPath, $LogPath)
{
	if(-Not(IsValidDirectory $SourcePath )) {
		throw "missing or invalid argument parameter sourcePath.  you must specify a valid source path to copy from"
	}
	
	if(-Not(IsValidDirectory $DestinationPath)) {
		throw "missing or invalid argument parameter destPath.  you must specify a valid destination path to copy to"
	}
	Log $LogPath ("config source: {0}" -f $SourcePath)
	Log $LogPath ("config destination: {0}" -f $DestinationPath)
	Log $LogPath ("logging to: {0}" -f $LogPath)
}

function IsValidDirectory($path)
{
	if([string]::IsNullOrEmpty($path)) {
		return $false
	}
	
	if(-Not(Test-Path -Path $path)) {
		return $false
	}
	
	return $true
}

function GetRelativePath($path, $sourcePathRoot, $destinationPath) 
{
	#strip out the root portion of the path
	#this will create a relative path preserving the folder
	#structure of the original file when it is copied locally
	$relativePath = $path.FullName.replace($sourcePathRoot, "")
	return Join-Path $destinationPath $relativePath
}

function Log($path, $msg) 
{
    $logMsg = "{0}: {1}" -f (Get-Date).ToString("yyyyMMdd_HHmmssfff"), $msg
    
    Write-Host $logMsg
	
	if(![string]::IsNullOrEmpty($path)) {
		Add-content $path -value $logMsg
	}
}