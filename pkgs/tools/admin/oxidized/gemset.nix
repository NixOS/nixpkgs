{
  asetus = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zkr8cbp8klanqmhzz7qmimzlxh6zmsy98zb3s75af34l7znq790";
      type = "gem";
    };
    version = "0.3.0";
  };
  backports = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sw58rsz1hl821ia1jj3nnl3jr7xwfkcljgs56kpq3fakzcljcdz";
      type = "gem";
    };
    version = "3.11.2";
  };
  emk-sinatra-url-for = {
    dependencies = ["sinatra"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rd5b1lraklv0hblzdnmw2z3dragfg0qqk7wxbpn58f8y7jxzjgj";
      type = "gem";
    };
    version = "0.2.1";
  };
  ffi = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zw6pbyvmj8wafdc7l5h7w20zkp1vbr2805ql5d941g2b20pk4zr";
      type = "gem";
    };
    version = "1.9.23";
  };
  haml = {
    dependencies = ["tilt"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mrzjgkygvfii66bbylj2j93na8i89998yi01fin3whwqbvx0m1p";
      type = "gem";
    };
    version = "4.0.7";
  };
  htmlentities = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nkklqsn8ir8wizzlakncfv42i32wc0w9hxp00hvdlgjr7376nhj";
      type = "gem";
    };
    version = "4.3.4";
  };
  multi_json = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rl0qy4inf1mp8mybfk56dfga0mvx97zwpmq5xmiwl5r770171nv";
      type = "gem";
    };
    version = "1.13.1";
  };
  net-ssh = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "013p5jb4wy0cq7x7036piw2a3s1i9p752ki1srx2m289mpz4ml3q";
      type = "gem";
    };
    version = "4.1.0";
  };
  oxidized = {
    dependencies = ["asetus" "net-ssh" "rugged" "slop"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xqx0iawj2cm6083a61y43d6a76xaypiw0nkyirx02lhynq07yz0";
      type = "gem";
    };
    version = "0.21.0";
  };
  oxidized-script = {
    dependencies = ["oxidized" "slop"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12c15gksrrar9kradcv6mx2d4a8ixa4lykszb4pcapiw5mi35mxp";
      type = "gem";
    };
    version = "0.5.0";
  };
  oxidized-web = {
    dependencies = ["emk-sinatra-url-for" "haml" "htmlentities" "oxidized" "puma" "sass" "sinatra" "sinatra-contrib"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14s10pr8qaq6g19zi753igngp02li46k3nm5ap537r3743v1l4f9";
      type = "gem";
    };
    version = "0.9.3";
  };
  puma = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03313mnx8n6g9qs9l5zafqq90grrhq2nqrmjs8lsffi28mgd3cfd";
      type = "gem";
    };
    version = "3.11.3";
  };
  rack = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g9926ln2lw12lfxm4ylq1h6nl0rafl10za3xvjzc87qvnqic87f";
      type = "gem";
    };
    version = "1.6.11";
  };
  rack-protection = {
    dependencies = ["rack"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0my0wlw4a5l3hs79jkx2xzv7djhajgf8d28k8ai1ddlnxxb0v7ss";
      type = "gem";
    };
    version = "1.5.5";
  };
  rack-test = {
    dependencies = ["rack"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1l799s5qr2qrshvrggq5ch3v235y491zfww07b39w4pj4vpa65l1";
      type = "gem";
    };
    version = "1.0.0";
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
  rugged = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0q1krxgd0ql03x8m9m05x5sxizw5sc7lms7rkp44qf45grpdk3v3";
      type = "gem";
    };
    version = "0.27.0";
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
  sinatra = {
    dependencies = ["rack" "rack-protection" "tilt"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0byxzl7rx3ki0xd7aiv1x8mbah7hzd8f81l65nq8857kmgzj1jqq";
      type = "gem";
    };
    version = "1.4.8";
  };
  sinatra-contrib = {
    dependencies = ["backports" "multi_json" "rack-protection" "rack-test" "sinatra" "tilt"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vi3i0icbi2figiayxpvxbqpbn1syma7w4p4zw5mav1ln4c7jnfr";
      type = "gem";
    };
    version = "1.4.7";
  };
  slop = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00w8g3j7k7kl8ri2cf1m58ckxk8rn350gp4chfscmgv6pq1spk3n";
      type = "gem";
    };
    version = "3.6.0";
  };
  tilt = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0020mrgdf11q23hm1ddd6fv691l51vi10af00f137ilcdb2ycfra";
      type = "gem";
    };
    version = "2.0.8";
  };
}