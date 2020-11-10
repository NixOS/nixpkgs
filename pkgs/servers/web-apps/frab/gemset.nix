{
  actionmailer = {
    dependencies = ["actionpack" "actionview" "activejob" "mail" "rails-dom-testing"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lw1pss1mrjm7x7qcg9pvxv55rz3d994yf3mwmlfg1y12fxq00n3";
      type = "gem";
    };
    version = "4.2.7.1";
  };
  actionpack = {
    dependencies = ["actionview" "activesupport" "rack" "rack-test" "rails-dom-testing" "rails-html-sanitizer"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ray5bvlmkimjax011zsw0mz9llfkqrfm7q1avjlp4i0kpcz8zlh";
      type = "gem";
    };
    version = "4.2.7.1";
  };
  actionview = {
    dependencies = ["activesupport" "builder" "erubis" "rails-dom-testing" "rails-html-sanitizer"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11m2x5nlbqrw79fh6h7m444lrka7wwy32b0dvgqg7ilbzih43k0c";
      type = "gem";
    };
    version = "4.2.7.1";
  };
  activejob = {
    dependencies = ["activesupport" "globalid"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ish5wd8nvmj7f6x1i22aw5ycizy5n1z1c7f3kyxmqwhw7lb0gaz";
      type = "gem";
    };
    version = "4.2.7.1";
  };
  activemodel = {
    dependencies = ["activesupport" "builder"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0acz0mbmahsc9mn41275fpfnrqwig5k09m3xhz3455kv90fn79v5";
      type = "gem";
    };
    version = "4.2.7.1";
  };
  activerecord = {
    dependencies = ["activemodel" "activesupport" "arel"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lk8l6i9p7qfl0pg261v5yph0w0sc0vysrdzc6bm5i5rxgi68flj";
      type = "gem";
    };
    version = "4.2.7.1";
  };
  activeresource = {
    dependencies = ["activemodel" "activesupport" "rails-observers"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nr5is20cx18s7vg8bdrdc996s2abl3h7fsi1q6mqsrzw7nrv2fa";
      type = "gem";
    };
    version = "4.1.0";
  };
  activesupport = {
    dependencies = ["i18n" "json" "minitest" "thread_safe" "tzinfo"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gds12k7nxrcc09b727a458ndidy1nfcllj9x22jcaj7pppvq6r4";
      type = "gem";
    };
    version = "4.2.7.1";
  };
  acts_as_commentable = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p4bwyqmm4ybcscn292aixschdzvns2dpl8a7w4zm0rqy2619cc9";
      type = "gem";
    };
    version = "4.0.2";
  };
  addressable = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mpn7sbjl477h56gmxsjqb89r5s3w7vx5af994ssgc3iamvgzgvs";
      type = "gem";
    };
    version = "2.4.0";
  };
  airbrussh = {
    dependencies = ["sshkit"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pv22d2kjdbsg9q45jca3f5gsylr2r1wfpn58g58xj4s4q4r95nx";
      type = "gem";
    };
    version = "1.1.1";
  };
  arel = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1a270mlajhrmpqbhxcqjqypnvgrq4pgixpv3w9gwp1wrrapnwrzk";
      type = "gem";
    };
    version = "6.0.3";
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
      sha256 = "14fii7ab8qszrvsvhz6z2z3i4dw0h41a62fjr2h1j8m41vbrmyv2";
      type = "gem";
    };
    version = "3.2.2";
  };
  bullet = {
    dependencies = ["activesupport" "uniform_notifier"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06pba7bdjnazbl0yhhvlina08nkawnm76zihkaam4k7fm0yrq1k0";
      type = "gem";
    };
    version = "5.4.0";
  };
  byebug = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18sdnscwwm76i2kbcib2ckwfwpq8b1dbfr97gdcx3j1x547yqv9x";
      type = "gem";
    };
    version = "9.0.5";
  };
  cancancan = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05kb459laaw339n7mas37v4k83nwz228bfpaghgybza347341x85";
      type = "gem";
    };
    version = "1.15.0";
  };
  capistrano = {
    dependencies = ["i18n" "rake" "sshkit"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0f73w6gpml0ickmwky1cn6d8392q075zy10a323f3vmyvxyhr0jb";
      type = "gem";
    };
    version = "3.4.1";
  };
  capistrano-bundler = {
    dependencies = ["capistrano" "sshkit"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1f4iikm7pn0li2lj6p53wl0d6y7svn0h76z9c6c582mmwxa9c72p";
      type = "gem";
    };
    version = "1.1.4";
  };
  capistrano-rails = {
    dependencies = ["capistrano" "capistrano-bundler"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03lzihrq72rwcqq7jiqak79wy0xbdnymn5gxj0bfgfjlg5kpgssw";
      type = "gem";
    };
    version = "1.1.8";
  };
  capistrano-rvm = {
    dependencies = ["capistrano" "sshkit"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15sy8zcal041yy5kb7fcdqnxvndgdhg3w1kvb5dk7hfjk3ypznsa";
      type = "gem";
    };
    version = "0.1.2";
  };
  capistrano3-puma = {
    dependencies = ["capistrano" "puma"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ynz1arnr07kcl0vsaa1znhp2ywhhs4fwndnkw8sasr9bydksln8";
      type = "gem";
    };
    version = "1.2.1";
  };
  chunky_png = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p1zy4gyfp7rapr2yxcljkw6qh0chkwf356i387b3fg85cwdj4xh";
      type = "gem";
    };
    version = "1.3.7";
  };
  climate_control = {
    dependencies = ["activesupport"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0krknwk6b8lwv1j9kjbxib6kf5zh4pxkf3y2vcyycx5d6nci1s55";
      type = "gem";
    };
    version = "0.0.3";
  };
  cocaine = {
    dependencies = ["climate_control"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01kk5xd7lspbkdvn6nyj0y51zhvia3z6r4nalbdcqw5fbsywwi7d";
      type = "gem";
    };
    version = "0.5.8";
  };
  cocoon = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gzznkrs6qy31v85cvdqyn5wd3vwlciwibf9clmd6gi4dns21pmv";
      type = "gem";
    };
    version = "1.2.9";
  };
  coderay = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1x6z923iwr1hi04k6kz5a6llrixflz8h5sskl9mhaaxy9jx2x93r";
      type = "gem";
    };
    version = "1.1.1";
  };
  coffee-rails = {
    dependencies = ["coffee-script" "railties"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mv1kaw3z4ry6cm51w8pfrbby40gqwxanrqyqr0nvs8j1bscc1gw";
      type = "gem";
    };
    version = "4.1.1";
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
      sha256 = "1k4fg39rrkl3bpgchfj94fbl9s4ysaz16w8dkqncf2vyf79l3qz0";
      type = "gem";
    };
    version = "1.10.0";
  };
  concurrent-ruby = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kb4sav7yli12pjr8lscv8z49g52a5xzpfg3z9h8clzw6z74qjsw";
      type = "gem";
    };
    version = "1.0.2";
  };
  database_cleaner = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fx6zmqznklmkbjl6f713jyl11d4g9q220rcl86m2jp82r8kfwjj";
      type = "gem";
    };
    version = "1.5.3";
  };
  dotenv = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p6zz0xzb15vq8jphpw2fh6m4dianw7s76ci8vj9x3zxayrn4lfm";
      type = "gem";
    };
    version = "2.1.1";
  };
  dotenv-rails = {
    dependencies = ["dotenv" "railties"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17s6c0yqaz01xd5wywjscbvv0pa3grak2lhwby91j84qm6h95vxz";
      type = "gem";
    };
    version = "2.1.1";
  };
  erubis = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fj827xqjs91yqsydf0zmfyw9p4l2jz5yikg3mppz6d7fi8kyrb3";
      type = "gem";
    };
    version = "2.7.0";
  };
  exception_notification = {
    dependencies = ["actionmailer" "activesupport"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vclsr0rjfy1khvqyj67lgpa0v14nb542vvjkyaswn367nnmijhw";
      type = "gem";
    };
    version = "4.2.1";
  };
  execjs = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yz55sf2nd3l666ms6xr18sm2aggcvmb8qr3v53lr4rir32y1yp1";
      type = "gem";
    };
    version = "2.7.0";
  };
  factory_girl = {
    dependencies = ["activesupport"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xzl4z9z390fsnyxp10c9if2n46zan3n6zwwpfnwc33crv4s410i";
      type = "gem";
    };
    version = "4.7.0";
  };
  factory_girl_rails = {
    dependencies = ["factory_girl" "railties"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hzpirb33xdqaz44i1mbcfv0icjrghhgaz747llcfsflljd4pa4r";
      type = "gem";
    };
    version = "4.7.0";
  };
  faker = {
    dependencies = ["i18n"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09amnh5d0m3q2gpb0vr9spbfa8l2nc0kl3s79y6sx7a16hrl4vvc";
      type = "gem";
    };
    version = "1.6.6";
  };
  github-markdown = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nax4fyyhz9xmi7q6mmc6d1h8hc0cxda9d7q5z0pba88mj00s9fj";
      type = "gem";
    };
    version = "0.6.9";
  };
  globalid = {
    dependencies = ["activesupport"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11plkgyl3w9k4y2scc1igvpgwyz4fnmsr63h2q4j8wkb48nlnhak";
      type = "gem";
    };
    version = "0.3.7";
  };
  haml = {
    dependencies = ["tilt"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mrzjgkygvfii66bbylj2j93na8i89998yi01fin3whwqbvx0m1p";
      type = "gem";
    };
    version = "4.0.7";
  };
  httparty = {
    dependencies = ["multi_xml"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1msa213hclsv14ijh49i1wggf9avhnj2j4xr58m9jx6fixlbggw6";
      type = "gem";
    };
    version = "0.14.0";
  };
  i18n = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1i5z1ykl8zhszsxcs8mzl8d0dxgs3ylz8qlzrw74jb0gplkx6758";
      type = "gem";
    };
    version = "0.7.0";
  };
  jbuilder = {
    dependencies = ["activesupport" "multi_json"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jbh1296imd0arc9nl1m71yfd7kg505p8srr1ijpsqv4hhbz5qci";
      type = "gem";
    };
    version = "2.6.0";
  };
  jquery-migrate-rails = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pcfs339wki4ax4imb4qi2xb04bbj6j4xvn8x3yn6yf95frrvch6";
      type = "gem";
    };
    version = "1.2.1";
  };
  jquery-rails = {
    dependencies = ["rails-dom-testing" "railties" "thor"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0prqyixv7j2qlq67qdr3miwcyvi27b9a82j51gbpb6vcl0ig2rik";
      type = "gem";
    };
    version = "4.2.1";
  };
  jquery-ui-rails = {
    dependencies = ["railties"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gfygrv4bjpjd2c377lw7xzk1b77rxjyy3w6wl4bq1gkqvyrkx77";
      type = "gem";
    };
    version = "5.0.5";
  };
  json = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nsby6ry8l9xg3yw4adlhk2pnc7i0h0rznvcss4vk3v74qg0k8lc";
      type = "gem";
    };
    version = "1.8.3";
  };
  launchy = {
    dependencies = ["addressable"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "190lfbiy1vwxhbgn4nl4dcbzxvm049jwc158r2x7kq3g5khjrxa2";
      type = "gem";
    };
    version = "2.4.3";
  };
  letter_opener = {
    dependencies = ["launchy"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pcrdbxvp2x5six8fqn8gf09bn9rd3jga76ds205yph5m8fsda21";
      type = "gem";
    };
    version = "1.4.1";
  };
  localized_language_select = {
    dependencies = ["rails"];
    source = {
      fetchSubmodules = false;
      rev = "85df6b97789de6e29c630808b630e56a1b76f80c";
      sha256 = "1b2pd8120nrl3s3idpgdzhrjkn9g5sxnkx4j671fjiyhadlr0q5j";
      type = "git";
      url = "git://github.com/frab/localized_language_select.git";
    };
    version = "0.3.0";
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
      sha256 = "0c9vqfy0na9b5096i5i4qvrvhwamjnmajhgqi3kdsdfl8l6agmkp";
      type = "gem";
    };
    version = "2.6.4";
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
  mimemagic = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "101lq4bnjs7ywdcicpw3vbz9amg5gbb4va1626fybd2hawgdx8d9";
      type = "gem";
    };
    version = "0.3.0";
  };
  mini_portile2 = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1y25adxb1hgg1wb2rn20g3vl07qziq6fz364jc5694611zz863hb";
      type = "gem";
    };
    version = "2.1.0";
  };
  minitest = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0300naf4ilpd9sf0k8si9h9sclkizaschn8bpnri5fqmvm9ybdbq";
      type = "gem";
    };
    version = "5.9.1";
  };
  multi_json = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wpc23ls6v2xbk3l1qncsbz16npvmw8p0b38l8czdzri18mp51xk";
      type = "gem";
    };
    version = "1.12.1";
  };
  multi_xml = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0i8r7dsz4z79z3j023l8swan7qpbgxbwwz11g38y2vjqjk16v4q8";
      type = "gem";
    };
    version = "0.5.5";
  };
  mysql2 = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1v537b7865f4z610rljy8prwmq1yhk3zalp9mcbxn7aqb3g75pra";
      type = "gem";
    };
    version = "0.4.4";
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
  net-ssh = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11djaq0h3bzzy61dca3l84rrs91702hha4vgg387gviipgz7f3yy";
      type = "gem";
    };
    version = "3.2.0";
  };
  nokogiri = {
    dependencies = ["mini_portile2" "pkg-config"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11sbmpy60ynak6s3794q32lc99hs448msjy8rkp84ay7mq7zqspv";
      type = "gem";
    };
    version = "1.6.7.2";
  };
  paper_trail = {
    dependencies = ["activerecord" "request_store"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1w3y2h1w0kml2fmzx4sdcrhnbj273npwrs0cx91xdgy2qfjj6hmr";
      type = "gem";
    };
    version = "5.2.2";
  };
  paperclip = {
    dependencies = ["activemodel" "activesupport" "cocaine" "mime-types" "mimemagic"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0r8krh5xg790845wzlc2r7l0jwskw4c4wk9xh4bpprqykwaghg0r";
      type = "gem";
    };
    version = "4.3.7";
  };
  pdf-core = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1x121sznmhfmjnk0rzpp6djxgi28afpc8avnhn3kzlmpc87r7fyi";
      type = "gem";
    };
    version = "0.1.6";
  };
  pg = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bplv27d0f8vwdj51967498pl1cjxq19hhcj4hdjr4h3s72l2z4j";
      type = "gem";
    };
    version = "0.19.0";
  };
  pkg-config = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lljiqnm0b4z6iy87lzapwrdfa6ps63x2z5zbs038iig8dqx2g0z";
      type = "gem";
    };
    version = "1.1.7";
  };
  polyamorous = {
    dependencies = ["activerecord"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1501y9l81b2lwb93fkycq8dr1bi6qcdhia3qv4fddnmrdihkl3pv";
      type = "gem";
    };
    version = "1.3.1";
  };
  prawn = {
    dependencies = ["pdf-core" "ttfunk"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04pxzfmmy8a6bv3zvh1mmyy5zi4bj994kq1v6qnlq2xlhvg4cxjc";
      type = "gem";
    };
    version = "0.15.0";
  };
  prawn_rails = {
    dependencies = ["prawn" "railties"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19m1pv2rsl3rf9rni78l8137dy2sq1r2443biv19wi9nis2pvgdg";
      type = "gem";
    };
    version = "0.0.11";
  };
  pry = {
    dependencies = ["coderay" "method_source" "slop"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05xbzyin63aj2prrv8fbq2d5df2mid93m81hz5bvf2v4hnzs42ar";
      type = "gem";
    };
    version = "0.10.4";
  };
  pry-byebug = {
    dependencies = ["byebug" "pry"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pvc94kgxd33p6iz41ghyadq8zfbjhkk07nvz2mbh3yhrc8w7gmw";
      type = "gem";
    };
    version = "3.4.0";
  };
  pry-rails = {
    dependencies = ["pry"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0a2iinvabis2xmv0z7z7jmh7bbkkngxj2qixfdg5m6qj9x8k1kx6";
      type = "gem";
    };
    version = "0.3.4";
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
  rails = {
    dependencies = ["actionmailer" "actionpack" "actionview" "activejob" "activemodel" "activerecord" "activesupport" "railties" "sprockets-rails"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1avd16ir7qx23dcnz1b3cafq1lja6rq0w222bs658p9n33rbw54l";
      type = "gem";
    };
    version = "4.2.7.1";
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
      sha256 = "1v8jl6803mbqpxh4hn0szj081q1a3ap0nb8ni0qswi7z4la844v8";
      type = "gem";
    };
    version = "1.0.7";
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
  rails-observers = {
    dependencies = ["activemodel"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lsw19jzmvipvrfy2z04hi7r29dvkfc43h43vs67x6lsj9rxwwcy";
      type = "gem";
    };
    version = "0.1.2";
  };
  railties = {
    dependencies = ["actionpack" "activesupport" "rake" "thor"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04rz7cn64zzvq7lnhc9zqmaqmqkq84q25v0ym9lcw75j1cj1mrq4";
      type = "gem";
    };
    version = "4.2.7.1";
  };
  rake = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cnjmbcyhm4hacpjn337mg1pnaw6hj09f74clwgh6znx8wam9xla";
      type = "gem";
    };
    version = "11.3.0";
  };
  ransack = {
    dependencies = ["actionpack" "activerecord" "activesupport" "i18n" "polyamorous"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cya3wygwjhj8rckckkl387bmva4nyfvqcl0qhp9hk3zv8y6wxjc";
      type = "gem";
    };
    version = "1.8.2";
  };
  redcarpet = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04v85p0bnpf1c7w4n0yr03s35yimxh0idgdrrybl9y13zbw5kgvg";
      type = "gem";
    };
    version = "3.3.4";
  };
  request_store = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1va9x0b3ww4chcfqlmi8b14db39di1mwa7qrjbh7ma0lhndvs2zv";
      type = "gem";
    };
    version = "1.3.1";
  };
  ri_cal = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1flga63anfpfpdwz6lpm3icpdqmvjq757hihfaw63rlkwq4pf390";
      type = "gem";
    };
    version = "0.8.8";
  };
  roust = {
    dependencies = ["activesupport" "httparty" "mail"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zdnwxxh34psv0iybcdnk9w4dpgpr07j3w1fvigkpccgz5vs82qk";
      type = "gem";
    };
    version = "1.8.9";
  };
  rqrcode = {
    dependencies = ["chunky_png"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h1pnnydgs032psakvg3l779w3ghbn08ajhhhw19hpmnfhrs8k0a";
      type = "gem";
    };
    version = "0.10.1";
  };
  sass = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dkj6v26fkg1g0majqswwmhxva7cd6p3psrhdlx93qal72dssywy";
      type = "gem";
    };
    version = "3.4.22";
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
  shoulda = {
    dependencies = ["shoulda-context" "shoulda-matchers"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0csmf15a7mcinfq54lfa4arp0f4b2jmwva55m0p94hdf3pxnjymy";
      type = "gem";
    };
    version = "3.5.0";
  };
  shoulda-context = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06wv2ika5zrbxn0m3qxwk0zkbspxids3zmlq3xxays5qmvl1qb55";
      type = "gem";
    };
    version = "1.2.1";
  };
  shoulda-matchers = {
    dependencies = ["activesupport"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0d3ryqcsk1n9y35bx5wxnqbgw4m8b3c79isazdjnnbg8crdp72d0";
      type = "gem";
    };
    version = "2.8.0";
  };
  simple_form = {
    dependencies = ["actionpack" "activemodel"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ii3rkkbj5cc10f5rdiny18ncdh36kijr25cah0ybbr7kigh3v3b";
      type = "gem";
    };
    version = "3.3.1";
  };
  slop = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00w8g3j7k7kl8ri2cf1m58ckxk8rn350gp4chfscmgv6pq1spk3n";
      type = "gem";
    };
    version = "3.6.0";
  };
  sprockets = {
    dependencies = ["concurrent-ruby" "rack"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jzsfiladswnzbrwqfiaj1xip68y58rwx0lpmj907vvq47k87gj1";
      type = "gem";
    };
    version = "3.7.0";
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
  sqlite3 = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19r06wglnm6479ffj9dl0fa4p5j2wi6dj7k6k3d0rbx7036cv3ny";
      type = "gem";
    };
    version = "1.3.11";
  };
  sshkit = {
    dependencies = ["net-scp" "net-ssh"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wpqvr2dyxwp3shwh0221i1ahyg8vd2hyilmjvdi026l00gk2j4l";
      type = "gem";
    };
    version = "1.11.3";
  };
  sucker_punch = {
    dependencies = ["concurrent-ruby"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0l8b53mlzl568kdl4la8kcjjcnawmbl0q6hq9c3kkyippa5c0x55";
      type = "gem";
    };
    version = "2.0.2";
  };
  thor = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08p5gx18yrbnwc6xc0mxvsfaxzgy2y9i78xq7ds0qmdm67q39y4z";
      type = "gem";
    };
    version = "0.19.1";
  };
  thread_safe = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hq46wqsyylx5afkp6jmcihdpv4ynzzq9ygb6z2pb1cbz5js0gcr";
      type = "gem";
    };
    version = "0.3.5";
  };
  tilt = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lgk8bfx24959yq1cn55php3321wddw947mgj07bxfnwyipy9hqf";
      type = "gem";
    };
    version = "2.0.5";
  };
  transitions = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11byymi45s4pxbhj195277r16dyhxkqc2jwf7snbhan23izzay2c";
      type = "gem";
    };
    version = "1.2.0";
  };
  ttfunk = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jvgqhp0i6v9d7davwdn20skgi508yd0xcf1h4p9f5dlslmpnkhj";
      type = "gem";
    };
    version = "1.1.1";
  };
  tzinfo = {
    dependencies = ["thread_safe"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1c01p3kg6xvy1cgjnzdfq45fggbwish8krd0h864jvbpybyx7cgx";
      type = "gem";
    };
    version = "1.2.2";
  };
  uglifier = {
    dependencies = ["execjs"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0f30s1631k03x4wm7xyc79g92pppzvyysa773zsaq2kcry1pmifc";
      type = "gem";
    };
    version = "3.0.2";
  };
  uniform_notifier = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jha0l7x602g5rvah960xl9r0f3q25gslj39i0x1vai8i5z6zr1l";
      type = "gem";
    };
    version = "1.10.0";
  };
  will_paginate = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xlls78hkkmk33q1rb84rgg2xr39g06a1z1239nq59c825g83k01";
      type = "gem";
    };
    version = "3.1.3";
  };
  yard = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gjl0sh7h0a9s67pllagw8192kscljg4y8nddfrqhji4g21yvcas";
      type = "gem";
    };
    version = "0.9.5";
  };
}