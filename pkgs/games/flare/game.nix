{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "flare-game";
  version = "1.12";

  src = fetchFromGitHub {
    owner = "flareteam";
    repo = pname;
    rev = "v${version}";
    sha256 = "15k9r7w587pvkzrln0670hhq5fzif8k7xmrhb0nl3z3fi6dw3mmc";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Fantasy action RPG using the FLARE engine";
    homepage = "https://github.com/flareteam/flare-game";
    maintainers = [ maintainers.aanderse ];
    license = [ licenses.cc-by-sa-30 ];
    platforms = platforms.unix;
  };
}
