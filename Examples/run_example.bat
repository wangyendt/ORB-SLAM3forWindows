@echo off

:start
set /p idx=Please select the task you wanna run (1. Mono; 2. MonoIMU; 3. Stereo; 4. Stereo IMU; 5. Custom Android)
set /p runtime=You want to run (1. Debug; 2. Release;)

if /i '%runtime%'=='1' set run="Debug"
if /i '%runtime%'=='2' set run="Release"
echo %run%

if /i '%idx%'=='1' goto mono
if /i '%idx%'=='2' goto monoimu
if /i '%idx%'=='3' goto stereo
if /i '%idx%'=='4' goto stereoimu
if /i '%idx%'=='5' goto mate20_mono



:mono
.\Monocular\%run%\mono_euroc.exe ..\Vocabulary\ORBvoc.bin .\Monocular\EuRoC.yaml D:\work\data\euroc\MH01 .\Monocular\EuRoC_TimeStamps\MH01.txt dataset-MH01_mono
goto ask_quiting
:monoimu
.\Monocular-Inertial\%run%\mono_inertial_euroc.exe ..\Vocabulary\ORBvoc.bin .\Monocular-Inertial\EuRoC.yaml D:\work\data\euroc\MH01 .\Monocular-Inertial\EuRoC_TimeStamps\MH01.txt dataset-MH01_monoi
goto ask_quiting
:stereo
.\Stereo\%run%\stereo_euroc.exe ..\Vocabulary\ORBvoc.bin .\Stereo\EuRoC.yaml D:\work\data\euroc\MH01 .\Stereo\EuRoC_TimeStamps\MH01.txt dataset-MH01_stereo
goto ask_quiting
:stereoimu
.\Stereo-Inertial\%run%\stereo_inertial_euroc.exe ..\Vocabulary\ORBvoc.bin .\Stereo-Inertial\EuRoC.yaml D:\work\data\euroc\MH01 .\Stereo-Inertial\EuRoC_TimeStamps\MH01.txt dataset-MH01_stereoi
goto ask_quiting
:mate20_mono
set root="D:\work\data\phone_data\slam\2022_08_08_15_55_04_slam"
.\Android-Phone\%run%\mono_android_mate20.exe ..\Vocabulary\ORBvoc.bin .\Android-Phone\mate20.yaml %root% %root%\mav0\cam0\timestamp.txt dataset-android-mono
goto ask_quiting


:ask_quiting

set /p res=Exit program? (1. exit 2. restart)
if /i '%res%'=='1' goto end
if /i '%res%'=='2' goto start

:end
pause
