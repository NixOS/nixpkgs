{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "dex";
  version = "2.17.0";

  src = fetchFromGitHub {
    owner = "dexidp";
    repo = pname;
    rev = "v${version}";
    sha256 = "1z94svpiwrs64m83gpfnniv0ac1fnmvywvl05f20ind1wlf8bvwn";
  };

  goPackagePath = "github.com/dexidp/dex";

  subPackages = [
    "cmd/dex"
  ];

  buildFlagsArray = [
    "-ldflags=-w -X github.com/dexidp/dex/version.Version=${src.rev}"
  ];

  postInstall = ''
    mkdir -p $bin/share
    cp -r $src/web $bin/share/web
  '';

  meta = with lib; {
    description = "OpenID Connect and OAuth2 identity provider with pluggable connectors";
    homepage = "https://github.com/dexidp/dex";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
