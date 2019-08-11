{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "dep-${version}";
  version = "0.5.1";
  rev = "v${version}";

  goPackagePath = "github.com/golang/dep";
  subPackages = [ "cmd/dep" ];

  src = fetchFromGitHub {
    inherit rev;
    owner = "golang";
    repo = "dep";
    sha256 = "1a5vq5v3ikg6iysbywxr5hcjnbv76nzhk50rd3iq3v2fnyq38dv2";
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
