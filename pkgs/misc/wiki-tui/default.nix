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
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "Builditluc";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-vBfD5SQnVx/UqRoyGJc4PINW/wKuHjpiUEz3WiRCR9A=";
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

  cargoHash = "sha256-xbjUdQs2t+cjplAlNVRN1Zw5CeAYv4+ir4Pvrt+/n9k=";

  meta = with lib; {
    description = "A simple and easy to use Wikipedia Text User Interface";
    homepage = "https://github.com/builditluc/wiki-tui";
    changelog = "https://github.com/Builditluc/wiki-tui/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ lom builditluc ];
  };
}
