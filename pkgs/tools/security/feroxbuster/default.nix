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
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "epi052";
    repo = pname;
    rev = version;
    hash = "sha256-Ub4HOi38fYNJkpXfms1/aDl97h2UI1Fru8+NAiAztoc=";
  };

  cargoSha256 = "sha256-ODLL++wn8IQloEFZXF8TasercTKJ0nhPtny4fsi03Ks=";

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

