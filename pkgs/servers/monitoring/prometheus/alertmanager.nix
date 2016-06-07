{ stdenv, lib, go, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "alertmanager-${version}";
  version = "0.1.0";
  rev = "${version}";

  goPackagePath = "github.com/prometheus/alertmanager";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "alertmanager";
    sha256 = "1ya465bns6cj2lqbipmfm13wz8kxii5h9mm7lc0ba1xv26xx5zs7";
  };

  # Tests exist, but seem to clash with the firewall.
  doCheck = false;

  buildFlagsArray = let t = "${goPackagePath}/version"; in ''
    -ldflags=
       -X ${t}.Version=${version}
       -X ${t}.Revision=unknown
       -X ${t}.Branch=unknown
       -X ${t}.BuildUser=nix@nixpkgs
       -X ${t}.BuildDate=unknown
       -X ${t}.GoVersion=${stdenv.lib.getVersion go}
  '';

  meta = with stdenv.lib; {
    description = "Alert dispatcher for the Prometheus monitoring system";
    homepage = https://github.com/prometheus/alertmanager;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
