{ stdenv, fetchzip, which, ocaml, ocamlbuild }:

if stdenv.lib.versionAtLeast ocaml.version "4.09"
then throw "camlp4 is not available for OCaml ${ocaml.version}"
else

let param = {
  "4.02" = {
     version = "4.02+6";
     sha256 = "06yl4q0qazl7g25b0axd1gdkfd4qpqzs1gr5fkvmkrcbz113h1hj"; };
  "4.03" = {
     version = "4.03+1";
     sha256 = "1f2ndch6f1m4fgnxsjb94qbpwjnjgdlya6pard44y6n0dqxi1wsq"; };
  "4.04" = {
     version = "4.04+1";
     sha256 = "1ad7rygqjxrc1im95gw9lp8q83nhdaf383f2808f1p63yl42xm7k"; };
  "4.05" = {
     version = "4.05+1";
     sha256 = "0wm795hpwvwpib9c9z6p8kw2fh7p7b2hml6g15z8zry3y7w738sv"; };
  "4.06" = {
     version = "4.06+1";
     sha256 = "0fazfw2l7wdmbwnqc22xby5n4ri1wz27lw9pfzhsbcdrighykysf"; };
  "4.07" = {
     version = "4.07+1";
     sha256 = "0cxl4hkqcvspvkx4f2k83217rh6051fll9i2yz7cw6m3bq57mdvl"; };
  "4.08" = {
     version = "4.08+1";
     sha256 = "0qplawvxwai25bi27niw2cgz2al01kcnkj8wxwhxslpi21z6pyx1"; };
  }.${ocaml.meta.branch};
in

stdenv.mkDerivation rec {
  pname = "camlp4";
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

  makeFlags = [ "all" ];

  installTargets = [ "install" "install-META" ];

  dontStrip = true;

  meta = with stdenv.lib; {
    description = "A software system for writing extensible parsers for programming languages";
    homepage = https://github.com/ocaml/camlp4;
    platforms = ocaml.meta.platforms or [];
  };
}
