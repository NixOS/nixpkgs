{stdenv, fetchurl, e2fsprogs, ncurses, readline, parted, libXext, libX11, zlib, qt3}:

stdenv.mkDerivation {
  name = "qtparted-0.4.4";
  src = fetchurl {
    url = http://surfnet.dl.sourceforge.net/sourceforge/qtparted/qtparted-0.4.4.tar.bz2;
    md5 = "b8253bf21eaebe1f2c22b50462e8046c";
  };
  buildInputs = [e2fsprogs ncurses readline parted libXext libX11 zlib qt3];
  configureFlags = "--disable-reiserfs --disable-jfs --disable-xfs --disable-ntfs";
}
