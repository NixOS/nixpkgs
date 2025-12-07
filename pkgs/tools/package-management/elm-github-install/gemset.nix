{
  addressable = {
    dependencies = [ "public_suffix" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0mxhjgihzsx45l9wh2n0ywl9w0c6k70igm5r0d63dxkcagwvh4vw";
      type = "gem";
    };
    version = "2.8.8";
  };
  adts = {
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1793bfsgg8ca58b70xas9rglnspig41ih0iwqcad62s0grxzrjwz";
      type = "gem";
    };
    version = "0.1.2";
  };
  commander = {
    dependencies = [ "highline" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1n8k547hqq9hvbyqbx2qi08g0bky20bbjca1df8cqq5frhzxq7bx";
      type = "gem";
    };
    version = "4.6.0";
  };
  contracts = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0rld0n4k9iimrgbi38yfwdjgql6wiaqvmddyggsvvvrw1bcdrz99";
      type = "gem";
    };
    version = "0.16.1";
  };
  elm_install = {
    dependencies = [
      "adts"
      "commander"
      "contracts"
      "git"
      "git_clone_url"
      "indentation"
      "molinillo"
      "smart_colored"
      "solve"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0vw4xllqjzkl6v6mpma6cw4mb57v73alxnnhjxf3wyi55aznv75k";
      type = "gem";
    };
    version = "1.6.1";
  };
  git = {
    dependencies = [
      "addressable"
      "rchardet"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0w3xhay1z7qx9ab04wmy5p4f1fadvqa6239kib256wsiyvcj595h";
      type = "gem";
    };
    version = "1.19.1";
  };
  git_clone_url = {
    dependencies = [ "uri-ssh_git" ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0qgq7pjl461si3m2gr28vwbx47dcbpyy682mcwra5y1klpkbcvr5";
      type = "gem";
    };
    version = "2.0.0";
  };
  highline = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0yclf57n2j3cw8144ania99h1zinf8q3f5zrhqa754j6gl95rp9d";
      type = "gem";
    };
    version = "2.0.3";
  };
  indentation = {
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ix64qgmm91xm1yiqxdcn9bqb1l6gwvkv7322yni34b3bd16lgvc";
      type = "gem";
    };
    version = "0.1.1";
  };
  molinillo = {
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "19h1nks0x2ljwyijs2rd1f9sh05j8xqvjaqk1rslp5nyy6h4a758";
      type = "gem";
    };
    version = "0.5.7";
  };
  public_suffix = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "15dhl6k4gbax0xz8frfs4nsb6lg5zgax9vkr1pqzjmhfxddhn2gp";
      type = "gem";
    };
    version = "7.0.0";
  };
  rchardet = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03rr05qam5d6gcsnsjs85bnwg80qww484xql347j42kj3bb2xsnm";
      type = "gem";
    };
    version = "1.10.0";
  };
  semverse = {
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1cf6iv5wgwb7b8jf7il751223k9yahz9aym06s9r0prda5mwddyy";
      type = "gem";
    };
    version = "2.0.0";
  };
  smart_colored = {
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0hccah5iwsvn9rf7zdgl7mdbh0h63vfwy1c6d280cb9qkfj8rdny";
      type = "gem";
    };
    version = "1.1.1";
  };
  solve = {
    dependencies = [
      "molinillo"
      "semverse"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0w7bk0128azqr42ad51ix3wfa385yxwvi6iw9v5qv4ps6ldpzk99";
      type = "gem";
    };
    version = "3.1.1";
  };
  uri-ssh_git = {
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0klyyvivbjll2ry18d8fhm1rbxbzd4kqa9lskxyiha4ndlb22cqj";
      type = "gem";
    };
    version = "2.0.0";
  };
}
