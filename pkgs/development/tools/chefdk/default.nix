{ lib, bundlerApp, ruby_2_5, perl, autoconf }:

bundlerApp {
  # Last updated via:
  # nix-shell -p bundix -p gcc -p libxml2 -p zlib --run "bundix -mdl"
  pname = "chef-dk";

  ruby = ruby_2_5;
  gemdir = ./.;

  # buildInputs = [ perl autoconf ];
  exes = ["chef"];

  meta = with lib; {
    description = "A streamlined development and deployment workflow for Chef platform";
    homepage    = https://downloads.chef.io/chef-dk/;
    license     = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    platforms   = platforms.unix;
  };
}
