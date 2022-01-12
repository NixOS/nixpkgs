{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "sad";
  version = "0.4.17";

  src = fetchFromGitHub {
    owner = "ms-jpq";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dclnsncql3TFOZ4z6SyIAWe4bgAFK3Us3xJ0AeX/wNA=";
  };

  cargoSha256 = "sha256-jej7JKSllBpb13Zq0WrcDPLdMtnjau8I0a4ghstHVqk=";

  meta = with lib; {
    description = "CLI tool to search and replace";
    homepage = "https://github.com/ms-jpq/sad";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
