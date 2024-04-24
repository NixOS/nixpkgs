{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "lemmeknow";
  version = "0.8.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-Q82tP4xNWAooFjHeJCFmuULnWlFbgca/9Y2lm8rVXKs=";
  };

  cargoHash = "sha256-slV9RxdFCEx1El7hngWGv+5CqDSQsU2ACF2nWQLOTU0=";

  meta = with lib; {
    description = "A tool to identify anything";
    homepage = "https://github.com/swanandx/lemmeknow";
    changelog = "https://github.com/swanandx/lemmeknow/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda Br1ght0ne ];
    mainProgram = "lemmeknow";
  };
}
