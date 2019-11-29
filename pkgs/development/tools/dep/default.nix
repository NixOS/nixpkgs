{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "dep";
  version = "0.5.4";
  rev = "v${version}";

  goPackagePath = "github.com/golang/dep";
  subPackages = [ "cmd/dep" ];

  src = fetchFromGitHub {
    inherit rev;
    owner = "golang";
    repo = "dep";
    sha256 = "02akzbjar1v01rdal746vk6mklff29yk2mqfyjk1zrs0mlg38ygd";
  };

  buildFlagsArray = ("-ldflags=-s -w -X main.commitHash=${rev} -X main.version=${version}");

  meta = with stdenv.lib; {
    homepage = https://github.com/golang/dep;
    description = "Go dependency management tool";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ carlsverre rvolosatovs ];
  };
}
