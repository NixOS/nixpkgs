{
  "addressable" = {
    version = "2.3.7";
    source = {
      type = "gem";
      sha256 = "1x1401m59snw59c2bxr10jj10z1n4r4jvz8c55d0c3sh2smbl8kh";
    };
  };
  "buftok" = {
    version = "0.2.0";
    source = {
      type = "gem";
      sha256 = "1rzsy1vy50v55x9z0nivf23y0r9jkmq6i130xa75pq9i8qrn1mxs";
    };
  };
  "equalizer" = {
    version = "0.0.9";
    source = {
      type = "gem";
      sha256 = "1i6vfh2lzyrvvm35qa9cf3xh2gxj941x0v78pp0c7bwji3f5hawr";
    };
  };
  "faraday" = {
    version = "0.9.1";
    source = {
      type = "gem";
      sha256 = "1h33znnfzxpscgpq28i9fcqijd61h61zgs3gabpdgqfa1043axsn";
    };
    dependencies = [
      "multipart-post"
    ];
  };
  "geokit" = {
    version = "1.9.0";
    source = {
      type = "gem";
      sha256 = "1bpkjz2q8hm7i4mrrp1if51zq6fz3qkqj55qwlb7jh9jlgyvjmqy";
    };
    dependencies = [
      "multi_json"
    ];
  };
  "htmlentities" = {
    version = "4.3.3";
    source = {
      type = "gem";
      sha256 = "0v4m2pn6q2h7iqdkxk9z3j4828harcjgk1h77v9i4x87avv5130p";
    };
  };
  "http" = {
    version = "0.6.3";
    source = {
      type = "gem";
      sha256 = "0wmj5i1l0f6ajhs8wi1h3sdwhrl00llrpsmh6xs9dwjm2amvdvxv";
    };
    dependencies = [
      "http_parser.rb"
    ];
  };
  "http_parser.rb" = {
    version = "0.6.0";
    source = {
      type = "gem";
      sha256 = "15nidriy0v5yqfjsgsra51wmknxci2n2grliz78sf9pga3n0l7gi";
    };
  };
  "json" = {
    version = "1.8.2";
    source = {
      type = "gem";
      sha256 = "0zzvv25vjikavd3b1bp6lvbgj23vv9jvmnl4vpim8pv30z8p6vr5";
    };
  };
  "launchy" = {
    version = "2.4.3";
    source = {
      type = "gem";
      sha256 = "190lfbiy1vwxhbgn4nl4dcbzxvm049jwc158r2x7kq3g5khjrxa2";
    };
    dependencies = [
      "addressable"
    ];
  };
  "memoizable" = {
    version = "0.4.2";
    source = {
      type = "gem";
      sha256 = "0v42bvghsvfpzybfazl14qhkrjvx0xlmxz0wwqc960ga1wld5x5c";
    };
    dependencies = [
      "thread_safe"
    ];
  };
  "multi_json" = {
    version = "1.11.0";
    source = {
      type = "gem";
      sha256 = "1mg3hp17ch8bkf3ndj40s50yjs0vrqbfh3aq5r02jkpjkh23wgxl";
    };
  };
  "multipart-post" = {
    version = "2.0.0";
    source = {
      type = "gem";
      sha256 = "09k0b3cybqilk1gwrwwain95rdypixb2q9w65gd44gfzsd84xi1x";
    };
  };
  "naught" = {
    version = "1.0.0";
    source = {
      type = "gem";
      sha256 = "04m6hh63c96kcnzwy5mpl826yn6sm465zz1z87mmsig86gqi1izd";
    };
  };
  "oauth" = {
    version = "0.4.7";
    source = {
      type = "gem";
      sha256 = "1k5j09p3al3clpjl6lax62qmhy43f3j3g7i6f9l4dbs6r5vpv95w";
    };
  };
  "retryable" = {
    version = "2.0.1";
    source = {
      type = "gem";
      sha256 = "0wg4vh76cmhwzwrgd0k6kbx4dlp4r98l8yizr72lmzph187dg48f";
    };
  };
  "simple_oauth" = {
    version = "0.3.1";
    source = {
      type = "gem";
      sha256 = "0dw9ii6m7wckml100xhjc6vxpjcry174lbi9jz5v7ibjr3i94y8l";
    };
  };
  "t" = {
    version = "2.9.0";
    source = {
      type = "gem";
      sha256 = "0qdsyblnnan2wcvql2mzg10jaj3gfv5pbfac54b1y7qkr56dc4dv";
    };
    dependencies = [
      "geokit"
      "htmlentities"
      "launchy"
      "oauth"
      "retryable"
      "thor"
      "twitter"
    ];
  };
  "thor" = {
    version = "0.19.1";
    source = {
      type = "gem";
      sha256 = "08p5gx18yrbnwc6xc0mxvsfaxzgy2y9i78xq7ds0qmdm67q39y4z";
    };
  };
  "thread_safe" = {
    version = "0.3.5";
    source = {
      type = "gem";
      sha256 = "1hq46wqsyylx5afkp6jmcihdpv4ynzzq9ygb6z2pb1cbz5js0gcr";
    };
  };
  "twitter" = {
    version = "5.14.0";
    source = {
      type = "gem";
      sha256 = "0vx7x3fmwgk3axqyw9hyf6yh99kx3ssdy14w2686hz7c4v3qwlc5";
    };
    dependencies = [
      "addressable"
      "buftok"
      "equalizer"
      "faraday"
      "http"
      "http_parser.rb"
      "json"
      "memoizable"
      "naught"
      "simple_oauth"
    ];
  };
}