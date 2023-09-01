{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "spacer";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "samwho";
    repo = "spacer";
    rev = "v${version}";
    hash = "sha256-6RGwOyp/TzO7Z2xpcNFtAb+UaiMmgiuac9nqZs4fC10=";
  };

  cargoHash = "sha256-XWXrivx0TJZmu5jJYJAzKm6dzqOwiWwU8mRuehZkQbA=";

  meta = with lib; {
    description = "CLI tool to insert spacers when command output stops";
    homepage = "https://github.com/samwho/spacer";
    changelog = "https://github.com/samwho/spacer/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
