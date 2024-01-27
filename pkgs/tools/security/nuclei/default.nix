{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "nuclei";
  version = "3.1.7";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "nuclei";
    rev = "refs/tags/v${version}";
    hash = "sha256-O7GWH65zOKK9mPlap5BL302ow/ruXOz8CxUjaHfIj3w=";
  };

  vendorHash = "sha256-mwqDoX79cnG6zPncN1l5uAdOSbyAVWzw2dV+2rnBsqw=";

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
