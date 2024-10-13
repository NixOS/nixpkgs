{ stdenv
, lib
, buildGoModule
, fetchFromGitHub
, pkg-config
, pcsclite
, softhsm
, opensc
, yubihsm-shell
}:

buildGoModule rec {
  pname = "step-kms-plugin";
  version = "0.11.5";

  src = fetchFromGitHub {
    owner = "smallstep";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-MxGhG8ehXT7ftXfoVHMSpyIr25tWj5Yq50nZZW/q5sQ=";
  };

  vendorHash = "sha256-5TWofXHtiBhfsSg3UgSju+7EO+t9bUktsd/WUAH5R5U=";

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
    broken = stdenv.hostPlatform.isDarwin;
  };
}
