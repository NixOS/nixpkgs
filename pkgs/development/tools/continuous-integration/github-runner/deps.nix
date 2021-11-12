{ fetchurl }:
let
  fetchNuGet = { name, version, sha256 }: fetchurl {
    inherit sha256;
    name = "${name}.${version}";
    url = "https://www.nuget.org/api/v2/package/${name}/${version}";
  };
in
[

  (fetchNuGet {
    name = "castle.core";
    version = "4.4.0";
    sha256 = "0rpcbmyhckvlvp6vbzpj03c1gqz56ixc6f15vgmxmyf1g40c24pf";
  })
  (fetchNuGet {
    name = "microsoft.aspnetcore.app.runtime.linux-x64";
    version = "3.1.19";
    sha256 = "19z4zrchaxcz0a33c33n1qd11z9khj4323nfzsbzah0xxkkj8ka8";
  })
  (fetchNuGet {
    name = "microsoft.aspnetcore.app.runtime.linux-arm64";
    version = "3.1.19";
    sha256 = "0xspb0xib1zsqnkkqm4s26z27v9idh9k09zziar1cavh2hxxxfcd";
  })
  (fetchNuGet {
    name = "microsoft.aspnet.webapi.client";
    version = "5.2.4";
    sha256 = "00fkczf69z2rwarcd8kjjdp47517a0ca6lggn72qbilsp03a5scj";
  })
  (fetchNuGet {
    name = "microsoft.csharp";
    version = "4.0.1";
    sha256 = "0zxc0apx1gcx361jlq8smc9pfdgmyjh6hpka8dypc9w23nlsh6yj";
  })
  (fetchNuGet {
    name = "microsoft.identitymodel.logging";
    version = "5.2.1";
    sha256 = "1gpka9jm2gl6f07pcwzwvaxw9xq1a19i9fskn0qs921c5grhlp3g";
  })
  (fetchNuGet {
    name = "microsoft.identitymodel.tokens";
    version = "5.2.1";
    sha256 = "03v6145vr1winq8xxfikydicds4f10qmy1ybyz2gfimnzzx51w00";
  })
  (fetchNuGet {
    name = "microsoft.netcore.app.runtime.linux-x64";
    version = "3.1.19";
    sha256 = "10c9bq1z8j173n9jzamgplbxq101yscwdhksshn1ybisn7cr5g0h";
  })
  (fetchNuGet {
    name = "microsoft.netcore.app.runtime.linux-arm64";
    version = "3.1.19";
    sha256 = "0v9nc38bg4k2qk547pl1rlrslwprixqlbhcbbf6pw1ia6261wm5m";
  })
  (fetchNuGet {
    name = "microsoft.netcore.platforms";
    version = "1.0.1";
    sha256 = "01al6cfxp68dscl15z7rxfw9zvhm64dncsw09a1vmdkacsa2v6lr";
  })
  (fetchNuGet {
    name = "microsoft.netcore.platforms";
    version = "1.0.1-rc2-24027";
    sha256 = "1a0w5fv8slfr4q7m3mh78lb9awdwyz4zv3bb73vybkyq1f6z7lx8";
  })
  (fetchNuGet {
    name = "microsoft.netcore.platforms";
    version = "1.1.0";
    sha256 = "08vh1r12g6ykjygq5d3vq09zylgb84l63k49jc4v8faw9g93iqqm";
  })
  (fetchNuGet {
    name = "microsoft.netcore.platforms";
    version = "2.0.0";
    sha256 = "1fk2fk2639i7nzy58m9dvpdnzql4vb8yl8vr19r2fp8lmj9w2jr0";
  })
  (fetchNuGet {
    name = "microsoft.netcore.runtime";
    version = "1.0.2-rc2-24027";
    sha256 = "0ippdn16381l8i2iy63i45nk0p303fjbd4amh7biwvqxgagfbvhh";
  })
  (fetchNuGet {
    name = "microsoft.netcore.runtime.coreclr";
    version = "1.0.2-rc2-24027";
    sha256 = "05y0jz6vfl9zs0lmmwsz6arf7r0mg2dm93ymizrzmqn706krz45x";
  })
  (fetchNuGet {
    name = "microsoft.netcore.runtime.native";
    version = "1.0.2-rc2-24027";
    sha256 = "11hpbbmnjbskw7s6sx32l6qzz63kshx0gyp3sawyxk82nbqrissl";
  })
  (fetchNuGet {
    name = "microsoft.netcore.targets";
    version = "1.0.1";
    sha256 = "0ppdkwy6s9p7x9jix3v4402wb171cdiibq7js7i13nxpdky7074p";
  })
  (fetchNuGet {
    name = "microsoft.netcore.targets";
    version = "1.0.1-rc2-24027";
    sha256 = "1j1458jska7540ng7fdf5i06k2vy71mxl5dld4x5s8gfndxpdzdj";
  })
  (fetchNuGet {
    name = "microsoft.netcore.targets";
    version = "1.1.0";
    sha256 = "193xwf33fbm0ni3idxzbr5fdq3i2dlfgihsac9jj7whj0gd902nh";
  })
  (fetchNuGet {
    name = "microsoft.netcore.windows.apisets";
    version = "1.0.1-rc2-24027";
    sha256 = "034m9p417iq3yzipg393wp4bddsh80di9iad78vvvh7w5difdv0x";
  })
  (fetchNuGet {
    name = "microsoft.net.test.sdk";
    version = "15.0.0";
    sha256 = "1ca9v53dphsgk22spilfwq1hjzp2sgrrj85v7hd7wfc6gjh31mb5";
  })
  (fetchNuGet {
    name = "microsoft.testplatform.objectmodel";
    version = "15.0.0";
    sha256 = "0xqssz2y8jzqph6kv1fzy00wzjcnc2whhlf8jsszgpn69ld7f1rb";
  })
  (fetchNuGet {
    name = "microsoft.testplatform.testhost";
    version = "15.0.0";
    sha256 = "1mi59wxwdqyzmkan0v9qrar96f50xs6k38xzv3l6ky859si2qk4b";
  })
  (fetchNuGet {
    name = "microsoft.win32.primitives";
    version = "4.0.1";
    sha256 = "1n8ap0cmljbqskxpf8fjzn7kh1vvlndsa75k01qig26mbw97k2q7";
  })
  (fetchNuGet {
    name = "microsoft.win32.primitives";
    version = "4.0.1-rc2-24027";
    sha256 = "1rvb076s4ksvmbvnxi4sv2f9f22izqp2rca0scjqya5x1qhcgkp0";
  })
  (fetchNuGet {
    name = "microsoft.win32.primitives";
    version = "4.3.0";
    sha256 = "0j0c1wj4ndj21zsgivsc24whiya605603kxrbiw6wkfdync464wq";
  })
  (fetchNuGet {
    name = "microsoft.win32.registry";
    version = "4.0.0";
    sha256 = "1spf4m9pikkc19544p29a47qnhcd885klncahz133hbnyqbkmz9k";
  })
  (fetchNuGet {
    name = "microsoft.win32.registry";
    version = "4.4.0";
    sha256 = "088j2anh1rnkxdcycw5kgp97ahk7cj741y6kask84880835arsb6";
  })
  (fetchNuGet {
    name = "minimatch";
    version = "2.0.0";
    sha256 = "1k84q1bz1qq2nh35nip8vmi65wixsh5y7piln5b4n172xzhfqvx0";
  })
  (fetchNuGet {
    name = "moq";
    version = "4.11.0";
    sha256 = "08bnk80scjjqnkdbjam8grcqrw2rvj9z7556hiznac7in3fcp77w";
  })
  (fetchNuGet {
    name = "netstandard.library";
    version = "1.5.0-rc2-24027";
    sha256 = "1kazwidj63w53r1s6fd8sgykb70kdic27fg9qhg74qzwm354imwm";
  })
  (fetchNuGet {
    name = "netstandard.library";
    version = "1.6.0";
    sha256 = "0nmmv4yw7gw04ik8ialj3ak0j6pxa9spih67hnn1h2c38ba8h58k";
  })
  (fetchNuGet {
    name = "netstandard.library";
    version = "1.6.1";
    sha256 = "1z70wvsx2d847a2cjfii7b83pjfs34q05gb037fdjikv5kbagml8";
  })
  (fetchNuGet {
    name = "newtonsoft.json";
    version = "11.0.2";
    sha256 = "1784xi44f4k8v1fr696hsccmwpy94bz7kixxqlri98zhcxn406b2";
  })
  (fetchNuGet {
    name = "newtonsoft.json";
    version = "9.0.1";
    sha256 = "0mcy0i7pnfpqm4pcaiyzzji4g0c8i3a5gjz28rrr28110np8304r";
  })
  (fetchNuGet {
    name = "newtonsoft.json.bson";
    version = "1.0.1";
    sha256 = "1r1hvj5gjl466bya2bfl5aaj8rbwyf5x1msg710wf3k2llbci1xa";
  })
  (fetchNuGet {
    name = "runtime.any.system.collections";
    version = "4.3.0";
    sha256 = "0bv5qgm6vr47ynxqbnkc7i797fdi8gbjjxii173syrx14nmrkwg0";
  })
  (fetchNuGet {
    name = "runtime.any.system.diagnostics.tools";
    version = "4.3.0";
    sha256 = "1wl76vk12zhdh66vmagni66h5xbhgqq7zkdpgw21jhxhvlbcl8pk";
  })
  (fetchNuGet {
    name = "runtime.any.system.diagnostics.tracing";
    version = "4.3.0";
    sha256 = "00j6nv2xgmd3bi347k00m7wr542wjlig53rmj28pmw7ddcn97jbn";
  })
  (fetchNuGet {
    name = "runtime.any.system.globalization";
    version = "4.3.0";
    sha256 = "1daqf33hssad94lamzg01y49xwndy2q97i2lrb7mgn28656qia1x";
  })
  (fetchNuGet {
    name = "runtime.any.system.globalization.calendars";
    version = "4.3.0";
    sha256 = "1ghhhk5psqxcg6w88sxkqrc35bxcz27zbqm2y5p5298pv3v7g201";
  })
  (fetchNuGet {
    name = "runtime.any.system.io";
    version = "4.3.0";
    sha256 = "0l8xz8zn46w4d10bcn3l4yyn4vhb3lrj2zw8llvz7jk14k4zps5x";
  })
  (fetchNuGet {
    name = "runtime.any.system.reflection";
    version = "4.3.0";
    sha256 = "02c9h3y35pylc0zfq3wcsvc5nqci95nrkq0mszifc0sjx7xrzkly";
  })
  (fetchNuGet {
    name = "runtime.any.system.reflection.extensions";
    version = "4.3.0";
    sha256 = "0zyri97dfc5vyaz9ba65hjj1zbcrzaffhsdlpxc9bh09wy22fq33";
  })
  (fetchNuGet {
    name = "runtime.any.system.reflection.primitives";
    version = "4.3.0";
    sha256 = "0x1mm8c6iy8rlxm8w9vqw7gb7s1ljadrn049fmf70cyh42vdfhrf";
  })
  (fetchNuGet {
    name = "runtime.any.system.resources.resourcemanager";
    version = "4.3.0";
    sha256 = "03kickal0iiby82wa5flar18kyv82s9s6d4xhk5h4bi5kfcyfjzl";
  })
  (fetchNuGet {
    name = "runtime.any.system.runtime";
    version = "4.3.0";
    sha256 = "1cqh1sv3h5j7ixyb7axxbdkqx6cxy00p4np4j91kpm492rf4s25b";
  })
  (fetchNuGet {
    name = "runtime.any.system.runtime.handles";
    version = "4.3.0";
    sha256 = "0bh5bi25nk9w9xi8z23ws45q5yia6k7dg3i4axhfqlnj145l011x";
  })
  (fetchNuGet {
    name = "runtime.any.system.runtime.interopservices";
    version = "4.3.0";
    sha256 = "0c3g3g3jmhlhw4klrc86ka9fjbl7i59ds1fadsb2l8nqf8z3kb19";
  })
  (fetchNuGet {
    name = "runtime.any.system.text.encoding";
    version = "4.3.0";
    sha256 = "0aqqi1v4wx51h51mk956y783wzags13wa7mgqyclacmsmpv02ps3";
  })
  (fetchNuGet {
    name = "runtime.any.system.text.encoding.extensions";
    version = "4.3.0";
    sha256 = "0lqhgqi0i8194ryqq6v2gqx0fb86db2gqknbm0aq31wb378j7ip8";
  })
  (fetchNuGet {
    name = "runtime.any.system.threading.tasks";
    version = "4.3.0";
    sha256 = "03mnvkhskbzxddz4hm113zsch1jyzh2cs450dk3rgfjp8crlw1va";
  })
  (fetchNuGet {
    name = "runtime.any.system.threading.timer";
    version = "4.3.0";
    sha256 = "0aw4phrhwqz9m61r79vyfl5la64bjxj8l34qnrcwb28v49fg2086";
  })
  (fetchNuGet {
    name =
      "runtime.debian.8-x64.runtime.native.system.security.cryptography.openssl";
    version = "4.3.0";
    sha256 = "16rnxzpk5dpbbl1x354yrlsbvwylrq456xzpsha1n9y3glnhyx9d";
  })
  (fetchNuGet {
    name =
      "runtime.fedora.23-x64.runtime.native.system.security.cryptography.openssl";
    version = "4.3.0";
    sha256 = "0hkg03sgm2wyq8nqk6dbm9jh5vcq57ry42lkqdmfklrw89lsmr59";
  })
  (fetchNuGet {
    name =
      "runtime.fedora.24-x64.runtime.native.system.security.cryptography.openssl";
    version = "4.3.0";
    sha256 = "0c2p354hjx58xhhz7wv6div8xpi90sc6ibdm40qin21bvi7ymcaa";
  })
  (fetchNuGet {
    name = "runtime.native.system";
    version = "4.0.0";
    sha256 = "1ppk69xk59ggacj9n7g6fyxvzmk1g5p4fkijm0d7xqfkig98qrkf";
  })
  (fetchNuGet {
    name = "runtime.native.system";
    version = "4.0.0-rc2-24027";
    sha256 = "0n3ndk1g5qdd892sjcz3y2qmg8ki8b001qfgl2fkwv5f52m65pz9";
  })
  (fetchNuGet {
    name = "runtime.native.system";
    version = "4.3.0";
    sha256 = "15hgf6zaq9b8br2wi1i3x0zvmk410nlmsmva9p0bbg73v6hml5k4";
  })
  (fetchNuGet {
    name = "runtime.native.system.io.compression";
    version = "4.1.0";
    sha256 = "0d720z4lzyfcabmmnvh0bnj76ll7djhji2hmfh3h44sdkjnlkknk";
  })
  (fetchNuGet {
    name = "runtime.native.system.io.compression";
    version = "4.1.0-rc2-24027";
    sha256 = "1qnd05bsrz88cr4wnkq7haf2bwml2zzjcscjk94v8ka4isi1i89b";
  })
  (fetchNuGet {
    name = "runtime.native.system.io.compression";
    version = "4.3.0";
    sha256 = "1vvivbqsk6y4hzcid27pqpm5bsi6sc50hvqwbcx8aap5ifrxfs8d";
  })
  (fetchNuGet {
    name = "runtime.native.system.net.http";
    version = "4.0.1";
    sha256 = "1hgv2bmbaskx77v8glh7waxws973jn4ah35zysnkxmf0196sfxg6";
  })
  (fetchNuGet {
    name = "runtime.native.system.net.http";
    version = "4.0.1-rc2-24027";
    sha256 = "0dpgj544rfdqlgjc1nwslwbq49mp286wyy6rfnklxlbfgc2mr216";
  })
  (fetchNuGet {
    name = "runtime.native.system.net.http";
    version = "4.3.0";
    sha256 = "1n6rgz5132lcibbch1qlf0g9jk60r0kqv087hxc0lisy50zpm7kk";
  })
  (fetchNuGet {
    name = "runtime.native.system.security.cryptography";
    version = "4.0.0";
    sha256 = "0k57aa2c3b10wl3hfqbgrl7xq7g8hh3a3ir44b31dn5p61iiw3z9";
  })
  (fetchNuGet {
    name = "runtime.native.system.security.cryptography";
    version = "4.0.0-rc2-24027";
    sha256 = "0pkd72vrqn1jxc20g8h2pgqz02xn2rfbl0m4i7b82xa8bc483jmz";
  })
  (fetchNuGet {
    name = "runtime.native.system.security.cryptography.apple";
    version = "4.3.0";
    sha256 = "1b61p6gw1m02cc1ry996fl49liiwky6181dzr873g9ds92zl326q";
  })
  (fetchNuGet {
    name = "runtime.native.system.security.cryptography.openssl";
    version = "4.3.0";
    sha256 = "18pzfdlwsg2nb1jjjjzyb5qlgy6xjxzmhnfaijq5s2jw3cm3ab97";
  })
  (fetchNuGet {
    name =
      "runtime.opensuse.13.2-x64.runtime.native.system.security.cryptography.openssl";
    version = "4.3.0";
    sha256 = "0qyynf9nz5i7pc26cwhgi8j62ps27sqmf78ijcfgzab50z9g8ay3";
  })
  (fetchNuGet {
    name =
      "runtime.opensuse.42.1-x64.runtime.native.system.security.cryptography.openssl";
    version = "4.3.0";
    sha256 = "1klrs545awhayryma6l7g2pvnp9xy4z0r1i40r80zb45q3i9nbyf";
  })
  (fetchNuGet {
    name =
      "runtime.osx.10.10-x64.runtime.native.system.security.cryptography.apple";
    version = "4.3.0";
    sha256 = "10yc8jdrwgcl44b4g93f1ds76b176bajd3zqi2faf5rvh1vy9smi";
  })
  (fetchNuGet {
    name =
      "runtime.osx.10.10-x64.runtime.native.system.security.cryptography.openssl";
    version = "4.3.0";
    sha256 = "0zcxjv5pckplvkg0r6mw3asggm7aqzbdjimhvsasb0cgm59x09l3";
  })
  (fetchNuGet {
    name =
      "runtime.rhel.7-x64.runtime.native.system.security.cryptography.openssl";
    version = "4.3.0";
    sha256 = "0vhynn79ih7hw7cwjazn87rm9z9fj0rvxgzlab36jybgcpcgphsn";
  })
  (fetchNuGet {
    name =
      "runtime.ubuntu.14.04-x64.runtime.native.system.security.cryptography.openssl";
    version = "4.3.0";
    sha256 = "160p68l2c7cqmyqjwxydcvgw7lvl1cr0znkw8fp24d1by9mqc8p3";
  })
  (fetchNuGet {
    name =
      "runtime.ubuntu.16.04-x64.runtime.native.system.security.cryptography.openssl";
    version = "4.3.0";
    sha256 = "15zrc8fgd8zx28hdghcj5f5i34wf3l6bq5177075m2bc2j34jrqy";
  })
  (fetchNuGet {
    name =
      "runtime.ubuntu.16.10-x64.runtime.native.system.security.cryptography.openssl";
    version = "4.3.0";
    sha256 = "1p4dgxax6p7rlgj4q73k73rslcnz4wdcv8q2flg1s8ygwcm58ld5";
  })
  (fetchNuGet {
    name = "runtime.unix.microsoft.win32.primitives";
    version = "4.3.0";
    sha256 = "0y61k9zbxhdi0glg154v30kkq7f8646nif8lnnxbvkjpakggd5id";
  })
  (fetchNuGet {
    name = "runtime.unix.system.console";
    version = "4.3.0";
    sha256 = "1pfpkvc6x2if8zbdzg9rnc5fx51yllprl8zkm5npni2k50lisy80";
  })
  (fetchNuGet {
    name = "runtime.unix.system.diagnostics.debug";
    version = "4.3.0";
    sha256 = "1lps7fbnw34bnh3lm31gs5c0g0dh7548wfmb8zz62v0zqz71msj5";
  })
  (fetchNuGet {
    name = "runtime.unix.system.io.filesystem";
    version = "4.3.0";
    sha256 = "14nbkhvs7sji5r1saj2x8daz82rnf9kx28d3v2qss34qbr32dzix";
  })
  (fetchNuGet {
    name = "runtime.unix.system.net.primitives";
    version = "4.3.0";
    sha256 = "0bdnglg59pzx9394sy4ic66kmxhqp8q8bvmykdxcbs5mm0ipwwm4";
  })
  (fetchNuGet {
    name = "runtime.unix.system.net.sockets";
    version = "4.3.0";
    sha256 = "03npdxzy8gfv035bv1b9rz7c7hv0rxl5904wjz51if491mw0xy12";
  })
  (fetchNuGet {
    name = "runtime.unix.system.private.uri";
    version = "4.3.0";
    sha256 = "1jx02q6kiwlvfksq1q9qr17fj78y5v6mwsszav4qcz9z25d5g6vk";
  })
  (fetchNuGet {
    name = "runtime.unix.system.runtime.extensions";
    version = "4.3.0";
    sha256 = "0pnxxmm8whx38dp6yvwgmh22smknxmqs5n513fc7m4wxvs1bvi4p";
  })
  (fetchNuGet {
    name = "system.appcontext";
    version = "4.1.0";
    sha256 = "0fv3cma1jp4vgj7a8hqc9n7hr1f1kjp541s6z0q1r6nazb4iz9mz";
  })
  (fetchNuGet {
    name = "system.appcontext";
    version = "4.1.0-rc2-24027";
    sha256 = "0c0x3sg12a5zwiamvxs9c4bhdwmmm9by6x5da58fbrzz7afbaaag";
  })
  (fetchNuGet {
    name = "system.appcontext";
    version = "4.3.0";
    sha256 = "1649qvy3dar900z3g817h17nl8jp4ka5vcfmsr05kh0fshn7j3ya";
  })
  (fetchNuGet {
    name = "system.buffers";
    version = "4.0.0-rc2-24027";
    sha256 = "1mqnay87pkxih73984jf5fm14d0m6yjq4cv4cqbj37nmgm54ssjp";
  })
  (fetchNuGet {
    name = "system.buffers";
    version = "4.3.0";
    sha256 = "0fgns20ispwrfqll4q1zc1waqcmylb3zc50ys9x8zlwxh9pmd9jy";
  })
  (fetchNuGet {
    name = "system.collections";
    version = "4.0.11";
    sha256 = "1ga40f5lrwldiyw6vy67d0sg7jd7ww6kgwbksm19wrvq9hr0bsm6";
  })
  (fetchNuGet {
    name = "system.collections";
    version = "4.0.11-rc2-24027";
    sha256 = "0ijpgf7iy3mcvr9327craxsb0lsznprajqzjy59sspc75gk0yahq";
  })
  (fetchNuGet {
    name = "system.collections";
    version = "4.3.0";
    sha256 = "19r4y64dqyrq6k4706dnyhhw7fs24kpp3awak7whzss39dakpxk9";
  })
  (fetchNuGet {
    name = "system.collections.concurrent";
    version = "4.0.12";
    sha256 = "07y08kvrzpak873pmyxs129g1ch8l27zmg51pcyj2jvq03n0r0fc";
  })
  (fetchNuGet {
    name = "system.collections.concurrent";
    version = "4.0.12-rc2-24027";
    sha256 = "0yhc5q74vb9vb9cmyrr9p4dfql62dr7c8ajbaxnzzs917v2z68q4";
  })
  (fetchNuGet {
    name = "system.collections.concurrent";
    version = "4.3.0";
    sha256 = "0wi10md9aq33jrkh2c24wr2n9hrpyamsdhsxdcnf43b7y86kkii8";
  })
  (fetchNuGet {
    name = "system.collections.immutable";
    version = "1.2.0";
    sha256 = "1jm4pc666yiy7af1mcf7766v710gp0h40p228ghj6bavx7xfa38m";
  })
  (fetchNuGet {
    name = "system.collections.nongeneric";
    version = "4.0.1";
    sha256 = "19994r5y5bpdhj7di6w047apvil8lh06lh2c2yv9zc4fc5g9bl4d";
  })
  (fetchNuGet {
    name = "system.collections.nongeneric";
    version = "4.3.0";
    sha256 = "07q3k0hf3mrcjzwj8fwk6gv3n51cb513w4mgkfxzm3i37sc9kz7k";
  })
  (fetchNuGet {
    name = "system.collections.specialized";
    version = "4.0.1";
    sha256 = "1wbv7y686p5x169rnaim7sln67ivmv6r57falrnx8aap9y33mam9";
  })
  (fetchNuGet {
    name = "system.collections.specialized";
    version = "4.3.0";
    sha256 = "1sdwkma4f6j85m3dpb53v9vcgd0zyc9jb33f8g63byvijcj39n20";
  })
  (fetchNuGet {
    name = "system.componentmodel";
    version = "4.0.1";
    sha256 = "0v4qpmqlzyfad2kswxxj2frnaqqhz9201c3yn8fmmarx5vlzg52z";
  })
  (fetchNuGet {
    name = "system.componentmodel";
    version = "4.3.0";
    sha256 = "0986b10ww3nshy30x9sjyzm0jx339dkjxjj3401r3q0f6fx2wkcb";
  })
  (fetchNuGet {
    name = "system.componentmodel.eventbasedasync";
    version = "4.0.11";
    sha256 = "07r5i7xwban347nsfw28hhjwpr78ywksjyhywvhj1yr0s7sr00wh";
  })
  (fetchNuGet {
    name = "system.componentmodel.primitives";
    version = "4.1.0";
    sha256 = "0wb5mnaag0w4fnyc40x19j8v2vshxp266razw64bcqfyj1whb1q0";
  })
  (fetchNuGet {
    name = "system.componentmodel.primitives";
    version = "4.3.0";
    sha256 = "1svfmcmgs0w0z9xdw2f2ps05rdxmkxxhf0l17xk9l1l8xfahkqr0";
  })
  (fetchNuGet {
    name = "system.componentmodel.typeconverter";
    version = "4.1.0";
    sha256 = "178cva9p1cs043h5n2fry5xkzr3wc9n0hwbxa8m3ymld9m6wcv0y";
  })
  (fetchNuGet {
    name = "system.componentmodel.typeconverter";
    version = "4.3.0";
    sha256 = "17ng0p7v3nbrg3kycz10aqrrlw4lz9hzhws09pfh8gkwicyy481x";
  })
  (fetchNuGet {
    name = "system.console";
    version = "4.0.0";
    sha256 = "0ynxqbc3z1nwbrc11hkkpw9skw116z4y9wjzn7id49p9yi7mzmlf";
  })
  (fetchNuGet {
    name = "system.console";
    version = "4.0.0-rc2-24027";
    sha256 = "072m313av0s5cfpr2rpq07p7c13dy4rh1ngigv3dnr1yyvab9081";
  })
  (fetchNuGet {
    name = "system.console";
    version = "4.3.0";
    sha256 = "1flr7a9x920mr5cjsqmsy9wgnv3lvd0h1g521pdr1lkb2qycy7ay";
  })
  (fetchNuGet {
    name = "system.diagnostics.debug";
    version = "4.0.11";
    sha256 = "0gmjghrqmlgzxivd2xl50ncbglb7ljzb66rlx8ws6dv8jm0d5siz";
  })
  (fetchNuGet {
    name = "system.diagnostics.debug";
    version = "4.0.11-rc2-24027";
    sha256 = "11rz0kdzk4bw9yc85jmskxla7i1bs61kladqzvymrg8xn3lk488a";
  })
  (fetchNuGet {
    name = "system.diagnostics.debug";
    version = "4.3.0";
    sha256 = "00yjlf19wjydyr6cfviaph3vsjzg3d5nvnya26i2fvfg53sknh3y";
  })
  (fetchNuGet {
    name = "system.diagnostics.diagnosticsource";
    version = "4.0.0";
    sha256 = "1n6c3fbz7v8d3pn77h4v5wvsfrfg7v1c57lg3nff3cjyh597v23m";
  })
  (fetchNuGet {
    name = "system.diagnostics.diagnosticsource";
    version = "4.0.0-rc2-24027";
    sha256 = "1cizj1xvaz7dm701r4bl6s08858j1r2794y7xx8abyw8j91c957w";
  })
  (fetchNuGet {
    name = "system.diagnostics.diagnosticsource";
    version = "4.3.0";
    sha256 = "0z6m3pbiy0qw6rn3n209rrzf9x1k4002zh90vwcrsym09ipm2liq";
  })
  (fetchNuGet {
    name = "system.diagnostics.process";
    version = "4.1.0";
    sha256 = "061lrcs7xribrmq7kab908lww6kn2xn1w3rdc41q189y0jibl19s";
  })
  (fetchNuGet {
    name = "system.diagnostics.textwritertracelistener";
    version = "4.0.0";
    sha256 = "1xigiwkwyxak0dhm0p8i2zb7a9syly9cdb5s9zkr9rbad4f2fqhs";
  })
  (fetchNuGet {
    name = "system.diagnostics.tools";
    version = "4.0.1";
    sha256 = "19cknvg07yhakcvpxg3cxa0bwadplin6kyxd8mpjjpwnp56nl85x";
  })
  (fetchNuGet {
    name = "system.diagnostics.tools";
    version = "4.0.1-rc2-24027";
    sha256 = "080gd86c1pkfkzz67ispkzxc426lfh82zajayiizbgwd6yqa7fv5";
  })
  (fetchNuGet {
    name = "system.diagnostics.tools";
    version = "4.3.0";
    sha256 = "0in3pic3s2ddyibi8cvgl102zmvp9r9mchh82ns9f0ms4basylw1";
  })
  (fetchNuGet {
    name = "system.diagnostics.tracesource";
    version = "4.0.0";
    sha256 = "1mc7r72xznczzf6mz62dm8xhdi14if1h8qgx353xvhz89qyxsa3h";
  })
  (fetchNuGet {
    name = "system.diagnostics.tracesource";
    version = "4.3.0";
    sha256 = "1kyw4d7dpjczhw6634nrmg7yyyzq72k75x38y0l0nwhigdlp1766";
  })
  (fetchNuGet {
    name = "system.diagnostics.tracing";
    version = "4.1.0";
    sha256 = "1d2r76v1x610x61ahfpigda89gd13qydz6vbwzhpqlyvq8jj6394";
  })
  (fetchNuGet {
    name = "system.diagnostics.tracing";
    version = "4.1.0-rc2-24027";
    sha256 = "0a0c24lm8yn0hbvd5m64lv7xhs2bmhm5fdpk89xvxj14zdarqhm6";
  })
  (fetchNuGet {
    name = "system.diagnostics.tracing";
    version = "4.3.0";
    sha256 = "1m3bx6c2s958qligl67q7grkwfz3w53hpy7nc97mh6f7j5k168c4";
  })
  (fetchNuGet {
    name = "system.dynamic.runtime";
    version = "4.0.11";
    sha256 = "1pla2dx8gkidf7xkciig6nifdsb494axjvzvann8g2lp3dbqasm9";
  })
  (fetchNuGet {
    name = "system.dynamic.runtime";
    version = "4.3.0";
    sha256 = "1d951hrvrpndk7insiag80qxjbf2y0y39y8h5hnq9612ws661glk";
  })
  (fetchNuGet {
    name = "system.globalization";
    version = "4.0.11";
    sha256 = "070c5jbas2v7smm660zaf1gh0489xanjqymkvafcs4f8cdrs1d5d";
  })
  (fetchNuGet {
    name = "system.globalization";
    version = "4.0.11-rc2-24027";
    sha256 = "0yl161lr85smzdfzb7fbk0lfrqk5ns71hcnws6vm3sn2aqvfmhpn";
  })
  (fetchNuGet {
    name = "system.globalization";
    version = "4.3.0";
    sha256 = "1cp68vv683n6ic2zqh2s1fn4c2sd87g5hpp6l4d4nj4536jz98ki";
  })
  (fetchNuGet {
    name = "system.globalization.calendars";
    version = "4.0.1";
    sha256 = "0bv0alrm2ck2zk3rz25lfyk9h42f3ywq77mx1syl6vvyncnpg4qh";
  })
  (fetchNuGet {
    name = "system.globalization.calendars";
    version = "4.0.1-rc2-24027";
    sha256 = "0whr2qird567iyc137s10qs0xi6607kjii9wi8a8g1f9lybzlz5k";
  })
  (fetchNuGet {
    name = "system.globalization.calendars";
    version = "4.3.0";
    sha256 = "1xwl230bkakzzkrggy1l1lxmm3xlhk4bq2pkv790j5lm8g887lxq";
  })
  (fetchNuGet {
    name = "system.globalization.extensions";
    version = "4.0.1";
    sha256 = "0hjhdb5ri8z9l93bw04s7ynwrjrhx2n0p34sf33a9hl9phz69fyc";
  })
  (fetchNuGet {
    name = "system.globalization.extensions";
    version = "4.3.0";
    sha256 = "02a5zfxavhv3jd437bsncbhd2fp1zv4gxzakp1an9l6kdq1mcqls";
  })
  (fetchNuGet {
    name = "system.identitymodel.tokens.jwt";
    version = "5.2.1";
    sha256 = "08n1z9ngsi26qlhwpjzxafhwl3p279widfci64l2ahxf1gprfqsx";
  })
  (fetchNuGet {
    name = "system.io";
    version = "4.1.0";
    sha256 = "1g0yb8p11vfd0kbkyzlfsbsp5z44lwsvyc0h3dpw6vqnbi035ajp";
  })
  (fetchNuGet {
    name = "system.io";
    version = "4.1.0-rc2-24027";
    sha256 = "0rwqmn743gl21xnb3rwqkdacshd5l86pn23mc4bviva3pbncbjs4";
  })
  (fetchNuGet {
    name = "system.io";
    version = "4.3.0";
    sha256 = "05l9qdrzhm4s5dixmx68kxwif4l99ll5gqmh7rqgw554fx0agv5f";
  })
  (fetchNuGet {
    name = "system.io.compression";
    version = "4.1.0";
    sha256 = "0iym7s3jkl8n0vzm3jd6xqg9zjjjqni05x45dwxyjr2dy88hlgji";
  })
  (fetchNuGet {
    name = "system.io.compression";
    version = "4.1.0-rc2-24027";
    sha256 = "07s5zxdw3ihxdv0mjxb2ywzg9phcp4bayrhkadzm95l4kcv0xaij";
  })
  (fetchNuGet {
    name = "system.io.compression";
    version = "4.3.0";
    sha256 = "084zc82yi6yllgda0zkgl2ys48sypiswbiwrv7irb3r0ai1fp4vz";
  })
  (fetchNuGet {
    name = "system.io.compression.zipfile";
    version = "4.0.1";
    sha256 = "0h72znbagmgvswzr46mihn7xm7chfk2fhrp5krzkjf29pz0i6z82";
  })
  (fetchNuGet {
    name = "system.io.compression.zipfile";
    version = "4.0.1-rc2-24027";
    sha256 = "0np6vf9rnfasz0sqys56kpryc84qcqi1a1rfskmycdlxk182p3s2";
  })
  (fetchNuGet {
    name = "system.io.compression.zipfile";
    version = "4.3.0";
    sha256 = "1yxy5pq4dnsm9hlkg9ysh5f6bf3fahqqb6p8668ndy5c0lk7w2ar";
  })
  (fetchNuGet {
    name = "system.io.filesystem";
    version = "4.0.1";
    sha256 = "0kgfpw6w4djqra3w5crrg8xivbanh1w9dh3qapb28q060wb9flp1";
  })
  (fetchNuGet {
    name = "system.io.filesystem";
    version = "4.0.1-rc2-24027";
    sha256 = "0hpw3ssnbcv9l1lnlcym2bv3h3sf2znif4brys2i3868s6h946k6";
  })
  (fetchNuGet {
    name = "system.io.filesystem";
    version = "4.3.0";
    sha256 = "0z2dfrbra9i6y16mm9v1v6k47f0fm617vlb7s5iybjjsz6g1ilmw";
  })
  (fetchNuGet {
    name = "system.io.filesystem.accesscontrol";
    version = "4.4.0";
    sha256 = "11sna2bv5ai4sivrs7g2gp7g0yjp02s0kasl01j3fa1cvnwwvgkv";
  })
  (fetchNuGet {
    name = "system.io.filesystem.primitives";
    version = "4.0.1";
    sha256 = "1s0mniajj3lvbyf7vfb5shp4ink5yibsx945k6lvxa96r8la1612";
  })
  (fetchNuGet {
    name = "system.io.filesystem.primitives";
    version = "4.0.1-rc2-24027";
    sha256 = "04q3sxrfxqgig9scmxblxlb6n6fypv535lby26pi20ixszs19dxc";
  })
  (fetchNuGet {
    name = "system.io.filesystem.primitives";
    version = "4.3.0";
    sha256 = "0j6ndgglcf4brg2lz4wzsh1av1gh8xrzdsn9f0yznskhqn1xzj9c";
  })
  (fetchNuGet {
    name = "system.io.filesystem.watcher";
    version = "4.0.0-rc2-24027";
    sha256 = "0g2h4q0w42frdz101z2cxs4n9zpxvzb43wnzawx1f26vpilz7km4";
  })
  (fetchNuGet {
    name = "system.linq";
    version = "4.1.0";
    sha256 = "1ppg83svb39hj4hpp5k7kcryzrf3sfnm08vxd5sm2drrijsla2k5";
  })
  (fetchNuGet {
    name = "system.linq";
    version = "4.1.0-rc2-24027";
    sha256 = "0icbsy0vq07achclz32jvnnfdchkgylsjj67gra3fn5906s40n24";
  })
  (fetchNuGet {
    name = "system.linq";
    version = "4.3.0";
    sha256 = "1w0gmba695rbr80l1k2h4mrwzbzsyfl2z4klmpbsvsg5pm4a56s7";
  })
  (fetchNuGet {
    name = "system.linq.expressions";
    version = "4.1.0";
    sha256 = "1gpdxl6ip06cnab7n3zlcg6mqp7kknf73s8wjinzi4p0apw82fpg";
  })
  (fetchNuGet {
    name = "system.linq.expressions";
    version = "4.3.0";
    sha256 = "0ky2nrcvh70rqq88m9a5yqabsl4fyd17bpr63iy2mbivjs2nyypv";
  })
  (fetchNuGet {
    name = "system.net.http";
    version = "4.0.1-rc2-24027";
    sha256 = "1j9z5as3k7ydr4yi83lwh09hqj32g2ndpjgj25xvny5a32dl2mhz";
  })
  (fetchNuGet {
    name = "system.net.http";
    version = "4.1.0";
    sha256 = "1i5rqij1icg05j8rrkw4gd4pgia1978mqhjzhsjg69lvwcdfg8yb";
  })
  (fetchNuGet {
    name = "system.net.http";
    version = "4.3.0";
    sha256 = "1i4gc757xqrzflbk7kc5ksn20kwwfjhw9w7pgdkn19y3cgnl302j";
  })
  (fetchNuGet {
    name = "system.net.nameresolution";
    version = "4.3.0";
    sha256 = "15r75pwc0rm3vvwsn8rvm2krf929mjfwliv0mpicjnii24470rkq";
  })
  (fetchNuGet {
    name = "system.net.primitives";
    version = "4.0.11";
    sha256 = "10xzzaynkzkakp7jai1ik3r805zrqjxiz7vcagchyxs2v26a516r";
  })
  (fetchNuGet {
    name = "system.net.primitives";
    version = "4.0.11-rc2-24027";
    sha256 = "16wv24cb39639i7fcw005hh1rggyz2bgn51dpkdc67aq9lz76ivm";
  })
  (fetchNuGet {
    name = "system.net.primitives";
    version = "4.3.0";
    sha256 = "0c87k50rmdgmxx7df2khd9qj7q35j9rzdmm2572cc55dygmdk3ii";
  })
  (fetchNuGet {
    name = "system.net.sockets";
    version = "4.1.0";
    sha256 = "1385fvh8h29da5hh58jm1v78fzi9fi5vj93vhlm2kvqpfahvpqls";
  })
  (fetchNuGet {
    name = "system.net.sockets";
    version = "4.1.0-rc2-24027";
    sha256 = "062kbbvm17nhwmcxjnakfv3i23vrk6c9gmz6x8q79kcr5hxr40qs";
  })
  (fetchNuGet {
    name = "system.net.sockets";
    version = "4.3.0";
    sha256 = "1ssa65k6chcgi6mfmzrznvqaxk8jp0gvl77xhf1hbzakjnpxspla";
  })
  (fetchNuGet {
    name = "system.objectmodel";
    version = "4.0.12";
    sha256 = "1sybkfi60a4588xn34nd9a58png36i0xr4y4v4kqpg8wlvy5krrj";
  })
  (fetchNuGet {
    name = "system.objectmodel";
    version = "4.0.12-rc2-24027";
    sha256 = "065p89awfiz9kb304hqs7wkfpykd9z9kkv84ihm813msv54i8lvj";
  })
  (fetchNuGet {
    name = "system.objectmodel";
    version = "4.3.0";
    sha256 = "191p63zy5rpqx7dnrb3h7prvgixmk168fhvvkkvhlazncf8r3nc2";
  })
  (fetchNuGet {
    name = "system.private.datacontractserialization";
    version = "4.1.1";
    sha256 = "1xk9wvgzipssp1393nsg4n16zbr5481k03nkdlj954hzq5jkx89r";
  })
  (fetchNuGet {
    name = "system.private.datacontractserialization";
    version = "4.3.0";
    sha256 = "06fjipqvjp559rrm825x6pll8gimdj9x1n3larigh5hsm584gndw";
  })
  (fetchNuGet {
    name = "system.private.uri";
    version = "4.3.0";
    sha256 = "04r1lkdnsznin0fj4ya1zikxiqr0h6r6a1ww2dsm60gqhdrf0mvx";
  })
  (fetchNuGet {
    name = "system.reflection";
    version = "4.1.0";
    sha256 = "1js89429pfw79mxvbzp8p3q93il6rdff332hddhzi5wqglc4gml9";
  })
  (fetchNuGet {
    name = "system.reflection";
    version = "4.1.0-rc2-24027";
    sha256 = "0717y8iqcw19g2zkcs0hkalvjhnpaq5mapd82kxkhiq1djgjhhi2";
  })
  (fetchNuGet {
    name = "system.reflection";
    version = "4.3.0";
    sha256 = "0xl55k0mw8cd8ra6dxzh974nxif58s3k1rjv1vbd7gjbjr39j11m";
  })
  (fetchNuGet {
    name = "system.reflection.emit";
    version = "4.0.1";
    sha256 = "0ydqcsvh6smi41gyaakglnv252625hf29f7kywy2c70nhii2ylqp";
  })
  (fetchNuGet {
    name = "system.reflection.emit";
    version = "4.3.0";
    sha256 = "11f8y3qfysfcrscjpjym9msk7lsfxkk4fmz9qq95kn3jd0769f74";
  })
  (fetchNuGet {
    name = "system.reflection.emit.ilgeneration";
    version = "4.0.1";
    sha256 = "1pcd2ig6bg144y10w7yxgc9d22r7c7ww7qn1frdfwgxr24j9wvv0";
  })
  (fetchNuGet {
    name = "system.reflection.emit.ilgeneration";
    version = "4.3.0";
    sha256 = "0w1n67glpv8241vnpz1kl14sy7zlnw414aqwj4hcx5nd86f6994q";
  })
  (fetchNuGet {
    name = "system.reflection.emit.lightweight";
    version = "4.0.1";
    sha256 = "1s4b043zdbx9k39lfhvsk68msv1nxbidhkq6nbm27q7sf8xcsnxr";
  })
  (fetchNuGet {
    name = "system.reflection.emit.lightweight";
    version = "4.3.0";
    sha256 = "0ql7lcakycrvzgi9kxz1b3lljd990az1x6c4jsiwcacrvimpib5c";
  })
  (fetchNuGet {
    name = "system.reflection.extensions";
    version = "4.0.1";
    sha256 = "0m7wqwq0zqq9gbpiqvgk3sr92cbrw7cp3xn53xvw7zj6rz6fdirn";
  })
  (fetchNuGet {
    name = "system.reflection.extensions";
    version = "4.0.1-rc2-24027";
    sha256 = "0lgz7wwdb02vapa17hgdkf1jnq1mcsbq8gwy6a9iqd04d2mfanv7";
  })
  (fetchNuGet {
    name = "system.reflection.extensions";
    version = "4.3.0";
    sha256 = "02bly8bdc98gs22lqsfx9xicblszr2yan7v2mmw3g7hy6miq5hwq";
  })
  (fetchNuGet {
    name = "system.reflection.metadata";
    version = "1.3.0";
    sha256 = "1y5m6kryhjpqqm2g3h3b6bzig13wkiw954x3b7icqjm6xypm1x3b";
  })
  (fetchNuGet {
    name = "system.reflection.primitives";
    version = "4.0.1";
    sha256 = "1bangaabhsl4k9fg8khn83wm6yial8ik1sza7401621jc6jrym28";
  })
  (fetchNuGet {
    name = "system.reflection.primitives";
    version = "4.0.1-rc2-24027";
    sha256 = "1xjbwji89s69f9lq8wcjfkz8y9ym9zffgj2mg9bv0rxwyqcynpz8";
  })
  (fetchNuGet {
    name = "system.reflection.primitives";
    version = "4.3.0";
    sha256 = "04xqa33bld78yv5r93a8n76shvc8wwcdgr1qvvjh959g3rc31276";
  })
  (fetchNuGet {
    name = "system.reflection.typeextensions";
    version = "4.3.0";
    sha256 = "0y2ssg08d817p0vdag98vn238gyrrynjdj4181hdg780sif3ykp1";
  })
  (fetchNuGet {
    name = "system.reflection.typeextensions";
    version = "4.4.0";
    sha256 = "0n9r1w4lp2zmadyqkgp4sk9wy90sj4ygq4dh7kzamx26i9biys5h";
  })
  (fetchNuGet {
    name = "system.resources.resourcemanager";
    version = "4.0.1";
    sha256 = "0b4i7mncaf8cnai85jv3wnw6hps140cxz8vylv2bik6wyzgvz7bi";
  })
  (fetchNuGet {
    name = "system.resources.resourcemanager";
    version = "4.0.1-rc2-24027";
    sha256 = "06lkqk5hjkcna19inpda5fqbxvd9pq5cs61di7kmhrd2sgzbs6xj";
  })
  (fetchNuGet {
    name = "system.resources.resourcemanager";
    version = "4.3.0";
    sha256 = "0sjqlzsryb0mg4y4xzf35xi523s4is4hz9q4qgdvlvgivl7qxn49";
  })
  (fetchNuGet {
    name = "system.runtime";
    version = "4.1.0";
    sha256 = "02hdkgk13rvsd6r9yafbwzss8kr55wnj8d5c7xjnp8gqrwc8sn0m";
  })
  (fetchNuGet {
    name = "system.runtime";
    version = "4.1.0-rc2-24027";
    sha256 = "1g5ghiyfb8njzfz39cswizjbxgaamil7kgkzgab93fhgk7jksmyg";
  })
  (fetchNuGet {
    name = "system.runtime";
    version = "4.3.0";
    sha256 = "066ixvgbf2c929kgknshcxqj6539ax7b9m570cp8n179cpfkapz7";
  })
  (fetchNuGet {
    name = "system.runtime.extensions";
    version = "4.1.0";
    sha256 = "0rw4rm4vsm3h3szxp9iijc3ksyviwsv6f63dng3vhqyg4vjdkc2z";
  })
  (fetchNuGet {
    name = "system.runtime.extensions";
    version = "4.1.0-rc2-24027";
    sha256 = "09k4c6is31dpccwgb749055m2ad0b84rnapk69fmj3wjswacg26p";
  })
  (fetchNuGet {
    name = "system.runtime.extensions";
    version = "4.3.0";
    sha256 = "1ykp3dnhwvm48nap8q23893hagf665k0kn3cbgsqpwzbijdcgc60";
  })
  (fetchNuGet {
    name = "system.runtime.handles";
    version = "4.0.1";
    sha256 = "1g0zrdi5508v49pfm3iii2hn6nm00bgvfpjq1zxknfjrxxa20r4g";
  })
  (fetchNuGet {
    name = "system.runtime.handles";
    version = "4.0.1-rc2-24027";
    sha256 = "0lw4amgaryahvija5xxb2vmybq7ks4b4ir7g7nc1xw6x9x58jf2q";
  })
  (fetchNuGet {
    name = "system.runtime.handles";
    version = "4.3.0";
    sha256 = "0sw2gfj2xr7sw9qjn0j3l9yw07x73lcs97p8xfc9w1x9h5g5m7i8";
  })
  (fetchNuGet {
    name = "system.runtime.interopservices";
    version = "4.1.0";
    sha256 = "01kxqppx3dr3b6b286xafqilv4s2n0gqvfgzfd4z943ga9i81is1";
  })
  (fetchNuGet {
    name = "system.runtime.interopservices";
    version = "4.1.0-rc2-24027";
    sha256 = "0v5phdy7yr6d1q13fvb6hhd32k89l93z6x4hlkh5qhm1zlavaabl";
  })
  (fetchNuGet {
    name = "system.runtime.interopservices";
    version = "4.3.0";
    sha256 = "00hywrn4g7hva1b2qri2s6rabzwgxnbpw9zfxmz28z09cpwwgh7j";
  })
  (fetchNuGet {
    name = "system.runtime.interopservices.pinvoke";
    version = "4.0.0-rc2-24027";
    sha256 = "0qsgwvr6ppvllblb64p5plr7ssbmwfxxc4qf6l1xfincza8np34r";
  })
  (fetchNuGet {
    name = "system.runtime.interopservices.runtimeinformation";
    version = "4.0.0";
    sha256 = "0glmvarf3jz5xh22iy3w9v3wyragcm4hfdr17v90vs7vcrm7fgp6";
  })
  (fetchNuGet {
    name = "system.runtime.interopservices.runtimeinformation";
    version = "4.0.0-rc2-24027";
    sha256 = "03pgqbgahfgvigyrsd08snzsryg90shfjlbdv4jk6yzfr27va3n2";
  })
  (fetchNuGet {
    name = "system.runtime.interopservices.runtimeinformation";
    version = "4.3.0";
    sha256 = "0q18r1sh4vn7bvqgd6dmqlw5v28flbpj349mkdish2vjyvmnb2ii";
  })
  (fetchNuGet {
    name = "system.runtime.loader";
    version = "4.0.0";
    sha256 = "0lpfi3psqcp6zxsjk2qyahal7zaawviimc8lhrlswhip2mx7ykl0";
  })
  (fetchNuGet {
    name = "system.runtime.loader";
    version = "4.3.0";
    sha256 = "07fgipa93g1xxgf7193a6vw677mpzgr0z0cfswbvqqb364cva8dk";
  })
  (fetchNuGet {
    name = "system.runtime.numerics";
    version = "4.0.1";
    sha256 = "1y308zfvy0l5nrn46mqqr4wb4z1xk758pkk8svbz8b5ij7jnv4nn";
  })
  (fetchNuGet {
    name = "system.runtime.numerics";
    version = "4.0.1-rc2-24027";
    sha256 = "1gkkc7njymmb12dd952q89x2h2jdrhp171vszsjqzh5q2ryj25gh";
  })
  (fetchNuGet {
    name = "system.runtime.numerics";
    version = "4.3.0";
    sha256 = "19rav39sr5dky7afygh309qamqqmi9kcwvz3i0c5700v0c5cg61z";
  })
  (fetchNuGet {
    name = "system.runtime.serialization.json";
    version = "4.0.2";
    sha256 = "08ypbzs0sb302ga04ds5b2wxa2gg0q50zpa0nvc87ipjhs0v66dn";
  })
  (fetchNuGet {
    name = "system.runtime.serialization.primitives";
    version = "4.1.1";
    sha256 = "042rfjixknlr6r10vx2pgf56yming8lkjikamg3g4v29ikk78h7k";
  })
  (fetchNuGet {
    name = "system.runtime.serialization.primitives";
    version = "4.3.0";
    sha256 = "01vv2p8h4hsz217xxs0rixvb7f2xzbh6wv1gzbfykcbfrza6dvnf";
  })
  (fetchNuGet {
    name = "system.runtime.serialization.xml";
    version = "4.3.0";
    sha256 = "1b2cxl2h7s8cydbhbmxhvvq071n9ck61g08npg4gyw7nvg37rfni";
  })
  (fetchNuGet {
    name = "system.security.accesscontrol";
    version = "4.4.0";
    sha256 = "0ixqw47krkazsw0ycm22ivkv7dpg6cjz8z8g0ii44bsx4l8gcx17";
  })
  (fetchNuGet {
    name = "system.security.claims";
    version = "4.3.0";
    sha256 = "0jvfn7j22l3mm28qjy3rcw287y9h65ha4m940waaxah07jnbzrhn";
  })
  (fetchNuGet {
    name = "system.security.cryptography.algorithms";
    version = "4.1.0-rc2-24027";
    sha256 = "183qanczf0jb6njgr9pibyr5jh0m8xwrja3j0pcdnzab0cii3n17";
  })
  (fetchNuGet {
    name = "system.security.cryptography.algorithms";
    version = "4.2.0";
    sha256 = "148s9g5dgm33ri7dnh19s4lgnlxbpwvrw2jnzllq2kijj4i4vs85";
  })
  (fetchNuGet {
    name = "system.security.cryptography.algorithms";
    version = "4.3.0";
    sha256 = "03sq183pfl5kp7gkvq77myv7kbpdnq3y0xj7vi4q1kaw54sny0ml";
  })
  (fetchNuGet {
    name = "system.security.cryptography.cng";
    version = "4.2.0";
    sha256 = "118jijz446kix20blxip0f0q8mhsh9bz118mwc2ch1p6g7facpzc";
  })
  (fetchNuGet {
    name = "system.security.cryptography.cng";
    version = "4.3.0";
    sha256 = "1k468aswafdgf56ab6yrn7649kfqx2wm9aslywjam1hdmk5yypmv";
  })
  (fetchNuGet {
    name = "system.security.cryptography.cng";
    version = "4.4.0";
    sha256 = "1grg9id80m358crr5y4q4rhhbrm122yw8jrlcl1ybi7nkmmck40n";
  })
  (fetchNuGet {
    name = "system.security.cryptography.csp";
    version = "4.0.0";
    sha256 = "1cwv8lqj8r15q81d2pz2jwzzbaji0l28xfrpw29kdpsaypm92z2q";
  })
  (fetchNuGet {
    name = "system.security.cryptography.csp";
    version = "4.0.0-rc2-24027";
    sha256 = "0nny9yvnhf3l5hjsy3ina8cha6sjln993vzkzdqka9d7rq1z23d5";
  })
  (fetchNuGet {
    name = "system.security.cryptography.csp";
    version = "4.3.0";
    sha256 = "1x5wcrddf2s3hb8j78cry7yalca4lb5vfnkrysagbn6r9x6xvrx1";
  })
  (fetchNuGet {
    name = "system.security.cryptography.encoding";
    version = "4.0.0";
    sha256 = "0a8y1a5wkmpawc787gfmnrnbzdgxmx1a14ax43jf3rj9gxmy3vk4";
  })
  (fetchNuGet {
    name = "system.security.cryptography.encoding";
    version = "4.0.0-rc2-24027";
    sha256 = "19f83159vrfnfppzchjclk82w2x1mkvnx1y5yg1f238dpjb2ri8w";
  })
  (fetchNuGet {
    name = "system.security.cryptography.encoding";
    version = "4.3.0";
    sha256 = "1jr6w70igqn07k5zs1ph6xja97hxnb3mqbspdrff6cvssgrixs32";
  })
  (fetchNuGet {
    name = "system.security.cryptography.openssl";
    version = "4.0.0";
    sha256 = "16sx3cig3d0ilvzl8xxgffmxbiqx87zdi8fc73i3i7zjih1a7f4q";
  })
  (fetchNuGet {
    name = "system.security.cryptography.openssl";
    version = "4.0.0-rc2-24027";
    sha256 = "1mqw7xkh4pj110f249c4jpv9mg1sd8c2cr6kj2zc0mic325vvg0s";
  })
  (fetchNuGet {
    name = "system.security.cryptography.openssl";
    version = "4.3.0";
    sha256 = "0givpvvj8yc7gv4lhb6s1prq6p2c4147204a0wib89inqzd87gqc";
  })
  (fetchNuGet {
    name = "system.security.cryptography.pkcs";
    version = "4.4.0";
    sha256 = "1bn7d2czpc994qzdph4drv7p1cv4x55j2dhbmr113p0gs4hx33zh";
  })
  (fetchNuGet {
    name = "system.security.cryptography.primitives";
    version = "4.0.0";
    sha256 = "0i7cfnwph9a10bm26m538h5xcr8b36jscp9sy1zhgifksxz4yixh";
  })
  (fetchNuGet {
    name = "system.security.cryptography.primitives";
    version = "4.0.0-rc2-24027";
    sha256 = "16zwyw3glsq2flq1crd0c24i336bc42rj28a9rjvvkg428vz4rf8";
  })
  (fetchNuGet {
    name = "system.security.cryptography.primitives";
    version = "4.3.0";
    sha256 = "0pyzncsv48zwly3lw4f2dayqswcfvdwq2nz0dgwmi7fj3pn64wby";
  })
  (fetchNuGet {
    name = "system.security.cryptography.protecteddata";
    version = "4.4.0";
    sha256 = "1q8ljvqhasyynp94a1d7jknk946m20lkwy2c3wa8zw2pc517fbj6";
  })
  (fetchNuGet {
    name = "system.security.cryptography.x509certificates";
    version = "4.1.0";
    sha256 = "0clg1bv55mfv5dq00m19cp634zx6inm31kf8ppbq1jgyjf2185dh";
  })
  (fetchNuGet {
    name = "system.security.cryptography.x509certificates";
    version = "4.1.0-rc2-24027";
    sha256 = "1gfxc9p73zak46klrfsyxgkcyzbvqnjarsm0wkvmj31n9g4dpjkz";
  })
  (fetchNuGet {
    name = "system.security.cryptography.x509certificates";
    version = "4.3.0";
    sha256 = "0valjcz5wksbvijylxijjxb1mp38mdhv03r533vnx1q3ikzdav9h";
  })
  (fetchNuGet {
    name = "system.security.principal";
    version = "4.3.0";
    sha256 = "12cm2zws06z4lfc4dn31iqv7072zyi4m910d4r6wm8yx85arsfxf";
  })
  (fetchNuGet {
    name = "system.security.principal.windows";
    version = "4.3.0";
    sha256 = "00a0a7c40i3v4cb20s2cmh9csb5jv2l0frvnlzyfxh848xalpdwr";
  })
  (fetchNuGet {
    name = "system.security.principal.windows";
    version = "4.4.0";
    sha256 = "11rr16fp68apc0arsymgj18w8ajs9a4366wgx9iqwny4glrl20wp";
  })
  (fetchNuGet {
    name = "system.serviceprocess.servicecontroller";
    version = "4.4.0";
    sha256 = "0hyijvysbcjh20mbbgajg9wh04nkjd6y5lqxgm0a6m28zjcjshl6";
  })
  (fetchNuGet {
    name = "system.text.encoding";
    version = "4.0.11";
    sha256 = "1dyqv0hijg265dwxg6l7aiv74102d6xjiwplh2ar1ly6xfaa4iiw";
  })
  (fetchNuGet {
    name = "system.text.encoding";
    version = "4.0.11-rc2-24027";
    sha256 = "0qkaldb06dwmi8gb940h75n9cs5rgy6sqcpa6f443mhahmagmsbd";
  })
  (fetchNuGet {
    name = "system.text.encoding";
    version = "4.3.0";
    sha256 = "1f04lkir4iladpp51sdgmis9dj4y8v08cka0mbmsy0frc9a4gjqr";
  })
  (fetchNuGet {
    name = "system.text.encoding.codepages";
    version = "4.4.0";
    sha256 = "07bzjnflxjk9vgpljfybrpqmvsr9qr2f20nq5wf11imwa5pbhgfc";
  })
  (fetchNuGet {
    name = "system.text.encoding.extensions";
    version = "4.0.11";
    sha256 = "08nsfrpiwsg9x5ml4xyl3zyvjfdi4mvbqf93kjdh11j4fwkznizs";
  })
  (fetchNuGet {
    name = "system.text.encoding.extensions";
    version = "4.0.11-rc2-24027";
    sha256 = "02xic3hhfy48s50bxh25as1l9v3afgrhlxqfnd5ki4qirxly7qs6";
  })
  (fetchNuGet {
    name = "system.text.encoding.extensions";
    version = "4.3.0";
    sha256 = "11q1y8hh5hrp5a3kw25cb6l00v5l5dvirkz8jr3sq00h1xgcgrxy";
  })
  (fetchNuGet {
    name = "system.text.regularexpressions";
    version = "4.0.12-rc2-24027";
    sha256 = "1111sgvbxrxq9c1i0nziqddlzfdc2bsawd0jcf2nna9nkcn4d6br";
  })
  (fetchNuGet {
    name = "system.text.regularexpressions";
    version = "4.1.0";
    sha256 = "1mw7vfkkyd04yn2fbhm38msk7dz2xwvib14ygjsb8dq2lcvr18y7";
  })
  (fetchNuGet {
    name = "system.text.regularexpressions";
    version = "4.3.0";
    sha256 = "1bgq51k7fwld0njylfn7qc5fmwrk2137gdq7djqdsw347paa9c2l";
  })
  (fetchNuGet {
    name = "system.threading";
    version = "4.0.11";
    sha256 = "19x946h926bzvbsgj28csn46gak2crv2skpwsx80hbgazmkgb1ls";
  })
  (fetchNuGet {
    name = "system.threading";
    version = "4.0.11-rc2-24027";
    sha256 = "0aa4zaqma4yagjd44m2j13gr9qzn8rv8dbz3p9mjdk0dx1zpi4iq";
  })
  (fetchNuGet {
    name = "system.threading";
    version = "4.3.0";
    sha256 = "0rw9wfamvhayp5zh3j7p1yfmx9b5khbf4q50d8k5rk993rskfd34";
  })
  (fetchNuGet {
    name = "system.threading.channels";
    version = "4.5.0";
    sha256 = "0n6z3wjia7h2a5vl727p97riydnb6jhhkb1pdcnizza02dwkz0nz";
  })
  (fetchNuGet {
    name = "system.threading.overlapped";
    version = "4.0.1-rc2-24027";
    sha256 = "1ansaxwkc4xi2ngpiv8gjmv02d75y0nb4lfqzxy73r3radakqvdp";
  })
  (fetchNuGet {
    name = "system.threading.tasks";
    version = "4.0.11";
    sha256 = "0nr1r41rak82qfa5m0lhk9mp0k93bvfd7bbd9sdzwx9mb36g28p5";
  })
  (fetchNuGet {
    name = "system.threading.tasks";
    version = "4.0.11-rc2-24027";
    sha256 = "0fsgdzdxm3yj1cym421ymn8x8anhyzgzc1529q5xd1vq4yknwfq0";
  })
  (fetchNuGet {
    name = "system.threading.tasks";
    version = "4.3.0";
    sha256 = "134z3v9abw3a6jsw17xl3f6hqjpak5l682k2vz39spj4kmydg6k7";
  })
  (fetchNuGet {
    name = "system.threading.tasks.extensions";
    version = "4.0.0";
    sha256 = "1cb51z062mvc2i8blpzmpn9d9mm4y307xrwi65di8ri18cz5r1zr";
  })
  (fetchNuGet {
    name = "system.threading.tasks.extensions";
    version = "4.0.0-rc2-24027";
    sha256 = "108sdqpy3ga6gzksl59w1k21a3jlrh8x2igyxh3dm3212rca1pyg";
  })
  (fetchNuGet {
    name = "system.threading.tasks.extensions";
    version = "4.3.0";
    sha256 = "1xxcx2xh8jin360yjwm4x4cf5y3a2bwpn2ygkfkwkicz7zk50s2z";
  })
  (fetchNuGet {
    name = "system.threading.tasks.extensions";
    version = "4.5.1";
    sha256 = "1ikrplvw4m6pzjbq3bfbpr572n4i9mni577zvmrkaygvx85q3myw";
  })
  (fetchNuGet {
    name = "system.threading.thread";
    version = "4.0.0";
    sha256 = "1gxxm5fl36pjjpnx1k688dcw8m9l7nmf802nxis6swdaw8k54jzc";
  })
  (fetchNuGet {
    name = "system.threading.thread";
    version = "4.0.0-rc2-24027";
    sha256 = "1gv963m4523m3m9gbn819bfzmhxqsv93m5kaqmbv4ijyziby2872";
  })
  (fetchNuGet {
    name = "system.threading.threadpool";
    version = "4.3.0";
    sha256 = "027s1f4sbx0y1xqw2irqn6x161lzj8qwvnh2gn78ciiczdv10vf1";
  })
  (fetchNuGet {
    name = "system.threading.timer";
    version = "4.0.1";
    sha256 = "15n54f1f8nn3mjcjrlzdg6q3520571y012mx7v991x2fvp73lmg6";
  })
  (fetchNuGet {
    name = "system.threading.timer";
    version = "4.0.1-rc2-24027";
    sha256 = "06kwi42lgf3zw3b5yw668ammbjl6208y182wyqaaqrxgn5gs4yh7";
  })
  (fetchNuGet {
    name = "system.threading.timer";
    version = "4.3.0";
    sha256 = "1nx773nsx6z5whv8kaa1wjh037id2f1cxhb69pvgv12hd2b6qs56";
  })
  (fetchNuGet {
    name = "system.xml.readerwriter";
    version = "4.0.11";
    sha256 = "0c6ky1jk5ada9m94wcadih98l6k1fvf6vi7vhn1msjixaha419l5";
  })
  (fetchNuGet {
    name = "system.xml.readerwriter";
    version = "4.0.11-rc2-24027";
    sha256 = "0vywggi6mqkbr6g1a1fh821hqfnyq1k829vlhfw908l7mj75k34d";
  })
  (fetchNuGet {
    name = "system.xml.readerwriter";
    version = "4.3.0";
    sha256 = "0c47yllxifzmh8gq6rq6l36zzvw4kjvlszkqa9wq3fr59n0hl3s1";
  })
  (fetchNuGet {
    name = "system.xml.xdocument";
    version = "4.0.11";
    sha256 = "0n4lvpqzy9kc7qy1a4acwwd7b7pnvygv895az5640idl2y9zbz18";
  })
  (fetchNuGet {
    name = "system.xml.xdocument";
    version = "4.0.11-rc2-24027";
    sha256 = "1rvglifac6xq1lawm78w49fq9cl8zvs1g4vrsd2hhf0vb4i85p1z";
  })
  (fetchNuGet {
    name = "system.xml.xdocument";
    version = "4.3.0";
    sha256 = "08h8fm4l77n0nd4i4fk2386y809bfbwqb7ih9d7564ifcxr5ssxd";
  })
  (fetchNuGet {
    name = "system.xml.xmldocument";
    version = "4.0.1";
    sha256 = "0ihsnkvyc76r4dcky7v3ansnbyqjzkbyyia0ir5zvqirzan0bnl1";
  })
  (fetchNuGet {
    name = "system.xml.xmldocument";
    version = "4.3.0";
    sha256 = "0bmz1l06dihx52jxjr22dyv5mxv6pj4852lx68grjm7bivhrbfwi";
  })
  (fetchNuGet {
    name = "system.xml.xmlserializer";
    version = "4.0.11";
    sha256 = "01nzc3gdslw90qfykq4qzr2mdnqxjl4sj0wp3fixiwdmlmvpib5z";
  })
  (fetchNuGet {
    name = "system.xml.xmlserializer";
    version = "4.3.0";
    sha256 = "07pa4sx196vxkgl3csvdmw94nydlsm9ir38xxcs84qjn8cycd912";
  })
  (fetchNuGet {
    name = "system.xml.xpath";
    version = "4.0.1";
    sha256 = "0fjqgb6y66d72d5n8qq1h213d9nv2vi8mpv8p28j3m9rccmsh04m";
  })
  (fetchNuGet {
    name = "system.xml.xpath.xmldocument";
    version = "4.0.1";
    sha256 = "0l7yljgif41iv5g56l3nxy97hzzgck2a7rhnfnljhx9b0ry41bvc";
  })
  (fetchNuGet {
    name = "xunit";
    version = "2.4.1";
    sha256 = "0xf3kaywpg15flqaqfgywqyychzk15kz0kz34j21rcv78q9ywq20";
  })
  (fetchNuGet {
    name = "xunit.abstractions";
    version = "2.0.3";
    sha256 = "00wl8qksgkxld76fgir3ycc5rjqv1sqds6x8yx40927q5py74gfh";
  })
  (fetchNuGet {
    name = "xunit.analyzers";
    version = "0.10.0";
    sha256 = "15n02q3akyqbvkp8nq75a8rd66d4ax0rx8fhdcn8j78pi235jm7j";
  })
  (fetchNuGet {
    name = "xunit.assert";
    version = "2.4.1";
    sha256 = "1imynzh80wxq2rp9sc4gxs4x1nriil88f72ilhj5q0m44qqmqpc6";
  })
  (fetchNuGet {
    name = "xunit.core";
    version = "2.4.1";
    sha256 = "1nnb3j4kzmycaw1g76ii4rfqkvg6l8gqh18falwp8g28h802019a";
  })
  (fetchNuGet {
    name = "xunit.extensibility.core";
    version = "2.4.1";
    sha256 = "103qsijmnip2pnbhciqyk2jyhdm6snindg5z2s57kqf5pcx9a050";
  })
  (fetchNuGet {
    name = "xunit.extensibility.execution";
    version = "2.4.1";
    sha256 = "1pbilxh1gp2ywm5idfl0klhl4gb16j86ib4x83p8raql1dv88qia";
  })
  (fetchNuGet {
    name = "xunit.runner.visualstudio";
    version = "2.4.1";
    sha256 = "0fln5pk18z98gp0zfshy1p9h6r9wc55nyqhap34k89yran646vhn";
  })
  (fetchNuGet {
    name = "yamldotnet.signed";
    version = "5.3.0";
    sha256 = "1gnp5aa2zzg7v61bbn2ra1npy0p07szp5w8vqk44fdj3fcvrdxib";
  })
]
