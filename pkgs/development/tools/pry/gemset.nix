{
  coderay = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3FMAGKRoRRL484FDzSoJbJ8CofwkWe3P5TR4en/HfUs=";
      type = "gem";
    };
    version = "1.1.3";
  };
  method_source = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-13lFWitWZqB5zlhXe/rYU09XGvfOyBB/Tc4yjwmB3t4=";
      type = "gem";
    };
    version = "1.0.0";
  };
  pry = {
    dependencies = [
      "coderay"
      "method_source"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-E5ORjEFa9GttCQRNK3jd6SspvINP2Fw2mpULqwgm3Ec=";
      type = "gem";
    };
    version = "0.13.1";
  };
}
