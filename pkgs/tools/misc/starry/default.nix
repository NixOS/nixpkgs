{ lib
, rustPlatform
, fetchCrate
, pkg-config
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "starry";
  version = "2.1.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-XzvRujVBHxpT2lLyxU50xWdhe/HCHxFjGA4N8hvtFo8=";
  };

  cargoHash = "sha256-a/b+nd0heJH9dJELY6G6f0MN2E7sKDpeQHPHbVh6upA=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "Current stars history tells only half the story";
    homepage = "https://github.com/Canop/starry";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "starry";
  };
}
