{ lib, rustPlatform, fetchFromGitHub, ncurses, openssl, pkg-config, stdenv, Security, fetchpatch }:

rustPlatform.buildRustPackage rec {
  pname = "wiki-tui";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "Builditluc";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-WiyRBF3rWLpOZ8mxT89ImRL++Oq9+b88oSKjr4tzCGs=";
  };

  buildInputs = [ ncurses openssl ] ++ lib.optional stdenv.isDarwin Security;

  nativeBuildInputs = [ pkg-config ];

  cargoSha256 = "sha256-R9xxIDqkU7FeulpD7PUM6aHgA67PVgqxHKYtdrjdaUo=";

  meta = with lib; {
    description = "A simple and easy to use Wikipedia Text User Interface";
    homepage = "https://github.com/builditluc/wiki-tui";
    license = licenses.mit;
    maintainers = with maintainers; [ lom builditluc ];
  };
}
