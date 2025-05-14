{
  addressable = {
    dependencies = [ "public_suffix" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0cl2qpvwiffym62z991ynks7imsm87qmgxf0yfsmlwzkgi9qcaa6";
      type = "gem";
    };
    version = "2.8.7";
  };
  aws-eventstream = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1mvjjn8vh1c3nhibmjj9qcwxagj6m9yy961wblfqdmvhr9aklb3y";
      type = "gem";
    };
    version = "1.3.2";
  };
  aws-partitions = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jdajznsdc0niv68xqp9sv29l9piyn32grq1y367l14hbm17mnf2";
      type = "gem";
    };
    version = "1.1064.0";
  };
  aws-sdk-cloudwatchlogs = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1izd0al8i8wmi0cx18w4y8nriw623c21rb7c8vwpgk4mzd2kqxhw";
      type = "gem";
    };
    version = "1.109.0";
  };
  aws-sdk-core = {
    dependencies = [
      "aws-eventstream"
      "aws-partitions"
      "aws-sigv4"
      "base64"
      "jmespath"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0cjdqmy5hjbgzc0iac1i143va76qgp7jc7hg1aviy1n8cgywq44y";
      type = "gem";
    };
    version = "3.220.1";
  };
  aws-sdk-firehose = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1sryh7fjg525ddwlbd37mi3ygjcc6qn9r0md64d6ssrvk2ah0v1i";
      type = "gem";
    };
    version = "1.89.0";
  };
  aws-sdk-kinesis = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qfwsc373a674y8xcy8g1ykc84d21vbz0dqpbh1f1k2mny2cxz7s";
      type = "gem";
    };
    version = "1.74.0";
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
      sha256 = "1a3mh89kfh6flqxw48wfv9wfwkj2zxazw096mqm56wnnzz1jyads";
      type = "gem";
    };
    version = "1.99.0";
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
      sha256 = "03a55dbihv6xvgfwhx0f35rwc7q3rr0555vfpxlwpdjw75wkbz6h";
      type = "gem";
    };
    version = "1.182.0";
  };
  aws-sdk-sqs = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "16b5jdnmk93l86nnqpij4zac7srx8c2yvx07xxbazmkawcnrd27g";
      type = "gem";
    };
    version = "1.93.0";
  };
  aws-sigv4 = {
    dependencies = [ "aws-eventstream" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1nx1il781qg58nwjkkdn9fw741cjjnixfsh389234qm8j5lpka2h";
      type = "gem";
    };
    version = "1.11.0";
  };
  base64 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "01qml0yilb9basf7is2614skjp8384h2pycfx86cr8023arfj98g";
      type = "gem";
    };
    version = "0.2.0";
  };
  bson = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "19vgs9rzzyvd7jfrzynjnc6518q0ffpfciyicfywbp77zl8nc9hk";
      type = "gem";
    };
    version = "4.15.0";
  };
  concurrent-ruby = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ipbrgvf0pp6zxdk5ascp6i29aybz2bx9wdrlchjmpx6mhvkwfw1";
      type = "gem";
    };
    version = "1.3.5";
  };
  "cool.io" = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0cl3ri6zsnpm3hixmlkrmyjir1w7m9szjfizwvccn05qb40a4apa";
      type = "gem";
    };
    version = "1.9.0";
  };
  csv = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0kmx36jjh2sahd989vcvw74lrlv07dqc3rnxchc5sj2ywqsw3w3g";
      type = "gem";
    };
    version = "3.3.2";
  };
  digest-crc = {
    dependencies = [ "rake" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "01wcsyhaadss4zzvqh12kvbq3hmkl5y4fck7pr608hd24qxc5bb4";
      type = "gem";
    };
    version = "0.7.0";
  };
  drb = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0h5kbj9hvg5hb3c7l425zpds0vb42phvln2knab8nmazg2zp5m79";
      type = "gem";
    };
    version = "2.2.1";
  };
  elastic-transport = {
    dependencies = [
      "faraday"
      "multi_json"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xz5q3zlbkwdb9zipallvqxdw6gnz8ljyz4w7b3pv1lar43f9sdm";
      type = "gem";
    };
    version = "8.4.0";
  };
  elasticsearch = {
    dependencies = [
      "elastic-transport"
      "elasticsearch-api"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1nbwd1f5s060hiqcs2bmwzvsli3l3vcyyd3khxcxzzxvysqq0zb9";
      type = "gem";
    };
    version = "8.17.1";
  };
  elasticsearch-api = {
    dependencies = [ "multi_json" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1iwl70xid303nyhfv5342yj5kk37rjbgdzkjdi83fnvyhisi5166";
      type = "gem";
    };
    version = "8.17.1";
  };
  excon = {
    dependencies = [ "logger" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "17asr18vawi08g3wbif0wdi8bnyj01d125saydl9j1f03fv0n16a";
      type = "gem";
    };
    version = "1.2.5";
  };
  faraday = {
    dependencies = [
      "faraday-net_http"
      "json"
      "logger"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1mls9g490k63rdmjc9shqshqzznfn1y21wawkxrwp2vvbk13jwqm";
      type = "gem";
    };
    version = "2.12.2";
  };
  faraday-excon = {
    dependencies = [
      "excon"
      "faraday"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xdmwnkkms7bnx0bpkdk52qcazjqa3skb7jmjr21cjr8mdsp3z65";
      type = "gem";
    };
    version = "2.3.0";
  };
  faraday-net_http = {
    dependencies = [ "net-http" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jp5ci6g40d6i50bsywp35l97nc2fpi9a592r2cibwicdb6y9wd1";
      type = "gem";
    };
    version = "3.4.0";
  };
  fluent-config-regexp-type = {
    dependencies = [ "fluentd" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0hk0vxcmlbid7n6piyv3x83j5gyiz7in397l9x3c6nh69wicy7gm";
      type = "gem";
    };
    version = "1.0.0";
  };
  fluent-plugin-cloudwatch-logs = {
    dependencies = [
      "aws-sdk-cloudwatchlogs"
      "fluentd"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "139d7qv4my818mhjp0104ns9dlndlvrb6dgxa2rkv6jlzlamjpjb";
      type = "gem";
    };
    version = "0.14.3";
  };
  fluent-plugin-concat = {
    dependencies = [ "fluentd" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1b9z6hrjcsvccfimmgczzcbhvf2zwyqzvsdc29i2biqhk1mcwn3k";
      type = "gem";
    };
    version = "2.5.0";
  };
  fluent-plugin-elasticsearch = {
    dependencies = [
      "elasticsearch"
      "excon"
      "faraday"
      "faraday-excon"
      "fluentd"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "19psa92z4zsmbwz8n4rizkwws58qlgb30325rhmqpnsp9h8b0cbb";
      type = "gem";
    };
    version = "5.4.3";
  };
  fluent-plugin-kafka = {
    dependencies = [
      "fluentd"
      "ltsv"
      "ruby-kafka"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0p3z1z22ir442rrxv8f8ki50iv6hmx7q5zm0lglyfh6nmkpf6vv1";
      type = "gem";
    };
    version = "0.19.3";
  };
  fluent-plugin-kinesis = {
    dependencies = [
      "aws-sdk-firehose"
      "aws-sdk-kinesis"
      "fluentd"
      "google-protobuf"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "12wx84a9h1xjldxa3yxxsmkyn620m2knw47dmfnr9rvgw2s4dlrz";
      type = "gem";
    };
    version = "3.5.0";
  };
  fluent-plugin-mongo = {
    dependencies = [
      "fluentd"
      "mongo"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1m3fa6fwpzxw08lnczsif5c7v33yryyvgb1lbp7a7qjhipvb6jfm";
      type = "gem";
    };
    version = "1.6.0";
  };
  fluent-plugin-record-reformer = {
    dependencies = [ "fluentd" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1gwfrfyi9is4l9q4ih3c4l3c9qvyh00jnd2qajdpdh5xjj2m7akn";
      type = "gem";
    };
    version = "0.9.1";
  };
  fluent-plugin-rewrite-tag-filter = {
    dependencies = [
      "fluent-config-regexp-type"
      "fluentd"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vjvn8ph87cl2dl0dbaap69rciglsdma1y5ghn2vm5mvh5h7xbs6";
      type = "gem";
    };
    version = "2.4.0";
  };
  fluent-plugin-s3 = {
    dependencies = [
      "aws-sdk-s3"
      "aws-sdk-sqs"
      "fluentd"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0c7l7y51j5fz99086ghj99rjv16frj5kl4wcclvfws1jc5c38mj9";
      type = "gem";
    };
    version = "1.8.3";
  };
  fluent-plugin-webhdfs = {
    dependencies = [
      "fluentd"
      "webhdfs"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1mqj7fk1ylydkrjrph2n15n6bcn1vpgnjh4z2svxi2qsc5rnaki3";
      type = "gem";
    };
    version = "1.6.0";
  };
  fluentd = {
    dependencies = [
      "base64"
      "cool.io"
      "csv"
      "drb"
      "http_parser.rb"
      "logger"
      "msgpack"
      "serverengine"
      "sigdump"
      "strptime"
      "tzinfo"
      "tzinfo-data"
      "webrick"
      "yajl-ruby"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "100fd0ihgpqddkdqmbvlp51v09rnr4xb25l5lq776ai21hc4gj8d";
      type = "gem";
    };
    version = "1.18.0";
  };
  google-protobuf = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0g0h7rwiivx93jddfws5pdkcpnhma3694k2jfv2i1k80qkrqnrmv";
      type = "gem";
    };
    version = "3.25.6";
  };
  "http_parser.rb" = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1gj4fmls0mf52dlr928gaq0c0cb0m3aqa9kaa6l0ikl2zbqk42as";
      type = "gem";
    };
    version = "0.8.0";
  };
  jmespath = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1cdw9vw2qly7q7r41s7phnac264rbsdqgj4l0h4nqgbjb157g393";
      type = "gem";
    };
    version = "1.6.2";
  };
  json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1p4l5ycdxfsr8b51gnvlvhq6s21vmx9z4x617003zbqv3bcqmj6x";
      type = "gem";
    };
    version = "2.10.1";
  };
  logger = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "05s008w9vy7is3njblmavrbdzyrwwc1fsziffdr58w9pwqj8sqfx";
      type = "gem";
    };
    version = "1.6.6";
  };
  ltsv = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0wrjvc5079zhpn62k1yflrf7js6vaysrg1qwggf7bj2zi0p5rhys";
      type = "gem";
    };
    version = "0.1.2";
  };
  mongo = {
    dependencies = [ "bson" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xinxrx25q9hzl78bhm404vlfgm04csbgkr7kkrw47s53l9mghhf";
      type = "gem";
    };
    version = "2.18.3";
  };
  msgpack = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0cnpnbn2yivj9gxkh8mjklbgnpx6nf7b8j2hky01dl0040hy0k76";
      type = "gem";
    };
    version = "1.8.0";
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
  net-http = {
    dependencies = [ "uri" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ysrwaabhf0sn24jrp0nnp51cdv0jf688mh5i6fsz63q2c6b48cn";
      type = "gem";
    };
    version = "0.6.0";
  };
  public_suffix = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0vqcw3iwby3yc6avs1vb3gfd0vcp2v7q310665dvxfswmcf4xm31";
      type = "gem";
    };
    version = "6.0.1";
  };
  rake = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "17850wcwkgi30p7yqh60960ypn7yibacjjha0av78zaxwvd3ijs6";
      type = "gem";
    };
    version = "13.2.1";
  };
  ruby-kafka = {
    dependencies = [ "digest-crc" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "13i3fvjy0n1n1aa71b30nwx2xchhsps3yhi17r0s6ay7wr26jr7p";
      type = "gem";
    };
    version = "1.5.0";
  };
  serverengine = {
    dependencies = [
      "base64"
      "logger"
      "sigdump"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1g26sbxwidgryn57nzxw25dq67ij037vml9ld28ckyl7y4qs8hja";
      type = "gem";
    };
    version = "2.4.0";
  };
  sigdump = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0hkj8fsl1swjfqvzgrwbyrwwn7403q95fficbll8nibhrqf6qw5v";
      type = "gem";
    };
    version = "0.2.5";
  };
  strptime = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ycs0xz58kymf7yp4h56f0nid2z7g3s18dj7pa3p790pfzzpgvcq";
      type = "gem";
    };
    version = "0.2.5";
  };
  tzinfo = {
    dependencies = [ "concurrent-ruby" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "16w2g84dzaf3z13gxyzlzbf748kylk5bdgg3n1ipvkvvqy685bwd";
      type = "gem";
    };
    version = "2.0.6";
  };
  tzinfo-data = {
    dependencies = [ "tzinfo" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "02yz3x0qxnnwbf7k18yck5pggbnyy43rq0d5w2r6rwlk3981m31d";
      type = "gem";
    };
    version = "1.2025.1";
  };
  uri = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "04bhfvc25b07jaiaf62yrach7khhr5jlr5bx6nygg8pf11329wp9";
      type = "gem";
    };
    version = "1.0.3";
  };
  webhdfs = {
    dependencies = [ "addressable" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "157b725w4795i4bk2318fbj4bg1r83kvnmnbjykgzypi94mfhc6i";
      type = "gem";
    };
    version = "0.11.0";
  };
  webrick = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "12d9n8hll67j737ym2zw4v23cn4vxyfkb6vyv1rzpwv6y6a3qbdl";
      type = "gem";
    };
    version = "1.9.1";
  };
  yajl-ruby = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1lni4jbyrlph7sz8y49q84pb0sbj82lgwvnjnsiv01xf26f4v5wc";
      type = "gem";
    };
    version = "1.4.3";
  };
}
