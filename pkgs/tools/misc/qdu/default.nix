{stdenv, fetchurl, qt3, libXext, libX11}:
stdenv.mkDerivation {
  src = fetchurl {
    url = http://artis.imag.fr/~Gilles.Debunne/Code/QDU/qdu-2.2.tar.gz;
    sha256 = "0nn13lcw7bpasdn5xd0ydkyzirz9zamgl8lizi3ncqdzv8bjm7xl";
  };

  buildInputs = [ qt3 libXext libX11];
 
  patchPhase = ''
  	sed -i "s@/usr/bin@$out/bin@" qdu.pro
  	sed -i "s@hint>directoryview@hint>directoryView@g" qduInterface.ui
  '';
  buildPhase = ''
	qmake
  	make
	make install
  '';
 
  name = "qdu-2.2";
  meta = { homepage = "http://freshmeat.net/redir/qdu/38383/url_homepage/QDU";
           description = "A graphical disk usage tool based on Qt";
           license="GPL";
         };
}
