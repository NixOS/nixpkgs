{ stdenv, lib, fetchgit, fetchhg, fetchbzr, fetchFromGitHub }:

let
  goDeps = [
    {
      root = "github.com/coreos/etcdctl";
      src = fetchFromGitHub {
        owner = "coreos";
        repo = "etcdctl";
        rev = "a1b38c93245542e340971189750baef7a55d306e";
        sha256 = "1kbri59ppil52v7s992q8r6i1zk9lac0s2w00z2lsgc9w1z59qs0";
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
