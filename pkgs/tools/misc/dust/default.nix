{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "dust";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "bootandy";
    repo = "dust";
    rev = "v${version}";
    sha256 = "1l5fh7yl8mbgahvzfa251cyp8j5awqdl66jblz565b1wb536kig7";
    # Remove unicode file names which leads to different checksums on HFS+
    # vs. other filesystems because of unicode normalisation.
    extraPostFetch = ''
      rm -rf $out/src/test_dir3/
    '';
  };

  cargoSha256 = "1sjzcawyg1xsi4xrx2zwnj8yavzph8k1wgxsffgp55wghzypafwl";

  doCheck = false;

  meta = with stdenv.lib; {
    description = "du + rust = dust. Like du but more intuitive";
    homepage = "https://github.com/bootandy/dust";
    license = licenses.asl20;
    maintainers = [ maintainers.infinisil ];
    platforms = platforms.all;
  };
}
