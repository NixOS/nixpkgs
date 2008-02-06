args: with args;
stdenv.mkDerivation (rec {
  pname = "wesnoth";
  version = "1.3.15";

  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://surfnet.dl.sourceforge.net/sourceforge/${pname}/${name}.tar.bz2";
    sha256 = "5c5c723bdef0b9872a20a4ee11365f050251baed375ee951db726bf82401766e";
  };

  buildInputs = [SDL SDL_image SDL_mixer SDL_net gettext zlib boost freetype];

  configureFlags = "--with-preferences-dir=.${name} --program-suffix=-${version} --with-datadir-name=${name} --with-boost=${boost}/include --disable-python";

  meta = {
    description = "
      The Battle for Wesnoth  is a free, turn-based strategy game with a fantasy theme.
";
  };
})
