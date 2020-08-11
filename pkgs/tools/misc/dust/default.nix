{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "du-dust";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "bootandy";
    repo = "dust";
    rev = "v${version}";
    sha256 = "181xlm0zj9pb73ijwf202kwwm2jji0m11ynsbaxl44alva3xpvmk";
    # Remove unicode file names which leads to different checksums on HFS+
    # vs. other filesystems because of unicode normalisation.
    extraPostFetch = ''
      rm -rf $out/src/test_dir3/
    '';
  };

  cargoSha256 = "1ypphm9n6wri5f03fj65i5p6lb11qj5zp8ddvybanaypv5llkfcb";

  doCheck = false;

  meta = with stdenv.lib; {
    description = "du + rust = dust. Like du but more intuitive";
    homepage = "https://github.com/bootandy/dust";
    license = licenses.asl20;
    maintainers = [ maintainers.infinisil ];
    platforms = platforms.all;
  };
}
