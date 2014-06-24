{ stdenv, lib, fetchgit, fetchhg, fetchbzr, fetchFromGitHub }:

let
  goDeps = [
    {
      root = "github.com/coreos/etcdctl";
      src = fetchFromGitHub {
        owner = "coreos";
        repo = "etcdctl";
        rev = "061135b2a02797a6b3c2b6c01183517c1bc76a2c";
        sha256 = "1hl9cz9ygr2k4d67qj9q1xj0n64b28qjy5sv7zylgg9h9ag2j2p4";
      };
    }
  ];

in

stdenv.mkDerivation rec {
  name = "go-deps";

  buildCommand =
    lib.concatStrings
      (map (dep: ''
              mkdir -p $out/src/`dirname ${dep.root}`
              ln -s ${dep.src} $out/src/${dep.root}
            '') goDeps);
}
