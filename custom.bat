@echo off

echo Original custom.bat by Victor Malyshev (@I1PABIJJA) i1pabijja@gmail.com
echo Current custom.bat by Max Pustovalov (@mxsin) sir.mxp@yandex.ru

echo init folders...

set CD=%~dp0
for /d %%I in ("*.zip.bzprj") do (set RD=%%~I)

set ROM=%CD%\%RD%\baseROM
set Tools=%CD%\data\tools
set marpt=%CD%\data\tools\marp_tools
set Repo=%CD%\repositories\patches\main\boot

echo clean dirs...

del %Tools%\*.img
rmdir /S /Q %Tools%\boot_PORT

echo Repacking boot.img...

ren %ROM%\boot.img boot_PORT.img

move /Y %ROM%\boot_PORT.img %Tools%\boot_PORT.img

call %Tools%\MTK_unpack.bat boot_PORT.img > nul

cd /d %CD%

rem python %marpt%\marp_custom_boot_data.py
rem python %marpt%\marp_initd_support.py
call %marpt%\marp_updater_script.py %ROM% mxsin MultiROM
pause

copy /Y %Repo%\kernel\* %Tools%\boot_PORT\
copy /Y %Repo%\rmdisk\* %Tools%\boot_PORT\rmdisk\

call %Tools%\MTK_pack.bat boot_PORT

move /Y %Tools%\new_image.img %ROM%\boot.img

del %Tools%\*.img
rmdir /S /Q %Tools%\boot_PORT

echo Repacking Boot.img finished...
