{ stdenv, fetchurl, scons, libX11, pkgconfig
, libusb1, boost, glib, dbus_glib }:

let
  version = "0.8.5";
in stdenv.mkDerivation {
  name = "xboxdrv-${version}";

  src = fetchurl {
    url = "https://github.com/Grumbel/xboxdrv/archive/v${version}.tar.gz";
    sha256 = "0xg2dhfsk3i693rgwr1pr532b3hk3zmjxlx55g6bplslr94bibi2";
  };

  patchPhase = ''
    substituteInPlace Makefile --replace /usr/local "$out"
  '';

  buildInputs = [ scons libX11 pkgconfig libusb1 boost glib dbus_glib];

  meta = with stdenv.lib; {
    homepage = "http://pingus.seul.org/~grumbel/xboxdrv/";
    description =
      "Xbox/Xbox360 (and more) gamepad driver for Linux that works in userspace.";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.fuuzetsu ];
  };

}
