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
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "smallstep";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Twi2Kixx1lIesVwxUkvAlvq0w+P7bdpwTuxNwRsNYQ8=";
  };

  vendorHash = "sha256-GjhpdcdRpxQczpkohBXTodwDcW9THSDJ9uQDDQY0hv0=";

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
