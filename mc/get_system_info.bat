@echo off

SET HH=%time:~0,2%
IF %HH% lss 10 (SET HH=0%time:~1,1%)
SET NN=%time:~3,2%
SET SS=%time:~6,2%
SET MS=%time:~9,2%
SET NEWFILENAME=system_info_%date:~0,4%-%date:~5,2%-%date:~8,2%_%HH%-%NN%-%SS%.txt

echo %NEWFILENAME%

wmic cpu get processorId >> %NEWFILENAME%
wmic baseboard get serialNumber >> %NEWFILENAME%
wmic bios get biosVersion >> %NEWFILENAME%
wmic bios get serialNumber >> %NEWFILENAME%

pause

