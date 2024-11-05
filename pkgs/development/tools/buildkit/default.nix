{ lib, stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "buildkit";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "moby";
    repo = "buildkit";
    rev = "v${version}";
    hash = "sha256-+FwbYG7PCj9+WG9CnR/MjmujnhfqWYtu99raT1tO+m4=";
  };

  vendorHash = null;

  subPackages = [ "cmd/buildctl" ] ++ lib.optionals stdenv.hostPlatform.isLinux [ "cmd/buildkitd" ];

  ldflags = [ "-s" "-w" "-X github.com/moby/buildkit/version.Version=${version}" "-X github.com/moby/buildkit/version.Revision=${src.rev}" ];

  doCheck = false;

  meta = {
    description = "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit";
    homepage = "https://github.com/moby/buildkit";
    changelog = "https://github.com/moby/buildkit/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ developer-guy vdemeester ];
    mainProgram = "buildctl";
  };
}
