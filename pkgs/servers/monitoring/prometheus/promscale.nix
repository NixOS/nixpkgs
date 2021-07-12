{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "promscale";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "timescale";
    repo = pname;
    rev = version;
    sha256 = "sha256-RdhsQtrD+I8eAgFNr1hvW83Ho22aNhWBX8crCM0b8jU=";
  };

  vendorSha256 = "sha256-82E82O0yaLbu+oSTX7AQoYXFYy3wYVdBCevV7pHZVOA=";

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
