{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libgit2
, openssl
, zlib
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "fw";
  version = "2.17.0";

  src = fetchFromGitHub {
    owner = "brocode";
    repo = "fw";
    rev = "v${version}";
    hash = "sha256-D3fwwjYLPDeWDRGO2HW0jcGhwrUWDTNQuJUnphN3wzI=";
  };

  cargoHash = "sha256-5jlpX6cOwsn4EaZUDLSKmOqBQg/WmaPRFHQcCrlBvxc=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
    openssl
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  meta = with lib; {
    description = "A workspace productivity booster";
    homepage = "https://github.com/brocode/fw";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ figsoda ];
  };
}
