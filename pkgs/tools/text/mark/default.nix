{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mark";
  version = "9.13.0";

  src = fetchFromGitHub {
    owner  = "kovetskiy";
    repo   = "mark";
    rev    = version;
    sha256 = "sha256-Y3mvseVIvKFuHuY7bSRAzbiAfa6lGYk1PfdhSiG6Is8=";
  };

  vendorHash = "sha256-DMjT4ja6yUaetTc+AHJBqf9hRU2KpE0+LGX36NgHzqU=";

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
