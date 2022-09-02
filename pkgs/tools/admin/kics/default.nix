{ stdenv, buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "kics";
  version = "1.5.15";

  src = fetchFromGitHub {
    owner = "Checkmarx";
    repo = "kics";
    rev = "v${version}";
    sha256 = "sha256-e6esrGb1p96yV9Ce7z0UCapXqOpRPjFb4EdStolAiMk=";
  };

  vendorSha256 = "sha256-eieulT+Vt6p2+gmQ/Ic8kgd3Cg6uHX0LSUSr/QrK/yw=";

  subPackages = [ "cmd/console" ];

  postInstall = ''
    mv $out/bin/console $out/bin/kics
  '';

  ldflags = [
    "-s" "-w"
    "-X github.com/Checkmarx/kics/internal/constant.SCMCommits=${version}"
    "-X github.com/Checkmarx/kics/internal/constants.Version=${version}"
  ];

  meta = with lib; {
    description = ''
      Find security vulnerabilities, compliance issues, and infrastructure misconfigurations early in the development
      cycle of your infrastructure-as-code with KICS by Checkmarx.
    '';
    homepage = "https://github.com/Checkmarx/kics";
    license = licenses.asl20;
    maintainers = with maintainers; [ patryk4815 ];
  };
}
