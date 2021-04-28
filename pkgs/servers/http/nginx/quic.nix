{ callPackage, fetchhg, boringssl, ... } @ args:

callPackage ./generic.nix args {
  src = fetchhg {
    url = "https://hg.nginx.org/nginx-quic";
    rev = "47a43b011dec"; # branch=quic
    sha256 = "1d4d1v4zbnf5qlfl79pi7sficn1h7zm6kk7llm24yyhlsvssz10x";
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
