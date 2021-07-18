{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "du-dust";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "bootandy";
    repo = "dust";
    rev = "v${version}";
    sha256 = "sha256-15n8CpyyC41oJRrFlNHYXF5UjOyYPX93Zrq7jcU2DVM=";
    # Remove unicode file names which leads to different checksums on HFS+
    # vs. other filesystems because of unicode normalisation.
    extraPostFetch = ''
      rm -r $out/tests/test_dir_unicode/
    '';
  };

  cargoSha256 = "sha256-rqNj3EwszSIn2cMmslO6T3K5NxQJ9u56m37TU1GwtVI=";

  doCheck = false;

  meta = with lib; {
    description = "du + rust = dust. Like du but more intuitive";
    homepage = "https://github.com/bootandy/dust";
    license = licenses.asl20;
    maintainers = with maintainers; [ infinisil SuperSandro2000 ];
    mainProgram = "dust";
  };
}
