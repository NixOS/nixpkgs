{ lib, stdenv, fetchurl, fetchpatch, makeWrapper, glibcLocales, mono, dotnetPackages, unzip, dotnet-sdk, writeText, roslyn }:

let

  xplat = fetchurl {
    url = "https://github.com/mono/msbuild/releases/download/0.08/mono_msbuild_6.4.0.208.zip";
    sha256 = "05k7qmnhfvrdgyjn6vp81jb97y21m261jnwdyqpjqpcmzz18j93g";
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
  version = "16.8+xamarinxplat.2020.07.30.15.02";

  src = fetchurl {
    url = "https://download.mono-project.com/sources/msbuild/msbuild-${version}.tar.xz";
    sha256 = "10amyca78b6pjfsy54b1rgwz2c1bx0sfky9zhldvzy4divckp25g";
  };

  nativeBuildInputs = [
    dotnet-sdk
    mono
    unzip
  ];

  buildInputs = [
    dotnetPackages.Nuget
    glibcLocales
    makeWrapper
  ];

  # https://github.com/NixOS/nixpkgs/issues/38991
  # bash: warning: setlocale: LC_ALL: cannot change locale (en_US.UTF-8)
  LOCALE_ARCHIVE = lib.optionalString stdenv.isLinux
      "${glibcLocales}/lib/locale/locale-archive";

  patches = [
    (fetchpatch {
      url = "https://github.com/mono/msbuild/commit/cad85cefabdaa001fb4bdbea2f5bf1d1cdb83c9b.patch";
      sha256 = "1s8agc7nxxs69b3fl1v1air0c4dpig3hy4sk11l1560jrlx06dhh";
    })
  ];

  postPatch = ''
    sed -i -e "/<\/projectImportSearchPaths>/a <property name=\"MSBuildExtensionsPath\" value=\"$out/lib/mono/xbuild\"/>" \
      src/MSBuild/app.config
  '';

  buildPhase = ''
    # nuget would otherwise try to base itself in /homeless-shelter
    export HOME=$(pwd)/fake-home

    cp ${nuget-config} NuGet.config
    nuget sources Add -Name nixos -Source $(pwd)/nixos

    for package in ${toString deps}; do
      nuget add $package -Source nixos
    done

    # license check is case sensitive
    mv LICENSE license.bak && mv license.bak license

    mkdir -p artifacts
    unzip ${xplat} -d artifacts
    mv artifacts/msbuild artifacts/mono-msbuild
    chmod +x artifacts/mono-msbuild/MSBuild.dll

    ln -s $(find ${dotnet-sdk} -name libhostfxr.so) artifacts/mono-msbuild/SdkResolvers/Microsoft.DotNet.MSBuildSdkResolver/

    # overwrite the file
    echo "#!${stdenv.shell}" > eng/common/dotnet-install.sh

    # not patchShebangs, there is /bin/bash in the body of the script as well
    substituteInPlace ./eng/cibuild_bootstrapped_msbuild.sh --replace /bin/bash ${stdenv.shell}

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
    license = licenses.mit;
    maintainers = with maintainers; [ jdanek ];
    platforms = platforms.unix;
  };
}
