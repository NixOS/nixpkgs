{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "fblog";
  version = "4.10.0";

  src = fetchFromGitHub {
    owner = "brocode";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-4Yg7gWVBG9GI1ailEbbcslM+XR8L7yjjjvf4dQq/87I=";
  };

  cargoHash = "sha256-8rnQllCne1q1uDpeJkqAdzNKSkEgVp+v9drXL8TaQmM=";

  meta = with lib; {
    description = "Small command-line JSON log viewer";
    mainProgram = "fblog";
    homepage = "https://github.com/brocode/fblog";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ figsoda ];
  };
}
