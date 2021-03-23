{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "dua";
  version = "2.11.1";

  src = fetchFromGitHub {
    owner = "Byron";
    repo = "dua-cli";
    rev = "v${version}";
    sha256 = "sha256-pjFApZQJqw0fJmJteO7VZWRLogV3rO5XDagZd1MliZg=";
    # Remove unicode file names which leads to different checksums on HFS+
    # vs. other filesystems because of unicode normalisation.
    extraPostFetch = ''
      rm -r $out/tests/fixtures
    '';
  };

  cargoSha256 = "sha256-xsTScRAu0SF1xtjUwBtNJUNIItoR0jjEd2CuSmmeh9c=";

  doCheck = false;

  meta = with lib; {
    description = "A tool to conveniently learn about the disk usage of directories, fast!";
    homepage = "https://github.com/Byron/dua-cli";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ killercup ];
  };
}
