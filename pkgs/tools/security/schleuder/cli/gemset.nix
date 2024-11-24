{
  schleuder-cli = {
    dependencies = ["thor"];
    groups = ["default"];
    platforms = [];
    source = {
      fetchSubmodules = false;
      rev = "fd010d28b1503504056e714e03abf043b64794ea";
      sha256 = "1r8ayi0d00c14q40247rwjf5s5n3dsy9d9blhf5jzm3kddzpwnbx";
      type = "git";
      url = "https://0xacab.org/schleuder/schleuder-cli";
    };
    version = "0.2.0";
  };
  thor = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vq1fjp45az9hfp6fxljhdrkv75cvbab1jfrwcw738pnsiqk8zps";
      type = "gem";
    };
    version = "1.3.1";
  };
}
