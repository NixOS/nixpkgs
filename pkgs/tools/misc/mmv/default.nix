{ lib, stdenv, fetchFromGitHub, pkg-config, gengetopt, m4, gnupg
, git, perl, autoconf, automake, help2man, boehmgc }:

stdenv.mkDerivation rec {
  pname = "mmv";
<<<<<<< HEAD
  version = "2.5.1";
=======
  version = "2.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "rrthomas";
    repo = "mmv";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-01MJjYVPfDaRkzitqKXTJZHbkkZTEaFoyYZEEMizHp0=";
=======
    sha256 = "sha256-lujar6QGlhNawGOIfM5RAUa4Sbs0BFgG8rEsCDLqDDE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    fetchSubmodules = true;
  };

  preConfigure = ''
    ./bootstrap
  '';

  nativeBuildInputs = [ gengetopt m4 git gnupg perl autoconf automake help2man pkg-config ];
  buildInputs = [ boehmgc ];

  meta = {
    homepage = "https://github.com/rrthomas/mmv";
    description = "Utility for wildcard renaming, copying, etc";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ siraben ];
  };
}
