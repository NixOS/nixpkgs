{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, ncurses
, openssl
, pkg-config
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "wiki-tui";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "Builditluc";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-WiyRBF3rWLpOZ8mxT89ImRL++Oq9+b88oSKjr4tzCGs=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    ncurses
    openssl
  ] ++ lib.optional stdenv.isDarwin [
    Security
  ];

  cargoHash = "sha256-R9xxIDqkU7FeulpD7PUM6aHgA67PVgqxHKYtdrjdaUo=";

  meta = with lib; {
    description = "A simple and easy to use Wikipedia Text User Interface";
    homepage = "https://github.com/builditluc/wiki-tui";
    changelog = "https://github.com/Builditluc/wiki-tui/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ lom builditluc ];
  };
}
