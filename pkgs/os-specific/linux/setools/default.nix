{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, bison, flex
, python, swig2, tcl, libsepol, libselinux, libxml2, sqlite, bzip2 }:

stdenv.mkDerivation rec {
  name = "setools-2015-02-12";

  src = fetchFromGitHub {
    owner = "TresysTechnology";
    repo = "setools3";
    rev = "f1e5b208d507171968ca4d2eeefd7980f1004a3c";
    sha256 = "02gzy2kpszhr13f0d9qfiwh2hj4201g2x366j53v5n5qz481aykd";
  };

  configureFlags = [
    "--disable-gui"
    "--with-sepol-devel=${libsepol}"
    "--with-selinux-devel=${libselinux}"
    "--with-tcl=${tcl}/lib"
  ];

  hardeningDisable = [ "format" ];

  NIX_CFLAGS_COMPILE = "-fstack-protector-all";
  NIX_LDFLAGS = "-L${libsepol}/lib -L${libselinux}/lib";

  nativeBuildInputs = [ autoreconfHook pkgconfig python swig2 bison flex ];
  buildInputs = [ tcl libxml2 sqlite bzip2 ];

  meta = {
    description = "SELinux Tools";
    homepage = "http://oss.tresys.com/projects/setools/";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
