{ lib
, stdenv
, dotnet_6
, dotnet_7
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

  dotnetPackages =
    if lib.versionAtLeast (lib.versions.majorMinor version) "1.7"
    then dotnet_7
    else dotnet_6;

in
dotnetPackages.buildDotnetModule rec {
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
