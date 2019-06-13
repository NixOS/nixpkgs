{ lib, bundlerApp }:

bundlerApp {
  pname = "cadre";
  gemdir = ./.;
  exes = [ "cadre" ];

  meta = with lib; {
    description = "Toolkit to add Ruby development - in-editor coverage, libnotify of test runs";
    homepage    = https://github.com/nyarly/cadre;
    license     = licenses.mit;
    maintainers = [ maintainers.nyarly ];
    platforms   = platforms.unix;
  };
}
