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
  version = "2.7.1";

  src = fetchFromGitHub {
    owner = "epi052";
    repo = pname;
    rev = version;
    hash = "sha256-B6FeY5pWW5+y/0HlVedkm8ol2z9GXgEYe5j7/uMhqsw=";
  };

  cargoSha256 = "sha256-OFgt8yu2wlvkP/wjlmRRl8UyD9MUx9/0Rcs6K8jLkjo=";

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

