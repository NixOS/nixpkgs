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
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "Builditluc";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-WEB6tzHeP7fX+KyNOqAADKHT6IE1t8af889XcHH/48Q=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    ncurses
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

  cargoHash = "sha256-pLAUwkn4w/vwg/znBtjxc+og2yJn5uABY3Au9AYkpM4=";

  meta = with lib; {
    description = "A simple and easy to use Wikipedia Text User Interface";
    homepage = "https://github.com/builditluc/wiki-tui";
    changelog = "https://github.com/Builditluc/wiki-tui/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ lom builditluc ];
  };
}
