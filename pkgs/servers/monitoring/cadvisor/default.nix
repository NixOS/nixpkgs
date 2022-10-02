{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cadvisor";
  version = "0.45.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "cadvisor";
    rev = "v${version}";
    sha256 = "sha256-hH3unhGRrB8IegVaX+j2idY0woMqzchEEXZB/ppzIf0=";
  };

  modRoot = "./cmd";

  vendorSha256 = "sha256-Mcelh/nYFcNTrI1Kq9KqkJeSnbgJhd7HfbexhNYbPFg=";

  ldflags = [ "-s" "-w" "-X github.com/google/cadvisor/version.Version=${version}" ];

  postInstall = ''
    mv $out/bin/{cmd,cadvisor}
    rm $out/bin/example
  '';

  preCheck = ''
    rm internal/container/mesos/handler_test.go
  '';

  meta = with lib; {
    description = "Analyzes resource usage and performance characteristics of running docker containers";
    homepage = "https://github.com/google/cadvisor";
    license = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.linux;
  };
}
