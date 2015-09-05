/* This file defines the composition for Go packages. */

{ overrides, stdenv, go, buildGoPackage, git
, fetchgit, fetchhg, fetchurl, fetchFromGitHub, fetchFromBitbucket, fetchbzr, pkgs }:

let
  isGo14 = go.meta.branch == "1.4";

  buildFromGitHub = { rev, date ? null, owner, repo, sha256, name ? repo, goPackagePath ? "github.com/${owner}/${repo}", ... }@args: buildGoPackage (args // {
    inherit rev goPackagePath;
    name = "${name}-${if date != null then date else stdenv.lib.strings.substring 0 7 rev}";
    src  = fetchFromGitHub { inherit rev owner repo sha256; };
  });

  self = _self // overrides; _self = with self; {

  inherit go buildGoPackage;

  ## OFFICIAL GO PACKAGES

  crypto = buildFromGitHub {
    rev      = "d5c5f1769f2fcd2377be6f29863081f59a4fc80f";
    date     = "2015-08-29";
    owner    = "golang";
    repo     = "crypto";
    sha256   = "0rkcvl3q8akkar4rmj052z23y61hbav9514ky6grb4gvxfx4ydbn";
    goPackagePath = "golang.org/x/crypto";
    goPackageAliases = [
      "code.google.com/p/go.crypto"
      "github.com/golang/crypto"
    ];
  };

  glog = buildFromGitHub {
    rev    = "fca8c8854093a154ff1eb580aae10276ad6b1b5f";
    date   = "2015-07-31";
    owner  = "golang";
    repo   = "glog";
    sha256 = "1nr2q0vas0a2f395f4shjxqpas18mjsf8yhgndsav7svngpbbpg8";
  };

  image = buildFromGitHub {
    rev = "8ab1ac6834edd43d91cbe24272897a87ce7e835e";
    date = "2015-08-23";
    owner = "golang";
    repo = "image";
    sha256 = "1ckr7yh5dx2kbvp9mis7i090ss9qcz46sazrj9f2hw4jj5g3y7dr";
    goPackagePath = "golang.org/x/image";
    goPackageAliases = [ "github.com/golang/image" ];
  };

  net = buildFromGitHub {
    rev    = "ea47fc708ee3e20177f3ca3716217c4ab75942cb";
    date   = "2015-08-29";
    owner  = "golang";
    repo   = "net";
    sha256 = "0x1pmg97n7l62vak9qnjdjrrfl98jydhv6j0w3jkk4dycdlzn30d";
    goPackagePath = "golang.org/x/net";
    goPackageAliases = [
      "code.google.com/p/go.net"
      "github.com/hashicorp/go.net"
      "github.com/golang/net"
    ];
    propagatedBuildInputs = [ text ];
  };

  oauth2 = buildFromGitHub {
    rev = "397fe7649477ff2e8ced8fc0b2696f781e53745a";
    date = "2015-06-23";
    owner = "golang";
    repo = "oauth2";
    sha256 = "0fza0l7iwh6llkq2yzqn7dxi138vab0da64lnghfj1p71fprjzn8";
    goPackagePath = "golang.org/x/oauth2";
    goPackageAliases = [ "github.com/golang/oauth2" ];
    propagatedBuildInputs = [ net gcloud-golang-compute-metadata ];
  };


  protobuf = buildFromGitHub {
    rev = "59b73b37c1e45995477aae817e4a653c89a858db";
    date = "2015-08-23";
    owner = "golang";
    repo = "protobuf";
    sha256 = "1dx22jvhvj34ivpr7gw01fncg9yyx35mbpal4mpgnqka7ajmgjsa";
    goPackagePath = "github.com/golang/protobuf";
    goPackageAliases = [ "code.google.com/p/goprotobuf" ];
  };

  snappy = buildFromGitHub {
    rev    = "0c7f8a7704bfec561913f4df52c832f094ef56f0";
    date   = "2015-07-21";
    owner  = "golang";
    repo   = "snappy";
    sha256 = "17j421ra8jm2da8gc0sk71g3n1nizqsfx1mapn255nvs887lqm0y";
    goPackageAliases = [ "code.google.com/p/snappy-go/snappy" ];
  };

  text = buildFromGitHub {
    rev = "505f8b49cc14d790314b7535959a10b87b9161c7";
    date = "2015-08-27";
    owner = "golang";
    repo = "text";
    sha256 = "0h31hyb1ijs7zcsmpwa713x41k1wkh0igv7i4chwvwyjyl7zligy";
    goPackagePath = "golang.org/x/text";
    goPackageAliases = [ "github.com/golang/text" ];
  };

  tools = buildFromGitHub {
    rev = "b48dc8da98ae78c3d11f220e7d327304c84e623a";
    date = "2015-08-24";
    owner = "golang";
    repo = "tools";
    sha256 = "187p3jjxrw2qjnzqwwrq7f9w10zh6vcnwnfl3q7ms8rbiffpjy5c";
    goPackagePath = "golang.org/x/tools";
    goPackageAliases = [ "code.google.com/p/go.tools" ];

    preConfigure = ''
      # Make the builtin tools available here
      mkdir -p $bin/bin
      eval $(go env | grep GOTOOLDIR)
      find $GOTOOLDIR -type f | while read x; do
        ln -sv "$x" "$bin/bin"
      done
      export GOTOOLDIR=$bin/bin
    '';

    excludedPackages = "\\("
      + stdenv.lib.concatStringsSep "\\|" ([ "testdata" ] ++ stdenv.lib.optionals (stdenv.lib.versionAtLeast go.meta.branch "1.5") [ "vet" "cover" ])
      + "\\)";

    buildInputs = [ net ];

    # Do not copy this without a good reason for enabling
    # In this case tools is heavily coupled with go itself and embeds paths.
    allowGoReference = true;
  };

  ## THIRD PARTY

  airbrake-go = buildFromGitHub {
    rev    = "5b5e269e1bc398d43f67e43dafff3414a59cd5a2";
    owner  = "tobi";
    repo   = "airbrake-go";
    sha256 = "1bps4y3vpphpj63mshjg2aplh579cvqac0hz7qzvac0d1fqcgkdz";
  };

  ansicolor = buildFromGitHub {
    rev    = "a5e2b567a4dd6cc74545b8a4f27c9d63b9e7735b";
    owner  = "shiena";
    repo   = "ansicolor";
    sha256 = "0gwplb1b4fvav1vjf4b2dypy5rcp2w41vrbxkd1dsmac870cy75p";
  };

  asciinema = buildFromGitHub {
    rev = "v1.1.1";
    owner = "asciinema";
    repo = "asciinema";
    sha256 = "0k48k8815k433s25lh8my2swl89kczp0m2gbqzjlpy1xwmk06nxc";
  };

  asn1-ber = buildGoPackage rec {
    rev = "f4b6f4a84f5cde443d1925b5ec185ee93c2bdc72";
    name = "asn1-ber-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/go-asn1-ber/asn1-ber";
    goPackageAliases = [
      "github.com/nmcclain/asn1-ber"
      "github.com/vanackere/asn1-ber"
      "gopkg.in/asn1-ber.v1"
    ];

    src = fetchFromGitHub {
      inherit rev;
      owner  = "go-asn1-ber";
      repo   = "asn1-ber";
      sha256 = "0qdyax6yw3hvplzqc2ykpihi3m5y4nii581ay0mxy9c54bzs2nk9";
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
    doCheck = false;
  };

  aws-sdk-go = buildFromGitHub {
    #rev    = "a28ecdc9741b7905b5198059c94aed20868ffc08";
    rev    = "127313c1b41e534a0456a68b6b3a16712dacb35d";
    owner  = "aws";
    repo   = "aws-sdk-go";
    #sha256 = "1kgnp5f5c5phmihh8krar9rbkfg0lk73imjhjvkhxirhw04g3n5j";
    sha256 = "0gd4nzv5jl02qi7g0y8lv6jadk0p52bpbl1r7pfgy8mn1vfxs37m";
    goPackageAliases = [
      "github.com/awslabs/aws-sdk-go"
    ];
    buildInputs = [ gucumber testify ];
    propagatedBuildInputs = [ go-ini ];

    preBuild = ''
      pushd go/src/$goPackagePath
      make generate
      popd
    '';
  };

  hashicorp.aws-sdk-go = buildFromGitHub {
    rev    = "e6ea0192eee4640f32ec73c0cbb71f63e4f2b65a";
    owner  = "hashicorp";
    repo   = "aws-sdk-go";
    sha256 = "1qrc2jl38marbarnl31sag7s0h18j2wx1cxkcqin5m1pqg62p4cn";
    propagatedBuildInputs = [ go-ini ];
    subPackages = [
      "./aws"
      "./gen/ec2"
      "./gen/endpoints"
      "./gen/iam"
    ];
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

  bosun = buildFromGitHub {
    rev = "0.3.0";
    owner = "bosun-monitor";
    repo = "bosun";
    sha256 = "05qfhm5ipdry0figa0rhmg93c45dzh2lwpia73pfxp64l1daqa3a";
    goPackagePath = "bosun.org";
    # Todo: Split these derivations if worried about size on each machine
    subPackages = [ "cmd/bosun" "cmd/scollector" ];
    disabled = !isGo14;
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

  cli = buildFromGitHub {
    rev = "8102d0ed5ea2709ade1243798785888175f6e415";
    owner = "mitchellh";
    repo = "cli";
    sha256 = "08mj1l94pww72jy34gk9a483hpic0rrackskfw13r3ycy997w7m2";
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
    rev    = "142e6cd241a4dfbf7f07a018f1f8225180018da4";
    owner  = "codegangsta";
    repo   = "cli";
    sha256 = "1w8naax4gvkkxw5h31a2c2dwniw5hj92nv0hn6ybdlavffyax9h5";
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

  copystructure = buildFromGitHub {
    rev = "6fc66267e9da7d155a9d3bd489e00dad02666dc6";
    owner = "mitchellh";
    repo = "copystructure";
    sha256 = "193s5vhw68d8npjyf5yvc5j24crazvy7d5dk316hl7590qrmbxrd";
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

  consul = buildFromGitHub {
    rev = "v0.5.2";
    owner = "hashicorp";
    repo = "consul";
    sha256 = "0p3lc1p346a5ipvkf15l94gn1ml3m7zz6bx0viark3hsv0a7iij7";

    buildInputs = [
      circbuf armon.go-metrics go-radix gomdb bolt consul-migrate go-checkpoint
      ugorji.go go-multierror go-syslog golang-lru hcl logutils memberlist
      net-rpc-msgpackrpc raft raft-boltdb raft-mdb scada-client serf yamux
      muxado dns cli mapstructure columnize crypto
    ];

    # Keep consul.ui for backward compatability
    passthru.ui = pkgs.consul-ui;
  };

  consul-api = buildFromGitHub {
    inherit (consul) rev owner repo sha256;
    subPackages = [ "api" ];
  };

  consul-alerts = buildFromGitHub {
    rev = "6eb4bc556d5f926dbf15d86170664d35d504ae54";
    date = "2015-08-09";
    owner = "AcalephStorage";
    repo = "consul-alerts";
    sha256 = "191bmxix3nl4pr26hcdfxa9qpv5dzggjvi86h2slajgyd2rzn23b";

    renameImports = ''
      # Remove all references to included dependency store
      rm -rf go/src/github.com/AcalephStorage/consul-alerts/Godeps
      govers -d -m github.com/AcalephStorage/consul-alerts/Godeps/_workspace/src/ ""
    '';

    # Temporary fix for name change
    postPatch = ''
      sed -i 's,SetApiKey,SetAPIKey,' notifier/opsgenie-notifier.go
    '';

    buildInputs = [ logrus docopt-go hipchat-go gopherduty consul-api opsgenie-go-sdk influxdb8-client ];
  };

  consul-migrate = buildFromGitHub {
    rev    = "678fb10cdeae25ab309e99e655148f0bf65f9710";
    date   = "2015-05-19";
    owner  = "hashicorp";
    repo   = "consul-migrate";
    sha256 = "18zqyzbc3pny700fnh4hi45i5mlsramqykikcr7lgyx7id6alf16";
    buildInputs = [ raft raft-boltdb raft-mdb ];
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

    src = fetchFromGitHub {
      inherit rev;
      owner = "godbus";
      repo = "dbus";
      sha256 = "1vk31wal7ncvjwvnb8q1myrkihv1np46f3q8dndi5k0csflbxxdf";
    };
  };

  dns = buildFromGitHub {
    rev    = "e59f851c912767b1db587dcabee6e6652e495c75";
    date   = "2015-07-22";
    owner  = "miekg";
    repo   = "dns";
    sha256 = "1zcj4drmmskwvjy5ld54qd8a34ls9651ysl3q7c2bcambax5r0hp";
  };

  docopt-go = buildFromGitHub {
    rev    = "854c423c810880e30b9fecdabb12d54f4a92f9bb";
    owner  = "docopt";
    repo   = "docopt-go";
    sha256 = "1sddkxgl1pwlipfvmv14h8vg9b9wq1km427j1gjarhb5yfqhh3l1";
  };

  drive = buildFromGitHub {
    rev = "4530cf8d59e1047cb1c005a6bd5b14ecb98b9e68";
    owner = "odeke-em";
    repo = "drive";
    sha256 = "1y4qlzvgg84mh8l6bhaazzy6bv6dwjcbpm0rxvvc5aknvvh581ps";
    subPackages = [ "cmd/drive" ];
    buildInputs = [
      pb go-isatty command dts odeke-em.log statos xon odeke-em.google-api-go-client
      cli-spinner oauth2 text net
    ];
    disabled = !isGo14;
  };

  dts = buildFromGitHub {
    rev    = "ec2daabf2f9078e887405f7bcddb3d79cb65502d";
    owner  = "odeke-em";
    repo   = "dts";
    sha256 = "0vq3cz4ab9vdsz9s0jjlp7z27w218jjabjzsh607ps4i8m5d441s";
  };

  du = buildFromGitHub {
    rev    = "3c0690cca16228b97741327b1b6781397afbdb24";
    date   = "2015-08-05";
    owner  = "calmh";
    repo   = "du";
    sha256 = "1mv6mkbslfc8giv47kyl97ny0igb3l7jya5hc75sm54xi6g205wa";
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
    rev    = "v2.1.2";
    owner  = "coreos";
    repo   = "etcd";
    sha256 = "1d3wl9rqbhkkdhfkjfrzjfcwz8hx315zbjbmij3pf62bc1p5nh60";
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

  flannel = buildFromGitHub {
    rev = "v0.5.3";
    owner = "coreos";
    repo = "flannel";
    sha256 = "0d9khv0bczvsaqnz16p546m4r5marmnkcrdhi0f3ajnwxb776r9p";
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

  fzf = buildFromGitHub {
    rev = "0.10.4";
    owner = "junegunn";
    repo = "fzf";
    sha256 = "06wda8pm1invnj4sfwcicw9qim3jdf9s1fcrai7xqz7wgy74qv1f";

    buildInputs = [
      crypto ginkgo gomega junegunn.go-runewidth go-shellwords pkgs.ncurses text
    ];
  };

  g2s = buildFromGitHub {
    rev    = "ec76db4c1ac16400ac0e17ca9c4840e1d23da5dc";
    owner  = "peterbourgon";
    repo   = "g2s";
    sha256 = "1p4p8755v2nrn54rik7yifpg9szyg44y5rpp0kryx4ycl72307rj";
  };

  gawp = buildFromGitHub {
    rev    = "488705639109de54d38974cc31353d34cc2cd609";
    date = "2015-08-31";
    owner  = "martingallagher";
    repo   = "gawp";
    sha256 = "0iqqd63nqdijdskdb9f0jwnm6akkh1p2jw4p2w7r1dbaqz1znyay";
    dontInstallSrc = true;
    buildInputs = [ fsnotify.v1 yaml-v2 ];

    meta = with stdenv.lib; {
      homepage    = "https://github.com/martingallagher/gawp";
      description = "A simple, configurable, file watching, job execution tool implemented in Go.";
      maintainers = with maintainers; [ kamilchm ];
      license     = licenses.asl20 ;
      platforms   = platforms.all;
    };
  };

  gcloud-golang = buildFromGitHub {
    rev = "6335269abf9002cf5a84613c13cda6010842b834";
    owner = "GoogleCloudPlatform";
    repo = "gcloud-golang";
    sha256 = "15xrqxna5ms0r634k3bfzyymn431dvqcjwbsap8ay60x371kzbwf";
    goPackagePath = "google.golang.org/cloud";
    buildInputs = [ net oauth2 protobuf google-api-go-client grpc ];
    excludedPackages = "oauth2";
    meta.hydraPlatforms = [ ];
  };

  gcloud-golang-compute-metadata = buildGoPackage rec {
    inherit (gcloud-golang) rev name goPackagePath src;
    subPackages = [ "compute/metadata" ];
    buildInputs = [ net ];
  };

  gettext-go = buildFromGitHub {
    rev    = "783c0fb3da95b06dd89c4ba2771f1dc289ecc27c";
    owner  = "chai2010";
    repo   = "gettext-go";
    sha256 = "1iz4wjxc3zkj0xkfs88ig670gb08p1sd922l0ig2cxpjcfjp1y99";
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
    rev    = "0.5.0";
    owner  = "Masterminds";
    repo   = "glide";
    sha256 = "10jg3h1zprx2ylmmcvmy94k4pw7lc9a6xfgr2ld8rih642sqg9wh";
    buildInputs = [ cookoo cli-go go-gypsy vcs ];
  };

  gls = buildFromGitHub {
    rev    = "9a4a02dbe491bef4bab3c24fd9f3087d6c4c6690";
    owner  = "jtolds";
    repo   = "gls";
    sha256 = "1gvgkx7llklz6plapb95fcql7d34i6j7anlvksqhdirpja465jnm";
  };

  ugorji.go = buildGoPackage rec {
    rev = "03e33114d4d60a1f37150325e15f51b0fa6fc4f6";
    name = "ugorji-go-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/ugorji/go";
    goPackageAliases = [ "github.com/hashicorp/go-msgpack" ];

    src = fetchFromGitHub {
      inherit rev;
      owner = "ugorji";
      repo = "go";
      sha256 = "01kdzgx23cgb4k867m1pvsw14hhdr9jf2frqy6i4j4221055m57v";
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

  gocql = buildFromGitHub {
    rev    = "53ea371a152ac188443fd3479f822ffecb0e9363";
    owner  = "gocql";
    repo   = "gocql";
    sha256 = "0rqykhqgx7lrggcjyh053c3qddf130sgvsm27gndjv29rjrm874f";
    propagatedBuildInputs = [ inf snappy groupcache ];
  };

  gocode = buildFromGitHub {
    rev = "680a0fbae5119fb0dbea5dca1d89e02747a80de0";
    date = "2015-09-03";
    owner = "nsf";
    repo = "gocode";
    sha256 = "1ay2xakz4bcn8r3ylicbj753gjljvv4cj9l4wfly55cj1vjybjpv";
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

  govers = buildFromGitHub {
    rev = "3b5f175f65d601d06f48d78fcbdb0add633565b9";
    date = "2015-01-09";
    owner = "rogpeppe";
    repo = "govers";
    sha256 = "0din5a7nff6hpc4wg0yad2nwbgy4q1qaazxl8ni49lkkr4hyp8pc";
    dontRenameImports = true;
  };

  golang-lru = buildFromGitHub {
    rev    = "7f9ef20a0256f494e24126014135cf893ab71e9e";
    owner  = "hashicorp";
    repo   = "golang-lru";
    sha256 = "165x0p8plr3fwn4r1d11m3pxa3r8dhyk98z7x6ah35lf63jm2cwv";
  };

  golang-petname = buildFromGitHub {
    rev    = "13f8b3a4326b9a6579358543cffe82713c1d6ce4";
    owner  = "dustinkirkland";
    repo   = "golang-petname";
    sha256 = "1xx6lpv1r2sji8m9w35a2fkr9v4vsgvxrrahcq9bdg75qvadq91d";
  };

  golang_protobuf_extensions = buildFromGitHub {
    rev    = "fc2b8d3a73c4867e51861bbdd5ae3c1f0869dd6a";
    date   = "2015-04-06";
    owner  = "matttproud";
    repo   = "golang_protobuf_extensions";
    sha256 = "0ajg41h6402big484drvm72wvid1af2sffw0qkzbmpy04lq68ahj";
    buildInputs = [ protobuf ];
  };

  goleveldb = buildFromGitHub {
    rev = "183614d6b32571e867df4cf086f5480ceefbdfac";
    date = "2015-06-17";
    owner = "syndtr";
    repo = "goleveldb";
    sha256 = "0crslwglkh8b3204l4zvav712a7yd2ykjnbrnny6yrq94mlvba8r";
    propagatedBuildInputs = [ ginkgo gomega snappy ];
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

  google-api-go-client = buildFromGitHub {
    rev = "a5c3e2a4792aff40e59840d9ecdff0542a202a80";
    date = "2015-08-19";
    owner = "google";
    repo = "google-api-go-client";
    sha256 = "1kigddnbyrl9ddpj5rs8njvf1ck54ipi4q1282k0d6b3am5qfbj8";
    goPackagePath = "google.golang.org/api";
    goPackageAliases = [ "github.com/google/google-api-client" ];
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
    buildInputs = [ net ];
    propagatedBuildInputs = [ google-api-go-client ];
  };

  gopass = buildFromGitHub {
    rev = "10b54de414cc9693221d5ff2ae14fd2fbf1b0ac1";
    owner = "howeyc";
    repo = "gopass";
    sha256 = "0lsi89zx1i2f5vhm66zqn2drs7xi7ff8r1xlp6m58r99dddws57s";
    propagatedBuildInputs = [ crypto ];
  };

  gopherduty = buildFromGitHub {
    rev    = "f4906ce7e59b33a50bfbcba93e2cf58778c11fb9";
    owner  = "darkcrux";
    repo   = "gopherduty";
    sha256 = "11w1yqc16fxj5q1y5ha5m99j18fg4p9lyqi542x2xbrmjqqialcf";
  };

  goproxy = buildFromGitHub {
    rev    = "2624781dc373cecd1136cafdaaaeba6c9bb90e96";
    date   = "2015-07-26";
    owner  = "elazarl";
    repo   = "goproxy";
    sha256 = "1zz425y8byjaa9i7mslc9anz9w2jc093fjl0562rmm5hh4rc5x5f";
    buildInputs = [ go-charset ];
  };

  goreq = buildFromGitHub {
    rev    = "72c51a544272e007ab3da4f7d9ac959b7af7af03";
    date   = "2015-08-18";
    owner  = "franela";
    repo   = "goreq";
    sha256 = "0dnqbijdzp2dgsf6m934nadixqbv73q0zkqglaa956zzw0pyhcxp";
  };

  gotags = buildFromGitHub {
    rev    = "be986a34e20634775ac73e11a5b55916085c48e7";
    date   = "2015-08-03";
    owner  = "jstemmer";
    repo   = "gotags";
    sha256 = "071wyq90b06xlb3bb0l4qjz1gf4nnci4bcngiddfcxf2l41w1vja";
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

  go-charset = buildFromGitHub {
    rev    = "61cdee49014dc952076b5852ce4707137eb36b64";
    date   = "2014-07-13";
    owner  = "paulrosania";
    repo   = "go-charset";
    sha256 = "0jp6rwxlgl66dipk6ssk8ly55jxncvsxs7jc3abgdrhr3rzccab8";
    goPackagePath = "code.google.com/p/go-charset";

    preBuild = ''
      find go/src/$goPackagePath -name \*.go | xargs sed -i 's,github.com/paulrosania/go-charset,code.google.com/p/go-charset,g'
    '';
  };

  go-checkpoint = buildFromGitHub {
    rev    = "88326f6851319068e7b34981032128c0b1a6524d";
    owner  = "hashicorp";
    repo   = "go-checkpoint";
    sha256 = "1npasn9lmvx57nw3wkswwvl5k0wmn01jpalbwv832x5wq4r0nsz4";
  };

  go-colorable = buildFromGitHub {
    rev    = "40e4aedc8fabf8c23e040057540867186712faa5";
    owner  = "mattn";
    repo   = "go-colorable";
    sha256 = "0pwc0s5lvz209dcyamv1ba1xl0c1r5hpxwlq0w5j2xcz8hzrcwkl";
  };

  go-colortext = buildFromGitHub {
    rev    = "13eaeb896f5985a1ab74ddea58707a73d875ba57";
    owner  = "daviddengcn";
    repo   = "go-colortext";
    sha256 = "0618xs9lc5xfp5zkkb5j47dr7i30ps3zj5fj0zpv8afqh2cc689x";
  };

  go-etcd = buildGoPackage rec {
    rev = "9847b93751a5fbaf227b893d172cee0104ac6427";
    name = "go-etcd-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/coreos/go-etcd";

    src = fetchFromGitHub {
      inherit rev;
      owner = "coreos";
      repo = "go-etcd";
      sha256 = "1ihq01ayqzxvn6hca5j00vl189vi5lm78f0fy2wpk5mrm3xi01l4";
    };

    propagatedBuildInputs = [ ugorji.go ];
  };

  go-flags = buildFromGitHub {
    rev    = "1b89bf73cd2c3a911d7b2a279ab085c4a18cf539";
    owner  = "jessevdk";
    repo   = "go-flags";
    sha256 = "027nglc5xx1cm03z9sisg0iqrhwcj6gh5z254rrpl8p4fwrxx680";
  };

  go-fuse = buildFromGitHub rec {
    rev = "324ea173d0a4d90e0e97c464a6ad33f80c9587a8";
    date = "2015-07-27";
    owner = "hanwen";
    repo = "go-fuse";
    sha256 = "0r5amgnpb4g7b6kpz42vnj01w515by4yhy64s5lqf3snzjygaycf";
  };

  go-github = buildFromGitHub {
    rev = "34fb8ee07214d23c3035c95691fe9069705814d6";
    owner = "google";
    repo = "go-github";
    sha256 = "0ygh0f6p679r095l4bym8q4l45w2l3d8r3hx9xrnnppxq59i2395";
    buildInputs = [ oauth2 ];
    propagatedBuildInputs = [ go-querystring ];
  };

  go-gypsy = buildFromGitHub {
    rev    = "42fc2c7ee9b8bd0ff636cd2d7a8c0a49491044c5";
    owner  = "kylelemons";
    repo   = "go-gypsy";
    sha256 = "04iy8rdk19n7i18bqipknrcb8lsy1vr4d1iqyxsxq6rmb7298iwj";
  };

  go-homedir = buildFromGitHub {
    rev    = "1f6da4a72e57d4e7edd4a7295a585e0a3999a2d4";
    owner  = "mitchellh";
    repo   = "go-homedir";
    sha256 = "1l5lrsjrnwxn299mhvyxvz8hd0spkx0d31gszm4cyx21bg1xsiy9";
  };

  go-hostpool = buildFromGitHub {
    rev    = "d0e59c22a56e8dadfed24f74f452cea5a52722d2";
    date   = "2015-03-31";
    owner  = "bitly";
    repo   = "go-hostpool";
    sha256 = "14ph12krn5zlg00vh9g6g08lkfjxnpw46nzadrfb718yl1hgyk3g";
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

  go-lxc = buildFromGitHub {
    rev    = "a0fa4019e64b385dfa2fb8abcabcdd2f66871639";
    owner  = "lxc";
    repo   = "go-lxc";
    sha256 = "0fkkmn7ynmzpr7j0ha1qsmh3k86ncxcbajmcb90hs0k0iaaiaahz";
    goPackagePath = "gopkg.in/lxc/go-lxc.v2";
    nativeBuildInputs = [ pkgs.pkgconfig ];
    buildInputs = [ pkgs.lxc ];
  };

  go-lz4 = buildFromGitHub {
    rev    = "74ddf82598bc4745b965729e9c6a463bedd33049";
    owner  = "bkaradzic";
    repo   = "go-lz4";
    sha256 = "1vdid8v0c2v2qhrg9rzn3l7ya1h34jirrxfnir7gv7w6s4ivdvc1";
  };

  rcrowley.go-metrics = buildFromGitHub {
    rev = "1ce93efbc8f9c568886b2ef85ce305b2217b3de3";
    date = "2015-08-22";
    owner = "rcrowley";
    repo = "go-metrics";
    sha256 = "06gg72krlmd0z3zdq6s716blrga95pyj8dc2f2psfbknbkyrkfqa";
    propagatedBuildInputs = [ stathat ];
  };

  appengine = buildFromGitHub {
    rev = "72f4367c4f14a20a98dcc8b762953b40788407be";
    owner = "golang";
    repo = "appengine";
    sha256 = "1phjkb0f0xp08db3irbf5wzdsxzsddsig5wv70wvmnr44ijllh4f";
    goPackagePath = "google.golang.org/appengine";
    buildInputs = [ protobuf net ];
  };

  armon.go-metrics = buildGoPackage rec {
    rev = "b2d95e5291cdbc26997d1301a5e467ecbb240e25";
    name = "armon.go-metrics-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/armon/go-metrics";

    src = fetchFromGitHub {
      inherit rev;
      owner = "armon";
      repo = "go-metrics";
      sha256 = "1jvdf98jlbyzbb9w159nifvv8fihrcs66drnl8pilqdjpmkmyyck";
    };

    propagatedBuildInputs = [ prometheus.client_golang ];
  };

  go-multierror = buildFromGitHub {
    rev    = "56912fb08d85084aa318edcf2bba735b97cf35c5";
    owner  = "hashicorp";
    repo   = "go-multierror";
    sha256 = "0s01cqdab2f7fxkkjjk2wqx05a1shnwlvfn45h2pi3i4gapvcn0r";
  };

  go-nsq = buildFromGitHub {
    rev = "v1.0.4";
    owner = "nsqio";
    repo = "go-nsq";
    sha256 = "06hrkwk84w8rshkanvfgmgbiml7n06ybv192dvibhwgk2wz2dl46";
    propagatedBuildInputs = [ go-simplejson go-snappystream ];
    goPackageAliases = [ "github.com/bitly/go-nsq" ];
  };

  go-options = buildFromGitHub {
    rev    = "7c174072188d0cfbe6f01bb457626abb22bdff52";
    date   = "2014-12-20";
    owner  = "mreiferson";
    repo   = "go-options";
    sha256 = "0ksyi2cb4k6r2fxamljg42qbz5hdcb9kv5i7y6cx4ajjy0xznwgm";
  };

  go-querystring = buildFromGitHub {
    rev    = "547ef5ac979778feb2f760cdb5f4eae1a2207b86";
    owner  = "google";
    repo   = "go-querystring";
    sha256 = "00ani7fhydcmlsm3n93nmj1hcqp2wmzvihnb1gdzynif1hw0530y";
  };

  go-radix = buildFromGitHub {
    rev    = "fbd82e84e2b13651f3abc5ffd26b65ba71bc8f93";
    owner  = "armon";
    repo   = "go-radix";
    sha256 = "16y64r1v054c2ln0bi5mrqq1cmvy6d6pnxk1glb8lw2g31ksa80c";
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

  go-restful = buildFromGitHub {
    rev    = "892402ba11a2e2fd5e1295dd633481f27365f14d";
    owner  = "emicklei";
    repo   = "go-restful";
    sha256 = "0gr9f53vayc6501a1kaw4p3h9pgf376cgxsfnr3f2dvp0xacvw8x";
  };

  go-repo-root = buildFromGitHub {
    rev = "90041e5c7dc634651549f96814a452f4e0e680f9";
    date = "2014-09-11";
    owner = "cstrahan";
    repo = "go-repo-root";
    sha256 = "1rlzp8kjv0a3dnfhyqcggny0ad648j5csr2x0siq5prahlp48mg4";
    buildInputs = [ tools ];
  };

  go-runit = buildFromGitHub {
    rev    = "a9148323a615e2e1c93b7a9893914a360b4945c8";
    owner  = "soundcloud";
    repo   = "go-runit";
    sha256 = "00f2rfhsaqj2wjanh5qp73phx7x12a5pwd7lc0rjfv68l6sgpg2v";
  };

  go-simplejson = buildFromGitHub {
    rev    = "18db6e68d8fd9cbf2e8ebe4c81a78b96fd9bf05a";
    date   = "2015-03-31";
    owner  = "bitly";
    repo   = "go-simplejson";
    sha256 = "0lj9cxyncchlw6p35j0yym5q5waiz0giw6ri41qdwm8y3dghwwiy";
  };

  go-snappystream = buildFromGitHub {
    rev = "028eae7ab5c4c9e2d1cb4c4ca1e53259bbe7e504";
    date = "2015-04-16";
    owner = "mreiferson";
    repo = "go-snappystream";
    sha256 = "0jdd5whp74nvg35d9hzydsi3shnb1vrnd7shi9qz4wxap7gcrid6";
  };

  go-sqlite3 = buildFromGitHub {
    rev    = "b4142c444a8941d0d92b0b7103a24df9cd815e42";
    date   = "2015-07-29";
    owner  = "mattn";
    repo   = "go-sqlite3";
    sha256 = "0xq2y4am8dz9w9aaq24s1npg1sn8pf2gn4nki73ylz2fpjwq9vla";
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

    src = fetchFromGitHub {
      inherit rev;
      owner = "coreos";
      repo = "go-systemd";
      sha256 = "0c1k3y5msc1xplhx0ksa7g08yqjaavns8s5zrfg4ig8az30gwlpa";
    };

    buildInputs = [ dbus ];
  };

  lxd-go-systemd = buildFromGitHub {
    rev = "a3dcd1d0480ee0ae9ec354f1632202bfba715e03";
    date = "2015-07-01";
    owner = "stgraber";
    repo = "lxd-go-systemd";
    sha256 = "006dhy3j8ld0kycm8hrjxvakd7xdn1b6z2dsjp1l4sqrxdmm188w";
    buildInputs = [ dbus ];
  };

  go-update-v0 = buildFromGitHub {
    rev = "d8b0b1d421aa1cbf392c05869f8abbc669bb7066";
    owner = "inconshreveable";
    repo = "go-update";
    sha256 = "0cvkik2w368fzimx3y29ncfgw7004qkbdf2n3jy5czvzn35q7dpa";
    goPackagePath = "gopkg.in/inconshreveable/go-update.v0";
    buildInputs = [ osext binarydist ];
  };

  go-uuid = buildFromGitHub {
    rev    = "6b8e5b55d20d01ad47ecfe98e5171688397c61e9";
    date   = "2015-07-22";
    owner  = "satori";
    repo   = "go.uuid";
    sha256 = "0injxzds41v8nc0brvyrrjl66fk3hycz6im38s5r9ccbwlp68p44";
  };

  go-vhost = buildFromGitHub {
    rev    = "c4c28117502e4bf00960c8282b2d1c51c865fe2c";
    owner  = "inconshreveable";
    repo   = "go-vhost";
    sha256 = "1rway6sls6fl2s2jk20ajj36rrlzh9944ncc9pdd19kifix54z32";
  };

  go-zookeeper = buildFromGitHub {
    rev    = "5bb5cfc093ad18a28148c578f8632cfdb4d802e4";
    date   = "2015-06-02";
    owner  = "samuel";
    repo   = "go-zookeeper";
    sha256 = "1kpx1ymh7rds0b2km291idnyqi0zck74nd8hnk72crgz7wmpqv6z";
  };

  lint = buildFromGitHub {
    rev = "7b7f4364ff76043e6c3610281525fabc0d90f0e4";
    date = "2015-06-23";
    owner = "golang";
    repo = "lint";
    sha256 = "1bj7zv534hyh87bp2vsbhp94qijc5nixb06li1dzfz9n0wcmlqw9";
    excludedPackages = "testdata";
    buildInputs = [ tools ];
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

  groupcache = buildFromGitHub {
    rev    = "604ed5785183e59ae2789449d89e73f3a2a77987";
    owner  = "golang";
    repo   = "groupcache";
    sha256 = "1jh862mmgss71wls4yxv633agr7dk7y6h36npwqxbmhbz5c2q28l";
    buildInputs = [ protobuf ];
  };

  grpc = buildFromGitHub {
    rev = "d455e65570c07e6ee7f23275063fbf34660ea616";
    date = "2015-08-29";
    owner = "grpc";
    repo = "grpc-go";
    sha256 = "08vra95hc8ihnj353680zhiqrv3ssw5yywkrifzb1zwl0l3cs2hr";
    goPackagePath = "google.golang.org/grpc";
    goPackageAliases = [ "github.com/grpc/grpc-go" ];
    propagatedBuildInputs = [ http2 net protobuf oauth2 glog etcd ];
    excludedPackages = "\\(test\\|benchmark\\)";
  };

  gucumber = buildGoPackage rec {
    rev = "e8116c9c66e641e9f81fc0a79fac923dfc646378";
    name = "gucumber-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/lsegal/gucumber";

    src = fetchFromGitHub {
      inherit rev;
      owner = "lsegal";
      repo = "gucumber";
      sha256 = "1ic1lsv05da6qv8xmf94lpbmaisxi8mwbv7bh2k1y78lh43yncah";
    };

    buildInputs = [ testify ];
    propagatedBuildInputs = [ ansicolor ];
  };

  hcl = buildFromGitHub {
    rev  = "54864211433d45cb780682431585b3e573b49e4a";
    owner  = "hashicorp";
    repo   = "hcl";
    sha256 = "07l2dydzjpdgm2d4a72hkmincn455j3nrafg6hs3c23bkvizj950";
    buildInputs = [ go-multierror ];
  };

  hipchat-go = buildGoPackage rec {
    rev = "1dd13e154219c15e2611fe46adbb6bf65db419b7";
    name = "hipchat-go-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/tbruyelle/hipchat-go";

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
    buildInputs = [ crypto protobuf goamz rgbterm go-bindata go-homedir ldap g2s gox ];
  };

  http2 = buildFromGitHub rec {
    rev = "f8202bc903bda493ebba4aa54922d78430c2c42f";
    owner = "bradfitz";
    repo = "http2";
    sha256 = "0cza2126jbji5vijwk4dxs05hifnff04xcr0vhxvafs6hz3sacvr";
    buildInputs = [ crypto ];
  };

  httprouter = buildFromGitHub {
    rev    = "6aacfd5ab513e34f7e64ea9627ab9670371b34e7";
    date   = "2015-07-08";
    owner  = "julienschmidt";
    repo   = "httprouter";
    sha256 = "00rrjysmq898qcrf2hfwfh9s70vwvmjx2kp5w03nz1krxa4zhrkl";
  };

  inf = buildFromGitHub {
    rev    = "c85f1217d51339c0fa3a498cc8b2075de695dae6";
    owner  = "go-inf";
    repo   = "inf";
    sha256 = "1ykdk410vca8i35db2fp6qqcfx0bmx95k0xqd15wzsl0xjmyjk3y";
    goPackagePath = "gopkg.in/inf.v0";
    goPackageAliases = [ "github.com/go-inf/inf" ];
  };

  influxdb = buildFromGitHub {
    rev = "v0.9.3";
    owner = "influxdb";
    repo = "influxdb";
    sha256 = "0hsvm8ls1g12j1d5ap396vqfpvd0g72hymhczdqg6z96h3zi90bx";
    propagatedBuildInputs = [ raft raft-boltdb snappy crypto gogo.protobuf pool pat toml gollectd statik liner ];
    excludedPackages = "test";
  };

  influxdb8-client = buildFromGitHub{
    rev = "v0.8.8";
    owner = "influxdb";
    repo = "influxdb";
    sha256 = "0xpigp76rlsxqj93apjzkbi98ha5g4678j584l6hg57p711gqsdv";
    subPackages = [ "client" ];
  };

  influxdb-backup = buildFromGitHub {
    rev = "4556edbffa914a8c17fa1fa1564962a33c6c7596";
    date = "2014-07-28";
    owner = "eckardt";
    repo = "influxdb-backup";
    sha256 = "2928063e6dfe4be7b69c8e72e4d6a5fc557f0c75e9625fadf607d59b8e80e34b";
    buildInputs = [ eckardt.influxdb-go ];
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

  ipfs = buildFromGitHub{
    rev = "ff26c312000da12d395c9cdba05c43f29b68b456";
    owner  = "ipfs";
    repo   = "go-ipfs";
    sha256 = "0qj3rwq5i4aiwn0i09skpi1s3mzqm8ma9v1cpjl7rya2y6ypx8xg";
    disabled = !isGo14;
  };

  ldap = buildGoPackage rec {
    rev = "83e65426fd1c06626e88aa8a085e5bfed0208e29";
    name = "ldap-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/go-ldap/ldap";
    goPackageAliases = [
      "github.com/nmcclain/ldap"
      "github.com/vanackere/ldap"
    ];

    src = fetchFromGitHub {
      inherit rev;
      owner  = "go-ldap";
      repo   = "ldap";
      sha256 = "179lwaf0hvczl8g4xzkpcpzq25p1b23f7399bx5zl55iin62d8yz";
    };

    propagatedBuildInputs = [ asn1-ber ];
  };

  levigo = buildGoPackage rec {
    rev = "1ddad808d437abb2b8a55a950ec2616caa88969b";
    name = "levigo-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/jmhodges/levigo";

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

  log15 = buildFromGitHub {
    rev    = "dc7890abeaadcb6a79a9a5ee30bc1897bbf97713";
    owner  = "inconshreveable";
    repo   = "log15";
    sha256 = "15wgicl078h931n90rksgbqmfixvbfxywk3m8qkaln34v69x4vgp";
    goPackagePath = "gopkg.in/inconshreveable/log15.v2";
    propagatedBuildInputs = [ go-colorable ];
  };

  log4go = buildGoPackage rec {
    rev = "cb4cc51cd03958183d3b637d0750497d88c2f7a8";
    name = "log4go-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/ccpaging/log4go";
    goPackageAliases = [
      "github.com/alecthomas/log4go"
      "code.google.com/p/log4go"
    ];

    src = fetchFromGitHub {
      inherit rev;
      owner = "ccpaging";
      repo = "log4go";
      sha256 = "0l9f86zzhla9hq35q4xhgs837283qrm4gxbp5lrwwls54ifiq7k2";
    };

    propagatedBuildInputs = [ go-colortext ];
  };

  logger = buildFromGitHub {
    rev = "c96f6a1a8c7b6bf2f4860c667867d90174799eb2";
    date = "2015-05-23";
    owner = "calmh";
    repo = "logger";
    sha256 = "1f67xbvvf210g5cqa84l12s00ynfbkjinhl8y6m88yrdb025v1vg";
  };

  logrus = buildFromGitHub rec {
    rev = "v0.8.6";
    owner = "Sirupsen";
    repo = "logrus";
    sha256 = "1v2qcjy6w24jgdm7kk0f8lqpa25qxzll2x6ycqwidd3pzjhrkifa";
    propagatedBuildInputs = [ airbrake-go bugsnag-go raven-go ];
  };

  logutils = buildFromGitHub {
    rev    = "0dc08b1671f34c4250ce212759ebd880f743d883";
    owner  = "hashicorp";
    repo   = "logutils";
    sha256 = "0rynhjwvacv9ibl2k4fwz0xy71d583ac4p33gm20k9yldqnznc7r";
  };

  luhn = buildFromGitHub {
    rev    = "0c8388ff95fa92d4094011e5a04fc99dea3d1632";
    date   = "2015-01-13";
    owner  = "calmh";
    repo   = "luhn";
    sha256 = "1hfj1lx7wdpifn16zqrl4xml6cj5gxbn6hfz1f46g2a6bdf0gcvs";
  };

  lxd = buildFromGitHub {
    rev    = "22fec6bb6bb5988eb0f1b3532a02ebacfb26cf47";
    date   = "2015-08-05";
    owner  = "lxc";
    repo   = "lxd";
    sha256 = "1n7fhzl6vrn82r3cqpgqpgq5d5142rnk1cp7vig38323n2yh3749";
    excludedPackages = "test"; # Don't build the binary called test which causes conflicts
    buildInputs = [
      gettext-go websocket crypto log15 go-lxc yaml-v2 tomb protobuf pongo2
      lxd-go-systemd go-uuid tablewriter golang-petname mux go-sqlite3 goproxy
      pkgs.python3
    ];
    postInstall = ''
      cp go/src/$goPackagePath/scripts/lxd-images $bin/bin
    '';
  };

  mapstructure = buildFromGitHub {
    rev    = "281073eb9eb092240d33ef253c404f1cca550309";
    owner  = "mitchellh";
    repo   = "mapstructure";
    sha256 = "1zjx9fv29639sp1fn84rxs830z7gp7bs38yd5y1hl5adb8s5x1mh";
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

  mesos-dns = buildFromGitHub {
    rev = "v0.1.2";
    owner = "mesosphere";
    repo = "mesos-dns";
    sha256 = "0zs6lcgk43j7jp370qnii7n55cd9pa8gl56r8hy4nagfvlvrcm02";

    # Avoid including the benchmarking test helper in the output:
    subPackages = [ "." ];

    buildInputs = [ glog mesos-go dns go-restful ];
  };

  mesos-go = buildFromGitHub {
    rev = "d98afa618cc9a9251758916f49ce87f9051b69a4";
    owner = "mesos";
    repo = "mesos-go";
    sha256 = "01ab0jf3cfb1rdwwb21r38rcfr5vp86pkfk28mws8298mlzbpri7";
    propagatedBuildInputs = [ gogo.protobuf glog net testify go-zookeeper objx uuid ];
    excludedPackages = "test";
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

  mgo = buildFromGitHub {
    rev = "r2015.06.03";
    owner = "go-mgo";
    repo = "mgo";
    sha256 = "1bwqbngdy0ghwpvarsz8rlrirdmjrda44aghihpfmin06hxy3zcd";
    goPackagePath = "gopkg.in/mgo.v2";
    goPackageAliases = [ "github.com/go-mgo/mgo" ];
    buildInputs = [ pkgs.cyrus_sasl tomb ];
  };

  mongo-tools = buildFromGitHub {
    rev    = "4fcfd3e57415de95c0c016def07b95bca63cccb4";
    owner  = "mongodb";
    repo   = "mongo-tools";
    sha256 = "0rm7bnb81hr0byxhvagwv8an1bky882nz68cmm2kbznzyprvhyaa";
    buildInputs = [ gopass go-flags mgo openssl tomb ];
    excludedPackages = "vendor";

    # Mongodb incorrectly names all of their binaries main
    # Let's work around this with our own installer
    preInstall = ''
      mkdir -p $bin/bin
      while read b; do
        rm -f go/bin/main
        go install $goPackagePath/$b/main
        cp go/bin/main $bin/bin/$b
      done < <(find go/src/$goPackagePath -name main | xargs dirname | xargs basename -a)
      rm -r go/bin
    '';
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

  mtpfs = buildFromGitHub {
    rev = "3ef47f91c38cf1da3e965e37debfc81738e9cd94";
    date = "2015-08-01";
    owner = "hanwen";
    repo = "go-mtpfs";
    sha256 = "1f7lcialkpkwk01f7yxw77qln291sqjkspb09mh0yacmrhl231g8";

    buildInputs = [ go-fuse usb ];
  };

  mux = buildFromGitHub {
    rev = "5a8a0400500543e28b2886a8c52d21a435815411";
    date = "2015-08-05";
    owner = "gorilla";
    repo = "mux";
    sha256 = "15w1bw14vx157r6v98fhy831ilnbzdsm5xzvs23j8hw6gnknzaw1";
    propagatedBuildInputs = [ context ];
  };

  muxado = buildFromGitHub {
    rev    = "f693c7e88ba316d1a0ae3e205e22a01aa3ec2848";
    owner  = "inconshreveable";
    repo   = "muxado";
    sha256 = "1vgiwwxhgx9c899f6ikvrs0w6vfsnypzalcqyr0mqm2w816r9hhs";
  };

  mysql = buildFromGitHub {
    rev    = "fb7299726d2e68745a8805b14f2ff44b5c2cfa84";
    owner  = "go-sql-driver";
    repo   = "mysql";
    sha256 = "185af0x475hq2wmm2zdvxjyslkplf8zzqijdxa937zqxq63qiw4w";
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

  ngrok = buildFromGitHub {
    rev = "1.7.1";
    owner = "inconshreveable";
    repo = "ngrok";
    sha256 = "1r4nc9knp0nxg4vglg7v7jbyd1nh1j2590l720ahll8a4fbsx5a4";
    goPackagePath = "ngrok";

    preConfigure = ''
      sed -e '/jteeuwen\/go-bindata/d' \
          -e '/export GOPATH/d' \
          -e 's/go get/#go get/' \
          -e 's|bin/go-bindata|go-bindata|' -i Makefile
      make assets BUILDTAGS=release
      export sourceRoot=$sourceRoot/src/ngrok
    '';

    buildInputs = [
      git log4go websocket go-vhost mousetrap termbox-go rcrowley.go-metrics
      yaml-v1 go-bindata.bin go-update-v0 binarydist osext
    ];

    buildFlags = [ "-tags release" ];
  };

  nsq = buildFromGitHub {
    rev = "v0.3.5";
    owner = "bitly";
    repo = "nsq";
    sha256 = "1r7jgplzn6bgwhd4vn8045n6cmm4iqbzssbjgj7j1c28zbficy2f";

    excludedPackages = "bench";

    buildInputs = [ go-nsq go-options semver perks toml go-hostpool timer_metrics ];
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

  openssl = buildFromGitHub {
    rev = "4c6dbafa5ec35b3ffc6a1b1e1fe29c3eba2053ec";
    owner = "10gen";
    repo = "openssl";
    sha256 = "1033c9vgv9lf8ks0qjy0ylsmx1hizqxa6izalma8vi30np6ka6zn";
    goPackageAliases = [ "github.com/spacemonkeygo/openssl" ];
    nativeBuildInputs = [ pkgs.pkgconfig ];
    buildInputs = [ pkgs.openssl ];
    propagatedBuildInputs = [ spacelog ];

    preBuild = ''
      find go/src/$goPackagePath -name \*.go | xargs sed -i 's,spacemonkeygo/openssl,10gen/openssl,g'
    '';
  };

  opsgenie-go-sdk = buildFromGitHub {
    rev = "c6e1235dfed2126eb9b562c4d776baf55ccd23e3";
    date = "2015-08-24";
    owner = "opsgenie";
    repo = "opsgenie-go-sdk";
    sha256 = "1prvnjiqmhnp9cggp9f6882yckix2laqik35fcj32117ry26p4jm";
    propagatedBuildInputs = [ seelog go-querystring goreq ];
    excludedPackages = "samples";
  };

  osext = buildFromGitHub {
    rev = "6e7f843663477789fac7c02def0d0909e969b4e5";
    owner = "kardianos";
    repo = "osext";
    sha256 = "1sn1kk60azqbll687fndiskkfvp0ppca8rmakv8wgsn7a64sm39f";
    goPackageAliases = [
      "github.com/bugsnag/osext"
      "bitbucket.org/kardianos/osext"
    ];
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

  pb = buildFromGitHub {
    rev    = "e648e12b78cedf14ebb2fc1855033f07b034cfbb";
    owner  = "cheggaaa";
    repo   = "pb";
    sha256 = "03k4cars7hcqqgdsd0minfls2p7gjpm8q6y8vknh1s68kvxd4xam";
  };

  perks = buildFromGitHub rec {
    date   = "2014-07-16";
    owner  = "bmizerany";
    repo   = "perks";
    rev    = "d9a9656a3a4b1c2864fdb44db2ef8619772d92aa";
    sha256 = "0f39b3zfm1zd6xcvlm6szgss026qs84n2j9y5bnb3zxzdkxb9w9n";
  };

  beorn7.perks = buildFromGitHub rec {
    date   = "2015-02-23";
    owner  = "beorn7";
    repo   = "perks";
    rev    = "b965b613227fddccbfffe13eae360ed3fa822f8d";
    sha256 = "1p8zsj4r0g61q922khfxpwxhdma2dx4xad1m5qx43mfn28kxngqk";
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

  pond = let isx86_64 = stdenv.lib.any (n: n == stdenv.system) stdenv.lib.platforms.x86_64; in buildFromGitHub {
    rev = "bce6e0dc61803c23699c749e29a83f81da3c41b2";
    owner = "agl";
    repo = "pond";
    sha256 = "1dmgbg4ak3jkbgmxh0lr4hga1nl623mh7pvsgby1rxl4ivbzwkh4";

    buildInputs = [ net crypto protobuf ed25519 pkgs.trousers ]
      ++ stdenv.lib.optional isx86_64 pkgs.dclxvi;
    buildFlags = "-tags nogui";
    excludedPackages = "\\(appengine\\|bn256cgo\\)";
    postPatch = stdenv.lib.optionalString isx86_64 ''
      grep -r 'bn256' | awk -F: '{print $1}' | xargs sed -i \
        -e "s,golang.org/x/crypto/bn256,github.com/agl/pond/bn256cgo,g" \
        -e "s,bn256\.,bn256cgo.,g"
    '';
  };

  pongo2 = buildFromGitHub {
    rev    = "5e81b817a0c48c1c57cdf1a9056cf76bdee02ca9";
    date   = "2014-10-27";
    owner  = "flosch";
    repo   = "pongo2";
    sha256 = "0fd7d79644zmcirsb1gvhmh0l5vb5nyxmkzkvqpmzzcg6yfczph8";
    goPackagePath = "gopkg.in/flosch/pongo2.v3";
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
    rev    = "0dad96c0b94f8dee039aa40467f767467392a0af";
    owner  = "lib";
    repo   = "pq";
    sha256 = "06c38iy37251mh8jy9s8n97b01pjnqpq8ii77nnmqh1dsph37jz4";
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

  prometheus.alertmanager = buildGoPackage rec {
    name = "prometheus-alertmanager-${rev}";
    rev = "0.0.4";
    goPackagePath = "github.com/prometheus/alertmanager";

    src = fetchFromGitHub {
      owner = "prometheus";
      repo = "alertmanager";
      inherit rev;
      sha256 = "0g656rzal7m284mihqdrw23vhs7yr65ax19nvi70jl51wdallv15";
    };

    buildInputs = [
      fsnotify.v0
      httprouter
      prometheus.client_golang
      prometheus.log
      pushover
    ];

    buildFlagsArray = ''
      -ldflags=
          -X main.buildVersion=${rev}
          -X main.buildBranch=master
          -X main.buildUser=nix@nixpkgs
          -X main.buildDate=20150101-00:00:00
          -X main.goVersion=${stdenv.lib.getVersion go}
    '';

    meta = with stdenv.lib; {
      description = "Alert dispatcher for the Prometheus monitoring system";
      homepage = https://github.com/prometheus/alertmanager;
      license = licenses.asl20;
      maintainers = with maintainers; [ benley ];
      platforms = platforms.unix;
    };
  };

  prometheus.client_golang = buildFromGitHub {
    rev = "0.7.0";
    owner = "prometheus";
    repo = "client_golang";
    sha256 = "1i3g5h2ncdb8b67742kfpid7d0a1jas1pyicglbglwngfmzhpkna";
    propagatedBuildInputs = [
      goautoneg
      protobuf
      golang_protobuf_extensions
      prometheus.client_model
      prometheus.procfs
      beorn7.perks
    ];
  };

  prometheus.cli = buildFromGitHub {
    rev = "0.3.0";
    owner = "prometheus";
    repo = "prometheus_cli";
    sha256 = "1qxqrcbd0d4mrjrgqz882jh7069nn5gz1b84rq7d7z1f1dqhczxn";

    buildInputs = [
      prometheus.client_model
      prometheus.client_golang
    ];

    meta = with stdenv.lib; {
      description = "Command line tool for querying the Prometheus HTTP API";
      homepage = https://github.com/prometheus/prometheus_cli;
      license = licenses.asl20;
      maintainers = with maintainers; [ benley ];
      platforms = platforms.unix;
    };
  };

  prometheus.client_model = buildFromGitHub {
    rev    = "fa8ad6fec33561be4280a8f0514318c79d7f6cb6";
    date   = "2015-02-12";
    owner  = "prometheus";
    repo   = "client_model";
    sha256 = "11a7v1fjzhhwsl128znjcf5v7v6129xjgkdpym2lial4lac1dhm9";
    buildInputs = [ protobuf ];
  };

  prometheus.collectd-exporter = buildFromGitHub {
    rev = "0.1.0";
    owner = "prometheus";
    repo = "collectd_exporter";
    sha256 = "165zsdn0lffb6fvxz75szmm152a6wmia5skb96k1mv59qbmn9fi1";
    buildInputs = [ prometheus.client_golang ];
    meta = with stdenv.lib; {
      description = "Relay server for exporting metrics from collectd to Prometheus";
      homepage = https://github.com/prometheus/alertmanager;
      license = licenses.asl20;
      maintainers = with maintainers; [ benley ];
      platforms = platforms.unix;
    };
  };

  prometheus.haproxy-exporter = buildFromGitHub {
    rev = "0.4.0";
    owner = "prometheus";
    repo = "haproxy_exporter";
    sha256 = "0cwls1d4hmzjkwc50mjkxjb4sa4q6yq581wlc5sg9mdvl6g91zxr";
    buildInputs = [ prometheus.client_golang ];
    meta = with stdenv.lib; {
      description = "HAProxy Exporter for the Prometheus monitoring system";
      homepage = https://github.com/prometheus/haproxy_exporter;
      license = licenses.asl20;
      maintainers = with maintainers; [ benley ];
      platforms = platforms.unix;
    };
  };

  prometheus.log = buildFromGitHub {
    rev    = "439e5db48fbb50ebbaf2c816030473a62f505f55";
    date   = "2015-05-29";
    owner  = "prometheus";
    repo   = "log";
    sha256 = "1fl23gsw2hn3c1y91qckr661sybqcw2gqnd1gllxn3hp6p2w6hxv";
    propagatedBuildInputs = [ logrus ];
  };

  prometheus.mesos-exporter = buildFromGitHub {
    rev = "0.1.0";
    owner = "prometheus";
    repo = "mesos_exporter";
    sha256 = "059az73j717gd960g4jigrxnvqrjh9jw1c324xpwaafa0bf10llm";
    buildInputs = [ mesos-stats prometheus.client_golang glog ];
    meta = with stdenv.lib; {
      description = "Export Mesos metrics to Prometheus";
      homepage = https://github.com/prometheus/mesos_exporter;
      license = licenses.asl20;
      maintainers = with maintainers; [ benley ];
      platforms = platforms.unix;
    };
  };

  prometheus.mysqld-exporter = buildFromGitHub {
    rev = "0.1.0";
    owner = "prometheus";
    repo = "mysqld_exporter";
    sha256 = "10xnyxyb6saz8pq3ijp424hxy59cvm1b5c9zcbw7ddzzkh1f6jd9";
    buildInputs = [ mysql prometheus.client_golang ];
    meta = with stdenv.lib; {
      description = "Prometheus exporter for MySQL server metrics";
      homepage = https://github.com/prometheus/mysqld_exporter;
      license = licenses.asl20;
      maintainers = with maintainers; [ benley ];
      platforms = platforms.unix;
    };
  };

  prometheus.nginx-exporter = buildFromGitHub {
    rev = "2cf16441591f6b6e58a8c0439dcaf344057aea2b";
    date = "2015-06-01";
    owner = "discordianfish";
    repo = "nginx_exporter";
    sha256 = "0p9j0bbr2lr734980x2p8d67lcify21glwc5k3i3j4ri4vadpxvc";
    buildInputs = [ prometheus.client_golang prometheus.log ];
    meta = with stdenv.lib; {
      description = "Metrics relay from nginx stats to Prometheus";
      homepage = https://github.com/discordianfish/nginx_exporter;
      license = licenses.asl20;
      maintainers = with maintainers; [ benley ];
      platforms = platforms.unix;
    };
  };

  prometheus.node-exporter = buildFromGitHub {
    rev = "0.10.0";
    owner = "prometheus";
    repo = "node_exporter";
    sha256 = "0dmczav52v9vi0kxl8gd2s7x7c94g0vzazhyvlq1h3729is2nf0p";

    buildInputs = [
      go-runit
      ntp
      prometheus.client_golang
      prometheus.client_model
      prometheus.log
      protobuf
    ];

    meta = with stdenv.lib; {
      description = "Prometheus exporter for machine metrics";
      homepage = https://github.com/prometheus/node_exporter;
      license = licenses.asl20;
      maintainers = with maintainers; [ benley ];
      platforms = platforms.unix;
    };
  };

  prometheus.procfs = buildFromGitHub {
    rev    = "c91d8eefde16bd047416409eb56353ea84a186e4";
    date   = "2015-06-16";
    owner  = "prometheus";
    repo   = "procfs";
    sha256 = "0pj3gzw9b58l72w0rkpn03ayssglmqfmyxghhfad6mh0b49dvj3r";
  };

  prometheus.prom2json = buildFromGitHub {
    rev = "0.1.0";
    owner = "prometheus";
    repo = "prom2json";
    sha256 = "0wwh3mz7z81fwh8n78sshvj46akcgjhxapjgfic5afc4nv926zdl";

    buildInputs = [
      golang_protobuf_extensions
      prometheus.client_golang
      protobuf
    ];

    meta = with stdenv.lib; {
      description = "Tool to scrape a Prometheus client and dump the result as JSON";
      homepage = https://github.com/prometheus/prom2json;
      license = licenses.asl20;
      maintainers = with maintainers; [ benley ];
      platforms = platforms.unix;
    };
  };

  prometheus.prometheus = buildGoPackage rec {
    name = "prometheus-${version}";
    version = "0.15.1";
    goPackagePath = "github.com/prometheus/prometheus";
    rev = "64349aade284846cb194be184b1b180fca629a7c";

    src = fetchFromGitHub {
      inherit rev;
      owner = "prometheus";
      repo = "prometheus";
      sha256 = "0gljpwnlip1fnmhbc96hji2rc56xncy97qccm7v1z5j1nhc5fam2";
    };

    buildInputs = [
      consul
      dns
      fsnotify.v1
      go-zookeeper
      goleveldb
      httprouter
      logrus
      net
      prometheus.client_golang
      prometheus.log
      yaml-v2
    ];

    preInstall = ''
      mkdir -p "$bin/share/doc/prometheus" "$bin/etc/prometheus"
      cp -a $src/documentation/* $bin/share/doc/prometheus
      cp -a $src/console_libraries $src/consoles $bin/etc/prometheus
    '';

    # Metadata that gets embedded into the binary
    buildFlagsArray = let t = "${goPackagePath}/version"; in
    ''
      -ldflags=
          -X ${t}.Version=${version}
          -X ${t}.Revision=${builtins.substring 0 6 rev}
          -X ${t}.Branch=master
          -X ${t}.BuildUser=nix@nixpkgs
          -X ${t}.BuildDate=20150101-00:00:00
          -X ${t}.GoVersion=${stdenv.lib.getVersion go}
    '';

    meta = with stdenv.lib; {
      description = "Service monitoring system and time series database";
      homepage = http://prometheus.io;
      license = licenses.asl20;
      maintainers = with maintainers; [ benley ];
      platforms = platforms.unix;
    };
  };

  prometheus.pushgateway = buildFromGitHub rec {
    rev = "0.1.1";
    owner = "prometheus";
    repo = "pushgateway";
    sha256 = "17q5z9msip46wh3vxcsq9lvvhbxg75akjjcr2b29zrky8bp2m230";

    buildInputs = [
      protobuf
      httprouter
      golang_protobuf_extensions
      prometheus.client_golang
    ];

    nativeBuildInputs = [ go-bindata.bin ];
    preBuild = ''
    (
      cd "go/src/$goPackagePath"
      go-bindata ./resources/
    )
    '';

    buildFlagsArray = ''
      -ldflags=
          -X main.buildVersion=${rev}
          -X main.buildRev=${rev}
          -X main.buildBranch=master
          -X main.buildUser=nix@nixpkgs
          -X main.buildDate=20150101-00:00:00
          -X main.goVersion=${stdenv.lib.getVersion go}
    '';

    meta = with stdenv.lib; {
      description = "Allows ephemeral and batch jobs to expose metrics to Prometheus";
      homepage = https://github.com/prometheus/pushgateway;
      license = licenses.asl20;
      maintainers = with maintainers; [ benley ];
      platforms = platforms.unix;
    };
  };

  prometheus.statsd-bridge = buildFromGitHub {
    rev = "0.1.0";
    owner = "prometheus";
    repo = "statsd_bridge";
    sha256 = "1fndpmd1k0a3ar6f7zpisijzc60f2dng5399nld1i1cbmd8jybjr";
    buildInputs = [ fsnotify.v0 prometheus.client_golang ];
    meta = with stdenv.lib; {
      description = "Receives StatsD-style metrics and exports them to Prometheus";
      homepage = https://github.com/prometheus/statsd_bridge;
      license = licenses.asl20;
      maintainers = with maintainers; [ benley ];
      platforms = platforms.unix;
    };
  };

  gogo.protobuf = buildFromGitHub {
    rev = "932b70afa8b0bf4a8e167fdf0c3367cebba45903";
    owner = "gogo";
    repo = "protobuf";
    sha256 = "1djhv9ckqhyjnnqajjv8ivcwpmjdnml30l6zhgbjcjwdyz3nyzhx";
    excludedPackages = "test";
    goPackageAliases = [
      "code.google.com/p/gogoprotobuf"
    ];
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

  qart = buildFromGitHub {
    rev    = "ccb109cf25f0cd24474da73b9fee4e7a3e8a8ce0";
    owner  = "vitrun";
    repo   = "qart";
    sha256 = "0bhp768b8ha6f25dmhwn9q8m2lkbn4qnjf8n7pizk25jn5zjdvc8";
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

  ratelimit = buildFromGitHub {
    rev    = "772f5c38e468398c4511514f4f6aa9a4185bc0a0";
    date   = "2015-06-19";
    owner  = "juju";
    repo   = "ratelimit";
    sha256 = "02rs61ay6sq499lxxszjsrxp33m6zklds1xrmnr5fk73vpqfa28p";
  };

  raw = buildFromGitHub {
    rev    = "724aedf6e1a5d8971aafec384b6bde3d5608fba4";
    owner  = "feyeleanor";
    repo   = "raw";
    sha256 = "0z4dcnadgk0fbxxd14dqa1wzzr0v3ksqlzd0swzs2mipim5wjgsz";
  };

  raven-go = buildFromGitHub {
    rev    = "74c334d7b8aaa4fd1b4fc6aa428c36fed1699e28";
    date   = "2015-07-21";
    owner  = "getsentry";
    repo   = "raven-go";
    sha256 = "1356a7h8zp1mcywnr0y83w0h4qdblp65rcf9slbx667n8x2rzda8";
  };

  redigo = buildFromGitHub {
    rev    = "535138d7bcd717d6531c701ef5933d98b1866257";
    owner  = "garyburd";
    repo   = "redigo";
    sha256 = "1m7nc1gvv5yqnq8ii75f33485il6y6prf8gxl97dimsw94qccc5v";
  };

  relaysrv = buildFromGitHub {
    rev    = "7fe1fdd8c751df165ea825bc8d3e895f118bb236";
    owner  = "syncthing";
    repo   = "relaysrv";
    sha256 = "0qy14pa0z2dq5mix5ylv2raabwxqwj31g5kkz905wzki6d4j5lnp";
    buildInputs = [ xdr syncthing-protocol ratelimit syncthing-lib ];
  };

  reflectwalk = buildFromGitHub {
    rev    = "eecf4c70c626c7cfbb95c90195bc34d386c74ac6";
    owner  = "mitchellh";
    repo   = "reflectwalk";
    sha256 = "1nm2ig7gwlmf04w7dbqd8d7p64z2030fnnfbgnd56nmd7dz8gpxq";
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

  seelog = buildFromGitHub {
    rev = "c510775bb50d98213cfafca75a4bc5e3fddc8d8f";
    date = "2015-05-26";
    owner = "cihub";
    repo = "seelog";
    sha256 = "1f0rwgqlffv1a7b05736a4gf4l9dn80wsfyqcnz6qd2skhwnzv29";
  };

  semver = buildFromGitHub {
    rev = "31b736133b98f26d5e078ec9eb591666edfd091f";
    date = "2015-07-20";
    owner = "blang";
    repo = "semver";
    sha256 = "19ifi0na4cj23q3h8xv89mx7p48y0ciymhmlrq9milm0xz80wk10";
  };

  serf = buildFromGitHub {
    rev = "668982d8f90f5eff4a766583c1286393c1d27f68";
    date = "2015-05-15";
    owner  = "hashicorp";
    repo   = "serf";
    sha256 = "1h05h5xhaj27r1mh5zshnykax29lqjhfc0bx4v9swiwb873c24qk";

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

  skydns = buildFromGitHub {
    rev = "2.5.2b";
    owner = "skynetservices";
    repo = "skydns";
    sha256 = "01vac6bd71wky5jbd5k4a0x665bjn1cpmw7p655jrdcn5757c2lv";

    buildInputs = [
      go-etcd rcrowley.go-metrics dns go-systemd prometheus.client_golang
    ];
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

  spacelog = buildFromGitHub {
    rev = "ae95ccc1eb0c8ce2496c43177430efd61930f7e4";
    owner = "spacemonkeygo";
    repo = "spacelog";
    sha256 = "1i1awivsix0ch0vg6rwvx0536ziyw6phcx45b1rmrclp6b6dyacy";
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

  structs = buildFromGitHub {
    rev    = "a9f7daa9c2729e97450c2da2feda19130a367d8f";
    owner  = "fatih";
    repo   = "structs";
    sha256 = "0pyrc7svc826g37al3db19n5l4r2m9h1mlhjh3hz2r41xfaqia50";
  };

  suture = buildFromGitHub {
    rev    = "fc7aaeabdc43fe41c5328efa1479ffea0b820978";
    owner  = "thejerf";
    repo   = "suture";
    sha256 = "1l7nw00pazp317n5nprrxwhcq56kdblc774lsznxmbb30xcp8nmf";
  };

  syncthing = buildFromGitHub {
    rev = "v0.11.23";
    owner = "syncthing";
    repo = "syncthing";
    sha256 = "06a5b68fq440xcysba65xbpr3zd4yhp7y1x6a11n5bx0rpxa4jzi";
    doCheck = true;
    buildInputs = [
      go-lz4 du luhn xdr snappy ratelimit osext syncthing-protocol relaysrv
      goleveldb suture qart crypto net text
    ];
  };

  syncthing-lib = buildFromGitHub {
    inherit (syncthing) rev owner repo sha256;
    subPackages = [ "lib/sync" ];
    buildInputs = [ logger ];
  };

  syncthing-protocol = buildFromGitHub {
    rev = "84365882de255d2204d0eeda8dee288082a27f98";
    date = "2015-08-28";
    owner = "syncthing";
    repo = "protocol";
    sha256 = "07xjs43lpd51pc339f8x487yhs39riysj3ifbjxsx329kljbflwx";
    propagatedBuildInputs = [ go-lz4 logger luhn xdr text ];
  };

  tablewriter = buildFromGitHub {
    rev    = "bc39950e081b457853031334b3c8b95cdfe428ba";
    date   = "2015-06-03";
    owner  = "olekukonko";
    repo   = "tablewriter";
    sha256 = "0n4gqjc2dqmnbpqgi9i8vrwdk4mkgyssc7l2n4r5bqx0n3nxpbps";
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
    rev = "089c7181b8c728499929ff09b62d3fdd8df8adff";
    name = "testify-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/stretchr/testify";

    src = fetchFromGitHub {
      inherit rev;
      owner = "stretchr";
      repo = "testify";
      sha256 = "03dzxkxbs298pvfsjz4kdadfaf9jkzsdhshqmg4p12wbyaj09s4p";
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

  timer_metrics = buildFromGitHub {
    rev = "afad1794bb13e2a094720aeb27c088aa64564895";
    date = "2015-02-02";
    owner = "bitly";
    repo = "timer_metrics";
    sha256 = "1b717vkwj63qb5kan4b92kx4rg6253l5mdb3lxpxrspy56a6rl0c";
  };

  tomb = buildFromGitHub {
    rev = "14b3d72120e8d10ea6e6b7f87f7175734b1faab8";
    owner = "go-tomb";
    repo = "tomb";
    sha256 = "1nza31jvkpka5431c4bdbirvjdy36b1b55sbzljqhqih25jrcjx5";
    goPackagePath = "gopkg.in/tomb.v2";
    goPackageAliases = [ "github.com/go-tomb/tomb" ];
  };

  toml = buildFromGitHub {
    rev    = "056c9bc7be7190eaa7715723883caffa5f8fa3e4";
    date   = "2015-05-01";
    owner  = "BurntSushi";
    repo   = "toml";
    sha256 = "0gkgkw04ndr5y7hrdy0r4v2drs5srwfcw2bs1gyas066hwl84xyw";
  };

  usb = buildFromGitHub rec {
    rev = "69aee4530ac705cec7c5344418d982aaf15cf0b1";
    date = "2014-12-17";
    owner = "hanwen";
    repo = "usb";
    sha256 = "01k0c2g395j65vm1w37mmrfkg6nm900khjrrizzpmx8f8yf20dky";

    nativeBuildInputs = [ pkgs.pkgconfig ];
    buildInputs = [ pkgs.libusb1 ];
  };

  uuid = buildFromGitHub {
    rev = "cccd189d45f7ac3368a0d127efb7f4d08ae0b655";
    date = "2015-08-24";
    owner = "pborman";
    repo = "uuid";
    sha256 = "0hswk9ihv3js5blp9pk2bpig64zkmyp5p1zhmgydfhb0dr2w8iad";
  };

  vault = buildFromGitHub {
    rev = "v0.2.0";
    owner = "hashicorp";
    repo = "vault";
    sha256 = "133fwhzk8z3xb6mf6scmn5rbl6g4vqg4g4n6zw620fsn9wy1b9ni";

    #postPatch = ''
    #  grep -r '/gen/' | awk -F: '{print $1}' | xargs sed -i 's,/gen/,/apis/,g'
    #'';

    # We just want the consul api not all of consul
    extraSrcs = [
      { inherit (consul) src goPackagePath; }
    ];

    buildInputs = [
      armon.go-metrics go-radix aws-sdk-go go-etcd structs ldap mysql gocql
      golang-lru go-github hashicorp.aws-sdk-go errwrap go-multierror go-syslog
      hcl logutils osext pq cli copystructure go-homedir mapstructure
      reflectwalk columnize go-zookeeper crypto net oauth2
    ];
  };

  vcs = buildFromGitHub {
    rev    = "c709a4244b817af98a8ecb495ca4ab0b11f27ecd";
    owner  = "Masterminds";
    repo   = "vcs";
    sha256 = "04gw4pp1f9wp36nvp9y234bmp267c4ajwcc39wa975cd89zhlhn4";
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
    rev    = "6eb6ad425a89d9da7a5549bc6da8f79ba5c17844";
    owner  = "gorilla";
    repo   = "websocket";
    sha256 = "0gljdfxqc94yb1kpqqrm5p94ph9dsxrzcixhdj6m92cwwa7z7p99";
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

  yaml-v2 = buildFromGitHub {
    rev = "7ad95dd0798a40da1ccdff6dff35fd177b5edf40";
    date = "2015-06-24";
    owner = "go-yaml";
    repo = "yaml";
    sha256 = "0d4jh46jq2yjg5dp00l7yl9ilhly7k4mfvi4harafd5ap5k9wnpb";
    goPackagePath = "gopkg.in/yaml.v2";
  };

  yamux = buildFromGitHub {
    rev    = "b2e55852ddaf823a85c67f798080eb7d08acd71d";
    owner  = "hashicorp";
    repo   = "yamux";
    sha256 = "0mr87my5m8lgc0byjcddlclxg34d07cpi9p78ps3rhzq7p37g533";
  };

  xdr = buildFromGitHub {
    rev    = "5f7208e86762911861c94f1849eddbfc0a60cbf0";
    date   = "2015-04-08";
    owner  = "calmh";
    repo   = "xdr";
    sha256 = "18m8ms2kg4apj5772r317i3axklgci8x1pq3pgicsv3acmpclh47";
  };

  xon = buildFromGitHub {
    rev    = "d580be739d723da4f6378083128f93017b8ab295";
    owner  = "odeke-em";
    repo   = "xon";
    sha256 = "07a7zj01d4a23xqp01m48jp2v5mw49islf4nbq2rj13sd5w4s6sc";
  };

}; in self
