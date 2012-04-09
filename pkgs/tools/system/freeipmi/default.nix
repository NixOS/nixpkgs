{ fetchurl, stdenv, libgcrypt, readline }:

stdenv.mkDerivation rec {
  name = "freeipmi-1.1.3";

  src = fetchurl {
    url = "mirror://gnu/freeipmi/${name}.tar.gz";
    sha256 = "11kawxzk8cp9g3q5hdm1sqgzanprc2gagjdnm33lyz5df8xjfkmk";
  };

  buildInputs = [ libgcrypt readline ];

  doCheck = true;

  meta = {
    description = "GNU FreeIPMI, an implementation of the Intelligent Platform Management Interface";

    longDescription =
      '' GNU FreeIPMI provides in-band and out-of-band IPMI software based on
         the IPMI v1.5/2.0 specification.  The IPMI specification defines a
         set of interfaces for platform management and is implemented by a
         number vendors for system management.  The features of IPMI that
         most users will be interested in are sensor monitoring, system event
         monitoring, power control, and serial-over-LAN (SOL).  The FreeIPMI
         tools and libraries listed below should provide users with the
         ability to access and utilize these and many other features.  A
         number of useful features for large HPC or cluster environments have
         also been implemented into FreeIPMI. See the README or FAQ for more
         info.
      '';

    homepage = http://www.gnu.org/software/freeipmi/;

    license = "GPLv3+";

    maintainers = with stdenv.lib.maintainers; [ raskin ludo ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
