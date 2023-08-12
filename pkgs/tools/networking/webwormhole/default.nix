{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "webwormhole";
  version = "unstable-2023-02-25";

  src = fetchFromGitHub {
    owner = "saljam";
    repo = pname;
    rev = "25b68f4f4c1aaa0c6c1949b60bd4ef52ec972ebb";
    hash = "sha256-JFmfwHBa/lNGTOIIgnMFc4VMlsXtjX9v9Tn2XpdVMfA=";
  };

  vendorHash = "sha256-+7ctAm2wnjmfMd6CHXlcAUwiUMS7cH4koDAvlEUAXEg=";

  meta = with lib; {
    description = "Send files using peer authenticated WebRTC";
    homepage = "https://github.com/saljam/webwormhole";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bbigras ];
    mainProgram = "ww";
  };
}
