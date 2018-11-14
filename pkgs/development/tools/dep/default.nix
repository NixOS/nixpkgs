{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "dep-${version}";
  version = "0.5.0";
  rev = "v${version}";

  goPackagePath = "github.com/golang/dep";
  subPackages = [ "cmd/dep" ];

  src = fetchFromGitHub {
    inherit rev;
    owner = "golang";
    repo = "dep";
    sha256 = "1p35995w2f8rp4cxhcwnhdv26ajx6gxx9pm2ijb5sjy2pwhw5c6j";
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
