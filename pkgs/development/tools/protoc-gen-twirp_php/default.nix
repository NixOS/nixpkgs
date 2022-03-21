{ lib, buildGoModule, fetchgit }:

buildGoModule rec {
  pname = "protoc-gen-twirp_php";
  version = "0.8.0";

  # fetchFromGitHub currently not possible, because go.mod and go.sum are export-ignored
  src = fetchgit {
    url = "https://github.com/twirphp/twirp.git";
    rev = "v${version}";
    sha256 = "sha256-TaHfyYoWsA/g5xZFxIMNwE1w6Dd9Cq5bp1gpQudYLs0=";
  };

  vendorSha256 = "sha256-qQFlBviRISEnPBt0q5391RqUrPTI/QDxg3MNfwWE8MI=";

  subPackages = [ "protoc-gen-twirp_php" ];

  meta = with lib; {
    description = "PHP port of Twitch's Twirp RPC framework";
    homepage = "https://github.com/twirphp/twirp";
    license = licenses.mit;
    maintainers = with maintainers; [ jojosch ];
  };
}
