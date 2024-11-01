{ lib, rustPlatform, fetchFromGitHub, pkg-config, wrapGAppsHook4, gtk4 }:

rustPlatform.buildRustPackage rec {
  pname = "ripdrag";
  version = "0.4.10";

  src = fetchFromGitHub {
    owner = "nik012003";
    repo = "ripdrag";
    rev = "v${version}";
    hash = "sha256-aK/1f56sHspohbYO0z2Hf1NDJsN8Dbf1NoL/QadbVSY=";
  };

  cargoHash = "sha256-9POXKvbt1Xr1wKYHhfLb14puKorLIlT1ckzEVd6eWa0=";

  nativeBuildInputs = [ pkg-config wrapGAppsHook4 ];

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
