{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "promscale";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "timescale";
    repo = pname;
    rev = version;
    sha256 = "sha256-kZYFOuY6FFM35mP+o/YU5SM5H9ziOq9BQ8T1RX7rhGE=";
  };

  vendorSha256 = "sha256-1VOhDOfFE4BpDR4XfhLoXJFuTDkG1nx88tVvTF3ZVxU=";

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/timescale/promscale/pkg/version.Version=${version} -X github.com/timescale/promscale/pkg/version.CommitHash=${src.rev}" ];

  doCheck = false; # Requires access to a docker daemon
  doInstallCheck = true;
  installCheckPhase = ''
    if [[ "$("$out/bin/${pname}" -version)" == "${version}" ]]; then
      echo '${pname} smoke check passed'
    else
      echo '${pname} smoke check failed'
      exit 1
    fi
  '';

  meta = with lib; {
    description = "An open-source analytical platform for Prometheus metrics";
    homepage = "https://github.com/timescale/promscale";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ _0x4A6F ];
  };
}
