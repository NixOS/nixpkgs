{ lib, stdenv, rustPlatform, fetchFromGitHub, libiconv, Foundation }:

rustPlatform.buildRustPackage rec {
  pname = "dua";
  version = "2.17.1";

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Foundation ];

  src = fetchFromGitHub {
    owner = "Byron";
    repo = "dua-cli";
    rev = "v${version}";
    sha256 = "sha256-58l0E5wwRKbF/ja3fmMMBIONjuwVOxlwdKRT5BeO9MQ=";
    # Remove unicode file names which leads to different checksums on HFS+
    # vs. other filesystems because of unicode normalisation.
    extraPostFetch = ''
      rm -r $out/tests/fixtures
    '';
  };

  cargoSha256 = "sha256-nft0wrgTMrI8Tav6NcqPwSF8Q367twIOr1voBsW2488=";

  doCheck = false;

  meta = with lib; {
    description = "A tool to conveniently learn about the disk usage of directories, fast!";
    homepage = "https://github.com/Byron/dua-cli";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ killercup ];
  };
}
