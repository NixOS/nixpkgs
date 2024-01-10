{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "dua";
  version = "2.24.2";

  src = fetchFromGitHub {
    owner = "Byron";
    repo = "dua-cli";
    rev = "v${version}";
    hash = "sha256-1rGzgKusUKlkH/Ew8qDzq143mu+gvSlXTcqL+I+ypSY=";
    # Remove unicode file names which leads to different checksums on HFS+
    # vs. other filesystems because of unicode normalisation.
    postFetch = ''
      rm -r $out/tests/fixtures
    '';
  };

  cargoHash = "sha256-+GHVZNuEpOxu29EuHOshrYyhg1HFcYJjC4MnFJgjw38=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Foundation
  ];

  doCheck = false;

  meta = with lib; {
    description = "A tool to conveniently learn about the disk usage of directories";
    homepage = "https://github.com/Byron/dua-cli";
    changelog = "https://github.com/Byron/dua-cli/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ figsoda killercup ];
    mainProgram = "dua";
  };
}
