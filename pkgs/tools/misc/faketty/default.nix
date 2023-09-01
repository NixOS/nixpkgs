{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "faketty";
  version = "1.0.13";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-jV5b6mB81Nz0Q+Toj5DTQq2QcM+EoQ7jRYV/OXgtemA=";
  };

  cargoHash = "sha256-9t1Km/ZXzxyO72CaWM81fWGcFkri7F+wMAVom0GV/YM=";

  postPatch = ''
    patchShebangs tests/test.sh
  '';

  meta = with lib; {
    description = "A wrapper to execute a command in a pty, even if redirecting the output";
    homepage = "https://github.com/dtolnay/faketty";
    changelog = "https://github.com/dtolnay/faketty/releases/tag/${version}";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
