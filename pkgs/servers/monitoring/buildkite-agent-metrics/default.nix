{ lib, go, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "buildkite-agent-metrics";
  version = "5.1.0";
  goDeps = ./deps.nix;
  goPackagePath = "github.com/buildkite/buildkite-agent-metrics";

  preBuild = ''
    rm -rf go/src/${goPackagePath}/vendor
  '';

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "buildkite";
    repo = "buildkite-agent-metrics";
    sha256 = "1dx8vhp07yc5c02la7iq5mxxj2lglsm4jzfb5vsac0vn70c9dwci";
  };

  buildFlagsArray = let
    t = "${goPackagePath}/vendor/github.com/buildkite/buildkite-agent-metrics/version";
  in ''
    -ldflags=
       -X ${t}.Version=${version}
       -X ${t}.Revision=unknown
       -X ${t}.Branch=unknown
       -X ${t}.BuildUser=nix@nixpkgs
       -X ${t}.BuildDate=unknown
       -X ${t}.GoVersion=${lib.getVersion go}
  '';

  doCheck = true;

  meta = with lib; {
    description = "A command-line tool (and Lambda) for collecting Buildkite agent metrics";
    homepage = "https://github.com/buildkite/buildkite-agent-metrics";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
