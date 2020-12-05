{ stdenv, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  pname = "buildkit";
  version = "0.8.0";

  goPackagePath = "github.com/moby/buildkit";
  subPackages = [ "cmd/buildctl" ] ++ stdenv.lib.optionals stdenv.isLinux [ "cmd/buildkitd" ];

  src = fetchFromGitHub {
    owner = "moby";
    repo = "buildkit";
    rev = "v${version}";
    sha256 = "0qcgq93wj77i912xqhwrzkzaqz608ilczfn5kcsrf9jk2m1gnx7m";
  };

  buildFlagsArray = [ "-ldflags=-s -w -X ${goPackagePath}/version.Version=${version} -X ${goPackagePath}/version.Revision=${src.rev}" ];

  meta = with stdenv.lib; {
    description = "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit";
    homepage = "https://github.com/moby/buildkit";
    license = licenses.asl20;
    maintainers = with maintainers; [ vdemeester marsam ];
  };
}
