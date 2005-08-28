{stdenv, dietlibc, gcc, langC ? true, langCC ? true, langF77 ? false}:

stdenv.mkDerivation {
  name = dietlibc.name;

  builder = ./builder.sh;

  inherit dietlibc gcc langC langCC langF77;
  #NIX_GLIBC_FLAGS_SET=1;

}
