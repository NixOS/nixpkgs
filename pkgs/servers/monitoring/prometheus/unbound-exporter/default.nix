{ stdenv, lib, go, buildGoPackage, fetchFromGitHub, prometheus }:

buildGoPackage rec {
  name = "prometheus-unbound-exporter-${version}";
  version = "0.1+git20171019";
  rev = "91ad2ff6208526858203f684abcf7e18fcbf6269";

  goPackagePath = "github.com/kumina/unbound_exporter";

  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    inherit rev;
    owner = "kumina";
    repo = "unbound_exporter";
    sha256 = "1zxc8cc8q6m285dz0rwynzlymyfw19d9w2vyivw0gbfiwx830aa2";
  };

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Simple Prometheus metrics exporter for the Unbound DNS resolver.";
    license = licenses.asl20;
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.unix;
  };
}
