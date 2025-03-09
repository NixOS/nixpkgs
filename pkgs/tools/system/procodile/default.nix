{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "procodile";
  gemdir = ./.;
  exes = [ "procodile" ];

  passthru.updateScript = bundlerUpdateScript "procodile";

  meta = with lib; {
    description = "Run processes in the background (and foreground) on Mac & Linux from a Procfile (for production and/or development environments)";
    homepage = "https://adam.ac/procodile";
    license = with licenses; mit;
    maintainers = with maintainers; [
      manveru
      nicknovitski
    ];
    platforms = platforms.unix;
    mainProgram = "procodile";
  };
}
