{ stdenv, genericSubstituter, shell, nix
}:

genericSubstituter {
  src = ./installer.sh;
  dir = "bin";
  isExecutable = true;
  inherit shell nix;
  
  nixClosure = stdenv.mkDerivation {
    name = "closure";
    builder = builtins.toFile "builder.sh"
      "source $stdenv/setup; nix-store -qR $nix > $out";
    buildInputs = [nix];
    inherit nix;
  };
}
