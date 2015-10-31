{stdenv, fetchurl, which, automake, autoconf, pkgconfig, curl, libtool, vala, python, intltool, fuse, ccnet}:

stdenv.mkDerivation rec
{
  version = "4.4.2";
  name = "seafile-shared-${version}";

  src = fetchurl
  {
    url = "https://github.com/haiwen/seafile/archive/v${version}.tar.gz";
    sha256 = "00sflvyap3nw38qblpagp2japgp83sqc5s4r336mi6475grgmnyi";
  };

  buildInputs = [ which automake autoconf pkgconfig libtool vala python intltool fuse ];
  propagatedBuildInputs = [ ccnet curl ];

  preConfigure = ''
  sed -ie 's|/bin/bash|/bin/sh|g' ./autogen.sh
  ./autogen.sh
  '';

  configureFlags = "--disable-server --disable-console";

  buildPhase = "make -j1";

  postInstall = ''
  # Remove seafile binary
  rm -rf "$out/bin/seafile"
  # Remove cli client binary
  rm -rf "$out/bin/seaf-cli"
  '';

  meta =
  {
    homepage = "https://github.com/haiwen/seafile";
    description = "Shared components of Seafile: seafile-daemon, libseafile, libseafile python bindings, manuals, and icons";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.calrama ];
  };
}
