{ fetchgit, stdenv, autoconf, automake, libtool
, machHeaders, hurdHeaders, hurd, headersOnly ? false
, cross ? null, gccCross ? null, glibcCross ? null }:

assert (cross != null) -> (gccCross != null) && (glibcCross != null);
assert (!headersOnly) -> (hurd != null);

let
  date = "20111020";

  # Use the `tschwinge/Peter_Herbolzheimer' branch as prescribed in
  # <http://www.gnu.org/software/hurd/hurd/building/cross-compiling.html>.
  rev = "a7b82c3302bf9c47176648eb802a61ae2d9a16f5";
in
stdenv.mkDerivation ({
  name = "libpthread-hurd-${if headersOnly then "headers-" else ""}${date}";

  src = fetchgit {
    url = "git://git.sv.gnu.org/hurd/libpthread.git";
    sha256 = "e8300762914d927c0da4168341a5982a1057613e1af363ee68942087b2570b3d";
    inherit rev;
  };

  nativeBuildInputs = [ autoconf automake libtool ];
  buildInputs = [ machHeaders hurdHeaders ]
   ++ stdenv.lib.optional (!headersOnly) hurd
   ++ stdenv.lib.optional (gccCross != null) gccCross;

  preConfigure = "autoreconf -vfi";

  meta = {
    description = "GNU Hurd's libpthread";

    license = "LGPLv2+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}

//

(if headersOnly
 then {
   configureFlags =
     [ "--build=i586-pc-gnu"
       "ac_cv_lib_ihash_hurd_ihash_create=yes"
     ];

   buildPhase = ":";
   installPhase = "make install-data-local-headers";
 }
 else { })

//

(if cross != null
 then {
   crossConfig = cross.config;

   # Tell gcc where to find `crt1.o' et al.  This is specified in two
   # different ways: one for gcc as run from `configure', and one for linking
   # libpthread.so (by default `libtool --mode=link' swallows `-B', hence
   # this workaround; see
   # <http://lists.gnu.org/archive/html/bug-libtool/2010-05/msg00012.html>.)
   LDFLAGS = "-B${glibcCross}/lib";
   makeFlags = [ "LDFLAGS=-Wc,-B${glibcCross}/lib" ];

   # Help the linker find glibc.
   CPATH = "${glibcCross}/include";
   LIBRARY_PATH = "${glibcCross}/lib";

   passthru = {
     # Extra target LDFLAGS to allow the cross-linker to find the
     # dependencies of the cross libpthread.so, namely libihash.so.
     # Note: these are raw `ld' flags, so `-Wl,' must be prepended when using
     # `gcc'.
     #
     # This is actually only useful while building the final cross-gcc, since
     # afterwards gcc-cross-wrapper should add the relevant flags.
     TARGET_LDFLAGS = "-rpath-link=${hurd}/lib";
   };
 }
 else { }))
