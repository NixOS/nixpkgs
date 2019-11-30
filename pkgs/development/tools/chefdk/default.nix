{ lib, bundlerEnv, bundlerUpdateScript, ruby_2_4, perl, autoconf }:

bundlerEnv {
  name = "chef-dk-2.4.17";

  ruby = ruby_2_4;
  gemdir = ./.;

  buildInputs = [ perl autoconf ];

  passthru.updateScript = bundlerUpdateScript "chefdk";

  meta = with lib; {
    description = "A streamlined development and deployment workflow for Chef platform";
    homepage    = https://downloads.chef.io/chef-dk/;
    license     = licenses.asl20;
    maintainers = with maintainers; [ offline nicknovitski ];
    platforms   = platforms.unix;
  };
}
