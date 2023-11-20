{ lib, buildGoModule, fetchFromGitHub, fetchpatch, testers, docker-credential-gcr }:

buildGoModule rec {
  pname = "docker-credential-gcr";
  version = "2.1.8";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "docker-credential-gcr";
    rev = "v${version}";
    sha256 = "sha256-6f84NRqMx0NX+3g+pCYgRYkGK4DaQmUEau3oMswUmSE=";
  };

  patches = [
    (fetchpatch {
      name = "fix-TestGet_GCRCredentials.patch";
      url = "https://github.com/GoogleCloudPlatform/docker-credential-gcr/commit/a0c080e58bbfdeb0aa24e66551c4e8b0359bf178.patch";
      sha256 = "sha256-aXp/1kNaxqQDPszC7pO+qP7ZBWHjpVljUHiKFnnDWuM=";
    })
  ];

  postPatch = ''
    rm -rf ./test
  '';

  vendorHash = "sha256-e7XNTizZYp/tS7KRvB9KxY3Yurphnm6Ehz4dHZNReK8=";

  CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/GoogleCloudPlatform/docker-credential-gcr/config.Version=${version}"
  ];

  passthru.tests.version = testers.testVersion {
    package = docker-credential-gcr;
    command = "docker-credential-gcr version";
  };

  meta = with lib; {
    description = "A Docker credential helper for GCR (https://gcr.io) users";
    longDescription = ''
      docker-credential-gcr is Google Container Registry's Docker credential
      helper. It allows for Docker clients v1.11+ to easily make
      authenticated requests to GCR's repositories (gcr.io, eu.gcr.io, etc.).
    '';
    homepage = "https://github.com/GoogleCloudPlatform/docker-credential-gcr";
    license = licenses.asl20;
    maintainers = with maintainers; [ suvash ];
  };
}
