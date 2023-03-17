{
  google-protobuf = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1i5g23mjc4fiwymrfkvgcmsym50rapw7vm988fm46rlpg3zijgl1";
      type = "gem";
    };
    version = "3.21.2";
  };
  pg_query = {
    dependencies = ["google-protobuf"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00bhwkhjy6bkp04313m5il7vd165i3fz0x4jissflf66i164ppgk";
      type = "gem";
    };
    version = "2.1.3";
  };
  sqlint = {
    dependencies = ["pg_query"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wbsi0ivashmpgavz7j22qns3zcya8j6sd2f9y8hk8bnqx7i3ak0";
      type = "gem";
    };
    version = "0.2.1";
  };
}
