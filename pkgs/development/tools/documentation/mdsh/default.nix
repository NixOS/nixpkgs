{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "mdsh";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "zimbatm";
    repo = "mdsh";
    rev = "v${version}";
    sha256 = "02xslf5ssmyklbfsif2d7yk5aaz08n5w0dqiid6v4vlr2mkqcpjl";
  };

  cargoSha256 = "0adjnn1zi1bf7p71km4v6k4cjd07lwzs7cqi18l4fjlihph7wvqx";

  meta = with lib; {
    description = "Markdown shell pre-processor";
    homepage = "https://github.com/zimbatm/mdsh";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ zimbatm ];
  };
}
