{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "webwormhole";
<<<<<<< HEAD
  version = "unstable-2023-02-25";
=======
  version = "unstable-2021-01-16";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "saljam";
    repo = pname;
<<<<<<< HEAD
    rev = "25b68f4f4c1aaa0c6c1949b60bd4ef52ec972ebb";
    hash = "sha256-JFmfwHBa/lNGTOIIgnMFc4VMlsXtjX9v9Tn2XpdVMfA=";
  };

  vendorHash = "sha256-+7ctAm2wnjmfMd6CHXlcAUwiUMS7cH4koDAvlEUAXEg=";
=======
    rev = "c85e196c8a8a885815136aa8aee1958ad80a3bb5";
    sha256 = "D10xmBwmEbeR3nU4CmppFBzdeE4Pm2+o/Vb5Yd+pPtM=";
  };

  vendorSha256 = "sha256-yK04gjDO6JSDcJULcbJBBuPBhx792JNn+B227lDUrWk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Send files using peer authenticated WebRTC";
    homepage = "https://github.com/saljam/webwormhole";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bbigras ];
    mainProgram = "ww";
  };
}
