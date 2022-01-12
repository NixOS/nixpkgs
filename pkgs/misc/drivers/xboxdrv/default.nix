{ lib
, stdenv
, fetchFromGitHub
, sconsPackages
, libX11
, pkg-config
, libusb1
, boost
, glib
, dbus-glib
}:

stdenv.mkDerivation rec {
  pname = "xboxdrv";
  version = "0.8.8";

  src = fetchFromGitHub {
    owner = "xboxdrv";
    repo = "xboxdrv";
    rev = "v${version}";
    hash = "sha256-R0Bt4xfzQA1EmZbf7lcWLwSSUayf5Y711QhlAVhiLrY=";
  };

  makeFlags = [ "PREFIX=$(out)" ];
  nativeBuildInputs = [ pkg-config sconsPackages.scons_3_1_2 ];
  buildInputs = [ libX11 libusb1 boost glib dbus-glib ];
  dontUseSconsInstall = true;

  meta = with lib; {
    homepage = "https://xboxdrv.gitlab.io/";
    description = "Xbox/Xbox360 (and more) gamepad driver for Linux that works in userspace";
    license = licenses.gpl3Plus;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
