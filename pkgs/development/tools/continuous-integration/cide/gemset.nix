{
  virtus = {
    dependencies = ["axiom-types" "coercible" "descendants_tracker" "equalizer"];
    source = {
      sha256 = "06iphwi3c4f7y9i2rvhvaizfswqbaflilziz4dxqngrdysgkn1fk";
      type = "gem";
    };
    version = "1.0.5";
  };
  thread_safe = {
    source = {
      sha256 = "1hq46wqsyylx5afkp6jmcihdpv4ynzzq9ygb6z2pb1cbz5js0gcr";
      type = "gem";
    };
    version = "0.3.5";
  };
  thor = {
    source = {
      sha256 = "08p5gx18yrbnwc6xc0mxvsfaxzgy2y9i78xq7ds0qmdm67q39y4z";
      type = "gem";
    };
    version = "0.19.1";
  };
  jmespath = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vpvd61kc60f98jn28kw7x7vi82qrwgglam42nvzh98i43yxwsfb";
      type = "gem";
    };
    version = "1.1.3";
  };
  ice_nine = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nv35qg1rps9fsis28hz2cq2fx1i96795f91q4nmkm934xynll2x";
      type = "gem";
    };
    version = "0.11.2";
  };
  equalizer = {
    source = {
      sha256 = "1kjmx3fygx8njxfrwcmn7clfhjhb6bvv3scy2lyyi0wqyi3brra4";
      type = "gem";
    };
    version = "0.0.11";
  };
  descendants_tracker = {
    dependencies = ["thread_safe"];
    source = {
      sha256 = "15q8g3fcqyb41qixn6cky0k3p86291y7xsh1jfd851dvrza1vi79";
      type = "gem";
    };
    version = "0.0.4";
  };
  coercible = {
    dependencies = ["descendants_tracker"];
    source = {
      sha256 = "1p5azydlsz0nkxmcq0i1gzmcfq02lgxc4as7wmf47j1c6ljav0ah";
      type = "gem";
    };
    version = "1.0.0";
  };
  cide = {
    version = "0.9.0";
    source = {
      type = "gem";
      remotes = ["https://rubygems.org"];
      sha256 = "1wykwv0jnrh49jm9zsy1cb5wddv65iw4ixh072hr242wb83dcyl0";
    };
  };
  axiom-types = {
    dependencies = ["descendants_tracker" "ice_nine" "thread_safe"];
    source = {
      sha256 = "10q3k04pll041mkgy0m5fn2b1lazm6ly1drdbcczl5p57lzi3zy1";
      type = "gem";
    };
    version = "0.1.1";
  };
  aws-sdk-resources = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vdnpjmil99n9d1fpk1w6ssgvmzx4wfmrqcij8nyd0iqdaacx3fj";
      type = "gem";
    };
    version = "2.2.17";
  };
  aws-sdk-core = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vq7ny5n3rdfzkdqdm76r48slmp2a5v7565llrl4bw5hb5k4p75z";
      type = "gem";
    };
    version = "2.2.17";
  };
  aws-sdk = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cwycrdk21blzjzf8fj1wlmdix94rj9aixj6phx6lwbqykn2dzx9";
      type = "gem";
    };
    version = "2.2.17";
  };
}