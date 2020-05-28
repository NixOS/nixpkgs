{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "snapraid";
  version = "11.5";

  src = fetchFromGitHub {
    owner = "amadvance";
    repo = "snapraid";
    rev = "v${version}";
    sha256 = "0dlhdsmq5l208zldfr9z9g0p67wry81dr0r23lpybb5c9fm2f2rm";
  };

  VERSION = version;

  doCheck = true;

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ ];

  meta = {
    homepage = "http://www.snapraid.it/";
    description = "A backup program for disk arrays";
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.makefu ];
    platforms = stdenv.lib.platforms.unix;
  };
}
