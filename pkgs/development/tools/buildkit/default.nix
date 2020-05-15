{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "buildkit";
  version = "0.7.1";

  subPackages = [ "cmd/buildctl" ] ++ stdenv.lib.optionals stdenv.isLinux [ "cmd/buildkitd" ];

  src = fetchFromGitHub {
    owner = "moby";
    repo = "buildkit";
    rev = "v${version}";
    sha256 = "048h69ffgmpir2ix9ldi6zrzlwxa5yz3idg5ajspz2dihmzmnwws";
  };


  meta = with stdenv.lib; {
    description = "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit";
    homepage = "https://github.com/moby/buildkit";
    license = licenses.asl20;
    maintainers = with maintainers; [ vdemeester marsam ];
  };
}