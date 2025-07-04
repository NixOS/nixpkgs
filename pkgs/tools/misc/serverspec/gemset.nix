{
  diff-lcs = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Sbk0AByMau2ze6GdrsXGNNonsxino8ZUrpeda6GSm2c=";
      type = "gem";
    };
    version = "1.5.0";
  };
  multi_json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-H9BBOLbkqQAX6NG4BMA5AxOZhm/z+6u3girqNnx4YV0=";
      type = "gem";
    };
    version = "1.15.0";
  };
  net-scp = {
    dependencies = [ "net-ssh" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-sy3tDUjIjOcIRKBj5OFO+0SpXlGp4MC/sMVLQxO2Iuo=";
      type = "gem";
    };
    version = "4.0.0";
  };
  net-ssh = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-B5k46QEjP/0ARNjo0awpmQLhNoLrY8SXSD/+6sq6oHs=";
      type = "gem";
    };
    version = "7.1.0";
  };
  net-telnet = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3SFGCDIl3if2TOEg+P9DJeQkuOiYm7NC0XCwyq/9HY8=";
      type = "gem";
    };
    version = "0.1.1";
  };
  rspec = {
    dependencies = [
      "rspec-core"
      "rspec-expectations"
      "rspec-mocks"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zMQXmaQ1CdwL6EBw4/BBCslcvUgK57bCRVQ+tkFiOZw=";
      type = "gem";
    };
    version = "3.12.0";
  };
  rspec-core = {
    dependencies = [ "rspec-support" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-LkDCZfce63yqTKxXEGpxXSzZyt3FUL2aTmMvSjcrRDU=";
      type = "gem";
    };
    version = "3.12.1";
  };
  rspec-expectations = {
    dependencies = [
      "diff-lcs"
      "rspec-support"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hlLbcLJa4zeLcnRHepBratGDOnt8+7ABoD9J3Rwdag0=";
      type = "gem";
    };
    version = "3.12.2";
  };
  rspec-its = {
    dependencies = [
      "rspec-core"
      "rspec-expectations"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-TaUQQOeCDar9QPL2IW0TyQqpSfDTAqBBLJ72B05z6pc=";
      type = "gem";
    };
    version = "1.3.0";
  };
  rspec-mocks = {
    dependencies = [
      "diff-lcs"
      "rspec-support"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ggMNK/oeTu8KLuNq9dPSJGclmJEqPzOE8ny7qfoJ1cE=";
      type = "gem";
    };
    version = "3.12.5";
  };
  rspec-support = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3U1Eskf/Z5uVtWB6xWQdGXpfmx0z+RYSPLmPxfkXxYs=";
      type = "gem";
    };
    version = "3.12.0";
  };
  serverspec = {
    dependencies = [
      "multi_json"
      "rspec"
      "rspec-its"
      "specinfra"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-vachr8Dr2HzKjN8QPwaueJEMxa9iOH5C+eX4qz1BHU8=";
      type = "gem";
    };
    version = "2.42.2";
  };
  sfl = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-mXOeUcMwYuOWThgCpwDunNjQ+cOJsqB/il/fhOGGpOI=";
      type = "gem";
    };
    version = "2.3";
  };
  specinfra = {
    dependencies = [
      "net-scp"
      "net-ssh"
      "net-telnet"
      "sfl"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-aGTDSHX3PTcTOKqMx5YoxH/VB7WjFpxPwycy27fPc6Y=";
      type = "gem";
    };
    version = "2.85.0";
  };
}
