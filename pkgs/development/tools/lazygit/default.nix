{ lib, buildGoModule, fetchFromGitHub, lazygit, testers }:

buildGoModule rec {
  pname = "lazygit";
  version = "0.41.0";

  src = fetchFromGitHub {
    owner = "jesseduffield";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Ok6QnXw3oDeSzBekft8cDXM/YsADgF1NZznfNoGNvck=";
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
    maintainers = with maintainers; [ Br1ght0ne equirosa paveloom starsep ];
    mainProgram = "lazygit";
  };
}
