{
  lib,
  bundlerApp,
  ruby_3_4,
  bundlerUpdateScript,
}:

(bundlerApp.override { ruby = ruby_3_4; }) {
  pname = "lolcat";
  gemdir = ./.;
  exes = [ "lolcat" ];

  passthru.updateScript = bundlerUpdateScript "lolcat";

  meta = with lib; {
    description = "Rainbow version of cat";
    homepage = "https://github.com/busyloop/lolcat";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      StillerHarpo
      manveru
      nicknovitski
    ];
    mainProgram = "lolcat";
  };
}
