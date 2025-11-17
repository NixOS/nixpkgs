{
  lib,
  stdenv,
  fetchFromGitHub,
  lilypond,
}:

let

  olpFont =
    {
      fontName,
      rev,
      sha256,
      version ? rev,
      ...
    }:
    stdenv.mkDerivation {
      inherit version;
      pname = "openlilypond-font-${fontName}";

      src = fetchFromGitHub {
        inherit rev sha256;
        owner = "OpenLilyPondFonts";
        repo = fontName;
      };

      installPhase = ''
        local fontsdir="$out/share/lilypond/${lilypond.version}/fonts"

        install -m755 -d "$fontsdir/otf"

        shopt -s globstar

        for font in {otf,supplementary-fonts,supplementary-files}/**/*.{o,t}tf; do
          echo $font
          install -Dt "$fontsdir/otf" -m644 "$font"
        done

        install -m755 -d "$fontsdir/svg"
        for font in {svg,woff}/**.{svg,woff}; do
          install -Dt "$fontsdir/svg" -m644 "$font"
        done
      '';

      meta = with lib; {
        inherit (lilypond.meta) homepage platforms;
        description = "${fontName} font for LilyPond";
        license = licenses.ofl;
        maintainers = with maintainers; [ yurrriq ];
      };
    };

in

rec {
  beethoven = olpFont {
    fontName = "beethoven";
    rev = "669f400";
    sha256 = "17wdklg5shmqwnb7b81qavfg52v32wx5yf15c6al0hbvv1nqqj2i";
  };
  bravura = olpFont {
    fontName = "bravura";
    rev = "53c7744";
    sha256 = "1p27w1c3bzxlnm6rzq8n7dbfjwbxqjy4r0fhkmk9jbm8awmzw214";
  };
  cadence = olpFont {
    fontName = "cadence";
    rev = "1cc0fb7";
    sha256 = "1zxb3m8glh8iwj8mzcgyaxhlq0bji0rwniw702m70h9kpifiim1j";
  };
  gonville = olpFont {
    fontName = "gonville";
    rev = "a638bc9";
    sha256 = "15khy9677crgd6bpajn7l1drysgxy49wiym3b248khgpavidwyy9";
  };
  gutenberg1939 = olpFont {
    fontName = "gutenberg1939";
    rev = "2316a35";
    sha256 = "1lkhivmrx92z37zfrb5mkhzhwggyaga9cm0wl89r0n2f2kayyc7q";
  };
  haydn = olpFont {
    fontName = "haydn";
    rev = "9e7de8b";
    sha256 = "1jmbhb2jm887sdc498l2jilpivq1d8lmmgdb8lp59lv8d9fx105z";
  };
  improviso = olpFont {
    fontName = "improviso";
    rev = "0753f5a";
    sha256 = "1clin9c74gjhhira12mwxynxn4b1ixij5bg04mvk828lbr740mfm";
  };
  lilyboulez = olpFont {
    fontName = "lilyboulez";
    rev = "e8455fc";
    sha256 = "0mq92x0rbgfb6s7ipgg2zcxika2si30w3ay89rp7m6vwca01649y";
  };
  lilyjazz = olpFont {
    fontName = "lilyjazz";
    rev = "8fa7d554";
    sha256 = "1z7px7k2sn7snnj7yfjv0p9axwbn452vn9ww9icmb1249b0d1qry";
  };
  lv-goldenage = olpFont {
    fontName = "lv-goldenage";
    rev = "8a92fd3";
    sha256 = "03nbd1vmlaj7wkhsnl2lq09nafv7zj1k518zs966vclzah94qghp";
  };
  paganini = olpFont {
    fontName = "paganini";
    rev = "8e4e55a";
    sha256 = "0gw9wr4hfn205j40rpgnfddhzhn9x4pwfinamj5b7607880nvx29";
  };
  profondo = olpFont {
    fontName = "profondo";
    rev = "8cfb668";
    sha256 = "0armwbg9y0l935949b7klngws6fq42fi944lws61qvjl61780br8";
  };
  ross = olpFont {
    fontName = "ross";
    rev = "aa8127f";
    sha256 = "1w2x3pd1d1z4x0107dpq95v7m547cj4nkkzxgqpmzfqa0074idqd";
  };
  scorlatti = olpFont {
    fontName = "scorlatti";
    rev = "1db87da";
    sha256 = "07jam5hwdy6bydrm98cdla6p6rl8lmy8zzsfq46i55l64l3w956h";
  };
  sebastiano = olpFont {
    fontName = "sebastiano";
    rev = "44bf262";
    sha256 = "09i8p3p4z6vz69j187cpxvikkgc4pk6gxippahy0k7i7bh0d4qaj";
  };

  all = [
    beethoven
    bravura
    cadence
    gonville
    gutenberg1939
    haydn
    improviso
    lilyboulez
    lilyjazz
    lv-goldenage
    paganini
    profondo
    ross
    scorlatti
    sebastiano
  ];
}
