{
  addressable = {
    dependencies = ["public_suffix"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0viqszpkggqi8hq87pqp0xykhvz60g99nwmkwsb0v45kc2liwxvk";
      type = "gem";
    };
    version = "2.5.2";
  };
  app_conf = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yqwhr7d9i0cgavqkkq0b4pfqpn213dbhj5ayygr293wplm0jh57";
      type = "gem";
    };
    version = "0.4.2";
  };
  ast = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pp82blr5fakdk27d1d21xq9zchzb6vmyb1zcsl520s3ygvprn8m";
      type = "gem";
    };
    version = "2.3.0";
  };
  backports = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1agsk23kfr194s690jnrpijh9pf3hq4a9yy66j1wzzj2x19ss9y0";
      type = "gem";
    };
    version = "3.10.3";
  };
  berkshelf = {
    dependencies = ["buff-config" "buff-extensions" "chef" "cleanroom" "concurrent-ruby" "faraday" "httpclient" "minitar" "mixlib-archive" "mixlib-shellout" "octokit" "retryable" "ridley" "solve" "thor"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03rwq5njxh3d3fcr3ap0wivqlavfcm1ywxj50m4arfndsdvvjih1";
      type = "gem";
    };
    version = "6.3.1";
  };
  buff-config = {
    dependencies = ["buff-extensions" "varia_model"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06zx175sww4grk1rwyn1g3b1j2y324jf1506wl4xx96iss8spa4r";
      type = "gem";
    };
    version = "2.0.0";
  };
  buff-extensions = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qjyx97b9gavrk1r77bif1wv7z2mwlqy0v42q0vb7jd609n7vgcg";
      type = "gem";
    };
    version = "2.0.0";
  };
  buff-ignore = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vn0jh4l8np1xlyvsrrhlzhapcwvrjfni92jmg1an5qdw1qlgxmh";
      type = "gem";
    };
    version = "1.2.0";
  };
  buff-ruby_engine = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1njpndvhvq7idfrwfw3p0hs5ch6nygwscjmksh23dz49dsirk7a9";
      type = "gem";
    };
    version = "1.0.0";
  };
  buff-shell_out = {
    dependencies = ["buff-ruby_engine"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zg1li17759whsi2yhb08wvbbqn5cy6i5v51384yjk2a29vs9lck";
      type = "gem";
    };
    version = "1.1.0";
  };
  builder = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qibi5s67lpdv1wgcj66wcymcr04q6j4mzws6a479n0mlrmh5wr1";
      type = "gem";
    };
    version = "3.2.3";
  };
  celluloid = {
    dependencies = ["timers"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "044xk0y7i1xjafzv7blzj5r56s7zr8nzb619arkrl390mf19jxv3";
      type = "gem";
    };
    version = "0.16.0";
  };
  celluloid-io = {
    dependencies = ["celluloid" "nio4r"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1l1x0p6daa5vskywrvaxdlanwib3k5pps16axwyy4p8d49pn9rnx";
      type = "gem";
    };
    version = "0.16.2";
  };
  chef = {
    dependencies = ["addressable" "chef-config" "chef-zero" "diff-lcs" "erubis" "ffi-yajl" "highline" "iniparse" "iso8601" "mixlib-archive" "mixlib-authentication" "mixlib-cli" "mixlib-log" "mixlib-shellout" "net-sftp" "net-ssh" "net-ssh-multi" "ohai" "plist" "proxifier" "rspec-core" "rspec-expectations" "rspec-mocks" "rspec_junit_formatter" "serverspec" "specinfra" "syslog-logger" "uuidtools"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1whvkx1a3877vnpv6q84bp9sb4aq5p5hgv9frln90l61f5nrx1gb";
      type = "gem";
    };
    version = "13.6.4";
  };
  chef-config = {
    dependencies = ["addressable" "fuzzyurl" "mixlib-config" "mixlib-shellout"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0r5bd2901bwcr8zffhvri1ypkqfmqinbg78aj0xnndg6lkbr9rd5";
      type = "gem";
    };
    version = "13.6.4";
  };
  chef-dk = {
    dependencies = ["addressable" "chef" "chef-provisioning" "cookbook-omnifetch" "diff-lcs" "ffi-yajl" "minitar" "mixlib-cli" "mixlib-shellout" "paint" "solve"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zqbwkad61rn4wli6z8a7l7glfnnrhbg474vfshvr0k1sicy8z2d";
      type = "gem";
    };
    version = "2.4.17";
  };
  chef-provisioning = {
    dependencies = ["cheffish" "inifile" "mixlib-install" "net-scp" "net-ssh" "net-ssh-gateway" "winrm" "winrm-elevated" "winrm-fs"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mxax73kblcbsz5bzqc655igbjwqjpl5f7vz478afr6amh3lsxsw";
      type = "gem";
    };
    version = "2.6.0";
  };
  chef-vault = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ks248hqd3s9w0nq8pnpp6and3522b128f2avg63cx5gq6889hwh";
      type = "gem";
    };
    version = "3.3.0";
  };
  chef-zero = {
    dependencies = ["ffi-yajl" "hashie" "mixlib-log" "rack" "uuidtools"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nzmc0fzi73k692j09zipm3gqx1fkrw4r4r4g2b3i1zvasaxbi7x";
      type = "gem";
    };
    version = "13.1.0";
  };
  cheffish = {
    dependencies = ["chef-zero" "net-ssh"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mpyf9bhnxil5mwy8cffcfl5l9alxhdnjzsmpzcdwihbz401qrn3";
      type = "gem";
    };
    version = "13.1.0";
  };
  chefspec = {
    dependencies = ["chef" "fauxhai" "rspec"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zpycdwp18k6nkgyx7l3ndhyaby1v4bfqh9by6ld2fbksnx29p6k";
      type = "gem";
    };
    version = "7.1.1";
  };
  cleanroom = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1r6qa4b248jasv34vh7rw91pm61gzf8g5dvwx2gxrshjs7vbhfml";
      type = "gem";
    };
    version = "1.0.0";
  };
  coderay = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15vav4bhcc2x3jmi3izb11l4d9f3xv8hp2fszb7iqmpsccv1pz4y";
      type = "gem";
    };
    version = "1.1.2";
  };
  concurrent-ruby = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "183lszf5gx84kcpb779v6a2y0mx9sssy8dgppng1z9a505nj1qcf";
      type = "gem";
    };
    version = "1.0.5";
  };
  cookbook-omnifetch = {
    dependencies = ["mixlib-archive"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dm93zjr2a9pappkncnw4hlrn7dl9vwmrx5xly4128rnzbcgn41p";
      type = "gem";
    };
    version = "0.8.0";
  };
  cucumber-core = {
    dependencies = ["backports" "cucumber-tag_expressions" "gherkin"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06lip8ds4lw3wyjwsjv1laimk5kz39vsmvv9if7hiq9v611kd3sn";
      type = "gem";
    };
    version = "3.1.0";
  };
  cucumber-tag_expressions = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cvmbljybws0qzjs1l67fvr9gqr005l8jk1ni5gcsis9pfmqh3vc";
      type = "gem";
    };
    version = "1.1.1";
  };
  diff-lcs = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18w22bjz424gzafv6nzv98h0aqkwz3d9xhm7cbr1wfbyas8zayza";
      type = "gem";
    };
    version = "1.3";
  };
  diffy = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "015nn9zaciqj43mfpjlw619r5dvnfkrjcka8nsa6j260v6qya941";
      type = "gem";
    };
    version = "3.2.0";
  };
  docker-api = {
    dependencies = ["excon" "multi_json"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09wsm6ims9gndfkh1ndhq3mps581g0slmvlvcdmsjfjb3qgm6fj5";
      type = "gem";
    };
    version = "1.34.0";
  };
  erubis = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fj827xqjs91yqsydf0zmfyw9p4l2jz5yikg3mppz6d7fi8kyrb3";
      type = "gem";
    };
    version = "2.7.0";
  };
  excon = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mnc9lqlzwqj5ayp0lh7impisqm55mdg3mw5q4gi9yjic5sidc40";
      type = "gem";
    };
    version = "0.59.0";
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
  fauxhai = {
    dependencies = ["net-ssh"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0145yfn48qh64wbr55lzs1xjd6fi0z9000ix1z086dziks508c2v";
      type = "gem";
    };
    version = "5.5.0";
  };
  ffi = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "034f52xf7zcqgbvwbl20jwdyjwznvqnwpbaps9nk18v9lgb1dpx0";
      type = "gem";
    };
    version = "1.9.18";
  };
  ffi-yajl = {
    dependencies = ["libyajl2"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mv7h8bjzgv96kpbmgkmg43rwy96w54kg39vldcdwym6kpqyfgr5";
      type = "gem";
    };
    version = "2.3.1";
  };
  foodcritic = {
    dependencies = ["cucumber-core" "erubis" "ffi-yajl" "nokogiri" "rake" "rufus-lru" "treetop"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0snnfv95zwv3rc9ilkzvw1pjch8cykkxq5q42ckx9zr9yd4bzmhz";
      type = "gem";
    };
    version = "12.2.1";
  };
  fuzzyurl = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03qchs33vfwbsv5awxg3acfmlcrf5xbhnbrc83fdpamwya0glbjl";
      type = "gem";
    };
    version = "0.9.0";
  };
  gherkin = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0arfhyjcsf5bv1anj4ysqhgl621nwl9qfcs7gg20y3sapcjwl2y7";
      type = "gem";
    };
    version = "5.0.0";
  };
  git = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1waikaggw7a1d24nw0sh8fd419gbf7awh000qhsf411valycj6q3";
      type = "gem";
    };
    version = "1.3.0";
  };
  gssapi = {
    dependencies = ["ffi"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0j93nsf9j57p7x4aafalvjg8hia2mmqv3aky7fmw2ck5yci343ix";
      type = "gem";
    };
    version = "1.2.0";
  };
  gyoku = {
    dependencies = ["builder"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wn0sl14396g5lyvp8sjmcb1hw9rbyi89gxng91r7w4df4jwiidh";
      type = "gem";
    };
    version = "1.3.1";
  };
  hashie = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "120mkd2hkwhcfj7avi1dphb0lm7wx364d1cjm9yr4fibqpvsgqi7";
      type = "gem";
    };
    version = "3.5.6";
  };
  highline = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01ib7jp85xjc4gh4jg0wyzllm46hwv8p0w1m4c75pbgi41fps50y";
      type = "gem";
    };
    version = "1.7.10";
  };
  hitimes = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06222h9236jw9jgmdlpi0q7psac1shvxqxqx905qkvabmxdxlfar";
      type = "gem";
    };
    version = "1.2.6";
  };
  htmlentities = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nkklqsn8ir8wizzlakncfv42i32wc0w9hxp00hvdlgjr7376nhj";
      type = "gem";
    };
    version = "4.3.4";
  };
  httpclient = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19mxmvghp7ki3klsxwrlwr431li7hm1lczhhj8z4qihl2acy8l99";
      type = "gem";
    };
    version = "2.8.3";
  };
  inifile = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1c5zmk7ia63yw5l2k14qhfdydxwi1sah1ppjdiicr4zcalvfn0xi";
      type = "gem";
    };
    version = "3.0.0";
  };
  iniparse = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xbik6838gfh5yq9ahh1m7dzszxlk0g7x5lvhb8amk60mafkrgws";
      type = "gem";
    };
    version = "1.4.4";
  };
  inspec = {
    dependencies = ["addressable" "faraday" "hashie" "htmlentities" "json" "method_source" "mixlib-log" "parallel" "parslet" "pry" "rainbow" "rspec" "rspec-its" "rubyzip" "semverse" "sslshake" "thor" "tomlrb" "train"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yvmqdhpag7v6m9z1mcwqj6y1rnrx6hbqws0lhh1zp4xky3w7fn4";
      type = "gem";
    };
    version = "1.47.0";
  };
  ipaddress = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1x86s0s11w202j6ka40jbmywkrx8fhq8xiy8mwvnkhllj57hqr45";
      type = "gem";
    };
    version = "0.8.3";
  };
  iso8601 = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0diaqrf9lxmjamasydmd8mbc9p1lh01mb2d9y66kd1mmi7ml85yp";
      type = "gem";
    };
    version = "0.9.1";
  };
  json = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01v6jjpvh3gnq6sgllpfqahlgxzj50ailwhj9b3cd20hi2dx0vxp";
      type = "gem";
    };
    version = "2.1.0";
  };
  kitchen-inspec = {
    dependencies = ["hashie" "inspec" "test-kitchen"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0giqlpwhc7d91245pa9wkjad6ag6wd0q1757kwxmpgz4rh59xwnz";
      type = "gem";
    };
    version = "0.20.0";
  };
  kitchen-vagrant = {
    dependencies = ["test-kitchen"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nd09fwk6ncb6rflhl8pwfnq8iyhfzrfqdx4pyhjqq18n5pp3nk6";
      type = "gem";
    };
    version = "1.2.1";
  };
  knife-spork = {
    dependencies = ["app_conf" "chef" "diffy" "git"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h9ifjwlqhav04j40psmz22vdz1s3xvq35kzqyc22ir3w6s9nrlj";
      type = "gem";
    };
    version = "1.7.1";
  };
  libyajl2 = {
    source = {
      sha256 = "0n5j0p8dxf9xzb9n4bkdr8w0a8gg3jzrn9indri3n0fv90gcs5qi";
      type = "gem";
    };
    version = "1.2.0";
  };
  little-plugger = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1frilv82dyxnlg8k1jhrvyd73l6k17mxc5vwxx080r4x1p04gwym";
      type = "gem";
    };
    version = "1.1.4";
  };
  logging = {
    dependencies = ["little-plugger" "multi_json"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06j6iaj89h9jhkx1x3hlswqrfnqds8br05xb1qra69dpvbdmjcwn";
      type = "gem";
    };
    version = "2.2.2";
  };
  method_source = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xqj21j3vfq4ldia6i2akhn2qd84m0iqcnsl49kfpq3xk6x0dzgn";
      type = "gem";
    };
    version = "0.9.0";
  };
  mini_portile2 = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13d32jjadpjj6d2wdhkfpsmy68zjx90p49bgf8f7nkpz86r1fr11";
      type = "gem";
    };
    version = "2.3.0";
  };
  minitar = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vpdjfmdq1yc4i620frfp9af02ia435dnpj8ybsd7dc3rypkvbka";
      type = "gem";
    };
    version = "0.5.4";
  };
  mixlib-archive = {
    dependencies = ["mixlib-log"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1b56iprv8cdhxjpzb8ck0mc54cl0kmyzlkn6bzzdqws4gxvdf6gk";
      type = "gem";
    };
    version = "0.4.1";
  };
  mixlib-authentication = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lh8vrkq2nnf0rx69mlyiqkx664baxbp32imb7l517lbcw5xspgb";
      type = "gem";
    };
    version = "1.4.2";
  };
  mixlib-cli = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0647msh7kp7lzyf6m72g6snpirvhimjm22qb8xgv9pdhbcrmcccp";
      type = "gem";
    };
    version = "1.7.0";
  };
  mixlib-config = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0s2ag6jz59r1gn8rbhf5c1g2mpbkc5jmz2fxh3n7hzv80dfzk42w";
      type = "gem";
    };
    version = "2.2.4";
  };
  mixlib-install = {
    dependencies = ["mixlib-shellout" "mixlib-versioning" "thor"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rsi3f3rcg3vky3biy59rvllk3wvx8xnyfch0d4h74r6sxcgbf79";
      type = "gem";
    };
    version = "3.8.0";
  };
  mixlib-log = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14sknyi9r7rg28m21c8ixzyndhbmi0d6vk02y4hf42dd60hmdbgp";
      type = "gem";
    };
    version = "1.7.1";
  };
  mixlib-shellout = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1aszrg8b6nrsb3avdm2x04f2n0xx81rdip0waxibkqpslcmb8zx5";
      type = "gem";
    };
    version = "2.3.2";
  };
  mixlib-versioning = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04ayjzsqqgi0ax8c657wwnmclxh53jvn82mnsf7jb2h7fzlb59v3";
      type = "gem";
    };
    version = "1.2.2";
  };
  molinillo = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hiy8qvk7hsy5bl5x5b19zf3v3qbmcpa0a9w1kywhvd9051a9vnr";
      type = "gem";
    };
    version = "0.6.4";
  };
  multi_json = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1raim9ddjh672m32psaa9niw67ywzjbxbdb8iijx3wv9k5b0pk2x";
      type = "gem";
    };
    version = "1.12.2";
  };
  multipart-post = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09k0b3cybqilk1gwrwwain95rdypixb2q9w65gd44gfzsd84xi1x";
      type = "gem";
    };
    version = "2.0.0";
  };
  net-scp = {
    dependencies = ["net-ssh"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0b0jqrcsp4bbi4n4mzyf70cp2ysyp6x07j8k8cqgxnvb4i3a134j";
      type = "gem";
    };
    version = "1.2.1";
  };
  net-sftp = {
    dependencies = ["net-ssh"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04674g4n6mryjajlcd82af8g8k95la4b1bj712dh71hw1c9vhw1y";
      type = "gem";
    };
    version = "2.1.2";
  };
  net-ssh = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07c4v97zl1daabmri9zlbzs6yvkl56z1q14bw74d53jdj0c17nhx";
      type = "gem";
    };
    version = "4.2.0";
  };
  net-ssh-gateway = {
    dependencies = ["net-ssh"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04ws9bvf3ppvcj9vrnwyabcwv4lz1m66ni443z2cf4wvvqssifsa";
      type = "gem";
    };
    version = "1.3.0";
  };
  net-ssh-multi = {
    dependencies = ["net-ssh" "net-ssh-gateway"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13kxz9b6kgr9mcds44zpavbndxyi6pvyzyda6bhk1kfmb5c10m71";
      type = "gem";
    };
    version = "1.2.1";
  };
  net-telnet = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13qxznpwmc3hs51b76wqx2w29r158gzzh8719kv2gpi56844c8fx";
      type = "gem";
    };
    version = "0.1.1";
  };
  nio4r = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1n7csawahihc4z0d1888l2c9hlxxd06m093c58gkp1mcbj9bvyb0";
      type = "gem";
    };
    version = "2.1.0";
  };
  nokogiri = {
    dependencies = ["mini_portile2"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "105xh2zkr8nsyfaj2izaisarpnkrrl9000y3nyflg9cbzrfxv021";
      type = "gem";
    };
    version = "1.8.1";
  };
  nori = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "066wc774a2zp4vrq3k7k8p0fhv30ymqmxma1jj7yg5735zls8agn";
      type = "gem";
    };
    version = "2.6.0";
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
  ohai = {
    dependencies = ["chef-config" "ffi" "ffi-yajl" "ipaddress" "mixlib-cli" "mixlib-config" "mixlib-log" "mixlib-shellout" "plist" "systemu" "wmi-lite"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05dx2nsswcnd9f7qvz4jgiwwh18z4qbx6mqvflzlx276adx68i0s";
      type = "gem";
    };
    version = "13.7.0";
  };
  paint = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1z1fqyyc2jiv6yabv467h652cxr2lmxl5gqqg7p14y28kdqf0nhj";
      type = "gem";
    };
    version = "1.0.1";
  };
  parallel = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qv2yj4sxr36ga6xdxvbq9h05hn10bwcbkqv6j6q1fiixhsdnnzd";
      type = "gem";
    };
    version = "1.12.0";
  };
  parser = {
    dependencies = ["ast"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bqc29xx4zwlshvi6krrd0sl82d7xjfhcrxvgf38wvdqcl3b7ck3";
      type = "gem";
    };
    version = "2.4.0.2";
  };
  parslet = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15ls4zgarhic522r767nbsfn7hddrhd7zv8hvlx5flas8b2ybirf";
      type = "gem";
    };
    version = "1.8.1";
  };
  plist = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0k0pyqrjcz9kn1b3ahsfs9aqym7s7yzz0vavya0zn0mca3jw2zqc";
      type = "gem";
    };
    version = "3.3.0";
  };
  polyglot = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bqnxwyip623d8pr29rg6m8r0hdg08fpr2yb74f46rn1wgsnxmjr";
      type = "gem";
    };
    version = "0.3.5";
  };
  powerpack = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fnn3fli5wkzyjl4ryh0k90316shqjfnhydmc7f8lqpi0q21va43";
      type = "gem";
    };
    version = "0.1.1";
  };
  proxifier = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1abzlg39cfji1nx3i8kmb5k3anr2rd392yg2icms24wkqz9g9zj0";
      type = "gem";
    };
    version = "1.0.3";
  };
  pry = {
    dependencies = ["coderay" "method_source"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mh312k3y94sj0pi160wpia0ps8f4kmzvm505i6bvwynfdh7v30g";
      type = "gem";
    };
    version = "0.11.3";
  };
  public_suffix = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mvzd9ycjw8ydb9qy3daq3kdzqs2vpqvac4dqss6ckk4rfcjc637";
      type = "gem";
    };
    version = "3.0.1";
  };
  rack = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pcgv8dv4vkaczzlix8q3j68capwhk420cddzijwqgi2qb4lm1zm";
      type = "gem";
    };
    version = "2.0.6";
  };
  rainbow = {
    dependencies = ["rake"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08w2ghc5nv0kcq5b257h7dwjzjz1pqcavajfdx2xjyxqsvh2y34w";
      type = "gem";
    };
    version = "2.2.2";
  };
  rake = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "190p7cs8zdn07mjj6xwwsdna3g0r98zs4crz7jh2j2q5b0nbxgjf";
      type = "gem";
    };
    version = "12.3.0";
  };
  retryable = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pxv5xgr08s9gv5npj7h3raxibywznrv2wcrb85ibhlhzgzcxggf";
      type = "gem";
    };
    version = "2.0.4";
  };
  ridley = {
    dependencies = ["addressable" "buff-config" "buff-extensions" "buff-ignore" "buff-shell_out" "celluloid" "celluloid-io" "chef-config" "erubis" "faraday" "hashie" "httpclient" "json" "mixlib-authentication" "retryable" "semverse" "varia_model"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0n2ykdnr1cn9fk8ns2dh3qf7g5dywl8p8kw4zbw4amb4v5xlkwjh";
      type = "gem";
    };
    version = "5.1.1";
  };
  rspec = {
    dependencies = ["rspec-core" "rspec-expectations" "rspec-mocks"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0134g96wzxjlig2gxzd240gm2dxfw8izcyi2h6hjmr40syzcyx01";
      type = "gem";
    };
    version = "3.7.0";
  };
  rspec-core = {
    dependencies = ["rspec-support"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15c4mgivvs9hpi0i1a8gypdl1f0hg6xknsbizgpm3khc95lqd9r9";
      type = "gem";
    };
    version = "3.7.0";
  };
  rspec-expectations = {
    dependencies = ["diff-lcs" "rspec-support"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fw06wm8jdj8k7wrb8xmzj0fr1wjyb0ya13x31hidnyblm41hmvy";
      type = "gem";
    };
    version = "3.7.0";
  };
  rspec-its = {
    dependencies = ["rspec-core" "rspec-expectations"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pwphny5jawcm1hda3vs9pjv1cybaxy17dc1s75qd7drrvx697p3";
      type = "gem";
    };
    version = "1.2.0";
  };
  rspec-mocks = {
    dependencies = ["diff-lcs" "rspec-support"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0b02ya3qhqgmcywqv4570dlhav70r656f7dmvwg89whpkq1z1xr3";
      type = "gem";
    };
    version = "3.7.0";
  };
  rspec-support = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hvpqpkh7j5rbwkkc0qwicwpgn0xlnpq935ikmx8n1wxxf553v3p";
      type = "gem";
    };
    version = "3.7.0";
  };
  rspec_junit_formatter = {
    dependencies = ["builder" "rspec-core"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hphl8iggqh1mpbbv0avf8735x6jgry5wmkqyzgv1zwnimvja1ai";
      type = "gem";
    };
    version = "0.2.3";
  };
  rubocop = {
    dependencies = ["parallel" "parser" "powerpack" "rainbow" "ruby-progressbar" "unicode-display_width"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cy2plq67b47ql06ypx3svbnnjmr2q616scwyhfd6330cg0aacf1";
      type = "gem";
    };
    version = "0.51.0";
  };
  ruby-progressbar = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1igh1xivf5h5g3y5m9b4i4j2mhz2r43kngh4ww3q1r80ch21nbfk";
      type = "gem";
    };
    version = "1.9.0";
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
  rufus-lru = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sp7ymz054md75fnn2hx5d2axmhrh0abbn8c2p759j4g4lxn11ip";
      type = "gem";
    };
    version = "1.1.0";
  };
  safe_yaml = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hly915584hyi9q9vgd968x2nsi5yag9jyf5kq60lwzi5scr7094";
      type = "gem";
    };
    version = "1.0.4";
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
  semverse = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cf6iv5wgwb7b8jf7il751223k9yahz9aym06s9r0prda5mwddyy";
      type = "gem";
    };
    version = "2.0.0";
  };
  serverspec = {
    dependencies = ["multi_json" "rspec" "rspec-its" "specinfra"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zsi7nb7mn6jsxbs6gbbkavmbnpdpk9xn2rsd5hbayzmqnb7qk43";
      type = "gem";
    };
    version = "2.41.3";
  };
  sfl = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qm4hvhq9pszi9zs1cl9qgwx1n4wxq0af0hq9sbf6qihqd8rwwwr";
      type = "gem";
    };
    version = "2.3";
  };
  solve = {
    dependencies = ["molinillo" "semverse"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08jywdc6wgfb57ncjnsdjb694fzq8aqw0iv289nijpw5hccd32g4";
      type = "gem";
    };
    version = "4.0.0";
  };
  specinfra = {
    dependencies = ["net-scp" "net-ssh" "net-telnet" "sfl"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1dh4ydl4rr6dc8dw9nqns9z3d4f5inmpjnspnvgppvy9hk9lnx9h";
      type = "gem";
    };
    version = "2.72.1";
  };
  sslshake = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19j8q4mnjvjnhlbzs9r0pn608bv5a4cihf6lswv36l3lc35gp9zl";
      type = "gem";
    };
    version = "1.2.0";
  };
  syslog-logger = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14y20phq1khdla4z9wvf98k7j3x6n0rjgs4f7vb0xlf7h53g6hbm";
      type = "gem";
    };
    version = "1.6.8";
  };
  systemu = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gmkbakhfci5wnmbfx5i54f25j9zsvbw858yg3jjhfs5n4ad1xq1";
      type = "gem";
    };
    version = "2.6.5";
  };
  test-kitchen = {
    dependencies = ["mixlib-install" "mixlib-shellout" "net-scp" "net-ssh" "net-ssh-gateway" "safe_yaml" "thor" "winrm" "winrm-elevated" "winrm-fs"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wypsc0yl5zgw4f39i8nwq35z0lnjpqx333w9ginmiifs9jydlvm";
      type = "gem";
    };
    version = "1.19.2";
  };
  thor = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08p5gx18yrbnwc6xc0mxvsfaxzgy2y9i78xq7ds0qmdm67q39y4z";
      type = "gem";
    };
    version = "0.19.1";
  };
  timers = {
    dependencies = ["hitimes"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jx4wb0x182gmbcs90vz0wzfyp8afi1mpl9w5ippfncyk4kffvrz";
      type = "gem";
    };
    version = "4.0.4";
  };
  tomlrb = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09gh67v8s1pr7c37490sjp782gi4wf9k9cadp4l926h1sp27bcgz";
      type = "gem";
    };
    version = "1.2.6";
  };
  train = {
    dependencies = ["docker-api" "json" "mixlib-shellout" "net-scp" "net-ssh" "winrm" "winrm-fs"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ic719ghmyvf93p4y91y00rc09s946sg4n1h855yip9h5795q9i5";
      type = "gem";
    };
    version = "0.31.1";
  };
  treetop = {
    dependencies = ["polyglot"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sdkd1v2h8dhj9ncsnpywmqv7w1mdwsyc5jwyxlxwriacv8qz8bd";
      type = "gem";
    };
    version = "1.6.9";
  };
  unicode-display_width = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12pi0gwqdnbx1lv5136v3vyr0img9wr0kxcn4wn54ipq4y41zxq8";
      type = "gem";
    };
    version = "1.3.0";
  };
  uuidtools = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zjvq1jrrnzj69ylmz1xcr30skf9ymmvjmdwbvscncd7zkr8av5g";
      type = "gem";
    };
    version = "2.1.5";
  };
  varia_model = {
    dependencies = ["buff-extensions" "hashie"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kgj37rc3yia4pr5pma0psgar6xjk064qdfii3nwr6dj1v73cyxz";
      type = "gem";
    };
    version = "0.6.0";
  };
  winrm = {
    dependencies = ["builder" "erubis" "gssapi" "gyoku" "httpclient" "logging" "nori" "rubyntlm"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02lzbixdbjvhmb0byqx9rl9x4xx9pqc8jwm7y6mmp7w7mri72zh6";
      type = "gem";
    };
    version = "2.2.3";
  };
  winrm-elevated = {
    dependencies = ["winrm" "winrm-fs"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04krbwnj4cw7jy42w3n2y5kp2fbcp3v9mbf59pdhfk1py18bswcr";
      type = "gem";
    };
    version = "1.1.0";
  };
  winrm-fs = {
    dependencies = ["erubis" "logging" "rubyzip" "winrm"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vax34qbr3n6jifxyzr4nngaz8vrmzw6ydw21cnnrhidfkqgh7ja";
      type = "gem";
    };
    version = "1.1.1";
  };
  wmi-lite = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06pm7jr2gcnphhhswha2kqw0vhxy91i68942s7gqriadbc8pq9z3";
      type = "gem";
    };
    version = "1.0.0";
  };
}