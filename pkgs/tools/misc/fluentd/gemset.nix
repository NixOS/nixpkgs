{
  "cool.io" = {
    version = "1.3.0";
    source = {
      type = "gem";
      sha256 = "1s3x0a32gbr6sg4lb0yk5irh48z4260my6g5ssifyl54rh4b6lzh";
    };
  };
  "elasticsearch" = {
    version = "1.0.8";
    source = {
      type = "gem";
      sha256 = "0kfiza9p98gchqgd0a64ryw77wgy42b7hhy89ba1s2jy2kcm3ahl";
    };
    dependencies = [
      "elasticsearch-api"
      "elasticsearch-transport"
    ];
  };
  "elasticsearch-api" = {
    version = "1.0.7";
    source = {
      type = "gem";
      sha256 = "0fb7pmzhfl48zxkbx3ayc61x1gv3qvvs4xcp4yf1rxflz1iw6ck9";
    };
    dependencies = [
      "multi_json"
    ];
  };
  "elasticsearch-transport" = {
    version = "1.0.7";
    source = {
      type = "gem";
      sha256 = "0p5yzbvgpw84asfj8ifbqckw6qbssc6xrw086qfh58kxpfnin0zc";
    };
    dependencies = [
      "faraday"
      "multi_json"
    ];
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
  "fluent-plugin-elasticsearch" = {
    version = "0.7.0";
    source = {
      type = "gem";
      sha256 = "1jav4lqf9j3w014ksgl3zr05kg62lkc58xnhjjriqp3c1412vwpy";
    };
    dependencies = [
      "elasticsearch"
      "fluentd"
      "patron"
    ];
  };
  "fluent-plugin-record-reformer" = {
    version = "0.6.0";
    source = {
      type = "gem";
      sha256 = "1h43xx7dypbrhdw22c28jsp3054g4imic2wd12rl5nf1k85phfkk";
    };
    dependencies = [
      "fluentd"
    ];
  };
  "fluentd" = {
    version = "0.12.6";
    source = {
      type = "gem";
      sha256 = "04lrr133ci6m3j85cj2rhhjkw3b1r12fxcymk943lsdlrip0brr1";
    };
    dependencies = [
      "cool.io"
      "http_parser.rb"
      "json"
      "msgpack"
      "sigdump"
      "string-scrub"
      "tzinfo"
      "tzinfo-data"
      "yajl-ruby"
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
  "msgpack" = {
    version = "0.5.11";
    source = {
      type = "gem";
      sha256 = "1jmi0i3j8xfvidx6ivbcbdwpyf54r0d7dc4rrq1jbvhd1ffvr79w";
    };
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
  "patron" = {
    version = "0.4.20";
    source = {
      type = "gem";
      sha256 = "0wdgjazzyllnajkzgdh55q60mlczq8h5jhwpzisrj2i8izrq45zb";
    };
  };
  "sigdump" = {
    version = "0.2.2";
    source = {
      type = "gem";
      sha256 = "1h4d4vfg1g3wbbmqahmk7khzhswk5mjv4hwbs7bhmp808h8mz973";
    };
  };
  "string-scrub" = {
    version = "0.0.5";
    source = {
      type = "gem";
      sha256 = "0fy4qby2az268qzmf00mb3p0hiqgshz9g6kvgl5vg76y90hl178g";
    };
  };
  "thread_safe" = {
    version = "0.3.5";
    source = {
      type = "gem";
      sha256 = "1hq46wqsyylx5afkp6jmcihdpv4ynzzq9ygb6z2pb1cbz5js0gcr";
    };
  };
  "tzinfo" = {
    version = "1.2.2";
    source = {
      type = "gem";
      sha256 = "1c01p3kg6xvy1cgjnzdfq45fggbwish8krd0h864jvbpybyx7cgx";
    };
    dependencies = [
      "thread_safe"
    ];
  };
  "tzinfo-data" = {
    version = "1.2015.1";
    source = {
      type = "gem";
      sha256 = "1x6fa8ayd2kal397d5gdsdg0fjqynfqv1n9n0q702mq839dw593h";
    };
    dependencies = [
      "tzinfo"
    ];
  };
  "yajl-ruby" = {
    version = "1.2.1";
    source = {
      type = "gem";
      sha256 = "0zvvb7i1bl98k3zkdrnx9vasq0rp2cyy5n7p9804dqs4fz9xh9vf";
    };
  };
}