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
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "smallstep";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-FQ9UW1zz+8HMFETZVef7oyh2+Nm5z3ksvmOv/MTiKAU=";
  };

  vendorHash = "sha256-bpQHe7B7dG1oeGP/V3su0Zc6in7tive7lmh18KqxGfo=";

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
