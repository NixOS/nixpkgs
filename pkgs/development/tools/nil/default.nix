{ lib, rustPlatform, fetchFromGitHub, nix, nix-update-script }:

rustPlatform.buildRustPackage rec {
  pname = "nil";
  version = "2022-09-26";

  src = fetchFromGitHub {
    owner = "oxalica";
    repo = pname;
    rev = version;
    hash = "sha256-2bcAXcJiFV+xKSIy3oD2/TkijV4302jAtTF3xtHiOhU=";
  };

  cargoHash = "sha256-RL9n2kfWPpu17qudqSx5DkZbgxqVCf2IRBu/koCAqFA=";

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
