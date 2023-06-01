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
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "Builditluc";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-vrWjX8WB9niZnBDIlMSj/NUuJxCkP4QoOLp+xTnvSjs=";
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

  cargoHash = "sha256-m3gxmoZVEVzqach7Oep943B4DhOUzrTB+Z6J/TvdCQ8=";

  meta = with lib; {
    description = "A simple and easy to use Wikipedia Text User Interface";
    homepage = "https://github.com/builditluc/wiki-tui";
    changelog = "https://github.com/Builditluc/wiki-tui/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ lom builditluc ];
  };
}
