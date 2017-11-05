{stdenv, fetchurl, autoreconfHook}:
stdenv.mkDerivation {
  name = "pwgen-2.08";

  src = fetchurl {
    url = https://github.com/tytso/pwgen/archive/v2.08.tar.gz;
    sha256 = "8d6e94f28655e61d6126290e3eafad4d17d7fba0d0d354239522a740a270bb2f";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    description = "Password generator which creates passwords which can be easily memorized by a human";
    platforms = stdenv.lib.platforms.all;
  };
}
