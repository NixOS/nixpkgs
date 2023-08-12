{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cadvisor";
  version = "unstable-2023-07-28";

  src = fetchFromGitHub {
    owner = "google";
    repo = "cadvisor";
    rev = "fdd3d9182bea6f7f11e4f934631c4abef3aa0584";
    hash = "sha256-U6oZ80EYx56FJ7VsDKzCXH4TvFEH+oPmgK/Nd8T/Zp4=";
  };

  modRoot = "./cmd";

  vendorHash = "sha256-hvgObwmNKk6yTJSyEHuHZ5abuXGPwPC42xUSAAF8UA0=";

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
