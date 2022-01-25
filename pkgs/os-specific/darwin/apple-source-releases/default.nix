{ lib, stdenv, fetchurl, fetchzip, pkgs }:

let
  # This attrset can in theory be computed automatically, but for that to work nicely we need
  # import-from-derivation to work properly. Currently it's rather ugly when we try to bootstrap
  # a stdenv out of something like this. With some care we can probably get rid of this, but for
  # now it's staying here.
  versions = {
    "osx-10.12.6" = {
      xnu           = "3789.70.16";
      libiconv      = "50";
      Libnotify     = "165.20.1";
      objc4         = "709.1";
      dyld          = "433.5";
      CommonCrypto  = "60092.50.5";
      copyfile      = "138";
      ppp           = "838.50.1";
      libclosure    = "67";
      Libinfo       = "503.50.4";
      Libsystem     = "1238.60.2";
      removefile    = "45";
      libresolv     = "64";
      libplatform   = "126.50.8";
      mDNSResponder = "765.50.9";
      libutil       = "47.30.1";
      libunwind     = "35.3";
      Libc          = "1158.50.2";
      dtrace        = "209.50.12";
      libpthread    = "218.60.3";
      hfs           = "366.70.1";
    };
    "osx-10.11.6" = {
      PowerManagement = "572.50.1";
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

      # IOKit contains a set of packages with different versions, so we don't have a general version
      IOKit         = "";

      libutil       = "43";
      libunwind     = "35.3";
      Librpcsvc     = "26";
      developer_cmds= "62";
      network_cmds  = "481.20.1";
      basic_cmds    = "55";
      adv_cmds      = "163";
      file_cmds     = "264.1.1";
      shell_cmds    = "187";
      system_cmds   = "550.6";
      diskdev_cmds   = "593";
      top           = "108";
      text_cmds     = "99";
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

  fetchApple' = pname: version: sha256: let
    # When cross-compiling, fetchurl depends on libiconv, resulting
    # in an infinite recursion without this. It's not clear why this
    # worked fine when not cross-compiling
    fetch = if pname == "libiconv"
      then stdenv.fetchurlBoot
      else fetchurl;
  in fetch {
    url = "http://www.opensource.apple.com/tarballs/${pname}/${pname}-${version}.tar.gz";
    inherit sha256;
  };

  fetchApple = sdkName: sha256: pname: let
    version = versions.${sdkName}.${pname};
  in fetchApple' pname version sha256;

  appleDerivation'' = stdenv: pname: version: sdkName: sha256: attrs: stdenv.mkDerivation ({
    inherit pname version;

    src = if attrs ? srcs then null else (fetchApple' pname version sha256);

    enableParallelBuilding = true;

    # In rare cases, APPLE may drop some headers quietly on new release.
    doInstallCheck = attrs ? appleHeaders;
    passAsFile = [ "appleHeaders" ];
    installCheckPhase = ''
      cd $out/include

      result=$(diff -u "$appleHeadersPath" <(find * -type f | sort) --label "Listed in appleHeaders" --label "Found in \$out/include" || true)

      if [ -z "$result" ]; then
        echo "Apple header list is matched."
      else
        echo >&2 "\
      Apple header list is inconsistent, please ensure no header file is unexpectedly dropped.
      $result
      "
        exit 1
      fi
    '';

  } // attrs // {
    meta = (with lib; {
      platforms = platforms.darwin;
      license = licenses.apsl20;
    }) // (attrs.meta or {});
  });

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

  IOKitSrcs = lib.mapAttrs (name: value: if lib.isFunction value then value name else value) IOKitSpecs;

in

# darwin package set
self:

let
  macosPackages_11_0_1 = import ./macos-11.0.1.nix { inherit applePackage'; };
  developerToolsPackages_11_3_1 = import ./developer-tools-11.3.1.nix { inherit applePackage'; };

  applePackage' = namePath: version: sdkName: sha256:
    let
      pname = builtins.head (lib.splitString "/" namePath);
      appleDerivation' = stdenv: appleDerivation'' stdenv pname version sdkName sha256;
      appleDerivation = appleDerivation' stdenv;
      callPackage = self.newScope { inherit appleDerivation' appleDerivation; };
    in callPackage (./. + "/${namePath}");

  applePackage = namePath: sdkName: sha256: let
    pname = builtins.head (lib.splitString "/" namePath);
    version = versions.${sdkName}.${pname};
  in applePackage' namePath version sdkName sha256;

  # Only used for bootstrapping. It’s convenient because it was the last version to come with a real makefile.
  adv_cmds-boot = applePackage "adv_cmds/boot.nix" "osx-10.5.8" "102ssayxbg9wb35mdmhswbnw0bg7js3pfd8fcbic83c5q3bqa6c6" {};

in

developerToolsPackages_11_3_1 // macosPackages_11_0_1 // {
    # TODO: shorten this list, we should cut down to a minimum set of bootstrap or necessary packages here.

    inherit (adv_cmds-boot) ps locale;
    architecture    = applePackage "architecture"      "osx-10.11.6"     "1pbpjcd7is69hn8y29i98ci0byik826if8gnp824ha92h90w0fq3" {};
    bsdmake         = applePackage "bsdmake"           "dev-tools-3.2.6" "11a9kkhz5bfgi1i8kpdkis78lhc6b5vxmhd598fcdgra1jw4iac2" {};
    CarbonHeaders   = applePackage "CarbonHeaders"     "osx-10.6.2"      "1zam29847cxr6y9rnl76zqmkbac53nx0szmqm9w5p469a6wzjqar" {};
    CommonCrypto    = applePackage "CommonCrypto"      "osx-10.12.6"     "0sgsqjcxbdm2g2zfpc50mzmk4b4ldyw7xvvkwiayhpczg1fga4ff" {};
    configd         = applePackage "configd"           "osx-10.8.5"      "1gxakahk8gallf16xmhxhprdxkh3prrmzxnmxfvj0slr0939mmr2" {
      Security      = applePackage "Security/boot.nix" "osx-10.9.5"      "1nv0dczf67dhk17hscx52izgdcyacgyy12ag0jh6nl5hmfzsn8yy" {};
    };
    copyfile        = applePackage "copyfile"          "osx-10.12.6"     "0a70bvzndkava1a946cdq42lnjhg7i7b5alpii3lap6r5fkvas0n" {};
    Csu             = applePackage "Csu"               "osx-10.11.6"     "0yh5mslyx28xzpv8qww14infkylvc1ssi57imhi471fs91sisagj" {};
    dtrace          = applePackage "dtrace"            "osx-10.12.6"     "0hpd6348av463yqf70n3xkygwmf1i5zza8kps4zys52sviqz3a0l" {};
    dyld            = applePackage "dyld"              "osx-10.12.6"     "0q4jmk78b5ajn33blh4agyq6v2a63lpb3fln78az0dy12bnp1qqk" {};
    eap8021x        = applePackage "eap8021x"          "osx-10.11.6"     "0iw0qdib59hihyx2275rwq507bq2a06gaj8db4a8z1rkaj1frskh" {};
    IOKit           = applePackage "IOKit"             "osx-10.11.6"     "0kcbrlyxcyirvg5p95hjd9k8a01k161zg0bsfgfhkb90kh2s8x00" { inherit IOKitSrcs; };
    launchd         = applePackage "launchd"           "osx-10.9.5"      "0w30hvwqq8j5n90s3qyp0fccxflvrmmjnicjri4i1vd2g196jdgj" {};
    libauto         = applePackage "libauto"           "osx-10.9.5"      "17z27yq5d7zfkwr49r7f0vn9pxvj95884sd2k6lq6rfaz9gxqhy3" {};
    Libc            = applePackage "Libc"              "osx-10.12.6"     "183wcy1nlj2wkpfsx3k3lyv917mk8r2p72qw8lb89mbjsw3yw0xx" {
      Libc_10-9 = fetchzip {
        url    = "http://www.opensource.apple.com/tarballs/Libc/Libc-997.90.3.tar.gz";
        sha256 = "1xchgxkxg5288r2b9yfrqji2gsgdap92k4wx2dbjwslixws12pq7";
      };
      Libc_old        = applePackage "Libc/825_40_1.nix" "osx-10.8.5"      "0xsx1im52gwlmcrv4lnhhhn9dyk5ci6g27k6yvibn9vj8fzjxwcf" {};
    };
    libclosure      = applePackage "libclosure"        "osx-10.11.6"     "1zqy1zvra46cmqv6vsf1mcsz3a76r9bky145phfwh4ab6y15vjpq" {};
    libdispatch     = applePackage "libdispatch"       "osx-10.10.5"     "0jsfbzp87lwk9snlby0hd4zvj7j894p5q3cw0wdx9ny1mcp3kdcj" {};
    libiconv        = applePackage "libiconv"          "osx-10.12.6"     "1gg5h6z8sk851bhv87vyxzs54jmqz6lh57ny8j4s51j7srja0nly" {};
    Libinfo         = applePackage "Libinfo"           "osx-10.11.6"     "0qjgkd4y8sjvwjzv5wwyzkb61pg8wwg95bkp721dgzv119dqhr8x" {};
    Libm            = applePackage "Libm"              "osx-10.7.4"      "02sd82ig2jvvyyfschmb4gpz6psnizri8sh6i982v341x6y4ysl7" {};
    Libnotify       = applePackage "Libnotify"         "osx-10.12.6"     "0p5qhvalf6j1w6n8xwywhn6dvbpzv74q5wqrgs8rwfpf74wg6s9z" {};
    libplatform     = applePackage "libplatform"       "osx-10.12.6"     "0rh1f5ybvwz8s0nwfar8s0fh7jbgwqcy903cv2x8m15iq1x599yn" {};
    libpthread      = applePackage "libpthread"        "osx-10.12.6"     "1j6541rcgjpas1fc77ip5krjgw4bvz6jq7bq7h9q7axb0jv2ns6c" {};
    libresolv       = applePackage "libresolv"         "osx-10.12.6"     "077j6ljfh7amqpk2146rr7dsz5vasvr3als830mgv5jzl7l6vz88" {};
    Libsystem       = applePackage "Libsystem"         "osx-10.12.6"     "1082ircc1ggaq3wha218vmfa75jqdaqidsy1bmrc4ckfkbr3bwx2" {};
    libutil         = applePackage "libutil"           "osx-10.12.6"     "0lqdxaj82h8yjbjm856jjz9k2d96k0viimi881akfng08xk1246y" {};
    libunwind       = applePackage "libunwind"         "osx-10.12.6"     "0miffaa41cv0lzf8az5k1j1ng8jvqvxcr4qrlkf3xyj479arbk1b" {};
    mDNSResponder   = applePackage "mDNSResponder"     "osx-10.12.6"     "02ms1p8zlgmprzn65jzr7yaqxykh3zxjcrw0c06aayim6h0dsqfy" {};
    objc4           = applePackage "objc4"             "osx-10.12.6"     "1cj1vhbcs9pkmag2ms8wslagicnq9bxi2qjkszmp3ys7z7ccrbwz" {};
    ppp             = applePackage "ppp"               "osx-10.12.6"     "1kcc2nc4x1kf8sz0a23i6nfpvxg381kipi0qdisrp8x9z2gbkxb8" {};
    removefile      = applePackage "removefile"        "osx-10.12.6"     "0jzjxbmxgjzhssqd50z7kq9dlwrv5fsdshh57c0f8mdwcs19bsyx" {};
    xnu             = applePackage "xnu"               "osx-10.12.6"     "1sjb0i7qzz840v2h4z3s4jyjisad4r5yyi6sg8pakv3wd81i5fg5" {
      python3 = pkgs.buildPackages.buildPackages.python3; # TODO(@Ericson2314) this shouldn't be needed.
    };
    hfs             = applePackage "hfs"               "osx-10.12.6"     "1mj3xvqpq1mgd80b6kl1s04knqnap7hccr0gz8rjphalq14rbl5g" {};
    Librpcsvc       = applePackage "Librpcsvc"         "osx-10.11.6"     "1zwfwcl9irxl1dlnf2b4v30vdybp0p0r6n6g1pd14zbdci1jcg2k" {};
    adv_cmds        = applePackage "adv_cmds"          "osx-10.11.6"    "12gbv35i09aij9g90p6b3x2f3ramw43qcb2gjrg8lzkzmwvcyw9q" {};
    basic_cmds      = applePackage "basic_cmds"        "osx-10.11.6"     "0hvab4b1v5q2x134hdkal0rmz5gsdqyki1vb0dbw4py1bqf0yaw9" {};
    developer_cmds  = applePackage "developer_cmds"    "osx-10.11.6"     "1r9c2b6dcl22diqf90x58psvz797d3lxh4r2wppr7lldgbgn24di" {};
    diskdev_cmds    = applePackage "diskdev_cmds"      "osx-10.11.6"     "1ssdyiaq5m1zfy96yy38yyknp682ki6bvabdqd5z18fa0rv3m2ar" {
      macosPackages_11_0_1 = macosPackages_11_0_1;
    };
    network_cmds    = applePackage "network_cmds"      "osx-10.11.6"     "0lhi9wz84qr1r2ab3fb4nvmdg9gxn817n5ldg7zw9gnf3wwn42kw" {};
    file_cmds       = applePackage "file_cmds"         "osx-10.11.6"     "1zfxbmasps529pnfdjvc13p7ws2cfx8pidkplypkswyff0nff4wp" {};
    shell_cmds      = applePackage "shell_cmds"        "osx-10.11.6"     "0084k271v66h4jqp7q7rmjvv7w4mvhx3aq860qs8jbd30canm86n" {};
    system_cmds     = applePackage "system_cmds"       "osx-10.11.6"     "1h46j2c5v02pkv5d9fyv6cpgyg0lczvwicrx6r9s210cl03l77jl" {};
    text_cmds       = applePackage "text_cmds"         "osx-10.11.6"     "1f93m7dd0ghqb2hwh905mjhzblyfr7dwffw98xhgmv1mfdnigxg0" {};
    top             = applePackage "top"               "osx-10.11.6"     "0i9120rfwapgwdvjbfg0ya143i29s1m8zbddsxh39pdc59xnsg5l" {};
    PowerManagement = applePackage "PowerManagement"   "osx-10.11.6"     "1llimhvp0gjffd47322lnjq7cqwinx0c5z7ikli04ad5srpa68mh" {};

    # `configdHeaders` can’t use an override because `pkgs.darwin.configd` on aarch64-darwin will
    # be replaced by SystemConfiguration.framework from the macOS SDK.
    configdHeaders  = applePackage "configd"           "osx-10.8.5"      "1gxakahk8gallf16xmhxhprdxkh3prrmzxnmxfvj0slr0939mmr2" {
      headersOnly = true;
      Security    = null;
    };
    libutilHeaders  = pkgs.darwin.libutil.override { headersOnly = true; };
    hfsHeaders      = pkgs.darwin.hfs.override { headersOnly = true; };
    libresolvHeaders= pkgs.darwin.libresolv.override { headersOnly = true; };

    # TODO(matthewbauer):
    # To be removed, once I figure out how to build a newer Security version.
    Security        = applePackage "Security/boot.nix" "osx-10.9.5"      "1nv0dczf67dhk17hscx52izgdcyacgyy12ag0jh6nl5hmfzsn8yy" {};
}
