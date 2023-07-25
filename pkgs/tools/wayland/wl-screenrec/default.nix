{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, wayland
, ffmpeg
}:

rustPlatform.buildRustPackage rec {
  pname = "wl-screenrec";
  version = "unstable-2023-05-31";

  src = fetchFromGitHub {
    owner = "russelltg";
    repo = pname;
    rev = "fc918f7898900c1882c6f64c96ed2de8cb9a6300";
    hash = "sha256-P/JELiw0qGcwLFgNPccN/uetNy8CNCJdlCLhgq0h4sc=";
  };

  cargoHash = "sha256-r9zmAiLiAntHcb5W/WKmKbVP9c9+15ElIWtHkks0wig=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    wayland
    ffmpeg
  ];

  meta = with lib; {
    description = "High performance wlroots screen recording, featuring hardware encoding";
    homepage = "https://github.com/russelltg/wl-screenrec";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
