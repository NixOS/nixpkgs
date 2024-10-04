{ lib
, substitute
, coreutils
, getopt
, runtimeShell
}:

substitute {
  name = "lsb_release";

  src = ./lsb_release.sh;

  dir = "bin";
  isExecutable = true;

  substitutions = [
    "--subst-var-by" "coreutils" coreutils
    "--subst-var-by" "getopt" getopt
    "--subst-var-by" "shell" runtimeShell
  ];

  meta = with lib; {
    description = "Prints certain LSB (Linux Standard Base) and Distribution information";
    mainProgram = "lsb_release";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ primeos ];
    platforms = platforms.linux;
  };
}
