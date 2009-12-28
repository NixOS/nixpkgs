args: with args;

stdenv.mkDerivation rec {
  pname = "wesnoth";
  version = "1.6.5";

  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/sourceforge/${pname}/${name}.tar.bz2";
    sha256 = "1mrhgwp8iw27ifpavnf4y69zf9fqfy7j4sfwkfzsay226sp4gw3y";
  };

  buildInputs = [SDL SDL_image SDL_mixer SDL_net SDL_ttf pango gettext zlib boost freetype libpng pkgconfig];

  configureFlags = "--with-preferences-dir=.${name} --program-suffix=-${version} --with-datadir-name=${name} --with-boost=${boost}/include --disable-python";

  meta = {
    description = "The Battle for Wesnoth, a free, turn-based strategy game with a fantasy theme";
  };
}
