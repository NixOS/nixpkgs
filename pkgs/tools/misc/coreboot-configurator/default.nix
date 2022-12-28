{ lib
, stdenv
, fetchFromGitHub
, inkscape
, meson
, ninja
, pkg-config
, libyamlcpp
, nvramtool
, qtbase
, qtsvg
, wrapQtAppsHook
}:

stdenv.mkDerivation {
  pname = "coreboot-configurator";
  version = "unstable-2022-08-22";

  src = fetchFromGitHub {
    owner = "StarLabsLtd";
    repo = "coreboot-configurator";
    rev = "37c93e7e101a20f85be309904177b9404875cfd8";
    sha256 = "2pk+uJk1EnVNO2vO1zF9Q6TLpij69iRdr5DFiNcZlM0=";
  };

  nativeBuildInputs = [ inkscape meson ninja pkg-config wrapQtAppsHook ];
  buildInputs = [ libyamlcpp qtbase qtsvg ];

  postPatch = ''
    substituteInPlace src/application/*.cpp \
      --replace '/usr/bin/pkexec' 'sudo' \
      --replace '/usr/bin/systemctl' 'systemctl' \
      --replace '/usr/sbin/nvramtool' '${nvramtool}/bin/nvramtool'
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
