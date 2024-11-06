{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "backdown";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = "backdown";
    rev = "v${version}";
    hash = "sha256-3+XmMRZz3SHF1sL+/CUvu4uQ2scE4ACpcC0r4nWhdkM=";
  };

  cargoHash = "sha256-+SxXOpSBuVVdX2HmJ4vF45uf5bvRtPdwaXUb9kq+lK0=";

  meta = with lib; {
    description = "File deduplicator";
    homepage = "https://github.com/Canop/backdown";
    changelog = "https://github.com/Canop/backdown/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "backdown";
  };
}
