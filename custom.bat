@echo off

echo custom.bat by Max Pustovalov (@mxsin) sir.mxp@yandex.ru

echo initialization...

set CD=%~dp0
cd %CD%
for /d %%i in ("*.zip.bzprj") do set RD=%%~i

set ROM=%CD%\%RD%\baseROM
set Tools=%CD%\data\tools
set marpt=%CD%\data\tools\marp_tools
set Repo=%CD%\repositories\patches\main\boot

echo current directory: %CD%
echo rom directory: %RD%
echo base rom directory: %RD%

echo cleaning tools directory...

del %Tools%\*.img
rmdir /S /Q %Tools%\boot_PORT

echo unpacking boot...

ren %ROM%\boot.img boot_PORT.img

move /Y %ROM%\boot_PORT.img %Tools%\boot_PORT.img

call %Tools%\MTK_unpack.bat boot_PORT.img > nul

echo modifying updater-script...

rem python %marpt%\marp_custom_boot_data.py
rem python %marpt%\marp_initd_support.py
call %marpt%\marp_updater_script.py %ROM% aleksieko MultiROM

echo replacing necessary files...

copy /Y %Repo%\kernel\* %Tools%\boot_PORT\
copy /Y %Repo%\rmdisk\* %Tools%\boot_PORT\rmdisk\

echo packing boot...

call %Tools%\MTK_pack.bat boot_PORT

move /Y %Tools%\new_image.img %ROM%\boot.img

echo post-process cleaning...

del %Tools%\*.img
rmdir /S /Q %Tools%\boot_PORT

echo work done!
