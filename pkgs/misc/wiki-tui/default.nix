{ lib, rustPlatform, fetchFromGitHub, ncurses, openssl, pkg-config, stdenv, Security, fetchpatch }:

rustPlatform.buildRustPackage rec {
  pname = "wiki-tui";
  version = "0.4.7";

  src = fetchFromGitHub {
    owner = "Builditluc";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qoj5rg0YeBWQuU/HU84wOSG9y9p4Q1DFbqsh61mYnUc=";
  };

  buildInputs = [ ncurses openssl ] ++ lib.optional stdenv.isDarwin Security;

  nativeBuildInputs = [ pkg-config ];

  cargoSha256 = "sha256-btSWvlObvn08cAWVMM4R0aciYz8swRFZjX+WDhALj3M=";

  # Tests fail with this error: `found argument --test-threads which was not expected`
  doCheck = false;

  meta = with lib; {
    description = "A simple and easy to use Wikipedia Text User Interface";
    homepage = "https://github.com/builditluc/wiki-tui";
    license = licenses.mit;
    maintainers = with maintainers; [ lom builditluc ];
  };
}
