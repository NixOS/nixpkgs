{ stdenv
, lib
, buildGoModule
, fetchFromGitHub
, pkg-config
, pcsclite
, softhsm
, opensc
, yubihsm-shell
<<<<<<< HEAD
}:

buildGoModule rec {
  pname = "step-kms-plugin";
  version = "0.9.1";
=======
, writeScriptBin }:

buildGoModule rec {
  pname = "step-kms-plugin";
  version = "0.8.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "smallstep";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-pbSv3qTQkeYWtg5HKu9kUIWYw6t6yKKA4GQuiwGEPD8=";
  };

  vendorHash = "sha256-hb1Nn/+PVhhBByQ8I9MuUEd5di5jEZVMtSpm0+qBXQk=";
=======
    hash = "sha256-1yJD5HHMUpcGV0PEN81Rizahd1+VlCCTtbcpV87mTWI=";
  };

  vendorHash = "sha256-IKMSBssfiMSoCmR2OF2kkMb+DPPPmfDof6W23oNfTg0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  proxyVendor = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    opensc
    pcsclite
    softhsm
    yubihsm-shell
  ];

  ldflags = [
    "-w"
    "-s"
    "-X github.com/smallstep/step-kms-plugin/cmd.Version=${version}"
  ];

  meta = with lib; {
    description = "step plugin to manage keys and certificates on cloud KMSs and HSMs";
    homepage = "https://smallstep.com/cli/";
    license = licenses.asl20;
    maintainers = with maintainers; [ qbit ];
    mainProgram = "step-kms-plugin";
    # can't find pcsclite header files
    broken = stdenv.isDarwin;
  };
}
