{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "dep-${version}";
  version = "0.3.1";
  rev = "v${version}";

  goPackagePath = "github.com/golang/dep";
  subPackages = [ "cmd/dep" ];

  src = fetchFromGitHub {
    inherit rev;
    owner = "golang";
    repo = "dep";
    sha256 = "0dsiaqfrp7ihhx10qapkl6zm3dw3rwdgcr9rkvmq8zprcp7njz90";
  };

  buildFlagsArray = ("-ldflags=-s -w -X main.commitHash=${rev} -X main.version=${version}");

  meta = with stdenv.lib; {
    homepage = https://github.com/golang/dep;
    description = "Go dependency management tool";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.carlsverre ];
  };
}
