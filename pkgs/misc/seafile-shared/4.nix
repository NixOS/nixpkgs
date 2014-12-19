{ stdenv, fetchurl, which, automake, autoconf, pkgconfig, libtool, vala, python
, intltool, fuse, ccnet4, curl }:

stdenv.mkDerivation rec
{
  version = "4.0.4";
  name = "seafile-shared-${version}";

  src = fetchurl
  {
    url = "https://github.com/haiwen/seafile/archive/v${version}.tar.gz";
    sha256 = "1sx120n9is6w5i8lzvzi5w1855rnp252rr9m4r8rfvbslb2rpchh";
  };

  buildInputs = [ which automake autoconf pkgconfig libtool vala python intltool
    fuse curl ];
  propagatedBuildInputs = [ ccnet4 ];

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
    maintainers = [ stdenv.lib.maintainers.matejc ];
  };
}
