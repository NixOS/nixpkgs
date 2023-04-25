{ stdenv
, lib
, buildGoModule
, fetchFromGitHub
, pkg-config
, pcsclite
, softhsm
, opensc
, yubihsm-shell
, writeScriptBin }:

buildGoModule rec {
  pname = "step-kms-plugin";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "smallstep";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-1yJD5HHMUpcGV0PEN81Rizahd1+VlCCTtbcpV87mTWI=";
  };

  vendorHash = "sha256-IKMSBssfiMSoCmR2OF2kkMb+DPPPmfDof6W23oNfTg0=";

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
