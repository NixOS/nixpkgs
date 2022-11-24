{ lib, rustPlatform, fetchFromGitHub, nix, nix-update-script }:

rustPlatform.buildRustPackage rec {
  pname = "nil";
  version = "2022-11-15";

  src = fetchFromGitHub {
    owner = "oxalica";
    repo = pname;
    rev = version;
    hash = "sha256-KzQmGCEaOACOqaE1LsVZsqn18XpjlUbGWztDEI+o++w=";
  };

  cargoHash = "sha256-t5HfL7DKMcWJGod6x30NoHYYlAza++fEdEVvfvFWems=";

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
