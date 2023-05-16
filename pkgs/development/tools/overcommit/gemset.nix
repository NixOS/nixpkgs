{
  childprocess = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lvcp8bsd35g57f7wz4jigcw2sryzzwrpcgjwwf3chmjrjcww5in";
      type = "gem";
    };
    version = "4.1.0";
  };
  iniparse = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wb1qy4i2xrrd92dc34pi7q7ibrjpapzk9y465v0n9caiplnb89n";
      type = "gem";
    };
    version = "1.5.0";
  };
  overcommit = {
    dependencies = ["childprocess" "iniparse" "rexml"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0slqmsycbqx746liwq0qw0c81xrp4051iff8s574a4fmj941gkia";
      type = "gem";
    };
    version = "0.60.0";
=======
      sha256 = "0dbz2y98r351r218m9d871ris1zfb6bcwr1gdhb39g2r9pail79n";
      type = "gem";
    };
    version = "0.59.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  rexml = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "05i8518ay14kjbma550mv0jm8a6di8yp5phzrd8rj44z9qnrlrp0";
      type = "gem";
    };
    version = "3.2.6";
=======
      sha256 = "08ximcyfjy94pm1rhcx04ny1vx2sk0x4y185gzn86yfsbzwkng53";
      type = "gem";
    };
    version = "3.2.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
