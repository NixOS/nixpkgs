{ stdenv, fetchurl, alsaLib, dbus, expat, libsamplerate
, libsndfile, makeWrapper, pkgconfig, python, pythonDBus
, firewireSupport ? false, ffado ? null }:

assert firewireSupport -> ffado != null;

stdenv.mkDerivation rec {
  name = "jackdbus-${version}";
  version = "1.9.8";

  src = fetchurl {
    urls = [
      "http://pkgs.fedoraproject.org/lookaside/pkgs/jack-audio-connection-kit/jack-1.9.8.tgz/1dd2ff054cab79dfc11d134756f27165/jack-1.9.8.tgz"
      "http://www.grame.fr/~letz/jack-1.9.8.tgz"
    ];
    sha256 = "0788092zxrivcfnfg15brpjkf14x8ma8cwjz4k0b9xdxajn2wwac";
  };

  buildInputs =
    [ alsaLib dbus expat libsamplerate libsndfile makeWrapper
      pkgconfig python pythonDBus
    ] ++ (stdenv.lib.optional firewireSupport ffado);

  patches = ./ffado_setbuffsize-jack2.patch;

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
