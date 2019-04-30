{ stdenv, buildPackages, fetchurl, fetchzip, pkgs }:

let
  # This attrset can in theory be computed automatically, but for that to work nicely we need
  # import-from-derivation to work properly. Currently it's rather ugly when we try to bootstrap
  # a stdenv out of something like this. With some care we can probably get rid of this, but for
  # now it's staying here.
  #
  # https://gist.github.com/burke/2ca715c526ed36202e28b2a17ba46e92 may be useful to generate a list
  # of versions for a new release, and was used for 10.14.1.
  versions = {
    # Released October 2018, latest as of 2019-04-29
    "macos-10.14.1" = {
      CommonCrypto                         = "60118.220.1";  # 1hsv6pwx99b2bzacwrbkdm33rx4d5sga9aai1jhnl0dy9fd4hrvq
      Csu                                  = "85";           # 0yh5mslyx28xzpv8qww14infkylvc1ssi57imhi471fs91sisagj
      ICU                                  = "62108.0.1";    # 0hqsw6mnrm42p2w09r6kbkzxcyxgwkqxdp9djssi4jz1wbv71wrb
      IOAudioFamily                        = "206.5";        # 1lx0577vxwxmr60ilq8sblmc42jk60r5wdqkpl9iw68j63qa2ks4
      IOBDStorageFamily                    = "19";           # 0kd00rd37jcnx3j9q9qsx1b56hy6i1hnbjglgp1vqhg7cwq73s19
      IOCDStorageFamily                    = "58";           # 1ws0yr9ycvhav78qc0gqchisv3598n4mb9k2898cqgy2ncbivxyz
      IODVDStorageFamily                   = "42";           # 1xrj8v6bjcagnana58sq8amj1l87h5f9w5pi397wncyg7kbc8xwi
      IOFWDVComponents                     = "208";          # 0jy5gh8v8x5pflwrc2zhbq2crfny9jx5r6y86iqk2jnjsbq40wzp
      IOFireWireAVC                        = "426";          # 05iky2rdnfrvpgn9d78pmlf0fbxmaw3lkvpybv98hp8lg5948a18
      IOFireWireFamily                     = "473";          # 0jqhqj98h1q5v78nsy3f4rvnxb6vjk4r2w2xpmx2xyzkadvvp445
      IOFireWireSBP2                       = "428";          # 0iqmbh1rl4jl5j1pngynf1w37lnwlshwdrg6xvwfysccvdh7626x
      IOFireWireSerialBusProtocolTransport = "252.200.1";    # 040draw04kiw9w2vxmsvk4ax4w30fwrl0n9wa4jpb0rap8m6jsjs
      IOGraphics                           = "530.12";       # 1x2q2isx7v08d1m1ma496g9290qyl924axxh18jk80hzmxmdf05p
      IOHIDFamily                          = "1090.220.12";  # 1ns8s5kilh11cavn17qg3kvnwa0lz69nhp8l4pza8iw8xppajvn4
      IOKitUser                            = "1483.220.15";  # 1gjksrmg5iw7krpl4i1gk2fbfpq87z531yvf34rh52gakx41x1s5
      IONetworkingFamily                   = "129.200.1";    # 10hh6gpqsj4wkdh006b13h3vn4imxn1q6bir1wwkyi57v8aalhhm
      IOSerialFamily                       = "93.200.2";     # 0af2avsvy9sbp7czwbbw49sxxbggk5fbir2r9wmll62iqzh0wama
      IOStorageFamily                      = "218.200.3";    # 1zv2ca9nkshpk32iw8avkzjfhaz9y91aapjh7qwhp7z6y6lav0rf
      Libc                                 = "1272.200.26";  # 1c9gqhq36a1frpy7wxry2zbm9537r3pjn05fw6acznz3kb9krvml
      Libinfo                              = "517.200.9";    # 1ih9ici8dc786xaaj5qi00vhc8i5ndmkdlg0a6pr4rrpdabirw3y
      Libnotify                            = "172.200.21";   # 04s7rmdny624nv9vi5jha5wfhi6snp7yim2vlny83sbplz5g634y
      Librpcsvc                            = "26";           # 1zwfwcl9irxl1dlnf2b4v30vdybp0p0r6n6g1pd14zbdci1jcg2k
      Libsystem                            = "1252.200.5";   # 169v478dh8zk3l7yy8miim5is2984j615qlcb3ba0lra1drgcd0n
      PowerManagement                      = "733.221.1";    # 09559gy2sq6272hh2j0v6cf8fyrz2yw3jm73h2spgvqa9927cmaa
      Security                             = "58286.220.15"; # 1il04i7kq1gyls7rb2rvkdw181dpgf5pnx02z9pp5mf4g34n1sqb
      adv_cmds                             = "172";          # 10w01vds4k70rm1v6cv31kxzjkqc0xycz78xvlhylgp184jnxgk8
      architecture                         = "272.200.3";    # 0qglcmhnn96ibfhzk9l6yjminnvzcswrhfvhqjzw7b1vcmwgh3p4
      basic_cmds                           = "55";           # 0hvab4b1v5q2x134hdkal0rmz5gsdqyki1vb0dbw4py1bqf0yaw9
      configd                              = "963.200.27";   # 04mcj4vvfmqpwp756nb0lpmq5n963cw2xbx00wxabg4lhcn7v2sh
      copyfile                             = "146.200.3";    # 0msmb8lqicn835x4rqa05gdhycsx1m0lmb34ghph0qhc4sh9a6qm
      diskdev_cmds                         = "593.221.1";    # 01jh3pdc46sah5wrny708i00mi30xxz2k4cp6g1rf7cs43rc1cx9
      dtrace                               = "284.200.15";   # 01qfg70w2s1qmywbrra7h2m2y6fig61x93a81jkpdsp9fjcc100r
      dyld                                 = "635.2";        # 0dyx4xyl7rzavvizaym3jwxrfkwljkg6f6l8pjvp1d8cpxbg54g8
      eap8021x                             = "264.200.8";    # 14hqawac3cvmgw6y3bgf4lhqvslf3fyi5fzvws70r77726v5z6p8
      file_cmds                            = "272.220.1";    # 1n73pwmkqvh5waj2dwabal87b3xvipdy367j3yc7ci7ypxyg1mdx
      libauto                              = "187";          # 1v0drlaflgsm9k7l2lpv2ksy3l7c7i25z7hirqmc1mywzp776r0f
      libclosure                           = "73";           # 0fjbj2f0g1v078l3dmqvbi4csbjk4njkvr8wznbxr180ip2gki80
      libdispatch                          = "1008.220.2";   # 1qshl1qmyqsjn4zm7mmaq5f922y4xqxg6hwmwxjxkd3v88gf78xw
      libiconv                             = "51.200.6";     # 1kknbbfff9mrf5p5h94h0xk81k4b38mrkrmg82bz6iafznw359q8
      libplatform                          = "177.200.16";   # 0dhxm8l1ha09sfcj2lav0lc733finr2cbhrdm45g38vhfl3nn7nx
      libpthread                           = "330.220.2";    # 008h68rqfagfgm8vg0f9v92jdj7gp5g5i5jhv33a75zb5h696kw9
      libresolv                            = "65.200.2";     # 04qbxkpsiv06ximsdjkm0rraa34l5g9x5cvkzrfsfv6vd3vma2mb
      libunwind                            = "35.4";         # 0zadcp5gsjs8sxib9zy8k680zl1lbzf6vllwn5vb6gm3ayrgr82w
      libutil                              = "51.200.4";     # 17bbaic7hpmdh653z5958qjaq2yrh0srrn5pha2n578ary4ghcwa
      mDNSResponder                        = "878.200.35";   # 187mnglgdawass83jpp4nrx0c6g3xp8hl2c0rd91bszmvgbv8xz7
      network_cmds                         = "543.200.16";   # 17v1yzlwj5pgk79kpzm2sa2xxcrzbx1r1l323nf4j7mghqlqnn90
      objc4                                = "750.1";        # 0171cw7c011f8g2m1di2vjh59gy84x5dbpykax12svh7ji29r4yn
      ppp                                  = "847.200.5";    # 00g0q0v7j10qqi0dzsicvbxk3ax9hy5j5x7kwqwrysx4kvvxs2i9
      removefile                           = "45.200.2";     # 096rxlzp1wdprnwqcm4pblx3p9frmiqwp3aacvi9hcdb86fzjkms
      security_systemkeychain              = "55207.50.1";   # 15i2dbr0qliixwwayn842wamzhjmpbgndsghhpffq181x40hykqf
      shell_cmds                           = "203";          # 0yahpq873im8j5crh91ryya5glm675v17b4ykcz7wjyzz1d6a7lp
      system_cmds                          = "805.220.1";    # 1g8asbf2hjg2izlab1xqj8h8gzy7n4ak3hzll12wyk484712dhcc
      text_cmds                            = "99";           # 1f93m7dd0ghqb2hwh905mjhzblyfr7dwffw98xhgmv1mfdnigxg0
      top                                  = "111.220.1";    # 07yc3gkazzbdmag0297qm1favsvzb8kwwnk9pr467a1xjpchbl1m
      xnu                                  = "4903.221.2";   # 1szlwx53mk7w2ic7qzvi3cz25zcrhiwq6j7g2yr34i7xmimzd967
    };
    # Released July 2017
    "macos-10.12.6" = {
      # Latest releases as of 2019-04-29, not listed in 10.13 - 10.14.1
      security_dotmac_tp = "55107.1";
    };
    # Released July 2016
    "osx-10.11.6" = {
      # Latest release as of 2019-04-29, not listed in 10.12 - 10.14.1
      SmartCardServices = "55111";
    };
    # Released September 2014
    "osx-10.9.5" = {
      # Latest releases as of 2019-04-29, not listed in 10.10 - 10.14.1
      launchd = "842.92.1";
    };
    # Released September 2013
    "osx-10.8.5" = {
      # Used as Libc_old
      Libc = "825.40.1";
      # Latest releases as of 2019-04-29, not listed in 10.9 - 10.14.1
      IOUSBFamily = "630.4.5";
    };
    # Released June 2013
    "osx-10.8.4" = {
      # Used as IOUSBFamily_older. I'm not totally clear on why.
      IOUSBFamily = "560.4.2";
    };
    # Released September 2012
    "osx-10.7.5" = {
      # Latest releases as of 2019-04-29, not listed in 10.8 - 10.14.1 (all libsecurity* listed here)
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
    # Released May 2012
    "osx-10.7.4" = {
      # Latest release as of 2019-04-29, not listed in 10.7.5 - 10.14.1
      Libm = "2026";
    };
    # Released June 2011
    "osx-10.6.8" = {
      # Latest release as of 2019-04-29, not listed in 10.7 - 10.14.1
      CarbonHeaders = "18.1";
    };
    # Released August 2009
    "osx-10.5.8" = {
      # See adv_cmds/default.nix for justification explaining why we're using
      # this ancient version (I think? It actually seems to contradict itself
      # and a newer version may actually work).
      adv_cmds = "119";
    };

    # Released October 2018, latest as of 2019-04-29, corresponds to macOS 10.14.1.
    "dev-tools-10.1" = {
      developer_cmds = "66";            # 0q08m4cxxwph7gxqravmx13l418p1i050bd46zwksn9j9zpw9mlr
      bootstrap_cmds = "96.20.2.200.4"; # 18arr8dkph9aa1pp0k90akm3f1f1qn7n7wcxm44na2x91l6lkcfb
    };
    # Released October 2011, corresponds to OSX 10.7.2
    "dev-tools-4.2" = {
      # Latest release as of 2019-04-29, not listed in 4.3 - 10.1
      bsdmake = "24";
    };
  };

  fetchApple = version: sha256: name: let
    # When cross-compiling, fetchurl depends on libiconv, resulting
    # in an infinite recursion without this. It's not clear why this
    # worked fine when not cross-compiling
    fetch = if name == "libiconv"
      then stdenv.fetchurlBoot
      else fetchurl;
  in fetch {
    url = "http://www.opensource.apple.com/tarballs/${name}/${name}-${versions.${version}.${name}}.tar.gz";
    inherit sha256;
  };

  appleDerivation_ = name: version: sha256: attrs: stdenv.mkDerivation ({
    inherit version;
    name = "${name}-${version}";
    enableParallelBuilding = true;
    meta = {
      platforms = stdenv.lib.platforms.darwin;
    };
  } // (if attrs ? srcs then {} else {
    src  = fetchApple version sha256 name;
  }) // attrs);

  applePackage = namePath: version: sha256:
    let
      name = builtins.elemAt (stdenv.lib.splitString "/" namePath) 0;
      appleDerivation = appleDerivation_ name version sha256;
      callPackage = pkgs.newScope (packages // pkgs.darwin // { inherit appleDerivation name version; });
    in callPackage (./. + "/${namePath}");

  libsecPackage = pkgs.callPackage ./libsecurity_generic {
    inherit applePackage appleDerivation_;
  };

  IOKitSpecs = {
    IOAudioFamily                        = fetchApple "macos-10.14.1" "1lx0577vxwxmr60ilq8sblmc42jk60r5wdqkpl9iw68j63qa2ks4";
    IOFireWireFamily                     = fetchApple "macos-10.14.1" "0jqhqj98h1q5v78nsy3f4rvnxb6vjk4r2w2xpmx2xyzkadvvp445";
    IOFWDVComponents                     = fetchApple "macos-10.14.1" "0jy5gh8v8x5pflwrc2zhbq2crfny9jx5r6y86iqk2jnjsbq40wzp";
    IOFireWireAVC                        = fetchApple "macos-10.14.1" "05iky2rdnfrvpgn9d78pmlf0fbxmaw3lkvpybv98hp8lg5948a18";
    IOFireWireSBP2                       = fetchApple "macos-10.14.1" "0iqmbh1rl4jl5j1pngynf1w37lnwlshwdrg6xvwfysccvdh7626x";
    IOFireWireSerialBusProtocolTransport = fetchApple "macos-10.14.1" "040draw04kiw9w2vxmsvk4ax4w30fwrl0n9wa4jpb0rap8m6jsjs";
    IOGraphics                           = fetchApple "macos-10.14.1" "1x2q2isx7v08d1m1ma496g9290qyl924axxh18jk80hzmxmdf05p";
    IOHIDFamily                          = fetchApple "macos-10.14.1" "1ns8s5kilh11cavn17qg3kvnwa0lz69nhp8l4pza8iw8xppajvn4";
    IONetworkingFamily                   = fetchApple "macos-10.14.1" "10hh6gpqsj4wkdh006b13h3vn4imxn1q6bir1wwkyi57v8aalhhm";
    IOSerialFamily                       = fetchApple "macos-10.14.1" "0af2avsvy9sbp7czwbbw49sxxbggk5fbir2r9wmll62iqzh0wama";
    IOStorageFamily                      = fetchApple "macos-10.14.1" "1zv2ca9nkshpk32iw8avkzjfhaz9y91aapjh7qwhp7z6y6lav0rf";
    IOBDStorageFamily                    = fetchApple "macos-10.14.1" "0kd00rd37jcnx3j9q9qsx1b56hy6i1hnbjglgp1vqhg7cwq73s19";
    IOCDStorageFamily                    = fetchApple "macos-10.14.1" "1ws0yr9ycvhav78qc0gqchisv3598n4mb9k2898cqgy2ncbivxyz";
    IODVDStorageFamily                   = fetchApple "macos-10.14.1" "1xrj8v6bjcagnana58sq8amj1l87h5f9w5pi397wncyg7kbc8xwi";
    IOKitUser                            = fetchApple "macos-10.14.1" "1gjksrmg5iw7krpl4i1gk2fbfpq87z531yvf34rh52gakx41x1s5";

    # IOUSBFamily hasn't been released in a long while, so we provide two older versions.
    IOUSBFamily       = fetchApple "osx-10.8.5" "1znqb6frxgab9mkyv7csa08c26p9p0ip6hqb4wm9c7j85kf71f4j";
    IOUSBFamily_older = fetchApple "osx-10.8.4" "113lmpz8n6sibd27p42h8bl7a6c3myc6zngwri7gnvf8qlajzyml" "IOUSBFamily";

    # IOStreamFamily has not been released.
    # IOVideo has not been released.
  };

  IOKitSrcs = stdenv.lib.mapAttrs (name: value: if stdenv.lib.isFunction value then value name else value) IOKitSpecs;

  # It's not entirely clear to me why we're using an ancient version here.
  adv_cmds = applePackage "adv_cmds" "osx-10.5.8" "102ssayxbg9wb35mdmhswbnw0bg7js3pfd8fcbic83c5q3bqa6c6" {};

  packages = {
    SmartCardServices = applePackage "SmartCardServices" "osx-10.11.6" "1qqjlbi6j37mw9p3qpfnwf14xh9ff8h5786bmvzwc4kblfglabkm" {};

    inherit (adv_cmds) ps locale;
    architecture   = applePackage "architecture"     "macos-10.14.1"   "0qglcmhnn96ibfhzk9l6yjminnvzcswrhfvhqjzw7b1vcmwgh3p4" {};
    bootstrap_cmds = applePackage "bootstrap_cmds"   "dev-tools-10.1"  "1v5dv2q3af1xwj5kz0a5g54fd5dm6j4c9dd2g66n4kc44ixyrhp3" {};
    bsdmake        = applePackage "bsdmake"          "dev-tools-3.2.6" "11a9kkhz5bfgi1i8kpdkis78lhc6b5vxmhd598fcdgra1jw4iac2" {};
    CarbonHeaders  = applePackage "CarbonHeaders"    "osx-10.6.8"      "1zam29847cxr6y9rnl76zqmkbac53nx0szmqm9w5p469a6wzjqar" {};
    CommonCrypto   = applePackage "CommonCrypto"     "macos-10.14.1"   "1hsv6pwx99b2bzacwrbkdm33rx4d5sga9aai1jhnl0dy9fd4hrvq" {};
    configd        = applePackage "configd"          "macos-10.14.1"   "04mcj4vvfmqpwp756nb0lpmq5n963cw2xbx00wxabg4lhcn7v2sh" {};
    copyfile       = applePackage "copyfile"         "macos-10.14.1"   "0msmb8lqicn835x4rqa05gdhycsx1m0lmb34ghph0qhc4sh9a6qm" {};
    Csu            = applePackage "Csu"              "macos-10.14.1"   "0yh5mslyx28xzpv8qww14infkylvc1ssi57imhi471fs91sisagj" {};
    dtrace         = applePackage "dtrace"           "macos-10.14.1"   "01qfg70w2s1qmywbrra7h2m2y6fig61x93a81jkpdsp9fjcc100r" {};
    dtrace-xcode   = applePackage "dtrace/xcode.nix" "macos-10.14.1"   "01qfg70w2s1qmywbrra7h2m2y6fig61x93a81jkpdsp9fjcc100r" {};
    dyld           = applePackage "dyld"             "macos-10.14.1"   "0dyx4xyl7rzavvizaym3jwxrfkwljkg6f6l8pjvp1d8cpxbg54g8" {};
    eap8021x       = applePackage "eap8021x"         "macos-10.14.1"   "14hqawac3cvmgw6y3bgf4lhqvslf3fyi5fzvws70r77726v5z6p8" {};
    ICU            = applePackage "ICU"              "macos-10.14.1"   "0hqsw6mnrm42p2w09r6kbkzxcyxgwkqxdp9djssi4jz1wbv71wrb" {};

    # TODO(burke): sum will need update
    IOKit   = applePackage "IOKit"   "macos-10.14.1" "0kcbrlyxcyirvg5p95hjd9k8a01k161zg0bsfgfhkb90kh2s8x00" { inherit IOKitSrcs; };
    launchd = applePackage "launchd" "osx-10.9.5"    "0w30hvwqq8j5n90s3qyp0fccxflvrmmjnicjri4i1vd2g196jdgj" {};
    libauto = applePackage "libauto" "macos-10.14.1" "1v0drlaflgsm9k7l2lpv2ksy3l7c7i25z7hirqmc1mywzp776r0f" {};
    # TODO(burke): What.
    Libc            = applePackage "Libc"              "osx-10.11.5"     "1qv7r0dgz06jy9i5agbqzxgdibb0m8ylki6g5n5pary88lzrawfd" {
      Libc_10-9 = fetchzip {
        url    = "http://www.opensource.apple.com/tarballs/Libc/Libc-997.90.3.tar.gz";
        sha256 = "1xchgxkxg5288r2b9yfrqji2gsgdap92k4wx2dbjwslixws12pq7";
      };
    };
    Libc_old        = applePackage "Libc/825_40_1.nix"  "osx-10.8.5"     "0xsx1im52gwlmcrv4lnhhhn9dyk5ci6g27k6yvibn9vj8fzjxwcf" {};
    libclosure      = applePackage "libclosure"         "macos-10.14.1"  "0fjbj2f0g1v078l3dmqvbi4csbjk4njkvr8wznbxr180ip2gki80" {};
    libdispatch     = applePackage "libdispatch"        "macos-10.14.1"  "1qshl1qmyqsjn4zm7mmaq5f922y4xqxg6hwmwxjxkd3v88gf78xw" {};
    libiconv        = applePackage "libiconv"           "macos-10.14.1"  "1kknbbfff9mrf5p5h94h0xk81k4b38mrkrmg82bz6iafznw359q8" {};
    Libinfo         = applePackage "Libinfo"            "macos-10.14.1"  "1ih9ici8dc786xaaj5qi00vhc8i5ndmkdlg0a6pr4rrpdabirw3y" {};
    Libm            = applePackage "Libm"               "osx-10.7.4"     "02sd82ig2jvvyyfschmb4gpz6psnizri8sh6i982v341x6y4ysl7" {};
    Libnotify       = applePackage "Libnotify"          "macos-10.14.1"  "04s7rmdny624nv9vi5jha5wfhi6snp7yim2vlny83sbplz5g634y" {};
    libplatform     = applePackage "libplatform"        "macos-10.14.1"  "0dhxm8l1ha09sfcj2lav0lc733finr2cbhrdm45g38vhfl3nn7nx" {};
    libpthread      = applePackage "libpthread"         "macos-10.14.1"  "008h68rqfagfgm8vg0f9v92jdj7gp5g5i5jhv33a75zb5h696kw9" {};
    libresolv       = applePackage "libresolv"          "macos-10.14.1"  "04qbxkpsiv06ximsdjkm0rraa34l5g9x5cvkzrfsfv6vd3vma2mb" {};
    Libsystem       = applePackage "Libsystem"          "macos-10.14.1"  "169v478dh8zk3l7yy8miim5is2984j615qlcb3ba0lra1drgcd0n" {};
    libutil         = applePackage "libutil"            "macos-10.14.1"  "17bbaic7hpmdh653z5958qjaq2yrh0srrn5pha2n578ary4ghcwa" {};
    libutil-new     = applePackage "libutil/new.nix"    "macos-10.14.1"  "17bbaic7hpmdh653z5958qjaq2yrh0srrn5pha2n578ary4ghcwa" {};
    libunwind       = applePackage "libunwind"          "macos-10.14.1"  "0zadcp5gsjs8sxib9zy8k680zl1lbzf6vllwn5vb6gm3ayrgr82w" {};
    mDNSResponder   = applePackage "mDNSResponder"      "macos-10.14.1"  "187mnglgdawass83jpp4nrx0c6g3xp8hl2c0rd91bszmvgbv8xz7" {};
    objc4           = applePackage "objc4"              "macos-10.14.1"  "0171cw7c011f8g2m1di2vjh59gy84x5dbpykax12svh7ji29r4yn" {};
    ppp             = applePackage "ppp"                "macos-10.14.1"  "00g0q0v7j10qqi0dzsicvbxk3ax9hy5j5x7kwqwrysx4kvvxs2i9" {};
    removefile      = applePackage "removefile"         "macos-10.14.1"  "096rxlzp1wdprnwqcm4pblx3p9frmiqwp3aacvi9hcdb86fzjkms" {};
    Security        = applePackage "Security"           "macos-10.14.1"  "1il04i7kq1gyls7rb2rvkdw181dpgf5pnx02z9pp5mf4g34n1sqb" {};
    xnu             = applePackage "xnu"                "macos-10.14.1"  "1szlwx53mk7w2ic7qzvi3cz25zcrhiwq6j7g2yr34i7xmimzd967" {};
    Librpcsvc       = applePackage "Librpcsvc"          "macos-10.14.1"  "1zwfwcl9irxl1dlnf2b4v30vdybp0p0r6n6g1pd14zbdci1jcg2k" {};
    adv_cmds        = applePackage "adv_cmds/xcode.nix" "macos-10.14.1"  "10w01vds4k70rm1v6cv31kxzjkqc0xycz78xvlhylgp184jnxgk8" {};
    basic_cmds      = applePackage "basic_cmds"         "macos-10.14.1"  "0hvab4b1v5q2x134hdkal0rmz5gsdqyki1vb0dbw4py1bqf0yaw9" {};
    developer_cmds  = applePackage "developer_cmds"     "dev-tools-10.1" "0q08m4cxxwph7gxqravmx13l418p1i050bd46zwksn9j9zpw9mlr" {};
    diskdev_cmds    = applePackage "diskdev_cmds"       "macos-10.14.1"  "01jh3pdc46sah5wrny708i00mi30xxz2k4cp6g1rf7cs43rc1cx9" {};
    network_cmds    = applePackage "network_cmds"       "macos-10.14.1"  "17v1yzlwj5pgk79kpzm2sa2xxcrzbx1r1l323nf4j7mghqlqnn90" {};
    file_cmds       = applePackage "file_cmds"          "macos-10.14.1"  "1n73pwmkqvh5waj2dwabal87b3xvipdy367j3yc7ci7ypxyg1mdx" {};
    shell_cmds      = applePackage "shell_cmds"         "macos-10.14.1"  "0yahpq873im8j5crh91ryya5glm675v17b4ykcz7wjyzz1d6a7lp" {};
    system_cmds     = applePackage "system_cmds"        "macos-10.14.1"  "1g8asbf2hjg2izlab1xqj8h8gzy7n4ak3hzll12wyk484712dhcc" {};
    text_cmds       = applePackage "text_cmds"          "macos-10.14.1"  "1f93m7dd0ghqb2hwh905mjhzblyfr7dwffw98xhgmv1mfdnigxg0" {};
    top             = applePackage "top"                "macos-10.14.1"  "07yc3gkazzbdmag0297qm1favsvzb8kwwnk9pr467a1xjpchbl1m" {};
    PowerManagement = applePackage "PowerManagement"    "macos-10.14.1"  "09559gy2sq6272hh2j0v6cf8fyrz2yw3jm73h2spgvqa9927cmaa" {};

    security_systemkeychain = applePackage "security_systemkeychain" "macos-10.14.1" "0xviskdgxsail15npi0billyiysvljlmg38mmhnr7qi4ymnnjr90" {};

    libsecurity_apple_csp      = libsecPackage "libsecurity_apple_csp"      "osx-10.7.5"    "1ngyn1ik27n4x981px3kfd1z1n8zx7r5w812b6qfjpy5nw4h746w" {};
    libsecurity_apple_cspdl    = libsecPackage "libsecurity_apple_cspdl"    "osx-10.7.5"    "1svqa5fhw7p7njzf8bzg7zgc5776aqjhdbnlhpwmr5hmz5i0x8r7" {};
    libsecurity_apple_file_dl  = libsecPackage "libsecurity_apple_file_dl"  "osx-10.7.5"    "1dfqani3n135i3iqmafc1k9awmz6s0a78zifhk15rx5a8ps870bl" {};
    libsecurity_apple_x509_cl  = libsecPackage "libsecurity_apple_x509_cl"  "osx-10.7.5"    "1gji2i080560s08k1nigsla1zdmi6slyv97xaj5vqxjpxb0g1xf5" {};
    libsecurity_apple_x509_tp  = libsecPackage "libsecurity_apple_x509_tp"  "osx-10.7.5"    "1bsms3nvi62wbvjviwjhjhzhylad8g6vmvlj3ngd0wyd0ywxrs46" {};
    libsecurity_asn1           = libsecPackage "libsecurity_asn1"           "osx-10.7.5"    "0i8aakjxdfj0lqcgqmbip32g7r4h57xhs8w0sxfvfl45q22s782w" {};
    libsecurity_cdsa_client    = libsecPackage "libsecurity_cdsa_client"    "osx-10.7.5"    "127jxnypkycy8zqwicfv333h11318m00gd37jnswbrpg44xd1wdy" {};
    libsecurity_cdsa_plugin    = libsecPackage "libsecurity_cdsa_plugin"    "osx-10.7.5"    "0ifmx85rs51i7zjm015s8kc2dqyrlvbr39lw9xzxgd2ds33i4lfj" {};
    libsecurity_cdsa_utilities = libsecPackage "libsecurity_cdsa_utilities" "osx-10.7.5"    "1kzsl0prvfa8a0m3j3pcxq06aix1csgayd3lzx27iqg84c8mhzan" {};
    libsecurity_cdsa_utils     = libsecPackage "libsecurity_cdsa_utils"     "osx-10.7.5"    "0q55jizav6n0lkj7lcmcr2mjdhnbnnn525fa9ipwgvzbspihw0g6" {};
    libsecurity_codesigning    = libsecPackage "libsecurity_codesigning"    "osx-10.7.5"    "0vf5nj2g383b4hknlp51qll5pm8z4qbf56dnc16n3wm8gj82iasy" {};
    libsecurity_cssm           = libsecPackage "libsecurity_cssm"           "osx-10.7.5"    "0l6ia533bhr8kqp2wa712bnzzzisif3kbn7h3bzzf4nps4wmwzn4" {};
    libsecurity_filedb         = libsecPackage "libsecurity_filedb"         "osx-10.7.5"    "1r0ik95xapdl6l2lhd079vpq41jjgshz2hqb8490gpy5wyc49cxb" {};
    libsecurity_keychain       = libsecPackage "libsecurity_keychain"       "osx-10.7.5"    "15wf2slcgyns61kk7jndgm9h22vidyphh9x15x8viyprra9bkhja" {};
    libsecurity_mds            = libsecPackage "libsecurity_mds"            "osx-10.7.5"    "0vin5hnzvkx2rdzaaj2gxmx38amxlyh6j24a8gc22y09d74p5lzs" {};
    libsecurity_ocspd          = libsecPackage "libsecurity_ocspd"          "osx-10.7.5"    "1bxzpihc6w0ji4x8810a4lfkq83787yhjl60xm24bv1prhqcm73b" {};
    libsecurity_pkcs12         = libsecPackage "libsecurity_pkcs12"         "osx-10.7.5"    "1yq8p2sp39q40fxshb256b7jn9lvmpymgpm8yz9kqrf980xddgsg" {};
    libsecurity_sd_cspdl       = libsecPackage "libsecurity_sd_cspdl"       "osx-10.7.5"    "10v76xycfnvz1n0zqfbwn3yh4w880lbssqhkn23iim3ihxgm5pbd" {};
    libsecurity_utilities      = libsecPackage "libsecurity_utilities"      "osx-10.7.5"    "0ayycfy9jm0n0c7ih9f3m69ynh8hs80v8yicq47aa1h9wclbxg8r" {};
    libsecurityd               = libsecPackage "libsecurityd"               "osx-10.7.5"    "1ywm2qj8l7rhaxy5biwxsyavd0d09d4bzchm03nlvwl313p2747x" {};
    security_dotmac_tp         = libsecPackage "security_dotmac_tp"         "macos-10.12.6" "1l4fi9qhrghj0pkvywi8da22bh06c5bv3l40a621b5g258na50pl" {};
  };
in packages
