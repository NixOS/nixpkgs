{ stdenv, fetchurl, pkgconfig, apacheHttpd_2_2, apr, avahi }:

stdenv.mkDerivation rec {
  name = "mod_dnssd-0.6";

  src = fetchurl {
    url = "http://0pointer.de/lennart/projects/mod_dnssd/${name}.tar.gz";
    sha256 = "2cd171d76eba398f03c1d5bcc468a1756f4801cd8ed5bd065086e4374997c5aa";
  };

  configureFlags = [ "--disable-lynx" ];

  buildInputs = [ pkgconfig apacheHttpd_2_2 avahi apr ];

  installPhase = ''
    mkdir -p $out/modules
    cp src/.libs/mod_dnssd.so $out/modules
  '';

  meta = with stdenv.lib; {
    homepage = http://0pointer.de/lennart/projects/mod_dnssd;
    description = "Provide Zeroconf support via DNS-SD using Avahi";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lethalman ];
  };
}

