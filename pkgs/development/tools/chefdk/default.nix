{ lib, bundlerEnv, bundlerUpdateScript, ruby, perl, autoconf }:

bundlerEnv {
  name = "chef-dk-4.7.73";

  inherit ruby;
  gemdir = ./.;

  buildInputs = [ perl autoconf ];

  passthru.updateScript = bundlerUpdateScript "chefdk";

  meta = with lib; {
    description = "A streamlined development and deployment workflow for Chef platform";
    homepage    = https://downloads.chef.io/chef-dk/;
    license     = licenses.asl20;
    maintainers = with maintainers; [ offline nicknovitski ];
    platforms   = platforms.unix;
    badPlatforms = [ "aarch64-linux" ];
  };
}
