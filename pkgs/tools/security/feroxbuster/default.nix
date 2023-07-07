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
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "epi052";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-u2c+s5kCAYOKwl5eb1zY7xdl4pD6eAjiyRj6JFkA07M=";
  };

  # disable linker overrides on aarch64-linux
  postPatch = ''
    rm .cargo/config
  '';

  cargoHash = "sha256-rPFj53KQkucz1/yAr6U2nk6gTdxcBxyRHVqGeawBYZU=";

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

