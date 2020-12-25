{ stdenv
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "code-minimap";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = pname;
    rev = "v${version}";
    sha256 = "03azqy4i15kfpd0gzjaw2di9xva4xdf95yb65b93z3y9y5wy4krc";
  };

  cargoSha256 = "1rxrdavj07i7qa5rf1i3aj7zdcp7c6lrg8yiy75r6lm4g98izzww";

  meta = with stdenv.lib; {
    description = "A high performance code minimap render";
    homepage = "https://github.com/wfxr/code-minimap";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ bsima ];
  };
}
