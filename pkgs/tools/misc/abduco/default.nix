{ stdenv, fetchFromGitHub, writeText, conf ? null }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "abduco-2018-05-16";

  src = fetchFromGitHub {
    owner = "martanne";
    repo = "abduco";
    rev = "8f80aa8044d7ecf0e43a0294a09007d056b20e4c";
    sha256 = "0wqcif633nbgnznn46j0sng9l0wncppw1x1c42f75b4p9hrph203";
  };

  configFile = optionalString (conf!=null) (writeText "config.def.h" conf);
  preBuild = optionalString (conf!=null) "cp ${configFile} config.def.h";

  CFLAGS = stdenv.lib.optionalString stdenv.isDarwin "-D_DARWIN_C_SOURCE";

  meta = {
    homepage = http://brain-dump.org/projects/abduco;
    license = licenses.isc;
    description = "Allows programs to be run independently from its controlling terminal";
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.unix;
  };
}
