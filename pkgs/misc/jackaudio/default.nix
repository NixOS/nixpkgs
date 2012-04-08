{ stdenv, fetchurl, alsaLib, dbus, expat, libsamplerate
, libsndfile, makeWrapper, pkgconfig, python, pythonDBus
, firewireSupport ? false, ffado ? null }:

assert firewireSupport -> ffado != null;

stdenv.mkDerivation rec {
  name = "jackdbus-${version}";
  version = "1.9.8";

  src = fetchurl {
    url = "http://www.grame.fr/~letz/jack-1.9.8.tgz";
    sha256 = "0788092zxrivcfnfg15brpjkf14x8ma8cwjz4k0b9xdxajn2wwac";
  };

  buildInputs =
    [ alsaLib dbus expat libsamplerate libsndfile makeWrapper
      pkgconfig python pythonDBus
    ] ++ (stdenv.lib.optional firewireSupport ffado);

  configurePhase = ''
    cd jack-1.9.8
    python waf configure --prefix=$out --dbus --alsa ${if firewireSupport then "--firewire" else ""}
  '';

  buildPhase = "python waf build";

  installPhase = ''
    python waf install
    wrapProgram $out/bin/jack_control --set PYTHONPATH $PYTHONPATH
  '';

  meta = with stdenv.lib; {
    description = "JACK audio connection kit, version 2 with jackdbus";
    homepage = "http://jackaudio.org";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
