args: with args;
stdenv.mkDerivation (rec {
  pname = "wesnoth";
  version = "1.3.18";

  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://surfnet.dl.sourceforge.net/sourceforge/${pname}/${name}.tar.bz2";
    sha256 = "ab2ed2cbe1daa134c453927bf0ec5d3a36f3319063b6f18c35819871f386da75";
  };

  buildInputs = [SDL SDL_image SDL_mixer SDL_net gettext zlib boost freetype];

  configureFlags = "--with-preferences-dir=.${name} --program-suffix=-${version} --with-datadir-name=${name} --with-boost=${boost}/include --disable-python";

  meta = {
    description = "
      The Battle for Wesnoth  is a free, turn-based strategy game with a fantasy theme.
";
  };
})
