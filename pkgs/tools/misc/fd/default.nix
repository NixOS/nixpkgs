{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name = "fd-${version}";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "fd";
    rev = "v${version}";
    sha256 = "1xs4y9zf5m0ykl95787jv98xg0a60gkcyyh7kg7qg4xrcgf4qz4j";
  };

  depsSha256 = "1hxf3j4584jgpwrwykx6yil6q6ka9l81qvx6zrbprdxk3pslp049";

  meta = {
    description = "A simple, fast and user-friendly alternative to find";
    longDescription = ''
      `fd` is a simple, fast and user-friendly alternative to `find`.

      While it does not seek to mirror all of `find`'s powerful functionality,
      it provides sensible (opinionated) defaults for 80% of the use cases.
    '';
    homepage = "https://github.com/sharkdp/fd";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
  };
}
