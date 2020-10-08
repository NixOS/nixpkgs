{ stdenv, buildGoPackage, fetchFromGitHub, nixosTests }:

buildGoPackage rec {
  pname = "redis_exporter";
  version = "1.7.0";

  goPackagePath = "github.com/oliver006/redis_exporter";

  src = fetchFromGitHub {
    owner = "oliver006";
    repo = "redis_exporter";
    rev = "v${version}";
    sha256 = "0rwaxpylividyxz0snfgck32kvpgjkhg20bmdnlp35cdzxcxi8m1";
  };

  goDeps = ./redis-exporter-deps.nix;

  buildFlagsArray = ''
    -ldflags=
       -X main.BuildVersion=${version}
       -X main.BuildCommitSha=unknown
       -X main.BuildDate=unknown
  '';

  passthru.tests = { inherit (nixosTests.prometheus-exporters) redis; };

  meta = with stdenv.lib; {
    description = "Prometheus exporter for Redis metrics";
    inherit (src.meta) homepage;
    license = licenses.mit;
    maintainers = with maintainers; [ eskytthe srhb ];
    platforms = platforms.unix;
  };
}
