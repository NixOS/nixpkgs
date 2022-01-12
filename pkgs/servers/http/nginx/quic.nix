{ callPackage
, fetchhg
, ...
} @ args:

callPackage ./generic.nix args {
  src = fetchhg {
    url = "https://hg.nginx.org/nginx-quic";
    rev = "10522e8dea41"; # branch=quic
    sha256 = "sha256-BnAhnJKq2uHAp0WqVWIk+Hw0GXF/rAOxKCTwwsiiZdo=";
  };

  preConfigure = ''
    ln -s auto/configure configure
  '';

  configureFlags = [
    "--with-http_v3_module"
    "--with-stream_quic_module"
  ];

  version = "1.21.5-quic";
}
