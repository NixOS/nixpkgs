{ stdenv, lib, fetchgit, fetchhg, fetchbzr, fetchFromGitHub }:

let
  goDeps = [
    {
      root = "github.com/jstemmer/gotags";
      src = fetchFromGitHub {
        owner = "jstemmer";
        repo = "gotags";
        rev = "a60c6a1b171faedc44354bd437d965e5e3bdc220";
        sha256 = "1drbypby0isdmkq44jmlv59k3jrwvq2jciaccxx2qc2nnx444fkq";
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
