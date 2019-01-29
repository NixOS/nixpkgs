{
  activesupport = {
    dependencies = ["concurrent-ruby" "i18n" "minitest" "tzinfo"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1iya7vxqwxysr74s7b4z1x19gmnx5advimzip3cbmsd5bd43wfgz";
      type = "gem";
    };
    version = "5.2.2";
  };
  addressable = {
    dependencies = ["public_suffix"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0viqszpkggqi8hq87pqp0xykhvz60g99nwmkwsb0v45kc2liwxvk";
      type = "gem";
    };
    version = "2.5.2";
  };
  concurrent-ruby = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ixcx9pfissxrga53jbdpza85qd5f6b5nq1sfqa9rnfq82qnlbp1";
      type = "gem";
    };
    version = "1.1.4";
  };
  faraday = {
    dependencies = ["multipart-post"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0s72m05jvzc1pd6cw1i289chas399q0a14xrwg4rvkdwy7bgzrh0";
      type = "gem";
    };
    version = "0.15.4";
  };
  faraday-http-cache = {
    dependencies = ["faraday"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08j86fgcwl7z792qyijdsq680arzpfiydqd24ja405z2rbm7r2i0";
      type = "gem";
    };
    version = "2.0.0";
  };
  github_changelog_generator = {
    dependencies = ["activesupport" "faraday-http-cache" "multi_json" "octokit" "rainbow" "rake" "retriable"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ylqfmc78i6jf42ydkyng0gzvsl5w80wr3rjkhd6q4kgi96n70lr";
      type = "gem";
    };
    version = "1.14.3";
  };
  i18n = {
    dependencies = ["concurrent-ruby"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "079sqshk08mqs3d6yzvshmqf4s175lpi2pp71f1p10l09sgmrixr";
      type = "gem";
    };
    version = "1.2.0";
  };
  minitest = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0icglrhghgwdlnzzp4jf76b0mbc71s80njn5afyfjn4wqji8mqbq";
      type = "gem";
    };
    version = "5.11.3";
  };
  multi_json = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rl0qy4inf1mp8mybfk56dfga0mvx97zwpmq5xmiwl5r770171nv";
      type = "gem";
    };
    version = "1.13.1";
  };
  multipart-post = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09k0b3cybqilk1gwrwwain95rdypixb2q9w65gd44gfzsd84xi1x";
      type = "gem";
    };
    version = "2.0.0";
  };
  octokit = {
    dependencies = ["sawyer"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yh0yzzqg575ix3y2l2261b9ag82gv2v4f1wczdhcmfbxcz755x6";
      type = "gem";
    };
    version = "4.13.0";
  };
  public_suffix = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08q64b5br692dd3v0a9wq9q5dvycc6kmiqmjbdxkxbfizggsvx6l";
      type = "gem";
    };
    version = "3.0.3";
  };
  rainbow = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bb2fpjspydr6x0s8pn1pqkzmxszvkfapv0p4627mywl7ky4zkhk";
      type = "gem";
    };
    version = "3.0.0";
  };
  rake = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1sy5a7nh6xjdc9yhcw31jji7ssrf9v5806hn95gbrzr998a2ydjn";
      type = "gem";
    };
    version = "12.3.2";
  };
  retriable = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1123kqmy3yk7k3vidvcwa46lknmhilv8axpaiag1wifa576hkqy1";
      type = "gem";
    };
    version = "2.1.0";
  };
  sawyer = {
    dependencies = ["addressable" "faraday"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sv1463r7bqzvx4drqdmd36m7rrv6sf1v3c6vswpnq3k6vdw2dvd";
      type = "gem";
    };
    version = "0.8.1";
  };
  thread_safe = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nmhcgq6cgz44srylra07bmaw99f5271l0dpsvl5f75m44l0gmwy";
      type = "gem";
    };
    version = "0.3.6";
  };
  tzinfo = {
    dependencies = ["thread_safe"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fjx9j327xpkkdlxwmkl3a8wqj7i4l4jwlrv3z13mg95z9wl253z";
      type = "gem";
    };
    version = "1.2.5";
  };
}