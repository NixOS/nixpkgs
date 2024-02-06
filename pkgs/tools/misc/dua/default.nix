{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "dua";
  version = "2.26.0";

  src = fetchFromGitHub {
    owner = "Byron";
    repo = "dua-cli";
    rev = "v${version}";
    hash = "sha256-+7pf87mmT5KB4KtKzZXYnV6GwMzb6ieXjBVZpvmQ3eU=";
    # Remove unicode file names which leads to different checksums on HFS+
    # vs. other filesystems because of unicode normalisation.
    postFetch = ''
      rm -r $out/tests/fixtures
    '';
  };

  cargoHash = "sha256-5n6zjuoL5v3ieP8eOzvyJf/YDmQ+MuGMk3T/8rHKQVE=";

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
