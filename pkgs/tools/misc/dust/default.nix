{ stdenv, lib, fetchFromGitHub, rustPlatform, AppKit }:

rustPlatform.buildRustPackage rec {
  pname = "du-dust";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "bootandy";
    repo = "dust";
    rev = "v${version}";
    sha256 = "sha256-g1i003nBbTYIuKG4ZCQSoI8gINTVc8BKRoO3UOeHOGE=";
    # Remove unicode file names which leads to different checksums on HFS+
    # vs. other filesystems because of unicode normalisation.
    postFetch = ''
      rm -r $out/tests/test_dir_unicode/
    '';
  };

  cargoHash = "sha256-jtQ/nkD5XMD2rsq550XsRK416wOCR3OuhgGPeuC3jzc=";

  buildInputs = lib.optionals stdenv.isDarwin [ AppKit ];

  doCheck = false;

  meta = with lib; {
    description = "du + rust = dust. Like du but more intuitive";
    homepage = "https://github.com/bootandy/dust";
    license = licenses.asl20;
    maintainers = with maintainers; [ infinisil SuperSandro2000 ];
    mainProgram = "dust";
  };
}
