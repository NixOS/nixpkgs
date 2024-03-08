{ lib, clangStdenv, stdenv, cmake, autoPatchelfHook, fetchFromGitHub, dotnetCorePackages, buildDotnetModule, netcoredbg, testers }:
let
  pname = "netcoredbg";
  build = "1018";
  release = "3.0.0";
  version = "${release}-${build}";
  hash = "sha256-9Rd0of1psQTVLaTOCPWsYgvIXN7apZKDQNxuZGj4vXw=";

  coreclr-version = "v7.0.14";
  coreclr-src = fetchFromGitHub {
    owner = "dotnet";
    repo = "runtime";
    rev = coreclr-version;
    sha256 = "sha256-n7ySUTB4XOXxeeVomySdZIYepdp0PNNGW9pU/2wwVGM=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_7_0;

  src = fetchFromGitHub {
    owner = "Samsung";
    repo = pname;
    rev = version;
    inherit hash;
  };

  unmanaged = clangStdenv.mkDerivation {
    inherit src pname version;

    nativeBuildInputs = [ cmake dotnet-sdk ];

    hardeningDisable = [ "strictoverflow" ];

    preConfigure = ''
      export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
    '';

    cmakeFlags = [
      "-DCORECLR_DIR=${coreclr-src}/src/coreclr"
      "-DDOTNET_DIR=${dotnet-sdk}"
      "-DBUILD_MANAGED=0"
    ];
  };

  managed = buildDotnetModule {
    inherit pname version src dotnet-sdk;

    projectFile = "src/managed/ManagedPart.csproj";
    nugetDeps = ./deps.nix;

    # include platform-specific dbgshim binary in nugetDeps
    dotnetFlags = [ "-p:UseDbgShimDependency=true" ];
    executables = [ ];

    # this passes RID down to dotnet build command
    # and forces dotnet to include binary dependencies in the output (libdbgshim)
    selfContainedBuild = true;
  };
in
stdenv.mkDerivation {
  inherit pname version;
  # managed brings external binaries (libdbgshim.*)
  # include source here so that autoPatchelfHook can do it's job
  src = managed;

  nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];
  buildInputs = lib.optionals stdenv.isLinux [ stdenv.cc.cc.lib ];
  installPhase = ''
    mkdir -p $out/share/netcoredbg $out/bin
    cp ${unmanaged}/* $out/share/netcoredbg
    cp ./lib/netcoredbg/* $out/share/netcoredbg
    # darwin won't work unless we link all files
    ln -s $out/share/netcoredbg/* "$out/bin/"
  '';

  passthru = {
    inherit (managed) fetch-deps;
    tests.version = testers.testVersion {
      package = netcoredbg;
      command = "netcoredbg --version";
      version = "NET Core debugger ${release}";
    };
  };

  meta = with lib; {
    description = "Managed code debugger with MI interface for CoreCLR";
    homepage = "https://github.com/Samsung/netcoredbg";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ leo60228 konradmalik ];
  };
}
