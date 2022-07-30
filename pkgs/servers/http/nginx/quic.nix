{ callPackage
, fetchhg
, ...
} @ args:

callPackage ./generic.nix args {
  src = fetchhg {
    url = "https://hg.nginx.org/nginx-quic";
    rev = "3550b00d9dc8"; # branch=quic
    sha256 = "sha256-JtE5FO4FHlDuqXd4UTXXPIFAdyyhQbOSMTT0NXh2iH4=";
  };

  preConfigure = ''
    ln -s auto/configure configure
  '';

  configureFlags = [
    "--with-http_v3_module"
    "--with-stream_quic_module"
  ];

  version = "1.23.1-quic";
}
