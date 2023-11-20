{ lib
, stdenv
, dotnetCorePackages
, dotnet-runtime_6
, dotnet-runtime_7
, buildDotnetModule
, fetchFromGitHub
, autoPatchelfHook
, fontconfig
, xorg
, libglvnd
, makeDesktopItem
, copyDesktopItems
}:

# NOTES:
# 1. we need autoPatchelfHook for quite a number of things in $out/lib

let
  version = "1.7.0.211";

  sdk =
    if lib.versionAtLeast (lib.versions.majorMinor version) "1.7"
    then dotnetCorePackages.sdk_7_0
    else dotnetCorePackages.sdk_6_0;

  runtime =
    if lib.versionAtLeast (lib.versions.majorMinor version) "1.7"
    then dotnet-runtime_7
    else dotnet-runtime_6;

in
buildDotnetModule rec {
  pname = "mqttmultimeter";
  inherit version;

  src = fetchFromGitHub {
    owner = "chkr1011";
    repo = "mqttMultimeter";
    rev = "v" + version;
    hash = "sha256-/XQ5HD0dBfFn3ERlLwHknS9Fyd3YMpKHBXuvMwRXcQ8=";
  };

  sourceRoot = "${src.name}/Source";

  projectFile = [ "mqttMultimeter.sln" ];
  nugetDeps = ./deps.nix;
  dotnet-sdk = sdk;
  dotnet-runtime = runtime;
  executables = [ "mqttMultimeter" ];

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
  ];

  buildInputs = [ stdenv.cc.cc.lib fontconfig ];

  # don't care about musl and windows versions, as they fail autoPatchelfHook
  postInstall = ''
    rm -rf $out/lib/${lib.toLower pname}/runtimes/{*musl*,win*}
  '';

  runtimeDeps = [
    libglvnd
    xorg.libSM
    xorg.libICE
    xorg.libX11
  ];

  desktopItems = makeDesktopItem {
    name = meta.mainProgram;
    exec = meta.mainProgram;
    icon = meta.mainProgram;
    desktopName = meta.mainProgram;
    genericName = meta.description;
    comment = meta.description;
    type = "Application";
    categories = [ "Network" ];
    startupNotify = true;
  };

  meta = with lib; {
    mainProgram = builtins.head executables;
    description = "MQTT traffic monitor";
    license = licenses.free;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.linux;
  };
}
