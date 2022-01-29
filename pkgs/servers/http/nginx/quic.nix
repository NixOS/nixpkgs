{ callPackage
, fetchhg
, ...
} @ args:

callPackage ./generic.nix args {
  src = fetchhg {
    url = "https://hg.nginx.org/nginx-quic";
    rev = "6f8253673669"; # branch=quic
    sha256 = "sha256:0zl4rws07vr8z7ml7sqlb70v3cx1cms7iablndqd38iqcx0bvjrq";
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
