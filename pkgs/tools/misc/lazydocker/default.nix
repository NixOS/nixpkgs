{ lib, buildGoModule, fetchFromGitHub, lazydocker, testers }:

buildGoModule rec {
  pname = "lazydocker";
  version = "0.23.3";

  src = fetchFromGitHub {
    owner = "jesseduffield";
    repo = "lazydocker";
    rev = "v${version}";
    sha256 = "sha256-1nw0X8sZBtBsxlEUDVYMAinjMEMlIlzjJ4s+WApeE6o=";
  };

  vendorHash = null;

  postPatch = ''
    rm -f pkg/config/app_config_test.go
  '';

  excludedPackages = [ "scripts" "test/printrandom" ];

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  passthru.tests.version = testers.testVersion {
    package = lazydocker;
  };

  meta = with lib; {
    description = "A simple terminal UI for both docker and docker-compose";
    homepage = "https://github.com/jesseduffield/lazydocker";
    license = licenses.mit;
    maintainers = with maintainers; [ das-g Br1ght0ne ];
    mainProgram = "lazydocker";
  };
}
