{ lib, buildGoModule, fetchgit }:

buildGoModule rec {
  pname = "protoc-gen-twirp_php";
  version = "0.9.1";

  # fetchFromGitHub currently not possible, because go.mod and go.sum are export-ignored
  src = fetchgit {
    url = "https://github.com/twirphp/twirp.git";
    rev = "v${version}";
    sha256 = "sha256-6tA+iNcs6s4vviWSJ5gCL9hPyCa7OvYXRCCokAAO0T8=";
  };

  vendorSha256 = "sha256-Kz9tMM4XSMOUmlHb/BE5/C/ZohdE505DTeDj9lGki/I=";

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
