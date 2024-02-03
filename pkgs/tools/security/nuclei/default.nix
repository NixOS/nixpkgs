{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "nuclei";
  version = "3.1.9";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "nuclei";
    rev = "refs/tags/v${version}";
    hash = "sha256-0GQoX4S4k3d7/BJ1KDTKH9UceLL12IHlEAt1E4JRPLA=";
  };

  vendorHash = "sha256-0ERUvPUAxj0H62YcRvsfYX8h0Hp/mA6NdE8E/BjPGzw=";

  subPackages = [
    "cmd/nuclei/"
  ];

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
    maintainers = with maintainers; [ fab Misaka13514 ];
    mainProgram = "nuclei";
  };
}
