{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name = "fd-${version}";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "fd";
    rev = "v${version}";
    sha256 = "1aw4pgsmvzzqlvbxzv5jnw42nf316qfhvr50b58iqi2dxy8z8cmv";
  };

  cargoSha256 = "1v9wg4dq4c7i85bkdhd79bj8gx7200z6np05wsyj2ycbv97p095j";

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
