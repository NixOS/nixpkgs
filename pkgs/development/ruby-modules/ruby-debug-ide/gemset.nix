{
  debase = {
    dependencies = ["debase-ruby_core_source"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zab27p7ah02gpy79qd21ccg9d6zwyjr7b6v6lxp6x1wvhpw4w7d";
      type = "gem";
    };
    version = "0.2.4.1";
  };
  debase-ruby_core_source = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ik5xay2d7jrm29ifyv2s1dn445px1jm5ckmj82q5yw1j9vr9gjd";
      type = "gem";
    };
    version = "0.10.9";
  };
  rake = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0w6qza25bq1s825faaglkx1k6d59aiyjjk3yw3ip5sb463mhhai9";
      type = "gem";
    };
    version = "13.0.1";
  };
  ruby-debug-ide = {
    dependencies = ["rake"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "175clfq45k2qirrw63rkcd9mgqvcg5s998bbhi23mbxbw9cri5qh";
      type = "gem";
    };
    version = "0.7.0";
  };
}