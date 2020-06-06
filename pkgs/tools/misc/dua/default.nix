{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "dua";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "Byron";
    repo = "dua-cli";
    rev = "v${version}";
    sha256 = "0wq6cqznbpkiy9vz3slpcnxlsxff6gx5x7fsbd67q6jv5zhkn881";
    # Remove unicode file names which leads to different checksums on HFS+
    # vs. other filesystems because of unicode normalisation.
    extraPostFetch = ''
      rm -r $out/tests/fixtures
    '';
  };

  cargoSha256 = "096c6i1hqyygaifnm2kg53x22a8hhfxfz22qlssh1rw79bj82q0x";

  doCheck = false;

  meta = with lib; {
    description = "A tool to conveniently learn about the disk usage of directories, fast!";
    homepage = "https://github.com/Byron/dua-cli";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ killercup ];
    platforms = platforms.all;
  };
}
