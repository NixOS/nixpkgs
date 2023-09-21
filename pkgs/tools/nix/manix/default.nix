{ lib, stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "manix";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "mlvzk";
    repo  = pname;
    rev = "v${version}";
    sha256 = "1b7xi8c2drbwzfz70czddc4j33s7g1alirv12dwl91hbqxifx8qs";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  cargoSha256 = "1yivx9vzk2fvncvlkwq5v11hb9llr1zlcmy69y12q6xnd9rd8x1b";

  meta = with lib; {
    description = "A Fast Documentation Searcher for Nix";
    homepage    = "https://github.com/mlvzk/manix";
    license     = [ licenses.mpl20 ];
    maintainers = [ maintainers.mlvzk ];
    platforms   = platforms.unix;
  };
}
