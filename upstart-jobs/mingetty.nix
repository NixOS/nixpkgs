{mingetty, pam_login, ttyNumber}:

{
  name = "tty" + toString ttyNumber;
  job = "
    start on startup
    stop on shutdown
    respawn ${mingetty}/sbin/mingetty --loginprog=${pam_login}/bin/login --noclear tty${toString ttyNumber}
  ";
}
