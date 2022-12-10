{ lib, rustPlatform, fetchFromGitHub, ncurses, openssl, pkg-config, stdenv, Security, fetchpatch }:

rustPlatform.buildRustPackage rec {
  pname = "wiki-tui";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "Builditluc";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-sqkVi8w4QoktC1ZLUPHzfMUxIzCadcIj3dEYigz854U=";
  };

  buildInputs = [ ncurses openssl ] ++ lib.optional stdenv.isDarwin Security;

  nativeBuildInputs = [ pkg-config ];

  cargoSha256 = "sha256-xRj0bF5VymvFVB0tSBndWA+OHBIEY2/ovRIBdDoOHA4=";

  # Tests fail with this error: `found argument --test-threads which was not expected`
  doCheck = false;

  meta = with lib; {
    description = "A simple and easy to use Wikipedia Text User Interface";
    homepage = "https://github.com/builditluc/wiki-tui";
    license = licenses.mit;
    maintainers = with maintainers; [ lom builditluc ];
  };
}
