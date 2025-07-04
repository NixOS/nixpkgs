{
  hue-cli = {
    dependencies = [
      "hue-lib"
      "json"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-P0FRfP5Vn2vs79vUsEgK4WXnUgtHaHdCFd5VdVNx8oE=";
      type = "gem";
    };
    version = "0.1.4";
  };
  hue-lib = {
    dependencies = [ "json" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-H2qQRFnl5m6iN/a8T12lAC+dcWt2//XSobDp+NBD1N8=";
      type = "gem";
    };
    version = "0.7.4";
  };
  json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ndFDcVZ3P3LAlgWOyDf6rBsAB3Eho/1XTmj4leo6qWs=";
      type = "gem";
    };
    version = "2.2.0";
  };
}
