# SimpleVersionControl
version control, archiving script that uses file hash to determine if a file has been changed and needs to be archived or not

## Intro
I wrote this to have a simple way to archive all my scripts, but it can be used for any type of file. Using a real version control system like Git is obviously better but is not always an option.
I have this script setup as a scheduled task that runs every hour but you could run it manually after making changes as well.

## How it works
This script will go through all the files (recursively) in the directory you provide and get the file hash. It will then get all the files from the archive directory that match the filename. If no match is found the file will be moved to the archive folder with a timestamp added to the filename.
If one or more matches are found the most recent archived file hash is compared to the current file hash. If there are any differences the file is moved to the archive folder with a timestamp.

## Limitations
The directory structure is not copied over to the archive folder.
That means that if you have files with the same name in different subfolders, they will be seen as the same file and be archived every single time. I might fix this later but haven't put the time in yet as I didn't need it for my use case.

The script expects the Archive folder to be inside of the folder it's monitoring so it will exclude any folder with the same name.
