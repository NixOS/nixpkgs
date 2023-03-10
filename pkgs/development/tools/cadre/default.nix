{ lib, bundlerApp, bundlerUpdateScript }:

bundlerApp {
  pname = "cadre";
  gemdir = ./.;
  exes = [ "cadre" ];

  passthru.updateScript = bundlerUpdateScript "cadre";

  meta = with lib; {
    description = "Toolkit to add Ruby development - in-editor coverage, libnotify of test runs";
    homepage    = "https://github.com/nyarly/cadre";
    license     = licenses.mit;
    maintainers = with maintainers; [ nyarly nicknovitski ];
    platforms   = platforms.unix;
  };
}
