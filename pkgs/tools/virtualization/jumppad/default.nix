{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "jumppad";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "jumppad-labs";
    repo = "jumppad";
    rev = version;
    hash = "sha256-jG/XTMkedgDSncCW7YbII3g3ieB1i0Z9cOEVfZiczHI=";
  };
  vendorHash = "sha256-FPM0q1ZVDfo00Z6QEXqtqfx77qkq5HhB+3vF9z9zrM0=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-X main.version=${version}"
  ];

  # Tests require a large variety of tools and resources to run including
  # Kubernetes, Docker, and GCC.
  doCheck = false;

  meta = with lib; {
    description = "Tool for building modern cloud native development environments";
    homepage = "https://jumppad.dev";
    license = licenses.mpl20;
    maintainers = with maintainers; [ cpcloud ];
    mainProgram = "jumppad";
  };
}
