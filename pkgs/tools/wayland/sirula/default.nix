{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, gtk3
, gtk-layer-shell
}:

rustPlatform.buildRustPackage rec {
  pname = "sirula";
  version = "unstable-2021-07-11";

  src = fetchFromGitHub {
    owner = "DorianRudolph";
    repo = "sirula";
    rev = "574725bc307fc704c42380cd0fa50b0b80c4764d";
    sha256 = "1m58j1hymjw4l2z1jdfirw1vb3rblc1qffpvc2lqy99frfz0dlvp";
  };

  cargoSha256 = "0wk90p20qkbpr866h8cvdshr8cl2kmc3dh2zxws5mlsh3sx2ld4w";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gtk3 gtk-layer-shell ];

  meta = with lib; {
    description = "Simple app launcher for wayland written in rust";
    homepage = "https://github.com/DorianRudolph/sirula";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ twitchyliquid64 ];
  };
}
