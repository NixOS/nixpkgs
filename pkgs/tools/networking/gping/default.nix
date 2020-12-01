{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "gping";
  version = "1.0.1-post2";

  src = fetchFromGitHub {
    owner = "orf";
    repo = "gping";
    rev = "v${version}";
    sha256 = "0cvbwxvq1cj9xcjc3hnxrpq9yrmfkapy533cbjzsjmvgiqk11hps";
  };

  cargoSha256 = "0vdhincvfassj7gbiplwbi43yyic3l6wlc32s6ci68b2wjmff8pn";

  meta = with lib; {
    description = "Ping, but with a graph";
    homepage = "https://github.com/orf/gping";
    license = licenses.mit;
    maintainers = with maintainers; [ andrew-d ];
  };
}
