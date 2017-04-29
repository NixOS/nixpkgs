{stdenv, fetchurl, ctags, qt4, python}:

stdenv.mkDerivation rec {

  version = "2.0.3";
  name = "gede-${version}";
  src = fetchurl {
    url = "http://gede.acidron.com/uploads/source/${name}.tar.xz";
    sha256 = "1znlmkjgrmjl79q73xaa9ybp1xdc3k4h4ynv3jj5z8f92gjnj3kk";
  };

  buildInputs = [ ctags qt4 python ];
  patches = [ ./build.patch ];

  unpackPhase = ''
    tar xf ${src}
    cd ${name}
  '';
  configurePhase = "";
  buildPhase = "";
  installPhase = "./build.py install --prefix=$out";

  meta = with stdenv.lib; {
    description = "Graphical frontend (GUI) to GDB";
    homepage = "http://gede.acidron.com";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ juliendehos ];
  };
}

