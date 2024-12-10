{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "t";
  gemdir = ./.;
  exes = [ "t" ];

  passthru.updateScript = bundlerUpdateScript "t";

  meta = with lib; {
    description = "A command-line power tool for Twitter";
    homepage = "http://sferik.github.io/t/";
    license = licenses.asl20;
    maintainers = with maintainers; [
      offline
      manveru
      nicknovitski
    ];
    platforms = platforms.unix;
    mainProgram = "t";
  };
}
