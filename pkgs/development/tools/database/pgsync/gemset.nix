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
      sha256 = "09a5z9qhxnybahx162q2q1cygdhxfp6cihdivvzh32jlwc37z1x3";
      type = "gem";
    };
    version = "1.4.4";
  };
  pgsync = {
    dependencies = ["parallel" "pg" "slop" "tty-spinner"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "009xrrxqwcrcackw2w86xamkb1clb70ghcr8g8n8w9h13qaa0j78";
      type = "gem";
    };
    version = "0.7.2";
  };
  slop = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cz9fpr7zya6d44070ya0ik4pwv7c8dlqgw4bxgxficzakdxy9kf";
      type = "gem";
    };
    version = "4.9.3";
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
