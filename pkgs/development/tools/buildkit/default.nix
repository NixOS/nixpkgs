{ lib, stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "buildkit";
  version = "0.13.2";

  src = fetchFromGitHub {
    owner = "moby";
    repo = "buildkit";
    rev = "v${version}";
    hash = "sha256-Kb5p838jezDTJnc2jcKnima1gE7ENMm+4cmN6F6vh+Y=";
  };

  vendorHash = null;

  subPackages = [ "cmd/buildctl" ] ++ lib.optionals stdenv.isLinux [ "cmd/buildkitd" ];

  ldflags = [ "-s" "-w" "-X github.com/moby/buildkit/version.Version=${version}" "-X github.com/moby/buildkit/version.Revision=${src.rev}" ];

  doCheck = false;

  meta = with lib; {
    description = "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit";
    homepage = "https://github.com/moby/buildkit";
    changelog = "https://github.com/moby/buildkit/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ vdemeester developer-guy ];
    mainProgram = "buildctl";
  };
}
