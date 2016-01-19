{
  "addressable" = {
    version = "2.3.8";
    source = {
      type = "gem";
      sha256 = "1533axm85gpz267km9gnfarf9c78g2scrysd6b8yw33vmhkz2km6";
    };
  };
  "berkshelf" = {
    version = "4.0.1";
    source = {
      type = "gem";
      sha256 = "14mh88lzpmlsc2q2m611pd3vyvxnhi16klnnrbg5ccrdl7xn4l4a";
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
    version = "2.0.0";
    source = {
      type = "gem";
      sha256 = "18kmbmilkj7dgykli8z22kdx5hvpxwvsby7xjlsj23gi1akk6lyl";
    };
    dependencies = [
      "faraday"
      "httpclient"
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
    version = "12.6.0";
    source = {
      type = "gem";
      sha256 = "0zg1462lrnz8xbvqyj7skjyikdn73hd1ccmnkx9jzj5gg4rfkf25";
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
      "pry"
      "rspec-core"
      "rspec-expectations"
      "rspec-mocks"
      "rspec_junit_formatter"
      "serverspec"
      "specinfra"
      "syslog-logger"
    ];
  };
  "chef-config" = {
    version = "12.6.0";
    source = {
      type = "gem";
      sha256 = "0clbamqxi8dy69a9bhi3aswl42lpfah3w2kjy6a81953jkyjjwwm";
    };
    dependencies = [
      "mixlib-config"
      "mixlib-shellout"
    ];
  };
  "chef-zero" = {
    version = "4.4.0";
    source = {
      type = "gem";
      sha256 = "1a8kky15wjj1v2lbjpilija4lbqslsymvbmg4w21ch7p0k66fkyc";
    };
    dependencies = [
      "ffi-yajl"
      "hashie"
      "mixlib-log"
      "rack"
      "uuidtools"
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
    version = "1.1.0";
    source = {
      type = "gem";
      sha256 = "059wkzlap2jlkhg460pkwc1ay4v4clsmg1bp4vfzjzkgwdckr52s";
    };
  };
  "dep-selector-libgecode" = {
    version = "1.0.2";
    source = {
      type = "gem";
      sha256 = "0755ps446wc4cf26ggmvibr4wmap6ch7zhkh1qmx1p6lic2hr4gn";
    };
  };
  "dep_selector" = {
    version = "1.0.3";
    source = {
      type = "gem";
      sha256 = "1ic90j3d6hmyxmdxzdz8crwmvw61f4kj0jphk43m6ipcx6bkphzw";
    };
    dependencies = [
      "dep-selector-libgecode"
      "ffi"
    ];
  };
  "diff-lcs" = {
    version = "1.2.5";
    source = {
      type = "gem";
      sha256 = "1vf9civd41bnqi6brr5d9jifdw73j9khc6fkhfl1f8r9cpkdvlx1";
    };
  };
  "erubis" = {
    version = "2.7.0";
    source = {
      type = "gem";
      sha256 = "1fj827xqjs91yqsydf0zmfyw9p4l2jz5yikg3mppz6d7fi8kyrb3";
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
    version = "2.6.0.1";
    source = {
      type = "gem";
      sha256 = "0haz4s9xnzr73mkfpgabspj43bhfm9znmpmgdk74n6gih1xlrx1l";
    };
  };
  "ipaddress" = {
    version = "0.8.2";
    source = {
      type = "gem";
      sha256 = "0sl0ldvhd6j0qbwhz18w24qy65mdj448b2vhgh2cwn7xrkksmv9l";
    };
  };
  "json" = {
    version = "1.8.3";
    source = {
      type = "gem";
      sha256 = "1nsby6ry8l9xg3yw4adlhk2pnc7i0h0rznvcss4vk3v74qg0k8lc";
    };
  };
  "knife-solo" = {
    version = "0.5.1";
    source = {
      type = "gem";
      sha256 = "0lcii10xa3i4sccp0nc8nkpisqbxh6cwyfakl1hv3my7zpajg6ia";
    };
    dependencies = [
      "chef"
      "erubis"
      "net-ssh"
    ];
  };
  "knife-solo_data_bag" = {
    version = "1.1.0";
    source = {
      type = "gem";
      sha256 = "1hn4qz3xmzfph04z4prmk1820qshwibxr7ihv96ry47n3bqw5z3k";
    };
  };
  "libyajl2" = {
    version = "1.2.0";
    source = {
      type = "gem";
      sha256 = "0n5j0p8dxf9xzb9n4bkdr8w0a8gg3jzrn9indri3n0fv90gcs5qi";
    };
  };
  "method_source" = {
    version = "0.8.2";
    source = {
      type = "gem";
      sha256 = "1g5i4w0dmlhzd18dijlqw5gk27bv6dj2kziqzrzb7mpgxgsd1sf2";
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
    version = "1.3.0";
    source = {
      type = "gem";
      sha256 = "1c5p5ipa3cssmwgdn0q3lyy1w7asikh9qfpnn7xcfz2f9m7v02zg";
    };
    dependencies = [
      "mixlib-log"
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
  "mixlib-log" = {
    version = "1.6.0";
    source = {
      type = "gem";
      sha256 = "1xblfxby3psh4n5cgc6j6xnvmmssyr8qjy0l76f92nr4b9yvv9m2";
    };
  };
  "mixlib-shellout" = {
    version = "2.2.5";
    source = {
      type = "gem";
      sha256 = "1is07rar0x8n9h67j4iyrxz2yfgis4bnhh3x7vhbbi6khqqixg79";
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
    version = "2.9.2";
    source = {
      type = "gem";
      sha256 = "1p0bj41zrmw5lhnxlm1pqb55zfz9y4p9fkrr9a79nrdmzrk1ph8r";
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
    version = "1.2.0";
    source = {
      type = "gem";
      sha256 = "1g3cvq16k04277fjg7i8yisp038x4v5s7745qlk96yn02lhm49rl";
    };
  };
  "octokit" = {
    version = "3.8.0";
    source = {
      type = "gem";
      sha256 = "0vmknh0vz1g734q32kgpxv0qwz9ifmnw2jfpd2w5rrk6xwq1k7a8";
    };
    dependencies = [
      "sawyer"
    ];
  };
  "ohai" = {
    version = "8.8.1";
    source = {
      type = "gem";
      sha256 = "1kk1z3ksbspbw5yvx2l6nb5ibiwqw67k0rkpqs9smmkbfj213f4j";
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
      "rake"
      "systemu"
      "wmi-lite"
    ];
  };
  "plist" = {
    version = "3.1.0";
    source = {
      type = "gem";
      sha256 = "0rh8nddwdya888j1f4wix3dfan1rlana3mc7mwrvafxir88a1qcs";
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
  "rack" = {
    version = "1.6.4";
    source = {
      type = "gem";
      sha256 = "09bs295yq6csjnkzj7ncj50i6chfxrhmzg1pk6p0vd2lb9ac8pj5";
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
    version = "4.4.2";
    source = {
      type = "gem";
      sha256 = "0avcjwm416rhsjn6hglggbwxpmhh07rsh2mk4j9krhlyym0ccadn";
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
    version = "3.4.1";
    source = {
      type = "gem";
      sha256 = "0zl4fbrzl4gg2bn3fhv910q04sm2jvzdidmvd71gdgqwbzk0zngn";
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
  "sawyer" = {
    version = "0.6.0";
    source = {
      type = "gem";
      sha256 = "0fk43bzwn816qj1ksiicm2i1kmzv5675cmnvk57kmfmi4rfsyjpy";
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
    version = "2.29.0";
    source = {
      type = "gem";
      sha256 = "06sp2zbvd2i7gpdsra6xyzxb1fk824slz89xxp9wb3g5czfyd1dz";
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
    version = "1.2.1";
    source = {
      type = "gem";
      sha256 = "0ff5iwhsr6fcp10gd2ivrx1fcw3lm5f5f11srhy2z5dc3v79mcja";
    };
    dependencies = [
      "dep_selector"
      "semverse"
    ];
  };
  "specinfra" = {
    version = "2.49.0";
    source = {
      type = "gem";
      sha256 = "0ls9fjsbgkgk4n6z7vhv71nkii5b64bzzisrr2y29s430l56qhx6";
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
  "wmi-lite" = {
    version = "1.0.0";
    source = {
      type = "gem";
      sha256 = "06pm7jr2gcnphhhswha2kqw0vhxy91i68942s7gqriadbc8pq9z3";
    };
  };
}