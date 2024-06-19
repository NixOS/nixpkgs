{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "nuclei";
  version = "3.2.8";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "nuclei";
    rev = "refs/tags/v${version}";
    hash = "sha256-U/L9V/1aGMjh30s/XDgV522RdLhS1yyUkHwkFDWjA4U=";
  };

  vendorHash = "sha256-DGNjDKjFZ0EJPOJxC7nTCCts8pisomfe4eru2WAHHow=";

  subPackages = [ "cmd/nuclei/" ];

  ldflags = [
    "-w"
    "-s"
  ];

  # Test files are not part of the release tarball
  doCheck = false;

  meta = with lib; {
    description = "Tool for configurable targeted scanning";
    longDescription = ''
      Nuclei is used to send requests across targets based on a template
      leading to zero false positives and providing effective scanning
      for known paths. Main use cases for nuclei are during initial
      reconnaissance phase to quickly check for low hanging fruits or
      CVEs across targets that are known and easily detectable.
    '';
    homepage = "https://github.com/projectdiscovery/nuclei";
    changelog = "https://github.com/projectdiscovery/nuclei/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      fab
      Misaka13514
    ];
    mainProgram = "nuclei";
  };
}
