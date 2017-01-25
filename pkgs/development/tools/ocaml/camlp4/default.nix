{ stdenv, fetchzip, which, ocaml, ocamlbuild }:

let param = {
  "4.02.3" = {
     version = "4.02+6";
     sha256 = "06yl4q0qazl7g25b0axd1gdkfd4qpqzs1gr5fkvmkrcbz113h1hj"; };
  "4.03.0" = {
     version = "4.03+1";
     sha256 = "1f2ndch6f1m4fgnxsjb94qbpwjnjgdlya6pard44y6n0dqxi1wsq"; };
  "4.04.0" = {
     version = "4.04+1";
     sha256 = "1ad7rygqjxrc1im95gw9lp8q83nhdaf383f2808f1p63yl42xm7k"; };
  }."${ocaml.version}";
in

stdenv.mkDerivation rec {
  name = "camlp4-${version}";
  inherit (param) version;

  src = fetchzip {
    url = "https://github.com/ocaml/camlp4/archive/${version}.tar.gz";
    inherit (param) sha256;
  };

  buildInputs = [ which ocaml ocamlbuild ];

  dontAddPrefix = true;

  preConfigure = ''
    configureFlagsArray=(
      --bindir=$out/bin
      --libdir=$out/lib/ocaml/${ocaml.version}/site-lib
      --pkgdir=$out/lib/ocaml/${ocaml.version}/site-lib
    )
  '';

  postConfigure = ''
    substituteInPlace camlp4/META.in \
    --replace +camlp4 $out/lib/ocaml/${ocaml.version}/site-lib/camlp4
  '';

  makeFlags = "all";

  installTargets = "install install-META";

  meta = with stdenv.lib; {
    description = "A software system for writing extensible parsers for programming languages";
    homepage = https://github.com/ocaml/camlp4;
    platforms = ocaml.meta.platforms or [];
  };
}
