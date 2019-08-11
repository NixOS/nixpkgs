{ fetchurl }: let

  fetchNuGet = { name, version, sha256 }: fetchurl {
    inherit sha256;
    url = "https://www.nuget.org/api/v2/package/${name}/${version}";
  };

in [

  (fetchNuGet {
    name = "Microsoft.NETCore.Platforms";
    version = "1.1.0";
    sha256 = "08vh1r12g6ykjygq5d3vq09zylgb84l63k49jc4v8faw9g93iqqm";
  })

  (fetchNuGet {
    name = "NETStandard.Library";
    version = "2.0.3";
    sha256 = "1fn9fxppfcg4jgypp2pmrpr6awl3qz1xmnri0cygpkwvyx27df1y";
  })

  (fetchNuGet {
    name = "MicroBuild.Core";
    version = "0.3.0";
    sha256 = "190d755l60j3l5m1661wj19gj9w6ngza56q3vkijkkmbbabdmqln";
  })

  (fetchNuGet {
    name = "Microsoft.Extensions.FileSystemGlobbing";
    version = "2.2.0";
    sha256 = "01jw7s1nb44n65qs3rk7xdzc419qwl0s5c34k031f1cc5ag3jvc2";
  })

  (fetchNuGet {
    name = "runtime.osx.10.10-x64.runtime.native.System.Security.Cryptography.Apple";
    version = "4.3.0";
    sha256 = "10yc8jdrwgcl44b4g93f1ds76b176bajd3zqi2faf5rvh1vy9smi";
  })

  (fetchNuGet {
    name = "runtime.native.System.Security.Cryptography.Apple";
    version = "4.3.0";
    sha256 = "1b61p6gw1m02cc1ry996fl49liiwky6181dzr873g9ds92zl326q";
  })

  (fetchNuGet {
    name = "runtime.fedora.23-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.2";
    sha256 = "1n06gxwlinhs0w7s8a94r1q3lwqzvynxwd3mp10ws9bg6gck8n4r";
  })

  (fetchNuGet {
    name = "runtime.ubuntu.16.10-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.2";
    sha256 = "1x0g58pbpjrmj2x2qw17rdwwnrcl0wvim2hdwz48lixvwvp22n9c";
  })

  (fetchNuGet {
    name = "runtime.ubuntu.16.04-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.2";
    sha256 = "0q0n5q1r1wnqmr5i5idsrd9ywl33k0js4pngkwq9p368mbxp8x1w";
  })

  (fetchNuGet {
    name = "runtime.opensuse.42.1-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.2";
    sha256 = "1dm8fifl7rf1gy7lnwln78ch4rw54g0pl5g1c189vawavll7p6rj";
  })

  (fetchNuGet {
    name = "runtime.ubuntu.14.04-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.2";
    sha256 = "15gsm1a8jdmgmf8j5v1slfz8ks124nfdhk2vxs2rw3asrxalg8hi";
  })

  (fetchNuGet {
    name = "runtime.rhel.7-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.2";
    sha256 = "1cpx56mcfxz7cpn57wvj18sjisvzq8b5vd9rw16ihd2i6mcp3wa1";
  })

  (fetchNuGet {
    name = "runtime.debian.8-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.2";
    sha256 = "0rwpqngkqiapqc5c2cpkj7idhngrgss5qpnqg0yh40mbyflcxf8i";
  })

  (fetchNuGet {
    name = "Newtonsoft.Json";
    version = "12.0.1";
    sha256 = "11f30cfxwn0z1hr5y69hxac0yyjz150ar69nvqhn18n9k92zfxz1";
  })

  (fetchNuGet {
    name = "runtime.osx.10.10-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.2";
    sha256 = "1m9z1k9kzva9n9kwinqxl97x2vgl79qhqjlv17k9s2ymcyv2bwr6";
  })

  (fetchNuGet {
    name = "Microsoft.NETCore.App";
    version = "2.2.0";
    sha256 = "0vwb1crz0lx46xkp0c1lr3d09qnnrnnjbkjs6gqbxvh2gz4vr9kk";
  })

  (fetchNuGet {
    name = "runtime.fedora.24-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.2";
    sha256 = "0404wqrc7f2yc0wxv71y3nnybvqx8v4j9d47hlscxy759a525mc3";
  })

  (fetchNuGet {
    name = "runtime.opensuse.13.2-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.2";
    sha256 = "096ch4n4s8k82xga80lfmpimpzahd2ip1mgwdqgar0ywbbl6x438";
  })

  (fetchNuGet {
    name = "System.Linq";
    version = "4.3.0";
    sha256 = "1w0gmba695rbr80l1k2h4mrwzbzsyfl2z4klmpbsvsg5pm4a56s7";
  })

  (fetchNuGet {
    name = "StreamJsonRpc";
    version = "2.0.146";
    sha256 = "016c39scjy4xs7q9b4f4r4f34571jvr82w8w4p8cn10yf6x8kn52";
  })

  (fetchNuGet {
    name = "Microsoft.NETCore.Platforms";
    version = "2.2.0";
    sha256 = "1v9knzss9y7l8wg912jparrwyk37jn9gp40nrxafh26hdk5axnpx";
  })

  (fetchNuGet {
    name = "System.Collections.Concurrent";
    version = "4.3.0";
    sha256 = "0wi10md9aq33jrkh2c24wr2n9hrpyamsdhsxdcnf43b7y86kkii8";
  })

  (fetchNuGet {
    name = "System.Security.Cryptography.Cng";
    version = "4.3.0";
    sha256 = "1k468aswafdgf56ab6yrn7649kfqx2wm9aslywjam1hdmk5yypmv";
  })

  (fetchNuGet {
    name = "Microsoft.NETCore.Targets";
    version = "2.0.0";
    sha256 = "0nsrrhafvxqdx8gmlgsz612bmlll2w3l2qn2ygdzr92rp1nqyka2";
  })

  (fetchNuGet {
    name = "System.Globalization.Calendars";
    version = "4.3.0";
    sha256 = "1xwl230bkakzzkrggy1l1lxmm3xlhk4bq2pkv790j5lm8g887lxq";
  })

  (fetchNuGet {
    name = "Microsoft.NETCore.DotNetHostPolicy";
    version = "2.2.0";
    sha256 = "1x8cn65c6ll5j5jksd2br9wlwvjf55m2x2ya4x93hj6mwgb5x6sk";
  })

  (fetchNuGet {
    name = "System.IO.Pipelines";
    version = "4.5.3";
    sha256 = "1z44vn1qp866lkx78cfqdd4vs7xn1hcfn7in6239sq2kgf5qiafb";
  })

  (fetchNuGet {
    name = "System.Memory";
    version = "4.5.2";
    sha256 = "1g24dwqfcmf4gpbgbhaw1j49xmpsz389l6bw2xxbsmnzvsf860ld";
  })

  (fetchNuGet {
    name = "System.Threading.Tasks.Extensions";
    version = "4.5.2";
    sha256 = "1sh63dz0dymqcwmprp0nadm77b83vmm7lyllpv578c397bslb8hj";
  })

  (fetchNuGet {
    name = "Microsoft.VisualStudio.Threading";
    version = "15.8.209";
    sha256 = "17j6fk6jxgafs4n45zzd3bjy683rig8k2b5611q5p7pfci5slcny";
  })

  (fetchNuGet {
    name = "Nerdbank.Streams";
    version = "2.0.206";
    sha256 = "1mpfk5a634asqz3nqnnarlqv0whqabb7glli9dy9a2sz21mla8nh";
  })

  (fetchNuGet {
    name = "System.Reflection.Emit";
    version = "4.3.0";
    sha256 = "11f8y3qfysfcrscjpjym9msk7lsfxkk4fmz9qq95kn3jd0769f74";
  })

  (fetchNuGet {
    name = "System.Net.WebSockets";
    version = "4.3.0";
    sha256 = "1gfj800078kggcgl0xyl00a6y5k4wwh2k2qm69rjy22wbmq7fy4p";
  })

  (fetchNuGet {
    name = "System.Net.Http";
    version = "4.3.3";
    sha256 = "02a8r520sc6zwrmls9n80j8f22lvx7p3nidjp4w7nh6my3d4lq77";
  })

  (fetchNuGet {
    name = "Microsoft.NETCore.DotNetHostResolver";
    version = "2.2.0";
    sha256 = "1hcgw7bv4xd344g45y6pbkzaqqabji54wswgqn01jsih0bsvrxbk";
  })

  (fetchNuGet {
    name = "Microsoft.VisualStudio.Validation";
    version = "15.3.15";
    sha256 = "1v3r2rlichlvxjrmj1grii1blnl9lp9npg2p6q3q4j6lamskxa9r";
  })

  (fetchNuGet {
    name = "Microsoft.VisualStudio.Threading.Analyzers";
    version = "15.8.209";
    sha256 = "0kkxxmmh9rx3wyvqaskscdmvplgsy0z0w4q0bybs76knmr1n60lb";
  })

  (fetchNuGet {
    name = "System.Buffers";
    version = "4.5.0";
    sha256 = "1ywfqn4md6g3iilpxjn5dsr0f5lx6z0yvhqp4pgjcamygg73cz2c";
  })

  (fetchNuGet {
    name = "System.ValueTuple";
    version = "4.5.0";
    sha256 = "00k8ja51d0f9wrq4vv5z2jhq8hy31kac2rg0rv06prylcybzl8cy";
  })

  (fetchNuGet {
    name = "System.Reflection.Emit.ILGeneration";
    version = "4.3.0";
    sha256 = "0w1n67glpv8241vnpz1kl14sy7zlnw414aqwj4hcx5nd86f6994q";
  })

  (fetchNuGet {
    name = "System.Reflection";
    version = "4.3.0";
    sha256 = "0xl55k0mw8cd8ra6dxzh974nxif58s3k1rjv1vbd7gjbjr39j11m";
  })

  (fetchNuGet {
    name = "System.Reflection.Primitives";
    version = "4.3.0";
    sha256 = "04xqa33bld78yv5r93a8n76shvc8wwcdgr1qvvjh959g3rc31276";
  })

  (fetchNuGet {
    name = "System.Runtime";
    version = "4.3.0";
    sha256 = "066ixvgbf2c929kgknshcxqj6539ax7b9m570cp8n179cpfkapz7";
  })

  (fetchNuGet {
    name = "System.Security.Cryptography.Csp";
    version = "4.3.0";
    sha256 = "1x5wcrddf2s3hb8j78cry7yalca4lb5vfnkrysagbn6r9x6xvrx1";
  })

  (fetchNuGet {
    name = "System.IO";
    version = "4.3.0";
    sha256 = "05l9qdrzhm4s5dixmx68kxwif4l99ll5gqmh7rqgw554fx0agv5f";
  })

  (fetchNuGet {
    name = "Microsoft.Win32.Primitives";
    version = "4.3.0";
    sha256 = "0j0c1wj4ndj21zsgivsc24whiya605603kxrbiw6wkfdync464wq";
  })

  (fetchNuGet {
    name = "System.Threading.Tasks";
    version = "4.3.0";
    sha256 = "134z3v9abw3a6jsw17xl3f6hqjpak5l682k2vz39spj4kmydg6k7";
  })

  (fetchNuGet {
    name = "System.Resources.ResourceManager";
    version = "4.3.0";
    sha256 = "0sjqlzsryb0mg4y4xzf35xi523s4is4hz9q4qgdvlvgivl7qxn49";
  })

  (fetchNuGet {
    name = "System.IO.FileSystem.Primitives";
    version = "4.3.0";
    sha256 = "0j6ndgglcf4brg2lz4wzsh1av1gh8xrzdsn9f0yznskhqn1xzj9c";
  })

  (fetchNuGet {
    name = "System.Runtime.Handles";
    version = "4.3.0";
    sha256 = "0sw2gfj2xr7sw9qjn0j3l9yw07x73lcs97p8xfc9w1x9h5g5m7i8";
  })

  (fetchNuGet {
    name = "System.Runtime.Extensions";
    version = "4.3.0";
    sha256 = "1ykp3dnhwvm48nap8q23893hagf665k0kn3cbgsqpwzbijdcgc60";
  })

  (fetchNuGet {
    name = "runtime.native.System";
    version = "4.3.0";
    sha256 = "15hgf6zaq9b8br2wi1i3x0zvmk410nlmsmva9p0bbg73v6hml5k4";
  })

  (fetchNuGet {
    name = "System.Runtime.Numerics";
    version = "4.3.0";
    sha256 = "19rav39sr5dky7afygh309qamqqmi9kcwvz3i0c5700v0c5cg61z";
  })

  (fetchNuGet {
    name = "System.Globalization.Extensions";
    version = "4.3.0";
    sha256 = "02a5zfxavhv3jd437bsncbhd2fp1zv4gxzakp1an9l6kdq1mcqls";
  })

  (fetchNuGet {
    name = "System.Collections";
    version = "4.3.0";
    sha256 = "19r4y64dqyrq6k4706dnyhhw7fs24kpp3awak7whzss39dakpxk9";
  })

  (fetchNuGet {
    name = "System.Diagnostics.Debug";
    version = "4.3.0";
    sha256 = "00yjlf19wjydyr6cfviaph3vsjzg3d5nvnya26i2fvfg53sknh3y";
  })

  (fetchNuGet {
    name = "System.Security.Cryptography.Primitives";
    version = "4.3.0";
    sha256 = "0pyzncsv48zwly3lw4f2dayqswcfvdwq2nz0dgwmi7fj3pn64wby";
  })

  (fetchNuGet {
    name = "System.Diagnostics.Tracing";
    version = "4.3.0";
    sha256 = "1m3bx6c2s958qligl67q7grkwfz3w53hpy7nc97mh6f7j5k168c4";
  })

  (fetchNuGet {
    name = "runtime.native.System.Net.Http";
    version = "4.3.0";
    sha256 = "1n6rgz5132lcibbch1qlf0g9jk60r0kqv087hxc0lisy50zpm7kk";
  })

  (fetchNuGet {
    name = "System.Text.Encoding";
    version = "4.3.0";
    sha256 = "1f04lkir4iladpp51sdgmis9dj4y8v08cka0mbmsy0frc9a4gjqr";
  })

  (fetchNuGet {
    name = "System.Diagnostics.DiagnosticSource";
    version = "4.3.0";
    sha256 = "0z6m3pbiy0qw6rn3n209rrzf9x1k4002zh90vwcrsym09ipm2liq";
  })

  (fetchNuGet {
    name = "System.Threading";
    version = "4.3.0";
    sha256 = "0rw9wfamvhayp5zh3j7p1yfmx9b5khbf4q50d8k5rk993rskfd34";
  })

  (fetchNuGet {
    name = "System.Globalization";
    version = "4.3.0";
    sha256 = "1cp68vv683n6ic2zqh2s1fn4c2sd87g5hpp6l4d4nj4536jz98ki";
  })

  (fetchNuGet {
    name = "System.Net.Primitives";
    version = "4.3.0";
    sha256 = "0c87k50rmdgmxx7df2khd9qj7q35j9rzdmm2572cc55dygmdk3ii";
  })

  (fetchNuGet {
    name = "System.Runtime.InteropServices";
    version = "4.3.0";
    sha256 = "00hywrn4g7hva1b2qri2s6rabzwgxnbpw9zfxmz28z09cpwwgh7j";
  })

  (fetchNuGet {
    name = "System.Security.Cryptography.OpenSsl";
    version = "4.3.0";
    sha256 = "0givpvvj8yc7gv4lhb6s1prq6p2c4147204a0wib89inqzd87gqc";
  })

  (fetchNuGet {
    name = "System.IO.FileSystem";
    version = "4.3.0";
    sha256 = "0z2dfrbra9i6y16mm9v1v6k47f0fm617vlb7s5iybjjsz6g1ilmw";
  })

  (fetchNuGet {
    name = "System.Security.Cryptography.X509Certificates";
    version = "4.3.0";
    sha256 = "0valjcz5wksbvijylxijjxb1mp38mdhv03r533vnx1q3ikzdav9h";
  })

  (fetchNuGet {
    name = "System.Security.Cryptography.Encoding";
    version = "4.3.0";
    sha256 = "1jr6w70igqn07k5zs1ph6xja97hxnb3mqbspdrff6cvssgrixs32";
  })

  (fetchNuGet {
    name = "runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.2";
    sha256 = "0zy5r25jppz48i2bkg8b9lfig24xixg6nm3xyr1379zdnqnpm8f6";
  })

  (fetchNuGet {
    name = "System.Security.Cryptography.Algorithms";
    version = "4.3.0";
    sha256 = "03sq183pfl5kp7gkvq77myv7kbpdnq3y0xj7vi4q1kaw54sny0ml";
  })

  (fetchNuGet {
    name = "Microsoft.NETCore.DotNetAppHost";
    version = "2.2.0";
    sha256 = "10kh106i1q209ki8v2j3xlzrz61qjqhqkvcnzk2blbrspa88xgrk";
  })

  (fetchNuGet {
    name = "Microsoft.NETCore.Targets";
    version = "1.1.0";
    sha256 = "193xwf33fbm0ni3idxzbr5fdq3i2dlfgihsac9jj7whj0gd902nh";
  })

  (fetchNuGet {
    name = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
    version = "2.2.0";
    sha256 = "1ai07a9pzjsphzx7rwchhwcpz6c0flcirxylga98f00rqgrb8xs4";
  })

  (fetchNuGet {
    name = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver";
    version = "2.2.0";
    sha256 = "1mq5s1xmfjyhwbr8piypaqm236b024hhqzw5rzlilypslm8rsvkn";
  })

  (fetchNuGet {
    name = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy";
    version = "2.2.0";
    sha256 = "0q40ir2fl8dqkkfcccl1r06qg160bw89i432iy084jq18w8smla3";
  })

  (fetchNuGet {
    name = "runtime.win-x86.Microsoft.NETCore.App";
    version = "2.2.0";
    sha256 = "0ja4rdcnj3w7xk76r93yhi1flks1dm8jrainv00aglmd1xpp1x64";
  })

  (fetchNuGet {
    name = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
    version = "2.2.0";
    sha256 = "1b13m641lz941ra22751zvpsd3fpf642r8bqang2867ipigk1h11";
  })

  (fetchNuGet {
    name = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver";
    version = "2.2.0";
    sha256 = "1cs565qbcziw302s0pf6s2cx6bw001gh4l2anfwq755km29x8ay0";
  })

  (fetchNuGet {
    name = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy";
    version = "2.2.0";
    sha256 = "13x25wh6wjjddld83ndr0zlypkyicddbw6dfsxqgywf29m9yrw8v";
  })

  (fetchNuGet {
    name = "runtime.win-x64.Microsoft.NETCore.App";
    version = "2.2.0";
    sha256 = "1q4s5ra24f6gp2xkdb5iymr0wdwli6ymq1czbiavgyxwh6jz1riz";
  })

  (fetchNuGet {
    name = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
    version = "2.2.0";
    sha256 = "0jxk2j0vgd70zzvpsv026pz32clgdrdx3dp4v0270p7h7912jzdw";
  })

  (fetchNuGet {
    name = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver";
    version = "2.2.0";
    sha256 = "1dy7ij8fmiw72m6rwl7k2583g8y6yf5z0ljcp4q5zqfr3agrnkby";
  })

  (fetchNuGet {
    name = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy";
    version = "2.2.0";
    sha256 = "1rin59cxpxl0a3ark8rwjvmsqr1y1l6jv5z5kijzmfb0a6jc6zh9";
  })

  (fetchNuGet {
    name = "runtime.osx-x64.Microsoft.NETCore.App";
    version = "2.2.0";
    sha256 = "1l6hs4si3i3csqd3rr28b518lg56q72bvw3sdkhv7ghgwpdgs7b1";
  })

  (fetchNuGet {
    name = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
    version = "2.2.0";
    sha256 = "0s1lp79lvi5dhay7wviicnbbdd838r4s38100nyzfd2xhz9yfb52";
  })

  (fetchNuGet {
    name = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver";
    version = "2.2.0";
    sha256 = "0p3y9r7l83crmsyspkx3hxj3ivbjq5m3f092ishb91gak9lagcnz";
  })

  (fetchNuGet {
    name = "runtime.linux-x64.Microsoft.NETCore.App";
    version = "2.2.0";
    sha256 = "1z3mbl2mlrs3sx7818i67wn0hd2fiqfqk73a8gzapd7i9x4b5hc1";
  })

  (fetchNuGet {
    name = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy";
    version = "2.2.0";
    sha256 = "0qhsb3ah6cb8cl5j8n34mljly9pn35lk3ikjhfvisxsz3mb8b26a";
  })

]
