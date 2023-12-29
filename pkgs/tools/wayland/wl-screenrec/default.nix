{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libdrm
, ffmpeg
, wayland
}:

rustPlatform.buildRustPackage rec {
  pname = "wl-screenrec";
  version = "unstable-2023-09-17";

  src = fetchFromGitHub {
    owner = "russelltg";
    repo = pname;
    rev = "a36c5923009b44f2131196d8a3a234948f8e0102";
    hash = "sha256-V29eB9vozVKIBq8dO7zgA4nirsh1eDBjJN+rwVkeDLE=";
  };

  cargoHash = "sha256-uUfEweLWn/NdqgY8O7Ld+YnGPKQV1tpJi/Gd4MZB4xI=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    wayland
    libdrm
    ffmpeg
  ];

  doCheck = false; # tests use host compositor, etc

  meta = with lib; {
    description = "High performance wlroots screen recording, featuring hardware encoding";
    homepage = "https://github.com/russelltg/wl-screenrec";
    license = licenses.asl20;
    platforms = platforms.linux;
    mainProgram = "wl-screenrec";
    maintainers = with maintainers; [ colemickens ];
  };
}
