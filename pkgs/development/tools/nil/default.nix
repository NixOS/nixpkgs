{ lib, rustPlatform, fetchFromGitHub, nix, nix-update-script }:

rustPlatform.buildRustPackage rec {
  pname = "nil";
  version = "2022-11-07";

  src = fetchFromGitHub {
    owner = "oxalica";
    repo = pname;
    rev = version;
    hash = "sha256-ioY9RvKx9DKnNTeMW8mAIEq23w7Y+lAOFWMkgUQ5fu4=";
  };

  cargoHash = "sha256-sL/bnLK3TifmVHy3LOsduETHh9SGz639vgEKkbHE0HQ=";

  CFG_DATE = version;
  CFG_REV = "release";

  nativeBuildInputs = [
    (lib.getBin nix)
  ];

  passthru.updateScript = nix-update-script {
    attrPath = pname;
  };

  meta = with lib; {
    description = "Yet another language server for Nix";
    homepage = "https://github.com/oxalica/nil";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ figsoda oxalica ];
  };
}
