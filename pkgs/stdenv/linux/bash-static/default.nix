{stdenv}:
 
stdenv.mkDerivation {
  name = "bash-static-2.05b";
  builder = ./builder.sh;
  src = ./bash;
}
