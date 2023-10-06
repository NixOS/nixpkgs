{
  ffi = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nq1fb3vbfylccwba64zblxy96qznxbys5900wd7gm9bpplmf432";
      type = "gem";
    };
    version = "1.15.0";
  };
  google-protobuf = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ak5yqqhr04b4x0axzvpw1xzwmxmfcw0gf4r1ijixv15kidhsj3z";
      type = "gem";
    };
    version = "3.15.6";
  };
  libusb = {
    dependencies = ["ffi" "mini_portile2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "005q4f3bi68yapza1vxamgwz2gpix2akci52s4yvr03hsxi137a6";
      type = "gem";
    };
    version = "0.6.4";
  };
  mini_portile2 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hdbpmamx8js53yk3h8cqy12kgv6ca06k0c9n3pxh6b6cjfs19x7";
      type = "gem";
    };
    version = "2.5.0";
  };
  nokogiri = {
    dependencies = ["mini_portile2" "racc"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0b51df8fwadak075cvi17w0nch6qz1r66564qp29qwfj67j9qp0p";
      type = "gem";
    };
    version = "1.11.2";
  };
  racc = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "178k7r0xn689spviqzhvazzvxfq6fyjldxb3ywjbgipbfi4s8j1g";
      type = "gem";
    };
    version = "1.5.2";
  };
  rubyserial = {
    dependencies = ["ffi"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vj5yan6srbvkf5vfp9d9b9z8wyygd0zxcy54c35yhkjl6kwd22q";
      type = "gem";
    };
    version = "0.6.0";
  };
}
