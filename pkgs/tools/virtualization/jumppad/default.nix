{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "jumppad";
  version = "0.5.51";

  src = fetchFromGitHub {
    owner = "jumppad-labs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Az/rNkGwwrYZfay+KjINjIT2PNsoGDNCwZnXZTeKqM4=";
  };
  vendorHash = "sha256-onUs7ZbnzJGbs+Q+1jvqUp9y9ecOxhtcdx/fkxZntmc=";

  ldflags = [
    "-s" "-w" "-X main.version=${version}"
  ];

  # Tests require a large variety of tools and resources to run including
  # Kubernetes, Docker, and GCC.
  doCheck = false;

  meta = with lib; {
    description = "A tool for building modern cloud native development environments";
    homepage = "https://jumppad.dev";
    license = licenses.mpl20;
    maintainers = with maintainers; [ cpcloud ];
  };
}
