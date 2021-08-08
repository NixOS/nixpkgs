{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "du-dust";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "bootandy";
    repo = "dust";
    rev = "v${version}";
    sha256 = "sha256-5GhoL3by4sXhFJrNZi/UlERBa+s2oqDVVJODY0kdfxI=";
    # Remove unicode file names which leads to different checksums on HFS+
    # vs. other filesystems because of unicode normalisation.
    extraPostFetch = ''
      rm -r $out/tests/test_dir_unicode/
    '';
  };

  cargoSha256 = "sha256-cgH3jrZPGUHiBDeJ9qj80dU+Vbz+wHMOsCaGAvJY6mg=";

  doCheck = false;

  meta = with lib; {
    description = "du + rust = dust. Like du but more intuitive";
    homepage = "https://github.com/bootandy/dust";
    license = licenses.asl20;
    maintainers = with maintainers; [ infinisil SuperSandro2000 ];
    mainProgram = "dust";
  };
}
