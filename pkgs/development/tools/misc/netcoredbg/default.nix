{ lib, clangStdenv, stdenv, cmake, autoPatchelfHook, fetchFromGitHub, dotnetCorePackages, buildDotnetModule }:
let
  pname = "netcoredbg";
  version = "2.2.0-961";
  hash = "0gbjm8x40hzf787kccfxqb2wdgfks81f6hzr6rrmid42s4bfs5w7";

  coreclr-version = "v7.0.4";
  coreclr-src = fetchFromGitHub {
    owner = "dotnet";
    repo = "runtime";
    rev = coreclr-version;
    sha256 = "sha256-gPl9sfn3eL3AUli1gdPizDK4lciTJ1ImBcics5BA63M=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_7_0;

  src = fetchFromGitHub {
    owner = "Samsung";
    repo = pname;
    rev = version;
    sha256 = hash;
  };

  unmanaged = clangStdenv.mkDerivation {
    inherit src pname version;

    # patch for arm from: https://github.com/Samsung/netcoredbg/pull/103#issuecomment-1446375535
    # needed until https://github.com/dotnet/runtime/issues/78286 is resolved
    # patch for darwin from: https://github.com/Samsung/netcoredbg/pull/103#issuecomment-1446457522
    # needed until: ?
    patches = [ ./arm64.patch ./darwin.patch ];
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
stdenv.mkDerivation rec {
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

    updateScript = [ ./update.sh pname version meta.homepage ];
  };

  meta = with lib; {
    description = "Managed code debugger with MI interface for CoreCLR";
    homepage = "https://github.com/Samsung/netcoredbg";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ leo60228 konradmalik ];
  };
}
