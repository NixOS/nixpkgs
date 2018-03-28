{ stdenv, go, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "alertmanager-${version}";
  version = "0.14.0";
  rev = "v${version}";

  goPackagePath = "github.com/prometheus/alertmanager";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "alertmanager";
    sha256 = "0f6yi19zffxnp3dlr4zs52b7bllks3kjxkdn9zvvi5lvpkzmba5j";
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
