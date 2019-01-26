# with import <nixpkgs>{};
{ stdenv, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  name = "drone-cli-${version}";
  version = "0.8.6";
  revision = "v${version}";
  goPackagePath = "github.com/drone/drone-cli";

  goDeps= ./deps.nix;

  src = fetchFromGitHub {
    owner = "drone";
    repo = "drone-cli";
    rev = revision;
    sha256 = "1vvilpqyx9jl0lc9hr73qxngwhwbyk81fycal7ys1w59gv9hxrh9";
  };

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ bricewge ];
    license = licenses.asl20;
    description = "Command line client for the Drone continuous integration server.";
  };
}
