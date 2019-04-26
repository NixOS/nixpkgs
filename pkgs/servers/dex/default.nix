{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "dex";
  version = "2.16.0";

  goPackagePath = "github.com/dexidp/dex";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "dexidp";
    repo = pname;
    sha256 = "0w8nl7inqp4grbaq320dgynmznbrln8vihd799dwb2cx86laxsi1";
  };

  subPackages = [
    "cmd/dex"
  ];

  buildFlagsArray = [
    "-ldflags=-w -X ${goPackagePath}/version.Version=${src.rev}"
  ];

  postInstall = ''
    mkdir -p $out/share
    cp -r go/src/${goPackagePath}/web $out/share/web
  '';

  meta = {
    description = "OpenID Connect and OAuth2 identity provider with pluggable connectors";
    license = lib.licenses.asl20;
    homepage = https://github.com/dexidp/dex;
    maintainers = with lib.maintainers; [benley];
    platforms = lib.platforms.unix;
  };
}
