{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cadvisor";
  version = "0.46.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "cadvisor";
    rev = "v${version}";
    sha256 = "sha256-ciGj8SK7OgK3x8Njih4aIQ0vvNV9s5/w2i+DF/vw1O8=";
  };

  modRoot = "./cmd";

  vendorSha256 = "sha256-dg+osxsxdJ8Tg++wdd4L6FMjiPLLFQj0NXb2aSC7vQg=";

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
