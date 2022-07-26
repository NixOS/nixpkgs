{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "nuclei";
  version = "2.7.4";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-J65NAc0yswIgDPHH26mzx2OqMgcMV4n/gVG77Xe64wg=";
  };

  vendorSha256 = "sha256-ewKKn+P8W/Fl3VaRiTmbA88DyMLJ38CG2rDExSa3oWw=";

  modRoot = "./v2";
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
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
