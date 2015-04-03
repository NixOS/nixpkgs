{
  "amq-protocol" = {
    version = "1.9.2";
    source = {
      type = "gem";
      sha256 = "1gl479j003vixfph5jmdskl20il8816y0flp4msrc8im3b5iiq3r";
    };
  };
  "amqp" = {
    version = "1.5.0";
    source = {
      type = "gem";
      sha256 = "0jlcwyvjz0b28wxdabkyhdqyqp5ji56ckfywsy9mgp0m4wfbrh8c";
    };
    dependencies = [
      "amq-protocol"
      "eventmachine"
    ];
  };
  "async_sinatra" = {
    version = "1.0.0";
    source = {
      type = "gem";
      sha256 = "02yi9qfsi8kk4a4p1c4sx4pgism05m18kwlc9dd23zzdy9jdgq1a";
    };
    dependencies = [
      "rack"
      "sinatra"
    ];
  };
  "childprocess" = {
    version = "0.5.3";
    source = {
      type = "gem";
      sha256 = "12djpdr487fddq55sav8gw1pjglcbb0ab0s6npga0ywgsqdyvsww";
    };
    dependencies = [
      "ffi"
    ];
  };
  "daemons" = {
    version = "1.2.2";
    source = {
      type = "gem";
      sha256 = "121c7vkimg3baxga69xvdkwxiq8wkmxqvdbyqi5i82vhih5d3cn3";
    };
  };
  "em-redis-unified" = {
    version = "0.6.0";
    source = {
      type = "gem";
      sha256 = "1hf7dv6qmxfilpd7crcqlyqk6jp5z8md76bpg3n0163ps4ra73p0";
    };
    dependencies = [
      "eventmachine"
    ];
  };
  "em-worker" = {
    version = "0.0.2";
    source = {
      type = "gem";
      sha256 = "0z4jx9z2q5hxvdvik4yp0ahwfk69qsmdnyp72ln22p3qlkq2z5wk";
    };
    dependencies = [
      "eventmachine"
    ];
  };
  "eventmachine" = {
    version = "1.0.3";
    source = {
      type = "gem";
      sha256 = "09sqlsb6x9ddlgfw5gsw7z0yjg5m2qfjiqkz2fx70zsizj3lqhil";
    };
  };
  "ffi" = {
    version = "1.9.8";
    source = {
      type = "gem";
      sha256 = "0ph098bv92rn5wl6rn2hwb4ng24v4187sz8pa0bpi9jfh50im879";
    };
  };
  "multi_json" = {
    version = "1.11.0";
    source = {
      type = "gem";
      sha256 = "1mg3hp17ch8bkf3ndj40s50yjs0vrqbfh3aq5r02jkpjkh23wgxl";
    };
  };
  "rack" = {
    version = "1.6.0";
    source = {
      type = "gem";
      sha256 = "1f57f8xmrgfgd76s6mq7vx6i266zm4330igw71an1g0kh3a42sbb";
    };
  };
  "rack-protection" = {
    version = "1.5.3";
    source = {
      type = "gem";
      sha256 = "0cvb21zz7p9wy23wdav63z5qzfn4nialik22yqp6gihkgfqqrh5r";
    };
    dependencies = [
      "rack"
    ];
  };
  "sensu" = {
    version = "0.17.1";
    source = {
      type = "gem";
      sha256 = "1fqpypins1zhind0in0ax0y97a6pf3z85gwjz4bjm6cjrkarb5zj";
    };
    dependencies = [
      "async_sinatra"
      "em-redis-unified"
      "eventmachine"
      "multi_json"
      "sensu-em"
      "sensu-extension"
      "sensu-extensions"
      "sensu-logger"
      "sensu-settings"
      "sensu-spawn"
      "sensu-transport"
      "sinatra"
      "thin"
      "uuidtools"
    ];
  };
  "sensu-em" = {
    version = "2.4.1";
    source = {
      type = "gem";
      sha256 = "08jz47lfnv55c9yl2dhyv1si6zl8h4xj8y1sjy2h2fqy48prfgmy";
    };
  };
  "sensu-extension" = {
    version = "1.1.2";
    source = {
      type = "gem";
      sha256 = "19qz22fcb3xjz9p5npghlcvxkf8h1rsfws3j988ybnimmmmiqm24";
    };
    dependencies = [
      "sensu-em"
    ];
  };
  "sensu-extensions" = {
    version = "1.2.0";
    source = {
      type = "gem";
      sha256 = "1b8978g1ww7vdrsw7zvba6qvc56s4vfm1hw3szw3j1gsk6j0vb81";
    };
    dependencies = [
      "multi_json"
      "sensu-em"
      "sensu-extension"
      "sensu-logger"
      "sensu-settings"
    ];
  };
  "sensu-logger" = {
    version = "1.0.0";
    source = {
      type = "gem";
      sha256 = "0vwa2b5wa9xqzb9lmhma49171iabwbnnnyhhhaii8n6j4axvar93";
    };
    dependencies = [
      "multi_json"
      "sensu-em"
    ];
  };
  "sensu-settings" = {
    version = "1.3.0";
    source = {
      type = "gem";
      sha256 = "0s9fyqhq5vf9m9937n3wczlr4z62rn1ydc6m53vn4156fpim6yga";
    };
    dependencies = [
      "multi_json"
    ];
  };
  "sensu-spawn" = {
    version = "1.1.0";
    source = {
      type = "gem";
      sha256 = "0w9z6hpr27lq02y6c2mnrdl9xpsjfg77kzsfsp2f2w4swdwmiv0v";
    };
    dependencies = [
      "childprocess"
      "em-worker"
      "sensu-em"
    ];
  };
  "sensu-transport" = {
    version = "2.4.0";
    source = {
      type = "gem";
      sha256 = "0gh8rcl22daax7qng93kj2jydql1jhhskd37kj7sgz0rr8wy2x06";
    };
    dependencies = [
      "amqp"
      "sensu-em"
    ];
  };
  "sinatra" = {
    version = "1.3.5";
    source = {
      type = "gem";
      sha256 = "1mn6nzfyirfqr7prhsn4nr3k481c6nzsad2p9s1xnsbvxa1vkqwr";
    };
    dependencies = [
      "rack"
      "rack-protection"
      "tilt"
    ];
  };
  "thin" = {
    version = "1.5.0";
    source = {
      type = "gem";
      sha256 = "14sd2qbbk6y108z6v723mh3f1mk8s4fwxmmn9f8dk4xkhk4rwvq1";
    };
    dependencies = [
      "daemons"
      "eventmachine"
      "rack"
    ];
  };
  "tilt" = {
    version = "1.4.1";
    source = {
      type = "gem";
      sha256 = "00sr3yy7sbqaq7cb2d2kpycajxqf1b1wr1yy33z4bnzmqii0b0ir";
    };
  };
  "uuidtools" = {
    version = "2.1.4";
    source = {
      type = "gem";
      sha256 = "1w0bhnkp5515f3yx5fakfrfkawxjpb4fjm1r2c6lk691xlr696s3";
    };
  };
}