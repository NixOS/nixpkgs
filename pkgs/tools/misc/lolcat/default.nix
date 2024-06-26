{ lib, bundlerApp, bundlerUpdateScript }:

bundlerApp {
  pname = "lolcat";
  gemdir = ./.;
  exes = [ "lolcat" ];

  passthru.updateScript = bundlerUpdateScript "lolcat";

  meta = with lib; {
    description = "Rainbow version of cat";
    homepage    = "https://github.com/busyloop/lolcat";
    license     = licenses.bsd3;
    maintainers = with maintainers; [ StillerHarpo manveru nicknovitski ];
    mainProgram = "lolcat";
  };
}
