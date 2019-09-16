{ fetchurl }: let

  fetchNuGet = { url, name, version, sha256 }: fetchurl {
    inherit name url sha256;
  };

in [
(fetchNuGet {
        name = "microsoft.build";
        version = "14.3.0";
        url = "https://www.nuget.org/api/v2/package/microsoft.build/14.3.0";
        sha256 = "1zamn3p8xxi0wsjlpln0y71ncb977f3fp08mvaz4wmbmi76nr0rz";
        })
(fetchNuGet {
        name = "system.io";
        version = "4.1.0";
        url = "https://www.nuget.org/api/v2/package/system.io/4.1.0";
        sha256 = "1g0yb8p11vfd0kbkyzlfsbsp5z44lwsvyc0h3dpw6vqnbi035ajp";
        })
(fetchNuGet {
        name = "system.io";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.io/4.3.0";
        sha256 = "05l9qdrzhm4s5dixmx68kxwif4l99ll5gqmh7rqgw554fx0agv5f";
        })
(fetchNuGet {
        name = "system.xml.xpath";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.xml.xpath/4.3.0";
        sha256 = "1cv2m0p70774a0sd1zxc8fm8jk3i5zk2bla3riqvi8gsm0r4kpci";
        })
(fetchNuGet {
        name = "microsoft.net.compilers.toolset";
        version = "3.3.0-beta2-19367-02";
        url = "https://dotnetfeed.blob.core.windows.net/dotnet-core/flatcontainer/microsoft.net.compilers.toolset/3.3.0-beta2-19367-02/microsoft.net.compilers.toolset.3.3.0-beta2-19367-02.nupkg";
        sha256 = "1v9lz2fmfprhql0klqa8iipiiz3wcflvlgr3a86pcjjk7x0y84sl";
        })
(fetchNuGet {
        name = "system.io.filesystem";
        version = "4.0.1";
        url = "https://www.nuget.org/api/v2/package/system.io.filesystem/4.0.1";
        sha256 = "0kgfpw6w4djqra3w5crrg8xivbanh1w9dh3qapb28q060wb9flp1";
        })
(fetchNuGet {
        name = "system.io.filesystem";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.io.filesystem/4.3.0";
        sha256 = "0z2dfrbra9i6y16mm9v1v6k47f0fm617vlb7s5iybjjsz6g1ilmw";
        })
(fetchNuGet {
        name = "largeaddressaware";
        version = "1.0.3";
        url = "https://www.nuget.org/api/v2/package/largeaddressaware/1.0.3";
        sha256 = "1ppss9bgj0hf5s8307bnm2a4qm10mrymp0v12m28a5q81zjz0fr5";
        })
(fetchNuGet {
        name = "nuget.protocol";
        version = "5.2.0-rtm.6067";
        url = "https://dotnet.myget.org/F/nuget-build/api/v2/package/nuget.protocol/5.2.0-rtm.6067";
        sha256 = "0fm3qgcdsy6dy6fih0n9a4w39mzdha4cz51gr9pp9g4nag34za2a";
        })
(fetchNuGet {
        name = "runtime.native.system.security.cryptography.openssl";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/runtime.native.system.security.cryptography.openssl/4.3.0";
        sha256 = "18pzfdlwsg2nb1jjjjzyb5qlgy6xjxzmhnfaijq5s2jw3cm3ab97";
        })
(fetchNuGet {
        name = "runtime.ubuntu.14.04-x64.runtime.native.system.security.cryptography.openssl";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/runtime.ubuntu.14.04-x64.runtime.native.system.security.cryptography.openssl/4.3.0";
        sha256 = "160p68l2c7cqmyqjwxydcvgw7lvl1cr0znkw8fp24d1by9mqc8p3";
        })
(fetchNuGet {
        name = "system.buffers";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.buffers/4.3.0";
        sha256 = "0fgns20ispwrfqll4q1zc1waqcmylb3zc50ys9x8zlwxh9pmd9jy";
        })
(fetchNuGet {
        name = "system.buffers";
        version = "4.4.0";
        url = "https://www.nuget.org/api/v2/package/system.buffers/4.4.0";
        sha256 = "183f8063w8zqn99pv0ni0nnwh7fgx46qzxamwnans55hhs2l0g19";
        })
(fetchNuGet {
        name = "xunit.core";
        version = "2.4.1";
        url = "https://www.nuget.org/api/v2/package/xunit.core/2.4.1";
        sha256 = "1nnb3j4kzmycaw1g76ii4rfqkvg6l8gqh18falwp8g28h802019a";
        })
(fetchNuGet {
        name = "system.io.filesystem.primitives";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.io.filesystem.primitives/4.3.0";
        sha256 = "0j6ndgglcf4brg2lz4wzsh1av1gh8xrzdsn9f0yznskhqn1xzj9c";
        })
(fetchNuGet {
        name = "system.io.filesystem.primitives";
        version = "4.0.1";
        url = "https://www.nuget.org/api/v2/package/system.io.filesystem.primitives/4.0.1";
        sha256 = "1s0mniajj3lvbyf7vfb5shp4ink5yibsx945k6lvxa96r8la1612";
        })
(fetchNuGet {
        name = "system.xml.xmldocument";
        version = "4.0.1";
        url = "https://www.nuget.org/api/v2/package/system.xml.xmldocument/4.0.1";
        sha256 = "0ihsnkvyc76r4dcky7v3ansnbyqjzkbyyia0ir5zvqirzan0bnl1";
        })
(fetchNuGet {
        name = "system.xml.xmldocument";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.xml.xmldocument/4.3.0";
        sha256 = "0bmz1l06dihx52jxjr22dyv5mxv6pj4852lx68grjm7bivhrbfwi";
        })
(fetchNuGet {
        name = "microsoft.build.framework";
        version = "15.5.180";
        url = "https://www.nuget.org/api/v2/package/microsoft.build.framework/15.5.180";
        sha256 = "064y3a711ikx9pm9d2wyms4i3k4f9hfvn3vymhwygg7yv7gcj92z";
        })
(fetchNuGet {
        name = "microsoft.build.framework";
        version = "14.3.0";
        url = "https://www.nuget.org/api/v2/package/microsoft.build.framework/14.3.0";
        sha256 = "0r7y1i7dbr3pb53fdrh268hyi627w85nzv2iblwyg8dzkfxraafd";
        })
(fetchNuGet {
        name = "system.globalization";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.globalization/4.3.0";
        sha256 = "1cp68vv683n6ic2zqh2s1fn4c2sd87g5hpp6l4d4nj4536jz98ki";
        })
(fetchNuGet {
        name = "system.globalization";
        version = "4.0.11";
        url = "https://www.nuget.org/api/v2/package/system.globalization/4.0.11";
        sha256 = "070c5jbas2v7smm660zaf1gh0489xanjqymkvafcs4f8cdrs1d5d";
        })
(fetchNuGet {
        name = "microsoft.dotnet.signtool";
        version = "1.0.0-beta.19372.10";
        url = "https://dotnetfeed.blob.core.windows.net/dotnet-core/flatcontainer/microsoft.dotnet.signtool/1.0.0-beta.19372.10/microsoft.dotnet.signtool.1.0.0-beta.19372.10.nupkg";
        sha256 = "1f2im2lilw10zslfclxh49knr542jy7q09p009flxsgn68riy0j6";
        })
(fetchNuGet {
        name = "system.runtime.handles";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.runtime.handles/4.3.0";
        sha256 = "0sw2gfj2xr7sw9qjn0j3l9yw07x73lcs97p8xfc9w1x9h5g5m7i8";
        })
(fetchNuGet {
        name = "system.runtime.handles";
        version = "4.0.1";
        url = "https://www.nuget.org/api/v2/package/system.runtime.handles/4.0.1";
        sha256 = "1g0zrdi5508v49pfm3iii2hn6nm00bgvfpjq1zxknfjrxxa20r4g";
        })
(fetchNuGet {
        name = "microsoft.codeanalysis.common";
        version = "3.0.0-beta1-61516-01";
        url = "https://dotnet.myget.org/F/roslyn/api/v2/package/microsoft.codeanalysis.common/3.0.0-beta1-61516-01";
        sha256 = "1qfm61yrsmihhir7n3hb5ccn1r50i39rv1g74880ma7ihjl1hz54";
        })
(fetchNuGet {
        name = "microsoft.netcore.platforms";
        version = "1.0.1";
        url = "https://www.nuget.org/api/v2/package/microsoft.netcore.platforms/1.0.1";
        sha256 = "01al6cfxp68dscl15z7rxfw9zvhm64dncsw09a1vmdkacsa2v6lr";
        })
(fetchNuGet {
        name = "microsoft.netcore.platforms";
        version = "1.1.0";
        url = "https://www.nuget.org/api/v2/package/microsoft.netcore.platforms/1.1.0";
        sha256 = "08vh1r12g6ykjygq5d3vq09zylgb84l63k49jc4v8faw9g93iqqm";
        })
(fetchNuGet {
        name = "system.reflection.primitives";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.reflection.primitives/4.3.0";
        sha256 = "04xqa33bld78yv5r93a8n76shvc8wwcdgr1qvvjh959g3rc31276";
        })
(fetchNuGet {
        name = "system.reflection.primitives";
        version = "4.0.1";
        url = "https://www.nuget.org/api/v2/package/system.reflection.primitives/4.0.1";
        sha256 = "1bangaabhsl4k9fg8khn83wm6yial8ik1sza7401621jc6jrym28";
        })
(fetchNuGet {
        name = "microbuild.core";
        version = "0.2.0";
        url = "https://www.nuget.org/api/v2/package/microbuild.core/0.2.0";
        sha256 = "0q4s45jskbyxfx4ay6znnvv94zma2wd85b8rwmwszd2nb0xl3194";
        })
(fetchNuGet {
        name = "system.diagnostics.tracesource";
        version = "4.0.0";
        url = "https://www.nuget.org/api/v2/package/system.diagnostics.tracesource/4.0.0";
        sha256 = "1mc7r72xznczzf6mz62dm8xhdi14if1h8qgx353xvhz89qyxsa3h";
        })
(fetchNuGet {
        name = "system.runtime.numerics";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.runtime.numerics/4.3.0";
        sha256 = "19rav39sr5dky7afygh309qamqqmi9kcwvz3i0c5700v0c5cg61z";
        })
(fetchNuGet {
        name = "system.threading.tasks.parallel";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.threading.tasks.parallel/4.3.0";
        sha256 = "1rr3qa4hxwyj531s4nb3bwrxnxxwz617i0n9gh6x7nr7dd3ayzgh";
        })
(fetchNuGet {
        name = "system.threading.tasks.parallel";
        version = "4.0.1";
        url = "https://www.nuget.org/api/v2/package/system.threading.tasks.parallel/4.0.1";
        sha256 = "114wdg32hr46dfsnns3pgs67kcha5jn47p5gg0mhxfn5vrkr2p75";
        })
(fetchNuGet {
        name = "nuget.credentials";
        version = "5.2.0-rtm.6067";
        url = "https://dotnet.myget.org/F/nuget-build/api/v2/package/nuget.credentials/5.2.0-rtm.6067";
        sha256 = "07g2na590sph9li5igww74i3gqyrj5cb6gsgjh54f1f4bs4x1c4k";
        })
(fetchNuGet {
        name = "system.objectmodel";
        version = "4.0.12";
        url = "https://www.nuget.org/api/v2/package/system.objectmodel/4.0.12";
        sha256 = "1sybkfi60a4588xn34nd9a58png36i0xr4y4v4kqpg8wlvy5krrj";
        })
(fetchNuGet {
        name = "system.objectmodel";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.objectmodel/4.3.0";
        sha256 = "191p63zy5rpqx7dnrb3h7prvgixmk168fhvvkkvhlazncf8r3nc2";
        })
(fetchNuGet {
        name = "system.xml.xmlserializer";
        version = "4.0.11";
        url = "https://www.nuget.org/api/v2/package/system.xml.xmlserializer/4.0.11";
        sha256 = "01nzc3gdslw90qfykq4qzr2mdnqxjl4sj0wp3fixiwdmlmvpib5z";
        })
(fetchNuGet {
        name = "microsoft.codeanalysis.build.tasks";
        version = "3.0.0-beta1-61516-01";
        url = "https://dotnet.myget.org/F/roslyn/api/v2/package/microsoft.codeanalysis.build.tasks/3.0.0-beta1-61516-01";
        sha256 = "1cjpqbd4i0gxhh86nvamlpkisd1krcrya6riwjhghvpjph6115vp";
        })
(fetchNuGet {
        name = "system.private.datacontractserialization";
        version = "4.1.1";
        url = "https://www.nuget.org/api/v2/package/system.private.datacontractserialization/4.1.1";
        sha256 = "1xk9wvgzipssp1393nsg4n16zbr5481k03nkdlj954hzq5jkx89r";
        })
(fetchNuGet {
        name = "system.numerics.vectors";
        version = "4.4.0";
        url = "https://www.nuget.org/api/v2/package/system.numerics.vectors/4.4.0";
        sha256 = "0rdvma399070b0i46c4qq1h2yvjj3k013sqzkilz4bz5cwmx1rba";
        })
(fetchNuGet {
        name = "microsoft.build.centralpackageversions";
        version = "2.0.1";
        url = "https://www.nuget.org/api/v2/package/microsoft.build.centralpackageversions/2.0.1";
        sha256 = "17cjiaj2b98q8s89168g42jb8rhwm6062jcbv57rbkdiiwdsn55k";
        })
(fetchNuGet {
        name = "system.text.encoding.extensions";
        version = "4.0.11";
        url = "https://www.nuget.org/api/v2/package/system.text.encoding.extensions/4.0.11";
        sha256 = "08nsfrpiwsg9x5ml4xyl3zyvjfdi4mvbqf93kjdh11j4fwkznizs";
        })
(fetchNuGet {
        name = "system.text.encoding.extensions";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.text.encoding.extensions/4.3.0";
        sha256 = "11q1y8hh5hrp5a3kw25cb6l00v5l5dvirkz8jr3sq00h1xgcgrxy";
        })
(fetchNuGet {
        name = "microsoft.visualstudio.sdk.embedinteroptypes";
        version = "15.0.15";
        url = "https://www.nuget.org/api/v2/package/microsoft.visualstudio.sdk.embedinteroptypes/15.0.15";
        sha256 = "0chr3slzzcanwcyd9isx4gichqzmfh4zd3h83piw0r4xsww1wmpd";
        })
(fetchNuGet {
        name = "runtime.ubuntu.16.04-x64.runtime.native.system.security.cryptography.openssl";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/runtime.ubuntu.16.04-x64.runtime.native.system.security.cryptography.openssl/4.3.0";
        sha256 = "15zrc8fgd8zx28hdghcj5f5i34wf3l6bq5177075m2bc2j34jrqy";
        })
(fetchNuGet {
        name = "system.runtime.extensions";
        version = "4.1.0";
        url = "https://www.nuget.org/api/v2/package/system.runtime.extensions/4.1.0";
        sha256 = "0rw4rm4vsm3h3szxp9iijc3ksyviwsv6f63dng3vhqyg4vjdkc2z";
        })
(fetchNuGet {
        name = "system.runtime.extensions";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.runtime.extensions/4.3.0";
        sha256 = "1ykp3dnhwvm48nap8q23893hagf665k0kn3cbgsqpwzbijdcgc60";
        })
(fetchNuGet {
        name = "system.resources.extensions";
        version = "4.6.0-preview8.19364.1";
        url = "https://dotnetfeed.blob.core.windows.net/dotnet-core/flatcontainer/system.resources.extensions/4.6.0-preview8.19364.1/system.resources.extensions.4.6.0-preview8.19364.1.nupkg";
        sha256 = "0jh9ilbicmsngv77a4ayzs0n7s440ycdf726nbljw029gq4rzvqf";
        })
(fetchNuGet {
        name = "nuget.frameworks";
        version = "5.2.0-rtm.6067";
        url = "https://dotnet.myget.org/F/nuget-build/api/v2/package/nuget.frameworks/5.2.0-rtm.6067";
        sha256 = "1g1kcfqhxr1bhl3ksbdmz3rb9nq1qmkac1sijf9ng4gmr9fmprdm";
        })
(fetchNuGet {
        name = "system.diagnostics.diagnosticsource";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.diagnostics.diagnosticsource/4.3.0";
        sha256 = "0z6m3pbiy0qw6rn3n209rrzf9x1k4002zh90vwcrsym09ipm2liq";
        })
(fetchNuGet {
        name = "system.security.claims";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.security.claims/4.3.0";
        sha256 = "0jvfn7j22l3mm28qjy3rcw287y9h65ha4m940waaxah07jnbzrhn";
        })
(fetchNuGet {
        name = "system.linq.expressions";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.linq.expressions/4.3.0";
        sha256 = "0ky2nrcvh70rqq88m9a5yqabsl4fyd17bpr63iy2mbivjs2nyypv";
        })
(fetchNuGet {
        name = "system.diagnostics.stacktrace";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.diagnostics.stacktrace/4.3.0";
        sha256 = "0ash4h9k0m7xsm0yl79r0ixrdz369h7y922wipp5gladmlbvpyjd";
        })
(fetchNuGet {
        name = "runtime.osx.10.10-x64.runtime.native.system.security.cryptography.openssl";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/runtime.osx.10.10-x64.runtime.native.system.security.cryptography.openssl/4.3.0";
        sha256 = "0zcxjv5pckplvkg0r6mw3asggm7aqzbdjimhvsasb0cgm59x09l3";
        })
(fetchNuGet {
        name = "system.diagnostics.tracing";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.diagnostics.tracing/4.3.0";
        sha256 = "1m3bx6c2s958qligl67q7grkwfz3w53hpy7nc97mh6f7j5k168c4";
        })
(fetchNuGet {
        name = "system.diagnostics.tracing";
        version = "4.1.0";
        url = "https://www.nuget.org/api/v2/package/system.diagnostics.tracing/4.1.0";
        sha256 = "1d2r76v1x610x61ahfpigda89gd13qydz6vbwzhpqlyvq8jj6394";
        })
(fetchNuGet {
        name = "xunit.analyzers";
        version = "0.10.0";
        url = "https://www.nuget.org/api/v2/package/xunit.analyzers/0.10.0";
        sha256 = "15n02q3akyqbvkp8nq75a8rd66d4ax0rx8fhdcn8j78pi235jm7j";
        })
(fetchNuGet {
        name = "xunit.assert";
        version = "2.4.1";
        url = "https://www.nuget.org/api/v2/package/xunit.assert/2.4.1";
        sha256 = "1imynzh80wxq2rp9sc4gxs4x1nriil88f72ilhj5q0m44qqmqpc6";
        })
(fetchNuGet {
        name = "system.appcontext";
        version = "4.1.0";
        url = "https://www.nuget.org/api/v2/package/system.appcontext/4.1.0";
        sha256 = "0fv3cma1jp4vgj7a8hqc9n7hr1f1kjp541s6z0q1r6nazb4iz9mz";
        })
(fetchNuGet {
        name = "system.appcontext";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.appcontext/4.3.0";
        sha256 = "1649qvy3dar900z3g817h17nl8jp4ka5vcfmsr05kh0fshn7j3ya";
        })
(fetchNuGet {
        name = "system.text.encoding.codepages";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.text.encoding.codepages/4.3.0";
        sha256 = "0lgxg1gn7pg7j0f942pfdc9q7wamzxsgq3ng248ikdasxz0iadkv";
        })
(fetchNuGet {
        name = "system.text.encoding.codepages";
        version = "4.0.1";
        url = "https://www.nuget.org/api/v2/package/system.text.encoding.codepages/4.0.1";
        sha256 = "00wpm3b9y0k996rm9whxprngm8l500ajmzgy2ip9pgwk0icp06y3";
        })
(fetchNuGet {
        name = "runtime.fedora.24-x64.runtime.native.system.security.cryptography.openssl";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/runtime.fedora.24-x64.runtime.native.system.security.cryptography.openssl/4.3.0";
        sha256 = "0c2p354hjx58xhhz7wv6div8xpi90sc6ibdm40qin21bvi7ymcaa";
        })
(fetchNuGet {
        name = "microsoft.codeanalysis.csharp";
        version = "3.0.0-beta1-61516-01";
        url = "https://dotnet.myget.org/F/roslyn/api/v2/package/microsoft.codeanalysis.csharp/3.0.0-beta1-61516-01";
        sha256 = "0a7npkdw6s5jczw1lkm63x2bpz1z3ccid20h5nm6k78cv7sihm4h";
        })
(fetchNuGet {
        name = "system.console";
        version = "4.0.0";
        url = "https://www.nuget.org/api/v2/package/system.console/4.0.0";
        sha256 = "0ynxqbc3z1nwbrc11hkkpw9skw116z4y9wjzn7id49p9yi7mzmlf";
        })
(fetchNuGet {
        name = "system.console";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.console/4.3.0";
        sha256 = "1flr7a9x920mr5cjsqmsy9wgnv3lvd0h1g521pdr1lkb2qycy7ay";
        })
(fetchNuGet {
        name = "system.reflection.typeextensions";
        version = "4.1.0";
        url = "https://www.nuget.org/api/v2/package/system.reflection.typeextensions/4.1.0";
        sha256 = "1bjli8a7sc7jlxqgcagl9nh8axzfl11f4ld3rjqsyxc516iijij7";
        })
(fetchNuGet {
        name = "system.runtime.compilerservices.unsafe";
        version = "4.5.2";
        url = "https://www.nuget.org/api/v2/package/system.runtime.compilerservices.unsafe/4.5.2";
        sha256 = "1vz4275fjij8inf31np78hw50al8nqkngk04p3xv5n4fcmf1grgi";
        })
(fetchNuGet {
        name = "system.threading.tasks";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.threading.tasks/4.3.0";
        sha256 = "134z3v9abw3a6jsw17xl3f6hqjpak5l682k2vz39spj4kmydg6k7";
        })
(fetchNuGet {
        name = "system.threading.tasks";
        version = "4.0.11";
        url = "https://www.nuget.org/api/v2/package/system.threading.tasks/4.0.11";
        sha256 = "0nr1r41rak82qfa5m0lhk9mp0k93bvfd7bbd9sdzwx9mb36g28p5";
        })
(fetchNuGet {
        name = "xunit.abstractions";
        version = "2.0.3";
        url = "https://www.nuget.org/api/v2/package/xunit.abstractions/2.0.3";
        sha256 = "00wl8qksgkxld76fgir3ycc5rjqv1sqds6x8yx40927q5py74gfh";
        })
(fetchNuGet {
        name = "microsoft.build.utilities.core";
        version = "15.5.180";
        url = "https://www.nuget.org/api/v2/package/microsoft.build.utilities.core/15.5.180";
        sha256 = "0c4bjhaqgc98bchln8p5d2p1vyn8qrha2b8gpn2l7bnznbcrd630";
        })
(fetchNuGet {
        name = "microsoft.build.utilities.core";
        version = "14.3.0";
        url = "https://www.nuget.org/api/v2/package/microsoft.build.utilities.core/14.3.0";
        sha256 = "0351nsnx12nzkss6vaqwwh7d7car7hrgyh0vyd4bl83c4x3ls1kb";
        })
(fetchNuGet {
        name = "system.reflection.emit";
        version = "4.0.1";
        url = "https://www.nuget.org/api/v2/package/system.reflection.emit/4.0.1";
        sha256 = "0ydqcsvh6smi41gyaakglnv252625hf29f7kywy2c70nhii2ylqp";
        })
(fetchNuGet {
        name = "microsoft.visualstudio.setup.configuration.interop";
        version = "1.16.30";
        url = "https://www.nuget.org/api/v2/package/microsoft.visualstudio.setup.configuration.interop/1.16.30";
        sha256 = "14022lx03vdcqlvbbdmbsxg5pqfx1rfq2jywxlyaz9v68cvsb0g4";
        })
(fetchNuGet {
        name = "system.net.sockets";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.net.sockets/4.3.0";
        sha256 = "1ssa65k6chcgi6mfmzrznvqaxk8jp0gvl77xhf1hbzakjnpxspla";
        })
(fetchNuGet {
        name = "microsoft.dotnet.arcade.sdk";
        version = "1.0.0-beta.19372.10";
        url = "https://dotnetfeed.blob.core.windows.net/dotnet-core/flatcontainer/microsoft.dotnet.arcade.sdk/1.0.0-beta.19372.10/microsoft.dotnet.arcade.sdk.1.0.0-beta.19372.10.nupkg";
        sha256 = "1lii0yg4fbsma80mmvw2zwplc26abb46q6gkxwbsbkyszkw128hv";
        })
(fetchNuGet {
        name = "runtime.fedora.23-x64.runtime.native.system.security.cryptography.openssl";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/runtime.fedora.23-x64.runtime.native.system.security.cryptography.openssl/4.3.0";
        sha256 = "0hkg03sgm2wyq8nqk6dbm9jh5vcq57ry42lkqdmfklrw89lsmr59";
        })
(fetchNuGet {
        name = "runtime.native.system.io.compression";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/runtime.native.system.io.compression/4.3.0";
        sha256 = "1vvivbqsk6y4hzcid27pqpm5bsi6sc50hvqwbcx8aap5ifrxfs8d";
        })
(fetchNuGet {
        name = "system.diagnostics.debug";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.diagnostics.debug/4.3.0";
        sha256 = "00yjlf19wjydyr6cfviaph3vsjzg3d5nvnya26i2fvfg53sknh3y";
        })
(fetchNuGet {
        name = "system.diagnostics.debug";
        version = "4.0.11";
        url = "https://www.nuget.org/api/v2/package/system.diagnostics.debug/4.0.11";
        sha256 = "0gmjghrqmlgzxivd2xl50ncbglb7ljzb66rlx8ws6dv8jm0d5siz";
        })
(fetchNuGet {
        name = "system.xml.readerwriter";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.xml.readerwriter/4.3.0";
        sha256 = "0c47yllxifzmh8gq6rq6l36zzvw4kjvlszkqa9wq3fr59n0hl3s1";
        })
(fetchNuGet {
        name = "system.xml.readerwriter";
        version = "4.0.11";
        url = "https://www.nuget.org/api/v2/package/system.xml.readerwriter/4.0.11";
        sha256 = "0c6ky1jk5ada9m94wcadih98l6k1fvf6vi7vhn1msjixaha419l5";
        })
(fetchNuGet {
        name = "system.threading.timer";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.threading.timer/4.3.0";
        sha256 = "1nx773nsx6z5whv8kaa1wjh037id2f1cxhb69pvgv12hd2b6qs56";
        })
(fetchNuGet {
        name = "system.threading.timer";
        version = "4.0.1";
        url = "https://www.nuget.org/api/v2/package/system.threading.timer/4.0.1";
        sha256 = "15n54f1f8nn3mjcjrlzdg6q3520571y012mx7v991x2fvp73lmg6";
        })
(fetchNuGet {
        name = "system.reflection.metadata";
        version = "1.4.2";
        url = "https://www.nuget.org/api/v2/package/system.reflection.metadata/1.4.2";
        sha256 = "08b7b43vczlliv8k7q43jinjfrxwpljsglw7sxmc6sd7d54pd1vi";
        })
(fetchNuGet {
        name = "system.reflection.metadata";
        version = "1.6.0";
        url = "https://www.nuget.org/api/v2/package/system.reflection.metadata/1.6.0";
        sha256 = "1wdbavrrkajy7qbdblpbpbalbdl48q3h34cchz24gvdgyrlf15r4";
        })
(fetchNuGet {
        name = "system.xml.xdocument";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.xml.xdocument/4.3.0";
        sha256 = "08h8fm4l77n0nd4i4fk2386y809bfbwqb7ih9d7564ifcxr5ssxd";
        })
(fetchNuGet {
        name = "system.linq";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.linq/4.3.0";
        sha256 = "1w0gmba695rbr80l1k2h4mrwzbzsyfl2z4klmpbsvsg5pm4a56s7";
        })
(fetchNuGet {
        name = "system.linq";
        version = "4.1.0";
        url = "https://www.nuget.org/api/v2/package/system.linq/4.1.0";
        sha256 = "1ppg83svb39hj4hpp5k7kcryzrf3sfnm08vxd5sm2drrijsla2k5";
        })
(fetchNuGet {
        name = "nuget.librarymodel";
        version = "5.2.0-rtm.6067";
        url = "https://dotnet.myget.org/F/nuget-build/api/v2/package/nuget.librarymodel/5.2.0-rtm.6067";
        sha256 = "0dxvnspgkc1lcmilb67kkipg39ih34cmifs6jwk9kbrwf96z51q9";
        })
(fetchNuGet {
        name = "xlifftasks";
        version = "1.0.0-beta.19252.1";
        url = "https://dotnetfeed.blob.core.windows.net/dotnet-core/flatcontainer/xlifftasks/1.0.0-beta.19252.1/xlifftasks.1.0.0-beta.19252.1.nupkg";
        sha256 = "0249sfb30y9dgsfryaj8644qw3yc1xp2xzc08lsrwvmm8vjcvkri";
        })
(fetchNuGet {
        name = "system.text.regularexpressions";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.text.regularexpressions/4.3.0";
        sha256 = "1bgq51k7fwld0njylfn7qc5fmwrk2137gdq7djqdsw347paa9c2l";
        })
(fetchNuGet {
        name = "system.text.regularexpressions";
        version = "4.1.0";
        url = "https://www.nuget.org/api/v2/package/system.text.regularexpressions/4.1.0";
        sha256 = "1mw7vfkkyd04yn2fbhm38msk7dz2xwvib14ygjsb8dq2lcvr18y7";
        })
(fetchNuGet {
        name = "system.security.accesscontrol";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.security.accesscontrol/4.3.0";
        sha256 = "1gakrskmlmwhzmjc1c2mrwk0fml615rsk31dw0kbjnn9yqnnrjbi";
        })
(fetchNuGet {
        name = "xunit.runner.visualstudio";
        version = "2.4.1";
        url = "https://www.nuget.org/api/v2/package/xunit.runner.visualstudio/2.4.1";
        sha256 = "0fln5pk18z98gp0zfshy1p9h6r9wc55nyqhap34k89yran646vhn";
        })
(fetchNuGet {
        name = "system.resources.resourcemanager";
        version = "4.0.1";
        url = "https://www.nuget.org/api/v2/package/system.resources.resourcemanager/4.0.1";
        sha256 = "0b4i7mncaf8cnai85jv3wnw6hps140cxz8vylv2bik6wyzgvz7bi";
        })
(fetchNuGet {
        name = "system.resources.resourcemanager";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.resources.resourcemanager/4.3.0";
        sha256 = "0sjqlzsryb0mg4y4xzf35xi523s4is4hz9q4qgdvlvgivl7qxn49";
        })
(fetchNuGet {
        name = "nuget.projectmodel";
        version = "5.2.0-rtm.6067";
        url = "https://dotnet.myget.org/F/nuget-build/api/v2/package/nuget.projectmodel/5.2.0-rtm.6067";
        sha256 = "1s5950nbcsnfrpbaxdnl6cv1xbsa57fln04lhyrki536476a6wcn";
        })
(fetchNuGet {
        name = "nuget.versioning";
        version = "5.2.0-rtm.6067";
        url = "https://dotnet.myget.org/F/nuget-build/api/v2/package/nuget.versioning/5.2.0-rtm.6067";
        sha256 = "04rr31ms95h7ymqxlalpv3xs48j8ng4ljfz5lmrfw7547rhcrj2h";
        })
(fetchNuGet {
        name = "system.memory";
        version = "4.5.3";
        url = "https://www.nuget.org/api/v2/package/system.memory/4.5.3";
        sha256 = "0naqahm3wljxb5a911d37mwjqjdxv9l0b49p5dmfyijvni2ppy8a";
        })
(fetchNuGet {
        name = "system.resources.reader";
        version = "4.0.0";
        url = "https://www.nuget.org/api/v2/package/system.resources.reader/4.0.0";
        sha256 = "1jafi73dcf1lalrir46manq3iy6xnxk2z7gpdpwg4wqql7dv3ril";
        })
(fetchNuGet {
        name = "nuget.common";
        version = "5.2.0-rtm.6067";
        url = "https://dotnet.myget.org/F/nuget-build/api/v2/package/nuget.common/5.2.0-rtm.6067";
        sha256 = "1ff5dhkv8v04n2kr5gyjjvki4mqsp1w4dwsgj7cvdcfcm8alba0m";
        })
(fetchNuGet {
        name = "runtime.native.system";
        version = "4.0.0";
        url = "https://www.nuget.org/api/v2/package/runtime.native.system/4.0.0";
        sha256 = "1ppk69xk59ggacj9n7g6fyxvzmk1g5p4fkijm0d7xqfkig98qrkf";
        })
(fetchNuGet {
        name = "runtime.native.system";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/runtime.native.system/4.3.0";
        sha256 = "15hgf6zaq9b8br2wi1i3x0zvmk410nlmsmva9p0bbg73v6hml5k4";
        })
(fetchNuGet {
        name = "system.runtime.interopservices";
        version = "4.1.0";
        url = "https://www.nuget.org/api/v2/package/system.runtime.interopservices/4.1.0";
        sha256 = "01kxqppx3dr3b6b286xafqilv4s2n0gqvfgzfd4z943ga9i81is1";
        })
(fetchNuGet {
        name = "system.runtime.interopservices";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.runtime.interopservices/4.3.0";
        sha256 = "00hywrn4g7hva1b2qri2s6rabzwgxnbpw9zfxmz28z09cpwwgh7j";
        })
(fetchNuGet {
        name = "microbuild.core.sentinel";
        version = "1.0.0";
        url = "https://dotnetfeed.blob.core.windows.net/dotnet-core/flatcontainer/microbuild.core.sentinel/1.0.0/microbuild.core.sentinel.1.0.0.nupkg";
        sha256 = "035kqx5fkapql108n222lz8psvxk04mv3dy1qg3h08i4b8j3dy8i";
        })
(fetchNuGet {
        name = "sn";
        version = "1.0.0";
        url = "https://dotnetfeed.blob.core.windows.net/dotnet-core/flatcontainer/sn/1.0.0/sn.1.0.0.nupkg";
        sha256 = "1012fcdc6vq2355v86h434s6p2nnqgpdapb7p25l4h39g5q8p1qs";
        })
(fetchNuGet {
        name = "system.text.encoding";
        version = "4.0.11";
        url = "https://www.nuget.org/api/v2/package/system.text.encoding/4.0.11";
        sha256 = "1dyqv0hijg265dwxg6l7aiv74102d6xjiwplh2ar1ly6xfaa4iiw";
        })
(fetchNuGet {
        name = "system.text.encoding";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.text.encoding/4.3.0";
        sha256 = "1f04lkir4iladpp51sdgmis9dj4y8v08cka0mbmsy0frc9a4gjqr";
        })
(fetchNuGet {
        name = "runtime.ubuntu.16.10-x64.runtime.native.system.security.cryptography.openssl";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/runtime.ubuntu.16.10-x64.runtime.native.system.security.cryptography.openssl/4.3.0";
        sha256 = "1p4dgxax6p7rlgj4q73k73rslcnz4wdcv8q2flg1s8ygwcm58ld5";
        })
(fetchNuGet {
        name = "system.reflection.emit.lightweight";
        version = "4.0.1";
        url = "https://www.nuget.org/api/v2/package/system.reflection.emit.lightweight/4.0.1";
        sha256 = "1s4b043zdbx9k39lfhvsk68msv1nxbidhkq6nbm27q7sf8xcsnxr";
        })
(fetchNuGet {
        name = "microsoft.net.test.sdk";
        version = "15.9.0";
        url = "https://www.nuget.org/api/v2/package/microsoft.net.test.sdk/15.9.0";
        sha256 = "0g7wjgiigs4v8qa32g9ysqgx8bx55dzmbxfkc4ic95mpd1vkjqxw";
        })
(fetchNuGet {
        name = "system.io.compression";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.io.compression/4.3.0";
        sha256 = "084zc82yi6yllgda0zkgl2ys48sypiswbiwrv7irb3r0ai1fp4vz";
        })
(fetchNuGet {
        name = "system.runtime.serialization.primitives";
        version = "4.1.1";
        url = "https://www.nuget.org/api/v2/package/system.runtime.serialization.primitives/4.1.1";
        sha256 = "042rfjixknlr6r10vx2pgf56yming8lkjikamg3g4v29ikk78h7k";
        })
(fetchNuGet {
        name = "system.diagnostics.fileversioninfo";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.diagnostics.fileversioninfo/4.3.0";
        sha256 = "094hx249lb3vb336q7dg3v257hbxvz2jnalj695l7cg5kxzqwai7";
        })
(fetchNuGet {
        name = "system.xml.xpath.xdocument";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.xml.xpath.xdocument/4.3.0";
        sha256 = "1wxckyb7n1pi433xzz0qcwcbl1swpra64065mbwwi8dhdc4kiabn";
        })
(fetchNuGet {
        name = "system.security.principal.windows";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.security.principal.windows/4.3.0";
        sha256 = "00a0a7c40i3v4cb20s2cmh9csb5jv2l0frvnlzyfxh848xalpdwr";
        })
(fetchNuGet {
        name = "vswhere";
        version = "2.6.7";
        url = "https://www.nuget.org/api/v2/package/vswhere/2.6.7";
        sha256 = "0h4k5i96p7633zzf4xsv7615f9x72rr5qr7b9934ri2y6gshfcwk";
        })
(fetchNuGet {
        name = "runtime.opensuse.13.2-x64.runtime.native.system.security.cryptography.openssl";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/runtime.opensuse.13.2-x64.runtime.native.system.security.cryptography.openssl/4.3.0";
        sha256 = "0qyynf9nz5i7pc26cwhgi8j62ps27sqmf78ijcfgzab50z9g8ay3";
        })
(fetchNuGet {
        name = "xunit.runner.console";
        version = "2.4.1";
        url = "https://www.nuget.org/api/v2/package/xunit.runner.console/2.4.1";
        sha256 = "13ykz9anhz72xc4q6byvdfwrp54hlcbl6zsfapwfhnzyvfgb9w13";
        })
(fetchNuGet {
        name = "system.threading";
        version = "4.0.11";
        url = "https://www.nuget.org/api/v2/package/system.threading/4.0.11";
        sha256 = "19x946h926bzvbsgj28csn46gak2crv2skpwsx80hbgazmkgb1ls";
        })
(fetchNuGet {
        name = "system.threading";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.threading/4.3.0";
        sha256 = "0rw9wfamvhayp5zh3j7p1yfmx9b5khbf4q50d8k5rk993rskfd34";
        })
(fetchNuGet {
        name = "system.threading.tasks.dataflow";
        version = "4.5.24";
        url = "https://www.nuget.org/api/v2/package/system.threading.tasks.dataflow/4.5.24";
        sha256 = "0wahbfdb0jxx3hi04xggfms8wgf68wmvv68m2vfp8v2kiqr5mr2r";
        })
(fetchNuGet {
        name = "microsoft.codeanalysis.analyzers";
        version = "1.1.0";
        url = "https://www.nuget.org/api/v2/package/microsoft.codeanalysis.analyzers/1.1.0";
        sha256 = "08r667hj2259wbim1p3al5qxkshydykmb7nd9ygbjlg4mmydkapc";
        })
(fetchNuGet {
        name = "system.dynamic.runtime";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.dynamic.runtime/4.3.0";
        sha256 = "1d951hrvrpndk7insiag80qxjbf2y0y39y8h5hnq9612ws661glk";
        })
(fetchNuGet {
        name = "system.io.pipes";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.io.pipes/4.3.0";
        sha256 = "1ygv16gzpi9cnlzcqwijpv7055qc50ynwg3vw29vj1q3iha3h06r";
        })
(fetchNuGet {
        name = "system.net.primitives";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.net.primitives/4.3.0";
        sha256 = "0c87k50rmdgmxx7df2khd9qj7q35j9rzdmm2572cc55dygmdk3ii";
        })
(fetchNuGet {
        name = "system.runtime.serialization.xml";
        version = "4.1.1";
        url = "https://www.nuget.org/api/v2/package/system.runtime.serialization.xml/4.1.1";
        sha256 = "11747an5gbz821pwahaim3v82gghshnj9b5c4cw539xg5a3gq7rk";
        })
(fetchNuGet {
        name = "system.security.cryptography.encoding";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.security.cryptography.encoding/4.3.0";
        sha256 = "1jr6w70igqn07k5zs1ph6xja97hxnb3mqbspdrff6cvssgrixs32";
        })
(fetchNuGet {
        name = "system.collections.nongeneric";
        version = "4.0.1";
        url = "https://www.nuget.org/api/v2/package/system.collections.nongeneric/4.0.1";
        sha256 = "19994r5y5bpdhj7di6w047apvil8lh06lh2c2yv9zc4fc5g9bl4d";
        })
(fetchNuGet {
        name = "system.diagnostics.tools";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.diagnostics.tools/4.3.0";
        sha256 = "0in3pic3s2ddyibi8cvgl102zmvp9r9mchh82ns9f0ms4basylw1";
        })
(fetchNuGet {
        name = "microsoft.netframework.referenceassemblies";
        version = "1.0.0-alpha-004";
        url = "https://dotnet.myget.org/F/roslyn-tools/api/v2/package/microsoft.netframework.referenceassemblies/1.0.0-alpha-004";
        sha256 = "1qrpxhcx11v92lqwvrih88mlyfw2rkrsjqh7gl8c1h71vyppr3bp";
        })
(fetchNuGet {
        name = "system.reflection.emit.ilgeneration";
        version = "4.0.1";
        url = "https://www.nuget.org/api/v2/package/system.reflection.emit.ilgeneration/4.0.1";
        sha256 = "1pcd2ig6bg144y10w7yxgc9d22r7c7ww7qn1frdfwgxr24j9wvv0";
        })
(fetchNuGet {
        name = "xunit.extensibility.execution";
        version = "2.4.1";
        url = "https://www.nuget.org/api/v2/package/xunit.extensibility.execution/2.4.1";
        sha256 = "1pbilxh1gp2ywm5idfl0klhl4gb16j86ib4x83p8raql1dv88qia";
        })
(fetchNuGet {
        name = "microsoft.codecoverage";
        version = "15.9.0";
        url = "https://www.nuget.org/api/v2/package/microsoft.codecoverage/15.9.0";
        sha256 = "10v5xrdilnm362g9545qxvlrbwc9vn65jhpb1i0jlhyqsj6bfwzg";
        })
(fetchNuGet {
        name = "xunit.extensibility.core";
        version = "2.4.1";
        url = "https://www.nuget.org/api/v2/package/xunit.extensibility.core/2.4.1";
        sha256 = "103qsijmnip2pnbhciqyk2jyhdm6snindg5z2s57kqf5pcx9a050";
        })
(fetchNuGet {
        name = "system.collections.concurrent";
        version = "4.0.12";
        url = "https://www.nuget.org/api/v2/package/system.collections.concurrent/4.0.12";
        sha256 = "07y08kvrzpak873pmyxs129g1ch8l27zmg51pcyj2jvq03n0r0fc";
        })
(fetchNuGet {
        name = "system.collections.concurrent";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.collections.concurrent/4.3.0";
        sha256 = "0wi10md9aq33jrkh2c24wr2n9hrpyamsdhsxdcnf43b7y86kkii8";
        })
(fetchNuGet {
        name = "system.collections";
        version = "4.0.11";
        url = "https://www.nuget.org/api/v2/package/system.collections/4.0.11";
        sha256 = "1ga40f5lrwldiyw6vy67d0sg7jd7ww6kgwbksm19wrvq9hr0bsm6";
        })
(fetchNuGet {
        name = "system.collections";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.collections/4.3.0";
        sha256 = "19r4y64dqyrq6k4706dnyhhw7fs24kpp3awak7whzss39dakpxk9";
        })
(fetchNuGet {
        name = "runtime.opensuse.42.1-x64.runtime.native.system.security.cryptography.openssl";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/runtime.opensuse.42.1-x64.runtime.native.system.security.cryptography.openssl/4.3.0";
        sha256 = "1klrs545awhayryma6l7g2pvnp9xy4z0r1i40r80zb45q3i9nbyf";
        })
(fetchNuGet {
        name = "microsoft.build.nugetsdkresolver";
        version = "5.2.0-rtm.6067";
        url = "https://dotnet.myget.org/F/nuget-build/api/v2/package/microsoft.build.nugetsdkresolver/5.2.0-rtm.6067";
        sha256 = "1rz2i4md7b8rlybb9s7416l0pr357f3ar149s6ipfq0xijn3xgmh";
        })
(fetchNuGet {
        name = "system.reflection";
        version = "4.1.0";
        url = "https://www.nuget.org/api/v2/package/system.reflection/4.1.0";
        sha256 = "1js89429pfw79mxvbzp8p3q93il6rdff332hddhzi5wqglc4gml9";
        })
(fetchNuGet {
        name = "system.reflection";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.reflection/4.3.0";
        sha256 = "0xl55k0mw8cd8ra6dxzh974nxif58s3k1rjv1vbd7gjbjr39j11m";
        })
(fetchNuGet {
        name = "nuget.configuration";
        version = "5.2.0-rtm.6067";
        url = "https://dotnet.myget.org/F/nuget-build/api/v2/package/nuget.configuration/5.2.0-rtm.6067";
        sha256 = "075mypb32i0d0x73rcr0di6pb0bhlp0izv3633ky64kddriajma1";
        })
(fetchNuGet {
        name = "system.net.http";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.net.http/4.3.0";
        sha256 = "1i4gc757xqrzflbk7kc5ksn20kwwfjhw9w7pgdkn19y3cgnl302j";
        })
(fetchNuGet {
        name = "runtime.debian.8-x64.runtime.native.system.security.cryptography.openssl";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/runtime.debian.8-x64.runtime.native.system.security.cryptography.openssl/4.3.0";
        sha256 = "16rnxzpk5dpbbl1x354yrlsbvwylrq456xzpsha1n9y3glnhyx9d";
        })
(fetchNuGet {
        name = "system.security.cryptography.x509certificates";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.security.cryptography.x509certificates/4.3.0";
        sha256 = "0valjcz5wksbvijylxijjxb1mp38mdhv03r533vnx1q3ikzdav9h";
        })
(fetchNuGet {
        name = "nuget.packaging";
        version = "5.2.0-rtm.6067";
        url = "https://dotnet.myget.org/F/nuget-build/api/v2/package/nuget.packaging/5.2.0-rtm.6067";
        sha256 = "16p5glvvpp5rw10ycbpyg39k4prir450l12r5frpm8qz0rdp3xig";
        })
(fetchNuGet {
        name = "nuget.commands";
        version = "5.2.0-rtm.6067";
        url = "https://dotnet.myget.org/F/nuget-build/api/v2/package/nuget.commands/5.2.0-rtm.6067";
        sha256 = "06vnphsmwnvcigwj37hy5abipjzwhnq61zw66cclwd6jjibb1kh9";
        })
(fetchNuGet {
        name = "system.runtime";
        version = "4.1.0";
        url = "https://www.nuget.org/api/v2/package/system.runtime/4.1.0";
        sha256 = "02hdkgk13rvsd6r9yafbwzss8kr55wnj8d5c7xjnp8gqrwc8sn0m";
        })
(fetchNuGet {
        name = "system.runtime";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.runtime/4.3.0";
        sha256 = "066ixvgbf2c929kgknshcxqj6539ax7b9m570cp8n179cpfkapz7";
        })
(fetchNuGet {
        name = "microsoft.win32.primitives";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/microsoft.win32.primitives/4.3.0";
        sha256 = "0j0c1wj4ndj21zsgivsc24whiya605603kxrbiw6wkfdync464wq";
        })
(fetchNuGet {
        name = "microsoft.win32.primitives";
        version = "4.0.1";
        url = "https://www.nuget.org/api/v2/package/microsoft.win32.primitives/4.0.1";
        sha256 = "1n8ap0cmljbqskxpf8fjzn7kh1vvlndsa75k01qig26mbw97k2q7";
        })
(fetchNuGet {
        name = "system.collections.immutable";
        version = "1.2.0";
        url = "https://www.nuget.org/api/v2/package/system.collections.immutable/1.2.0";
        sha256 = "1jm4pc666yiy7af1mcf7766v710gp0h40p228ghj6bavx7xfa38m";
        })
(fetchNuGet {
        name = "system.collections.immutable";
        version = "1.3.1";
        url = "https://www.nuget.org/api/v2/package/system.collections.immutable/1.3.1";
        sha256 = "17615br2x5riyx8ivf1dcqwj6q3ipq1bi5hqhw54yfyxmx38ddva";
        })
(fetchNuGet {
        name = "system.collections.immutable";
        version = "1.5.0";
        url = "https://www.nuget.org/api/v2/package/system.collections.immutable/1.5.0";
        sha256 = "1d5gjn5afnrf461jlxzawcvihz195gayqpcfbv6dd7pxa9ialn06";
        })
(fetchNuGet {
        name = "nuget.dependencyresolver.core";
        version = "5.2.0-rtm.6067";
        url = "https://dotnet.myget.org/F/nuget-build/api/v2/package/nuget.dependencyresolver.core/5.2.0-rtm.6067";
        sha256 = "0iw1z2lascjjmdkk9nf2wqm5sj5nqjv4611xx29vlmp6cyhnpq4i";
        })
(fetchNuGet {
        name = "netstandard.library";
        version = "1.6.1";
        url = "https://www.nuget.org/api/v2/package/netstandard.library/1.6.1";
        sha256 = "1z70wvsx2d847a2cjfii7b83pjfs34q05gb037fdjikv5kbagml8";
        })
(fetchNuGet {
        name = "shouldly";
        version = "3.0.0";
        url = "https://www.nuget.org/api/v2/package/shouldly/3.0.0";
        sha256 = "1hg28w898kl84rx57sclb2z9b76v5hxlwxig1xnb6fr81aahzlw3";
        })
(fetchNuGet {
        name = "microsoft.diasymreader.pdb2pdb";
        version = "1.1.0-beta1-62506-02";
        url = "https://dotnetfeed.blob.core.windows.net/dotnet-core/flatcontainer/microsoft.diasymreader.pdb2pdb/1.1.0-beta1-62506-02/microsoft.diasymreader.pdb2pdb.1.1.0-beta1-62506-02.nupkg";
        sha256 = "1dkhpmq5aw34nndvb4xc370866vf33x70zrjhgvnpwwspb6vb0zh";
        })
(fetchNuGet {
        name = "system.globalization.calendars";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.globalization.calendars/4.3.0";
        sha256 = "1xwl230bkakzzkrggy1l1lxmm3xlhk4bq2pkv790j5lm8g887lxq";
        })
(fetchNuGet {
        name = "system.io.compression.zipfile";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.io.compression.zipfile/4.3.0";
        sha256 = "1yxy5pq4dnsm9hlkg9ysh5f6bf3fahqqb6p8668ndy5c0lk7w2ar";
        })
(fetchNuGet {
        name = "system.runtime.interopservices.runtimeinformation";
        version = "4.0.0";
        url = "https://www.nuget.org/api/v2/package/system.runtime.interopservices.runtimeinformation/4.0.0";
        sha256 = "0glmvarf3jz5xh22iy3w9v3wyragcm4hfdr17v90vs7vcrm7fgp6";
        })
(fetchNuGet {
        name = "system.runtime.interopservices.runtimeinformation";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.runtime.interopservices.runtimeinformation/4.3.0";
        sha256 = "0q18r1sh4vn7bvqgd6dmqlw5v28flbpj349mkdish2vjyvmnb2ii";
        })
(fetchNuGet {
        name = "system.io.filesystem.driveinfo";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.io.filesystem.driveinfo/4.3.0";
        sha256 = "0j67khc75lwdf7d5i3z41cks7zhac4zdccgvk2xmq6wm1l08xnlh";
        })
(fetchNuGet {
        name = "system.threading.tasks.extensions";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.threading.tasks.extensions/4.3.0";
        sha256 = "1xxcx2xh8jin360yjwm4x4cf5y3a2bwpn2ygkfkwkicz7zk50s2z";
        })
(fetchNuGet {
        name = "system.threading.tasks.extensions";
        version = "4.0.0";
        url = "https://www.nuget.org/api/v2/package/system.threading.tasks.extensions/4.0.0";
        sha256 = "1cb51z062mvc2i8blpzmpn9d9mm4y307xrwi65di8ri18cz5r1zr";
        })
(fetchNuGet {
        name = "microsoft.netcore.targets";
        version = "1.0.1";
        url = "https://www.nuget.org/api/v2/package/microsoft.netcore.targets/1.0.1";
        sha256 = "0ppdkwy6s9p7x9jix3v4402wb171cdiibq7js7i13nxpdky7074p";
        })
(fetchNuGet {
        name = "microsoft.netcore.targets";
        version = "1.1.0";
        url = "https://www.nuget.org/api/v2/package/microsoft.netcore.targets/1.1.0";
        sha256 = "193xwf33fbm0ni3idxzbr5fdq3i2dlfgihsac9jj7whj0gd902nh";
        })
(fetchNuGet {
        name = "system.reflection.extensions";
        version = "4.0.1";
        url = "https://www.nuget.org/api/v2/package/system.reflection.extensions/4.0.1";
        sha256 = "0m7wqwq0zqq9gbpiqvgk3sr92cbrw7cp3xn53xvw7zj6rz6fdirn";
        })
(fetchNuGet {
        name = "system.reflection.extensions";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.reflection.extensions/4.3.0";
        sha256 = "02bly8bdc98gs22lqsfx9xicblszr2yan7v2mmw3g7hy6miq5hwq";
        })
(fetchNuGet {
        name = "system.diagnostics.process";
        version = "4.1.0";
        url = "https://www.nuget.org/api/v2/package/system.diagnostics.process/4.1.0";
        sha256 = "061lrcs7xribrmq7kab908lww6kn2xn1w3rdc41q189y0jibl19s";
        })
(fetchNuGet {
        name = "system.diagnostics.process";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.diagnostics.process/4.3.0";
        sha256 = "0g4prsbkygq8m21naqmcp70f24a1ksyix3dihb1r1f71lpi3cfj7";
        })
(fetchNuGet {
        name = "system.security.cryptography.primitives";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.security.cryptography.primitives/4.3.0";
        sha256 = "0pyzncsv48zwly3lw4f2dayqswcfvdwq2nz0dgwmi7fj3pn64wby";
        })
(fetchNuGet {
        name = "system.threading.thread";
        version = "4.0.0";
        url = "https://www.nuget.org/api/v2/package/system.threading.thread/4.0.0";
        sha256 = "1gxxm5fl36pjjpnx1k688dcw8m9l7nmf802nxis6swdaw8k54jzc";
        })
(fetchNuGet {
        name = "system.threading.thread";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.threading.thread/4.3.0";
        sha256 = "0y2xiwdfcph7znm2ysxanrhbqqss6a3shi1z3c779pj2s523mjx4";
        })
(fetchNuGet {
        name = "newtonsoft.json";
        version = "9.0.1";
        url = "https://www.nuget.org/api/v2/package/newtonsoft.json/9.0.1";
        sha256 = "0mcy0i7pnfpqm4pcaiyzzji4g0c8i3a5gjz28rrr28110np8304r";
        })
(fetchNuGet {
        name = "runtime.rhel.7-x64.runtime.native.system.security.cryptography.openssl";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/runtime.rhel.7-x64.runtime.native.system.security.cryptography.openssl/4.3.0";
        sha256 = "0vhynn79ih7hw7cwjazn87rm9z9fj0rvxgzlab36jybgcpcgphsn";
        })
(fetchNuGet {
        name = "xunit";
        version = "2.4.1";
        url = "https://www.nuget.org/api/v2/package/xunit/2.4.1";
        sha256 = "0xf3kaywpg15flqaqfgywqyychzk15kz0kz34j21rcv78q9ywq20";
        })
(fetchNuGet {
        name = "system.valuetuple";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.valuetuple/4.3.0";
        sha256 = "1227k7fxbxapq7dms4lvwwjdf3pr1jcsmhy2nzzhj6g6hs530hxn";
        })
(fetchNuGet {
        name = "microsoft.netframework.referenceassemblies.net472";
        version = "1.0.0-alpha-004";
        url = "https://dotnet.myget.org/F/roslyn-tools/api/v2/package/microsoft.netframework.referenceassemblies.net472/1.0.0-alpha-004";
        sha256 = "08wa54dm7yskayzxivnwbm8sg1pf6ai8ccr64ixf9lyz3yw6y0nc";
        })
(fetchNuGet {
        name = "system.security.cryptography.algorithms";
        version = "4.3.0";
        url = "https://www.nuget.org/api/v2/package/system.security.cryptography.algorithms/4.3.0";
        sha256 = "03sq183pfl5kp7gkvq77myv7kbpdnq3y0xj7vi4q1kaw54sny0ml";
        })
]
