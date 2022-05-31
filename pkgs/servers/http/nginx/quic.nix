{ callPackage
, fetchhg
, ...
} @ args:

callPackage ./generic.nix args {
  src = fetchhg {
    url = "https://hg.nginx.org/nginx-quic";
    rev = "5b1011b5702b"; # branch=quic
    sha256 = "sha256-q1gsJ6CJ7SD1XLitygnRusJ+exFPFg+B3wdsN+NvuL8=";
  };

  preConfigure = ''
    ln -s auto/configure configure
  '';

  configureFlags = [
    "--with-http_v3_module"
    "--with-stream_quic_module"
  ];

  version = "1.21.7-quic";
}
