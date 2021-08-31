{ lib, stdenv, fetchurl, sconsPackages, libX11, pkg-config
, libusb1, boost, glib, dbus-glib }:

let
  version = "0.8.8";
in stdenv.mkDerivation {
  pname = "xboxdrv";
  inherit version;

  src = fetchurl {
    url = "https://github.com/xboxdrv/xboxdrv/archive/v${version}.tar.gz";
    sha256 = "0jx2wqmc7602dxyj19n3h8x0cpy929h7c0h39vcc5rf0q74fh3id";
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
