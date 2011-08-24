{ stdenv, fetchurl, pkgconfig, alsaLib, python, dbus, pythonDBus, expat, makeWrapper }:

stdenv.mkDerivation rec {
  name = "jackdbus-${version}";
  version = "1.9.7";

  src = fetchurl {
    url = "http://www.grame.fr/~letz/jack-1.9.7.tar.bz2";
    sha256 = "01gcn82bb7xnbcsd2ispbav6lwm0il4g8rs2mbaqpcrf9nnmfvq9";
  };

  buildInputs = [ pkgconfig alsaLib python dbus pythonDBus expat makeWrapper ];

  configurePhase = "python waf configure --prefix=$out --dbus --alsa";

  buildPhase = "python waf";

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
