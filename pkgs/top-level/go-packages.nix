/* This file defines the composition for Go packages. */

{ overrides, stdenv, go, buildGoPackage, git, pkgconfig, libusb
, fetchgit, fetchhg, fetchurl, fetchFromGitHub, fetchFromBitbucket, fetchbzr, pkgs }:

let
  isGo13 = go.meta.branch == "1.3";
  isGo14 = go.meta.branch == "1.4";

  buildFromGitHub = { rev, owner, repo, sha256, name ? repo, goPackagePath ? "github.com/${owner}/${repo}", ... }@args: buildGoPackage (args // {
    inherit rev goPackagePath;
    name = "${name}-${stdenv.lib.strings.substring 0 7 rev}";
    src  = fetchFromGitHub { inherit rev owner repo sha256; };
  });

  self = _self // overrides; _self = with self; {

  inherit go buildGoPackage;

  ## OFFICIAL GO PACKAGES

  crypto = buildFromGitHub {
    rev      = "4d48e5fa3d62b5e6e71260571bf76c767198ca02";
    disabled = isGo13;
    owner    = "golang";
    repo     = "crypto";
    sha256   = "0plvjv56afb02p7l3c2zfwffnhscmc3f0ckj1gls9ay6vj85y7l8";
    goPackagePath    = "golang.org/x/crypto";
    goPackageAliases = [ "code.google.com/p/go.crypto" ];
  };

  glog = buildFromGitHub {
    rev    = "44145f04b68cf362d9c4df2182967c2275eaefed";
    owner  = "golang";
    repo   = "glog";
    sha256 = "1k7sf6qmpgm0iw81gx2dwggf9di6lgw0n54mni7862hihwfrb5rq";
  };

  image = buildGoPackage rec {
    rev = "d8e202c6ce59fad0017414839b6648851d10767e";
    name = "image-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "golang.org/x/image";

    src = fetchFromGitHub {
      inherit rev;
      owner = "golang";
      repo = "image";
      sha256 = "0cxymm28rgbzsk76d19wm8fwp40dkwxhzmmdjnbkw5541272339l";
    };
  };

  net = buildGoPackage rec {
    rev = "d1d694760b7a3a9fa32e4d1c49e08b2d672221d8";
    name = "net-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "golang.org/x/net";
    goPackageAliases = [
      "code.google.com/p/go.net"
      "github.com/hashicorp/go.net"
    ];

    src = fetchFromGitHub {
      inherit rev;
      owner = "golang";
      repo = "net";
      sha256 = "1fk62vjxsyca8hmlpca9rkgy8wqg9zw920d56ib442sjn9ys3zic";
    };

    propagatedBuildInputs = [ text ];
  };

  oauth2 = buildGoPackage rec {
    rev = "f98d0160877ab4712b906626425ed8b0b320907c";
    name = "oauth2-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "golang.org/x/oauth2";

    src = fetchFromGitHub {
      inherit rev;
      owner = "golang";
      repo = "oauth2";
      sha256 = "0hi54mm63ha7a75avydj6xm0a4dd2njdzllr9y2si1i1wnijqw2i";
    };

    propagatedBuildInputs = [ net gcloud-golang-compute-metadata ];
  };


  protobuf = buildGoPackage rec {
    rev = "39e27fc0f226450c58e11eda145b542bc5dff3fe";
    name = "protobuf-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/golang/protobuf";
    goPackageAliases = [ "code.google.com/p/goprotobuf" ];

    src = fetchFromGitHub {
      inherit rev;
      owner = "golang";
      repo = "protobuf";
      sha256 = "12l036ix0dc8hg35xrqmdcr3bpwncrdkgqkhp3s90w6a3qpva3gs";
    };
  };

  gogo.protobuf = buildGoPackage rec {
    rev = "499788908625f4d83de42a204d1350fde8588e4f";
    name = "protobuf-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/gogo/protobuf";
    goPackageAliases = [ "code.google.com/p/gogoprotobuf/proto" "code.google.com/p/goprotobuf/proto" ];

    src = fetchFromGitHub {
      inherit rev;
      owner = "gogo";
      repo = "protobuf";
      sha256 = "09h2j0apl70709nbqasqrkss6fdk99xm7xr5ci311dl48rmm1dzn";
    };

    subPackages = [ "proto" ];
  };

  text = buildGoPackage rec {
    rev = "c93e7c9fff19fb9139b5ab04ce041833add0134e";
    name = "text-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "golang.org/x/text";

    src = fetchFromGitHub {
      inherit rev;
      owner = "golang";
      repo = "text";
      sha256 = "1yvmllriqjm0k97vnxycz9q0likvh18a68xbyg1k6ddkvn9sy03y";
    };
  };


  tools = buildGoPackage rec {
    rev = "7d75e8b219c3efda2d08ae38acd6b42f8da4f5f9";
    name = "tools-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "golang.org/x/tools";
    goPackageAliases = [ "code.google.com/p/go.tools" ];

    preConfigure = ''
      # Make the builtin tools available here
      mkdir -p $out/bin
      eval $(go env | grep GOTOOLDIR)
      find $GOTOOLDIR -type f | while read x; do
        ln -sv "$x" "$out/bin"
      done
      export GOTOOLDIR=$out/bin
    '';

    excludedPackages = "testdata";

    src = fetchFromGitHub {
      inherit rev;
      owner = "golang";
      repo = "tools";
      sha256 = "0vq0l3pjhgsp97v6ndlr3jcs029r5zilwai30snwfq74s580sriq";
    };

    buildInputs = [ net ];
  };

  ## THIRD PARTY

  airbrake-go = buildFromGitHub {
    rev    = "5b5e269e1bc398d43f67e43dafff3414a59cd5a2";
    owner  = "tobi";
    repo   = "airbrake-go";
    sha256 = "1bps4y3vpphpj63mshjg2aplh579cvqac0hz7qzvac0d1fqcgkdz";
  };

  ansicolor = buildFromGitHub {
    rev    = "8368d3b31cf6f2c2464c7a91675342c9a0ac6658";
    owner  = "shiena";
    repo   = "ansicolor";
    sha256 = "1fyn06vxm44s0ph8pr7r9gkab1f4x851zlyy3p6jbbwsa6an8g9w";
  };

  asn1-ber = buildGoPackage rec {
    rev = "295c7b21db5d9525ad959e3382610f3aff029663";
    name = "asn1-ber-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/vanackere/asn1-ber";
    goPackageAliases = [
      "github.com/nmcclain/asn1-ber"
    ];

    src = fetchFromGitHub {
      inherit rev;
      owner  = "vanackere";
      repo   = "asn1-ber";
      sha256 = "1zamvcbk2xk3vznvckgqmdag32nlv7ip0fr1cc0z9ggai22ddh8n";
    };
  };

  assertions = buildGoPackage rec {
    version = "1.5.0";
    name = "assertions-${version}";
    goPackagePath = "github.com/smartystreets/assertions";
    src = fetchurl {
      name = "${name}.tar.gz";
      url = "https://github.com/smartystreets/assertions/archive/${version}.tar.gz";
      sha256 = "1s4b0v49yv7jmy4izn7grfqykjrg7zg79dg5hsqr3x40d5n7mk02";
    };
    buildInputs = [ oglematchers ];
    propagatedBuildInputs = [ goconvey ];
    # subPackages = [];
    doCheck = false;
  };

  aws-sdk-go = buildGoPackage rec {
    rev = "5e038f730cbb99b144eeb1dbf92cd06c2d00b503";
    name = "aws-sdk-go-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/awslabs/aws-sdk-go";
    goPackageAliases = [
      "github.com/hashicorp/aws-sdk-go"
    ];

    src = fetchFromGitHub {
      inherit rev;
      owner  = "awslabs";
      repo   = "aws-sdk-go";
      sha256 = "1725y3aic53l8ms0583gdn0s915y1b783hs339qll0mmx7v09in5";
    };

    buildInputs = [ go-ini gucumber testify ];
  };

  hashicorp.aws-sdk-go = buildGoPackage rec {
    rev = "e6ea0192eee4640f32ec73c0cbb71f63e4f2b65a";
    name = "aws-sdk-go-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/hashicorp/aws-sdk-go";

    src = fetchFromGitHub {
      inherit rev;
      owner  = "hashicorp";
      repo   = "aws-sdk-go";
      sha256 = "1qrc2jl38marbarnl31sag7s0h18j2wx1cxkcqin5m1pqg62p4cn";
    };

    buildInputs = [ go-ini net sandblast ];
  };

  binarydist = buildFromGitHub {
    rev    = "9955b0ab8708602d411341e55fffd7e0700f86bd";
    owner  = "kr";
    repo   = "binarydist";
    sha256 = "11wncbbbrdcxl5ff3h6w8vqfg4bxsf8709mh6vda0cv236flkyn3";
  };

  bolt = buildFromGitHub {
    rev    = "957d850b5158a4eebf915476058e720f43459584";
    owner  = "boltdb";
    repo   = "bolt";
    sha256 = "193adhhsqdy0kyq1l1fi8pg2n6pwyrw4h607qm78qyi26f8i7vzf";
  };

  bufio = buildFromGitHub {
    rev    = "24e7e48f60fc2d9e99e43c07485d9fff42051e66";
    owner  = "vmihailenco";
    repo   = "bufio";
    sha256 = "0x46qnf2f15v7m0j2dcb16raxjamk5rdc7hqwgyxfr1sqmmw3983";
  };

  bugsnag-go = buildGoPackage rec {
    rev = "v1.0.3";
    name = "bugsnag-go-${rev}";
    goPackagePath = "github.com/bugsnag/bugsnag-go";

    src = fetchFromGitHub {
      inherit rev;
      owner  = "bugsnag";
      repo   = "bugsnag-go";
      sha256 = "1ymi5hrvd2nyfwfd12xll43gn00ii3bjb5ma9dfhaaxv2asi3ajx";
    };

    propagatedBuildInputs = [ panicwrap revel ];
  };

  cascadia = buildGoPackage rec {
    rev = "54abbbf07a45a3ef346ebe903e0715d9a3c19352"; #master
    name = "cascadia-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/andybalholm/cascadia";
    goPackageAliases = [ "code.google.com/p/cascadia" ];
    propagatedBuildInputs = [ net ];
    buildInputs = propagatedBuildInputs;
    doCheck = true;

    src = fetchFromGitHub {
      inherit rev;
      owner = "andybalholm";
      repo = "cascadia";
      sha256 = "1z21w6p5bp7mi2pvicvcqc871k9s8a6262pkwyjm2qfc859c203m";
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

  circbuf = buildFromGitHub {
    rev    = "f092b4f207b6e5cce0569056fba9e1a2735cb6cf";
    owner  = "armon";
    repo   = "circbuf";
    sha256 = "06kwwdwa3hskdh6ws7clj1vim80dyc3ldim8k9y5qpd30x0avn5s";
  };

  cli = buildGoPackage rec {
    rev = "6cc8bc522243675a2882b81662b0b0d2e04b99c9";
    name = "cli-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/mitchellh/cli";

    src = fetchFromGitHub {
      inherit rev;
      owner = "mitchellh";
      repo = "cli";
      sha256 = "05w9ypliva9lyn3h4rahznj04mh0fws7vaqlwhxfs5nnd5g03dma";
    };

    propagatedBuildInputs = [ crypto ];
  };

  cli-spinner = buildFromGitHub {
    rev    = "610063bb4aeef25f7645b3e6080456655ec0fb33";
    owner  = "odeke-em";
    repo   = "cli-spinner";
    sha256 = "13wzs2qrxd72ah32ym0ppswhvyimjw5cqaq3q153y68vlvxd048c";
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

  cli-go = buildFromGitHub {
    rev    = "v1.2.0";
    owner  = "codegangsta";
    repo   = "cli";
    sha256 = "1axcpc8wgs0b66dpl36pz97pqbxkgvvbwz1b6rf7gl103jqpii40";
  };

  columnize = buildFromGitHub {
    rev    = "44cb4788b2ec3c3d158dd3d1b50aba7d66f4b59a";
    owner  = "ryanuber";
    repo   = "columnize";
    sha256 = "1qrqr76cw58x2hkjic6h88na5ihgvkmp8mqapj8kmjcjzdxkzhr9";
  };

  command = buildFromGitHub {
    rev    = "076a2ad5f3a7ec92179f2d57208728432280ec4e";
    owner  = "odeke-em";
    repo   = "command";
    sha256 = "093as4kxlabk3hrsd52kr9fhl6qafr4ghg89cjyglsva0mk0n7sb";
  };

  copystructure = buildGoPackage rec {
    rev = "6fc66267e9da7d155a9d3bd489e00dad02666dc6";
    name = "copystructure-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/mitchellh/copystructure";

    src = fetchFromGitHub {
      inherit rev;
      owner = "mitchellh";
      repo = "copystructure";
      sha256 = "193s5vhw68d8npjyf5yvc5j24crazvy7d5dk316hl7590qrmbxrd";
    };

    buildInputs = [ reflectwalk ];
  };

  confd = buildGoPackage rec {
    rev = "v0.9.0";
    name = "confd-${rev}";
    goPackagePath = "github.com/kelseyhightower/confd";
    preBuild = "export GOPATH=$GOPATH:$NIX_BUILD_TOP/go/src/${goPackagePath}/Godeps/_workspace";
    src = fetchFromGitHub {
      inherit rev;
      owner = "kelseyhightower";
      repo = "confd";
      sha256 = "0rz533575hdcln8ciqaz79wbnga3czj243g7fz8869db6sa7jwlr";
    };
    subPackages = [ "./" ];
  };

  config = buildFromGitHub {
    rev    = "0f78529c8c7e3e9a25f15876532ecbc07c7d99e6";
    owner  = "robfig";
    repo   = "config";
    sha256 = "0xmxy8ay0wzd307x7xba3rmigvr6rjlpfk9fmn6ir2nc97ifv3i0";
  };

  consul = buildGoPackage rec {
    rev = "v0.5.2";
    name = "consul-${rev}";
    goPackagePath = "github.com/hashicorp/consul";

    src = fetchFromGitHub {
      inherit rev;
      owner = "hashicorp";
      repo = "consul";
      sha256 = "0p3lc1p346a5ipvkf15l94gn1ml3m7zz6bx0viark3hsv0a7iij7";
    };

    buildInputs = [
      circbuf armon.go-metrics go-radix gomdb bolt consul-migrate go-checkpoint
      ugorji.go go-multierror go-syslog golang-lru hcl logutils memberlist
      net-rpc-msgpackrpc raft raft-boltdb raft-mdb scada-client serf yamux
      muxado dns cli mapstructure columnize crypto
    ];

    # Keep consul.ui for backward compatability
    passthru.ui = pkgs.consul-ui;
  };

  consul-alerts = buildGoPackage rec {
    rev = "7dff28aa4c8c883a65106f8ec22796e1a589edab";
    name = "consul-alerts-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/AcalephStorage/consul-alerts";

    renameImports = ''
      # Remove all references to included dependency store
      rm -rf go/src/${goPackagePath}/Godeps
      govers -d -m github.com/AcalephStorage/consul-alerts/Godeps/_workspace/src/ ""

      # Fix references to consul-api
      govers -d -m github.com/armon/consul-api github.com/hashicorp/consul/api
      sed -i 's,consulapi,api,g' go/src/${goPackagePath}/consul/client.go
      sed -i 's,consulapi,api,g' go/src/${consul-skipper.goPackagePath}/skipper.go
    '';

    src = fetchFromGitHub {
      inherit rev;
      owner = "AcalephStorage";
      repo = "consul-alerts";
      sha256 = "1vwybkvjgyilxk3l6avzivd31l8gnk8d0v7bl10qll0cd068fabq";
    };

    # We just want the consul api not all of consul
    extraSrcs = [
      { inherit (consul) src goPackagePath; }
      { inherit (influxdb8) src goPackagePath; }
      { inherit (consul-skipper) src goPackagePath; }
    ];

    buildInputs = [ logrus docopt-go hipchat-go gopherduty ];
  };

  consul-migrate = buildGoPackage rec {
    rev = "4977886fc950a0db1a6f0bbadca56dfabf170f9c";
    name = "consul-migrate-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/hashicorp/consul-migrate";

    src = fetchFromGitHub {
      inherit rev;
      owner = "hashicorp";
      repo = "consul-migrate";
      sha256 = "0kjziwhz1ifj4wpy5viba6z17sfgjjibdhnn73ffp7q5q8abg8w3";
    };

    buildInputs = [ raft raft-boltdb raft-mdb ];
  };

  consul-skipper = buildGoPackage rec {
    rev = "729b4fdcc7f572f7c083673595f939256b80b76f";
    name = "consul-skipper-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/darkcrux/consul-skipper";

    renameImports = ''
      govers -d -m github.com/armon/consul-api github.com/hashicorp/consul/api
      sed -i 's,consulapi,api,g' go/src/${goPackagePath}/skipper.go
    '';

    src = fetchFromGitHub {
      inherit rev;
      owner = "darkcrux";
      repo = "consul-skipper";
      sha256 = "0shqvihbmq1w5ddnkn62qd4k6gs5zalq6k4alacjz92bwf6d2x6x";
    };

    # We just want the consul api not all of consul
    extraSrcs = [
      { inherit (consul) src goPackagePath; }
    ];

    buildInputs = [ logrus ];
  };

  consul-template = buildGoPackage rec {
    rev = "v0.9.0";
    name = "consul-template-${rev}";
    goPackagePath = "github.com/hashicorp/consul-template";

    src = fetchFromGitHub {
      inherit rev;
      owner = "hashicorp";
      repo = "consul-template";
      sha256 = "1k64rjskzn7cxn7rxab978847jq8gr4zj4cnzgznhn44nzasgymj";
    };

    # We just want the consul api not all of consul and vault
    extraSrcs = [
      { inherit (consul) src goPackagePath; }
      { inherit (vault) src goPackagePath; }
    ];

    buildInputs = [ go-multierror go-syslog hcl logutils mapstructure ];
  };

  context = buildGoPackage rec {
    rev = "215affda49addc4c8ef7e2534915df2c8c35c6cd";
    name = "config-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/gorilla/context";

    src = fetchFromGitHub {
      inherit rev;
      owner = "gorilla";
      repo = "context";
      sha256 = "1ybvjknncyx1f112mv28870n0l7yrymsr0861vzw10gc4yn1h97g";
    };
  };

  cookoo = buildFromGitHub {
    rev    = "v1.2.0";
    owner  = "Masterminds";
    repo   = "cookoo";
    sha256 = "1mxqnxddny43k1shsvd39sfzfs0d20gv3vm9lcjp04g3b0rplck1";
  };

  dbus = buildGoPackage rec {
    rev = "a5942dec6340eb0d57f43f2003c190ce06e43dea";
    name = "dbus-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/godbus/dbus";

    excludedPackages = "examples";

    src = fetchFromGitHub {
      inherit rev;
      owner = "godbus";
      repo = "dbus";
      sha256 = "1vk31wal7ncvjwvnb8q1myrkihv1np46f3q8dndi5k0csflbxxdf";
    };
  };

  dns = buildFromGitHub {
    rev    = "bb1103f648f811d2018d4bedcb2d4b2bce34a0f1";
    owner  = "miekg";
    repo   = "dns";
    sha256 = "1c1gasvzlcmgwyqhksm656p03nc76kxjxllbcw9bwfy5v7p9w7qq";
  };

  docopt-go = buildFromGitHub {
    rev    = "854c423c810880e30b9fecdabb12d54f4a92f9bb";
    owner  = "docopt";
    repo   = "docopt-go";
    sha256 = "1sddkxgl1pwlipfvmv14h8vg9b9wq1km427j1gjarhb5yfqhh3l1";
  };

  dts = buildFromGitHub {
    rev    = "ec2daabf2f9078e887405f7bcddb3d79cb65502d";
    owner  = "odeke-em";
    repo   = "dts";
    sha256 = "0vq3cz4ab9vdsz9s0jjlp7z27w218jjabjzsh607ps4i8m5d441s";
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

  errwrap = buildFromGitHub {
    rev    = "7554cd9344cec97297fa6649b055a8c98c2a1e55";
    owner  = "hashicorp";
    repo   = "errwrap";
    sha256 = "0kmv0p605di6jc8i1778qzass18m0mv9ks9vxxrfsiwcp4la82jf";
  };

  etcd = buildFromGitHub {
    rev    = "v2.1.1";
    owner  = "coreos";
    repo   = "etcd";
    sha256 = "0jd97091jwwdvx50vbdi1py9v5w9fk86cw85p0zinb0ww6bs4y0s";
    excludedPackages = "Godeps";
  };

  fsnotify.v0 = buildGoPackage rec {
    rev = "v0.9.3";
    name = "fsnotify.v0-${rev}";
    goPackagePath = "gopkg.in/fsnotify.v0";
    goPackageAliases = [ "github.com/howeyc/fsnotify" ];

    src = fetchFromGitHub {
      inherit rev;
      owner = "go-fsnotify";
      repo = "fsnotify";
      sha256 = "15wqjpkfzsxnaxbz6y4r91hw6812g3sc4ipagxw1bya9klbnkdc9";
    };
  };

  fsnotify.v1 = buildGoPackage rec {
    rev = "v1.2.0";
    name = "fsnotify.v1-${rev}";
    goPackagePath = "gopkg.in/fsnotify.v1";

    src = fetchFromGitHub {
      inherit rev;
      owner = "go-fsnotify";
      repo = "fsnotify";
      sha256 = "1308z1by82fbymcra26wjzw7lpjy91kbpp2skmwqcq4q1iwwzvk2";
    };
  };

  g2s = buildFromGitHub {
    rev    = "ec76db4c1ac16400ac0e17ca9c4840e1d23da5dc";
    owner  = "peterbourgon";
    repo   = "g2s";
    sha256 = "1p4p8755v2nrn54rik7yifpg9szyg44y5rpp0kryx4ycl72307rj";
  };

  gcloud-golang = buildGoPackage rec {
    rev = "de1c38e5af44da22abe7c3b14a1edcf6264dae55";
    name = "gcloud-golang-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "google.golang.org/cloud";

    src = fetchFromGitHub {
      inherit rev;
      owner = "GoogleCloudPlatform";
      repo = "gcloud-golang";
      sha256 = "0n6sh1zblixwyc9ykbsknmadsx2dmn3b5rsyrs30id1f96pgh4l0";
    };

    buildInputs = [ net oauth2 protobuf google-api-go-client grpc ];
  };

  gcloud-golang-compute-metadata = buildGoPackage rec {
    inherit (gcloud-golang) rev name goPackagePath src;
    subPackages = [ "compute/metadata" ];
    buildInputs = [ net ];
  };

  ginkgo = buildGoPackage rec {
    rev = "5ed93e443a4b7dfe9f5e95ca87e6082e503021d2";
    name = "ginkgo-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/onsi/ginkgo";
    src = fetchFromGitHub {
      inherit rev;
      owner = "onsi";
      repo = "ginkgo";
      sha256 = "0ghrx5qmgvgb8cbvsj53v1ir4j9agilg4wyhpk5ikqdv6mmqly4h";
    };
    subPackages = [ "./" ];  # don't try to build test fixtures
  };

  glide = buildFromGitHub {
    rev    = "0.4.1";
    owner  = "Masterminds";
    repo   = "glide";
    sha256 = "0237l8s7z1ysfkv3kmw4788fg4kjcq2sh6073bjcwynz3hldkrlr";
    buildInputs = [ cookoo cli-go go-gypsy ];
  };

  gls = buildFromGitHub {
    rev    = "9a4a02dbe491bef4bab3c24fd9f3087d6c4c6690";
    owner  = "jtolds";
    repo   = "gls";
    sha256 = "1gvgkx7llklz6plapb95fcql7d34i6j7anlvksqhdirpja465jnm";
  };

  ugorji.go = buildGoPackage rec {
    rev = "821cda7e48749cacf7cad2c6ed01e96457ca7e9d";
    name = "ugorji-go-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/ugorji/go";
    goPackageAliases = [ "github.com/hashicorp/go-msgpack" ];

    src = fetchFromGitHub {
      inherit rev;
      owner = "ugorji";
      repo = "go";
      sha256 = "1ay1l6gijxjgc7j0093drp5mjm93fmrp7r20qbqz4k05l43mqb3j";
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

  goautoneg = buildGoPackage rec {
    rev = "75cd24fc2f2c2a2088577d12123ddee5f54e0675";
    name = "goautoneg-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "bitbucket.org/ww/goautoneg";

    src = fetchhg {
      inherit rev;
      url = "https://${goPackagePath}";
      sha256 = "19khhn5xhqv1yp7d6k987gh5w5rhrjnp4p0c6fyrd8z6lzz5h9qi";
    };
  };

  dgnorton.goback = buildFromGitHub {
    rev    = "a49ca3c0a18f50ae0b8a247e012db4385e516cf4";
    owner  = "dgnorton";
    repo   = "goback";
    sha256 = "1nyg6sckwd0iafs9vcmgbga2k3hid2q0avhwj29qbdhj3l78xi47";
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

  gocolorize = buildGoPackage rec {
    rev = "v1.0.0";
    name = "gocolorize-${rev}";
    goPackagePath = "github.com/agtorre/gocolorize";

    src = fetchFromGitHub {
      inherit rev;
      owner = "agtorre";
      repo = "gocolorize";
      sha256 = "1dj7s8bgw9qky344d0k9gz661c0m317a08a590184drw7m51hy9p";
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

  gomdb = buildFromGitHub {
    rev    = "151f2e08ef45cb0e57d694b2562f351955dff572";
    owner  = "armon";
    repo   = "gomdb";
    sha256 = "02wdhgfarmmwfbc75snd1dh6p9k9c1y2135apdm6mkr062qlxx61";
  };

  influx.gomdb = buildFromGitHub {
    rev    = "29fe330c5ab33c4e48470bd4b980bf522471190a";
    owner  = "influxdb";
    repo   = "gomdb";
    sha256 = "0yg1jpr7lcaqh6i8n9wbs9r128kk541qjv06r9a6fp9vj56rqr3m";
  };

  govers = buildGoPackage rec {
    rev = "3b5f175f65d601d06f48d78fcbdb0add633565b9";
    name = "govers-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/rogpeppe/govers";
    dontRenameImports = true;
    src = fetchFromGitHub {
      inherit rev;
      owner = "rogpeppe";
      repo = "govers";
      sha256 = "0din5a7nff6hpc4wg0yad2nwbgy4q1qaazxl8ni49lkkr4hyp8pc";
    };
  };

  golang-lru = buildFromGitHub {
    rev    = "995efda3e073b6946b175ed93901d729ad47466a";
    owner  = "hashicorp";
    repo   = "golang-lru";
    sha256 = "0ilnzg9qq2pfa8qb9yd25s5afi0fvsm78kqzqy39kgg8zsx70xyj";
  };

  golang_protobuf_extensions = buildGoPackage rec {
    rev = "fc2b8d3a73c4867e51861bbdd5ae3c1f0869dd6a";
    name = "golang-protobuf-extensions-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/matttproud/golang_protobuf_extensions";

    src = fetchFromGitHub {
      inherit rev;
      owner = "matttproud";
      repo = "golang_protobuf_extensions";
      sha256 = "0ajg41h6402big484drvm72wvid1af2sffw0qkzbmpy04lq68ahj";
    };

    buildInputs = [ protobuf ];
  };

  goleveldb = buildGoPackage rec {
    rev = "e9e2c8f6d3b9c313fb4acaac5ab06285bcf30b04";
    name = "goleveldb-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/syndtr/goleveldb";
    src = fetchFromGitHub {
      inherit rev;
      owner = "syndtr";
      repo = "goleveldb";
      sha256 = "0vg3pcrbdhbmanwkc5njxagi64f4k2ikfm173allcghxcjamrkwv";
    };
    propagatedBuildInputs = [ ginkgo gomega gosnappy ];
  };

  gollectd = buildFromGitHub {
    rev    = "cf6dec97343244b5d8a5485463675d42f574aa2d";
    owner  = "kimor79";
    repo   = "gollectd";
    sha256 = "1f3ml406cprzjc192csyr2af4wcadkc74kg8n4c0zdzglxxfsqxa";
  };

  gomega = buildFromGitHub {
    rev    = "8adf9e1730c55cdc590de7d49766cb2acc88d8f2";
    owner  = "onsi";
    repo   = "gomega";
    sha256 = "1rf6cxn50d1pji3pv4q372s395r5nxwcgp405z2r2mfdkri4v3w4";
  };

  gomemcache = buildFromGitHub {
    rev    = "72a68649ba712ee7c4b5b4a943a626bcd7d90eb8";
    owner  = "bradfitz";
    repo   = "gomemcache";
    sha256 = "1r8fpzwhakq8fsppc33n4iivq1pz47xhs0h6bv4x5qiip5mswwvg";
  };

  google-api-go-client = buildGoPackage rec {
    rev = "34c5554e6406f7f715ede3616b39034247545ce0";
    name = "google-api-go-client-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "google.golang.org/api";

    preBuild = ''
      rm -rf go/src/${goPackagePath}/examples
    '';

    src = fetchFromGitHub {
      inherit rev;
      owner = "google";
      repo = "google-api-go-client";
      sha256 = "1496h0xc7vjklr4m4j7vy1764k1qk2grpcwz5zssgplpfs9s9wfz";
    };

    buildInputs = [ net ];
  };

  odeke-em.google-api-go-client = buildGoPackage rec {
    rev = "30f4c144b02321ebbc712f35dc95c3e72a5a7fdc";
    name = "odeke-em-google-api-go-client-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/odeke-em/google-api-go-client";
    src = fetchFromGitHub {
      inherit rev;
      owner = "odeke-em";
      repo = "google-api-go-client";
      sha256 = "1fidlljxnd82i2r9yia0b9gh0vv3hwb5k65papnvw7sqpc4sriby";
    };
    preBuild = ''
      rm -rf go/src/${goPackagePath}/examples
    '';
    buildInputs = [ net ];
    propagatedBuildInputs = [ google-api-go-client ];
  };

  gopass = buildGoPackage rec {
    rev = "2c70fa70727c953c51695f800f25d6b44abb368e";
    name = "gopass-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/howeyc/gopass";
    src = fetchFromGitHub {
      inherit rev;
      owner = "howeyc";
      repo = "gopass";
      sha256 = "152lrkfxk205rlxiign0w5wb0fmfh910yz4jhlv4f4l1qr1h2lx8";
    };
    buildInputs = [ crypto ];
  };

  gopherduty = buildFromGitHub {
    rev    = "f4906ce7e59b33a50bfbcba93e2cf58778c11fb9";
    owner  = "darkcrux";
    repo   = "gopherduty";
    sha256 = "11w1yqc16fxj5q1y5ha5m99j18fg4p9lyqi542x2xbrmjqqialcf";
  };

  gosnappy = buildFromGitHub {
    rev    = "ce8acff4829e0c2458a67ead32390ac0a381c862";
    owner  = "syndtr";
    repo   = "gosnappy";
    sha256 = "0ywa52kcii8g2a9lbqcx8ghdf6y56lqq96sl5nl9p6h74rdvmjr7";
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
      description = "A small utility which generates Go code from any file, useful for embedding binary data in a Go program";
      maintainers = with maintainers; [ cstrahan ];
      license     = licenses.cc0 ;
      platforms   = platforms.all;
    };
  };

  pmylund.go-cache = buildGoPackage rec {
    rev = "93d85800f2fa6bd0a739e7bd612bfa3bc008b72d";
    name = "go-cache-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/pmylund/go-cache";
    goPackageAliases = [
      "github.com/robfig/go-cache"
      "github.com/influxdb/go-cache"
    ];

    src = fetchFromGitHub {
      inherit rev;
      owner = "pmylund";
      repo = "go-cache";
      sha256 = "08wfwm7nk381lv6a95p0hfgqwaksn0vhzz1xxdncjdw6w71isyy7";
    };
  };

  robfig.go-cache = buildFromGitHub {
    rev    = "9fc39e0dbf62c034ec4e45e6120fc69433a3ec51";
    owner  = "robfig";
    repo   = "go-cache";
    sha256 = "032nh3y43bpzpcm7bdkxfh55aydvzc2jzhigvy5gd9f648m4j9ha";
  };

  go-checkpoint = buildFromGitHub {
    rev    = "88326f6851319068e7b34981032128c0b1a6524d";
    owner  = "hashicorp";
    repo   = "go-checkpoint";
    sha256 = "1npasn9lmvx57nw3wkswwvl5k0wmn01jpalbwv832x5wq4r0nsz4";
  };

  go-colortext = buildFromGitHub {
    rev    = "13eaeb896f5985a1ab74ddea58707a73d875ba57";
    owner  = "daviddengcn";
    repo   = "go-colortext";
    sha256 = "0618xs9lc5xfp5zkkb5j47dr7i30ps3zj5fj0zpv8afqh2cc689x";
  };

  go-etcd = buildGoPackage rec {
    rev = "4734e7aca379f0d7fcdf04fbb2101696a4b45ce8";
    name = "go-etcd-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/coreos/go-etcd";
    disabled = isGo13;

    src = fetchFromGitHub {
      inherit rev;
      owner = "coreos";
      repo = "go-etcd";
      sha256 = "0zqr7mzd5kq0rnxj3zx5x5wwbmjkg365farwv72hzrsvq6g8zczr";
    };
    buildInputs = [ pkgs.etcd ];
  };

  go-flags = buildFromGitHub {
    rev    = "5e118789801496c93ba210d34ef1f2ce5a9173bd";
    owner  = "jessevdk";
    repo   = "go-flags";
    sha256 = "1davr5h936fhc8zy7digp5yqxr216d1mshksr7iiad5xb3r8r9ja";
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

  go-github = buildGoPackage rec {
    rev = "9eb187bac4eba6fff5a54f80550b2df73b651523";
    name = "go-github-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/google/go-github";

    src = fetchFromGitHub {
      inherit rev;
      owner = "google";
      repo = "go-github";
      sha256 = "123ck9nf5ggdrndg2gs1bhr4ysh4z0izph9sp7ciisxpgjkaycxq";
    };

    buildInputs = [ go-querystring oauth2 ];
  };

  go-gypsy = buildFromGitHub {
    rev    = "42fc2c7ee9b8bd0ff636cd2d7a8c0a49491044c5";
    owner  = "kylelemons";
    repo   = "go-gypsy";
    sha256 = "04iy8rdk19n7i18bqipknrcb8lsy1vr4d1iqyxsxq6rmb7298iwj";
  };

  go-homedir = buildFromGitHub {
    rev    = "7d2d8c8a4e078ce3c58736ab521a40b37a504c52";
    owner  = "mitchellh";
    repo   = "go-homedir";
    sha256 = "1ixhwxnvq1qx53asq47yhg3l88ndwrnyw4fkkidcjg759dc86d0i";
  };

  go-hostpool = buildFromGitHub {
    rev    = "fed86fae5cacdc77e7399937e2f8836563620a2e";
    owner  = "bitly";
    repo   = "go-hostpool";
    sha256 = "0nbssfp5ksj4hhc0d8lfq54afd9nqv6qzk3vi6rinxr3fgplrj44";
  };

  go-ini = buildFromGitHub {
    rev    = "a98ad7ee00ec53921f08832bc06ecf7fd600e6a1";
    owner  = "vaughan0";
    repo   = "go-ini";
    sha256 = "1l1isi3czis009d9k5awsj4xdxgbxn4n9yqjc1ac7f724x6jacfa";
  };

  go-isatty = buildFromGitHub {
    rev    = "ae0b1f8f8004be68d791a576e3d8e7648ab41449";
    owner  = "mattn";
    repo   = "go-isatty";
    sha256 = "0qrcsh7j9mxcaspw8lfxh9hhflz55vj4aq1xy00v78301czq6jlj";
  };

  go-log = buildGoPackage rec {
    rev = "70d039bee4b0e389e5be560491d8291708506f59";
    name = "go-log-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/coreos/go-log";

    src = fetchFromGitHub {
      inherit rev;
      owner = "coreos";
      repo = "go-log";
      sha256 = "1s95xmmhcgw4ascf4zr8c4ij2n4s3mr881nxcpmc61g0gb722b13";
    };

    propagatedBuildInputs = [ osext go-systemd ];
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

    buildInputs = [ influxdb8 stathat ];
  };

  appengine = buildGoPackage rec {
    rev = "25b8450bec636c6b6e3b9b33d3a3f55230b10812";
    name = "appengine-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "google.golang.org/appengine";
    src = fetchFromGitHub {
      inherit rev;
      owner = "golang";
      repo = "appengine";
      sha256 = "1b0v244hmw8078601v18xda501aix0kw4q2m1g3ai33dl0p2dh2n";
    };
    buildInputs = [ protobuf net ];
  };

  armon.go-metrics = buildGoPackage rec {
    rev = "a54701ebec11868993bc198c3f315353e9de2ed6";
    name = "armon.go-metrics-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/armon/go-metrics";

    src = fetchFromGitHub {
      inherit rev;
      owner = "armon";
      repo = "go-metrics";
      sha256 = "0ia9i96nac7vnmf5qb98rs74npf3vg55kdsvmql8cwgfpmqqcfdh";
    };

    propagatedBuildInputs = [ prometheus.client_golang ];
  };

  go-multierror = buildFromGitHub {
    rev    = "fcdddc395df1ddf4247c69bd436e84cfa0733f7e";
    owner  = "hashicorp";
    repo   = "go-multierror";
    sha256 = "1gvrm2bqi425mfg55m01z9gppfd7v4ljz1z8bykmh2sc82fj25jz";
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

  go-options = buildFromGitHub {
    rev    = "896a539cd709f4f39d787562d1583c016ce7517e";
    owner  = "mreiferson";
    repo   = "go-options";
    sha256 = "0hg0n5grcjcj5719rqchz0plp39wfk3znqxw8y354k4jwsqwmn17";
  };

  go-querystring = buildFromGitHub {
    rev    = "547ef5ac979778feb2f760cdb5f4eae1a2207b86";
    owner  = "google";
    repo   = "go-querystring";
    sha256 = "00ani7fhydcmlsm3n93nmj1hcqp2wmzvihnb1gdzynif1hw0530y";
  };

  go-radix = buildFromGitHub {
    rev    = "0bab926c3433cfd6490c6d3c504a7b471362390c";
    owner  = "armon";
    repo   = "go-radix";
    sha256 = "0llq96lxh7p9426hjii8k42kq0cp1hflawh1kjwhbmi5g0jrq04d";
  };

  junegunn.go-runewidth = buildGoPackage rec {
    rev = "travisish";
    name = "go-runewidth-${rev}";
    goPackagePath = "github.com/junegunn/go-runewidth";
    src = fetchFromGitHub {
      inherit rev;
      owner = "junegunn";
      repo = "go-runewidth";
      sha256 = "07d612val59sibqly5d6znfkp4h4gjd77783jxvmiq6h2fwb964k";
    };
  };

  go-shellwords = buildGoPackage rec {
    rev = "35d512af75e283aae4ca1fc3d44b159ed66189a4";
    name = "go-shellwords-${rev}";
    goPackagePath = "github.com/junegunn/go-shellwords";
    src = fetchFromGitHub {
      inherit rev;
      owner = "junegunn";
      repo = "go-shellwords";
      sha256 = "c792abe5fda48d0dfbdc32a84edb86d884a0ccbd9ed49ad48a30cda5ba028a22";
    };
  };

  go-runit = buildFromGitHub {
    rev    = "a9148323a615e2e1c93b7a9893914a360b4945c8";
    owner  = "soundcloud";
    repo   = "go-runit";
    sha256 = "00f2rfhsaqj2wjanh5qp73phx7x12a5pwd7lc0rjfv68l6sgpg2v";
  };

  go-simplejson = buildFromGitHub {
    rev    = "1cfceb0e12f47ec02665ef480212d7b531d6f4c5";
    owner  = "bitly";
    repo   = "go-simplejson";
    sha256 = "1d8x0himl58qn87lv418djy6mbs66p9ai3zpqq13nhkfl67fj3bi";
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

  go-syslog = buildFromGitHub {
    rev    = "42a2b573b664dbf281bd48c3cc12c086b17a39ba";
    owner  = "hashicorp";
    repo   = "go-syslog";
    sha256 = "1j53m2wjyczm9m55znfycdvm4c8vfniqgk93dvzwy8vpj5gm6sb3";
  };

  go-systemd = buildGoPackage rec {
    rev = "2688e91251d9d8e404e86dd8f096e23b2f086958";
    name = "go-systemd-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/coreos/go-systemd";
    disabled = isGo13;

    excludedPackages = "examples";

    src = fetchFromGitHub {
      inherit rev;
      owner = "coreos";
      repo = "go-systemd";
      sha256 = "0c1k3y5msc1xplhx0ksa7g08yqjaavns8s5zrfg4ig8az30gwlpa";
    };

    buildInputs = [ dbus ];
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

  go-vhost = buildFromGitHub {
    rev    = "c4c28117502e4bf00960c8282b2d1c51c865fe2c";
    owner  = "inconshreveable";
    repo   = "go-vhost";
    sha256 = "1rway6sls6fl2s2jk20ajj36rrlzh9944ncc9pdd19kifix54z32";
  };

  go-zookeeper = buildFromGitHub {
    rev    = "d0e0d8e11f318e000a8cc434616d69e329edc374";
    owner  = "samuel";
    repo   = "go-zookeeper";
    sha256 = "0v6g14ygnjl1l2fykyfjyvnab82a70jy0zzmsn5swlyy45b9gq2d";
  };

  goquery = buildGoPackage rec {
    rev = "f065786d418c9d22a33cad33decd59277af31471"; #tag v.0.3.2
    name = "goquery-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/PuerkitoBio/goquery";
    propagatedBuildInputs = [ cascadia net ];
    buildInputs = [ cascadia net ];
    doCheck = true;
    src = fetchFromGitHub {
      inherit rev;
      owner = "PuerkitoBio";
      repo = "goquery";
      sha256 = "0bskm3nja1v3pmg7g8nqjkmpwz5p72h1h81y076x1z17zrjaw585";
    };
  };

  grafana = buildGoPackage rec {
    version = "2.0.0-beta1";
    name = "grafana-v${version}";
    goPackagePath = "github.com/grafana/grafana";
    preBuild = "export GOPATH=$GOPATH:$NIX_BUILD_TOP/go/src/${goPackagePath}/Godeps/_workspace";
    src = fetchFromGitHub {
      rev = "v${version}";
      owner = "grafana";
      repo = "grafana";
      sha256 = "1b263qj7n72xc5qn0hhrlivqrd0zc8746c9ic11kdxyf81nx4lza";
    };
    subPackages = [ "./" ];
  };

  grpc = buildGoPackage rec {
    rev = "f5ebd86be717593ab029545492c93ddf8914832b";
    name = "grpc-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "google.golang.org/grpc";

    src = fetchFromGitHub {
      inherit rev;
      owner = "grpc";
      repo = "grpc-go";
      sha256 = "07dfpwwk68rrhxmqj69gq2ncsf3kfmn0zhlwscda0gc5gb57n5x1";
    };

    buildInputs = [ gcloud-golang-compute-metadata ];
    propagatedBuildInputs = [ http2 glog net protobuf oauth2 ];
  };

  gucumber = buildGoPackage rec {
    rev = "fba94dc5a9077fa81eb85199fa9dfdaa8af82ab5";
    name = "gucumber-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/lsegal/gucumber";

    src = fetchFromGitHub {
      inherit rev;
      owner = "lsegal";
      repo = "gucumber";
      sha256 = "028wczwpicwmggk3221pz8ffzh30l47x8217gvdzcqq6h9iiaczr";
    };

    buildInputs = [ testify ];
    propagatedBuildInputs = [ ansicolor ];
  };

  hcl = buildGoPackage rec {
    rev  = "513e04c400ee2e81e97f5e011c08fb42c6f69b84";
    name = "hcl-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/hashicorp/hcl";

    src = fetchFromGitHub {
      inherit rev;
      owner  = "hashicorp";
      repo   = "hcl";
      sha256 = "041js0k8bj7qsgr79p207m6r3nkpw7839gq31747618sap6w3g8c";
    };

    buildInputs = [ go-multierror ];
  };

  hipchat-go = buildGoPackage rec {
    rev = "1dd13e154219c15e2611fe46adbb6bf65db419b7";
    name = "hipchat-go-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/tbruyelle/hipchat-go";

    excludedPackages = "examples";

    src = fetchFromGitHub {
      inherit rev;
      owner = "tbruyelle";
      repo = "hipchat-go";
      sha256 = "060wg5yjlh28v03mvm80kwgxyny6cyj7zjpcdg032b8b1sz9z81s";
    };
  };

  hologram = buildGoPackage rec {
    rev  = "2bf08f0edee49297358bd06a0c9bf44ba9051e9c";
    name = "hologram-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/AdRoll/hologram";

    src = fetchFromGitHub {
      inherit rev;
      owner  = "copumpkin";
      repo   = "hologram";
      sha256 = "1ra6rdniqh3pi84fm29zam4irzv52a1dd2sppaqngk07f7rkkhi4";
    };
    buildInputs = [ crypto protobuf goamz rgbterm go-bindata go-homedir vanackere.ldap g2s gox ];
  };

  http2 = buildGoPackage rec {
    rev = "f8202bc903bda493ebba4aa54922d78430c2c42f";
    name = "http2-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/bradfitz/http2";

    src = fetchFromGitHub {
      inherit rev;
      owner = "bradfitz";
      repo = "http2";
      sha256 = "0cza2126jbji5vijwk4dxs05hifnff04xcr0vhxvafs6hz3sacvr";
    };

    buildInputs = [ crypto ];
  };

  httprouter = buildFromGitHub {
    rev    = "bde5c16eb82ff15a1734a3818d9b9547065f65b1";
    owner  = "julienschmidt";
    repo   = "httprouter";
    sha256 = "1l74pvqqhhval4vfnhca9d6i1ij69qs3ljf41w3m1l2id42rq7r9";
  };

  influxdb = buildGoPackage rec {
    rev = "50a2b9ba0f189213fc399f59247787e71b872b2d";
    name = "influxdb-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/influxdb/influxdb";
    goPackageAliases = [
      "github.com/influxdb/influxdb-go"
    ];

    src = fetchFromGitHub {
      inherit rev;
      owner = "influxdb";
      repo = "influxdb";
      sha256 = "0spwnr9dwxwrjxrajpcspj3aci2ylkrm085jhq7rd99nmbsms6jq";
    };

    propagatedBuildInputs = [ bolt crypto statik liner toml pat gollectd gogo.protobuf raft raft-boltdb pool ];
  };

  influxdb8 = buildGoPackage rec {
    rev = "v0.8.8";
    name = "influxdb-${rev}";
    goPackagePath = "github.com/influxdb/influxdb";
    goPackageAliases = [
      "github.com/influxdb/influxdb-go"
    ];

    src = fetchFromGitHub {
      inherit rev;
      owner = "influxdb";
      repo = "influxdb";
      sha256 = "0xpigp76rlsxqj93apjzkbi98ha5g4678j584l6hg57p711gqsdv";
    };

    buildInputs = [ statik crypto gogo.protobuf log4go toml pmylund.go-cache gollectd pat dgnorton.goback mux context gocheck influx.gomdb levigo ];
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

  flagfile = buildFromGitHub {
    rev    = "871ce569c29360f95d7596f90aa54d5ecef75738";
    owner  = "spacemonkeygo";
    repo   = "flagfile";
    sha256 = "1y6wf1s51c90qc1aki8qikkw1wqapzjzr690xrmnrngsfpdyvkrc";
  };

  iochan = buildFromGitHub {
    rev    = "b584a329b193e206025682ae6c10cdbe03b0cd77";
    owner  = "mitchellh";
    repo   = "iochan";
    sha256 = "1fcwdhfci41ibpng2j4c1bqfng578cwzb3c00yw1lnbwwhaq9r6b";
  };

  ipfs = buildGoPackage rec {
    rev = "952dc9c60fdff27902749222fdc30164e7eea1ee";
    name = "ipfs-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/ipfs/go-ipfs";

    src = fetchFromGitHub {
      inherit rev;
      owner  = "ipfs";
      repo   = "go-ipfs";
      sha256 = "1mlilx1i77px85jag4jwpcy8fy0vv15hsmpr1d9zvcs3b7qhskqp";
    };
  };

  vanackere.ldap = buildGoPackage rec {
    rev = "e29b797d1abde6567ccb4ab56236e033cabf845a";
    name = "ldap-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/vanackere/ldap";
    goPackageAliases = [
      "github.com/nmcclain/ldap"
    ];

    src = fetchFromGitHub {
      inherit rev;
      owner  = "vanackere";
      repo   = "ldap";
      sha256 = "069n242wszl04z0cyrwfzpdf64ziw5c3ps4czrsdsx7h4msmvr1x";
    };

    propagatedBuildInputs = [ asn1-ber ];
  };

  levigo = buildGoPackage rec {
    rev = "1ddad808d437abb2b8a55a950ec2616caa88969b";
    name = "logrus-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/jmhodges/levigo";

    excludedPackages = "examples";

    src = fetchFromGitHub {
      inherit rev;
      owner = "jmhodges";
      repo = "levigo";
      sha256 = "1lmafyk7nglhig3n471jq4hmnqf45afj5ldb2jx0253f5ii4r2yq";
    };

    buildInputs = [ pkgs.leveldb ];
  };

  liner = buildFromGitHub {
    rev    = "1bb0d1c1a25ed393d8feb09bab039b2b1b1fbced";
    owner  = "peterh";
    repo   = "liner";
    sha256 = "05ihxpmp6x3hw71xzvjdgxnyvyx2s4lf23xqnfjj16s4j4qidc48";
  };

  odeke-em.log = buildFromGitHub {
    rev    = "cad53c4565a0b0304577bd13f3862350bdc5f907";
    owner  = "odeke-em";
    repo   = "log";
    sha256 = "059c933qjikxlvaywzpzljqnab19svymbv6x32pc7khw156fh48w";
  };

  log4go = buildGoPackage rec {
    rev = "cb4cc51cd03958183d3b637d0750497d88c2f7a8";
    name = "log4go-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/ccpaging/log4go";
    goPackageAliases = [
      "github.com/alecthomas/log4go"
      "code.google.com/p/log4go"
    ];

    excludedPackages = "examples";

    src = fetchFromGitHub {
      inherit rev;
      owner = "ccpaging";
      repo = "log4go";
      sha256 = "0l9f86zzhla9hq35q4xhgs837283qrm4gxbp5lrwwls54ifiq7k2";
    };

    propagatedBuildInputs = [ go-colortext ];
  };

  logrus = buildGoPackage rec {
    rev = "v0.8.2";
    name = "logrus-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/Sirupsen/logrus";

    excludedPackages = "examples";

    src = fetchFromGitHub {
      inherit rev;
      owner = "Sirupsen";
      repo = "logrus";
      sha256 = "0isihf185bw54yc72mbkf3cgfh7xj0x8ky04fs52xpj6vrmd72bv";
    };

    propagatedBuildInputs = [ airbrake-go bugsnag-go raven-go ];
  };

  logutils = buildFromGitHub {
    rev    = "367a65d59043b4f846d179341d138f01f988c186";
    owner  = "hashicorp";
    repo   = "logutils";
    sha256 = "0rjag8c6fn3f51nysrq62r46ma6gzyvijxba47q7cdfjq35mydb8";
  };

  mapstructure = buildFromGitHub {
    rev    = "f7d28d5aeab42b9b95d2e6d6b956f73a290077fc";
    owner  = "mitchellh";
    repo   = "mapstructure";
    sha256 = "1l9bxx0lrxdb75bxgy3jq2f6sgin2xd5ll70z5797vi96mlz8ydb";
  };

  mdns = buildGoPackage rec {
    rev = "2b439d37011456df8ff83a70ffd1cd6046410113";
    name = "mdns-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/hashicorp/mdns";

    src = fetchFromGitHub {
      inherit rev;
      owner = "hashicorp";
      repo = "mdns";
      sha256 = "17zwk212zmyramnjylpvvrvbbsz0qb5crkhly6yiqkyll3qzpb96";
    };

    propagatedBuildInputs = [ net dns ];
  };

  memberlist = buildGoPackage rec {
    rev = "6025015f2dc659ca2c735112d37e753bda6e329d";
    name = "memberlist-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/hashicorp/memberlist";

    src = fetchFromGitHub {
      inherit rev;
      owner = "hashicorp";
      repo = "memberlist";
      sha256 = "01s2gwnbgvwz4wshz9d4za0p12ji4fnapnlmz3jwfcmcwjpyqfb7";
    };

    propagatedBuildInputs = [ ugorji.go armon.go-metrics ];
  };

  memberlist_v2 = buildGoPackage rec {
    rev = "165267096ca647f00cc0b59a8f1ede9a96cbfbb1";
    name = "memberlist-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/hashicorp/memberlist";

    src = fetchFromGitHub {
      inherit rev;
      owner = "hashicorp";
      repo = "memberlist";
      sha256 = "09lh79xqy7q0gy23x22lpfwihb5acr750vxl2fx0i4b88kq1vrzh";
    };

    propagatedBuildInputs = [ ugorji.go armon.go-metrics ];
  };

  mesos-stats = buildGoPackage rec {
    rev = "0c6ea494c19bedc67ebb85ce3d187ec21050e920";
    name = "mesos-stats-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/antonlindstrom/mesos_stats";
    src = fetchFromGitHub {
      inherit rev;
      owner = "antonlindstrom";
      repo = "mesos_stats";
      sha256 = "18ggyjf4nyn77gkn16wg9krp4dsphgzdgcr3mdflv6mvbr482ar4";
    };
  };

  mgo = buildGoPackage rec {
    rev = "c6a7dce14133ccac2dcac3793f1d6e2ef048503a";
    name = "mgo-${rev}";
    goPackagePath = "gopkg.in/mgo.v2";
    src = fetchFromGitHub {
      inherit rev;
      owner = "go-mgo";
      repo = "mgo";
      sha256 ="0rg232q1bkq3y3kd5816hgk1jpf7i38aha5q5ia7j6p9xashz7vj";
    };

    buildInputs = [ pkgs.cyrus_sasl ];
  };

  mousetrap = buildFromGitHub {
    rev    = "9dbb96d2c3a964935b0870b5abaea13c98b483aa";
    owner  = "inconshreveable";
    repo   = "mousetrap";
    sha256 = "1f9g8vm18qv1rcb745a4iahql9vfrz0jni9mnzriab2wy1pfdl5b";
  };

  msgpack = buildGoPackage rec {
    rev = "9dbd4ac30c0b67927f0fb5557fb8341047bd35f7";
    name = "msgpack-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "gopkg.in/vmihailenco/msgpack.v2";

    src = fetchFromGitHub {
      inherit rev;
      owner = "vmihailenco";
      repo = "msgpack";
      sha256 = "0nq9yb85hi3c35kwyl38ywv95vd8n7aywmj78wwylglld22nfmw2";
    };
  };

  mux = buildGoPackage rec {
    rev = "47e8f450ef38c857cdd922ec08862ca9d65a1c6d";
    name = "mux-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/gorilla/mux";

    src = fetchFromGitHub {
      inherit rev;
      owner = "gorilla";
      repo = "mux";
      sha256 = "03z7pk95z3314s3jryp6vs33209fj147g5jb2f331567gzld3b9g";
    };

    buildInputs = [ context ];
  };

  muxado = buildFromGitHub {
    rev    = "f693c7e88ba316d1a0ae3e205e22a01aa3ec2848";
    owner  = "inconshreveable";
    repo   = "muxado";
    sha256 = "1vgiwwxhgx9c899f6ikvrs0w6vfsnypzalcqyr0mqm2w816r9hhs";
  };

  mysql = buildFromGitHub {
    rev    = "0cc29e9fe8e25c2c58cf47bcab566e029bbaa88b";
    owner  = "go-sql-driver";
    repo   = "mysql";
    sha256 = "0ydvd0mk53793sj3hgycsx926zvzxipxvppld1i175g3pn4d41xp";
  };

  net-rpc-msgpackrpc = buildGoPackage rec {
    rev = "d377902b7aba83dd3895837b902f6cf3f71edcb2";
    name = "net-rpc-msgpackrpc-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/hashicorp/net-rpc-msgpackrpc";

    src = fetchFromGitHub {
      inherit rev;
      owner = "hashicorp";
      repo = "net-rpc-msgpackrpc";
      sha256 = "05q8qlf42ygafcp8zdyx7y7kv9vpjrxnp8ak4qcszz9kgl2cg969";
    };

    propagatedBuildInputs = [ ugorji.go ];
  };

  ntp = buildFromGitHub {
    rev    = "0a5264e2563429030eb922f258229ae3fee5b5dc";
    owner  = "beevik";
    repo   = "ntp";
    sha256 = "03fvgbjf2aprjj1s6wdc35wwa7k1w5phkixzvp5n1j21sf6w4h24";
  };

  objx = buildFromGitHub {
    rev    = "cbeaeb16a013161a98496fad62933b1d21786672";
    owner  = "stretchr";
    repo   = "objx";
    sha256 = "1xn7iibjik77h6h0jilfvcjkkzaqz45baf44p3rb2i03hbmkqkp1";
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

  openssl = buildGoPackage rec {
    rev = "84b5df477423634115e53fb171a66007cece19f5";
    name = "openssl-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/spacemonkeygo/openssl";
    src = fetchFromGitHub {
      inherit rev;
      owner = "spacemonkeygo";
      repo = "openssl";
      sha256 = "1l0cyazxp8bwmi151djyr6pknj9jv8n53lgfhgj6l0zj32p5kh1v";
    };
    buildInputs = [ spacelog pkgconfig pkgs.openssl ];
  };

  osext = buildGoPackage rec {
    rev = "8fef92e41e22a70e700a96b29f066cda30ea24ef";
    name = "osext-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/kardianos/osext";
    goPackageAliases = [
      "github.com/bugsnag/osext"
      "bitbucket.org/kardianos/osext"
    ];

    src = fetchFromGitHub {
      inherit rev;
      owner = "kardianos";
      repo = "osext";
      sha256 = "1md9c0qlmfhwcwgqg92vfykcy95snci4n815plb15mgj5cf8dm7d";
    };
  };

  pat = buildFromGitHub {
    rev    = "b8a35001b773c267eb260a691f4e5499a3531600";
    owner  = "bmizerany";
    repo   = "pat";
    sha256 = "11zxd45rvjm6cn3wzbi18wy9j4vr1r1hgg6gzlqnxffiizkycxmz";
  };

  pathtree = buildFromGitHub {
    rev    = "41257a1839e945fce74afd070e02bab2ea2c776a";
    owner  = "robfig";
    repo   = "pathtree";
    sha256 = "087hvskjx1zw815h1617i135vwsn5288v579mz6yral91wbn0kvi";
  };

  panicwrap = buildGoPackage rec {
    rev = "e5f9854865b9778a45169fc249e99e338d4d6f27";
    name = "panicwrap-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/bugsnag/panicwrap";

    src = fetchFromGitHub {
      inherit rev;
      owner = "bugsnag";
      repo = "panicwrap";
      sha256 = "01afviklmgm25i82c0z9xkjgbrh0j1fm9a1adqfd2jqv0cm41k9d";
    };

    propagatedBuildInputs = [ osext ];
  };

  perks = buildFromGitHub {
    rev    = "aac9e2eab5a334037057336897fd10b0289a5ae8";
    owner  = "bmizerany";
    repo   = "perks";
    sha256 = "1d027jgc327qz5xmal0hrpqvsj45i9yqmm9pxk3xp3hancvz3l3k";
  };

  pb = buildFromGitHub {
    rev    = "e648e12b78cedf14ebb2fc1855033f07b034cfbb";
    owner  = "cheggaaa";
    repo   = "pb";
    sha256 = "03k4cars7hcqqgdsd0minfls2p7gjpm8q6y8vknh1s68kvxd4xam";
  };

  beorn7.perks = buildGoPackage rec {
    rev = "b965b613227fddccbfffe13eae360ed3fa822f8d";
    name = "beorn7.perks-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/beorn7/perks";

    src = fetchFromGitHub {
      inherit rev;
      owner = "beorn7";
      repo = "perks";
      sha256 = "1p8zsj4r0g61q922khfxpwxhdma2dx4xad1m5qx43mfn28kxngqk";
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

  pool = buildGoPackage rec {
    rev = "v2.0.0";
    name = "pq-${rev}";
    goPackagePath = "gopkg.in/fatih/pool.v2";

    src = fetchFromGitHub {
      inherit rev;
      owner = "fatih";
      repo = "pool";
      sha256 = "1jlrakgnpvhi2ny87yrsj1gyrcncfzdhypa9i2mlvvzqlj4r0dn0";
    };
  };

  pq = buildFromGitHub {
    rev    = "93e9980741c9e593411b94e07d5bad8cfb4809db";
    owner  = "lib";
    repo   = "pq";
    sha256 = "1q0zlizsk3xn7jn0skbvbhcxsfhq7z3dva96cm72n2r5vs5ld783";
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

  prometheus.client_golang = buildGoPackage rec {
    name = "prometheus-client-${version}";
    version = "0.5.0";
    goPackagePath = "github.com/prometheus/client_golang";

    src = fetchFromGitHub {
      owner = "prometheus";
      repo = "client_golang";
      rev = "${version}";
      sha256 = "0aaf20iv797dj2vr5lnqk006aw7n0cclmxlpk8xy6c6nrn6fm3nv";
    };

    propagatedBuildInputs = [
      goautoneg
      protobuf
      golang_protobuf_extensions
      prometheus.client_model
      prometheus.procfs
      beorn7.perks
    ];
  };

  prometheus.client_model = buildGoPackage rec {
    rev = "fa8ad6fec33561be4280a8f0514318c79d7f6cb6";
    name = "prometheus-client-model-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/prometheus/client_model";
    src = fetchFromGitHub {
      inherit rev;
      owner = "prometheus";
      repo = "client_model";
      sha256 = "11a7v1fjzhhwsl128znjcf5v7v6129xjgkdpym2lial4lac1dhm9";
    };
    buildInputs = [ protobuf ];
  };

  prometheus.log = buildGoPackage rec {
    name = "prometheus-log-${version}";
    version = "git-2015-05-29";
    goPackagePath = "github.com/prometheus/log";
    src = fetchFromGitHub {
      rev = "439e5db48fbb50ebbaf2c816030473a62f505f55";
      owner = "prometheus";
      repo = "log";
      sha256 = "1fl23gsw2hn3c1y91qckr661sybqcw2gqnd1gllxn3hp6p2w6hxv";
    };
    propagatedBuildInputs = [ logrus ];
  };

  prometheus.procfs = buildGoPackage rec {
    rev = "351fbfac67c8ae8bcacd468f678f5e8d5a585d3d";
    name = "prometheus-procfs-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/prometheus/procfs";

    src = fetchFromGitHub {
      inherit rev;
      owner = "prometheus";
      repo = "procfs";
      sha256 = "0hxssp6h1cs7l2cvnxj1hyacy3328hhpi1pd123f2a57aikha9ff";
    };
  };

  pty = buildFromGitHub {
    rev    = "67e2db24c831afa6c64fc17b4a143390674365ef";
    owner  = "kr";
    repo   = "pty";
    sha256 = "1l3z3wbb112ar9br44m8g838z0pq2gfxcp5s3ka0xvm1hjvanw2d";
  };

  pushover = buildFromGitHub {
    rev    = "a8420a1935479cc266bda685cee558e86dad4b9f";
    owner  = "thorduri";
    repo   = "pushover";
    sha256 = "0j4k43ppka20hmixlwhhz5mhv92p6wxbkvdabs4cf7k8jpk5argq";
  };

  raft = buildGoPackage rec {
    rev = "a8065f298505708bf60f518c09178149f3c06f21";
    name = "raft-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/hashicorp/raft";

    src = fetchFromGitHub {
      inherit rev;
      owner  = "hashicorp";
      repo   = "raft";
      sha256 = "122mjijphas7ybbvssxv1r36sb8i907gdr9kvplnx6yg9w52j3mn";
    };

    propagatedBuildInputs = [ armon.go-metrics ugorji.go ];
  };

  raft-boltdb = buildGoPackage rec {
    rev = "d1e82c1ec3f15ee991f7cc7ffd5b67ff6f5bbaee";
    name = "raft-boltdb-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/hashicorp/raft-boltdb";

    src = fetchFromGitHub {
      inherit rev;
      owner  = "hashicorp";
      repo   = "raft-boltdb";
      sha256 = "0p609w6x0h6bapx4b0d91dxnp2kj7dv0534q4blyxp79shv2a8ia";
    };

    propagatedBuildInputs = [ bolt ugorji.go raft ];
  };

  raft-mdb = buildGoPackage rec {
    rev = "4ec3694ffbc74d34f7532e70ef2e9c3546a0c0b0";
    name = "raft-mdb-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/hashicorp/raft-mdb";

    src = fetchFromGitHub {
      inherit rev;
      owner  = "hashicorp";
      repo   = "raft-mdb";
      sha256 = "15l4n6zygwn3h118m2945h9jxkryaxxcgy8xij2rxjhzrzpfyj3i";
    };

    propagatedBuildInputs = [ gomdb ugorji.go raft ];
  };

  raw = buildFromGitHub {
    rev    = "724aedf6e1a5d8971aafec384b6bde3d5608fba4";
    owner  = "feyeleanor";
    repo   = "raw";
    sha256 = "0z4dcnadgk0fbxxd14dqa1wzzr0v3ksqlzd0swzs2mipim5wjgsz";
  };

  raven-go = buildFromGitHub {
    rev    = "c8f8fb7c415203f52ca882e2661d21bc6dcb54d7";
    owner  = "getsentry";
    repo   = "raven-go";
    sha256 = "052avpl8xsqlcmjmi3v00nm23lhs95af6vpaw2sh5xckln0lfbxh";
  };

  redigo = buildFromGitHub {
    rev    = "535138d7bcd717d6531c701ef5933d98b1866257";
    owner  = "garyburd";
    repo   = "redigo";
    sha256 = "1m7nc1gvv5yqnq8ii75f33485il6y6prf8gxl97dimsw94qccc5v";
  };

  reflectwalk = buildFromGitHub {
    rev    = "242be0c275dedfba00a616563e6db75ab8f279ec";
    owner  = "mitchellh";
    repo   = "reflectwalk";
    sha256 = "0xjyjs7ci7yaslk0rcgdw99ys2kq0p14cx6c90pmdzl0m9pcc9v4";
  };

  revel = buildGoPackage rec {
    rev = "v0.12.0";
    name = "revel-${rev}";
    goPackagePath = "github.com/revel/revel";

    src = fetchFromGitHub {
      inherit rev;
      owner  = "revel";
      repo   = "revel";
      sha256 = "1g88fw5lqh3a9qmx182s64zk3h1s1mx8bljyghissmd9z505pbzf";
    };

    # Using robfig's old go-cache due to compilation errors.
    # Try to switch to pmylund.go-cache after v0.12.0
    propagatedBuildInputs = [
      gocolorize config net pathtree fsnotify.v1 robfig.go-cache redigo gomemcache
    ];
  };

  rgbterm = buildFromGitHub {
    rev    = "c07e2f009ed2311e9c35bca12ec00b38ccd48283";
    owner  = "aybabtme";
    repo   = "rgbterm";
    sha256 = "1qph7drds44jzx1whqlrh1hs58k0wv0v58zyq2a81hmm72gsgzam";
  };

  ripper = buildFromGitHub {
    rev    = "bd1a682568fcb8a480b977bb5851452fc04f9ccb";
    owner  = "odeke-em";
    repo   = "ripper";
    sha256 = "010jsclnmkaywdlyfqdmq372q7kh3qbz2zra0c4wn91qnkmkrnw1";
  };

  sandblast = buildGoPackage rec {
    rev = "694d24817b9b7b8bacb6d458b7989b30d7fe3555";
    name = "sandblast-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/aarzilli/sandblast";

    src = fetchFromGitHub {
      inherit rev;
      owner  = "aarzilli";
      repo   = "sandblast";
      sha256 = "1pj0bic3x89v44nr8ycqxwnafkiz3cr5kya4wfdfj5ldbs5xnq9l";
    };

    buildInputs = [ net text ];
  };

  scada-client = buildGoPackage rec {
    rev = "c26580cfe35393f6f4bf1b9ba55e6afe33176bae";
    name = "scada-client-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/hashicorp/scada-client";

    src = fetchFromGitHub {
      inherit rev;
      owner  = "hashicorp";
      repo   = "scada-client";
      sha256 = "0s8xg49fa7d2d0vv8pi37f43rjrgkb7w6x6ydkikz1v8ccg05p3b";
    };

    buildInputs = [ armon.go-metrics net-rpc-msgpackrpc yamux ];
  };

  serf = buildGoPackage rec {
    rev = "668982d8f90f5eff4a766583c1286393c1d27f68";
    name = "serf-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/hashicorp/serf";

    src = fetchFromGitHub {
      inherit rev;
      owner  = "hashicorp";
      repo   = "serf";
      sha256 = "1h05h5xhaj27r1mh5zshnykax29lqjhfc0bx4v9swiwb873c24qk";
    };

    buildInputs = [
      circbuf armon.go-metrics ugorji.go go-syslog logutils mdns memberlist
      cli mapstructure columnize
    ];
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

  spacelog = buildGoPackage rec {
    rev = "ae95ccc1eb0c8ce2496c43177430efd61930f7e4";
    name = "spacelog-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/spacemonkeygo/spacelog";
    src = fetchFromGitHub {
      inherit rev;
      owner = "spacemonkeygo";
      repo = "spacelog";
      sha256 = "1i1awivsix0ch0vg6rwvx0536ziyw6phcx45b1rmrclp6b6dyacy";
    };
    buildInputs = [ flagfile ];
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

  statos = buildFromGitHub {
    rev    = "f27d6ab69b62abd9d9fe80d355e23a3e45d347d6";
    owner  = "odeke-em";
    repo   = "statos";
    sha256 = "17cpks8bi9i7p8j38x0wy60jb9g39wbzszcmhx4hlq6yzxr04jvs";
  };

  statik = buildGoPackage rec {
    rev = "274df120e9065bdd08eb1120e0375e3dc1ae8465";
    name = "statik-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/rakyll/statik";

    excludedPackages = "example";

    src = fetchFromGitHub {
      inherit rev;
      owner = "rakyll";
      repo = "statik";
      sha256 = "0llk7bxmk66wdiy42h32vj1jfk8zg351xq21hwhrq7gkfljghffp";
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

  testify = buildGoPackage rec {
    rev = "dab07ac62d4905d3e48d17dc549c684ac3b7c15a";
    name = "testify-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/stretchr/testify";

    src = fetchFromGitHub {
      inherit rev;
      owner = "stretchr";
      repo = "testify";
      sha256 = "0r24v9ly3g68ywqyri14fn8smvkw8zvrzbivxw3ndd6jxcvi84b7";
    };

    buildInputs = [ objx ];
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

  tomb = buildGoPackage rec {
    rev = "14b3d72120e8d10ea6e6b7f87f7175734b1faab8";
    name = "tomb-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "gopkg.in/tomb.v2";
    src = fetchFromGitHub {
      inherit rev;
      owner = "go-tomb";
      repo = "tomb";
      sha256 = "1nza31jvkpka5431c4bdbirvjdy36b1b55sbzljqhqih25jrcjx5";
    };
  };

  toml = buildFromGitHub {
    rev    = "056c9bc7be7190eaa7715723883caffa5f8fa3e4";
    owner  = "BurntSushi";
    repo   = "toml";
    sha256 = "0gkgkw04ndr5y7hrdy0r4v2drs5srwfcw2bs1gyas066hwl84xyw";
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

  vault = buildGoPackage rec {
    rev = "v0.1.2";
    name = "vault-${rev}";
    goPackagePath = "github.com/hashicorp/vault";

    src = fetchFromGitHub {
      inherit rev;
      owner = "hashicorp";
      repo = "vault";
      sha256 = "0q6wlw0s9dig11mzcfg25fh2wz7g70zxkqm7c5f58fncxdby2nqj";
    };

    # We just want the consul api not all of consul
    extraSrcs = [
      { inherit (consul) src goPackagePath; }
    ];

    buildInputs = [
      armon.go-metrics go-radix mysql go-querystring hashicorp.aws-sdk-go
      errwrap go-multierror go-syslog golang-lru hcl logutils pq cli
      copystructure go-homedir mapstructure reflectwalk columnize go-zookeeper
      asn1-ber vanackere.ldap go-ini crypto net oauth2 osext go-github
    ];
  };

  vulcand = buildGoPackage rec {
    rev = "v0.8.0-beta.3";
    name = "vulcand-${rev}";
    goPackagePath = "github.com/mailgun/vulcand";
    preBuild = "export GOPATH=$GOPATH:$NIX_BUILD_TOP/go/src/${goPackagePath}/Godeps/_workspace";
    src = fetchFromGitHub {
      inherit rev;
      owner = "mailgun";
      repo = "vulcand";
      sha256 = "08mal9prwlsav63r972q344zpwqfql6qw6v4ixbn1h3h32kk3ic6";
    };
    subPackages = [ "./" ];
  };

  websocket = buildFromGitHub {
    rev    = "f4076986b69612ecb8bc7ce06d742eda6286200d";
    owner  = "gorilla";
    repo   = "websocket";
    sha256 = "09arvwlxw15maf4z8pcgjc25hd00mckqpdi0byafqfgm3nvvacvq";
  };

  yaml-v1 = buildGoPackage rec {
    name = "yaml-v1-${version}";
    version = "git-2015-05-01";
    goPackagePath = "gopkg.in/yaml.v1";
    src = fetchFromGitHub {
      rev = "b0c168ac0cf9493da1f9bb76c34b26ffef940b4a";
      owner = "go-yaml";
      repo = "yaml";
      sha256 = "0jbdy41pplf2d1j24qwr8gc5qsig6ai5ch8rwgvg72kq9q0901cy";
    };
  };

  yaml-v2 = buildGoPackage rec {
    name = "yaml-v2-${version}";
    version = "git-2015-05-19";
    goPackagePath = "gopkg.in/yaml.v2";
    src = fetchFromGitHub {
      rev = "c1cd2254a6dd314c9d73c338c12688c9325d85c6";
      owner = "go-yaml";
      repo = "yaml";
      sha256 = "0xhv0i700hh8lczrwxhn3c99npqma7k4337qrh6k36falm0jpp4s";
    };
  };

  yamux = buildFromGitHub {
    rev    = "b2e55852ddaf823a85c67f798080eb7d08acd71d";
    owner  = "hashicorp";
    repo   = "yamux";
    sha256 = "0mr87my5m8lgc0byjcddlclxg34d07cpi9p78ps3rhzq7p37g533";
  };

  xon = buildFromGitHub {
    rev    = "d580be739d723da4f6378083128f93017b8ab295";
    owner  = "odeke-em";
    repo   = "xon";
    sha256 = "07a7zj01d4a23xqp01m48jp2v5mw49islf4nbq2rj13sd5w4s6sc";
  };

}; in self
