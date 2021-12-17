{ lib
, buildGoModule
, docker
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "grype";
  version = "0.26.1";

  src = fetchFromGitHub {
    owner = "anchore";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-B+b+Fb5nUBLSGeZ+ZUpvcZ+jOIotskXEPFoaQ48ob34=";
  };

  vendorSha256 = "sha256-w4mN9O5FKZNCksS8OwF3Ty9c1V552MAbMhqisQDK9GY=";

  propagatedBuildInputs = [ docker ];

  ldflags = [
    "-s" "-w" "-X github.com/anchore/grype/internal/version.version=${version}"
  ];

  # Tests require a running Docker instance
  doCheck = false;

  meta = with lib; {
    description = "Vulnerability scanner for container images and filesystems";
    longDescription = ''
      As a vulnerability scanner is grype abale to scan the contents of a container
      image or filesystem to find known vulnerabilities.
    '';
    homepage = "https://github.com/anchore/grype";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
