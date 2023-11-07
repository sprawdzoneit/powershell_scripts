#sort images by sprawdzone.it

#PowerShell script to sort images (screenshoot) from default folder in Windows and make txt file with content using bullitin OCR functon
#sort files to sub folders with name from creation time year and month

#script need OCR module - run only once to install module for OCR
#https://www.powershellgallery.com/packages/PsOcr/1.1.0
#Install-Module -Name PsOcr 

#path to screenshots folder in user profile
$path = "C:\Users\user\Pictures\Screenshots"

#get files from directory
$files = Get-ChildItem -Path $path -File


foreach ($file in $files) {

    #CreationTime of file to new folder name
    $YearMonth = $file.CreationTime.ToString('yyyyMM')

    $newPath = Join-Path -Path $path -ChildPath $YearMonth  

    #test folder if exist
    if ( !(Test-Path -Path $newpath)) {
        New-Item -ItemType Directory -Force -Path $newPath
    } 
    
    #text file name for OCR
    $textFileName = $file.BaseName + ".txt"

    #OCR usig module PsOcr
    (Convert-PsoImageToText -Path $path\$file).text | Out-File -FilePath $newPath\$textFileName

    #move file to new folder
    Move-Item -Path $file.FullName -Destination $newPath

}