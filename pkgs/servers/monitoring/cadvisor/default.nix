{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cadvisor";
  version = "unstable-2023-10-22";

  src = fetchFromGitHub {
    owner = "google";
    repo = "cadvisor";
    rev = "bf2a7fee4170e418e7ac774af7679257fe26dc69";
    hash = "sha256-wf5TtUmBC8ikpaUp3KLs8rBMunFPevNYYoactudHMsU=";
  };

  modRoot = "./cmd";

  vendorHash = "sha256-LEtiJC3L6Q7MZH2gvpR9y2Zn9vig+9mWlRyVuKY3rsA=";

  ldflags = [ "-s" "-w" "-X github.com/google/cadvisor/version.Version=${version}" ];

  postInstall = ''
    mv $out/bin/{cmd,cadvisor}
    rm $out/bin/example
  '';

  meta = with lib; {
    description = "Analyzes resource usage and performance characteristics of running docker containers";
    homepage = "https://github.com/google/cadvisor";
    license = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.linux;
  };
}
