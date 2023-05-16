{
  addressable = {
    dependencies = ["public_suffix"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "05r1fwy487klqkya7vzia8hnklcxy4vr92m9dmni3prfwk6zpw33";
      type = "gem";
    };
    version = "2.8.5";
=======
      sha256 = "1ypdmpdn20hxp5vwxz3zc04r5xcwqc25qszdlg41h8ghdqbllwmw";
      type = "gem";
    };
    version = "2.8.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
  Ascii85 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ds4v9xgsyvijnlflak4dzf1qwmda9yd5bv8jwsb56nngd399rlw";
      type = "gem";
    };
    version = "1.1.0";
  };
  asciidoctor = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0yblqlbix3is5ihiqrpbfazb44in7ichfkjzdbsqibp48paanpl3";
      type = "gem";
    };
    version = "2.0.20";
=======
      sha256 = "11z3vnd8vh3ny1vx69bjrbck5b2g8zsbj94npyadpn7fdp8y3ldv";
      type = "gem";
    };
    version = "2.0.18";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  asciidoctor-bibtex = {
    dependencies = ["asciidoctor" "bibtex-ruby" "citeproc-ruby" "csl-styles" "latex-decode"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fx80bpykixvnlscyz2c4dnjr1063r5ar7j1zn2977vsr8fi8ial";
      type = "gem";
    };
    version = "0.8.0";
  };
  asciidoctor-diagram = {
    dependencies = ["asciidoctor" "asciidoctor-diagram-ditaamini" "asciidoctor-diagram-plantuml" "rexml"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0j6622x9525xbshvbds4gkavvy72lqjqq1jw9flljr8vvsv7xjcs";
      type = "gem";
    };
    version = "2.2.11";
=======
      sha256 = "1jzaahnnyarjn24vvgprkisij5nw5mzqjphgycxf11gpmnvs2lar";
      type = "gem";
    };
    version = "2.2.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  asciidoctor-diagram-ditaamini = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13h65bfbq7hc7z3kqn0m28w9c6ap7fikpjcvsdga6jg01slb4c56";
      type = "gem";
    };
    version = "1.0.3";
  };
  asciidoctor-diagram-plantuml = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0c1pz97fvc0hwvh0by5i682mxnwngqpxb5hp85fly9k8q9hb2hwg";
      type = "gem";
    };
    version = "1.2023.10";
=======
      sha256 = "18vbvj9cjr5f63jmjlq9kdknpn2dzykhnrv3i4y5gnbhs6f4jhi2";
      type = "gem";
    };
    version = "1.2022.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  asciidoctor-epub3 = {
    dependencies = ["asciidoctor" "gepub" "mime-types"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05lylv2k18vcnf3647n47zdqxpa70bg16znzn252ymp8say25zzg";
      type = "gem";
    };
    version = "1.5.1";
  };
  asciidoctor-html5s = {
    dependencies = ["asciidoctor" "thread_safe"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zfbfcqyrsk8bnd526ang3b4j3m5pbns7x3fdxarrm8vv1qplss1";
      type = "gem";
    };
    version = "0.5.1";
  };
  asciidoctor-mathematical = {
    dependencies = ["asciidoctor" "asciimath" "mathematical"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lxfq7qn3ql642pva6jh3h1abm9j9daxg5icfn1h73k6cjsmcisp";
      type = "gem";
    };
    version = "0.3.5";
  };
  asciidoctor-multipage = {
    dependencies = ["asciidoctor"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1c72ys845dvcfdrgmkzk3zx6d2f1vh8q8fnvyp4rwy6qcvhpjg4d";
      type = "gem";
    };
    version = "0.0.16";
  };
  asciidoctor-pdf = {
    dependencies = ["asciidoctor" "concurrent-ruby" "matrix" "prawn" "prawn-icon" "prawn-svg" "prawn-table" "prawn-templates" "treetop"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "19c98a6riqhxxlc7kmksjslnyxdjp106ppsqy1vdbkjb39zfign3";
      type = "gem";
    };
    version = "2.3.9";
  };
  asciidoctor-reducer = {
    dependencies = ["asciidoctor"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1708fi4bxjpkdszm6a4naa0qcsl0vqnhcklryn2sysl24zaz07h5";
      type = "gem";
    };
    version = "1.0.5";
  };
  asciidoctor-revealjs = {
    dependencies = ["asciidoctor"];
=======
      sha256 = "16mw0mlrrx44wn5j2knp3cv7b7phan90y4dr285c1qgdd25310xv";
      type = "gem";
    };
    version = "2.3.2";
  };
  asciidoctor-revealjs = {
    dependencies = ["asciidoctor" "concurrent-ruby" "thread_safe"];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0xh8ax5pv7cc9wa4sx0njpyj20gzfbhramca31qwldgi6hwk4wm8";
      type = "gem";
    };
    version = "5.0.1";
