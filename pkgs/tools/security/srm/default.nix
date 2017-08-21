{ stdenv, fetchurl }:

stdenv.mkDerivation rec {

  name = "srm-" + version;
  version = "1.2.15";

  src = fetchurl {
    url = "mirror://sourceforge/project/srm/${version}/${name}.tar.gz";
    sha256 = "10sjarhprs6s4zandndg720528rcnd4xk8dl48pjj7li1q9c30vm";
  };

  meta = with stdenv.lib; {
    description = "Delete files securely";
    longDescription = ''
      srm (secure rm) is a command-line compatible rm(1) which
      overwrites file contents before unlinking. The goal is to
      provide drop in security for users who wish to prevent recovery
      of deleted information, even if the machine is compromised.
    '';
    homepage = http://srm.sourceforge.net;
    license = licenses.mit;
    maintainers = with maintainers; [ edwtjo ];
    platforms = platforms.linux;
  };

}