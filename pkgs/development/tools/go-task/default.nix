{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-task";
  version = "3.9.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = "task";
    rev = "v${version}";
    sha256 = "sha256-DKlKEnvhrdq3pdkSG6muQecsTZYFwRv3w4uptRwuLb4=";
  };

  vendorSha256 = "sha256-DI9N2PX8vvMombx2HfaciACmdM5u+rJLoekg72VGYyI=";

  doCheck = false;

  subPackages = [ "cmd/task" ];

  ldflags = [
    "-s" "-w" "-X main.version=${version}"
  ];

  postInstall = ''
    ln -s $out/bin/task $out/bin/go-task
  '';

  meta = with lib; {
    homepage = "https://taskfile.dev/";
    description = "A task runner / simpler Make alternative written in Go";
    license = licenses.mit;
    maintainers = with maintainers; [ parasrah ];
  };
}
