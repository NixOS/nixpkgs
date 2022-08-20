{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, gtk3
, gtk-layer-shell
}:

rustPlatform.buildRustPackage rec {
  pname = "sirula";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "DorianRudolph";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-C5mVO10+jD4TDg6R9rVJO6fdDiOD5tT+bEaI53WVdFA=";
  };

  cargoSha256 = "sha256-pxVEa3m7SWMwOAcR/jRKzEc6MH6YkNfTW0cm6Nid6Zo=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gtk3 gtk-layer-shell ];

  meta = with lib; {
    description = "Simple app launcher for wayland written in rust";
    homepage = "https://github.com/DorianRudolph/sirula";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ twitchyliquid64 ];
  };
}
