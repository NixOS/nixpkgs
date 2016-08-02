{ lib, bundlerEnv, ruby }:

bundlerEnv {
  name = "reckon";
  inherit ruby;
  gemfile = ./Gemfile;
  lockfile = ./Gemfile.lock;
  gemset = ./gemset.nix;
 
  meta = with lib; {
    description = "Flexibly import bank account CSV files into Ledger for command line accounting";
    license = licenses.mit;
    maintainers = "mckean.kylej@gmail.com";
    platforms = platforms.unix;
  };
}
