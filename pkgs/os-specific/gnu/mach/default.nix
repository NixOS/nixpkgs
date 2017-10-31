{ fetchgit, stdenv, mig ? null, autoconf, automake, texinfo
, headersOnly ? false }:

assert (!headersOnly) -> (mig != null);

let
  date = "20120303";
  rev = "2a603e88f86bee88e013c2451eacf076fbcaed81";
in
stdenv.mkDerivation ({
  name = "gnumach${if headersOnly then "-headers" else ""}-${date}";

  src = fetchgit {
    url = "git://git.sv.gnu.org/hurd/gnumach.git";
    sha256 = "1q8zk8xzbiwpnvvmfgkylj4gwkvkn5n2ydy9j054qv5plnaczj1c";
    inherit rev;
  };

  configureFlags =
       stdenv.lib.optional headersOnly "--build=i586-pc-gnu"  # cheat

    # Always enable dependency tracking.  See
    # <http://lists.gnu.org/archive/html/bug-hurd/2010-05/msg00137.html>.
    ++ [ "--enable-dependency-tracking" ];

  nativeBuildInputs = [ autoconf automake texinfo ]
    ++ stdenv.lib.optional (mig != null) mig;

  preConfigure = "autoreconf -vfi";

  meta = {
    description = "GNU Mach, the microkernel used by the GNU Hurd";

    longDescription =
      '' GNU Mach is the microkernel that the GNU Hurd system is based on.

         It is maintained by the Hurd developers for the GNU project and
         remains compatible with Mach 3.0.

         The majority of GNU Mach's device drivers are from Linux 2.0.  They
         were added using glue code, i.e., a Linux emulation layer in Mach.
      '';

    license = stdenv.lib.licenses.gpl2Plus;

    homepage = http://www.gnu.org/software/hurd/microkernel/mach/gnumach.html;

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = [ "i586-gnu" ];
  };
}

//

(if headersOnly
 then { dontBuild = true; installPhase = "make install-data"; }
 else {}))
