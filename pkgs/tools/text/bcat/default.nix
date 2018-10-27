{ lib, bundlerApp }:

bundlerApp {
  pname = "bcat";
  gemdir = ./.;
  exes = [ "bcat" "btee" "a2h" ];
  manpages = [ "man/bcat.1" "man/btee.1" "man/a2h.1" ];

  meta = with lib; {
    description = "Pipe to browser utility";
    homepage    = http://rtomayko.github.com/bcat/;
    license     = licenses.mit;
    maintainers = [ maintainers.jraygauthier ];
    platforms   = platforms.unix;
  };
}
