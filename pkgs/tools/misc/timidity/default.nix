{ composableDerivation, stdenv, fetchurl, alsaLib, libjack2, ncurses }:

let inherit (composableDerivation) edf; in

composableDerivation.composableDerivation {} {

  name = "timidity-2.14.0";

  src = fetchurl {
    url = mirror://sourceforge/timidity/TiMidity++-2.14.0.tar.bz2;
    sha256 = "0xk41w4qbk23z1fvqdyfblbz10mmxsllw0svxzjw5sa9y11vczzr";
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
      buildInputs = [libjack2];
      NIX_LDFLAGS = ["-ljack -L${libjack2}/lib"];
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

  meta = with stdenv.lib; {
    homepage = http://sourceforge.net/projects/timidity/;
    license = licenses.gpl2;
    description = "A software MIDI renderer";
    maintainers = [ maintainers.marcweber ];
    platforms = platforms.linux;
  };
}
