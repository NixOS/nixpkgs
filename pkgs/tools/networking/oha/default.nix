{ fetchFromGitHub, lib, pkg-config, rustPlatform, stdenv, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "oha";
  version = "0.4.7";

  src = fetchFromGitHub {
    owner = "hatoo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/gcNVTfLJKA5qzRgAqFSlSI618QBsJTxFE1doOKR7e8=";
  };

  cargoSha256 = "sha256-o5VKj69Wp7zLR3TS+wNA0D8nP6Cynlr4KtW4JSUm0VE=";

  nativeBuildInputs = lib.optional stdenv.isLinux pkg-config;

  buildInputs = lib.optional stdenv.isLinux openssl
    ++ lib.optional stdenv.isDarwin Security;

  # tests don't work inside the sandbox
  doCheck = false;

  meta = with lib; {
    description = "HTTP load generator inspired by rakyll/hey with tui animation";
    homepage = "https://github.com/hatoo/oha";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
