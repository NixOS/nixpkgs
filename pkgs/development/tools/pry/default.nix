{ lib, bundlerApp, bundlerUpdateScript }:

bundlerApp {
  pname = "pry";
  gemdir = ./.;
  exes = [ "pry" ];

  passthru.updateScript = bundlerUpdateScript "pry";

  meta = with lib; {
    description = "A Ruby runtime developer console and IRB alternative";
    homepage    = https://pryrepl.org;
    license     = licenses.mit;
    maintainers = [ maintainers.tckmn ];
    platforms   = platforms.unix;
  };
}
