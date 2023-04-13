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
  version = "2.9.3";

  src = fetchFromGitHub {
    owner = "epi052";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Z97CAfGnNTQmJd2zMlvGfk5jW9zHAB/efqYoYgVRfMc=";
  };

  # disable linker overrides on aarch64-linux
  postPatch = ''
    rm .cargo/config
  '';

  cargoHash = "sha256-siLyPPSTBaZ4vpfzeKVlrqIdFMI5z3hRA8c2lRsBAGM=";

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

