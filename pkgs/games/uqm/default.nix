{ stdenv, lib, fetchurl, fetchFromGitHub, pkg-config, libGLU, libGL
, SDL, SDL_image, libpng, libvorbis, libogg, libmikmod

, use3DOVideos ? false, requireFile ? null, writeText ? null
, haskellPackages ? null

, useRemixPacks ? false
}:

assert use3DOVideos -> requireFile != null && writeText != null
                    && haskellPackages != null;

let
  videos = import ./3dovideo.nix {
    inherit stdenv lib requireFile writeText fetchFromGitHub haskellPackages;
  };

  remixPacks = lib.imap1 (num: sha256: fetchurl rec {
    name = "uqm-remix-disc${toString num}.uqm";
    url = "mirror://sourceforge/sc2/${name}";
    inherit sha256;
  }) [
    "1s470i6hm53l214f2rkrbp111q4jyvnxbzdziqg32ffr8m3nk5xn"
    "1pmsq65k8gk4jcbyk3qjgi9yqlm0dlaimc2r8hz2fc9f2124gfvz"
    "07g966ylvw9k5q9jdzqdczp7c5qv4s91xjlg4z5z27fgcs7rzn76"
    "1l46k9aqlcp7d3fjkjb3n05cjfkxx8rjlypgqy0jmdx529vikj54"
  ];

in stdenv.mkDerivation rec {
  pname = "uqm";
  version = "0.7.0";

  src = fetchurl {
    url = "mirror://sourceforge/sc2/uqm-${version}-source.tgz";
    sha256 = "08dj7fsvflxx69an6vpf3wx050mk0ycmdv401yffrrqbgxgmqsd3";
  };

  content = fetchurl {
    url = "mirror://sourceforge/sc2/uqm-${version}-content.uqm";
    sha256 = "1gx39ns698hyczd4nx73mr0z86bbi4q3h8sw3pxjh1lzla5xpxmq";
  };

  voice = fetchurl {
    url = "mirror://sourceforge/sc2/uqm-${version}-voice.uqm";
    sha256 = "0yf9ff5sxk229202gsa7ski6wn7a8hkjjyr1yr7mjdxsnh0zik5w";
  };

  music = fetchurl {
    url = "mirror://sourceforge/sc2/uqm-${version}-3domusic.uqm";
    sha256 = "10nbvcrr0lc0mxivxfkcbxnibwk3vwmamabrlvwdsjxd9pk8aw65";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ SDL SDL_image libpng libvorbis libogg libmikmod libGLU libGL ];

  postUnpack = ''
    mkdir -p uqm-${version}/content/packages
    mkdir -p uqm-${version}/content/addons
    ln -s "$content" "uqm-${version}/content/packages/uqm-0.7.0-content.uqm"
    ln -s "$music" "uqm-${version}/content/addons/uqm-0.7.0-3domusic.uqm"
    ln -s "$voice" "uqm-${version}/content/addons/uqm-0.7.0-voice.uqm"
  '' + lib.optionalString useRemixPacks (lib.concatMapStrings (disc: ''
    ln -s "${disc}" "uqm-$version/content/addons/${disc.name}"
  '') remixPacks) + lib.optionalString use3DOVideos ''
    ln -s "${videos}" "uqm-${version}/content/addons/3dovideo"
  '';

  postPatch = ''
    # Using _STRINGS_H as include guard conflicts with glibc.
    sed -i -e '/^#/s/_STRINGS_H/_UQM_STRINGS_H/g' src/uqm/comm/*/strings.h
    # See https://github.com/NixOS/nixpkgs/pull/93560
    sed -i -e 's,/tmp/,$TMPDIR/,' build/unix/config_functions
  '';

  # uqm has a 'unique' build system with a root script incidentally called
  # 'build.sh'.
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
        - to bring Star Control II to modern platforms, thereby making a lot of
          people happy
        - to make game translations easy, thereby making even more people happy
        - to adapt the code so that people can more easily make their own
          spin-offs, thereby making zillions more people happy!
    '';
    homepage = "http://sc2.sourceforge.net/";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ jcumming aszlig ];
    platforms = with lib.platforms; linux;
  };
}
