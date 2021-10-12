{ fetchFromGitHub, lib, pkg-config, rustPlatform, stdenv, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "oha";
  version = "0.4.6";

  src = fetchFromGitHub {
    owner = "hatoo";
    repo = pname;
    rev = "v${version}";
    sha256 = "0vx8ki0wi9xil2iksvxzh8mhx4c5ikkhdcnc8mcwqn14cvjkggja";
  };

  cargoSha256 = "1nx2lvbjflsjma5q9ck6vq499hf75w91i4h8wlzr83wqk37i7rhc";

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
