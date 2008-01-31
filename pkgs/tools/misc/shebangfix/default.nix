args: with args;
stdenv.mkDerivation {
  name = "shebangfix-0.0";

  buildInputs = [perl];

  file = ./shebangfix.pl;

  phases = "buildPhase";

  buildPhase = "
    ensureDir \$out/bin
    s=\$out/bin/shebangfix
    cp \$file \$s
    chmod +x \$s
    perl \$s \$s
  ";

  meta = { description = "replaces the #!executable with $#!correctpath/executable "; };
}
