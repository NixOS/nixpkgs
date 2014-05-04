R:

{ name, buildInputs ? [], ... } @ attrs:

R.stdenv.mkDerivation (attrs // {
  name = "r-" + name;
  builder = ./builder.sh;
  buildInputs = buildInputs ++ [ R ];
})
