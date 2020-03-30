{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "dua";
  version = "2.3.8";

  src = fetchFromGitHub {
    owner = "Byron";
    repo = "dua-cli";
    rev = "v${version}";
    sha256 = "0ql74z24qp68m3ivzmxdijafrhpwjgs462chrxd021n9nl7mqhss";
    # Remove unicode file names which leads to different checksums on HFS+
    # vs. other filesystems because of unicode normalisation.
    extraPostFetch = ''
      rm -r $out/tests/fixtures
    '';
  };

  cargoSha256 = "0c0d9qi7v3s7vf1rzd467w56i9zdh8fqqrmkkk6xxyh5xhkqx0kd";

  doCheck = false;

  meta = with lib; {
    description = "A tool to conveniently learn about the disk usage of directories, fast!";
    homepage = "https://github.com/Byron/dua-cli";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ killercup ];
    platforms = platforms.all;
  };
}
