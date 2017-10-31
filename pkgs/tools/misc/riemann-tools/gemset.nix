{
  "CFPropertyList" = {
    version = "2.3.1";
    source = {
      type = "gem";
      sha256 = "1wnk3gxnhfafbhgp0ic7qhzlx3lhv04v8nws2s31ii5s8135hs6k";
    };
  };
  "beefcake" = {
    version = "1.1.0";
    source = {
      type = "gem";
      sha256 = "009gzy9jp81lsnxnwisinhc58cd0qljdiipj2701lzzrha5d826z";
    };
  };
  "builder" = {
    version = "3.2.2";
    source = {
      type = "gem";
      sha256 = "14fii7ab8qszrvsvhz6z2z3i4dw0h41a62fjr2h1j8m41vbrmyv2";
    };
  };
  "excon" = {
    version = "0.45.3";
    source = {
      type = "gem";
      sha256 = "183kfxfjjlc97w4rxkrxjw3kis4lxm65vppmvl4bkblvlw4nq94j";
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
  "fission" = {
    version = "0.5.0";
    source = {
      type = "gem";
      sha256 = "09pmp1j1rr8r3pcmbn2na2ls7s1j9ijbxj99xi3a8r6v5xhjdjzh";
    };
    dependencies = [
      "CFPropertyList"
    ];
  };
  "fog" = {
    version = "1.31.0";
    source = {
      type = "gem";
      sha256 = "0xr8xyrrkljm2hxi420x4qr5v6wqcj8d63v0qy1g6rkb3b1yhl9i";
    };
    dependencies = [
      "fog-atmos"
      "fog-aws"
      "fog-brightbox"
      "fog-core"
      "fog-ecloud"
      "fog-google"
      "fog-json"
      "fog-local"
      "fog-powerdns"
      "fog-profitbricks"
      "fog-radosgw"
      "fog-riakcs"
      "fog-sakuracloud"
      "fog-serverlove"
      "fog-softlayer"
      "fog-storm_on_demand"
      "fog-terremark"
      "fog-vmfusion"
      "fog-voxel"
      "fog-xml"
      "ipaddress"
      "nokogiri"
    ];
  };
  "fog-atmos" = {
    version = "0.1.0";
    source = {
      type = "gem";
      sha256 = "1aaxgnw9zy96gsh4h73kszypc32sx497s6bslvhfqh32q9d1y8c9";
    };
    dependencies = [
      "fog-core"
      "fog-xml"
    ];
  };
  "fog-aws" = {
    version = "0.6.0";
    source = {
      type = "gem";
      sha256 = "1m79s5ha6qq60pxqqxr9qs9fg8fwaz79sfxckidyhxdydcsjwx6z";
    };
    dependencies = [
      "fog-core"
      "fog-json"
      "fog-xml"
      "ipaddress"
    ];
  };
  "fog-brightbox" = {
    version = "0.7.2";
    source = {
      type = "gem";
      sha256 = "0636sqaf2w1rh4i2hxfgs24374l4ai8dgch8a7nycqhvjk2dm0aq";
    };
    dependencies = [
      "fog-core"
      "fog-json"
      "inflecto"
    ];
  };
  "fog-core" = {
    version = "1.31.1";
    source = {
      type = "gem";
      sha256 = "1bcsy4cq7vyjmdf3h2v7q6hfj64v6phn0rfvwgj5wfza7yaxnhk7";
    };
    dependencies = [
      "builder"
      "excon"
      "formatador"
      "mime-types"
      "net-scp"
      "net-ssh"
    ];
  };
  "fog-ecloud" = {
    version = "0.3.0";
    source = {
      type = "gem";
      sha256 = "18rb4qjad9xwwqvvpj8r2h0hi9svy71pm4d3fc28cdcnfarmdi06";
    };
    dependencies = [
      "fog-core"
      "fog-xml"
    ];
  };
  "fog-google" = {
    version = "0.0.6";
    source = {
      type = "gem";
      sha256 = "1g3ykk239nxpdsr5anhprkp8vzk106gi4q6aqjh4z8q4bii0dflm";
    };
    dependencies = [
      "fog-core"
      "fog-json"
      "fog-xml"
    ];
  };
  "fog-json" = {
    version = "1.0.2";
    source = {
      type = "gem";
      sha256 = "0advkkdjajkym77r3c0bg2rlahl2akj0vl4p5r273k2qmi16n00r";
    };
    dependencies = [
      "fog-core"
      "multi_json"
    ];
  };
  "fog-local" = {
    version = "0.2.1";
    source = {
      type = "gem";
      sha256 = "0i5hxwzmc2ag3z9nlligsaf679kp2pz39cd8n2s9cmxaamnlh2s3";
    };
    dependencies = [
      "fog-core"
    ];
  };
  "fog-powerdns" = {
    version = "0.1.1";
    source = {
      type = "gem";
      sha256 = "08zavzwfkk344gz83phz4sy9nsjznsdjsmn1ifp6ja17bvydlhh7";
    };
    dependencies = [
      "fog-core"
      "fog-json"
      "fog-xml"
    ];
  };
  "fog-profitbricks" = {
    version = "0.0.3";
    source = {
      type = "gem";
      sha256 = "01a3ylfkjkyagf4b4xg9x2v20pzapr3ivn9ydd92v402bjsm1nmr";
    };
    dependencies = [
      "fog-core"
      "fog-xml"
      "nokogiri"
    ];
  };
  "fog-radosgw" = {
    version = "0.0.4";
    source = {
      type = "gem";
      sha256 = "1pxbvmr4dsqx4x2klwnciyhki4r5ryr9y0hi6xmm3n6fdv4ii7k3";
    };
    dependencies = [
      "fog-core"
      "fog-json"
      "fog-xml"
    ];
  };
  "fog-riakcs" = {
    version = "0.1.0";
    source = {
      type = "gem";
      sha256 = "1nbxc4dky3agfwrmgm1aqmi59p6vnvfnfbhhg7xpg4c2cf41whxm";
    };
    dependencies = [
      "fog-core"
      "fog-json"
      "fog-xml"
    ];
  };
  "fog-sakuracloud" = {
    version = "1.0.1";
    source = {
      type = "gem";
      sha256 = "1s16b48kh7y03hjv74ccmlfwhqqq7j7m4k6cywrgbyip8n3258n8";
    };
    dependencies = [
      "fog-core"
      "fog-json"
    ];
  };
  "fog-serverlove" = {
    version = "0.1.2";
    source = {
      type = "gem";
      sha256 = "0hxgmwzygrw25rbsy05i6nzsyr0xl7xj5j2sjpkb9n9wli5sagci";
    };
    dependencies = [
      "fog-core"
      "fog-json"
    ];
  };
  "fog-softlayer" = {
    version = "0.4.7";
    source = {
      type = "gem";
      sha256 = "0fgfbhqnyp8ywymvflflhvbns54d1432x57pgpnfy8k1cxvhv9b8";
    };
    dependencies = [
      "fog-core"
      "fog-json"
    ];
  };
  "fog-storm_on_demand" = {
    version = "0.1.1";
    source = {
      type = "gem";
      sha256 = "0fif1x8ci095b2yyilf65n7x6iyvn448azrsnmwsdkriy8vxxv3y";
    };
    dependencies = [
      "fog-core"
      "fog-json"
    ];
  };
  "fog-terremark" = {
    version = "0.1.0";
    source = {
      type = "gem";
      sha256 = "01lfkh9jppj0iknlklmwyb7ym3bfhkq58m3absb6rf5a5mcwi3lf";
    };
    dependencies = [
      "fog-core"
      "fog-xml"
    ];
  };
  "fog-vmfusion" = {
    version = "0.1.0";
    source = {
      type = "gem";
      sha256 = "0g0l0k9ylxk1h9pzqr6h2ba98fl47lpp3j19lqv4jxw0iw1rqxn4";
    };
    dependencies = [
      "fission"
      "fog-core"
    ];
  };
  "fog-voxel" = {
    version = "0.1.0";
    source = {
      type = "gem";
      sha256 = "10skdnj59yf4jpvq769njjrvh2l0wzaa7liva8n78qq003mvmfgx";
    };
    dependencies = [
      "fog-core"
      "fog-xml"
    ];
  };
  "fog-xml" = {
    version = "0.1.2";
    source = {
      type = "gem";
      sha256 = "1576sbzza47z48p0k9h1wg3rhgcvcvdd1dfz3xx1cgahwr564fqa";
    };
    dependencies = [
      "fog-core"
      "nokogiri"
    ];
  };
  "formatador" = {
    version = "0.2.5";
    source = {
      type = "gem";
      sha256 = "1gc26phrwlmlqrmz4bagq1wd5b7g64avpx0ghxr9xdxcvmlii0l0";
    };
  };
  "inflecto" = {
    version = "0.0.2";
    source = {
      type = "gem";
      sha256 = "085l5axmvqw59mw5jg454a3m3gr67ckq9405a075isdsn7bm3sp4";
    };
  };
  "ipaddress" = {
    version = "0.8.0";
    source = {
      type = "gem";
      sha256 = "0cwy4pyd9nl2y2apazp3hvi12gccj5a3ify8mi8k3knvxi5wk2ir";
    };
  };
  "mime-types" = {
    version = "2.6.1";
    source = {
      type = "gem";
      sha256 = "1vnrvf245ijfyxzjbj9dr6i1hkjbyrh4yj88865wv9bs75axc5jv";
    };
  };
  "mini_portile" = {
    version = "0.6.2";
    source = {
      type = "gem";
      sha256 = "0h3xinmacscrnkczq44s6pnhrp4nqma7k056x5wv5xixvf2wsq2w";
    };
  };
  "mtrc" = {
    version = "0.0.4";
    source = {
      type = "gem";
      sha256 = "0xj2pv4cpn0ad1xw38sinsxfzwhgqs6ff18hw0cwz5xmsf3zqmiz";
    };
  };
  "multi_json" = {
    version = "1.11.1";
    source = {
      type = "gem";
      sha256 = "0lrmadw2scqwz7nw3j5pfdnmzqimlbaxlxi37xsydrpbbr78qf6g";
    };
  };
  "multipart-post" = {
    version = "2.0.0";
    source = {
      type = "gem";
      sha256 = "09k0b3cybqilk1gwrwwain95rdypixb2q9w65gd44gfzsd84xi1x";
    };
  };
  "munin-ruby" = {
    version = "0.2.5";
    source = {
      type = "gem";
      sha256 = "0378jyf0hdbfs2vvk7v8k7hqilzi1rfkpn271dyrqqal7g2lnjl2";
    };
  };
  "net-scp" = {
    version = "1.2.1";
    source = {
      type = "gem";
      sha256 = "0b0jqrcsp4bbi4n4mzyf70cp2ysyp6x07j8k8cqgxnvb4i3a134j";
    };
    dependencies = [
      "net-ssh"
    ];
  };
  "net-ssh" = {
    version = "2.9.2";
    source = {
      type = "gem";
      sha256 = "1p0bj41zrmw5lhnxlm1pqb55zfz9y4p9fkrr9a79nrdmzrk1ph8r";
    };
  };
  "nokogiri" = {
    version = "1.6.6.2";
    source = {
      type = "gem";
      sha256 = "1j4qv32qjh67dcrc1yy1h8sqjnny8siyy4s44awla8d6jk361h30";
    };
    dependencies = [
      "mini_portile"
    ];
  };
  "riemann-client" = {
    version = "0.2.5";
    source = {
      type = "gem";
      sha256 = "1myhyh31f290jm1wlhhjvf331n5l8qdm7axkxyacdgjsfg4szsjc";
    };
    dependencies = [
      "beefcake"
      "mtrc"
      "trollop"
    ];
  };
  "riemann-tools" = {
    version = "0.2.6";
    source = {
      type = "gem";
      sha256 = "0qjm7p55h70l5bs876hhvz3isr204663f97py9g0ajxz2z8jkzpi";
    };
    dependencies = [
      "faraday"
      "fog"
      "munin-ruby"
      "nokogiri"
      "riemann-client"
      "trollop"
      "yajl-ruby"
    ];
  };
  "trollop" = {
    version = "2.1.2";
    source = {
      type = "gem";
      sha256 = "0415y63df86sqj43c0l82and65ia5h64if7n0znkbrmi6y0jwhl8";
    };
  };
  "yajl-ruby" = {
    version = "1.2.1";
    source = {
      type = "gem";
      sha256 = "0zvvb7i1bl98k3zkdrnx9vasq0rp2cyy5n7p9804dqs4fz9xh9vf";
    };
  };
}