args: with args;
stdenv.mkDerivation (rec {
  pname = "wesnoth";
  version = "1.3.16";

  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://surfnet.dl.sourceforge.net/sourceforge/${pname}/${name}.tar.bz2";
    sha256 = "b963fa5db93d7aebc886178f589d69a4b015803938b87ce996ff57f1643a385a";
  };

  buildInputs = [SDL SDL_image SDL_mixer SDL_net gettext zlib boost freetype];

  configureFlags = "--with-preferences-dir=.${name} --program-suffix=-${version} --with-datadir-name=${name} --with-boost=${boost}/include --disable-python";

  meta = {
    description = "
      The Battle for Wesnoth  is a free, turn-based strategy game with a fantasy theme.
";
  };
})
