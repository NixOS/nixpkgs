{ stdenv, lib, fetchFromGitHub, fetchgit, go }:

stdenv.mkDerivation {
  name = "terraform-0.5.0";

  src = import ./deps.nix {
    inherit stdenv lib fetchFromGitHub fetchgit;
  };

  buildInputs = [ go ];

  buildPhase = ''
    export GOPATH=$src
    go build -v -o terraform github.com/hashicorp/terraform
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp terraform $out/bin
  '';

  meta = {
    description = "A tool for building, changing, and combining infrastructure safely and efficiently";
    homepage    = http://www.terraform.io/;
    license     = stdenv.lib.licenses.mpl20;
    maintainers = [ lib.maintainers.lassulus ];
  };
}
