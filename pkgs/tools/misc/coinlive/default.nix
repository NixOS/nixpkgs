{ lib
, stdenv
, fetchFromGitHub
, openssl
, pkg-config
, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "coinlive";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "mayeranalytics";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-i21C1ZSAPoUOBlnDQl40/17yRqmNx3wkjswHJeV9vko=";
  };

  cargoSha256 = "sha256-0pUXCY5rZWh26KGD2OU2+M9L0RtCIan6hmuNeIeBEHI=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

  meta = with lib; {
    description = "Live cryptocurrency prices CLI";
    homepage = "https://github.com/mayeranalytics/coinlive";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
