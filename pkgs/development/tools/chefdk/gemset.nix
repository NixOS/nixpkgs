{
  "addressable" = {
    version = "2.4.0";
    source = {
      type = "gem";
      sha256 = "0mpn7sbjl477h56gmxsjqb89r5s3w7vx5af994ssgc3iamvgzgvs";
    };
  };
  "app_conf" = {
    version = "0.4.2";
    source = {
      type = "gem";
      sha256 = "1yqwhr7d9i0cgavqkkq0b4pfqpn213dbhj5ayygr293wplm0jh57";
    };
  };
  "ast" = {
    version = "2.2.0";
    source = {
      type = "gem";
      sha256 = "14md08f8f1mmr2v7lczqnf1n1v8bal73gvg6ldhvkds1bmbnkrlb";
    };
  };
  "berkshelf" = {
    version = "4.3.0";
    source = {
      type = "gem";
      sha256 = "1dsbyq3749b9133rmnzjak7rsysyps1ryalc2r4rxyihflmxhix9";
    };
    dependencies = [
      "addressable"
      "berkshelf-api-client"
      "buff-config"
      "buff-extensions"
      "buff-shell_out"
      "celluloid"
      "celluloid-io"
      "cleanroom"
      "faraday"
      "httpclient"
      "minitar"
      "octokit"
      "retryable"
      "ridley"
      "solve"
      "thor"
    ];
  };
  "berkshelf-api-client" = {
    version = "2.0.2";
    source = {
      type = "gem";
      sha256 = "0xbn8q2xi09x5a7ma6wqs13gkpzj4ly21vls7m7ffv3sw8x29cyc";
    };
    dependencies = [
      "faraday"
      "httpclient"
      "ridley"
    ];
  };
  "buff-config" = {
    version = "1.0.1";
    source = {
      type = "gem";
      sha256 = "0r3h3mk1dj7pc4zymz450bdqp23faqprx363ji4zfdg8z6r31jfh";
    };
    dependencies = [
      "buff-extensions"
      "varia_model"
    ];
  };
  "buff-extensions" = {
    version = "1.0.0";
    source = {
      type = "gem";
      sha256 = "1jqb5sn38qgx66lc4km6rljzz05myijjw12hznz1fk0k4qfw6yzk";
    };
  };
  "buff-ignore" = {
    version = "1.1.1";
    source = {
      type = "gem";
      sha256 = "1ghzhkgbq7f5fc7xilw0c9gspxpdhqhq3ygi1ybjm6r0dxlmvdb4";
    };
  };
  "buff-ruby_engine" = {
    version = "0.1.0";
    source = {
      type = "gem";
      sha256 = "1llpwpmzkakbgz9fc3vr1298cx1n9zv1g25fwj80xnnr7428aj8p";
    };
  };
  "buff-shell_out" = {
    version = "0.2.0";
    source = {
      type = "gem";
      sha256 = "0sphb69vxm346ys2laiz174k5jx628vfwz9ch8g2w9plc4xkxf3p";
    };
    dependencies = [
      "buff-ruby_engine"
    ];
  };
  "builder" = {
    version = "3.2.2";
    source = {
      type = "gem";
      sha256 = "14fii7ab8qszrvsvhz6z2z3i4dw0h41a62fjr2h1j8m41vbrmyv2";
    };
  };
  "celluloid" = {
    version = "0.16.0";
    source = {
      type = "gem";
      sha256 = "044xk0y7i1xjafzv7blzj5r56s7zr8nzb619arkrl390mf19jxv3";
    };
    dependencies = [
      "timers"
    ];
  };
  "celluloid-io" = {
    version = "0.16.2";
    source = {
      type = "gem";
      sha256 = "1l1x0p6daa5vskywrvaxdlanwib3k5pps16axwyy4p8d49pn9rnx";
    };
    dependencies = [
      "celluloid"
      "nio4r"
    ];
  };
  "chef" = {
    version = "12.8.1";
    source = {
      type = "gem";
      sha256 = "16wb3ymnl7rbayy8qp35fp0947cnq2y9bac7xzhc1njp5j2p6lhg";
    };
    dependencies = [
      "chef-config"
      "chef-zero"
      "diff-lcs"
      "erubis"
      "ffi-yajl"
      "highline"
      "mixlib-authentication"
      "mixlib-cli"
      "mixlib-log"
      "mixlib-shellout"
      "net-ssh"
      "net-ssh-multi"
      "ohai"
      "plist"
      "proxifier"
      "rspec-core"
      "rspec-expectations"
      "rspec-mocks"
      "rspec_junit_formatter"
      "serverspec"
      "specinfra"
      "syslog-logger"
      "uuidtools"
    ];
  };
  "chef-config" = {
    version = "12.8.1";
    source = {
      type = "gem";
      sha256 = "0chgbdv9c1xfkhzx3kmpr8lj0wjdbziixgln2y3ryn84x4fg84ic";
    };
    dependencies = [
      "mixlib-config"
      "mixlib-shellout"
    ];
  };
  "chef-dk" = {
    version = "0.11.2";
    source = {
      type = "gem";
      sha256 = "1qfx5qclvh3kwjgfs18iwdn0knpgka5py7mwi4r0mz2sw14wq5wk";
    };
    dependencies = [
      "chef"
      "chef-provisioning"
      "cookbook-omnifetch"
      "diff-lcs"
      "ffi-yajl"
      "minitar"
      "mixlib-cli"
      "mixlib-shellout"
      "paint"
      "solve"
    ];
  };
  "chef-provisioning" = {
    version = "1.6.0";
    source = {
      type = "gem";
      sha256 = "1nxgia4zyhyqbrz65q7lgjwx8ba5iyzxdxa181y0s4aqqpv0j45g";
    };
    dependencies = [
      "cheffish"
      "inifile"
      "mixlib-install"
      "net-scp"
      "net-ssh"
      "net-ssh-gateway"
      "winrm"
    ];
  };
  "chef-vault" = {
    version = "2.8.0";
    source = {
      type = "gem";
      sha256 = "0dbvawlrfx9mqjyh8q71jjfh987xqqv3f6c0pmcjp6qxs95l1dqq";
    };
  };
  "chef-zero" = {
    version = "4.5.0";
    source = {
      type = "gem";
      sha256 = "1lqvmgjniviahrhim8k67qddnwh5p7wzw33r1wga4z136pfka1zx";
    };
    dependencies = [
      "ffi-yajl"
      "hashie"
      "mixlib-log"
      "rack"
      "uuidtools"
    ];
  };
  "cheffish" = {
    version = "2.0.2";
    source = {
      type = "gem";
      sha256 = "0mvp7kybgp3nm2sdcmlx8bv147hcdjx745a8k97bx1m47isv97ax";
    };
    dependencies = [
      "chef-zero"
      "compat_resource"
    ];
  };
  "chefspec" = {
    version = "4.6.0";
    source = {
      type = "gem";
      sha256 = "1ikn8k6xdqixdjga50jmkqajz2z2z71dg4j3dsmd31hv1mdbp7wz";
    };
    dependencies = [
      "chef"
      "fauxhai"
      "rspec"
    ];
  };
  "cleanroom" = {
    version = "1.0.0";
    source = {
      type = "gem";
      sha256 = "1r6qa4b248jasv34vh7rw91pm61gzf8g5dvwx2gxrshjs7vbhfml";
    };
  };
  "coderay" = {
    version = "1.1.1";
    source = {
      type = "gem";
      sha256 = "1x6z923iwr1hi04k6kz5a6llrixflz8h5sskl9mhaaxy9jx2x93r";
    };
  };
  "compat_resource" = {
    version = "12.8.0";
    source = {
      type = "gem";
      sha256 = "0zp1dd1wkbgxbazvs7acqyk1xjls0wq1pd5ilhj6zi63lpychgy5";
    };
  };
  "cookbook-omnifetch" = {
    version = "0.2.2";
    source = {
      type = "gem";
      sha256 = "1ml25xc69nsgbvp9a6w9yi376rav7b659cvyr8qhfb4jaj4l1yd6";
    };
    dependencies = [
      "minitar"
    ];
  };
  "diff-lcs" = {
    version = "1.2.5";
    source = {
      type = "gem";
      sha256 = "1vf9civd41bnqi6brr5d9jifdw73j9khc6fkhfl1f8r9cpkdvlx1";
    };
  };
  "diffy" = {
    version = "3.1.0";
    source = {
      type = "gem";
      sha256 = "1azibizfv91sjbzhjqj1pg2xcv8z9b8a7z6kb3wpl4hpj5hil5kj";
    };
  };
  "docker-api" = {
    version = "1.26.2";
    source = {
      type = "gem";
      sha256 = "0sg2xazcga21pmlb9yy1z5f3yyzqa2ly5b2h2cxfhyfda6k748wk";
    };
    dependencies = [
      "excon"
      "json"
    ];
  };
  "erubis" = {
    version = "2.7.0";
    source = {
      type = "gem";
      sha256 = "1fj827xqjs91yqsydf0zmfyw9p4l2jz5yikg3mppz6d7fi8kyrb3";
    };
  };
  "excon" = {
    version = "0.48.0";
    source = {
      type = "gem";
      sha256 = "0hjfd2p2mhklavhy8gy1ygm390iz3imx71065dcr9r28s3wk63gf";
    };
  };
  "faraday" = {
    version = "0.9.2";
    source = {
      type = "gem";
      sha256 = "1kplqkpn2s2yl3lxdf6h7sfldqvkbkpxwwxhyk7mdhjplb5faqh6";
    };
    dependencies = [
      "multipart-post"
    ];
  };
  "fauxhai" = {
    version = "3.1.0";
    source = {
      type = "gem";
      sha256 = "0ff8wappc4n4v7v6969zm64c36qiadfw3igl8cyqrpp36fnqm04d";
    };
    dependencies = [
      "net-ssh"
    ];
  };
  "ffi" = {
    version = "1.9.10";
    source = {
      type = "gem";
      sha256 = "1m5mprppw0xcrv2mkim5zsk70v089ajzqiq5hpyb0xg96fcyzyxj";
    };
  };
  "ffi-yajl" = {
    version = "2.2.3";
    source = {
      type = "gem";
      sha256 = "14wgy2isc5yir4zdkk0l3hzh1s1ycwblqb1hllbv4g9svb9naqbz";
    };
    dependencies = [
      "libyajl2"
    ];
  };
  "foodcritic" = {
    version = "6.0.1";
    source = {
      type = "gem";
      sha256 = "06pi4984g6vwfzqvsf73zpw4h1p63bl7yn2sjb9mqd896bb3v6cn";
    };
    dependencies = [
      "erubis"
      "gherkin"
      "nokogiri"
      "rake"
      "rufus-lru"
      "treetop"
      "yajl-ruby"
    ];
  };
  "gherkin" = {
    version = "2.12.2";
    source = {
      type = "gem";
      sha256 = "1mxfgw15pii1jmq00xxbyp77v71mh3bp99ndgwzfwkxvbcisha25";
    };
    dependencies = [
      "multi_json"
    ];
  };
  "git" = {
    version = "1.3.0";
    source = {
      type = "gem";
      sha256 = "1waikaggw7a1d24nw0sh8fd419gbf7awh000qhsf411valycj6q3";
    };
  };
  "gssapi" = {
    version = "1.2.0";
    source = {
      type = "gem";
      sha256 = "0j93nsf9j57p7x4aafalvjg8hia2mmqv3aky7fmw2ck5yci343ix";
    };
    dependencies = [
      "ffi"
    ];
  };
  "gyoku" = {
    version = "1.3.1";
    source = {
      type = "gem";
      sha256 = "1wn0sl14396g5lyvp8sjmcb1hw9rbyi89gxng91r7w4df4jwiidh";
    };
    dependencies = [
      "builder"
    ];
  };
  "hashie" = {
    version = "3.4.3";
    source = {
      type = "gem";
      sha256 = "1iv5hd0zcryprx9lbcm615r3afc0d6rhc27clywmhhgpx68k8899";
    };
  };
  "highline" = {
    version = "1.7.8";
    source = {
      type = "gem";
      sha256 = "1nf5lgdn6ni2lpfdn4gk3gi47fmnca2bdirabbjbz1fk9w4p8lkr";
    };
  };
  "hitimes" = {
    version = "1.2.3";
    source = {
      type = "gem";
      sha256 = "1fr9raz7652bnnx09dllyjdlnwdxsnl0ig5hq9s4s8vackvmckv4";
    };
  };
  "httpclient" = {
    version = "2.7.1";
    source = {
      type = "gem";
      sha256 = "1y01wgmvwz8r4ycr87d12niglpk0nlh2hkpgy9bnmm8as7kgs428";
    };
  };
  "inifile" = {
    version = "2.0.2";
    source = {
      type = "gem";
      sha256 = "03rpacxnrnisjhd2zhc7629ica958bkdbakicl5kipw1wbprck25";
    };
  };
  "inspec" = {
    version = "0.14.8";
    source = {
      type = "gem";
      sha256 = "0whd57f82ml0awn7wgfi8gj3mwl7njww22hn2ciabxafqld9xrri";
    };
    dependencies = [
      "json"
      "method_source"
      "pry"
      "r-train"
      "rainbow"
      "rspec"
      "rspec-its"
      "rubyzip"
      "thor"
    ];
  };
  "ipaddress" = {
    version = "0.8.3";
    source = {
      type = "gem";
      sha256 = "1x86s0s11w202j6ka40jbmywkrx8fhq8xiy8mwvnkhllj57hqr45";
    };
  };
  "json" = {
    version = "1.8.3";
    source = {
      type = "gem";
      sha256 = "1nsby6ry8l9xg3yw4adlhk2pnc7i0h0rznvcss4vk3v74qg0k8lc";
    };
  };
  "kitchen-inspec" = {
    version = "0.12.3";
    source = {
      type = "gem";
      sha256 = "1vjb9pxb4ga9ppr35k6vsqh053k35b4fxamzg99g17y1rijp6dbj";
    };
    dependencies = [
      "inspec"
      "test-kitchen"
    ];
  };
  "kitchen-vagrant" = {
    version = "0.19.0";
    source = {
      type = "gem";
      sha256 = "0sydjihhvnr40vqnj7bg65zxf00crwvwdli1av03ghhggrp5scla";
    };
    dependencies = [
      "test-kitchen"
    ];
  };
  "knife-spork" = {
    version = "1.6.1";
    source = {
      type = "gem";
      sha256 = "104f3xq4gfy7rszc8zbfakg9wlnwnf8k9zij9ahdq4id3sdf1ylb";
    };
    dependencies = [
      "app_conf"
      "chef"
      "diffy"
      "git"
    ];
  };
  "libyajl2" = {
    version = "1.2.0";
    source = {
      type = "gem";
      sha256 = "0n5j0p8dxf9xzb9n4bkdr8w0a8gg3jzrn9indri3n0fv90gcs5qi";
    };
  };
  "little-plugger" = {
    version = "1.1.4";
    source = {
      type = "gem";
      sha256 = "1frilv82dyxnlg8k1jhrvyd73l6k17mxc5vwxx080r4x1p04gwym";
    };
  };
  "logging" = {
    version = "2.0.0";
    source = {
      type = "gem";
      sha256 = "0ka5q88qvc2w7yr9z338jwxcyj1kifmbr9is5hps2f37asismqvb";
    };
    dependencies = [
      "little-plugger"
      "multi_json"
    ];
  };
  "method_source" = {
    version = "0.8.2";
    source = {
      type = "gem";
      sha256 = "1g5i4w0dmlhzd18dijlqw5gk27bv6dj2kziqzrzb7mpgxgsd1sf2";
    };
  };
  "mini_portile2" = {
    version = "2.0.0";
    source = {
      type = "gem";
      sha256 = "056drbn5m4khdxly1asmiik14nyllswr6sh3wallvsywwdiryz8l";
    };
  };
  "minitar" = {
    version = "0.5.4";
    source = {
      type = "gem";
      sha256 = "1vpdjfmdq1yc4i620frfp9af02ia435dnpj8ybsd7dc3rypkvbka";
    };
  };
  "mixlib-authentication" = {
    version = "1.4.0";
    source = {
      type = "gem";
      sha256 = "0qk6mln2bkp6jgkz3sh5r69lzipzjs4dqdixqq12wzvwapmgc0zj";
    };
    dependencies = [
      "mixlib-log"
      "rspec-core"
      "rspec-expectations"
      "rspec-mocks"
    ];
  };
  "mixlib-cli" = {
    version = "1.5.0";
    source = {
      type = "gem";
      sha256 = "0im6jngj76azrz0nv69hgpy1af4smcgpfvmmwh5iwsqwa46zx0k0";
    };
  };
  "mixlib-config" = {
    version = "2.2.1";
    source = {
      type = "gem";
      sha256 = "0smhnyhw1va94vrd7zapxplbavbs4dc78h9yd1yfv52fzxx16zk3";
    };
  };
  "mixlib-install" = {
    version = "0.7.1";
    source = {
      type = "gem";
      sha256 = "1ws2syfimnqzlff2fp6yj5v7zgnzmi3pj9kbkg7xlmd9fhnkb0n7";
    };
  };
  "mixlib-log" = {
    version = "1.6.0";
    source = {
      type = "gem";
      sha256 = "1xblfxby3psh4n5cgc6j6xnvmmssyr8qjy0l76f92nr4b9yvv9m2";
    };
  };
  "mixlib-shellout" = {
    version = "2.2.6";
    source = {
      type = "gem";
      sha256 = "1xfs7yp533qx3nsd4x2q2r125awyxcizgdc4dwgdlxsa1n1pj0pd";
    };
  };
  "molinillo" = {
    version = "0.2.3";
    source = {
      type = "gem";
      sha256 = "1ylvnpdn20nna488mkzpq3iy6gr866gmkiv090c7g5h88x1qws0b";
    };
  };
  "multi_json" = {
    version = "1.11.2";
    source = {
      type = "gem";
      sha256 = "1rf3l4j3i11lybqzgq2jhszq7fh7gpmafjzd14ymp9cjfxqg596r";
    };
  };
  "multipart-post" = {
    version = "2.0.0";
    source = {
      type = "gem";
      sha256 = "09k0b3cybqilk1gwrwwain95rdypixb2q9w65gd44gfzsd84xi1x";
    };
  };
  "net-scp" = {
    version = "1.2.1";
    source = {
      type = "gem";
      sha256 = "0b0jqrcsp4bbi4n4mzyf70cp2ysyp6x07j8k8cqgxnvb4i3a134j";
    };
    dependencies = [
      "net-ssh"
    ];
  };
  "net-ssh" = {
    version = "3.0.2";
    source = {
      type = "gem";
      sha256 = "1k3hrgr899dlhkn53c4hnn5qzbhc7lwks0vaqgw95gg74hn1ivqw";
    };
  };
  "net-ssh-gateway" = {
    version = "1.2.0";
    source = {
      type = "gem";
      sha256 = "1nqkj4wnj26r81rp3g4jqk7bkd2nqzjil3c9xqwchi0fsbwv2niy";
    };
    dependencies = [
      "net-ssh"
    ];
  };
  "net-ssh-multi" = {
    version = "1.2.1";
    source = {
      type = "gem";
      sha256 = "13kxz9b6kgr9mcds44zpavbndxyi6pvyzyda6bhk1kfmb5c10m71";
    };
    dependencies = [
      "net-ssh"
      "net-ssh-gateway"
    ];
  };
  "net-telnet" = {
    version = "0.1.1";
    source = {
      type = "gem";
      sha256 = "13qxznpwmc3hs51b76wqx2w29r158gzzh8719kv2gpi56844c8fx";
    };
  };
  "nio4r" = {
    version = "1.2.1";
    source = {
      type = "gem";
      sha256 = "1adnm77xfxck0mrvid5d7lwng783gh580rh3y18nq4bwdikr6nha";
    };
  };
  "nokogiri" = {
    version = "1.6.7.2";
    source = {
      type = "gem";
      sha256 = "11sbmpy60ynak6s3794q32lc99hs448msjy8rkp84ay7mq7zqspv";
    };
    dependencies = [
      "mini_portile2"
    ];
  };
  "nori" = {
    version = "2.6.0";
    source = {
      type = "gem";
      sha256 = "066wc774a2zp4vrq3k7k8p0fhv30ymqmxma1jj7yg5735zls8agn";
    };
  };
  "octokit" = {
    version = "4.3.0";
    source = {
      type = "gem";
      sha256 = "1hq47ck0z03vr3rzblyszihn7x2m81gv35chwwx0vrhf17nd27np";
    };
    dependencies = [
      "sawyer"
    ];
  };
  "ohai" = {
    version = "8.12.0";
    source = {
      type = "gem";
      sha256 = "0l7vdfnfm4plla6q4qkngwpmy0ah53pnymlwfzc7iy6jn2n9ibpm";
    };
    dependencies = [
      "chef-config"
      "ffi"
      "ffi-yajl"
      "ipaddress"
      "mixlib-cli"
      "mixlib-config"
      "mixlib-log"
      "mixlib-shellout"
      "plist"
      "rake"
      "systemu"
      "wmi-lite"
    ];
  };
  "paint" = {
    version = "1.0.1";
    source = {
      type = "gem";
      sha256 = "1z1fqyyc2jiv6yabv467h652cxr2lmxl5gqqg7p14y28kdqf0nhj";
    };
  };
  "parser" = {
    version = "2.3.0.6";
    source = {
      type = "gem";
      sha256 = "1r14k5jlsc5ivxjm1kljhk9sqp50rnd71n0mzx18hz135nvw1hbz";
    };
    dependencies = [
      "ast"
    ];
  };
  "plist" = {
    version = "3.1.0";
    source = {
      type = "gem";
      sha256 = "0rh8nddwdya888j1f4wix3dfan1rlana3mc7mwrvafxir88a1qcs";
    };
  };
  "polyglot" = {
    version = "0.3.5";
    source = {
      type = "gem";
      sha256 = "1bqnxwyip623d8pr29rg6m8r0hdg08fpr2yb74f46rn1wgsnxmjr";
    };
  };
  "powerpack" = {
    version = "0.1.1";
    source = {
      type = "gem";
      sha256 = "1fnn3fli5wkzyjl4ryh0k90316shqjfnhydmc7f8lqpi0q21va43";
    };
  };
  "proxifier" = {
    version = "1.0.3";
    source = {
      type = "gem";
      sha256 = "1abzlg39cfji1nx3i8kmb5k3anr2rd392yg2icms24wkqz9g9zj0";
    };
  };
  "pry" = {
    version = "0.10.3";
    source = {
      type = "gem";
      sha256 = "1x78rvp69ws37kwig18a8hr79qn36vh8g1fn75p485y3b3yiqszg";
    };
    dependencies = [
      "coderay"
      "method_source"
      "slop"
    ];
  };
  "r-train" = {
    version = "0.10.3";
    source = {
      type = "gem";
      sha256 = "1hn0aap2lq15p97mb91h32yfsw8rh4imhyjlbs4jx9x52h2q6nam";
    };
    dependencies = [
      "docker-api"
      "json"
      "mixlib-shellout"
      "net-scp"
      "net-ssh"
      "winrm"
      "winrm-fs"
    ];
  };
  "rack" = {
    version = "1.6.4";
    source = {
      type = "gem";
      sha256 = "09bs295yq6csjnkzj7ncj50i6chfxrhmzg1pk6p0vd2lb9ac8pj5";
    };
  };
  "rainbow" = {
    version = "2.1.0";
    source = {
      type = "gem";
      sha256 = "11licivacvfqbjx2rwppi8z89qff2cgs67d4wyx42pc5fg7g9f00";
    };
  };
  "rake" = {
    version = "10.5.0";
    source = {
      type = "gem";
      sha256 = "0jcabbgnjc788chx31sihc5pgbqnlc1c75wakmqlbjdm8jns2m9b";
    };
  };
  "retryable" = {
    version = "2.0.3";
    source = {
      type = "gem";
      sha256 = "0lr3wasxwdyzr0bag179003hs2ycn9w86m450pazc81v19j4x1dq";
    };
  };
  "ridley" = {
    version = "4.5.0";
    source = {
      type = "gem";
      sha256 = "0y0p45y3xp37gg8ab132x4i0iggl3p907wfklhr5gb7r5yj6sj4r";
    };
    dependencies = [
      "addressable"
      "buff-config"
      "buff-extensions"
      "buff-ignore"
      "buff-shell_out"
      "celluloid"
      "celluloid-io"
      "chef-config"
      "erubis"
      "faraday"
      "hashie"
      "httpclient"
      "json"
      "mixlib-authentication"
      "retryable"
      "semverse"
      "varia_model"
    ];
  };
  "rspec" = {
    version = "3.4.0";
    source = {
      type = "gem";
      sha256 = "12axhz2nj2m0dy350lxym76m36m1hq48hc59mf00z9dajbpnj78s";
    };
    dependencies = [
      "rspec-core"
      "rspec-expectations"
      "rspec-mocks"
    ];
  };
  "rspec-core" = {
    version = "3.4.4";
    source = {
      type = "gem";
      sha256 = "1z2zmy3xaq00v20ykamqvnynzv2qrrnbixc6dn0jw1c5q9mqq9fp";
    };
    dependencies = [
      "rspec-support"
    ];
  };
  "rspec-expectations" = {
    version = "3.4.0";
    source = {
      type = "gem";
      sha256 = "07pz570glwg87zpyagxxal0daa1jrnjkiksnn410s6846884fk8h";
    };
    dependencies = [
      "diff-lcs"
      "rspec-support"
    ];
  };
  "rspec-its" = {
    version = "1.2.0";
    source = {
      type = "gem";
      sha256 = "1pwphny5jawcm1hda3vs9pjv1cybaxy17dc1s75qd7drrvx697p3";
    };
    dependencies = [
      "rspec-core"
      "rspec-expectations"
    ];
  };
  "rspec-mocks" = {
    version = "3.4.1";
    source = {
      type = "gem";
      sha256 = "0sk8ijq5d6bwhvjq94gfm02fssxkm99bgpasqazsmmll5m1cn7vr";
    };
    dependencies = [
      "diff-lcs"
      "rspec-support"
    ];
  };
  "rspec-support" = {
    version = "3.4.1";
    source = {
      type = "gem";
      sha256 = "0l6zzlf22hn3pcwnxswsjsiwhqjg7a8mhvm680k5vq98307bkikr";
    };
  };
  "rspec_junit_formatter" = {
    version = "0.2.3";
    source = {
      type = "gem";
      sha256 = "0hphl8iggqh1mpbbv0avf8735x6jgry5wmkqyzgv1zwnimvja1ai";
    };
    dependencies = [
      "builder"
      "rspec-core"
    ];
  };
  "rubocop" = {
    version = "0.38.0";
    source = {
      type = "gem";
      sha256 = "0qgwq558n41z2id7nwc3bh7z8h9yh7c9zdasqn8p30p0p72f5520";
    };
    dependencies = [
      "parser"
      "powerpack"
      "rainbow"
      "ruby-progressbar"
      "unicode-display_width"
    ];
  };
  "ruby-progressbar" = {
    version = "1.7.5";
    source = {
      type = "gem";
      sha256 = "0hynaavnqzld17qdx9r7hfw00y16ybldwq730zrqfszjwgi59ivi";
    };
  };
  "rubyntlm" = {
    version = "0.6.0";
    source = {
      type = "gem";
      sha256 = "00k1cll10mcyg6qpdzyrazm5pjbpj7wq54ki2y8vxz86842vbsgp";
    };
  };
  "rubyzip" = {
    version = "1.2.0";
    source = {
      type = "gem";
      sha256 = "10a9p1m68lpn8pwqp972lv61140flvahm3g9yzbxzjks2z3qlb2s";
    };
  };
  "rufus-lru" = {
    version = "1.0.5";
    source = {
      type = "gem";
      sha256 = "1vrsbvcsl7yspzb761p2gbl7dwz0d1j82msbjsksf8hi4cv970s5";
    };
  };
  "safe_yaml" = {
    version = "1.0.4";
    source = {
      type = "gem";
      sha256 = "1hly915584hyi9q9vgd968x2nsi5yag9jyf5kq60lwzi5scr7094";
    };
  };
  "sawyer" = {
    version = "0.7.0";
    source = {
      type = "gem";
      sha256 = "1cn48ql00mf1ag9icmfpj7g7swh7mdn7992ggynjqbw1gh15bs3j";
    };
    dependencies = [
      "addressable"
      "faraday"
    ];
  };
  "semverse" = {
    version = "1.2.1";
    source = {
      type = "gem";
      sha256 = "0s47lprqwmlhnxm3anrhvd3559g51hgrcqn3mq0fy696zkv8vfd8";
    };
  };
  "serverspec" = {
    version = "2.31.0";
    source = {
      type = "gem";
      sha256 = "169mh6s4drxy9qs7f01gqcaq1qfkvy9hdc1ny3lnk0aiwfcm2s1p";
    };
    dependencies = [
      "multi_json"
      "rspec"
      "rspec-its"
      "specinfra"
    ];
  };
  "sfl" = {
    version = "2.2";
    source = {
      type = "gem";
      sha256 = "0aq7ykbyvx8mx4szkcgp09zs094fg60l2pzxscmxqrgqk9yvyg1j";
    };
  };
  "slop" = {
    version = "3.6.0";
    source = {
      type = "gem";
      sha256 = "00w8g3j7k7kl8ri2cf1m58ckxk8rn350gp4chfscmgv6pq1spk3n";
    };
  };
  "solve" = {
    version = "2.0.2";
    source = {
      type = "gem";
      sha256 = "0mwdd6z3vbzna9vphnkgdghy40xawn0yiwhamvb6spfk6n2c80kb";
    };
    dependencies = [
      "molinillo"
      "semverse"
    ];
  };
  "specinfra" = {
    version = "2.53.1";
    source = {
      type = "gem";
      sha256 = "17jbrn7nm6c72qy1nw064c0yi9cimd295s7j6x9bm878cbyq9i6i";
    };
    dependencies = [
      "net-scp"
      "net-ssh"
      "net-telnet"
      "sfl"
    ];
  };
  "syslog-logger" = {
    version = "1.6.8";
    source = {
      type = "gem";
      sha256 = "14y20phq1khdla4z9wvf98k7j3x6n0rjgs4f7vb0xlf7h53g6hbm";
    };
  };
  "systemu" = {
    version = "2.6.5";
    source = {
      type = "gem";
      sha256 = "0gmkbakhfci5wnmbfx5i54f25j9zsvbw858yg3jjhfs5n4ad1xq1";
    };
  };
  "test-kitchen" = {
    version = "1.6.0";
    source = {
      type = "gem";
      sha256 = "1glmvjm24fmlbhm8q4lzi1ynds77ip3s4s5q6fdjlhdanh6jrgwz";
    };
    dependencies = [
      "mixlib-install"
      "mixlib-shellout"
      "net-scp"
      "net-ssh"
      "safe_yaml"
      "thor"
    ];
  };
  "thor" = {
    version = "0.19.1";
    source = {
      type = "gem";
      sha256 = "08p5gx18yrbnwc6xc0mxvsfaxzgy2y9i78xq7ds0qmdm67q39y4z";
    };
  };
  "timers" = {
    version = "4.0.4";
    source = {
      type = "gem";
      sha256 = "1jx4wb0x182gmbcs90vz0wzfyp8afi1mpl9w5ippfncyk4kffvrz";
    };
    dependencies = [
      "hitimes"
    ];
  };
  "treetop" = {
    version = "1.6.5";
    source = {
      type = "gem";
      sha256 = "1lg7j8xf8yxmnz1v8zkwhs4l6j30kq2pxvvrvpah2frlaqz077dh";
    };
    dependencies = [
      "polyglot"
    ];
  };
  "unicode-display_width" = {
    version = "1.0.2";
    source = {
      type = "gem";
      sha256 = "1cffs73zrn788dyd1vv91p0mcxgx2g1sis6552ggmfib3f148gbi";
    };
  };
  "uuidtools" = {
    version = "2.1.5";
    source = {
      type = "gem";
      sha256 = "0zjvq1jrrnzj69ylmz1xcr30skf9ymmvjmdwbvscncd7zkr8av5g";
    };
  };
  "varia_model" = {
    version = "0.4.1";
    source = {
      type = "gem";
      sha256 = "1qm9fhizfry055yras9g1129lfd48fxg4lh0hck8h8cvjdjz1i62";
    };
    dependencies = [
      "buff-extensions"
      "hashie"
    ];
  };
  "winrm" = {
    version = "1.7.2";
    source = {
      type = "gem";
      sha256 = "1as865gd6f0g0hppw8plki1i4afpn6lcx89sgi52v1mlgwxfifff";
    };
    dependencies = [
      "builder"
      "gssapi"
      "gyoku"
      "httpclient"
      "logging"
      "nori"
      "rubyntlm"
    ];
  };
  "winrm-fs" = {
    version = "0.3.2";
    source = {
      type = "gem";
      sha256 = "08j2ip9wx1vcx45kd9ws6lb6znfq9gib1n2j7shzs10rxwgs1bj8";
    };
    dependencies = [
      "erubis"
      "logging"
      "rubyzip"
      "winrm"
    ];
  };
  "wmi-lite" = {
    version = "1.0.0";
    source = {
      type = "gem";
      sha256 = "06pm7jr2gcnphhhswha2kqw0vhxy91i68942s7gqriadbc8pq9z3";
    };
  };
  "yajl-ruby" = {
    version = "1.2.1";
    source = {
      type = "gem";
      sha256 = "0zvvb7i1bl98k3zkdrnx9vasq0rp2cyy5n7p9804dqs4fz9xh9vf";
    };
  };
}