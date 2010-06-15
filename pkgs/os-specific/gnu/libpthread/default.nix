{ fetchgit, stdenv, autoconf, automake, libtool
, machHeaders, hurdHeaders, hurd
, cross ? null, gccCross ? null, glibcCross ? null }:

assert (cross != null) -> (gccCross != null) && (glibcCross != null);

let
  date = "20100512";

  # Use the `tschwinge/Peter_Herbolzheimer' branch as prescribed in
  # <http://www.gnu.org/software/hurd/hurd/building/cross-compiling.html>.
  rev = "c4bb52770f0b6703bef76c5abdd08663b46b4dc9";
in
stdenv.mkDerivation ({
  name = "libpthread-hurd-${date}";

  src = fetchgit {
    url = "git://git.sv.gnu.org/hurd/libpthread.git";
    sha256 = "1wya9kfmqgn04l995a25p4hxfwddjahfmhdzljb4cribw0bqdizg";
    inherit rev;
  };

  buildNativeInputs = [ autoconf automake libtool ];
  buildInputs = [ machHeaders hurdHeaders hurd ]
   ++ stdenv.lib.optional (gccCross != null) gccCross;

  preConfigure = "autoreconf -vfi";

  meta = {
    description = "GNU Hurd's libpthread";

    license = "LGPLv2+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}

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
     #
     # This is actually only useful while building the final cross-gcc, since
     # afterwards gcc-cross-wrapper should add the relevant flags.
     TARGET_LDFLAGS = "-Wl,-rpath-link=${hurd}/lib";
   };
 }
 else { }))
