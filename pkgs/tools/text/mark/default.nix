{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mark";
  version = "9.12.0";

  src = fetchFromGitHub {
    owner  = "kovetskiy";
    repo   = "mark";
    rev    = version;
    sha256 = "sha256-GbtwC361BI02mI1xzwdH9iqTIrY5ItiAKfZ7C3uk5ms=";
  };

  vendorHash = "sha256-3OTHHhRgY9N6l6GXN6HCbmPAgpXyfyJ/3KAZWLltz24=";

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
