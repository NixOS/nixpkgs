{ stdenv, fetchurl, pkgs }:

let
  fetchApple = version: sha256: name: fetchurl {
    url = "http://www.opensource.apple.com/tarballs/${name}/${name}-${version}.tar.gz";
    inherit sha256;
  };

  appleDerivation_ = name: version: sha256: attrs: stdenv.mkDerivation ({
    inherit version;
    name = "${name}-${version}";
  } // (if attrs ? srcs then {} else {
    src  = fetchApple version sha256 name;
  }) // attrs);

  applePackage = namePath: version: sha256:
    let
      name = builtins.elemAt (stdenv.lib.splitString "/" namePath) 0;
      appleDerivation = appleDerivation_ name version sha256;
      callPackage = pkgs.newScope (packages // pkgs.darwin // { inherit appleDerivation name version; });
    in callPackage (./. + builtins.toPath "/${namePath}");

  libsecPackage = pkgs.callPackage ./libsecurity_generic {
    inherit applePackage appleDerivation_;
  };

  IOKitSpecs = {
    IOAudioFamily                        = fetchApple "197.4.2"    "1dmrczdmbdkvnhjbv233wx4xczgpf5wjrhr83aizrwpks5avkxbr";
    IOFireWireFamily                     = fetchApple "455.4.0"    "034n2v6z7lf1cx3sp3309z4sn8mkchjcrsf177iag46yzlzcjgfl";
    IOFWDVComponents                     = fetchApple "207.4.1"    "1brr0yn6mxgapw3bvlhyissfksifzj2mqsvj9vmps6zwcsxjfw7m";
    IOFireWireAVC                        = fetchApple "422.4.0"    "1anw8cfmwkavnrs28bzshwa3cwk4r1p3x72561zljx57d0na9164";
    IOFireWireSBP2                       = fetchApple "426.4.1"    "0asik6qjhf3jjp22awsiyyd6rj02zwnx47l0afbwmxpn5bchfk60";
    IOFireWireSerialBusProtocolTransport = fetchApple "251.0.1"    "09kiq907qpk94zbij1mrcfcnyyc5ncvlxavxjrj4v5braxm78lhi";
    IOGraphics                           = fetchApple "471.92.1"   "1c110c9chafy5ilvnc08my9ka530aljggbn66gh3sjsg7lzck9nb";
    IOHIDFamily                          = fetchApple "503.215.2"  "0nx9mzdw848y6ppcfvip3ybczd1fxkr413zhi9qhw7gnpvac5g3n";
    IONetworkingFamily                   = fetchApple "100"        "10r769mqq7aiksdsvyz76xjln0lg7dj4pkg2x067ygyf9md55hlz";
    IOSerialFamily                       = fetchApple "64.1.1"     "1bfkqmg7clwm23byr3iji812j7v1p6565b1ri6p78zviqxnxh7cx";
    IOStorageFamily                      = fetchApple "172"        "0w5yr8ppl82anwph2zba0ppjji6ipf5x410zhcm1drzwn4bbkxrj";
    IOBDStorageFamily                    = fetchApple "14"         "1rbvmh311n853j5qb6hfda94vym9wkws5w736w2r7dwbrjyppc1q";
    IOCDStorageFamily                    = fetchApple "51"         "1905sxwmpxdcnm6yggklc5zimx1558ygm3ycj6b34f9h48xfxzgy";
    IODVDStorageFamily                   = fetchApple "35"         "1fv82rn199mi998l41c0qpnlp3irhqp2rb7v53pxbx7cra4zx3i6";
    # There should be an IOStreamFamily project here, but they haven't released it :(
    IOUSBFamily                          = fetchApple "630.4.5"    "1znqb6frxgab9mkyv7csa08c26p9p0ip6hqb4wm9c7j85kf71f4j"; # This is from 10.8 :(
    IOUSBFamily_older                    = fetchApple "560.4.2"    "113lmpz8n6sibd27p42h8bl7a6c3myc6zngwri7gnvf8qlajzyml" "IOUSBFamily"; # This is even older :(
    IOKitUser                            = fetchApple "907.100.13" "0kcbrlyxcyirvg5p95hjd9k8a01k161zg0bsfgfhkb90kh2s8x0m";
    # There should be an IOVideo here, but they haven't released it :(
  };

  IOKitSrcs = stdenv.lib.mapAttrs (name: value: if builtins.isFunction value then value name else value) IOKitSpecs;

  packages = {
    adv_cmds        = applePackage "adv_cmds"          "153"         "174v6a4zkcm2pafzgdm6kvs48z5f911zl7k49hv7kjq6gm58w99v" {};
    architecture    = applePackage "architecture"      "265"         "05wz8wmxlqssfp29x203fwfb8pgbdjj1mpz12v508658166yzqj8" {};
    bootstrap_cmds  = applePackage "bootstrap_cmds"    "86"          "0xr0296jm1r3q7kbam98h85g23qlfi763z54ahj563n636kyk2wb" {};
    CarbonHeaders   = applePackage "CarbonHeaders"     "9A581"       "1hc0yijlpwq39x5bic6nnywqp2m1wj1f11j33m2q7p505h1h740c" {};
    CF              = applePackage "CF"                "855.17"      "1sadmxi9fsvsmdyxvg2133sdzvkzwil5fvyyidxsyk1iyfzqsvln" {};
    CommonCrypto    = applePackage "CommonCrypto"      "60049"       "1azin6w7cnzl0iv8kd2qzgwcp6a45zy64y5z1i6jysjcl6xmlw2h" {};
    configd         = applePackage "configd"           "453.19"      "1gxakahk8gallf16xmhxhprdxkh3prrmzxnmxfvj0slr0939mmr2" {};
    copyfile        = applePackage "copyfile"          "103.92.1"    "15i2hw5aqx0fklvmq6avin5s00adacvzqc740vviwc2y742vrdcd" {};
    CoreOSMakefiles = applePackage "CoreOSMakefiles"   "76"          "0sw3w3sjil0kvxz8y86b81sz82rcd1nijayki1a1bsnsf0hz6qbf" {};
    Csu             = applePackage "Csu"               "79"          "1hif4dz23isgx85sgh11yg8amvp2ksvvhz3y5v07zppml7df2lnh" {};
    dtrace          = applePackage "dtrace"            "118.1"       "0pp5x8dgvzmg9vvg32hpy2brm17dpmbwrcr4prsmdmfvd4767wcf" {};
    dyld            = applePackage "dyld"              "239.4"       "07z7lyv6x0f6gllb5hymccl31zisrdhz4gqp722xcs9nhsqaqvn7" {};
    eap8021x        = applePackage "eap8021x"          "180"         "1ynkq8zmhgqhpkdg2syj085lzya0fz55d3423hvf9kcgpbjcd9ic" {};
    IOKit           = applePackage "IOKit"             "907.100.13"  "0kcbrlyxcyirvg5p95hjd9k8a01k161zg0bsfgfhkb90kh2s8x0m" { inherit IOKitSrcs; };
    launchd         = applePackage "launchd"           "842.92.1"    "0w30hvwqq8j5n90s3qyp0fccxflvrmmjnicjri4i1vd2g196jdgj" {};
    libauto         = applePackage "libauto"           "185.5"       "17z27yq5d7zfkwr49r7f0vn9pxvj95884sd2k6lq6rfaz9gxqhy3" {};
    Libc            = applePackage "Libc"              "997.90.3"    "1jz5bx9l4q484vn28c6n9b28psja3rpxiqbj6zwrwvlndzmq1yz5" {};
    Libc_old        = applePackage "Libc/825_40_1.nix" "825.40.1"    "0xsx1im52gwlmcrv4lnhhhn9dyk5ci6g27k6yvibn9vj8fzjxwcf" {};
    libclosure      = applePackage "libclosure"        "63"          "083v5xhihkkajj2yvz0dwgbi0jl2qvzk22p7pqq1zp3ry85xagrx" {};
    libdispatch     = applePackage "libdispatch"       "339.92.1"    "1lc5033cmkwxy3r26gh9plimxshxfcbgw6i0j7mgjlnpk86iy5bk" {};
    libiconv        = applePackage "libiconv"          "41"          "0sni1gx6i2h7r4r4hhwbxdir45cp039m4wi74izh4l0pfw7gywad" {};
    Libinfo         = applePackage "Libinfo"           "449.1.3"     "1ix6f7xwjnq9bqgv8w27k4j64bqn1mfhh91nc7ciiv55axpdb9hq" {};
    Libm            = applePackage "Libm"              "2026"        "02sd82ig2jvvyyfschmb4gpz6psnizri8sh6i982v341x6y4ysl7" {}; # This is from 10.7 !! :(
    Libnotify       = applePackage "Libnotify"         "121.20.1"    "164rx4za5z74s0mk9x0m1815r1m9kfal8dz3bfaw7figyjd6nqad" {};
    libpthread      = applePackage "libpthread"        "105.1.4"     "09vwwahcvmxvx2xl0890gkp91n61dld29j73y2pa597bqkag2qpg" {};
    libresolv       = applePackage "libresolv"         "54"          "028mp2smd744ryxwl8cqz4njv8h540sdw3an1yl7yxqcs04r0p4b" {};
    Libsystem       = applePackage "Libsystem"         "1197.1.1"    "1yfj2qdrf9vrzs7p9m4wlb7zzxcrim1gw43x4lvz4qydpp5kg2rh" {};
    #libutil         = applePackage "libutil"           "38"          "12gsvmj342n5d81kqwba68bmz3zf2757442g1sz2y5xmcapa3g5f" {};
    libunwind       = applePackage "libunwind"         "35.3"        "0miffaa41cv0lzf8az5k1j1ng8jvqvxcr4qrlkf3xyj479arbk1b" {};
    mDNSResponder   = applePackage "mDNSResponder"     "522.92.1"    "1cp87qda1s7brriv413i71yggm8yqfwv64vknrnqv24fcb8hzbmy" {};
    objc4           = applePackage "objc4"             "551.1"       "1jrdb6yyb5jwwj27c1r0nr2y2ihqjln8ynj61mpkvp144c1cm5bg" {};
    #objc4_pure      = applePackage "objc4/pure.nix"    "551.1"       "1jrdb6yyb5jwwj27c1r0nr2y2ihqjln8ynj61mpkvp144c1cm5bg" {};
    ppp             = applePackage "ppp"               "727.90.1"    "166xz1q7al12hm3q3drlp2r6fgdrsq3pmazjp3nsqg3vnglyh4gk" {};
    removefile      = applePackage "removefile"        "33"          "0ycvp7cnv40952a1jyhm258p6gg5xzh30x86z5gb204x80knw30y" {};
    Security        = applePackage "Security"          "55471.14.18" "1nv0dczf67dhk17hscx52izgdcyacgyy12ag0jh6nl5hmfzsn8yy" {};
    xnu             = applePackage "xnu"               "2422.115.4"  "1ssw5fzvgix20bw6y13c39ib0zs7ykpig3irlwbaccpjpci5jl0s" {};

    libsecurity_apple_csp      = libsecPackage "libsecurity_apple_csp"      "55003"    "1ngyn1ik27n4x981px3kfd1z1n8zx7r5w812b6qfjpy5nw4h746w" {};
    libsecurity_apple_cspdl    = libsecPackage "libsecurity_apple_cspdl"    "55000"    "1svqa5fhw7p7njzf8bzg7zgc5776aqjhdbnlhpwmr5hmz5i0x8r7" {};
    libsecurity_apple_file_dl  = libsecPackage "libsecurity_apple_file_dl"  "55000"    "1dfqani3n135i3iqmafc1k9awmz6s0a78zifhk15rx5a8ps870bl" {};
    libsecurity_apple_x509_cl  = libsecPackage "libsecurity_apple_x509_cl"  "55004"    "1gji2i080560s08k1nigsla1zdmi6slyv97xaj5vqxjpxb0g1xf5" {};
    libsecurity_apple_x509_tp  = libsecPackage "libsecurity_apple_x509_tp"  "55009.3"  "1bsms3nvi62wbvjviwjhjhzhylad8g6vmvlj3ngd0wyd0ywxrs46" {};
    libsecurity_asn1           = libsecPackage "libsecurity_asn1"           "55000.2"  "0i8aakjxdfj0lqcgqmbip32g7r4h57xhs8w0sxfvfl45q22s782w" {};
    libsecurity_cdsa_client    = libsecPackage "libsecurity_cdsa_client"    "55000"    "127jxnypkycy8zqwicfv333h11318m00gd37jnswbrpg44xd1wdy" {};
    libsecurity_cdsa_plugin    = libsecPackage "libsecurity_cdsa_plugin"    "55001"    "0ifmx85rs51i7zjm015s8kc2dqyrlvbr39lw9xzxgd2ds33i4lfj" {};
    libsecurity_cdsa_utilities = libsecPackage "libsecurity_cdsa_utilities" "55006"    "1kzsl0prvfa8a0m3j3pcxq06aix1csgayd3lzx27iqg84c8mhzan" {};
    libsecurity_cdsa_utils     = libsecPackage "libsecurity_cdsa_utils"     "55000"    "0q55jizav6n0lkj7lcmcr2mjdhnbnnn525fa9ipwgvzbspihw0g6" {};
    libsecurity_codesigning    = libsecPackage "libsecurity_codesigning"    "55037.15" "0vf5nj2g383b4hknlp51qll5pm8z4qbf56dnc16n3wm8gj82iasy" {};
    libsecurity_cssm           = libsecPackage "libsecurity_cssm"           "55005.5"  "0l6ia533bhr8kqp2wa712bnzzzisif3kbn7h3bzzf4nps4wmwzn4" {};
    libsecurity_filedb         = libsecPackage "libsecurity_filedb"         "55016.1"  "1r0ik95xapdl6l2lhd079vpq41jjgshz2hqb8490gpy5wyc49cxb" {};
    libsecurity_keychain       = libsecPackage "libsecurity_keychain"       "55050.9"  "15wf2slcgyns61kk7jndgm9h22vidyphh9x15x8viyprra9bkhja" {};
    libsecurity_mds            = libsecPackage "libsecurity_mds"            "55000"    "0vin5hnzvkx2rdzaaj2gxmx38amxlyh6j24a8gc22y09d74p5lzs" {};
    libsecurity_ocspd          = libsecPackage "libsecurity_ocspd"          "55010"    "1bxzpihc6w0ji4x8810a4lfkq83787yhjl60xm24bv1prhqcm73b" {};
    libsecurity_pkcs12         = libsecPackage "libsecurity_pkcs12"         "55000"    "1yq8p2sp39q40fxshb256b7jn9lvmpymgpm8yz9kqrf980xddgsg" {};
    libsecurity_sd_cspdl       = libsecPackage "libsecurity_sd_cspdl"       "55003"    "10v76xycfnvz1n0zqfbwn3yh4w880lbssqhkn23iim3ihxgm5pbd" {};
    libsecurity_utilities      = libsecPackage "libsecurity_utilities"      "55030.3"  "0ayycfy9jm0n0c7ih9f3m69ynh8hs80v8yicq47aa1h9wclbxg8r" {};
    libsecurityd               = libsecPackage "libsecurityd"               "55004"    "1ywm2qj8l7rhaxy5biwxsyavd0d09d4bzchm03nlvwl313p2747x" {};
    security_dotmac_tp         = libsecPackage "security_dotmac_tp"         "55107.1"  "1l4fi9qhrghj0pkvywi8da22bh06c5bv3l40a621b5g258na50pl" {};
  };
in packages
