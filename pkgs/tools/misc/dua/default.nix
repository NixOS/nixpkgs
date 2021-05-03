{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "dua";
  version = "2.11.2";

  src = fetchFromGitHub {
    owner = "Byron";
    repo = "dua-cli";
    rev = "v${version}";
    sha256 = "sha256-sT4hg5MC6xuhSKeNxaVY9vOlMEx23uwxgK6UMLO4kVs=";
    # Remove unicode file names which leads to different checksums on HFS+
    # vs. other filesystems because of unicode normalisation.
    extraPostFetch = ''
      rm -r $out/tests/fixtures
    '';
  };

  cargoSha256 = "sha256-DOotIN8XScgHR9L6aFgky2B18piGIKfLWx1GTdYnCB0=";

  doCheck = false;

  meta = with lib; {
    description = "A tool to conveniently learn about the disk usage of directories, fast!";
    homepage = "https://github.com/Byron/dua-cli";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ killercup ];
  };
}
