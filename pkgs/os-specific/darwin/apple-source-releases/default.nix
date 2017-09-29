{ stdenv, fetchurl, fetchzip, pkgs, fetchurlBoot }:

let
  # This attrset can in theory be computed automatically, but for that to work nicely we need
  # import-from-derivation to work properly. Currently it's rather ugly when we try to bootstrap
  # a stdenv out of something like this. With some care we can probably get rid of this, but for
  # now it's staying here.
  versions = {
    "osx-10.11.6" = {
      dtrace        = "168";
      xnu           = "3248.60.10";
      libpthread    = "138.10.4";
      libiconv      = "44";
      Libnotify     = "150.40.1";
      objc4         = "680";
      eap8021x      = "222.40.1";
      dyld          = "360.22";
      architecture  = "268";
      CommonCrypto  = "60075.50.1";
      copyfile      = "127";
      Csu           = "85";
      ppp           = "809.50.2";
      libclosure    = "65";
      Libinfo       = "477.50.4";
      Libsystem     = "1226.10.1";
      removefile    = "41";
      libresolv     = "60";

      # Their release page is a bit of a mess here, so I'm going to lie a bit and say this version
      # is the right one, even though it isn't. The version I have here doesn't appear to be linked
      # to any OS releases, but Apple also doesn't mention mDNSResponder from 10.11 to 10.11.6, and
      # neither of those versions are publicly available.
      libplatform   = "125";
      mDNSResponder = "625.41.2";

      libutil       = "43";
      libunwind     = "35.3";
      Librpcsvc     = "26";
      developer_cmds= "62";
      network_cmds  = "481.20.1";
      basic_cmds    = "55";
      adv_cmds      = "163";
      file_cmds     = "264.1.1";
      shell_cmds    = "187";
    };
    "osx-10.11.5" = {
      Libc          = "1082.50.1"; # 10.11.6 still unreleased :/
    };
    "osx-10.10.5" = {
      adv_cmds      = "158";
      CF            = "1153.18";
      ICU           = "531.48";
      libdispatch   = "442.1.4";
      Security      = "57031.40.6";

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
      launchd            = "842.92.1";
      libauto            = "185.5";
      Libc               = "997.90.3"; # We use this, but not from here
      Libsystem          = "1197.1.1";
      Security           = "55471.14.18";
      security_dotmac_tp = "55107.1";

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

  fetchApple = version: sha256: name: let
    # When cross-compiling, fetchurl depends on libiconv, resulting
    # in an infinite recursion without this. It's not clear why this
    # worked fine when not cross-compiling
    fetch = if name == "libiconv"
      then fetchurlBoot
      else fetchurl;
  in fetch {
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
    architecture    = applePackage "architecture"      "osx-10.11.6"     "1pbpjcd7is69hn8y29i98ci0byik826if8gnp824ha92h90w0fq3" {};
    bootstrap_cmds  = applePackage "bootstrap_cmds"    "dev-tools-7.0"   "1v5dv2q3af1xwj5kz0a5g54fd5dm6j4c9dd2g66n4kc44ixyrhp3" {};
    bsdmake         = applePackage "bsdmake"           "dev-tools-3.2.6" "11a9kkhz5bfgi1i8kpdkis78lhc6b5vxmhd598fcdgra1jw4iac2" {};
    CarbonHeaders   = applePackage "CarbonHeaders"     "osx-10.6.2"      "1zam29847cxr6y9rnl76zqmkbac53nx0szmqm9w5p469a6wzjqar" {};
    CF              = applePackage "CF"                "osx-10.10.5"     "07f5psjxi7wyd13ci4x83ya5hy6p69sjfqcpp2mmxdlhd8yzkf74" {};
    CommonCrypto    = applePackage "CommonCrypto"      "osx-10.11.6"     "0vllfpb8f4f97wj2vpdd7w5k9ibnsbr6ff1zslpp6q323h01n25y" {};
    configd         = applePackage "configd"           "osx-10.8.5"      "1gxakahk8gallf16xmhxhprdxkh3prrmzxnmxfvj0slr0939mmr2" {};
    copyfile        = applePackage "copyfile"          "osx-10.11.6"     "1rkf3iaxmjz5ycgrmf0g971kh90jb2z1zqxg5vlqz001s4y457gs" {};
    Csu             = applePackage "Csu"               "osx-10.11.6"     "0yh5mslyx28xzpv8qww14infkylvc1ssi57imhi471fs91sisagj" {};
    dtrace          = applePackage "dtrace"            "osx-10.11.6"     "0pp5x8dgvzmg9vvg32hpy2brm17dpmbwrcr4prsmdmfvd4767wc0" {};
    dyld            = applePackage "dyld"              "osx-10.11.6"     "0qkjmjazm2zpgvwqizhandybr9cm3gz9pckx8rmf0py03faafc08" {};
    eap8021x        = applePackage "eap8021x"          "osx-10.11.6"     "0iw0qdib59hihyx2275rwq507bq2a06gaj8db4a8z1rkaj1frskh" {};
    ICU             = applePackage "ICU"               "osx-10.10.5"     "1qihlp42n5g4dl0sn0f9pc0bkxy1452dxzf0vr6y5gqpshlzy03p" {};
    IOKit           = applePackage "IOKit"             "osx-10.11.6"     "0kcbrlyxcyirvg5p95hjd9k8a01k161zg0bsfgfhkb90kh2s8x00" { inherit IOKitSrcs; };
    launchd         = applePackage "launchd"           "osx-10.9.5"      "0w30hvwqq8j5n90s3qyp0fccxflvrmmjnicjri4i1vd2g196jdgj" {};
    libauto         = applePackage "libauto"           "osx-10.9.5"      "17z27yq5d7zfkwr49r7f0vn9pxvj95884sd2k6lq6rfaz9gxqhy3" {};
    Libc            = applePackage "Libc"              "osx-10.11.5"     "1qv7r0dgz06jy9i5agbqzxgdibb0m8ylki6g5n5pary88lzrawfd" {
      Libc_10-9 = fetchzip {
        url    = "http://www.opensource.apple.com/tarballs/Libc/Libc-997.90.3.tar.gz";
        sha256 = "1xchgxkxg5288r2b9yfrqji2gsgdap92k4wx2dbjwslixws12pq7";
      };
    };
    Libc_old        = applePackage "Libc/825_40_1.nix" "osx-10.8.5"      "0xsx1im52gwlmcrv4lnhhhn9dyk5ci6g27k6yvibn9vj8fzjxwcf" {};
    libclosure      = applePackage "libclosure"        "osx-10.11.6"     "1zqy1zvra46cmqv6vsf1mcsz3a76r9bky145phfwh4ab6y15vjpq" {};
    libdispatch     = applePackage "libdispatch"       "osx-10.10.5"     "0jsfbzp87lwk9snlby0hd4zvj7j894p5q3cw0wdx9ny1mcp3kdcj" {};
    libiconv        = applePackage "libiconv"          "osx-10.11.6"     "11h6lfajydri4widis62q8scyz7z8l6msqyx40ly4ahsdlbl0981" {};
    Libinfo         = applePackage "Libinfo"           "osx-10.11.6"     "0qjgkd4y8sjvwjzv5wwyzkb61pg8wwg95bkp721dgzv119dqhr8x" {};
    Libm            = applePackage "Libm"              "osx-10.7.4"      "02sd82ig2jvvyyfschmb4gpz6psnizri8sh6i982v341x6y4ysl7" {};
    Libnotify       = applePackage "Libnotify"         "osx-10.11.6"     "0zbcyxlcfhf91jxczhd5bq9qfgvg494gwwp3l7q5ayb2qdihzr8b" {};
    libplatform     = applePackage "libplatform"       "osx-10.11.6"     "1v4ik6vlklwsi0xb1g5kmhy29j9xk5m2y8xb9zbi1k4ng8x39czk" {};
    libpthread      = applePackage "libpthread"        "osx-10.11.6"     "1kbw738cmr9pa7pz1igmajs307clfq7gv2vm1sqdzhcnnjxbl28w" {};
    libresolv       = applePackage "libresolv"         "osx-10.11.6"     "09flfdi3dlzq0yap32sxidacpc4nn4va7z12a6viip21ix2xb2gf" {};
    Libsystem       = applePackage "Libsystem"         "osx-10.11.6"     "1nfkmbqml587v2s1d1y2s2v8nmr577jvk51y6vqrfvsrhdhc2w94" {};
    libutil         = applePackage "libutil"           "osx-10.11.6"     "1gmgmcyqdyc684ih7dimdmxdljnq7mzjy5iqbf589wc0pa8h5abm" {};
    libunwind       = applePackage "libunwind"         "osx-10.11.6"     "0miffaa41cv0lzf8az5k1j1ng8jvqvxcr4qrlkf3xyj479arbk1b" {};
    mDNSResponder   = applePackage "mDNSResponder"     "osx-10.11.6"     "069incq28a78yh1bnr17h9cd5if5mwqpq8ahnkyxxx25fkaxgzcf" {};
    objc4           = applePackage "objc4"             "osx-10.11.6"     "00b7vbgxni8frrqyi69b4njjihlwydzjd9zj9x4z5dbx8jabkvrj" {};
    ppp             = applePackage "ppp"               "osx-10.11.6"     "1dql6r1v0vbcs04958nn2i6p31yfsxyy51jca63bm5mf0gxalk3f" {};
    removefile      = applePackage "removefile"        "osx-10.11.6"     "1b6r74ry3k01kypvlaclf33fha15pcm0kzx9zrymlg66wg0s0i3r" {};
    Security        = applePackage "Security"          "osx-10.9.5"      "1nv0dczf67dhk17hscx52izgdcyacgyy12ag0jh6nl5hmfzsn8yy" {};
    xnu             = applePackage "xnu"               "osx-10.11.6"     "0yhziq4dqqcbjpf6vyqn8xhwva2zb525gndkx8cp8alzwp76jnr9" {};
    Librpcsvc       = applePackage "Librpcsvc"         "osx-10.11.6"     "1zwfwcl9irxl1dlnf2b4v30vdybp0p0r6n6g1pd14zbdci1jcg2k" {};
    adv_cmds        = applePackage "adv_cmds/xcode.nix" "osx-10.11.6"    "12gbv35i09aij9g90p6b3x2f3ramw43qcb2gjrg8lzkzmwvcyw9q" {};
    basic_cmds      = applePackage "basic_cmds"        "osx-10.11.6"     "0hvab4b1v5q2x134hdkal0rmz5gsdqyki1vb0dbw4py1bqf0yaw9" {};
    developer_cmds  = applePackage "developer_cmds"    "osx-10.11.6"     "1r9c2b6dcl22diqf90x58psvz797d3lxh4r2wppr7lldgbgn24di" {};
    network_cmds    = applePackage "network_cmds"      "osx-10.11.6"     "0lhi9wz84qr1r2ab3fb4nvmdg9gxn817n5ldg7zw9gnf3wwn42kw" {};
    file_cmds       = applePackage "file_cmds"         "osx-10.11.6"     "1zfxbmasps529pnfdjvc13p7ws2cfx8pidkplypkswyff0nff4wp" {};
    shell_cmds      = applePackage "shell_cmds"        "osx-10.11.6"     "0084k271v66h4jqp7q7rmjvv7w4mvhx3aq860qs8jbd30canm86n" {};

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
