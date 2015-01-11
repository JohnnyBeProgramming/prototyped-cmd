@echo off

set map_drive=X:
set map_path=\\SERVERNAME\ShareFolder

echo -------------------------------------------------------------------------------
echo  Map Network Drive [ %map_drive% ]
echo -------------------------------------------------------------------------------
echo  - Map Folder: %map_path%

net use %map_drive% "%map_path%"

pause