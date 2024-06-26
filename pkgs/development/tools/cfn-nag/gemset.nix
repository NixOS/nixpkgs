{
  aws-eventstream = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1pyis1nvnbjxk12a43xvgj2gv0mvp4cnkc1gzw0v1018r61399gz";
      type = "gem";
    };
    version = "1.2.0";
  };
  aws-partitions = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ap27g6hxcczpb5dj7v0wzxrvywfa2kf3zx69xnjz1qvxf3plw54";
      type = "gem";
    };
    version = "1.568.0";
  };
  aws-sdk-core = {
    dependencies = [
      "aws-eventstream"
      "aws-partitions"
      "aws-sigv4"
      "jmespath"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "14ymvp06k46gvkpvz5zaqvbvr6wd8vdka5iq25q0wd0fzdx7aivm";
      type = "gem";
    };
    version = "3.130.0";
  };
  aws-sdk-kms = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0fmpdll52ng1kfn4r5ndcyppn5553qvvxw87w58m9n70ga3avasi";
      type = "gem";
    };
    version = "1.55.0";
  };
  aws-sdk-s3 = {
    dependencies = [
      "aws-sdk-core"
      "aws-sdk-kms"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0iafjly868kdzmpxkv1ndmqm524ik36ibs15mqh145vw32gz7bax";
      type = "gem";
    };
    version = "1.113.0";
  };
  aws-sigv4 = {
    dependencies = [ "aws-eventstream" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1wh1y79v0s4zgby2m79bnifk65hwf5pvk2yyrxzn2jkjjq8f8fqa";
      type = "gem";
    };
    version = "1.4.0";
  };
  cfn-model = {
    dependencies = [
      "kwalify"
      "psych"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1b3ix36yfnfwyxb4w9ss8a7nc6w15m1wbj3q8rarsqjrs3xj6wjs";
      type = "gem";
    };
    version = "0.6.6";
  };
  cfn-nag = {
    dependencies = [
      "aws-sdk-s3"
      "cfn-model"
      "lightly"
      "logging"
      "netaddr"
      "optimist"
      "rexml"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "14qlnflxx5chjvda9n2ka2axcfcjbmn9h00cija8k7kvpy1dgqga";
      type = "gem";
    };
    version = "0.8.9";
  };
  jmespath = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1mnvb80cdg7fzdcs3xscv21p28w4igk5sj5m7m81xp8v2ks87jj0";
      type = "gem";
    };
    version = "1.6.1";
  };
  kwalify = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ngxg3ysq5vip9dn3d32ajc7ly61kdin86hfycm1hkrcvkkn1vjf";
      type = "gem";
    };
    version = "0.7.2";
  };
  lightly = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0sgj2r6j7qxb9vqzkx5isjbphi38rplk4h8838am0cjcpq5h3jb3";
      type = "gem";
    };
    version = "0.3.3";
  };
  little-plugger = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1frilv82dyxnlg8k1jhrvyd73l6k17mxc5vwxx080r4x1p04gwym";
      type = "gem";
    };
    version = "1.1.4";
  };
  logging = {
    dependencies = [
      "little-plugger"
      "multi_json"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "06j6iaj89h9jhkx1x3hlswqrfnqds8br05xb1qra69dpvbdmjcwn";
      type = "gem";
    };
    version = "2.2.2";
  };
  multi_json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0pb1g1y3dsiahavspyzkdy39j4q377009f6ix0bh1ag4nqw43l0z";
      type = "gem";
    };
    version = "1.15.0";
  };
  netaddr = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0r7nln9xvrralwwhd5s1q4sghp0k9y7g9z5pinzpqkx715xcpdxm";
      type = "gem";
    };
    version = "2.0.5";
  };
  optimist = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vg2chy1cfmdj6c1gryl8zvjhhmb3plwgyh1jfnpq4fnfqv7asrk";
      type = "gem";
    };
    version = "3.0.1";
  };
  psych = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "10iawnkpa44hcfrapy7yw6zmjn4g1g0y09lw244qiv424f7jasn5";
      type = "gem";
    };
    version = "3.3.2";
  };
  rexml = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "08ximcyfjy94pm1rhcx04ny1vx2sk0x4y185gzn86yfsbzwkng53";
      type = "gem";
    };
    version = "3.2.5";
  };
}
