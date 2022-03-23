{ callPackage
, fetchhg
, ...
} @ args:

callPackage ./generic.nix args {
  src = fetchhg {
    url = "https://hg.nginx.org/nginx-quic";
    rev = "55b38514729b"; # branch=quic
    sha256 = "sha256-EJ3Fuxb4Z43I5eSb3mzzIOBfppAZ4Adv1yVZWbVCv0A=";
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
