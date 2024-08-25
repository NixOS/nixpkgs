{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
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

  patches = [
    (fetchpatch {
      name = "CVE-2024-40641.patch";
      url = "https://github.com/projectdiscovery/nuclei/commit/1c51a6bef6a5d9a5b9c4967e4984595ef4bb48cd.patch";
      hash = "sha256-5yB37XIw7jUU80jHUCTtNHEOEw01CPyhB37eBleIe34=";
    })
  ];

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
