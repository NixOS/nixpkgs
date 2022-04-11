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
  version = "2.6.4";

  src = fetchFromGitHub {
    owner = "epi052";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-aTyjZc+bsA4rvbcFTLArK+zbfF6thHEYyPbMx9vLcMo=";
  };

  cargoSha256 = "sha256-PLrIMgn0o+fFB6Zv9sf7X4gZyHwVSd6BOM1/KUo3TAg=";

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

