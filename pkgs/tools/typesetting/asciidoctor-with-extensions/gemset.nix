{
  addressable = {
    dependencies = [ "public_suffix" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0cl2qpvwiffym62z991ynks7imsm87qmgxf0yfsmlwzkgi9qcaa6";
      type = "gem";
    };
    version = "2.8.7";
  };
  afm = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "06kj9hgd0z8pj27bxp2diwqh6fv7qhwwm17z64rhdc4sfn76jgn8";
      type = "gem";
    };
    version = "0.2.2";
  };
  Ascii85 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1c62cx96r0v265mywnlik43qx0wf6bjbzl54qa47x6dzjg861mvk";
      type = "gem";
    };
    version = "1.1.1";
  };
  asciidoctor = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1wyxgwmnz9bw377r3lba26b090hbsq9qnbw8575a1prpy83qh82j";
      type = "gem";
    };
    version = "2.0.23";
  };
  asciidoctor-bibtex = {
    dependencies = [
      "asciidoctor"
      "bibtex-ruby"
      "citeproc-ruby"
      "csl-styles"
      "latex-decode"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "16l7s926h6cjzy4y582sf3x32l4w10klmdnphxi7p4g6d8vhb61y";
      type = "gem";
    };
    version = "0.9.0";
  };
  asciidoctor-diagram = {
    dependencies = [
      "asciidoctor"
      "asciidoctor-diagram-ditaamini"
      "asciidoctor-diagram-plantuml"
      "rexml"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1214scxm36k409gfy3wilfqx3akrm52r530zmra6cmmf6d22c5q4";
      type = "gem";
    };
    version = "2.3.1";
  };
  asciidoctor-diagram-batik = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0220xqxmkmimxmhsqhlbr0hslijvnhzdds3s6h6fxbxqrrmm0jrl";
      type = "gem";
    };
    version = "1.17";
  };
  asciidoctor-diagram-ditaamini = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "13h65bfbq7hc7z3kqn0m28w9c6ap7fikpjcvsdga6jg01slb4c56";
      type = "gem";
    };
    version = "1.0.3";
  };
  asciidoctor-diagram-plantuml = {
    dependencies = [ "asciidoctor-diagram-batik" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "173mp5vnzvn3yv9fw0p66rsbxaip9lhphw22yn19l62d1drlmhia";
      type = "gem";
    };
    version = "1.2024.6";
  };
  asciidoctor-epub3 = {
    dependencies = [
      "asciidoctor"
      "gepub"
      "mime-types"
      "sass"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1yn2nhr7fr5rx7fn0nhw44gf7iampiy53bw59agpfl7h2dyazjll";
      type = "gem";
    };
    version = "2.1.3";
  };
  asciidoctor-html5s = {
    dependencies = [
      "asciidoctor"
      "thread_safe"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1zfbfcqyrsk8bnd526ang3b4j3m5pbns7x3fdxarrm8vv1qplss1";
      type = "gem";
    };
    version = "0.5.1";
  };
  asciidoctor-mathematical = {
    dependencies = [
      "asciidoctor"
      "asciimath"
      "mathematical"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1lxfq7qn3ql642pva6jh3h1abm9j9daxg5icfn1h73k6cjsmcisp";
      type = "gem";
    };
    version = "0.3.5";
  };
  asciidoctor-multipage = {
    dependencies = [ "asciidoctor" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1hjqqiibqrmx0147m8b372s57rmhixmpxgv4kwdpnkqbkqgykh7i";
      type = "gem";
    };
    version = "0.0.19";
  };
  asciidoctor-pdf = {
    dependencies = [
      "asciidoctor"
      "concurrent-ruby"
      "matrix"
      "prawn"
      "prawn-icon"
      "prawn-svg"
      "prawn-table"
      "prawn-templates"
      "treetop"
      "ttfunk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ybkw3xjv75xsc0wbwg76bk83sfspr50k2phshpvh9ynchli8jh3";
      type = "gem";
    };
    version = "2.3.19";
  };
  asciidoctor-reducer = {
    dependencies = [ "asciidoctor" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1fbrk97mdn26zk118dav2ckyiw6kgrlbkkhdcasawsl42hj16slw";
      type = "gem";
    };
    version = "1.0.6";
  };
  asciidoctor-revealjs = {
    dependencies = [ "asciidoctor" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jgazcfzn577xlichfj0rvci0fayp63xcng11ss9mmwqgk48ri53";
      type = "gem";
    };
    version = "5.1.0";
  };
  asciimath = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ny2qql3lgh7gx54psji2lm4mmbwyiwy00a17w26rjyh6cy55491";
      type = "gem";
    };
    version = "2.0.5";
  };
  bibtex-ruby = {
    dependencies = [
      "latex-decode"
      "racc"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ggx2j1gi46f1a6p45l1abk3nryfg1pj0cdlyrnilnqqpr1cfc96";
      type = "gem";
    };
    version = "6.1.0";
  };
  citeproc = {
    dependencies = [ "namae" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "13vl5sjmksk5a8kjcqnjxh7kn9gn1n4f9p1rvqfgsfhs54p0m6l2";
      type = "gem";
    };
    version = "1.0.10";
  };
  citeproc-ruby = {
    dependencies = [
      "citeproc"
      "csl"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0a8ahyhhmdinl4kcyv51r74ipnclmfyz4zjv366dns8v49n5vkk3";
      type = "gem";
    };
    version = "1.1.14";
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
  concurrent-ruby = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0chwfdq2a6kbj6xz9l6zrdfnyghnh32si82la1dnpa5h75ir5anl";
      type = "gem";
    };
    version = "1.3.4";
  };
  csl = {
    dependencies = [
      "namae"
      "rexml"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0n8iqmzvvqy2b1wfr4c7yj28x4z3zgm36628y8ybl49dgnmjycrk";
      type = "gem";
    };
    version = "1.6.0";
  };
  csl-styles = {
    dependencies = [ "csl" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0l29qlk7i74088fpba5iqhhgiqkj7glcmc42nbmvgqysx577nag8";
      type = "gem";
    };
    version = "1.0.1.11";
  };
  css_parser = {
    dependencies = [ "addressable" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "17i0fn99kswvfps8r698zw2cr16rc98xdrl0d26y36rv3vhdqh0r";
      type = "gem";
    };
    version = "1.19.1";
  };
  ffi = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "07139870npj59jnl8vmk39ja3gdk3fb5z9vc0lf32y2h891hwqsi";
      type = "gem";
    };
    version = "1.17.0";
  };
  gepub = {
    dependencies = [
      "nokogiri"
      "rubyzip"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "08fny807zd4700f263ckc76bladjipsniyk3clv8a7x76x3fqshx";
      type = "gem";
    };
    version = "1.0.15";
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
  latex-decode = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1y5xn3zwghpqr6lvs4s0mn5knms8zw3zk7jb58zkkiagb386nq72";
      type = "gem";
    };
    version = "0.4.0";
  };
  logger = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0lwncq2rf8gm79g2rcnnyzs26ma1f4wnfjm6gs4zf2wlsdz5in9s";
      type = "gem";
    };
    version = "1.6.1";
  };
  mathematical = {
    dependencies = [ "ruby-enum" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0y103dvfjswm5r0xafyjrw6ybvz1qrqfa4lvpk9gdhbzwpaiwy4r";
      type = "gem";
    };
    version = "1.6.20";
  };
  matrix = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1h2cgkpzkh3dd0flnnwfq6f3nl2b1zff9lvqz8xs853ssv5kq23i";
      type = "gem";
    };
    version = "0.4.2";
  };
  mime-types = {
    dependencies = [
      "logger"
      "mime-types-data"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0r34mc3n7sxsbm9mzyzy8m3dvq7pwbryyc8m452axkj0g2axnwbg";
      type = "gem";
    };
    version = "3.6.0";
  };
  mime-types-data = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "06dbn0j13jwdrmlvrjd50mxqrjlkh3lvxp0afh4glyzbliqvqpsd";
      type = "gem";
    };
    version = "3.2024.1001";
  };
  mini_portile2 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1q1f2sdw3y3y9mnym9dhjgsjr72sq975cfg5c4yx7gwv8nmzbvhk";
      type = "gem";
    };
    version = "2.8.7";
  };
  namae = {
    dependencies = [ "racc" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "17fmp6p74ai2w984xayv3kz2nh44w81hqqvn4cfrim3g115wwh9m";
      type = "gem";
    };
    version = "1.2.0";
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
      sha256 = "15gysw8rassqgdq3kwgl4mhqmrgh7nk2qvrcqp4ijyqazgywn6gq";
      type = "gem";
    };
    version = "1.16.7";
  };
  pdf-core = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1fz0yj4zrlii2j08kaw11j769s373ayz8jrdhxwwjzmm28pqndjg";
      type = "gem";
    };
    version = "0.9.0";
  };
  pdf-reader = {
    dependencies = [
      "Ascii85"
      "afm"
      "hashery"
      "ruby-rc4"
      "ttfunk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0n0pp7blk3np3fqsb54l34fsamrww80cp3dhlhskfayg7542mrv1";
      type = "gem";
    };
    version = "2.12.0";
  };
  polyglot = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1bqnxwyip623d8pr29rg6m8r0hdg08fpr2yb74f46rn1wgsnxmjr";
      type = "gem";
    };
    version = "0.3.5";
  };
  prawn = {
    dependencies = [
      "pdf-core"
      "ttfunk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1g9avv2rprsjisdk137s9ljr05r7ajhm78hxa1vjsv0jyx22f1l2";
      type = "gem";
    };
    version = "2.4.0";
  };
  prawn-icon = {
    dependencies = [ "prawn" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1xdnjik5zinnkjavmybbh2s52wzcpb8hzaqckiv0mxp0vs0x9j6s";
      type = "gem";
    };
    version = "3.0.0";
  };
  prawn-svg = {
    dependencies = [
      "css_parser"
      "matrix"
      "prawn"
      "rexml"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "143sfwadbdrgi57am8ikalryjijdyl82h2sdc1cns3wl6b9pkzxg";
      type = "gem";
    };
    version = "0.34.2";
  };
  prawn-table = {
    dependencies = [ "prawn" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1nxd6qmxqwl850icp18wjh5k0s3amxcajdrkjyzpfgq0kvilcv9k";
      type = "gem";
    };
    version = "0.2.2";
  };
  prawn-templates = {
    dependencies = [
      "pdf-reader"
      "prawn"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1w9irn3rllm992c6j7fsx81gg539i7yy8zfddyw7q53hnlys0yhi";
      type = "gem";
    };
    version = "0.1.2";
  };
  public_suffix = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0vqcw3iwby3yc6avs1vb3gfd0vcp2v7q310665dvxfswmcf4xm31";
      type = "gem";
    };
    version = "6.0.1";
  };
  "pygments.rb" = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "14xhvfnj188pypy6pxj29hrn60pznv6dc4ycdgyd6jv2d769wwj1";
      type = "gem";
    };
    version = "3.0.0";
  };
  racc = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0byn0c9nkahsl93y9ln5bysq4j31q8xkf2ws42swighxd4lnjzsa";
      type = "gem";
    };
    version = "1.8.1";
  };
  rb-fsevent = {
    groups = [ "default" ];
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
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0vmy8xgahixcz6hzwy4zdcyn2y6d6ri8dqv5xccgzc1r292019x0";
      type = "gem";
    };
    version = "0.11.1";
  };
  rexml = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1j9p66pmfgxnzp76ksssyfyqqrg7281dyi3xyknl3wwraaw7a66p";
      type = "gem";
    };
    version = "3.3.9";
  };
  rouge = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0r0b48945hakgy0y7lg6h1bb7pkfz8jqd0r6777f80ij3sansvbs";
      type = "gem";
    };
    version = "4.4.0";
  };
  ruby-enum = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ry6ha94a5jqbj5y3x9k0szyy3jgnsfyxvva98nivg6yx1dfyrz7";
      type = "gem";
    };
    version = "1.0.0";
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
  rubyzip = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0grps9197qyxakbpw02pda59v45lfgbgiyw48i0mq9f2bn9y6mrz";
      type = "gem";
    };
    version = "2.3.2";
  };
  sass = {
    dependencies = [ "sass-listen" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0p95lhs0jza5l7hqci1isflxakz83xkj97lkvxl919is0lwhv2w0";
      type = "gem";
    };
    version = "3.7.4";
  };
  sass-listen = {
    dependencies = [
      "rb-fsevent"
      "rb-inotify"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xw3q46cmahkgyldid5hwyiwacp590zj2vmswlll68ryvmvcp7df";
      type = "gem";
    };
    version = "4.0.0";
  };
  thread_safe = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0nmhcgq6cgz44srylra07bmaw99f5271l0dpsvl5f75m44l0gmwy";
      type = "gem";
    };
    version = "0.3.6";
  };
  treetop = {
    dependencies = [ "polyglot" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0adc8qblz8ii668r3rksjx83p675iryh52rvdvysimx2hkbasj7d";
      type = "gem";
    };
    version = "1.6.12";
  };
  ttfunk = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "15iaxz9iak5643bq2bc0jkbjv8w2zn649lxgvh5wg48q9d4blw13";
      type = "gem";
    };
    version = "1.7.0";
  };
}
