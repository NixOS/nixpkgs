{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "exoscale-cli";
  version = "1.54.0";

  src = fetchFromGitHub {
    owner = "exoscale";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-uvPJ1cOKMpDf1KfEPkSTWMIMNojUlfpqI1ESomX1MlM=";
  };

  vendorSha256 = null;

  excludedPackages = [ "./completion" "./docs" ];

  ldflags = [ "-s" "-w" "-X main.version=${version}" "-X main.commit=${src.rev}" ];

  # we need to rename the resulting binary but can't use buildFlags with -o here
  # because these are passed to "go install" which does not recognize -o
  postBuild = ''
    mv $GOPATH/bin/cli $GOPATH/bin/exo
  '';

  meta = {
    description = "Command-line tool for everything at Exoscale: compute, storage, dns";
    homepage = "https://github.com/exoscale/cli";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dramaturg ];
    mainProgram = "exo";
  };
}
