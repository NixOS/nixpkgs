{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "neo-cowsay";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "Code-Hex";
    repo = "Neo-cowsay";
    rev = "v${version}";
    sha256 = "sha256-VswknPs/yCUOUsXoGlGNF22i7dK8FrYzWkUWlfIPrNo=";
  };

  vendorSha256 = "sha256-kJSKDqw2NpnPjotUM6Ck6sixCJt3nVOdx800/+JBiWM=";

  doCheck = false;

  subPackages = [ "cmd/cowsay" "cmd/cowthink" ];

  meta = with lib; {
    description = "Cowsay reborn, written in Go";
    homepage = "https://github.com/Code-Hex/Neo-cowsay";
    license = with licenses; [artistic1 /* or */ gpl3];
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
