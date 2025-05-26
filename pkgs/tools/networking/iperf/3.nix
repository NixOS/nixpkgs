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
  version = "3.18";

  src = fetchurl {
    url = "https://downloads.es.net/pub/iperf/iperf-${version}.tar.gz";
    hash = "sha256-wGGBdVFDMedmUiUA4gyUv7KTtEJOsn1yB/tCe4jSC6s=";
  };

  buildInputs = [ openssl ] ++ lib.optionals stdenv.hostPlatform.isLinux [ lksctp-tools ];
  configureFlags = [ "--with-openssl=${openssl.dev}" ];

  outputs = [
    "out"
    "man"
  ];

  patches =
    [
      # Patch to exit with 0 on SIGTERM, i.e. stop service cleanly under
      # systemd. Will be part of the next release.
      (fetchpatch {
        url = "https://github.com/esnet/iperf/commit/4bab9bc39d08069976c519868fefa11c35f6c3f0.patch";
        name = "exit-with-0-on-sigterm.patch";
        hash = "sha256-klW5UzPckJuZ/1Lx0hXJkGK+NyaqSn5AndBT4P+uajw=";
      })
    ]
    ++ lib.optionals stdenv.hostPlatform.isMusl [
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
