{ fetchFromGitHub, lib, pkg-config, rustPlatform, stdenv, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "oha";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "hatoo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-wCoBlbi4/EiTAA1xiZ/taVrokE0ECf8STAlA1sk/pm0=";
  };

  cargoSha256 = "sha256-tcORdyxGViUhKbtxVJaZ1G3uUpyr1pRLu5j8v52lMg8=";

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
