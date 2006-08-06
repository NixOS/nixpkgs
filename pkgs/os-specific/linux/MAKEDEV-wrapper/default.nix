{stdenv, MAKEDEV}:

stdenv.mkDerivation {
  name = MAKEDEV.name;

  builder = ./builder.sh;

  inherit MAKEDEV;
}
