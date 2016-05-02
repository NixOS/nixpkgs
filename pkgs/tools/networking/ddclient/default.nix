{ stdenv, buildPerlPackage, fetchurl, perlPackages, iproute }:

buildPerlPackage rec {
  name = "ddclient-${version}";
  version = "3.8.3";

  src = fetchurl {
    url = "mirror://sourceforge/ddclient/${name}.tar.gz";
    sha256 = "1j8zdn7fy7i0bjk3jf0hxnbnshc2yf054vxq64imxdpfd7n5zgfy";
  };

  outputs = [ "out" ];

  buildInputs = [ perlPackages.IOSocketSSL perlPackages.DigestSHA1 ];

  patches = [ ./ddclient-line-buffer-stdout.patch ];

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

  meta = with stdenv.lib; {
    homepage = https://sourceforge.net/p/ddclient/wiki/Home/;
    description = "Client for updating dynamic DNS service entries";
    license = licenses.gpl2Plus;

    # Mostly since `iproute` is Linux only.
    platforms = platforms.linux;
  };
}
