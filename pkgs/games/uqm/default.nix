{stdenv, fetchurl 
, pkgconfig, mesa
, SDL, SDL_image, libpng, zlib, libvorbis, libogg, libmikmod, unzip
}:

stdenv.mkDerivation rec {
  name = "uqm-${version}";
  version = "0.7.0";

  src = fetchurl {
    url = "mirror://sourceforge/sc2/uqm-${version}-source.tgz";
    sha256 = "a3695c5f7f0be7ec9c0f80ec569907b382023a1fee6e635532bd53b7b53bb221";
  };

  content = fetchurl {
    url = "mirror://sourceforge/sc2/uqm-${version}-content.uqm";
    sha256 = "b8f6db8ba29f0628fb1d5c233830896b19f441aee3744bda671ea264b44da3bf";
  };

  voice = fetchurl {
    url = "mirror://sourceforge/sc2/uqm-${version}-voice.uqm";
    sha256 = "bcccf801b4ba37594ff6217b292744ea586ee2d447e927804842ccae8b73c979";
  };

  music = fetchurl {
    url = "mirror://sourceforge/sc2/uqm-${version}-3domusic.uqm";
    sha256 = "c57085e64dad4bddf8a679a9aa2adf63f2156d5f6cbabe63af80519033dbcb82";
  };


 /* uses pthread_cancel(), which requires libgcc_s.so.1 to be
    loadable at run-time. Adding the flag below ensures that the
    library can be found. Obviously, though, this is a hack. */
  NIX_LDFLAGS="-lgcc_s";

  buildInputs = [SDL SDL_image libpng libvorbis libogg libmikmod unzip pkgconfig mesa];

  postUnpack = ''
    mkdir -p uqm-${version}/content/packages
    mkdir -p uqm-${version}/content/addons
    cp $content uqm-${version}/content/packages/uqm-0.7.0-content.uqm
    cp $music uqm-${version}/content/addons/uqm-0.7.0-3domusic.uqm
    cp $voice uqm-${version}/content/addons/uqm-0.7.0-voice.uqm
    '';

  /* uqm has a 'unique' build system with a root script incidentally called
 * 'build.sh'. */

  configurePhase = ''
    echo "INPUT_install_prefix_VALUE='$out'" >> config.state
    echo "INPUT_install_bindir_VALUE='$out/bin'" >> config.state
    echo "INPUT_install_libdir_VALUE='$out/lib'" >> config.state
    echo "INPUT_install_sharedir_VALUE='$out/share'" >> config.state
    PREFIX=$out ./build.sh uqm config
    ''; 

  buildPhase = ''
    ./build.sh uqm
    '';

  installPhase = ''
    ./build.sh uqm install
    sed -i $out/bin/uqm -e "s%/usr/local/games/%$out%g"
    '';

  meta = {
    description = "Remake of Star Control II";
    longDescription = ''
    The goals for the The Ur-Quan Masters project are:
      - to bring Star Control II to modern platforms, thereby making a lot of people happy
      - to make game translations easy, thereby making even more people happy
      - to adapt the code so that people can more easily make their own spin-offs, thereby making zillions more people happy!
    '';
    homepage = http://sc2.sourceforge.net/;
    license = "GPLv2";
    maintainers = with stdenv.lib.maintainers; [ jcumming ];
  };
}
