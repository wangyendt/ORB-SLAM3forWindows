@echo off

:start
set /p idx=请选择您要运行的任务（1. Mono; 2. MonoIMU; 3. Stereo; 4. Stereo IMU; 5. Custom Android）

if /i '%idx%'=='1' goto mono
if /i '%idx%'=='2' goto monoimu
if /i '%idx%'=='3' goto stereo
if /i '%idx%'=='4' goto stereoimu


:mono
.\Monocular\Release\mono_euroc.exe ..\Vocabulary\ORBvoc.txt .\Monocular\EuRoC.yaml D:\work\data\euroc\MH01 .\Monocular\EuRoC_TimeStamps\MH01.txt dataset-MH01_mono
goto ask_quiting
:monoimu
.\Monocular-Inertial\Release\mono_inertial_euroc.exe ..\Vocabulary\ORBvoc.txt .\Monocular-Inertial\EuRoC.yaml D:\work\data\euroc\MH01 .\Monocular-Inertial\EuRoC_TimeStamps\MH01.txt dataset-MH01_monoi
goto ask_quiting
:stereo
.\Stereo\Release\stereo_euroc.exe ..\Vocabulary\ORBvoc.txt .\Stereo\EuRoC.yaml D:\work\data\euroc\MH01 .\Stereo\EuRoC_TimeStamps\MH01.txt dataset-MH01_stereo
goto ask_quiting
:stereoimu
.\Stereo-Inertial\Release\stereo_inertial_euroc.exe ..\Vocabulary\ORBvoc.txt .\Stereo-Inertial\EuRoC.yaml D:\work\data\euroc\MH01 .\Stereo-Inertial\EuRoC_TimeStamps\MH01.txt dataset-MH01_stereoi
goto ask_quiting

:ask_quiting

set /p res=是否退出程序？（1. 退出; 2. 重新运行）
if /i '%res%'=='1' goto end
if /i '%res%'=='2' goto start

:end
pause
