{ lib, bundlerApp, bundlerUpdateScript }:

bundlerApp {
  pname = "licensee";
  gemdir = ./.;
  exes = [ "licensee" ];

  passthru.updateScript = bundlerUpdateScript "licensee";

  meta = with lib; {
    description = "Ruby Gem to detect under what license a project is distributed";
    homepage    = "https://licensee.github.io/licensee/";
    license     = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
    platforms   = platforms.unix;
    mainProgram = "licensee";
  };
}
