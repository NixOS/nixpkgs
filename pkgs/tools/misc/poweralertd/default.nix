{ lib, stdenv, fetchFromSourcehut, meson, ninja, pkg-config, scdoc, systemd }:

stdenv.mkDerivation rec {
  pname = "poweralertd";
  version = "0.2.0";

  outputs = [ "out" "man" ];

  src = fetchFromSourcehut {
    owner = "~kennylevinsen";
    repo = "poweralertd";
    rev = version;
    sha256 = "19rw9q4pcqw56nmzjfglfikzx5wwjl4n08awwdhg0jy1k0bm3dvp";
  };

  postPatch = ''
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
    mainProgram = "poweralertd";
  };
}
