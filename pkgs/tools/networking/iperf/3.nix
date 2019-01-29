{ stdenv, fetchurl, openssl, fetchpatch }:

stdenv.mkDerivation rec {
  name = "iperf-3.6";

  src = fetchurl {
    url = "https://downloads.es.net/pub/iperf/${name}.tar.gz";
    sha256 = "0vllfmyqiy6nxgbagsx1zrs4pmfawyalzm5l1xcwqq64dpj52pfy";
  };

  buildInputs = [ openssl ];

  patches = stdenv.lib.optionals stdenv.hostPlatform.isMusl [
    (fetchpatch {
      url = "http://git.alpinelinux.org/cgit/aports/plain/main/iperf3/remove-pg-flags.patch";
      name = "remove-pg-flags.patch";
      sha256 = "0lnczhass24kgq59drgdipnhjnw4l1cy6gqza7f2ah1qr4q104rm";
    })
  ];

  postInstall = ''
    ln -s iperf3 $out/bin/iperf
  '';

  meta = with stdenv.lib; {
    homepage = http://software.es.net/iperf/;
    description = "Tool to measure IP bandwidth using UDP or TCP";
    platforms = platforms.unix;
    license = "as-is";
    maintainers = with maintainers; [ fpletz ];
  };
}
