{ fetchurl, lib, stdenv, libgcrypt, readline, libgpgerror }:

stdenv.mkDerivation rec {
  version = "1.6.7";
  pname = "freeipmi";

  src = fetchurl {
    url = "mirror://gnu/freeipmi/${pname}-${version}.tar.gz";
    sha256 = "1gyyx99q02p3v2nqm3h53mkjd33l0hrapwg4alg6qr9k74qik1dv";
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

    homepage = "https://www.gnu.org/software/freeipmi/";
    downloadPage = "https://www.gnu.org/software/freeipmi/download.html";

    license = lib.licenses.gpl3Plus;

    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.gnu ++ lib.platforms.linux;  # arbitrary choice

    updateWalker = true;
    inherit version;
  };
}
