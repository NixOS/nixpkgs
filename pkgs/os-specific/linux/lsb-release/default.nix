{ substituteAll, lib }:

substituteAll {
  name = "lsb_release";

  src = ./lsb_release.sh;

  dir = "bin";
  isExecutable = true;

  meta = with lib; {
    description = "Prints certain LSB (Linux Standard Base) and Distribution information";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ primeos ];
    platforms = platforms.linux;
  };
}
