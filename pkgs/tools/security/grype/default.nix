{ lib
, buildGoModule
, docker
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "grype";
  version = "0.27.3";

  src = fetchFromGitHub {
    owner = "anchore";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-W1HP+bzsLY8SaZQK+H33mibM7lfxoGnKnOvsStwzv4E=";
  };

  vendorSha256 = "sha256-IwEQkdspSjdlm4siwhaBZsIaRz8oKKG6d6PAK1MvHlw=";

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
