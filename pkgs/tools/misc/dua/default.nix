{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "dua";
  version = "2.29.4";

  src = fetchFromGitHub {
    owner = "Byron";
    repo = "dua-cli";
    rev = "v${version}";
    hash = "sha256-TVwRz5bAdJMtmhhzfZZ/NuV+YrLcnuK6d86Oj/JmgW4=";
    # Remove unicode file names which leads to different checksums on HFS+
    # vs. other filesystems because of unicode normalisation.
    postFetch = ''
      rm -r $out/tests/fixtures
    '';
  };

  cargoHash = "sha256-h4Z0Gb4lf/KXrBxU6gEGcRvuhqjUABsggcv/A+AFclo=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
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
