{buildPerlPackage, fetchurl, perlPackages, iproute}:

buildPerlPackage {
  name = "ddclient-3.8.2";

  src = fetchurl {
    url = mirror://sourceforge/ddclient/ddclient-3.8.2.tar.gz ;
    sha256 = "17mcdqxcwa6c05m8xhxi4r37j4qvbp3wgbpvzqgmrmgwava5wcrw";
  };

  buildInputs = [ perlPackages.IOSocketSSL perlPackages.DigestSHA1 ];

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
