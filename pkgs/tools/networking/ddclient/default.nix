{ stdenv, fetchurl, perlPackages, iproute }:

perlPackages.buildPerlPackage rec {
  name = "ddclient-${version}";
  version = "3.9.0";

  src = fetchurl {
    url = "mirror://sourceforge/ddclient/${name}.tar.gz";
    sha256 = "0fwyhab8yga2yi1kdfkbqxa83wxhwpagmj1w1mwkg2iffh1fjjlw";
  };

  # perl packages by default get devdoc which isn't present
  outputs = [ "out" ];

  buildInputs = with perlPackages; [ IOSocketSSL DigestSHA1 DataValidateIP JSONPP ];

  # Use iproute2 instead of ifconfig
  preConfigure = ''
    touch Makefile.PL
    substituteInPlace ddclient \
      --replace 'in the output of ifconfig' 'in the output of ip addr show' \
      --replace 'ifconfig -a'               '${iproute}/sbin/ip addr show' \
      --replace 'ifconfig $arg'             '${iproute}/sbin/ip addr show $arg'
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 ddclient $out/bin/ddclient
    install -Dm644 -t $out/share/doc/ddclient COP* ChangeLog README.* RELEASENOTE

    runHook postInstall
  '';

  # there are no tests distributed with ddclient
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Client for updating dynamic DNS service entries";
    homepage    = https://sourceforge.net/p/ddclient/wiki/Home/;
    license     = licenses.gpl2Plus;
    # Mostly since `iproute` is Linux only.
    platforms   = platforms.linux;
  };
}
