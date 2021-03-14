{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "nuclei";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "nuclei";
    rev = "v${version}";
    sha256 = "0xrvza86aczlnb11x58fiqch5g0q6gvpxwsi5dq3akfi95gk3a3x";
  };

  vendorSha256 = "1v3ax8l1lgp2vs50gsa2fhdd6bvyfdlkd118akrqmwxahyyyqycv";

  preBuild = ''
    mv v2/* .
  '';

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
