<<<<<<< HEAD
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
=======
{ lib, rustPlatform, fetchCrate, pkg-config, gtk4 }:

rustPlatform.buildRustPackage rec {
  pname = "ripdrag";
  version = "0.3.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-D4WB1RdMPJfSLbJ96h3OuFhokfyY8Gamctm0XY694YM=";
  };

  cargoSha256 = "sha256-C2I26E/dd18A4DDgOYGR8aS1RBrrNUwaXI4ZJHcrKy0=";

  nativeBuildInputs = [ pkg-config ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = [ gtk4 ];

  meta = with lib; {
    description = "An application that lets you drag and drop files from and to the terminal";
    homepage = "https://github.com/nik012003/ripdrag";
<<<<<<< HEAD
    changelog = "https://github.com/nik012003/ripdrag/releases/tag/${src.rev}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
  };
}
