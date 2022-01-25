{ fetchurl }:
let
  nugetUrlBase = "https://www.nuget.org/api/v2/package";
  fetchNuGet = { pname, version, sha256 }: fetchurl { inherit sha256; url = "${nugetUrlBase}/${pname}/${version}"; };
in
[

  (fetchNuGet {
    pname = "hdrhistogram";
    version = "2.5.0";
    sha256 = "1s2np7m3pp17rgambax9a3x5pd2grx74cr325q3xapjz2gd58sj1";
  })
  (fetchNuGet {
    pname = "microsoft.build.tasks.git";
    version = "1.0.0-beta-63127-02";
    sha256 = "10avjhp4vjbmix4rwacbw6cim2d4kbmz64q4n7r6zz94395l61b6";
  })
  (fetchNuGet {
    pname = "microsoft.codecoverage";
    version = "15.9.0";
    sha256 = "10v5xrdilnm362g9545qxvlrbwc9vn65jhpb1i0jlhyqsj6bfwzg";
  })
  (fetchNuGet {
    pname = "microsoft.netcore.platforms";
    version = "1.1.0";
    sha256 = "08vh1r12g6ykjygq5d3vq09zylgb84l63k49jc4v8faw9g93iqqm";
  })
  (fetchNuGet {
    pname = "microsoft.netcore.platforms";
    version = "1.1.1";
    sha256 = "164wycgng4mi9zqi2pnsf1pq6gccbqvw6ib916mqizgjmd8f44pj";
  })
  (fetchNuGet {
    pname = "microsoft.netcore.platforms";
    version = "2.1.0";
    sha256 = "0nmdnkmwyxj8cp746hs9an57zspqlmqdm55b00i7yk8a22s6akxz";
  })
  (fetchNuGet {
    pname = "microsoft.netcore.targets";
    version = "1.1.0";
    sha256 = "193xwf33fbm0ni3idxzbr5fdq3i2dlfgihsac9jj7whj0gd902nh";
  })
  (fetchNuGet {
    pname = "microsoft.netframework.referenceassemblies";
    version = "1.0.0";
    sha256 = "0na724xhvqm63vq9y18fl9jw9q2v99bdwr353378s5fsi11qzxp9";
  })
  (fetchNuGet {
    pname = "microsoft.netframework.referenceassemblies.net452";
    version = "1.0.0";
    sha256 = "1f0vqrnkggnn4fgfbb2wp4hg9b1n1zvcknvgpphl5dfrk4b0zag8";
  })
  (fetchNuGet {
    pname = "microsoft.netframework.referenceassemblies.net46";
    version = "1.0.0";
    sha256 = "1yl609ilni8adiyryn9rm967sjm499pkx4xj06gpb16dm8d9jkji";
  })
  (fetchNuGet {
    pname = "microsoft.netframework.referenceassemblies.net471";
    version = "1.0.0";
    sha256 = "101incszmaxdhrfzqbfya04fqivi81xvazdfc5l0hr7hm42r6k2m";
  })
  (fetchNuGet {
    pname = "microsoft.net.test.sdk";
    version = "15.9.0";
    sha256 = "0g7wjgiigs4v8qa32g9ysqgx8bx55dzmbxfkc4ic95mpd1vkjqxw";
  })
  (fetchNuGet {
    pname = "microsoft.sourcelink.common";
    version = "1.0.0-beta-63127-02";
    sha256 = "0y29xx3x9nd14n1sr8ycxhf6y1a83pv3sayfxjib8wi6s866lagb";
  })
  (fetchNuGet {
    pname = "microsoft.sourcelink.github";
    version = "1.0.0-beta-63127-02";
    sha256 = "1096d5n7mfvgm1apdmafjkxkqray6r2cw6zjhhxj2zn98836w1n2";
  })
  (fetchNuGet {
    pname = "microsoft.win32.primitives";
    version = "4.3.0";
    sha256 = "0j0c1wj4ndj21zsgivsc24whiya605603kxrbiw6wkfdync464wq";
  })
  (fetchNuGet {
    pname = "netstandard.library";
    version = "2.0.3";
    sha256 = "1fn9fxppfcg4jgypp2pmrpr6awl3qz1xmnri0cygpkwvyx27df1y";
  })
  (fetchNuGet {
    pname = "newtonsoft.json";
    version = "11.0.2";
    sha256 = "1784xi44f4k8v1fr696hsccmwpy94bz7kixxqlri98zhcxn406b2";
  })
  (fetchNuGet {
    pname = "nlog";
    version = "4.5.10";
    sha256 = "0d4yqxrhqn2k36h3v1f5pn6qqlagbzg67v6gvxqhz3s4zyc3b8rg";
  })
  (fetchNuGet {
    pname = "nunit";
    version = "3.11.0";
    sha256 = "0mmc8snwjjmbkhk6cv5c0ha77czzy9bca4q59244rxciw9sxk1cz";
  })
  (fetchNuGet {
    pname = "nunit3testadapter";
    version = "3.10.0";
    sha256 = "0ahzfk9y2dq0wl91ll5hss89hqw7la85ndll5030nslizsgm5q2i";
  })
  (fetchNuGet {
    pname = "protobuf-net";
    version = "2.4.0";
    sha256 = "106lxm9afga7ihlknyy7mlfplyq40mrndksqrsn8ia2a47fbqqld";
  })
  (fetchNuGet {
    pname = "runtime.any.system.collections";
    version = "4.3.0";
    sha256 = "0bv5qgm6vr47ynxqbnkc7i797fdi8gbjjxii173syrx14nmrkwg0";
  })
  (fetchNuGet {
    pname = "runtime.any.system.diagnostics.tracing";
    version = "4.3.0";
    sha256 = "00j6nv2xgmd3bi347k00m7wr542wjlig53rmj28pmw7ddcn97jbn";
  })
  (fetchNuGet {
    pname = "runtime.any.system.globalization";
    version = "4.3.0";
    sha256 = "1daqf33hssad94lamzg01y49xwndy2q97i2lrb7mgn28656qia1x";
  })
  (fetchNuGet {
    pname = "runtime.any.system.globalization.calendars";
    version = "4.3.0";
    sha256 = "1ghhhk5psqxcg6w88sxkqrc35bxcz27zbqm2y5p5298pv3v7g201";
  })
  (fetchNuGet {
    pname = "runtime.any.system.io";
    version = "4.3.0";
    sha256 = "0l8xz8zn46w4d10bcn3l4yyn4vhb3lrj2zw8llvz7jk14k4zps5x";
  })
  (fetchNuGet {
    pname = "runtime.any.system.reflection";
    version = "4.3.0";
    sha256 = "02c9h3y35pylc0zfq3wcsvc5nqci95nrkq0mszifc0sjx7xrzkly";
  })
  (fetchNuGet {
    pname = "runtime.any.system.reflection.extensions";
    version = "4.3.0";
    sha256 = "0zyri97dfc5vyaz9ba65hjj1zbcrzaffhsdlpxc9bh09wy22fq33";
  })
  (fetchNuGet {
    pname = "runtime.any.system.reflection.primitives";
    version = "4.3.0";
    sha256 = "0x1mm8c6iy8rlxm8w9vqw7gb7s1ljadrn049fmf70cyh42vdfhrf";
  })
  (fetchNuGet {
    pname = "runtime.any.system.resources.resourcemanager";
    version = "4.3.0";
    sha256 = "03kickal0iiby82wa5flar18kyv82s9s6d4xhk5h4bi5kfcyfjzl";
  })
  (fetchNuGet {
    pname = "runtime.any.system.runtime";
    version = "4.3.0";
    sha256 = "1cqh1sv3h5j7ixyb7axxbdkqx6cxy00p4np4j91kpm492rf4s25b";
  })
  (fetchNuGet {
    pname = "runtime.any.system.runtime.handles";
    version = "4.3.0";
    sha256 = "0bh5bi25nk9w9xi8z23ws45q5yia6k7dg3i4axhfqlnj145l011x";
  })
  (fetchNuGet {
    pname = "runtime.any.system.runtime.interopservices";
    version = "4.3.0";
    sha256 = "0c3g3g3jmhlhw4klrc86ka9fjbl7i59ds1fadsb2l8nqf8z3kb19";
  })
  (fetchNuGet {
    pname = "runtime.any.system.text.encoding";
    version = "4.3.0";
    sha256 = "0aqqi1v4wx51h51mk956y783wzags13wa7mgqyclacmsmpv02ps3";
  })
  (fetchNuGet {
    pname = "runtime.any.system.text.encoding.extensions";
    version = "4.3.0";
    sha256 = "0lqhgqi0i8194ryqq6v2gqx0fb86db2gqknbm0aq31wb378j7ip8";
  })
  (fetchNuGet {
    pname = "runtime.any.system.threading.tasks";
    version = "4.3.0";
    sha256 = "03mnvkhskbzxddz4hm113zsch1jyzh2cs450dk3rgfjp8crlw1va";
  })
  (fetchNuGet {
    pname = "runtime.debian.8-x64.runtime.native.system.security.cryptography.openssl";
    version = "4.3.0";
    sha256 = "16rnxzpk5dpbbl1x354yrlsbvwylrq456xzpsha1n9y3glnhyx9d";
  })
  (fetchNuGet {
    pname = "runtime.debian.8-x64.runtime.native.system.security.cryptography.openssl";
    version = "4.3.2";
    sha256 = "0rwpqngkqiapqc5c2cpkj7idhngrgss5qpnqg0yh40mbyflcxf8i";
  })
  (fetchNuGet {
    pname = "runtime.fedora.23-x64.runtime.native.system.security.cryptography.openssl";
    version = "4.3.0";
    sha256 = "0hkg03sgm2wyq8nqk6dbm9jh5vcq57ry42lkqdmfklrw89lsmr59";
  })
  (fetchNuGet {
    pname = "runtime.fedora.23-x64.runtime.native.system.security.cryptography.openssl";
    version = "4.3.2";
    sha256 = "1n06gxwlinhs0w7s8a94r1q3lwqzvynxwd3mp10ws9bg6gck8n4r";
  })
  (fetchNuGet {
    pname = "runtime.fedora.24-x64.runtime.native.system.security.cryptography.openssl";
    version = "4.3.0";
    sha256 = "0c2p354hjx58xhhz7wv6div8xpi90sc6ibdm40qin21bvi7ymcaa";
  })
  (fetchNuGet {
    pname = "runtime.fedora.24-x64.runtime.native.system.security.cryptography.openssl";
    version = "4.3.2";
    sha256 = "0404wqrc7f2yc0wxv71y3nnybvqx8v4j9d47hlscxy759a525mc3";
  })
  (fetchNuGet {
    pname = "runtime.native.system";
    version = "4.3.0";
    sha256 = "15hgf6zaq9b8br2wi1i3x0zvmk410nlmsmva9p0bbg73v6hml5k4";
  })
  (fetchNuGet {
    pname = "runtime.native.system.net.http";
    version = "4.3.0";
    sha256 = "1n6rgz5132lcibbch1qlf0g9jk60r0kqv087hxc0lisy50zpm7kk";
  })
  (fetchNuGet {
    pname = "runtime.native.system.net.security";
    version = "4.3.0";
    sha256 = "0dnqjhw445ay3chpia9p6vy4w2j6s9vy3hxszqvdanpvvyaxijr3";
  })
  (fetchNuGet {
    pname = "runtime.native.system.security.cryptography.apple";
    version = "4.3.0";
    sha256 = "1b61p6gw1m02cc1ry996fl49liiwky6181dzr873g9ds92zl326q";
  })
  (fetchNuGet {
    pname = "runtime.native.system.security.cryptography.openssl";
    version = "4.3.0";
    sha256 = "18pzfdlwsg2nb1jjjjzyb5qlgy6xjxzmhnfaijq5s2jw3cm3ab97";
  })
  (fetchNuGet {
    pname = "runtime.native.system.security.cryptography.openssl";
    version = "4.3.2";
    sha256 = "0zy5r25jppz48i2bkg8b9lfig24xixg6nm3xyr1379zdnqnpm8f6";
  })
  (fetchNuGet {
    pname = "runtime.opensuse.13.2-x64.runtime.native.system.security.cryptography.openssl";
    version = "4.3.0";
    sha256 = "0qyynf9nz5i7pc26cwhgi8j62ps27sqmf78ijcfgzab50z9g8ay3";
  })
  (fetchNuGet {
    pname = "runtime.opensuse.13.2-x64.runtime.native.system.security.cryptography.openssl";
    version = "4.3.2";
    sha256 = "096ch4n4s8k82xga80lfmpimpzahd2ip1mgwdqgar0ywbbl6x438";
  })
  (fetchNuGet {
    pname = "runtime.opensuse.42.1-x64.runtime.native.system.security.cryptography.openssl";
    version = "4.3.0";
    sha256 = "1klrs545awhayryma6l7g2pvnp9xy4z0r1i40r80zb45q3i9nbyf";
  })
  (fetchNuGet {
    pname = "runtime.opensuse.42.1-x64.runtime.native.system.security.cryptography.openssl";
    version = "4.3.2";
    sha256 = "1dm8fifl7rf1gy7lnwln78ch4rw54g0pl5g1c189vawavll7p6rj";
  })
  (fetchNuGet {
    pname = "runtime.osx.10.10-x64.runtime.native.system.security.cryptography.apple";
    version = "4.3.0";
    sha256 = "10yc8jdrwgcl44b4g93f1ds76b176bajd3zqi2faf5rvh1vy9smi";
  })
  (fetchNuGet {
    pname = "runtime.osx.10.10-x64.runtime.native.system.security.cryptography.openssl";
    version = "4.3.0";
    sha256 = "0zcxjv5pckplvkg0r6mw3asggm7aqzbdjimhvsasb0cgm59x09l3";
  })
  (fetchNuGet {
    pname = "runtime.osx.10.10-x64.runtime.native.system.security.cryptography.openssl";
    version = "4.3.2";
    sha256 = "1m9z1k9kzva9n9kwinqxl97x2vgl79qhqjlv17k9s2ymcyv2bwr6";
  })
  (fetchNuGet {
    pname = "runtime.rhel.7-x64.runtime.native.system.security.cryptography.openssl";
    version = "4.3.0";
    sha256 = "0vhynn79ih7hw7cwjazn87rm9z9fj0rvxgzlab36jybgcpcgphsn";
  })
  (fetchNuGet {
    pname = "runtime.rhel.7-x64.runtime.native.system.security.cryptography.openssl";
    version = "4.3.2";
    sha256 = "1cpx56mcfxz7cpn57wvj18sjisvzq8b5vd9rw16ihd2i6mcp3wa1";
  })
  (fetchNuGet {
    pname = "runtime.ubuntu.14.04-x64.runtime.native.system.security.cryptography.openssl";
    version = "4.3.0";
    sha256 = "160p68l2c7cqmyqjwxydcvgw7lvl1cr0znkw8fp24d1by9mqc8p3";
  })
  (fetchNuGet {
    pname = "runtime.ubuntu.14.04-x64.runtime.native.system.security.cryptography.openssl";
    version = "4.3.2";
    sha256 = "15gsm1a8jdmgmf8j5v1slfz8ks124nfdhk2vxs2rw3asrxalg8hi";
  })
  (fetchNuGet {
    pname = "runtime.ubuntu.16.04-x64.runtime.native.system.security.cryptography.openssl";
    version = "4.3.0";
    sha256 = "15zrc8fgd8zx28hdghcj5f5i34wf3l6bq5177075m2bc2j34jrqy";
  })
  (fetchNuGet {
    pname = "runtime.ubuntu.16.04-x64.runtime.native.system.security.cryptography.openssl";
    version = "4.3.2";
    sha256 = "0q0n5q1r1wnqmr5i5idsrd9ywl33k0js4pngkwq9p368mbxp8x1w";
  })
  (fetchNuGet {
    pname = "runtime.ubuntu.16.10-x64.runtime.native.system.security.cryptography.openssl";
    version = "4.3.0";
    sha256 = "1p4dgxax6p7rlgj4q73k73rslcnz4wdcv8q2flg1s8ygwcm58ld5";
  })
  (fetchNuGet {
    pname = "runtime.ubuntu.16.10-x64.runtime.native.system.security.cryptography.openssl";
    version = "4.3.2";
    sha256 = "1x0g58pbpjrmj2x2qw17rdwwnrcl0wvim2hdwz48lixvwvp22n9c";
  })
  (fetchNuGet {
    pname = "runtime.unix.microsoft.win32.primitives";
    version = "4.3.0";
    sha256 = "0y61k9zbxhdi0glg154v30kkq7f8646nif8lnnxbvkjpakggd5id";
  })
  (fetchNuGet {
    pname = "runtime.unix.system.diagnostics.debug";
    version = "4.3.0";
    sha256 = "1lps7fbnw34bnh3lm31gs5c0g0dh7548wfmb8zz62v0zqz71msj5";
  })
  (fetchNuGet {
    pname = "runtime.unix.system.io.filesystem";
    version = "4.3.0";
    sha256 = "14nbkhvs7sji5r1saj2x8daz82rnf9kx28d3v2qss34qbr32dzix";
  })
  (fetchNuGet {
    pname = "runtime.unix.system.net.primitives";
    version = "4.3.0";
    sha256 = "0bdnglg59pzx9394sy4ic66kmxhqp8q8bvmykdxcbs5mm0ipwwm4";
  })
  (fetchNuGet {
    pname = "runtime.unix.system.private.uri";
    version = "4.3.0";
    sha256 = "1jx02q6kiwlvfksq1q9qr17fj78y5v6mwsszav4qcz9z25d5g6vk";
  })
  (fetchNuGet {
    pname = "runtime.unix.system.runtime.extensions";
    version = "4.3.0";
    sha256 = "0pnxxmm8whx38dp6yvwgmh22smknxmqs5n513fc7m4wxvs1bvi4p";
  })
  (fetchNuGet {
    pname = "system.buffers";
    version = "4.3.0";
    sha256 = "0fgns20ispwrfqll4q1zc1waqcmylb3zc50ys9x8zlwxh9pmd9jy";
  })
  (fetchNuGet {
    pname = "system.collections";
    version = "4.3.0";
    sha256 = "19r4y64dqyrq6k4706dnyhhw7fs24kpp3awak7whzss39dakpxk9";
  })
  (fetchNuGet {
    pname = "system.collections.concurrent";
    version = "4.3.0";
    sha256 = "0wi10md9aq33jrkh2c24wr2n9hrpyamsdhsxdcnf43b7y86kkii8";
  })
  (fetchNuGet {
    pname = "system.diagnostics.debug";
    version = "4.3.0";
    sha256 = "00yjlf19wjydyr6cfviaph3vsjzg3d5nvnya26i2fvfg53sknh3y";
  })
  (fetchNuGet {
    pname = "system.diagnostics.diagnosticsource";
    version = "4.3.0";
    sha256 = "0z6m3pbiy0qw6rn3n209rrzf9x1k4002zh90vwcrsym09ipm2liq";
  })
  (fetchNuGet {
    pname = "system.diagnostics.tracing";
    version = "4.3.0";
    sha256 = "1m3bx6c2s958qligl67q7grkwfz3w53hpy7nc97mh6f7j5k168c4";
  })
  (fetchNuGet {
    pname = "system.globalization";
    version = "4.3.0";
    sha256 = "1cp68vv683n6ic2zqh2s1fn4c2sd87g5hpp6l4d4nj4536jz98ki";
  })
  (fetchNuGet {
    pname = "system.globalization.calendars";
    version = "4.3.0";
    sha256 = "1xwl230bkakzzkrggy1l1lxmm3xlhk4bq2pkv790j5lm8g887lxq";
  })
  (fetchNuGet {
    pname = "system.globalization.extensions";
    version = "4.3.0";
    sha256 = "02a5zfxavhv3jd437bsncbhd2fp1zv4gxzakp1an9l6kdq1mcqls";
  })
  (fetchNuGet {
    pname = "system.io";
    version = "4.3.0";
    sha256 = "05l9qdrzhm4s5dixmx68kxwif4l99ll5gqmh7rqgw554fx0agv5f";
  })
  (fetchNuGet {
    pname = "system.io.filesystem";
    version = "4.3.0";
    sha256 = "0z2dfrbra9i6y16mm9v1v6k47f0fm617vlb7s5iybjjsz6g1ilmw";
  })
  (fetchNuGet {
    pname = "system.io.filesystem.primitives";
    version = "4.3.0";
    sha256 = "0j6ndgglcf4brg2lz4wzsh1av1gh8xrzdsn9f0yznskhqn1xzj9c";
  })
  (fetchNuGet {
    pname = "system.linq";
    version = "4.3.0";
    sha256 = "1w0gmba695rbr80l1k2h4mrwzbzsyfl2z4klmpbsvsg5pm4a56s7";
  })
  (fetchNuGet {
    pname = "system.net.http";
    version = "4.3.4";
    sha256 = "0kdp31b8819v88l719j6my0yas6myv9d1viql3qz5577mv819jhl";
  })
  (fetchNuGet {
    pname = "system.net.primitives";
    version = "4.3.0";
    sha256 = "0c87k50rmdgmxx7df2khd9qj7q35j9rzdmm2572cc55dygmdk3ii";
  })
  (fetchNuGet {
    pname = "system.net.requests";
    version = "4.3.0";
    sha256 = "0pcznmwqqk0qzp0gf4g4xw7arhb0q8v9cbzh3v8h8qp6rjcr339a";
  })
  (fetchNuGet {
    pname = "system.net.security";
    version = "4.3.2";
    sha256 = "1aw1ca1vssqrillrh4qkarx0lxwc8wcaqdkfdima8376wb98j2q8";
  })
  (fetchNuGet {
    pname = "system.net.webheadercollection";
    version = "4.3.0";
    sha256 = "0ms3ddjv1wn8sqa5qchm245f3vzzif6l6fx5k92klqpn7zf4z562";
  })
  (fetchNuGet {
    pname = "system.private.servicemodel";
    version = "4.5.3";
    sha256 = "0nyw9m9dj327hn0qb0jmgwpch0f40jv301fk4mrchga8g99xbpng";
  })
  (fetchNuGet {
    pname = "system.private.uri";
    version = "4.3.0";
    sha256 = "04r1lkdnsznin0fj4ya1zikxiqr0h6r6a1ww2dsm60gqhdrf0mvx";
  })
  (fetchNuGet {
    pname = "system.reflection";
    version = "4.3.0";
    sha256 = "0xl55k0mw8cd8ra6dxzh974nxif58s3k1rjv1vbd7gjbjr39j11m";
  })
  (fetchNuGet {
    pname = "system.reflection.dispatchproxy";
    version = "4.5.0";
    sha256 = "0v9sg38h91aljvjyc77m1y5v34p50hjdbxvvxwa1whlajhafadcn";
  })
  (fetchNuGet {
    pname = "system.reflection.emit";
    version = "4.3.0";
    sha256 = "11f8y3qfysfcrscjpjym9msk7lsfxkk4fmz9qq95kn3jd0769f74";
  })
  (fetchNuGet {
    pname = "system.reflection.emit.ilgeneration";
    version = "4.3.0";
    sha256 = "0w1n67glpv8241vnpz1kl14sy7zlnw414aqwj4hcx5nd86f6994q";
  })
  (fetchNuGet {
    pname = "system.reflection.emit.lightweight";
    version = "4.3.0";
    sha256 = "0ql7lcakycrvzgi9kxz1b3lljd990az1x6c4jsiwcacrvimpib5c";
  })
  (fetchNuGet {
    pname = "system.reflection.extensions";
    version = "4.3.0";
    sha256 = "02bly8bdc98gs22lqsfx9xicblszr2yan7v2mmw3g7hy6miq5hwq";
  })
  (fetchNuGet {
    pname = "system.reflection.primitives";
    version = "4.3.0";
    sha256 = "04xqa33bld78yv5r93a8n76shvc8wwcdgr1qvvjh959g3rc31276";
  })
  (fetchNuGet {
    pname = "system.reflection.typeextensions";
    version = "4.4.0";
    sha256 = "0n9r1w4lp2zmadyqkgp4sk9wy90sj4ygq4dh7kzamx26i9biys5h";
  })
  (fetchNuGet {
    pname = "system.resources.resourcemanager";
    version = "4.3.0";
    sha256 = "0sjqlzsryb0mg4y4xzf35xi523s4is4hz9q4qgdvlvgivl7qxn49";
  })
  (fetchNuGet {
    pname = "system.runtime";
    version = "4.3.0";
    sha256 = "066ixvgbf2c929kgknshcxqj6539ax7b9m570cp8n179cpfkapz7";
  })
  (fetchNuGet {
    pname = "system.runtime.extensions";
    version = "4.3.0";
    sha256 = "1ykp3dnhwvm48nap8q23893hagf665k0kn3cbgsqpwzbijdcgc60";
  })
  (fetchNuGet {
    pname = "system.runtime.handles";
    version = "4.3.0";
    sha256 = "0sw2gfj2xr7sw9qjn0j3l9yw07x73lcs97p8xfc9w1x9h5g5m7i8";
  })
  (fetchNuGet {
    pname = "system.runtime.interopservices";
    version = "4.3.0";
    sha256 = "00hywrn4g7hva1b2qri2s6rabzwgxnbpw9zfxmz28z09cpwwgh7j";
  })
  (fetchNuGet {
    pname = "system.runtime.numerics";
    version = "4.3.0";
    sha256 = "19rav39sr5dky7afygh309qamqqmi9kcwvz3i0c5700v0c5cg61z";
  })
  (fetchNuGet {
    pname = "system.security.claims";
    version = "4.3.0";
    sha256 = "0jvfn7j22l3mm28qjy3rcw287y9h65ha4m940waaxah07jnbzrhn";
  })
  (fetchNuGet {
    pname = "system.security.cryptography.algorithms";
    version = "4.3.0";
    sha256 = "03sq183pfl5kp7gkvq77myv7kbpdnq3y0xj7vi4q1kaw54sny0ml";
  })
  (fetchNuGet {
    pname = "system.security.cryptography.cng";
    version = "4.3.0";
    sha256 = "1k468aswafdgf56ab6yrn7649kfqx2wm9aslywjam1hdmk5yypmv";
  })
  (fetchNuGet {
    pname = "system.security.cryptography.csp";
    version = "4.3.0";
    sha256 = "1x5wcrddf2s3hb8j78cry7yalca4lb5vfnkrysagbn6r9x6xvrx1";
  })
  (fetchNuGet {
    pname = "system.security.cryptography.encoding";
    version = "4.3.0";
    sha256 = "1jr6w70igqn07k5zs1ph6xja97hxnb3mqbspdrff6cvssgrixs32";
  })
  (fetchNuGet {
    pname = "system.security.cryptography.openssl";
    version = "4.3.0";
    sha256 = "0givpvvj8yc7gv4lhb6s1prq6p2c4147204a0wib89inqzd87gqc";
  })
  (fetchNuGet {
    pname = "system.security.cryptography.primitives";
    version = "4.3.0";
    sha256 = "0pyzncsv48zwly3lw4f2dayqswcfvdwq2nz0dgwmi7fj3pn64wby";
  })
  (fetchNuGet {
    pname = "system.security.cryptography.x509certificates";
    version = "4.3.0";
    sha256 = "0valjcz5wksbvijylxijjxb1mp38mdhv03r533vnx1q3ikzdav9h";
  })
  (fetchNuGet {
    pname = "system.security.principal";
    version = "4.3.0";
    sha256 = "12cm2zws06z4lfc4dn31iqv7072zyi4m910d4r6wm8yx85arsfxf";
  })
  (fetchNuGet {
    pname = "system.security.principal.windows";
    version = "4.5.0";
    sha256 = "0rmj89wsl5yzwh0kqjgx45vzf694v9p92r4x4q6yxldk1cv1hi86";
  })
  (fetchNuGet {
    pname = "system.servicemodel.primitives";
    version = "4.5.3";
    sha256 = "1v90pci049cn44y0km885k1vrilhb34w6q2zva4y6f3ay84klrih";
  })
  (fetchNuGet {
    pname = "system.text.encoding";
    version = "4.3.0";
    sha256 = "1f04lkir4iladpp51sdgmis9dj4y8v08cka0mbmsy0frc9a4gjqr";
  })
  (fetchNuGet {
    pname = "system.text.encoding.extensions";
    version = "4.3.0";
    sha256 = "11q1y8hh5hrp5a3kw25cb6l00v5l5dvirkz8jr3sq00h1xgcgrxy";
  })
  (fetchNuGet {
    pname = "system.text.regularexpressions";
    version = "4.3.0";
    sha256 = "1bgq51k7fwld0njylfn7qc5fmwrk2137gdq7djqdsw347paa9c2l";
  })
  (fetchNuGet {
    pname = "system.threading";
    version = "4.3.0";
    sha256 = "0rw9wfamvhayp5zh3j7p1yfmx9b5khbf4q50d8k5rk993rskfd34";
  })
  (fetchNuGet {
    pname = "system.threading.tasks";
    version = "4.3.0";
    sha256 = "134z3v9abw3a6jsw17xl3f6hqjpak5l682k2vz39spj4kmydg6k7";
  })
  (fetchNuGet {
    pname = "system.threading.tasks.extensions";
    version = "4.3.0";
    sha256 = "1xxcx2xh8jin360yjwm4x4cf5y3a2bwpn2ygkfkwkicz7zk50s2z";
  })
  (fetchNuGet {
    pname = "system.threading.threadpool";
    version = "4.3.0";
    sha256 = "027s1f4sbx0y1xqw2irqn6x161lzj8qwvnh2gn78ciiczdv10vf1";
  })
  (fetchNuGet {
    pname = "system.xml.readerwriter";
    version = "4.3.0";
    sha256 = "0c47yllxifzmh8gq6rq6l36zzvw4kjvlszkqa9wq3fr59n0hl3s1";
  })
  (fetchNuGet {
    pname = "system.xml.xmldocument";
    version = "4.3.0";
    sha256 = "0bmz1l06dihx52jxjr22dyv5mxv6pj4852lx68grjm7bivhrbfwi";
  })
  (fetchNuGet {
    pname = "system.xml.xmlserializer";
    version = "4.3.0";
    sha256 = "07pa4sx196vxkgl3csvdmw94nydlsm9ir38xxcs84qjn8cycd912";
  })
  (fetchNuGet {
    pname = "yamldotnet";
    version = "5.2.1";
    sha256 = "0nb34qcdhs5qn4783idg28f2kr89vaiyjn4v2barhv7i75zhym6y";
  })
]
