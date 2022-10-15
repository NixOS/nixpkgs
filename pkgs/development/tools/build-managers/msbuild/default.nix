{ lib, stdenv, fetchurl, fetchpatch, makeWrapper, glibcLocales, mono, dotnetPackages, unzip, dotnetCorePackages, writeText, roslyn }:

let

  dotnet-sdk = dotnetCorePackages.sdk_5_0;

  xplat = fetchurl {
    url = "https://github.com/mono/msbuild/releases/download/v16.9.0/mono_msbuild_6.12.0.137.zip";
    sha256 = "1wnzbdpk4s9bmawlh359ak2b8zi0sgx1qvcjnvfncr1wsck53v7q";
  };

  deps = map (package: package.src)
    (import ./deps.nix { inherit fetchurl; });

  nuget-config = writeText "NuGet.config" ''
    <?xml version="1.0" encoding="utf-8"?>
    <configuration>
      <packageSources>
        <clear />
      </packageSources>
    </configuration>
  '';

in

stdenv.mkDerivation rec {
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
    dotnetPackages.Nuget
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

  buildPhase = ''
    # nuget would otherwise try to base itself in /homeless-shelter
    export HOME=$(pwd)/fake-home

    cp ${nuget-config} NuGet.config
    nuget sources Add -Name nixos -Source $(pwd)/nixos

    for package in ${toString deps}; do
      nuget add $package -Source nixos
    done

    mkdir -p artifacts
    unzip ${xplat} -d artifacts
    mv artifacts/msbuild artifacts/mono-msbuild
    chmod +x artifacts/mono-msbuild/MSBuild.dll

    ln -s $(find ${dotnet-sdk} -name libhostfxr.so) artifacts/mono-msbuild/SdkResolvers/Microsoft.DotNet.MSBuildSdkResolver/

    # overwrite the file
    echo "#!${stdenv.shell}" > eng/common/dotnet-install.sh
    echo "#!${stdenv.shell}" > mono/build/get_sdk_files.sh

    mkdir -p mono/dotnet-overlay/msbuild-bin
    cp ${dotnet-sdk}/sdk/*/{Microsoft.NETCoreSdk.BundledVersions.props,RuntimeIdentifierGraph.json} mono/dotnet-overlay/msbuild-bin

    # DisableNerdbankVersioning https://gitter.im/Microsoft/msbuild/archives/2018/06/27?at=5b33dbc4ce3b0f268d489bfa
    # TODO there are some (many?) failing tests
    ./eng/cibuild_bootstrapped_msbuild.sh --host_type mono --configuration Release --skip_tests /p:DisableNerdbankVersioning=true
    patchShebangs stage1/mono-msbuild/msbuild
  '';

  installPhase = ''
    stage1/mono-msbuild/msbuild mono/build/install.proj /p:MonoInstallPrefix="$out" /p:Configuration=Release-MONO

    ln -s ${roslyn}/lib/dotnet/microsoft.net.compilers.toolset/*/tasks/net472 $out/lib/mono/msbuild/Current/bin/Roslyn

    makeWrapper ${mono}/bin/mono $out/bin/msbuild \
      --set-default MONO_GC_PARAMS "nursery-size=64m" \
      --add-flags "$out/lib/mono/msbuild/15.0/bin/MSBuild.dll"

    ln -s $(find ${dotnet-sdk} -name libhostfxr.so) $out/lib/mono/msbuild/Current/bin/SdkResolvers/Microsoft.DotNet.MSBuildSdkResolver/
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
