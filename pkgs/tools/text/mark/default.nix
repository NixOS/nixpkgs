{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mark";
  version = "10.0.0";

  src = fetchFromGitHub {
    owner  = "kovetskiy";
    repo   = "mark";
    rev    = version;
    sha256 = "sha256-66mXxM0J0G+RVaeXKwdGycSmXBiaiyVg57kmOzZmNUo=";
  };

  vendorHash = "sha256-mGdwFqQ606JX+9xLDITaQrcNW9tR0sC0BMvdUddJxO4=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  checkFlags =
    let
      skippedTests = [
        # Expects to be able to launch google-chrome
        "TestExtractMermaidImage"
      ];
    in [
      "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$"
    ];

  meta = with lib; {
    description = "Tool for syncing your markdown documentation with Atlassian Confluence pages";
    mainProgram = "mark";
    homepage = "https://github.com/kovetskiy/mark";
    license = licenses.asl20;
    maintainers = with maintainers; [ rguevara84 ];
  };
}
