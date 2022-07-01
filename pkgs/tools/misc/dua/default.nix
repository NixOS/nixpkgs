{ lib, stdenv, rustPlatform, fetchFromGitHub, libiconv, Foundation }:

rustPlatform.buildRustPackage rec {
  pname = "dua";
  version = "2.17.7";

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Foundation ];

  src = fetchFromGitHub {
    owner = "Byron";
    repo = "dua-cli";
    rev = "v${version}";
    sha256 = "sha256-FiTjN4coOJZ3Uu9LfaJxcpvVKS+5MVYWQPmwllBh1Jg=";
    # Remove unicode file names which leads to different checksums on HFS+
    # vs. other filesystems because of unicode normalisation.
    postFetch = ''
      rm -r $out/tests/fixtures
    '';
  };

  cargoSha256 = "sha256-xCHbS+D7ss85hklv9xftJTsctvQlAjkKtuJbTt5R8nM=";

  doCheck = false;

  meta = with lib; {
    description = "A tool to conveniently learn about the disk usage of directories, fast!";
    homepage = "https://github.com/Byron/dua-cli";
    changelog = "https://github.com/Byron/dua-cli/raw/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ killercup ];
  };
}
