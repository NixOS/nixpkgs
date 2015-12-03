{
  "builder" = {
    version = "3.2.2";
    source = {
      type = "gem";
      sha256 = "14fii7ab8qszrvsvhz6z2z3i4dw0h41a62fjr2h1j8m41vbrmyv2";
    };
  };
  "chef" = {
    version = "12.5.1";
    source = {
      type = "gem";
      sha256 = "0hf6766wmh1dg7f09hi80s8hn1knvzgnaimbhvc05b4q973k5lmb";
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
    version = "12.5.1";
    source = {
      type = "gem";
      sha256 = "18iqlf9x3iavh6183zlkiasxsz45drshihmk8yj56prrzfiys67m";
    };
    dependencies = [
      "mixlib-config"
      "mixlib-shellout"
    ];
  };
  "chef-dk" = {
    version = "0.10.0";
    source = {
      type = "gem";
      sha256 = "0gxm8dbq7y4bf9wb8zad9q5idsl88f1nm3rvnd2am0xka6bnxv29";
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
    version = "1.5.0";
    source = {
      type = "gem";
      sha256 = "1xln9hf8mcm81cmw96ccmyzrak54fbjrl9wgii37rx04v4a2435n";
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
  "chef-zero" = {
    version = "4.3.2";
    source = {
      type = "gem";
      sha256 = "1djnxs97kj13vj1hxx4v6978pkwm8i03p76gbirbp3z2zs6jyvjf";
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
    version = "1.6.0";
    source = {
      type = "gem";
      sha256 = "10aj660azybnf7444a604pjs8p9pvwm3n4mavy8mp3g30yr07paq";
    };
    dependencies = [
      "chef-zero"
    ];
  };
  "coderay" = {
    version = "1.1.0";
    source = {
      type = "gem";
      sha256 = "059wkzlap2jlkhg460pkwc1ay4v4clsmg1bp4vfzjzkgwdckr52s";
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
  "erubis" = {
    version = "2.7.0";
    source = {
      type = "gem";
      sha256 = "1fj827xqjs91yqsydf0zmfyw9p4l2jz5yikg3mppz6d7fi8kyrb3";
    };
  };
  "ffi" = {
    version = "1.9.10";
    source = {
      type = "gem";
      sha256 = "1m5mprppw0xcrv2mkim5zsk70v089ajzqiq5hpyb0xg96fcyzyxj";
    };
  };
  "ffi-yajl" = {
    version = "2.2.2";
    source = {
      type = "gem";
      sha256 = "013n5cf80p2wfpmj1mdjkbmcyx3hg4c81wl3bamglaf4i12a2qk2";
    };
    dependencies = [
      "libyajl2"
    ];
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
  "httpclient" = {
    version = "2.7.0.1";
    source = {
      type = "gem";
      sha256 = "0k6bqsaqq6c824vrbfb5pkz8bpk565zikd10w85rzj2dy809ik6c";
    };
  };
  "inifile" = {
    version = "2.0.2";
    source = {
      type = "gem";
      sha256 = "03rpacxnrnisjhd2zhc7629ica958bkdbakicl5kipw1wbprck25";
    };
  };
  "ipaddress" = {
    version = "0.8.0";
    source = {
      type = "gem";
      sha256 = "0cwy4pyd9nl2y2apazp3hvi12gccj5a3ify8mi8k3knvxi5wk2ir";
    };
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
  "mime-types" = {
    version = "2.99";
    source = {
      type = "gem";
      sha256 = "1hravghdnk9qbibxb3ggzv7mysl97djh8n0rsswy3ssjaw7cbvf2";
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
  "mixlib-install" = {
    version = "0.7.0";
    source = {
      type = "gem";
      sha256 = "0ll1p7v7fp3rf11dz8pifz33jhl4bdg779n4hzlnbia2z7xfsa2w";
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
  "nori" = {
    version = "2.6.0";
    source = {
      type = "gem";
      sha256 = "066wc774a2zp4vrq3k7k8p0fhv30ymqmxma1jj7yg5735zls8agn";
    };
  };
  "ohai" = {
    version = "8.7.0";
    source = {
      type = "gem";
      sha256 = "1f10kgxh89iwij54yx8q11n1q87653ckvdmdwg8cwz3qlgf4flhy";
    };
    dependencies = [
      "chef-config"
      "ffi"
      "ffi-yajl"
      "ipaddress"
      "mime-types"
      "mixlib-cli"
      "mixlib-config"
      "mixlib-log"
      "mixlib-shellout"
      "rake"
      "systemu"
      "wmi-lite"
    ];
  };
  "paint" = {
    version = "1.0.0";
    source = {
      type = "gem";
      sha256 = "0mhwj6w60q40w4f6jz8xx8bv1kghjvsjc3d8q8pnslax4fkmzbp1";
    };
  };
  "plist" = {
    version = "3.1.0";
    source = {
      type = "gem";
      sha256 = "0rh8nddwdya888j1f4wix3dfan1rlana3mc7mwrvafxir88a1qcs";
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
    version = "10.4.2";
    source = {
      type = "gem";
      sha256 = "1rn03rqlf1iv6n87a78hkda2yqparhhaivfjpizblmxvlw2hk5r8";
    };
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
    version = "3.4.0";
    source = {
      type = "gem";
      sha256 = "0iw9qvpawj3cfcg3xipi1v4y11g9q4f5lvmzgksn6f0chf97sjy1";
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
  "rubyntlm" = {
    version = "0.4.0";
    source = {
      type = "gem";
      sha256 = "03xmi8mxcbc5laad10r6b705dk4vyhl9lr7h940f2rhibymxq45x";
    };
  };
  "semverse" = {
    version = "1.2.1";
    source = {
      type = "gem";
      sha256 = "0s47lprqwmlhnxm3anrhvd3559g51hgrcqn3mq0fy696zkv8vfd8";
    };
  };
  "serverspec" = {
    version = "2.24.3";
    source = {
      type = "gem";
      sha256 = "03v6qqshqjsvbbjf1pwbi2mzgqg84wdbhnqb3gdbl1m9bz7sxg1n";
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
    version = "2.0.1";
    source = {
      type = "gem";
      sha256 = "0009xvg40y59bijds5njnwfshfw68wmj54yz3qy538g9rpxvmqp1";
    };
    dependencies = [
      "molinillo"
      "semverse"
    ];
  };
  "specinfra" = {
    version = "2.44.5";
    source = {
      type = "gem";
      sha256 = "018i3bmmy7lc21hagvwfmz2sdfj0v87a7yy3z162lcpq62vxw89r";
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
  "uuidtools" = {
    version = "2.1.5";
    source = {
      type = "gem";
      sha256 = "0zjvq1jrrnzj69ylmz1xcr30skf9ymmvjmdwbvscncd7zkr8av5g";
    };
  };
  "winrm" = {
    version = "1.3.6";
    source = {
      type = "gem";
      sha256 = "1rx42y5w9d3w6axxwdj9zckzsgsjk172zxn52w2jj65spl98vxbc";
    };
    dependencies = [
      "builder"
      "gssapi"
      "gyoku"
      "httpclient"
      "logging"
      "nori"
      "rubyntlm"
      "uuidtools"
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