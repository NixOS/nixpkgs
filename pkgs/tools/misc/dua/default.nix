{ lib, stdenv, rustPlatform, fetchFromGitHub, libiconv, Foundation }:

rustPlatform.buildRustPackage rec {
  pname = "dua";
  version = "2.14.2";

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Foundation ];

  src = fetchFromGitHub {
    owner = "Byron";
    repo = "dua-cli";
    rev = "v${version}";
    sha256 = "sha256-gUTDiUH/jlGAGbhOOCa63wfNy5Y8W6VWlSb9E+hQjHY=";
    # Remove unicode file names which leads to different checksums on HFS+
    # vs. other filesystems because of unicode normalisation.
    extraPostFetch = ''
      rm -r $out/tests/fixtures
    '';
  };

  cargoSha256 = "sha256-P8QFeP5KD5YeD4Px7OQNwCrvErgT9ytr4OlFkXuPgGU=";

  doCheck = false;

  meta = with lib; {
    description = "A tool to conveniently learn about the disk usage of directories, fast!";
    homepage = "https://github.com/Byron/dua-cli";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ killercup ];
  };
}
