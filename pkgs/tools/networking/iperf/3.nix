{ stdenv, fetchurl, openssl, fetchpatch }:

stdenv.mkDerivation rec {
  name = "iperf-3.7";

  src = fetchurl {
    url = "https://downloads.es.net/pub/iperf/${name}.tar.gz";
    sha256 = "033is7b5grfbiil98jxlz4ixp9shm44x6hy8flpsyz1i4h108inq";
  };

  buildInputs = [ openssl ];

  outputs = [ "out" "man" ];

  patches = stdenv.lib.optionals stdenv.hostPlatform.isMusl [
    (fetchpatch {
      url = "https://git.alpinelinux.org/aports/plain/main/iperf3/remove-pg-flags.patch?id=99ec9e1c84e338629cf1b27b0fdc808bde4d8564";
      name = "remove-pg-flags.patch";
      sha256 = "0b3vcw1pdyk10764p4vlglwi1acrm7wz2jjd6li7p11v4rggrb5c";
    })
  ];

  postInstall = ''
    ln -s $out/bin/iperf3 $out/bin/iperf
    ln -s $man/share/man/man1/iperf3.1 $man/share/man/man1/iperf.1
  '';

  meta = with stdenv.lib; {
    homepage = http://software.es.net/iperf/;
    description = "Tool to measure IP bandwidth using UDP or TCP";
    platforms = platforms.unix;
    license = "as-is";
    maintainers = with maintainers; [ fpletz ];
  };
}
