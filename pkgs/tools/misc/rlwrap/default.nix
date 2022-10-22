{ lib, stdenv, fetchFromGitHub, autoreconfHook, perl, readline }:

stdenv.mkDerivation rec {
  pname = "rlwrap";
  version = "0.45.2";

  src = fetchFromGitHub {
    owner = "hanslub42";
    repo = "rlwrap";
    rev = "v${version}";
    sha256 = "sha256-ubhAOyswdDG0mFKpnSDDq5f7umyCHsW/m721IHdjNMc=";
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
    maintainers = with maintainers; [ SuperSandro2000 srapenne ];
  };
}
