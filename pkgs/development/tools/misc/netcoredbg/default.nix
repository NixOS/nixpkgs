{ clangStdenv, stdenvNoCC, makeWrapper, cmake, fetchFromGitHub, dotnetCorePackages, runCommand, fetchurl, dotnetPackages }:
let
  # according to CMakeLists.txt, this should be 3.1 even when building for .NET 5
  coreclr-version = dotnetCorePackages.netcore_3_1.version;
  coreclr-src = fetchFromGitHub {
    owner = "dotnet";
    repo = "coreclr";
    rev = "v${coreclr-version}";
    sha256 = "xoLBfmlIS0RbOP0VISmU1pO3lRIZbKZm/XjbALbwCSk=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_5_0;
  runtime-version = "5.0.5"; # FIXME: keep this in sync automatically

  pname = "netcoredbg";
  version = "1.2.0-786";

  src = fetchFromGitHub {
    owner = "Samsung";
    repo = pname;
    rev = version;
    sha256 = "a5eamraswh8PMDlYJA1nAsvP0lPs9hsHLu9S/vFQhX8=";
  };

  unmanaged = clangStdenv.mkDerivation rec {
    inherit src pname version;

    nativeBuildInputs = [ cmake ];

    # Building the "unmanaged part" still involves compiling C# code.
    preBuild = ''
      export HOME=$(mktemp -d)
      export DOTNET_CLI_TELEMETRY_OPTOUT=1
      export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1
    '';

    cmakeFlags = [
      "-DCORECLR_DIR=${coreclr-src}"
      "-DDOTNET_DIR=${dotnet-sdk}"
      "-DBUILD_MANAGED=0"
      "-DDBGSHIM_RUNTIME_DIR=${dotnet-sdk}/shared/Microsoft.NETCore.App/${runtime-version}"
    ];
  };

  deps = import ./deps.nix { inherit fetchurl; };

  # Build the nuget source needed for the later build all by itself
  # since it's a time-consuming step that only depends on ./deps.nix.
  # This makes it easier to experiment with the main build.
  nugetSource = stdenvNoCC.mkDerivation {
    pname = "netcoredbg-nuget-deps";
    inherit version;

    dontUnpack = true;

    nativeBuildInputs = [ dotnetPackages.Nuget ];

    buildPhase = ''
      export HOME=$(mktemp -d)

      mkdir -p $out/lib

      # disable default-source so nuget does not try to download from online-repo
      nuget sources Disable -Name "nuget.org"
      # add all dependencies to the source
      for package in ${toString deps}; do
        nuget add $package -Source $out/lib
      done
    '';

    dontInstall = true;
  };

  managed = stdenvNoCC.mkDerivation {
    inherit pname version src;

    buildInputs = [ dotnet-sdk ];
    nativeBuildInputs = [ dotnetPackages.Nuget ];

    buildPhase = ''
      mkdir -p $out/lib

      export HOME=$(mktemp -d)
      export DOTNET_CLI_TELEMETRY_OPTOUT=1
      export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1

      pushd src
      nuget sources Disable -Name "nuget.org"
      dotnet restore --source ${nugetSource}/lib managed/ManagedPart.csproj
      popd

      pushd src/managed
      dotnet build --no-restore -c Release ManagedPart.csproj
      popd
    '';

    installPhase = ''
      pushd src/managed
      dotnet publish --no-restore -o $out/lib -c Release ManagedPart.csproj
      popd
    '';
  };
in
stdenvNoCC.mkDerivation {
  inherit pname version;

  nativeBuildInputs = [ makeWrapper ];

  buildCommand = ''
    mkdir -p $out
    cp ${unmanaged}/* $out
    cp ${managed}/lib/* $out
    makeWrapper $out/netcoredbg $out/bin/netcoredbg
  '';
}
