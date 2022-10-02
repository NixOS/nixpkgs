{ lib
, stdenv
, buildDotnetModule
, fetchFromGitHub
, autoPatchelfHook
, wrapGAppsHook
, dotnetCorePackages
, fontconfig
, gtk3
, openssl
, libX11
, libXi
, xinput
}:

buildDotnetModule rec {
  pname = "opentracker";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "trippsc2";
    repo = pname;
    rev = version;
    sha256 = "0nsmyb1wd86465iri9jxl3jp74gxkscvnmr3687ddbia3dv4fz0z";
  };

  dotnet-runtime = dotnetCorePackages.runtime_3_1;
  dotnet-sdk = dotnetCorePackages.sdk_3_1;

  nugetDeps = ./deps.nix;

  projectFile = "OpenTracker.sln";
  executables = [ "OpenTracker" ];

  doCheck = true;

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    fontconfig
    gtk3
  ];

  runtimeDeps = [
    gtk3
    openssl
    libX11
    libXi
    xinput
  ];

  autoPatchelfIgnoreMissingDeps = [ "libc.musl-x86_64.so.1" ]; # Attempts to patchelf unneeded SOs

  meta = with lib; {
    description = "A tracking application for A Link to the Past Randomizer";
    homepage = "https://github.com/trippsc2/OpenTracker";
    sourceProvenance = with sourceTypes; [
      fromSource
      # deps
      binaryBytecode
      binaryNativeCode
    ];
    license = licenses.mit;
    maintainers = [ maintainers.ivar ];
    mainProgram = "OpenTracker";
    platforms = [ "x86_64-linux" ];
  };
}
