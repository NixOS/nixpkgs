{ stdenv, lib, fetchgit, fetchhg, fetchbzr, fetchFromGitHub }:

let
  goDeps = [
    {
      root = "github.com/golang/lint";
      src = fetchFromGitHub {
        owner = "golang";
        repo = "lint";
        rev = "8ca23475bcb43213a55dd8210b69363f6b0e09c1";
        sha256 = "16wbykik6dw3x9s7iqi4ln8kvzsh3g621wb8mk4nfldw7lyqp3cs";
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
