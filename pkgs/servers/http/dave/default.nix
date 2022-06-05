{ lib, buildGoPackage, fetchFromGitHub, mage }:

buildGoPackage rec {
  pname = "dave";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "micromata";
    repo = "dave";
    rev = "v${version}";
    sha256 = "sha256-wvsW4EwMWAgEV+LPeMhHL4AsuyS5TDMmpD9D4F1nVM4=";
  };

  goPackagePath = "github.com/micromata/dave";

  subPackages = [ "cmd/dave" "cmd/davecli" ];

  ldflags =
    [ "-s" "-w" "-X main.version=${version}" "-X main.builtBy=nixpkgs" ];

  meta = with lib; {
    homepage = "https://github.com/micromata/dave";
    description =
      "A totally simple and very easy to configure stand alone webdav server";
    license = licenses.asl20;
    maintainers = with maintainers; [ lunik1 ];
  };
}
