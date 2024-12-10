{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "nomino";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "yaa110";
    repo = pname;
    rev = version;
    hash = "sha256-jV1GqwQURRFPGuFXPhtgbBJHOdroQk6KHMI5yHa0Z64=";
  };

  cargoHash = "sha256-QluOfU8TO5422lVXswjiQb2YleWiq5twwYzpBJsBs2Y=";

  meta = with lib; {
    description = "Batch rename utility for developers";
    homepage = "https://github.com/yaa110/nomino";
    changelog = "https://github.com/yaa110/nomino/releases/tag/${src.rev}";
    license = with licenses; [
      mit # or
      asl20
    ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "nomino";
  };
}
