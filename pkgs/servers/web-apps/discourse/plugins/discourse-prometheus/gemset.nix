{
  prometheus_exporter = {
    dependencies = [ "webrick" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "15vl8fw8vjnaj9g129dzrwk9nlrdqgffaj3rys4ba9ns2bqim9rq";
      type = "gem";
    };
    version = "2.2.0";
  };
  webrick = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ca1hr2rxrfw7s613rp4r4bxb454i3ylzniv9b9gxpklqigs3d5y";
      type = "gem";
    };
    version = "1.9.2";
  };
}
