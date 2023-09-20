{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "srm";
  version = "1.2.15";

  src = fetchurl {
    url = "mirror://sourceforge/project/srm/${version}/srm-${version}.tar.gz";
    sha256 = "10sjarhprs6s4zandndg720528rcnd4xk8dl48pjj7li1q9c30vm";
  };

  meta = with lib; {
    description = "Delete files securely";
    longDescription = ''
      srm (secure rm) is a command-line compatible rm(1) which
      overwrites file contents before unlinking. The goal is to
      provide drop in security for users who wish to prevent recovery
      of deleted information, even if the machine is compromised.
    '';
    homepage = "https://srm.sourceforge.net";
    license = licenses.mit;
    maintainers = with maintainers; [ edwtjo ];
    platforms = platforms.unix;
  };

}
