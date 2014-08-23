{ composableDerivation, stdenv, fetchurl, alsaLib, jack2, ncurses }:

let inherit (composableDerivation) edf; in

composableDerivation.composableDerivation {} {

  name = "timidity-2.13.0";

  src = fetchurl {
    url = mirror://sourceforge/timidity/TiMidity++-2.13.0.tar.bz2;
    sha256 = "1jbmk0m375fh5nj2awqzns7pdjbi7dxpjdwcix04zipfcilppbmf";
  };

  mergeAttrBy.audioModes = a : b : "${a},${b}";

  preConfigure = ''
    configureFlags="$configureFlags --enable-audio=$audioModes"
  '';

  # configure still has many more options...
  flags = {
    oss = {
      audioModes = "oss";
    };
    alsa = {
      audioModes = "alsa";
      buildInputs = [alsaLib];
      # this is better than /dev/dsp !
      configureFlags = ["--with-default-output-mode=alsa"];
    };
    jack = {
      audioModes = "jack";
      buildInputs = [jack2];
      NIX_LDFLAGS = ["-ljack -L${jack2}/lib64"];
    };
  } // edf { name = "ncurses"; enable = { buildInputs = [ncurses]; };};

  cfg = {
    ncursesSupport = true;

    ossSupport = true;
    alsaSupport = true;
    jackSupport = true;
  };

  instruments = fetchurl {
    url = http://www.csee.umbc.edu/pub/midia/instruments.tar.gz;
    sha256 = "0lsh9l8l5h46z0y8ybsjd4pf6c22n33jsjvapfv3rjlfnasnqw67";
  };

  # the instruments could be compressed (?)
  postInstall = ''
    mkdir -p $out/share/timidity/;
    cp ${./timidity.cfg} $out/share/timidity/timidity.cfg
    tar --strip-components=1 -xf $instruments -C $out/share/timidity/
  '';

  meta = {
    description = "A software MIDI renderer";
    maintainers = [ stdenv.lib.maintainers.marcweber ];
  };
}
