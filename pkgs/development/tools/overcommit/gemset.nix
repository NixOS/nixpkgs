{
  childprocess = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1lvcp8bsd35g57f7wz4jigcw2sryzzwrpcgjwwf3chmjrjcww5in";
      type = "gem";
    };
    version = "4.1.0";
  };
  iniparse = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1wb1qy4i2xrrd92dc34pi7q7ibrjpapzk9y465v0n9caiplnb89n";
      type = "gem";
    };
    version = "1.5.0";
  };
  overcommit = {
    dependencies = [
      "childprocess"
      "iniparse"
      "rexml"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0slqmsycbqx746liwq0qw0c81xrp4051iff8s574a4fmj941gkia";
      type = "gem";
    };
    version = "0.60.0";
  };
  rexml = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "05i8518ay14kjbma550mv0jm8a6di8yp5phzrd8rj44z9qnrlrp0";
      type = "gem";
    };
    version = "3.2.6";
  };
}
