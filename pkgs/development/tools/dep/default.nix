{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "dep-${version}";
  version = "0.4.1";
  rev = "v${version}";

  goPackagePath = "github.com/golang/dep";
  subPackages = [ "cmd/dep" ];

  src = fetchFromGitHub {
    inherit rev;
    owner = "golang";
    repo = "dep";
    sha256 = "0183xq5l4sinnclynv6xi85vmk69mqpy5wjfsgh8bxwziq3vkd7y";
  };

  buildFlagsArray = ("-ldflags=-s -w -X main.commitHash=${rev} -X main.version=${version}");

  meta = with stdenv.lib; {
    homepage = https://github.com/golang/dep;
    description = "Go dependency management tool";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = [ maintainers.carlsverre ];
  };
}
