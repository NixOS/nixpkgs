{
  arr-pm = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/f9IL3UjkjkgH01mfZNCRBJjmq0LOwrU2CfnxjfgrTk=";
      type = "gem";
    };
    version = "0.0.12";
  };
  backports = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Q5+8nbRNucY88SAB7S46ndvbUNpWCyv3zz++b8rmStg=";
      type = "gem";
    };
    version = "3.25.1";
  };
  cabin = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-kcU5Qonpk+cDemyGnj8hLzGlmE0rGBGsk09ZHIdEayw=";
      type = "gem";
    };
    version = "0.9.0";
  };
  clamp = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-T2qZqGeNUau/FlAmOnTRrFCTntwRmGJxQx0uA6DXoCI=";
      type = "gem";
    };
    version = "1.3.2";
  };
  dotenv = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xnDfR4Z10jiJ5le+rKb7QjIo91zp8FKgaQwNDaozPPM=";
      type = "gem";
    };
    version = "3.1.7";
  };
  fpm = {
    dependencies = [
      "arr-pm"
      "backports"
      "cabin"
      "clamp"
      "pleaserun"
      "rexml"
      "stud"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-2er+YTz73507jvLjIeGUzQotMAzjf3FsC+GzpCt9td8=";
      type = "gem";
    };
    version = "1.16.0";
  };
  insist = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-b2dZ7uWD3E4Apsw/cTz6fFcFcpWLofXWVZUEbXlbgy8=";
      type = "gem";
    };
    version = "1.0.0";
  };
  mustache = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-gmqW24lYGcE//6T6PCC4XoC2Cq7B8o9559uACSq9sLw=";
      type = "gem";
    };
    version = "0.99.8";
  };
  pleaserun = {
    dependencies = [
      "cabin"
      "clamp"
      "dotenv"
      "insist"
      "mustache"
      "stud"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-TdjbGLgbSOKodewMf/84aUVNH5Op9eLmxOuIgShw06s=";
      type = "gem";
    };
    version = "0.0.32";
  };
  rexml = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-x0UnqaCgS07DHb4NxO1gBLlgr5Q9jbQuU57d46hxq8o=";
      type = "gem";
    };
    version = "3.4.1";
  };
  stud = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-a6Jvoo/FCo1ZIpspanM7SNUPFHOx4+f14znVu9gp62I=";
      type = "gem";
    };
    version = "0.0.23";
  };
}
