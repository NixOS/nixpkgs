{
  addressable = {
    dependencies = [ "public_suffix" ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "15s8van7r2ad3dq6i03l3z4hqnvxcq75a3h72kxvf9an53sqma20";
      type = "gem";
    };
    version = "2.8.4";
  };
  capybara = {
    dependencies = [
      "addressable"
      "matrix"
      "mini_mime"
      "nokogiri"
      "rack"
      "rack-test"
      "regexp_parser"
      "xpath"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "114qm5f5vhwaaw9rj1h2lcamh46zl13v1m18jiw68zl961gwmw6n";
      type = "gem";
    };
    version = "3.39.2";
  };
  capybara-screenshot = {
    dependencies = [
      "capybara"
      "launchy"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xqc7hdiw1ql42mklpfvqd2pyfsxmy55cpx0h9y0jlkpl1q96sw1";
      type = "gem";
    };
    version = "1.0.26";
  };
  chunky_png = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1znw5x86hmm9vfhidwdsijz8m38pqgmv98l9ryilvky0aldv7mc9";
      type = "gem";
    };
    version = "1.4.0";
  };
  coffee-script = {
    dependencies = [
      "coffee-script-source"
      "execjs"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0rc7scyk7mnpfxqv5yy4y5q1hx3i7q3ahplcp4bq2g5r24g2izl2";
      type = "gem";
    };
    version = "2.4.1";
  };
  coffee-script-source = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1907v9q1zcqmmyqzhzych5l7qifgls2rlbnbhy5vzyr7i7yicaz1";
      type = "gem";
    };
    version = "1.12.2";
  };
  compass = {
    dependencies = [
      "chunky_png"
      "compass-core"
      "compass-import-once"
      "rb-fsevent"
      "rb-inotify"
      "sass"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0lfi83w8z75czr0pf0rmj9hda22082h3cmvczl8r1ma9agf88y2c";
      type = "gem";
    };
    version = "1.0.3";
  };
  compass-core = {
    dependencies = [
      "multi_json"
      "sass"
    ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0yaspqwdmzwdcqviclbs3blq7an16pysrfzylz8q1gxmmd6bpj3a";
      type = "gem";
    };
    version = "1.0.3";
  };
  compass-import-once = {
    dependencies = [ "sass" ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0bn7gwbfz7jvvdd0qdfqlx67fcb83gyvxqc7dr9fhcnks3z8z5rq";
      type = "gem";
    };
    version = "1.0.5";
  };
  concurrent-ruby = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0krcwb6mn0iklajwngwsg850nk8k9b35dhmc2qkbdqvmifdi2y9q";
      type = "gem";
    };
    version = "1.2.2";
  };
  daemons = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "07cszb0zl8mqmwhc8a2yfg36vi6lbgrp4pa5bvmryrpcz9v6viwg";
      type = "gem";
    };
    version = "1.4.1";
  };
  date = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03skfikihpx37rc27vr3hwrb057gxnmdzxhmzd4bf4jpkl0r55w1";
      type = "gem";
    };
    version = "3.3.3";
  };
  diff-lcs = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0rwvjahnp7cpmracd8x732rjgnilqv2sx7d1gfrysslc3h039fa9";
      type = "gem";
    };
    version = "1.5.0";
  };
  eventmachine = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0wh9aqb0skz80fhfn66lbpr4f86ya2z5rx6gm5xlfhd05bj1ch4r";
      type = "gem";
    };
    version = "1.2.7";
  };
  execjs = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "121h6af4i6wr3wxvv84y53jcyw2sk71j5wsncm6wq6yqrwcrk4vd";
      type = "gem";
    };
    version = "2.8.1";
  };
  faye-websocket = {
    dependencies = [
      "eventmachine"
      "websocket-driver"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "01xkpv5b4fjc5n6n1fq6z1ris991av2fbadvs8r71i9r34b8g48h";
      type = "gem";
    };
    version = "0.11.3";
  };
  ffi = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1862ydmclzy1a0cjbvm8dz7847d9rch495ib0zb64y84d3xd4bkg";
      type = "gem";
    };
    version = "1.15.5";
  };
  launchy = {
    dependencies = [ "addressable" ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "06r43899384das2bkbrpsdxsafyyqa94il7111053idfalb4984a";
      type = "gem";
    };
    version = "2.5.2";
  };
  mail = {
    dependencies = [
      "mini_mime"
      "net-imap"
      "net-pop"
      "net-smtp"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1bf9pysw1jfgynv692hhaycfxa8ckay1gjw5hz3madrbrynryfzc";
      type = "gem";
    };
    version = "2.8.1";
  };
  mailcatcher = {
    dependencies = [
      "eventmachine"
      "faye-websocket"
      "mail"
      "net-smtp"
      "rack"
      "sinatra"
      "sqlite3"
      "thin"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "003d2a6i97syw67jxrjq0p4xm19p9cfqnbmsg4b1c3mdb5c78rfz";
      type = "gem";
    };
    version = "0.9.0";
  };
  matrix = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1h2cgkpzkh3dd0flnnwfq6f3nl2b1zff9lvqz8xs853ssv5kq23i";
      type = "gem";
    };
    version = "0.4.2";
  };
  mini_mime = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0lbim375gw2dk6383qirz13hgdmxlan0vc5da2l072j3qw6fqjm5";
      type = "gem";
    };
    version = "1.1.2";
  };
  mini_portile2 = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "02mj8mpd6ck5gpcnsimx5brzggw5h5mmmpq2djdypfq16wcw82qq";
      type = "gem";
    };
    version = "2.8.4";
  };
  multi_json = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0pb1g1y3dsiahavspyzkdy39j4q377009f6ix0bh1ag4nqw43l0z";
      type = "gem";
    };
    version = "1.15.0";
  };
  net-imap = {
    dependencies = [
      "date"
      "net-protocol"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0lf7wqg7czhaj51qsnmn28j7jmcxhkh3m28rl1cjrqsgjxhwj7r3";
      type = "gem";
    };
    version = "0.3.7";
  };
  net-pop = {
    dependencies = [ "net-protocol" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1wyz41jd4zpjn0v1xsf9j778qx1vfrl24yc20cpmph8k42c4x2w4";
      type = "gem";
    };
    version = "0.1.2";
  };
  net-protocol = {
    dependencies = [ "timeout" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0dxckrlw4q1lcn3qg4mimmjazmg9bma5gllv72f8js3p36fb3b91";
      type = "gem";
    };
    version = "0.2.1";
  };
  net-smtp = {
    dependencies = [ "net-protocol" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1c6md06hm5bf6rv53sk54dl2vg038pg8kglwv3rayx0vk2mdql9x";
      type = "gem";
    };
    version = "0.3.3";
  };
  nokogiri = {
    dependencies = [
      "mini_portile2"
      "racc"
    ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1l8b0i24h4irivyhwy9xmkjbggw86cxkzkiqdqg0jpcp9qc8h4rl";
      type = "gem";
    };
    version = "1.16.0";
  };
  psych = {
    dependencies = [ "stringio" ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1msambb54r3d1sg6smyj4k2pj9h9lz8jq4jamip7ivcyv32a85vz";
      type = "gem";
    };
    version = "5.1.0";
  };
  public_suffix = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0n9j7mczl15r3kwqrah09cxj8hxdfawiqxa60kga2bmxl9flfz9k";
      type = "gem";
    };
    version = "5.0.3";
  };
  racc = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "11v3l46mwnlzlc371wr3x6yylpgafgwdf0q7hc7c1lzx6r414r5g";
      type = "gem";
    };
    version = "1.7.1";
  };
  rack = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0wr1f3g9rc9i8svfxa9cijajl1661d817s56b2w7rd572zwn0zi0";
      type = "gem";
    };
    version = "1.6.13";
  };
  rack-protection = {
    dependencies = [ "rack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0my0wlw4a5l3hs79jkx2xzv7djhajgf8d28k8ai1ddlnxxb0v7ss";
      type = "gem";
    };
    version = "1.5.5";
  };
  rack-test = {
    dependencies = [ "rack" ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ysx29gk9k14a14zsp5a8czys140wacvp91fja8xcja0j1hzqq8c";
      type = "gem";
    };
    version = "2.1.0";
  };
  rake = {
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "15whn7p9nrkxangbs9hh75q585yfn66lv0v2mhj6q6dl6x8bzr2w";
      type = "gem";
    };
    version = "13.0.6";
  };
  rb-fsevent = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1zmf31rnpm8553lqwibvv3kkx0v7majm1f341xbxc0bk5sbhp423";
      type = "gem";
    };
    version = "0.11.2";
  };
  rb-inotify = {
    dependencies = [ "ffi" ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1jm76h8f8hji38z3ggf4bzi8vps6p7sagxn3ab57qc0xyga64005";
      type = "gem";
    };
    version = "0.10.1";
  };
  rdoc = {
    dependencies = [ "psych" ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "05r2cxscapr9saqjw8dlp89as7jvc2mlz1h5kssrmkbz105qmfcm";
      type = "gem";
    };
    version = "6.5.0";
  };
  regexp_parser = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "136br91alxdwh1s85z912dwz23qlhm212vy6i3wkinz3z8mkxxl3";
      type = "gem";
    };
    version = "2.8.1";
  };
  rexml = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "05i8518ay14kjbma550mv0jm8a6di8yp5phzrd8rj44z9qnrlrp0";
      type = "gem";
    };
    version = "3.2.6";
  };
  rspec = {
    dependencies = [
      "rspec-core"
      "rspec-expectations"
      "rspec-mocks"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "171rc90vcgjl8p1bdrqa92ymrj8a87qf6w20x05xq29mljcigi6c";
      type = "gem";
    };
    version = "3.12.0";
  };
  rspec-core = {
    dependencies = [ "rspec-support" ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0l95bnjxdabrn79hwdhn2q1n7mn26pj7y1w5660v5qi81x458nqm";
      type = "gem";
    };
    version = "3.12.2";
  };
  rspec-expectations = {
    dependencies = [
      "diff-lcs"
      "rspec-support"
    ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "05j44jfqlv7j2rpxb5vqzf9hfv7w8ba46wwgxwcwd8p0wzi1hg89";
      type = "gem";
    };
    version = "3.12.3";
  };
  rspec-mocks = {
    dependencies = [
      "diff-lcs"
      "rspec-support"
    ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1gq7gviwpck7fhp4y5ibljljvxgjklza18j62qf6zkm2icaa8lfy";
      type = "gem";
    };
    version = "3.12.6";
  };
  rspec-support = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ky86j3ksi26ng9ybd7j0qsdf1lpr8mzrmn98yy9gzv801fvhsgr";
      type = "gem";
    };
    version = "3.12.1";
  };
  rubyzip = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0grps9197qyxakbpw02pda59v45lfgbgiyw48i0mq9f2bn9y6mrz";
      type = "gem";
    };
    version = "2.3.2";
  };
  sass = {
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0kfpcwh8dgw4lc81qglkvjl73689jy3g7196zkxm4fpskg1p5lkw";
      type = "gem";
    };
    version = "3.4.25";
  };
  selenium-webdriver = {
    dependencies = [
      "rexml"
      "rubyzip"
      "websocket"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1kxnv3ywssagv2q453hasrrrvsv68d5f3ccm33pyacdji88w8pqg";
      type = "gem";
    };
    version = "4.9.0";
  };
  sinatra = {
    dependencies = [
      "rack"
      "rack-protection"
      "tilt"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0byxzl7rx3ki0xd7aiv1x8mbah7hzd8f81l65nq8857kmgzj1jqq";
      type = "gem";
    };
    version = "1.4.8";
  };
  sprockets = {
    dependencies = [
      "concurrent-ruby"
      "rack"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "182jw5a0fbqah5w9jancvfmjbk88h8bxdbwnl4d3q809rpxdg8ay";
      type = "gem";
    };
    version = "3.7.2";
  };
  sprockets-helpers = {
    dependencies = [ "sprockets" ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0513ma356g05lsskhsb363263177h6ccmp475il0p69y18his2ij";
      type = "gem";
    };
    version = "1.4.0";
  };
  sprockets-sass = {
    dependencies = [ "sprockets" ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "02g153dhzmrlik5dd9kyq0rvr2xjm3fwx8rm7apqfrykc47aizqr";
      type = "gem";
    };
    version = "2.0.0.beta2";
  };
  sqlite3 = {
    dependencies = [ "mini_portile2" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0h95kr5529qv786mfk8r2jjdsdi6v7v3k3dpz69mrcc9i0vpdd37";
      type = "gem";
    };
    version = "1.6.3";
  };
  stringio = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0557v4z7996cgqw7i9197848mymv02krads93dn9lyqa5d7xd0dn";
      type = "gem";
    };
    version = "3.0.7";
  };
  thin = {
    dependencies = [
      "daemons"
      "eventmachine"
      "rack"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "08g1yq6zzvgndj8fd98ah7pp8g2diw28p8bfjgv7rvjvp8d2am8w";
      type = "gem";
    };
    version = "1.8.2";
  };
  tilt = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0bmjgbv8158klwp2r3klxjwaj93nh1sbl4xvj9wsha0ic478avz7";
      type = "gem";
    };
    version = "2.2.0";
  };
  timeout = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1d9cvm0f4zdpwa795v3zv4973y5zk59j7s1x3yn90jjrhcz1yvfd";
      type = "gem";
    };
    version = "0.4.0";
  };
  uglifier = {
    dependencies = [ "execjs" ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0wgh7bzy68vhv9v68061519dd8samcy8sazzz0w3k8kqpy3g4s5f";
      type = "gem";
    };
    version = "4.2.0";
  };
  websocket = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0dib6p55sl606qb4vpwrvj5wh881kk4aqn2zpfapf8ckx7g14jw8";
      type = "gem";
    };
    version = "1.2.9";
  };
  websocket-driver = {
    dependencies = [ "websocket-extensions" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1nyh873w4lvahcl8kzbjfca26656d5c6z3md4sbqg5y1gfz0157n";
      type = "gem";
    };
    version = "0.7.6";
  };
  websocket-extensions = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0hc2g9qps8lmhibl5baa91b4qx8wqw872rgwagml78ydj8qacsqw";
      type = "gem";
    };
    version = "0.1.5";
  };
  xpath = {
    dependencies = [ "nokogiri" ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0bh8lk9hvlpn7vmi6h4hkcwjzvs2y0cmkk3yjjdr8fxvj6fsgzbd";
      type = "gem";
    };
    version = "3.2.0";
  };
}
