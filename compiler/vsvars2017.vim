let $CommandPromptType='Native'
let $default_version='2022'
let $DevEnvDir='C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\Common7\IDE\'
let $ExtensionSdkDir='C:\Program Files (x86)\Microsoft SDKs\Windows Kits\10\ExtensionSDKs'
let $Framework40Version='v4.0'
let $FrameworkDir='C:\Windows\Microsoft.NET\Framework64\'
let $FrameworkDIR64='C:\Windows\Microsoft.NET\Framework64'
let $FrameworkVersion='v4.0.30319'
let $FrameworkVersion64='v4.0.30319'
let $HTMLHelpDir='C:\Program Files (x86)\HTML Help Workshop'
let $INCLUDE='C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\VC\Tools\MSVC\14.16.27023\ATLMFC\include;' ..
    \ 'C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\VC\Tools\MSVC\14.16.27023\include;' ..
    \ 'C:\Program Files (x86)\Windows Kits\10\include\10.0.26100.0\ucrt;' ..
    \ 'C:\Program Files (x86)\Windows Kits\10\include\10.0.26100.0\shared;' ..
    \ 'C:\Program Files (x86)\Windows Kits\10\include\10.0.26100.0\um;' ..
    \ 'C:\Program Files (x86)\Windows Kits\10\include\10.0.26100.0\winrt;' ..
    \ 'C:\Program Files (x86)\Windows Kits\10\include\10.0.26100.0\cppwinrt'
let $LIB='C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\VC\Tools\MSVC\14.16.27023\ATLMFC\lib\x64;' ..
    \ 'C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\VC\Tools\MSVC\14.16.27023\lib\x64;' ..
    \ 'C:\Program Files (x86)\Windows Kits\10\lib\10.0.26100.0\ucrt\x64;' ..
    \ 'C:\Program Files (x86)\Windows Kits\10\lib\10.0.26100.0\um\x64;' ..
    \ ''
let $LIBPATH='C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\VC\Tools\MSVC\14.16.27023\ATLMFC\lib\x64;' ..
    \ 'C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\VC\Tools\MSVC\14.16.27023\lib\x64;' ..
    \ 'C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\VC\Tools\MSVC\14.16.27023\lib\x86\store\references;' ..
    \ 'C:\Program Files (x86)\Windows Kits\10\UnionMetadata\10.0.26100.0;' ..
    \ 'C:\Program Files (x86)\Windows Kits\10\References\10.0.26100.0;' ..
    \ 'C:\Windows\Microsoft.NET\Framework64\v4.0.30319;' ..
    \ ''
if !exists('$__VSCMD_PREINIT_PATH')
  let $__VSCMD_PREINIT_PATH=$Path
  let $Path='C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\VC\Tools\MSVC\14.16.27023\bin\HostX64\x64;' ..
      \ 'C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\Common7\IDE\VC\VCPackages;' ..
      \ 'C:\Program Files (x86)\Microsoft SDKs\TypeScript\3.1;' ..
      \ 'C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\Common7\IDE\CommonExtensions\Microsoft\TestWindow;' ..
      \ 'C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer;' ..
      \ 'C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\MSBuild\15.0\bin\Roslyn;' ..
      \ 'C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\Team Tools\Performance Tools\x64;' ..
      \ 'C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\Team Tools\Performance Tools;' ..
      \ 'C:\Program Files (x86)\Microsoft Visual Studio\Shared\Common\VSPerfCollectionTools\\x64;' ..
      \ 'C:\Program Files (x86)\Microsoft Visual Studio\Shared\Common\VSPerfCollectionTools\;' ..
      \ 'C:\Program Files (x86)\HTML Help Workshop;' ..
      \ 'C:\Program Files (x86)\Windows Kits\10\bin\10.0.26100.0\x64;' ..
      \ 'C:\Program Files (x86)\Windows Kits\10\bin\x64;' ..
      \ 'C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\\MSBuild\15.0\bin;' ..
      \ 'C:\Windows\Microsoft.NET\Framework64\v4.0.30319;' ..
      \ 'C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\Common7\IDE\;' ..
      \ 'C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\Common7\Tools\;' ..
      \ $__VSCMD_PREINIT_PATH
endif
let $Platform='x64'
let $UCRTVersion='10.0.26100.0'
let $UniversalCRTSdkDir='C:\Program Files (x86)\Windows Kits\10\'
let $VCIDEInstallDir='C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\Common7\IDE\VC\'
let $VCINSTALLDIR='C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\VC\'
let $VCToolsInstallDir='C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\VC\Tools\MSVC\14.16.27023\'
let $VCToolsRedistDir='C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\VC\Redist\MSVC\14.16.27012\'
let $VCToolsVersion='14.16.27023'
let $version='2017'
let $VisualStudioVersion='15.0'
let $VS141COMNTOOLS='C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\VC\Auxiliary\Build\'
let $VS150COMNTOOLS='C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\Common7\Tools\'
let $VSCMD_ARG_app_plat='Desktop'
let $VSCMD_ARG_HOST_ARCH='x64'
let $VSCMD_ARG_TGT_ARCH='x64'
let $VSCMD_VER='15.9.74'
let $VSINSTALLDIR='C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\'
let $WindowsLibPath='C:\Program Files (x86)\Windows Kits\10\UnionMetadata\10.0.26100.0;' ..
    \ 'C:\Program Files (x86)\Windows Kits\10\References\10.0.26100.0'
let $WindowsSdkBinPath='C:\Program Files (x86)\Windows Kits\10\bin\'
let $WindowsSdkDir='C:\Program Files (x86)\Windows Kits\10\'
let $WindowsSDKLibVersion='10.0.26100.0\'
let $WindowsSdkVerBinPath='C:\Program Files (x86)\Windows Kits\10\bin\10.0.26100.0\'
let $WindowsSDKVersion='10.0.26100.0\'
let $__DOTNET_ADD_64BIT='1'
let $__DOTNET_PREFERRED_BITNESS='64'

set makeprg=cmd.exe\ /c\ %:h\vsmake.bat
