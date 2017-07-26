{ lib, buildGoPackage, fetchFromGitHub }:

let version = "2.4.1"; in

buildGoPackage rec {
  name = "dex-${version}";

  goPackagePath = "github.com/coreos/dex";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "coreos";
    repo = "dex";
    sha256 = "11qpn3wh74mq16xgl9l50n2v02ffqcd14xccf77j5il04xr764nx";
  };

  subPackages = [
    "cmd/dex"
  ];

  buildFlagsArray = [
    "-ldflags=-w -X ${goPackagePath}/version.Version=${src.rev}"
  ];

  meta = {
    description = "OpenID Connect and OAuth2 identity provider with pluggable connectors";
    license = lib.licenses.asl20;
    homepage = https://github.com/coreos/dex;
    maintainers = with lib.maintainers; [benley];
    platforms = lib.platforms.unix;
  };
}
