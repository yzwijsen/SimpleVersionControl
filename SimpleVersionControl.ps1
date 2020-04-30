$ScriptFolder = "C:\Scripts"
$ArchiveFolder = "C:\Scripts\Archive"

function Archive-File ($path)
{
	$fileName = [io.path]::GetFileNameWithoutExtension($path)
	$extension = [io.path]::GetExtension($path)
	$newPath  = "$ArchiveFolder\$fileName-$(get-date -f yyyy-MM-dd-HH-mm)$extension"
	
	Write-Host "Archiving File..." -BackgroundColor White -ForegroundColor DarkBlue
	Copy-Item $path $newPath -Verbose
}

$files = Get-ChildItem -File -Path $ScriptFolder -Recurse  | Where-Object { $_.FullName -inotmatch ($ArchiveFolder.Split("\") | Select -Last 1) }

foreach ($file in $files)
{
	$fileName = $file.Name
	$baseName = $file.BaseName
	$extension = $file.Extension
	$path = $file.FullName
	
	Write-Host "FILE: $fileName"
	
	#find script with same name in Arhive folder
	#if no file exists create one
	#if file exists, find most recent one and compare hash
	$diffFile = Get-ChildItem -File -Path $ArchiveFolder | Where-Object {($_.BaseName).SubString(0,($_.BaseName).Length - 17) -eq "$baseName" -and $_.Extension -eq $extension} | Sort-Object -Property LastWriteTime -Descending | Select -First 1
	
	if ($diffFile -eq $null)
	{
		Write-Host "No Archived Copy Found" -ForegroundColor Yellow
		Archive-File $path
		continue
	}
	
	Write-Host "Archived Copy Found: $diffFile"
	
	#check filehash
	if ((Get-FileHash $file.FullName).hash -eq (Get-FileHash $diffFile.FullName).hash)
	{
		Write-Host "No Changes Detected" -ForegroundColor Green
	}
	else
	{
		Write-Host "Changes Detected" -ForegroundColor Yellow
		Archive-File $path
	}
	
	Write-Host "*****************"
}

Read-Host "Done! Press Enter To Exit"
