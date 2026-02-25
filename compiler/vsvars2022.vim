let $CommandPromptType='Native'
let $default_version='2022'
let $DevEnvDir='C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\'
let $ExtensionSdkDir='C:\Program Files (x86)\Microsoft SDKs\Windows Kits\10\ExtensionSDKs'
let $EXTERNAL_INCLUDE='C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Tools\MSVC\14.44.35207\include;' ..
    \ 'C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Tools\MSVC\14.44.35207\ATLMFC\include;' ..
    \ 'C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Auxiliary\VS\include;' ..
    \ 'C:\Program Files (x86)\Windows Kits\10\include\10.0.26100.0\ucrt;' ..
    \ 'C:\Program Files (x86)\Windows Kits\10\\include\10.0.26100.0\\um;' ..
    \ 'C:\Program Files (x86)\Windows Kits\10\\include\10.0.26100.0\\shared;' ..
    \ 'C:\Program Files (x86)\Windows Kits\10\\include\10.0.26100.0\\winrt;' ..
    \ 'C:\Program Files (x86)\Windows Kits\10\\include\10.0.26100.0\\cppwinrt;' ..
    \ 'C:\Program Files (x86)\Windows Kits\NETFXSDK\4.8\include\um'
let $Framework40Version='v4.0'
let $FrameworkDir='C:\Windows\Microsoft.NET\Framework64\'
let $FrameworkDIR64='C:\Windows\Microsoft.NET\Framework64'
let $FrameworkVersion='v4.0.30319'
let $FrameworkVersion64='v4.0.30319'
let $HTMLHelpDir='C:\Program Files (x86)\HTML Help Workshop'
let $IFCPATH='C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Tools\MSVC\14.44.35207\ifc\x64'
let $INCLUDE='C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Tools\MSVC\14.44.35207\include;' ..
    \ 'C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Tools\MSVC\14.44.35207\ATLMFC\include;' ..
    \ 'C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Auxiliary\VS\include;' ..
    \ 'C:\Program Files (x86)\Windows Kits\10\include\10.0.26100.0\ucrt;' ..
    \ 'C:\Program Files (x86)\Windows Kits\10\\include\10.0.26100.0\\um;' ..
    \ 'C:\Program Files (x86)\Windows Kits\10\\include\10.0.26100.0\\shared;' ..
    \ 'C:\Program Files (x86)\Windows Kits\10\\include\10.0.26100.0\\winrt;' ..
    \ 'C:\Program Files (x86)\Windows Kits\10\\include\10.0.26100.0\\cppwinrt;' ..
    \ 'C:\Program Files (x86)\Windows Kits\NETFXSDK\4.8\include\um'
let $is_x64_arch='true'
let $LIB='C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Tools\MSVC\14.44.35207\ATLMFC\lib\x64;' ..
    \ 'C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Tools\MSVC\14.44.35207\lib\x64;' ..
    \ 'C:\Program Files (x86)\Windows Kits\NETFXSDK\4.8\lib\um\x64;' ..
    \ 'C:\Program Files (x86)\Windows Kits\10\lib\10.0.26100.0\ucrt\x64;' ..
    \ 'C:\Program Files (x86)\Windows Kits\10\\lib\10.0.26100.0\\um\x64'
let $LIBPATH='C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Tools\MSVC\14.44.35207\ATLMFC\lib\x64;' ..
    \ 'C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Tools\MSVC\14.44.35207\lib\x64;' ..
    \ 'C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Tools\MSVC\14.44.35207\lib\x86\store\references;' ..
    \ 'C:\Program Files (x86)\Windows Kits\10\UnionMetadata\10.0.26100.0;' ..
    \ 'C:\Program Files (x86)\Windows Kits\10\References\10.0.26100.0;' ..
    \ 'C:\Windows\Microsoft.NET\Framework64\v4.0.30319'
