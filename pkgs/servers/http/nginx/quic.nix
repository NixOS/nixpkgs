{ callPackage
, fetchhg
, ...
} @ args:

callPackage ./generic.nix args {
  pname = "nginxQuic";

  src = fetchhg {
    url = "https://hg.nginx.org/nginx-quic";
    rev = "0af598651e33"; # branch=quic
    hash = "sha256-rG0jXA+ci7anUxZCBhXZLZKwnTtzzDEAViuoImKpALA=";
  };

  preConfigure = ''
    ln -s auto/configure configure
  '';

  configureFlags = [
    "--with-http_v3_module"
    "--with-stream_quic_module"
  ];

  version = "1.23.4";
}
