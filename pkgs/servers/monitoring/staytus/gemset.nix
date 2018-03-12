{
  actioncable = {
    dependencies = ["actionpack" "nio4r" "websocket-driver"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01mpn264z07bixjia4kf1ic2x2hpp455c0l2j9hb0600qznibb2a";
      type = "gem";
    };
    version = "5.1.1";
  };
  actionmailer = {
    dependencies = ["actionpack" "actionview" "activejob" "mail" "rails-dom-testing"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vyvp5kadpvirbl7vflffkc3caz6iajj4bsz2p7511gxprznm8x9";
      type = "gem";
    };
    version = "5.1.1";
  };
  actionpack = {
    dependencies = ["actionview" "activesupport" "rack" "rack-test" "rails-dom-testing" "rails-html-sanitizer"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1a2jh2dfj28ngkynqrd9ff5r3y9r51k19wqnlcq21p9b5gxy1jiq";
      type = "gem";
    };
    version = "5.1.1";
  };
  actionview = {
    dependencies = ["activesupport" "builder" "erubi" "rails-dom-testing" "rails-html-sanitizer"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12rs60dw1fzq0dlq2pmhrb70bnm04hpnp9k07pynx7b10lzzrds0";
      type = "gem";
    };
    version = "5.1.1";
  };
  activejob = {
    dependencies = ["activesupport" "globalid"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gg6cxb3sggddpzg1gwfpvqj1fp5lhnjc44k81gi1f9k7z996rm4";
      type = "gem";
    };
    version = "5.1.1";
  };
  activemodel = {
    dependencies = ["activesupport"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ci68dg3wn9f47634gr9i8qqw9rvqskkwzcsa54lkhgk349ga532";
      type = "gem";
    };
    version = "5.1.1";
  };
  activerecord = {
    dependencies = ["activemodel" "activesupport" "arel"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02zzvl4303rddg24bjj1nwjwcdvk0apbxzg4178691yyjfidph31";
      type = "gem";
    };
    version = "5.1.1";
  };
  activesupport = {
    dependencies = ["concurrent-ruby" "i18n" "minitest" "tzinfo"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09qnkp6yrkqccnxcp89f256fkgxgi3lcyl2gjcxahn0wp2vj53sh";
      type = "gem";
    };
    version = "5.1.1";
  };
  activevalidators = {
    dependencies = ["activemodel" "countries" "credit_card_validations" "date_validator" "mail" "phony" "rake"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14irgl98hja99qba2h1psgh16bhvgcnjg473jxfrvicm02br5n8y";
      type = "gem";
    };
    version = "4.0.2";
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
  annotate = {
    dependencies = ["activerecord" "rake"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vvgmd4xqbhnqicb7dw1px4li1v2wfzr02g2n9qjaax9s4kpz5ax";
      type = "gem";
    };
    version = "2.6.7";
  };
  arel = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nw0qbc6ph625p6n3maqq9f527vz3nbl0hk72fbyka8jzsmplxzl";
      type = "gem";
    };
    version = "8.0.0";
  };
  authie = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07vsbc412418qnfc1c2fhdkag1c3bdqzb4wsaf2869cpf9n09b9p";
      type = "gem";
    };
    version = "3.0.0";
  };
  bcrypt = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1d254sdhdj6mzak3fb5x3jam8b94pvl1srladvs53j05a89j5z50";
      type = "gem";
    };
    version = "3.1.11";
  };
  builder = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qibi5s67lpdv1wgcj66wcymcr04q6j4mzws6a479n0mlrmh5wr1";
      type = "gem";
    };
    version = "3.2.3";
  };
  chronic = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hrdkn4g8x7dlzxwb1rfgr8kw3bp4ywg5l4y4i9c2g5cwv62yvvn";
      type = "gem";
    };
    version = "0.10.2";
  };
  chronic_duration = {
    dependencies = ["numerizer"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1k7sx3xqbrn6s4pishh2pgr4kw6fmw63h00lh503l66k8x0qvigs";
      type = "gem";
    };
    version = "0.10.6";
  };
  coffee-rails = {
    dependencies = ["coffee-script" "railties"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jp81gjcid66ialk5n242y27p3payy0cz6c6i80ik02nx54mq2h8";
      type = "gem";
    };
    version = "4.2.2";
  };
  coffee-script = {
    dependencies = ["coffee-script-source" "execjs"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rc7scyk7mnpfxqv5yy4y5q1hx3i7q3ahplcp4bq2g5r24g2izl2";
      type = "gem";
    };
    version = "2.4.1";
  };
  coffee-script-source = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1907v9q1zcqmmyqzhzych5l7qifgls2rlbnbhy5vzyr7i7yicaz1";
      type = "gem";
    };
    version = "1.12.2";
  };
  concurrent-ruby = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "183lszf5gx84kcpb779v6a2y0mx9sssy8dgppng1z9a505nj1qcf";
      type = "gem";
    };
    version = "1.0.5";
  };
  countries = {
    dependencies = ["currencies" "i18n_data"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1knsfpfwmicbhka4j3xw2nwjn2q9rlcrwvknqh9w1hxzsxavg3aw";
      type = "gem";
    };
    version = "1.2.5";
  };
  credit_card_validations = {
    dependencies = ["activemodel" "activesupport"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gfa8acf3mr1bv1q2bfbcvdq2q4cnqyfh1l5yi8xb476pi0f8yw4";
      type = "gem";
    };
    version = "3.4.0";
  };
  css_parser = {
    dependencies = ["addressable"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jlr17cn044yaq4l3d9p42g3bghnamwsprq9c39xn6pxjrn5k1hy";
      type = "gem";
    };
    version = "1.5.0";
  };
  currencies = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ggp5r4wyja31h678s2zd0z3451j9aqkjfkckyjinz90dy0k6yp2";
      type = "gem";
    };
    version = "0.4.2";
  };
  date_validator = {
    dependencies = ["activemodel" "activesupport"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vaic0l22w7bfh7kli8sclp7w0lg0ccbh1z0qyb0wkfakv41z0yy";
      type = "gem";
    };
    version = "0.9.0";
  };
  datey = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01a1svz8mwjx9y3l7i2pyr3gfcv7i64b7myw7iqc40csk5nbrppm";
      type = "gem";
    };
    version = "1.1.0";
  };
  deep_merge = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11jd70l0vppnm0kwmrvb74acjvcpijqs72km0cgi69ma92g44a0c";
      type = "gem";
    };
    version = "1.1.1";
  };
  delayed_job = {
    dependencies = ["activesupport"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xnja49ssl1iki3xlkgkc16pzlsamnbs0f945blgc0ycdp56q3v6";
      type = "gem";
    };
    version = "4.1.3";
  };
  delayed_job_active_record = {
    dependencies = ["activerecord" "delayed_job"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bf1ck0r9pmd5pqfjzkjhw0w2pzi8gdfdd2j2wc42s5h49qj4zwq";
      type = "gem";
    };
    version = "4.1.2";
  };
  dynamic_form = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06993181dx05dkvrxdr4wc9avy2vjbcx6i8hn8yi7n4r1swsnd9i";
      type = "gem";
    };
    version = "1.1.4";
  };
  erubi = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03wafwyfwydrfbl8wl7s185kq9gf3g2a60axkqh1l80g74cisp1x";
      type = "gem";
    };
    version = "1.6.0";
  };
  execjs = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yz55sf2nd3l666ms6xr18sm2aggcvmb8qr3v53lr4rir32y1yp1";
      type = "gem";
    };
    version = "2.7.0";
  };
  florrick = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gla6ws9g7xl4wdqlym59d5zsc8axm0rdwinh4dqgibw63dzdzbh";
      type = "gem";
    };
    version = "1.1.3";
  };
  foreman = {
    dependencies = ["thor"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06mq39lpmc17bxzlwhad9d8i0lcnbb08xr18smh2x79mm631wsw0";
      type = "gem";
    };
    version = "0.84.0";
  };
  globalid = {
    dependencies = ["activesupport"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cjzw0qwzsmsagz64p15x1s3qrw1nm43dagkc5lc5rcipvcwr2fx";
      type = "gem";
    };
    version = "0.4.0";
  };
  haml = {
    dependencies = ["temple" "tilt"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "035mnasq1vsa9k247xfizxww5ai4b5f8q9hkf4s0jcx0x73d9mb2";
      type = "gem";
    };
    version = "5.0.1";
  };
  htmlentities = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nkklqsn8ir8wizzlakncfv42i32wc0w9hxp00hvdlgjr7376nhj";
      type = "gem";
    };
    version = "4.3.4";
  };
  i18n = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1j491wrfzham4nk8q4bifah3lx7nr8wp9ahfb7vd3hxn71v7kic7";
      type = "gem";
    };
    version = "0.8.4";
  };
  i18n_data = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "118arp9q575wyp1aq58ffmp9dkpclkkrpkmgg2c6m3k33vsxfnwp";
      type = "gem";
    };
    version = "0.7.0";
  };
  jquery-rails = {
    dependencies = ["rails-dom-testing" "railties" "thor"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02ii77vwxc49f2lrkbdzww2168bp5nihwzakc9mqyrsbw394w7ki";
      type = "gem";
    };
    version = "4.3.1";
  };
  json = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qmj7fypgb9vag723w1a49qihxrcf5shzars106ynw2zk352gbv5";
      type = "gem";
    };
    version = "1.8.6";
  };
  kaminari = {
    dependencies = ["actionpack" "activesupport"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14vx3kgssl4lv2kn6grr5v2whsynx5rbl1j9aqiq8nc3d7j74l67";
      type = "gem";
    };
    version = "0.16.3";
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
  mail = {
    dependencies = ["mime-types"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07k8swmv7vgk86clzpjhdlmgahlvg6yzjwy7wcsv0xx400fh4x61";
      type = "gem";
    };
    version = "2.6.5";
  };
  method_source = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g5i4w0dmlhzd18dijlqw5gk27bv6dj2kziqzrzb7mpgxgsd1sf2";
      type = "gem";
    };
    version = "0.8.2";
  };
  mime-types = {
    dependencies = ["mime-types-data"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0087z9kbnlqhci7fxh9f6il63hj1k02icq2rs0c6cppmqchr753m";
      type = "gem";
    };
    version = "3.1";
  };
  mime-types-data = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04my3746hwa4yvbx1ranhfaqkgf6vavi1kyijjnw8w3dy37vqhkm";
      type = "gem";
    };
    version = "3.2016.0521";
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
      sha256 = "11my86fnihvpndyknn3c14hc82nhsgggnhlxh8h3bdjpmfsvl0my";
      type = "gem";
    };
    version = "5.10.2";
  };
  moonrope = {
    dependencies = ["deep_merge" "json" "rack"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zvsb1flhw218lfwayz19kyahgw5yc3s5914m2amsa8cbq3bqldn";
      type = "gem";
    };
    version = "2.0.1";
  };
  mysql2 = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18pinkvflvss3jqlqpnj6vld9m6hcf1jbvbz0338i4s0ddjc9nbg";
      type = "gem";
    };
    version = "0.4.6";
  };
  nifty-attachments = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15fnipz31g5mxk91cvp4yrxyi9jba9fi3ns1mc78dpdmkwwwh15y";
      type = "gem";
    };
    version = "1.0.4";
  };
  nifty-utils = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mlnwkjaxqj1iyhr11spvlj9y62ykghl1p7agdnv8alap9ml25z6";
      type = "gem";
    };
    version = "1.1.7";
  };
  nilify_blanks = {
    dependencies = ["activerecord" "activesupport"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12r3zjxxhbr5bp3qh1v0kcs3qwg0ivxp9yxzjy4ww8spfdm7a766";
      type = "gem";
    };
    version = "1.1.0";
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
      sha256 = "1nffsyx1xjg6v5n9rrbi8y1arrcx2i5f21cp6clgh9iwiqkr7rnn";
      type = "gem";
    };
    version = "1.8.0";
  };
  numerizer = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vrk9jbv4p4dcz0wzr72wrf5kajblhc5l9qf7adbcwi4qvz9xv0h";
      type = "gem";
    };
    version = "0.1.1";
  };
  phony = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xm2dip7pbcgbfgk5ijnz6jpawjcaq080dd8d2d6hsrdzsrsxdyf";
      type = "gem";
    };
    version = "2.15.44";
  };
  premailer = {
    dependencies = ["css_parser" "htmlentities"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ca91l2xx52mzm39j3myny75jfis4iyzpv7w2v12bm4x8jszaxc5";
      type = "gem";
    };
    version = "1.8.7";
  };
  public_suffix = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "040jf98jpp6w140ghkhw2hvc1qx41zvywx5gj7r2ylr1148qnj7q";
      type = "gem";
    };
    version = "2.0.5";
  };
  puma = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1k13n500r7v480rcbxm7k09hip0zi7p8zvy3vajj8g9hb7gdcwnp";
      type = "gem";
    };
    version = "3.9.1";
  };
  rack = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kczgp2zwcrvp257dl8j4y3mnyqflxr7rn4vl9w1rwblznx9n74c";
      type = "gem";
    };
    version = "2.0.3";
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
  rails = {
    dependencies = ["actioncable" "actionmailer" "actionpack" "actionview" "activejob" "activemodel" "activerecord" "activesupport" "railties" "sprockets-rails"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mxf87lq6isw1aqbqi9i9fxrrvkg2fp8jn85yx7hwivh0zfpjphp";
      type = "gem";
    };
    version = "5.1.1";
  };
  rails-dom-testing = {
    dependencies = ["activesupport" "nokogiri"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lfq2a7kp2x64dzzi5p4cjcbiv62vxh9lyqk2f0rqq3fkzrw8h5i";
      type = "gem";
    };
    version = "2.0.3";
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
  rails_env_config = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0glhin4mf0jy178xn6g5mr1hjxi2q1nqpbiq76yq7hx2pmnn6fhc";
      type = "gem";
    };
    version = "1.1.0";
  };
  railties = {
    dependencies = ["actionpack" "activesupport" "method_source" "rake" "thor"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06gk6dsja5302n2i5x94xj0fgqg0a5flg7q7qldix1vykpf0r459";
      type = "gem";
    };
    version = "5.1.1";
  };
  rake = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rn03rqlf1iv6n87a78hkda2yqparhhaivfjpizblmxvlw2hk5r8";
      type = "gem";
    };
    version = "10.4.2";
  };
  redcarpet = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0l6zr8wlqb648z202kzi7l9p89b6v4ivdhif5w803l1rrwyzvj0m";
      type = "gem";
    };
    version = "3.2.3";
  };
  sass = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00mdak4hiaajnw4cbaklhfq4sr3rxy88kka9lq842qa8zs0607af";
      type = "gem";
    };
    version = "3.4.24";
  };
  sass-rails = {
    dependencies = ["railties" "sass" "sprockets" "sprockets-rails" "tilt"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0iji20hb8crncz14piss1b29bfb6l89sz3ai5fny3iw39vnxkdcb";
      type = "gem";
    };
    version = "5.0.6";
  };
  sprockets = {
    dependencies = ["concurrent-ruby" "rack"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sv3zk5hwxyjvg7iy9sggjc7k3mfxxif7w8p260rharfyib939ar";
      type = "gem";
    };
    version = "3.7.1";
  };
  sprockets-rails = {
    dependencies = ["actionpack" "activesupport" "sprockets"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zr9vk2vn44wcn4265hhnnnsciwlmqzqc6bnx78if1xcssxj6x44";
      type = "gem";
    };
    version = "3.2.0";
  };
  temple = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00nxf610nzi4n1i2lkby43nrnarvl89fcl6lg19406msr0k3ycmq";
      type = "gem";
    };
    version = "0.8.0";
  };
  thor = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01n5dv9kql60m6a00zc0r66jvaxx98qhdny3klyj0p3w34pad2ns";
      type = "gem";
    };
    version = "0.19.4";
  };
  thread_safe = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nmhcgq6cgz44srylra07bmaw99f5271l0dpsvl5f75m44l0gmwy";
      type = "gem";
    };
    version = "0.3.6";
  };
  tilt = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1is1ayw5049z8pd7slsk870bddyy5g2imp4z78lnvl8qsl8l0s7b";
      type = "gem";
    };
    version = "2.0.7";
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
  uglifier = {
    dependencies = ["execjs"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wmqvn4xncw6h3d5gp2a44170zwxfyj3iq4rsjp16zarvzbdmgnz";
      type = "gem";
    };
    version = "3.2.0";
  };
  websocket-driver = {
    dependencies = ["websocket-extensions"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1943442yllhldh9dbp374x2q39cxa49xrm28nb78b7mfbv3y195l";
      type = "gem";
    };
    version = "0.6.5";
  };
  websocket-extensions = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07qnsafl6203a2zclxl20hy4jq11c471cgvd0bj5r9fx1qqw06br";
      type = "gem";
    };
    version = "0.1.2";
  };
}