{ bundlerApp }:

bundlerApp {
  pname = "puppet-lint";
  gemdir = ./.;
  exes = [ "puppet-lint" ];
}
