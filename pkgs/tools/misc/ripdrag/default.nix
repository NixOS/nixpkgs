{ lib, rustPlatform, fetchFromGitHub, pkg-config, wrapGAppsHook4, gtk4 }:

rustPlatform.buildRustPackage rec {
  pname = "ripdrag";
  version = "0.4.8";

  src = fetchFromGitHub {
    owner = "nik012003";
    repo = "ripdrag";
    rev = "v${version}";
    hash = "sha256-DjLQJUaSwglM9mtgKhG+JZ9vHTTfLXy21YLkZiPfTyE=";
  };

  cargoHash = "sha256-un7HE91w4p5+2LrjasKC8/q+nGg8F/6+ZACS5X3OJ1Q=";

  nativeBuildInputs = [ pkg-config wrapGAppsHook4 ];

  buildInputs = [ gtk4 ];

  meta = with lib; {
    description = "An application that lets you drag and drop files from and to the terminal";
    homepage = "https://github.com/nik012003/ripdrag";
    changelog = "https://github.com/nik012003/ripdrag/releases/tag/${src.rev}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "ripdrag";
  };
}
