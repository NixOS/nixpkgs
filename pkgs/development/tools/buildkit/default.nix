{ stdenv, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  pname = "buildkit";
  version = "0.8.1";

  goPackagePath = "github.com/moby/buildkit";
  subPackages = [ "cmd/buildctl" ] ++ stdenv.lib.optionals stdenv.isLinux [ "cmd/buildkitd" ];

  src = fetchFromGitHub {
    owner = "moby";
    repo = "buildkit";
    rev = "v${version}";
    sha256 = "0lqfz097nyb6q6bn5mmfg6vl1nmgb6k4lmwxc8anza6zp8qh7wif";
  };

  buildFlagsArray = [ "-ldflags=-s -w -X ${goPackagePath}/version.Version=${version} -X ${goPackagePath}/version.Revision=${src.rev}" ];

  meta = with stdenv.lib; {
    description = "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit";
    homepage = "https://github.com/moby/buildkit";
    license = licenses.asl20;
    maintainers = with maintainers; [ vdemeester marsam ];
  };
}
