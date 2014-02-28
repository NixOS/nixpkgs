{stdenv, fetchurl, which, automake, autoconf, pkgconfig, libtool, vala, python, intltool, fuse, ccnet}:

stdenv.mkDerivation rec
{
  version = "2.1.1";
  name = "seafile-shared-${version}";

  src = fetchurl
  {
    url = "https://github.com/haiwen/seafile/archive/v${version}.tar.gz";
    sha256 = "f07b09ab1eb1cb33f92cee74e499d0350941624396910a4c1a7d79abb45acaa6";
  };

  patches = [ ./0003-Add-autoconfiguration-for-libjansson.patch ];

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
