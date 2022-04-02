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
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "epi052";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-RY9bFuALRaVXDrC0eIx0inPjRqNpRKNZf3mCrKIdGL8=";
  };

  cargoSha256 = "sha256-0Zawlx/lhF7K8nOsHYKO84pnctVMpm3RfnAFCOltOqE=";

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

