{ stdenv, fetchurl, pkgs }:

let
  # This attrset can in theory be computed automatically, but for that to work nicely we need
  # import-from-derivation to work properly. Currently it's rather ugly when we try to bootstrap
  # a stdenv out of something like this. With some care we can probably get rid of this, but for
  # now it's staying here.
  versions = {
    "osx-10.11.2" = {
      dtrace = "168";
      xnu    = "3248.20.55";
    };
    "osx-10.10.5" = {
      adv_cmds      = "158";
      architecture  = "266";
      CF            = "1153.18";
      CommonCrypto  = "60061.30.1";
      copyfile      = "118.1.2";
      Csu           = "85";
      dyld          = "353.2.3";
      eap8021x      = "198.30.1";
      libauto       = "186";
      Libc          = "1044.40.1";
      libclosure    = "65";
      libdispatch   = "442.1.4";
      libiconv      = "42";
      Libinfo       = "459.40.1";
      Libnotify     = "133.1.1";
      libpthread    = "105.40.1";
      libresolv     = "57";
      Libsystem     = "1213";
      libunwind     = "35.3";
      libutil       = "38";
      mDNSResponder = "576.30.4";
      objc4         = "647";
      ppp           = "786.40.2";
      removefile    = "35";
      Security      = "57031.40.6";
      xnu           = "2782.40.9";

      IOAudioFamily                        = "203.3";
      IOFireWireFamily                     = "458";
      IOFWDVComponents                     = "207.4.1";
      IOFireWireAVC                        = "423";
      IOFireWireSBP2                       = "427";
      IOFireWireSerialBusProtocolTransport = "251.0.1";
      IOGraphics                           = "485.40.1";
      IOHIDFamily                          = "606.40.1";
      IONetworkingFamily                   = "101";
      IOSerialFamily                       = "74.20.1";
      IOStorageFamily                      = "182.1.1";
      IOBDStorageFamily                    = "14";
      IOCDStorageFamily                    = "51";
      IODVDStorageFamily                   = "35";
      IOKitUser                            = "1050.20.2";
    };
    "osx-10.9.5" = {
      CF                 = "855.17";
      launchd            = "842.92.1";
      libauto            = "185.5";
      Libc               = "997.90.3";
      libdispatch        = "339.92.1";
      libiconv           = "41";
      Libnotify          = "121.20.1";
      Libsystem          = "1197.1.1";
      objc4              = "551.1";
      Security           = "55471.14.18";
      security_dotmac_tp = "55107.1";
      xnu                = "2422.115.4";

      IOStorageFamily = "172";
    };
    "osx-10.8.5" = {
      configd     = "453.19";
      Libc        = "825.40.1";
      IOUSBFamily = "630.4.5";
    };
    "osx-10.8.4" = {
      IOUSBFamily = "560.4.2";
    };
    "osx-10.7.5" = {
      libsecurity_apple_csp      = "55003";
      libsecurity_apple_cspdl    = "55000";
      libsecurity_apple_file_dl  = "55000";
      libsecurity_apple_x509_cl  = "55004";
      libsecurity_apple_x509_tp  = "55009.3";
      libsecurity_asn1           = "55000.2";
      libsecurity_cdsa_client    = "55000";
      libsecurity_cdsa_plugin    = "55001";
      libsecurity_cdsa_utilities = "55006";
      libsecurity_cdsa_utils     = "55000";
      libsecurity_codesigning    = "55037.15";
      libsecurity_cssm           = "55005.5";
      libsecurity_filedb         = "55016.1";
      libsecurity_keychain       = "55050.9";
      libsecurity_mds            = "55000";
      libsecurity_ocspd          = "55010";
      libsecurity_pkcs12         = "55000";
      libsecurity_sd_cspdl       = "55003";
      libsecurity_utilities      = "55030.3";
      libsecurityd               = "55004";
    };
    "osx-10.7.4" = {
      Libm = "2026";
    };
    "osx-10.6.2" = {
      CarbonHeaders = "18.1";
    };
    "osx-10.5.8" = {
      adv_cmds = "119";
    };
    "osx-10.5" = {
      CoreOSMakeFiles = "40";
    };
    "dev-tools-7.0" = {
      bootstrap_cmds = "93";
    };
    "dev-tools-5.1" = {
      bootstrap_cmds = "86";
    };
    "dev-tools-3.2.6" = {
      bsdmake = "24";
    };
  };

  fetchApple = version: sha256: name: fetchurl {
    url = "http://www.opensource.apple.com/tarballs/${name}/${name}-${versions.${version}.${name}}.tar.gz";
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
    IOAudioFamily                        = fetchApple "osx-10.10.5" "0ggq7za3iq8g02j16rj67prqhrw828jsw3ah3bxq8a1cvr55aqnq";
    IOFireWireFamily                     = fetchApple "osx-10.10.5" "059qa1m668kwvchl90cqcx35b31zaqdg61zi11y1imn5s389y2g1";
    IOFWDVComponents                     = fetchApple "osx-10.10.5" "1brr0yn6mxgapw3bvlhyissfksifzj2mqsvj9vmps6zwcsxjfw7m";
    IOFireWireAVC                        = fetchApple "osx-10.10.5" "194an37gbqs9s5s891lmw6prvd1m2362602s8lj5m89fp9h8mbal";
    IOFireWireSBP2                       = fetchApple "osx-10.10.5" "1mym158kp46y1vfiq625b15ihh4jjbpimfm7d56wlw6l2syajqvi";
    IOFireWireSerialBusProtocolTransport = fetchApple "osx-10.10.5" "09kiq907qpk94zbij1mrcfcnyyc5ncvlxavxjrj4v5braxm78lhi";
    IOGraphics                           = fetchApple "osx-10.10.5" "1z0x3yrv0p8pfdqnvwf8rvrf9wip593lhm9q6yzbclz3fn53ad0p";
    IOHIDFamily                          = fetchApple "osx-10.10.5" "0yibagwk74imp3j3skjycm703s5ybdqw0qlsmnml6zwjpbrz5894";
    IONetworkingFamily                   = fetchApple "osx-10.10.5" "04as1hc8avncijf61mp9dmplz8vb1inhirkd1g74gah08lgrfs9j";
    IOSerialFamily                       = fetchApple "osx-10.10.5" "0jh12aanxcigqi9w6wqzbwjdin9m48zwrhdj3n4ki0h41sg89y91";
    IOStorageFamily                      = fetchApple "osx-10.9.5"  "0w5yr8ppl82anwph2zba0ppjji6ipf5x410zhcm1drzwn4bbkxrj";
    IOBDStorageFamily                    = fetchApple "osx-10.10.5" "1rbvmh311n853j5qb6hfda94vym9wkws5w736w2r7dwbrjyppc1q";
    IOCDStorageFamily                    = fetchApple "osx-10.10.5" "1905sxwmpxdcnm6yggklc5zimx1558ygm3ycj6b34f9h48xfxzgy";
    IODVDStorageFamily                   = fetchApple "osx-10.10.5" "1fv82rn199mi998l41c0qpnlp3irhqp2rb7v53pxbx7cra4zx3i6";
    # There should be an IOStreamFamily project here, but they haven't released it :(
    IOUSBFamily                          = fetchApple "osx-10.8.5"  "1znqb6frxgab9mkyv7csa08c26p9p0ip6hqb4wm9c7j85kf71f4j"; # This is from 10.8 :(
    IOUSBFamily_older                    = fetchApple "osx-10.8.4"  "113lmpz8n6sibd27p42h8bl7a6c3myc6zngwri7gnvf8qlajzyml" "IOUSBFamily"; # This is even older :(
    IOKitUser                            = fetchApple "osx-10.10.5" "1jzndziv97bhjxmla8nib5fpcswbvsxr04447g251ls81rw313lb";
    # There should be an IOVideo here, but they haven't released it :(
  };

  IOKitSrcs = stdenv.lib.mapAttrs (name: value: if builtins.isFunction value then value name else value) IOKitSpecs;

  adv_cmds = applePackage "adv_cmds" "osx-10.5.8" "102ssayxbg9wb35mdmhswbnw0bg7js3pfd8fcbic83c5q3bqa6c6" {};

  packages = {
    inherit (adv_cmds) ps locale;
    architecture    = applePackage "architecture"      "osx-10.10.5"     "0fc9s1f4mnzaixrmkkq9y8276g8i5grryh2dggi4h347i33kd097" {};
    bootstrap_cmds  = applePackage "bootstrap_cmds"    "dev-tools-7.0"   "1v5dv2q3af1xwj5kz0a5g54fd5dm6j4c9dd2g66n4kc44ixyrhp3" {};
    bsdmake         = applePackage "bsdmake"           "dev-tools-3.2.6" "11a9kkhz5bfgi1i8kpdkis78lhc6b5vxmhd598fcdgra1jw4iac2" {};
    CarbonHeaders   = applePackage "CarbonHeaders"     "osx-10.6.2"      "1zam29847cxr6y9rnl76zqmkbac53nx0szmqm9w5p469a6wzjqar" {};
    CF              = applePackage "CF"                "osx-10.9.5"      "1sadmxi9fsvsmdyxvg2133sdzvkzwil5fvyyidxsyk1iyfzqsvln" {};
    CommonCrypto    = applePackage "CommonCrypto"      "osx-10.10.5"     "0rm1r552i3mhyik2y3309dw90ap6vlhk583237jxfmdkip4c6mdr" {};
    configd         = applePackage "configd"           "osx-10.8.5"      "1gxakahk8gallf16xmhxhprdxkh3prrmzxnmxfvj0slr0939mmr2" {};
    copyfile        = applePackage "copyfile"          "osx-10.10.5"     "1s90wv9jsi6ismdnc1my3rxaa83k3s5ialrs5xlrmyb7s0pgvz7j" {};
    CoreOSMakefiles = applePackage "CoreOSMakefiles"   "osx-10.5"        "0kxp53spbn7109l7cvhi88pmfsi81lwmbws819b6wr3hm16v84f4" {};
    Csu             = applePackage "Csu"               "osx-10.10.5"     "0yh5mslyx28xzpv8qww14infkylvc1ssi57imhi471fs91sisagj" {};
    dtrace          = applePackage "dtrace"            "osx-10.10.5"     "0pp5x8dgvzmg9vvg32hpy2brm17dpmbwrcr4prsmdmfvd4767wcf" {};
    dtracen         = applePackage "dtrace"            "osx-10.11.2"     "04mi0jy8gy0w59rk9i9dqznysv6fzz1v5mq779s41cp308yi0h1c" {};
    dyld            = applePackage "dyld"              "osx-10.10.5"     "167f74ln8pmfimwn6kwh199ylvy3fw72fd15da94mf34ii0zar6k" {};
    eap8021x        = applePackage "eap8021x"          "osx-10.10.5"     "1f37dpbcgrd1b14nrv2lpqrkap74myjbparz9masx92df6kcn7l2" {};
    IOKit           = applePackage "IOKit"             "osx-10.10.5"     "0kcbrlyxcyirvg5p95hjd9k8a01k161zg0bsfgfhkb90kh2s8x0m" { inherit IOKitSrcs; };
    launchd         = applePackage "launchd"           "osx-10.9.5"      "0w30hvwqq8j5n90s3qyp0fccxflvrmmjnicjri4i1vd2g196jdgj" {};
    libauto         = applePackage "libauto"           "osx-10.9.5"      "17z27yq5d7zfkwr49r7f0vn9pxvj95884sd2k6lq6rfaz9gxqhy3" {};
    Libc            = applePackage "Libc"              "osx-10.9.5"      "1jz5bx9l4q484vn28c6n9b28psja3rpxiqbj6zwrwvlndzmq1yz5" {};
    Libc_old        = applePackage "Libc/825_40_1.nix" "osx-10.8.5"      "0xsx1im52gwlmcrv4lnhhhn9dyk5ci6g27k6yvibn9vj8fzjxwcf" {};
    libclosure      = applePackage "libclosure"        "osx-10.10.5"     "1zqy1zvra46cmqv6vsf1mcsz3a76r9bky145phfwh4ab6y15vjpq" {};
    libdispatch     = applePackage "libdispatch"       "osx-10.9.5"      "1lc5033cmkwxy3r26gh9plimxshxfcbgw6i0j7mgjlnpk86iy5bk" {};
    libiconv        = applePackage "libiconv"          "osx-10.9.5"      "0sni1gx6i2h7r4r4hhwbxdir45cp039m4wi74izh4l0pfw7gywad" {};
    Libinfo         = applePackage "Libinfo"           "osx-10.10.5"     "19n72s652rrqnc9hzlh4xq3h7xsfyjyklmcgyzyj0v0z68ww3z6h" {};
    Libm            = applePackage "Libm"              "osx-10.7.4"      "02sd82ig2jvvyyfschmb4gpz6psnizri8sh6i982v341x6y4ysl7" {};
    Libnotify       = applePackage "Libnotify"         "osx-10.9.5"      "164rx4za5z74s0mk9x0m1815r1m9kfal8dz3bfaw7figyjd6nqad" {};
    libpthread      = applePackage "libpthread"        "osx-10.10.5"     "1p2y6xvsfqyakivr6d48fgrd163b5m9r045cxyfwrf8w0r33nfn3" {};
    libresolv       = applePackage "libresolv"         "osx-10.10.5"     "0nvssf4qaqgs1dxwayzdy66757k99969f6c7n68n58n2yh6f5f6a" {};
    Libsystem       = applePackage "Libsystem"         "osx-10.9.5"      "1yfj2qdrf9vrzs7p9m4wlb7zzxcrim1gw43x4lvz4qydpp5kg2rh" {};
    libutil         = applePackage "libutil"           "osx-10.10.5"     "12gsvmj342n5d81kqwba68bmz3zf2757442g1sz2y5xmcapa3g5f" {};
    libunwind       = applePackage "libunwind"         "osx-10.10.5"     "0miffaa41cv0lzf8az5k1j1ng8jvqvxcr4qrlkf3xyj479arbk1b" {};
    mDNSResponder   = applePackage "mDNSResponder"     "osx-10.10.5"     "1h4jin7ya1ih7v0hksi7gfmbv767pv8wsyyv1qfy2xw36x8wnds7" {};
    objc4           = applePackage "objc4"             "osx-10.9.5"      "1jrdb6yyb5jwwj27c1r0nr2y2ihqjln8ynj61mpkvp144c1cm5bg" {};
    ppp             = applePackage "ppp"               "osx-10.10.5"     "01v7i0xds185glv8psvlffylfcfhbx1wgsfg74kx5rh3lyrigwrb" {};
    removefile      = applePackage "removefile"        "osx-10.10.5"     "1f2jw5irq6fz2jv5pag1w2ivfp8659v74f0h8kh0yx0rqw4asm33" {};
    Security        = applePackage "Security"          "osx-10.9.5"      "1nv0dczf67dhk17hscx52izgdcyacgyy12ag0jh6nl5hmfzsn8yy" {};
    xnu             = applePackage "xnu"               "osx-10.9.5"      "1ssw5fzvgix20bw6y13c39ib0zs7ykpig3irlwbaccpjpci5jl0s" {};

    # Pending work... we can't change the above packages in place because the bootstrap depends on them, so we detach the expressions
    # here so we can work on them.
    CF_new          = applePackage "CF/new.nix"          "osx-10.10.5"     "1sadmxi9fsvsmdyxvg2133sdzvkzwil50vyyidxsyk1iyfzqsvln" {};
    Libc_new        = applePackage "Libc/new.nix"        "osx-10.10.5"     "1jz5bx9l4q484vn08c6n9b28psja3rpxiqbj6zwrwvlndzmq1yz5" {};
    libdispatch_new = applePackage "libdispatch/new.nix" "osx-10.10.5"     "1lc5033cmkwxy0r26gh9plimxshxfcbgw6i0j7mgjlnpk86iy5bk" {};
    libiconv_new    = applePackage "libiconv/new.nix"    "osx-10.10.5"     "0sni1gx6i2h7r404hhwbxdir45cp039m4wi74izh4l0pfw7gywad" {};
    Libnotify_new   = applePackage "Libnotify/new.nix"   "osx-10.10.5"     "0sni1gx6i2h7r404hhwbxdir45cp039m4wi70izh4l0pfw7gywad" {};
    Libsystem_new   = applePackage "Libsystem/new.nix"   "osx-10.10.5"     "1yfj2qdrf9vrzs7p9m4wlb7zzxcrim10w43x4lvz4qydpp5kg2rh" {};
    objc4_new       = applePackage "objc4/new.nix"       "osx-10.10.5"     "0r0797ckmgv19if4i14dzyjh7i5klkm9jpacjif9v3rpycyyx1n3" {};
    xnu_new         = applePackage "xnu/new.nix"         "osx-10.11.2"     "1ax280jblz7laqam8fcwrffrrz26am10p1va9mlg9mklvbqarhqh" {};

    libsecurity_apple_csp      = libsecPackage "libsecurity_apple_csp"      "osx-10.7.5" "1ngyn1ik27n4x981px3kfd1z1n8zx7r5w812b6qfjpy5nw4h746w" {};
    libsecurity_apple_cspdl    = libsecPackage "libsecurity_apple_cspdl"    "osx-10.7.5" "1svqa5fhw7p7njzf8bzg7zgc5776aqjhdbnlhpwmr5hmz5i0x8r7" {};
    libsecurity_apple_file_dl  = libsecPackage "libsecurity_apple_file_dl"  "osx-10.7.5" "1dfqani3n135i3iqmafc1k9awmz6s0a78zifhk15rx5a8ps870bl" {};
    libsecurity_apple_x509_cl  = libsecPackage "libsecurity_apple_x509_cl"  "osx-10.7.5" "1gji2i080560s08k1nigsla1zdmi6slyv97xaj5vqxjpxb0g1xf5" {};
    libsecurity_apple_x509_tp  = libsecPackage "libsecurity_apple_x509_tp"  "osx-10.7.5" "1bsms3nvi62wbvjviwjhjhzhylad8g6vmvlj3ngd0wyd0ywxrs46" {};
    libsecurity_asn1           = libsecPackage "libsecurity_asn1"           "osx-10.7.5" "0i8aakjxdfj0lqcgqmbip32g7r4h57xhs8w0sxfvfl45q22s782w" {};
    libsecurity_cdsa_client    = libsecPackage "libsecurity_cdsa_client"    "osx-10.7.5" "127jxnypkycy8zqwicfv333h11318m00gd37jnswbrpg44xd1wdy" {};
    libsecurity_cdsa_plugin    = libsecPackage "libsecurity_cdsa_plugin"    "osx-10.7.5" "0ifmx85rs51i7zjm015s8kc2dqyrlvbr39lw9xzxgd2ds33i4lfj" {};
    libsecurity_cdsa_utilities = libsecPackage "libsecurity_cdsa_utilities" "osx-10.7.5" "1kzsl0prvfa8a0m3j3pcxq06aix1csgayd3lzx27iqg84c8mhzan" {};
    libsecurity_cdsa_utils     = libsecPackage "libsecurity_cdsa_utils"     "osx-10.7.5" "0q55jizav6n0lkj7lcmcr2mjdhnbnnn525fa9ipwgvzbspihw0g6" {};
    libsecurity_codesigning    = libsecPackage "libsecurity_codesigning"    "osx-10.7.5" "0vf5nj2g383b4hknlp51qll5pm8z4qbf56dnc16n3wm8gj82iasy" {};
    libsecurity_cssm           = libsecPackage "libsecurity_cssm"           "osx-10.7.5" "0l6ia533bhr8kqp2wa712bnzzzisif3kbn7h3bzzf4nps4wmwzn4" {};
    libsecurity_filedb         = libsecPackage "libsecurity_filedb"         "osx-10.7.5" "1r0ik95xapdl6l2lhd079vpq41jjgshz2hqb8490gpy5wyc49cxb" {};
    libsecurity_keychain       = libsecPackage "libsecurity_keychain"       "osx-10.7.5" "15wf2slcgyns61kk7jndgm9h22vidyphh9x15x8viyprra9bkhja" {};
    libsecurity_mds            = libsecPackage "libsecurity_mds"            "osx-10.7.5" "0vin5hnzvkx2rdzaaj2gxmx38amxlyh6j24a8gc22y09d74p5lzs" {};
    libsecurity_ocspd          = libsecPackage "libsecurity_ocspd"          "osx-10.7.5" "1bxzpihc6w0ji4x8810a4lfkq83787yhjl60xm24bv1prhqcm73b" {};
    libsecurity_pkcs12         = libsecPackage "libsecurity_pkcs12"         "osx-10.7.5" "1yq8p2sp39q40fxshb256b7jn9lvmpymgpm8yz9kqrf980xddgsg" {};
    libsecurity_sd_cspdl       = libsecPackage "libsecurity_sd_cspdl"       "osx-10.7.5" "10v76xycfnvz1n0zqfbwn3yh4w880lbssqhkn23iim3ihxgm5pbd" {};
    libsecurity_utilities      = libsecPackage "libsecurity_utilities"      "osx-10.7.5" "0ayycfy9jm0n0c7ih9f3m69ynh8hs80v8yicq47aa1h9wclbxg8r" {};
    libsecurityd               = libsecPackage "libsecurityd"               "osx-10.7.5" "1ywm2qj8l7rhaxy5biwxsyavd0d09d4bzchm03nlvwl313p2747x" {};
    security_dotmac_tp         = libsecPackage "security_dotmac_tp"         "osx-10.9.5" "1l4fi9qhrghj0pkvywi8da22bh06c5bv3l40a621b5g258na50pl" {};
  };
in packages
