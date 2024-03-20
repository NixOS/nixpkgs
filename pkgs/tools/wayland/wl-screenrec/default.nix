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
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "russelltg";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ThPZPV1GyMFRu94O9WwUpXbR4gnIML26K7TyIfXZlcI=";
  };

  cargoHash = "sha256-DtlVsUFKNKXcwqNvGvqkSKUE+kRHX8wajL4fR0c9ZuQ=";

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
