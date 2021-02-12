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

  cargoSha256 = "0my314zdsy2lmmmppxf4j8g8dzhqzilg4rllxwr6xj1b5ghih4xi";

  meta = with lib; {
    description = "Ping, but with a graph";
    homepage = "https://github.com/orf/gping";
    license = licenses.mit;
    maintainers = with maintainers; [ andrew-d ];
  };
}
