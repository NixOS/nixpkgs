{ lib, rustPlatform, fetchFromGitHub, nix, nix-update-script }:

rustPlatform.buildRustPackage rec {
  pname = "nil";
  version = "2022-12-01";

  src = fetchFromGitHub {
    owner = "oxalica";
    repo = pname;
    rev = version;
    hash = "sha256-E/QGmoL7Q3GDR2/I5o2CAMHMcmPQEJAySke1s+nOaho=";
  };

  cargoHash = "sha256-T3i86L6cF6uFbSs7xtKHGzB6XrE9jn2RZghxFzDleXU=";

  CFG_DATE = version;
  CFG_REV = "release";

  nativeBuildInputs = [
    (lib.getBin nix)
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Yet another language server for Nix";
    homepage = "https://github.com/oxalica/nil";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ figsoda oxalica ];
  };
}
