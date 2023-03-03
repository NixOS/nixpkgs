{ lib, bundlerEnv, bundlerUpdateScript, ruby, perl, autoconf }:

bundlerEnv {
  name = "chef-dk-4.13.3";
  # Do not change this to pname & version until underlying issues with Ruby
  # packaging are resolved ; see https://github.com/NixOS/nixpkgs/issues/70171

  inherit ruby;
  gemdir = ./.;

  buildInputs = [ perl autoconf ];

  passthru.updateScript = bundlerUpdateScript "chefdk";

  meta = with lib; {
    description = "A streamlined development and deployment workflow for Chef platform";
    homepage    = "https://downloads.chef.io/chef-dk/";
    license     = licenses.asl20;
    maintainers = with maintainers; [ offline nicknovitski ];
    platforms   = platforms.unix;
    badPlatforms = [ "aarch64-linux" ];
  };
}
