{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "dex";
  version = "2.23.0";

  src = fetchFromGitHub {
    owner = "dexidp";
    repo = pname;
    rev = "v${version}";
    sha256 = "1fr5r7d0xwj0b69jhszyyif4yc4kiy7zpfcpf83zdy12mh8f96c8";
  };

  goPackagePath = "github.com/dexidp/dex";

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
