{ lib, rustPlatform, fetchFromGitHub, nix, nix-update-script }:

rustPlatform.buildRustPackage rec {
  pname = "nil";
  version = "2023-01-01";

  src = fetchFromGitHub {
    owner = "oxalica";
    repo = pname;
    rev = version;
    hash = "sha256-xpNlmGG7Qy0SPzXZ9sQ0i9Yo2hMaK+YsTEOTk10rs+k=";
  };

  cargoHash = "sha256-mwfM3hIEaHKa2oPVWzXpua+W2Oa5brvNRbRCcV0KapY=";

  CFG_DATE = version;
  CFG_REV = "release";

  nativeBuildInputs = [
    (lib.getBin nix)
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Yet another language server for Nix";
    homepage = "https://github.com/oxalica/nil";
    changelog = "https://github.com/oxalica/nil/releases/tag/${version}";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ figsoda oxalica ];
  };
}
