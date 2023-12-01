{ lib, buildGoModule, fetchgit }:

buildGoModule rec {
  pname = "protoc-gen-twirp_php";
  version = "0.10.0";

  # fetchFromGitHub currently not possible, because go.mod and go.sum are export-ignored
  src = fetchgit {
    url = "https://github.com/twirphp/twirp.git";
    rev = "v${version}";
    sha256 = "sha256-YMndB5DiER2Z1ARbw2cpxE1DBFCoVNWhMdsfA3X27EE=";
  };

  vendorHash = "sha256-Gf8thGuFAKX4pCNFJM3RbJ63vciLNcSqpOULcUOaGNw=";

  subPackages = [ "protoc-gen-twirp_php" ];

  ldflags = [
    "-X main.version=${version}"
  ];

  meta = with lib; {
    description = "PHP port of Twitch's Twirp RPC framework";
    homepage = "https://github.com/twirphp/twirp";
    license = licenses.mit;
    maintainers = with maintainers; [ jojosch ];
  };
}
