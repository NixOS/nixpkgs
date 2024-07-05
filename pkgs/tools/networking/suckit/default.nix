{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, stdenv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "suckit";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "skallwar";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-M4/vD1sVny7hAf4h56Z2xy7yuCqH/H3qHYod6haZOs0=";
  };

  cargoSha256 = "sha256-JsH7TL9iITawuECm1hzs5oXFtnoUqLT4ug2CafoO2ao=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optional stdenv.isDarwin Security;

  # requires internet access
  checkFlags = [
    "--skip=test_download_url"
    "--skip=test_external_download"
  ];

  meta = with lib; {
    description = "Recursively visit and download a website's content to your disk";
    homepage = "https://github.com/skallwar/suckit";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "suckit";
  };
}
