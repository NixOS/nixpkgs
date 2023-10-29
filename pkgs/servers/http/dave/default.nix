{ lib, buildGoModule, fetchFromGitHub, mage }:

buildGoModule rec {
  pname = "dave";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "micromata";
    repo = "dave";
    rev = "v${version}";
    hash = "sha256-JgRclcSrdgTXBuU8attSbDhRj4WUGXSpKTrUZ8mP5ns=";
  };

  vendorHash = "sha256-yo6DEvKnCQak+MrpIIDU4DkRhRP+HeJXLV87NRf6g/c=";

  subPackages = [ "cmd/dave" "cmd/davecli" ];

  ldflags = [ "-s" "-w" "-X main.version=${version}" "-X main.builtBy=nixpkgs" ];

  meta = with lib; {
    homepage = "https://github.com/micromata/dave";
    description = "A totally simple and very easy to configure stand alone webdav server";
    license = licenses.asl20;
    maintainers = with maintainers; [ lunik1 ];
    broken = true; # unmaintained, to be removed before 24.05
  };
}
