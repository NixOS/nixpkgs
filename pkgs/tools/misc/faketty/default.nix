{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "faketty";
  version = "1.0.14";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-oma8Vmp1AMmEGyZG8i/ztiyYH0RrLZ/l/vXgPJs+5o0=";
  };

  cargoHash = "sha256-+gojthIR5WMSjN1gCUyN0cKHWYBKBezsckVZJD7JncM=";

  postPatch = ''
    patchShebangs tests/test.sh
  '';

  meta = with lib; {
    description = "A wrapper to execute a command in a pty, even if redirecting the output";
    homepage = "https://github.com/dtolnay/faketty";
    changelog = "https://github.com/dtolnay/faketty/releases/tag/${version}";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "faketty";
  };
}
