{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "tv";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "uzimaru0000";
    repo = pname;
    rev = "v${version}";
    sha256 = "07gcs64j468213jxcjjv9vywzvfair7gbaiqzqm9wwsdgjyw0wwc";
  };

  cargoSha256 = "00fi7wimr0rihf6qx20r77w85w2i55kn823gp283lsszbw1z8as9";

  meta = with lib; {
    description = "Format json into table view";
    homepage = "https://github.com/uzimaru0000/tv";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
