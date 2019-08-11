{ fetchurl, stdenv, libgcrypt, readline, libgpgerror }:

stdenv.mkDerivation rec {
  version = "1.6.3";
  name = "freeipmi-${version}";

  src = fetchurl {
    url = "mirror://gnu/freeipmi/${name}.tar.gz";
    sha256 = "1sg12ycig2g5yv9l3vx25wsjmz7ybnrsvji0vs51yjmclwsygm5a";
  };

  buildInputs = [ libgcrypt readline libgpgerror ];

  doCheck = true;

  meta = {
    description = "Implementation of the Intelligent Platform Management Interface";

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

    homepage = https://www.gnu.org/software/freeipmi/;
    downloadPage = "https://www.gnu.org/software/freeipmi/download.html";

    license = stdenv.lib.licenses.gpl3Plus;

    maintainers = with stdenv.lib.maintainers; [ raskin ];
    platforms = stdenv.lib.platforms.gnu ++ stdenv.lib.platforms.linux;  # arbitrary choice

    updateWalker = true;
    inherit version;
  };
}
