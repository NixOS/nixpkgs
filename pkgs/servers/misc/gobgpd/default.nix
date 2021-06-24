{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "gobgpd";
  version = "2.26.0";

  src = fetchFromGitHub {
    owner = "osrg";
    repo = "gobgp";
    rev = "v${version}";
    sha256 = "10fq74hv3vmcq58i3w67ic370925vl9wl6khcmy3f2vg60i962di";
  };

  vendorSha256 = "0dmd4r6x76jn8pyvp47x4llzc2wij5m9lchgyaagcb5sfdgbns9x";

  postConfigure = ''
    export CGO_ENABLED=0
  '';

  buildFlagsArray = ''
    -ldflags=
    -s -w -extldflags '-static'
  '';

  subPackages = [ "cmd/gobgpd" ];

  meta = with lib; {
    description = "BGP implemented in Go";
    homepage = "https://osrg.github.io/gobgp/";
    changelog = "https://github.com/osrg/gobgp/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ higebu ];
  };
}
