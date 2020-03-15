{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "du-dust";
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

  cargoSha256 = "0s8z8cg9q0gfqm0ann8rkxwp5y25si97kgginh6b6lbnaai7y4fj";

  doCheck = false;

  meta = with stdenv.lib; {
    description = "du + rust = dust. Like du but more intuitive";
    homepage = "https://github.com/bootandy/dust";
    license = licenses.asl20;
    maintainers = [ maintainers.infinisil ];
    platforms = platforms.all;
  };
}
