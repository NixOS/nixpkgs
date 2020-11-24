{ lib, buildGoModule, fetchFromGitHub, go }:

buildGoModule rec {
  pname = "cortextool";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "cortextool";
    rev = "v${version}";
    sha256 = "0p3g418bg6agk6manibazlb2rplv8253z5gka5nb37jvccz6k38v";
  };

  modSha256 = "0wpmn6clmsb5ird9h8wx6njg6xgpmw80zx4dbpmifsgirldi5yjd";

  buildFlagsArray =''
    -ldflags=
        -X main.Version=${version}
        -X main.Revision=unknown
        -X main.Branch=unknown
        -X main.BuildUser=nix@nixpkgs
        -X main.BuildDate=unknown
        -X main.GoVersion=${lib.getVersion go}
    '';

  doCheck = true;

  meta = with lib; {
    description = "A powerful command line tool for interacting with cortex";
    homepage = "https://github.com/grafana/cortextool";
    license = licenses.asl20;
    maintainers = with maintainers; [ ekpdt ];
  };
}
