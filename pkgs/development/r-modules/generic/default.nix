R:

{ buildInputs ? [], ... } @ attrs:

R.stdenv.mkDerivation (
  {
  }
  //
  attrs
  //
  {
    name = "r-" + attrs.name;
    builder = ./builder.sh;
    buildInputs = buildInputs ++ [ R ];
    phases = [ "installPhase" "fixupPhase" ];
  }
)
