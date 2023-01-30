{ lib, stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "buildkit";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "moby";
    repo = "buildkit";
    rev = "v${version}";
    hash = "sha256-P1hu60vjJJASWxgc9LOwdy7psqgIHi8Z/D5c++TProY=";
  };

  vendorHash = null;

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
