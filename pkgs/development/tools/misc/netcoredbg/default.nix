{ lib, clangStdenv, stdenvNoCC, cmake, fetchFromGitHub, dotnetCorePackages, buildDotnetModule }:
let
  pname = "netcoredbg";
  version = "1.2.0-825";

  # according to CMakeLists.txt, this should be 3.1 even when building for .NET 5
  coreclr-version = "3.1.19";
  coreclr-src = fetchFromGitHub {
    owner = "dotnet";
    repo = "coreclr";
    rev = "v${coreclr-version}";
    sha256 = "o1KafmXqNjX9axr6sSxPKrfUX0e+b/4ANiVQt4T2ybw=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_5_0;

  src = fetchFromGitHub {
    owner = "Samsung";
    repo = pname;
    rev = version;
    sha256 = "JQhDI1+bVbOIFNkXixZnFB/5+dzqCbInR0zJvykcFCg=";
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

    hardeningDisable = [ "strictoverflow" ];

    preConfigure = ''
      dotnetVersion="$(${dotnet-sdk}/bin/dotnet --list-runtimes | grep -Po '^Microsoft.NETCore.App \K.*?(?= )')"
      cmakeFlagsArray+=(
        "-DDBGSHIM_RUNTIME_DIR=${dotnet-sdk}/shared/Microsoft.NETCore.App/$dotnetVersion"
      )
    '';

    cmakeFlags = [
      "-DCORECLR_DIR=${coreclr-src}"
      "-DDOTNET_DIR=${dotnet-sdk}"
      "-DBUILD_MANAGED=0"
    ];
  };

  managed = buildDotnetModule {
    inherit pname version src dotnet-sdk;

    projectFile = "src/managed/ManagedPart.csproj";
    nugetDeps = ./deps.nix;

    executables = [ ];
  };
in
stdenvNoCC.mkDerivation {
  inherit pname version;

  buildCommand = ''
    mkdir -p $out/share/netcoredbg $out/bin
    cp ${unmanaged}/* $out/share/netcoredbg
    cp ${managed}/lib/netcoredbg/* $out/share/netcoredbg
    ln -s $out/share/netcoredbg/netcoredbg $out/bin/netcoredbg
  '';

  meta = with lib; {
    description = "Managed code debugger with MI interface for CoreCLR";
    homepage = "https://github.com/Samsung/netcoredbg";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.leo60228 ];
  };
}
