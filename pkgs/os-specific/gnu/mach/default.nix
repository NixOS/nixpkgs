{ fetchgit, stdenv, mig ? null, autoconf, automake, texinfo
, headersOnly ? false }:

assert (!headersOnly) -> (mig != null);

let
  date = "2010-05-12";
  rev = "master@{${date}}";
in
stdenv.mkDerivation ({
  name = "gnumach${if headersOnly then "-headers" else ""}-${date}";

  src = fetchgit {
    url = "git://git.sv.gnu.org/hurd/gnumach.git";
    sha256 = "7b383a23b7fbe1ec812951cc0f553c85da3279f4f723dd6a65e45976f9d5ca2d";
    inherit rev;
  };

  configureFlags =
       stdenv.lib.optional headersOnly "--build=i586-pc-gnu"  # cheat

    # Always enable dependency tracking.  See
    # <http://lists.gnu.org/archive/html/bug-hurd/2010-05/msg00137.html>.
    ++ [ "--enable-dependency-tracking" ];

  buildNativeInputs = [ autoconf automake texinfo ]
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

    license = "GPLv2+";

    homepage = http://www.gnu.org/software/hurd/microkernel/mach/gnumach.html;

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = [ "i586-gnu" ];
  };
}

//

(if headersOnly
 then { buildPhase = ":"; installPhase = "make install-data"; }
 else {}))
