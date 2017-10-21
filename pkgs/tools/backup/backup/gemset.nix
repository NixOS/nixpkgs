{
  "CFPropertyList" = {
    version = "2.3.1";
    source = {
      type = "gem";
      sha256 = "1wnk3gxnhfafbhgp0ic7qhzlx3lhv04v8nws2s31ii5s8135hs6k";
    };
  };
  "addressable" = {
    version = "2.3.5";
    source = {
      type = "gem";
      sha256 = "11hv69v6h39j7m4v51a4p7my7xwjbhxbsg3y7ja156z7by10wkg7";
    };
  };
  "atomic" = {
    version = "1.1.14";
    source = {
      type = "gem";
      sha256 = "09dzi1gxr5yj273s6s6ss7l2sq4ayavpg95561kib3n4kzvxrhk4";
    };
  };
  "aws-ses" = {
    version = "0.5.0";
    source = {
      type = "gem";
      sha256 = "1kpfcdnakngypgkzn1f8cl8p4jg1rvmx3ag4ggcl0c7gs91ki8k3";
    };
    dependencies = [
      "builder"
      "mail"
      "mime-types"
      "xml-simple"
    ];
  };
  "backup" = {
    version = "4.2.2";
    source = {
      type = "gem";
      sha256 = "0fj5jq6s1kpgp4bl1sr7qw1dgyc9zk0afh6mrfgbscg82irfxi1p";
    };
    dependencies = [
      "CFPropertyList"
      "addressable"
      "atomic"
      "aws-ses"
      "buftok"
      "builder"
      "descendants_tracker"
      "dogapi"
      "dropbox-sdk"
      "equalizer"
      "excon"
      "faraday"
      "fission"
      "flowdock"
      "fog"
      "fog-atmos"
      "fog-aws"
      "fog-brightbox"
      "fog-core"
      "fog-ecloud"
      "fog-json"
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
      "formatador"
      "hipchat"
      "http"
      "http_parser.rb"
      "httparty"
      "inflecto"
      "ipaddress"
      "json"
      "mail"
      "memoizable"
      "mime-types"
      "mini_portile"
      "multi_json"
      "multi_xml"
      "multipart-post"
      "net-scp"
      "net-sftp"
      "net-ssh"
      "nokogiri"
      "open4"
      "pagerduty"
      "polyglot"
      "simple_oauth"
      "thor"
      "thread_safe"
      "treetop"
      "twitter"
      "unf"
      "unf_ext"
      "xml-simple"
    ];
  };
  "buftok" = {
    version = "0.2.0";
    source = {
      type = "gem";
      sha256 = "1rzsy1vy50v55x9z0nivf23y0r9jkmq6i130xa75pq9i8qrn1mxs";
    };
  };
  "builder" = {
    version = "3.2.2";
    source = {
      type = "gem";
      sha256 = "14fii7ab8qszrvsvhz6z2z3i4dw0h41a62fjr2h1j8m41vbrmyv2";
    };
  };
  "descendants_tracker" = {
    version = "0.0.3";
    source = {
      type = "gem";
      sha256 = "0819j80k85j62qjg90v8z8s3h4nf3v6afxxz73hl6iqxr2dhgmq1";
    };
  };
  "diff-lcs" = {
    version = "1.2.5";
    source = {
      type = "gem";
      sha256 = "1vf9civd41bnqi6brr5d9jifdw73j9khc6fkhfl1f8r9cpkdvlx1";
    };
  };
  "dogapi" = {
    version = "1.11.0";
    source = {
      type = "gem";
      sha256 = "01v5jphxbqdn8h0pifgl97igcincd1pjwd177a80ig9fpwndd19d";
    };
    dependencies = [
      "json"
    ];
  };
  "dropbox-sdk" = {
    version = "1.5.1";
    source = {
      type = "gem";
      sha256 = "1zrzxzjfgwkdnn5vjvkhhjh10azyy28982hpkw5xv0kwrqg07axj";
    };
    dependencies = [
      "json"
    ];
  };
  "equalizer" = {
    version = "0.0.9";
    source = {
      type = "gem";
      sha256 = "1i6vfh2lzyrvvm35qa9cf3xh2gxj941x0v78pp0c7bwji3f5hawr";
    };
  };
  "excon" = {
    version = "0.44.4";
    source = {
      type = "gem";
      sha256 = "062ynrdazix4w1lz6n8qgm3dasi2837sfn88ma96pbp4sk11gbp5";
    };
  };
  "faraday" = {
    version = "0.8.8";
    source = {
      type = "gem";
      sha256 = "1cnyj5japrnv6wvl01la5amf7hikckfznh8234ad21n730b2wci4";
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
  "flowdock" = {
    version = "0.4.0";
    source = {
      type = "gem";
      sha256 = "1myza5n6wqk550ky3ld4np89cd491prndqy0l1fqsddxpap6pp60";
    };
    dependencies = [
      "httparty"
      "multi_json"
    ];
  };
  "fog" = {
    version = "1.28.0";
    source = {
      type = "gem";
      sha256 = "12b03r77vdicbsc7j6by2gysm16wij32z65qp6bkrxkfba9yb37h";
    };
    dependencies = [
      "fog-atmos"
      "fog-aws"
      "fog-brightbox"
      "fog-core"
      "fog-ecloud"
      "fog-json"
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
    version = "0.1.1";
    source = {
      type = "gem";
      sha256 = "17a3sspf81bgvkrrrmwx7aci7fjy1m7b3w61ljc2mpqbafz80v7i";
    };
    dependencies = [
      "fog-core"
      "fog-json"
      "fog-xml"
      "ipaddress"
    ];
  };
  "fog-brightbox" = {
    version = "0.7.1";
    source = {
      type = "gem";
      sha256 = "1cpa92q2ls51gidxzn407x53f010k0hmrl94ipw7rdzdapp8c4cn";
    };
    dependencies = [
      "fog-core"
      "fog-json"
      "inflecto"
    ];
  };
  "fog-core" = {
    version = "1.29.0";
    source = {
      type = "gem";
      sha256 = "0ayv9j3i7jy2d1l4gw6sfchgb8l62590a6fpvpr7qvdjc79mvm3p";
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
    version = "0.0.2";
    source = {
      type = "gem";
      sha256 = "0lhxjp6gi48zanqmkblyhxjp0lknl1akifgfk5lq3j3vj2d3pnr8";
    };
    dependencies = [
      "fog-core"
      "fog-xml"
    ];
  };
  "fog-json" = {
    version = "1.0.0";
    source = {
      type = "gem";
      sha256 = "1517sm8bl0bmaw2fbaf5ra6midq3wzgkpm55lb9rw6jm5ys23lyw";
    };
    dependencies = [
      "multi_json"
    ];
  };
  "fog-profitbricks" = {
    version = "0.0.2";
    source = {
      type = "gem";
      sha256 = "0hk290cw99qx727sxfhxlmczv9kv15hlnrflh00wfprqxk4r8rd4";
    };
    dependencies = [
      "fog-core"
      "fog-xml"
      "nokogiri"
    ];
  };
  "fog-radosgw" = {
    version = "0.0.3";
    source = {
      type = "gem";
      sha256 = "1fbpi0sfff5f5hrn4f7ish260cykzcqvzwmvm61i6mprfrfnx10r";
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
    version = "1.0.0";
    source = {
      type = "gem";
      sha256 = "1805m44x2pclhjyvdrpj6zg8l9dldgnc20h0g61r7hqxpydz066x";
    };
    dependencies = [
      "fog-core"
      "fog-json"
    ];
  };
  "fog-serverlove" = {
    version = "0.1.1";
    source = {
      type = "gem";
      sha256 = "094plkkr6xiss8k85fp66g7z544kxgfx1ck0f3sqndk27miw26jk";
    };
    dependencies = [
      "fog-core"
      "fog-json"
    ];
  };
  "fog-softlayer" = {
    version = "0.4.1";
    source = {
      type = "gem";
      sha256 = "1cf6y6xxjjpjglz31kf6jmmyh687x7sxhn4bx3hlr1nb1hcy19sq";
    };
    dependencies = [
      "fog-core"
      "fog-json"
    ];
  };
  "fog-storm_on_demand" = {
    version = "0.1.0";
    source = {
      type = "gem";
      sha256 = "0rrfv37x9y07lvdd03pbappb8ybvqb6g8rxzwvgy3mmbmbc6l6d2";
    };
    dependencies = [
      "fog-core"
      "fog-json"
    ];
  };
  "fog-terremark" = {
    version = "0.0.4";
    source = {
      type = "gem";
      sha256 = "0bxznlc904zaw3qaxhkvhqqbrv9n6nf5idih8ra9dihvacifwhvc";
    };
    dependencies = [
      "fog-core"
      "fog-xml"
    ];
  };
  "fog-vmfusion" = {
    version = "0.0.1";
    source = {
      type = "gem";
      sha256 = "0x1vxc4a627g7ambcprhxiqvywy64li90145r96b2ig9z23hmy7g";
    };
    dependencies = [
      "fission"
      "fog-core"
    ];
  };
  "fog-voxel" = {
    version = "0.0.2";
    source = {
      type = "gem";
      sha256 = "0by7cs0c044b8dkcmcf3pjzydnrakj8pnbcxzhw8hwlgqr0jfqgn";
    };
    dependencies = [
      "fog-core"
      "fog-xml"
    ];
  };
  "fog-xml" = {
    version = "0.1.1";
    source = {
      type = "gem";
      sha256 = "0kgxjwz0mzyp7bgj1ycl9jyfmzfqc1fjdz9sm57fgj5w31jfvxw5";
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
  "fuubar" = {
    version = "2.0.0";
    source = {
      type = "gem";
      sha256 = "0xwqs24y8s73aayh39si17kccsmr0bjgmi6jrjyfp7gkjb6iyhpv";
    };
    dependencies = [
      "rspec"
      "ruby-progressbar"
    ];
  };
  "hipchat" = {
    version = "1.0.1";
    source = {
      type = "gem";
      sha256 = "1khcb6cxrr1qn104rl87wq85anigykf45x7knxnyqfpwnbda2nh1";
    };
    dependencies = [
      "httparty"
    ];
  };
  "http" = {
    version = "0.5.0";
    source = {
      type = "gem";
      sha256 = "1vw10xxs0i7kn90lx3b2clfkm43nb59jjph902bafpsaarqsai8d";
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
  "httparty" = {
    version = "0.12.0";
    source = {
      type = "gem";
      sha256 = "10y3znh7s1fx88lbnbsmyx5zri6jr1gi48zzzq89wir8q9zlp28c";
    };
    dependencies = [
      "json"
      "multi_xml"
    ];
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
  "json" = {
    version = "1.8.2";
    source = {
      type = "gem";
      sha256 = "0zzvv25vjikavd3b1bp6lvbgj23vv9jvmnl4vpim8pv30z8p6vr5";
    };
  };
  "mail" = {
    version = "2.5.4";
    source = {
      type = "gem";
      sha256 = "0z15ksb8blcppchv03g34844f7xgf36ckp484qjj2886ig1qara4";
    };
    dependencies = [
      "mime-types"
      "treetop"
    ];
  };
  "memoizable" = {
    version = "0.4.0";
    source = {
      type = "gem";
      sha256 = "0xhg8c9qw4y35qp1k8kv20snnxk6rlyilx354n1d72r0y10s7qcr";
    };
    dependencies = [
      "thread_safe"
    ];
  };
  "metaclass" = {
    version = "0.0.4";
    source = {
      type = "gem";
      sha256 = "0hp99y2b1nh0nr8pc398n3f8lakgci6pkrg4bf2b2211j1f6hsc5";
    };
  };
  "mime-types" = {
    version = "1.25.1";
    source = {
      type = "gem";
      sha256 = "0mhzsanmnzdshaba7gmsjwnv168r1yj8y0flzw88frw1cickrvw8";
    };
  };
  "mini_portile" = {
    version = "0.6.2";
    source = {
      type = "gem";
      sha256 = "0h3xinmacscrnkczq44s6pnhrp4nqma7k056x5wv5xixvf2wsq2w";
    };
  };
  "mocha" = {
    version = "1.1.0";
    source = {
      type = "gem";
      sha256 = "107nmnngbv8lq2g7hbjpn5kplb4v2c8gs9lxrg6vs8gdbddkilzi";
    };
    dependencies = [
      "metaclass"
    ];
  };
  "multi_json" = {
    version = "1.10.1";
    source = {
      type = "gem";
      sha256 = "1ll21dz01jjiplr846n1c8yzb45kj5hcixgb72rz0zg8fyc9g61c";
    };
  };
  "multi_xml" = {
    version = "0.5.5";
    source = {
      type = "gem";
      sha256 = "0i8r7dsz4z79z3j023l8swan7qpbgxbwwz11g38y2vjqjk16v4q8";
    };
  };
  "multipart-post" = {
    version = "1.2.0";
    source = {
      type = "gem";
      sha256 = "12p7lnmc52di1r4h73h6xrpppplzyyhani9p7wm8l4kgf1hnmwnc";
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
  "net-sftp" = {
    version = "2.1.2";
    source = {
      type = "gem";
      sha256 = "04674g4n6mryjajlcd82af8g8k95la4b1bj712dh71hw1c9vhw1y";
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
  "open4" = {
    version = "1.3.0";
    source = {
      type = "gem";
      sha256 = "12jyp97p7pq29q1zmkdrhzvg5cg2x3hlfdbq6asnb9nqlkx6vhf2";
    };
  };
  "pagerduty" = {
    version = "2.0.0";
    source = {
      type = "gem";
      sha256 = "1ads8bj2swm3gbhr6193ls83pnwsy39xyh3i8sw6rl8fxfdf717v";
    };
    dependencies = [
      "json"
    ];
  };
  "polyglot" = {
    version = "0.3.3";
    source = {
      type = "gem";
      sha256 = "082zmail2h3cxd9z1wnibhk6aj4sb1f3zzwra6kg9bp51kx2c00v";
    };
  };
  "rspec" = {
    version = "3.4.0";
    source = {
      type = "gem";
      sha256 = "12axhz2nj2m0dy350lxym76m36m1hq48hc59mf00z9dajbpnj78s";
    };
    dependencies = [
      "rspec-core"
      "rspec-expectations"
      "rspec-mocks"
    ];
  };
  "rspec-core" = {
    version = "3.4.1";
    source = {
      type = "gem";
      sha256 = "0zl4fbrzl4gg2bn3fhv910q04sm2jvzdidmvd71gdgqwbzk0zngn";
    };
    dependencies = [
      "rspec-support"
    ];
  };
  "rspec-expectations" = {
    version = "3.4.0";
    source = {
      type = "gem";
      sha256 = "07pz570glwg87zpyagxxal0daa1jrnjkiksnn410s6846884fk8h";
    };
    dependencies = [
      "diff-lcs"
      "rspec-support"
    ];
  };
  "rspec-mocks" = {
    version = "3.4.0";
    source = {
      type = "gem";
      sha256 = "0iw9qvpawj3cfcg3xipi1v4y11g9q4f5lvmzgksn6f0chf97sjy1";
    };
    dependencies = [
      "diff-lcs"
      "rspec-support"
    ];
  };
  "rspec-support" = {
    version = "3.4.1";
    source = {
      type = "gem";
      sha256 = "0l6zzlf22hn3pcwnxswsjsiwhqjg7a8mhvm680k5vq98307bkikr";
    };
  };
  "ruby-progressbar" = {
    version = "1.7.5";
    source = {
      type = "gem";
      sha256 = "0hynaavnqzld17qdx9r7hfw00y16ybldwq730zrqfszjwgi59ivi";
    };
  };
  "simple_oauth" = {
    version = "0.2.0";
    source = {
      type = "gem";
      sha256 = "1vsjhxybif9r53jx4dhhwf80qjkg7gbwpfmskjqns223qrhwsxig";
    };
  };
  "thor" = {
    version = "0.18.1";
    source = {
      type = "gem";
      sha256 = "0d1g37j6sc7fkidf8rqlm3wh9zgyg3g7y8h2x1y34hmil5ywa8c3";
    };
  };
  "thread_safe" = {
    version = "0.1.3";
    source = {
      type = "gem";
      sha256 = "0f2w62x5nx95d2c2lrn9v4g60xhykf8zw7jaddkrgal913dzifgq";
    };
    dependencies = [
      "atomic"
    ];
  };
  "timecop" = {
    version = "0.8.0";
    source = {
      type = "gem";
      sha256 = "0zf46hkd36y2ywysjfgkvpcc5v04s2rwlg2k7k8j23bh7k8sgiqs";
    };
  };
  "treetop" = {
    version = "1.4.15";
    source = {
      type = "gem";
      sha256 = "1zqj5y0mvfvyz11nhsb4d5ch0i0rfcyj64qx19mw4qhg3hh8z9pz";
    };
    dependencies = [
      "polyglot"
      "polyglot"
    ];
  };
  "twitter" = {
    version = "5.5.0";
    source = {
      type = "gem";
      sha256 = "0yl1im3s4svl4hxxsyc60mm7cxvwz538amc9y0vzw6lkiii5f197";
    };
    dependencies = [
      "addressable"
      "buftok"
      "descendants_tracker"
      "equalizer"
      "faraday"
      "http"
      "http_parser.rb"
      "json"
      "memoizable"
      "simple_oauth"
    ];
  };
  "unf" = {
    version = "0.1.3";
    source = {
      type = "gem";
      sha256 = "1f2q8mxxngg8q608r6xajpharp9zz1ia3336y1lsg1asn2ach2sm";
    };
    dependencies = [
      "unf_ext"
    ];
  };
  "unf_ext" = {
    version = "0.0.6";
    source = {
      type = "gem";
      sha256 = "07zbmkzcid6pzdqgla3456ipfdka7j1v4hsx1iaa8rbnllqbmkdg";
    };
  };
  "xml-simple" = {
    version = "1.1.4";
    source = {
      type = "gem";
      sha256 = "0x5c3mqhahh8hzqqq41659bxj0wn3n6bhj5p6b4hsia2k4akzg6s";
    };
  };
}