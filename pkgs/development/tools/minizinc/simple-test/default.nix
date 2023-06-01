# These tests show that the minizinc build is capable of running the
# examples in the official tutorial:
# https://www.minizinc.org/doc-2.7.3/en/modelling.html

{ stdenv, minizinc }:

stdenv.mkDerivation {
  name = "minizinc-simple-test";
  meta.timeout = 10;
  dontInstall = true;
  buildCommand = ''
    ${minizinc}/bin/minizinc --solver gecode ${./aust.mzn}
    ${minizinc}/bin/minizinc --solver cbc ${./loan.mzn} ${./loan1.dzn}
    touch $out
  '';
}
