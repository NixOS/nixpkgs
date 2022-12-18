{ callPackage
, fetchhg
, ...
} @ args:

callPackage ./generic.nix args {
  src = fetchhg {
    url = "https://hg.nginx.org/nginx-quic";
    rev = "3be953161026"; # branch=quic
    sha256 = "sha256-maWQ0RPI2pe6L8QL7TQ1YJts5ZJHhiTYG9sdwINGMDA=";
  };

  preConfigure = ''
    ln -s auto/configure configure
  '';

  configureFlags = [
    "--with-http_v3_module"
    "--with-stream_quic_module"
  ];

  version = "1.23.2-quic";
}
