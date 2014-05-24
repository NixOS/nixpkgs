{stdenv, fetchurl, which, automake, autoconf, pkgconfig, libtool, vala, python, intltool, fuse, ccnet}:

stdenv.mkDerivation rec
{
  version = "3.0.4";
  name = "seafile-shared-${version}";

  src = fetchurl
  {
    url = "https://github.com/haiwen/seafile/archive/v${version}.tar.gz";
    sha256 = "0a0yj9k2rr3q42swwzn1js3r8bld9wcysw6p9415rw5jabcm1af0";
  };

  buildInputs = [ which automake autoconf pkgconfig libtool vala python intltool fuse ];
  propagatedBuildInputs = [ ccnet ];

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
