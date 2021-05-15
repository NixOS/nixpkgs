{ lib, buildGoModule, fetchgit }:

buildGoModule rec {
  pname = "protoc-gen-twirp_php";
  version = "0.7.1";

  # fetchFromGitHub currently not possible, because go.mod and go.sum are export-ignored
  src = fetchgit {
    url = "https://github.com/twirphp/twirp.git";
    rev = "v${version}";
    sha256 = "sha256-94GN/Gq3RXXg83eUsmIcdF4VuK4syCgD0Zkc5eDiVYE=";
  };

  vendorSha256 = "sha256-gz4JELCffuh7dyFdBex8/SFZ1/PDXuC/93m3WNHwRss=";

  subPackages = [ "protoc-gen-twirp_php" ];

  meta = with lib; {
    description = "PHP port of Twitch's Twirp RPC framework";
    homepage = "https://github.com/twirphp/twirp";
    license = licenses.mit;
    maintainers = with maintainers; [ jojosch ];
  };
}
