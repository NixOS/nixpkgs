{
  actionpack = {
    dependencies = ["actionview" "activesupport" "rack" "rack-test" "rails-dom-testing" "rails-html-sanitizer"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xh89xyrn6w3ywl4db3fvkwkm3xhvdfl7w4v2s17l44h44ly1d5c";
      type = "gem";
    };
    version = "4.2.6";
  };
  actionview = {
    dependencies = ["activesupport" "builder" "erubis" "rails-dom-testing" "rails-html-sanitizer"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jssa1qkyr1xavv36rkadg0wh5x4v21c215q4v65yc78rwxfwn47";
      type = "gem";
    };
    version = "4.2.6";
  };
  activemodel = {
    dependencies = ["activesupport" "builder"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ibi87w1a4ldx979cz9qrsffj08nh8x3k6hgjjpvc15slw796c22";
      type = "gem";
    };
    version = "4.2.6";
  };
  activerecord = {
    dependencies = ["activemodel" "activesupport" "arel"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bjkfr7mrcrxy5m1ir50bfmkab3sha6jliy38n7wx92vvxfjikxz";
      type = "gem";
    };
    version = "4.2.6";
  };
  activesupport = {
    dependencies = ["i18n" "json" "minitest" "thread_safe" "tzinfo"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03y5xk7xmmny3knkwilszd5w7pfh6qf9cib5mva88ni1g7r6s9hq";
      type = "gem";
    };
    version = "4.2.6";
  };
  addressable = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mpn7sbjl477h56gmxsjqb89r5s3w7vx5af994ssgc3iamvgzgvs";
      type = "gem";
    };
    version = "2.4.0";
  };
  arel = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1a270mlajhrmpqbhxcqjqypnvgrq4pgixpv3w9gwp1wrrapnwrzk";
      type = "gem";
    };
    version = "6.0.3";
  };
  arel-helpers = {
    dependencies = ["activerecord"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0k8hqa2505b2s3w6gajh2lvi2mn832yqldiy2z4c55phzkmr08sr";
      type = "gem";
    };
    version = "2.3.0";
  };
  aruba = {
    dependencies = ["childprocess" "contracts" "cucumber" "ffi" "rspec-expectations" "thor"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cvxvw0v7wnhz15piylxrwpjdgjccwyrddda052z97cpnj5qjg5w";
      type = "gem";
    };
    version = "0.14.1";
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
  capybara = {
    dependencies = ["addressable" "mime-types" "nokogiri" "rack" "rack-test" "xpath"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04ymps3y9ka2n8p52l2xdv81dcvks5z8fg12fv2inw3fngphq09c";
      type = "gem";
    };
    version = "2.7.1";
  };
  childprocess = {
    dependencies = ["ffi"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1is253wm9k2s325nfryjnzdqv9flq8bm4y2076mhdrncxamrh7r2";
      type = "gem";
    };
    version = "0.5.9";
  };
  coderay = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1x6z923iwr1hi04k6kz5a6llrixflz8h5sskl9mhaaxy9jx2x93r";
      type = "gem";
    };
    version = "1.1.1";
  };
  contracts = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16dwwxshmn85cv6bk9yw957plidah7f24yhr04mjvz426a2fw012";
      type = "gem";
    };
    version = "0.14.0";
  };
  cucumber = {
    dependencies = ["builder" "cucumber-core" "cucumber-wire" "diff-lcs" "gherkin" "multi_json" "multi_test"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0camkrxa4ag6001fgaha7il35zr6ih4dm6iw4kw02d51wnm4ad59";
      type = "gem";
    };
    version = "2.3.3";
  };
  cucumber-core = {
    dependencies = ["gherkin"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0f05hkrgn9h9yl2d7s92s9bd4q60y4p4smd4av838b4hfsz0jf38";
      type = "gem";
    };
    version = "1.4.0";
  };
  cucumber-rails = {
    dependencies = ["capybara" "cucumber" "mime-types" "nokogiri" "railties"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gxgh6xl0j2v1djzkkjg2m9bnib258xrxn345w89s31apyr11wim";
      type = "gem";
    };
    version = "1.4.3";
  };
  cucumber-wire = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09ymvqb0sbw2if1nxg8rcj33sf0va88ancq5nmp8g01dfwzwma2f";
      type = "gem";
    };
    version = "0.0.1";
  };
  diff-lcs = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vf9civd41bnqi6brr5d9jifdw73j9khc6fkhfl1f8r9cpkdvlx1";
      type = "gem";
    };
    version = "1.2.5";
  };
  docile = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0m8j31whq7bm5ljgmsrlfkiqvacrw6iz9wq10r3gwrv5785y8gjx";
      type = "gem";
    };
    version = "1.1.5";
  };
  erubis = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fj827xqjs91yqsydf0zmfyw9p4l2jz5yikg3mppz6d7fi8kyrb3";
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
  faraday = {
    dependencies = ["multipart-post"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kplqkpn2s2yl3lxdf6h7sfldqvkbkpxwwxhyk7mdhjplb5faqh6";
      type = "gem";
    };
    version = "0.9.2";
  };
  ffi = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1m5mprppw0xcrv2mkim5zsk70v089ajzqiq5hpyb0xg96fcyzyxj";
      type = "gem";
    };
    version = "1.9.10";
  };
  filesize = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "061qmg82mm9xnmnq3b7gbi24g28xk62w0b0nw86gybd07m1jn989";
      type = "gem";
    };
    version = "0.1.1";
  };
  fivemat = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gvw6g4yc96l2pcyvigahyfsjxpdjx21iiwzvf965zippchdh6gk";
      type = "gem";
    };
    version = "1.3.2";
  };
  gherkin = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "055dirx8y1zn71jjgphha2aywbla0j69f2fgmxwncpy6csi0893i";
      type = "gem";
    };
    version = "3.2.0";
  };
  i18n = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1i5z1ykl8zhszsxcs8mzl8d0dxgs3ylz8qlzrw74jb0gplkx6758";
      type = "gem";
    };
    version = "0.7.0";
  };
  jsobfu = {
    dependencies = ["rkelly-remix"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qjadryhxwxjqc158f9y13xw1x7is4dlla1yqbgsf9hq24fzi6kd";
      type = "gem";
    };
    version = "0.4.1";
  };
  json = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nsby6ry8l9xg3yw4adlhk2pnc7i0h0rznvcss4vk3v74qg0k8lc";
      type = "gem";
    };
    version = "1.8.3";
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
      sha256 = "0vwn7in6wamscvx0yn5csaik2ay1qb12qghwk6n2zc02ivvn6pq7";
      type = "gem";
    };
    version = "1.0.2";
  };
  metasploit-concern = {
    dependencies = ["activemodel" "activesupport" "railties"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1af2l0wxz0wy6v8vyxxb3q2pff3k55ibvvy920kp357j4r3x6hpg";
      type = "gem";
    };
    version = "2.0.1";
  };
  metasploit-credential = {
    dependencies = ["metasploit-concern" "metasploit-model" "metasploit_data_models" "pg" "railties" "rubyntlm" "rubyzip"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0c29rjdnbqil4rzscdnf272by7xyj2p2lbp8fbh2zvl94y2b6d98";
      type = "gem";
    };
    version = "2.0.2";
  };
  metasploit-framework = {
    dependencies = ["actionpack" "activerecord" "activesupport" "bcrypt" "filesize" "jsobfu" "json" "metasm" "metasploit-concern" "metasploit-credential" "metasploit-model" "metasploit-payloads" "metasploit_data_models" "msgpack" "network_interface" "nokogiri" "octokit" "openssl-ccm" "packetfu" "patch_finder" "pcaprub" "pg" "railties" "rb-readline-r7" "recog" "redcarpet" "robots" "rubyzip" "sqlite3" "tzinfo" "tzinfo-data"];
  };
  metasploit-model = {
    dependencies = ["activemodel" "activesupport" "railties"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "120pm7x1jk6bya1pdd361w4ghm91hldmspj73kl9va8f2v2s03y4";
      type = "gem";
    };
    version = "2.0.0";
  };
  metasploit-payloads = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1h5lrs023kzind7088f2l0h6n90g5xish9kvgjm1bgrnkzigyffj";
      type = "gem";
    };
    version = "1.1.11";
  };
  metasploit_data_models = {
    dependencies = ["activerecord" "activesupport" "arel-helpers" "metasploit-concern" "metasploit-model" "pg" "postgres_ext" "railties" "recog"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fsm6qy8xpsg3igv1dvafva7h4k388dzmdqj8b4i3dfa03mjmwxm";
      type = "gem";
    };
    version = "2.0.0";
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
      sha256 = "1snjc38a9vqvy8j41xld1i1byq9prbl955pbjw7dxqcfcirqlzra";
      type = "gem";
    };
    version = "3.0";
  };
  mime-types-data = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05ygjn0nnfh6yp1wsi574jckk95wqg9a6g598wk4svvrkmkrzkpn";
      type = "gem";
    };
    version = "3.2016.0221";
  };
  mini_portile2 = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "056drbn5m4khdxly1asmiik14nyllswr6sh3wallvsywwdiryz8l";
      type = "gem";
    };
    version = "2.0.0";
  };
  minitest = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05nlp0w2mfns9pd9ypfbz6zw0r9smlv1m5i4pbpijizm7v3kxmra";
      type = "gem";
    };
    version = "5.8.4";
  };
  msgpack = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fn2riiaygiyvmr0glgm1vx995np3jb2hjf5i0j78vncd2wbwdw5";
      type = "gem";
    };
    version = "0.7.6";
  };
  multi_json = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gx5alrrkgw28k4q6bp79ijlf2479j8xy01gmj5aih27dqd9vd8a";
      type = "gem";
    };
    version = "1.12.0";
  };
  multi_test = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1sx356q81plr67hg16jfwz9hcqvnk03bd9n75pmdw8pfxjfy1yxd";
      type = "gem";
    };
    version = "0.1.2";
  };
  multipart-post = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09k0b3cybqilk1gwrwwain95rdypixb2q9w65gd44gfzsd84xi1x";
      type = "gem";
    };
    version = "2.0.0";
  };
  network_interface = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ir4c1vbz1y0gxyih024262i7ig1nji1lkylcrn9pjzx3798p97a";
      type = "gem";
    };
    version = "0.0.1";
  };
  nokogiri = {
    dependencies = ["mini_portile2"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11sbmpy60ynak6s3794q32lc99hs448msjy8rkp84ay7mq7zqspv";
      type = "gem";
    };
    version = "1.6.7.2";
  };
  octokit = {
    dependencies = ["sawyer"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hq47ck0z03vr3rzblyszihn7x2m81gv35chwwx0vrhf17nd27np";
      type = "gem";
    };
    version = "4.3.0";
  };
  openssl-ccm = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18h5lxv0zh4j2f0wnhdmfz63x02vbzbq2k1clz6kzr0q83h8kj9c";
      type = "gem";
    };
    version = "1.2.1";
  };
  packetfu = {
    dependencies = ["network_interface" "pcaprub"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05i85s6xpnc1y9w2nws5nbc5qs936c7idw9pdj2nwi07ly7kksba";
      type = "gem";
    };
    version = "1.1.11";
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
  pg = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07dv4ma9xd75xpsnnwwg1yrpwpji7ydy0q1d9dl0yfqbzpidrw32";
      type = "gem";
    };
    version = "0.18.4";
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
  pry = {
    dependencies = ["coderay" "method_source" "slop"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1x78rvp69ws37kwig18a8hr79qn36vh8g1fn75p485y3b3yiqszg";
      type = "gem";
    };
    version = "0.10.3";
  };
  rack = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09bs295yq6csjnkzj7ncj50i6chfxrhmzg1pk6p0vd2lb9ac8pj5";
      type = "gem";
    };
    version = "1.6.4";
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
  railties = {
    dependencies = ["actionpack" "activesupport" "rake" "thor"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dh6wqs8pf3c2z5k75gg0wfw32vy0vj8p71zk01wmy4hh09pnr7i";
      type = "gem";
    };
    version = "4.2.6";
  };
  rake = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jfmy7kd543ldi3d4fg35a1w7q6jikpnzxqj4bzchfbn94cbabqz";
      type = "gem";
    };
    version = "11.1.2";
  };
  rb-readline-r7 = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fd3zyfq58ljlydzdckr9qjrlsciiccwmxl700171wrkcl466bza";
      type = "gem";
    };
    version = "0.5.2.0";
  };
  recog = {
    dependencies = ["nokogiri"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xxa5hwlws4il7k8md15rk81kin9f96vz9vzi5d85yx49059hx1n";
      type = "gem";
    };
    version = "2.0.21";
  };
  redcarpet = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04v85p0bnpf1c7w4n0yr03s35yimxh0idgdrrybl9y13zbw5kgvg";
      type = "gem";
    };
    version = "3.3.4";
  };
  rkelly-remix = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ihsns5v8nx96gvj7sqw5m8d6dsnmpfzpd07y860bldjhkjsxp1z";
      type = "gem";
    };
    version = "0.0.6";
  };
  robots = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "141gvihcr2c0dpzl3dqyh8kqc9121prfdql2iamaaw0mf9qs3njs";
      type = "gem";
    };
    version = "0.10.1";
  };
  rspec-core = {
    dependencies = ["rspec-support"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1z2zmy3xaq00v20ykamqvnynzv2qrrnbixc6dn0jw1c5q9mqq9fp";
      type = "gem";
    };
    version = "3.4.4";
  };
  rspec-expectations = {
    dependencies = ["diff-lcs" "rspec-support"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07pz570glwg87zpyagxxal0daa1jrnjkiksnn410s6846884fk8h";
      type = "gem";
    };
    version = "3.4.0";
  };
  rspec-mocks = {
    dependencies = ["diff-lcs" "rspec-support"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sk8ijq5d6bwhvjq94gfm02fssxkm99bgpasqazsmmll5m1cn7vr";
      type = "gem";
    };
    version = "3.4.1";
  };
  rspec-rails = {
    dependencies = ["actionpack" "activesupport" "railties" "rspec-core" "rspec-expectations" "rspec-mocks" "rspec-support"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1y3jpj44sia9n8drfp3qkmkmjq0kfsbrh5cp4jr1c43b7940wfv6";
      type = "gem";
    };
    version = "3.4.2";
  };
  rspec-support = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0l6zzlf22hn3pcwnxswsjsiwhqjg7a8mhvm680k5vq98307bkikr";
      type = "gem";
    };
    version = "3.4.1";
  };
  rubyntlm = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00k1cll10mcyg6qpdzyrazm5pjbpj7wq54ki2y8vxz86842vbsgp";
      type = "gem";
    };
    version = "0.6.0";
  };
  rubyzip = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10a9p1m68lpn8pwqp972lv61140flvahm3g9yzbxzjks2z3qlb2s";
      type = "gem";
    };
    version = "1.2.0";
  };
  sawyer = {
    dependencies = ["addressable" "faraday"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cn48ql00mf1ag9icmfpj7g7swh7mdn7992ggynjqbw1gh15bs3j";
      type = "gem";
    };
    version = "0.7.0";
  };
  shoulda-matchers = {
    dependencies = ["activesupport"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cf6d2d9br82vylr9p362yk9cfrd14jz8v77n0yb0lbcxdbk7xzq";
      type = "gem";
    };
    version = "3.1.1";
  };
  simplecov = {
    dependencies = ["docile" "json" "simplecov-html"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p0jhxwsv2ksk4hmp8qbhnr325z9fhs26z9y8in5v5c49y331qw2";
      type = "gem";
    };
    version = "0.11.2";
  };
  simplecov-html = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qni8g0xxglkx25w54qcfbi4wjkpvmb28cb7rj5zk3iqynjcdrqf";
      type = "gem";
    };
    version = "0.10.0";
  };
  slop = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00w8g3j7k7kl8ri2cf1m58ckxk8rn350gp4chfscmgv6pq1spk3n";
      type = "gem";
    };
    version = "3.6.0";
  };
  sqlite3 = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19r06wglnm6479ffj9dl0fa4p5j2wi6dj7k6k3d0rbx7036cv3ny";
      type = "gem";
    };
    version = "1.3.11";
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
  timecop = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vwbkwqyxhavzvr1820hqwz43ylnfcf6w4x6sag0nghi44sr9kmx";
      type = "gem";
    };
    version = "0.8.1";
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
  tzinfo-data = {
    dependencies = ["tzinfo"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bxfljd5i7g89s7jc5l4a3ddykfsvvp0gm02805r1q77ahn1gp33";
      type = "gem";
    };
    version = "1.2016.4";
  };
  xpath = {
    dependencies = ["nokogiri"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04kcr127l34p7221z13blyl0dvh0bmxwx326j72idayri36a394w";
      type = "gem";
    };
    version = "2.0.0";
  };
  yard = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1dj6ibc0qqvmb5a5r5kk0vhr04mnrz9b26gnfrs5p8jgp620i89x";
      type = "gem";
    };
    version = "0.8.7.6";
  };
}