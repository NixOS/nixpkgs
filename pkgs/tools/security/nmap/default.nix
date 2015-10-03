{ stdenv, fetchurl, libpcap, pkgconfig, openssl
, graphicalSupport ? false
, libX11 ? null
, gtk ? null
, python ? null
, pygtk ? null
, makeWrapper ? null
, pygobject ? null
, pycairo ? null
, pysqlite ? null
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "nmap${optionalString graphicalSupport "-graphical"}-${version}";
  version = "6.49BETA4";

  src = fetchurl {
    url = "http://nmap.org/dist/nmap-${version}.tar.bz2";
    sha256 = "042fg73w7596b3h6ha9y62ckc0hd352zv1shwip3dx14v5igrsna";
  };

  patches = ./zenmap.patch;

  configureFlags = optionalString (!graphicalSupport) "--without-zenmap";

  postInstall = ''
      wrapProgram $out/bin/ndiff --prefix PYTHONPATH : "$(toPythonPath $out)" --prefix PYTHONPATH : "$PYTHONPATH"
  '' + optionalString graphicalSupport ''
      wrapProgram $out/bin/zenmap --prefix PYTHONPATH : "$(toPythonPath $out)" --prefix PYTHONPATH : "$PYTHONPATH" --prefix PYTHONPATH : $(toPythonPath ${pygtk})/gtk-2.0 --prefix PYTHONPATH : $(toPythonPath ${pygobject})/gtk-2.0 --prefix PYTHONPATH : $(toPythonPath ${pycairo})/gtk-2.0
  '';

  buildInputs = [ libpcap pkgconfig openssl makeWrapper python ]
    ++ optionals graphicalSupport [
      libX11 gtk pygtk pysqlite pygobject pycairo
    ];

  meta = {
    description = "A free and open source utility for network discovery and security auditing";
    homepage    = http://www.nmap.org;
    license     = licenses.gpl2;
    platforms   = platforms.all;
    maintainers = with maintainers; [ mornfall thoughtpolice ];
  };
}
