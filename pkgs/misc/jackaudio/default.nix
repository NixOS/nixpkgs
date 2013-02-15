{ stdenv, fetchurl, alsaLib, dbus, expat, libsamplerate
, libsndfile, makeWrapper, pkgconfig, python, pythonDBus
, firewireSupport ? false, ffado ? null, bash }:

assert firewireSupport -> ffado != null;

stdenv.mkDerivation rec {
  name = "jackdbus-${version}";
  version = "1.9.9.5";

  src = fetchurl {
    urls = [
      https://dl.dropbox.com/u/28869550/jack-1.9.9.5.tar.bz2
    ];
    sha256 = "1ggba69jsfg7dmjzlyqz58y2wa92lm3vwdy4r15bs7mvxb65mvv5";
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
