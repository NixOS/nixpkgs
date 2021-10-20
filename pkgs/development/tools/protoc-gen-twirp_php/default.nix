{ lib, buildGoModule, fetchgit }:

buildGoModule rec {
  pname = "protoc-gen-twirp_php";
  version = "0.7.5";

  # fetchFromGitHub currently not possible, because go.mod and go.sum are export-ignored
  src = fetchgit {
    url = "https://github.com/twirphp/twirp.git";
    rev = "v${version}";
    sha256 = "sha256-pHGGZaMBggBUu2CZCxWrZ592K5V93vPI2sZnFkqku2k=";
  };

  vendorSha256 = "sha256-p7t+2QgPkcTmsK+jKcPCPDCchNup9F326yKc6JbJHOE=";

  subPackages = [ "protoc-gen-twirp_php" ];

  meta = with lib; {
    description = "PHP port of Twitch's Twirp RPC framework";
    homepage = "https://github.com/twirphp/twirp";
    license = licenses.mit;
    maintainers = with maintainers; [ jojosch ];
  };
}
