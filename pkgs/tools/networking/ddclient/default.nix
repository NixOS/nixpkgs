{buildPerlPackage, fetchurl, perl}:

buildPerlPackage {
  name = "ddclient-3.8.0";

  src = fetchurl {
    url = mirror://sourceforge/ddclient/ddclient-3.8.0.tar.gz ;
    sha256 = "1cqz6fwx8bcl7zdrvm6irh3bzs8858gkyficww9simyjmz7z3w48";
  };

  patches = [ ./ddclient-foreground.patch ];

  preConfigure = '' 
    touch Makefile.PL
  ''; 

  installPhase = ''
    mkdir -p $out/bin
    cp ddclient $out/bin
  '';

  doCheck = false;

}
