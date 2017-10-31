{ stdenv, lib, bundlerEnv, ruby, perl, autoconf }:

bundlerEnv {
  name = "chefdk-1.3.40";

  inherit ruby;
  gemdir = ./.;

  buildInputs = [ perl autoconf ];

  meta = with lib; {
    description = "A streamlined development and deployment workflow for Chef platform";
    homepage    = https://downloads.chef.io/chef-dk/;
    license     = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    platforms   = platforms.unix;
  };
}
