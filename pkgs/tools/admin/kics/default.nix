{ lib
, buildGoModule
, fetchFromGitHub
, testers
, kics
}:

buildGoModule rec {
  pname = "kics";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "Checkmarx";
    repo = "kics";
    rev = "v${version}";
    hash = "sha256-OdX3ipfPj+rope5oT5ND9MEaefW36X6XDV5F7PaQOuw=";
  };

  vendorHash = "sha256-vYAMzXBQIt8F9DTGLkWNXx6e08MPo12W2ogiTZ8gcjw=";

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
