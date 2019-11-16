{ stdenv, fetchFromGitHub, buildGoModule }:

let version = "1.2.0";
in buildGoModule rec {
  inherit version;
  pname = "drone-cli";
  revision = "v${version}";
  goPackagePath = "github.com/drone/drone-cli";

  modSha256 = "0jvhnrvqi1axypyzgjzbv44s7w1j53y6wak6xlkxdm64qw6pf1hc";

  preBuild = ''
    buildFlagsArray+=("-ldflags" "-X main.version=${version}")
  '';

  src = fetchFromGitHub {
    owner = "drone";
    repo = "drone-cli";
    rev = revision;
    sha256 = "1b1c3mih760z3hx5xws9h4m1xhlx1pm4qhm3sm31cyim9p8rmi4s";
  };

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ bricewge ];
    license = licenses.asl20;
    description = "Command line client for the Drone continuous integration server.";
  };
}
