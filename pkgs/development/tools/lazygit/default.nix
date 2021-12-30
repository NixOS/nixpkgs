{ lib, buildGoModule, fetchFromGitHub, lazygit, testVersion }:

buildGoModule rec {
  pname = "lazygit";
  version = "0.31.4";

  src = fetchFromGitHub {
    owner = "jesseduffield";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-yze4UaSEbyHwHSyj0mM7uCzaDED+p4O3HVVlHJi/FKU=";
  };

  vendorSha256 = null;
  subPackages = [ "." ];

  ldflags = [ "-X main.version=${version}" "-X main.buildSource=nix" ];

  passthru.tests.version = testVersion { package = lazygit; };

  meta = with lib; {
    description = "Simple terminal UI for git commands";
    homepage = "https://github.com/jesseduffield/lazygit";
    changelog = "https://github.com/jesseduffield/lazygit/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fpletz equirosa Br1ght0ne ];
  };
}
