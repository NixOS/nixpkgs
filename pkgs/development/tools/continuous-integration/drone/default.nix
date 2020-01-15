{ stdenv, fetchFromGitHub, buildGoPackage, go-bindata, go-bindata-assetfs }:

buildGoPackage rec {
  pname = "drone.io";
  version = "0.8.6-20180727-${stdenv.lib.strings.substring 0 7 revision}";
  revision = "c48150767c2700d35dcc29b110a81c8b5969175e";
  goPackagePath = "github.com/drone/drone";

  # These dependencies pulled (in `drone` buildprocess) via Makefile,
  # so I extracted them here, all revisions pinned by same date, as ${version}
  goDeps= ./deps.nix;

  nativeBuildInputs = [ go-bindata go-bindata-assetfs ];

  src = fetchFromGitHub {
    owner = "drone";
    repo = "drone";
    rev = revision;
    sha256 = "0miq2012nivvr1ysi3aa2xrr5ak3mf0l3drybyc83iycy0kp4bda";
  };

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ avnik vdemeester ];
    license = licenses.asl20;
    description = "Continuous Integration platform built on container technology";
  };
}
