{ lib, rustPlatform, fetchFromGitHub, pkg-config, wrapGAppsHook4, gtk4 }:

rustPlatform.buildRustPackage rec {
  pname = "ripdrag";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "nik012003";
    repo = "ripdrag";
    rev = "v${version}";
    hash = "sha256-GWNu970nyD4E2mWghOtHnuvVYGhgZ87zNCNxSpxOsgQ=";
  };

  cargoHash = "sha256-aN+25hhE6LhI8M+enyzsfSTARIxbY36mdeP70rjBJQ8=";

  nativeBuildInputs = [ pkg-config wrapGAppsHook4 ];

  buildInputs = [ gtk4 ];

  meta = with lib; {
    description = "An application that lets you drag and drop files from and to the terminal";
    homepage = "https://github.com/nik012003/ripdrag";
    changelog = "https://github.com/nik012003/ripdrag/releases/tag/${src.rev}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
  };
}
