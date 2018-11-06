{
  actionpack = {
    dependencies = ["actionview" "activesupport" "rack" "rack-test" "rails-dom-testing" "rails-html-sanitizer"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kgrq74gp2czzxr0f2sqrc98llz03lgq498300z2z5n4khgznwc4";
      type = "gem";
    };
    version = "4.2.9";
  };
  actionview = {
    dependencies = ["activesupport" "builder" "erubis" "rails-dom-testing" "rails-html-sanitizer"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04kgp4gmahw31miz8xdq1pns14qmvvzd14fgfv7fg9klkw3bxyyp";
      type = "gem";
    };
    version = "4.2.9";
  };
  activemodel = {
    dependencies = ["activesupport" "builder"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qxmivny0ka5s3iyap08sn9bp2bd9wrhqp2njfw26hr9wsjk5kfv";
      type = "gem";
    };
    version = "4.2.9";
  };
  activerecord = {
    dependencies = ["activemodel" "activesupport" "arel"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18i790dfhi4ndypd1pj9pv08knpxr2sayvvwfq7axj5jfwgpmrqb";
      type = "gem";
    };
    version = "4.2.9";
  };
  activesupport = {
    dependencies = ["i18n" "minitest" "thread_safe" "tzinfo"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1d0a362p3m2m2kljichar2pwq0qm4vblc3njy1rdzm09ckzd45sp";
      type = "gem";
    };
    version = "4.2.9";
  };
  addressable = {
    dependencies = ["public_suffix"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1i8q32a4gr0zghxylpyy7jfqwxvwrivsxflg9mks6kx92frh75mh";
      type = "gem";
    };
    version = "2.5.1";
  };
  afm = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06kj9hgd0z8pj27bxp2diwqh6fv7qhwwm17z64rhdc4sfn76jgn8";
      type = "gem";
    };
    version = "0.2.2";
  };
  arel = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nfcrdiys6q6ylxiblky9jyssrw2xj96fmxmal7f4f0jj3417vj4";
      type = "gem";
    };
    version = "6.0.4";
  };
  arel-helpers = {
    dependencies = ["activerecord"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1sx4qbzhld3a99175p2krz3hv1npc42rv3sd8x4awzkgplg3zy9c";
      type = "gem";
    };
    version = "2.4.0";
  };
  Ascii85 = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0j95sbxd18kc8rhcnvl1w37kflqpax1r12h1x47gh4xxn3mz4m7q";
      type = "gem";
    };
    version = "1.0.2";
  };
  backports = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17pcz0z6jms5jydr1r95kf1bpk3ms618hgr26c62h34icy9i1dpm";
      type = "gem";
    };
    version = "3.8.0";
  };
  bcrypt = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1d254sdhdj6mzak3fb5x3jam8b94pvl1srladvs53j05a89j5z50";
      type = "gem";
    };
    version = "3.1.11";
  };
  bcrypt_pbkdf = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cj4k13c7qvvck7y25i3xarvyqq8d27vl61jddifkc7llnnap1hv";
      type = "gem";
    };
    version = "1.0.0";
  };
  bindata = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10sii2chgnkp2jw830sbr2wb20p8p1wcwrl9jhadkw94f505qcyg";
      type = "gem";
    };
    version = "2.4.0";
  };
  bit-struct = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1w7x1fh4a6inpb46imhdf4xrq0z4d6zdpg7sdf8n98pif2hx50sx";
      type = "gem";
    };
    version = "0.16";
  };
  builder = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qibi5s67lpdv1wgcj66wcymcr04q6j4mzws6a479n0mlrmh5wr1";
      type = "gem";
    };
    version = "3.2.3";
  };
  dnsruby = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qfvpkka69f8vnmda3zhkr54fjpf7pwgmbx0gcsxg3jd6c7sjs1d";
      type = "gem";
    };
    version = "1.60.2";
  };
  erubis = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fj827xqjs91yqsydf0zmfyw9p4l2jz5yikg3mppz6d7fi8kyrb3";
      type = "gem";
    };
    version = "2.7.0";
  };
  faraday = {
    dependencies = ["multipart-post"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gyqsj7vlqynwvivf9485zwmcj04v1z7gq362z0b8zw2zf4ag0hw";
      type = "gem";
    };
    version = "0.13.1";
  };
  ffi = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "034f52xf7zcqgbvwbl20jwdyjwznvqnwpbaps9nk18v9lgb1dpx0";
      type = "gem";
    };
    version = "1.9.18";
  };
  filesize = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "061qmg82mm9xnmnq3b7gbi24g28xk62w0b0nw86gybd07m1jn989";
      type = "gem";
    };
    version = "0.1.1";
  };
  hashery = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qj8815bf7q6q7llm5rzdz279gzmpqmqqicxnzv066a020iwqffj";
      type = "gem";
    };
    version = "2.1.2";
  };
  i18n = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1i3aqvzfsj786kwjj70jsjpxm6ffw5pwhalzr2abjfv2bdc7k9kw";
      type = "gem";
    };
    version = "0.8.6";
  };
  jsobfu = {
    dependencies = ["rkelly-remix"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hchns89cfj0gggm2zbr7ghb630imxm2x2d21ffx2jlasn9xbkyk";
      type = "gem";
    };
    version = "0.4.2";
  };
  json = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01v6jjpvh3gnq6sgllpfqahlgxzj50ailwhj9b3cd20hi2dx0vxp";
      type = "gem";
    };
    version = "2.1.0";
  };
  loofah = {
    dependencies = ["nokogiri"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "109ps521p0sr3kgc460d58b4pr1z4mqggan2jbsf0aajy9s6xis8";
      type = "gem";
    };
    version = "2.0.3";
  };
  metasm = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gss57q4lv6l0jkih77zffrpjjzgkdcsy7b9nvvawyzknis9w4s5";
      type = "gem";
    };
    version = "1.0.3";
  };
  metasploit-concern = {
    dependencies = ["activemodel" "activesupport" "railties"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0v9lm225fhzhnbjcc0vwb38ybikxwzlv8116rrrkndzs8qy79297";
      type = "gem";
    };
    version = "2.0.5";
  };
  metasploit-credential = {
    dependencies = ["metasploit-concern" "metasploit-model" "metasploit_data_models" "pg" "railties" "rex-socket" "rubyntlm" "rubyzip"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1flahrcl5hf4bncqs40mry6pkffvmir85kqzkad22x3dh6crw50i";
      type = "gem";
    };
    version = "2.0.12";
  };
  metasploit-framework = {
    dependencies = ["actionpack" "activerecord" "activesupport" "backports" "bcrypt" "bcrypt_pbkdf" "bit-struct" "dnsruby" "filesize" "jsobfu" "json" "metasm" "metasploit-concern" "metasploit-credential" "metasploit-model" "metasploit-payloads" "metasploit_data_models" "metasploit_payloads-mettle" "msgpack" "nessus_rest" "net-ssh" "network_interface" "nexpose" "nokogiri" "octokit" "openssl-ccm" "openvas-omp" "packetfu" "patch_finder" "pcaprub" "pdf-reader" "pg" "railties" "rb-readline" "rbnacl" "rbnacl-libsodium" "recog" "redcarpet" "rex-arch" "rex-bin_tools" "rex-core" "rex-encoder" "rex-exploitation" "rex-java" "rex-mime" "rex-nop" "rex-ole" "rex-powershell" "rex-random_identifier" "rex-registry" "rex-rop_builder" "rex-socket" "rex-sslscan" "rex-struct2" "rex-text" "rex-zip" "robots" "ruby_smb" "rubyntlm" "rubyzip" "sqlite3" "sshkey" "tzinfo" "tzinfo-data" "windows_error" "xdr" "xmlrpc"];
    source = {
      fetchSubmodules = false;
      rev = "dbec1c2d2ae4bd77276cbfb3c6ee2902048b9453";
      sha256 = "06a2dc64wl8w02zimf44hch4cap7ckw42kg1x01lmcwaa8d5q09w";
      type = "git";
      url = "https://github.com/rapid7/metasploit-framework";
    };
    version = "4.16.1";
  };
  metasploit-model = {
    dependencies = ["activemodel" "activesupport" "railties"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05pnai1cv00xw87rrz38dz4s3ss45s90290d0knsy1mq6rp8yvmw";
      type = "gem";
    };
    version = "2.0.4";
  };
  metasploit-payloads = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0icha08z4c5rnyp66xcyn9c8lbv43gx7hgs9rsm3539gj8c40znx";
      type = "gem";
    };
    version = "1.3.1";
  };
  metasploit_data_models = {
    dependencies = ["activerecord" "activesupport" "arel-helpers" "metasploit-concern" "metasploit-model" "pg" "postgres_ext" "railties" "recog"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0j3ijxn6n3ack9572a74cwknijymy41c8rx34njyhg25lx4hbvah";
      type = "gem";
    };
    version = "2.0.15";
  };
  metasploit_payloads-mettle = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1y2nfzgs17pq3xvlw14jgjcksr4h8p4miypxk9a87l1h7xv7dcgn";
      type = "gem";
    };
    version = "0.2.0";
  };
  mini_portile2 = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0g5bpgy08q0nc0anisg3yvwc1gc3inl854fcrg48wvg7glqd6dpm";
      type = "gem";
    };
    version = "2.2.0";
  };
  minitest = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05521clw19lrksqgvg2kmm025pvdhdaniix52vmbychrn2jm7kz2";
      type = "gem";
    };
    version = "5.10.3";
  };
  msgpack = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ck7w17d6b4jbb8inh1q57bghi9cjkiaxql1d3glmj1yavbpmlh7";
      type = "gem";
    };
    version = "1.1.0";
  };
  multipart-post = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09k0b3cybqilk1gwrwwain95rdypixb2q9w65gd44gfzsd84xi1x";
      type = "gem";
    };
    version = "2.0.0";
  };
  nessus_rest = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1allyrd4rll333zbmsi3hcyg6cw1dhc4bg347ibsw191nswnp8ci";
      type = "gem";
    };
    version = "0.1.6";
  };
  net-ssh = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "013p5jb4wy0cq7x7036piw2a3s1i9p752ki1srx2m289mpz4ml3q";
      type = "gem";
    };
    version = "4.1.0";
  };
  network_interface = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ir4c1vbz1y0gxyih024262i7ig1nji1lkylcrn9pjzx3798p97a";
      type = "gem";
    };
    version = "0.0.1";
  };
  nexpose = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jnyvj09z8r3chhj930fdnashbfcfv0vw2drjvsrcnm7firdhdzb";
      type = "gem";
    };
    version = "6.1.1";
  };
  nokogiri = {
    dependencies = ["mini_portile2"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nffsyx1xjg6v5n9rrbi8y1arrcx2i5f21cp6clgh9iwiqkr7rnn";
      type = "gem";
    };
    version = "1.8.0";
  };
  octokit = {
    dependencies = ["sawyer"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h6cm7bi0y7ysjgwws3paaipqdld6c0m0niazrjahhpz88qqq1g4";
      type = "gem";
    };
    version = "4.7.0";
  };
  openssl-ccm = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18h5lxv0zh4j2f0wnhdmfz63x02vbzbq2k1clz6kzr0q83h8kj9c";
      type = "gem";
    };
    version = "1.2.1";
  };
  openvas-omp = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14xf614vd76qjdjxjv14mmjar6s64fwp4cwb7bv5g1wc29srg28x";
      type = "gem";
    };
    version = "0.0.4";
  };
  packetfu = {
    dependencies = ["pcaprub"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16ppq9wfxq4x2hss61l5brs3s6fmi8gb50mnp1nnnzb1asq4g8ll";
      type = "gem";
    };
    version = "1.1.13";
  };
  patch_finder = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1md9scls55n1riw26vw1ak0ajq38dfygr36l0h00wqhv51cq745m";
      type = "gem";
    };
    version = "1.0.2";
  };
  pcaprub = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pl4lqy7308185pfv0197n8b4v20fhd0zb3wlpz284rk8ssclkvz";
      type = "gem";
    };
    version = "0.12.4";
  };
  pdf-reader = {
    dependencies = ["Ascii85" "afm" "hashery" "ruby-rc4" "ttfunk"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nlammdpjy3padmzxhsql7mw31jyqp88n6bdffiarv5kzl4s3y7p";
      type = "gem";
    };
    version = "2.0.0";
  };
  pg = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03xcgwjs6faxis81jxf2plnlalg55dhhafqv3kvjxfr8ic7plpw5";
      type = "gem";
    };
    version = "0.20.0";
  };
  pg_array_parser = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1034dhg8h53j48sfm373js54skg4vpndjga6hzn2zylflikrrf3s";
      type = "gem";
    };
    version = "0.0.9";
  };
  postgres_ext = {
    dependencies = ["activerecord" "arel" "pg_array_parser"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lbp1qf5s1addhznm7d4bzks9adh7jpilgcsr8k7mbd0a1ailcgc";
      type = "gem";
    };
    version = "3.0.0";
  };
  public_suffix = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "040jf98jpp6w140ghkhw2hvc1qx41zvywx5gj7r2ylr1148qnj7q";
      type = "gem";
    };
    version = "2.0.5";
  };
  rack = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g9926ln2lw12lfxm4ylq1h6nl0rafl10za3xvjzc87qvnqic87f";
      type = "gem";
    };
    version = "1.6.11";
  };
  rack-test = {
    dependencies = ["rack"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h6x5jq24makgv2fq5qqgjlrk74dxfy62jif9blk43llw8ib2q7z";
      type = "gem";
    };
    version = "0.6.3";
  };
  rails-deprecated_sanitizer = {
    dependencies = ["activesupport"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qxymchzdxww8bjsxj05kbf86hsmrjx40r41ksj0xsixr2gmhbbj";
      type = "gem";
    };
    version = "1.0.3";
  };
  rails-dom-testing = {
    dependencies = ["activesupport" "nokogiri" "rails-deprecated_sanitizer"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ny7mbjxhq20rzg4pivvyvk14irmc7cn20kxfk3vc0z2r2c49p8r";
      type = "gem";
    };
    version = "1.0.8";
  };
  rails-html-sanitizer = {
    dependencies = ["loofah"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "138fd86kv073zqfx0xifm646w6bgw2lr8snk16lknrrfrss8xnm7";
      type = "gem";
    };
    version = "1.0.3";
  };
  railties = {
    dependencies = ["actionpack" "activesupport" "rake" "thor"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g5jnk1zllm2fr06lixq7gv8l2cwqc99akv7886gz6lshijpfyxd";
      type = "gem";
    };
    version = "4.2.9";
  };
  rake = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01j8fc9bqjnrsxbppncai05h43315vmz9fwg28qdsgcjw9ck1d7n";
      type = "gem";
    };
    version = "12.0.0";
  };
  rb-readline = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14w79a121czmvk1s953qfzww30mqjb2zc0k9qhi0ivxxk3hxg6wy";
      type = "gem";
    };
    version = "0.5.5";
  };
  rbnacl = {
    dependencies = ["ffi"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08dkigw8wdx53hviw1zqrs7rcrzqcwh9jd3dvwr72013z9fmyp48";
      type = "gem";
    };
    version = "4.0.2";
  };
  rbnacl-libsodium = {
    dependencies = ["rbnacl"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1323fli41m01af13xz5xvabsjnz09si1b9l4qd2p802kq0dr61gd";
      type = "gem";
    };
    version = "1.0.13";
  };
  recog = {
    dependencies = ["nokogiri"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h023ykrrra74bpbibkyg083kafaswvraw4naw9p1ghcjzn9ggj3";
      type = "gem";
    };
    version = "2.1.12";
  };
  redcarpet = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h9qz2hik4s9knpmbwrzb3jcp3vc5vygp9ya8lcpl7f1l9khmcd7";
      type = "gem";
    };
    version = "3.4.0";
  };
  rex-arch = {
    dependencies = ["rex-text"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1izzalmjwdyib8y0xlgys8qb60di6xyjk485ylgh14p47wkyc6yp";
      type = "gem";
    };
    version = "0.1.11";
  };
  rex-bin_tools = {
    dependencies = ["metasm" "rex-arch" "rex-core" "rex-struct2" "rex-text"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01hi1cjr68adp47nxbjfprvn0r3b72r4ib82x9j33bf2pny6nvaw";
      type = "gem";
    };
    version = "0.1.4";
  };
  rex-core = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16dwf4pw7bpx8xvlv241imxvwhvjfv0cw9kl7ipsv40yazy5lzpk";
      type = "gem";
    };
    version = "0.1.12";
  };
  rex-encoder = {
    dependencies = ["metasm" "rex-arch" "rex-text"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zm5jdxgyyp8pkfqwin34izpxdrmglx6vmk20ifnvcsm55c9m70z";
      type = "gem";
    };
    version = "0.1.4";
  };
  rex-exploitation = {
    dependencies = ["jsobfu" "metasm" "rex-arch" "rex-encoder" "rex-text"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gbj28jqaaldpk4qzysgcl6m0wcqx3gcldarqdk55p5z9zasrk19";
      type = "gem";
    };
    version = "0.1.14";
  };
  rex-java = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0j58k02p5g9snkpak64sb4aymkrvrh9xpqh8wsnya4w7b86w2y6i";
      type = "gem";
    };
    version = "0.1.5";
  };
  rex-mime = {
    dependencies = ["rex-text"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15a14kz429h7pn81ysa6av3qijxjmxagjff6dyss5v394fxzxf4a";
      type = "gem";
    };
    version = "0.1.5";
  };
  rex-nop = {
    dependencies = ["rex-arch"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0aigf9qsqsmiraa6zvfy1a7cyvf7zc3iyhzxi6fjv5sb8f64d6ny";
      type = "gem";
    };
    version = "0.1.1";
  };
  rex-ole = {
    dependencies = ["rex-text"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pnzbqfnvbs0vc0z0ryszk3fxhgxrjd6gzwqa937rhlphwp5jpww";
      type = "gem";
    };
    version = "0.1.6";
  };
  rex-powershell = {
    dependencies = ["rex-random_identifier" "rex-text"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nl60fdd1rlckk95d3s3y873w84vb0sgwvwxdzv414qxz8icpjnm";
      type = "gem";
    };
    version = "0.1.72";
  };
  rex-random_identifier = {
    dependencies = ["rex-text"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cksrljaw61mdjvbmj9vqqhd8nra7jv466w5nim47n73rj72jc19";
      type = "gem";
    };
    version = "0.1.2";
  };
  rex-registry = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wv812ghnz143vx10ixmv32ypj1xrzr4rh4kgam8d8wwjwxsgw1q";
      type = "gem";
    };
    version = "0.1.3";
  };
  rex-rop_builder = {
    dependencies = ["metasm" "rex-core" "rex-text"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xjd3d6wnbq4ym0d0m268md8fb16f2hbwrahvxnl14q63fj9i3wy";
      type = "gem";
    };
    version = "0.1.3";
  };
  rex-socket = {
    dependencies = ["rex-core"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bkr64qrfy2mcv6cpp2z2rn9npgn9s0yyagzjh7kawbm80ldwf2h";
      type = "gem";
    };
    version = "0.1.8";
  };
  rex-sslscan = {
    dependencies = ["rex-core" "rex-socket" "rex-text"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06gbx45q653ajcx099p0yxdqqxazfznbrqshd4nwiwg1p498lmyx";
      type = "gem";
    };
    version = "0.1.5";
  };
  rex-struct2 = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nbdn53264a20cr2m2nq2v4mg0n33dvrd1jj1sixl37qjzw2k452";
      type = "gem";
    };
    version = "0.1.2";
  };
  rex-text = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "024miva867h4wv4y1lnxxrw2d7p51va32ismxqf3fsz4s9cqc88m";
      type = "gem";
    };
    version = "0.2.15";
  };
  rex-zip = {
    dependencies = ["rex-text"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mbfryyhcw47i7jb8cs8vilbyqgyiyjkfl1ngl6wdbf7d87dwdw7";
      type = "gem";
    };
    version = "0.1.3";
  };
  rkelly-remix = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g7hjl9nx7f953y7lncmfgp0xgxfxvgfm367q6da9niik6rp1y3j";
      type = "gem";
    };
    version = "0.0.7";
  };
  robots = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "141gvihcr2c0dpzl3dqyh8kqc9121prfdql2iamaaw0mf9qs3njs";
      type = "gem";
    };
    version = "0.10.1";
  };
  ruby-rc4 = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00vci475258mmbvsdqkmqadlwn6gj9m01sp7b5a3zd90knil1k00";
      type = "gem";
    };
    version = "0.1.5";
  };
  ruby_smb = {
    dependencies = ["bindata" "rubyntlm" "windows_error"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jby5wlppxhc2jlqldic05aqd5l57171lsxqv86702grk665n612";
      type = "gem";
    };
    version = "0.0.18";
  };
  rubyntlm = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p6bxsklkbcqni4bcq6jajc2n57g0w5rzn4r49c3lb04wz5xg0dy";
      type = "gem";
    };
    version = "0.6.2";
  };
  rubyzip = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06js4gznzgh8ac2ldvmjcmg9v1vg9llm357yckkpylaj6z456zqz";
      type = "gem";
    };
    version = "1.2.1";
  };
  sawyer = {
    dependencies = ["addressable" "faraday"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sv1463r7bqzvx4drqdmd36m7rrv6sf1v3c6vswpnq3k6vdw2dvd";
      type = "gem";
    };
    version = "0.8.1";
  };
  sqlite3 = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01ifzp8nwzqppda419c9wcvr8n82ysmisrs0hph9pdmv1lpa4f5i";
      type = "gem";
    };
    version = "1.3.13";
  };
  sshkey = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0g02lh50jd5z4l9bp7xirnfn3n1dh9lr06dv3xh0kr3yhsny059h";
      type = "gem";
    };
    version = "1.9.0";
  };
  thor = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nmqpyj642sk4g16nkbq6pj856adpv91lp4krwhqkh2iw63aszdl";
      type = "gem";
    };
    version = "0.20.0";
  };
  thread_safe = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nmhcgq6cgz44srylra07bmaw99f5271l0dpsvl5f75m44l0gmwy";
      type = "gem";
    };
    version = "0.3.6";
  };
  ttfunk = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mgrnqla5n51v4ivn844albsajkck7k6lviphfqa8470r46c58cd";
      type = "gem";
    };
    version = "1.5.1";
  };
  tzinfo = {
    dependencies = ["thread_safe"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05r81lk7q7275rdq7xipfm0yxgqyd2ggh73xpc98ypngcclqcscl";
      type = "gem";
    };
    version = "1.2.3";
  };
  tzinfo-data = {
    dependencies = ["tzinfo"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1n83rmy476d4qmzq74qx0j7lbcpskbvrj1bmy3np4d5pydyw2yky";
      type = "gem";
    };
    version = "1.2017.2";
  };
  windows_error = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kbcv9j5sc7pvjzf1dkp6h69i6lmj205zyy2arxcfgqg11bsz2kp";
      type = "gem";
    };
    version = "0.1.2";
  };
  xdr = {
    dependencies = ["activemodel" "activesupport"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0c5cp1k4ij3xq1q6fb0f6xv5b65wy18y7bhwvsdx8wd0zyg3x96m";
      type = "gem";
    };
    version = "2.0.0";
  };
  xmlrpc = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1s744iwblw262gj357pky3d9fcx9hisvla7rnw29ysn5zsb6i683";
      type = "gem";
    };
    version = "0.3.0";
  };
}