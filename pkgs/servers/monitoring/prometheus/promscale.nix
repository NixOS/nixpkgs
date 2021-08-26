{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "promscale";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "timescale";
    repo = pname;
    rev = version;
    sha256 = "sha256-u9qlABTuQ4EWEfyei6nN/AZ7j9QJXQ61GvyhP8wEmK0=";
  };

  vendorSha256 = "sha256-DFDTYT7UK1cYwGeCgeQcJmrCoqGPDzicusRPPUbH0Gs=";

  ldflags = [ "-s" "-w" "-X github.com/timescale/promscale/pkg/version.Version=${version}" "-X github.com/timescale/promscale/pkg/version.CommitHash=${src.rev}" ];

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
