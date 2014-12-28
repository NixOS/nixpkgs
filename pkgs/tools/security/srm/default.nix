{ stdenv, fetchurl }:

stdenv.mkDerivation rec {

  name = "srm-" + version;
  version = "1.2.14";

  src = fetchurl {
    url = "mirror://sourceforge/project/srm/1.2.14/srm-1.2.14.tar.gz";
    sha256 = "1irwwpb7yhmii2v4vz1fjkmmhw7w7qd1ak9arn9zfg3mgcnwl32q";
  };

  meta = with stdenv.lib; {
    description = "Delete files securely";
    longDescription = ''
      srm (secure rm) is a command-line compatible rm(1) which
      overwrites file contents before unlinking. The goal is to
      provide drop in security for users who wish to prevent recovery
      of deleted information, even if the machine is compromised.
    '';
    homepage = "http://srm.sourceforge.net";
    license = licenses.mit;
    maintainers = with maintainers; [ edwtjo ];
    platforms = platforms.linux;
  };

}