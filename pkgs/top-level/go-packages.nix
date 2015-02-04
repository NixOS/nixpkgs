/* This file defines the composition for Go packages. */

{ overrides, stdenv, go, buildGoPackage, git
,fetchgit, fetchhg, fetchurl, fetchFromGitHub }:

let self = _self // overrides; _self = with self; {

  inherit go buildGoPackage;

  ## OFFICIAL GO PACKAGES

  crypto = buildGoPackage rec {
    rev = "31393df5baea";
    name = "go-crypto-${rev}";
    goPackagePath = "code.google.com/p/go.crypto";
    src = fetchhg {
      inherit rev;
      url = "https://${goPackagePath}";
      sha256 = "0b95dpsvxxapcjjvhj05fdmyn0mzffamc25hvxy7xgsl2l9yy3nw";
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

  ## THIRD PARTY

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

  go-metrics = buildGoPackage rec {
    rev = "f770e6f5e91a8770cecee02d5d3f7c00b023b4df";
    name = "go-metrics-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/rcrowley/go-metrics";
    src = fetchFromGitHub {
      inherit rev;
      owner = "rcrowley";
      repo = "go-metrics";
      sha256 = "07dc74kiam8v5my7rhi3yxqrpnaapladhk8b3qbnrpjk3shvnx5f";
    };

    buildInputs = [ influxdb-go stathat ];
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
