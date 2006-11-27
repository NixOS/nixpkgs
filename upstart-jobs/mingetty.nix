{mingetty, ttyNumber}:

{
  name = "tty" + toString ttyNumber;
  job = "
    start on startup
    stop on shutdown
    respawn ${mingetty}/sbin/mingetty --noclear tty${toString ttyNumber}
  ";
}
