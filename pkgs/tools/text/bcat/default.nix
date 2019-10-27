{ lib, bundlerApp, bundlerUpdateScript }:

bundlerApp {
  pname = "bcat";
  gemdir = ./.;
  exes = [ "bcat" "btee" "a2h" ];

  passthru.updateScript = bundlerUpdateScript "bcat";

  meta = with lib; {
    description = "Pipe to browser utility";
    homepage    = http://rtomayko.github.com/bcat/;
    license     = licenses.mit;
    maintainers = with maintainers; [ jraygauthier nicknovitski ];
    platforms   = platforms.unix;
  };
}
