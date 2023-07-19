{ lib, stdenv, fetchurl, openssl, fetchpatch, lksctp-tools }:

stdenv.mkDerivation rec {
  pname = "iperf";
  version = "3.12";

  src = fetchurl {
    url = "https://downloads.es.net/pub/iperf/iperf-${version}.tar.gz";
    sha256 = "sha256-cgNOz7an1tZ+OE4Z+27/8yNspPftTFGNfbZJxEfh/9Y=";
  };

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isLinux [ lksctp-tools ];
  configureFlags = [
    "--with-openssl=${openssl.dev}"
  ];

  outputs = [ "out" "man" ];

  patches = [
    (fetchpatch {
      url = "https://github.com/esnet/iperf/commit/0ef151550d96cc4460f98832df84b4a1e87c65e9.patch";
      name = "CVE-2023-38403.patch";
      hash = "sha256-Yaup8rlljyuBK6n71YtHhFd1+WnjxfmEQpoXJulhQTs=";
    })
  ] ++ lib.optionals stdenv.hostPlatform.isMusl [
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

  meta = with lib; {
    homepage = "http://software.es.net/iperf/";
    description = "Tool to measure IP bandwidth using UDP or TCP";
    platforms = platforms.unix;
    license = licenses.bsd3;
    maintainers = with maintainers; [ fpletz ];
  };
}
