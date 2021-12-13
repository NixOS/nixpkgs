{ callPackage
, fetchhg
, ...
} @ args:

callPackage ./generic.nix args {
  src = fetchhg {
    url = "https://hg.nginx.org/nginx-quic";
    rev = "0ee56d2eac44"; # branch=quic
    sha256 = "sha256-ErJa71aOzcjcBl1P9+g5kzs5sr0JdjrPwYKZ9VAvQus=";
  };

  preConfigure = ''
    ln -s auto/configure configure
  '';

  configureFlags = [
    "--with-http_v3_module"
    "--with-stream_quic_module"
  ];

  version = "1.21.4-quic";
}
