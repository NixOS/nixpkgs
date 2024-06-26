{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  gtk4,
}:

rustPlatform.buildRustPackage rec {
  pname = "ripdrag";
  version = "0.4.9";

  src = fetchFromGitHub {
    owner = "nik012003";
    repo = "ripdrag";
    rev = "v${version}";
    hash = "sha256-fsCIyaGCLwf1T8xyVCTjg51TXS8v0l9dBHRB8wdyN5g=";
  };

  cargoHash = "sha256-ZzD+WkmvZX4YXtOwWHw/7t9N/xgKWrMfCThcYFyHG/g=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [ gtk4 ];

  meta = with lib; {
    description = "Application that lets you drag and drop files from and to the terminal";
    homepage = "https://github.com/nik012003/ripdrag";
    changelog = "https://github.com/nik012003/ripdrag/releases/tag/${src.rev}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "ripdrag";
  };
}
