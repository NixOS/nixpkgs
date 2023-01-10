{ stdenv
, buildGoModule
, fetchFromGitHub
, lib
, testers
, kics
}:

buildGoModule rec {
  pname = "kics";
  version = "1.6.7";

  src = fetchFromGitHub {
    owner = "Checkmarx";
    repo = "kics";
    rev = "v${version}";
    sha256 = "sha256-VtQauOf3FavXULFeWWw3aThHZAFMuwuI/FYr0dtZc0A=";
  };

  vendorHash = "sha256-0Y4+tG54McwcRVuHXJBfs6Zg1fJBffeDs7JYInqfXe0=";

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
  };
}
