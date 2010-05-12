{ fetchgit, stdenv, mig ? null, autoconf, automake, texinfo
, headersOnly ? true }:

assert (!headersOnly) -> (mig != null);

let rev = "7987a711e8f13c0543e87a0211981f4b40ef6d94";
in
stdenv.mkDerivation (rec {
  name = "gnumach-1.4-${rev}";

  src = fetchgit {
    url = "git://git.sv.gnu.org/hurd/gnumach.git";
    sha256 = "7b383a23b7fbe1ec812951cc0f553c85da3279f4f723dd6a65e45976f9d5ca2d";
    inherit rev;
  };

  configureFlags = "--build=i586-pc-gnu";

  buildInputs = [ autoconf automake texinfo ]
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
  };
}

//

(if headersOnly
 then { buildPhase = ":"; installPhase = "make install-data"; }
 else {}))
