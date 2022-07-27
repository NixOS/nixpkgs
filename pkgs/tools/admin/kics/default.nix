{ stdenv, buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "kics";
  version = "1.5.12";

  src = fetchFromGitHub {
    owner = "Checkmarx";
    repo = "kics";
    rev = "v${version}";
    sha256 = "sha256-jHspStyjq5T9jzYDRYaf2gOI4F/X+h4nDn0PFUOHoBY=";
  };

  vendorSha256 = "sha256-q5NuuP04kOoLVj210s17fIW2cxrsC/tAyET8YYGai0M=";

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