let $NETFXSDKDir='C:\Program Files (x86)\Windows Kits\NETFXSDK\4.8\'
if !exists('$__VSCMD_PREINIT_PATH')
  let $__VSCMD_PREINIT_PATH=$Path
  let $Path='C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Tools\MSVC\14.44.35207\bin\HostX64\x64;' ..
      \ 'C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\VC\VCPackages;' ..
      \ 'C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\CommonExtensions\Microsoft\TestWindow;' ..
      \ 'C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer;' ..
      \ 'C:\Program Files\Microsoft Visual Studio\2022\Professional\MSBuild\Current\bin\Roslyn;' ..
      \ 'C:\Program Files (x86)\Microsoft SDKs\Windows\v10.0A\bin\NETFX 4.8 Tools\x64\;' ..
      \ 'C:\Program Files (x86)\HTML Help Workshop;' ..
      \ 'C:\Program Files\Microsoft Visual Studio\2022\Professional\Team Tools\DiagnosticsHub\Collector;' ..
      \ 'C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Tools\Llvm\x64\bin;' ..
      \ 'C:\Program Files (x86)\Windows Kits\10\bin\10.0.26100.0\\x64;' ..
      \ 'C:\Program Files (x86)\Windows Kits\10\bin\\x64;' ..
      \ 'C:\Program Files\Microsoft Visual Studio\2022\Professional\\MSBuild\Current\Bin\amd64;' ..
      \ 'C:\Windows\Microsoft.NET\Framework64\v4.0.30319;' ..
      \ 'C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\;' ..
      \ 'C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\Tools\;' ..
      \ '' .. $__VSCMD_PREINIT_PATH
endif
let $Platform='x64'
let $UCRTVersion='10.0.26100.0'
let $UniversalCRTSdkDir='C:\Program Files (x86)\Windows Kits\10\'
let $VCIDEInstallDir='C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\VC\'
let $VCINSTALLDIR='C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\'
let $VCPKG_ROOT='C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\vcpkg'
let $VCToolsInstallDir='C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Tools\MSVC\14.44.35207\'
let $VCToolsRedistDir='C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Redist\MSVC\14.44.35112\'
let $VCToolsVersion='14.44.35207'
let $version='2022'
let $VisualStudioVersion='17.0'
let $VS143COMNTOOLS='C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Auxiliary\Build\'
let $VS170COMNTOOLS='C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\Tools\'
let $VSCMD_ARG_app_plat='Desktop'
let $VSCMD_ARG_HOST_ARCH='x64'
let $VSCMD_ARG_TGT_ARCH='x64'
let $VSCMD_VER='17.14.7'
let $VSINSTALLDIR='C:\Program Files\Microsoft Visual Studio\2022\Professional\'
let $WindowsLibPath='C:\Program Files (x86)\Windows Kits\10\UnionMetadata\10.0.26100.0;' ..
    \ 'C:\Program Files (x86)\Windows Kits\10\References\10.0.26100.0'
let $WindowsSdkBinPath='C:\Program Files (x86)\Windows Kits\10\bin\'
let $WindowsSdkDir='C:\Program Files (x86)\Windows Kits\10\'
let $WindowsSDKLibVersion='10.0.26100.0\'
let $WindowsSdkVerBinPath='C:\Program Files (x86)\Windows Kits\10\bin\10.0.26100.0\'
let $WindowsSDKVersion='10.0.26100.0\'
let $WindowsSDK_ExecutablePath_x64='C:\Program Files (x86)\Microsoft SDKs\Windows\v10.0A\bin\NETFX 4.8 Tools\x64\'
let $WindowsSDK_ExecutablePath_x86='C:\Program Files (x86)\Microsoft SDKs\Windows\v10.0A\bin\NETFX 4.8 Tools\'
let $__DOTNET_ADD_64BIT='1'
let $__DOTNET_PREFERRED_BITNESS='64'

set makeprg=cmd.exe\ /c\ %:h\vsmake.bat
