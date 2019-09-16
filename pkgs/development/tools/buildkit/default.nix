{ stdenv, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  pname = "buildkit";
  version = "0.4.0";
  rev = "v${version}";

  goPackagePath = "github.com/moby/buildkit";
  subPackages = [ "cmd/buildctl" ] ++ stdenv.lib.optionals stdenv.isLinux [ "cmd/buildkitd" ];

  src = fetchFromGitHub {
    inherit rev;
    owner = "moby";
    repo = "buildkit";
    sha256 = "0gkwcjqbcskn63y79jwa26hxkps452z4bgz8lrryaskzbdpvhh3d";
  };

  meta = with stdenv.lib; {
    description = "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit";
    homepage = https://github.com/moby/buildkit;
    license = licenses.asl20;
    maintainers = with maintainers; [ vdemeester ];
  };
}
