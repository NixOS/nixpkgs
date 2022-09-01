{ stdenv, lib, fetchFromGitHub, rustPlatform, AppKit }:

rustPlatform.buildRustPackage rec {
  pname = "du-dust";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "bootandy";
    repo = "dust";
    rev = "v${version}";
    sha256 = "sha256-+YcHiW4kR4JeIY6zv1WJ97dCIakvtbn8+b9tLFH+aLE=";
    # Remove unicode file names which leads to different checksums on HFS+
    # vs. other filesystems because of unicode normalisation.
    postFetch = ''
      rm -r $out/tests/test_dir_unicode/
    '';
  };

  cargoSha256 = "sha256-yKj9CBoEC6UJf4L+XO2qi69//45lSqblMe8ofnLctEw=";

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
