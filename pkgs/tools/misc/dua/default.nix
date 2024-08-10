{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "dua";
  version = "2.29.1";

  src = fetchFromGitHub {
    owner = "Byron";
    repo = "dua-cli";
    rev = "v${version}";
    hash = "sha256-YOXK6u9KF2FnICMFEj5IEZG2OQ6PaKQsShp7/gbSK4Y=";
    # Remove unicode file names which leads to different checksums on HFS+
    # vs. other filesystems because of unicode normalisation.
    postFetch = ''
      rm -r $out/tests/fixtures
    '';
  };

  cargoPatches = [ ./add-cargo-lock.patch ];

  cargoHash = "sha256-Km8I5t6xDaCYn4Z8v7LLDtX4sk89iqnliECPiV7Ed5o=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Foundation
  ];

  doCheck = false;

  meta = with lib; {
    description = "Tool to conveniently learn about the disk usage of directories";
    homepage = "https://github.com/Byron/dua-cli";
    changelog = "https://github.com/Byron/dua-cli/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ figsoda killercup ];
    mainProgram = "dua";
  };
}
