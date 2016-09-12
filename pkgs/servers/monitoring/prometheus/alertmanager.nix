{ stdenv, lib, go, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "alertmanager-${version}";
  version = "0.4.2";
  rev = "v${version}";

  goPackagePath = "github.com/prometheus/alertmanager";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "alertmanager";
    sha256 = "1ngfilln259mh92x5wigiz70lnkgwpfbbmf5682j4pw7m3bxaam8";
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
