{ stdenv, fetchurl, alsaLib, dbus, expat, libsamplerate
, libsndfile, makeWrapper, pkgconfig, python, pythonDBus
, firewireSupport ? false, ffado ? null, bash }:

assert firewireSupport -> ffado != null;

stdenv.mkDerivation rec {
  name = "jack2-${version}";
  version = "1.9.10";

  src = fetchurl {
    urls = [
      https://github.com/jackaudio/jack2/archive/v1.9.10.tar.gz
    ];
    sha256 = "03b0iiyk3ng3vh5s8gaqwn565vik7910p56mlbk512bw3dhbdwc8";
  };

  buildInputs =
    [ alsaLib dbus expat libsamplerate libsndfile makeWrapper
      pkgconfig python pythonDBus
    ] ++ (stdenv.lib.optional firewireSupport ffado);

  patchPhase = ''
    substituteInPlace svnversion_regenerate.sh --replace /bin/bash ${bash}/bin/bash
  '';

  configurePhase = ''
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
