{mingetty, ttyNumber, loginProgram}:

{
  name = "tty" + toString ttyNumber;
  job = "
    start on udev
    stop on shutdown
    respawn ${mingetty}/sbin/mingetty --loginprog=${loginProgram} --noclear tty${toString ttyNumber}
  ";
}
