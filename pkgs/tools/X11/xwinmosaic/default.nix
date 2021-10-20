{ lib, stdenv, fetchFromGitHub, gtk2, cmake, pkg-config, libXdamage }:

stdenv.mkDerivation rec {
  version = "0.4.2";
  pname = "xwinmosaic";

  src = fetchFromGitHub {
    owner = "soulthreads";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "16qhrpgn84fz0q3nfvaz5sisc82zk6y7c0sbvbr69zfx5fwbs1rr";
  };

  nativeBuildInputs = [ pkg-config cmake ];
  buildInputs = [ gtk2 libXdamage ];

  meta = {
    description = "X window switcher drawing a colourful grid";
    license = lib.licenses.bsd2 ;
    maintainers = [lib.maintainers.raskin];
    platforms = lib.platforms.linux;
  };
}
