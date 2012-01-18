{ stdenv, perl }:

stdenv.mkDerivation {
  name = "shebangfix-0.0";

  buildInputs = [perl];

  file = ./shebangfix.pl;

  phases = "buildPhase";

  buildPhase = ''
    mkdir -p $out/bin
    s=$out/bin/shebangfix
    cp $file $s
    chmod +wx $s
    ls -l $s
    perl $s $s
  '';

  meta = { description = "replaces the #!executable with $#!correctpath/executable "; };
}
