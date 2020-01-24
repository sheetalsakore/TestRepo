if not exist C:\ATP mkdir C:\ATP
if not exist C:\ATP\Client mkdir C:\ATP\Client
if not exist C:\ATP\Client mkdir C:\ATP\ClientExtra
pushd C:\ATP
ping SUCHITAM-AUTO
ping SUCHITAM-AUTO
dir \\SUCHITAM-AUTO\CTEPExton\SrcStorages\cvs\plantatp\tip\
xcopy /I /E /Y /Z /R /H \\SUCHITAM-AUTO\CTEPExton\SrcStorages\cvs\plantatp\tip\exebin\* C:\ATP\Client
xcopy /I /Y /Z /R /H \\SUCHITAM-AUTO\CTEPExton\SrcStorages\cvs\plantatp\tip\dep\misc\caffeine.exe C:\ATP\Client\
xcopy /I /E /Y /Z /R /H C:\ATP\Client\* C:\ATP\ClientExtra
pushd C:\ATP\ClientExtra
popd
