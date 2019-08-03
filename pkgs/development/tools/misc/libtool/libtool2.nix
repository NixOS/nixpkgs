{ stdenv, fetchurl, m4, perl, help2man
}:

stdenv.mkDerivation rec {
  name = "libtool-2.4.6";

  src = fetchurl {
    url = "mirror://gnu/libtool/${name}.tar.gz";
    sha256 = "1qq61k6lp1fp75xs398yzi6wvbx232l7xbyn3p13cnh27mflvgg3";
  };

  outputs = [ "out" "lib" ];

  nativeBuildInputs = [ perl help2man m4 ];
  propagatedBuildInputs = [ m4 ];

  # Don't fixup "#! /bin/sh" in Libtool, otherwise it will use the
  # "fixed" path in generated files!
  dontPatchShebangs = true;

  # XXX: The GNU ld wrapper does all sorts of nasty things wrt. RPATH, which
  # leads to the failure of a number of tests.
  doCheck = false;
  doInstallCheck = false;

  # Don't run the native `strip' when cross-compiling.  This breaks at least
  # with `.a' files for MinGW.
  dontStrip = stdenv.hostPlatform != stdenv.buildPlatform;

  meta = {
    description = "GNU Libtool, a generic library support script";

    longDescription = ''
      GNU libtool is a generic library support script.  Libtool hides
      the complexity of using shared libraries behind a consistent,
      portable interface.

      To use libtool, add the new generic library building commands to
      your Makefile, Makefile.in, or Makefile.am.  See the
      documentation for details.
    '';

    homepage = https://www.gnu.org/software/libtool/;

    license = stdenv.lib.licenses.gpl2Plus;

    maintainers = [ ];
    platforms = stdenv.lib.platforms.unix;
  };
}
