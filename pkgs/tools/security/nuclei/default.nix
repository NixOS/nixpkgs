{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "nuclei";
  version = "3.0.4";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-S8YU25JA1yBdbDQpy9kxl3I/4PkMN9BrueCiXrZXAEI=";
  };

  vendorHash = "sha256-4i6jLRe9yDxC6FPOpFrwaLWjg16HR9PqkHNamlwT3PA=";

  subPackages = [
    "cmd/nuclei/"
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
  };
}
