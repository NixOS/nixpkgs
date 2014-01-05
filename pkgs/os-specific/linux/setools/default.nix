{ stdenv, fetchurl, autoreconfHook, pkgconfig, bison, flex
, python, swig2, tcl, libsepol, libselinux, libxml2, sqlite, bzip2 }:

stdenv.mkDerivation rec {
  name = "setools-3.3.8";

  src = fetchurl {
    url = "http://oss.tresys.com/projects/setools/chrome/site/dists/${name}/${name}.tar.bz2";
    sha256 = "16g987ijaxabc30zyjzia4nafq49rm038y1pm4vca7i3kb67wf24";
  };

  # SWIG-TCL is broken in 3.3.8
  configureFlags = ''
    --with-tcl=${tcl}/lib
    --with-sepol-devel=${libsepol}
    --with-selinux-devel=${libselinux}
    --disable-gui
    --disable-swig-tcl
  '';

  buildInputs = [ autoreconfHook pkgconfig bison flex python swig2 ];

  nativeBuildInputs = [ tcl libsepol libselinux libxml2 sqlite bzip2 ];

  meta = {
    description = "SELinux Tools";
    homepage = "http://oss.tresys.com/projects/setools/";
    license = "GPLv2";
    platforms = stdenv.lib.platforms.linux;
  };
}
