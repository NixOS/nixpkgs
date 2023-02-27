{ lib, stdenv, fetchFromGitHub, autoreconfHook, perl, readline }:

stdenv.mkDerivation rec {
  pname = "rlwrap";
  version = "0.46";

  src = fetchFromGitHub {
    owner = "hanslub42";
    repo = "rlwrap";
    rev = "v${version}";
    sha256 = "sha256-NlpVg1AimJn3VAbUl2GK1kaLkqU1Djw7/2Uc21AY0Jo=";
  };

  postPatch = ''
    substituteInPlace src/readline.c \
      --replace "if(*p >= 0 && *p < ' ')" "if(*p >= 0 && (*p >= 0) && (*p < ' '))"
  '';

  nativeBuildInputs = [ autoreconfHook perl ];

  buildInputs = [ readline ];

  meta = with lib; {
    description = "Readline wrapper for console programs";
    homepage = "https://github.com/hanslub42/rlwrap";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ srapenne ];
  };
}
