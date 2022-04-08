{ lib
, stdenv
, fetchFromGitHub
, openssl
, pkg-config
, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "feroxbuster";
  version = "2.6.2";

  src = fetchFromGitHub {
    owner = "epi052";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-SRVCtyl0+GRQ6MUHDY3gi7eg0l42d74c+Ct7G70MJfw=";
  };

  cargoSha256 = "sha256-5SCJqVA5CEyILc5Ojr5ZsFiK8y6qfgggXyp9e8i5pdo=";

  OPENSSL_NO_VENDOR = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

  # Tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Fast, simple, recursive content discovery tool";
    homepage = "https://github.com/epi052/feroxbuster";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}

