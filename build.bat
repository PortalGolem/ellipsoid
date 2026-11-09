mkdir %~dp0build
odin build %~dp0src -out:%~dp0build\elipsoid.exe
copy %~dp0lib\SDL3.dll %~dp0build\
