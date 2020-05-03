{ stdenv, fetchurl, makeWrapper, glibcLocales, mono, dotnetPackages, unzip, dotnet-sdk }:

let

  xplat = fetchurl {
    url = "https://github.com/mono/msbuild/releases/download/0.07/mono_msbuild_xplat-master-8f608e49.zip";
    sha256 = "1jxq3fk9a6q2a8i9zacxaz3fkvc22i9qvzlpa7wbb95h42g0ffhq";
  };

  deps = import ./nuget.nix { inherit fetchurl; };

in

stdenv.mkDerivation rec {
  pname = "msbuild";
  version = "16.3+xamarinxplat.2019.07.26.14.57";

  src = fetchurl {
    url = "https://download.mono-project.com/sources/msbuild/msbuild-${version}.tar.xz";
    sha256 = "1zcdfx4xsh62wj3g1jc2an0lppsfs691lz4dv05xbgi01aq1hk6a";
  };

  nativeBuildInputs = [
    dotnet-sdk
    mono
  ];

  buildInputs = [
    dotnetPackages.Nuget
    glibcLocales
    makeWrapper
    unzip
  ];

  # https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=msbuild
  phases = ["unpackPhase" "buildPhase" "installPhase" "installCheckPhase"];

  # https://github.com/NixOS/nixpkgs/issues/38991
  # bash: warning: setlocale: LC_ALL: cannot change locale (en_US.UTF-8)
  LOCALE_ARCHIVE = stdenv.lib.optionalString stdenv.isLinux
      "${glibcLocales}/lib/locale/locale-archive";

  buildPhase = ''
    # nuget would otherwise try to base itself in /homeless-shelter
    export HOME=$(pwd)/fake-home

    for package in ${toString deps}; do
      nuget add $package -Source nixos
    done

    nuget sources Disable -Name "nuget.org"
    nuget sources Add -Name nixos -Source $(pwd)/nixos

    # license check is case sensitive
    mv LICENSE license

    mkdir -p artifacts
    unzip ${xplat} -d artifacts
    mv artifacts/msbuild artifacts/mono-msbuild
    chmod +x artifacts/mono-msbuild/MSBuild.dll

    ln -s $(find ${dotnet-sdk} -name libhostfxr.so) artifacts/mono-msbuild/SdkResolvers/Microsoft.DotNet.MSBuildSdkResolver/

    # overwrite the file
    echo "#!${stdenv.shell}" > eng/common/dotnet-install.sh

    # msbuild response files to use only the nixos source
    echo "/p:RestoreSources=nixos" > artifacts/mono-msbuild/MSBuild.rsp
    echo "/p:RestoreSources=nixos" > src/MSBuild/MSBuild.rsp

    # not patchShebangs, there is /bin/bash in the body of the script as well
    substituteInPlace ./eng/cibuild_bootstrapped_msbuild.sh --replace /bin/bash ${stdenv.shell}

    # DisableNerdbankVersioning https://gitter.im/Microsoft/msbuild/archives/2018/06/27?at=5b33dbc4ce3b0f268d489bfa
    # TODO there are some (many?) failing tests
    ./eng/cibuild_bootstrapped_msbuild.sh --host_type mono --configuration Release --skip_tests /p:DisableNerdbankVersioning=true
  '';

  installPhase = ''
    mono artifacts/mono-msbuild/MSBuild.dll mono/build/install.proj /p:MonoInstallPrefix="$out" /p:Configuration=Release-MONO

    ln -s ${mono}/lib/mono/msbuild/Current/bin/Roslyn $out/lib/mono/msbuild/Current/bin/Roslyn

    makeWrapper ${mono}/bin/mono $out/bin/msbuild \
      --set MSBuildExtensionsPath $out/lib/mono/xbuild \
      --set-default MONO_GC_PARAMS "nursery-size=64m" \
      --add-flags "$out/lib/mono/msbuild/15.0/bin/MSBuild.dll"
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

  meta = with stdenv.lib; {
    description = "Mono version of Microsoft Build Engine, the build platform for .NET, and Visual Studio";
    homepage = "https://github.com/mono/msbuild";
    license = licenses.mit;
    maintainers = with maintainers; [ jdanek ];
    platforms = platforms.unix;
  };
}

