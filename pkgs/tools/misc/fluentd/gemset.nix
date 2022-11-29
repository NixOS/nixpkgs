{
  addressable = {
    dependencies = ["public_suffix"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ypdmpdn20hxp5vwxz3zc04r5xcwqc25qszdlg41h8ghdqbllwmw";
      type = "gem";
    };
    version = "2.8.1";
  };
  aws-eventstream = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pyis1nvnbjxk12a43xvgj2gv0mvp4cnkc1gzw0v1018r61399gz";
      type = "gem";
    };
    version = "1.2.0";
  };
  aws-partitions = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15bw7jm2n7kxjz65amg9s837zlxsf98fn6wf6x20ngz1x4i8n0j6";
      type = "gem";
    };
    version = "1.661.0";
  };
  aws-sdk-cloudwatchlogs = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1iy8r65hwqlqaifhv7yxwapizrf02ch800xl90i9vg9293p5545w";
      type = "gem";
    };
    version = "1.56.0";
  };
  aws-sdk-core = {
    dependencies = ["aws-eventstream" "aws-partitions" "aws-sigv4" "jmespath"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "095nj7sf8914y60m1grnpy7cm6ybnw4ywnc0j84gz2vgv1m8awfk";
      type = "gem";
    };
    version = "3.167.0";
  };
  aws-sdk-firehose = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vhrld6gpa8idw51qfpvy2d624jbwmvickpfr8bnb4a5b06im80a";
      type = "gem";
    };
    version = "1.49.0";
  };
  aws-sdk-kinesis = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0n6jdkcyh9cm4f15zmmgpzwxbal5dg2w17xcm65d1gf9dwajsjda";
      type = "gem";
    };
    version = "1.42.0";
  };
  aws-sdk-kms = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lq1f03gy02f8z5fpc61kngkja8kkgk2m8cc6g42aij0iszjw03c";
      type = "gem";
    };
    version = "1.59.0";
  };
  aws-sdk-s3 = {
    dependencies = ["aws-sdk-core" "aws-sdk-kms" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17ah9j82313ynb8nkcbq21fa3dy1a3v6lk5kdrhphazbpb2xmxkn";
      type = "gem";
    };
    version = "1.117.1";
  };
  aws-sdk-sqs = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jf878ncdkxz3z507pa2fl47h2a9yvi01cx2pg3camqmal1nd1x7";
      type = "gem";
    };
    version = "1.52.0";
  };
  aws-sigv4 = {
    dependencies = ["aws-eventstream"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11hkna2av47bl0yprgp8k4ya70rc3m2ib5w10fn0piplgkkmhz7m";
      type = "gem";
    };
    version = "1.5.2";
  };
  bson = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19vgs9rzzyvd7jfrzynjnc6518q0ffpfciyicfywbp77zl8nc9hk";
      type = "gem";
    };
    version = "4.15.0";
  };
  concurrent-ruby = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0s4fpn3mqiizpmpy2a24k4v365pv75y50292r8ajrv4i1p5b2k14";
      type = "gem";
    };
    version = "1.1.10";
  };
  "cool.io" = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dfq4h168wzvs9cvn2mm8648ynkl936pgjva2p8ik34p6d620537";
      type = "gem";
    };
    version = "1.7.1";
  };
  digest-crc = {
    dependencies = ["rake"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1czaak53w8n13y1fr0q23gp0fhklvxjac5n562qj3xk6sh5ad0x2";
      type = "gem";
    };
    version = "0.6.4";
  };
  elastic-transport = {
    dependencies = ["faraday" "multi_json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0w5l26fwyby8pjcyyap015q5lxc619j8ig6af5slbp9l2x7kjaby";
      type = "gem";
    };
    version = "8.1.0";
  };
  elasticsearch = {
    dependencies = ["elastic-transport" "elasticsearch-api"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19jbvm6rzm19vzd3d83icchs0l4qgh7kp3cfi4pd2lcfiy635qil";
      type = "gem";
    };
    version = "8.5.1";
  };
  elasticsearch-api = {
    dependencies = ["multi_json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00b6lhfs4r9jp3dkphly9qqyyrd7sx4s1186kcjf8zhsxyq0m310";
      type = "gem";
    };
    version = "8.5.1";
  };
  excon = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "094kbi32i56p08348b95amg9dz5c9prn5jywhkcghsd3d6kll981";
      type = "gem";
    };
    version = "0.94.0";
  };
  faraday = {
    dependencies = ["faraday-em_http" "faraday-em_synchrony" "faraday-excon" "faraday-httpclient" "faraday-multipart" "faraday-net_http" "faraday-net_http_persistent" "faraday-patron" "faraday-rack" "faraday-retry" "ruby2_keywords"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1d5ipsv069dhgv9zhxgj8pz4j52yhgvfm01aq881yz7qgjd7ilxp";
      type = "gem";
    };
    version = "1.10.2";
  };
  faraday-em_http = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12cnqpbak4vhikrh2cdn94assh3yxza8rq2p9w2j34bqg5q4qgbs";
      type = "gem";
    };
    version = "1.0.0";
  };
  faraday-em_synchrony = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vgrbhkp83sngv6k4mii9f2s9v5lmp693hylfxp2ssfc60fas3a6";
      type = "gem";
    };
    version = "1.0.0";
  };
  faraday-excon = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h09wkb0k0bhm6dqsd47ac601qiaah8qdzjh8gvxfd376x1chmdh";
      type = "gem";
    };
    version = "1.1.0";
  };
  faraday-httpclient = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fyk0jd3ks7fdn8nv3spnwjpzx2lmxmg2gh4inz3by1zjzqg33sc";
      type = "gem";
    };
    version = "1.0.1";
  };
  faraday-multipart = {
    dependencies = ["multipart-post"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09871c4hd7s5ws1wl4gs7js1k2wlby6v947m2bbzg43pnld044lh";
      type = "gem";
    };
    version = "1.0.4";
  };
  faraday-net_http = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fi8sda5hc54v1w3mqfl5yz09nhx35kglyx72w7b8xxvdr0cwi9j";
      type = "gem";
    };
    version = "1.0.1";
  };
  faraday-net_http_persistent = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dc36ih95qw3rlccffcb0vgxjhmipsvxhn6cw71l7ffs0f7vq30b";
      type = "gem";
    };
    version = "1.2.0";
  };
  faraday-patron = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19wgsgfq0xkski1g7m96snv39la3zxz6x7nbdgiwhg5v82rxfb6w";
      type = "gem";
    };
    version = "1.0.0";
  };
  faraday-rack = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1h184g4vqql5jv9s9im6igy00jp6mrah2h14py6mpf9bkabfqq7g";
      type = "gem";
    };
    version = "1.0.0";
  };
  faraday-retry = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "153i967yrwnswqgvnnajgwp981k9p50ys1h80yz3q94rygs59ldd";
      type = "gem";
    };
    version = "1.0.3";
  };
  fluent-config-regexp-type = {
    dependencies = ["fluentd"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hk0vxcmlbid7n6piyv3x83j5gyiz7in397l9x3c6nh69wicy7gm";
      type = "gem";
    };
    version = "1.0.0";
  };
  fluent-plugin-cloudwatch-logs = {
    dependencies = ["aws-sdk-cloudwatchlogs" "fluentd"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "139d7qv4my818mhjp0104ns9dlndlvrb6dgxa2rkv6jlzlamjpjb";
      type = "gem";
    };
    version = "0.14.3";
  };
  fluent-plugin-elasticsearch = {
    dependencies = ["elasticsearch" "excon" "faraday" "fluentd"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "136nsmi15vcn0var59j1vqkysvmcp7y8fva25gkcx3hx1l92bxwh";
      type = "gem";
    };
    version = "5.2.4";
  };
  fluent-plugin-kafka = {
    dependencies = ["fluentd" "ltsv" "ruby-kafka"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ggiq89brahyamnw4sn4pmfqsw8xjz2k9k9hajsjlzkm9djppdwf";
      type = "gem";
    };
    version = "0.18.1";
  };
  fluent-plugin-kinesis = {
    dependencies = ["aws-sdk-firehose" "aws-sdk-kinesis" "fluentd" "google-protobuf"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07n5pzfz143hlvbzbx5rczb33ai9kdp48vhdak100m6xpaqkvc2p";
      type = "gem";
    };
    version = "3.4.2";
  };
  fluent-plugin-mongo = {
    dependencies = ["fluentd" "mongo"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1m3fa6fwpzxw08lnczsif5c7v33yryyvgb1lbp7a7qjhipvb6jfm";
      type = "gem";
    };
    version = "1.6.0";
  };
  fluent-plugin-record-reformer = {
    dependencies = ["fluentd"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gwfrfyi9is4l9q4ih3c4l3c9qvyh00jnd2qajdpdh5xjj2m7akn";
      type = "gem";
    };
    version = "0.9.1";
  };
  fluent-plugin-rewrite-tag-filter = {
    dependencies = ["fluent-config-regexp-type" "fluentd"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vjvn8ph87cl2dl0dbaap69rciglsdma1y5ghn2vm5mvh5h7xbs6";
      type = "gem";
    };
    version = "2.4.0";
  };
  fluent-plugin-s3 = {
    dependencies = ["aws-sdk-s3" "aws-sdk-sqs" "fluentd"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04yvxhynjqm35dycrxqwfw9r7mv6ycyda1wvki27z5hpsdy57b1m";
      type = "gem";
    };
    version = "1.7.2";
  };
  fluent-plugin-webhdfs = {
    dependencies = ["fluentd" "webhdfs"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1llpsbd5n2lgxbq16px5hbp3zfw65bdp46b08v87b6rmn3h47aiv";
      type = "gem";
    };
    version = "1.5.0";
  };
  fluentd = {
    dependencies = ["cool.io" "http_parser.rb" "msgpack" "serverengine" "sigdump" "strptime" "tzinfo" "tzinfo-data" "webrick" "yajl-ruby"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jn1i14zaw2pf4j6i7g7cj0h8j94wrcbn0an8w44h7g5mazl98nn";
      type = "gem";
    };
    version = "1.15.3";
  };
  google-protobuf = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p4aa5nnkkrdd3v3i57092vj2agj7ih3zavymw451j52k8anqras";
      type = "gem";
    };
    version = "3.21.9";
  };
  "http_parser.rb" = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gj4fmls0mf52dlr928gaq0c0cb0m3aqa9kaa6l0ikl2zbqk42as";
      type = "gem";
    };
    version = "0.8.0";
  };
  jmespath = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mnvb80cdg7fzdcs3xscv21p28w4igk5sj5m7m81xp8v2ks87jj0";
      type = "gem";
    };
    version = "1.6.1";
  };
  ltsv = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wrjvc5079zhpn62k1yflrf7js6vaysrg1qwggf7bj2zi0p5rhys";
      type = "gem";
    };
    version = "0.1.2";
  };
  mongo = {
    dependencies = ["bson"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16dzacmhz4g4n4kmw9qfg7hjh4xj71rzb7nd7n8vl1788x9h3sp5";
      type = "gem";
    };
    version = "2.18.1";
  };
  msgpack = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1q03pb0vq8388s431nbxabsfxnch6p304c8vnjlk0zzpcv713yr3";
      type = "gem";
    };
    version = "1.6.0";
  };
  multi_json = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pb1g1y3dsiahavspyzkdy39j4q377009f6ix0bh1ag4nqw43l0z";
      type = "gem";
    };
    version = "1.15.0";
  };
  multipart-post = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1n0kvnrcrjn31jb97kcx3wj1f5kkjza7yygfq8rxzf3i57g7jaa6";
      type = "gem";
    };
    version = "2.2.3";
  };
  public_suffix = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sqw1zls6227bgq38sxb2hs8nkdz4hn1zivs27mjbniswfy4zvi6";
      type = "gem";
    };
    version = "5.0.0";
  };
  rake = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15whn7p9nrkxangbs9hh75q585yfn66lv0v2mhj6q6dl6x8bzr2w";
      type = "gem";
    };
    version = "13.0.6";
  };
  ruby-kafka = {
    dependencies = ["digest-crc"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13i3fvjy0n1n1aa71b30nwx2xchhsps3yhi17r0s6ay7wr26jr7p";
      type = "gem";
    };
    version = "1.5.0";
  };
  ruby2_keywords = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vz322p8n39hz3b4a9gkmz9y7a5jaz41zrm2ywf31dvkqm03glgz";
      type = "gem";
    };
    version = "0.0.5";
  };
  serverengine = {
    dependencies = ["sigdump"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1snxfmkmmxpdica8629gdl6qj3xradcx787ccvhfa90gh8wyfqqj";
      type = "gem";
    };
    version = "2.3.0";
  };
  sigdump = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mqf06iw7rymv54y7rgbmfi6ppddgjjmxzi3hrw658n1amp1gwhb";
      type = "gem";
    };
    version = "0.2.4";
  };
  strptime = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ycs0xz58kymf7yp4h56f0nid2z7g3s18dj7pa3p790pfzzpgvcq";
      type = "gem";
    };
    version = "0.2.5";
  };
  tzinfo = {
    dependencies = ["concurrent-ruby"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rx114mpqnw2k4h98vc0rs0x0bmf0img84yh8mkkjkal07cjydf5";
      type = "gem";
    };
    version = "2.0.5";
  };
  tzinfo-data = {
    dependencies = ["tzinfo"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dpwi70x9jrpvc7p103ci0kppam79wqqrskq9n39r3jrp4b4j27w";
      type = "gem";
    };
    version = "1.2022.6";
  };
  webhdfs = {
    dependencies = ["addressable"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pkdsj8ybjfp1sr7gzdxd7van5fpmhc9v2c5g3hifdx4s4yzhcq7";
      type = "gem";
    };
    version = "0.10.2";
  };
  webrick = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1d4cvgmxhfczxiq5fr534lmizkhigd15bsx5719r5ds7k7ivisc7";
      type = "gem";
    };
    version = "1.7.0";
  };
  yajl-ruby = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lni4jbyrlph7sz8y49q84pb0sbj82lgwvnjnsiv01xf26f4v5wc";
      type = "gem";
    };
    version = "1.4.3";
  };
}
