{ lib, stdenv, fetchFromGitHub, autoreconfHook, perl, readline }:

stdenv.mkDerivation rec {
  pname = "rlwrap";
  version = "0.46.1";

  src = fetchFromGitHub {
    owner = "hanslub42";
    repo = "rlwrap";
    rev = version;
    sha256 = "sha256-yKJXfdxfaCsmPtI0KmTzfFKY+evUuytomVrLsSCYDGo=";
  };

  postPatch = ''
    substituteInPlace src/readline.c \
      --replace "if(*p >= 0 && *p < ' ')" "if(*p >= 0 && (*p >= 0) && (*p < ' '))"
  '';

  nativeBuildInputs = [ autoreconfHook perl ];

  buildInputs = [ readline ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-Wno-error=implicit-function-declaration";

  meta = with lib; {
    description = "Readline wrapper for console programs";
    homepage = "https://github.com/hanslub42/rlwrap";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jlesquembre ];
    mainProgram = "rlwrap";
  };
}
