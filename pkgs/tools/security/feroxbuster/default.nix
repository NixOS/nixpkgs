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
  version = "2.9.4";

  src = fetchFromGitHub {
    owner = "epi052";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-9PLj5tORWE4A6MWU9DF6JUbRebTOswIC/Jg6aq6SUPc=";
  };

  # disable linker overrides on aarch64-linux
  postPatch = ''
    rm .cargo/config
  '';

  cargoHash = "sha256-Kest8QCfiS0F8pw1PULny7iuYf9oILiZykPsL2ZSskQ=";

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
    changelog = "https://github.com/epi052/feroxbuster/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    platforms = platforms.unix;
  };
}

