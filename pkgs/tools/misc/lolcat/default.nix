{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "lolcat";
  gemdir = ./.;
  exes = [ "lolcat" ];

  passthru.updateScript = bundlerUpdateScript "lolcat";

  meta = {
    description = "Rainbow version of cat";
    homepage = "https://github.com/busyloop/lolcat";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      StillerHarpo
      manveru
      nicknovitski
    ];
    mainProgram = "lolcat";
  };
}
