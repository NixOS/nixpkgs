{ lib, stdenv, fetchFromSourcehut, meson, ninja, pkg-config, scdoc, systemd }:

stdenv.mkDerivation rec {
  pname = "poweralertd";
  version = "0.1.0";

  outputs = [ "out" "man" ];

  src = fetchFromSourcehut {
    owner = "~kennylevinsen";
    repo = "poweralertd";
    rev = version;
    sha256 = "136xcrp7prilh905a6v933vryqy20l7nw24ahc4ycax8f0s906x9";
  };

  patchPhase = ''
    substituteInPlace meson.build --replace "systemd.get_pkgconfig_variable('systemduserunitdir')" "'${placeholder "out"}/lib/systemd/user'"
  '';

  buildInputs = [
    systemd
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  depsBuildBuild = [
    scdoc
    pkg-config
  ];

  meta = with lib; {
    description = "UPower-powered power alerter";
    homepage = "https://git.sr.ht/~kennylevinsen/poweralertd";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ thibautmarty ];
  };
}
