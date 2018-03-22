{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "snapraid-${version}";
  version = "11.2";

  src = fetchFromGitHub {
    owner = "amadvance";
    repo = "snapraid";
    rev = "v${version}";
    sha256 = "01z8fl3x2j5bnm0rybj7hhch18is6dkwqc43yzwc6418spr4imsd";
  };

  VERSION = version;

  doCheck = true;

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ ];

  meta = {
    homepage = http://www.snapraid.it/;
    description = "A backup program for disk arrays";
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.makefu ];
    platforms = stdenv.lib.platforms.unix;
  };
}
