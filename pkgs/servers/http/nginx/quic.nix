{ callPackage
, fetchhg
, ...
} @ args:

callPackage ./generic.nix args {
  src = fetchhg {
    url = "https://hg.nginx.org/nginx-quic";
    rev = "12f18e0bca09"; # branch=quic
    sha256 = "1lr6zlny26kamczgk8ddscmy5fp5mzxqcppwhjhvq1a029a0r4b7";
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
