{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "promscale";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "timescale";
    repo = pname;
    rev = version;
    sha256 = "sha256-rXOAAd08NTWFRGnJoAY9xllw6dAA7Xu3qcImIVq9ewE=";
  };

  vendorSha256 = "sha256-/woSbtrOI3BVBhh+A2kO1CB1BLzBciwOqvSbGkFeMEU=";

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
