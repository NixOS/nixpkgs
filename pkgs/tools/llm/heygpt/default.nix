{
  fetchFromGitHub,
  lib,
  openssl,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "heygpt";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "fuyufjh";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Gtbb0G7tV+cjbq/74dnZKIwWZgNfSJl0My6F4OmAdhU=";
  };

  cargoSha256 = "sha256-ON6+gU+KsI2QFQjwxPRcbMClaAGrjVJ33mVuf0jSro8=";

  nativeBuildInputs = [openssl];

  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR = 1;
  OPENSSL_LIB_DIR = "${lib.getLib openssl}/lib";
  OPENSSL_DIR = "${lib.getDev openssl}";

  meta = with lib; {
    description = "A simple command-line interface for ChatGPT API.";
    homepage = "https://github.com/fuyufjh/heygpt";
    license = licenses.mit;
    mainProgram = pname;
    maintainers = with maintainers; [aldoborrero];
  };
}
