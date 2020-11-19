{ stdenv, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  pname = "buildkit";
  version = "0.7.2";

  goPackagePath = "github.com/moby/buildkit";
  subPackages = [ "cmd/buildctl" ] ++ stdenv.lib.optionals stdenv.isLinux [ "cmd/buildkitd" ];

  src = fetchFromGitHub {
    owner = "moby";
    repo = "buildkit";
    rev = "v${version}";
    sha256 = "0kn2ad0rh3xlcxjxslkyrfxhv3cx88996nhxn86605x1mybxb2iq";
  };

  buildFlagsArray = [ "-ldflags=-s -w -X ${goPackagePath}/version.Version=${version} -X ${goPackagePath}/version.Revision=${src.rev}" ];

  meta = with stdenv.lib; {
    description = "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit";
    homepage = "https://github.com/moby/buildkit";
    license = licenses.asl20;
    maintainers = with maintainers; [ vdemeester marsam ];
  };
}
