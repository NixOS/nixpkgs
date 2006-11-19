{genericSubstituter, mingetty, ttyNumber}:

genericSubstituter {
  src = ./mingetty.sh;
  dir = "etc/event.d";
  name = "tty" + toString ttyNumber;
  inherit mingetty ttyNumber;
}
