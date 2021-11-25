{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "snapraid";
  version = "11.6";

  src = fetchFromGitHub {
    owner = "amadvance";
    repo = "snapraid";
    rev = "v${version}";
    sha256 = "sha256-nO0Ujo9je59C+zP7l9Pp7JEdsSfVAv+9EnAq4OtJ78o=";
  };

  VERSION = version;

  doCheck = true;

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ ];

  meta = {
    homepage = "http://www.snapraid.it/";
    description = "A backup program for disk arrays";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.makefu ];
    platforms = lib.platforms.unix;
  };
}
