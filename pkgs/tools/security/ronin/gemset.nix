{
  activemodel = {
    dependencies = [ "activesupport" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "01jrk2i6vp8jcll65d03mqmp1ibxa0ip7bdg5157fkm5syblzsqw";
      type = "gem";
    };
    version = "7.1.0";
  };
  activerecord = {
    dependencies = [
      "activemodel"
      "activesupport"
      "timeout"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1lpcbgqbrb3yfk3i66mnxa5i36r0ig9dwzksjbm15i30rndr27p5";
      type = "gem";
    };
    version = "7.1.0";
  };
  activesupport = {
    dependencies = [
      "base64"
      "bigdecimal"
      "concurrent-ruby"
      "connection_pool"
      "drb"
      "i18n"
      "minitest"
      "mutex_m"
      "tzinfo"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1xpwx7hw7mgmjk3w3g8bkz5jfapixhgn3ihly0xkpyvgp1shp8h1";
      type = "gem";
    };
    version = "7.1.0";
  };
  addressable = {
    dependencies = [ "public_suffix" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "05r1fwy487klqkya7vzia8hnklcxy4vr92m9dmni3prfwk6zpw33";
      type = "gem";
    };
    version = "2.8.5";
  };
  async = {
    dependencies = [
      "console"
      "fiber-annotation"
      "io-event"
      "timers"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "02ng89h9s4wwpncyqbkm9n26swp4q45dkvqsb2fpmkan32zn48ji";
      type = "gem";
    };
    version = "2.6.4";
  };
  async-io = {
    dependencies = [ "async" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "11lgd7276rgy651zwbzvbsz8q0k09ljgngyhsppy7kvkjzj25n58";
      type = "gem";
    };
    version = "1.36.0";
  };
  base64 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0cydk9p2cv25qysm0sn2pb97fcpz1isa7n3c8xm1gd99li8x6x8c";
      type = "gem";
    };
    version = "0.1.1";
  };
  bigdecimal = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "07y615s8yldk3k13lmkhpk1k190lcqvmxmnjwgh4bzjan9xrc36y";
      type = "gem";
    };
    version = "3.1.4";
  };
  chars = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "18lgsszrrh3xnaym2jdz7g5gm7c8hv5faj7zyrm1ws9l107jrhr5";
      type = "gem";
    };
    version = "0.3.2";
  };
  combinatorics = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1sf0pj29xzriwsqv607iwzs76piac6kygqxpg0i59qwx029100fw";
      type = "gem";
    };
    version = "0.4.4";
  };
  command_kit = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "179mlrnzj56ghviyvvwk0kdfyvr050yk4jj4nwb78izlbxw1wl1m";
      type = "gem";
    };
    version = "0.4.0";
  };
  command_mapper = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1v363y9g7zxfx2y7p50hdvxj6c0a8mfh30wac2rm3ibldspcjmn1";
      type = "gem";
    };
    version = "0.3.1";
  };
  concurrent-ruby = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0krcwb6mn0iklajwngwsg850nk8k9b35dhmc2qkbdqvmifdi2y9q";
      type = "gem";
    };
    version = "1.2.2";
  };
  connection_pool = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1x32mcpm2cl5492kd6lbjbaf17qsssmpx9kdyr7z1wcif2cwyh0g";
      type = "gem";
    };
    version = "2.4.1";
  };
  console = {
    dependencies = [
      "fiber-annotation"
      "fiber-local"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "150wdj94qg8c95b9v1g7ak5a9g159wxfanclpihrz9p9qbv1ga0w";
      type = "gem";
    };
    version = "1.23.2";
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
  domain_name = {
    dependencies = [ "unf" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0lcqjsmixjp52bnlgzh4lg9ppsk52x9hpwdjd53k8jnbah2602h0";
      type = "gem";
    };
    version = "0.5.20190701";
  };
  drb = {
    dependencies = [ "ruby2_keywords" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0h9c2qiam82y3caapa2x157j1lkk9954hrjg3p22hxcsk8fli3vb";
      type = "gem";
    };
    version = "2.1.1";
  };
  fake_io = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "10559cnd2cqllql8ibd0zx0rvq8xk0qll5sqa4khb5963596ldmn";
      type = "gem";
    };
    version = "0.1.0";
  };
  fiber-annotation = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "00vcmynyvhny8n4p799rrhcx0m033hivy0s1gn30ix8rs7qsvgvs";
      type = "gem";
    };
    version = "0.2.0";
  };
  fiber-local = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vrxxb09fc7aicb9zb0pmn5akggjy21dmxkdl3w949y4q05rldr9";
      type = "gem";
    };
    version = "1.0.0";
  };
  hexdump = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1787w456yzmy4c13ray228n89a5wz6p6k3ibssjvy955qlr44b7g";
      type = "gem";
    };
    version = "1.0.0";
  };
  http-cookie = {
    dependencies = [ "domain_name" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "13rilvlv8kwbzqfb644qp6hrbsj82cbqmnzcvqip1p6vqx36sxbk";
      type = "gem";
    };
    version = "1.0.5";
  };
  i18n = {
    dependencies = [ "concurrent-ruby" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0qaamqsh5f3szhcakkak8ikxlzxqnv49n2p7504hcz2l0f4nj0wx";
      type = "gem";
    };
    version = "1.14.1";
  };
  io-console = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0dikardh14c72gd9ypwh8dim41wvqmzfzf35mincaj5yals9m7ff";
      type = "gem";
    };
    version = "0.6.0";
  };
  io-event = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1m2x5m2m8fa83p5890byf46qb4s1073vn3z6gan9jmbq2a5w0iy8";
      type = "gem";
    };
    version = "1.3.2";
  };
  irb = {
    dependencies = [
      "rdoc"
      "reline"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "17p6arsklbzh2hvwwr8i4cfrpa7vhk8q88fhickhwmn7m80lxdw7";
      type = "gem";
    };
    version = "1.8.1";
  };
  mechanize = {
    dependencies = [
      "addressable"
      "domain_name"
      "http-cookie"
      "mime-types"
      "net-http-digest_auth"
      "net-http-persistent"
      "nokogiri"
      "rubyntlm"
      "webrick"
      "webrobots"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "08lcl3qwgi8r3q0hm5ysmj7j5xqb289kqrd15w09anirj36jc80z";
      type = "gem";
    };
    version = "2.9.1";
  };
  mime-types = {
    dependencies = [ "mime-types-data" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0q8d881k1b3rbsfcdi3fx0b5vpdr5wcrhn88r2d9j7zjdkxp5mw5";
      type = "gem";
    };
    version = "3.5.1";
  };
  mime-types-data = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0yjv0apysnrhbc70ralinfpcqn9382lxr643swp7a5sdwpa9cyqg";
      type = "gem";
    };
    version = "3.2023.1003";
  };
  mini_portile2 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "02mj8mpd6ck5gpcnsimx5brzggw5h5mmmpq2djdypfq16wcw82qq";
      type = "gem";
    };
    version = "2.8.4";
  };
  minitest = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0bkmfi9mb49m0fkdhl2g38i3xxa02d411gg0m8x0gvbwfmmg5ym3";
      type = "gem";
    };
    version = "5.20.0";
  };
  mustermann = {
    dependencies = [ "ruby2_keywords" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0rwbq20s2gdh8dljjsgj5s6wqqfmnbclhvv2c2608brv7jm6jdbd";
      type = "gem";
    };
    version = "3.0.0";
  };
  mutex_m = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1pkxnp7p44kvs460bbbgjarr7xy1j8kjjmhwkg1kypj9wgmwb6qa";
      type = "gem";
    };
    version = "0.1.2";
  };
  net-ftp = {
    dependencies = [
      "net-protocol"
      "time"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0bqy9xg5225x102873j1qqq1bvnwfbi8lnf4357mpq6wimnw9pf9";
      type = "gem";
    };
    version = "0.2.0";
  };
  net-http-digest_auth = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1nq859b0gh2vjhvl1qh1zrk09pc7p54r9i6nnn6sb06iv07db2jb";
      type = "gem";
    };
    version = "1.4.1";
  };
  net-http-persistent = {
    dependencies = [ "connection_pool" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0i1as2lgnw7b4jid0gw5glv5hnxz36nmfsbr9rmxbcap72ijgy03";
      type = "gem";
    };
    version = "4.0.2";
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
      sha256 = "0d0r31b79appz95dd63wmasly1qjz3hn58ffxw6ix4mqk49jcbq2";
      type = "gem";
    };
    version = "0.4.1";
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
      sha256 = "1rx3758w0bmbr21s2nsc6llflsrnp50fwdnly3ixra4v53gbhzid";
      type = "gem";
    };
    version = "0.4.0";
  };
  nokogiri = {
    dependencies = [
      "mini_portile2"
      "racc"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0k9w2z0953mnjrsji74cshqqp08q7m1r6zhadw1w0g34xzjh3a74";
      type = "gem";
    };
    version = "1.15.4";
  };
  nokogiri-diff = {
    dependencies = [
      "nokogiri"
      "tdiff"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0njr1s42war0bj1axb2psjvk49l74a8wzr799wckqqdcb6n51lc1";
      type = "gem";
    };
    version = "0.2.0";
  };
  nokogiri-ext = {
    dependencies = [ "nokogiri" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0y1yflr1989vfy46lxhvs5njlskwiv08akkjybnh8n0cdqms4lhs";
      type = "gem";
    };
    version = "0.1.0";
  };
  open_namespace = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "11j392gl62ibhkidjrjfnb3sygmqmvsc7zd5bhmnigd65x5gs310";
      type = "gem";
    };
    version = "0.4.1";
  };
  psych = {
    dependencies = [ "stringio" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1msambb54r3d1sg6smyj4k2pj9h9lz8jq4jamip7ivcyv32a85vz";
      type = "gem";
    };
    version = "5.1.0";
  };
  public_suffix = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0n9j7mczl15r3kwqrah09cxj8hxdfawiqxa60kga2bmxl9flfz9k";
      type = "gem";
    };
    version = "5.0.3";
  };
  racc = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "11v3l46mwnlzlc371wr3x6yylpgafgwdf0q7hc7c1lzx6r414r5g";
      type = "gem";
    };
    version = "1.7.1";
  };
  rack = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "15rdwbyk71c9nxvd527bvb8jxkcys8r3dj3vqra5b3sa63qs30vv";
      type = "gem";
    };
    version = "2.2.8";
  };
  rack-protection = {
    dependencies = [ "rack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xsz78hccgza144n37bfisdkzpr2c8m0xl6rnlzgxdbsm1zrkg7r";
      type = "gem";
    };
    version = "3.1.0";
  };
  rack-user_agent = {
    dependencies = [
      "rack"
      "woothee"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1l1gw8xx1g04kdxc89hsy4aawdz8r2an4b78yzk9cc3y8qmw16v7";
      type = "gem";
    };
    version = "0.5.3";
  };
  rdoc = {
    dependencies = [ "psych" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "05r2cxscapr9saqjw8dlp89as7jvc2mlz1h5kssrmkbz105qmfcm";
      type = "gem";
    };
    version = "6.5.0";
  };
  reline = {
    dependencies = [ "io-console" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0187pj9k7d8kdvzjk6r6mf7z7wy18saxxhn7x7pqc840w6h4s0ja";
      type = "gem";
    };
    version = "0.3.9";
  };
  ronin = {
    dependencies = [
      "async-io"
      "open_namespace"
      "ronin-code-asm"
      "ronin-code-sql"
      "ronin-core"
      "ronin-db"
      "ronin-exploits"
      "ronin-fuzzer"
      "ronin-payloads"
      "ronin-repos"
      "ronin-support"
      "ronin-vulns"
      "ronin-web"
      "rouge"
      "wordlist"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0v1v1xb2brgajhh1w38qs4lhnmgygymh1q0q63xpwq32w7a5k7s3";
      type = "gem";
    };
    version = "2.0.5";
  };
  ronin-code-asm = {
    dependencies = [ "ruby-yasm" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0faic3m95nhr7wrh7visdj45qaah7dvnl0afl4a5gmy6ybij16zl";
      type = "gem";
    };
    version = "1.0.0";
  };
  ronin-code-sql = {
    dependencies = [ "ronin-support" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1z6ynbrbzlkab1fbhccghr2xm6dak9xb2djqjlc6nai3fdhid1v8";
      type = "gem";
    };
    version = "2.1.0";
  };
  ronin-core = {
    dependencies = [
      "command_kit"
      "irb"
      "reline"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1s2hndkdh4pw6xppq4jqn30fk2b26gk08yym5gavlzkcg5k17vvd";
      type = "gem";
    };
    version = "0.1.2";
  };
  ronin-db = {
    dependencies = [
      "ronin-core"
      "ronin-db-activerecord"
      "ronin-support"
      "sqlite3"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0fiqdk1rnqk86icx27z531yc1qjs2n41nw9p361980wg0j8b4hsj";
      type = "gem";
    };
    version = "0.1.2";
  };
  ronin-db-activerecord = {
    dependencies = [
      "activerecord"
      "uri-query_params"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0igw9syk4psdmijji0cx1dhrv76r1abji8fzdndnrn5h819b2fm3";
      type = "gem";
    };
    version = "0.1.2";
  };
  ronin-exploits = {
    dependencies = [
      "ronin-code-sql"
      "ronin-core"
      "ronin-payloads"
      "ronin-post_ex"
      "ronin-repos"
      "ronin-support"
      "ronin-vulns"
      "uri-query_params"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1g2ilmmn6vccjn1i72wyakvjlh0b1qrgnw2nshl9f50j7yj93xpn";
      type = "gem";
    };
    version = "1.0.3";
  };
  ronin-fuzzer = {
    dependencies = [
      "combinatorics"
      "ronin-core"
      "ronin-support"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "19sc4kk6lwpq6fd23dmji0vf4mjkf1z5pjq4wp0xs2cby2fzld5p";
      type = "gem";
    };
    version = "0.1.0";
  };
  ronin-payloads = {
    dependencies = [
      "ronin-code-asm"
      "ronin-core"
      "ronin-post_ex"
      "ronin-repos"
      "ronin-support"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1gsgbw90xmwwnpc8i873wwgia56hcjkhlyjpxl7s4yvd7ml7pj0f";
      type = "gem";
    };
    version = "0.1.4";
  };
  ronin-post_ex = {
    dependencies = [
      "fake_io"
      "hexdump"
      "ronin-core"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0dcpnlz8niqjjm5d9z8khg53acl7xn5dgliv70svsncc3h0hx0w7";
      type = "gem";
    };
    version = "0.1.0";
  };
  ronin-repos = {
    dependencies = [ "ronin-core" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0c453qw7xr4vsq2y5dlnihfmzy95q3xjbfl5cm1y0xwzdm7ibbzx";
      type = "gem";
    };
    version = "0.1.1";
  };
  ronin-support = {
    dependencies = [
      "addressable"
      "chars"
      "combinatorics"
      "hexdump"
      "uri-query_params"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0k2vs6mkcyx0h7k3rjs2bwqimhkfa2m50ll8rgm7zygxz3f6gny3";
      type = "gem";
    };
    version = "1.0.3";
  };
  ronin-vulns = {
    dependencies = [
      "ronin-core"
      "ronin-support"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1p00xrj71436g301b0wnq23ps89x4g9mmzvkghw9sqyfazgc829f";
      type = "gem";
    };
    version = "0.1.4";
  };
  ronin-web = {
    dependencies = [
      "mechanize"
      "nokogiri"
      "nokogiri-diff"
      "nokogiri-ext"
      "open_namespace"
      "ronin-core"
      "ronin-support"
      "ronin-web-server"
      "ronin-web-spider"
      "ronin-web-user_agents"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "06rh7hrkj4yl6pn1m3isfim2sk5vb3ap3rba91bw7drcqsra7fmw";
      type = "gem";
    };
    version = "1.0.2";
  };
  ronin-web-server = {
    dependencies = [
      "rack"
      "rack-user_agent"
      "ronin-support"
      "sinatra"
      "webrick"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "14p1z2s20dkipb6rp2wyjc91dz6bjn5v8nv68m54my7p1vac05zk";
      type = "gem";
    };
    version = "0.1.1";
  };
  ronin-web-spider = {
    dependencies = [
      "ronin-support"
      "spidr"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0592llhzm8miy0lj4xsb4h0ppy18wmwqi54rjzzsm7h3d2py7iv9";
      type = "gem";
    };
    version = "0.1.0";
  };
  ronin-web-user_agents = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1shca7bsc09hag7ax3js9xszw71mnf1ywrf0l0pk40hfqmnnaxcl";
      type = "gem";
    };
    version = "0.1.0";
  };
  rouge = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1dnfkrk8xx2m8r3r9m2p5xcq57viznyc09k7r3i4jbm758i57lx3";
      type = "gem";
    };
    version = "3.30.0";
  };
  ruby-yasm = {
    dependencies = [ "command_mapper" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vf0kdaaysx9kr7v8rl0hl0j73zkfkg7zqvg0b41sgfg3zfib0ap";
      type = "gem";
    };
    version = "0.3.0";
  };
  ruby2_keywords = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vz322p8n39hz3b4a9gkmz9y7a5jaz41zrm2ywf31dvkqm03glgz";
      type = "gem";
    };
    version = "0.0.5";
  };
  rubyntlm = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0b8hczk8hysv53ncsqzx4q6kma5gy5lqc7s5yx8h64x3vdb18cjv";
      type = "gem";
    };
    version = "0.6.3";
  };
  sinatra = {
    dependencies = [
      "mustermann"
      "rack"
      "rack-protection"
      "tilt"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "00541cnypsh1mnilfxxqlz6va9afrixf9m1asn4wzjp5m59777p8";
      type = "gem";
    };
    version = "3.1.0";
  };
  spidr = {
    dependencies = [ "nokogiri" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "15gjqry61z93f4p84x5b1bi6f65xd4djax0563ljngmsckyg7xg5";
      type = "gem";
    };
    version = "0.7.0";
  };
  sqlite3 = {
    dependencies = [ "mini_portile2" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "15415lmz69jbzl6nch4q5l2jxv054676nk6y0vgy0g3iklmjrxvc";
      type = "gem";
    };
    version = "1.6.6";
  };
  stringio = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ix96dxbjqlpymdigb4diwrifr0bq7qhsrng95fkkp18av326nqk";
      type = "gem";
    };
    version = "3.0.8";
  };
  tdiff = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0rjvqyyxrybzhaqmgh4zjcdrvmqyqcqqbq4vda39idhrqcd2gy67";
      type = "gem";
    };
    version = "0.3.4";
  };
  tilt = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0p3l7v619hwfi781l3r7ypyv1l8hivp09r18kmkn6g11c4yr1pc2";
      type = "gem";
    };
    version = "2.3.0";
  };
  time = {
    dependencies = [ "date" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "13pzdsgf3v06mymzipcpa7p80shyw328ybn775nzpnhc6n8y9g30";
      type = "gem";
    };
    version = "0.2.2";
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
  timers = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0pjzipnmzfywvgsr3gxwj6nmg47lz4700g0q71jgcy1z6rb7dn7p";
      type = "gem";
    };
    version = "4.3.5";
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
  unf = {
    dependencies = [ "unf_ext" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0bh2cf73i2ffh4fcpdn9ir4mhq8zi50ik0zqa1braahzadx536a9";
      type = "gem";
    };
    version = "0.1.4";
  };
  unf_ext = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1yj2nz2l101vr1x9w2k83a0fag1xgnmjwp8w8rw4ik2rwcz65fch";
      type = "gem";
    };
    version = "0.0.8.2";
  };
  uri-query_params = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "08i91q1q2fvjq7n21p4f4pryi8b9msknrgwz132spvhm4l55n6l6";
      type = "gem";
    };
    version = "0.8.1";
  };
  webrick = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "13qm7s0gr2pmfcl7dxrmq38asaza4w0i2n9my4yzs499j731wh8r";
      type = "gem";
    };
    version = "1.8.1";
  };
  webrobots = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "19ndcbba8s8m62hhxxfwn83nax34rg2k5x066awa23wknhnamg7b";
      type = "gem";
    };
    version = "0.1.2";
  };
  woothee = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xg31qi09swgsf46b9ba38z2jav2516bg3kg7xf1wfbzw8mpd3fc";
      type = "gem";
    };
    version = "1.13.0";
  };
  wordlist = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "06d4nj2nd172sn5yjw9qmpz7zqnymadbsxph741yx2h9va8q0qgd";
      type = "gem";
    };
    version = "1.1.0";
  };
}
