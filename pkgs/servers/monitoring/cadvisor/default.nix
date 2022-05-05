{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cadvisor";
  version = "0.40.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "cadvisor";
    rev = "v${version}";
    sha256 = "sha256-8HOaKjdATVZpyx4yLf7xefz+jiOEqmkWiZnA3DOyT50=";
  };

  modRoot = "./cmd";

  vendorSha256 = "sha256-+nrXD0hQ3zBwTTq9xoBqO3ho4s4tf8uZQz2wL1nYi/k=";

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
