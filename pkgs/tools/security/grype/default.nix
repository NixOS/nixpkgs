{ lib
, buildGoModule
, docker
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "grype";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "anchore";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-xiUDyuVNVkVT+kxOEFOq4RKxMc5nNjsom/ZTKzfkOhU=";
  };

  vendorSha256 = "sha256-mW3e4WFa9pKSpyTZYmPA2j8nZz+94G2PqdqI0BDo3wc=";

  propagatedBuildInputs = [ docker ];

  preBuild = ''
    buildFlagsArray+=("-ldflags" "-s -w -X github.com/anchore/grype/internal/version.version=${version}")
  '';

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
