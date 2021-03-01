{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "gping";
  version = "1.2.0-post";

  src = fetchFromGitHub {
    owner = "orf";
    repo = "gping";
    rev = "v${version}";
    sha256 = "0h4cd36lrhr64p3m2l7yvkq22h8fzzm3g61m39d303s1viibm6dg";
  };

  cargoSha256 = "0aadalgs5p7wqbbkidm49ccfl716xairb4pirrgm3749zdg55bi9";

  meta = with lib; {
    description = "Ping, but with a graph";
    homepage = "https://github.com/orf/gping";
    license = licenses.mit;
    maintainers = with maintainers; [ andrew-d ];
  };
}
