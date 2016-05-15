@echo off
chcp 1251 >nul

echo custom.bat by Victor Malyshev (@I1PABIJJA) i1pabijja@gmail.com

echo init folders...

set CD=%~dp0
for /d %%I in ("*.zip.bzprj") do (set RD=%%~I)

set ROM=%CD%\%RD%\baseROM
set Tools=%CD%\data\tools
set marpt=%CD%\data\tools\marp-tools
set Repo=%CD%\repositories\patches\main\boot

echo clean dirs...

del %Tools%\*.img
rmdir /S /Q %Tools%\boot_PORT

echo Repacking boot.img...

ren %ROM%\boot.img boot_PORT.img

move /Y %ROM%\boot_PORT.img %Tools%\boot_PORT.img

call %Tools%\MTK_unpack.bat boot_PORT.img 

python %marpt%\marp-cr.py
python -jar %marpt%\marp-id.py
python -jar %marpt%\marp-us.py %ROM%

copy /Y %Repo%\kernel\* %Tools%\boot_PORT\
copy /Y %Repo%\rmdisk\* %Tools%\boot_PORT\rmdisk\

call %Tools%\MTK_pack.bat boot_PORT

move /Y %Tools%\new_image.img %ROM%\boot.img

del %Tools%\*.img
rmdir /S /Q %Tools%\boot_PORT

echo Repacking Boot.img finished...
