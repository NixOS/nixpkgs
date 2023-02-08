{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "nuclei";
  version = "2.8.8";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-limgyp13eh2FuD1MzqQn+NQ30fOJsvr8UT4kZrxnIPM=";
  };

  vendorHash = "sha256-nmZpYShVNAqBO8adxCSt9t3ocB3elWna06pIBG6dQNY=";

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
    changelog = "https://github.com/projectdiscovery/nuclei/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
