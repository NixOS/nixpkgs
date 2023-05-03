{ lib, rustPlatform, fetchFromGitHub, nix, nix-update-script }:

rustPlatform.buildRustPackage rec {
  pname = "nil";
  version = "2023-05-02";

  src = fetchFromGitHub {
    owner = "oxalica";
    repo = pname;
    rev = version;
    hash = "sha256-T6iBqa9+KsVbcjNivRWXi2kXP90S+NJLp2qVah7I1w8=";
  };

  cargoHash = "sha256-ehT+i4Khen8fD6OZ6WMzFPtv1D49JyxmGmN0ZPKiOhk=";

  CFG_RELEASE = version;

  nativeBuildInputs = [
    (lib.getBin nix)
  ];

  # might be related to https://github.com/NixOS/nix/issues/5884
  preBuild = ''
    export NIX_STATE_DIR=$(mktemp -d)
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Yet another language server for Nix";
    homepage = "https://github.com/oxalica/nil";
    changelog = "https://github.com/oxalica/nil/releases/tag/${version}";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ figsoda oxalica ];
  };
}
