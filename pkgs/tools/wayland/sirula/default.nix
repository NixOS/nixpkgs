{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, gtk3
, gtk-layer-shell
}:

rustPlatform.buildRustPackage rec {
  pname = "sirula";
  version = "unstable-2021-10-12";

  src = fetchFromGitHub {
    owner = "DorianRudolph";
    repo = "sirula";
    rev = "b300cabde03ec4d8c28ed84e318166b675fb4a77";
    sha256 = "0pxdgjpqaf1bq1y1flafg0ksk8548rif6pfbw0lp31p655pq95c8";
  };

  cargoSha256 = "175rl09jmnj8pd5isyp2chnn66vdz1c16fgqhnjsxvbcasmn8vdj";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gtk3 gtk-layer-shell ];

  meta = with lib; {
    description = "Simple app launcher for wayland written in rust";
    homepage = "https://github.com/DorianRudolph/sirula";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ twitchyliquid64 ];
  };
}
