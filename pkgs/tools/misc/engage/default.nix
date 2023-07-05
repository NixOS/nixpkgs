{ lib
, rustPlatform
, fetchgit
}:

let
  pname = "engage";
  version = "0.1.2";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  # fetchFromGitLab doesn't work on GitLab's end for unknown reasons
  src = fetchgit {
    url = "https://or.computer.surgery/charles/${pname}";
    rev = "v${version}";
    hash = "sha256-7zLFgTLeAIaMMoj0iThH/5UhnV9OUGe9CVwbbShCieo=";
  };

  cargoHash = "sha256-+4uqC0VoBSmkS9hYC1lzWeJmK873slZT04TljHPE+Eo=";

  meta = {
    description = "A task runner with DAG-based parallelism";
    homepage = "https://or.computer.surgery/charles/engage";
    changelog = "https://or.computer.surgery/charles/engage/-/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [ asl20 mit ];
    maintainers = with lib.maintainers; [ CobaltCause ];
  };
}
