{
  base64 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DyXpshoCoMwM6o75KyBBA105NQlG6HicVistGj2gFQc=";
      type = "gem";
    };
    version = "0.2.0";
  };
  daemons = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-j8dtdvrsZp/rXkVdcvNb1MRtxnNeKMQgr7gi+sH6mh0=";
      type = "gem";
    };
    version = "1.4.1";
  };
  date = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-vyaOFO9xWACb/q7EC1+jxycZBuiLGW2VionUtAir5k8=";
      type = "gem";
    };
    version = "3.4.1";
  };
  eventmachine = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-mUAW5CqgQUd7qc/0XL5Q3iBH8l3UGOugA+hPDRZWCXI=";
      type = "gem";
    };
    version = "1.2.7";
  };
  faye-websocket = {
    dependencies = [
      "eventmachine"
      "websocket-driver"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-EJGHFhk5xXAy0rup5cRWISUdc/gGu2CNLUw6ssq+swc=";
      type = "gem";
    };
    version = "0.11.3";
  };
  mail = {
    dependencies = [
      "mini_mime"
      "net-imap"
      "net-pop"
      "net-smtp"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-7Dufrc8rN1XHh4XLF7yaDKnumFcQimS29c/JwLW/ya0=";
      type = "gem";
    };
    version = "2.8.1";
  };
  mailcatcher = {
    dependencies = [
      "eventmachine"
      "faye-websocket"
      "mail"
      "net-smtp"
      "rack"
      "sinatra"
      "sqlite3"
      "thin"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-9Ztv4YRoe9rSs6RTK3m7Mxs1gw8dDczyB1DeRmPVAw0=";
      type = "gem";
    };
    version = "0.10.0";
  };
  mini_mime = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hoG34uQhXyoVn5QAtYFthenYxsa0kelqEnl+eY+LzO8=";
      type = "gem";
    };
    version = "1.1.5";
  };
  mini_portile2 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-jkcTbNrATOgXULtsCXM7N4lb8GliVU5LQFbXgWjXCnU=";
      type = "gem";
    };
    version = "2.8.8";
  };
  mustermann = {
    dependencies = [ "ruby2_keywords" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-0fjpui3a7UcVDd+B9qfqBGgmtkxnL7yS2DvOa3Blfog=";
      type = "gem";
    };
    version = "3.0.3";
  };
  net-imap = {
    dependencies = [
      "date"
      "net-protocol"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Ht6ASO5oihQgYGC/N6cW0Yy26gCFX2ybFdrul+5R++U=";
      type = "gem";
    };
    version = "0.5.6";
  };
  net-pop = {
    dependencies = [ "net-protocol" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hItOmCATwVsvA4J5Imh2O3SMzpHJ6R42sPJ+0mQg3/M=";
      type = "gem";
    };
    version = "0.1.2";
  };
  net-protocol = {
    dependencies = [ "timeout" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-qnPgy6ahJTad6YN7jY74KmGEk2DroFIZAOLDcTqhYqg=";
      type = "gem";
    };
    version = "0.2.2";
  };
  net-smtp = {
    dependencies = [ "net-protocol" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-7Zagr2PFJPzrSymw01IZXDDYLdkWpC8Dxio6cOW3BzY=";
      type = "gem";
    };
    version = "0.5.1";
  };
  rack = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zO4QFxlpal2hLunab7Ox0gyzKZOeCJ4ORYvm6TZn8Ps=";
      type = "gem";
    };
    version = "2.2.13";
  };
  rack-protection = {
    dependencies = [
      "base64"
      "rack"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-PHS6f8WQZkU9Ya+by6W2/nqbPatvRFQY07OR1eqO+/8=";
      type = "gem";
    };
    version = "3.2.0";
  };
  ruby2_keywords = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/9E3QMVztzAc96LmH8hXsqjj06/zJUXW+DANi64Q4+8=";
      type = "gem";
    };
    version = "0.0.5";
  };
  sinatra = {
    dependencies = [
      "mustermann"
      "rack"
      "rack-protection"
      "tilt"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-bnJ/TQNOhwZ9mqs38ygCHXwWci/9KT7we26WiRUQmAc=";
      type = "gem";
    };
    version = "3.2.0";
  };
  sqlite3 = {
    dependencies = [ "mini_portile2" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-+nf2PHCVSPRtTptrtFzaUqo4gaoSzIWZETJ1jolocBw=";
      type = "gem";
    };
    version = "1.7.3";
  };
  thin = {
    dependencies = [
      "daemons"
      "eventmachine"
      "rack"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-HFUlGrpb7nz2k26hiwSPTTx074EKpeaQbPbt/w324SE=";
      type = "gem";
    };
    version = "1.8.2";
  };
  tilt = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Jj10hGbg2D5RCqGi4ige/1R5N/DvBr4z02MnIeJV92s=";
      type = "gem";
    };
    version = "2.6.0";
  };
  timeout = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-lQnwebK1X+QjbXljO9deNMHB5+P7S1bLX9ph+AoP4w4=";
      type = "gem";
    };
    version = "0.4.3";
  };
  websocket-driver = {
    dependencies = [
      "base64"
      "websocket-extensions"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-BW2Z8s1UVxLPsSkWUP3nR45PJmHcHbag+juWYjGhRrQ=";
      type = "gem";
    };
    version = "0.7.7";
  };
  websocket-extensions = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-HGumMJLNo0PrU/xlcRDHHHVMVkhKrUJXhJUifXF6gkE=";
      type = "gem";
    };
    version = "0.1.5";
  };
}
