{ callPackage
, fetchhg
, ...
} @ args:

callPackage ./generic.nix args {
  src = fetchhg {
    url = "https://hg.nginx.org/nginx-quic";
    rev = "404de224517e"; # branch=quic
    sha256 = "00x8djp3hqnq60jzpddfrj0v23j2fbl27jyw609ha3wqkkbxrip9";
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
