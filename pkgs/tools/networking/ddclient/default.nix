{buildPerlPackage, fetchurl, perlPackages, iproute}:

buildPerlPackage {
  name = "ddclient-3.8.1";

  src = fetchurl {
    url = mirror://sourceforge/ddclient/ddclient-3.8.1.tar.gz ;
    sha256 = "f22ac7b0ec78e310d7b88a1cf636e5c00360b2ed9c087f231b3522ef3e6295f2";
  };

  buildInputs = [ perlPackages.IOSocketSSL ];

  patches = [ ./ddclient-foreground.patch ];

  # Use iproute2 instead of ifconfig
  preConfigure = '' 
    touch Makefile.PL
    substituteInPlace ddclient --replace 'in the output of ifconfig' 'in the output of ip addr show'
    substituteInPlace ddclient --replace 'ifconfig -a' '${iproute}/sbin/ip addr show'
    substituteInPlace ddclient --replace 'ifconfig $arg' '${iproute}/sbin/ip addr show $arg'
  ''; 

  installPhase = ''
    mkdir -p $out/bin
    cp ddclient $out/bin
  '';

  doCheck = false;
}
