{
  buildGoModule,
  fetchFromGitHub,
  lib,
  docker,
}:

buildGoModule rec {
  pname = "docker-ls";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "mayflower";
    repo = "docker-ls";
    rev = "v${version}";
    sha256 = "sha256-4+REt0NH4S367qFsyJncVedUrC4t1zw5o0CLTiQfIz8=";
  };

  vendorHash = "sha256-UulcjQOLEIP++eoYQTEIbCJW51jyE312dMxB8+AKcdU=";

  meta = with lib; {
    description = "Tools for browsing and manipulating docker registries";
    longDescription = ''
      Docker-ls is a set of CLI tools for browsing and manipulating docker registries.
      In particular, docker-ls can handle authentication and display the sha256 content digests associated
      with tags.
    '';

    homepage = "https://github.com/mayflower/docker-ls";
    maintainers = with maintainers; [ ];
    platforms = docker.meta.platforms;
    license = licenses.mit;
  };
}
