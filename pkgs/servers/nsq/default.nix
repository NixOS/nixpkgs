{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "nsq";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "nsqio";
    repo = "nsq";
    rev = "v${version}";
    hash = "sha256-yOfhDf0jidAYvkgIIJy6Piu6GKGzph/Er/obYB2XWCo=";
  };

  vendorHash = "sha256-SkNxb90uet/DAApGjj+jpFnjdPiw4oxqxpEpqL9JXYc=";

  excludedPackages = [ "bench" ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://nsq.io/";
    description = "A realtime distributed messaging platform";
    changelog = "https://github.com/nsqio/nsq/raw/v${version}/ChangeLog.md";
    license = licenses.mit;
  };
}
