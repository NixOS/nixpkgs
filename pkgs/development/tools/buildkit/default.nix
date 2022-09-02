{ lib, stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "buildkit";
  version = "0.10.4";

  src = fetchFromGitHub {
    owner = "moby";
    repo = "buildkit";
    rev = "v${version}";
    sha256 = "sha256-vxu0QLZ6ERNV1lTH0/c0yR6FT/im5rn85oqQeRvdt6M=";
  };

  vendorSha256 = null;

  subPackages = [ "cmd/buildctl" ] ++ lib.optionals stdenv.isLinux [ "cmd/buildkitd" ];

  ldflags = [ "-s" "-w" "-X github.com/moby/buildkit/version.Version=${version}" "-X github.com/moby/buildkit/version.Revision=${src.rev}" ];

  doCheck = false;

  meta = with lib; {
    description = "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit";
    homepage = "https://github.com/moby/buildkit";
    license = licenses.asl20;
    maintainers = with maintainers; [ vdemeester marsam ];
    mainProgram = "buildctl";
  };
}
