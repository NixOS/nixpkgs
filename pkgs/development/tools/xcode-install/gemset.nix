{
  addressable = {
    dependencies = ["public_suffix"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fvchp2rhp2rmigx7qglf69xvjqvzq7x0g49naliw29r2bz656sy";
      type = "gem";
    };
    version = "2.7.0";
  };
  artifactory = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wify8rhjwr5bw5y6ary61vba290vk766cxw9a9mg05yswmaisls";
      type = "gem";
    };
    version = "3.0.15";
  };
  atomos = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17vq6sjyswr5jfzwdccw748kgph6bdw30bakwnn6p8sl4hpv4hvx";
      type = "gem";
    };
    version = "0.1.3";
  };
  aws-eventstream = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0r0pn66yqrdkrfdin7qdim0yj2x75miyg4wp6mijckhzhrjb7cv5";
      type = "gem";
    };
    version = "1.1.0";
  };
  aws-partitions = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vz0djj8w3ns0sz5gvkla5jml8xzx6skbcfj255m81fyww1x6ws8";
      type = "gem";
    };
    version = "1.419.0";
  };
  aws-sdk-core = {
    dependencies = ["aws-eventstream" "aws-partitions" "aws-sigv4" "jmespath"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bfj1cnpp0ljr9jc44kljdwl5399cbqlvlqkz6fxq5i4r6ckggi4";
      type = "gem";
    };
    version = "3.111.2";
  };
  aws-sdk-kms = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02f70a4rr5h2na7navjhaf3n15ifq95zdl1avsryyxdvqzm5gzwm";
      type = "gem";
    };
    version = "1.41.0";
  };
  aws-sdk-s3 = {
    dependencies = ["aws-sdk-core" "aws-sdk-kms" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0capqhvm08ngq74n33ym0khixkdj342jpikssw57avdmd8g6kaq7";
      type = "gem";
    };
    version = "1.87.0";
  };
  aws-sigv4 = {
    dependencies = ["aws-eventstream"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ll9382c1x2hp750cilh01h1cycgyhdr4cmmgx23k94hyyb8chv5";
      type = "gem";
    };
    version = "1.2.2";
  };
  babosa = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16dwqn33kmxkqkv51cwiikdkbrdjfsymlnc0rgbjwilmym8a9phq";
      type = "gem";
    };
    version = "1.0.4";
  };
  CFPropertyList = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ia09r8bj3bjhcfiyr3vlk9zx7vahfypbs2lyrxix9x1jx3lfzq4";
      type = "gem";
    };
    version = "3.0.3";
  };
  claide = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kasxsms24fgcdsq680nz99d5lazl9rmz1qkil2y5gbbssx89g0z";
      type = "gem";
    };
    version = "1.0.3";
  };
  colored = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0b0x5jmsyi0z69bm6sij1k89z7h0laag3cb4mdn7zkl9qmxb90lx";
      type = "gem";
    };
    version = "1.2";
  };
  colored2 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jlbqa9q4mvrm73aw9mxh23ygzbjiqwisl32d8szfb5fxvbjng5i";
      type = "gem";
    };
    version = "3.1.2";
  };
  commander-fastlane = {
    dependencies = ["highline"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0y8d3ac9qwm1cg6rnpf8rcdsy1yxacrd2g2kl809xsp2vi973g65";
      type = "gem";
    };
    version = "4.4.6";
  };
  declarative = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yczgnqrbls7shrg63y88g7wand2yp9h6sf56c9bdcksn5nds8c0";
      type = "gem";
    };
    version = "0.0.20";
  };
  declarative-option = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g4ibxq566f1frnhdymzi9hxxcm4g2gw4n21mpjk2mhwym4q6l0p";
      type = "gem";
    };
    version = "0.1.0";
  };
  digest-crc = {
    dependencies = ["rake"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "118d5p02kdw6a5pi8af12dxma7q3b77zz5q5xjjf5kgp8qh1930a";
      type = "gem";
    };
    version = "0.6.3";
  };
  domain_name = {
    dependencies = ["unf"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lcqjsmixjp52bnlgzh4lg9ppsk52x9hpwdjd53k8jnbah2602h0";
      type = "gem";
    };
    version = "0.5.20190701";
  };
  dotenv = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0iym172c5337sm1x2ykc2i3f961vj3wdclbyg1x6sxs3irgfsl94";
      type = "gem";
    };
    version = "2.7.6";
  };
  emoji_regex = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qbzlracxw4xwyvrgr0qcl1alk4ijk6pv53ni6f43csi649y3n3s";
      type = "gem";
    };
    version = "3.2.1";
  };
  excon = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16ij8617v3js03yj1zd32mmrf7kpi9l96bid5mpqk30c4mzai55r";
      type = "gem";
    };
    version = "0.78.1";
  };
  faraday = {
    dependencies = ["faraday-net_http" "multipart-post" "ruby2_keywords"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hmssd8pj4n7yq4kz834ylkla8ryyvhaap6q9nzymp93m1xq21kz";
      type = "gem";
    };
    version = "1.3.0";
  };
  faraday-cookie_jar = {
    dependencies = ["faraday" "http-cookie"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00hligx26w9wdnpgsrf0qdnqld4rdccy8ym6027h5m735mpvxjzk";
      type = "gem";
    };
    version = "0.0.7";
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
  faraday_middleware = {
    dependencies = ["faraday"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jik2kgfinwnfi6fpp512vlvs0mlggign3gkbpkg5fw1jr9his0r";
      type = "gem";
    };
    version = "1.0.0";
  };
  fastimage = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vqp53s9vgd28f4l17q0vs7xv32y64af0ny3wb1fgg4i534rzg6j";
      type = "gem";
    };
    version = "2.2.1";
  };
  fastlane = {
    dependencies = ["CFPropertyList" "addressable" "artifactory" "aws-sdk-s3" "babosa" "colored" "commander-fastlane" "dotenv" "emoji_regex" "excon" "faraday" "faraday-cookie_jar" "faraday_middleware" "fastimage" "gh_inspector" "google-api-client" "google-cloud-storage" "highline" "json" "jwt" "mini_magick" "multipart-post" "plist" "rubyzip" "security" "simctl" "slack-notifier" "terminal-notifier" "terminal-table" "tty-screen" "tty-spinner" "word_wrap" "xcodeproj" "xcpretty" "xcpretty-travis-formatter"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0crr42qdgy9l409pffpfs7nq8ha18lp1nxngny2dc9hiq1xx4r5d";
      type = "gem";
    };
    version = "2.172.0";
  };
  gh_inspector = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0f8r9byajj3bi2c7c5sqrc7m0zrv3nblfcd4782lw5l73cbsgk04";
      type = "gem";
    };
    version = "1.1.3";
  };
  google-api-client = {
    dependencies = ["addressable" "googleauth" "httpclient" "mini_mime" "representable" "retriable" "signet"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jybks8i00rxrxx9mkx90dbdk6pczh2w757wchlavmrkrk0dp9s1";
      type = "gem";
    };
    version = "0.38.0";
  };
  google-apis-core = {
    dependencies = ["addressable" "googleauth" "httpclient" "mini_mime" "representable" "retriable" "rexml" "signet" "webrick"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "184pqw7z7s8mc1r5gj8f76xvp8z650xq50vdfj5gjwsbmzd99z2f";
      type = "gem";
    };
    version = "0.2.1";
  };
  google-apis-iamcredentials_v1 = {
    dependencies = ["google-apis-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xjlzq2fxpwvp9b6ajs8cpyjv8vs2d2npg9v23yj181hj2fnn82c";
      type = "gem";
    };
    version = "0.1.0";
  };
  google-apis-storage_v1 = {
    dependencies = ["google-apis-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0axycds5q20fqm6vqxa5r922021p0f8jhwvlgw8r1vq600ljribi";
      type = "gem";
    };
    version = "0.1.0";
  };
  google-cloud-core = {
    dependencies = ["google-cloud-env" "google-cloud-errors"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qjn7vs8f85vxi1nkikbjfja6bv9snrj26vzscjii0cm8n4dy0i1";
      type = "gem";
    };
    version = "1.5.0";
  };
  google-cloud-env = {
    dependencies = ["faraday"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bjgxyvagy6hjj8yg7fqq24rwdjxb6hx7fdd1bmn4mwd846lci2i";
      type = "gem";
    };
    version = "1.4.0";
  };
  google-cloud-errors = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hvs1x39g77hbdqjxmzcl6gq8160pv3kskvzbbch0ww1np6qwm67";
      type = "gem";
    };
    version = "1.0.1";
  };
  google-cloud-storage = {
    dependencies = ["addressable" "digest-crc" "google-apis-iamcredentials_v1" "google-apis-storage_v1" "google-cloud-core" "googleauth" "mini_mime"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17axi5gmy0g04801v11lww5mvqzffqdc3w6k1j7f95v90hy4yn6m";
      type = "gem";
    };
    version = "1.30.0";
  };
  googleauth = {
    dependencies = ["faraday" "jwt" "memoist" "multi_json" "os" "signet"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pwm0mzb5zffhk6yw4v3n1yj8qr6jla6f78vsv4g0bxh9z0ikc2z";
      type = "gem";
    };
    version = "0.15.0";
  };
  highline = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01ib7jp85xjc4gh4jg0wyzllm46hwv8p0w1m4c75pbgi41fps50y";
      type = "gem";
    };
    version = "1.7.10";
  };
  http-cookie = {
    dependencies = ["domain_name"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "004cgs4xg5n6byjs7qld0xhsjq3n6ydfh897myr2mibvh6fjc49g";
      type = "gem";
    };
    version = "1.0.3";
  };
  httpclient = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19mxmvghp7ki3klsxwrlwr431li7hm1lczhhj8z4qihl2acy8l99";
      type = "gem";
    };
    version = "2.8.3";
  };
  jmespath = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1d4wac0dcd1jf6kc57891glih9w57552zgqswgy74d1xhgnk0ngf";
      type = "gem";
    };
    version = "1.4.0";
  };
  json = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lrirj0gw420kw71bjjlqkqhqbrplla61gbv1jzgsz6bv90qr3ci";
      type = "gem";
    };
    version = "2.5.1";
  };
  jwt = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14ynyq1q483spj20ffl4xayfqx1a8qr761mqjfxczf8lwlap392n";
      type = "gem";
    };
    version = "2.2.2";
  };
  memoist = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0i9wpzix3sjhf6d9zw60dm4371iq8kyz7ckh2qapan2vyaim6b55";
      type = "gem";
    };
    version = "0.16.2";
  };
  mini_magick = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1aj604x11d9pksbljh0l38f70b558rhdgji1s9i763hiagvvx2hs";
      type = "gem";
    };
    version = "4.11.0";
  };
  mini_mime = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1axm0rxyx3ss93wbmfkm78a6x03l8y4qy60rhkkiq0aza0vwq3ha";
      type = "gem";
    };
    version = "1.0.2";
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
      sha256 = "09k0b3cybqilk1gwrwwain95rdypixb2q9w65gd44gfzsd84xi1x";
      type = "gem";
    };
    version = "2.0.0";
  };
  nanaimo = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xi36h3f7nm8bc2k0b6svpda1lyank2gf872lxjbhw3h95hdrbma";
      type = "gem";
    };
    version = "0.3.0";
  };
  naturally = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04x1nkx6gkqzlc4phdvq05v3vjds6mgqhjqzqpcs6vdh5xyqrf59";
      type = "gem";
    };
    version = "2.2.1";
  };
  os = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12fli64wz5j9868gpzv5wqsingk1jk457qyqksv9ksmq9b0zpc9x";
      type = "gem";
    };
    version = "1.1.1";
  };
  plist = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1whhr897z6z6av85x2cipyjk46bwh6s4wx6nbrcd3iifnzvbqs7l";
      type = "gem";
    };
    version = "3.6.0";
  };
  public_suffix = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xqcgkl7bwws1qrlnmxgh8g4g9m10vg60bhlw40fplninb3ng6d9";
      type = "gem";
    };
    version = "4.0.6";
  };
  rake = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1iik52mf9ky4cgs38fp2m8r6skdkq1yz23vh18lk95fhbcxb6a67";
      type = "gem";
    };
    version = "13.0.3";
  };
  representable = {
    dependencies = ["declarative" "declarative-option" "uber"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qm9rgi1j5a6nv726ka4mmixivlxfsg91h8rpp72wwd4vqbkkm07";
      type = "gem";
    };
    version = "3.0.4";
  };
  retriable = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1q48hqws2dy1vws9schc0kmina40gy7sn5qsndpsfqdslh65snha";
      type = "gem";
    };
    version = "3.1.2";
  };
  rexml = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mkvkcw9fhpaizrhca0pdgjcrbns48rlz4g6lavl5gjjq3rk2sq3";
      type = "gem";
    };
    version = "3.2.4";
  };
  rouge = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sfikq1q8xyqqx690iiz7ybhzx87am4w50w8f2nq36l3asw4x89d";
      type = "gem";
    };
    version = "2.0.7";
  };
  ruby2_keywords = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15wfcqxyfgka05v2a7kpg64x57gl1y4xzvnc9lh60bqx5sf1iqrs";
      type = "gem";
    };
    version = "0.0.4";
  };
  rubyzip = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0590m2pr9i209pp5z4mx0nb1961ishdiqb28995hw1nln1d1b5ji";
      type = "gem";
    };
    version = "2.3.0";
  };
  security = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ryjxs0j66wrbky2c08yf0mllwalvpg12rpxzbdx2rdhj3cbrlxa";
      type = "gem";
    };
    version = "0.1.3";
  };
  signet = {
    dependencies = ["addressable" "faraday" "jwt" "multi_json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10g2667fvxnc50hcd1aywgsbf8j7nrckg3n7zjvywmyz82pwmpqp";
      type = "gem";
    };
    version = "0.14.0";
  };
  simctl = {
    dependencies = ["CFPropertyList" "naturally"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1v9rsdmg5c5kkf8ps47xnrfbvjnq11sbaifr186jwkh4npawz00x";
      type = "gem";
    };
    version = "1.6.8";
  };
  slack-notifier = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pkfn99dhy5s526r6k8d87fwwb6j287ga9s7lxqmh60z28xqh3bv";
      type = "gem";
    };
    version = "2.3.2";
  };
  terminal-notifier = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1slc0y8pjpw30hy21v8ypafi8r7z9jlj4bjbgz03b65b28i2n3bs";
      type = "gem";
    };
    version = "2.0.0";
  };
  terminal-table = {
    dependencies = ["unicode-display_width"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1512cngw35hsmhvw4c05rscihc59mnj09m249sm9p3pik831ydqk";
      type = "gem";
    };
    version = "1.8.0";
  };
  tty-cursor = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0j5zw041jgkmn605ya1zc151bxgxl6v192v2i26qhxx7ws2l2lvr";
      type = "gem";
    };
    version = "0.7.1";
  };
  tty-screen = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18jr6s1cg8yb26wzkqa6874q0z93rq0y5aw092kdqazk71y6a235";
      type = "gem";
    };
    version = "0.8.1";
  };
  tty-spinner = {
    dependencies = ["tty-cursor"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hh5awmijnzw9flmh5ak610x1d00xiqagxa5mbr63ysggc26y0qf";
      type = "gem";
    };
    version = "0.9.3";
  };
  uber = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p1mm7mngg40x05z52md3mbamkng0zpajbzqjjwmsyw0zw3v9vjv";
      type = "gem";
    };
    version = "0.1.0";
  };
  unf = {
    dependencies = ["unf_ext"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bh2cf73i2ffh4fcpdn9ir4mhq8zi50ik0zqa1braahzadx536a9";
      type = "gem";
    };
    version = "0.1.4";
  };
  unf_ext = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wc47r23h063l8ysws8sy24gzh74mks81cak3lkzlrw4qkqb3sg4";
      type = "gem";
    };
    version = "0.0.7.7";
  };
  unicode-display_width = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06i3id27s60141x6fdnjn5rar1cywdwy64ilc59cz937303q3mna";
      type = "gem";
    };
    version = "1.7.0";
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
  word_wrap = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1iyc5bc7dbgsd8j3yk1i99ral39f23l6wapi0083fbl19hid8mpm";
      type = "gem";
    };
    version = "1.0.0";
  };
  xcode-install = {
    dependencies = ["claide" "fastlane"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yhslanqw8r0mhls2hira05c8xjzzr7mnz1ab9p5qwg4z45ddjj8";
      type = "gem";
    };
    version = "2.6.8";
  };
  xcodeproj = {
    dependencies = ["CFPropertyList" "atomos" "claide" "colored2" "nanaimo"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1411j6sfnz0cx4fiw52f0yqx4bgcn8cmpgi3i5rwmmahayyjz2fn";
      type = "gem";
    };
    version = "1.19.0";
  };
  xcpretty = {
    dependencies = ["rouge"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xq47q2h5llj7b54rws4796904vnnjz7qqnacdv7wlp3gdbwrivm";
      type = "gem";
    };
    version = "0.3.0";
  };
  xcpretty-travis-formatter = {
    dependencies = ["xcpretty"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14rg4f70klrs910n7rsgfa4dn8s2qyny55194ax2qyyb2wpk7k5a";
      type = "gem";
    };
    version = "1.0.1";
  };
}