=======
      sha256 = "03vmbcc3x059h17ry4qwk1p0yar9wgh87l2qssi307gy45cjw2mq";
      type = "gem";
    };
    version = "4.1.0";
  };
  asciidoctor-rouge = {
    dependencies = ["asciidoctor" "rouge"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "197sbzs9km58pgfqdnnglhqr7anhb0m330cv1vxfc3s2qz106zjz";
      type = "gem";
    };
    version = "0.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  asciimath = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1ny2qql3lgh7gx54psji2lm4mmbwyiwy00a17w26rjyh6cy55491";
      type = "gem";
    };
    version = "2.0.5";
=======
      sha256 = "1fy2jrn3gr7cl33qydp3pwyfilcmb4m4z6hfhnvydzg8r3srp36j";
      type = "gem";
    };
    version = "2.0.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  bibtex-ruby = {
    dependencies = ["latex-decode"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0adh2x935r69nm8qmns5fjsjw034xlyaqddzza2jr2npvf41g34r";
      type = "gem";
    };
    version = "5.1.6";
  };
  citeproc = {
    dependencies = ["namae"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13vl5sjmksk5a8kjcqnjxh7kn9gn1n4f9p1rvqfgsfhs54p0m6l2";
      type = "gem";
    };
    version = "1.0.10";
  };
  citeproc-ruby = {
    dependencies = ["citeproc" "csl"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0a8ahyhhmdinl4kcyv51r74ipnclmfyz4zjv366dns8v49n5vkk3";
      type = "gem";
    };
    version = "1.1.14";
  };
  coderay = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jvxqxzply1lwp7ysn94zjhh57vc14mcshw1ygw14ib8lhc00lyw";
      type = "gem";
    };
    version = "1.1.3";
  };
  concurrent-ruby = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0krcwb6mn0iklajwngwsg850nk8k9b35dhmc2qkbdqvmifdi2y9q";
      type = "gem";
    };
    version = "1.2.2";
