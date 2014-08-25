{ stdenv, udev, ncurses, pkgconfig, fetchurl, bluez }:

stdenv.mkDerivation rec {
  name = "xwiimote";
  src = fetchurl {
    url = "https://github.com/dvdhrm/xwiimote/releases/download/xwiimote-2/xwiimote-2.tar.xz";
    sha256 = "1g9cbhblll47l300zr999xr51x2g98y49l222f77fhswd12kjzhd";
  };

  buildInputs = [ udev ncurses pkgconfig bluez ];

  configureFlags = "--with-doxygen=no";

  meta = {
    homepage = http://dvdhrm.github.io/xwiimote;
    description = "Userspace utilities to control connected Nintendo Wii Remotes";
    platforms = stdenv.lib.platforms.linux;
  };

  postInstallPhase = ''
    mkdir -p "$out/etc/X11/xorg.conf.d/"
    cp "res/50-xorg-fix-xwiimote.conf" "$out/etc/X11/xorg.conf.d/50-fix-xwiimote.conf"
  '';
}
