src: {
  actionmailer = {
    dependencies = [
      "actionpack"
      "actionview"
      "activejob"
      "activesupport"
      "mail"
      "rails-dom-testing"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0g64lm550x0sx2ad5sgwmx19jg9acj98hih6q33a00pz50dl9sl8";
      type = "gem";
    };
    version = "8.1.3.1";
  };
  actionpack = {
    dependencies = [
      "actionview"
      "activesupport"
      "nokogiri"
      "rack"
      "rack-session"
      "rack-test"
      "rails-dom-testing"
      "rails-html-sanitizer"
      "useragent"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1l13fy0y55h5c5ccm7c94mwfhf6bk5xj83qv1d3izs288lavfk4p";
      type = "gem";
    };
    version = "8.1.3.1";
  };
  actionview = {
    dependencies = [
      "activesupport"
      "builder"
      "erubi"
      "rails-dom-testing"
      "rails-html-sanitizer"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1dng2b5bbjm4c1bcpak7q9w4zh71mz2nkknipszl6yy42j28p9id";
      type = "gem";
    };
    version = "8.1.3.1";
  };
  actionview_precompiler = {
    dependencies = [ "actionview" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "077d83avfm73nd0yji853jn94jpbr496apyz5zh5df61qipbvdik";
      type = "gem";
    };
    version = "0.4.0";
  };
  active_model_serializers = {
    dependencies = [ "activemodel" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0k3mgia2ahh7mbk30hjq9pzqbk0kh281s91kq2z6p555nv9y6l3k";
      type = "gem";
    };
    version = "0.8.4";
  };
  activejob = {
    dependencies = [
      "activesupport"
      "globalid"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jlm75lxj7bjd67jkgclzlrhlm9sj4ywdzngxq6z83ckvxsx538w";
      type = "gem";
    };
    version = "8.1.3.1";
  };
  activemodel = {
    dependencies = [ "activesupport" ];
    groups = [
      "default"
      "development"
      "migrations"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "124gi0hlvkabkl5fzfn90ylj7gbyg22rv5208k8p3hxf5z705k4r";
      type = "gem";
    };
    version = "8.1.3.1";
  };
  activerecord = {
    dependencies = [
      "activemodel"
      "activesupport"
      "timeout"
    ];
    groups = [
      "default"
      "development"
      "migrations"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0fs0q1c35k2bh079kj1xbx9pvqx7q2z4k9d32fqgcf29iz1bcbqa";
      type = "gem";
    };
    version = "8.1.3.1";
  };
  activesupport = {
    dependencies = [
      "base64"
      "bigdecimal"
      "concurrent-ruby"
      "connection_pool"
      "drb"
      "i18n"
      "json"
      "logger"
      "minitest"
      "securerandom"
      "tzinfo"
      "uri"
    ];
    groups = [
      "default"
      "development"
      "migrations"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xhkhdx8svhaf439y398yixik0snzarnnsy43688p92yy9jqfic5";
      type = "gem";
    };
    version = "8.1.3.1";
  };
  addressable = {
    dependencies = [ "public_suffix" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1by7h2lwziiblizpd5yx87jsq8ppdhzvwf08ga34wzqgcv1nmpvz";
      type = "gem";
    };
    version = "2.9.0";
  };
  afm = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ia5iw9xvvy1igaxsa08vvv4b5ry9ipyr18917pi8w0y4kvddm2v";
      type = "gem";
    };
    version = "1.0.0";
  };
  annotaterb = {
    dependencies = [
      "activerecord"
      "activesupport"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1xwbz5zk37f7p3g6ypxzamisay06hidjmdsrvhxw4q0xin4jw6w7";
      type = "gem";
    };
    version = "4.20.0";
  };
  anonymous_loader = {
    dependencies = [ "version_gem" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0mfb8kf2a4qmam6jvlrsb38zqh9gk3y1vhbx8iaxji4i8gi1hjh8";
      type = "gem";
    };
    version = "0.1.3";
  };
  Ascii85 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0nmyxpngg5rycyryhq9l9hapz1y3iqyflskyksxkqm0832a5vjqm";
      type = "gem";
    };
    version = "2.0.1";
  };
  ast = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "10yknjyn0728gjn6b5syynvrvrwm66bhssbxq8mkhshxghaiailm";
      type = "gem";
    };
    version = "2.4.3";
  };
  auth-sanitizer = {
    dependencies = [ "version_gem" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0g1yjdchydvk44v4303rjhb5sfb73nzbrvipnr5cdr7v5k4sl46v";
      type = "gem";
    };
    version = "0.2.3";
  };
  aws-eventstream = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0fqqdqg15rgwgz3mn4pj91agd20csk9gbrhi103d20328dfghsqi";
      type = "gem";
    };
    version = "1.4.0";
  };
  aws-partitions = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1p2qvraa79fl6gq7g69r73bsfpxk231c0c3wp8qhlhys2gd34r02";
      type = "gem";
    };
    version = "1.1284.0";
  };
  aws-sdk-bedrockruntime = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1fbcjd4c025nzfcnrz33iq7m62fd2cyr6nrkfbjxib8gi4zsaivf";
      type = "gem";
    };
    version = "1.83.0";
  };
  aws-sdk-core = {
    dependencies = [
      "aws-eventstream"
      "aws-partitions"
      "aws-sigv4"
      "base64"
      "bigdecimal"
      "jmespath"
      "logger"
      "rexml"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0grlhf96r8m8s8appy9aj8x05mw0p2ydwvkaivmy5r4nhyy7zb1b";
      type = "gem";
    };
    version = "3.255.0";
  };
  aws-sdk-kms = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1a3mh89kfh6flqxw48wfv9wfwkj2zxazw096mqm56wnnzz1jyads";
      type = "gem";
    };
    version = "1.99.0";
  };
  aws-sdk-mediaconvert = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1r0182r7scavikd82v7392mzj2x76cihy7cffz00f14brmqsamfr";
      type = "gem";
    };
    version = "1.165.0";
  };
  aws-sdk-s3 = {
    dependencies = [
      "aws-sdk-core"
      "aws-sdk-kms"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0fd9xq7xyadlldgd9l9iry3fi38wwr1iaag9ax4xpirpkazj6asm";
      type = "gem";
    };
    version = "1.227.0";
  };
  aws-sdk-sns = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1m3dz9cz7zlwhbd5n5wnsqm00c7khpmbnggvraqq2cf50dr3qazr";
      type = "gem";
    };
    version = "1.96.0";
  };
  aws-sdk-sts = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "07q6bvbgq9x1r5si0fqjzs6cx6hn9anam7qx5503ahnj7li69gcv";
      type = "gem";
    };
    version = "1.12.0";
  };
  aws-sigv4 = {
    dependencies = [ "aws-eventstream" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "003ch8qzh3mppsxch83ns0jra8d222ahxs96p9cdrl0grfazywv9";
      type = "gem";
    };
    version = "1.12.1";
  };
  base64 = {
    groups = [
      "default"
      "development"
      "migrations"
      "test"
    ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0yx9yn47a8lkfcjmigk79fykxvr80r4m1i35q82sxzynpbm7lcr7";
      type = "gem";
    };
    version = "0.3.0";
  };
  benchmark = {
    groups = [
      "default"
      "development"
      "migrations"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0v1337j39w1z7x9zs4q7ag0nfv4vs4xlsjx2la0wpv8s6hig2pa6";
      type = "gem";
    };
    version = "0.5.0";
  };
  better_errors = {
    dependencies = [
      "erubi"
      "rack"
      "rouge"
    ];
    groups = [ "development" ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0wqazisnn6hn1wsza412xribpw5wzx6b5z5p4mcpfgizr6xg367p";
      type = "gem";
    };
    version = "2.10.1";
  };
  bigdecimal = {
    groups = [
      "default"
      "development"
      "migrations"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0612spks81fvpv2zrrv3371lbs6mwd7w6g5zafglyk75ici1x87a";
      type = "gem";
    };
    version = "3.3.1";
  };
  bootsnap = {
    dependencies = [ "msgpack" ];
    groups = [ "default" ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1kzzpigr9nh7qcj6b3c03ffzq4xrcighjpa66cx05d4w1xyrw1a1";
      type = "gem";
    };
    version = "1.25.0";
  };
  builder = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0pw3r2lyagsxkm71bf44v5b74f7l9r7di22brbyji9fwz791hya9";
      type = "gem";
    };
    version = "3.3.0";
  };
  bullet = {
    dependencies = [
      "activesupport"
      "uniform_notifier"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0wz4pd9zcnqys43yqfmnzg37438d9zs4a4q4v979x4qwx36xh7lj";
      type = "gem";
    };
    version = "8.2.0";
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
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vxfah83j6zpw3v5hic0j70h519nvmix2hbszmjwm8cfawhagns2";
      type = "gem";
    };
    version = "3.40.0";
  };
  capybara-playwright-driver = {
    dependencies = [
      "addressable"
      "capybara"
      "playwright-ruby-client"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1hx2ha4q90am6ncc4zcisvbpa7haps2lkd7s8k34645wf8nmg3p4";
      type = "gem";
    };
    version = "0.5.10";
  };
  cbor = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "12nj07lblrdvzbbjvzkg4xi6r4npi3sm9mdywj6zxgwvgq61van3";
      type = "gem";
    };
    version = "0.5.10.3";
  };
  certified = {
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1706p6p0a8adyvd943af2a3093xakvislgffw3v9dvp7j07dyk5a";
      type = "gem";
    };
    version = "1.0.0";
  };
  cgi = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1fzqwshg1xzbdm97havskfp6wifsgbjii00dzba0y6bih4lk1jk1";
      type = "gem";
    };
    version = "0.5.2";
  };
  chunky_png = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1znw5x86hmm9vfhidwdsijz8m38pqgmv98l9ryilvky0aldv7mc9";
      type = "gem";
    };
    version = "1.4.0";
  };
  coderay = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jvxqxzply1lwp7ysn94zjhh57vc14mcshw1ygw14ib8lhc00lyw";
      type = "gem";
    };
    version = "1.1.3";
  };
  colored2 = {
    groups = [
      "default"
      "migrations"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0drbrv5m3l3qpal7s87gvss81cbzl76gad1hqkpqfqlphf0h7qb3";
      type = "gem";
    };
    version = "4.0.3";
  };
  concurrent-ruby = {
    groups = [
      "default"
      "development"
      "migrations"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qfi2ns3zwkgq616fc127xiqhan7g7m7gqpwriwcr34nds1vxwdj";
      type = "gem";
    };
    version = "1.3.8";
  };
  connection_pool = {
    groups = [
      "default"
      "development"
      "migrations"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1b8nlxr5z843ii7hfk6igpr5acw3k2ih9yjrgkyz2gbmallgjkz5";
      type = "gem";
    };
    version = "2.5.5";
  };
  console = {
    dependencies = [
      "fiber-annotation"
      "fiber-local"
      "json"
    ];
    groups = [
      "default"
      "migrations"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1mzgyg46jxdyijmg6dkxjv3yqmaixr7mk66094w0cnjrqa3b54w0";
      type = "gem";
    };
    version = "1.37.0";
  };
  cose = {
    dependencies = [
      "cbor"
      "openssl-signature_algorithm"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1rbdzl9n8ppyp38y75hw06s17kp922ybj6jfvhz52p83dg6xpm6m";
      type = "gem";
    };
    version = "1.3.1";
  };
  cppjieba_rb = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1bzsr3k926cwz6r0sx6p60cjyhqls7n8fd123f6qmhkfgfspm6ii";
      type = "gem";
    };
    version = "0.4.4";
  };
  crack = {
    dependencies = [
      "bigdecimal"
      "rexml"
    ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0zjcdl5i6lw508r01dym05ibhkc784cfn93m1d26c7fk1hwi0jpz";
      type = "gem";
    };
    version = "1.0.1";
  };
  crass = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "15djj19ynz3sbw54fsf8n7y3sha8a333f2mgvjfwhr46jhcqg1ll";
      type = "gem";
    };
    version = "1.0.7";
  };
  css_parser = {
    dependencies = [
      "addressable"
      "ssrf_filter"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "119q8j23xyb9pifka1n6jjrw04099zpwwdajh5pd10fm7wlfkw7a";
      type = "gem";
    };
    version = "3.0.0";
  };
  csv = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0mj4kq4wwpc7c8ll52q30hsir1jrcd5kq7yb8lyz0rksa1z1x9mb";
      type = "gem";
    };
    version = "3.3.6";
  };
  date = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1h0db8r2v5llxdbzkzyllkfniqw9gm092qn7cbaib73v9lw0c3bm";
      type = "gem";
    };
    version = "3.5.1";
  };
  debug = {
    dependencies = [
      "irb"
      "reline"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1djjx5332d1hdh9s782dyr0f9d4fr9rllzdcz2k0f8lz2730l2rf";
      type = "gem";
    };
    version = "1.11.1";
  };
  diff-lcs = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0qlrj2qyysc9avzlr4zs1py3x684hqm61n4czrsk1pyllz5x5q4s";
      type = "gem";
    };
    version = "1.6.2";
  };
  diffy = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qs7drxvyzk3dg22xgblc12lq5kww9hhj7vpn8ay3l42rasllf3r";
      type = "gem";
    };
    version = "3.4.4";
  };
  digest = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0isr75hlidx0k50kflsimhs1y6l64mmchr6587fdbmvjwas14cxb";
      type = "gem";
    };
    version = "3.2.1";
  };
  digest-xxhash = {
    groups = [
      "default"
      "migrations"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1mwqln5078r4arxzngbzvr82fshl1bn836ga9dm17i03khqdi2d9";
      type = "gem";
    };
    version = "0.2.9";
  };
  discourse-emojis = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0g69yc1m3f9a0xpncmmp2pya6wkjfr9si9hdckhqvsrmr1p551p9";
      type = "gem";
    };
    version = "1.0.46";
  };
  discourse-fonts = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0cq0ds6c2hz1qs2f3skdbs9pqy4dkl1jfm3778q0hnb1f7bdvm3q";
      type = "gem";
    };
    version = "0.0.19";
  };
  discourse-seed-fu = {
    dependencies = [
      "activerecord"
      "activesupport"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1r3mbi72cx3xx8dnva1zhvxcacdma4xfn16d8s860m7d25fdjqag";
      type = "gem";
    };
    version = "2.3.12";
  };
  discourse_ai-tokenizers = {
    dependencies = [
      "activesupport"
      "tiktoken_ruby"
      "tokenizers"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "04z4m8bkhxv4m990ynrbc41i0dh4543jnnqian9fcfiab1ag5hk1";
      type = "gem";
    };
    version = "0.4.2";
  };
  discourse_dev_assets = {
    dependencies = [
      "faker"
      "literate_randomizer"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0kpa19f6m041qifi5mrm1svsxnnn77pmm6x89cddd8vsj937kzjd";
      type = "gem";
    };
    version = "0.0.6";
  };
  discourse_math_bundle = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0dw3pkhxa9xba3h6j8ndmh7m17mqq4rbmbkxyyrcm04nbjk2zn67";
      type = "gem";
    };
    version = "1.0.1";
  };
  discourse_voice_assets = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1hhcq5by1rr6aknmdfd7pzngvvlb5lby5if33bkha65akqzbrgv7";
      type = "gem";
    };
    version = "0.1.0";
  };
  drb = {
    groups = [
      "default"
      "development"
      "migrations"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0wrkl7yiix268s2md1h6wh91311w95ikd8fy8m5gx589npyxc00b";
      type = "gem";
    };
    version = "2.2.3";
  };
  dry-initializer = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qy4cv0j0ahabprdbp02nc3r1606jd5dp90lzqg0mp0jz6c9gm9p";
      type = "gem";
    };
    version = "3.2.0";
  };
  ed25519 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "01n5rbyws1ijwc5dw7s88xx3zzacxx9k97qn8x11b6k8k18pzs8n";
      type = "gem";
    };
    version = "1.4.0";
  };
  email_reply_trimmer = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0mwg9xa0v45c9yh36nigj09pscrf0npn681r2wn9glzh943fkf6d";
      type = "gem";
    };
    version = "0.4.0";
  };
  erb = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "14pfj6zn0p1hxj6s6s0r7d424wap8zl9zxf89nj79y8fbg16vjn5";
      type = "gem";
    };
    version = "6.0.7";
  };
  erubi = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1naaxsqkv5b3vklab5sbb9sdpszrjzlfsbqpy7ncbnw510xi10m0";
      type = "gem";
    };
    version = "1.13.1";
  };
  excon = {
    dependencies = [ "logger" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1hma5q4f2dxr72v2af1w026cv756cy797zcy9x7cxdg1xh78fbfx";
      type = "gem";
    };
    version = "1.7.1";
  };
  exifr = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0895676gyazah7rwbidkx1l92pfrazapilfcv3qznii9r7dsb1xd";
      type = "gem";
    };
    version = "1.5.1";
  };
  extralite-bundle = {
    groups = [
      "default"
      "migrations"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1b2ajjrzv0afzljsga1l5r9597lam7b3c2fq352v955ib7abdfa9";
      type = "gem";
    };
    version = "3.0.1";
  };
  fabrication = {
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qrv8vvhjx9yi64bji6hrp08if14hmwdy08prg9qld3ij2nvz856";
      type = "gem";
    };
    version = "3.0.0";
  };
  faker = {
    dependencies = [ "i18n" ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0rfp6y0pc2slv83vcnayiypfjsanja5qg9wfm6wwq5dvq0nlhqdr";
      type = "gem";
    };
    version = "3.5.3";
  };
  faraday = {
    dependencies = [
      "faraday-net_http"
      "json"
      "logger"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0y7j6yzv07zggic6g0p2v1ivnvkzsbqjnfdl4215qqb6cxz290hq";
      type = "gem";
    };
    version = "2.14.3";
  };
  faraday-multipart = {
    dependencies = [ "multipart-post" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0mzp9rlqiryyi99bm9ii80hfsbbafh9wl8r3c5pif51pd54sk2bx";
      type = "gem";
    };
    version = "1.2.0";
  };
  faraday-net_http = {
    dependencies = [ "net-http" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "125m3qri52vwh5v9dhq0dkqxf8629cxrf99yyc01pva72wasyy0f";
      type = "gem";
    };
    version = "3.4.4";
  };
  faraday-retry = {
    dependencies = [ "faraday" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ghys6d46j8mxkqprnlz1ks1y1w0lsa2vca7ybx2crg5ny7w8ybv";
      type = "gem";
    };
    version = "2.4.0";
  };
  fast_blank = {
    groups = [ "default" ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "rbx";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1shpmamyzyhyxmv95r96ja5rylzaw60r19647d0fdm7y2h2c77r6";
      type = "gem";
    };
    version = "1.0.1";
  };
  fastimage = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "085d82jw6swv4k6jxya85q7rg3vjzy2nw7hcnwx99n3gdgafnjy6";
      type = "gem";
    };
    version = "2.4.1";
  };
  ffi = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1kqasqvy8d7r09ri4n6bkdwbk63j7afd9ilsw34nzlgh0qp69ldw";
      type = "gem";
    };
    version = "1.17.4";
  };
  fiber-annotation = {
    groups = [
      "default"
      "migrations"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "00vcmynyvhny8n4p799rrhcx0m033hivy0s1gn30ix8rs7qsvgvs";
      type = "gem";
    };
    version = "0.2.0";
  };
  fiber-local = {
    dependencies = [ "fiber-storage" ];
    groups = [
      "default"
      "migrations"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "01lz929qf3xa90vra1ai1kh059kf2c8xarfy6xbv1f8g457zk1f8";
      type = "gem";
    };
    version = "1.1.0";
  };
  fiber-storage = {
    groups = [
      "default"
      "migrations"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qa0j9qjwav9xb0n3isx0rbh0942xrfback392n6vs8bidnmp3pl";
      type = "gem";
    };
    version = "1.0.1";
  };
  fspath = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xcxikkrjv8ws328nn5ax5pyfjs8pn7djg1hks7qyb3yp6prpb5m";
      type = "gem";
    };
    version = "3.1.2";
  };
  globalid = {
    dependencies = [ "activesupport" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "09zl0rkskfq0cwfrk9ypjvflvzanfg3xbhh1slaa1myry7xi4zq3";
      type = "gem";
    };
    version = "1.4.0";
  };
  goldiloader = {
    dependencies = [
      "activerecord"
      "activesupport"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1iw9k9pdhbv13bm5djmrsspvd0fl0hgm4ym6al92jr4risrb2gb1";
      type = "gem";
    };
    version = "6.0.0";
  };
  google-protobuf = {
    dependencies = [
      "bigdecimal"
      "rake"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xvamgf5fxrdzkp8lmws15r20bbwpibgh62lv98fmdindgbcjfl9";
      type = "gem";
    };
    version = "4.36.1";
  };
  guess_html_encoding = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "16700fk6kmif3q3kpc1ldhy3nsc9pkxlgl8sqhznff2zjj5lddna";
      type = "gem";
    };
    version = "0.0.11";
  };
  hana = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03cvrv2wl25j9n4n509hjvqnmwa60k92j741b64a1zjisr1dn9al";
      type = "gem";
    };
    version = "1.3.7";
  };
  hashdiff = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1lbw8lqzjv17vnwb9vy5ki4jiyihybcc5h2rmcrqiz1xa6y9s1ww";
      type = "gem";
    };
    version = "1.2.1";
  };
  hashery = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0qj8815bf7q6q7llm5rzdz279gzmpqmqqicxnzv066a020iwqffj";
      type = "gem";
    };
    version = "2.1.2";
  };
  hashie = {
    dependencies = [ "logger" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0w1qrab701d3a63aj2qavwc2fpcqmkzzh1w2x93c88zkjqc4frn2";
      type = "gem";
    };
    version = "5.1.0";
  };
  highline = {
    dependencies = [ "reline" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jmvyhjp2v3iq47la7w6psrxbprnbnmzz0hxxski3vzn356x7jv7";
      type = "gem";
    };
    version = "3.1.2";
  };
  htmlentities = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1hy5jvzd4wagk0k0yq7bjm6fa7ba7vjggzjfpri95jifkzvbvbxv";
      type = "gem";
    };
    version = "4.4.2";
  };
  http_accept_language = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0d0nlfz9vm4jr1l6q0chx4rp2hrnrfbx3gadc1dz930lbbaz0hq0";
      type = "gem";
    };
    version = "2.1.1";
  };
  i18n = {
    dependencies = [ "concurrent-ruby" ];
    groups = [
      "default"
      "development"
      "migrations"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1994i044vdmzzkyr76g8rpl1fq1532wf0sb21xg5r1ilj5iphmr8";
      type = "gem";
    };
    version = "1.14.8";
  };
  image_optim = {
    dependencies = [
      "exifr"
      "fspath"
      "image_size"
      "in_threads"
      "progress"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "18rb5j4fl2p43f7fh47jf2v7yn2mckh38wdwmb148cp9isi5wza5";
      type = "gem";
    };
    version = "0.32.0";
  };
  image_size = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0a6b1p75nrmr1xvmqykn9dx947lrld1hb4l7m01zb2v5rfb4370v";
      type = "gem";
    };
    version = "3.6.0";
  };
  in_threads = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0j9132d4g8prjafgdh4pw948j527kr09m2lvylrcd797il9yd9wi";
      type = "gem";
    };
    version = "1.6.0";
  };
  inflection = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0mfkk0j0dway3p4gwzk8fnpi4hwaywl2v0iywf1azf98zhk9pfnf";
      type = "gem";
    };
    version = "1.0.0";
  };
  io-console = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "026v93kja19bfslnwi9xfq2dj4r89kkwdprim4whjg6h3n4lz9zg";
      type = "gem";
    };
    version = "0.9.2";
  };
  irb = {
    dependencies = [
      "pp"
      "prism"
      "rdoc"
      "reline"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qs8a9vprg7s8krgq4s0pygr91hclqqyz98ik15p0m1sf2h5956y";
      type = "gem";
    };
    version = "1.18.0";
  };
  iso8601 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "18js898rhh6byp0znvchiv6mcxi5l8v3v0bj2ddajpxynwajp319";
      type = "gem";
    };
    version = "0.13.0";
  };
  jmespath = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1cdw9vw2qly7q7r41s7phnac264rbsdqgj4l0h4nqgbjb157g393";
      type = "gem";
    };
    version = "1.6.2";
  };
  json = {
    groups = [
      "default"
      "development"
      "migrations"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0shwgjqbj856mb6m9kgkpy08nhym2gdvc2yaprlimfmky9y3n78z";
      type = "gem";
    };
    version = "2.21.2";
  };
  json-schema = {
    dependencies = [
      "addressable"
      "bigdecimal"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0rinh4347nvl9jm0r4mk7gi1zh1iz367w3dxn8d2r8j5v1pg9gz8";
      type = "gem";
    };
    version = "6.2.0";
  };
  json_completer = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1cbpy4zlgb21yins7a8z59hpmpc1x9cynqn512rcqkk3fa8p8ra6";
      type = "gem";
    };
    version = "1.2.0";
  };
  json_schemer = {
    dependencies = [
      "bigdecimal"
      "hana"
      "regexp_parser"
      "simpleidn"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "15p31bq932bfpsi1wgrkgwm71l7z1h1w53q6vl44w6kjrr6gn09g";
      type = "gem";
    };
    version = "2.5.0";
  };
  jwt = {
    dependencies = [ "base64" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1mqps8z4ly74hpksfajcfamqk1wb79biy187pn10knmi6zzb26al";
      type = "gem";
    };
    version = "3.2.0";
  };
  landlock = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "187b4k2rp5i3qgsz2d3bz2bg60dgldynka0fpx6zpq4c4gmcarjc";
      type = "gem";
    };
    version = "0.5.1";
  };
  language_server-protocol = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1w5p8c2145lmqzr25bxh4ikzjm6k8y1k5lriqqdpw9pq730w1wjy";
      type = "gem";
    };
    version = "3.17.0.6";
  };
  libv8-node = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "16kkimc2gq64ka6xabarqfs87yq24ha4mqr9m0xxxrdzc6w26gfr";
      type = "gem";
    };
    version = "24.12.0.1";
  };
  lint_roller = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "11yc0d84hsnlvx8cpk4cbj6a4dz9pk0r1k29p0n1fz9acddq831c";
      type = "gem";
    };
    version = "1.1.0";
  };
  liquid = {
    dependencies = [
      "bigdecimal"
      "strscan"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0wx6lan7kvhxz0i18m1vlnfhmkajxamxjkiyqlhmv4nd60j2qg2s";
      type = "gem";
    };
    version = "5.12.0";
  };
  listen = {
    dependencies = [
      "logger"
      "rb-fsevent"
      "rb-inotify"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ln9c0vx165hkfbn2817qw4m6i77xcxh6q0r5v6fqfhlcbdq5qf6";
      type = "gem";
    };
    version = "3.10.0";
  };
  literate_randomizer = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1c8p8aw93bx4ygpkwfv6dv41psb86jb0pi16gvnv30rr72dkq1q5";
      type = "gem";
    };
    version = "0.4.0";
  };
  logger = {
    groups = [
      "default"
      "development"
      "migrations"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "00q2zznygpbls8asz5knjvvj2brr3ghmqxgr83xnrdj4rk3xwvhr";
      type = "gem";
    };
    version = "1.7.0";
  };
  lograge = {
    dependencies = [
      "actionpack"
      "activesupport"
      "railties"
      "request_store"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "05nzwq2a5jyhcf0w4mbd3dd9yxd6q7zgadsi33f1jl5ra0gjq1rl";
      type = "gem";
    };
    version = "0.15.0";
  };
  logstash-event = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1bk7fhhryjxp1klr3hq6i6srrc21wl4p980bysjp0w66z9hdr9w9";
      type = "gem";
    };
    version = "1.2.02";
  };
  logster = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "00isn77kjxf33x17vbhx6hbjckbwggvr6s2mh7h9zy6mk3m73p2y";
      type = "gem";
    };
    version = "2.21.0";
  };
  loofah = {
    dependencies = [
      "crass"
      "nokogiri"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "062r891hxis58j5q735kk9sj5srxx0rv813f8m95bilsjm3gf1r0";
      type = "gem";
    };
    version = "2.25.2";
  };
  lru_redux = {
    groups = [
      "default"
      "migrations"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1yxghzg7476sivz8yyr9nkak2dlbls0b89vc2kg52k0nmg6d0wgf";
      type = "gem";
    };
    version = "1.1.0";
  };
  lz4-ruby = {
    groups = [ "default" ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "rbx";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "12fymsvcb9kw6ycyfzc8b9svriq0afqf1qnl121xrz8c4gpfa6q1";
      type = "gem";
    };
    version = "0.3.3";
  };
  mail = {
    dependencies = [
      "logger"
      "mini_mime"
      "net-imap"
      "net-pop"
      "net-smtp"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1s30l5z7jkazgi4m6l6mh80rgsyhh2pp1pa5h70xclsj8z54wmq6";
      type = "gem";
    };
    version = "2.9.1";
  };
  markbridge = {
    groups = [
      "default"
      "migrations"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "04jvacvsm24cycdircxbipfk2lky3d3zllw10r1gvll9fka5yr17";
      type = "gem";
    };
    version = "0.4.0";
  };
  matrix = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0nscas3a4mmrp1rc07cdjlbbpb2rydkindmbj3v3z5y1viyspmd0";
      type = "gem";
    };
    version = "0.4.3";
  };
  maxminddb = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0zlhqilyggiryywgswfi624bv10qnkm66hggmg79vvgv73j3p4sh";
      type = "gem";
    };
    version = "0.1.22";
  };
  memory_profiler = {
    groups = [ "default" ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1y58ba08n4lx123c0hjcc752fc4x802mjy39qj1hq50ak3vpv8br";
      type = "gem";
    };
    version = "1.1.0";
  };
  message_bus = {
    dependencies = [
      "logger"
      "rack"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ky0lk2nw4n1znna1b4gr4c5rf9f99kx1did2y2hh503h4xl3fwv";
      type = "gem";
    };
    version = "5.0.0";
  };
  messageformat-wrapper = {
    dependencies = [ "mini_racer" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1g30y5qv6jx39qz5g0yai37n46mvzjn7si8whjyd24p44sb8gspc";
      type = "gem";
    };
    version = "1.1.0";
  };
  method_source = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1igmc3sq9ay90f8xjvfnswd1dybj1s3fi0dwd53inwsvqk4h24qq";
      type = "gem";
    };
    version = "1.1.0";
  };
  migrations-converters = {
    dependencies = [
      "activesupport"
      "colored2"
      "discourse-emojis"
      "i18n"
      "markbridge"
      "migrations-core"
      "mini_racer"
      "pg"
      "zeitwerk"
    ];
    groups = [ "migrations" ];
    platforms = [ ];
    source = {
      path = "${src}/migrations/converters";
      type = "path";
    };
    version = "0.0.1";
  };
  migrations-core = {
    dependencies = [
      "activesupport"
      "colored2"
      "concurrent-ruby"
      "digest-xxhash"
      "extralite-bundle"
      "i18n"
      "json"
      "lru_redux"
      "samovar"
      "unicode-display_width"
      "zeitwerk"
    ];
    groups = [ "migrations" ];
    platforms = [ ];
    source = {
      path = "${src}/migrations/core";
      type = "path";
    };
    version = "0.0.1";
  };
  migrations-importer = {
    dependencies = [
      "activerecord"
      "activesupport"
      "colored2"
      "i18n"
      "migrations-core"
      "pg"
      "zeitwerk"
    ];
    groups = [ "migrations" ];
    platforms = [ ];
    source = {
      path = "${src}/migrations/importer";
      type = "path";
    };
    version = "0.0.1";
  };
  migrations-tooling = {
    dependencies = [
      "activerecord"
      "activesupport"
      "colored2"
      "i18n"
      "migrations-core"
      "zeitwerk"
    ];
    groups = [ "migrations" ];
    platforms = [ ];
    source = {
      path = "${src}/migrations/tooling";
      type = "path";
    };
    version = "0.0.1";
  };
  mime-types = {
    dependencies = [
      "logger"
      "mime-types-data"
    ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0mjyxl7c0xzyqdqa8r45hqg7jcw2prp3hkp39mdf223g4hfgdsyw";
      type = "gem";
    };
    version = "3.7.0";
  };
  mime-types-data = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03vkd9g09jnxsp8mdacvjbplrrqfl5l26n50kd4kdn49zghi326d";
      type = "gem";
    };
    version = "3.2026.0701";
  };
  mini_mime = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vycif7pjzkr29mfk4dlqv3disc5dn0va04lkwajlpr1wkibg0c6";
      type = "gem";
    };
    version = "1.1.5";
  };
  mini_portile2 = {
    groups = [
      "default"
      "development"
      "generic_import"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "12f2830x7pq3kj0v8nz0zjvaw02sv01bqs1zwdrc04704kwcgmqc";
      type = "gem";
    };
    version = "2.8.9";
  };
  mini_racer = {
    dependencies = [ "libv8-node" ];
    groups = [
      "default"
      "migrations"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "12ji47z8dn6g70c1ni70rfbrkjapnspvsmlqpy479raz0fjbm9y0";
      type = "gem";
    };
    version = "0.22.1";
  };
  mini_scheduler = {
    dependencies = [ "sidekiq" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "01bvk73g922jq34531ix86aq5dhn1n2xw84f79h8m97lici4i2dx";
      type = "gem";
    };
    version = "0.20.0";
  };
  mini_sql = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vnn88gv935szjz2hndnisfgys19k9z07237w11vpxaad9zn75jj";
      type = "gem";
    };
    version = "1.6.0";
  };
  mini_suffix = {
    dependencies = [ "ffi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1rr2nx1kixd7ccxqdnswjnflg46s6lr1f9vxkdy298k95zwk67cd";
      type = "gem";
    };
    version = "0.3.3";
  };
  minitest = {
    dependencies = [
      "drb"
      "prism"
    ];
    groups = [
      "default"
      "development"
      "migrations"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1wfnqyfayx9n9j7x871v2ars4hjhfisi1dl24fa64ylq3mns6ghm";
      type = "gem";
    };
    version = "6.0.6";
  };
  mocha = {
    dependencies = [ "ruby2_keywords" ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0mhx9qyiig73mw3zrk8f28ca8dqx8gwgipw94jri07zvxdljvx3m";
      type = "gem";
    };
    version = "3.1.0";
  };
  msgpack = {
    groups = [ "default" ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0yry1bcnbl0c5xwg173n5y647596r8ydmsppa01c5l8d6lnw44a4";
      type = "gem";
    };
    version = "1.8.4";
  };
  multi_json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1040lr5y2phn7avdyam6zw6ikprlmk77biw3yhclsfwfh0qnl4p6";
      type = "gem";
    };
    version = "1.21.1";
  };
  multi_xml = {
    dependencies = [ "bigdecimal" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0msflv26i6i3jr9w761k4qdl7cp9zbhymjkn57b1w90pkjsndrvw";
      type = "gem";
    };
    version = "0.9.1";
  };
  multipart-post = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1a5lrlvmg2kb2dhw3lxcsv6x276bwgsxpnka1752082miqxd0wlq";
      type = "gem";
    };
    version = "2.4.1";
  };
  mustache = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1hlks2kkf3drbjb811cxyfp8f84rn9kjh9icms7idbz42ymgxgbm";
      type = "gem";
    };
    version = "1.1.3";
  };
  net-http = {
    dependencies = [ "uri" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "15k96fj6qwbaiv6g52l538ass95ds1qwgynqdridz29yqrkhpfi5";
      type = "gem";
    };
    version = "0.9.1";
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
      sha256 = "1px886qvws5zvqphy5cysj8vg01lym0w7vs9wq1h41pk1pjlxaln";
      type = "gem";
    };
    version = "0.6.6";
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
      sha256 = "0wklahcafcib6jwrr3angj7zzcb9csq3c0xj3axldb8w9wyhqcds";
      type = "gem";
    };
    version = "0.3.0";
  };
  net-smtp = {
    dependencies = [ "net-protocol" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0dh7nzjp0fiaqq1jz90nv4nxhc2w359d7c199gmzq965cfps15pd";
      type = "gem";
    };
    version = "0.5.1";
  };
  nio4r = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "18fwy5yqnvgixq3cn0h63lm8jaxsjjxkmj8rhiv8wpzv9271d43c";
      type = "gem";
    };
    version = "2.7.5";
  };
  nokogiri = {
    dependencies = [
      "mini_portile2"
      "racc"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1d9safb4dly6qmc2g06444l0zifby52yy6j1a5fa1g4j3ihm3jah";
      type = "gem";
    };
    version = "1.19.4";
  };
  oauth = {
    dependencies = [
      "anonymous_loader"
      "auth-sanitizer"
      "base64"
      "oauth-tty"
      "snaky_hash"
      "version_gem"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03nm2qp4pzswaf93ammm458ssgwcldzwrqkcm0hgix0s75sbgw3v";
      type = "gem";
    };
    version = "1.1.8";
  };
  oauth-tty = {
    dependencies = [
      "anonymous_loader"
      "auth-sanitizer"
      "version_gem"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "18xlmsfkzmqvx01v7q3pkpgcb4mqlh1dqcd7x4gx4vzars9mzbbi";
      type = "gem";
    };
    version = "1.0.13";
  };
  oauth2 = {
    dependencies = [
      "anonymous_loader"
      "auth-sanitizer"
      "faraday"
      "jwt"
      "logger"
      "multi_xml"
      "rack"
      "snaky_hash"
      "version_gem"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1b42dax3qwm1zbz86c9zcii7v45vi6c3rp083dyadjn2jcpnlwrg";
      type = "gem";
    };
    version = "2.0.25";
  };
  octokit = {
    dependencies = [
      "faraday"
      "sawyer"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1s14kbjfm9vdvcrwqdarfdbfsjqs1jxpglp60plvfdvnkd9rmsc2";
      type = "gem";
    };
    version = "10.0.0";
  };
  oj = {
    dependencies = [
      "bigdecimal"
      "ostruct"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1376v0gnz0b6ldzgahf7m5795jkgx793q0mqrv1k085105z2a4gm";
      type = "gem";
    };
    version = "3.17.6";
  };
  omniauth = {
    dependencies = [
      "hashie"
      "rack"
      "rack-protection"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1km0wqx9pj609jidvrqfsvzbzfgdnlpdnv7i7xfqm3wb55vk5w6y";
      type = "gem";
    };
    version = "2.1.2";
  };
  omniauth-facebook = {
    dependencies = [
      "bigdecimal"
      "omniauth-oauth2"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qdrziqfa4sqpqf77i0nzbwq4qyg8qaqd127alnmg1skvax6rp6z";
      type = "gem";
    };
    version = "10.0.0";
  };
  omniauth-github = {
    dependencies = [
      "omniauth"
      "omniauth-oauth2"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1m6a7kg3lxz2nm96prln2ja8r4wlm37m5vsy9199vnynqq5fgy4g";
      type = "gem";
    };
    version = "2.0.1";
  };
  omniauth-google-oauth2 = {
    dependencies = [
      "jwt"
      "oauth2"
      "omniauth"
      "omniauth-oauth2"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1a8xgjc4g29cx6va72db2nxfyp2p4ligrp72xq17j2z5cizbdfmx";
      type = "gem";
    };
    version = "1.2.3";
  };
  omniauth-oauth = {
    dependencies = [
      "oauth"
      "omniauth"
      "rack"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1a4dqmlv3if6hb4ddyx4y5v7vkpi7zq901104nl0ya1l0b4j5gr5";
      type = "gem";
    };
    version = "1.2.1";
  };
  omniauth-oauth2 = {
    dependencies = [
      "oauth2"
      "omniauth"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1s7yagqmzzqcr5l1rrb4bdjf7g2k2jf5pk0lw5y81489sbczc5gd";
      type = "gem";
    };
    version = "1.9.0";
  };
  omniauth-twitter = {
    dependencies = [
      "cgi"
      "omniauth-oauth"
      "rack"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qv2ld087mnj38rlgjdp5h894gf01mwj5xypw5agdchk8598im7p";
      type = "gem";
    };
    version = "1.5.0";
  };
  openssl = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1hj7wwp4r3jhvnyd8ik85wbs25cq1w61r28pv6ddyn5fd0lasdqh";
      type = "gem";
    };
    version = "4.0.2";
  };
  openssl-signature_algorithm = {
    dependencies = [ "openssl" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "103yjl68wqhl5kxaciir5jdnyi7iv9yckishdr52s5knh9g0pd53";
      type = "gem";
    };
    version = "1.3.0";
  };
  optimist = {
    groups = [ "default" ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0kp3f8g7g7cbw5vfkmpdv71pphhpcxk3lpc892mj9apkd7ys1y4c";
      type = "gem";
    };
    version = "3.2.1";
  };
  ostruct = {
    groups = [
      "default"
      "development"
    ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "04nrir9wdpc4izqwqbysxyly8y7hsfr4fsv69rw91lfi9d5fv8lm";
      type = "gem";
    };
    version = "0.6.3";
  };
  parallel = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0mlkn1vhh9lr7vljibpgspwsswk7mzm8nw6bbr616c9fbj35hlmk";
      type = "gem";
    };
    version = "2.1.0";
  };
  parallel_tests = {
    dependencies = [ "parallel" ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0p003p7qpdc04m7r7yhv3579fxlxgwhpgy4fmyw27hm2dk2645rz";
      type = "gem";
    };
    version = "5.7.0";
  };
  parser = {
    dependencies = [
      "ast"
      "racc"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0a4q5h2hcihk79dbr20scgkm56l79qp7fsvfvkxlv8nmapvxg9i1";
      type = "gem";
    };
    version = "3.3.12.0";
  };
  pastel = {
    dependencies = [ "tty-color" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xash2gj08dfjvq4hy6l1z22s5v30fhizwgs10d6nviggpxsj7a8";
      type = "gem";
    };
    version = "0.8.0";
  };
  pdf-reader = {
    dependencies = [
      "Ascii85"
      "afm"
      "hashery"
      "ttfunk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0cipbx3ssgfsww7hrlll2j27b2vpcwaczqxxg614s9l5q1j5a6xz";
      type = "gem";
    };
    version = "2.16.0";
  };
  pg = {
    groups = [
      "default"
      "migrations"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "16caca7lcz5pwl82snarqrayjj9j7abmxqw92267blhk7rbd120k";
      type = "gem";
    };
    version = "1.6.3";
  };
  pitchfork = {
    dependencies = [
      "logger"
      "rack"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "155bskm6j5n78b6jxhqwzyn25zsjcqh8mgbsc96wkswjayibbl4m";
      type = "gem";
    };
    version = "0.18.2";
  };
  playwright-ruby-client = {
    dependencies = [
      "base64"
      "concurrent-ruby"
      "mime-types"
    ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "05apnpyyqpwwfa3rjwqn05l5jgj0j9wdp9w82a5gd1vrmd8n1ss4";
      type = "gem";
    };
    version = "1.62.0";
  };
  pp = {
    dependencies = [ "prettyprint" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0w5mha75hs8gdj75g8vl0sxpyp8rzvwq8a4jcmi4ah8cf370zjyz";
      type = "gem";
    };
    version = "0.6.4";
  };
  prettier_print = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ybgks9862zmlx71zd4j20ky86fsrp6j6m0az4hzzb1zyaskha57";
      type = "gem";
    };
    version = "1.2.1";
  };
  prettyprint = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "14zicq3plqi217w6xahv7b8f7aj5kpxv1j1w98344ix9h5ay3j9b";
      type = "gem";
    };
    version = "0.2.0";
  };
  prism = {
    groups = [
      "default"
      "development"
      "migrations"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "11ggfikcs1lv17nhmhqyyp6z8nq5pkfcj6a904047hljkxm0qlvv";
      type = "gem";
    };
    version = "1.9.0";
  };
  progress = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0wymdk40cwrqn32gwg1kw94s5p1n0z3n7ma7x1s62gd4vw3d63in";
      type = "gem";
    };
    version = "3.6.0";
  };
  propshaft = {
    dependencies = [
      "actionpack"
      "activesupport"
      "rack"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "17iqn4sa59c9z5y3bpvxqka00srqnl379w6a57y1phljdbjs6mhx";
      type = "gem";
    };
    version = "1.3.2";
  };
  pry = {
    dependencies = [
      "coderay"
      "method_source"
      "reline"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0kh5nv8v74k1ccy6gc7nd04aaf1cjkbk7g8pwy2izvcqaq36jv6p";
      type = "gem";
    };
    version = "0.16.0";
  };
  pry-rails = {
    dependencies = [ "pry" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0garafb0lxbm3sx2r9pqgs7ky9al58cl3wmwc0gmvmrl9bi2i7m6";
      type = "gem";
    };
    version = "0.3.11";
  };
  public_suffix = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "08znfv30pxmdkjyihvbjqbvv874dj3nybmmyscl958dy3f7v12qs";
      type = "gem";
    };
    version = "7.0.5";
  };
  puma = {
    dependencies = [ "nio4r" ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1yw6nvkvddriacmva8hm0za0961d6j96dm7zm6748rmyzcfqgvf8";
      type = "gem";
    };
    version = "8.0.2";
  };
  racc = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0byn0c9nkahsl93y9ln5bysq4j31q8xkf2ws42swighxd4lnjzsa";
      type = "gem";
    };
    version = "1.8.1";
  };
  rack = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0pyammr7fpxqa1sdvw0vnk4699j081sqqcsj6isl67471mm545pg";
      type = "gem";
    };
    version = "2.2.24";
  };
  rack-mini-profiler = {
    dependencies = [ "rack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1q822cwrs4khc4l4jgc6dsnvw7iz46rgchqam2dqs759gw4bmicr";
      type = "gem";
    };
    version = "5.0.0";
  };
  rack-protection = {
    dependencies = [
      "base64"
      "rack"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1zzvivmdb4dkscc58i3gmcyrnypynsjwp6xgc4ylarlhqmzvlx1w";
      type = "gem";
    };
    version = "3.2.0";
  };
  rack-session = {
    dependencies = [ "rack" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xhxhlsz6shh8nm44jsmd9276zcnyzii364vhcvf0k8b8bjia8d0";
      type = "gem";
    };
    version = "1.0.2";
  };
  rack-test = {
    dependencies = [ "rack" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0qy4ylhcfdn65a5mz2hly7g9vl0g13p5a0rmm6sc0sih5ilkcnh0";
      type = "gem";
    };
    version = "2.2.0";
  };
  rackup = {
    dependencies = [
      "rack"
      "webrick"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jf2ncj2nx56vh96hh2nh6h4r530nccxh87z7c2f37wq515611ms";
      type = "gem";
    };
    version = "1.0.1";
  };
  rails-dom-testing = {
    dependencies = [
      "activesupport"
      "minitest"
      "nokogiri"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "07awj8bp7jib54d0khqw391ryw8nphvqgw4bb12cl4drlx9pkk4a";
      type = "gem";
    };
    version = "2.3.0";
  };
  rails-html-sanitizer = {
    dependencies = [
      "loofah"
      "nokogiri"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1hi25xz5ijz3kjx4vsiywqbq05mlkas7di8pwc3p6mhyn34sg5z7";
      type = "gem";
    };
    version = "1.7.1";
  };
  rails_failover = {
    dependencies = [
      "activerecord"
      "concurrent-ruby"
      "railties"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1jcijjfz595nd1h0z4h2jb7iw4md5snrglha0xmryvzxfh3fmmpf";
      type = "gem";
    };
    version = "2.3.0";
  };
  rails_multisite = {
    dependencies = [
      "activerecord"
      "railties"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1rlmwimr8yb7dhid36b5lgaf337bqh8ml28jaw2x326b0l28zj1b";
      type = "gem";
    };
    version = "9.0.0";
  };
  railties = {
    dependencies = [
      "actionpack"
      "activesupport"
      "irb"
      "rackup"
      "rake"
      "thor"
      "tsort"
      "zeitwerk"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "11s4n3zqd7bry5ndraq02f641hskhmnfcza8lkzcw04sawra5213";
      type = "gem";
    };
    version = "8.1.3.1";
  };
  rainbow = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0smwg4mii0fm38pyb5fddbmrdpifwv22zv3d3px2xx497am93503";
      type = "gem";
    };
    version = "3.1.1";
  };
  raindrops = {
    groups = [ "default" ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "rbx";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0c27mcglrj928zkm4d2spj9yh2xkkka8ns5s6bidkwild3zvj3ma";
      type = "gem";
    };
    version = "0.20.1";
  };
  rake = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "009p524zl0p0kfa65nii8wdmaigkmawv9pbvlcffky7islmmp0nb";
      type = "gem";
    };
    version = "13.4.2";
  };
  rake-compiler-dock = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "08w033c3p25wr0zwbgx0b4mb4ha5kqd4j0ydmx9j0gcgfg10acpi";
      type = "gem";
    };
    version = "1.12.0";
  };
  rb-fsevent = {
    groups = [
      "development"
      "test"
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
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0vmy8xgahixcz6hzwy4zdcyn2y6d6ri8dqv5xccgzc1r292019x0";
      type = "gem";
    };
    version = "0.11.1";
  };
  rb_sys = {
    dependencies = [ "rake-compiler-dock" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "05c6ak9wgzf7xqnrnn5j9axr1sjszih9ibyy2man60nsq6cnsj3x";
      type = "gem";
    };
    version = "0.9.130";
  };
  rbs = {
    dependencies = [
      "logger"
      "prism"
      "tsort"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0x067q8cdam4kv5dc09iq2nzca8qm2kdl0dr22gc0ny0vj3bixsi";
      type = "gem";
    };
    version = "4.2.0";
  };
  rbtrace = {
    dependencies = [
      "ffi"
      "msgpack"
      "optimist"
    ];
    groups = [ "default" ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0s7yfa35d35lw0lr2wy2fcv4fk6ndkrm4bj1chs1y9f4xbzh00pd";
      type = "gem";
    };
    version = "0.5.5";
  };
  rdoc = {
    dependencies = [
      "erb"
      "prism"
      "rbs"
      "tsort"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0sf4909q2mr9z0rpygv94z12b0yamg07gz8cba2mi5k3m448rgq3";
      type = "gem";
    };
    version = "8.0.0";
  };
  redcarpet = {
    groups = [ "generic_import" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0iglapqs4av4za9yfaac0lna7s16fq2xn36wpk380m55d8792i6l";
      type = "gem";
    };
    version = "3.6.1";
  };
  redis = {
    dependencies = [ "redis-client" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "19ndpji1plvkvb0x180lfkpc1fb3ig8cszpcb6vqcs8hvl7c2wfy";
      type = "gem";
    };
    version = "6.0.0";
  };
  redis-client = {
    dependencies = [ "connection_pool" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0baj2r8wa6imzfndyz6cj732v8nq02wy7nicfciqdr5zgdfbqlai";
      type = "gem";
    };
    version = "0.30.1";
  };
  redis-namespace = {
    dependencies = [ "redis" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0f92i9cwlp6xj6fyn7qn4qsaqvxfw4wqvayll7gbd26qnai1l6p9";
      type = "gem";
    };
    version = "1.11.0";
  };
  regexp_parser = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1fwfw26a32rps78920nn29shqg2zmqv72i89j1fap41isshida9m";
      type = "gem";
    };
    version = "2.12.0";
  };
  reline = {
    dependencies = [ "io-console" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0gaq2lc463ap1srz7y5kh2p4dxazs7vjrpiby58d9yfvan72s0av";
      type = "gem";
    };
    version = "0.7.0";
  };
  request_store = {
    dependencies = [ "rack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1jw89j9s5p5cq2k7ffj5p4av4j4fxwvwjs1a4i9g85d38r9mvdz1";
      type = "gem";
    };
    version = "1.7.0";
  };
  reverse_markdown = {
    dependencies = [ "nokogiri" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1bxqlpwnixn8x4bnna958w6m6qkdkbnd23b9j6ib3nrrrs9bp3l1";
      type = "gem";
    };
    version = "3.0.2";
  };
  rexml = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0hninnbvqd2pn40h863lbrn9p11gvdxp928izkag5ysx8b1s5q0r";
      type = "gem";
    };
    version = "3.4.4";
  };
  rinku = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0zcdha17s1wzxyc5814j6319wqg33jbn58pg6wmxpws36476fq4b";
      type = "gem";
    };
    version = "2.0.6";
  };
  rotp = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0m48hv6wpmmm6cjr6q92q78h1i610riml19k5h1dil2yws3h1m3m";
      type = "gem";
    };
    version = "6.3.0";
  };
  rouge = {
    dependencies = [ "strscan" ];
    groups = [
      "default"
      "development"
    ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ljlr1da64kx3mimpzb4x2yczk08b0sg04h2ji3m2zxb88l66z5p";
      type = "gem";
    };
    version = "5.1.0";
  };
  rqrcode = {
    dependencies = [
      "chunky_png"
      "rqrcode_core"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0hlm1cfqs891irh4pl6wynsfm7nh7w7baf0g6cqxfrxvlr64khb4";
      type = "gem";
    };
    version = "3.2.0";
  };
  rqrcode_core = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0l9hl5nb7jx8sjchsrlv6bk30hywr449ihcdxv2qy6wwz1fvh0zk";
      type = "gem";
    };
    version = "2.1.0";
  };
  rrule = {
    dependencies = [ "activesupport" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1wm40i2hnfwxzzsp0fm6jw0a4wlkb3sw5s9d05wihi7y9qrrmcdb";
      type = "gem";
    };
    version = "0.8.0";
  };
  rspec = {
    dependencies = [
      "rspec-core"
      "rspec-expectations"
      "rspec-mocks"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "11q5hagj6vr694innqj4r45jrm8qcwvkxjnphqgyd66piah88qi0";
      type = "gem";
    };
    version = "3.13.2";
  };
  rspec-core = {
    dependencies = [ "rspec-support" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0bcbh9yv6cs6pv299zs4bvalr8yxa51kcdd1pjl60yv625j3r0m8";
      type = "gem";
    };
    version = "3.13.6";
  };
  rspec-expectations = {
    dependencies = [
      "diff-lcs"
      "rspec-support"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0dl8npj0jfpy31bxi6syc7jymyd861q277sfr6jawq2hv6hx791k";
      type = "gem";
    };
    version = "3.13.5";
  };
  rspec-html-matchers = {
    dependencies = [
      "nokogiri"
      "rspec"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1bp9q28qw4xmxknrrp3ppcr08bbcnnand6r9prw4920407mvy96l";
      type = "gem";
    };
    version = "0.10.0";
  };
  rspec-mocks = {
    dependencies = [
      "diff-lcs"
      "rspec-support"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0iqxmw0knjiz5nf6pgr8ihs6cjzh89f0ppj3fqiz8cvms79x6sh8";
      type = "gem";
    };
    version = "3.13.8";
  };
  rspec-multi-mock = {
    dependencies = [ "rspec" ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0k3rafylxilq9jzdz450vgiwf3bvz4a9l3ppmgncv78xipr71518";
      type = "gem";
    };
    version = "0.3.1";
  };
  rspec-rails = {
    dependencies = [
      "actionpack"
      "activesupport"
      "railties"
      "rspec-core"
      "rspec-expectations"
      "rspec-mocks"
      "rspec-support"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1pr29snnnlgkqv80vbi4795l6rxq3l47x5rl7lyni4h8zj95c8q6";
      type = "gem";
    };
    version = "8.0.4";
  };
  rspec-support = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0z64h5rznm2zv21vjdjshz4v0h7bxvg02yc6g7yzxakj11byah06";
      type = "gem";
    };
    version = "3.13.7";
  };
  rss = {
    dependencies = [ "rexml" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ayi296p6gdf15h28ckbd9g9d8499sd0fn91x7dpxmlisv21xvrp";
      type = "gem";
    };
    version = "0.3.3";
  };
  rswag-specs = {
    dependencies = [
      "activesupport"
      "json-schema"
      "railties"
      "rspec-core"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qx9mxhnwz8ia9ry1fwn3hzc2zg7n774gvm4whgp9y49vzvbvcm3";
      type = "gem";
    };
    version = "2.17.0";
  };
  rtlcss = {
    dependencies = [ "mini_racer" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0q5zlx1k4gqyq0rvnfkljvrwa73ysycxc5m5ly9py9k1pw05lg91";
      type = "gem";
    };
    version = "0.2.1";
  };
  rubocop = {
    dependencies = [
      "json"
      "language_server-protocol"
      "lint_roller"
      "parallel"
      "parser"
      "rainbow"
      "regexp_parser"
      "rubocop-ast"
      "ruby-progressbar"
      "unicode-display_width"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1l4nh82hq54nxgyisdcf8vbkpzm149p9kff5k0vpwp8w76zvg0lw";
      type = "gem";
    };
    version = "1.91.0";
  };
  rubocop-ast = {
    dependencies = [
      "parser"
      "prism"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1nw84xk6vc2ls8sxqvyhxs2agh4l0jrws85d4bi3x0501lq8ijmr";
      type = "gem";
    };
    version = "1.50.0";
  };
  rubocop-capybara = {
    dependencies = [
      "lint_roller"
      "rubocop"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jwcfv1hs9r838zjaz61g5d62k564p47mqw77j7pznmc7196ar3s";
      type = "gem";
    };
    version = "3.0.0";
  };
  rubocop-discourse = {
    dependencies = [
      "activesupport"
      "lint_roller"
      "rubocop-capybara"
      "rubocop-discourse-base"
      "rubocop-factory_bot"
      "rubocop-rails"
      "rubocop-rspec"
      "rubocop-rspec_rails"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0w4w3qxah2ci39hqbgvkvx0bv1kb9by1a9p8k29lczlkkg7nn227";
      type = "gem";
    };
    version = "3.20.0";
  };
  rubocop-discourse-base = {
    dependencies = [ "rubocop" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1dvjniwyxgbkjv3b055cpqn3fdgxz5m108pfkwjw6clf587iy4m4";
      type = "gem";
    };
    version = "1.0.0";
  };
  rubocop-factory_bot = {
    dependencies = [
      "lint_roller"
      "rubocop"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1jzhj9fi1h9rh7z2j6m78hl7c3av36fpacg12wrifi24281gq5sb";
      type = "gem";
    };
    version = "2.28.0";
  };
  rubocop-rails = {
    dependencies = [
      "activesupport"
      "lint_roller"
      "rack"
      "rubocop"
      "rubocop-ast"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0zjby5icpp5r9gqqnfcl2dcpqsam1y10vnnxz0l063h6snnla5kf";
      type = "gem";
    };
    version = "2.37.0";
  };
  rubocop-rspec = {
    dependencies = [
      "lint_roller"
      "regexp_parser"
      "rubocop"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qk5bx4vg7n17i9475h6dqkhay9m3s6vanq9y35hxl9cb762wghb";
      type = "gem";
    };
    version = "3.10.2";
  };
  rubocop-rspec_rails = {
    dependencies = [
      "lint_roller"
      "rubocop"
      "rubocop-rspec"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "004i5a4iww7l3vpaxl70ijypmi321afrslsgadbvksznf8f683aa";
      type = "gem";
    };
    version = "2.32.0";
  };
  ruby-lsp = {
    dependencies = [
      "language_server-protocol"
      "prism"
      "rbs"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0gaq685p1zizhsbax8gakraq46lhvy8m82v86688rzrpf9cg3j2c";
      type = "gem";
    };
    version = "0.26.11";
  };
  ruby-lsp-rails = {
    dependencies = [ "ruby-lsp" ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1bj4bj35l9jas2yf6w93j5ngw3f24lck2j9h5zmxwqs0dn91z7gh";
      type = "gem";
    };
    version = "0.4.8";
  };
  ruby-lsp-rspec = {
    dependencies = [ "ruby-lsp" ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1raf477s25l50rylq0p2rzj664gvi0r3fckxn5bcsxikf9wyb2vr";
      type = "gem";
    };
    version = "0.1.29";
  };
  ruby-prof = {
    dependencies = [
      "base64"
      "ostruct"
    ];
    groups = [ "development" ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03kcdnip5zv7m529xc05pk6vsz6prfq5s5036g1qllw9408vbhyv";
      type = "gem";
    };
    version = "2.0.5";
  };
  ruby-progressbar = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0cwvyb7j47m7wihpfaq7rc47zwwx9k4v7iqd9s1xch5nm53rrz40";
      type = "gem";
    };
    version = "1.13.0";
  };
  ruby-rc4 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "00vci475258mmbvsdqkmqadlwn6gj9m01sp7b5a3zd90knil1k00";
      type = "gem";
    };
    version = "0.1.5";
  };
  ruby-readability = {
    dependencies = [
      "guess_html_encoding"
      "nokogiri"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0hf2xwvjlsmkizkk7h3qvj4vdiicxal6gqcrv4awq63i0fmky8dx";
      type = "gem";
    };
    version = "0.7.3";
  };
  ruby-vips = {
    dependencies = [
      "ffi"
      "logger"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0x2k5x272m2zs0vmznl2jac14bj9a2g0365xxcnr2s9rq41fr1g6";
      type = "gem";
    };
    version = "2.3.0";
  };
  ruby2_keywords = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vz322p8n39hz3b4a9gkmz9y7a5jaz41zrm2ywf31dvkqm03glgz";
      type = "gem";
    };
    version = "0.0.5";
  };
  rubyzip = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "15dnb2admqpyw6ipxbaqj4cnfwldwkm11gwrzlf2sa329pa99296";
      type = "gem";
    };
    version = "3.6.0";
  };
  samovar = {
    dependencies = [ "console" ];
    groups = [
      "default"
      "migrations"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "15133m5jihv7pv00dcrg51yvrkw5qiw1dd0y6bq89046p0gc97wa";
      type = "gem";
    };
    version = "2.5.1";
  };
  sanitize = {
    dependencies = [
      "crass"
      "nokogiri"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "111r4xdcf6ihdnrs6wkfc6nqdzrjq0z69x9sf83r7ri6fffip796";
      type = "gem";
    };
    version = "7.0.0";
  };
  sass-embedded = {
    dependencies = [
      "google-protobuf"
      "rake"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1zcvhvamsmphnai6wjbqk73gpz52ifaya5fmarsxg5nyj347r31h";
      type = "gem";
    };
    version = "1.104.0";
  };
  sassc-embedded = {
    dependencies = [ "sass-embedded" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1apy1n0x79in6l88f6m7ynkq06a7hpwighywq538cm41a63sv45z";
      type = "gem";
    };
    version = "1.80.9";
  };
  sawyer = {
    dependencies = [
      "addressable"
      "faraday"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0hayryyz46nlkcb6j0ij0kxq6i3ryiigwfc6ccvp0108hhlij3qd";
      type = "gem";
    };
    version = "0.9.3";
  };
  securerandom = {
    groups = [
      "default"
      "development"
      "migrations"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1cd0iriqfsf1z91qg271sm88xjnfd92b832z49p1nd542ka96lfc";
      type = "gem";
    };
    version = "0.4.1";
  };
  shoulda-matchers = {
    dependencies = [ "activesupport" ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1202qsi1xsskl4qa9fwlzwhs3j783445w20v24js57avfvjldfsx";
      type = "gem";
    };
    version = "8.0.1";
  };
  sidekiq = {
    dependencies = [
      "base64"
      "connection_pool"
      "logger"
      "rack"
      "redis-client"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0g4fxxr1kvd4mn3cgvl2xrzznfi827r74gfp999l4q7kbvvb87kq";
      type = "gem";
    };
    version = "7.3.10";
  };
  simplecov = {
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0y0ya82s3zi2wmkadnmb3l9r13mbsvd1g63n9mlp8bhb7zqmx0i5";
      type = "gem";
    };
    version = "1.1.1";
  };
  simpleidn = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "00sdym5q3d9zg7lv47mjamzv67z1lfyd3gz9256v0g9gxl5p7jhj";
      type = "gem";
    };
    version = "0.3.0";
  };
  smarter_json = {
    dependencies = [ "bigdecimal" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0i9bf8d2q251riqr65ix5yvk27c7p7swid0jh8k6vqjl779a4f36";
      type = "gem";
    };
    version = "1.2.6";
  };
  snaky_hash = {
    dependencies = [
      "hashie"
      "version_gem"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0kfbrd4sgajhnjwhqpk1mb4h10whfx2h5kb0i3j35yd3280cf0kx";
      type = "gem";
    };
    version = "2.0.7";
  };
  sqlite3 = {
    dependencies = [ "mini_portile2" ];
    groups = [ "generic_import" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "13nh4kd96d28dv3habjv2fiap30ccb73lz8mqx5d0834jl3fcvwm";
      type = "gem";
    };
    version = "2.9.6";
  };
  sshkey = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1k8i5pzjhcnyf0bhcyn5iixpfp4pz0556rcxwpglh6p0sr8s6nv5";
      type = "gem";
    };
    version = "3.0.0";
  };
  ssrf_filter = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1xlpb8y555frl82cx4q2i922mps36mmn0ajk21kpy3bks6wwsgg0";
      type = "gem";
    };
    version = "1.5.0";
  };
  stackprof = {
    groups = [ "default" ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "014s1zxlxcw35shislar3y1i3mqa0c6gh3m21js14q1q5zharhjf";
      type = "gem";
    };
    version = "0.2.28";
  };
  stripe = {
    dependencies = [
      "bigdecimal"
      "logger"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "176l1phy2yayxm7r4q8dnbyfgc22wb0p1rwwxzdhmfjsl9v4jqcs";
      type = "gem";
    };
    version = "19.6.2";
  };
  strscan = {
    groups = [
      "default"
      "development"
    ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "17k75zrwf4ag9yl9wjjkcb90zrm4r5jigdzv3zr5jm9239hxpqma";
      type = "gem";
    };
    version = "3.1.8";
  };
  syntax_tree = {
    dependencies = [ "prettier_print" ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ggi6p7xxjsj42q8pp0yz6z7dbwlbr6fjbs4qnafr667jab5mqjn";
      type = "gem";
    };
    version = "6.3.0";
  };
  test-prof = {
    dependencies = [ "logger" ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "188p735jnx0bxm53ysfwsrxcwvj4dfgj1r10k037c9rbc4bylyh2";
      type = "gem";
    };
    version = "1.6.3";
  };
  thor = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0wsy88vg2mazl039392hqrcwvs5nb9kq8jhhrrclir2px1gybag3";
      type = "gem";
    };
    version = "1.5.0";
  };
  tiktoken_ruby = {
    dependencies = [ "rb_sys" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1hr7x8v5yzys8s5js4s36b0p0j8klqs559wsbaxdhxdbkv6qnaly";
      type = "gem";
    };
    version = "0.0.17";
  };
  timeout = {
    groups = [
      "default"
      "development"
      "migrations"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1jxcji88mh6xsqz0mfzwnxczpg7cyniph7wpavnavfz7lxl77xbq";
      type = "gem";
    };
    version = "0.6.1";
  };
  tokenizers = {
    dependencies = [ "rb_sys" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0iwgirp1bwsfdyk7r9k3favj51hkppa85hz0dgn5sq3yxspz50bq";
      type = "gem";
    };
    version = "0.6.4";
  };
  tsort = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "17q8h020dw73wjmql50lqw5ddsngg67jfw8ncjv476l5ys9sfl4n";
      type = "gem";
    };
    version = "0.2.0";
  };
  ttfunk = {
    dependencies = [ "bigdecimal" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ji0kn8jkf1rpskv3ijzxvqwixg4p6sk8kg0vmwyjinci7jcgjx7";
      type = "gem";
    };
    version = "1.8.0";
  };
  tty-color = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0aik4kmhwwrmkysha7qibi2nyzb4c8kp42bd5vxnf8sf7b53g73g";
      type = "gem";
    };
    version = "0.6.0";
  };
  tty-cursor = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0j5zw041jgkmn605ya1zc151bxgxl6v192v2i26qhxx7ws2l2lvr";
      type = "gem";
    };
    version = "0.7.1";
  };
  tty-prompt = {
    dependencies = [
      "pastel"
      "tty-reader"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1j4y8ik82azjxshgd4i1v4wwhsv3g9cngpygxqkkz69qaa8cxnzw";
      type = "gem";
    };
    version = "0.23.1";
  };
  tty-reader = {
    dependencies = [
      "tty-cursor"
      "tty-screen"
      "wisper"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1cf2k7w7d84hshg4kzrjvk9pkyc2g1m3nx2n1rpmdcf0hp4p4af6";
      type = "gem";
    };
    version = "0.9.0";
  };
  tty-screen = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0l4vh6g333jxm9lakilkva2gn17j6gb052626r1pdbmy2lhnb460";
      type = "gem";
    };
    version = "0.8.2";
  };
  tzinfo = {
    dependencies = [ "concurrent-ruby" ];
    groups = [
      "default"
      "development"
      "migrations"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "16w2g84dzaf3z13gxyzlzbf748kylk5bdgg3n1ipvkvvqy685bwd";
      type = "gem";
    };
    version = "2.0.6";
  };
  tzinfo-data = {
    dependencies = [ "tzinfo" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ygpikd3hdqsi16gqh33r5al1b9xdwrv2wl3rw210g7iar9vr3s7";
      type = "gem";
    };
    version = "1.2026.3";
  };
  unf = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1aq4bfddln9kx4lycqdgmahsssljsm3vfgbmb6a3y3nq07hw5g76";
      type = "gem";
    };
    version = "0.2.0";
  };
  unicode-display_width = {
    dependencies = [ "unicode-emoji" ];
    groups = [
      "default"
      "development"
      "migrations"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0hiwhnqpq271xqari6mg996fgjps42sffm9cpk6ljn8sd2srdp8c";
      type = "gem";
    };
    version = "3.2.0";
  };
  unicode-emoji = {
    groups = [
      "default"
      "development"
      "migrations"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03zqn207zypycbz5m9mn7ym763wgpk7hcqbkpx02wrbm1wank7ji";
      type = "gem";
    };
    version = "4.2.0";
  };
  uniform_notifier = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "17ffzyq6482yn27r7rz2k3zslf9jigbz383d90c68vznarapi1s7";
      type = "gem";
    };
    version = "1.18.0";
  };
  uri = {
    groups = [
      "default"
      "development"
      "migrations"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ijpbj7mdrq7rhpq2kb51yykhrs2s54wfs6sm9z3icgz4y6sb7rp";
      type = "gem";
    };
    version = "1.1.1";
  };
  useragent = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0i1q2xdjam4d7gwwc35lfnz0wyyzvnca0zslcfxm9fabml9n83kh";
      type = "gem";
    };
    version = "0.16.11";
  };
  version_gem = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1l17paljrcjdrvv0ida39msync07v3g1ij70cwsjw999gdc42cm7";
      type = "gem";
    };
    version = "1.1.15";
  };
  web-push = {
    dependencies = [
      "jwt"
      "openssl"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0z8qwx6v59dj443z7wf6604wpk5khs5g4nfsmc6vg3y5801v06jh";
      type = "gem";
    };
    version = "3.1.0";
  };
  webmock = {
    dependencies = [
      "addressable"
      "crack"
      "hashdiff"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03fmmb5ym51rby3asas3w5s31hik8mzwf2gvijbfdsqps83a53cd";
      type = "gem";
    };
    version = "3.26.4";
  };
  webrick = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ca1hr2rxrfw7s613rp4r4bxb454i3ylzniv9b9gxpklqigs3d5y";
      type = "gem";
    };
    version = "1.9.2";
  };
  wisper = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1rpsi0ziy78cj82sbyyywby4d0aw0a5q84v65qd28vqn79fbq5yf";
      type = "gem";
    };
    version = "2.0.1";
  };
  xpath = {
    dependencies = [ "nokogiri" ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0bh8lk9hvlpn7vmi6h4hkcwjzvs2y0cmkk3yjjdr8fxvj6fsgzbd";
      type = "gem";
    };
    version = "3.2.0";
  };
  yaml-lint = {
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "12jc68af2mwdkr9iqay2v6qgq47yk5g82sd171riibk62wbhp5p3";
      type = "gem";
    };
    version = "0.1.2";
  };
  yard = {
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0lfwngmsz3xq9k9la9890cqpm4vk3rda4171yzms7f3w7x4i3qjj";
      type = "gem";
    };
    version = "0.9.45";
  };
  zeitwerk = {
    groups = [
      "default"
      "development"
      "migrations"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1rcjpgyzmdxp8rdw466156fmr588k9q1wg8j42g0dkk7hid1519c";
      type = "gem";
    };
    version = "2.8.3";
  };
  zendesk_api = {
    dependencies = [
      "base64"
      "faraday"
      "faraday-multipart"
      "hashie"
      "inflection"
      "mini_mime"
      "multipart-post"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "05gcvhnz316rff8ysm0746yig1inb80skkz7m4c3bvgq789nqwiz";
      type = "gem";
    };
    version = "3.1.2";
  };
}
