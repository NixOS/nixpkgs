{ stdenv, lib, fetchgit, fetchhg, fetchbzr, fetchFromGitHub }:

let
  goDeps = [
    {
      root = "github.com/nsf/gocode";
      src = fetchFromGitHub {
        owner = "nsf";
        repo = "gocode";
        rev = "9b760fdb16f18eafbe0cd274527efd2bd89dfa78";
        sha256 = "0d1wl0x8jkaav6lcfzs70cr6gy0p88cbk5n3p19l6d0h9xz464ax";
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
