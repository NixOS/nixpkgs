{
  childprocess = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ic028k8xgm2dds9mqnvwwx3ibaz32j8455zxr9f4bcnviyahya5";
      type = "gem";
    };
    version = "3.0.0";
  };
  iniparse = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xbik6838gfh5yq9ahh1m7dzszxlk0g7x5lvhb8amk60mafkrgws";
      type = "gem";
    };
    version = "1.4.4";
  };
  overcommit = {
    dependencies = ["childprocess" "iniparse"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fjrrm9dy9mry5ss96sizn6xcphia5l54ydz9c31phipm61nwmfk";
      type = "gem";
    };
    version = "0.51.0";
  };
}
