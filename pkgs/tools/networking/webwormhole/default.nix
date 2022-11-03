{ lib, buildGoModule, fetchFromGitHub, updateGolangSysHook }:

buildGoModule rec {
  pname = "webwormhole";
  version = "unstable-2021-01-16";

  src = fetchFromGitHub {
    owner = "saljam";
    repo = pname;
    rev = "c85e196c8a8a885815136aa8aee1958ad80a3bb5";
    sha256 = "D10xmBwmEbeR3nU4CmppFBzdeE4Pm2+o/Vb5Yd+pPtM=";
  };

  nativeBuildInputs = [ updateGolangSysHook ];

  vendorSha256 = "sha256-n1MgsOWeVkPTYhK5HUYvEcvf0rDEjkSd+Yyr7Nkh8hk=";

  meta = with lib; {
    description = "Send files using peer authenticated WebRTC";
    homepage = "https://github.com/saljam/webwormhole";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bbigras ];
    mainProgram = "ww";
  };
}
