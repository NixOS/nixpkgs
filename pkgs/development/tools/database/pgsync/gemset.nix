{
  parallel = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07vnk6bb54k4yc06xnwck7php50l09vvlw1ga8wdz0pia461zpzb";
      type = "gem";
    };
    version = "1.22.1";
  };
  pg = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wd6nl81nbdwck04hccsm7wf23ghpi8yddd9j4rbwyvyj0sbsff1";
      type = "gem";
    };
    version = "1.4.5";
  };
  pgsync = {
    dependencies = ["parallel" "pg" "slop" "tty-spinner"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18misp6iwjr3cd4jzhbnf2q058gnkxx27jx1b87z6p64bwkgr3x2";
      type = "gem";
    };
    version = "0.7.3";
  };
  slop = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "052mhd76f4dshc36f2bd5pp807lgnaj5i6ai8jg075384wcfhcpb";
      type = "gem";
    };
    version = "4.10.0";
  };
  tty-cursor = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0j5zw041jgkmn605ya1zc151bxgxl6v192v2i26qhxx7ws2l2lvr";
      type = "gem";
    };
    version = "0.7.1";
  };
  tty-spinner = {
    dependencies = ["tty-cursor"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hh5awmijnzw9flmh5ak610x1d00xiqagxa5mbr63ysggc26y0qf";
      type = "gem";
    };
    version = "0.9.3";
  };
}
