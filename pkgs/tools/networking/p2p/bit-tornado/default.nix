{ stdenv,fetchurl,python, wxPython, makeWrapper }:
stdenv.mkDerivation {
  name = "bit-tornado-0.3.18";

  src = fetchurl {
    url = http://download2.bittornado.com/download/BitTornado-0.3.18.tar.gz;
    sha256 = "1q6rapidnizy8wawasirgyjl9s4lrm7mm740mc5q5sdjyl5svrnr";
  };

  buildInputs = [ python wxPython makeWrapper ];

  buildPhase = '' '';
  installPhase = ''
    python setup.py install --prefix=$out ;
    for i in $(cd $out/bin && ls); do
        wrapProgram $out/bin/$i \
            --prefix PYTHONPATH : "$(toPythonPath $out):$PYTHONPATH" 
    done
  '';

  meta = {
    description = "Bittorrent client with IPv6 support.";
  };
}
