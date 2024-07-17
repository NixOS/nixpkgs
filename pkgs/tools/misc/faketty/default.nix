{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "faketty";
  version = "1.0.16";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-BlQnVjYPFUfEurFUE2MHOL2ad56Nu/atzRuFu4OoCSI=";
  };

  cargoHash = "sha256-q9jx03XYA977481B9xuUfaaMBDbSVx4xREj4Q1Ti/Yw=";

  postPatch = ''
    patchShebangs tests/test.sh
  '';

  meta = with lib; {
    description = "A wrapper to execute a command in a pty, even if redirecting the output";
    homepage = "https://github.com/dtolnay/faketty";
    changelog = "https://github.com/dtolnay/faketty/releases/tag/${version}";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "faketty";
  };
}
