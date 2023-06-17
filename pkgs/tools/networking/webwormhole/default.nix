{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "webwormhole";
  version = "unstable-2021-01-16";

  src = fetchFromGitHub {
    owner = "saljam";
    repo = pname;
    rev = "c85e196c8a8a885815136aa8aee1958ad80a3bb5";
    sha256 = "D10xmBwmEbeR3nU4CmppFBzdeE4Pm2+o/Vb5Yd+pPtM=";
  };

  vendorSha256 = "sha256-yK04gjDO6JSDcJULcbJBBuPBhx792JNn+B227lDUrWk=";

  meta = with lib; {
    description = "Send files using peer authenticated WebRTC";
    homepage = "https://github.com/saljam/webwormhole";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bbigras ];
    mainProgram = "ww";
  };
}
