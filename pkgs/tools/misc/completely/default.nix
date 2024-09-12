{ lib
, bundlerApp
, bundlerUpdateScript
}:

bundlerApp {
  pname = "completely";

  gemdir = ./.;
  exes = [ "completely" ];

  passthru.updateScript = bundlerUpdateScript "completely";

  meta = with lib; {
    description = "Generate bash completion scripts using a simple configuration file";
    homepage = "https://github.com/DannyBen/completely";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ zendo ];
    mainProgram = "completely";
  };
}
