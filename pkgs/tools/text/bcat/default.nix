{ lib, bundlerApp }:

bundlerApp {
  pname = "bcat";
  gemdir = ./.;
  exes = [ "bcat" "btee" "a2h" ];

  meta = with lib; {
    description = "Pipe to browser utility";
    homepage    = http://rtomayko.github.com/bcat/;
    license     = licenses.mit;
    maintainers = [ maintainers.jraygauthier ];
    platforms   = platforms.unix;
  };
}
