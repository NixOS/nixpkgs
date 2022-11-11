{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "lazygit";
  version = "0.35";

  src = fetchFromGitHub {
    owner = "jesseduffield";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-TYtjwEQTXjkp1o95cXJw0VDVv5us07K+6NrJF9bsJfg=";
  };

  vendorSha256 = null;
  subPackages = [ "." ];

  ldflags = [ "-X main.version=${version}" "-X main.buildSource=nix" ];

  meta = with lib; {
    description = "Simple terminal UI for git commands";
    homepage = "https://github.com/jesseduffield/lazygit";
    changelog = "https://github.com/jesseduffield/lazygit/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ equirosa Br1ght0ne ];
  };
}