=======
      sha256 = "0s4fpn3mqiizpmpy2a24k4v365pv75y50292r8ajrv4i1p5b2k14";
      type = "gem";
    };
    version = "1.1.10";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  csl = {
    dependencies = ["namae" "rexml"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0n8iqmzvvqy2b1wfr4c7yj28x4z3zgm36628y8ybl49dgnmjycrk";
      type = "gem";
    };
    version = "1.6.0";
  };
  csl-styles = {
    dependencies = ["csl"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0l29qlk7i74088fpba5iqhhgiqkj7glcmc42nbmvgqysx577nag8";
      type = "gem";
    };
    version = "1.0.1.11";
  };
  css_parser = {
    dependencies = ["addressable"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "04q1vin8slr3k8mp76qz0wqgap6f9kdsbryvgfq9fljhrm463kpj";
      type = "gem";
    };
    version = "1.14.0";
=======
      sha256 = "1107j3frhmcd95wcsz0rypchynnzhnjiyyxxcl6dlmr2lfy08z4b";
      type = "gem";
    };
    version = "1.12.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  gepub = {
    dependencies = ["nokogiri" "rubyzip"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08fny807zd4700f263ckc76bladjipsniyk3clv8a7x76x3fqshx";
      type = "gem";
    };
    version = "1.0.15";
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
  i18n = {
    dependencies = ["concurrent-ruby"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0qaamqsh5f3szhcakkak8ikxlzxqnv49n2p7504hcz2l0f4nj0wx";
      type = "gem";
    };
    version = "1.14.1";
=======
      sha256 = "1vdcchz7jli1p0gnc669a7bj3q1fv09y9ppf0y3k0vb1jwdwrqwi";
      type = "gem";
    };
    version = "1.12.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  latex-decode = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1y5xn3zwghpqr6lvs4s0mn5knms8zw3zk7jb58zkkiagb386nq72";
      type = "gem";
    };
    version = "0.4.0";
  };
  mathematical = {
    dependencies = ["ruby-enum"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05mn68gxhfa37qsnzsmdqaa005hf511j5lga76qsrad2gcnhan1b";
      type = "gem";
    };
    version = "1.6.14";
  };
  matrix = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1h2cgkpzkh3dd0flnnwfq6f3nl2b1zff9lvqz8xs853ssv5kq23i";
      type = "gem";
    };
    version = "0.4.2";
  };
  mime-types = {
    dependencies = ["mime-types-data"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1s95nyppk5wrpfgqrzf6f00g7nk0662zmxm4mr2vbdbl83q3k72x";
      type = "gem";
    };
    version = "3.5.0";
=======
      sha256 = "0ipw892jbksbxxcrlx9g5ljq60qx47pm24ywgfbyjskbcl78pkvb";
      type = "gem";
    };
    version = "3.4.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  mime-types-data = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "17zdim7kzrh5j8c97vjqp4xp78wbyz7smdp4hi5iyzk0s9imdn5a";
      type = "gem";
    };
    version = "3.2023.0808";
=======
      sha256 = "003gd7mcay800k2q4pb2zn8lwwgci4bhi42v2jvlidm8ksx03i6q";
      type = "gem";
    };
    version = "3.2022.0105";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  mini_portile2 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "02mj8mpd6ck5gpcnsimx5brzggw5h5mmmpq2djdypfq16wcw82qq";
      type = "gem";
    };
    version = "2.8.4";
=======
      sha256 = "0rapl1sfmfi3bfr68da4ca16yhc0pp93vjwkj7y3rdqrzy3b41hy";
      type = "gem";
    };
    version = "2.8.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  namae = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1j3nl1klkx3gymrdxfc1hlq4a8qlvhhl9aj5v1v08b9fz27sky0l";
      type = "gem";
    };
    version = "1.1.1";
  };
  nokogiri = {
    dependencies = ["mini_portile2" "racc"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0k9w2z0953mnjrsji74cshqqp08q7m1r6zhadw1w0g34xzjh3a74";
      type = "gem";
    };
    version = "1.15.4";
=======
      sha256 = "0g7axlq2y6gzmixzzzhw3fn6nhrhg469jj8gfr7gs8igiclpkhkr";
      type = "gem";
    };
    version = "1.13.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  pdf-core = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fz0yj4zrlii2j08kaw11j769s373ayz8jrdhxwwjzmm28pqndjg";
      type = "gem";
    };
    version = "0.9.0";
  };
  pdf-reader = {
    dependencies = ["Ascii85" "afm" "hashery" "ruby-rc4" "ttfunk"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "09sx25jpnip2sp6wh5sn5ad7za78rfi95qp5iiczfh43z4jqa8q3";
      type = "gem";
    };
    version = "2.11.0";
=======
      sha256 = "07chhyxf3qlr65jngns3z5187ibfibf5h2q59505vx45dfr3lvwz";
      type = "gem";
    };
    version = "2.10.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  polyglot = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bqnxwyip623d8pr29rg6m8r0hdg08fpr2yb74f46rn1wgsnxmjr";
      type = "gem";
    };
    version = "0.3.5";
  };
  prawn = {
    dependencies = ["pdf-core" "ttfunk"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g9avv2rprsjisdk137s9ljr05r7ajhm78hxa1vjsv0jyx22f1l2";
      type = "gem";
    };
    version = "2.4.0";
  };
  prawn-icon = {
    dependencies = ["prawn"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xdnjik5zinnkjavmybbh2s52wzcpb8hzaqckiv0mxp0vs0x9j6s";
      type = "gem";
    };
    version = "3.0.0";
  };
  prawn-svg = {
    dependencies = ["css_parser" "prawn" "rexml"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mbxzw7r7hv43db9422flc24ib9d8bdy1nasbni2h998jc5a5lb6";
      type = "gem";
    };
    version = "0.32.0";
  };
  prawn-table = {
    dependencies = ["prawn"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nxd6qmxqwl850icp18wjh5k0s3amxcajdrkjyzpfgq0kvilcv9k";
      type = "gem";
    };
    version = "0.2.2";
  };
  prawn-templates = {
    dependencies = ["pdf-reader" "prawn"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1w9irn3rllm992c6j7fsx81gg539i7yy8zfddyw7q53hnlys0yhi";
      type = "gem";
    };
    version = "0.1.2";
  };
  public_suffix = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0n9j7mczl15r3kwqrah09cxj8hxdfawiqxa60kga2bmxl9flfz9k";
      type = "gem";
    };
    version = "5.0.3";
