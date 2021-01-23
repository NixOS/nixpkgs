{ lib, stdenv, fetchurl, readline }:

stdenv.mkDerivation rec {
  pname = "rlwrap";
  version = "0.43";

  src = fetchurl {
    url = "https://github.com/hanslub42/rlwrap/releases/download/v${version}/${pname}-${version}.tar.gz";
    sha256 = "0bzb7ylk2770iv59v2d0gypb21y2xn87m299s9rqm6rdi2vx11lf";
  };

  buildInputs = [ readline ];

  # Be high-bit-friendly
  preBuild = ''
    sed -i src/readline.c -e "s@[*]p [<] ' '@(*p >= 0) \\&\\& (*p < ' ')@"
  '';

  meta = {
    description = "Readline wrapper for console programs";
    homepage = "https://github.com/hanslub42/rlwrap";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ];
  };
}
