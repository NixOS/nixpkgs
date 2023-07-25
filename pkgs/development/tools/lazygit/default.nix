{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "lazygit";
  version = "0.39.4";

  src = fetchFromGitHub {
    owner = "jesseduffield";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-1eJmnLsQrcGw+A0rGXfZUFHwJAthZSNhNcc2zt/dx5M=";
  };

  vendorHash = null;
  subPackages = [ "." ];

  ldflags = [ "-X main.version=${version}" "-X main.buildSource=nix" ];

  meta = with lib; {
    description = "Simple terminal UI for git commands";
    homepage = "https://github.com/jesseduffield/lazygit";
    changelog = "https://github.com/jesseduffield/lazygit/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne equirosa paveloom ];
  };
}
