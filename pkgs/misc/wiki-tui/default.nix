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
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "Builditluc";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-pjNXDU1YgzaH4vtdQnnfRCSmbhIgeAiOP/uyhBNG/7s=";
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

  cargoHash = "sha256-RWj1QCHYEtw+QzdX+YlFiMqMhvCfxYzj6SUzfhqrcM8=";

  meta = with lib; {
    description = "A simple and easy to use Wikipedia Text User Interface";
    homepage = "https://github.com/builditluc/wiki-tui";
    changelog = "https://github.com/Builditluc/wiki-tui/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ lom builditluc ];
  };
}
