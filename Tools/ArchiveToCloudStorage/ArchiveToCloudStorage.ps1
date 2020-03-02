Import-Module -Name AWSPowerShell.NetCore
# script to archive items over x number of days old to cloud storage (s3). Files in the targetted 
# directory are moved to a temp dir, zipped up and uploaded to cloud storage. 
# Script checks that the zip files is there and then removes the archived files

$Path = "/home/matthew/Documents/R"
$DaysToKeep = '10'
$Now = Get-Date
$LastWriteTime = $Now.AddDays(-$DaysToKeep)

#s3 values
$BucketName = 'matt-aws-archive'

#archiveFolder
$ArchiveDirectory = '/home/matthew/Archive/'
$ArchiveFolderName = (Get-Date -Format "yyyy-MM-dd").ToString()
$ArchivePath = New-Item -Path $ArchiveDirectory -Name $ArchiveFolderName -ItemType Directory

#remove old files
function Remove-ArchivedItem ([string] $Path) {
    Remove-Item -Path $Path -Recurse -Force
}


Copy-Item -Path $Path -Destination $ArchivePath -Recurse |
Where-Object -FilterScript {$_.LastWriteTime -lt $LastWriteTime}

$zipName = "$ArchiveDirectory$ArchiveFolderName.zip" 
Compress-Archive -Path $ArchivePath -DestinationPath $zipName

Write-S3Object -BucketName $BucketName -Key $zipName -File $zipName -Verbose


#check file upload ok and remove old files

if (Get-S3Object -BucketName $BucketName -Key $zipName) {
    Write-Output 'Success, remove old files'
    Remove-ArchivedItem($ArchivePath)
    Remove-ArchivedItem($zipName)
} else {
    Write-Output 'Alert, upload failed'
}


