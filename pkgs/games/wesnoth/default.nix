args: with args;
stdenv.mkDerivation (rec {
  pname = "wesnoth";
  version = "1.4";

  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://surfnet.dl.sourceforge.net/sourceforge/${pname}/${name}.tar.bz2";
    sha256 = "67ad0509567d9496f15f1a3888c9e2001776411ffdd7007bdb8f324cdce5895d";
  };

  buildInputs = [SDL SDL_image SDL_mixer SDL_net gettext zlib boost freetype];

  configureFlags = "--with-preferences-dir=.${name} --program-suffix=-${version} --with-datadir-name=${name} --with-boost=${boost}/include --disable-python";

  meta = {
    description = "
      The Battle for Wesnoth  is a free, turn-based strategy game with a fantasy theme.
";
  };
})
