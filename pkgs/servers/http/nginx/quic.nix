{ callPackage
, fetchhg
, ...
} @ args:

callPackage ./generic.nix args {
  src = fetchhg {
    url = "https://hg.nginx.org/nginx-quic";
    rev = "5b0c229ba5fe"; # branch=quic
    sha256 = "1bb6n6b4nkc1cfllj75lwr4gjijl8883bkcvq8ncg7r4s5xs7r90";
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
