{
  chronic = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hrdkn4g8x7dlzxwb1rfgr8kw3bp4ywg5l4y4i9c2g5cwv62yvvn";
      type = "gem";
    };
    version = "0.10.2";
  };
  highline = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1f8cr014j7mdqpdb9q17fp5vb5b8n1pswqaif91s3ylg5x3pygfn";
      type = "gem";
    };
    version = "2.1.0";
  };
  matrix = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1h2cgkpzkh3dd0flnnwfq6f3nl2b1zff9lvqz8xs853ssv5kq23i";
      type = "gem";
    };
    version = "0.4.2";
=======
      sha256 = "0yclf57n2j3cw8144ania99h1zinf8q3f5zrhqa754j6gl95rp9d";
      type = "gem";
    };
    version = "2.0.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  rchardet = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1isj1b3ywgg2m1vdlnr41lpvpm3dbyarf1lla4dfibfmad9csfk9";
      type = "gem";
    };
    version = "1.8.0";
  };
  reckon = {
<<<<<<< HEAD
    dependencies = ["chronic" "highline" "matrix" "rchardet"];
=======
    dependencies = ["chronic" "highline" "rchardet"];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0188k41lvz5vnn03qw1hbi6c2i88n5p3183rb0xz9rfjcngh2ly3";
      type = "gem";
    };
    version = "0.9.2";
=======
      sha256 = "0qnghypb9pj7888096xwyrx7myhzk85x69ympxkxki3kxcgcrdfn";
      type = "gem";
    };
    version = "0.8.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
