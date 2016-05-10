/* This file defines the composition for Go packages. */

{ overrides, stdenv, go, buildGoPackage, git
, fetchgit, fetchhg, fetchurl, fetchFromGitHub, fetchFromBitbucket, fetchbzr, pkgs }:

let
  isGo14 = go.meta.branch == "1.4";
  isGo15 = go.meta.branch == "1.5";
  isGo16 = go.meta.branch == "1.6";

  self = _self // overrides; _self = with self; {

  inherit go buildGoPackage;

  buildFromGitHub = { rev, version ? null, owner, repo, sha256, name ? repo, goPackagePath ? "github.com/${owner}/${repo}", ... }@args: buildGoPackage (args // {
    inherit rev goPackagePath;
    name = "${name}-${if version != null then version else if builtins.stringLength rev != 40 then rev else stdenv.lib.strings.substring 0 7 rev}";
    src  = fetchFromGitHub { inherit rev owner repo sha256; };
  });

  ## OFFICIAL GO PACKAGES

  crypto = buildFromGitHub {
    rev      = "575fdbe86e5dd89229707ebec0575ce7d088a4a6";
    version  = "2015-08-29";
    owner    = "golang";
    repo     = "crypto";
    sha256   = "1kgv1mkw9y404pk3lcwbs0vgl133mwyp294i18jg9hp10s5d56xa";
    goPackagePath = "golang.org/x/crypto";
    goPackageAliases = [
      "code.google.com/p/go.crypto"
      "github.com/golang/crypto"
    ];
  };

  glog = buildFromGitHub {
    rev    = "fca8c8854093a154ff1eb580aae10276ad6b1b5f";
    version = "2015-07-31";
    owner  = "golang";
    repo   = "glog";
    sha256 = "1nr2q0vas0a2f395f4shjxqpas18mjsf8yhgndsav7svngpbbpg8";
  };

  codesearch = buildFromGitHub {
    rev    = "a45d81b686e85d01f2838439deaf72126ccd5a96";
    version = "2015-06-17";
    owner  = "google";
    repo   = "codesearch";
    sha256 = "12bv3yz0l3bmsxbasfgv7scm9j719ch6pmlspv4bd4ix7wjpyhny";
  };

  image = buildFromGitHub {
    rev = "8ab1ac6834edd43d91cbe24272897a87ce7e835e";
    version = "2015-08-23";
    owner = "golang";
    repo = "image";
    sha256 = "1ckr7yh5dx2kbvp9mis7i090ss9qcz46sazrj9f2hw4jj5g3y7dr";
    goPackagePath = "golang.org/x/image";
    goPackageAliases = [ "github.com/golang/image" ];
  };

  net_go15 = buildFromGitHub {
    rev    = "62ac18b461605b4be188bbc7300e9aa2bc836cd4";
    version = "2015-11-04";
    owner  = "golang";
    repo   = "net";
    sha256 = "0lwwvbbwbf3yshxkfhn6z20gd45dkvnmw2ms36diiy34krgy402p";
    goPackagePath = "golang.org/x/net";
    goPackageAliases = [
      "code.google.com/p/go.net"
      "github.com/hashicorp/go.net"
      "github.com/golang/net"
    ];
    propagatedBuildInputs = [ text crypto ];
    disabled = isGo14;
  };

  net_go14 = buildFromGitHub {
    rev    = "ea47fc708ee3e20177f3ca3716217c4ab75942cb";
    version = "2015-08-29";
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
    disabled = !isGo14;
  };

  net = if isGo14 then net_go14 else net_go15;

  oauth2 = buildFromGitHub {
    rev = "397fe7649477ff2e8ced8fc0b2696f781e53745a";
    version = "2015-06-23";
    owner = "golang";
    repo = "oauth2";
    sha256 = "0fza0l7iwh6llkq2yzqn7dxi138vab0da64lnghfj1p71fprjzn8";
    goPackagePath = "golang.org/x/oauth2";
    goPackageAliases = [ "github.com/golang/oauth2" ];
    propagatedBuildInputs = [ net gcloud-golang-compute-metadata ];
  };


  protobuf = buildFromGitHub {
    rev = "59b73b37c1e45995477aae817e4a653c89a858db";
    version = "2015-08-23";
    owner = "golang";
    repo = "protobuf";
    sha256 = "1dx22jvhvj34ivpr7gw01fncg9yyx35mbpal4mpgnqka7ajmgjsa";
    goPackagePath = "github.com/golang/protobuf";
    goPackageAliases = [ "code.google.com/p/goprotobuf" ];
  };

  snappy = buildFromGitHub {
    rev    = "723cc1e459b8eea2dea4583200fd60757d40097a";
    version = "2015-07-21";
    owner  = "golang";
    repo   = "snappy";
    sha256 = "0bprq0qb46f5511b5scrdqqzskqqi2z8b4yh3216rv0n1crx536h";
    goPackageAliases = [ "code.google.com/p/snappy-go/snappy" ];
  };

  sys = buildFromGitHub {
    rev    = "d9157a9621b69ad1d8d77a1933590c416593f24f";
    version = "2015-02-01";
    owner  = "golang";
    repo   = "sys";
    sha256 = "1asdbp7rj1j1m1aar1a022wpcwbml6zih6cpbxaw7b2m8v8is931";
    goPackagePath = "golang.org/x/sys";
    goPackageAliases = [
      "github.com/golang/sys"
    ];
  };

  text = buildFromGitHub {
    rev = "5eb8d4684c4796dd36c74f6452f2c0fa6c79597e";
    version = "2015-08-27";
    owner = "golang";
    repo = "text";
    sha256 = "1cjwm2pv42dbfqc6ylr7jmma902zg4gng5aarqrbjf1k2nf2vs14";
    goPackagePath = "golang.org/x/text";
    goPackageAliases = [ "github.com/golang/text" ];
  };

  tools = buildFromGitHub {
    rev = "c887be1b2ebd11663d4bf2fbca508c449172339e";
    version = "2016-02-04";
    owner = "golang";
    repo = "tools";
    sha256 = "15cm7wmab5na4hphvriazlz639882z0ipb466xmp7500rn6f5kzf";
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

    # Set GOTOOLDIR for derivations adding this to buildInputs
    postInstall = ''
      mkdir -p $bin/nix-support
      substituteAll ${../development/go-modules/tools/setup-hook.sh} $bin/nix-support/setup-hook.tmp
      cat $bin/nix-support/setup-hook.tmp >> $bin/nix-support/setup-hook
      rm $bin/nix-support/setup-hook.tmp
    '';
  };


  ## THIRD PARTY

  ace = buildFromGitHub {
    rev    = "899eede6af0d99400b2c8886d86fd8d351074d37";
    owner  = "yosssi";
    repo   = "ace";
    sha256 = "0xdzqfzaipyaa973j41yq9lbijw36kyaz523sw05kci4r5ivq4f5";
    buildInputs = [ gohtml ];
  };

  acme = buildFromGitHub {
    rev    = "v0.3.0";
    owner  = "xenolf";
    repo   = "lego";
    sha256 = "0hlnqdn793j4s43bhnmpi2lxgmjxs1ccg26alxnrcyw5x7p2vvdn";

    subPackages = [ "acme" ];
    propagatedBuildInputs = [ crypto dns go-jose-v1 net ];
  };

  adapted = buildFromGitHub {
    rev = "eaea06aaff855227a71b1c58b18bc6de822e3e77";
    version = "2015-06-03";
    owner = "michaelmacinnis";
    repo = "adapted";
    sha256 = "0f28sn5mj48087zhjdrph2sjcznff1i1lwnwplx32bc5ax8nx5xm";
    propagatedBuildInputs = [ sys ];
  };

  afero = buildFromGitHub {
    rev    = "90b5a9bd18a72dbf3e27160fc47acfaac6c08389";
    owner  = "spf13";
    repo   = "afero";
    sha256 = "1xqvbwny61j85psymcs8hggmqyyg4yq3q4cssnvnvbsl3aq8kn4k";
    propagatedBuildInputs = [ text ];
  };

  airbrake-go = buildFromGitHub {
    rev    = "5b5e269e1bc398d43f67e43dafff3414a59cd5a2";
    owner  = "tobi";
    repo   = "airbrake-go";
    sha256 = "1bps4y3vpphpj63mshjg2aplh579cvqac0hz7qzvac0d1fqcgkdz";
  };

  amber = buildFromGitHub {
    rev    = "144da19a9994994c069f0693294a66dd310e14a4";
    owner  = "eknkc";
    repo   = "amber";
    sha256 = "079wwdq4cn9i1vx5zik16z4bmghkc7zmmvbrp1q6y4cnpmq95rqk";
  };

  ansicolor = buildFromGitHub {
    rev    = "a5e2b567a4dd6cc74545b8a4f27c9d63b9e7735b";
    owner  = "shiena";
    repo   = "ansicolor";
    sha256 = "0gwplb1b4fvav1vjf4b2dypy5rcp2w41vrbxkd1dsmac870cy75p";
  };

  archiver = buildFromGitHub {
    rev = "85f054813ed511646b0ce5e047697e0651b8e1a4";
    owner = "mholt";
    repo = "archiver";
    sha256 = "0b38mrfm3rwgdi7hrp4gjhf0y0f6bw73qjkfrkafxjrdpdg7nyly";
  };

  asciinema = buildFromGitHub {
    rev = "v1.2.0";
    owner = "asciinema";
    repo = "asciinema";
    sha256 = "0wvrq92ackhfycfs1fircs8al3ji69igqqrc55ic29wbpnvz355x";
  };

  asmfmt = buildFromGitHub {
    rev = "7971758b0c6584f67d745c62d006814ae7b44e9d";
    owner = "klauspost";
    repo = "asmfmt";
    sha256 = "07i3f8jzs4yvfpm16s2c2hd65r3q729m0agg8q1i3lwbs3fimyj5";
    buildInputs = [ tools goreturns ];
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

  astrotime = buildFromGitHub {
    rev = "9c7d514efdb561775030eaf8f1a9ae6bddb3a2ca";
    owner = "cpucycle";
    repo = "astrotime";
    sha256 = "024sc7g55v4s54irssm5wsn74sr2k2ynsm6z16w47q66cxhgvby1";
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

  azure-sdk-for-go = buildFromGitHub {
    rev   = "v2.0.0-beta";
    owner = "Azure";
    repo  = "azure-sdk-for-go";
    sha256 = "04bixwh4bzgysa79azis1p755rb6zxjjzhpskpvpmvkv49baharc";
    propagatedBuildInputs = [ go-autorest cli-go ];
  };

  azure-vhd-tools-for-go = buildFromGitHub {
    rev    = "7db4795475aeab95590f8643969e06b633ead4ec";
    owner  = "Microsoft";
    repo   = "azure-vhd-utils-for-go";
    sha256 = "0xg6a1qw8jjxqhgvy9zlvq5b8xnnvfkjnkjz9f8g4y1kcw09lird";

    propagatedBuildInputs = [ azure-sdk-for-go ];
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

  bleve = buildFromGitHub {
    rev    = "fc34a97875840b2ae24517e7d746b69bdae9be90";
    version = "2016-01-19";
    owner  = "blevesearch";
    repo   = "bleve";
    sha256 = "0ny7nvilrxmmzcdvpivwyrjkynnhc22c5gdrxzs421jly35jw8jx";
    buildFlags = [ "-tags all" ];
    propagatedBuildInputs = [ protobuf goleveldb kagome gtreap bolt text
     rcrowley.go-metrics bitset segment go-porterstemmer ];
  };

  binarydist = buildFromGitHub {
    rev    = "9955b0ab8708602d411341e55fffd7e0700f86bd";
    owner  = "kr";
    repo   = "binarydist";
    sha256 = "11wncbbbrdcxl5ff3h6w8vqfg4bxsf8709mh6vda0cv236flkyn3";
  };

  bitset = buildFromGitHub {
    rev    = "bb0da3785c4fe9d26f6029c77c8fce2aa4d0b291";
    version = "2016-01-13";
    owner  = "willf";
    repo   = "bitset";
    sha256 = "1d4z2hjjs9jk6aysi4mf50p8lbbzag4ir4y1f0z4sz8gkwagh7b7";
  };

  blackfriday = buildFromGitHub {
    rev    = "d18b67ae0afd61dae240896eae1785f00709aa31";
    owner  = "russross";
    repo   = "blackfriday";
    sha256 = "1l78hz8k1ixry5fjw29834jz1q5ysjcpf6kx2ggjj1s6xh0bfzvf";
    propagatedBuildInputs = [ sanitized_anchor_name ];
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

  caddy = buildFromGitHub {
    rev     = "e2234497b79603388b58ba226abb157aa4aaf065";
    version = "v0.8.3";
    owner   = "mholt";
    repo    = "caddy";
    sha256  = "1snijkbz02yr7wij7bcmrj4257709sbklb3nhb5qmy95b9ssffm6";
    buildInputs = [
      acme archiver blackfriday crypto go-humanize go-shlex go-syslog
      http-authentication lumberjack-v2 toml websocket yaml-v2
    ];
    disabled = isGo14 || isGo15;
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

  cast = buildFromGitHub {
    rev    = "ee815aaf958c707ad07547cd62150d973710f747";
    owner  = "spf13";
    repo   = "cast";
    sha256 = "144xwvmjbrv59zjj1gnq5j9qpy62dgyfamxg5l3smdwfwa8vpf5i";
    buildInputs = [ jwalterweatherman ];
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

  cobra = buildFromGitHub {
    rev    = "ee6224d01f6a83f543ae90f881b703cf195782ba";
    owner  = "spf13";
    repo   = "cobra";
    sha256 = "0skmq1lmkh2xzl731a2sfcnl2xbcy9v1050pcf10dahwqzsbx6ij";
    propagatedBuildInputs = [ pflag-spf13 mousetrap go-md2man viper ];
  };

  cli-go = buildFromGitHub {
    rev    = "71f57d300dd6a780ac1856c005c4b518cfd498ec";
    owner  = "codegangsta";
    repo   = "cli";
    sha256 = "1fxznirkvank5461789dm5aw5z8aqi0jvwligvz44659rfl376p3";
    propagatedBuildInputs = [ yaml-v2 ];
  };

  columnize = buildFromGitHub {
    rev    = "44cb4788b2ec3c3d158dd3d1b50aba7d66f4b59a";
    owner  = "ryanuber";
    repo   = "columnize";
    sha256 = "1qrqr76cw58x2hkjic6h88na5ihgvkmp8mqapj8kmjcjzdxkzhr9";
  };

  command = buildFromGitHub {
    rev    = "91ca5ec5e9a1bc2668b1ccbe0967e04a349e3561";
    owner  = "odeke-em";
    repo   = "command";
    sha256 = "1ghckzr8h99ckagpmb15p61xazdjmf9mjmlym634hsr9vcj84v62";
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
    version = "2015-08-09";
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
    version = "2015-05-19";
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

  crypt = buildFromGitHub {
    rev    = "749e360c8f236773f28fc6d3ddfce4a470795227";
    owner  = "xordataexchange";
    repo   = "crypt";
    sha256 = "17g9122b8bmbdpshyzhl7cxsp0nvhk0rc6syc92djavggmbpl6ig";
    preBuild = ''
      substituteInPlace go/src/github.com/xordataexchange/crypt/backend/consul/consul.go \
        --replace 'github.com/armon/consul-api' 'github.com/hashicorp/consul/api' \
        --replace 'consulapi' 'api'
    '';
    propagatedBuildInputs = [ go-etcd consul-api crypto ];
  };

  cssmin = buildFromGitHub {
    rev    = "fb8d9b44afdc258bfff6052d3667521babcb2239";
    owner  = "dchest";
    repo   = "cssmin";
    sha256 = "09sdijfx5d05z4cd5k6lhl7k3kbpdf2amzlngv15h5v0fff9qw4s";
  };

  dbus-old-2015-05-19 = buildFromGitHub {
    rev    = "a5942dec6340eb0d57f43f2003c190ce06e43dea";
    version = "2015-05-19";
    owner  = "godbus";
    repo   = "dbus";
    sha256 = "1vk31wal7ncvjwvnb8q1myrkihv1np46f3q8dndi5k0csflbxxdf";
  };

  dbus = buildFromGitHub {
    rev    = "230e4b23db2fd81c53eaa0073f76659d4849ce51";
    version = "2016-03-02";
    owner  = "godbus";
    repo   = "dbus";
    sha256 = "1wxv2cbihzcsz2z7iycyzl7f3arhhgagcc5kqln1k1mkm4l85z0q";
  };

  deis = buildFromGitHub {
    rev = "v1.12.2";
    owner = "deis";
    repo = "deis";
    sha256 = "03lznzcij3gn08kqj2p6skifcdv5aw09dm6zxgvqw7nxx2n1j2ib";
    subPackages = [ "client" ];
    buildInputs = [ docopt-go crypto yaml-v2 ];
    postInstall = ''
      if [ -f "$bin/bin/client" ]; then
        mv "$bin/bin/client" "$bin/bin/deis"
      fi
    '';
  };

  dns = buildFromGitHub {
    rev     = "7e024ce8ce18b21b475ac6baf8fa3c42536bf2fa";
    version = "2016-03-28";
    owner   = "miekg";
    repo    = "dns";
    sha256  = "0hlwb52lnnj3c6papjk9i5w5cjdw6r7c891v4xksnfvk1f9cy9kl";
  };

  docopt-go = buildFromGitHub {
    rev    = "854c423c810880e30b9fecdabb12d54f4a92f9bb";
    owner  = "docopt";
    repo   = "docopt-go";
    sha256 = "1sddkxgl1pwlipfvmv14h8vg9b9wq1km427j1gjarhb5yfqhh3l1";
  };

  docker.docker = buildFromGitHub {
    rev = "cb87b6eb6a955e5a66b17e0a15557f37f76b85c0";
    version = "2016-04-14";
    owner = "docker";
    repo = "docker";
    sha256 = "1hkah4scs8a589jhp82kw5wcx21nhq41asfq8icwy6bzdz1bq0j0";
    buildInputs = [ docker.go-units ];
    subPackages = [ "pkg/term" "pkg/symlink" "pkg/system" "pkg/mount" ];
  };

  docker.go-units = buildFromGitHub {
    rev = "5d2041e26a699eaca682e2ea41c8f891e1060444";
    version = "2016-01-25";
    owner = "docker";
    repo = "go-units";
    sha256 = "0hn8xdbaykp046inc4d2mwig5ir89ighma8hk18dfkm8rh1vvr8i";
  };

  drive = buildFromGitHub {
    rev = "6dc2f1e83032ea3911fa6147b846ee93f18dc544";
    owner = "odeke-em";
    repo = "drive";
    sha256 = "07s4nhfcr6vznf1amvl3a4wq2hn9zq871rcppfi4i6zs7iw2ay1v";
    subPackages = [ "cmd/drive" ];
    buildInputs = [
      pb go-isatty command dts odeke-em.log statos xon odeke-em.google-api-go-client
      cli-spinner oauth2 text net pretty-words meddler open-golang extractor
      exponential-backoff cache bolt
    ];
    disabled = !isGo14;
  };

  cache = buildFromGitHub {
    rev = "b51b08cb6cf889deda6c941a5205baecfd16f3eb";
    owner = "odeke-em";
    repo = "cache";
    sha256 = "1rmm1ky7irqypqjkk6qcd2n0xkzpaggdxql9dp9i9qci5rvvwwd4";
  };

  exercism = buildFromGitHub {
    rev = "v2.2.1";
    name = "exercism";
    owner = "exercism";
    repo = "cli";
    sha256 = "13kwcxd7m3xv42j50nlm9dd08865dxji41glfvnb4wwq9yicyn4g";
    buildInputs = [ net cli-go osext ];
  };

  exponential-backoff = buildFromGitHub {
    rev = "96e25d36ae36ad09ac02cbfe653b44c4043a8e09";
    owner = "odeke-em";
    repo = "exponential-backoff";
    sha256 = "1as21p2jj8xpahvdxqwsw2i1s3fll14dlc9j192iq7xl1ybwpqs6";
  };

  extractor = buildFromGitHub {
    rev = "801861aedb854c7ac5e1329e9713023e9dc2b4d4";
    owner = "odeke-em";
    repo = "extractor";
    sha256 = "036zmnqxy48h6mxiwywgxix2p4fqvl4svlmcp734ri2rbq3cmxs1";
  };

  open-golang = buildFromGitHub {
    rev = "c8748311a7528d0ba7330d302adbc5a677ef9c9e";
    owner = "skratchdot";
    repo = "open-golang";
    sha256 = "0qhn2d00v3m9fiqk9z7swdm599clc6j7rnli983s8s1byyp0x3ac";
  };

  pretty-words = buildFromGitHub {
    rev = "9d37a7fcb4ae6f94b288d371938482994458cecb";
    owner = "odeke-em";
    repo = "pretty-words";
    sha256 = "1466wjhrg9lhqmzil1vf8qj16fxk32b5kxlcccyw2x6dybqa6pkl";
  };

  meddler = buildFromGitHub {
    rev = "d2b51d2b40e786ab5f810d85e65b96404cf33570";
    owner = "odeke-em";
    repo = "meddler";
    sha256 = "0m0fqrn3kxy4swyk4ja1y42dn1i35rq9j85y11wb222qppy2342x";
  };

  dts = buildFromGitHub {
    rev    = "ec2daabf2f9078e887405f7bcddb3d79cb65502d";
    owner  = "odeke-em";
    repo   = "dts";
    sha256 = "0vq3cz4ab9vdsz9s0jjlp7z27w218jjabjzsh607ps4i8m5d441s";
  };

  du = buildFromGitHub {
    rev    = "3c0690cca16228b97741327b1b6781397afbdb24";
    version = "2015-08-05";
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

  errcheck = buildFromGitHub {
    rev = "f76568f8d87e48ccbbd17a827c2eaf31805bf58c";
    owner = "kisielk";
    repo = "errcheck";
    sha256 = "1y1cqd0ibgr03zf96q6aagk65yhv6vcnq9xa8nqhjpnz7jhfndhs";
    postPatch = ''
      for f in $(find -name "*.go"); do
        substituteInPlace $f \
          --replace '"go/types"' '"golang.org/x/tools/go/types"'
      done
    '';
    excludedPackages = [ "testdata" ];
    buildInputs = [ gotool tools ];
  };

  errwrap = buildFromGitHub {
    rev    = "7554cd9344cec97297fa6649b055a8c98c2a1e55";
    owner  = "hashicorp";
    repo   = "errwrap";
    sha256 = "0kmv0p605di6jc8i1778qzass18m0mv9ks9vxxrfsiwcp4la82jf";
  };

  etcd = buildFromGitHub {
    rev    = "v2.3.0";
    owner  = "coreos";
    repo   = "etcd";
    sha256 = "1cchlhsdbbqal145cvdiq7rzqqi131iq7z0r2hmzwx414k04wyn7";
    buildInputs = [ pkgs.libpcap tablewriter ];
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

  fsync = buildFromGitHub {
    rev    = "c2544e79b93fda5653255f907a30fba1c2ac2638";
    owner  = "spf13";
    repo   = "fsync";
    sha256 = "0hzfk2f8pm756j10zgsk8b8gbfylcf8h6q4djz0ka9zpg76s26lz";
    buildInputs = [ afero ];
  };

  fzf = buildFromGitHub {
    rev = "0.12.0";
    owner = "junegunn";
    repo = "fzf";
    sha256 = "0lxh8nf5xc5qnmx18h0q43iy3hy818firkz4rfkr3b0b5gd3aan1";

    buildInputs = [
      crypto ginkgo gomega junegunn.go-runewidth go-shellwords pkgs.ncurses text
    ];

    postInstall= ''
      cp $src/bin/fzf-tmux $bin/bin
    '';
  };

  g2s = buildFromGitHub {
    rev    = "ec76db4c1ac16400ac0e17ca9c4840e1d23da5dc";
    owner  = "peterbourgon";
    repo   = "g2s";
    sha256 = "1p4p8755v2nrn54rik7yifpg9szyg44y5rpp0kryx4ycl72307rj";
  };

  gawp = buildFromGitHub {
    rev    = "488705639109de54d38974cc31353d34cc2cd609";
    version = "2015-08-31";
    owner  = "martingallagher";
    repo   = "gawp";
    sha256 = "0iqqd63nqdijdskdb9f0jwnm6akkh1p2jw4p2w7r1dbaqz1znyay";
    dontInstallSrc = true;
    buildInputs = [ fsnotify.v1 yaml-v2 ];

    meta = with stdenv.lib; {
      homepage    = "https://github.com/martingallagher/gawp";
      description = "A simple, configurable, file watching, job execution tool implemented in Go";
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

  gojsonpointer = buildFromGitHub {
    rev = "e0fe6f68307607d540ed8eac07a342c33fa1b54a";
    version = "2015-11-27";
    owner = "xeipuuv";
    repo = "gojsonpointer";
    sha256 = "0yfbisaas3w3ygh0cvb82mj6c1f8adqmnwmyid8l5p12r55531f8";
  };

  gojsonreference = buildFromGitHub {
    rev = "e02fc20de94c78484cd5ffb007f8af96be030a45";
    version = "2015-08-08";
    owner = "xeipuuv";
    repo = "gojsonreference";
    sha256 = "195in5zr3bhb3r1iins2h610kz339naj284b3839xmrhc15wqxzq";
    propagatedBuildInputs = [ gojsonpointer ];
  };

  gojsonschema = buildFromGitHub {
    rev = "93e72a773fade158921402d6a24c819b48aba29d";
    version = "2016-03-23";
    owner = "xeipuuv";
    repo = "gojsonschema";
    sha256 = "0hqpcy4xgm9xw16dxbs1skrh6ga60bwfjv5dyz5zh86xsxpln3nr";
    propagatedBuildInputs = [ gojsonreference ];
  };

  gosexy.gettext = buildFromGitHub {
    rev    = "4a979356fe964fec12e18326a32a89661f93dea7";
    version = "2016-02-20";
    owner  = "gosexy";
    repo   = "gettext";
    sha256 = "07f3dmq4qsdykbn3fkha3v1w61hic6xw82dvdmvzhf0m41jxsgy6";
    buildInputs = [ pkgs.gettext go-flags ];
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

  git-annex-remote-b2 = buildFromGitHub {
    buildInputs = [ go go-backblaze ];
    owner = "encryptio";
    repo = "git-annex-remote-b2";
    rev = "v0.2";
    sha256 = "1139rzdvlj3hanqsccfinprvrzf4qjc5n4f0r21jp9j24yhjs6j2";
  };

  git-appraise = buildFromGitHub {
    rev = "v0.3";
    owner = "google";
    repo = "git-appraise";
    sha256 = "124hci9whsvlcywsfz5y20kkj3nhy176a1d5s1lkvsga09yxq6wm";
  };

  git-lfs = buildFromGitHub {
    version = "1.1.1";
    rev = "v1.1.1";
    owner = "github";
    repo = "git-lfs";
    sha256 = "1m7kii57jrsb22m5x9v8xa3s1qmipfkpk6cscgxrbrj7g0a75fnc";

    # Tests fail with 'lfstest-gitserver.go:46: main redeclared in this block'
    excludedPackages = [ "test" ];

    preBuild = ''
      pushd go/src/github.com/github/git-lfs
        go generate ./commands
      popd
    '';

    postInstall = ''
      rm -v $bin/bin/{man,script}
    '';
  };

  glide = buildFromGitHub {
    rev    = "0.6.1";
    owner  = "Masterminds";
    repo   = "glide";
    sha256 = "1v66c2igm8lmljqrrsyq3cl416162yc5l597582bqsnhshj2kk4m";
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

  gocapability = buildFromGitHub {
    rev    = "2c00daeb6c3b45114c80ac44119e7b8801fdd852";
    version = "2015-07-16";
    owner  = "syndtr";
    repo   = "gocapability";
    sha256 = "1x7jdcg2r5pakjf20q7bdiidfmv7vcjiyg682186rkp2wz0yws0l";
  };

  gocryptfs = buildFromGitHub {
    rev = "v0.5";
    owner = "rfjakob";
    repo = "gocryptfs";
    sha256 = "0jsdz8y7a1fkyrfwg6353c9r959qbqnmf2cjh57hp26w1za5bymd";
    buildInputs = [ crypto go-fuse openssl-spacemonkey ];
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
    version = "2015-09-03";
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

  gohtml = buildFromGitHub {
    rev    = "ccf383eafddde21dfe37c6191343813822b30e6b";
    owner  = "yosssi";
    repo   = "gohtml";
    sha256 = "1cghwgnx0zjdrqxzxw71riwiggd2rjs2i9p2ljhh76q3q3fd4s9f";
    propagatedBuildInputs = [ net ];
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

  gotool = buildFromGitHub {
    rev = "58a7a198f2ec6ea7af221fd216e7f559d663ce02";
    owner = "kisielk";
    repo = "gotool";
    sha256  = "1l1w4mczqmah0c154vb1daw5l3cc7vn5gmy5s67p3ad1lnz5l79x";
  };

  gotty = buildFromGitHub {
    rev     = "v0.0.10";
    owner   = "yudai";
    repo    = "gotty";
    sha256  = "0gvnbr61d5si06ik2j075jg00r9b94ryfgg06nqxkf10dp8lgi09";

    buildInputs = [ cli-go go manners go-bindata-assetfs go-multierror structs websocket hcl pty ];

    meta = with stdenv.lib; {
      description = "Share your terminal as a web application";
      homepage = "https://github.com/yudai/gotty";
      maintainers = with maintainers; [ matthiasbeyer ];
      license = licenses.mit;
    };
  };

  govers = buildFromGitHub {
    rev = "3b5f175f65d601d06f48d78fcbdb0add633565b9";
    version = "2015-01-09";
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
    version = "2015-04-06";
    owner  = "matttproud";
    repo   = "golang_protobuf_extensions";
    sha256 = "0ajg41h6402big484drvm72wvid1af2sffw0qkzbmpy04lq68ahj";
    buildInputs = [ protobuf ];
  };

  goleveldb = buildFromGitHub {
    rev = "1a9d62f03ea92815b46fcaab357cfd4df264b1a0";
    version = "2015-08-19";
    owner = "syndtr";
    repo = "goleveldb";
    sha256 = "04ywbif36fiah4fw0x2abr5q3p4fdhi6q57d5icc2mz03q889vhb";
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

  gometalinter = buildFromGitHub {
    rev = "be87b7414dc44dbea2fee33ccb8bd8a859ebcaf1";
    owner = "alecthomas";
    repo = "gometalinter";
    sha256 = "05n852kf11gq5k7b4h6kz85z99qfa46dy6b6fqkg9xfk2bmvdxms";
    buildInputs = [ shlex kingpin testify ];
  };

  google-api-go-client = buildFromGitHub {
    rev = "a5c3e2a4792aff40e59840d9ecdff0542a202a80";
    version = "2015-08-19";
    owner = "google";
    repo = "google-api-go-client";
    sha256 = "1kigddnbyrl9ddpj5rs8njvf1ck54ipi4q1282k0d6b3am5qfbj8";
    goPackagePath = "google.golang.org/api";
    goPackageAliases = [ "github.com/google/google-api-client" ];
    buildInputs = [ net ];
  };

  goreturns = buildFromGitHub {
    rev = "b368f1f77f2950c753e05a6a29acfc487fa7a959";
    owner = "sqs";
    repo = "goreturns";
    sha256 = "0qllmcvg3xd43pymn24zrjn7vb39zj83ayq3sg7kzgxvba0ylb05";
    goPackagePath = "sourcegraph.com/sqs/goreturns";
    buildInputs = [ tools ];
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
    version = "2015-07-26";
    owner  = "elazarl";
    repo   = "goproxy";
    sha256 = "1zz425y8byjaa9i7mslc9anz9w2jc093fjl0562rmm5hh4rc5x5f";
    buildInputs = [ go-charset ];
  };

  goreq = buildFromGitHub {
    rev    = "72c51a544272e007ab3da4f7d9ac959b7af7af03";
    version = "2015-08-18";
    owner  = "franela";
    repo   = "goreq";
    sha256 = "0dnqbijdzp2dgsf6m934nadixqbv73q0zkqglaa956zzw0pyhcxp";
  };

  gotags = buildFromGitHub {
    rev    = "be986a34e20634775ac73e11a5b55916085c48e7";
    version = "2015-08-03";
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

  gosu = buildFromGitHub {
    rev = "1.7";
    owner = "tianon";
    repo = "gosu";
    sha256 = "02vln88yyhj8k8cyzac0sgw84626vshmzdrrc1jpl4k4sc27vcbp";
    buildInputs = [ opencontainers.runc ];
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

  gozim = buildFromGitHub {
    rev    = "ea9b7c39cb1d13bd8bf19ba4dc4e2a16bab52f14";
    version = "2016-01-15";
    owner  = "akhenakh";
    repo   = "gozim";
    sha256 = "1n50fdd56r3s1sgjbpa72nvdh50gfpf6fq55c077w2p3bxn6p8k6";
    propagatedBuildInputs = [ bleve go-liblzma groupcache go-rice goquery ];
    buildInputs = [ pkgs.zip ];
    postInstall = ''
      pushd $NIX_BUILD_TOP/go/src/$goPackagePath/cmd/gozimhttpd
      ${go-rice.bin}/bin/rice append --exec $bin/bin/gozimhttpd
      popd
    '';
    dontStrip = true;
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

  go-autorest = buildFromGitHub {
    rev = "v6.0.0";
    owner = "Azure";
    repo = "go-autorest";
    sha256 = "07zrbw8p3jc5xfjwn0qj1hrn1r7nbnryc5zmvk42qgximyxsls26";
    propagatedBuildInputs = [ jwt-go crypto ];
  };

  go-backblaze = buildFromGitHub {
    buildInputs = [ go-flags go-humanize uilive uiprogress ];
    goPackagePath = "gopkg.in/kothar/go-backblaze.v0";
    rev = "373819725fc560fa962c6cd883b533d2ebec4844";
    owner = "kothar";
    repo = "go-backblaze";
    sha256 = "1kmlwfnnfd4h46bb9pz2gw1hxqm1pzkwvidfmnc0zkrilaywk6fx";
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
    rev = "a0ff2567cfb70903282db057e799fd826784d41d";
    date = "2015-10-23";
    version = "${date}-${stdenv.lib.strings.substring 0 7 rev}";
    name = "go-bindata-${version}";
    goPackagePath = "github.com/jteeuwen/go-bindata";
    src = fetchFromGitHub {
      inherit rev;
      repo = "go-bindata";
      owner = "jteeuwen";
      sha256 = "0d6zxv0hgh938rf59p1k5lj0ymrb8kcps2vfrb9kaarxsvg7y69v";
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

  go-bindata-assetfs = buildFromGitHub {
    rev     = "d5cac425555ca5cf00694df246e04f05e6a55150";
    owner   = "elazarl";
    repo    = "go-bindata-assetfs";
    sha256  = "636ce247ff6f85c14f38a421f46662fa77bdc29762692e1f72b3cd1f9d7a1d17";
    version = "2015-08-13";

    meta = with stdenv.lib; {
      description = "Serves embedded files from jteeuwen/go-bindata with net/http";
      homepage = "https://github.com/elazarl/go-bindata-assetfs";
      maintainers = with maintainers; [ matthiasbeyer ];
      license = licenses.bsd2;
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
    version = "2014-07-13";
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
    version = "2015-07-27";
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

  go-gtk-agl = buildFromGitHub {
    rev = "6937b8d28cf70d583346220b966074cfd3a2e233";
    owner = "agl";
    repo = "go-gtk";
    sha256 = "0jnhsv7ypyhprpy0fndah22v2pbbavr3db6f9wxl1vf34qkns3p4";
    # Examples require many go libs, and gtksourceview seems ready only for
    # gtk2
    preConfigure = ''
      rm -R example gtksourceview
    '';
    nativeBuildInputs = [ pkgs.pkgconfig ];
    propagatedBuildInputs = [ pkgs.gtk3 ];
    buildInputs = [ pkgs.gtkspell3 ];
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
    version = "2015-03-31";
    owner  = "bitly";
    repo   = "go-hostpool";
    sha256 = "14ph12krn5zlg00vh9g6g08lkfjxnpw46nzadrfb718yl1hgyk3g";
  };

  go-humanize = buildFromGitHub {
    rev = "8929fe90cee4b2cb9deb468b51fb34eba64d1bf0";
    owner = "dustin";
    repo = "go-humanize";
    sha256 = "1g155kxjh6hd3ibx41nbpj6f7h5bh54zgl9dr53xzg2xlxljgjy0";
  };

  go-ini = buildFromGitHub {
    rev    = "a98ad7ee00ec53921f08832bc06ecf7fd600e6a1";
    owner  = "vaughan0";
    repo   = "go-ini";
    sha256 = "1l1isi3czis009d9k5awsj4xdxgbxn4n9yqjc1ac7f724x6jacfa";
  };

  go-incremental = buildFromGitHub {
    rev    = "92fd0ce4a694213e8b3dfd2d39b16e51d26d0fbf";
    version = "2015-02-20";
    owner  = "GeertJohan";
    repo   = "go.incremental";
    sha256 = "160cspmq73bk6cvisa6kq1dwrrp1yqpkrpq8dl69wcnaf91cbnml";
  };

  go-isatty = buildFromGitHub {
    rev    = "ae0b1f8f8004be68d791a576e3d8e7648ab41449";
    owner  = "mattn";
    repo   = "go-isatty";
    sha256 = "0qrcsh7j9mxcaspw8lfxh9hhflz55vj4aq1xy00v78301czq6jlj";
  };

  go-jose-v1 = buildFromGitHub {
    rev    = "v1.0.1";
    owner  = "square";
    repo   = "go-jose";
    sha256 = "0asa1kl1qbx0cyayk44jhxxff0awpkwiw6va7yzrzjzhfc5kvg7p";
    propagatedBuildInputs = [ cli-go ];
    goPackagePath = "gopkg.in/square/go-jose.v1";
    goPackageAliases = [ "github.com/square/go-jose" ];
  };

  go-liblzma = buildFromGitHub {
    rev    = "e74be71c3c60411922b5424e875d7692ea638b78";
    version = "2016-01-01";
    owner  = "remyoudompheng";
    repo   = "go-liblzma";
    sha256 = "12lwjmdcv2l98097rhvjvd2yz8jl741hxcg29i1c18grwmwxa7nf";
    propagatedBuildInputs = [ pkgs.lzma ];
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
    rev    = "d89df0ad9dc13a7ce491eedaa771b076cf32db16";
    version = "2016-02-12";
    owner  = "lxc";
    repo   = "go-lxc";
    sha256 = "051kqvvclfcinqcbi4zch694llvnxa5vvbw6cbdxbkzhr5zxm36q";
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
    version = "2015-08-22";
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

  go-md2man = buildFromGitHub {
    rev    = "71acacd42f85e5e82f70a55327789582a5200a90";
    owner  = "cpuguy83";
    repo   = "go-md2man";
    sha256 = "0hmkrq4gdzb6mwllmh4p1y7vrz7hyr8xqagpk9nyr5dhygvnnq2v";
    propagatedBuildInputs = [ blackfriday ];
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
    version = "2014-12-20";
    owner  = "mreiferson";
    repo   = "go-options";
    sha256 = "0ksyi2cb4k6r2fxamljg42qbz5hdcb9kv5i7y6cx4ajjy0xznwgm";
  };

  go-porterstemmer = buildFromGitHub {
    rev    = "23a2c8e5cf1f380f27722c6d2ae8896431dc7d0e";
    version = "2014-12-30";
    owner  = "blevesearch";
    repo   = "go-porterstemmer";
    sha256 = "0rcfbrad79xd114h3dhy5d3zs3b5bcgqwm3h5ih1lk69zr9wi91d";
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

  jp = buildFromGitHub {
    rev = "0.1.2";
    owner = "jmespath";
    repo = "jp";
    sha256 = "1i0jl0c062crigkxqx8zpyqliz8j4d37y95cna33jl777kx42r6h";
    meta = with stdenv.lib; {
      description = "A command line to JMESPath, an expression language for manipulating JSON";
      license = licenses.asl20;
      homepage = http://jmespath.org;
      maintainers = with maintainers; [ cransom ];
      platforms = platforms.unix;
    };
  };

  mattn.go-runewidth = buildFromGitHub {
    rev    = "d6bea18f789704b5f83375793155289da36a3c7f";
    version = "2016-03-15";
    owner  = "mattn";
    repo   = "go-runewidth";
    sha256 = "1hnigpn7rjbwd1ircxkyx9hvi0xmxr32b2jdy2jzw6b3jmcnz1fs";
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
    version = "2014-09-11";
    owner = "cstrahan";
    repo = "go-repo-root";
    sha256 = "1rlzp8kjv0a3dnfhyqcggny0ad648j5csr2x0siq5prahlp48mg4";
    buildInputs = [ tools ];
  };

  go-rice = buildFromGitHub {
    rev    = "4f3c5af2322e393f305d9674845bc36cd1dea589";
    version = "2016-01-04";
    owner  = "GeertJohan";
    repo   = "go.rice";
    sha256 = "01q2d5iwibwdl68gn8sg6dm7byc42hax3zmiqgmdw63ir1fsv4ag";
    propagatedBuildInputs = [ osext go-spew go-flags go-zipexe rsrc
      go-incremental ];
  };

  go-runit = buildFromGitHub {
    rev    = "a9148323a615e2e1c93b7a9893914a360b4945c8";
    owner  = "soundcloud";
    repo   = "go-runit";
    sha256 = "00f2rfhsaqj2wjanh5qp73phx7x12a5pwd7lc0rjfv68l6sgpg2v";
  };

  go-sct = buildFromGitHub {
    rev = "b82c2f81727357c45a47a43965c50ed5da5a2e74";
    version = "2016-01-11";
    owner = "d4l3k";
    repo = "go-sct";
    sha256 = "13hgmpv2c8ll5ap8fn1n480bdv1j21n86jjwcssd36kh2i933anl";
    buildInputs = [ astrotime pkgs.xorg.libX11 pkgs.xorg.libXrandr ];
    meta = with stdenv.lib; {
      description = "Color temperature setting library and CLI that operates in a similar way to f.lux and Redshift";
      license = licenses.mit;
      maintainers = with maintainers; [ cstrahan ];
      platforms = platforms.unix;
    };
  };

  go-shlex = buildFromGitHub {
    rev    = "3f9db97f856818214da2e1057f8ad84803971cff";
    owner  = "flynn";
    repo   = "go-shlex";
    sha256 = "2a6a6f8eb150260cd60881ec5f027b7d1d2946ee22c627b450773eaf3d1de4c8";
  };

  go-simplejson = buildFromGitHub {
    rev    = "18db6e68d8fd9cbf2e8ebe4c81a78b96fd9bf05a";
    version = "2015-03-31";
    owner  = "bitly";
    repo   = "go-simplejson";
    sha256 = "0lj9cxyncchlw6p35j0yym5q5waiz0giw6ri41qdwm8y3dghwwiy";
  };

  go-snappystream = buildFromGitHub {
    rev = "028eae7ab5c4c9e2d1cb4c4ca1e53259bbe7e504";
    version = "2015-04-16";
    owner = "mreiferson";
    repo = "go-snappystream";
    sha256 = "0jdd5whp74nvg35d9hzydsi3shnb1vrnd7shi9qz4wxap7gcrid6";
  };

  go-spew = buildFromGitHub {
    rev    = "5215b55f46b2b919f50a1df0eaa5886afe4e3b3d";
    version = "2015-11-05";
    owner  = "davecgh";
    repo   = "go-spew";
    sha256 = "15h9kl73rdbzlfmsdxp13jja5gs7sknvqkpq2qizq3qv3nr1x8dk";
  };

  go-sqlite3 = buildFromGitHub {
    rev    = "b4142c444a8941d0d92b0b7103a24df9cd815e42";
    version = "2015-07-29";
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

  go-systemd = buildFromGitHub {
    rev    = "7b2428fec40033549c68f54e26e89e7ca9a9ce31";
    version = "2016-03-10";
    owner  = "coreos";
    repo   = "go-systemd";
    sha256 = "0kfbxvm9zsjgvgmiq2jl807y4s5z0rya65rm399llr5rr7vz1lxd";
    nativeBuildInputs = [ pkgs.pkgconfig pkgs.systemd ];
    propagatedBuildInputs = [ dbus ];
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
    version = "2015-07-22";
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

  go-zipexe = buildFromGitHub {
    rev    = "a5fe2436ffcb3236e175e5149162b41cd28bd27d";
    version = "2015-03-29";
    owner  = "daaku";
    repo   = "go.zipexe";
    sha256 = "0vi5pskhifb6zw78w2j97qbhs09zmrlk4b48mybgk5b3sswp6510";
  };

  go-zookeeper = buildFromGitHub {
    rev    = "5bb5cfc093ad18a28148c578f8632cfdb4d802e4";
    version = "2015-06-02";
    owner  = "samuel";
    repo   = "go-zookeeper";
    sha256 = "1kpx1ymh7rds0b2km291idnyqi0zck74nd8hnk72crgz7wmpqv6z";
  };

  lint = buildFromGitHub {
    rev = "7b7f4364ff76043e6c3610281525fabc0d90f0e4";
    version = "2015-06-23";
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

  groupcache = buildFromGitHub {
    rev    = "604ed5785183e59ae2789449d89e73f3a2a77987";
    owner  = "golang";
    repo   = "groupcache";
    sha256 = "1jh862mmgss71wls4yxv633agr7dk7y6h36npwqxbmhbz5c2q28l";
    buildInputs = [ protobuf ];
  };

  grpc = buildFromGitHub {
    rev = "d455e65570c07e6ee7f23275063fbf34660ea616";
    version = "2015-08-29";
    owner = "grpc";
    repo = "grpc-go";
    sha256 = "08vra95hc8ihnj353680zhiqrv3ssw5yywkrifzb1zwl0l3cs2hr";
    goPackagePath = "google.golang.org/grpc";
    goPackageAliases = [ "github.com/grpc/grpc-go" ];
    propagatedBuildInputs = [ http2 net protobuf oauth2 glog etcd ];
    excludedPackages = "\\(test\\|benchmark\\)";
  };

  gtreap = buildFromGitHub {
    rev = "0abe01ef9be25c4aedc174758ec2d917314d6d70";
    version = "2015-08-07";
    owner = "steveyen";
    repo = "gtreap";
    sha256 = "03z5j8myrpmd0jk834l318xnyfm0n4rg15yq0d35y7j1aqx26gvk";
    goPackagePath = "github.com/steveyen/gtreap";
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

  hmacauth = buildGoPackage {
    name = "hmacauth";
    goPackagePath = "github.com/18F/hmacauth";
    src = fetchFromGitHub {
      rev = "9232a6386b737d7d1e5c1c6e817aa48d5d8ee7cd";
      owner = "18F";
      repo = "hmacauth";
      sha256 = "056mcqrf2bv0g9gn2ixv19srk613h4sasl99w9375mpvmadb3pz1";
    };
  };

  hound = buildGoPackage rec {
    rev  = "0a364935ba9db53e6f3f5563b02fcce242e0930f";
    name = "hound-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/etsy/hound";

    src = fetchFromGitHub {
      inherit rev;
      owner  = "etsy";
      repo   = "hound";
      sha256 = "0jhnjskpm15nfa1cvx0h214lx72zjvnkjwrbgwgqqyn9afrihc7q";
    };
    buildInputs = [ go-bindata.bin pkgs.nodejs pkgs.nodePackages.react-tools pkgs.python pkgs.rsync ];
    postInstall = ''
      pushd go
      python src/github.com/etsy/hound/tools/setup
      sed -i 's|bin/go-bindata||' Makefile
      sed -i 's|$<|#go-bindata|' Makefile
      make
    '';
  };

  hologram = buildGoPackage rec {
    rev  = "8d86e3fdcbfd967ba58d8de02f5e8173c101212e";
    name = "hologram-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/AdRoll/hologram";

    src = fetchFromGitHub {
      inherit rev;
      owner  = "AdRoll";
      repo   = "hologram";
      sha256 = "0i0p170brdsczfz079mqbc5y7x7mdph04p3wgqsd7xcrddvlkkaf";
    };
    buildInputs = [ crypto protobuf goamz rgbterm go-bindata go-homedir ldap g2s gox gopass ];
  };

  http-authentication = buildFromGitHub {
    rev    = "3eca13d6893afd7ecabe15f4445f5d2872a1b012";
    owner  = "jimstudt";
    repo   = "http-authentication";
    sha256 = "08601600811a172d7f806b541f05691e4bef812ed8a68f7de65fde9ee11a3cb7";
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
    version = "2015-07-08";
    owner  = "julienschmidt";
    repo   = "httprouter";
    sha256 = "00rrjysmq898qcrf2hfwfh9s70vwvmjx2kp5w03nz1krxa4zhrkl";
  };

  hugo = buildFromGitHub {
    rev    = "v0.15";
    owner  = "spf13";
    repo   = "hugo";
    sha256 = "1v0z9ar5kakhib3c3c43ddwd1ga4b8icirg6kk3cnaqfckd638l5";
    buildInputs = [
      mapstructure text websocket cobra osext fsnotify.v1 afero
      jwalterweatherman cast viper yaml-v2 ace purell mmark blackfriday amber
      cssmin nitro inflect fsync
    ];
  };

  i3cat = buildFromGitHub {
    rev    = "b9ba886a7c769994ccd8d4627978ef4b51fcf576";
    version = "2015-03-21";
    owner  = "vincent-petithory";
    repo   = "i3cat";
    sha256 = "1xlm5c9ajdb71985nq7hcsaraq2z06przbl6r4ykvzi8w2lwgv72";
    buildInputs = [ structfield ];
  };

  inf = buildFromGitHub {
    rev    = "c85f1217d51339c0fa3a498cc8b2075de695dae6";
    owner  = "go-inf";
    repo   = "inf";
    sha256 = "1ykdk410vca8i35db2fp6qqcfx0bmx95k0xqd15wzsl0xjmyjk3y";
    goPackagePath = "gopkg.in/inf.v0";
    goPackageAliases = [ "github.com/go-inf/inf" ];
  };

  inflect = buildGoPackage {
    name = "inflect-2013-08-29";
    goPackagePath = "bitbucket.org/pkg/inflect";
    src = fetchFromBitbucket {
      rev    = "8961c3750a47b8c0b3e118d52513b97adf85a7e8";
      owner  = "pkg";
      repo   = "inflect";
      sha256 = "11qdyr5gdszy24ai1bh7sf0cgrb4q7g7fsd11kbpgj5hjiigxb9a";
    };
  };

  influxdb8-client = buildFromGitHub{
    rev = "v0.8.8";
    owner = "influxdb";
    repo = "influxdb";
    sha256 = "0xpigp76rlsxqj93apjzkbi98ha5g4678j584l6hg57p711gqsdv";
    subPackages = [ "client" ];
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
    rev = "7070b4d878baad57dcc8da80080dd293aa46cabd";
    version = "2016-01-12";
    owner  = "ipfs";
    repo   = "go-ipfs";
    sha256 = "1b7aimnbz287fy7p27v3qdxnz514r5142v3jihqxanbk9g384gcd";
    disabled = isGo14;
    meta = with stdenv.lib; {
      description = "A global, versioned, peer-to-peer filesystem";
      license = licenses.mit;
    };
  };

  json2csv = buildFromGitHub{
    rev = "d82e60e6dc2a7d3bcf15314d1ecbebeffaacf0c6";
    owner  = "jehiah";
    repo   = "json2csv";
    sha256 = "1fw0qqaz2wj9d4rj2jkfj7rb25ra106p4znfib69p4d3qibfjcsn";
  };

  jwalterweatherman = buildFromGitHub {
    rev    = "c2aa07df593850a04644d77bb757d002e517a296";
    owner  = "spf13";
    repo   = "jwalterweatherman";
    sha256 = "0m8867afsvka5gp2idrmlarpjg7kxx7qacpwrz1wl8y3zxyn3945";
  };

  jwt-go  = buildFromGitHub {
    rev = "v2.4.0";
    owner = "dgrijalva";
    repo = "jwt-go";
    sha256 = "00rvv1d2f62svd6311dkr8j56ysx8wgk9yfkb9vqf2mp5ix37dc0";
  };

  kagome = buildFromGitHub {
    rev = "1bbdbdd590e13a8c2f4508c67a079113cd7b9f51";
    version = "2016-01-19";
    owner = "ikawaha";
    repo = "kagome";
    sha256 = "1isnjdkn9hnrkp5g37p2k5bbsrx0ma32v3icwlmwwyc5mppa4blb";

    # I disable the parallel building, because otherwise each
    # spawned compile takes over 1.5GB of RAM.
    buildFlags = "-p 1";
    enableParallelBuilding = false;

    goPackagePath = "github.com/ikawaha/kagome";
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
    rev    = "ad1edfd30321d8f006ccf05f1e0524adeb943060";
    owner  = "peterh";
    repo   = "liner";
    sha256 = "0c24d9j1gnq7r982h1l2isp3d37379qw155hr8ihx9i2mhpfz317";
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
    version = "2015-05-23";
    owner = "calmh";
    repo = "logger";
    sha256 = "1f67xbvvf210g5cqa84l12s00ynfbkjinhl8y6m88yrdb025v1vg";
  };

  logrus = buildFromGitHub rec {
    rev = "v0.9.0";
    owner = "Sirupsen";
    repo = "logrus";
    sha256 = "1m6vvd4pg4lwglhk54lv5mf6cc8h7bi0d9zb3gar4crz531r66y4";
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
    version = "2015-01-13";
    owner  = "calmh";
    repo   = "luhn";
    sha256 = "1hfj1lx7wdpifn16zqrl4xml6cj5gxbn6hfz1f46g2a6bdf0gcvs";
  };

  lumberjack-v2 = buildFromGitHub {
    rev    = "v2.0";
    owner  = "natefinch";
    repo   = "lumberjack";
    sha256 = "1v92v8vkip36l2fs6l5dpp655151hrijjc781cif658r8nf7xr82";
    goPackagePath = "gopkg.in/natefinch/lumberjack.v2";
    goPackageAliases = [ "github.com/natefinch/lumberjack" ];
  };


  lxd = buildFromGitHub {
    rev    = "lxd-2.0.0.rc4";
    owner  = "lxc";
    repo   = "lxd";
    sha256 = "1rpyyj6d38d9kmb47dcmy1x41fiacj384yx01yslsrj2l6qxcdjn";
    excludedPackages = "test"; # Don't build the binary called test which causes conflicts
    buildInputs = [
      gosexy.gettext websocket crypto log15 go-lxc yaml-v2 tomb protobuf pongo2
      go-uuid tablewriter golang-petname mux go-sqlite3 goproxy
      pkgs.python3 go-systemd uuid gocapability
    ];
    postInstall = ''
      cp go/src/$goPackagePath/scripts/lxd-images $bin/bin
    '';

    meta = with stdenv.lib; {
      description = "Daemon based on liblxc offering a REST API to manage containers";
      homepage = https://github.com/lxc/lxd;
      license = licenses.asl20;
      maintainers = with maintainers; [ globin fpletz ];
      platforms = platforms.linux;
    };
  };

  manners = buildFromGitHub {
    rev = "0.4.0";
    owner = "braintree";
    repo = "manners";
    sha256 = "07985pbfhwlhbglr9zwh2wx8kkp0wzqr1lf0xbbxbhga4hn9q3ak";

    meta = with stdenv.lib; {
      description = "A polite Go HTTP server that shuts down gracefully";
      homepage = "https://github.com/braintree/manners";
      maintainers = with maintainers; [ matthiasbeyer ];
      license = licenses.mit;
    };
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

  mmark = buildFromGitHub {
    rev    = "eacb2132c31a489033ebb068432892ba791a2f1b";
    owner  = "miekg";
    repo   = "mmark";
    sha256 = "0wsi6fb6f1qi1a8yv858bkgn8pmsspw2k6dx5fx38kvg8zsb4l1a";
    buildInputs = [ toml ];
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

  motion = buildFromGitHub {
    rev = "e09baac69ad86bff1de868e8d6c4327eb0a918d7";
    owner = "fatih";
    repo = "motion";
    sha256 = "0yay4a1b5l9f4zmwkcsmr5plnp7a9b66bczy1xz4nzhl20bal6sx";
    excludedPackages = [ "testdata" ];
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
    version = "2015-08-01";
    owner = "hanwen";
    repo = "go-mtpfs";
    sha256 = "1f7lcialkpkwk01f7yxw77qln291sqjkspb09mh0yacmrhl231g8";

    buildInputs = [ go-fuse usb ];
  };

  mux = buildFromGitHub {
    rev = "5a8a0400500543e28b2886a8c52d21a435815411";
    version = "2015-08-05";
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

  netlink = buildFromGitHub {
    rev = "a632d6dc2806fa19d2f7693017d3fb79d3d8fa03";
    version = "2016-04-05";
    owner = "vishvananda";
    repo = "netlink";
    sha256 = "1m1aanxlsb1zqqxmdi528ma8c5k2h0hp6vk2nmplm6rldcnvyr4v";
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

  nitro = buildFromGitHub {
    rev    = "24d7ef30a12da0bdc5e2eb370a79c659ddccf0e8";
    owner  = "spf13";
    repo   = "nitro";
    sha256 = "143sbpx0jdgf8f8ayv51x6l4jg6cnv6nps6n60qxhx4vd90s6mib";
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

  oauth2_proxy = buildGoPackage {
    name = "oauth2_proxy";
    goPackagePath = "github.com/bitly/oauth2_proxy";
    src = fetchFromGitHub {
      rev = "10f47e325b782a60b8689653fa45360dee7fbf34";
      owner = "bitly";
      repo = "oauth2_proxy";
      sha256 = "13f6kaq15f6ial9gqzrsx7i94jhd5j70js2k93qwxcw1vkh1b6si";
    };
    buildInputs = [
      go-assert go-options go-simplejson toml fsnotify.v1 oauth2
      google-api-go-client hmacauth
    ];
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

  oh = buildFromGitHub {
    rev = "22d91b0ea97f817cd5cccd90549f74923a57daa4";
    version = "2016-03-28";
    owner = "michaelmacinnis";
    repo = "oh";
    sha256 = "1dkw3c0d640g7ciw0mmbdq94zyykdcfada05m5amnqymknphmdvl";
    goPackageAliases = [ "github.com/michaelmacinnis/oh" ];
    buildInputs = [ adapted liner ];
    disabled = isGo14;
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

  # reintroduced for gocrytpfs as I don't understand the 10gen/spacemonkey split
  openssl-spacemonkey = buildFromGitHub rec {
    rev = "71f9da2a482c2b7bc3507c3fabaf714d6bb8b75d";
    name = "openssl-${stdenv.lib.strings.substring 0 7 rev}";
    owner = "spacemonkeygo";
    repo = "openssl";
    sha256 = "1byxwiq4mcbsj0wgaxqmyndp6jjn5gm8fjlsxw9bg0f33a3kn5jk";
    nativeBuildInputs = [ pkgs.pkgconfig ];
    buildInputs = [ pkgs.openssl ];
    propagatedBuildInputs = [ spacelog ];
  };

  opencontainers.runtime-spec = buildFromGitHub {
    rev = "53f0da5e98284a39b3aaa04d5be6730924380686";
    version = "2016-04-14";
    owner = "opencontainers";
    repo = "runtime-spec";
    sha256 = "1vxhbp8rcws4kix1v0pmrbg4x1k7zmsyq1an9526q4jdrdckp7kb";
    propagatedBuildInputs = [ gojsonschema ];
  };

  opencontainers.runc = buildFromGitHub {
    rev = "d1e00150320329da347de8ec830618c697c3df79";
    version = "2016-04-14";
    owner = "opencontainers";
    repo = "runc";
    sha256 = "18dhbb1d25s4cpikrari2ws3w7x92r6yxj4si64h9y177wmn6kml";
    propagatedBuildInputs = [
      go-systemd opencontainers.runtime-spec protobuf gocapability
      docker.go-units logrus docker.docker netlink cli-go
    ];
  };

  opsgenie-go-sdk = buildFromGitHub {
    rev = "c6e1235dfed2126eb9b562c4d776baf55ccd23e3";
    version = "2015-08-24";
    owner = "opsgenie";
    repo = "opsgenie-go-sdk";
    sha256 = "1prvnjiqmhnp9cggp9f6882yckix2laqik35fcj32117ry26p4jm";
    propagatedBuildInputs = [ seelog go-querystring goreq ];
    excludedPackages = "samples";
  };

  osext = buildFromGitHub {
    rev = "29ae4ffbc9a6fe9fb2bc5029050ce6996ea1d3bc";
    owner = "kardianos";
    repo = "osext";
    sha256 = "1mawalaz84i16njkz6f9fd5jxhcbxkbsjnav3cmqq2dncv2hyv8a";
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
    version = "2014-07-16";
    owner  = "bmizerany";
    repo   = "perks";
    rev    = "d9a9656a3a4b1c2864fdb44db2ef8619772d92aa";
    sha256 = "0f39b3zfm1zd6xcvlm6szgss026qs84n2j9y5bnb3zxzdkxb9w9n";
  };

  beorn7.perks = buildFromGitHub rec {
    version = "2015-02-23";
    owner  = "beorn7";
    repo   = "perks";
    rev    = "b965b613227fddccbfffe13eae360ed3fa822f8d";
    sha256 = "1p8zsj4r0g61q922khfxpwxhdma2dx4xad1m5qx43mfn28kxngqk";
  };

  pflag = buildGoPackage rec {
    version = "20131112";
    rev = "94e98a55fb412fcbcfc302555cb990f5e1590627";
    name = "pflag-${version}-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/spf13/pflag";
    src = fetchgit {
      inherit rev;
      url = "https://${goPackagePath}.git";
      sha256 = "0z8nzdhj8nrim8fz11magdl0wxnisix9p2kcvn5kkb3bg8wmxhbg";
    };
    doCheck = false; # bad import path in tests
  };

  pflag-spf13 = buildFromGitHub rec {
    rev    = "08b1a584251b5b62f458943640fc8ebd4d50aaa5";
    owner  = "spf13";
    repo   = "pflag";
    sha256 = "139d08cq06jia0arc6cikdnhnaqms07xfay87pzq5ym86fv0agiq";
  };

  pond = let
      isx86_64 = stdenv.lib.any (n: n == stdenv.system) stdenv.lib.platforms.x86_64;
      gui = true; # Might be implemented with nixpkgs config.
  in buildFromGitHub {
    rev = "bce6e0dc61803c23699c749e29a83f81da3c41b2";
    owner = "agl";
    repo = "pond";
    sha256 = "1dmgbg4ak3jkbgmxh0lr4hga1nl623mh7pvsgby1rxl4ivbzwkh4";

    buildInputs = [ net crypto protobuf ed25519 pkgs.trousers ]
      ++ stdenv.lib.optional isx86_64 pkgs.dclxvi
      ++ stdenv.lib.optionals gui [ go-gtk-agl pkgs.wrapGAppsHook ];
    buildFlags = stdenv.lib.optionalString (!gui) "-tags nogui";
    excludedPackages = "\\(appengine\\|bn256cgo\\)";
    postPatch = stdenv.lib.optionalString isx86_64 ''
      grep -r 'bn256' | awk -F: '{print $1}' | xargs sed -i \
        -e "s,golang.org/x/crypto/bn256,github.com/agl/pond/bn256cgo,g" \
        -e "s,bn256\.,bn256cgo.,g"
    '';
  };

  pongo2 = buildFromGitHub {
    rev    = "5e81b817a0c48c1c57cdf1a9056cf76bdee02ca9";
    version = "2014-10-27";
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

  prometheus.alertmanager = buildFromGitHub rec {
    rev = "0.1.0";
    owner = "prometheus";
    repo = "alertmanager";
    sha256 = "1ya465bns6cj2lqbipmfm13wz8kxii5h9mm7lc0ba1xv26xx5zs7";

    buildInputs = [
      # fsnotify.v0
      # httprouter
      # prometheus.client_golang
      # prometheus.log
      # pushover
    ];

    # Tests exist, but seem to clash with the firewall.
    doCheck = false;

    preBuild = ''
      export GO15VENDOREXPERIMENT=1
    '';

    buildFlagsArray = let t = "github.com/${owner}/${repo}/version"; in ''
      -ldflags=
         -X ${t}.Version=${rev}
         -X ${t}.Revision=unknown
         -X ${t}.Branch=unknown
         -X ${t}.BuildUser=nix@nixpkgs
         -X ${t}.BuildDate=unknown
         -X ${t}.GoVersion=${stdenv.lib.getVersion go}
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
    version = "2015-02-12";
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
    version = "2015-05-29";
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
    version = "2015-06-01";
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
    rev = "0.11.0";
    owner = "prometheus";
    repo = "node_exporter";
    sha256 = "149fs9yxnbiyd4ww7bxsv730mcskblpzb3cs4v12jnq2v84a4kk4";

    buildInputs = [
      go-runit
      ntp
      prometheus.client_golang
      prometheus.client_model
      prometheus.log
      protobuf
    ];

    doCheck = true;

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
    version = "2015-06-16";
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

  prometheus.prometheus = buildFromGitHub rec {
    rev = "0.17.0";
    owner = "prometheus";
    repo = "prometheus";
    sha256 = "176198krna2i37dfhwsqi7m36sqn175yiny6n52vj27mc9s8ggzx";

    buildInputs = [
      # consul
      # dns
      # fsnotify.v1
      # go-zookeeper
      # goleveldb
      # httprouter
      # logrus
      # net
      # prometheus.client_golang
      # prometheus.log
      # yaml-v2
    ];

    docheck = true;

    preBuild = ''
      export GO15VENDOREXPERIMENT=1
    '';

    buildFlagsArray = let t = "github.com/${owner}/${repo}/version"; in ''
      -ldflags=
         -X ${t}.Version=${rev}
         -X ${t}.Revision=unknown
         -X ${t}.Branch=unknown
         -X ${t}.BuildUser=nix@nixpkgs
         -X ${t}.BuildDate=unknown
         -X ${t}.GoVersion=${stdenv.lib.getVersion go}
    '';

    preInstall = ''
      mkdir -p "$bin/share/doc/prometheus" "$bin/etc/prometheus"
      cp -a $src/documentation/* $bin/share/doc/prometheus
      cp -a $src/console_libraries $src/consoles $bin/etc/prometheus
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

  properties = buildFromGitHub {
    rev    = "v1.5.6";
    owner  = "magiconair";
    repo   = "properties";
    sha256 = "043jhba7qbbinsij3yc475s1i42sxaqsb82mivh9gncpvnmnf6cl";
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

  purell = buildFromGitHub {
    rev    = "d69616f51cdfcd7514d6a380847a152dfc2a749d";
    owner  = "PuerkitoBio";
    repo   = "purell";
    sha256 = "0nma5i25j0y223ns7482lx4klcfhfwdr8v6r9kzrs0pwlq64ghs0";
    propagatedBuildInputs = [ urlesc ];
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
    version = "2015-06-19";
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
    version = "2015-07-21";
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

  relaysrv = buildFromGitHub rec {
    rev    = "7fe1fdd8c751df165ea825bc8d3e895f118bb236";
    owner  = "syncthing";
    repo   = "relaysrv";
    sha256 = "0qy14pa0z2dq5mix5ylv2raabwxqwj31g5kkz905wzki6d4j5lnp";
    buildInputs = [ xdr syncthing-protocol011 ratelimit syncthing-lib ];
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

  restic = buildFromGitHub {
    rev    = "4d7e802c44369b40177cd52938bc5b0930bd2be1";
    version = "2016-01-17";
    owner  = "restic";
    repo   = "restic";
    sha256 = "0lf40539dy2xa5l1xy1kyn1vk3w0fmapa1h65ciksrdhn89ilrxv";
    # Using its delivered dependencies. Easier.
    preBuild = "export GOPATH=$GOPATH:$NIX_BUILD_TOP/go/src/$goPackagePath/Godeps/_workspace";
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

  rsrc = buildFromGitHub {
    rev    = "ba14da1f827188454a4591717fff29999010887f";
    version = "2015-11-03";
    owner  = "akavel";
    repo   = "rsrc";
    sha256 = "0g9fj10xnxcv034c8hpcgbhswv6as0d8l176c5nfgh1lh6klmmzc";
  };

  s3gof3r = buildFromGitHub rec {
    owner    = "rlmcpherson";
    repo     = "s3gof3r";
    rev      = "v${version}";
    version  = "0.5.0";
    sha256   = "10banc8hnhxpsdmlkf9nc5fjkh1349bgpd9k7lggw3yih1rvmh7k";
    disabled = isGo14;
    propagatedBuildInputs = [ go-flags ];
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

  # This is the upstream package name, underscores and all. I don't like it
  # but it seems wrong to change their name when packaging it.
  sanitized_anchor_name = buildFromGitHub {
    rev    = "10ef21a441db47d8b13ebcc5fd2310f636973c77";
    owner  = "shurcooL";
    repo   = "sanitized_anchor_name";
    sha256 = "1cnbzcf47cn796rcjpph1s64qrabhkv5dn9sbynsy7m9zdwr5f01";
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
    version = "2015-05-26";
    owner = "cihub";
    repo = "seelog";
    sha256 = "1f0rwgqlffv1a7b05736a4gf4l9dn80wsfyqcnz6qd2skhwnzv29";
  };

  segment = buildFromGitHub {
    rev    = "db70c57796cc8c310613541dfade3dce627d09c7";
    version = "2016-01-05";
    owner  = "blevesearch";
    repo   = "segment";
    sha256 = "09xfdlcc6bsrr5grxp6fgnw9p4cf6jc0wwa9049fd1l0zmhj2m1g";
  };

  semver = buildFromGitHub {
    rev = "31b736133b98f26d5e078ec9eb591666edfd091f";
    version = "2015-07-20";
    owner = "blang";
    repo = "semver";
    sha256 = "19ifi0na4cj23q3h8xv89mx7p48y0ciymhmlrq9milm0xz80wk10";
  };

  serf = buildFromGitHub {
    rev = "668982d8f90f5eff4a766583c1286393c1d27f68";
    version = "2015-05-15";
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

  shlex = buildFromGitHub {
    rev = "6f45313302b9c56850fc17f99e40caebce98c716";
    owner = "google";
    repo = "shlex";
    sha256 = "0ybz1w3hndma8myq3pxan36533hy9f4w598hsv4hnj21l4br8jpx";
  };

  skydns = buildFromGitHub {
    rev = "2.5.3a";
    owner = "skynetservices";
    repo = "skydns";
    sha256 = "0i1iaif79cwnwm7pc8nxfa261cgl4zhm3p2a5a3smhy1ibgccpq7";

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

  structfield = buildFromGitHub {
    rev    = "01a738558a47fbf16712994d1737fb31c77e7d11";
    version = "2014-08-01";
    owner  = "vincent-petithory";
    repo   = "structfield";
    sha256 = "1kyx71z13mf6hc8ly0j0b9zblgvj5lzzvgnc3fqh61wgxrsw24dw";
  };

  structs = buildFromGitHub {
    rev    = "a9f7daa9c2729e97450c2da2feda19130a367d8f";
    owner  = "fatih";
    repo   = "structs";
    sha256 = "0pyrc7svc826g37al3db19n5l4r2m9h1mlhjh3hz2r41xfaqia50";
  };

  suture = buildFromGitHub rec {
    version = "1.0.1";
    rev    = "v${version}";
    owner  = "thejerf";
    repo   = "suture";
    sha256 = "094ksr2nlxhvxr58nbnzzk0prjskb21r86jmxqjr3rwg4rkwn6d4";
  };

  syncthing = buildFromGitHub rec {
    version = "0.12.23";
    rev = "v${version}";
    owner = "syncthing";
    repo = "syncthing";
    sha256 = "0v8343k670ncjfd25hzhyfi87cz46k57rmv6pf30v7iclfhpmy1s";
    buildFlags = [ "-tags noupgrade,release" ];
    disabled = isGo14;
    buildInputs = [
      go-lz4 du luhn xdr snappy ratelimit osext
      goleveldb suture qart crypto net text rcrowley.go-metrics
    ];
    postPatch = ''
      # Mostly a cosmetic change
      sed -i 's,unknown-dev,${version},g' cmd/syncthing/main.go
    '';
  };

  syncthing011 = buildFromGitHub rec {
    version = "0.11.26";
    rev = "v${version}";
    owner = "syncthing";
    repo = "syncthing";
    sha256 = "0c0dcvxrvjc84dvrsv90790aawkmavsj9bwp8c6cd6wrwj3cp9lq";
    buildInputs = [
      go-lz4 du luhn xdr snappy ratelimit osext syncthing-protocol011
      goleveldb suture qart crypto net text
    ];
    postPatch = ''
      # Mostly a cosmetic change
      sed -i 's,unknown-dev,${version},g' cmd/syncthing/main.go
    '';
  };

  syncthing-lib = buildFromGitHub {
    inherit (syncthing) rev owner repo sha256;
    subPackages = [ "lib/sync" ];
    propagatedBuildInputs = syncthing.buildInputs;
  };

  syncthing-protocol = buildFromGitHub {
    inherit (syncthing) rev owner repo sha256;
    subPackages = [ "lib/protocol" ];
    propagatedBuildInputs = [
      go-lz4
      logger
      luhn
      xdr
      text ];
  };

  syncthing-protocol011 = buildFromGitHub {
    rev = "84365882de255d2204d0eeda8dee288082a27f98";
    version = "2015-08-28";
    owner = "syncthing";
    repo = "protocol";
    sha256 = "07xjs43lpd51pc339f8x487yhs39riysj3ifbjxsx329kljbflwx";
    propagatedBuildInputs = [ go-lz4 logger luhn xdr text ];
  };

  tablewriter = buildFromGitHub {
    rev    = "cca8bbc0798408af109aaaa239cbd2634846b340";
    version = "2016-01-15";
    owner  = "olekukonko";
    repo   = "tablewriter";
    sha256 = "0f9ph3z7lh6p6gihbl1461j9yq5qiaqxr9mzdkp512n18v89ml48";
    propagatedBuildInputs = [ mattn.go-runewidth ];
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

  terraform = buildFromGitHub {
    rev = "v0.6.15";
    owner = "hashicorp";
    repo = "terraform";
    disabled = isGo14 || isGo15;
    sha256 = "1mf98hagb0yp40g2mbar7aw7hmpq01clnil6y9khvykrb33vy0nb";

    postInstall = ''
      for i in $bin/bin/{provider,provisioner}-*; do mv $i $bin/bin/terraform-$(basename $i); done
    '';
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
    version = "2015-02-02";
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
    version = "2015-05-01";
    owner  = "BurntSushi";
    repo   = "toml";
    sha256 = "0gkgkw04ndr5y7hrdy0r4v2drs5srwfcw2bs1gyas066hwl84xyw";
  };

  uilive = buildFromGitHub {
    rev = "1b9b73fa2b2cc24489b1aba4d29a82b12cd0a71f";
    owner = "gosuri";
    repo = "uilive";
    sha256 = "0669f21hd5cw74irrfakdpvxn608cd5xy6s2nyp5kgcy2ijrq4ab";
  };

  uiprogress = buildFromGitHub {
    buildInputs = [ uilive ];
    rev = "fd1c82df78a6c1f5ddbd3b6ec46407ea0acda1ad";
    owner = "gosuri";
    repo = "uiprogress";
    sha256 = "1s61vp2h6n1d8y1zqr2ca613ch5n18rx28waz6a8im94sgzzawp7";
  };

  urlesc = buildFromGitHub {
    rev    = "5fa9ff0392746aeae1c4b37fcc42c65afa7a9587";
    owner  = "opennota";
    repo   = "urlesc";
    sha256 = "0dppkmfs0hb5vcqli191x9yss5vvlx29qxjcywhdfirc89rn0sni";
  };

  usb = buildFromGitHub rec {
    rev = "69aee4530ac705cec7c5344418d982aaf15cf0b1";
    version = "2014-12-17";
    owner = "hanwen";
    repo = "usb";
    sha256 = "01k0c2g395j65vm1w37mmrfkg6nm900khjrrizzpmx8f8yf20dky";

    nativeBuildInputs = [ pkgs.pkgconfig ];
    buildInputs = [ pkgs.libusb1 ];
  };

  uuid = buildFromGitHub {
    rev = "cccd189d45f7ac3368a0d127efb7f4d08ae0b655";
    version = "2015-08-24";
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
    rev    = "1.4.0";
    owner  = "Masterminds";
    repo   = "vcs";
    sha256 = "0590ww2av4407y7zy3bcmnr8i74fv00k9zzcxcpjxivl6qszna0d";
  };

  viper = buildFromGitHub {
    rev    = "e37b56e207dda4d79b9defe0548e960658ee8b6b";
    owner  = "spf13";
    repo   = "viper";
    sha256 = "0q0hkla23hgvc3ab6qdlrfwxa8lnhy2s2mh2c8zrh632gp8d6prl";
    propagatedBuildInputs = [
      mapstructure yaml-v2 jwalterweatherman crypt fsnotify.v1 cast properties
      pretty toml pflag-spf13
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
    rev    = "6eb6ad425a89d9da7a5549bc6da8f79ba5c17844";
    owner  = "gorilla";
    repo   = "websocket";
    sha256 = "0gljdfxqc94yb1kpqqrm5p94ph9dsxrzcixhdj6m92cwwa7z7p99";
  };

  xmpp-client = buildFromGitHub {
    rev      = "525bd26cf5f56ec5aee99464714fd1d019c119ff";
    version  = "2016-01-10";
    owner    = "agl";
    repo     = "xmpp-client";
    sha256   = "0a1r08zs723ikcskmn6ylkdi3frcd0i0lkx30i9q39ilf734v253";
    disabled = isGo14;
    buildInputs = [ crypto net ];

    meta = with stdenv.lib; {
      description = "An XMPP client with OTR support";
      homepage = https://github.com/agl/xmpp-client;
      license = licenses.bsd3;
      maintainers = with maintainers; [ codsl ];
    };
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
    version = "2015-06-24";
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
    rev    = "e467b5aeb65ca8516fb3925c84991bf1d7cc935e";
    version = "2015-04-08";
    owner  = "calmh";
    repo   = "xdr";
    sha256 = "1bi4b2xkjzcr0vq1wxz14i9943k71sj092dam0gdmr9yvdrg0nra";
  };

  xon = buildFromGitHub {
    rev    = "d580be739d723da4f6378083128f93017b8ab295";
    owner  = "odeke-em";
    repo   = "xon";
    sha256 = "07a7zj01d4a23xqp01m48jp2v5mw49islf4nbq2rj13sd5w4s6sc";
  };

  ninefans = buildFromGitHub {
    rev    = "65b8cf069318223b1e722b4b36e729e5e9bb9eab";
    version = "2015-10-24";
    owner  = "9fans";
    repo   = "go";
    sha256 = "0kzyxhs2xf0339nlnbm9gc365b2svyyjxnr86rphx5m072r32ims";
    goPackagePath = "9fans.net/go";
    goPackageAliases = [
      "github.com/9fans/go"
    ];
    excludedPackages = "\\(plan9/client/cat\\|acme/Watch\\)";
    buildInputs = [ net ];
  };

  godef = buildFromGitHub {
    rev    = "ea14e800fd7d16918be88dae9f0195f7bd688586";
    version = "2015-10-24";
    owner  = "rogpeppe";
    repo   = "godef";
    sha256 = "1wkvsz8nqwyp36wbm8vcw4449sfs46894nskrfj9qbsrjijvamyc";
    excludedPackages = "\\(go/printer/testdata\\)";
    buildInputs = [ ninefans ];
    subPackages = [ "./" ];
  };

  godep = buildFromGitHub rec {
    version = "60";
    rev    = "v${version}";
    owner  = "tools";
    repo   = "godep";
    sha256 = "1v05185ikfcb3sz9ygcwm9x8la77i27ml1bg9fs6vvahjzyr0rif";
  };

  color = buildFromGitHub {
    rev      = "9aae6aaa22315390f03959adca2c4d395b02fcef";
    owner    = "fatih";
    repo     = "color";
    sha256   = "1vjcgx4xc0h4870qzz4mrh1l0f07wr79jm8pnbp6a2yd41rm8wjp";
    propagatedBuildInputs = [ net go-isatty ];
    buildInputs = [ ansicolor go-colorable ];
  };

  pup = buildFromGitHub {
    rev      = "9693b292601dd24dab3c04bc628f9ae3fa72f831";
    owner    = "EricChiang";
    repo     = "pup";
    sha256   = "04j3fy1vk6xap8ad7k3c05h9b5mg2n1vy9vcyg9rs02cb13d3sy0";
    propagatedBuildInputs = [ net ];
    buildInputs = [ go-colorable color ];
    postPatch = ''
      grep -sr github.com/ericchiang/pup/Godeps/_workspace/src/ |
        cut -f 1 -d : |
        sort -u |
        xargs -d '\n' sed -i -e s,github.com/ericchiang/pup/Godeps/_workspace/src/,,g
    '';
  };

  textsecure = buildFromGitHub rec {
    rev = "505e129c42fc4c5cb2d105520cef7c04fa3a6b64";
    owner = "janimo";
    repo = "textsecure";
    sha256 = "0sdcqd89dlic0bllb6mjliz4x54rxnm1r3xqd5qdp936n7xs3mc6";
    propagatedBuildInputs = [ crypto protobuf ed25519 yaml-v2 logrus ];
    disabled = isGo14;
  };

  interlock = buildFromGitHub rec {
    version = "2016.01.14";
    rev = "v${version}";
    owner = "inversepath";
    repo = "interlock";
    sha256 = "0wabx6vqdxh2aprsm2rd9mh71q7c2xm6xk9a6r1bn53r9dh5wrsb";
    buildInputs = [ crypto textsecure ];
    nativeBuildInputs = [ pkgs.sudo ];
    buildFlags = [ "-tags textsecure" ];
    subPackages = [ "./cmd/interlock" ];
    postPatch = ''
      grep -lr '/s\?bin/' | xargs sed -i \
        -e 's|/bin/mount|${pkgs.utillinux}/bin/mount|' \
        -e 's|/bin/umount|${pkgs.utillinux}/bin/umount|' \
        -e 's|/bin/cp|${pkgs.coreutils}/bin/cp|' \
        -e 's|/bin/mv|${pkgs.coreutils}/bin/mv|' \
        -e 's|/bin/chown|${pkgs.coreutils}/bin/chown|' \
        -e 's|/bin/date|${pkgs.coreutils}/bin/date|' \
        -e 's|/sbin/poweroff|${pkgs.systemd}/sbin/poweroff|' \
        -e 's|/usr/bin/sudo|/var/setuid-wrappers/sudo|' \
        -e 's|/sbin/cryptsetup|${pkgs.cryptsetup}/bin/cryptsetup|'
    '';
    disabled = isGo14;
  };

  template = buildFromGitHub {
    rev = "14fd436dd20c3cc65242a9f396b61bfc8a3926fc";
    owner = "alecthomas";
    repo = "template";
    sha256 = "19rzvvcgvr1z2wz9xpqsmlm8syizbpxjp5zbzgakvrqlajpbjvx2";
  };

  units = buildFromGitHub {
    rev = "2efee857e7cfd4f3d0138cc3cbb1b4966962b93a";
    owner = "alecthomas";
    repo = "units";
    sha256 = "1j65b91qb9sbrml9cpabfrcf07wmgzzghrl7809hjjhrmbzri5bl";
  };

  go-difflib = buildFromGitHub {
    rev = "d8ed2627bdf02c080bf22230dbb337003b7aba2d";
    owner = "pmezard";
    repo = "go-difflib";
    sha256 = "0w1jp4k4zbnrxh3jvh8fgbjgqpf2hg31pbj8fb32kh26px9ldpbs";
  };

  kingpin = buildFromGitHub {
    rev = "21551c2a6259a8145110ca80a36e25c9d7624032";
    owner = "alecthomas";
    repo = "kingpin";
    sha256 = "1zhpqc4qxsw9lc1b4dwk5r42k9r702ihzrabs3mnsphvm9jx4l59";
    propagatedBuildInputs = [ template units ];
    goPackageAliases = [ "gopkg.in/alecthomas/kingpin.v2" ];
  };

  go2nix = buildFromGitHub rec {
    rev = "4c552dadd855e3694ed3499feb46dca9cd855f60";
    owner = "kamilchm";
    repo = "go2nix";
    sha256 = "1pwnm1vrjxvgl17pk9n1k5chmhgwxkrwp2s1bzi64xf12anibj63";

    buildInputs = [ pkgs.makeWrapper go-bindata.bin tools.bin vcs go-spew gls go-difflib assertions goconvey testify kingpin ];

    preBuild = ''go generate ./...'';

    postInstall = ''
      wrapProgram $bin/bin/go2nix \
        --prefix PATH : ${pkgs.nix-prefetch-git}/bin \
        --prefix PATH : ${pkgs.git}/bin
    '';

    allowGoReference = true;
  };

  godotenv = buildFromGitHub rec {
    rev    = "4ed13390c0acd2ff4e371e64d8b97c8954138243";
    version = "2015-09-07";
    owner  = "joho";
    repo   = "godotenv";
    sha256 = "1wzgws4dnlavi14aw3jzdl3mdr348skgqaq8xx4j8l68irfqyh0p";
    buildInputs = [ go-colortext yaml-v2 ];
  };

  goreman = buildFromGitHub rec {
    version = "0.0.8-rc0";
    rev    = "d3e62509ccf23e47a390447886c51b1d89d0934b";
    owner  = "mattn";
    repo   = "goreman";
    sha256 = "153hf4dq4jh1yv35pv30idmxhc917qzl590qy5394l48d4rapgb5";
    buildInputs = [ go-colortext yaml-v2 godotenv ];
  };

  # To use upower-notify, the maintainer suggests adding something like this to your configuration.nix:
  #
  # service.xserver.displayManager.sessionCommands = ''
  #   ${pkgs.dunst}/bin/dunst -shrink -geometry 0x0-50-50 -key space & # ...if don't already have a dbus notification display app
  #   (sleep 3; exec ${pkgs.yeshup}/bin/yeshup ${pkgs.go-upower-notify}/bin/upower-notify) &
  # '';
  upower-notify = buildFromGitHub rec {
    rev    = "14c581e683a7e90ec9fa6d409413c16599a5323c";
    version = "2016-03-10";
    owner  = "omeid";
    repo   = "upower-notify";
    sha256 = "16zlvn53p9m10ph8n9gps51fkkvl6sf4afdzni6azk05j0ng49jw";
    propagatedBuildInputs = [ dbus ];
  };

  ingo = buildFromGitHub rec {
    rev     = "fab41e4e62cbef5d92998746ec25f7e195100f38";
    version = "2016-04-07";
    owner   = "schachmat";
    repo    = "ingo";
    sha256  = "04yfnch7pdabjjqfl2qxjmsaknvp4m1rbjlv8qrpmnqwjkxzx0hb";
    propagatedBuildInputs = [ ];
  };

  wego = buildFromGitHub rec {
    rev     = "81d72ffd761f032fbd73dba4f94bd94c8c2d53d5";
    version = "2016-04-07";
    owner   = "schachmat";
    repo    = "wego";
    sha256  = "14p3hvv82bsxqnbnzz8hjv75i39kzg154a132n6cdxx3vgw76gck";
    propagatedBuildInputs = [ go-colorable mattn.go-runewidth ingo ];
  };

  textql = buildFromGitHub rec {
    rev     = "1785cd353c68aa34f97627143b9c2908dfd4ea04";
    version = "2.0.3";
    owner   = "dinedal";
    repo    = "textql";
    sha256 = "1b61w4pc5gl7m12mphricihzq7ifnzwn0yyw3ypv0d0fj26h5hc3";
    propagatedBuildInputs = [ go-sqlite3 ];

    meta = with stdenv.lib; {
      description = "Execute SQL against structured text like CSV or TSV";
      homepage = https://github.com/dinedal/textql;
      license = licenses.mit;
      maintainers = with maintainers; [ vrthra ];
    };

  };

  gopsutil = buildFromGitHub rec {
    version = "1.0.0";
    rev = "37d89088411de59a4ef9fc340afa0e89dfcb4ea9";
    owner = "shirou";
    repo = "gopsutil";
    sha256 = "13bi1d9hw8vr6qjpblryhglm0ikzpijbwhpp6rx7f5yd7sxsswhm";
    propagatedBuildInputs = [ ];
  };

  gohai = buildFromGitHub rec {
    rev = "94685629c66fe481bfb499175b448fb401a41781";
    version = "2016-04-14";
    owner = "DataDog";
    repo = "gohai";
    sha256 = "0dvrv7skc0k8zd83gbwml8c02wjwldhxhhgzmwdfvvaqc00qz2c0";
    propagatedBuildInputs = [ seelog gopsutil ];
  };
}; in self
