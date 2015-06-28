{
  "chef" = {
    version = "12.0.3";
    source = {
      type = "gem";
      sha256 = "0lqix0mli6fm3lwrf563sjvfkfsrnyzbz8xqkp54q65dkl63ldy0";
    };
    dependencies = [
      "chef-zero"
      "diff-lcs"
      "erubis"
      "ffi-yajl"
      "highline"
      "mixlib-authentication"
      "mixlib-cli"
      "mixlib-config"
      "mixlib-log"
      "mixlib-shellout"
      "net-ssh"
      "net-ssh-multi"
      "ohai"
      "plist"
      "pry"
    ];
  };
  "chef-dk" = {
    version = "0.4.0";
    source = {
      type = "gem";
      sha256 = "12fdk5j6cymwk4vk45mvi5i1hs9a88jvg6g7x6pxbc0bp3if2c6a";
    };
    dependencies = [
      "chef"
      "cookbook-omnifetch"
      "ffi-yajl"
      "mixlib-cli"
      "mixlib-shellout"
      "solve"
    ];
  };
  "chef-zero" = {
    version = "3.2.1";
    source = {
      type = "gem";
      sha256 = "04zypmygpxz8nwhjs4gvr8rcb9vqhmz37clbh7k7xxh5b2hs654k";
    };
    dependencies = [
      "ffi-yajl"
      "hashie"
      "mixlib-log"
      "rack"
      "uuidtools"
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
    version = "0.2.0";
    source = {
      type = "gem";
      sha256 = "027zz78693jd5g0fwp0xlzig2zijsxcgvfw5854ig37gy5a54wy4";
    };
    dependencies = [
      "minitar"
    ];
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
  "ffi" = {
    version = "1.9.6";
    source = {
      type = "gem";
      sha256 = "1ckw1336rnyv9yvvl614qgkqqi477g4hljv6xsws2vz14ynlvzhj";
    };
  };
  "ffi-yajl" = {
    version = "1.4.0";
    source = {
      type = "gem";
      sha256 = "1l289wyzc06v0rn73msqxx4gm48iqgxkd9rins22f13qicpczi5g";
    };
    dependencies = [
      "ffi"
      "libyajl2"
    ];
  };
  "hashie" = {
    version = "2.1.2";
    source = {
      type = "gem";
      sha256 = "08w9ask37zh5w989b6igair3zf8gwllyzix97rlabxglif9f9qd9";
    };
  };
  "highline" = {
    version = "1.7.1";
    source = {
      type = "gem";
      sha256 = "1355zfwmm6baq44rp0ny7zdnsipgn5maxk19hvii0jx2bsk417fr";
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
  "method_source" = {
    version = "0.8.2";
    source = {
      type = "gem";
      sha256 = "1g5i4w0dmlhzd18dijlqw5gk27bv6dj2kziqzrzb7mpgxgsd1sf2";
    };
  };
  "mime-types" = {
    version = "2.4.3";
    source = {
      type = "gem";
      sha256 = "16nissnb31wj7kpcaynx4gr67i7pbkzccfg8k7xmplbkla4rmwiq";
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
    version = "2.1.0";
    source = {
      type = "gem";
      sha256 = "13mb628614nl4dfwyyqpxc7b688ls6cfnjx06j8c13sl003xkp7g";
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
    version = "2.0.1";
    source = {
      type = "gem";
      sha256 = "16n2zli15504bfzxwj5riq92zz3h8n8xswvs5gi0dp2dhyjd7lp3";
    };
  };
  "net-dhcp" = {
    version = "1.3.2";
    source = {
      type = "gem";
      sha256 = "13mq3kwk6k3cd0vhnj1xq0gvbg2hbynzpnvq6fa6vqakbyc0iznd";
    };
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
    version = "1.2.0";
    source = {
      type = "gem";
      sha256 = "0927244ac8h3z6wl5cifkblsa95ddpsxr6k8h2fmdvg5wdqs4ydh";
    };
    dependencies = [
      "net-ssh"
      "net-ssh-gateway"
    ];
  };
  "ohai" = {
    version = "8.1.1";
    source = {
      type = "gem";
      sha256 = "1lcbl7lrmy56x6l6ca7miawj9h40ff6nv4b3n6bz3w7fa3vh9xz0";
    };
    dependencies = [
      "ffi"
      "ffi-yajl"
      "ipaddress"
      "mime-types"
      "mixlib-cli"
      "mixlib-config"
      "mixlib-log"
      "mixlib-shellout"
      "net-dhcp"
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
  "pry" = {
    version = "0.10.1";
    source = {
      type = "gem";
      sha256 = "1j0r5fm0wvdwzbh6d6apnp7c0n150hpm9zxpm5xvcgfqr36jaj8z";
    };
    dependencies = [
      "coderay"
      "method_source"
      "slop"
    ];
  };
  "rack" = {
    version = "1.6.0";
    source = {
      type = "gem";
      sha256 = "1f57f8xmrgfgd76s6mq7vx6i266zm4330igw71an1g0kh3a42sbb";
    };
  };
  "rake" = {
    version = "10.4.2";
    source = {
      type = "gem";
      sha256 = "1rn03rqlf1iv6n87a78hkda2yqparhhaivfjpizblmxvlw2hk5r8";
    };
  };
  "semverse" = {
    version = "1.2.1";
    source = {
      type = "gem";
      sha256 = "0s47lprqwmlhnxm3anrhvd3559g51hgrcqn3mq0fy696zkv8vfd8";
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
  "systemu" = {
    version = "2.6.4";
    source = {
      type = "gem";
      sha256 = "16k94azpsy1r958r6ysk4ksnpp54rqmh5hyamad9kwc3lk83i32z";
    };
  };
  "uuidtools" = {
    version = "2.1.5";
    source = {
      type = "gem";
      sha256 = "0zjvq1jrrnzj69ylmz1xcr30skf9ymmvjmdwbvscncd7zkr8av5g";
    };
  };
  "wmi-lite" = {
    version = "1.0.0";
    source = {
      type = "gem";
      sha256 = "06pm7jr2gcnphhhswha2kqw0vhxy91i68942s7gqriadbc8pq9z3";
    };
  };
}