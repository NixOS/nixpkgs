/* This file defines the composition for Go packages. */

{ overrides, stdenv, go, buildGoPackage, git, pkgconfig, libusb
, fetchgit, fetchhg, fetchurl, fetchFromGitHub, fetchbzr, pkgs }:

let self = _self // overrides; _self = with self; {

  inherit go buildGoPackage;

  ## OFFICIAL GO PACKAGES

  crypto = buildGoPackage rec {
    rev = "1351f936d976c60a0a48d728281922cf63eafb8d";
    name = "go-crypto-${rev}";
    goPackagePath = "golang.org/x/crypto";
    src = fetchFromGitHub {
      inherit rev;
      owner  = "golang";
      repo   = "crypto";
      sha256 = "1vf4z97y7xnhzjizik0lghr7ip77hhdj9kbb35rr4c9sn108f20j";
    };
  };

  image = buildGoPackage rec {
    rev = "490b1ad139b3";
    name = "go.image-${rev}";
    goPackagePath = "code.google.com/p/go.image";
    src = fetchhg {
      inherit rev;
      url = "https://${goPackagePath}";
      sha256 = "02m6ifwby2fi88njarbbb6dimwg0pd2b6llkgyadh4b9wzp2vy4r";
    };
  };

  net = buildGoPackage rec {
    rev = "3338d5f109e9";
    name = "go.net-${rev}";
    goPackagePath = "code.google.com/p/go.net";
    src = fetchhg {
      inherit rev;
      url = "https://${goPackagePath}";
      sha256 = "0yz807y3ac07x3nf0qlaw1w1i6asynrpyssjl8jyv3pplww0qj7i";
    };
    propagatedBuildInputs = [ text ];
  };

  protobuf = buildGoPackage rec {
    rev = "36be16571e14";
    name = "goprotobuf-${rev}";
    goPackagePath = "code.google.com/p/goprotobuf";
    src = fetchhg {
      inherit rev;
      url = "https://code.google.com/p/goprotobuf";
      sha256 = "14yay2sgfbbs0bx3q03bdqn1kivyvxfdm34rmp2612gvinlll215";
    };
    subPackages = [ "proto" "protoc-gen-go" ];
  };

  text = buildGoPackage rec {
    rev = "024681b033be";
    name = "go.text-${rev}";
    goPackagePath = "code.google.com/p/go.text";
    src = fetchhg {
      inherit rev;
      url = "https://${goPackagePath}";
      sha256 = "19px5pw5mvwjb7ymivfkkkr6cyl2npv834jxlr6y0x5ca1djhsci";
    };
    doCheck = false;
  };

  tools = buildGoPackage rec {
    rev = "140fcaadc5860b1a014ec69fdeec807fe3b787e8";
    name = "go.tools-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "code.google.com/p/go.tools";
    src = fetchhg {
      inherit rev;
      url = "http://code.google.com/p/go.tools";
      sha256 = "1vgz4kxy0p56qh6pfbs2c68156hakgx4cmrci9jbg7lnrdaz4y56";
    };
    subPackages = [ "go/vcs" ];
  };

  ## THIRD PARTY

  asn1-ber = buildGoPackage rec {
    rev = "ec51d5ed21377b4023ca7b1e70ae4cb296ee6047";
    name = "asn1-ber-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/nmcclain/asn1-ber";
    src = fetchFromGitHub {
      inherit rev;
      owner  = "nmcclain";
      repo   = "asn1-ber";
      sha256 = "0a2d38k7zpcnf148zlxq2rm7s1s1hzybb3w5ygxilipz0m7qkdsb";
    };
  };

  binarydist = buildGoPackage rec {
    rev = "9955b0ab8708602d411341e55fffd7e0700f86bd";
    name = "binarydist-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/kr/binarydist";

    src = fetchFromGitHub {
      inherit rev;
      owner = "kr";
      repo = "binarydist";
      sha256 = "11wncbbbrdcxl5ff3h6w8vqfg4bxsf8709mh6vda0cv236flkyn3";
    };
  };

  bufio = buildGoPackage rec {
    rev = "24e7e48f60fc2d9e99e43c07485d9fff42051e66";
    name = "bufio-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/vmihailenco/bufio";
    src = fetchFromGitHub {
      inherit rev;
      owner = "vmihailenco";
      repo = "bufio";
      sha256 = "0x46qnf2f15v7m0j2dcb16raxjamk5rdc7hqwgyxfr1sqmmw3983";
    };
  };

  check-v1 = buildGoPackage rec {
    rev = "871360013c92e1c715c2de6d06b54899468a8a2d";
    name = "check-v1-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "gopkg.in/check.v1";
    src = fetchgit {
      inherit rev;
      url = "https://github.com/go-check/check.git";
      sha256 = "0i83qjmd4ri9mrfddhsbpj9nb43rf2j9803k030fj155j31klwcx";
    };
  };

  circbuf = buildGoPackage rec {
    rev = "f092b4f207b6e5cce0569056fba9e1a2735cb6cf";
    name = "circbuf-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/armon/circbuf";
    src = fetchFromGitHub {
      inherit rev;
      owner = "armon";
      repo = "circbuf";
      sha256 = "06kwwdwa3hskdh6ws7clj1vim80dyc3ldim8k9y5qpd30x0avn5s";
    };
  };

  cli = buildGoPackage rec {
    rev = "8262fe3f76f0da53b5674eb35c8c6436430794c3";
    name = "cli-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/mitchellh/cli";
    src = fetchFromGitHub {
      inherit rev;
      owner = "mitchellh";
      repo = "cli";
      sha256 = "0pqkxh1q49kkxihggrfjs8174d927g4c5qqx00ggw8sqqsgrw6vn";
    };
  };

  cobra = buildGoPackage rec {
    date = "20140617";
    rev = "10a8494a87448bf5003222d9974f166437e7f042";
    name = "cobra-${date}-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/spf13/cobra";
    src = fetchgit {
      inherit rev;
      url = "https://${goPackagePath}.git";
      sha256 = "1ydcccx0zdswca4v9hfmrn8ck42h485hy3wrd9k7y6mra3r6c08j";
    };
    propagatedBuildInputs = [ pflag ];
  };

  columnize = buildGoPackage rec {
    rev = "785d943a7b6886e0bb2f139a60487b823dd8d9de";
    name = "columnize-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/ryanuber/columnize";
    src = fetchFromGitHub {
      inherit rev;
      owner = "ryanuber";
      repo = "columnize";
      sha256 = "1h3sxzhiwz65vf3cvclirlf6zhdr97v01dpn5cmf3m09rxxpnp3f";
    };
  };

  dns = buildGoPackage rec {
    rev = "0bd3fb7026404936cf18204ea527d27f067923cf";
    name = "dns-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/miekg/dns";
    src = fetchFromGitHub {
      inherit rev;
      owner = "miekg";
      repo = "dns";
      sha256 = "1hv2ikpd9gr9idf7zh8nyqgdbnnffs057wsdpd7m44mllbmzhdxn";
    };
  };

  ed25519 = buildGoPackage rec {
    rev = "d2b94fd789ea21d12fac1a4443dd3a3f79cda72c";
    name = "ed25519-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/agl/ed25519";
    src = fetchgit {
      inherit rev;
      url = "git://${goPackagePath}.git";
      sha256 = "83e3010509805d1d315c7aa85a356fda69d91b51ff99ed98a503d63adb3613e9";
    };
  };

  g2s = buildGoPackage rec {
    rev = "ec76db4c1ac16400ac0e17ca9c4840e1d23da5dc";
    name = "g2s-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/peterbourgon/g2s";
    src = fetchFromGitHub {
      inherit rev;
      owner  = "peterbourgon";
      repo   = "g2s";
      sha256 = "1p4p8755v2nrn54rik7yifpg9szyg44y5rpp0kryx4ycl72307rj";
    };
  };

  goamz = buildGoPackage rec {
    rev = "2a8fed5e89ab9e16210fc337d1aac780e8c7bbb7";
    name = "goamz-${rev}";
    goPackagePath = "github.com/goamz/goamz";
    src = fetchFromGitHub {
      inherit rev;
      owner  = "goamz";
      repo   = "goamz";
      sha256 = "0rlinp0cvgw66qjndg4padr5s0wd3n7kjfggkx6czqj9bqaxcz4b";
    };
    propagatedBuildInputs = [ go-ini ];

    # These might need propagating too, but I haven't tested the entire library
    buildInputs = [ sets go-simplejson check-v1 ];
  };

  gocheck = buildGoPackage rec {
    rev = "87";
    name = "gocheck-${rev}";
    goPackagePath = "launchpad.net/gocheck";
    src = fetchbzr {
      inherit rev;
      url = "https://${goPackagePath}";
      sha256 = "1y9fa2mv61if51gpik9isls48idsdz87zkm1p3my7swjdix7fcl0";
    };
  };

  goconvey = buildGoPackage rec {
    version = "1.5.0";
    name = "goconvey-${version}";
    goPackagePath = "github.com/smartystreets/goconvey";
    src = fetchurl {
      name = "${name}.tar.gz";
      url = "https://github.com/smartystreets/goconvey/archive/${version}.tar.gz";
      sha256 = "0g3965cb8kg4kf9b0klx4pj9ycd7qwbw1jqjspy6i5d4ccd6mby4";
    };
    buildInputs = [ oglematchers ];
    doCheck = false; # please check again
  };

  gox = buildGoPackage rec {
    rev = "e8e6fd4fe12510cc46893dff18c5188a6a6dc549";
    name = "gox-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/mitchellh/gox";
    src = fetchFromGitHub {
      inherit rev;
      owner  = "mitchellh";
      repo   = "gox";
      sha256 = "14jb2vgfr6dv7zlw8i3ilmp125m5l28ljv41a66c9b8gijhm48k1";
    };
    buildInputs = [ iochan ];
  };

  go-assert = buildGoPackage rec {
    rev = "e17e99893cb6509f428e1728281c2ad60a6b31e3";
    name = "assert-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/bmizerany/assert";
    src = fetchFromGitHub {
      inherit rev;
      owner = "bmizerany";
      repo = "assert";
      sha256 = "1lfrvqqmb09y6pcr76yjv4r84cshkd4s7fpmiy7268kfi2cvqnpc";
    };
    propagatedBuildInputs = [ pretty ];
  };

  go-bencode = buildGoPackage rec {
    version = "1.1.1";
    name = "go-bencode-${version}";
    goPackagePath = "github.com/ehmry/go-bencode";

    src = fetchurl {
      url = "https://${goPackagePath}/archive/v${version}.tar.gz";
      sha256 = "0y2kz2sg1f7mh6vn70kga5d0qhp04n01pf1w7k6s8j2nm62h24j6";
    };
  };

  go-bindata = buildGoPackage rec {
    version = "3.0.7";
    name = "go-bindata-${version}";
    goPackagePath = "github.com/jteeuwen/go-bindata";
    src = fetchFromGitHub {
      repo = "go-bindata";
      owner = "jteeuwen";
      rev = "v${version}";
      sha256 = "1v8xwwlv6my5ixvis31m3vgz4sdc0cq82855j8gxmjp1scinv432";
    };

    subPackages = [ "./" "go-bindata" ]; # don't build testdata

    meta = with stdenv.lib; {
      homepage    = "https://github.com/jteeuwen/go-bindata";
      description = "A small utility which generates Go code from any file. Useful for embedding binary data in a Go program.";
      maintainers = with maintainers; [ cstrahan ];
      license     = licenses.cc0 ;
      platforms   = platforms.all;
    };
  };

  go-codec = buildGoPackage rec {
    rev = "71c2886f5a673a35f909803f38ece5810165097b";
    name = "go-codec-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/ugorji/go";
    src = fetchFromGitHub {
      inherit rev;
      owner = "ugorji";
      repo = "go";
      sha256 = "157f24xnkhclrjwwa1b7lmpj112ynlbf7g1cfw0c657iqny5720j";
    };
  };

  go-fuse = buildGoPackage rec {
    rev = "5d16aa11eef4643de2d91e88a64dcb6138705d58";
    name = "go-fuse-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/hanwen/go-fuse";
    src = fetchFromGitHub {
      inherit rev;
      owner = "hanwen";
      repo = "go-fuse";
      sha256 = "0lycfhchn88kbs81ypz8m5jh032fpbv14gldrjirf32wm1d4f8pj";
    };
    subPackages = [ "fuse" "fuse/nodefs" "fuse/pathfs" ];
  };

  go-homedir = buildGoPackage rec {
    rev = "7d2d8c8a4e078ce3c58736ab521a40b37a504c52";
    name = "go-homedir-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/mitchellh/go-homedir";
    src = fetchFromGitHub {
      inherit rev;
      owner  = "mitchellh";
      repo   = "go-homedir";
      sha256 = "1ixhwxnvq1qx53asq47yhg3l88ndwrnyw4fkkidcjg759dc86d0i";
    };
  };

  go-hostpool = buildGoPackage rec {
    rev = "fed86fae5cacdc77e7399937e2f8836563620a2e";
    name = "go-hostpool-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/bitly/go-hostpool";
    src = fetchFromGitHub {
      inherit rev;
      owner = "bitly";
      repo = "go-hostpool";
      sha256 = "0nbssfp5ksj4hhc0d8lfq54afd9nqv6qzk3vi6rinxr3fgplrj44";
    };
  };

  go-ini = buildGoPackage rec {
    rev = "a98ad7ee00ec53921f08832bc06ecf7fd600e6a1";
    name = "go-ini-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/vaughan0/go-ini";
    src = fetchFromGitHub {
      inherit rev;
      owner  = "vaughan0";
      repo   = "go-ini";
      sha256 = "1l1isi3czis009d9k5awsj4xdxgbxn4n9yqjc1ac7f724x6jacfa";
    };
  };

  rcrowley.go-metrics = buildGoPackage rec {
    rev = "f770e6f5e91a8770cecee02d5d3f7c00b023b4df";
    name = "rcrowley.go-metrics-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/rcrowley/go-metrics";
    src = fetchFromGitHub {
      inherit rev;
      owner = "rcrowley";
      repo = "go-metrics";
      sha256 = "07dc74kiam8v5my7rhi3yxqrpnaapladhk8b3qbnrpjk3shvnx5f";
    };

    buildInputs = [ influxdb-go stathat ];
  };

  armon.go-metrics = buildGoPackage rec {
    rev = "02567bbc4f518a43853d262b651a3c8257c3f141";
    name = "armon.go-metrics-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/armon/go-metrics";
    src = fetchFromGitHub {
      inherit rev;
      owner = "armon";
      repo = "go-metrics";
      sha256 = "08fk3zmw0ywmdfp2qhrpv0vrk1y97hzqczrgr3y2yip3x8sr37ar";
    };
  };

  go-msgpack = buildGoPackage rec {
    rev = "75092644046c5e38257395b86ed26c702dc95b92";
    name = "go-msgpack-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/ugorji/go-msgpack";
    src = fetchFromGitHub {
      inherit rev;
      owner = "ugorji";
      repo = "go-msgpack";
      sha256 = "1bmqi16bfiqw7qhb3d5hbh0dfzhx2bbq1g15nh2pxwxckwh80x98";
    };
  };

  go-nsq = buildGoPackage rec {
    rev = "c79a282f05364e340eadc2ce2f862a3d44eea9c0";
    name = "go-nsq-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/bitly/go-nsq";
    src = fetchFromGitHub {
      inherit rev;
      owner = "bitly";
      repo = "go-nsq";
      sha256 = "19jlwj5419p5xwjzfnzlddjnbh5g7ifnqhd00i5p0b6ww1gk011p";
    };
    propagatedBuildInputs = [ go-simplejson go-snappystream ];
  };

  go-options = buildGoPackage rec {
    rev = "896a539cd709f4f39d787562d1583c016ce7517e";
    name = "go-options-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/mreiferson/go-options";
    src = fetchFromGitHub {
      inherit rev;
      owner = "mreiferson";
      repo = "go-options";
      sha256 = "0hg0n5grcjcj5719rqchz0plp39wfk3znqxw8y354k4jwsqwmn17";
    };
  };

  go-simplejson = buildGoPackage rec {
    rev = "1cfceb0e12f47ec02665ef480212d7b531d6f4c5";
    name = "go-simplejson-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/bitly/go-simplejson";
    src = fetchFromGitHub {
      inherit rev;
      owner = "bitly";
      repo = "go-simplejson";
      sha256 = "1d8x0himl58qn87lv418djy6mbs66p9ai3zpqq13nhkfl67fj3bi";
    };
  };

  go-snappystream = buildGoPackage rec {
    rev = "97c96e6648e99c2ce4fe7d169aa3f7368204e04d";
    name = "go-snappystream-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/mreiferson/go-snappystream";
    src = fetchFromGitHub {
      inherit rev;
      owner = "mreiferson";
      repo = "go-snappystream";
      sha256 = "08ylvx9r6b1fi76v6cqjvny4yqsvcqjfsg93jdrgs7hi4mxvxynn";
    };
    propagatedBuildInputs = [ snappy-go ];
  };

  go-syslog = buildGoPackage rec {
    rev = "ac3963b72ac367e48b1e68a831e62b93fb69091c";
    name = "go-syslog-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/hashicorp/go-syslog";
    src = fetchFromGitHub {
      inherit rev;
      owner = "hashicorp";
      repo = "go-syslog";
      sha256 = "1r9s1gsa4azcs05gx1179ixk7qvrkrik3v92wr4s8gwm00m0gf81";
    };
  };
 
  go-update = buildGoPackage rec {
    rev = "c1385108bc3a016f1c88b75ea7d2e2a356a1571d";
    name = "go-update-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/inconshreveable/go-update";

    buildInputs = [ osext binarydist ];

    src = fetchFromGitHub {
      inherit rev;
      owner = "inconshreveable";
      repo = "go-update";
      sha256 = "16zaxa0i07ismxdmkvjj4dpyc9lgp6wa94q090m9a48si40w9sjn";
    };
  };

  go-vhost = buildGoPackage rec {
    rev = "c4c28117502e4bf00960c8282b2d1c51c865fe2c";
    name = "go-vhost-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/inconshreveable/go-vhost";
    src = fetchFromGitHub {
      inherit rev;
      owner = "inconshreveable";
      repo = "go-vhost";
      sha256 = "1rway6sls6fl2s2jk20ajj36rrlzh9944ncc9pdd19kifix54z32";
    };
  };

  hologram = buildGoPackage rec {
    rev  = "6e81a11091f59a9392e424d8f1c42b4b813c4bff";
    name = "hologram-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/AdRoll/hologram";
    src = fetchFromGitHub {
      inherit rev;
      owner  = "copumpkin";
      repo   = "hologram";
      sha256 = "1rpnc8sv9mwm9r9yfh8h2zxczznmvlhasrz55bcifmk4sym4ywq7";
    };
    preBuild = ''
      cd "go/src/$goPackagePath"
      # Work around `go install` assuming containing directory is the executable name we want
      for i in */bin; do
        mv "$i" "$(dirname "$i")/$(dirname "$i")"
      done

      # Generate protobuf definitions and static assets
      make protocol/hologram.pb.go
      make transport/remote/bindata.go
    '';

    buildInputs = [ pkgs.protobuf crypto protobuf goamz rgbterm go-bindata go-homedir ldap g2s gox ];
  };

  influxdb-go = buildGoPackage rec {
    rev = "63c9a5f67dcb633d05164bf8442160c9e2e402f7";
    name = "influxdb-go-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/influxdb/influxdb-go";
    src = fetchFromGitHub {
      inherit rev;
      owner = "influxdb";
      repo = "influxdb-go";
      sha256 = "16in1xhx94pir06aw166inn0hzpb7836xbws16laabs1p2np7bld";
    };
  };

  eckardt.influxdb-go = buildGoPackage rec {
    rev = "8b71952efc257237e077c5d0672e936713bad38f";
    name = "influxdb-go-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/eckardt/influxdb-go";
    src = fetchgit {
      inherit rev;
      url = "https://${goPackagePath}.git";
      sha256 = "5318c7e1131ba2330c90a1b67855209e41d3c77811b1d212a96525b42d391f6e";
    };
  };

  iochan = buildGoPackage rec {
    rev = "b584a329b193e206025682ae6c10cdbe03b0cd77";
    name = "iochan-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/mitchellh/iochan";
    src = fetchFromGitHub {
      inherit rev;
      owner = "mitchellh";
      repo = "iochan";
      sha256 = "1fcwdhfci41ibpng2j4c1bqfng578cwzb3c00yw1lnbwwhaq9r6b";
    };
  };

  ldap = buildGoPackage rec {
    rev = "469fe5a802d61523b40dbb29bb8012a6b99b06b5";
    name = "ldap-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/nmcclain/ldap";
    src = fetchFromGitHub {
      inherit rev;
      owner  = "nmcclain";
      repo   = "ldap";
      sha256 = "0xq5dc03ym0wlg9mvf4gbrmj74l4c8bgkls8fd7c98a128qw2srk";
    };
    propagatedBuildInputs = [ asn1-ber ];
    subPackages = [ "./" ];
  };

  log4go = buildGoPackage rec {
    rev = "48";
    name = "log4go-${rev}";
    goPackagePath = "code.google.com/p/log4go";

    src = fetchhg {
      inherit rev;
      url = "https://${goPackagePath}";
      sha256 = "0q906sxrmwir295virfibqvdzlaj340qh2r4ysx1ccjrjazc0q5p";
    };

    subPackages = [ "./" ]; # don't build examples
  };

  logutils = buildGoPackage rec {
    rev = "8e0820fe7ac5eb2b01626b1d99df47c5449eb2d8";
    name = "logutils-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/hashicorp/logutils";
    src = fetchFromGitHub {
      inherit rev;
      owner = "hashicorp";
      repo = "logutils";
      sha256 = "033rbkc066g657r0dnzysigjz2bs4biiz0kmiypd139d34jvslwz";
    };
  };

  mapstructure = buildGoPackage rec {
    rev = "6fb2c832bcac61d01212ab1d172f7a14a8585b07";
    name = "mapstructure-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/mitchellh/mapstructure";
    src = fetchFromGitHub {
      inherit rev;
      owner = "mitchellh";
      repo = "mapstructure";
      sha256 = "0mx855lwhv0rk461wmbnbzbpkhmq5p2ipmrm5bhzimagrr1w17hw";
    };
  };

  mdns = buildGoPackage rec {
    rev = "70462deb060d44247356ee238ebafd7699ddcffe";
    name = "mdns-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/armon/mdns";
    src = fetchFromGitHub {
      inherit rev;
      owner = "armon";
      repo = "mdns";
      sha256 = "0xkm3d0hsixdm1yrkx9c39723kfjkb3wvrzrmx3np9ylcwn6h5p5";
    };

    propagatedBuildInputs = [ dns net ];
  };

  memberlist = buildGoPackage rec {
    rev = "17d39b695094be943bfb98442a80b082e6b9ac47";
    name = "memberlist-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/hashicorp/memberlist";
    src = fetchFromGitHub {
      inherit rev;
      owner = "hashicorp";
      repo = "memberlist";
      sha256 = "0nvgjnwmfqhv2wvr77d2q5mq1bfw4xbpil6wgyj4fyrmhsfzrv3g";
    };

    propagatedBuildInputs = [ go-codec armon.go-metrics ];
  };

  mgo = buildGoPackage rec {
    rev = "2";
    name = "mgo-${rev}"; 
    goPackagePath = "launchpad.net/mgo";
    src = fetchbzr {
      inherit rev;
      url = "https://${goPackagePath}";
      sha256 = "0h1dxzyx5c4r4gfnmjxv92hlhjxrgx9p4g53p4fhmz6x2fdglb0x";
    };
  };

  mousetrap = buildGoPackage rec {
    rev = "9dbb96d2c3a964935b0870b5abaea13c98b483aa";
    name = "mousetrap-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/inconshreveable/mousetrap";
    src = fetchFromGitHub {
      inherit rev;
      owner = "inconshreveable";
      repo = "mousetrap";
      sha256 = "1f9g8vm18qv1rcb745a4iahql9vfrz0jni9mnzriab2wy1pfdl5b";
    };
  };

  msgpack = buildGoPackage rec {
    rev = "20c1b88a6c7fc5432037439f4e8c582e236fb205";
    name = "msgpack-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/vmihailenco/msgpack";
    src = fetchFromGitHub {
      inherit rev;
      owner = "vmihailenco";
      repo = "msgpack";
      sha256 = "1dj5scpfhgnw0yrh0w6jlrb9d03halvsv4l3wgjhazrrimdqf0q0";
    };
  };

  oglematchers = buildGoPackage rec {
    rev = "4fc24f97b5b74022c2a3f4ca7eed57ca29083d3e";
    name = "oglematchers-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/jacobsa/oglematchers";
    src = fetchgit {
      inherit rev;
      url = "https://${goPackagePath}.git";
      sha256 = "4075ede31601adf8c4e92739693aebffa3718c641dfca75b09cf6b4bd6c26cc0";
    };
    #goTestInputs = [ ogletest ];
    doCheck = false; # infinite recursion
  };

  oglemock = buildGoPackage rec {
    rev = "d054ecee522bdce4481690cdeb09d1b4c44da4e1";
    name = "oglemock-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/jacobsa/oglemock";
    src = fetchgit {
      inherit rev;
      url = "https://${goPackagePath}.git";
      sha256 = "685e7fc4308d118ae25467ba84c64754692a7772c77c197f38d8c1b63ea81da2";
    };
    buildInputs = [ oglematchers ];
    #goTestInputs = [ ogletest ];
    doCheck = false; # infinite recursion
  };

  ogletest = buildGoPackage rec {
    rev = "7de485607c3f215cf92c1f793b5d5a7de46ec3c7";
    name = "ogletest-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/jacobsa/ogletest";
    src = fetchgit {
      inherit rev;
      url = "https://${goPackagePath}.git";
      sha256 = "0cfc43646d59dcea5772320f968aef2f565fb5c46068d8def412b8f635365361";
    };
    buildInputs = [ oglemock oglematchers ];
    doCheck = false; # check this again
  };

  osext = buildGoPackage rec {
    rev = "10";
    name = "osext-${rev}";
    goPackagePath = "bitbucket.org/kardianos/osext";
    src = fetchhg {
      inherit rev;
      url = "https://${goPackagePath}";
      sha256 = "1sj9r5pm28l9sqx6354fwp032n53znx9k8495k3dfnyqjrkvlw6n";
    };
  };

  perks = buildGoPackage rec {
    rev = "aac9e2eab5a334037057336897fd10b0289a5ae8";
    name = "perks-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/bmizerany/perks";
    src = fetchFromGitHub {
      inherit rev;
      owner = "bmizerany";
      repo = "perks";
      sha256 = "1d027jgc327qz5xmal0hrpqvsj45i9yqmm9pxk3xp3hancvz3l3k";
    };
  };

  pflag = buildGoPackage rec {
    date = "20131112";
    rev = "94e98a55fb412fcbcfc302555cb990f5e1590627";
    name = "pflag-${date}-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/spf13/pflag";
    src = fetchgit {
      inherit rev;
      url = "https://${goPackagePath}.git";
      sha256 = "0z8nzdhj8nrim8fz11magdl0wxnisix9p2kcvn5kkb3bg8wmxhbg";
    };
    doCheck = false; # bad import path in tests
  };

  pretty = buildGoPackage rec {
    rev = "bc9499caa0f45ee5edb2f0209fbd61fbf3d9018f";
    name = "pretty-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/kr/pretty";
    src = fetchFromGitHub {
      inherit rev;
      owner = "kr";
      repo = "pretty";
      sha256 = "1m61y592qsnwsqn76v54mm6h2pcvh4wlzbzscc1ag645x0j33vvl";
    };
    propagatedBuildInputs = [ kr.text ];
  };

  pty = buildGoPackage rec {
    rev = "67e2db24c831afa6c64fc17b4a143390674365ef";
    name = "pty-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/kr/pty";
    src = fetchFromGitHub {
      inherit rev;
      owner = "kr";
      repo = "pty";
      sha256 = "1l3z3wbb112ar9br44m8g838z0pq2gfxcp5s3ka0xvm1hjvanw2d";
    };
  };

  raw = buildGoPackage rec {
    rev = "724aedf6e1a5d8971aafec384b6bde3d5608fba4";
    name = "raw-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/feyeleanor/raw";
    src = fetchFromGitHub {
      inherit rev;
      owner  = "feyeleanor";
      repo   = "raw";
      sha256 = "0z4dcnadgk0fbxxd14dqa1wzzr0v3ksqlzd0swzs2mipim5wjgsz";
    };
  };

  rgbterm = buildGoPackage rec {
    rev = "9e3d038e1b8341ed7416c841a884cab4a3487941";
    name = "rgbterm-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/aybabtme/rgbterm";
    src = fetchFromGitHub {
      inherit rev;
      owner  = "aybabtme";
      repo   = "rgbterm";
      sha256 = "1pfg56pkm9clzd3c1s0czvydw1k35jggz9ydv8x2dbns3f7qn2ph";
    };
  };

  sets = buildGoPackage rec {
    rev = "6c54cb57ea406ff6354256a4847e37298194478f";
    name = "sets-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/feyeleanor/sets";
    src = fetchFromGitHub {
      inherit rev;
      owner  = "feyeleanor";
      repo   = "sets";
      sha256 = "1l3hyl8kmwb9k6qi8x4w54g2cmydap0g3cqvs47bhvm47rg1j1zc";
    };
    propagatedBuildInputs = [ slices ];
  };

  slices = buildGoPackage rec {
    rev = "bb44bb2e4817fe71ba7082d351fd582e7d40e3ea";
    name = "slices-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/feyeleanor/slices";
    src = fetchFromGitHub {
      inherit rev;
      owner  = "feyeleanor";
      repo   = "slices";
      sha256 = "1miqhzqgww41d8xbvmxfzx9rsfxgw742nqz96mhjkxpadrxg870v";
    };
    propagatedBuildInputs = [ raw ];
  };

  snappy-go = buildGoPackage rec {
    rev = "14";
    name = "snappy-go-${rev}";
    goPackagePath = "code.google.com/p/snappy-go";
    src = fetchhg {
      inherit rev;
      url = "http://code.google.com/p/snappy-go";
      sha256 = "0ywa52kcii8g2a9lbqcx8ghdf6y56lqq96sl5nl9p6h74rdvmjr7";
    };
  };

  stathat = buildGoPackage rec {
    rev = "01d012b9ee2ecc107cb28b6dd32d9019ed5c1d77";
    name = "stathat-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/stathat/go";
    src = fetchFromGitHub {
      inherit rev;
      owner = "stathat";
      repo = "go";
      sha256 = "0mrn70wjfcs4rfkmga3hbfqmbjk33skcsc8pyqxp02bzpwdpc4bi";
    };
  };

  termbox-go = buildGoPackage rec {
    rev = "9aecf65084a5754f12d27508fa2e6ed56851953b";
    name = "termbox-go-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/nsf/termbox-go";
    src = fetchFromGitHub {
      inherit rev;
      owner = "nsf";
      repo = "termbox-go";
      sha256 = "16sak07bgvmax4zxfrd4jia1dgygk733xa8vk8cdx28z98awbfsh";
    };

    subPackages = [ "./" ]; # prevent building _demos
  };

  kr.text = buildGoPackage rec {
    rev = "6807e777504f54ad073ecef66747de158294b639";
    name = "kr.text-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/kr/text";
    src = fetchFromGitHub {
      inherit rev;
      owner = "kr";
      repo = "text";
      sha256 = "1wkszsg08zar3wgspl9sc8bdsngiwdqmg3ws4y0bh02sjx5a4698";
    };
    propagatedBuildInputs = [ pty ];
  };

  toml = buildGoPackage rec {
    rev = "f87ce853111478914f0bcffa34d43a93643e6eda";
    name = "toml-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/BurntSushi/toml";
    src = fetchFromGitHub {
      inherit rev;
      owner = "BurntSushi";
      repo = "toml";
      sha256 = "0g8203y9ycf34j2q3ymxb8nh4habgwdrjn9vdgrginllx73yq565";
    };
  };

  usb = buildGoPackage rec {
    rev = "69aee4530ac705cec7c5344418d982aaf15cf0b1";
    name = "usb-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/hanwen/usb";
    src = fetchFromGitHub {
      inherit rev;
      owner = "hanwen";
      repo = "usb";
      sha256 = "01k0c2g395j65vm1w37mmrfkg6nm900khjrrizzpmx8f8yf20dky";
    };
    buildInputs = [ pkgconfig libusb ];
  };

  websocket = buildGoPackage rec {
    rev = "f4076986b69612ecb8bc7ce06d742eda6286200d";
    name = "websocket-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/gorilla/websocket";

    src = fetchFromGitHub {
      inherit rev;
      owner = "gorilla";
      repo = "websocket";
      sha256 = "09arvwlxw15maf4z8pcgjc25hd00mckqpdi0byafqfgm3nvvacvq";
    };
  };

  yaml-v1 = buildGoPackage rec {
    rev = "b0c168ac0cf9493da1f9bb76c34b26ffef940b4a";
    name = "yaml-v1-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "gopkg.in/yaml.v1";
    src = fetchgit {
      inherit rev;
      url = "https://github.com/go-yaml/yaml.git";
      sha256 = "0jbdy41pplf2d1j24qwr8gc5qsig6ai5ch8rwgvg72kq9q0901cy";
    };
  };

}; in self