=======
      sha256 = "0sqw1zls6227bgq38sxb2hs8nkdz4hn1zivs27mjbniswfy4zvi6";
      type = "gem";
    };
    version = "5.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  "pygments.rb" = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "080kb51l3m0n7xbbzmlcy78wsi03wr995v932v3b6lf6xa6nq8rg";
      type = "gem";
    };
    version = "2.4.0";
=======
      sha256 = "047mjyzz8v4kkgi1ap6fsjf7kcp6dwirpnigif00ss0hxsxchhac";
      type = "gem";
    };
    version = "2.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  racc = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "11v3l46mwnlzlc371wr3x6yylpgafgwdf0q7hc7c1lzx6r414r5g";
      type = "gem";
    };
    version = "1.7.1";
=======
      sha256 = "0la56m0z26j3mfn1a9lf2l03qx1xifanndf9p3vx1azf6sqy7v9d";
      type = "gem";
    };
    version = "1.6.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  rexml = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "05i8518ay14kjbma550mv0jm8a6di8yp5phzrd8rj44z9qnrlrp0";
      type = "gem";
    };
    version = "3.2.6";
=======
      sha256 = "08ximcyfjy94pm1rhcx04ny1vx2sk0x4y185gzn86yfsbzwkng53";
      type = "gem";
    };
    version = "3.2.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  rouge = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "19drl3x8fw65v3mpy7fk3cf3dfrywz5alv98n2rm4pp04vdn71lw";
      type = "gem";
    };
    version = "4.1.3";
=======
      sha256 = "1dnfkrk8xx2m8r3r9m2p5xcq57viznyc09k7r3i4jbm758i57lx3";
      type = "gem";
    };
    version = "3.30.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  ruby-enum = {
    dependencies = ["i18n"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pys90hxylhyg969iw9lz3qai5lblf8xwbdg1g5aj52731a9k83p";
      type = "gem";
    };
    version = "0.9.0";
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
  rubyzip = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0grps9197qyxakbpw02pda59v45lfgbgiyw48i0mq9f2bn9y6mrz";
      type = "gem";
    };
    version = "2.3.2";
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
  treetop = {
    dependencies = ["polyglot"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0adc8qblz8ii668r3rksjx83p675iryh52rvdvysimx2hkbasj7d";
      type = "gem";
    };
    version = "1.6.12";
=======
      sha256 = "0697qz1akblf8r3wi0s2dsjh468hfsd57fb0mrp93z35y2ni6bhh";
      type = "gem";
    };
    version = "1.6.11";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  ttfunk = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15iaxz9iak5643bq2bc0jkbjv8w2zn649lxgvh5wg48q9d4blw13";
      type = "gem";
    };
    version = "1.7.0";
  };
}
