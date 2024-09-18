{ lib, stdenv, fetchurl, makeWrapper, glibcLocales, mono, unzip, dotnetCorePackages, roslyn }:

let

  dotnet-sdk = dotnetCorePackages.sdk_6_0;

  xplat = fetchurl {
    url = "https://github.com/mono/msbuild/releases/download/v16.9.0/mono_msbuild_6.12.0.137.zip";
    sha256 = "1wnzbdpk4s9bmawlh359ak2b8zi0sgx1qvcjnvfncr1wsck53v7q";
  };

  inherit (stdenv.hostPlatform.extensions) sharedLibrary;

  mkPackage = attrs: stdenv.mkDerivation (finalAttrs:
    dotnetCorePackages.addNuGetDeps
      {
        nugetDeps = ./deps.nix;
        overrideFetchAttrs = a: {
          dontBuild = false;
        };
      }
      attrs finalAttrs);

in

mkPackage rec {
  pname = "msbuild";
  version = "16.10.1+xamarinxplat.2021.05.26.14.00";

  src = fetchurl {
    url = "https://download.mono-project.com/sources/msbuild/msbuild-${version}.tar.xz";
    sha256 = "05ghqqkdj4s3d0xkp7mkdzjig5zj3k6ajx71j0g2wv6rdbvg6899";
  };

  nativeBuildInputs = [
    dotnet-sdk
    mono
    unzip
    makeWrapper
  ];

  buildInputs = [
    glibcLocales
  ];

  # https://github.com/NixOS/nixpkgs/issues/38991
  # bash: warning: setlocale: LC_ALL: cannot change locale (en_US.UTF-8)
  LOCALE_ARCHIVE = lib.optionalString stdenv.isLinux
      "${glibcLocales}/lib/locale/locale-archive";

  postPatch = ''
    # not patchShebangs, there is /bin/bash in the body of the script as well
    substituteInPlace ./eng/cibuild_bootstrapped_msbuild.sh --replace /bin/bash ${stdenv.shell}

    patchShebangs eng/*.sh mono/build/*.sh

    sed -i -e "/<\/projectImportSearchPaths>/a <property name=\"MSBuildExtensionsPath\" value=\"$out/lib/mono/xbuild\"/>" \
      src/MSBuild/app.config

    # license check is case sensitive
    mv LICENSE license.bak && mv license.bak license
  '';

  linkNugetPackages = true;

  buildPhase = ''
    mkdir -p artifacts
    unzip ${xplat} -d artifacts
    mv artifacts/msbuild artifacts/mono-msbuild
    chmod +x artifacts/mono-msbuild/MSBuild.dll

    # The provided libhostfxr.dylib is for x86_64-darwin, so we remove it
    rm artifacts/mono-msbuild/SdkResolvers/Microsoft.DotNet.MSBuildSdkResolver/libhostfxr.dylib

    ln -s $(find ${dotnet-sdk} -name libhostfxr${sharedLibrary}) artifacts/mono-msbuild/SdkResolvers/Microsoft.DotNet.MSBuildSdkResolver/

    # overwrite the file
    echo "#!${stdenv.shell}" > eng/common/dotnet-install.sh
    echo "#!${stdenv.shell}" > mono/build/get_sdk_files.sh

    # Prevent msbuild from downloading a new libhostfxr
    echo "#!${stdenv.shell}" > mono/build/extract_and_copy_hostfxr.sh

    mkdir -p mono/dotnet-overlay/msbuild-bin
    cp ${dotnet-sdk}/sdk/*/{Microsoft.NETCoreSdk.BundledVersions.props,RuntimeIdentifierGraph.json} mono/dotnet-overlay/msbuild-bin

    # DisableNerdbankVersioning https://gitter.im/Microsoft/msbuild/archives/2018/06/27?at=5b33dbc4ce3b0f268d489bfa
    # TODO there are some (many?) failing tests
    NuGetPackageRoot="$NUGET_PACKAGES" ./eng/cibuild_bootstrapped_msbuild.sh --host_type mono --configuration Release --skip_tests /p:DisableNerdbankVersioning=true
    patchShebangs stage1/mono-msbuild/msbuild
  '';

  installPhase = ''
    stage1/mono-msbuild/msbuild mono/build/install.proj /p:MonoInstallPrefix="$out" /p:Configuration=Release-MONO

    ln -s ${roslyn}/lib/dotnet/microsoft.net.compilers.toolset/*/tasks/net472 $out/lib/mono/msbuild/Current/bin/Roslyn

    makeWrapper ${mono}/bin/mono $out/bin/msbuild \
      --set-default MONO_GC_PARAMS "nursery-size=64m" \
      --add-flags "$out/lib/mono/msbuild/15.0/bin/MSBuild.dll"

    ln -s $(find ${dotnet-sdk} -name libhostfxr${sharedLibrary}) $out/lib/mono/msbuild/Current/bin/SdkResolvers/Microsoft.DotNet.MSBuildSdkResolver/
  '';

  doInstallCheck = true;

  # https://docs.microsoft.com/cs-cz/visualstudio/msbuild/walkthrough-creating-an-msbuild-project-file-from-scratch?view=vs-2019
  installCheckPhase = ''
    cat > Helloworld.cs <<EOF
using System;

class HelloWorld
{
    static void Main()
    {
#if DebugConfig
        Console.WriteLine("WE ARE IN THE DEBUG CONFIGURATION");
#endif

        Console.WriteLine("Hello, world!");
    }
}
EOF

    cat > Helloworld.csproj <<EOF
<Project xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
  <ItemGroup>
    <Compile Include="Helloworld.cs" />
  </ItemGroup>
  <Target Name="Build">
    <Csc Sources="@(Compile)"/>
  </Target>
</Project>
EOF

    $out/bin/msbuild Helloworld.csproj -t:Build
    ${mono}/bin/mono Helloworld.exe | grep "Hello, world!"
  '';

  meta = with lib; {
    description = "Mono version of Microsoft Build Engine, the build platform for .NET, and Visual Studio";
    mainProgram = "msbuild";
    homepage = "https://github.com/mono/msbuild";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryNativeCode  # dependencies
    ];
    license = licenses.mit;
    maintainers = with maintainers; [ jdanek ];
    platforms = platforms.unix;
  };
}
