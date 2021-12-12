{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "snapraid";
  version = "12.0";

  src = fetchFromGitHub {
    owner = "amadvance";
    repo = "snapraid";
    rev = "v${version}";
    sha256 = "sha256-CcJaxnbRvGYiQjU38qnTgNyim5aDQWmxhQv16ZT1F00=";
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
