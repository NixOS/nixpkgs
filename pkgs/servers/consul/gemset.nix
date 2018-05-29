{
  execjs = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yz55sf2nd3l666ms6xr18sm2aggcvmb8qr3v53lr4rir32y1yp1";
      type = "gem";
    };
    version = "2.7.0";
  };
  ffi = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zw6pbyvmj8wafdc7l5h7w20zkp1vbr2805ql5d941g2b20pk4zr";
      type = "gem";
    };
    version = "1.9.23";
  };
  libv8 = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0271i5sfma05gvhmrmxqb0jj667bl6m54yd49ay6yrdbh1g4wpl1";
      type = "gem";
    };
    version = "3.16.14.19";
  };
  rb-fsevent = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lm1k7wpz69jx7jrc92w3ggczkjyjbfziq5mg62vjnxmzs383xx8";
      type = "gem";
    };
    version = "0.10.3";
  };
  rb-inotify = {
    dependencies = ["ffi"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yfsgw5n7pkpyky6a9wkf1g9jafxb0ja7gz0qw0y14fd2jnzfh71";
      type = "gem";
    };
    version = "0.9.10";
  };
  ref = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04p4pq4sikly7pvn30dc7v5x2m7fqbfwijci4z1y6a1ilwxzrjii";
      type = "gem";
    };
    version = "2.0.0";
  };
  sass = {
    dependencies = ["sass-listen"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19wyzp9qsg8hdkkxlsv713w0qmy66qrdp0shj42587ssx4qhrlag";
      type = "gem";
    };
    version = "3.5.6";
  };
  sass-listen = {
    dependencies = ["rb-fsevent" "rb-inotify"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xw3q46cmahkgyldid5hwyiwacp590zj2vmswlll68ryvmvcp7df";
      type = "gem";
    };
    version = "4.0.0";
  };
  therubyracer = {
    dependencies = ["libv8" "ref"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g95bzs2axjglyjyj6xvsywqgr80bnzlkw7mddxx1fdrak5wni2q";
      type = "gem";
    };
    version = "0.12.3";
  };
  uglifier = {
    dependencies = ["execjs"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dycp9c5xiricla6sgvg0vf22i3axs5k1v1607dvl7nv1xkkaczi";
      type = "gem";
    };
    version = "4.1.10";
  };
}