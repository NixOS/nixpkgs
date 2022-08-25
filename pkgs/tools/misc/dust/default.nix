{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "du-dust";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "bootandy";
    repo = "dust";
    rev = "v${version}";
    sha256 = "sha256-ZPIxJ8D8yxaL7RKIVKIIlqwUXBbVM0JprE5TSTGkhfI=";
    # Remove unicode file names which leads to different checksums on HFS+
    # vs. other filesystems because of unicode normalisation.
    postFetch = ''
      rm -r $out/tests/test_dir_unicode/
    '';
  };

  cargoSha256 = "sha256-dgAyxSVNe+UKuT0UJqPvYcrLolKtC2+EN/okSvzkhcA=";

  doCheck = false;

  meta = with lib; {
    description = "du + rust = dust. Like du but more intuitive";
    homepage = "https://github.com/bootandy/dust";
    license = licenses.asl20;
    maintainers = with maintainers; [ infinisil SuperSandro2000 ];
    mainProgram = "dust";
  };
}
