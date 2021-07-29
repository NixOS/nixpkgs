{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "pwgen";
  version = "2.08";

  src = fetchFromGitHub {
    owner = "tytso";
    repo = "pwgen";
    rev = "v${version}";
    sha256 = "8d6e94f58655e61d6126290e3eafad4d17d7fba0d0d354239522a740a270bb2f";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    description = "Password generator which creates passwords which can be easily memorized by a human";
    maintainers = with maintainers; [ ];
    license = with licenses; [ gpl2Only ];
    platforms = platforms.all;
  };
}
