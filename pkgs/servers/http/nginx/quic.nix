{ callPackage
, fetchhg
, ...
} @ args:

callPackage ./generic.nix args {
  src = fetchhg {
    url = "https://hg.nginx.org/nginx-quic";
    rev = "8d0753760546"; # branch=quic
    sha256 = "sha256-HcYkjbm3qfTU34ahseHCZhHYWNm1phfVph6oJBARMI8=";
  };

  preConfigure = ''
    ln -s auto/configure configure
  '';

  configureFlags = [
    "--with-http_v3_module"
    "--with-stream_quic_module"
  ];

  version = "1.23.0-quic";
}
