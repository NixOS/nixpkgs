{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "maddy";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "foxcpp";
    repo = "maddy";
    rev = "v${version}";
    sha256 = "sha256-SxJfuNZBtwaILF4zD4hrTANc/GlOG53XVwg3NvKYAkg=";
  };

  vendorSha256 = "sha256-bxKEQaOubjRfLX+dMxVDzLOUInHykUdy9X8wvFE6Va4=";

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/foxcpp/maddy.Version=${version}" ];

  subPackages = [ "cmd/maddy" "cmd/maddyctl" ];

  meta = with lib; {
    description = "Composable all-in-one mail server";
    homepage = "https://foxcpp.dev/maddy";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ lxea ];
  };
}
