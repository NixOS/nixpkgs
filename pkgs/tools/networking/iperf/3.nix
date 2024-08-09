{
  lib,
  stdenv,
  fetchurl,
  openssl,
  fetchpatch,
  lksctp-tools,
}:

stdenv.mkDerivation rec {
  pname = "iperf";
  version = "3.17.1";

  src = fetchurl {
    url = "https://downloads.es.net/pub/iperf/iperf-${version}.tar.gz";
    hash = "sha256-hEBMqEMbWV6GxHPY8j2LsQKBAAHxX+r2EO/9OzGHiKo=";
  };

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isLinux [ lksctp-tools ];
  configureFlags = [ "--with-openssl=${openssl.dev}" ];

  outputs = [
    "out"
    "man"
  ];

  patches = lib.optionals stdenv.hostPlatform.isMusl [
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

  meta = {
    homepage = "https://software.es.net/iperf/";
    description = "Tool to measure IP bandwidth using UDP or TCP";
    platforms = lib.platforms.unix;
    license = lib.licenses.bsd3;
    mainProgram = "iperf3";
    maintainers = with lib.maintainers; [ fpletz ];
  };
}
