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
  version = "0.11.3";

  src = fetchFromGitHub {
    owner = "smallstep";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Gl/5AExN2/MEoR2HKpw7mDfuc/1Wj0UGSdXPzHl2JdU=";
  };

  vendorHash = "sha256-O6orQYrupJdJbx23TXCP0qWyvn6Hv2iDeRYvIgLp1NM=";

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
