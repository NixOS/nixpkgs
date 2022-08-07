{ lib, clangStdenv, stdenvNoCC, cmake, fetchFromGitHub, dotnetCorePackages, buildDotnetModule }:
let
  pname = "netcoredbg";
  version = "2.0.0-895";

  # according to CMakeLists.txt, this should be 3.1 even when building for .NET 5
  coreclr-version = "3.1.19";
  coreclr-src = fetchFromGitHub {
    owner = "dotnet";
    repo = "coreclr";
    rev = "v${coreclr-version}";
    sha256 = "o1KafmXqNjX9axr6sSxPKrfUX0e+b/4ANiVQt4T2ybw=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_6_0;

  src = fetchFromGitHub {
    owner = "Samsung";
    repo = pname;
    rev = version;
    sha256 = "sha256-zOfChuNjD6py6KD1AmN5DgCGxD2YNH9gTyageoiN8PU=";
  };

  unmanaged = clangStdenv.mkDerivation rec {
    inherit src pname version;

    patches = [ ./limits.patch ];
    nativeBuildInputs = [ cmake dotnet-sdk ];

    hardeningDisable = [ "strictoverflow" ];

    preConfigure = ''
      export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
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
