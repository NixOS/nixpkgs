{
  fetchFromGitHub,
  lib,
  openssl,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "heygpt";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "fuyufjh";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-oP0yIdYytXSsbZ2pNaZ8Rrak1qJsudTe/oP6dGncGUM=";
  };

  cargoHash = "sha256-yKHAZpELuUD7wlM3Mi7XvxbKgdU1QxD9hsvIFcj3twE=";

  nativeBuildInputs = [ openssl ];

  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR = 1;
  OPENSSL_LIB_DIR = "${lib.getLib openssl}/lib";
  OPENSSL_DIR = "${lib.getDev openssl}";

  meta = with lib; {
    description = "A simple command-line interface for ChatGPT API";
    homepage = "https://github.com/fuyufjh/heygpt";
    license = licenses.mit;
    mainProgram = "heygpt";
    maintainers = with maintainers; [ aldoborrero ];
  };
}
