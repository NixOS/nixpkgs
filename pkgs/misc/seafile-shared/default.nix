{stdenv, fetchurl, which, automake, autoconf, pkgconfig, curl, libtool, vala_0_23, python, intltool, fuse, ccnet}:

stdenv.mkDerivation rec
{
  version = "6.1.0";
  name = "seafile-shared-${version}";

  src = fetchurl
  {
    url = "https://github.com/haiwen/seafile/archive/v${version}.tar.gz";
    sha256 = "03zvxk25311xgn383k54qvvpr8xbnl1vxd99fg4ca9yg5rmir1q6";
  };

  buildInputs = [ which automake autoconf pkgconfig libtool vala_0_23 python intltool fuse ];
  propagatedBuildInputs = [ ccnet curl ];

  preConfigure = ''
  sed -ie 's|/bin/bash|${stdenv.shell}|g' ./autogen.sh
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
    homepage = https://github.com/haiwen/seafile;
    description = "Shared components of Seafile: seafile-daemon, libseafile, libseafile python bindings, manuals, and icons";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.calrama ];
  };
}
