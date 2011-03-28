{stdenv}:

assert stdenv.isDarwin;

stdenv.mkDerivation {
  name = "darwin-install_name_tool-utility";
  builder = ./builder.sh;
}
