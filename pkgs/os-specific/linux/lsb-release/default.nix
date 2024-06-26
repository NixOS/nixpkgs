{
  substituteAll,
  lib,
  coreutils,
  getopt,
}:

substituteAll {
  name = "lsb_release";

  src = ./lsb_release.sh;

  dir = "bin";
  isExecutable = true;

  inherit coreutils getopt;

  meta = with lib; {
    description = "Prints certain LSB (Linux Standard Base) and Distribution information";
    mainProgram = "lsb_release";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ primeos ];
    platforms = platforms.linux;
  };
}
