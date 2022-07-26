{ lib, stdenv, fetchurl, libpcap, bison, flex, cyrus_sasl, tcp_wrappers, pkg-config, perl, libtirpc, libnsl }:

stdenv.mkDerivation rec {
  pname = "argus-clients";
  version = "3.0.8.3";

  src = fetchurl {
    url = "http://qosient.com/argus/src/${pname}-${version}.tar.gz";
    sha256 = "sha256-uNTvi6zbrYHAivQMPkhlNCoqRW9GOkgKvCf3mInds80=";
  };

  NIX_CFLAGS_COMPILE = [ "-I${libtirpc.dev}/include/tirpc" ];

  postPatch = ''
    for file in ./examples/*/*.pl; do
      substituteInPlace $file \
        --subst-var-by PERLBIN ${perl}/bin/perl
    done
    '';

  configureFlags = [ "--with-perl=${perl}/bin/perl" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libpcap bison cyrus_sasl tcp_wrappers flex libnsl ];

  meta = with lib; {
    description = "Clients for ARGUS";
    longDescription = ''Clients for Audit Record Generation and
    Utilization System (ARGUS). The Argus Project is focused on developing all
    aspects of large scale network situtational awareness derived from
    network activity audit. Argus, itself, is next-generation network
    flow technology, processing packets, either on the wire or in
    captures, into advanced network flow data. The data, its models,
    formats, and attributes are designed to support Network
    Operations, Performance and Security Management. If you need to
    know what is going on in your network, right now or historically,
    you will find Argus a useful tool. '';
    homepage = "http://qosient.com/argus";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ leenaars ];
    platforms = platforms.linux;
  };
}
