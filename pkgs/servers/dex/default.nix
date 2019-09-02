{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dex";
  version = "2.17.0";

  src = fetchFromGitHub {
    owner = "dexidp";
    repo = pname;
    rev = "v${version}";
    sha256 = "1z94svpiwrs64m83gpfnniv0ac1fnmvywvl05f20ind1wlf8bvwn";
  };

  modSha256 = "043sjq547nwg5v8708nhij0g7d2j28pyn676fgbnpps35ymnywfi";

  subPackages = [
    "cmd/dex"
  ];

  buildFlagsArray = [
    "-ldflags=-w -X github.com/dexidp/dex/version.Version=${src.rev}"
  ];

  postInstall = ''
    mkdir -p $out/share
    cp -r $src/web $out/share/web
  '';

  meta = with lib; {
    description = "OpenID Connect and OAuth2 identity provider with pluggable connectors";
    homepage = "https://github.com/dexidp/dex";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
