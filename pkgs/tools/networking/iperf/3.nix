{ stdenv, fetchurl, openssl, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "iperf";
  version = "3.8.1";

  src = fetchurl {
    url = "https://downloads.es.net/pub/iperf/iperf-${version}.tar.gz";
    sha256 = "15pdgnan9krf3dijan9in73ir8rcmhk3iw8085d732is4zrq1c75";
  };

  buildInputs = [ openssl ];
  configureFlags = [
    "--with-openssl=${openssl.dev}"
  ];

  outputs = [ "out" "man" ];

  patches = stdenv.lib.optionals stdenv.hostPlatform.isMusl [
    (fetchpatch {
      url = "https://git.alpinelinux.org/aports/plain/main/iperf3/remove-pg-flags.patch?id=7f979fc51ae31d5c695d8481ba84a4afc5080efb";
      name = "remove-pg-flags.patch";
      sha256 = "0z3zsmf7ln08rg1mmzl8s8jm5gp8x62f5cxiqcmi8dcs2nsxwgbi";
    })
  ];

  postInstall = ''
    ln -s $out/bin/iperf3 $out/bin/iperf
    ln -s $man/share/man/man1/iperf3.1 $man/share/man/man1/iperf.1
  '';

  meta = with stdenv.lib; {
    homepage = "http://software.es.net/iperf/";
    description = "Tool to measure IP bandwidth using UDP or TCP";
    platforms = platforms.unix;
    license = licenses.bsd3;
    maintainers = with maintainers; [ fpletz ];
  };
}
