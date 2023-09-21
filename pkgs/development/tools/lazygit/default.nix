{ lib, buildGoModule, fetchFromGitHub, lazygit, testers }:

buildGoModule rec {
  pname = "lazygit";
  version = "0.40.2";

  src = fetchFromGitHub {
    owner = "jesseduffield";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-xj5WKAduaJWA3NhWuMsF5EXF91+NTGAXkbdhpeFqLxE=";
  };

  vendorHash = null;
  subPackages = [ "." ];

  ldflags = [ "-X main.version=${version}" "-X main.buildSource=nix" ];

  passthru.tests.version = testers.testVersion {
    package = lazygit;
  };

  meta = with lib; {
    description = "Simple terminal UI for git commands";
    homepage = "https://github.com/jesseduffield/lazygit";
    changelog = "https://github.com/jesseduffield/lazygit/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne equirosa paveloom ];
    mainProgram = "lazygit";
  };
}
