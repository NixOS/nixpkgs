{ lib, buildGoModule, fetchgit }:

buildGoModule rec {
  pname = "protoc-gen-twirp_php";
  version = "0.8.1";

  # fetchFromGitHub currently not possible, because go.mod and go.sum are export-ignored
  src = fetchgit {
    url = "https://github.com/twirphp/twirp.git";
    rev = "v${version}";
    sha256 = "sha256-5PACgKqc8rWqaA6Syj5NyxHm3827yd67tm0mwVSMnWQ=";
  };

  vendorSha256 = "sha256-qQFlBviRISEnPBt0q5391RqUrPTI/QDxg3MNfwWE8MI=";

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
