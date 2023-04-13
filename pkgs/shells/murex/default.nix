{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "murex";
  version = "3.1.3100";

  src = fetchFromGitHub {
    owner = "lmorg";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-haYS3M3Cg+RBGbH5Af/9qcTkKroqx76r1Fb6Bf08lgY=";
  };

  vendorHash = "sha256-GKgwll9Cl+FMYwn07F7d33VXl4a9lcC7muzNvRzmR4k=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Bash-like shell and scripting environment with advanced features designed for safety and productivity";
    homepage = "https://murex.rocks";
    license = licenses.gpl2;
    maintainers = with maintainers; [ dit7ya ];
  };
}
