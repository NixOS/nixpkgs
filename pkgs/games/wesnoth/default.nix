args: with args;

stdenv.mkDerivation rec {
  pname = "wesnoth";
  version = "1.4.1";

  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://surfnet.dl.sourceforge.net/sourceforge/${pname}/${name}.tar.bz2";
    sha256 = "c5b7b478553dc8994d99024e14b48b3f64e2c328631bd5b05904509b499fa68c";
  };

  buildInputs = [SDL SDL_image SDL_mixer SDL_net gettext zlib boost freetype];

  configureFlags = "--with-preferences-dir=.${name} --program-suffix=-${version} --with-datadir-name=${name} --with-boost=${boost}/include --disable-python";

  meta = {
    description = "The Battle for Wesnoth, a free, turn-based strategy game with a fantasy theme";
  };
}
