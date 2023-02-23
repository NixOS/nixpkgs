{ lib
, stdenv
, fetchFromGitHub
, inkscape
, meson
, mkDerivation
, ninja
, pkg-config
, pkexecPath ? "/run/wrappers/bin/pkexec"
, yaml-cpp
, nvramtool
, systemd
, qtbase
, qtsvg
, wrapQtAppsHook
}:

mkDerivation {
  pname = "coreboot-configurator";
  version = "unstable-2023-01-17";

  src = fetchFromGitHub {
    owner = "StarLabsLtd";
    repo = "coreboot-configurator";
    rev = "944b575dc873c78627c352f9c1a1493981431a58";
    sha256 = "sha256-ReWQNzeoyTF66hVnevf6Kkrnt0/PqRHd3oyyPYtx+0M=";
  };

  nativeBuildInputs = [ inkscape meson ninja pkg-config wrapQtAppsHook ];
  buildInputs = [ yaml-cpp qtbase qtsvg ];

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

  meta = with lib; {
    description = "A simple GUI to change settings in Coreboot's CBFS";
    homepage = "https://support.starlabs.systems/kb/guides/coreboot-configurator";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ danth ];
  };
}
