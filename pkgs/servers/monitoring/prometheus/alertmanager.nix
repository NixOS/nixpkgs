{ stdenv, go, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "alertmanager";
  version = "0.19.0";
  rev = "v${version}";

  goPackagePath = "github.com/prometheus/alertmanager";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "alertmanager";
    sha256 = "08k898x9ks5rzcmb7ps1rnxv36ynv64x8yq2ahpwmfkmv6nw1ylh";
  };

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
    maintainers = with maintainers; [ benley fpletz globin ];
    platforms = platforms.unix;
  };
}
