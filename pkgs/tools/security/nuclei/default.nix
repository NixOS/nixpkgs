{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "nuclei";
  version = "2.7.9";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-cAXIb8C14cpBKLpvQfJT2JbSy7Jf3SL4XyXVISoI8vE=";
  };

  vendorSha256 = "sha256-qIEKGnFURtfh8CdHSbAtEaQRrsjfpvwyK+uPmYNXpiA=";

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
