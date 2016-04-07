@echo off

cd %~dp0
chcp 1251 >nul
if (%1)==() (
		goto end
)

setlocal enabledelayedexpansion
COLOR 0A
mode con:cols=128 lines=50
rem находим смещение kernel 
bin\sfk166.exe hexfind %1 -pat -bin /88168858/ -case >bin\offset.txt
rem находим смещение ram_disk.gz
bin\sfk166.exe hexfind %1 -pat -bin /FFFFFFFF1F8B08/ -case >>bin\offset.txt 
rem очищаем результаты поиска
bin\sfk166.exe find bin\offset.txt -pat offset>bin\off2.txt
bin\sfk166.exe replace bin\off2.txt -binary /20/0A/ -yes
cls

if exist %~N1 rd /s /q %~N1 >nul

set /A N=0
:loop
FOR /F %%G IN (bin\off2.txt) DO (
	if !N!==1 (
		set /A ofs1=%%G
		set /A N+=1
	)
	if !N!==3 (
		set /A ofs2=%%G
		set /A N+=1
	)
	if !N!==5 (
		set /A ofs3=%%G+4
		set /A N+=1
	)	
	if `%%G` EQU `offset` (
		set /A N+=1
	)
)
FOR %%i IN (%1) DO ( set /A boot_size=%%~Zi )

del bin\offset.txt
del bin\off2.txt
md %~N1
bin\sfk166.exe partcopy %1 -fromto 0x0 %ofs1% %~N1\kernel_header -yes
bin\sfk166.exe partcopy %1 -fromto %ofs1% %ofs2% %~N1\kernel -yes
bin\sfk166.exe partcopy %1 -fromto %ofs2% %ofs3% %~N1\ram_header -yes
bin\sfk166.exe partcopy %1 -fromto %ofs3% %boot_size% %~N1\ram_disk.gz -yes
bin\7z.exe -tgzip x -y %~N1\ram_disk.gz -o%~N1\gz >nul
move %~N1\gz\* %~N1\ram_disk>>nul
rd %~N1\gz
md %~N1\rmdisk
cd %~N1
cd rmdisk
%~dp0bin\cpio.exe -i <../ram_disk
cd ..
cd ..
copy %1 %~N1/%1>>nul
if exist "%~N1/kernel" (
	echo - %~N1/kernel exist.        Success.
) else (
	echo - %~N1/kernel do not exist. Fail.
)
if exist "%~N1/rmdisk" (
	echo - %~N1/rmdisk exist.        Success.
) else (
	echo - %~N1/rmdisk do not exist. Fail.
)
if exist "%~N1/rmdisk/*" (
	echo - %~N1/rmdisk is not empty. Success.
) else (
	echo - %~N1/rmdisk is empty.     Fail.
)
:end