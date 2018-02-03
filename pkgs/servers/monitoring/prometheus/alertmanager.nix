{ stdenv, go, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "alertmanager-${version}";
  version = "0.13.0";
  rev = "v${version}";

  goPackagePath = "github.com/prometheus/alertmanager";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "alertmanager";
    sha256 = "170q5fynwa3g3wm77g61610n1lf5kqirhrgak6slqzn52ji870nc";
  };

  # Tests exist, but seem to clash with the firewall.
  doCheck = false;

  buildFlagsArray = let t = "${goPackagePath}/vendor/github.com/prometheus/common/version"; in ''
    -ldflags=
       -X ${t}.Version=${version}
       -X ${t}.Revision=${src.rev}
       -X ${t}.Branch=unknown
       -X ${t}.BuildUser=nix@nixpkgs
       -X ${t}.BuildDate=unknown
       -X ${t}.GoVersion=${stdenv.lib.getVersion go}
  '';

  postInstall = ''
    mkdir -p $bin/etc/bash_completion.d
    $NIX_BUILD_TOP/go/bin/amtool --completion-script-bash > $bin/etc/bash_completion.d/amtool_completion.sh
  '';

  meta = with stdenv.lib; {
    description = "Alert dispatcher for the Prometheus monitoring system";
    homepage = https://github.com/prometheus/alertmanager;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley fpletz ];
    platforms = platforms.unix;
  };
}
