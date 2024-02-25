{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "faketty";
  version = "1.0.15";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-f32Y9Aj4Z9y6Da9rbRgwi9BGPl4FsI790BH52cIIoPA=";
  };

  cargoHash = "sha256-+M1oq2CHUK6CIDFiUNLjO1UmHI19D5zdHVl8dvmQ1G8=";

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
