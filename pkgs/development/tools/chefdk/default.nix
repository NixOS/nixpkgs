{ stdenv, lib, bundlerEnv, ruby, perl }:

bundlerEnv {
  name = "chefdk-0.4.0";

  inherit ruby;
  gemfile = ./Gemfile;
  lockfile = ./Gemfile.lock;
  gemset = ./gemset.nix;

  buildInputs = [ perl ];

  meta = with lib; {
    description = "A streamlined development and deployment workflow for Chef platform.";
    homepage    = https://downloads.chef.io/chef-dk/;
    license     = with licenses; asl20;
    maintainers = with maintainers; [ offline ];
    platforms   = platforms.unix;
  };
}
