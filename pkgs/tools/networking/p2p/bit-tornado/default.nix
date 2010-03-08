{stdenv,fetchurl,python,wxPython26}:
stdenv.mkDerivation {
  name = "bit-tornado";

  src = fetchurl {
    url = http://download2.bittornado.com/download/BitTornado-0.3.18.tar.gz;
    sha256 = "1q6rapidnizy8wawasirgyjl9s4lrm7mm740mc5q5sdjyl5svrnr";
  };

  buildInputs = [python];

  buildPhase = " ";
  installPhase = "python setup.py install --prefix=$out ;"+
	" echo 'export PYTHONPATH=$PYTHONPATH:'$out'/lib/python2.4/site-packages:"+
	wxPython26+"/lib/python2.4/site-packages:"+
	wxPython26+"/lib/python2.6/site-packages:"+
	"'$out'/lib/python2.5/site-packages:"+
	"'$out'/lib/python2.6/site-packages:"+
	wxPython26+"/lib/python2.4/site-packages/wx-2.6-gtk2-unicode:"+
	wxPython26+"/lib/python2.6/site-packages/wx-2.6-gtk2-unicode:"+
	wxPython26+"/lib/python2.5/site-packages/wx-2.6-gtk2-unicode; "+
	"python `which btdownloadgui.py` --ipv6_enabled 1 --ipv6_binds_v4 0 \"$@\";' >"+
	"$out/bin/bittornado ; chmod a+rx $out/bin/bittornado;";

  meta = {
    description = "Bittorrent client with IPv6 support.";
  };
}
