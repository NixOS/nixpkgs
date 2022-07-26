{
  parallel = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hkfpm78c2vs1qblnva3k1grijvxh87iixcnyd83s3lxrxsjvag4";
      type = "gem";
    };
    version = "1.21.0";
  };
  pg = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13mfrysrdrh8cka1d96zm0lnfs59i5x2g6ps49r2kz5p3q81xrzj";
      type = "gem";
    };
    version = "1.2.3";
  };
  pgsync = {
    dependencies = ["parallel" "pg" "slop" "tty-spinner"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rsm1irmz97v1kxhnq4lbwwiapqa2zkx0n0xlcf68ca8sfcfql1z";
      type = "gem";
    };
    version = "0.6.8";
  };
  slop = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "067bvjmjdjs19bvy138hkqqvw8li3732radcd4x5f5dbf30yk3a9";
      type = "gem";
    };
    version = "4.9.1";
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
