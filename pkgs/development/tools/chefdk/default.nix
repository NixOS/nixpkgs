{ stdenv, lib, bundlerEnv, ruby, perl, autoconf, gecode_3_7_3}:

bundlerEnv {
  name = "chefdk-0.10.0";

  inherit ruby;
  gemfile = ./Gemfile;
  lockfile = ./Gemfile.lock;
  gemset = ./gemset.nix;

  buildInputs = [ perl autoconf gecode_3_7_3 ];

  meta = with lib; {
    description = "A streamlined development and deployment workflow for Chef platform";
    homepage    = https://downloads.chef.io/chef-dk/;
    license     = licenses.asl20;
    maintainers = with maintainers; [ offline rvlander ];
    platforms   = platforms.unix;
  };
}
