{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "dep-${version}";
  version = "0.4.0";
  rev = "v${version}";

  goPackagePath = "github.com/golang/dep";
  subPackages = [ "cmd/dep" ];

  src = fetchFromGitHub {
    inherit rev;
    owner = "golang";
    repo = "dep";
    sha256 = "1m325p1brzhqkabibc1ifvrsa589m0077z33l3hzq6ml88qm6nyp";
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
