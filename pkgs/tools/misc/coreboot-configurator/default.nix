{
  lib,
  stdenv,
  fetchFromGitHub,
  inkscape,
  meson,
  ninja,
  # We will resolve pkexec from the path because it has a setuid wrapper on
  # NixOS meaning that we cannot just use the path from the nix store.
  # Using the path to the wrapper here would make the package incompatible
  # with non-NixOS systems.
  pkexecPath ? "pkexec",
  pkg-config,
  yaml-cpp,
  nvramtool,
  systemd,
  qtbase,
  qtsvg,
  wrapQtAppsHook,
}:

stdenv.mkDerivation {
  pname = "coreboot-configurator";
  version = "unstable-2023-01-17";

  src = fetchFromGitHub {
    owner = "StarLabsLtd";
    repo = "coreboot-configurator";
    rev = "944b575dc873c78627c352f9c1a1493981431a58";
    sha256 = "sha256-ReWQNzeoyTF66hVnevf6Kkrnt0/PqRHd3oyyPYtx+0M=";
  };

  nativeBuildInputs = [
    inkscape
    meson
    ninja
    pkg-config
    wrapQtAppsHook
  ];
  buildInputs = [
    yaml-cpp
    qtbase
    qtsvg
  ];

  postPatch = ''
    substituteInPlace src/application/*.cpp \
      --replace '/usr/bin/pkexec' '${pkexecPath}' \
      --replace '/usr/bin/systemctl' '${lib.getBin systemd}/systemctl' \
      --replace '/usr/sbin/nvramtool' '${lib.getExe nvramtool}'

    substituteInPlace src/resources/org.coreboot.nvramtool.policy \
      --replace '/usr/sbin/nvramtool' '${lib.getExe nvramtool}'

    substituteInPlace src/resources/org.coreboot.reboot.policy \
      --replace '/usr/sbin/reboot' '${lib.getBin systemd}/reboot'
  '';

  postFixup = ''
    substituteInPlace $out/share/applications/coreboot-configurator.desktop \
      --replace '/usr/bin/coreboot-configurator' 'coreboot-configurator'
  '';

  meta = {
    description = "Simple GUI to change settings in Coreboot's CBFS";
    homepage = "https://support.starlabs.systems/kb/guides/coreboot-configurator";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ danth ];
    mainProgram = "coreboot-configurator";
  };
}
