{ lib
, buildGoModule
, fetchFromGitHub
, testers
, kics
}:

buildGoModule rec {
  pname = "kics";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "Checkmarx";
    repo = "kics";
    rev = "v${version}";
    hash = "sha256-w9zLdj+/Wbf4MIyxDxn78tfmSZfwziK0UB2WSdrBSrU=";
  };

  vendorHash = "sha256-73b3j0/aEMDW1aFPPM3HWvdMRIJswv+F5o6jt6rPSwU=";

  subPackages = [ "cmd/console" ];

  postInstall = ''
    mv $out/bin/console $out/bin/kics
  '';

  ldflags = [
    "-s" "-w"
    "-X github.com/Checkmarx/kics/internal/constant.SCMCommits=${version}"
    "-X github.com/Checkmarx/kics/internal/constants.Version=${version}"
  ];

  passthru.tests.version = testers.testVersion {
    package = kics;
    command = "kics version";
  };

  meta = with lib; {
    description = ''
      Find security vulnerabilities, compliance issues, and infrastructure misconfigurations early in the development
      cycle of your infrastructure-as-code with KICS by Checkmarx.
    '';
    homepage = "https://github.com/Checkmarx/kics";
    license = licenses.asl20;
    maintainers = with maintainers; [ patryk4815 ];
    mainProgram = "kics";
  };
}
