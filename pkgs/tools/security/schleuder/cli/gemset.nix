{
  schleuder-cli = {
    dependencies = ["thor"];
    groups = ["default"];
    platforms = [];
    source = {
      fetchSubmodules = false;
      rev = "1de2548695d9a74f47b7868954561b48cbc966f9";
      sha256 = "0k4i33w9a0bscw4wbs301vxca367g7pa89y6cr24i0014pbmhs9z";
      type = "git";
      url = "https://0xacab.org/schleuder/schleuder-cli";
    };
    version = "0.1.0";
  };
  thor = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yhrnp9x8qcy5vc7g438amd5j9sw83ih7c30dr6g6slgw9zj3g29";
      type = "gem";
    };
    version = "0.20.3";
  };
}
