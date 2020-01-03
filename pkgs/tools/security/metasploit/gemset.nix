{
  actionpack = {
    dependencies = ["actionview" "activesupport" "rack" "rack-test" "rails-dom-testing" "rails-html-sanitizer"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rmldsk3a4lwxk0lrp6x1nz1v1r2xmbm3300l4ghgfygv3grdwjh";
      type = "gem";
    };
    version = "4.2.11.1";
  };
  actionview = {
    dependencies = ["activesupport" "builder" "erubis" "rails-dom-testing" "rails-html-sanitizer"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0x7vjn8q6blzyf7j3kwg0ciy7vnfh28bjdkd1mp9k4ghp9jn0g9p";
      type = "gem";
    };
    version = "4.2.11.1";
  };
  activemodel = {
    dependencies = ["activesupport" "builder"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1c1x0rd6wnk1f0gsmxs6x3gx7yf6fs9qqkdv7r4hlbcdd849in33";
      type = "gem";
    };
    version = "4.2.11.1";
  };
  activerecord = {
    dependencies = ["activemodel" "activesupport" "arel"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07ixiwi0zzs9skqarvpfamsnay7npfswymrn28ngxaf8hi279q5p";
      type = "gem";
    };
    version = "4.2.11.1";
  };
  activesupport = {
    dependencies = ["i18n" "minitest" "thread_safe" "tzinfo"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vbq7a805bfvyik2q3kl9s3r418f5qzvysqbz2cwy4hr7m2q4ir6";
      type = "gem";
    };
    version = "4.2.11.1";
  };
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
  afm = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06kj9hgd0z8pj27bxp2diwqh6fv7qhwwm17z64rhdc4sfn76jgn8";
      type = "gem";
    };
    version = "0.2.2";
  };
  arel = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nfcrdiys6q6ylxiblky9jyssrw2xj96fmxmal7f4f0jj3417vj4";
      type = "gem";
    };
    version = "6.0.4";
  };
  arel-helpers = {
    dependencies = ["activerecord"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lb52rd20ix7khh70vrwd85qivir9sis62s055k3zr5h9iy3lyqi";
      type = "gem";
    };
    version = "2.10.0";
  };
  Ascii85 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0658m37jjjn6drzqg1gk4p6c205mgp7g1jh2d00n4ngghgmz5qvs";
      type = "gem";
    };
    version = "1.0.3";
  };
  aws-eventstream = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "100g77a5ixg4p5zwq77f28n2pdkk0y481f7v83qrlmnj22318qq6";
      type = "gem";
    };
    version = "1.0.3";
  };
  aws-partitions = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vkjw8cxssfwplrcl593gp4jxxiajihb8gqmpgzyac8i3xigpacb";
      type = "gem";
    };
    version = "1.208.0";
  };
  aws-sdk-core = {
    dependencies = ["aws-eventstream" "aws-partitions" "aws-sigv4" "jmespath"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18h35j7wp7n6zc5r6dpixjcyjshqmpkhwph9qgpv2g0db37zlxyk";
      type = "gem";
    };
    version = "3.66.0";
  };
  aws-sdk-ec2 = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1sb04blmc0lgdgq909cj8cm63zl2idgc5mcysj6cg4rvm8699ahp";
      type = "gem";
    };
    version = "1.106.0";
  };
  aws-sdk-iam = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ypv1cmmrc496myllqd8dqz422qm1i0bhskkvqb9b2lbagmzr3l9";
      type = "gem";
    };
    version = "1.29.0";
  };
  aws-sdk-kms = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14blvvfz67rhffi4ahby50jiip5f0hm85mcxlx6y93g0cfrnxh3m";
      type = "gem";
    };
    version = "1.24.0";
  };
  aws-sdk-s3 = {
    dependencies = ["aws-sdk-core" "aws-sdk-kms" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14iv2wqvvbiz0gdms21i9n6rh8390r1yg4zcf8pzzfplbqfwqw4w";
      type = "gem";
    };
    version = "1.48.0";
  };
  aws-sigv4 = {
    dependencies = ["aws-eventstream"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1dfc8i5cxjwlvi4b665lbpbwvks8a6wfy3vfmwr3pjdmxwdmc2cs";
      type = "gem";
    };
    version = "1.1.0";
  };
  backports = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cczfi1yp7a68bg7ipzi4lvrmi4xsi36n9a19krr4yb3nfwd8fn2";
      type = "gem";
    };
    version = "3.15.0";
  };
  bcrypt = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ysblqxkclmnhrd0kmb5mr8p38mbar633gdsb14b7dhkhgawgzfy";
      type = "gem";
    };
    version = "3.1.12";
  };
  bcrypt_pbkdf = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02vssr285m7kpsr47jdmzbar1h1d0mnkmyrpr1zg828isfmwii35";
      type = "gem";
    };
    version = "1.0.1";
  };
  bindata = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kz42nvxnk1j9cj0i8lcnhprcgdqsqska92g6l19ziadydfk2gqy";
      type = "gem";
    };
    version = "2.4.4";
  };
  bit-struct = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1w7x1fh4a6inpb46imhdf4xrq0z4d6zdpg7sdf8n98pif2hx50sx";
      type = "gem";
    };
    version = "0.16";
  };
  builder = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qibi5s67lpdv1wgcj66wcymcr04q6j4mzws6a479n0mlrmh5wr1";
      type = "gem";
    };
    version = "3.2.3";
  };
  concurrent-ruby = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "183lszf5gx84kcpb779v6a2y0mx9sssy8dgppng1z9a505nj1qcf";
      type = "gem";
    };
    version = "1.0.5";
  };
  cookiejar = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0q0kmbks9l3hl0wdq744hzy97ssq9dvlzywyqv9k9y1p3qc9va2a";
      type = "gem";
    };
    version = "0.3.3";
  };
  crass = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bpxzy6gjw9ggjynlxschbfsgmx8lv3zw1azkjvnb8b9i895dqfi";
      type = "gem";
    };
    version = "1.0.4";
  };
  daemons = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0l5gai3vd4g7aqff0k1mp41j9zcsvm2rbwmqn115a325k9r7pf4w";
      type = "gem";
    };
    version = "1.3.1";
  };
  dnsruby = {
    dependencies = ["addressable"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "139cbl2k934q7d50g7hi8r4im69ca3iv16y9plq9yc6mgjq1cgfk";
      type = "gem";
    };
    version = "1.61.3";
  };
  ed25519 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1f5kr8za7hvla38fc0n9jiv55iq62k5bzclsa5kdb14l3r4w6qnw";
      type = "gem";
    };
    version = "1.2.4";
  };
  em-http-request = {
    dependencies = ["addressable" "cookiejar" "em-socksify" "eventmachine" "http_parser.rb"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13rxmbi0fv91n4sg300v3i9iiwd0jxv0i6xd0sp81dx3jlx7kasx";
      type = "gem";
    };
    version = "1.1.5";
  };
  em-socksify = {
    dependencies = ["eventmachine"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rk43ywaanfrd8180d98287xv2pxyl7llj291cwy87g1s735d5nk";
      type = "gem";
    };
    version = "0.3.2";
  };
  erubis = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fj827xqjs91yqsydf0zmfyw9p4l2jz5yikg3mppz6d7fi8kyrb3";
      type = "gem";
    };
    version = "2.7.0";
  };
  eventmachine = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wh9aqb0skz80fhfn66lbpr4f86ya2z5rx6gm5xlfhd05bj1ch4r";
      type = "gem";
    };
    version = "1.2.7";
  };
  faker = {
    dependencies = ["i18n"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wpzpqzpqd9jjzm3ap8182sfbnhdahcxpbg0dssbwq13qdf1s5xs";
      type = "gem";
    };
    version = "2.2.1";
  };
  faraday = {
    dependencies = ["multipart-post"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0s72m05jvzc1pd6cw1i289chas399q0a14xrwg4rvkdwy7bgzrh0";
      type = "gem";
    };
    version = "0.15.4";
  };
  filesize = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17p7rf1x7h3ivaznb4n4kmxnnzj25zaviryqgn2n12v2kmibhp8g";
      type = "gem";
    };
    version = "0.2.0";
  };
  hashery = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qj8815bf7q6q7llm5rzdz279gzmpqmqqicxnzv066a020iwqffj";
      type = "gem";
    };
    version = "2.1.2";
  };
  "http_parser.rb" = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15nidriy0v5yqfjsgsra51wmknxci2n2grliz78sf9pga3n0l7gi";
      type = "gem";
    };
    version = "0.6.0";
  };
  i18n = {
    dependencies = ["concurrent-ruby"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "038qvz7kd3cfxk8bvagqhakx68pfbnmghpdkx7573wbf0maqp9a3";
      type = "gem";
    };
    version = "0.9.5";
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
  jsobfu = {
    dependencies = ["rkelly-remix"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hchns89cfj0gggm2zbr7ghb630imxm2x2d21ffx2jlasn9xbkyk";
      type = "gem";
    };
    version = "0.4.2";
  };
  json = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sx97bm9by389rbzv8r1f43h06xcz8vwi3h5jv074gvparql7lcx";
      type = "gem";
    };
    version = "2.2.0";
  };
  loofah = {
    dependencies = ["crass" "nokogiri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ccsid33xjajd0im2xv941aywi58z7ihwkvaf1w2bv89vn5bhsjg";
      type = "gem";
    };
    version = "2.2.3";
  };
  metasm = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mbmpc8vsi574s78f23bhiqk07sr6yrrrmk702lfv61ql4ah5l89";
      type = "gem";
    };
    version = "1.0.4";
  };
  metasploit-concern = {
    dependencies = ["activemodel" "activesupport" "railties"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0v9lm225fhzhnbjcc0vwb38ybikxwzlv8116rrrkndzs8qy79297";
      type = "gem";
    };
    version = "2.0.5";
  };
  metasploit-credential = {
    dependencies = ["metasploit-concern" "metasploit-model" "metasploit_data_models" "net-ssh" "pg" "railties" "rex-socket" "rubyntlm" "rubyzip"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0m6j149x502p00y2jzra65281dhhw3m8a41pwfn1sk9wv7aiclvl";
      type = "gem";
    };
    version = "3.0.3";
  };
  metasploit-framework = {
    dependencies = ["actionpack" "activerecord" "activesupport" "aws-sdk-ec2" "aws-sdk-iam" "aws-sdk-s3" "backports" "bcrypt" "bcrypt_pbkdf" "bit-struct" "concurrent-ruby" "dnsruby" "ed25519" "em-http-request" "faker" "filesize" "jsobfu" "json" "metasm" "metasploit-concern" "metasploit-credential" "metasploit-model" "metasploit-payloads" "metasploit_data_models" "metasploit_payloads-mettle" "mqtt" "msgpack" "nessus_rest" "net-ssh" "network_interface" "nexpose" "nokogiri" "octokit" "openssl-ccm" "openvas-omp" "packetfu" "patch_finder" "pcaprub" "pdf-reader" "pg" "railties" "rb-readline" "recog" "redcarpet" "rex-arch" "rex-bin_tools" "rex-core" "rex-encoder" "rex-exploitation" "rex-java" "rex-mime" "rex-nop" "rex-ole" "rex-powershell" "rex-random_identifier" "rex-registry" "rex-rop_builder" "rex-socket" "rex-sslscan" "rex-struct2" "rex-text" "rex-zip" "ruby-macho" "ruby_smb" "rubyntlm" "rubyzip" "sinatra" "sqlite3" "sshkey" "thin" "tzinfo" "tzinfo-data" "warden" "windows_error" "xdr" "xmlrpc"];
    groups = ["default"];
    platforms = [];
    source = {
      fetchSubmodules = false;
      rev = "2b9e74c7a8a4423ea195e75abca1f56c354e5541";
      sha256 = "16jl3fkfbwl4wwbj2zrq9yr8y8brkhj9641hplc8idv8gaqkgmm5";
      type = "git";
      url = "https://github.com/rapid7/metasploit-framework";
    };
    version = "5.0.45";
  };
  metasploit-model = {
    dependencies = ["activemodel" "activesupport" "railties"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05pnai1cv00xw87rrz38dz4s3ss45s90290d0knsy1mq6rp8yvmw";
      type = "gem";
    };
    version = "2.0.4";
  };
  metasploit-payloads = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01s3xmgw4fp2ic0wql8lswa86q3lgr3z687idx3xkfii3dskjpp3";
      type = "gem";
    };
    version = "1.3.70";
  };
  metasploit_data_models = {
    dependencies = ["activerecord" "activesupport" "arel-helpers" "metasploit-concern" "metasploit-model" "pg" "postgres_ext" "railties" "recog"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1h59lblfrx8gsnqr10wk958zp6rsjy3qib3hb87s3nm6m1zhm2bc";
      type = "gem";
    };
    version = "3.0.10";
  };
  metasploit_payloads-mettle = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1x2rgs2r16m8z87j5z78vp49xvr2sr4dxjgbi6d0nxrlr52pd8yf";
      type = "gem";
    };
    version = "0.5.16";
  };
  mini_portile2 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15zplpfw3knqifj9bpf604rb3wc1vhq6363pd6lvhayng8wql5vy";
      type = "gem";
    };
    version = "2.4.0";
  };
  minitest = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0icglrhghgwdlnzzp4jf76b0mbc71s80njn5afyfjn4wqji8mqbq";
      type = "gem";
    };
    version = "5.11.3";
  };
  mqtt = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0d1khsry5mf63y03r6v91f4vrbn88277ksv7d69z3xmqs9sgpri9";
      type = "gem";
    };
    version = "0.5.0";
  };
  msgpack = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qr2mkm2i3m76zarvy7qgjl9596hmvjrg7x6w42vx8cfsbf5p0y1";
      type = "gem";
    };
    version = "1.3.1";
  };
  multipart-post = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zgw9zlwh2a6i1yvhhc4a84ry1hv824d6g2iw2chs3k5aylpmpfj";
      type = "gem";
    };
    version = "2.1.1";
  };
  nessus_rest = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1allyrd4rll333zbmsi3hcyg6cw1dhc4bg347ibsw191nswnp8ci";
      type = "gem";
    };
    version = "0.1.6";
  };
  net-ssh = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "101wd2px9lady54aqmkibvy4j62zk32w0rjz4vnigyg974fsga40";
      type = "gem";
    };
    version = "5.2.0";
  };
  network_interface = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xh4knfq77ii4pjzsd2z1p3nd6nrcdjhb2vi5gw36jqj43ffw0zp";
      type = "gem";
    };
    version = "0.0.2";
  };
  nexpose = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0i108glkklwgjxhfhnlqf4b16plqf9b84qpfz0pnl2pbnal5af8m";
      type = "gem";
    };
    version = "7.2.1";
  };
  nokogiri = {
    dependencies = ["mini_portile2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nmdrqqz1gs0fwkgzxjl4wr554gr8dc1fkrqjc2jpsvwgm41rygv";
      type = "gem";
    };
    version = "1.10.4";
  };
  octokit = {
    dependencies = ["sawyer"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1w7agbfg39jzqk81yad9xhscg31869277ysr2iwdvpjafl5lj4ha";
      type = "gem";
    };
    version = "4.14.0";
  };
  openssl-ccm = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gxwxk657jya2s5m8cpckvgy5m7qx0hzfp8xvc0hg2wf1lg5gwp0";
      type = "gem";
    };
    version = "1.2.2";
  };
  openvas-omp = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14xf614vd76qjdjxjv14mmjar6s64fwp4cwb7bv5g1wc29srg28x";
      type = "gem";
    };
    version = "0.0.4";
  };
  packetfu = {
    dependencies = ["pcaprub"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16ppq9wfxq4x2hss61l5brs3s6fmi8gb50mnp1nnnzb1asq4g8ll";
      type = "gem";
    };
    version = "1.1.13";
  };
  patch_finder = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1md9scls55n1riw26vw1ak0ajq38dfygr36l0h00wqhv51cq745m";
      type = "gem";
    };
    version = "1.0.2";
  };
  pcaprub = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h4iarqdych6v4jm5s0ywkc01qspadz8sf6qn7pkqmszq4iqv67q";
      type = "gem";
    };
    version = "0.13.0";
  };
  pdf-reader = {
    dependencies = ["Ascii85" "afm" "hashery" "ruby-rc4" "ttfunk"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14lqdbiwn2qwgbvnnzxg7haqiy026d8x37hp45c3m9jb9rym92ps";
      type = "gem";
    };
    version = "2.2.1";
  };
  pg = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00vhasqwc4f98qb4wxqn2h07fjwzhp5lwyi41j2gndi2g02wrdqh";
      type = "gem";
    };
    version = "0.21.0";
  };
  pg_array_parser = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1034dhg8h53j48sfm373js54skg4vpndjga6hzn2zylflikrrf3s";
      type = "gem";
    };
    version = "0.0.9";
  };
  postgres_ext = {
    dependencies = ["activerecord" "arel" "pg_array_parser"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ni1ajzxvc17ba4rgl27cd3645ddbpqpfckv7m08sfgk015hh7dq";
      type = "gem";
    };
    version = "3.0.1";
  };
  public_suffix = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xnfv2j2bqgdpg2yq9i2rxby0w2sc9h5iyjkpaas2xknwrgmhdb0";
      type = "gem";
    };
    version = "4.0.1";
  };
  rack = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g9926ln2lw12lfxm4ylq1h6nl0rafl10za3xvjzc87qvnqic87f";
      type = "gem";
    };
    version = "1.6.11";
  };
  rack-protection = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0my0wlw4a5l3hs79jkx2xzv7djhajgf8d28k8ai1ddlnxxb0v7ss";
      type = "gem";
    };
    version = "1.5.5";
  };
  rack-test = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h6x5jq24makgv2fq5qqgjlrk74dxfy62jif9blk43llw8ib2q7z";
      type = "gem";
    };
    version = "0.6.3";
  };
  rails-deprecated_sanitizer = {
    dependencies = ["activesupport"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qxymchzdxww8bjsxj05kbf86hsmrjx40r41ksj0xsixr2gmhbbj";
      type = "gem";
    };
    version = "1.0.3";
  };
  rails-dom-testing = {
    dependencies = ["activesupport" "nokogiri" "rails-deprecated_sanitizer"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wssfqpn00byhvp2372p99mphkcj8qx6pf6646avwr9ifvq0q1x6";
      type = "gem";
    };
    version = "1.0.9";
  };
  rails-html-sanitizer = {
    dependencies = ["loofah"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ilwxzm3a7bql5c9q2n9g9nb1hax7vd8d65a5yp3d967ld97nvrq";
      type = "gem";
    };
    version = "1.2.0";
  };
  railties = {
    dependencies = ["actionpack" "activesupport" "rake" "thor"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bjf21z9maiiazc1if56nnh9xmgbkcqlpznv34f40a1hsvgk1d1m";
      type = "gem";
    };
    version = "4.2.11.1";
  };
  rake = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cvaqarr1m84mhc006g3l1vw7sa5qpkcw0138lsxlf769zdllsgp";
      type = "gem";
    };
    version = "12.3.3";
  };
  rb-readline = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14w79a121czmvk1s953qfzww30mqjb2zc0k9qhi0ivxxk3hxg6wy";
      type = "gem";
    };
    version = "0.5.5";
  };
  recog = {
    dependencies = ["nokogiri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kbv0j82zf90sc9hhwna2bkb5zv0nxagk22gxyfy82kjmcz71c6k";
      type = "gem";
    };
    version = "2.3.2";
  };
  redcarpet = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0skcyx1h8b5ms0rp2zm3ql6g322b8c1adnkwkqyv7z3kypb4bm7k";
      type = "gem";
    };
    version = "3.5.0";
  };
  rex-arch = {
    dependencies = ["rex-text"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cvdy2ysiphdig258lkicbxqq2y47bkl69kgj4kkj8w338rb5kwa";
      type = "gem";
    };
    version = "0.1.13";
  };
  rex-bin_tools = {
    dependencies = ["metasm" "rex-arch" "rex-core" "rex-struct2" "rex-text"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19q4cj7cis29k3zx9j2gp4h3ib0zig2fa4rs56c1gjr32f192zzk";
      type = "gem";
    };
    version = "0.1.6";
  };
  rex-core = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1b9pf7f8m2zjck65dpp8h8v4n0a05kfas6cn9adv0w8d9z58aqvv";
      type = "gem";
    };
    version = "0.1.13";
  };
  rex-encoder = {
    dependencies = ["metasm" "rex-arch" "rex-text"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zm5jdxgyyp8pkfqwin34izpxdrmglx6vmk20ifnvcsm55c9m70z";
      type = "gem";
    };
    version = "0.1.4";
  };
  rex-exploitation = {
    dependencies = ["jsobfu" "metasm" "rex-arch" "rex-encoder" "rex-text"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0b2jg7mccwc34j9mfpndh7b387723qas38qsd906bs4s8b6hf05c";
      type = "gem";
    };
    version = "0.1.21";
  };
  rex-java = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0j58k02p5g9snkpak64sb4aymkrvrh9xpqh8wsnya4w7b86w2y6i";
      type = "gem";
    };
    version = "0.1.5";
  };
  rex-mime = {
    dependencies = ["rex-text"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15a14kz429h7pn81ysa6av3qijxjmxagjff6dyss5v394fxzxf4a";
      type = "gem";
    };
    version = "0.1.5";
  };
  rex-nop = {
    dependencies = ["rex-arch"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0aigf9qsqsmiraa6zvfy1a7cyvf7zc3iyhzxi6fjv5sb8f64d6ny";
      type = "gem";
    };
    version = "0.1.1";
  };
  rex-ole = {
    dependencies = ["rex-text"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pnzbqfnvbs0vc0z0ryszk3fxhgxrjd6gzwqa937rhlphwp5jpww";
      type = "gem";
    };
    version = "0.1.6";
  };
  rex-powershell = {
    dependencies = ["rex-random_identifier" "rex-text"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fcyiz8cgcv6pcn5w969ac4wwhr1cz6jk6kf6p8gyw5rjrlwfz0j";
      type = "gem";
    };
    version = "0.1.82";
  };
  rex-random_identifier = {
    dependencies = ["rex-text"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fg94sczff5c2rlvqqgw2dndlqyzjil5rjk3p9f46ss2hc8zxlbk";
      type = "gem";
    };
    version = "0.1.4";
  };
  rex-registry = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wv812ghnz143vx10ixmv32ypj1xrzr4rh4kgam8d8wwjwxsgw1q";
      type = "gem";
    };
    version = "0.1.3";
  };
  rex-rop_builder = {
    dependencies = ["metasm" "rex-core" "rex-text"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xjd3d6wnbq4ym0d0m268md8fb16f2hbwrahvxnl14q63fj9i3wy";
      type = "gem";
    };
    version = "0.1.3";
  };
  rex-socket = {
    dependencies = ["rex-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "136szyv31fcdzmcgs44vg009k3ssyawkqppkhm3xyv2ivpp1mlgv";
      type = "gem";
    };
    version = "0.1.17";
  };
  rex-sslscan = {
    dependencies = ["rex-core" "rex-socket" "rex-text"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06gbx45q653ajcx099p0yxdqqxazfznbrqshd4nwiwg1p498lmyx";
      type = "gem";
    };
    version = "0.1.5";
  };
  rex-struct2 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nbdn53264a20cr2m2nq2v4mg0n33dvrd1jj1sixl37qjzw2k452";
      type = "gem";
    };
    version = "0.1.2";
  };
  rex-text = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cmfwzd3r6xzhaw5l2grgiivql1yynh620drg8h39q8hiixya6xz";
      type = "gem";
    };
    version = "0.2.23";
  };
  rex-zip = {
    dependencies = ["rex-text"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mbfryyhcw47i7jb8cs8vilbyqgyiyjkfl1ngl6wdbf7d87dwdw7";
      type = "gem";
    };
    version = "0.1.3";
  };
  rkelly-remix = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g7hjl9nx7f953y7lncmfgp0xgxfxvgfm367q6da9niik6rp1y3j";
      type = "gem";
    };
    version = "0.0.7";
  };
  ruby-macho = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1k5vvk9d13pixhbram6fs74ibgmr2dngv7bks13npcjb42q275if";
      type = "gem";
    };
    version = "2.2.0";
  };
  ruby-rc4 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00vci475258mmbvsdqkmqadlwn6gj9m01sp7b5a3zd90knil1k00";
      type = "gem";
    };
    version = "0.1.5";
  };
  ruby_smb = {
    dependencies = ["bindata" "rubyntlm" "windows_error"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "125pimmaskp13nkk5j138nfk1kd8n91sfdlx4dhj2j9zk342wsf4";
      type = "gem";
    };
    version = "1.1.0";
  };
  rubyntlm = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p6bxsklkbcqni4bcq6jajc2n57g0w5rzn4r49c3lb04wz5xg0dy";
      type = "gem";
    };
    version = "0.6.2";
  };
  rubyzip = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1w9gw28ly3zyqydnm8phxchf4ymyjl2r7zf7c12z8kla10cpmhlc";
      type = "gem";
    };
    version = "1.2.3";
  };
  sawyer = {
    dependencies = ["addressable" "faraday"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yrdchs3psh583rjapkv33mljdivggqn99wkydkjdckcjn43j3cz";
      type = "gem";
    };
    version = "0.8.2";
  };
  sinatra = {
    dependencies = ["rack" "rack-protection" "tilt"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0byxzl7rx3ki0xd7aiv1x8mbah7hzd8f81l65nq8857kmgzj1jqq";
      type = "gem";
    };
    version = "1.4.8";
  };
  sqlite3 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1v903nbcws3ifm6jnxrdfcpgl1qg2x3lbif16mhlbyfn0npzb494";
      type = "gem";
    };
    version = "1.4.1";
  };
  sshkey = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03bkn55qsng484iqwz2lmm6rkimj01vsvhwk661s3lnmpkl65lbp";
      type = "gem";
    };
    version = "2.0.0";
  };
  thin = {
    dependencies = ["daemons" "eventmachine" "rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nagbf9pwy1vg09k6j4xqhbjjzrg5dwzvkn4ffvlj76fsn6vv61f";
      type = "gem";
    };
    version = "1.7.2";
  };
  thor = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yhrnp9x8qcy5vc7g438amd5j9sw83ih7c30dr6g6slgw9zj3g29";
      type = "gem";
    };
    version = "0.20.3";
  };
  thread_safe = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nmhcgq6cgz44srylra07bmaw99f5271l0dpsvl5f75m44l0gmwy";
      type = "gem";
    };
    version = "0.3.6";
  };
  tilt = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ca4k0clwf0rkvy7726x4nxpjxkpv67w043i39saxgldxd97zmwz";
      type = "gem";
    };
    version = "2.0.9";
  };
  ttfunk = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mgrnqla5n51v4ivn844albsajkck7k6lviphfqa8470r46c58cd";
      type = "gem";
    };
    version = "1.5.1";
  };
  tzinfo = {
    dependencies = ["thread_safe"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fjx9j327xpkkdlxwmkl3a8wqj7i4l4jwlrv3z13mg95z9wl253z";
      type = "gem";
    };
    version = "1.2.5";
  };
  tzinfo-data = {
    dependencies = ["tzinfo"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1m507in0d7vlfgasxpkz3y1a44zp532k9qlqcaz90ay939sz9h5q";
      type = "gem";
    };
    version = "1.2019.2";
  };
  warden = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0va966lhpylcwbqb9n151kkihx30agh0a57mwjwdxyanll4s1q12";
      type = "gem";
    };
    version = "1.2.7";
  };
  windows_error = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kbcv9j5sc7pvjzf1dkp6h69i6lmj205zyy2arxcfgqg11bsz2kp";
      type = "gem";
    };
    version = "0.1.2";
  };
  xdr = {
    dependencies = ["activemodel" "activesupport"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0c5cp1k4ij3xq1q6fb0f6xv5b65wy18y7bhwvsdx8wd0zyg3x96m";
      type = "gem";
    };
    version = "2.0.0";
  };
  xmlrpc = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1s744iwblw262gj357pky3d9fcx9hisvla7rnw29ysn5zsb6i683";
      type = "gem";
    };
    version = "0.3.0";
  };
}