{ callPackage
, fetchhg
, ...
} @ args:

callPackage ./generic.nix args {
  src = fetchhg {
    url = "https://hg.nginx.org/nginx-quic";
    rev = "6d1488b62dc5"; # branch=quic
    sha256 = "18xrkzzi4cxl4zi7clikwww9ad9l7vilrfs67hhzx7898jkws5fi";
  };

  preConfigure = ''
    ln -s auto/configure configure
  '';

  configureFlags = [
    "--with-http_v3_module"
    "--with-http_quic_module"
    "--with-stream_quic_module"
  ];

  version = "quic";
}
