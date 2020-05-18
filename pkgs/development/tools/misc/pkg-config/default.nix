{ stdenv, fetchurl, libiconv, vanilla ? false }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "pkg-config";
  version = "0.29.2";

  setupHook = ./setup-hook.sh;

  src = fetchurl {
    url = "https://pkgconfig.freedesktop.org/releases/${pname}-${version}.tar.gz";
    sha256 = "14fmwzki1rlz8bs2p810lk6jqdxsk966d8drgsjmi54cd00rrikg";
  };

  # Process Requires.private properly, see
  # http://bugs.freedesktop.org/show_bug.cgi?id=4738.
  patches = optional (!vanilla) ./requires-private.patch
    ++ optional stdenv.isCygwin ./2.36.3-not-win32.patch;

  # These three tests fail due to a (desired) behavior change from our ./requires-private.patch
  postPatch = ''
    rm -f check/check-requires-private check/check-gtk check/missing
  '';

  buildInputs = optional (stdenv.isCygwin || stdenv.isDarwin || stdenv.isSunOS) libiconv;

  configureFlags = [ "--with-internal-glib" ]
    ++ optional (stdenv.isSunOS) [ "--with-libiconv=gnu" "--with-system-library-path" "--with-system-include-path" "CFLAGS=-DENABLE_NLS" ]
       # Can't run these tests while cross-compiling
    ++ optional (stdenv.hostPlatform != stdenv.buildPlatform)
       [ "glib_cv_stack_grows=no"
         "glib_cv_uscore=no"
         "ac_cv_func_posix_getpwuid_r=yes"
         "ac_cv_func_posix_getgrgid_r=yes"
       ];

  enableParallelBuilding = true;
  doCheck = true;

  postInstall = ''rm -f "$out"/bin/*-pkg-config''; # clean the duplicate file

  meta = {
    description = "A tool that allows packages to find out information about other packages";
    homepage = "http://pkg-config.freedesktop.org/wiki/";
    platforms = platforms.all;
    license = licenses.gpl2Plus;
  };
}
