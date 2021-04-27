{ lib
, buildGoModule
, docker
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "grype";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "anchore";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-E1tJ9hEJ4GaL+S4dz6aGq3nJPpdtx0/Tfb1RzgJSe8M=";
  };

  vendorSha256 = "sha256-LUyrX/rm01tCPT6Ua6hphhf+4ycNn4tLONRyH3iTrZ4=";

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
