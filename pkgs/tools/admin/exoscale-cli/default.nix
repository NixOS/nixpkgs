{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "exoscale-cli";
  version = "1.45.2";

  src = fetchFromGitHub {
    owner  = "exoscale";
    repo   = "cli";
    rev    = "v${version}";
    sha256 = "sha256-bzm8UNFWAXHBdarovNMyARW2xA4tSXIgIHpxROx4nOI=";
  };

  goPackagePath = "github.com/exoscale/cli";

  ldflags = [ "-s" "-w" "-X main.version=${version}" "-X main.commit=${src.rev}" ];

  # ensures only the cli binary is built and we don't clutter bin/ with submodules
  subPackages = [ "." ];

  # we need to rename the resulting binary but can't use buildFlags with -o here
  # because these are passed to "go install" which does not recognize -o
  postBuild = ''
    mv go/bin/cli go/bin/exo
  '';

  meta = {
    description = "Command-line tool for everything at Exoscale: compute, storage, dns";
    homepage    = "https://github.com/exoscale/cli";
    license     = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dramaturg ];
  };
}
