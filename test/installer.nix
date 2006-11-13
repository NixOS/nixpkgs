{ stdenv, genericSubstituter, shell, nix
}:

genericSubstituter {
  src = ./installer.sh;
  dir = "bin";
  isExecutable = true;
  inherit shell nix;

  nixClosure = stdenv.mkDerivation {
    name = "closure";
    exportReferencesGraph = ["refs" nix];
    builder = builtins.toFile "builder.sh" "
      source $stdenv/setup
      if ! test -e refs; then
        echo 'Your Nix installation is too old!'
        exit 1
      fi
      cp refs $out
    ";
  };
}
