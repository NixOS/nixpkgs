{
  lib,
  stdenv,
  dotnetCorePackages,
  dotnet-runtime_8,
  buildDotnetModule,
  fetchFromGitHub,
  fontconfig,
  xorg,
  libglvnd,
  makeDesktopItem,
  copyDesktopItems,
}:

buildDotnetModule rec {
  pname = "mqttmultimeter";
  version = "1.8.2.272";

  src = fetchFromGitHub {
    owner = "chkr1011";
    repo = "mqttMultimeter";
    rev = "v" + version;
    hash = "sha256-vL9lmIhNLwuk1tmXLKV75xAhktpdNOb0Q4ZdvLur5hw=";
  };

  sourceRoot = "${src.name}/Source";

  projectFile = [ "mqttMultimeter.sln" ];
  nugetDeps = ./deps.nix;
  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnet-runtime_8;
  executables = [ "mqttMultimeter" ];

  nativeBuildInputs = [
    copyDesktopItems
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    fontconfig
  ];

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
