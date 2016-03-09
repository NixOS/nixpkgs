/* This file defines the composition for Go packages. */

{ overrides, stdenv, go, buildGoPackage, git
, fetchgit, fetchhg, fetchurl, fetchFromGitHub, fetchFromBitbucket, fetchbzr, pkgs }:

let
  isGo14 = go.meta.branch == "1.4";

  # When adding entries to the json file, please use `jq . < go-packages.json --sort-keys`
  # to canonicallize the data.
  ghPackages = stdenv.lib.importJSON ./go-packages.json;

  self = _self // overrides; _self = with self; {

  inherit go buildGoPackage;

  buildFromGitHub = { rev ? ghPackages."${owner}"."${repo}".rev, date ? null
                    , sha256 ? ghPackages."${owner}"."${repo}".sha256
                    , owner, repo , name ? repo, goPackagePath ? "github.com/${owner}/${repo}"
                    , ... }@args: buildGoPackage (args // {
    inherit rev goPackagePath sha256;
    name = "${name}-${if date != null then date else if builtins.stringLength rev != 40 then rev else stdenv.lib.strings.substring 0 7 rev}";
    src  = args.src or (fetchFromGitHub { inherit rev owner repo sha256; });
  });

  ## OFFICIAL GO PACKAGES

  crypto = buildFromGitHub {
    date     = "2015-08-29";
    owner    = "golang";
    repo     = "crypto";
    goPackagePath = "golang.org/x/crypto";
    goPackageAliases = [
      "code.google.com/p/go.crypto"
      "github.com/golang/crypto"
    ];
  };

  glog = buildFromGitHub {
    date   = "2015-07-31";
    owner  = "golang";
    repo   = "glog";
  };

  codesearch = buildFromGitHub {
    date   = "2015-06-17";
    owner  = "google";
    repo   = "codesearch";
  };

  image = buildFromGitHub {
    date = "2015-08-23";
    owner = "golang";
    repo = "image";
    goPackagePath = "golang.org/x/image";
    goPackageAliases = [ "github.com/golang/image" ];
  };

  net_go15 = buildFromGitHub {
    date   = "2015-11-04";
    owner  = "golang";
    repo   = "net";
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
    date   = "2015-08-29";
    owner  = "golang";
    repo   = "net";
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
    date = "2015-06-23";
    owner = "golang";
    repo = "oauth2";
    goPackagePath = "golang.org/x/oauth2";
    goPackageAliases = [ "github.com/golang/oauth2" ];
    propagatedBuildInputs = [ net gcloud-golang-compute-metadata ];
  };


  protobuf = buildFromGitHub {
    date = "2015-08-23";
    owner = "golang";
    repo = "protobuf";
    goPackagePath = "github.com/golang/protobuf";
    goPackageAliases = [ "code.google.com/p/goprotobuf" ];
  };

  snappy = buildFromGitHub {
    date   = "2015-07-21";
    owner  = "golang";
    repo   = "snappy";
    goPackageAliases = [ "code.google.com/p/snappy-go/snappy" ];
  };

  sys = buildFromGitHub {
    date   = "2015-02-01";
    owner  = "golang";
    repo   = "sys";
    goPackagePath = "golang.org/x/sys";
    goPackageAliases = [
      "github.com/golang/sys"
    ];
  };

  text = buildFromGitHub {
    date = "2015-08-27";
    owner = "golang";
    repo = "text";
    goPackagePath = "golang.org/x/text";
    goPackageAliases = [ "github.com/golang/text" ];
  };

  tools = buildFromGitHub {
    date = "2015-08-24";
    owner = "golang";
    repo = "tools";
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
    owner  = "yosssi";
    repo   = "ace";
    buildInputs = [ gohtml ];
  };

  adapted = buildFromGitHub {
    date = "2015-06-03";
    owner = "michaelmacinnis";
    repo = "adapted";
    propagatedBuildInputs = [ sys ];
  };

  afero = buildFromGitHub {
    owner  = "spf13";
    repo   = "afero";
    propagatedBuildInputs = [ text ];
  };

  airbrake-go = buildFromGitHub {
    owner  = "tobi";
    repo   = "airbrake-go";
  };

  amber = buildFromGitHub {
    owner  = "eknkc";
    repo   = "amber";
  };

  ansicolor = buildFromGitHub {
    owner  = "shiena";
    repo   = "ansicolor";
  };

  asciinema = buildFromGitHub {
    owner = "asciinema";
    repo = "asciinema";
  };

  asn1-ber = buildFromGitHub rec {
    owner  = "go-asn1-ber";
    repo   = "asn1-ber";
    goPackagePath = "github.com/go-asn1-ber/asn1-ber";
    goPackageAliases = [
      "github.com/nmcclain/asn1-ber"
      "github.com/vanackere/asn1-ber"
      "gopkg.in/asn1-ber.v1"
    ];
  };

  assertions = buildFromGitHub rec {
    owner = "smartystreets";
    repo = "assertions";
    buildInputs = [ oglematchers ];
    propagatedBuildInputs = [ goconvey ];
    doCheck = false;
  };

  aws-sdk-go = buildFromGitHub {
    owner  = "aws";
    repo   = "aws-sdk-go";
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
    owner  = "hashicorp";
    repo   = "aws-sdk-go";
    propagatedBuildInputs = [ go-ini ];
    subPackages = [
      "./aws"
      "./gen/ec2"
      "./gen/endpoints"
      "./gen/iam"
    ];
  };

  bleve = buildFromGitHub {
    date   = "2016-01-19";
    owner  = "blevesearch";
    repo   = "bleve";
    buildFlags = [ "-tags all" ];
    propagatedBuildInputs = [ protobuf goleveldb kagome gtreap bolt text
     rcrowley.go-metrics bitset segment go-porterstemmer ];
  };

  binarydist = buildFromGitHub {
    owner  = "kr";
    repo   = "binarydist";
  };

  bitset = buildFromGitHub {
    date   = "2016-01-13";
    owner  = "willf";
    repo   = "bitset";
  };

  blackfriday = buildFromGitHub {
    owner  = "russross";
    repo   = "blackfriday";
    propagatedBuildInputs = [ sanitized_anchor_name ];
  };

  bolt = buildFromGitHub {
    owner  = "boltdb";
    repo   = "bolt";
  };

  bufio = buildFromGitHub {
    owner  = "vmihailenco";
    repo   = "bufio";
  };

  bugsnag-go = buildFromGitHub {
    owner = "bugsnag";
    repo = "bugsnag-go";
    propagatedBuildInputs = [ panicwrap revel ];
  };

  cascadia = buildFromGitHub rec {
    owner = "andybalholm";
    repo = "cascadia";
    goPackageAliases = [ "code.google.com/p/cascadia" ];
    propagatedBuildInputs = [ net ];
    buildInputs = propagatedBuildInputs;
    doCheck = true;
  };

  cast = buildFromGitHub {
    owner  = "spf13";
    repo   = "cast";
    buildInputs = [ jwalterweatherman ];
  };

  check-v1 = buildFromGitHub {
    owner = "go-check";
    repo = "check";
    goPackagePath = "gopkg.in/check.v1";
  };

  circbuf = buildFromGitHub {
    owner  = "armon";
    repo   = "circbuf";
  };

  cli = buildFromGitHub {
    owner = "mitchellh";
    repo = "cli";
    propagatedBuildInputs = [ crypto ];
  };

  cli-spinner = buildFromGitHub {
    owner  = "odeke-em";
    repo   = "cli-spinner";
  };

  cobra = buildFromGitHub {
    owner  = "spf13";
    repo   = "cobra";
    propagatedBuildInputs = [ pflag-spf13 mousetrap go-md2man viper ];
  };

  cli-go = buildFromGitHub {
    owner  = "codegangsta";
    repo   = "cli";
  };

  columnize = buildFromGitHub {
    owner  = "ryanuber";
    repo   = "columnize";
  };

  command = buildFromGitHub {
    owner  = "odeke-em";
    repo   = "command";
  };

  copystructure = buildFromGitHub {
    owner = "mitchellh";
    repo = "copystructure";
    buildInputs = [ reflectwalk ];
  };

  confd = buildFromGitHub {
    owner = "kelseyhightower";
    repo = "confd";
    preBuild = "export GOPATH=$GOPATH:$NIX_BUILD_TOP/go/src/$goPackagePath/Godeps/_workspace";
    subPackages = [ "./" ];
  };

  config = buildFromGitHub {
    owner  = "robfig";
    repo   = "config";
  };

  consul = buildFromGitHub {
    owner = "hashicorp";
    repo = "consul";

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
    inherit (consul) owner repo;
    inherit (consul) src;
    subPackages = [ "api" ];
  };

  consul-alerts = buildFromGitHub {
    date = "2015-08-09";
    owner = "AcalephStorage";
    repo = "consul-alerts";

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
    date   = "2015-05-19";
    owner  = "hashicorp";
    repo   = "consul-migrate";
    buildInputs = [ raft raft-boltdb raft-mdb ];
  };

  consul-template = buildFromGitHub {
    owner = "hashicorp";
    repo = "consul-template";

    # We just want the consul api not all of consul and vault
    extraSrcs = [
      { inherit (consul) src goPackagePath; }
      { inherit (vault) src goPackagePath; }
    ];

    buildInputs = [ go-multierror go-syslog hcl logutils mapstructure ];
  };

  context = buildFromGitHub rec {
    owner = "gorilla";
    repo = "context";
  };

  cookoo = buildFromGitHub {
    owner  = "Masterminds";
    repo   = "cookoo";
  };

  crypt = buildFromGitHub {
    owner  = "xordataexchange";
    repo   = "crypt";
    preBuild = ''
      substituteInPlace go/src/github.com/xordataexchange/crypt/backend/consul/consul.go \
        --replace 'github.com/armon/consul-api' 'github.com/hashicorp/consul/api' \
        --replace 'consulapi' 'api'
    '';
    propagatedBuildInputs = [ go-etcd consul-api crypto ];
  };

  cssmin = buildFromGitHub {
    owner  = "dchest";
    repo   = "cssmin";
  };

  dbus = buildFromGitHub {
    owner = "godbus";
    repo = "dbus";
  };

  deis = buildFromGitHub {
    owner = "deis";
    repo = "deis";
    subPackages = [ "client" ];
    buildInputs = [ docopt-go crypto yaml-v2 ];
    postInstall = ''
      if [ -f "$bin/bin/client" ]; then
        mv "$bin/bin/client" "$bin/bin/deis"
      fi
    '';
  };

  dns = buildFromGitHub {
    date   = "2015-07-22";
    owner  = "miekg";
    repo   = "dns";
  };

  docopt-go = buildFromGitHub {
    owner  = "docopt";
    repo   = "docopt-go";
  };

  drive = buildFromGitHub {
    owner = "odeke-em";
    repo = "drive";
    subPackages = [ "cmd/drive" ];
    buildInputs = [
      pb go-isatty command dts odeke-em.log statos xon odeke-em.google-api-go-client
      cli-spinner oauth2 text net pretty-words meddler open-golang extractor
      exponential-backoff cache bolt
    ];
    disabled = !isGo14;
  };

  cache = buildFromGitHub {
    owner = "odeke-em";
    repo = "cache";
  };

  exercism = buildFromGitHub {
    name = "exercism";
    owner = "exercism";
    repo = "cli";
    buildInputs = [ net cli-go osext ];
  };

  exponential-backoff = buildFromGitHub {
    owner = "odeke-em";
    repo = "exponential-backoff";
  };

  extractor = buildFromGitHub {
    owner = "odeke-em";
    repo = "extractor";
  };

  open-golang = buildFromGitHub {
    owner = "skratchdot";
    repo = "open-golang";
  };

  pretty-words = buildFromGitHub {
    owner = "odeke-em";
    repo = "pretty-words";
  };

  meddler = buildFromGitHub {
    owner = "odeke-em";
    repo = "meddler";
  };

  dts = buildFromGitHub {
    owner  = "odeke-em";
    repo   = "dts";
  };

  du = buildFromGitHub {
    date   = "2015-08-05";
    owner  = "calmh";
    repo   = "du";
  };

  ed25519 = buildFromGitHub {
    owner = "agl";
    repo = "ed25519";
  };

  errwrap = buildFromGitHub {
    owner  = "hashicorp";
    repo   = "errwrap";
  };

  etcd = buildFromGitHub {
    owner  = "coreos";
    repo   = "etcd";
  };

  flannel = buildFromGitHub {
    owner = "coreos";
    repo = "flannel";
  };

  fsnotify.v0 = buildFromGitHub {
    rev = "v0.9.3";
    owner = "go-fsnotify";
    repo = "fsnotify";
    sha256 = "15wqjpkfzsxnaxbz6y4r91hw6812g3sc4ipagxw1bya9klbnkdc9";
    goPackagePath = "gopkg.in/fsnotify.v0";
    goPackageAliases = [ "github.com/howeyc/fsnotify" ];
  };

  fsnotify.v1 = buildFromGitHub rec {
    rev = "v1.2.0";
    owner = "go-fsnotify";
    repo = "fsnotify";
    sha256 = "1308z1by82fbymcra26wjzw7lpjy91kbpp2skmwqcq4q1iwwzvk2";
    goPackagePath = "gopkg.in/fsnotify.v1";
  };

  fsync = buildFromGitHub {
    owner  = "spf13";
    repo   = "fsync";
    buildInputs = [ afero ];
  };

  fzf = buildFromGitHub {
    owner = "junegunn";
    repo = "fzf";

    buildInputs = [
      crypto ginkgo gomega junegunn.go-runewidth go-shellwords pkgs.ncurses text
    ];

    postInstall= ''
      cp $src/bin/fzf-tmux $bin/bin
    '';
  };

  g2s = buildFromGitHub {
    owner  = "peterbourgon";
    repo   = "g2s";
  };

  gawp = buildFromGitHub {
    date = "2015-08-31";
    owner  = "martingallagher";
    repo   = "gawp";
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
    owner = "GoogleCloudPlatform";
    repo = "gcloud-golang";
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
    owner  = "chai2010";
    repo   = "gettext-go";
  };

  ginkgo = buildFromGitHub {
    owner = "onsi";
    repo = "ginkgo";
    subPackages = [ "./" ];  # don't try to build test fixtures
  };

  git-annex-remote-b2 = buildFromGitHub {
    buildInputs = [ go go-backblaze ];
    owner = "encryptio";
    repo = "git-annex-remote-b2";
  };

  git-appraise = buildFromGitHub {
    owner = "google";
    repo = "git-appraise";
  };

  git-lfs = buildFromGitHub {
    date = "1.1.1";  # "date" is effectively "version"
    owner = "github";
    repo = "git-lfs";

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
    owner  = "Masterminds";
    repo   = "glide";
    buildInputs = [ cookoo cli-go go-gypsy vcs ];
  };

  gls = buildFromGitHub {
    owner  = "jtolds";
    repo   = "gls";
  };

  ugorji.go = buildFromGitHub {
    owner = "ugorji";
    repo = "go";
    goPackageAliases = [ "github.com/hashicorp/go-msgpack" ];
  };

  goamz = buildFromGitHub {
    owner  = "goamz";
    repo   = "goamz";
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
    owner  = "dgnorton";
    repo   = "goback";
  };

  gocryptfs = buildFromGitHub {
    owner = "rfjakob";
    repo = "gocryptfs";
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
    owner  = "gocql";
    repo   = "gocql";
    propagatedBuildInputs = [ inf snappy groupcache ];
  };

  gocode = buildFromGitHub {
    date = "2015-09-03";
    owner = "nsf";
    repo = "gocode";
  };

  gocolorize = buildFromGitHub rec {
    owner = "agtorre";
    repo = "gocolorize";
    goPackagePath = "github.com/agtorre/gocolorize";
  };

  goconvey = buildFromGitHub rec {
    owner = "smartystreets";
    repo = "goconvey";
    buildInputs = [ oglematchers ];
    doCheck = false; # please check again
  };

  gohtml = buildFromGitHub {
    owner  = "yosssi";
    repo   = "gohtml";
    propagatedBuildInputs = [ net ];
  };

  gomdb = buildFromGitHub {
    owner  = "armon";
    repo   = "gomdb";
  };

  influx.gomdb = buildFromGitHub {
    owner  = "influxdb";
    repo   = "gomdb";
  };

  gotty = buildFromGitHub {
    owner   = "yudai";
    repo    = "gotty";

    buildInputs = [ cli-go go manners go-bindata-assetfs go-multierror structs websocket hcl pty ];

    meta = with stdenv.lib; {
      description = "Share your terminal as a web application";
      homepage = "https://github.com/yudai/gotty";
      maintainers = with maintainers; [ matthiasbeyer ];
      license = licenses.mit;
    };
  };

  govers = buildFromGitHub {
    date = "2015-01-09";
    owner = "rogpeppe";
    repo = "govers";
    dontRenameImports = true;
  };

  golang-lru = buildFromGitHub {
    owner  = "hashicorp";
    repo   = "golang-lru";
  };

  golang-petname = buildFromGitHub {
    owner  = "dustinkirkland";
    repo   = "golang-petname";
  };

  golang_protobuf_extensions = buildFromGitHub {
    date   = "2015-04-06";
    owner  = "matttproud";
    repo   = "golang_protobuf_extensions";
    buildInputs = [ protobuf ];
  };

  goleveldb = buildFromGitHub {
    date = "2015-08-19";
    owner = "syndtr";
    repo = "goleveldb";
    propagatedBuildInputs = [ ginkgo gomega snappy ];
  };

  gollectd = buildFromGitHub {
    owner  = "kimor79";
    repo   = "gollectd";
  };

  gomega = buildFromGitHub {
    owner  = "onsi";
    repo   = "gomega";
  };

  gomemcache = buildFromGitHub {
    owner  = "bradfitz";
    repo   = "gomemcache";
  };

  google-api-go-client = buildFromGitHub {
    date = "2015-08-19";
    owner = "google";
    repo = "google-api-go-client";
    goPackagePath = "google.golang.org/api";
    goPackageAliases = [ "github.com/google/google-api-client" ];
    buildInputs = [ net ];
  };

  odeke-em.google-api-go-client = buildFromGitHub {
    owner = "odeke-em";
    repo = "google-api-go-client";
    buildInputs = [ net ];
    propagatedBuildInputs = [ google-api-go-client ];
  };

  gopass = buildFromGitHub {
    owner = "howeyc";
    repo = "gopass";
    propagatedBuildInputs = [ crypto ];
  };

  gopherduty = buildFromGitHub {
    owner  = "darkcrux";
    repo   = "gopherduty";
  };

  goproxy = buildFromGitHub {
    date   = "2015-07-26";
    owner  = "elazarl";
    repo   = "goproxy";
    buildInputs = [ go-charset ];
  };

  goreq = buildFromGitHub {
    date   = "2015-08-18";
    owner  = "franela";
    repo   = "goreq";
  };

  gotags = buildFromGitHub {
    date   = "2015-08-03";
    owner  = "jstemmer";
    repo   = "gotags";
  };

  gosnappy = buildFromGitHub {
    owner  = "syndtr";
    repo   = "gosnappy";
  };

  gox = buildFromGitHub {
    owner  = "mitchellh";
    repo   = "gox";
    buildInputs = [ iochan ];
  };

  gozim = buildFromGitHub {
    date   = "2016-01-15";
    owner  = "akhenakh";
    repo   = "gozim";
    propagatedBuildInputs = [ bleve go-liblzma groupcache go-rice goquery ];
    buildInputs = [ pkgs.zip ];
    postInstall = ''
      pushd $NIX_BUILD_TOP/go/src/$goPackagePath/cmd/gozimhttpd
      ${go-rice.bin}/bin/rice append --exec $bin/bin/gozimhttpd
      popd
    '';
    dontStrip = true;
  };

  go-assert = buildFromGitHub {
    owner = "bmizerany";
    repo = "assert";
    propagatedBuildInputs = [ pretty ];
  };

  go-backblaze = buildFromGitHub {
    owner = "kothar";
    repo = "go-backblaze";
    buildInputs = [ go-flags go-humanize uilive uiprogress ];
    goPackagePath = "gopkg.in/kothar/go-backblaze.v0";
  };

  go-bencode = buildFromGitHub {
    owner = "ehmry";
    repo = "go-bencode";
  };

  go-bindata = buildFromGitHub rec {
    owner = "jteeuwen";
    repo = "go-bindata";
    date = "2015-10-23";

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
    owner   = "elazarl";
    repo    = "go-bindata-assetfs";

    date = "2015-08-13";

    meta = with stdenv.lib; {
      description = "Serves embedded files from jteeuwen/go-bindata with net/http";
      homepage = "https://github.com/elazarl/go-bindata-assetfs";
      maintainers = with maintainers; [ matthiasbeyer ];
      license = licenses.bsd2;
    };
  };

  pmylund.go-cache = buildFromGitHub {
    owner = "pmylund";
    repo = "go-cache";
    goPackageAliases = [
      "github.com/robfig/go-cache"
      "github.com/influxdb/go-cache"
    ];
  };

  robfig.go-cache = buildFromGitHub {
    owner  = "robfig";
    repo   = "go-cache";
  };

  go-charset = buildFromGitHub {
    date   = "2014-07-13";
    owner  = "paulrosania";
    repo   = "go-charset";
    goPackagePath = "code.google.com/p/go-charset";

    preBuild = ''
      find go/src/$goPackagePath -name \*.go | xargs sed -i 's,github.com/paulrosania/go-charset,code.google.com/p/go-charset,g'
    '';
  };

  go-checkpoint = buildFromGitHub {
    owner  = "hashicorp";
    repo   = "go-checkpoint";
  };

  go-colorable = buildFromGitHub {
    owner  = "mattn";
    repo   = "go-colorable";
  };

  go-colortext = buildFromGitHub {
    owner  = "daviddengcn";
    repo   = "go-colortext";
  };

  go-etcd = buildFromGitHub {
    owner = "coreos";
    repo = "go-etcd";
    propagatedBuildInputs = [ ugorji.go ];
  };

  go-flags = buildFromGitHub {
    owner  = "jessevdk";
    repo   = "go-flags";
  };

  go-fuse = buildFromGitHub rec {
    date = "2015-07-27";
    owner = "hanwen";
    repo = "go-fuse";
  };

  go-github = buildFromGitHub {
    owner = "google";
    repo = "go-github";
    buildInputs = [ oauth2 ];
    propagatedBuildInputs = [ go-querystring ];
  };

  go-gtk-agl = buildFromGitHub {
    owner = "agl";
    repo = "go-gtk";
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
    owner  = "kylelemons";
    repo   = "go-gypsy";
  };

  go-homedir = buildFromGitHub {
    owner  = "mitchellh";
    repo   = "go-homedir";
  };

  go-hostpool = buildFromGitHub {
    date   = "2015-03-31";
    owner  = "bitly";
    repo   = "go-hostpool";
  };

  go-humanize = buildFromGitHub {
    owner = "dustin";
    repo = "go-humanize";
  };

  go-ini = buildFromGitHub {
    owner  = "vaughan0";
    repo   = "go-ini";
  };

  go-incremental = buildFromGitHub {
    date   = "2015-02-20";
    owner  = "GeertJohan";
    repo   = "go.incremental";
  };

  go-isatty = buildFromGitHub {
    owner  = "mattn";
    repo   = "go-isatty";
  };

  go-liblzma = buildFromGitHub {
    date   = "2016-01-01";
    owner  = "remyoudompheng";
    repo   = "go-liblzma";
    propagatedBuildInputs = [ pkgs.lzma ];
  };

  go-log = buildFromGitHub {
    owner = "coreos";
    repo = "go-log";
    propagatedBuildInputs = [ osext go-systemd ];
  };

  go-lxc = buildFromGitHub {
    owner  = "lxc";
    repo   = "go-lxc";
    goPackagePath = "gopkg.in/lxc/go-lxc.v2";
    nativeBuildInputs = [ pkgs.pkgconfig ];
    buildInputs = [ pkgs.lxc ];
  };

  go-lz4 = buildFromGitHub {
    owner  = "bkaradzic";
    repo   = "go-lz4";
  };

  rcrowley.go-metrics = buildFromGitHub {
    date = "2015-08-22";
    owner = "rcrowley";
    repo = "go-metrics";
    propagatedBuildInputs = [ stathat ];
  };

  appengine = buildFromGitHub {
    owner = "golang";
    repo = "appengine";
    goPackagePath = "google.golang.org/appengine";
    buildInputs = [ protobuf net ];
  };

  armon.go-metrics = buildFromGitHub {
    owner = "armon";
    repo = "go-metrics";
    propagatedBuildInputs = [ prometheus.client_golang ];
  };

  go-md2man = buildFromGitHub {
    owner  = "cpuguy83";
    repo   = "go-md2man";
    propagatedBuildInputs = [ blackfriday ];
  };

  go-multierror = buildFromGitHub {
    owner  = "hashicorp";
    repo   = "go-multierror";
  };

  go-nsq = buildFromGitHub {
    owner = "nsqio";
    repo = "go-nsq";
    propagatedBuildInputs = [ go-simplejson go-snappystream ];
    goPackageAliases = [ "github.com/bitly/go-nsq" ];
  };

  go-options = buildFromGitHub {
    date   = "2014-12-20";
    owner  = "mreiferson";
    repo   = "go-options";
  };

  go-porterstemmer = buildFromGitHub {
    date   = "2014-12-30";
    owner  = "blevesearch";
    repo   = "go-porterstemmer";
  };

  go-querystring = buildFromGitHub {
    owner  = "google";
    repo   = "go-querystring";
  };

  go-radix = buildFromGitHub {
    owner  = "armon";
    repo   = "go-radix";
  };

  junegunn.go-runewidth = buildFromGitHub {
    owner = "junegunn";
    repo = "go-runewidth";
  };

  go-shellwords = buildFromGitHub {
    owner = "junegunn";
    repo = "go-shellwords";
  };

  go-restful = buildFromGitHub {
    owner  = "emicklei";
    repo   = "go-restful";
  };

  go-repo-root = buildFromGitHub {
    date = "2014-09-11";
    owner = "cstrahan";
    repo = "go-repo-root";
    buildInputs = [ tools ];
  };

  go-rice = buildFromGitHub {
    date   = "2016-01-04";
    owner  = "GeertJohan";
    repo   = "go.rice";
    propagatedBuildInputs = [ osext go-spew go-flags go-zipexe rsrc
      go-incremental ];
  };

  go-runit = buildFromGitHub {
    owner  = "soundcloud";
    repo   = "go-runit";
  };

  go-simplejson = buildFromGitHub {
    date   = "2015-03-31";
    owner  = "bitly";
    repo   = "go-simplejson";
  };

  go-snappystream = buildFromGitHub {
    date = "2015-04-16";
    owner = "mreiferson";
    repo = "go-snappystream";
  };

  go-spew = buildFromGitHub {
    date   = "2015-11-05";
    owner  = "davecgh";
    repo   = "go-spew";
  };

  go-sqlite3 = buildFromGitHub {
    date   = "2015-07-29";
    owner  = "mattn";
    repo   = "go-sqlite3";
  };

  go-syslog = buildFromGitHub {
    owner  = "hashicorp";
    repo   = "go-syslog";
  };

  go-systemd = buildFromGitHub {
    owner = "coreos";
    repo = "go-systemd";
    buildInputs = [ dbus ];
  };

  lxd-go-systemd = buildFromGitHub {
    date = "2015-07-01";
    owner = "stgraber";
    repo = "lxd-go-systemd";
    buildInputs = [ dbus ];
  };

  go-update-v0 = buildFromGitHub {
    owner = "inconshreveable";
    repo = "go-update";
    goPackagePath = "gopkg.in/inconshreveable/go-update.v0";
    buildInputs = [ osext binarydist ];
  };

  go-uuid = buildFromGitHub {
    date   = "2015-07-22";
    owner  = "satori";
    repo   = "go.uuid";
  };

  go-vhost = buildFromGitHub {
    owner  = "inconshreveable";
    repo   = "go-vhost";
  };

  go-zipexe = buildFromGitHub {
    date   = "2015-03-29";
    owner  = "daaku";
    repo   = "go.zipexe";
  };

  go-zookeeper = buildFromGitHub {
    date   = "2015-06-02";
    owner  = "samuel";
    repo   = "go-zookeeper";
  };

  lint = buildFromGitHub {
    date = "2015-06-23";
    owner = "golang";
    repo = "lint";
    excludedPackages = "testdata";
    buildInputs = [ tools ];
  };

  goquery = buildFromGitHub {
    owner = "PuerkitoBio";
    repo = "goquery";
    propagatedBuildInputs = [ cascadia net ];
    buildInputs = [ cascadia net ];
    doCheck = true;
  };

  groupcache = buildFromGitHub {
    owner  = "golang";
    repo   = "groupcache";
    buildInputs = [ protobuf ];
  };

  grpc = buildFromGitHub {
    date = "2015-08-29";
    owner = "grpc";
    repo = "grpc-go";
    goPackagePath = "google.golang.org/grpc";
    goPackageAliases = [ "github.com/grpc/grpc-go" ];
    propagatedBuildInputs = [ http2 net protobuf oauth2 glog etcd ];
    excludedPackages = "\\(test\\|benchmark\\)";
  };

  gtreap = buildFromGitHub {
    date = "2015-08-07";
    owner = "steveyen";
    repo = "gtreap";
    goPackagePath = "github.com/steveyen/gtreap";
  };

  gucumber = buildFromGitHub {
    owner = "lsegal";
    repo = "gucumber";
    buildInputs = [ testify ];
    propagatedBuildInputs = [ ansicolor ];
  };

  hcl = buildFromGitHub {
    owner  = "hashicorp";
    repo   = "hcl";
    buildInputs = [ go-multierror ];
  };

  hipchat-go = buildFromGitHub {
    owner = "tbruyelle";
    repo = "hipchat-go";
  };

  hmacauth = buildFromGitHub {
    owner = "18F";
    repo = "hmacauth";
  };

  hound = buildFromGitHub {
    owner = "etsy";
    repo = "hound";
    buildInputs = [ go-bindata.bin pkgs.nodejs pkgs.nodePackages.react-tools pkgs.python pkgs.rsync ];
    postInstall = ''
      pushd go
      python src/github.com/etsy/hound/tools/setup
      sed -i 's|bin/go-bindata||' Makefile
      sed -i 's|$<|#go-bindata|' Makefile
      make
    '';
  };

  hologram = buildFromGitHub {
    owner = "AdRoll";
    repo = "hologram";
    buildInputs = [ crypto protobuf goamz rgbterm go-bindata go-homedir ldap g2s gox ];
  };

  http2 = buildFromGitHub rec {
    owner = "bradfitz";
    repo = "http2";
    buildInputs = [ crypto ];
  };

  httprouter = buildFromGitHub {
    date   = "2015-07-08";
    owner  = "julienschmidt";
    repo   = "httprouter";
  };

  hugo = buildFromGitHub {
    owner  = "spf13";
    repo   = "hugo";
    buildInputs = [
      mapstructure text websocket cobra osext fsnotify.v1 afero
      jwalterweatherman cast viper yaml-v2 ace purell mmark blackfriday amber
      cssmin nitro inflect fsync
    ];
  };

  i3cat = buildFromGitHub {
    date   = "2015-03-21";
    owner  = "vincent-petithory";
    repo   = "i3cat";
    buildInputs = [ structfield ];
  };

  inf = buildFromGitHub {
    owner  = "go-inf";
    repo   = "inf";
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
    owner = "influxdb";
    repo = "influxdb";
    subPackages = [ "client" ];
  };

  eckardt.influxdb-go = buildFromGitHub {
    owner = "eckardt";
    repo = "influxdb-go";
  };

  flagfile = buildFromGitHub {
    owner  = "spacemonkeygo";
    repo   = "flagfile";
  };

  iochan = buildFromGitHub {
    owner  = "mitchellh";
    repo   = "iochan";
  };

  ipfs = buildFromGitHub{
    date   = "2016-01-12";
    owner  = "ipfs";
    repo   = "go-ipfs";
    disabled = isGo14;
    meta = with stdenv.lib; {
      description = "A global, versioned, peer-to-peer filesystem";
      license = licenses.mit;
    };
  };

  json2csv = buildFromGitHub{
    owner  = "jehiah";
    repo   = "json2csv";
  };

  jwalterweatherman = buildFromGitHub {
    owner  = "spf13";
    repo   = "jwalterweatherman";
  };

  kagome = buildFromGitHub {
    date = "2016-01-19";
    owner = "ikawaha";
    repo = "kagome";

    # I disable the parallel building, because otherwise each
    # spawned compile takes over 1.5GB of RAM.
    buildFlags = "-p 1";
    enableParallelBuilding = false;

    goPackagePath = "github.com/ikawaha/kagome";
  };

  ldap = buildFromGitHub {
    owner = "go-ldap";
    repo = "ldap";
    goPackageAliases = [
      "github.com/nmcclain/ldap"
      "github.com/vanackere/ldap"
    ];
    propagatedBuildInputs = [ asn1-ber ];
  };

  levigo = buildFromGitHub {
    owner = "jmhodges";
    repo = "levigo";
    buildInputs = [ pkgs.leveldb ];
  };

  liner = buildFromGitHub {
    owner  = "peterh";
    repo   = "liner";
  };

  odeke-em.log = buildFromGitHub {
    owner  = "odeke-em";
    repo   = "log";
  };

  log15 = buildFromGitHub {
    owner  = "inconshreveable";
    repo   = "log15";
    goPackagePath = "gopkg.in/inconshreveable/log15.v2";
    propagatedBuildInputs = [ go-colorable ];
  };

  log4go = buildFromGitHub {
    owner = "ccpaging";
    repo = "log4go";
    goPackageAliases = [
      "github.com/alecthomas/log4go"
      "code.google.com/p/log4go"
    ];
    propagatedBuildInputs = [ go-colortext ];
  };

  logger = buildFromGitHub {
    date = "2015-05-23";
    owner = "calmh";
    repo = "logger";
  };

  logrus = buildFromGitHub rec {
    owner = "Sirupsen";
    repo = "logrus";
    propagatedBuildInputs = [ airbrake-go bugsnag-go raven-go ];
  };

  logutils = buildFromGitHub {
    owner  = "hashicorp";
    repo   = "logutils";
  };

  luhn = buildFromGitHub {
    date   = "2015-01-13";
    owner  = "calmh";
    repo   = "luhn";
  };

  lxd = buildFromGitHub {
    owner  = "lxc";
    repo   = "lxd";
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

  manners = buildFromGitHub {
    owner = "braintree";
    repo = "manners";

    meta = with stdenv.lib; {
      description = "A polite Go HTTP server that shuts down gracefully";
      homepage = "https://github.com/braintree/manners";
      maintainers = with maintainers; [ matthiasbeyer ];
      license = licenses.mit;
    };
  };

  mapstructure = buildFromGitHub {
    owner  = "mitchellh";
    repo   = "mapstructure";
  };

  mdns = buildFromGitHub {
    owner = "hashicorp";
    repo = "mdns";
    propagatedBuildInputs = [ net dns ];
  };

  memberlist = buildFromGitHub {
    owner = "hashicorp";
    repo = "memberlist";
    propagatedBuildInputs = [ ugorji.go armon.go-metrics ];
  };

  memberlist_v2 = buildFromGitHub {
    owner = "hashicorp";
    repo = "memberlist";
    propagatedBuildInputs = [ ugorji.go armon.go-metrics ];
  };

  mesos-dns = buildFromGitHub {
    owner = "mesosphere";
    repo = "mesos-dns";

    # Avoid including the benchmarking test helper in the output:
    subPackages = [ "." ];

    buildInputs = [ glog mesos-go dns go-restful ];
  };

  mesos-go = buildFromGitHub {
    owner = "mesos";
    repo = "mesos-go";
    propagatedBuildInputs = [ gogo.protobuf glog net testify go-zookeeper objx uuid ];
    excludedPackages = "test";
  };

  mesos-stats = buildFromGitHub {
    owner = "antonlindstrom";
    repo = "mesos_stats";
  };

  mgo = buildFromGitHub {
    owner = "go-mgo";
    repo = "mgo";
    goPackagePath = "gopkg.in/mgo.v2";
    goPackageAliases = [ "github.com/go-mgo/mgo" ];
    buildInputs = [ pkgs.cyrus_sasl tomb ];
  };

  mmark = buildFromGitHub {
    owner  = "miekg";
    repo   = "mmark";
    buildInputs = [ toml ];
  };

  mongo-tools = buildFromGitHub {
    owner  = "mongodb";
    repo   = "mongo-tools";
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
    owner  = "inconshreveable";
    repo   = "mousetrap";
  };

  msgpack = buildFromGitHub {
    owner = "vmihailenco";
    repo = "msgpack";
    goPackagePath = "gopkg.in/vmihailenco/msgpack.v2";
  };

  mtpfs = buildFromGitHub {
    date = "2015-08-01";
    owner = "hanwen";
    repo = "go-mtpfs";
    buildInputs = [ go-fuse usb ];
  };

  mux = buildFromGitHub {
    date = "2015-08-05";
    owner = "gorilla";
    repo = "mux";
    propagatedBuildInputs = [ context ];
  };

  muxado = buildFromGitHub {
    owner  = "inconshreveable";
    repo   = "muxado";
  };

  mysql = buildFromGitHub {
    owner  = "go-sql-driver";
    repo   = "mysql";
  };

  net-rpc-msgpackrpc = buildFromGitHub {
    owner = "hashicorp";
    repo = "net-rpc-msgpackrpc";
    propagatedBuildInputs = [ ugorji.go ];
  };

  ngrok = buildFromGitHub {
    owner = "inconshreveable";
    repo = "ngrok";
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
    owner  = "spf13";
    repo   = "nitro";
  };

  nsq = buildFromGitHub {
    owner = "bitly";
    repo = "nsq";

    excludedPackages = "bench";

    buildInputs = [ go-nsq go-options semver perks toml go-hostpool timer_metrics ];
  };

  ntp = buildFromGitHub {
    owner  = "beevik";
    repo   = "ntp";
  };

  oauth2_proxy = buildFromGitHub {
    name = "oauth2_proxy";
    owner = "bitly";
    repo = "oauth2_proxy";
    buildInputs = [
      go-assert go-options go-simplejson toml fsnotify.v1 oauth2
      google-api-go-client hmacauth
    ];
  };

  objx = buildFromGitHub {
    owner  = "stretchr";
    repo   = "objx";
  };

  oglematchers = buildFromGitHub {
    owner = "jacobsa";
    repo = "oglematchers";
    #goTestInputs = [ ogletest ];
    doCheck = false; # infinite recursion
  };

  oglemock = buildFromGitHub {
    owner = "jacobsa";
    repo = "oglemock";
    buildInputs = [ oglematchers ];
    #goTestInputs = [ ogletest ];
  };

  ogletest = buildFromGitHub {
    owner = "jacobsa";
    repo = "ogletest";
    buildInputs = [ oglemock oglematchers ];
    doCheck = false; # check this again
  };

  oh = buildFromGitHub {
    date = "2016-02-23";
    owner = "michaelmacinnis";
    repo = "oh";
    goPackageAliases = [ "github.com/michaelmacinnis/oh" ];
    buildInputs = [ adapted liner ];
    disabled = isGo14;
  };

  openssl = buildFromGitHub {
    owner = "10gen";
    repo = "openssl";
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
    owner = "spacemonkeygo";
    repo = "openssl";
    nativeBuildInputs = [ pkgs.pkgconfig ];
    buildInputs = [ pkgs.openssl ];
    propagatedBuildInputs = [ spacelog ];
  };

  opsgenie-go-sdk = buildFromGitHub {
    date = "2015-08-24";
    owner = "opsgenie";
    repo = "opsgenie-go-sdk";
    propagatedBuildInputs = [ seelog go-querystring goreq ];
    excludedPackages = "samples";
  };

  osext = buildFromGitHub {
    owner = "kardianos";
    repo = "osext";
    goPackageAliases = [
      "github.com/bugsnag/osext"
      "bitbucket.org/kardianos/osext"
    ];
  };

  pat = buildFromGitHub {
    owner  = "bmizerany";
    repo   = "pat";
  };

  pathtree = buildFromGitHub {
    owner  = "robfig";
    repo   = "pathtree";
  };

  panicwrap = buildFromGitHub {
    owner = "bugsnag";
    repo = "panicwrap";
    propagatedBuildInputs = [ osext ];
  };

  pb = buildFromGitHub {
    owner  = "cheggaaa";
    repo   = "pb";
  };

  perks = buildFromGitHub {
    date   = "2014-07-16";
    owner  = "bmizerany";
    repo   = "perks";
  };

  beorn7.perks = buildFromGitHub rec {
    date   = "2015-02-23";
    owner  = "beorn7";
    repo   = "perks";
  };

  # XXX: why have does pflag seem to be a dupe of pflag-spf13?
  pflag = buildFromGitHub {
    date = "20131112";
    rev = "94e98a55fb412fcbcfc302555cb990f5e1590627";
    owner = "spf13";
    repo = "pflag";
    sha256 = "0z8nzdhj8nrim8fz11magdl0wxnisix9p2kcvn5kkb3bg8wmxhbg";
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
    owner = "agl";
    repo = "pond";

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
    date   = "2014-10-27";
    owner  = "flosch";
    repo   = "pongo2";
    goPackagePath = "gopkg.in/flosch/pongo2.v3";
  };

  pool = buildFromGitHub {
    owner = "fatih";
    repo = "pool";
    goPackagePath = "gopkg.in/fatih/pool.v2";
  };

  pq = buildFromGitHub {
    owner  = "lib";
    repo   = "pq";
  };

  pretty = buildFromGitHub {
    owner = "kr";
    repo = "pretty";
    propagatedBuildInputs = [ kr.text ];
  };

  prometheus.alertmanager = buildFromGitHub rec {
    rev = ghPackages.prometheus.alertmanager.rev;
    owner = "prometheus";
    repo = "alertmanager";

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
    owner = "prometheus";
    repo = "client_golang";
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
    owner = "prometheus";
    repo = "prometheus_cli";

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
    date   = "2015-02-12";
    owner  = "prometheus";
    repo   = "client_model";
    buildInputs = [ protobuf ];
  };

  prometheus.collectd-exporter = buildFromGitHub {
    owner = "prometheus";
    repo = "collectd_exporter";
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
    owner = "prometheus";
    repo = "haproxy_exporter";
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
    date   = "2015-05-29";
    owner  = "prometheus";
    repo   = "log";
    propagatedBuildInputs = [ logrus ];
  };

  prometheus.mesos-exporter = buildFromGitHub {
    owner = "prometheus";
    repo = "mesos_exporter";
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
    owner = "prometheus";
    repo = "mysqld_exporter";
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
    date = "2015-06-01";
    owner = "discordianfish";
    repo = "nginx_exporter";
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
    owner = "prometheus";
    repo = "node_exporter";

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
    date   = "2015-06-16";
    owner  = "prometheus";
    repo   = "procfs";
  };

  prometheus.prom2json = buildFromGitHub {
    owner = "prometheus";
    repo = "prom2json";

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
    rev = ghPackages.prometheus.prometheus.rev;
    owner = "prometheus";
    repo = "prometheus";

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
    rev = ghPackages.prometheus.pushgateway.rev;
    owner = "prometheus";
    repo = "pushgateway";

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
    owner = "prometheus";
    repo = "statsd_bridge";
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
    owner  = "magiconair";
    repo   = "properties";
  };

  gogo.protobuf = buildFromGitHub {
    owner = "gogo";
    repo = "protobuf";
    excludedPackages = "test";
    goPackageAliases = [
      "code.google.com/p/gogoprotobuf"
    ];
  };

  pty = buildFromGitHub {
    owner  = "kr";
    repo   = "pty";
  };

  purell = buildFromGitHub {
    owner  = "PuerkitoBio";
    repo   = "purell";
    propagatedBuildInputs = [ urlesc ];
  };

  pushover = buildFromGitHub {
    owner  = "thorduri";
    repo   = "pushover";
  };

  qart = buildFromGitHub {
    owner  = "vitrun";
    repo   = "qart";
  };

  raft = buildFromGitHub rec {
    owner  = "hashicorp";
    repo   = "raft";
    propagatedBuildInputs = [ armon.go-metrics ugorji.go ];
  };

  raft-boltdb = buildFromGitHub {
    owner  = "hashicorp";
    repo   = "raft-boltdb";
    propagatedBuildInputs = [ bolt ugorji.go raft ];
  };

  raft-mdb = buildFromGitHub {
    owner  = "hashicorp";
    repo   = "raft-mdb";
    propagatedBuildInputs = [ gomdb ugorji.go raft ];
  };

  ratelimit = buildFromGitHub {
    date   = "2015-06-19";
    owner  = "juju";
    repo   = "ratelimit";
  };

  raw = buildFromGitHub {
    owner  = "feyeleanor";
    repo   = "raw";
  };

  raven-go = buildFromGitHub {
    date   = "2015-07-21";
    owner  = "getsentry";
    repo   = "raven-go";
  };

  redigo = buildFromGitHub {
    owner  = "garyburd";
    repo   = "redigo";
  };

  relaysrv = buildFromGitHub {
    owner  = "syncthing";
    repo   = "relaysrv";
    buildInputs = [ xdr syncthing-protocol011 ratelimit syncthing-lib ];
  };

  reflectwalk = buildFromGitHub {
    owner  = "mitchellh";
    repo   = "reflectwalk";
  };

  revel = buildFromGitHub {
    owner  = "revel";
    repo   = "revel";
    # Using robfig's old go-cache due to compilation errors.
    # Try to switch to pmylund.go-cache after v0.12.0
    propagatedBuildInputs = [
      gocolorize config net pathtree fsnotify.v1 robfig.go-cache redigo gomemcache
    ];
  };

  restic = buildFromGitHub {
    date   = "2016-01-17";
    owner  = "restic";
    repo   = "restic";
    # Using its delivered dependencies. Easier.
    preBuild = "export GOPATH=$GOPATH:$NIX_BUILD_TOP/go/src/$goPackagePath/Godeps/_workspace";
  };

  rgbterm = buildFromGitHub {
    owner  = "aybabtme";
    repo   = "rgbterm";
  };

  ripper = buildFromGitHub {
    owner  = "odeke-em";
    repo   = "ripper";
  };

  rsrc = buildFromGitHub {
    date   = "2015-11-03";
    owner  = "akavel";
    repo   = "rsrc";
  };

  sandblast = buildFromGitHub {
    owner  = "aarzilli";
    repo   = "sandblast";
    buildInputs = [ net text ];
  };

  # This is the upstream package name, underscores and all. I don't like it
  # but it seems wrong to change their name when packaging it.
  sanitized_anchor_name = buildFromGitHub {
    owner  = "shurcooL";
    repo   = "sanitized_anchor_name";
  };

  scada-client = buildFromGitHub {
    owner  = "hashicorp";
    repo   = "scada-client";
    buildInputs = [ armon.go-metrics net-rpc-msgpackrpc yamux ];
  };

  seelog = buildFromGitHub {
    date = "2015-05-26";
    owner = "cihub";
    repo = "seelog";
  };

  segment = buildFromGitHub {
    date   = "2016-01-05";
    owner  = "blevesearch";
    repo   = "segment";
  };

  semver = buildFromGitHub {
    date = "2015-07-20";
    owner = "blang";
    repo = "semver";
  };

  serf = buildFromGitHub {
    date = "2015-05-15";
    owner  = "hashicorp";
    repo   = "serf";

    buildInputs = [
      circbuf armon.go-metrics ugorji.go go-syslog logutils mdns memberlist
      cli mapstructure columnize
    ];
  };

  sets = buildFromGitHub {
    owner  = "feyeleanor";
    repo   = "sets";
    propagatedBuildInputs = [ slices ];
  };

  skydns = buildFromGitHub {
    owner = "skynetservices";
    repo = "skydns";
    buildInputs = [
      go-etcd rcrowley.go-metrics dns go-systemd prometheus.client_golang
    ];
  };

  slices = buildFromGitHub {
    owner = "feyeleanor";
    repo = "slices";
    propagatedBuildInputs = [ raw ];
  };

  spacelog = buildFromGitHub {
    owner = "spacemonkeygo";
    repo = "spacelog";
    buildInputs = [ flagfile ];
  };

  stathat = buildFromGitHub {
    owner = "stathat";
    repo = "go";
  };

  statos = buildFromGitHub {
    owner  = "odeke-em";
    repo   = "statos";
  };

  statik = buildFromGitHub {
    owner = "rakyll";
    repo = "statik";
    excludedPackages = "example";
  };

  structfield = buildFromGitHub {
    date   = "2014-08-01";
    owner  = "vincent-petithory";
    repo   = "structfield";
  };

  structs = buildFromGitHub {
    owner  = "fatih";
    repo   = "structs";
  };

  suture = buildFromGitHub {
    owner  = "thejerf";
    repo   = "suture";
  };

  syncthing = buildFromGitHub rec {
    version = "0.12.19";
    owner = "syncthing";
    repo = "syncthing";
    buildFlags = [ "-tags noupgrade,release" ];
    disabled = isGo14;
    buildInputs = [
      go-lz4 du luhn xdr snappy ratelimit osext
      goleveldb suture qart crypto net text rcrowley.go-metrics
    ];
    # TODO: find a way to automatically update the veresion here:
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
    inherit (syncthing) owner repo src;
    subPackages = [ "lib/sync" ];
    propagatedBuildInputs = syncthing.buildInputs;
  };

  syncthing-protocol = buildFromGitHub {
    inherit (syncthing) owner repo src;
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
    date = "2015-08-28";
    owner = "syncthing";
    repo = "protocol";
    sha256 = "07xjs43lpd51pc339f8x487yhs39riysj3ifbjxsx329kljbflwx";
    propagatedBuildInputs = [ go-lz4 logger luhn xdr text ];
  };

  tablewriter = buildFromGitHub {
    date   = "2015-06-03";
    owner  = "olekukonko";
    repo   = "tablewriter";
  };

  termbox-go = buildFromGitHub {
    owner = "nsf";
    repo = "termbox-go";
    subPackages = [ "./" ]; # prevent building _demos
  };

  testify = buildFromGitHub {
    owner = "stretchr";
    repo = "testify";
    buildInputs = [ objx ];
  };

  kr.text = buildFromGitHub {
    owner = "kr";
    repo = "text";
    propagatedBuildInputs = [ pty ];
  };

  timer_metrics = buildFromGitHub {
    date = "2015-02-02";
    owner = "bitly";
    repo = "timer_metrics";
  };

  tomb = buildFromGitHub {
    owner = "go-tomb";
    repo = "tomb";
    goPackagePath = "gopkg.in/tomb.v2";
    goPackageAliases = [ "github.com/go-tomb/tomb" ];
  };

  toml = buildFromGitHub {
    date   = "2015-05-01";
    owner  = "BurntSushi";
    repo   = "toml";
  };

  uilive = buildFromGitHub {
    owner = "gosuri";
    repo = "uilive";
  };

  uiprogress = buildFromGitHub {
    buildInputs = [ uilive ];
    owner = "gosuri";
    repo = "uiprogress";
  };

  urlesc = buildFromGitHub {
    owner  = "opennota";
    repo   = "urlesc";
  };

  usb = buildFromGitHub rec {
    date = "2014-12-17";
    owner = "hanwen";
    repo = "usb";

    nativeBuildInputs = [ pkgs.pkgconfig ];
    buildInputs = [ pkgs.libusb1 ];
  };

  uuid = buildFromGitHub {
    date = "2015-08-24";
    owner = "pborman";
    repo = "uuid";
  };

  vault = buildFromGitHub {
    owner = "hashicorp";
    repo = "vault";

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
    owner  = "Masterminds";
    repo   = "vcs";
  };

  viper = buildFromGitHub {
    owner  = "spf13";
    repo   = "viper";
    propagatedBuildInputs = [
      mapstructure yaml-v2 jwalterweatherman crypt fsnotify.v1 cast properties
      pretty toml pflag-spf13
    ];
  };

  vulcand = buildFromGitHub rec {
    owner = "mailgun";
    repo = "vulcand";
    goPackagePath = "github.com/mailgun/vulcand";
    preBuild = "export GOPATH=$GOPATH:$NIX_BUILD_TOP/go/src/$goPackagePath/Godeps/_workspace";
    subPackages = [ "./" ];
  };

  websocket = buildFromGitHub {
    owner  = "gorilla";
    repo   = "websocket";
  };

  xmpp-client = buildFromGitHub {
    date     = "2016-01-10";
    owner    = "agl";
    repo     = "xmpp-client";
    disabled = isGo14;
    buildInputs = [ crypto net ];

    meta = with stdenv.lib; {
      description = "An XMPP client with OTR support";
      homepage = https://github.com/agl/xmpp-client;
      license = licenses.bsd3;
      maintainers = with maintainers; [ codsl ];
    };
  };

  # TODO(cstrahan): find a way to automate this pattern of gopkg.in/yaml.vX
  # packages.
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
    owner  = "hashicorp";
    repo   = "yamux";
  };

  xdr = buildFromGitHub {
    date   = "2015-04-08";
    owner  = "calmh";
    repo   = "xdr";
  };

  xon = buildFromGitHub {
    owner  = "odeke-em";
    repo   = "xon";
  };

  ninefans = buildFromGitHub {
    date   = "2015-10-24";
    owner  = "9fans";
    repo   = "go";
    goPackagePath = "9fans.net/go";
    goPackageAliases = [
      "github.com/9fans/go"
    ];
    excludedPackages = "\\(plan9/client/cat\\|acme/Watch\\)";
    buildInputs = [ net ];
  };

  godef = buildFromGitHub {
    date   = "2015-10-24";
    owner  = "rogpeppe";
    repo   = "godef";
    excludedPackages = "\\(go/printer/testdata\\)";
    buildInputs = [ ninefans ];
    subPackages = [ "./" ];
  };

  godep = buildFromGitHub {
    date   = "2015-10-15";
    owner  = "tools";
    repo   = "godep";
  };

  color = buildFromGitHub {
    owner    = "fatih";
    repo     = "color";
    propagatedBuildInputs = [ net go-isatty ];
    buildInputs = [ ansicolor go-colorable ];
  };

  pup = buildFromGitHub {
    owner    = "EricChiang";
    repo     = "pup";
    propagatedBuildInputs = [ net ];
    buildInputs = [ go-colorable color ];
    postPatch = ''
      grep -sr github.com/ericchiang/pup/Godeps/_workspace/src/ |
        cut -f 1 -d : |
        sort -u |
        xargs -d '\n' sed -i -e s,github.com/ericchiang/pup/Godeps/_workspace/src/,,g
    '';
  };

  textsecure = buildFromGitHub {
    owner = "janimo";
    repo = "textsecure";
    propagatedBuildInputs = [ crypto protobuf ed25519 yaml-v2 logrus ];
    disabled = isGo14;
  };

  interlock = buildFromGitHub {
    owner = "inversepath";
    repo = "interlock";
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
    owner = "alecthomas";
    repo = "template";
  };

  units = buildFromGitHub {
    owner = "alecthomas";
    repo = "units";
  };

  go-difflib = buildFromGitHub {
    owner = "pmezard";
    repo = "go-difflib";
  };

  kingpin = buildFromGitHub {
    owner = "alecthomas";
    repo = "kingpin";
    propagatedBuildInputs = [ template units ];
    goPackageAliases = [ "gopkg.in/alecthomas/kingpin.v2" ];
  };

  go2nix = buildFromGitHub rec {
    owner = "kamilchm";
    repo = "go2nix";

    buildInputs = [ pkgs.makeWrapper go-bindata.bin tools.bin vcs go-spew gls go-difflib assertions goconvey testify kingpin ];

    preBuild = ''go generate ./...'';

    postInstall = ''
      wrapProgram $bin/bin/go2nix \
        --prefix PATH : ${pkgs.nix-prefetch-git}/bin \
        --prefix PATH : ${pkgs.git}/bin
    '';

    allowGoReference = true;
  };

  godotenv = buildFromGitHub {
    date   = "2015-09-07";
    owner  = "joho";
    repo   = "godotenv";
    buildInputs = [ go-colortext yaml-v2 ];
  };

  goreman = buildFromGitHub {
    version = "0.0.8-rc0";
    date   = "2016-01-30";
    owner  = "mattn";
    repo   = "goreman";
    buildInputs = [ go-colortext yaml-v2 godotenv ];
  };
}; in self
