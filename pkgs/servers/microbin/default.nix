{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, oniguruma
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "microbin";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "szabodanika";
    repo = "microbin";
    rev = "v${version}";
    hash = "sha256-fsRpqSYDsuV0M6Xar2GVoyTgCPT39dcKJ6eW4YXCkQ0=";
  };

  cargoHash = "sha256-7GSgyh2aJ2f8pozoh/0Yxzbk8Wg3JYuqSy/34ywAc2s=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    oniguruma
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  meta = with lib; {
    description = "A tiny, self-contained, configurable paste bin and URL shortener written in Rust";
    homepage = "https://github.com/szabodanika/microbin";
    changelog = "https://github.com/szabodanika/microbin/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dit7ya figsoda ];
  };
}
