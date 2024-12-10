{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "wire";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "wire";
    rev = "v${version}";
    hash = "sha256-bV/bb577JzGF37HmvRprxr+GWcLLiFRisURwtGDbqko=";
  };

  patches = [
    # Bump the minimum version of Go required to compile packages in this module,
    # as `golang.org/x/tools` requires go1.18 or later.
    ./go-modules.patch
  ];

  vendorHash = "sha256-7IW97ZvCGlKCiVh8mKQutTdAxih7oFkXrKo4h3Pl9YY=";

  subPackages = [ "cmd/wire" ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    homepage = "https://github.com/google/wire";
    description = "A code generation tool that automates connecting components using dependency injection";
    mainProgram = "wire";
    license = licenses.asl20;
    maintainers = with maintainers; [ svrana ];
  };
}
