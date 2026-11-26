# This file contains the Python packages set.
# Each attribute is a Python library or a helper function.
# Python packages that do not need to be available for each interpreter version do not belong in this packages set.
# Examples are Python-based cli tools.
#
# For more details, please see the Python section in the Nixpkgs manual.

self: super: with self; {

  bootstrap = lib.recurseIntoAttrs {
    flit-core = toPythonModule (callPackage ./non-by-name/bootstrap/flit-core { });
    installer = toPythonModule (
      callPackage ./non-by-name/bootstrap/installer { inherit (bootstrap) flit-core; }
    );
    build = toPythonModule (
      callPackage ./non-by-name/bootstrap/build {
        inherit (bootstrap) flit-core installer;
      }
    );
    packaging = toPythonModule (
      callPackage ./non-by-name/bootstrap/packaging {
        inherit (bootstrap) flit-core installer;
      }
    );
  };

  setuptools = callPackage ./non-by-name/setuptools { };

  setuptools_80 = callPackage ./non-by-name/setuptools/80.nix { };

  # by_regex ensures inherit statements are sorted after the (first) attribute name that is inherited.
  # keep-sorted start block=yes newline_separated=yes by_regex=["(?:inherit\\s+\\([^)]+\\)\\n?\\s*)?(.+)"]
  adios2 = toPythonModule (
    pkgs.adios2.override {
      python3Packages = self;
      pythonSupport = true;
    }
  );

  afdko = callPackage ./non-by-name/afdko { };

  ai-edge-litert = callPackage ./non-by-name/ai-edge-litert {
    openvino-native = pkgs.openvino;
  };

  aioquic_1_2 = callPackage ./non-by-name/aioquic_1_2 { };

  aligator = callPackage ./non-by-name/aligator { inherit (pkgs) aligator; };

  inherit (callPackage ./non-by-name/aliyun-python-sdk { })
    aliyun-python-sdk-actiontrail
    aliyun-python-sdk-adb
    aliyun-python-sdk-adcp
    aliyun-python-sdk-address-purification
    aliyun-python-sdk-aicontent
    aliyun-python-sdk-aigen
    aliyun-python-sdk-aimath
    aliyun-python-sdk-aimiaobi
    aliyun-python-sdk-aipodcast
    aliyun-python-sdk-airec
    aliyun-python-sdk-airticketopen
    aliyun-python-sdk-alb
    aliyun-python-sdk-alidns
    aliyun-python-sdk-alikafka
    aliyun-python-sdk-alimt
    aliyun-python-sdk-alinlp
    aliyun-python-sdk-amqp-open
    aliyun-python-sdk-antiddos-public
    aliyun-python-sdk-anytrans
    aliyun-python-sdk-apds
    aliyun-python-sdk-appstream-center
    aliyun-python-sdk-aps
    aliyun-python-sdk-arms
    aliyun-python-sdk-avatar
    aliyun-python-sdk-bailianchatbot
    aliyun-python-sdk-beian
    aliyun-python-sdk-bpstudio
    aliyun-python-sdk-brain-industrial
    aliyun-python-sdk-brinekingdom
    aliyun-python-sdk-bssopenapi
    aliyun-python-sdk-btripopen
    aliyun-python-sdk-buss
    aliyun-python-sdk-cams
    aliyun-python-sdk-captcha
    aliyun-python-sdk-cassandra
    aliyun-python-sdk-cbn
    aliyun-python-sdk-cc5g
    aliyun-python-sdk-ccc
    aliyun-python-sdk-cciotgw
    aliyun-python-sdk-cdn
    aliyun-python-sdk-cdrs
    aliyun-python-sdk-ciomarketpop
    aliyun-python-sdk-clickhouse
    aliyun-python-sdk-cloudapi
    aliyun-python-sdk-cloudauth
    aliyun-python-sdk-cloudauth-console
    aliyun-python-sdk-cloudesl
    aliyun-python-sdk-cloudphone
    aliyun-python-sdk-cloud-siem
    aliyun-python-sdk-cms
    aliyun-python-sdk-codeup
    aliyun-python-sdk-companyreg
    aliyun-python-sdk-computenest
    aliyun-python-sdk-computenestsupplier
    aliyun-python-sdk-config
    aliyun-python-sdk-csas
    aliyun-python-sdk-das
    aliyun-python-sdk-dashdeviceconsole
    aliyun-python-sdk-dataphin-public
    aliyun-python-sdk-dataworks-public
    aliyun-python-sdk-dbfs
    aliyun-python-sdk-dbs
    aliyun-python-sdk-dcdn
    aliyun-python-sdk-ddosbgp
    aliyun-python-sdk-ddoscoo
    aliyun-python-sdk-ddosdiversion
    aliyun-python-sdk-dds
    aliyun-python-sdk-devops-rdc
    aliyun-python-sdk-dfs
    aliyun-python-sdk-dg
    aliyun-python-sdk-dms
    aliyun-python-sdk-dms-dg
    aliyun-python-sdk-dms-enterprise
    aliyun-python-sdk-documentautoml
    aliyun-python-sdk-domain
    aliyun-python-sdk-drds
    aliyun-python-sdk-dt-oc-info
    aliyun-python-sdk-dts
    aliyun-python-sdk-dybaseapi
    aliyun-python-sdk-dyplsapi
    aliyun-python-sdk-dypnsapi
    aliyun-python-sdk-dypnsapi-intl
    aliyun-python-sdk-dysmsapi
    aliyun-python-sdk-dytnsapi
    aliyun-python-sdk-dyvmsapi
    aliyun-python-sdk-eais
    aliyun-python-sdk-eas
    aliyun-python-sdk-ebs
    aliyun-python-sdk-ecd
    aliyun-python-sdk-eci
    aliyun-python-sdk-ecs
    aliyun-python-sdk-ecs-workbench
    aliyun-python-sdk-edas
    aliyun-python-sdk-eds-user
    aliyun-python-sdk-eduinterpreting
    aliyun-python-sdk-eflo
    aliyun-python-sdk-eflo-controller
    aliyun-python-sdk-ehpc
    aliyun-python-sdk-ehpcinstant
    aliyun-python-sdk-eiam
    aliyun-python-sdk-eipanycast
    aliyun-python-sdk-elasticsearch
    aliyun-python-sdk-emas-appmonitor
    aliyun-python-sdk-emr
    aliyun-python-sdk-emrstudio
    aliyun-python-sdk-ens
    aliyun-python-sdk-esa
    aliyun-python-sdk-ess
    aliyun-python-sdk-es-serverless
    aliyun-python-sdk-et-industry-openapi
    aliyun-python-sdk-eventbridge
    aliyun-python-sdk-facebody
    aliyun-python-sdk-fnf
    aliyun-python-sdk-foas
    aliyun-python-sdk-ft
    aliyun-python-sdk-ga
    aliyun-python-sdk-gdb
    aliyun-python-sdk-geoip
    aliyun-python-sdk-governance
    aliyun-python-sdk-gpdb
    aliyun-python-sdk-grace
    aliyun-python-sdk-green
    aliyun-python-sdk-gwlb
    aliyun-python-sdk-hbase
    aliyun-python-sdk-hbr
    aliyun-python-sdk-hcs-mgw
    aliyun-python-sdk-hitsdb
    aliyun-python-sdk-ice
    aliyun-python-sdk-idaas-doraemon
    aliyun-python-sdk-imageaudit
    aliyun-python-sdk-imageenhan
    aliyun-python-sdk-imageprocess
    aliyun-python-sdk-imagerecog
    aliyun-python-sdk-imageseg
    aliyun-python-sdk-imarketing
    aliyun-python-sdk-imgsearch
    aliyun-python-sdk-imm
    aliyun-python-sdk-intlmarket
    aliyun-python-sdk-iot
    aliyun-python-sdk-iotcc
    aliyun-python-sdk-iqs
    aliyun-python-sdk-itag
    aliyun-python-sdk-ivision
    aliyun-python-sdk-kms
    aliyun-python-sdk-lingmou
    aliyun-python-sdk-linkvisual
    aliyun-python-sdk-linkwan
    aliyun-python-sdk-live
    aliyun-python-sdk-ltl
    aliyun-python-sdk-lto
    aliyun-python-sdk-market
    aliyun-python-sdk-marketplaceintl
    aliyun-python-sdk-maxcompute
    aliyun-python-sdk-mns-open
    aliyun-python-sdk-moguan-sdk
    aliyun-python-sdk-msccommonquery
    aliyun-python-sdk-mse
    aliyun-python-sdk-mseap
    aliyun-python-sdk-mts
    aliyun-python-sdk-nas
    aliyun-python-sdk-nis
    aliyun-python-sdk-nlb
    aliyun-python-sdk-nlp-automl
    aliyun-python-sdk-objectdet
    aliyun-python-sdk-oceanbasepro
    aliyun-python-sdk-ocr
    aliyun-python-sdk-ocs
    aliyun-python-sdk-oms
    aliyun-python-sdk-ons
    aliyun-python-sdk-onsmqtt
    aliyun-python-sdk-oos
    aliyun-python-sdk-openanalytics-open
    aliyun-python-sdk-openitag
    aliyun-python-sdk-opensearch
    aliyun-python-sdk-osssddp
    aliyun-python-sdk-outboundbot
    aliyun-python-sdk-pai-dsw
    aliyun-python-sdk-paielasticdatasetaccelerator
    aliyun-python-sdk-paifeaturestore
    aliyun-python-sdk-pairecservice
    aliyun-python-sdk-polardb
    aliyun-python-sdk-polardbx
    aliyun-python-sdk-privatelink
    aliyun-python-sdk-push
    aliyun-python-sdk-pvtz
    aliyun-python-sdk-qianzhou
    aliyun-python-sdk-qualitycheck
    aliyun-python-sdk-quickbi-public
    aliyun-python-sdk-quotas
    aliyun-python-sdk-ram
    aliyun-python-sdk-rds
    aliyun-python-sdk-rds-data
    aliyun-python-sdk-reid-cloud
    aliyun-python-sdk-resourcecenter
    aliyun-python-sdk-resourcemanager
    aliyun-python-sdk-resourcesharing
    aliyun-python-sdk-retailcloud
    aliyun-python-sdk-r-kvstore
    aliyun-python-sdk-ros
    aliyun-python-sdk-rsimganalys
    aliyun-python-sdk-rtc
    aliyun-python-sdk-sae
    aliyun-python-sdk-safconsole
    aliyun-python-sdk-sas
    aliyun-python-sdk-sasti
    aliyun-python-sdk-scdn
    aliyun-python-sdk-schedulerx2
    aliyun-python-sdk-schedulerx3
    aliyun-python-sdk-scsp
    aliyun-python-sdk-sddp
    aliyun-python-sdk-selectdb
    aliyun-python-sdk-sgw
    aliyun-python-sdk-slb
    aliyun-python-sdk-sls
    aliyun-python-sdk-smartag
    aliyun-python-sdk-smartsales
    aliyun-python-sdk-smc
    aliyun-python-sdk-snsuapi
    aliyun-python-sdk-sophonsoar
    aliyun-python-sdk-sts
    aliyun-python-sdk-swas-open
    aliyun-python-sdk-tag
    aliyun-python-sdk-threedvision
    aliyun-python-sdk-tingwu
    aliyun-python-sdk-unimkt
    aliyun-python-sdk-ververica
    aliyun-python-sdk-viapi
    aliyun-python-sdk-viapi-oxs-cross
    aliyun-python-sdk-viapi-regen
    aliyun-python-sdk-videoenhan
    aliyun-python-sdk-videorecog
    aliyun-python-sdk-videoseg
    aliyun-python-sdk-vod
    aliyun-python-sdk-voicenavigator
    aliyun-python-sdk-vpc
    aliyun-python-sdk-vpcpeer
    aliyun-python-sdk-vs
    aliyun-python-sdk-waf-openapi
    aliyun-python-sdk-websitebuild
    aliyun-python-sdk-wfts
    aliyun-python-sdk-workbench-ide
    aliyun-python-sdk-workorder
    aliyun-python-sdk-wss
    aliyun-python-sdk-xtrace
    ;

  amdsmi = toPythonModule (
    pkgs.rocmPackages.amdsmi.override {
      inherit python;
    }
  );

  angrcli = callPackage ./non-by-name/angrcli { inherit (pkgs) coreutils; };

  anki-mac-helper = callPackage ./non-by-name/anki-mac-helper {
    inherit (pkgs) swift;
  };

  ansible = callPackage ./non-by-name/ansible { };

  ansible-builder = callPackage ./non-by-name/ansible-builder {
    inherit (pkgs) podman;
  };

  ansible-core = callPackage ./non-by-name/ansible/core.nix { };

  antlr4-python3-runtime = callPackage ./non-by-name/antlr4-python3-runtime {
    inherit (pkgs) antlr4;
  };

  anytree = callPackage ./non-by-name/anytree { inherit (pkgs) graphviz; };

  argostranslate = callPackage ./non-by-name/argostranslate {
    ctranslate2-cpp = pkgs.ctranslate2;
  };

  arro3-compute = (callPackage ./non-by-name/arro3 { }).arro3-compute;

  arro3-core = (callPackage ./non-by-name/arro3 { }).arro3-core;

  arro3-io = (callPackage ./non-by-name/arro3 { }).arro3-io;

  ast-grep-py = callPackage ./non-by-name/ast-grep-py { };

  atopile-kicad-python = callPackage ./non-by-name/atopile-kicad-python { };

  audioop-lts = if pythonAtLeast "3.13" then callPackage ./non-by-name/audioop-lts { } else null;

  audit = toPythonModule (
    pkgs.audit.override {
      python3Packages = self;
    }
  );

  auditwheel = callPackage ./non-by-name/auditwheel {
    inherit (pkgs)
      bzip2
      gnutar
      patchelf
      unzip
      ;
  };

  avahi = toPythonModule (
    pkgs.avahi.override {
      inherit python;
      withPython = true;
    }
  );

  awkward-cpp = callPackage ./non-by-name/awkward-cpp { inherit (pkgs) cmake ninja; };

  babeltrace = toPythonModule (
    pkgs.babeltrace.override {
      pythonPackages = self;
      enablePython = true;
    }
  );

  babeltrace2 = toPythonModule (
    pkgs.babeltrace2.override {
      inherit (self) python;
      pythonPackages = self;
      enablePython = true;
    }
  );

  backports-asyncio-runner =
    if pythonAtLeast "3.12" then null else callPackage ./non-by-name/backports-asyncio-runner { };

  backports-strenum =
    if pythonAtLeast "3.11" then null else callPackage ./non-by-name/backports-strenum { };

  backports-zstd =
    if pythonAtLeast "3.14" then
      null
    else
      callPackage ./non-by-name/backports-zstd {
        inherit (pkgs) zstd;
      };

  bap = callPackage ./non-by-name/bap {
    inherit (pkgs.ocaml-ng.ocamlPackages_4_14) bap;
  };

  basemap = callPackage ./non-by-name/basemap { };

  bcc = toPythonModule (pkgs.bcc.override { python3Packages = self; });

  bcrypt =
    if stdenv.hostPlatform.system == "i686-linux" then
      callPackage ./non-by-name/bcrypt/3.nix { }
    else
      callPackage ./non-by-name/bcrypt { };

  beancount = callPackage ./non-by-name/beancount { };

  beancount_2 = callPackage ./non-by-name/beancount/2.nix { };

  beets = callPackage ./non-by-name/beets {
    inherit (pkgs) chromaprint;
  };

  beets-minimal = beets.override {
    disableAllPlugins = true;
  };

  bencodetools = callPackage ./non-by-name/bencodetools {
    bencodetools = pkgs.bencodetools;
  };

  bgutil-ytdlp-pot-provider = callPackage ./non-by-name/bgutil-ytdlp-pot-provider { };

  bibtexparser = callPackage ./non-by-name/bibtexparser { };

  bibtexparser_2 = callPackage ./non-by-name/bibtexparser/2.nix { };

  black = callPackage ./non-by-name/black { };

  # Build boost for this specific Python version
  # TODO: use separate output for libboost_python.so
  boost = toPythonModule (
    pkgs.boost.override {
      inherit (self) python numpy;
      enablePython = true;
    }
  );

  boost-histogram = callPackage ./non-by-name/boost-histogram {
    inherit (pkgs) boost;
  };

  borb = callPackage ./non-by-name/borb { };

  borb_2 = callPackage ./non-by-name/borb/2.nix { };

  botan3 = callPackage ./non-by-name/botan3 { inherit (pkgs) botan3; };

  brainflow = callPackage ./non-by-name/brainflow { inherit (pkgs) brainflow; };

  brotli = callPackage ./non-by-name/brotli {
    inherit (pkgs) brotli;
  };

  brotlicffi = callPackage ./non-by-name/brotlicffi { inherit (pkgs) brotli; };

  bytesize = toPythonModule (pkgs.libbytesize.override { python3Packages = self; });

  caffe = toPythonModule (
    pkgs.caffe.override {
      pythonSupport = true;
      inherit (self) python numpy boost;
    }
  );

  capstone = callPackage ./non-by-name/capstone { inherit (pkgs) capstone; };

  capstone_4 = callPackage ./non-by-name/capstone/4.nix {
    inherit (pkgs) capstone_4;
  };

  casadi = toPythonModule (
    pkgs.casadi.override {
      pythonSupport = true;
      python3Packages = self;
    }
  );

  catalyst = toPythonModule (
    pkgs.catalyst.override {
      python3Packages = self;
      pythonSupport = true;
    }
  );

  catboost = callPackage ./non-by-name/catboost {
    catboost = pkgs.catboost.override {
      pythonSupport = true;
      python3Packages = self;
    };
  };

  cbor2 = callPackage ./non-by-name/cbor2 { };

  cbor2WithoutCExtensions = callPackage ./non-by-name/cbor2 {
    withCExtensions = false;
  };

  cccolutils = callPackage ./non-by-name/cccolutils { krb5-c = pkgs.krb5; };

  cffi = if isPyPy then null else callPackage ./non-by-name/cffi { };

  cgal = callPackage ./non-by-name/cgal { inherit (pkgs) cgal; };

  chardet = callPackage ./non-by-name/chardet { };

  chardet_5 = callPackage ./non-by-name/chardet/5.nix { };

  chromadb = callPackage ./non-by-name/chromadb { zstd-c = pkgs.zstd; };

  ckzg = callPackage ./non-by-name/ckzg {
    inherit (pkgs) clang;
  };

  cle = callPackage ./non-by-name/cle { };

  clingo = toPythonModule (
    pkgs.clingo.override {
      inherit python;
      withPython = true;
    }
  );

  cmake = callPackage ./non-by-name/cmake { inherit (pkgs) cmake; };

  cmd2_3 = callPackage ./non-by-name/cmd2_3 { };

  cmigemo = callPackage ./non-by-name/cmigemo { inherit (pkgs) cmigemo; };

  coal = callPackage ./non-by-name/coal { inherit (pkgs) coal; };

  coincurve = callPackage ./non-by-name/coincurve { inherit (pkgs) secp256k1; };

  conduit = callPackage ./non-by-name/conduit { };

  conduit-mpi = callPackage ./non-by-name/conduit { mpiSupport = true; };

  cot = callPackage ./non-by-name/cot { inherit (pkgs) qemu; };

  cppe = callPackage ./non-by-name/cppe { inherit (pkgs) cppe; };

  cramjam = callPackage ./non-by-name/cramjam {
    inherit (pkgs) zstd;
  };

  crocoddyl = callPackage ./non-by-name/crocoddyl { inherit (pkgs) crocoddyl; };

  cryptolyzer = callPackage ./non-by-name/cryptolyzer { };

  cryptoparser = callPackage ./non-by-name/cryptoparser { };

  ctranslate2 = callPackage ./non-by-name/ctranslate2 {
    ctranslate2-cpp = pkgs.ctranslate2;
  };

  cuda-bindings = callPackage ./non-by-name/cuda-bindings { };

  cuda-cccl = callPackage ./non-by-name/cuda-cccl { };

  cynthion = callPackage ./non-by-name/cynthion { };

  cyscale = callPackage ./non-by-name/cyscale { };

  cython = callPackage ./non-by-name/cython { };

  cython_0 = callPackage ./non-by-name/cython/0.nix { };

  cython_3_2 = callPackage ./non-by-name/cython/3_2.nix { };

  daft = callPackage ./non-by-name/daft { inherit (pkgs) zstd; };

  dartsim = toPythonModule (
    pkgs.dartsim.override {
      pythonSupport = true;
      python3Packages = self;
    }
  );

  datafusion = callPackage ./non-by-name/datafusion {
    protoc = pkgs.protobuf;
  };

  datasets = callPackage ./non-by-name/datasets { };

  datasets_3 = callPackage ./non-by-name/datasets/3.nix { };

  dbus-python = callPackage ./non-by-name/dbus-python { inherit (pkgs) dbus; };

  deltalake = callPackage ./non-by-name/deltalake { inherit (pkgs) zstd; };

  devpi-server = callPackage ../../by-name/de/devpi-server/unwrapped.nix { };

  dfir-ntfs = callPackage ./non-by-name/dfir_ntfs { };

  dftd4 = callPackage ../../by-name/df/dftd4/python.nix {
    inherit (pkgs) dftd4;
  };

  distutils = if pythonOlder "3.12" then null else callPackage ./non-by-name/distutils { };

  distutils_80 = if pythonOlder "3.12" then null else callPackage ./non-by-name/distutils/80.nix { };

  # LTS with mainsteam support
  django = self.django_5;

  django-auth-ldap = callPackage ./non-by-name/django-auth-ldap {
    inherit (pkgs) openldap;
  };

  django-extensions = callPackage ./non-by-name/django-extensions { };

  django-oauth-toolkit = callPackage ./non-by-name/django-oauth-toolkit { };

  django-oauth-toolkit_2 = callPackage ./non-by-name/django-oauth-toolkit/2.nix { };

  django-stubs-ext = callPackage ./non-by-name/django-stubs-ext { };

  # LTS in extended support phase
  django_5 = callPackage ./non-by-name/django/5.nix { };

  django_6 = callPackage ./non-by-name/django/6.nix { };

  django_6_0 = callPackage ./non-by-name/django/6_0.nix { };

  djangorestframework = callPackage ./non-by-name/djangorestframework { };

  djangorestframework_3_17 = callPackage ./non-by-name/djangorestframework/3_17.nix { };

  dlib = callPackage ./non-by-name/dlib { inherit (pkgs) dlib; };

  dm-tree = callPackage ./non-by-name/dm-tree {
    inherit (pkgs) abseil-cpp;
  };

  docling-parse = callPackage ./non-by-name/docling-parse {
    loguru-cpp = pkgs.loguru;
  };

  dot2tex = callPackage ./non-by-name/dot2tex { inherit (pkgs) graphviz; };

  duckdb = callPackage ./non-by-name/duckdb { inherit (pkgs) duckdb; };

  dulwich = callPackage ./non-by-name/dulwich { inherit (pkgs) gnupg; };

  eccodes = toPythonModule (
    pkgs.eccodes.override {
      enablePython = true;
      python3Packages = self;
    }
  );

  echo = callPackage ./non-by-name/echo {
    inherit (pkgs) mesa;
  };

  edlib = callPackage ./non-by-name/edlib { inherit (pkgs) edlib; };

  elastic-transport = callPackage ./non-by-name/elastic-transport { };

  elastic-transport_9 = callPackage ./non-by-name/elastic-transport/9.nix { };

  elasticsearchdsl = self.elasticsearch-dsl;

  elfdeps = toPythonModule (pkgs.elfdeps.override { python3Packages = self; });

  entrance = callPackage ./non-by-name/entrance { routerFeatures = false; };

  entrance-with-router-features = callPackage ./non-by-name/entrance {
    routerFeatures = true;
  };

  es-client = callPackage ./non-by-name/es-client { };

  es-client_8 = callPackage ./non-by-name/es-client/8.nix { };

  etcd3 = callPackage ./non-by-name/etcd3 { inherit (pkgs) etcd; };

  example-robot-data = callPackage ./non-by-name/example-robot-data {
    inherit (pkgs) example-robot-data;
  };

  exiv2 = callPackage ./non-by-name/exiv2 { inherit (pkgs) exiv2; };

  extractcode = callPackage ./non-by-name/extractcode { };

  extractcode-7z = callPackage ./non-by-name/extractcode/7z.nix {
    inherit (pkgs) p7zip;
  };

  extractcode-libarchive = callPackage ./non-by-name/extractcode/libarchive.nix {
    inherit (pkgs)
      libarchive
      libb2
      bzip2
      expat
      lz4
      xz
      zlib
      zstd
      ;
  };

  f3d = toPythonModule (
    pkgs.f3d.override {
      withPythonBinding = true;
      python3Packages = self;
    }
  );

  face-recognition = callPackage ./non-by-name/face-recognition { };

  face-recognition-models = callPackage ./non-by-name/face-recognition/models.nix { };

  faiss = callPackage ./non-by-name/faiss {
    faiss-build = pkgs.faiss.override {
      pythonSupport = true;
      python3Packages = self;
    };
  };

  faiss-cpu = callPackage ./non-by-name/faiss-cpu {
    faiss = self.faiss.override {
      faiss-build = pkgs.faiss.override {
        pythonSupport = true;
        python3Packages = self;
        cudaSupport = false;
      };
    };
  };

  fastnlo-toolkit = toPythonModule (
    pkgs.fastnlo-toolkit.override {
      withPython = true;
      inherit (self) python;
    }
  );

  fava-portfolio-returns = callPackage ./non-by-name/fava-portfolio-returns { };

  finufft = callPackage ./non-by-name/finufft {
    inherit (pkgs) finufft;
  };

  flash-attn-3 = callPackage ./non-by-name/flash-attn-3 { };

  flashinfer-python = callPackage ./non-by-name/flashinfer-python { };

  flatbuffers = callPackage ./non-by-name/flatbuffers { inherit (pkgs) flatbuffers; };

  fluent-pygments = callPackage ./non-by-name/python-fluent/fluent-pygments.nix { };

  fluent-runtime = callPackage ./non-by-name/python-fluent/fluent-runtime.nix { };

  fluent-syntax = callPackage ./non-by-name/python-fluent/fluent-syntax.nix { };

  flufl-bounce = callPackage ./non-by-name/flufl/bounce.nix { };

  flufl-i18n = callPackage ./non-by-name/flufl/i18n.nix { };

  flufl-lock = callPackage ./non-by-name/flufl/lock.nix { };

  fontforge = toPythonModule (
    pkgs.fontforge.override {
      withPython = true;
      python3 = python;
    }
  );

  foss-flame = callPackage ./non-by-name/foss-flame { };

  foundationdb = callPackage ./non-by-name/foundationdb {
    inherit (pkgs) foundationdb;
  };

  freesasa = callPackage ./non-by-name/freesasa { inherit (pkgs) freesasa; };

  fx2 = callPackage ./non-by-name/fx2 { };

  galario = toPythonModule (
    pkgs.galario.override {
      enablePython = true;
      pythonPackages = self;
    }
  );

  gattlib = callPackage ./non-by-name/gattlib {
    inherit (pkgs) bluez glib pkg-config;
  };

  gdal = toPythonModule (pkgs.gdal.override { python3Packages = self; });

  gdcm = toPythonModule (
    pkgs.gdcm.override {
      inherit (self) python;
      enablePython = true;
    }
  );

  geant4 = toPythonModule (
    pkgs.geant4.override {
      enablePython = true;
      python3 = python;
    }
  );

  gemmi = toPythonModule (
    pkgs.gemmi.override {
      enablePython = true;
      python3Packages = self;
    }
  );

  geoarrow-c = callPackage ./non-by-name/geoarrow-c { };

  inherit (callPackage ./non-by-name/geoarrow-rust { })
    geoarrow-rust-core
    geoarrow-rust-io
    ;

  geoip = callPackage ./non-by-name/geoip { libgeoip = pkgs.geoip; };

  gfal2-util = callPackage ./non-by-name/gfal2-util { inherit (pkgs) xrootd; };

  gmsh = toPythonModule (
    pkgs.gmsh.override {
      python3Packages = self;
      enablePython = true;
    }
  );

  gnucash = toPythonModule (
    pkgs.gnucash.override {
      python3 = python;
    }
  );

  google-crc32c = callPackage ./non-by-name/google-crc32c { inherit (pkgs) crc32c; };

  gpaw = callPackage ./non-by-name/gpaw {
    inherit (pkgs) libxc;
  };

  gpg = callPackage ./non-by-name/gpg { inherit (pkgs) gpgme; };

  gpiod = callPackage ./non-by-name/gpiod { inherit (pkgs) libgpiod; };

  gprof2dot = callPackage ./non-by-name/gprof2dot { inherit (pkgs) graphviz; };

  gradio = callPackage ./non-by-name/gradio { };

  gradio-client = callPackage ./non-by-name/gradio/client.nix {
    inherit (pkgs) jq;
  };

  grafanalib = callPackage ./non-by-name/grafanalib/default.nix { };

  graph-tool = callPackage ./non-by-name/graph-tool { inherit (pkgs) cgal; };

  # built-in for pypi
  greenlet = if isPyPy then null else callPackage ./non-by-name/greenlet { };

  gruut-ipa = callPackage ./non-by-name/gruut-ipa { inherit (pkgs) espeak; };

  gssapi = callPackage ./non-by-name/gssapi {
    krb5-c = pkgs.krb5;
  };

  gst-python = callPackage ./non-by-name/gst-python {
    # inherit (pkgs) meson won't work because it won't be spliced
    inherit (pkgs.buildPackages) meson;
  };

  gudhi = callPackage ./non-by-name/gudhi { inherit (pkgs) cgal; };

  guestfs = toPythonModule (
    pkgs.libguestfs.override {
      python3 = python;
    }
  );

  h3 = callPackage ./non-by-name/h3 { h3 = pkgs.h3_4; };

  h5py-mpi = self.h5py.override { hdf5 = pkgs.hdf5-mpi; };

  halide =
    toPythonModule
      (pkgs.halide.override {
        pythonSupport = true;
        python3Packages = self;
      }).lib;

  hatch = callPackage ./non-by-name/hatch/default.nix { };

  hdf5plugin = callPackage ./non-by-name/hdf5plugin {
    inherit (pkgs) zstd lz4;
  };

  hepmc3 = toPythonModule (pkgs.hepmc3.override { inherit python; });

  hid = callPackage ./non-by-name/hid { inherit (pkgs) hidapi; };

  hidapi = callPackage ./non-by-name/hidapi { inherit (pkgs) hidapi udev; };

  hnswlib = callPackage ./non-by-name/hnswlib { inherit (pkgs) hnswlib; };

  home-assistant-chip-wheels = toPythonModule (
    callPackage ./non-by-name/home-assistant-chip-wheels { }
  );

  horizon-eda = callPackage ./non-by-name/horizon-eda { inherit (pkgs) horizon-eda; };

  inherit (callPackage ./non-by-name/huaweicloudsdk { })
    huaweicloudsdkaad
    huaweicloudsdkagentarts
    huaweicloudsdkagentidentity
    huaweicloudsdkantiddos
    huaweicloudsdkaom
    huaweicloudsdkaos
    huaweicloudsdkapig
    huaweicloudsdkapm
    huaweicloudsdkas
    huaweicloudsdkasm
    huaweicloudsdkastrozero
    huaweicloudsdkbcc
    huaweicloudsdkbcs
    huaweicloudsdkbms
    huaweicloudsdkbss
    huaweicloudsdkbssintl
    huaweicloudsdkcae
    huaweicloudsdkcampusgo
    huaweicloudsdkcbh
    huaweicloudsdkcbr
    huaweicloudsdkcbs
    huaweicloudsdkcc
    huaweicloudsdkcce
    huaweicloudsdkccm
    huaweicloudsdkcdm
    huaweicloudsdkcdn
    huaweicloudsdkces
    huaweicloudsdkcfw
    huaweicloudsdkclassroom
    huaweicloudsdkclouddc
    huaweicloudsdkcloudide
    huaweicloudsdkcloudpond
    huaweicloudsdkcloudrtc
    huaweicloudsdkcloudtable
    huaweicloudsdkcloudtest
    huaweicloudsdkcoc
    huaweicloudsdkcodeartsartifact
    huaweicloudsdkcodeartsbuild
    huaweicloudsdkcodeartscheck
    huaweicloudsdkcodeartsdeploy
    huaweicloudsdkcodeartsgovernance
    huaweicloudsdkcodeartside
    huaweicloudsdkcodeartsinspector
    huaweicloudsdkcodeartspipeline
    huaweicloudsdkcodeartsrepo
    huaweicloudsdkcodecraft
    huaweicloudsdkconfig
    huaweicloudsdkcpcs
    huaweicloudsdkcph
    huaweicloudsdkcpts
    huaweicloudsdkcse
    huaweicloudsdkcsms
    huaweicloudsdkcss
    huaweicloudsdkcts
    huaweicloudsdkdas
    huaweicloudsdkdataartsfabric
    huaweicloudsdkdataartsfabricep
    huaweicloudsdkdataartsstudio
    huaweicloudsdkdbss
    huaweicloudsdkdc
    huaweicloudsdkdcc
    huaweicloudsdkdcos
    huaweicloudsdkdcs
    huaweicloudsdkddm
    huaweicloudsdkdds
    huaweicloudsdkdeh
    huaweicloudsdkdevstar
    huaweicloudsdkdgc
    huaweicloudsdkdis
    huaweicloudsdkdlf
    huaweicloudsdkdli
    huaweicloudsdkdns
    huaweicloudsdkdris
    huaweicloudsdkdrs
    huaweicloudsdkdsc
    huaweicloudsdkdwr
    huaweicloudsdkdws
    huaweicloudsdkec
    huaweicloudsdkecs
    huaweicloudsdkedgesec
    huaweicloudsdkeg
    huaweicloudsdkeihealth
    huaweicloudsdkeip
    huaweicloudsdkelb
    huaweicloudsdkeps
    huaweicloudsdker
    huaweicloudsdkesw
    huaweicloudsdkevs
    huaweicloudsdkfrs
    huaweicloudsdkfunctiongraph
    huaweicloudsdkga
    huaweicloudsdkgaussdb
    huaweicloudsdkgaussdbfornosql
    huaweicloudsdkgaussdbforopengauss
    huaweicloudsdkgeip
    huaweicloudsdkges
    huaweicloudsdkgsl
    huaweicloudsdkhilens
    huaweicloudsdkhss
    huaweicloudsdkiam
    huaweicloudsdkiamaccessanalyzer
    huaweicloudsdkidentitycenter
    huaweicloudsdkidentitycenteroidc
    huaweicloudsdkidentitycenterportalapi
    huaweicloudsdkidentitycenterscim
    huaweicloudsdkidentitycenterstore
    huaweicloudsdkidme
    huaweicloudsdkidmeclassicapi
    huaweicloudsdkiec
    huaweicloudsdkief
    huaweicloudsdkimage
    huaweicloudsdkimagesearch
    huaweicloudsdkims
    huaweicloudsdkiotanalytics
    huaweicloudsdkiotda
    huaweicloudsdkiotdm
    huaweicloudsdkiotedge
    huaweicloudsdkivs
    huaweicloudsdkkafka
    huaweicloudsdkkms
    huaweicloudsdkkoomessage
    huaweicloudsdkkps
    huaweicloudsdkkvs
    huaweicloudsdklakeformation
    huaweicloudsdklive
    huaweicloudsdklts
    huaweicloudsdkmapds
    huaweicloudsdkmas
    huaweicloudsdkmastudio
    huaweicloudsdkmeeting
    huaweicloudsdkmetastudio
    huaweicloudsdkmodelarts
    huaweicloudsdkmoderation
    huaweicloudsdkmpc
    huaweicloudsdkmrs
    huaweicloudsdkmsgsms
    huaweicloudsdkmssi
    huaweicloudsdknat
    huaweicloudsdknlp
    huaweicloudsdkobs
    huaweicloudsdkocr
    huaweicloudsdkoctopus
    huaweicloudsdkoms
    huaweicloudsdkoptverse
    huaweicloudsdkorganizations
    huaweicloudsdkorgid
    huaweicloudsdkoroas
    huaweicloudsdkosm
    huaweicloudsdkpangulargemodels
    huaweicloudsdkprojectman
    huaweicloudsdkrabbitmq
    huaweicloudsdkram
    huaweicloudsdkrc
    huaweicloudsdkrds
    huaweicloudsdkres
    huaweicloudsdkrfs
    huaweicloudsdkrgc
    huaweicloudsdkrms
    huaweicloudsdkrocketmq
    huaweicloudsdkroma
    huaweicloudsdksa
    huaweicloudsdkscm
    huaweicloudsdksdrs
    huaweicloudsdksecmaster
    huaweicloudsdkservicestage
    huaweicloudsdksfsturbo
    huaweicloudsdksis
    huaweicloudsdksmn
    huaweicloudsdksmnglobal
    huaweicloudsdksms
    huaweicloudsdksmsapi
    huaweicloudsdksts
    huaweicloudsdkswr
    huaweicloudsdktics
    huaweicloudsdktms
    huaweicloudsdkucs
    huaweicloudsdkugo
    huaweicloudsdkvas
    huaweicloudsdkvcm
    huaweicloudsdkversatile
    huaweicloudsdkvod
    huaweicloudsdkvpc
    huaweicloudsdkvpcep
    huaweicloudsdkvpn
    huaweicloudsdkwaf
    huaweicloudsdkworkspace
    huaweicloudsdkworkspaceapp
    ;

  huggingface-hub = callPackage ./non-by-name/huggingface-hub { };

  huggingface-hub_0 = callPackage ./non-by-name/huggingface-hub/0.nix { };

  i2c-tools = callPackage ./non-by-name/i2c-tools { inherit (pkgs) i2c-tools; };

  icoextract = toPythonModule (pkgs.icoextract.override { python3Packages = self; });

  ifcopenshell = callPackage ./non-by-name/ifcopenshell {
    inherit (pkgs) cgal_5 libxml2;
  };

  igraph = callPackage ./non-by-name/igraph { inherit (pkgs) igraph; };

  imread = callPackage ./non-by-name/imread {
    inherit (pkgs)
      libjpeg
      libpng
      libtiff
      libwebp
      ;
  };

  indexed-gzip = callPackage ./non-by-name/indexed-gzip { inherit (pkgs) zlib; };

  indexed-zstd = callPackage ./non-by-name/indexed-zstd { inherit (pkgs) zstd; };

  ironcalc = callPackage ../../by-name/ir/ironcalc/python.nix {
    inherit (pkgs) ironcalc;
  };

  islpy = callPackage ./non-by-name/islpy { isl = pkgs.isl_0_27; };

  itk = toPythonModule (
    pkgs.itk.override {
      inherit python numpy;
      enablePython = true;
      enableRtk = false;
      stdenv =
        if stdenv.cc.isGNU then pkgs.stdenvAdapters.useLibsFrom stdenv pkgs.gcc13Stdenv else stdenv;
    }
  );

  jaxlib = jaxlib-bin;

  jaxlib-bin = callPackage ./non-by-name/jaxlib/bin.nix { };

  jaxlib-build = callPackage ./non-by-name/jaxlib {
    snappy-cpp = pkgs.snappy;
  };

  jq = callPackage ./non-by-name/jq { inherit (pkgs) jq; };

  jupyter-collaboration = callPackage ./non-by-name/jupyter-collaboration { };

  jupyter-repo2docker = callPackage ./non-by-name/jupyter-repo2docker {
    pkgs-docker = pkgs.docker;
  };

  jupyterlab-git-core = callPackage ./non-by-name/jupyterlab-git-core { };

  k5test = callPackage ./non-by-name/k5test {
    inherit (pkgs) findutils;
    krb5-c = pkgs.krb5;
  };

  kahip = toPythonModule (
    pkgs.kahip.override {
      pythonSupport = true;
      python3Packages = self;
    }
  );

  kaldi-active-grammar = callPackage ./non-by-name/kaldi-active-grammar { };

  keyutils = callPackage ./non-by-name/keyutils { inherit (pkgs) keyutils; };

  kiauto = callPackage ./non-by-name/kiauto {
    kicadPkg = pkgs.kicad;
  };

  kicad = toPythonModule (pkgs.kicad.override { python3 = python; }).src;

  kicad-python = callPackage ./non-by-name/kicad-python { };

  klayout = callPackage ./non-by-name/klayout { inherit (pkgs) klayout; };

  kmsxx = toPythonModule (
    pkgs.kmsxx.override {
      withPython = true;
      python3Packages = self;
    }
  );

  krb5 = callPackage ./non-by-name/krb5 { krb5-c = pkgs.krb5; };

  kubernetes-validate = callPackage ../../by-name/ku/kubernetes-validate/unwrapped.nix { };

  lammps = callPackage ./non-by-name/lammps { inherit (pkgs) lammps; };

  lancedb = callPackage ./non-by-name/lancedb { inherit (pkgs) protobuf; };

  laszip = callPackage ./non-by-name/laszip {
    inherit (pkgs) cmake ninja;
    inherit (pkgs.__splicedPackages) laszip;
  };

  ledger =
    (toPythonModule (
      pkgs.ledger.override {
        usePython = true;
        python3 = python;
      }
    )).py;

  legacy-cgi = if pythonOlder "3.13" then null else callPackage ./non-by-name/legacy-cgi { };

  leidenalg = callPackage ./non-by-name/leidenalg { igraph-c = pkgs.igraph; };

  lesscpy = toPythonModule (pkgs.lesscpy.override { python3Packages = self; });

  lgpio = toPythonModule (
    pkgs.lgpio.override {
      inherit buildPythonPackage;
      pyProject = "PY_LGPIO";
      lgpioWithoutPython = pkgs.lgpio;
    }
  );

  lhapdf = toPythonModule (pkgs.lhapdf.override { python3 = python; });

  libapparmor = callPackage (
    {
      python,
      pythonImportsCheckHook,
      setuptools,
    }@python3Packages:
    toPythonModule (
      pkgs.libapparmor.override {
        inherit python3Packages;
      }
    )
  ) { };

  libarchive-c = callPackage ./non-by-name/libarchive-c {
    inherit (pkgs) libarchive;
  };

  libasyncns = callPackage ./non-by-name/libasyncns { inherit (pkgs) libasyncns; };

  libcap_ng = callPackage (
    {
      python,
      pythonImportsCheckHook,
      libcap_ng, # for python3Packages.libcap_ng.tests.python passthru
    }@python3Packages:
    toPythonModule (
      pkgs.libcap_ng.override {
        withPython = true;
        inherit python3Packages;
      }
    )
  ) { };

  libcec =
    (toPythonModule (
      pkgs.libcec.override {
        python3 = python;
        pythonSupport = true;
      }
    )).python;

  libcomps = lib.pipe pkgs.libcomps [
    toPythonModule
    (
      p:
      p.overrideAttrs (super: {
        meta = super.meta // {
          outputsToInstall = [ "py" ];
        };
      })
    )
    (p: p.override { python3 = python; })
    (p: p.py)
  ];

  libdebug = callPackage ./non-by-name/libdebug { inherit (pkgs) zstd; };

  libdnf = lib.pipe pkgs.libdnf [
    toPythonModule
    (
      p:
      p.overrideAttrs (super: {
        meta = super.meta // {
          outputsToInstall = [ "py" ];
        };
      })
    )
    (p: p.override { python3 = python; })
    (p: p.py)
  ];

  libfdt = toPythonModule (
    pkgs.dtc.override {
      inherit python;
      pythonSupport = true;
    }
  );

  libfive = toPythonModule (pkgs.libfive.override { python3 = python; });

  libiio =
    (toPythonModule (
      pkgs.libiio.override {
        pythonSupport = true;
        python3 = python;
      }
    )).python;

  libloot = callPackage ./non-by-name/libloot {
    libloot-native = pkgs.libloot;
  };

  liblzfse = callPackage ./non-by-name/liblzfse { inherit (pkgs) lzfse; };

  libmodulemd = lib.pipe pkgs.libmodulemd [
    toPythonModule
    (
      p:
      p.overrideAttrs (super: {
        meta = super.meta // {
          outputsToInstall = [ "py" ]; # The package always builds python3 bindings
          broken = (super.meta.broken or false) || !isPy3k;
        };
      })
    )
    (p: p.override { python3 = python; })
    (p: p.py)
  ];

  libnacl = callPackage ./non-by-name/libnacl { inherit (pkgs) libsodium; };

  libnbd = toPythonModule (
    pkgs.libnbd.override {
      buildPythonBindings = true;
      python3 = python;
    }
  );

  libpcap = callPackage ./non-by-name/libpcap {
    pkgsLibpcap = pkgs.libpcap; # Needs the C library
  };

  libpwquality = lib.pipe pkgs.libpwquality [
    toPythonModule
    (
      p:
      p.overrideAttrs (super: {
        meta = super.meta // {
          outputsToInstall = [ "py" ];
        };
      })
    )
    (
      p:
      p.override {
        enablePython = true;
        python3 = python;
      }
    )
    (p: p.py)
  ];

  libredwg = toPythonModule (
    pkgs.libredwg.override {
      enablePython = true;
      inherit (self) python libxml2;
    }
  );

  librepo = lib.pipe pkgs.librepo [
    toPythonModule
    (
      p:
      p.overrideAttrs (super: {
        meta = super.meta // {
          outputsToInstall = [ "py" ];
        };
      })
    )
    (p: p.override { python3 = python; })
    (p: p.py)
  ];

  libsass = callPackage ./non-by-name/libsass { inherit (pkgs) libsass; };

  libsbml = toPythonModule (
    pkgs.libsbml.override {
      withPython = true;
      inherit (self) python;
    }
  );

  libselinux = lib.pipe pkgs.libselinux [
    toPythonModule
    (
      p:
      p.overrideAttrs (super: {
        meta = super.meta // {
          outputsToInstall = [ "py" ];
        };
      })
    )
    (
      p:
      p.override {
        enablePython = true;
        python3 = python;
        python3Packages = self;
      }
    )
    (p: p.py)
  ];

  libsixel = callPackage ./non-by-name/libsixel { inherit (pkgs) libsixel; };

  libtorrent-rasterbar =
    (toPythonModule (pkgs.libtorrent-rasterbar.override { python3 = python; })).python;

  libusb-package = callPackage ./non-by-name/libusb-package {
    inherit (pkgs) libusb1;
  };

  libusb1 = callPackage ./non-by-name/libusb1 { inherit (pkgs) libusb1; };

  libusbsio = callPackage ./non-by-name/libusbsio { inherit (pkgs) libusbsio; };

  libversion = callPackage ./non-by-name/libversion { inherit (pkgs) libversion; };

  libvirt-python = callPackage ./non-by-name/libvirt-python {
    inherit (pkgs) libvirt;
  };

  libxc = callPackage ../../by-name/li/libxc/python.nix {
    libxc = pkgs.libxc_7;
  };

  libxml2 =
    (toPythonModule (
      pkgs.libxml2.override {
        pythonSupport = true;
        python3 = python;
      }
    )).py;

  libxslt =
    (toPythonModule (
      pkgs.libxslt.override {
        pythonSupport = true;
        python3 = python;
        inherit (self) libxml2;
      }
    )).py;

  lief = (toPythonModule (pkgs.lief.override { python3 = python; })).py;

  lirc = toPythonModule (pkgs.lirc.override { python3 = python; });

  lln-libparse = callPackage ./non-by-name/lln-libparse/package.nix { };

  llvmlite = callPackage ./non-by-name/llvmlite {
    inherit (pkgs) cmake ninja;
  };

  lmdb = callPackage ./non-by-name/lmdb { inherit (pkgs) lmdb; };

  logilab-common = callPackage ./non-by-name/logilab/common.nix {
    pytestCheckHook = pytest7CheckHook;
  };

  logilab-constraint = callPackage ./non-by-name/logilab/constraint.nix { };

  lsprotocol = callPackage ./non-by-name/lsprotocol { };

  lsprotocol_2023 = callPackage ./non-by-name/lsprotocol/2023.nix { };

  lxml = callPackage ./non-by-name/lxml { inherit (pkgs) libxml2 libxslt zlib; };

  manifestparser = callPackage ./non-by-name/marionette-harness/manifestparser.nix { };

  marisa = callPackage ./non-by-name/marisa { inherit (pkgs) marisa; };

  marisa-trie = callPackage ./non-by-name/marisa-trie {
    marisa-cpp = pkgs.marisa;
  };

  materialx = toPythonModule (
    pkgs.materialx.override {
      python3Packages = self;
      pythonSupport = true;
    }
  );

  matplotlib = callPackage ./non-by-name/matplotlib {
    stdenv = if stdenv.hostPlatform.isDarwin then pkgs.clangStdenv else pkgs.stdenv;
  };

  matscipy = callPackage ./non-by-name/matscipy { };

  mautrix-appservice = self.mautrix; # alias 2019-12-28

  mcp = callPackage ./non-by-name/mcp { };

  mcp_1 = callPackage ./non-by-name/mcp/1.nix { };

  mercurial = toPythonModule (pkgs.mercurial.override { python3Packages = self; });

  meson = toPythonModule (
    (pkgs.meson.override { python3 = python; }).overridePythonAttrs (oldAttrs: {
      # We do not want the setup hook in Python packages because the build is performed differently.
      setupHook = null;
    })
  );

  meson-python = callPackage ./non-by-name/meson-python { inherit (pkgs) ninja; };

  mhcflurry = callPackage ./non-by-name/mhcflurry { };

  mim-solvers = callPackage ./non-by-name/mim-solvers { inherit (pkgs) mim-solvers; };

  mininet-python = (toPythonModule (pkgs.mininet.override { python3 = python; })).py;

  mistune = callPackage ./non-by-name/mistune { };

  mistune_2 = callPackage ./non-by-name/mistune/2.nix { };

  mitmproxy-linux = callPackage ./non-by-name/mitmproxy-linux { };

  mlt = toPythonModule (
    pkgs.mlt.override {
      python3 = python;
      enablePython = true;
    }
  );

  mlx = callPackage ./non-by-name/mlx { };

  mlx-bin = callPackage ./non-by-name/mlx/bin.nix { };

  mlx-metal = callPackage ./non-by-name/mlx/metal.nix { };

  mlx-metal-macos15 = self.mlx-metal.override { macosVariant = "15"; };

  mlx-metal-macos26 = self.mlx-metal.override { macosVariant = "26"; };

  mlxtend = callPackage ./non-by-name/mlxtend { };

  moderngl-window = callPackage ./non-by-name/moderngl-window {
    inherit (pkgs) mesa;
  };

  molecule = callPackage ./non-by-name/molecule { };

  molecule-plugins = callPackage ./non-by-name/molecule/plugins.nix { };

  monosat = callPackage pkgs.monosat.python { };

  mozjpeg_lossless_optimization = callPackage ./non-by-name/mozjpeg_lossless_optimization { };

  mpl-typst = callPackage ./non-by-name/mpl-typst {
    inherit (pkgs) typst;
  };

  mpv = callPackage ./non-by-name/mpv { inherit (pkgs) mpv; };

  mujoco-core = callPackage ./non-by-name/mujoco-core { inherit (pkgs) mujoco; };

  mujoco-mjx = callPackage ./non-by-name/mujoco-mjx { mujoco-main = pkgs.mujoco; };

  myhdl = callPackage ./non-by-name/myhdl { inherit (pkgs) ghdl iverilog; };

  mypy = callPackage ./non-by-name/mypy { };

  inherit (callPackage ./non-by-name/mypy-boto3 { })
    mypy-boto3-accessanalyzer
    mypy-boto3-account
    mypy-boto3-acm
    mypy-boto3-acm-pca
    mypy-boto3-amp
    mypy-boto3-amplify
    mypy-boto3-amplifybackend
    mypy-boto3-amplifyuibuilder
    mypy-boto3-apigateway
    mypy-boto3-apigatewaymanagementapi
    mypy-boto3-apigatewayv2
    mypy-boto3-appconfig
    mypy-boto3-appconfigdata
    mypy-boto3-appfabric
    mypy-boto3-appflow
    mypy-boto3-appintegrations
    mypy-boto3-application-autoscaling
    mypy-boto3-application-insights
    mypy-boto3-applicationcostprofiler
    mypy-boto3-appmesh
    mypy-boto3-apprunner
    mypy-boto3-appstream
    mypy-boto3-appsync
    mypy-boto3-arc-zonal-shift
    mypy-boto3-athena
    mypy-boto3-auditmanager
    mypy-boto3-autoscaling
    mypy-boto3-autoscaling-plans
    mypy-boto3-backup
    mypy-boto3-backup-gateway
    mypy-boto3-batch
    mypy-boto3-billingconductor
    mypy-boto3-braket
    mypy-boto3-budgets
    mypy-boto3-ce
    mypy-boto3-chime
    mypy-boto3-chime-sdk-identity
    mypy-boto3-chime-sdk-media-pipelines
    mypy-boto3-chime-sdk-meetings
    mypy-boto3-chime-sdk-messaging
    mypy-boto3-chime-sdk-voice
    mypy-boto3-cleanrooms
    mypy-boto3-cloud9
    mypy-boto3-cloudcontrol
    mypy-boto3-clouddirectory
    mypy-boto3-cloudformation
    mypy-boto3-cloudfront
    mypy-boto3-cloudhsm
    mypy-boto3-cloudhsmv2
    mypy-boto3-cloudsearch
    mypy-boto3-cloudsearchdomain
    mypy-boto3-cloudtrail
    mypy-boto3-cloudtrail-data
    mypy-boto3-cloudwatch
    mypy-boto3-codeartifact
    mypy-boto3-codebuild
    mypy-boto3-codecatalyst
    mypy-boto3-codecommit
    mypy-boto3-codedeploy
    mypy-boto3-codeguru-reviewer
    mypy-boto3-codeguru-security
    mypy-boto3-codeguruprofiler
    mypy-boto3-codepipeline
    mypy-boto3-codestar
    mypy-boto3-codestar-connections
    mypy-boto3-codestar-notifications
    mypy-boto3-cognito-identity
    mypy-boto3-cognito-idp
    mypy-boto3-cognito-sync
    mypy-boto3-comprehend
    mypy-boto3-comprehendmedical
    mypy-boto3-compute-optimizer
    mypy-boto3-config
    mypy-boto3-connect
    mypy-boto3-connect-contact-lens
    mypy-boto3-connectcampaigns
    mypy-boto3-connectcases
    mypy-boto3-connectparticipant
    mypy-boto3-controltower
    mypy-boto3-cur
    mypy-boto3-customer-profiles
    mypy-boto3-databrew
    mypy-boto3-dataexchange
    mypy-boto3-datapipeline
    mypy-boto3-datasync
    mypy-boto3-dax
    mypy-boto3-detective
    mypy-boto3-devicefarm
    mypy-boto3-devops-guru
    mypy-boto3-directconnect
    mypy-boto3-discovery
    mypy-boto3-dlm
    mypy-boto3-dms
    mypy-boto3-docdb
    mypy-boto3-docdb-elastic
    mypy-boto3-drs
    mypy-boto3-ds
    mypy-boto3-dynamodb
    mypy-boto3-dynamodbstreams
    mypy-boto3-ebs
    mypy-boto3-ec2
    mypy-boto3-ec2-instance-connect
    mypy-boto3-ecr
    mypy-boto3-ecr-public
    mypy-boto3-ecs
    mypy-boto3-efs
    mypy-boto3-eks
    mypy-boto3-elastic-inference
    mypy-boto3-elasticache
    mypy-boto3-elasticbeanstalk
    mypy-boto3-elastictranscoder
    mypy-boto3-elb
    mypy-boto3-elbv2
    mypy-boto3-emr
    mypy-boto3-emr-containers
    mypy-boto3-emr-serverless
    mypy-boto3-entityresolution
    mypy-boto3-es
    mypy-boto3-events
    mypy-boto3-evidently
    mypy-boto3-finspace
    mypy-boto3-finspace-data
    mypy-boto3-firehose
    mypy-boto3-fis
    mypy-boto3-fms
    mypy-boto3-forecast
    mypy-boto3-forecastquery
    mypy-boto3-frauddetector
    mypy-boto3-fsx
    mypy-boto3-gamelift
    mypy-boto3-glacier
    mypy-boto3-globalaccelerator
    mypy-boto3-glue
    mypy-boto3-grafana
    mypy-boto3-greengrass
    mypy-boto3-greengrassv2
    mypy-boto3-groundstation
    mypy-boto3-guardduty
    mypy-boto3-health
    mypy-boto3-healthlake
    mypy-boto3-iam
    mypy-boto3-identitystore
    mypy-boto3-imagebuilder
    mypy-boto3-importexport
    mypy-boto3-inspector
    mypy-boto3-inspector2
    mypy-boto3-internetmonitor
    mypy-boto3-iot
    mypy-boto3-iot-data
    mypy-boto3-iot-jobs-data
    mypy-boto3-iot1click-devices
    mypy-boto3-iot1click-projects
    mypy-boto3-iotanalytics
    mypy-boto3-iotdeviceadvisor
    mypy-boto3-iotevents
    mypy-boto3-iotevents-data
    mypy-boto3-iotfleethub
    mypy-boto3-iotfleetwise
    mypy-boto3-iotsecuretunneling
    mypy-boto3-iotsitewise
    mypy-boto3-iotthingsgraph
    mypy-boto3-iottwinmaker
    mypy-boto3-iotwireless
    mypy-boto3-ivs
    mypy-boto3-ivs-realtime
    mypy-boto3-ivschat
    mypy-boto3-kafka
    mypy-boto3-kafkaconnect
    mypy-boto3-kendra
    mypy-boto3-kendra-ranking
    mypy-boto3-keyspaces
    mypy-boto3-kinesis
    mypy-boto3-kinesis-video-archived-media
    mypy-boto3-kinesis-video-media
    mypy-boto3-kinesis-video-signaling
    mypy-boto3-kinesis-video-webrtc-storage
    mypy-boto3-kinesisanalytics
    mypy-boto3-kinesisanalyticsv2
    mypy-boto3-kinesisvideo
    mypy-boto3-kms
    mypy-boto3-lakeformation
    mypy-boto3-lambda
    mypy-boto3-lex-models
    mypy-boto3-lex-runtime
    mypy-boto3-lexv2-models
    mypy-boto3-lexv2-runtime
    mypy-boto3-license-manager
    mypy-boto3-license-manager-linux-subscriptions
    mypy-boto3-license-manager-user-subscriptions
    mypy-boto3-lightsail
    mypy-boto3-location
    mypy-boto3-logs
    mypy-boto3-lookoutequipment
    mypy-boto3-lookoutmetrics
    mypy-boto3-lookoutvision
    mypy-boto3-m2
    mypy-boto3-machinelearning
    mypy-boto3-macie2
    mypy-boto3-managedblockchain
    mypy-boto3-managedblockchain-query
    mypy-boto3-marketplace-catalog
    mypy-boto3-marketplace-entitlement
    mypy-boto3-marketplacecommerceanalytics
    mypy-boto3-mediaconnect
    mypy-boto3-mediaconvert
    mypy-boto3-medialive
    mypy-boto3-mediapackage
    mypy-boto3-mediapackage-vod
    mypy-boto3-mediapackagev2
    mypy-boto3-mediastore
    mypy-boto3-mediastore-data
    mypy-boto3-mediatailor
    mypy-boto3-medical-imaging
    mypy-boto3-memorydb
    mypy-boto3-meteringmarketplace
    mypy-boto3-mgh
    mypy-boto3-mgn
    mypy-boto3-migration-hub-refactor-spaces
    mypy-boto3-migrationhub-config
    mypy-boto3-migrationhuborchestrator
    mypy-boto3-migrationhubstrategy
    mypy-boto3-mq
    mypy-boto3-mturk
    mypy-boto3-mwaa
    mypy-boto3-neptune
    mypy-boto3-neptunedata
    mypy-boto3-network-firewall
    mypy-boto3-networkmanager
    mypy-boto3-nimble
    mypy-boto3-oam
    mypy-boto3-omics
    mypy-boto3-opensearch
    mypy-boto3-opensearchserverless
    mypy-boto3-opsworks
    mypy-boto3-opsworkscm
    mypy-boto3-organizations
    mypy-boto3-osis
    mypy-boto3-outposts
    mypy-boto3-panorama
    mypy-boto3-payment-cryptography
    mypy-boto3-payment-cryptography-data
    mypy-boto3-pca-connector-ad
    mypy-boto3-personalize
    mypy-boto3-personalize-events
    mypy-boto3-personalize-runtime
    mypy-boto3-pi
    mypy-boto3-pinpoint
    mypy-boto3-pinpoint-email
    mypy-boto3-pinpoint-sms-voice
    mypy-boto3-pinpoint-sms-voice-v2
    mypy-boto3-pipes
    mypy-boto3-polly
    mypy-boto3-pricing
    mypy-boto3-privatenetworks
    mypy-boto3-proton
    mypy-boto3-qldb
    mypy-boto3-qldb-session
    mypy-boto3-quicksight
    mypy-boto3-ram
    mypy-boto3-rbin
    mypy-boto3-rds
    mypy-boto3-rds-data
    mypy-boto3-redshift
    mypy-boto3-redshift-data
    mypy-boto3-redshift-serverless
    mypy-boto3-rekognition
    mypy-boto3-resiliencehub
    mypy-boto3-resource-explorer-2
    mypy-boto3-resource-groups
    mypy-boto3-resourcegroupstaggingapi
    mypy-boto3-robomaker
    mypy-boto3-rolesanywhere
    mypy-boto3-route53
    mypy-boto3-route53-recovery-cluster
    mypy-boto3-route53-recovery-control-config
    mypy-boto3-route53-recovery-readiness
    mypy-boto3-route53domains
    mypy-boto3-route53resolver
    mypy-boto3-rum
    mypy-boto3-s3
    mypy-boto3-s3control
    mypy-boto3-s3outposts
    mypy-boto3-sagemaker
    mypy-boto3-sagemaker-a2i-runtime
    mypy-boto3-sagemaker-edge
    mypy-boto3-sagemaker-featurestore-runtime
    mypy-boto3-sagemaker-geospatial
    mypy-boto3-sagemaker-metrics
    mypy-boto3-sagemaker-runtime
    mypy-boto3-savingsplans
    mypy-boto3-scheduler
    mypy-boto3-schemas
    mypy-boto3-sdb
    mypy-boto3-secretsmanager
    mypy-boto3-securityhub
    mypy-boto3-securitylake
    mypy-boto3-serverlessrepo
    mypy-boto3-service-quotas
    mypy-boto3-servicecatalog
    mypy-boto3-servicecatalog-appregistry
    mypy-boto3-servicediscovery
    mypy-boto3-ses
    mypy-boto3-sesv2
    mypy-boto3-shield
    mypy-boto3-signer
    mypy-boto3-simspaceweaver
    mypy-boto3-sms
    mypy-boto3-sms-voice
    mypy-boto3-snow-device-management
    mypy-boto3-snowball
    mypy-boto3-sns
    mypy-boto3-sqs
    mypy-boto3-ssm
    mypy-boto3-ssm-contacts
    mypy-boto3-ssm-incidents
    mypy-boto3-ssm-sap
    mypy-boto3-sso
    mypy-boto3-sso-admin
    mypy-boto3-sso-oidc
    mypy-boto3-stepfunctions
    mypy-boto3-storagegateway
    mypy-boto3-sts
    mypy-boto3-support
    mypy-boto3-support-app
    mypy-boto3-swf
    mypy-boto3-synthetics
    mypy-boto3-textract
    mypy-boto3-timestream-query
    mypy-boto3-timestream-write
    mypy-boto3-tnb
    mypy-boto3-transcribe
    mypy-boto3-transfer
    mypy-boto3-translate
    mypy-boto3-verifiedpermissions
    mypy-boto3-voice-id
    mypy-boto3-vpc-lattice
    mypy-boto3-waf
    mypy-boto3-waf-regional
    mypy-boto3-wafv2
    mypy-boto3-wellarchitected
    mypy-boto3-wisdom
    mypy-boto3-workdocs
    mypy-boto3-worklink
    mypy-boto3-workmail
    mypy-boto3-workmailmessageflow
    mypy-boto3-workspaces
    mypy-boto3-workspaces-web
    mypy-boto3-xray
    ;

  mypy-extensions = callPackage ./non-by-name/mypy/extensions.nix { };

  mypy-protobuf_3_6 = callPackage ./non-by-name/mypy-protobuf_3_6 { };

  nanoarrow = callPackage ./non-by-name/nanoarrow {
    zstd-c = pkgs.zstd;
    nanoarrow-c = pkgs.nanoarrow;
  };

  nanobind_3 = callPackage ./non-by-name/nanobind_3 { };

  nanomsg = callPackage ./non-by-name/nanomsg {
    inherit (pkgs) nanomsg;
  };

  napalm = callPackage ./non-by-name/napalm { };

  napalm-hp-procurve = callPackage ./non-by-name/napalm/hp-procurve.nix { };

  napalm-ros = callPackage ./non-by-name/napalm/ros.nix { };

  ndcurves = callPackage ./non-by-name/ndcurves { inherit (pkgs) ndcurves; };

  nemo-relay = callPackage ./non-by-name/nemo-relay {
    inherit (pkgs) zstd;
  };

  nest = toPythonModule (
    pkgs.nest-mpi.override {
      withPython = true;
      python3 = python;
    }
  );

  netgen-mesher = toPythonModule (pkgs.netgen.override { python3Packages = self; });

  neuron-full = pkgs.neuron-full.override { python3 = python; };

  neuronpy = toPythonModule neuron-full;

  nftables = callPackage ../../by-name/nf/nftables/python.nix { };

  ninja = callPackage ./non-by-name/ninja { inherit (pkgs) ninja; };

  nipype = callPackage ./non-by-name/nipype { inherit (pkgs) which; };

  nix-kernel = callPackage ./non-by-name/nix-kernel { inherit (pkgs) nix; };

  nixl = callPackage ./non-by-name/nixl {
    nixl = pkgs.nixl.override { python3Packages = self; };
  };

  nnpdf = toPythonModule (pkgs.nnpdf.override { python3 = python; });

  nominatim-api = callPackage ../../by-name/no/nominatim/nominatim-api.nix { };

  notmuch = callPackage ./non-by-name/notmuch { inherit (pkgs) notmuch; };

  notmuch2 = callPackage ./non-by-name/notmuch2 { inherit (pkgs) notmuch; };

  numba = callPackage ./non-by-name/numba { inherit (pkgs.config) cudaSupport; };

  numbaWithCuda = self.numba.override { cudaSupport = true; };

  numcodecs = callPackage ./non-by-name/numcodecs {
    inherit (pkgs) zstd;
  };

  nutpie = callPackage ./non-by-name/nutpie { inherit (pkgs) zstd; };

  nvidia-cutlass-operators = callPackage ./non-by-name/nvidia-cutlass-operators { };

  nvtx = callPackage ./non-by-name/nvtx {
    # Only for its source and versions. Every CUDA package set from 12.9 on has the same source
    # build, while earlier ones (possibly the default cudaPackages) use the redistributable.
    inherit (pkgs.cudaPackages) nvtx;
  };

  objgraph = callPackage ./non-by-name/objgraph {
    # requires both the graphviz package and python package
    graphvizPkgs = pkgs.graphviz;
  };

  ocrmypdf = callPackage ./non-by-name/ocrmypdf { tesseract = pkgs.tesseract5; };

  omniorb = toPythonModule (pkgs.omniorb.override { python3 = self.python; });

  onnx = callPackage ./non-by-name/onnx {
    onnx = pkgs.onnx.override {
      python3Packages = self;
    };
  };

  onnxruntime = callPackage ./non-by-name/onnxruntime {
    onnxruntime = pkgs.onnxruntime.override {
      python3Packages = self;
      pythonSupport = true;
    };
    inherit (pkgs) openvino;
  };

  openbabel = toPythonModule (pkgs.openbabel.override { python3 = python; });

  opencv4 = toPythonModule (
    pkgs.opencv4.override {
      enablePython = true;
      pythonPackages = self;
    }
  );

  opencv4Full = toPythonModule (
    pkgs.opencv4.override rec {
      enablePython = true;
      pythonPackages = self;
      enableCuda = pkgs.config.cudaSupport;
      enableCublas = enableCuda;
      enableCudnn = enableCuda;
      enableCufft = enableCuda;
      enableLto = !stdenv.hostPlatform.isLinux; # https://github.com/NixOS/nixpkgs/issues/343123
      enableUnfree = false; # prevents cache
      enableIpp = true;
      enableGtk3 = true;
      enableVtk = true;
      enableFfmpeg = true;
      enableGStreamer = true;
      enableTesseract = true;
      enableTbb = true;
      enableOvis = true;
      enableGPhoto2 = true;
      enableDC1394 = true;
      enableDocs = true;
    }
  );

  openimageio = toPythonModule (
    pkgs.openimageio.override {
      enablePython = true;
      python3Packages = self;
    }
  );

  openmm = toPythonModule (
    pkgs.openmm.override {
      python3Packages = self;
      enablePython = true;
    }
  );

  openpaperwork-core = callPackage ../../applications/office/paperwork/openpaperwork-core.nix { };

  openpaperwork-gtk = callPackage ../../applications/office/paperwork/openpaperwork-gtk.nix { };

  openrazer = callPackage ./non-by-name/openrazer/pylib.nix { };

  openrazer-daemon = callPackage ./non-by-name/openrazer/daemon.nix { };

  opensearch-py = callPackage ./non-by-name/opensearch-py { };

  openshadinglanguage = toPythonModule (
    pkgs.openshadinglanguage.override { python3Packages = self; }
  );

  openslide-python = callPackage ./non-by-name/openslide-python {
    inherit (pkgs) openslide;
  };

  openturns = toPythonModule (
    pkgs.openturns.override {
      python3Packages = self;
      enablePython = true;
    }
  );

  openusd = callPackage ./non-by-name/openusd { alembic = pkgs.alembic; };

  openvino = callPackage ./non-by-name/openvino {
    openvino-native = pkgs.openvino.override { python3Packages = self; };
  };

  openvino-genai = callPackage ./non-by-name/openvino-genai {
    openvino-genai-native = pkgs.openvino-genai.override { python3Packages = self; };
  };

  openvino-tokenizers = callPackage ./non-by-name/openvino-tokenizers {
    openvino-tokenizers-native = pkgs.openvino-tokenizers;
  };

  ortools = callPackage ./non-by-name/ortools {
    or-tools = pkgs.or-tools.override { python3 = self.python; };
  };

  osadl-matrix = callPackage ./non-by-name/osadl-matrix/default.nix { };

  osmium = callPackage ./non-by-name/osmium { inherit (pkgs) lz4; };

  ouster-sdk = callPackage ./non-by-name/ouster-sdk {
    inherit (pkgs) ouster-sdk;
  };

  paho-mqtt = callPackage ./non-by-name/paho-mqtt/default.nix { };

  pandas = callPackage ./non-by-name/pandas { inherit (pkgs.darwin) adv_cmds; };

  paperless-ngx-erechnung = callPackage ./non-by-name/paperless-ngx-erechnung {
    inherit (pkgs) fop;
  };

  paperwork-backend = callPackage ../../applications/office/paperwork/paperwork-backend.nix { };

  paperwork-shell = callPackage ../../applications/office/paperwork/paperwork-shell.nix { };

  pcapy-ng = callPackage ./non-by-name/pcapy-ng {
    inherit (pkgs) libpcap; # Avoid confusion with python package of the same name
  };

  peewee = callPackage ./non-by-name/peewee { };

  peewee-migrate = callPackage ./non-by-name/peewee-migrate { };

  peewee-migrate_1 = callPackage ./non-by-name/peewee-migrate/1.nix { };

  peewee_3 = callPackage ./non-by-name/peewee/3.nix { };

  pelican = callPackage ./non-by-name/pelican { inherit (pkgs) glibcLocales git; };

  petsc4py = toPythonModule (
    pkgs.petsc.override {
      python3Packages = self;
      pythonSupport = true;
    }
  );

  pigpio = toPythonModule (
    pkgs.pigpio.override {
      inherit buildPythonPackage;
    }
  );

  pillow = callPackage ./non-by-name/pillow {
    inherit (pkgs)
      freetype
      lcms2
      libavif
      libimagequant
      libjpeg
      libraqm
      libtiff
      libwebp
      openjpeg
      zlib-ng
      libxcb
      ;
  };

  pinocchio = callPackage ./non-by-name/pinocchio { inherit (pkgs) pinocchio; };

  pip-requirements-parser = callPackage ./non-by-name/pip-requirements-parser { };

  piper-phonemize = callPackage ./non-by-name/piper-phonemize {
    onnxruntime-native = pkgs.onnxruntime;
    piper-phonemize-native = pkgs.piper-phonemize;
  };

  pjsua2 =
    (toPythonModule (
      pkgs.pjsip.override {
        pythonSupport = true;
        python3 = self.python;
      }
    )).py;

  plantuml-markdown = callPackage ./non-by-name/plantuml-markdown {
    inherit (pkgs) plantuml;
  };

  plasTeX = callPackage ./non-by-name/plasTeX { };

  plfit = toPythonModule (
    pkgs.plfit.override {
      withPython = true;
      inherit (self) python;
    }
  );

  # Use Plover 5 as Plover 4 depends on setuptool's pkg_resources to discover plugins,
  # which the setuptools upstream deprecated at version 81.0.0 and removed at version 82.0.0
  # Plover 5 has addressed this issue by switching to importlib.meta.distributions()
  #
  # NOTE:
  # Plover 5 moves from PyQt5 to PySide6,
  # which is a backward-incompatible change to graphical plugins.
  # List of unsupported plugins:
  # https://github.com/opensteno/plover_plugins_registry/blob/master/unsupported.json
  plover = plover_5;

  plover_4 = callPackage ./non-by-name/plover/4.nix {
    inherit (pkgs.libsForQt5) wrapQtAppsHook;
  };

  plover_5 = callPackage ./non-by-name/plover/5.nix {
    inherit (pkgs.qt6) qtbase wrapQtAppsHook qtsvg;
  };

  plumed = callPackage ./non-by-name/plumed {
    inherit (pkgs) plumed;
  };

  pocketsphinx = callPackage ./non-by-name/pocketsphinx {
    inherit (pkgs) pocketsphinx;
  };

  poppler-qt5 = callPackage ./non-by-name/poppler-qt5 {
    inherit (pkgs.qt5) qtbase qmake;
    inherit (pkgs.libsForQt5) poppler;
  };

  primp = callPackage ./non-by-name/primp { zstd-c = pkgs.zstd; };

  # If a protobuf upgrade causes many Python packages to fail, please pin it here to the previous version.
  protobuf = protobuf7;

  # Protobuf 4.x
  protobuf4 = callPackage ./non-by-name/protobuf/4.nix {
    protobuf = pkgs.protobuf_25;
  };

  # Protobuf 5.x
  protobuf5 = callPackage ./non-by-name/protobuf/5.nix {
    protobuf = pkgs.__splicedPackages.protobuf_29;
  };

  # Protobuf 6.x
  protobuf6 = callPackage ./non-by-name/protobuf/6.nix {
    protobuf = pkgs.__splicedPackages.protobuf_33;
  };

  # Protobuf 7.x
  protobuf7 = callPackage ./non-by-name/protobuf/7.nix {
    inherit (pkgs.__splicedPackages) protobuf;
  };

  proxsuite = toPythonModule (
    pkgs.proxsuite.override {
      pythonSupport = true;
      python3Packages = self;
    }
  );

  psycopg = callPackage ./non-by-name/psycopg { };

  psycopg-c = psycopg.c;

  psycopg-pool = psycopg.pool;

  pulp = callPackage ./non-by-name/pulp { };

  pulumi-aws-native = callPackage pkgs.pulumiPackages.pulumi-aws-native.sdks.python.override { };

  pulumi-azure-native = callPackage pkgs.pulumiPackages.pulumi-azure-native.sdks.python.override { };

  pulumi-command = callPackage pkgs.pulumiPackages.pulumi-command.sdks.python.override { };

  pulumi-hcloud = callPackage pkgs.pulumiPackages.pulumi-hcloud.sdks.python.override { };

  pulumi-kubernetes =
    callPackage
      (pkgs.pulumiPackages.pulumi-kubernetes.override { python3Packages = self; }).sdks.python.override
      { };

  pulumi-linode = callPackage pkgs.pulumiPackages.pulumi-linode.sdks.python.override { };

  pulumi-random = callPackage pkgs.pulumiPackages.pulumi-random.sdks.python.override { };

  pulumiverse-talos = callPackage pkgs.pulumiPackages.pulumiverse-talos.sdks.python.override { };

  pwntools = callPackage ./non-by-name/pwntools { debugger = pkgs.gdb; };

  py-desmume = callPackage ./non-by-name/py-desmume {
    inherit (pkgs) libpcap; # Avoid confusion with python package of the same name
  };

  py3exiv2 = callPackage ./non-by-name/py3exiv2 { inherit (pkgs) exiv2; };

  pyabpoa = toPythonModule (
    pkgs.abpoa.override {
      enablePython = true;
      python3Packages = self;
    }
  );

  pyarrow = callPackage ./non-by-name/pyarrow { inherit (pkgs) arrow-cpp cmake; };

  pyaskalono = callPackage ./non-by-name/pyaskalono { inherit (pkgs) zstd; };

  pyatspi = callPackage ./non-by-name/pyatspi { inherit (pkgs.buildPackages) meson; };

  pybind11 = callPackage ./non-by-name/pybind11 { };

  pybind11_3_0 = callPackage ./non-by-name/pybind11/3_0.nix { };

  pybluez = callPackage ./non-by-name/pybluez { inherit (pkgs) bluez; };

  pycairo = callPackage ./non-by-name/pycairo { inherit (pkgs.buildPackages) meson; };

  pycangjie = callPackage ./non-by-name/pycangjie {
    inherit (pkgs.buildPackages) meson;
  };

  pycflow2dot = callPackage ./non-by-name/pycflow2dot { inherit (pkgs) graphviz; };

  pydantic = callPackage ./non-by-name/pydantic { };

  pydantic-monty = callPackage ./non-by-name/pydantic-monty {
    inherit (pkgs) zstd;
  };

  pydantic_1 = callPackage ./non-by-name/pydantic/1.nix { };

  pydeep2 = callPackage ./non-by-name/pydeep2 { inherit (pkgs) ssdeep; };

  pydeps = callPackage ./non-by-name/pydeps { inherit (pkgs) graphviz; };

  pydot = callPackage ./non-by-name/pydot { inherit (pkgs) graphviz; };

  pyenchant = callPackage ./non-by-name/pyenchant { inherit (pkgs) enchant_2; };

  pyfwup = callPackage ./non-by-name/pyfwup { inherit (pkgs) libusb1; };

  pyfzf = callPackage ./non-by-name/pyfzf { inherit (pkgs) fzf; };

  # pygame-ce is better maintained upstream, the breaking point was https://github.com/NixOS/nixpkgs/pull/475917#issuecomment-3706940043
  pygame = if pythonAtLeast "3.14" then pygame-ce else pygame-original;

  pygls = callPackage ./non-by-name/pygls { };

  pygls_1 = callPackage ./non-by-name/pygls/1.nix { };

  pygobject3 = callPackage ./non-by-name/pygobject/3.nix {
    # inherit (pkgs) meson won't work because it won't be spliced
    inherit (pkgs.buildPackages) meson;
  };

  pygraphviz = callPackage ./non-by-name/pygraphviz { inherit (pkgs) graphviz; };

  pygrib = callPackage ./non-by-name/pygrib { };

  pygsl = callPackage ./non-by-name/pygsl { inherit (pkgs) gsl swig; };

  pyiceberg-core = callPackage ./non-by-name/pyiceberg-core {
    inherit (pkgs) zstd;
  };

  pyimpfuzzy = callPackage ./non-by-name/pyimpfuzzy { inherit (pkgs) ssdeep; };

  pykdtree = callPackage ./non-by-name/pykdtree {
    inherit (pkgs.llvmPackages) openmp;
  };

  pykerberos = callPackage ./non-by-name/pykerberos { krb5-c = pkgs.krb5; };

  pylance = callPackage ./non-by-name/pylance { };

  pylibdmtx = callPackage ./non-by-name/pylibdmtx { };

  pylibftdi = callPackage ./non-by-name/pylibftdi { inherit (pkgs) libusb1; };

  pyluwen = callPackage ./non-by-name/pyluwen { };

  pymssql = callPackage ./non-by-name/pymssql { krb5-c = pkgs.krb5; };

  pync = callPackage ./non-by-name/pync { inherit (pkgs) which; };

  pyobjc-framework-AVFoundation = callPackage ./non-by-name/pyobjc-framework-AVFoundation { };

  pyobjc-framework-ApplicationServices =
    callPackage ./non-by-name/pyobjc-framework-ApplicationServices
      { };

  pyobjc-framework-Cocoa = callPackage ./non-by-name/pyobjc-framework-Cocoa { };

  pyobjc-framework-CoreAudio = callPackage ./non-by-name/pyobjc-framework-CoreAudio { };

  pyobjc-framework-CoreBluetooth = callPackage ./non-by-name/pyobjc-framework-CoreBluetooth { };

  pyobjc-framework-CoreMedia = callPackage ./non-by-name/pyobjc-framework-CoreMedia { };

  pyobjc-framework-CoreText = callPackage ./non-by-name/pyobjc-framework-CoreText { };

  pyobjc-framework-MediaPlayer = callPackage ./non-by-name/pyobjc-framework-MediaPlayer { };

  pyobjc-framework-Quartz = callPackage ./non-by-name/pyobjc-framework-Quartz { };

  pyobjc-framework-Security = callPackage ./non-by-name/pyobjc-framework-Security { };

  pyobjc-framework-WebKit = callPackage ./non-by-name/pyobjc-framework-WebKit { };

  pyobjc-framework-libdispatch = callPackage ./non-by-name/pyobjc-framework-libdispatch { };

  pyobjus = callPackage ./non-by-name/pyobjus {
    inherit (pkgs) clang;
  };

  pyocr = callPackage ./non-by-name/pyocr { tesseract = pkgs.tesseract4; };

  pyopen-wakeword = callPackage ./non-by-name/pyopen-wakeword/default.nix { };

  pyopengl = callPackage ./non-by-name/pyopengl {
    inherit (pkgs) mesa;
  };

  pypamtest = toPythonModule (
    pkgs.libpam-wrapper.override {
      enablePython = true;
      inherit python;
    }
  );

  pyprecice = callPackage ./non-by-name/pyprecice {
    precice = pkgs.precice.override {
      python3Packages = self;
    };
  };

  pyqt5 = callPackage ./non-by-name/pyqt/5.x.nix { inherit (pkgs) mesa; };

  pyqt5-multimedia = self.pyqt5.override { withMultimedia = true; };

  pyqt5-sip = callPackage ./non-by-name/pyqt/sip.nix {
    inherit (pkgs) mesa;
  };

  pyqt6 = callPackage ./non-by-name/pyqt/6.x.nix {
    inherit (pkgs) mesa;
  };

  pyqt6-charts = callPackage ./non-by-name/pyqt6-charts {
    inherit (pkgs) mesa;
  };

  pyqt6-qscintilla = callPackage ./non-by-name/qscintilla { };

  pyqt6-sip = callPackage ./non-by-name/pyqt/pyqt6-sip.nix {
    inherit (pkgs) mesa;
  };

  pyqt6-webengine = callPackage ./non-by-name/pyqt6-webengine {
    inherit (pkgs) mesa;
  };

  pyrate-limiter_2 = callPackage ./non-by-name/pyrate-limiter_2 { };

  pyrealsense2 = toPythonModule (
    pkgs.librealsense.override {
      enablePython = true;
      pythonPackages = self;
    }
  );

  pyrealsense2WithCuda = toPythonModule (
    pkgs.librealsenseWithCuda.override {
      cudaSupport = true;
      enablePython = true;
      pythonPackages = self;
    }
  );

  pyrealsense2WithoutCuda = toPythonModule (
    pkgs.librealsenseWithoutCuda.override {
      enablePython = true;
      pythonPackages = self;
    }
  );

  pyrender = callPackage ./non-by-name/pyrender {
    inherit (pkgs) mesa;
  };

  pyreqwest = callPackage ./non-by-name/pyreqwest { zstd-c = pkgs.zstd; };

  pysail = callPackage ./non-by-name/pysail {
    protoc = pkgs.protobuf;
    inherit (pkgs) zstd;
  };

  pysaml2 = callPackage ./non-by-name/pysaml2 { inherit (pkgs) xmlsec; };

  pyscf = callPackage ./non-by-name/pyscf {
    inherit (pkgs) libxc;
  };

  pysearpc = toPythonModule (pkgs.libsearpc.override { python3 = self.python; });

  pyshark = callPackage ./non-by-name/pyshark { };

  pyside2 = toPythonModule (callPackage ./non-by-name/pyside2 { inherit (pkgs) cmake ninja qt5; });

  pyside2-tools = toPythonModule (
    callPackage ./non-by-name/pyside2-tools { inherit (pkgs) cmake qt5; }
  );

  pyside6 = toPythonModule (callPackage ./non-by-name/pyside6 { inherit (pkgs) cmake ninja; });

  pyslurm = callPackage ./non-by-name/pyslurm { inherit (pkgs) slurm; };

  pysoundfile = self.soundfile; # Alias added 23-06-2019

  pystemd = callPackage ./non-by-name/pystemd { inherit (pkgs) systemd; };

  pystrich = callPackage ./non-by-name/pystrich {
    inherit (pkgs) ghostscript;
  };

  pysvn = callPackage ./non-by-name/pysvn {
    inherit (pkgs)
      bash
      subversion
      apr
      aprutil
      ;
  };

  pytelegrambotapi = callPackage ./non-by-name/pyTelegramBotAPI { };

  pytest = callPackage ./non-by-name/pytest { };

  pytest-asyncio = callPackage ./non-by-name/pytest-asyncio { };

  pytest-asyncio_0 = callPackage ./non-by-name/pytest-asyncio/0.nix { };

  pytest-cache = self.pytestcache; # added 2021-01-04

  pytest-django_4_12 = callPackage ./non-by-name/pytest-django_4_12 { };

  pytest-services = callPackage ./non-by-name/pytest-services {
    inherit (pkgs) memcached;
  };

  pytest7CheckHook = pytestCheckHook.override { pytest = pytest_7; };

  pytest8_3CheckHook = pytestCheckHook.override { pytest = pytest_8_3; };

  pytest9_0CheckHook = pytestCheckHook.override { pytest = pytest_9_0; };

  pytest_7 = callPackage ./non-by-name/pytest/7.nix { };

  pytest_8_3 = callPackage ./non-by-name/pytest/8_3.nix { };

  pytest_9_0 = callPackage ./non-by-name/pytest/9_0.nix { };

  python-augeas = callPackage ./non-by-name/python-augeas { inherit (pkgs) augeas; };

  python-ldap = callPackage ./non-by-name/python-ldap {
    inherit (pkgs) openldap cyrus_sasl;
  };

  python-libpcap = callPackage ./non-by-name/python-libpcap {
    inherit (pkgs) libpcap;
  };

  python-lzo = callPackage ./non-by-name/python-lzo { inherit (pkgs) lzo; };

  python-mapnik = callPackage ./non-by-name/python-mapnik rec {
    inherit (pkgs)
      pkg-config
      cairo
      icu
      libjpeg
      libpng
      libtiff
      libwebp
      proj
      zlib
      ;
    boost = pkgs.boost.override {
      enablePython = true;
      inherit python;
    };
    harfbuzz = pkgs.harfbuzz.override { withIcu = true; };
    mapnik = pkgs.mapnik.override { inherit boost harfbuzz; };
  };

  python-matter-server = callPackage ./non-by-name/python-matter-server { };

  python-memcached = callPackage ./non-by-name/python-memcached {
    inherit (pkgs) memcached;
  };

  python-mpv-jsonipc = callPackage ./non-by-name/python-mpv-jsonipc {
    inherit (pkgs) mpv;
  };

  python-pam = callPackage ./non-by-name/python-pam { inherit (pkgs) pam; };

  python-sbom = callPackage ./non-by-name/python-sbom { inherit (pkgs) cmake; };

  python-snap7 = callPackage ./non-by-name/python-snap7 { inherit (pkgs) snap7; };

  python-snappy = callPackage ./non-by-name/python-snappy {
    snappy-cpp = pkgs.snappy;
  };

  python-statemachine = callPackage ./non-by-name/python-statemachine {
    inherit (pkgs) graphviz;
  };

  python-subunit = callPackage ./non-by-name/python-subunit {
    inherit (pkgs) subunit cppunit check;
  };

  python-xapp = callPackage ./non-by-name/python-xapp {
    inherit (pkgs.buildPackages) meson;
    inherit (pkgs)
      gtk3
      gobject-introspection
      polkit
      xapp
      ;
  };

  pythonocc-core = toPythonModule (
    callPackage ./non-by-name/pythonocc-core {
      inherit (pkgs)
        fontconfig
        rapidjson
        libx11
        libxi
        libxmu
        libxext
        ;
    }
  );

  pythran = callPackage ./non-by-name/pythran { inherit (pkgs.llvmPackages) openmp; };

  pytz = callPackage ./non-by-name/pytz {
    inherit (pkgs) tzdata;
  };

  pyudev = callPackage ./non-by-name/pyudev { inherit (pkgs) udev; };

  pyusb = callPackage ./non-by-name/pyusb { inherit (pkgs) libusb1; };

  pyvips = callPackage ./non-by-name/pyvips { inherit (pkgs) vips glib; };

  pywbem = callPackage ./non-by-name/pywbem { inherit (pkgs) libxml2; };

  pywidevine = callPackage ./non-by-name/pywidevine {
    protobuf = protobuf6;
  };

  pyxdia = callPackage ./non-by-name/pyxdia { };

  pyzfs_2_3 = toPythonModule (
    pkgs.zfs_2_3.override {
      enablePyzfs = true;
      python3Packages = self;
    }
  );

  pyzfs_2_4 = toPythonModule (
    pkgs.zfs_2_4.override {
      enablePyzfs = true;
      python3Packages = self;
    }
  );

  pyzstd = callPackage ./non-by-name/pyzstd { zstd-c = pkgs.zstd; };

  qdldl = callPackage ./non-by-name/qdldl { inherit (pkgs) qdldl; };

  qemu = callPackage ./non-by-name/qemu { qemu = pkgs.qemu; };

  qh3 = callPackage ./non-by-name/qh3 {
    inherit (pkgs) cmake;
  };

  qrcodegen = callPackage ./non-by-name/qrcodegen { qrcodegen = pkgs.qrcodegen; };

  qscintilla = callPackage ./non-by-name/qscintilla {
    useQt6 = false;
  };

  qt6 = pkgs.qt6.override { python3 = self.python; };

  qtile = callPackage ./non-by-name/qtile { wlroots = pkgs.wlroots_0_20; };

  qutip = callPackage ./non-by-name/qutip { };

  radicale-infcloud = callPackage ./non-by-name/radicale-infcloud {
    radicale = pkgs.radicale.override { python3 = python; };
  };

  rapidgzip = callPackage ./non-by-name/rapidgzip { inherit (pkgs) nasm; };

  rarfile = callPackage ./non-by-name/rarfile { inherit (pkgs) libarchive unrar; };

  rasterio = callPackage ./non-by-name/rasterio {
    gdal-cpp = pkgs.gdal;
  };

  ratarmountcore = callPackage ./non-by-name/ratarmountcore { inherit (pkgs) zstd; };

  raylib = callPackage ./non-by-name/raylib { inherit (pkgs) raylib; };

  rdkit = callPackage ./non-by-name/rdkit {
    boost = pkgs.boost.override {
      enablePython = true;
      inherit python;
    };
  };

  rds2py = callPackage ./non-by-name/rds2py { };

  real-ladybug = callPackage ./non-by-name/real-ladybug { };

  recoll = toPythonModule (pkgs.recoll.override { python3Packages = self; });

  recursive-pth-loader = toPythonModule (callPackage ./non-by-name/recursive-pth-loader { });

  reflex = callPackage ./non-by-name/reflex { };

  inherit (reflex.subPkgs) reflex-hosting-cli;

  remctl = callPackage ./non-by-name/remctl { remctl-c = pkgs.remctl; };

  reqif = callPackage ./non-by-name/reqif { };

  rgpio = toPythonModule (
    pkgs.lgpio.override {
      inherit buildPythonPackage;
      pyProject = "PY_RGPIO";
    }
  );

  rivet = toPythonModule (pkgs.rivet.override { python3 = python; });

  rocksdict = callPackage ./non-by-name/rocksdict { inherit (pkgs) zstd; };

  root = callPackage ./non-by-name/root {
    inherit (pkgs) root;
  };

  rpm = toPythonModule (pkgs.rpm.override { python3 = self.python; });

  rpy2-rinterface = callPackage ./non-by-name/rpy2-rinterface {
    inherit (pkgs) zstd;
  };

  rtree = callPackage ./non-by-name/rtree { inherit (pkgs) libspatialindex; };

  ruff = callPackage ./non-by-name/ruff { inherit (pkgs) ruff; };

  samplerate = callPackage ./non-by-name/samplerate { inherit (pkgs) libsamplerate; };

  samplerate-ledfx = callPackage ./non-by-name/samplerate-ledfx {
    inherit (pkgs) libsamplerate;
  };

  sane = callPackage ./non-by-name/sane { inherit (pkgs) sane-backends; };

  sanic = callPackage ./non-by-name/sanic {
    # Don't pass any `sanic` to avoid dependency loops.  `sanic-testing`
    # has special logic to disable tests when this is the case.
    sanic-testing = self.sanic-testing.override { sanic = null; };
  };

  scanpy = callPackage ./non-by-name/scanpy { };

  scapy = callPackage ./non-by-name/scapy {
    inherit (pkgs) libpcap; # Avoid confusion with python package of the same name
  };

  seccomp = callPackage ./non-by-name/seccomp { };

  secp256k1 = callPackage ./non-by-name/secp256k1 { inherit (pkgs) secp256k1; };

  segyio = callPackage ./non-by-name/segyio { inherit (pkgs) cmake ninja; };

  selenium = callPackage ./non-by-name/selenium { };

  semgrep = callPackage ./non-by-name/semgrep {
    semgrep-core = callPackage ./non-by-name/semgrep/semgrep-core.nix { };
  };

  sentencepiece = callPackage ./non-by-name/sentencepiece {
    inherit (pkgs) sentencepiece;
  };

  sentry-sdk = callPackage ./non-by-name/sentry-sdk/default.nix { };

  sherpa-onnx = callPackage ./non-by-name/sherpa-onnx {
    sherpa-onnx = pkgs.sherpa-onnx.override {
      python3Packages = self;
      pythonSupport = true;
    };
  };

  shiboken2 = toPythonModule (
    callPackage ./non-by-name/shiboken2 { inherit (pkgs) cmake llvmPackages qt5; }
  );

  shiboken6 = toPythonModule (
    callPackage ./non-by-name/shiboken6 { inherit (pkgs) cmake llvmPackages; }
  );

  shiboken6-generator = toPythonModule (
    callPackage ./non-by-name/shiboken6-generator { inherit (pkgs) cmake llvmPackages; }
  );

  simple-dftd3 = callPackage ../../development/libraries/science/chemistry/simple-dftd3/python.nix {
    inherit (pkgs) simple-dftd3;
  };

  simpleitk = callPackage ./non-by-name/simpleitk { inherit (pkgs) itk simpleitk; };

  sip = callPackage ./non-by-name/sip { };

  sip4 = callPackage ./non-by-name/sip/4.x.nix { };

  sirius = toPythonModule (
    pkgs.sirius.override {
      enablePython = true;
      pythonPackages = self;
    }
  );

  skytemple-ssb-emulator = callPackage ./non-by-name/skytemple-ssb-emulator {
    inherit (pkgs) libpcap;
  };

  slepc4py = toPythonModule (
    pkgs.slepc.override {
      pythonSupport = true;
      python3Packages = self;
      petsc = petsc4py;
    }
  );

  sleqp = toPythonModule (
    pkgs.sleqp.override {
      pythonSupport = true;
      python3Packages = self;
    }
  );

  slixmpp = callPackage ./non-by-name/slixmpp { inherit (pkgs) gnupg; };

  snack = toPythonModule (pkgs.newt.override { python3 = self.python; });

  snakemake = toPythonModule (pkgs.snakemake.override { python3Packages = self; });

  soapysdr = toPythonModule (
    pkgs.soapysdr.override {
      inherit (self) python;
      usePython = true;
    }
  );

  soapysdr-with-plugins = toPythonModule (
    pkgs.soapysdr-with-plugins.override {
      inherit (self) python;
      usePython = true;
    }
  );

  solidpython2 = callPackage ./non-by-name/solidpython2 { };

  solyx-energy-api-client = callPackage ./non-by-name/solyx-energy-api-client { };

  sourmash = callPackage ./non-by-name/sourmash { inherit (pkgs) zstd; };

  soxr = callPackage ./non-by-name/soxr { libsoxr = pkgs.soxr; };

  spacy = callPackage ./non-by-name/spacy { };

  spacy-legacy = callPackage ./non-by-name/spacy/legacy.nix { };

  spacy-lookups-data = callPackage ./non-by-name/spacy/lookups-data.nix { };

  spacy-models = callPackage ./non-by-name/spacy/models.nix { inherit (pkgs) jq; };

  sphinx-automodapi = callPackage ./non-by-name/sphinx-automodapi {
    graphviz = pkgs.graphviz;
  };

  sphinxcontrib-mscgen = callPackage ./non-by-name/sphinxcontrib-mscgen {
    inherit (pkgs) mscgen;
  };

  sphinxcontrib-plantuml = callPackage ./non-by-name/sphinxcontrib-plantuml {
    inherit (pkgs) plantuml;
  };

  sqlalchemy = callPackage ./non-by-name/sqlalchemy { };

  sqlalchemy_1_4 = callPackage ./non-by-name/sqlalchemy/1_4.nix { };

  sqlite-vec = callPackage ./non-by-name/sqlite-vec {
    sqlite-vec-c = pkgs.sqlite-vec;
  };

  ssdeep = callPackage ./non-by-name/ssdeep { inherit (pkgs) ssdeep; };

  standard-aifc = if pythonAtLeast "3.13" then callPackage ./non-by-name/standard-aifc { } else null;

  standard-cgi = if pythonAtLeast "3.13" then callPackage ./non-by-name/standard-cgi { } else null;

  standard-chunk =
    if pythonAtLeast "3.13" then callPackage ./non-by-name/standard-chunk { } else null;

  standard-imghdr =
    if pythonAtLeast "3.13" then callPackage ./non-by-name/standard-imghdr { } else null;

  standard-mailcap =
    if pythonOlder "3.13" then null else callPackage ./non-by-name/standard-mailcap { };

  standard-nntplib =
    if pythonOlder "3.13" then null else callPackage ./non-by-name/standard-nntplib { };

  standard-pipes =
    if pythonAtLeast "3.13" then callPackage ./non-by-name/standard-pipes { } else null;

  standard-sndhdr =
    if pythonAtLeast "3.13" then callPackage ./non-by-name/standard-sndhdr { } else null;

  standard-sunau =
    if pythonAtLeast "3.13" then callPackage ./non-by-name/standard-sunau { } else null;

  standard-telnetlib =
    if pythonAtLeast "3.13" then callPackage ./non-by-name/standard-telnetlib { } else null;

  stockfish = callPackage ./non-by-name/stockfish { inherit (pkgs) stockfish; };

  stp = toPythonModule (pkgs.stp.override { python3 = self.python; });

  sudachidict-core = callPackage ./non-by-name/sudachidict { };

  sudachidict-full = callPackage ./non-by-name/sudachidict {
    sudachidict = pkgs.sudachidict.override { dict-type = "full"; };
  };

  sudachidict-small = callPackage ./non-by-name/sudachidict {
    sudachidict = pkgs.sudachidict.override { dict-type = "small"; };
  };

  symbolic = callPackage ./non-by-name/symbolic { inherit (pkgs) zstd; };

  symengine = callPackage ./non-by-name/symengine { inherit (pkgs) symengine; };

  syndication-domination = toPythonModule (
    pkgs.syndication-domination.override {
      enablePython = true;
      python3Packages = self;
    }
  );

  syrupy = callPackage ./non-by-name/syrupy { };

  syrupy_5 = callPackage ./non-by-name/syrupy/5.nix { };

  systemd-python = callPackage ./non-by-name/systemd-python {
    inherit (pkgs) systemd;
  };

  taco = toPythonModule (
    pkgs.taco.override {
      enablePython = true;
    }
  );

  tblite = callPackage ../../by-name/tb/tblite/python.nix {
    inherit (pkgs)
      tblite
      meson
      simple-dftd3
      dftd4
      ;
  };

  telethon = callPackage ./non-by-name/telethon { inherit (pkgs) openssl; };

  temporalio = callPackage ./non-by-name/temporalio { inherit (pkgs) zstd; };

  tensorflow = self.tensorflow-bin;

  tensorflow-bin = callPackage ./non-by-name/tensorflow/bin.nix {
    inherit (pkgs.config) cudaSupport;
  };

  tensorflow-estimator-bin = callPackage ./non-by-name/tensorflow-estimator/bin.nix { };

  tensorflowWithCuda = self.tensorflow.override { cudaSupport = true; };

  tensorflowWithoutCuda = self.tensorflow.override { cudaSupport = false; };

  textnets = callPackage ./non-by-name/textnets {
    en_core_web_sm = spacy-models.en_core_web_sm;
  };

  tiledb = callPackage ./non-by-name/tiledb { inherit (pkgs) tiledb; };

  tiny-cuda-nn = toPythonModule (
    pkgs.tiny-cuda-nn.override {
      cudaPackages = self.torch.cudaPackages;
      python3Packages = self;
      pythonSupport = true;
    }
  );

  tkinter =
    if isPyPy then
      null
    else
      callPackage ./non-by-name/tkinter {
        # Tcl/Tk 9.0 support in Tkinter is not quite ready yet:
        # - https://github.com/python/cpython/issues/124111
        # - https://github.com/python/cpython/issues/104568
        tcl = if pythonAtLeast "3.14" then pkgs.tcl-9_0 else pkgs.tcl-8_6;
        tk = if pythonAtLeast "3.14" then pkgs.tk-9_0 else pkgs.tk-8_6;
      };

  tkinter-gl = callPackage ./non-by-name/tkinter-gl {
    inherit (pkgs) mesa;
    inherit (pkgs.tclPackages.override { inherit (tkinter) tcl tk; }) tkgl;
  };

  tlsh = callPackage ./non-by-name/tlsh { };

  tokenspeed-mla = callPackage ./non-by-name/tokenspeed-mla { };

  tokenspeed-mla-bin = callPackage ./non-by-name/tokenspeed-mla/bin.nix { };

  tokenspeed-triton = callPackage ./non-by-name/tokenspeed-triton { };

  tokenspeed-triton-bin = callPackage ./non-by-name/tokenspeed-triton/bin.nix { };

  torch = callPackage ./non-by-name/torch/source { };

  torch-bin = callPackage ./non-by-name/torch/bin { triton = self.triton-bin; };

  # Required to test triton
  torch-no-triton = self.torch.override { tritonSupport = false; };

  torch-tb-profiler = callPackage ./non-by-name/torch-tb-profiler/default.nix { };

  torch-tensorrt = callPackage ./non-by-name/torch-tensorrt {
    torch-tensorrt = pkgs.torch-tensorrt.override {
      python3Packages = self;
    };
  };

  torchWithCuda = self.torch.override {
    triton = self.triton-cuda;
    cudaSupport = true;
    rocmSupport = false;
  };

  torchWithRocm = self.torch.override {
    triton = self.triton-no-cuda;
    rocmSupport = true;
    cudaSupport = false;
  };

  torchWithVulkan = self.torch.override { vulkanSupport = true; };

  torchWithoutCuda = self.torch.override { cudaSupport = false; };

  torchWithoutRocm = self.torch.override { rocmSupport = false; };

  torchaudio = callPackage ./non-by-name/torchaudio { };

  torchaudio-bin = callPackage ./non-by-name/torchaudio/bin.nix { };

  torchvision = callPackage ./non-by-name/torchvision { };

  torchvision-bin = callPackage ./non-by-name/torchvision/bin.nix { };

  towncrier = callPackage ./non-by-name/towncrier { inherit (pkgs) git; };

  trailbase = callPackage ./non-by-name/trailbase { inherit (pkgs) trailbase; };

  transformer-engine-jax = transformer-engine.override {
    withJax = true;
    withPytorch = false;
  };

  transformer-engine-pytorch = transformer-engine.override {
    withJax = false;
    withPytorch = true;
  };

  transformers = callPackage ./non-by-name/transformers { };

  transformers_4 = callPackage ./non-by-name/transformers/4.nix { };

  tree-sitter-grammars = lib.recurseIntoAttrs (
    lib.mapAttrs
      (name: grammarDrv: callPackage ./non-by-name/tree-sitter-grammars { inherit name grammarDrv; })
      (
        # Filtering grammars not compatible with current py-tree-sitter version
        lib.filterAttrs (
          name: value:
          !(builtins.elem name [
            "tree-sitter-go-template"
            "tree-sitter-php-only"
            "tree-sitter-sql"
            "tree-sitter-sshclientconfig"
            "tree-sitter-templ"
          ])
        ) pkgs.tree-sitter-grammars.derivations
      )
  );

  tree-sitter-language-pack = callPackage ./non-by-name/tree-sitter-language-pack {
    inherit (pkgs) zstd;
  };

  trezor-agent = callPackage ./non-by-name/trezor-agent {
    pinentry = pkgs.pinentry-curses;
  };

  triton = callPackage ./non-by-name/triton { llvm = pkgs.triton-llvm; };

  triton-bin = callPackage ./non-by-name/triton/bin.nix { };

  triton-cuda = self.triton.override { cudaSupport = true; };

  triton-no-cuda = self.triton.override { cudaSupport = false; };

  trlib = toPythonModule (
    pkgs.trlib.override {
      pythonSupport = true;
      python3Packages = self;
    }
  );

  tsid = callPackage ./non-by-name/tsid { inherit (pkgs) tsid; };

  ttnn = callPackage ./non-by-name/ttnn { inherit (pkgs) tt-metal; };

  txtai = callPackage ./non-by-name/txtai { sqlite-vec-c = pkgs.sqlite-vec; };

  ty = callPackage ./non-by-name/ty { inherit (pkgs) ty; };

  typecode = callPackage ./non-by-name/typecode { };

  typecode-libmagic = callPackage ./non-by-name/typecode/libmagic.nix {
    inherit (pkgs) file zlib;
  };

  inherit (callPackage ./non-by-name/types-aiobotocore-packages { })
    types-aiobotocore-accessanalyzer
    types-aiobotocore-account
    types-aiobotocore-acm
    types-aiobotocore-acm-pca
    types-aiobotocore-aiops
    types-aiobotocore-alexaforbusiness
    types-aiobotocore-amp
    types-aiobotocore-amplify
    types-aiobotocore-amplifybackend
    types-aiobotocore-amplifyuibuilder
    types-aiobotocore-apigateway
    types-aiobotocore-apigatewaymanagementapi
    types-aiobotocore-apigatewayv2
    types-aiobotocore-appconfig
    types-aiobotocore-appconfigdata
    types-aiobotocore-appfabric
    types-aiobotocore-appflow
    types-aiobotocore-appintegrations
    types-aiobotocore-application-autoscaling
    types-aiobotocore-application-insights
    types-aiobotocore-applicationcostprofiler
    types-aiobotocore-appmesh
    types-aiobotocore-apprunner
    types-aiobotocore-appstream
    types-aiobotocore-appsync
    types-aiobotocore-arc-zonal-shift
    types-aiobotocore-athena
    types-aiobotocore-auditmanager
    types-aiobotocore-autoscaling
    types-aiobotocore-autoscaling-plans
    types-aiobotocore-backup
    types-aiobotocore-backup-gateway
    types-aiobotocore-backupstorage
    types-aiobotocore-batch
    types-aiobotocore-billingconductor
    types-aiobotocore-braket
    types-aiobotocore-budgets
    types-aiobotocore-ce
    types-aiobotocore-chime
    types-aiobotocore-chime-sdk-identity
    types-aiobotocore-chime-sdk-media-pipelines
    types-aiobotocore-chime-sdk-meetings
    types-aiobotocore-chime-sdk-messaging
    types-aiobotocore-chime-sdk-voice
    types-aiobotocore-cleanrooms
    types-aiobotocore-cloud9
    types-aiobotocore-cloudcontrol
    types-aiobotocore-clouddirectory
    types-aiobotocore-cloudformation
    types-aiobotocore-cloudfront
    types-aiobotocore-cloudhsm
    types-aiobotocore-cloudhsmv2
    types-aiobotocore-cloudsearch
    types-aiobotocore-cloudsearchdomain
    types-aiobotocore-cloudtrail
    types-aiobotocore-cloudtrail-data
    types-aiobotocore-cloudwatch
    types-aiobotocore-codeartifact
    types-aiobotocore-codebuild
    types-aiobotocore-codecatalyst
    types-aiobotocore-codecommit
    types-aiobotocore-codeconnections
    types-aiobotocore-codedeploy
    types-aiobotocore-codeguru-reviewer
    types-aiobotocore-codeguru-security
    types-aiobotocore-codeguruprofiler
    types-aiobotocore-codepipeline
    types-aiobotocore-codestar
    types-aiobotocore-codestar-connections
    types-aiobotocore-codestar-notifications
    types-aiobotocore-cognito-identity
    types-aiobotocore-cognito-idp
    types-aiobotocore-cognito-sync
    types-aiobotocore-comprehend
    types-aiobotocore-comprehendmedical
    types-aiobotocore-compute-optimizer
    types-aiobotocore-config
    types-aiobotocore-connect
    types-aiobotocore-connect-contact-lens
    types-aiobotocore-connectcampaigns
    types-aiobotocore-connectcases
    types-aiobotocore-connectparticipant
    types-aiobotocore-controltower
    types-aiobotocore-cur
    types-aiobotocore-customer-profiles
    types-aiobotocore-databrew
    types-aiobotocore-dataexchange
    types-aiobotocore-datapipeline
    types-aiobotocore-datasync
    types-aiobotocore-dax
    types-aiobotocore-detective
    types-aiobotocore-devicefarm
    types-aiobotocore-devops-guru
    types-aiobotocore-directconnect
    types-aiobotocore-discovery
    types-aiobotocore-dlm
    types-aiobotocore-dms
    types-aiobotocore-docdb
    types-aiobotocore-docdb-elastic
    types-aiobotocore-drs
    types-aiobotocore-ds
    types-aiobotocore-dynamodb
    types-aiobotocore-dynamodbstreams
    types-aiobotocore-ebs
    types-aiobotocore-ec2
    types-aiobotocore-ec2-instance-connect
    types-aiobotocore-ecr
    types-aiobotocore-ecr-public
    types-aiobotocore-ecs
    types-aiobotocore-efs
    types-aiobotocore-eks
    types-aiobotocore-elastic-inference
    types-aiobotocore-elasticache
    types-aiobotocore-elasticbeanstalk
    types-aiobotocore-elastictranscoder
    types-aiobotocore-elb
    types-aiobotocore-elbv2
    types-aiobotocore-emr
    types-aiobotocore-emr-containers
    types-aiobotocore-emr-serverless
    types-aiobotocore-entityresolution
    types-aiobotocore-es
    types-aiobotocore-events
    types-aiobotocore-evidently
    types-aiobotocore-finspace
    types-aiobotocore-finspace-data
    types-aiobotocore-firehose
    types-aiobotocore-fis
    types-aiobotocore-fms
    types-aiobotocore-forecast
    types-aiobotocore-forecastquery
    types-aiobotocore-frauddetector
    types-aiobotocore-freetier
    types-aiobotocore-fsx
    types-aiobotocore-gamelift
    types-aiobotocore-gamesparks
    types-aiobotocore-glacier
    types-aiobotocore-globalaccelerator
    types-aiobotocore-glue
    types-aiobotocore-grafana
    types-aiobotocore-greengrass
    types-aiobotocore-greengrassv2
    types-aiobotocore-groundstation
    types-aiobotocore-guardduty
    types-aiobotocore-health
    types-aiobotocore-healthlake
    types-aiobotocore-honeycode
    types-aiobotocore-iam
    types-aiobotocore-identitystore
    types-aiobotocore-imagebuilder
    types-aiobotocore-importexport
    types-aiobotocore-inspector
    types-aiobotocore-inspector2
    types-aiobotocore-internetmonitor
    types-aiobotocore-iot
    types-aiobotocore-iot-data
    types-aiobotocore-iot-jobs-data
    types-aiobotocore-iot-roborunner
    types-aiobotocore-iot1click-devices
    types-aiobotocore-iot1click-projects
    types-aiobotocore-iotanalytics
    types-aiobotocore-iotdeviceadvisor
    types-aiobotocore-iotevents
    types-aiobotocore-iotevents-data
    types-aiobotocore-iotfleethub
    types-aiobotocore-iotfleetwise
    types-aiobotocore-iotsecuretunneling
    types-aiobotocore-iotsitewise
    types-aiobotocore-iotthingsgraph
    types-aiobotocore-iottwinmaker
    types-aiobotocore-iotwireless
    types-aiobotocore-ivs
    types-aiobotocore-ivs-realtime
    types-aiobotocore-ivschat
    types-aiobotocore-kafka
    types-aiobotocore-kafkaconnect
    types-aiobotocore-kendra
    types-aiobotocore-kendra-ranking
    types-aiobotocore-keyspaces
    types-aiobotocore-kinesis
    types-aiobotocore-kinesis-video-archived-media
    types-aiobotocore-kinesis-video-media
    types-aiobotocore-kinesis-video-signaling
    types-aiobotocore-kinesis-video-webrtc-storage
    types-aiobotocore-kinesisanalytics
    types-aiobotocore-kinesisanalyticsv2
    types-aiobotocore-kinesisvideo
    types-aiobotocore-kms
    types-aiobotocore-lakeformation
    types-aiobotocore-lambda
    types-aiobotocore-lex-models
    types-aiobotocore-lex-runtime
    types-aiobotocore-lexv2-models
    types-aiobotocore-lexv2-runtime
    types-aiobotocore-license-manager
    types-aiobotocore-license-manager-linux-subscriptions
    types-aiobotocore-license-manager-user-subscriptions
    types-aiobotocore-lightsail
    types-aiobotocore-location
    types-aiobotocore-logs
    types-aiobotocore-lookoutequipment
    types-aiobotocore-lookoutmetrics
    types-aiobotocore-lookoutvision
    types-aiobotocore-m2
    types-aiobotocore-machinelearning
    types-aiobotocore-macie
    types-aiobotocore-macie2
    types-aiobotocore-managedblockchain
    types-aiobotocore-managedblockchain-query
    types-aiobotocore-marketplace-catalog
    types-aiobotocore-marketplace-entitlement
    types-aiobotocore-marketplacecommerceanalytics
    types-aiobotocore-mediaconnect
    types-aiobotocore-mediaconvert
    types-aiobotocore-medialive
    types-aiobotocore-mediapackage
    types-aiobotocore-mediapackage-vod
    types-aiobotocore-mediapackagev2
    types-aiobotocore-mediastore
    types-aiobotocore-mediastore-data
    types-aiobotocore-mediatailor
    types-aiobotocore-medical-imaging
    types-aiobotocore-memorydb
    types-aiobotocore-meteringmarketplace
    types-aiobotocore-mgh
    types-aiobotocore-mgn
    types-aiobotocore-migration-hub-refactor-spaces
    types-aiobotocore-migrationhub-config
    types-aiobotocore-migrationhuborchestrator
    types-aiobotocore-migrationhubstrategy
    types-aiobotocore-mobile
    types-aiobotocore-mq
    types-aiobotocore-mturk
    types-aiobotocore-mwaa
    types-aiobotocore-neptune
    types-aiobotocore-network-firewall
    types-aiobotocore-networkmanager
    types-aiobotocore-networkmonitor
    types-aiobotocore-nimble
    types-aiobotocore-oam
    types-aiobotocore-omics
    types-aiobotocore-opensearch
    types-aiobotocore-opensearchserverless
    types-aiobotocore-opsworks
    types-aiobotocore-opsworkscm
    types-aiobotocore-organizations
    types-aiobotocore-osis
    types-aiobotocore-outposts
    types-aiobotocore-panorama
    types-aiobotocore-payment-cryptography
    types-aiobotocore-payment-cryptography-data
    types-aiobotocore-personalize
    types-aiobotocore-personalize-events
    types-aiobotocore-personalize-runtime
    types-aiobotocore-pi
    types-aiobotocore-pinpoint
    types-aiobotocore-pinpoint-email
    types-aiobotocore-pinpoint-sms-voice
    types-aiobotocore-pinpoint-sms-voice-v2
    types-aiobotocore-pipes
    types-aiobotocore-polly
    types-aiobotocore-pricing
    types-aiobotocore-privatenetworks
    types-aiobotocore-proton
    types-aiobotocore-qapps
    types-aiobotocore-qbusiness
    types-aiobotocore-qconnect
    types-aiobotocore-qldb
    types-aiobotocore-qldb-session
    types-aiobotocore-quicksight
    types-aiobotocore-ram
    types-aiobotocore-rbin
    types-aiobotocore-rds
    types-aiobotocore-rds-data
    types-aiobotocore-redshift
    types-aiobotocore-redshift-data
    types-aiobotocore-redshift-serverless
    types-aiobotocore-rekognition
    types-aiobotocore-resiliencehub
    types-aiobotocore-resource-explorer-2
    types-aiobotocore-resource-groups
    types-aiobotocore-resourcegroupstaggingapi
    types-aiobotocore-robomaker
    types-aiobotocore-rolesanywhere
    types-aiobotocore-route53
    types-aiobotocore-route53-recovery-cluster
    types-aiobotocore-route53-recovery-control-config
    types-aiobotocore-route53-recovery-readiness
    types-aiobotocore-route53domains
    types-aiobotocore-route53resolver
    types-aiobotocore-rum
    types-aiobotocore-s3
    types-aiobotocore-s3control
    types-aiobotocore-s3outposts
    types-aiobotocore-sagemaker
    types-aiobotocore-sagemaker-a2i-runtime
    types-aiobotocore-sagemaker-edge
    types-aiobotocore-sagemaker-featurestore-runtime
    types-aiobotocore-sagemaker-geospatial
    types-aiobotocore-sagemaker-metrics
    types-aiobotocore-sagemaker-runtime
    types-aiobotocore-savingsplans
    types-aiobotocore-scheduler
    types-aiobotocore-schemas
    types-aiobotocore-sdb
    types-aiobotocore-secretsmanager
    types-aiobotocore-securityhub
    types-aiobotocore-securitylake
    types-aiobotocore-serverlessrepo
    types-aiobotocore-service-quotas
    types-aiobotocore-servicecatalog
    types-aiobotocore-servicecatalog-appregistry
    types-aiobotocore-servicediscovery
    types-aiobotocore-ses
    types-aiobotocore-sesv2
    types-aiobotocore-shield
    types-aiobotocore-signer
    types-aiobotocore-simspaceweaver
    types-aiobotocore-sms
    types-aiobotocore-sms-voice
    types-aiobotocore-snow-device-management
    types-aiobotocore-snowball
    types-aiobotocore-sns
    types-aiobotocore-sqs
    types-aiobotocore-ssm
    types-aiobotocore-ssm-contacts
    types-aiobotocore-ssm-incidents
    types-aiobotocore-ssm-sap
    types-aiobotocore-sso
    types-aiobotocore-sso-admin
    types-aiobotocore-sso-oidc
    types-aiobotocore-stepfunctions
    types-aiobotocore-storagegateway
    types-aiobotocore-sts
    types-aiobotocore-support
    types-aiobotocore-support-app
    types-aiobotocore-swf
    types-aiobotocore-synthetics
    types-aiobotocore-textract
    types-aiobotocore-timestream-query
    types-aiobotocore-timestream-write
    types-aiobotocore-tnb
    types-aiobotocore-transcribe
    types-aiobotocore-transfer
    types-aiobotocore-translate
    types-aiobotocore-verifiedpermissions
    types-aiobotocore-voice-id
    types-aiobotocore-vpc-lattice
    types-aiobotocore-waf
    types-aiobotocore-waf-regional
    types-aiobotocore-wafv2
    types-aiobotocore-wellarchitected
    types-aiobotocore-wisdom
    types-aiobotocore-workdocs
    types-aiobotocore-worklink
    types-aiobotocore-workmail
    types-aiobotocore-workmailmessageflow
    types-aiobotocore-workspaces
    types-aiobotocore-workspaces-web
    types-aiobotocore-xray
    ;

  typesense = callPackage ./non-by-name/typesense {
    inherit (pkgs) typesense curl;
  };

  typing = null;

  ueberzug = callPackage ./non-by-name/ueberzug {
    inherit (pkgs) libx11 libxext;
  };

  unicorn = callPackage ./non-by-name/unicorn { inherit (pkgs) unicorn; };

  units-llnl = callPackage ./non-by-name/units-llnl {
    inherit (pkgs) units-llnl;
  };

  unrar = callPackage ./non-by-name/unrar { inherit (pkgs) unrar; };

  unrardll = callPackage ./non-by-name/unrardll { inherit (pkgs) unrar; };

  usbrelay-py = callPackage ../../os-specific/linux/usbrelay/python.nix { };

  ustreamer = toPythonModule (
    pkgs.ustreamer.override {
      python3Packages = self;
      withPython = true;
    }
  );

  uv = callPackage ./non-by-name/uv { inherit (pkgs) uv; };

  vapoursynth = callPackage ./non-by-name/vapoursynth { inherit (pkgs) vapoursynth; };

  viennarna = toPythonModule (pkgs.viennarna.override { python3 = self.python; });

  vina = callPackage ../../by-name/au/autodock-vina/python-bindings.nix { };

  virtualenv-clone = callPackage ./non-by-name/virtualenv-clone { };

  vivisect = callPackage ./non-by-name/vivisect {
    inherit (pkgs.libsForQt5) wrapQtAppsHook;
  };

  vl-convert-python = callPackage ./non-by-name/vl-convert-python {
    inherit (pkgs) protobuf;
  };

  vllm = callPackage ./non-by-name/vllm { inherit (pkgs) zstd; };

  vtk = toPythonModule (
    pkgs.vtk.override {
      pythonSupport = true;
      python3Packages = self;
    }
  );

  vyper = callPackage ../../development/compilers/vyper { };

  warp-lang = callPackage ./non-by-name/warp-lang {
    # warp targets LLVM 22 in its build-from-source path (build_llvm.py clones llvmorg-22.x)
    stdenv = if stdenv.hostPlatform.isDarwin then pkgs.llvmPackages_22.stdenv else pkgs.stdenv;
    llvmPackages = pkgs.llvmPackages_22;
  };

  wasm-tools = callPackage ./non-by-name/wasm-tools { inherit (pkgs) jq; };

  inherit (self.wasmerPackages)
    wasmer
    wasmer-compiler-cranelift
    wasmer-compiler-llvm
    wasmer-compiler-singlepass
    ;

  wasmerPackages = lib.recurseIntoAttrs (callPackage ./non-by-name/wasmer { });

  wasmtime = callPackage ../../by-name/wa/wasmtime/python.nix { };

  webrtc-noise-gain = callPackage ./non-by-name/webrtc-noise-gain { };

  wfuzz = callPackage ./non-by-name/wfuzz { };

  whisperx = callPackage ./non-by-name/whisperx {
    ffmpeg = pkgs.ffmpeg-headless;
    ctranslate2-cpp = pkgs.ctranslate2;
  };

  wtforms = callPackage ./non-by-name/wtforms { };

  wtforms_3_3 = callPackage ./non-by-name/wtforms/3_3.nix { };

  wxpython = callPackage ./non-by-name/wxpython/4.2.nix {
    wxGTK = pkgs.wxwidgets_3_2.override { withWebKit = true; };
  };

  wxpython_4_3 = callPackage ./non-by-name/wxpython/4.3.nix { };

  xapian = callPackage ./non-by-name/xapian { inherit (pkgs) xapian; };

  xdot = callPackage ./non-by-name/xdot { inherit (pkgs) graphviz; };

  xeddsa = toPythonModule (callPackage ./non-by-name/xeddsa { });

  xen = toPythonModule (pkgs.xen.override { python3Packages = self; });

  xgboost = callPackage ./non-by-name/xgboost { inherit (pkgs) xgboost; };

  xmlsec = callPackage ./non-by-name/xmlsec {
    inherit (pkgs)
      libxslt
      libxml2
      libtool
      pkg-config
      xmlsec
      ;
  };

  xonsh = callPackage ../../by-name/xo/xonsh/unwrapped.nix { };

  xrootd = callPackage ./non-by-name/xrootd { inherit (pkgs) xrootd; };

  yoda = toPythonModule (pkgs.yoda.override { python3 = python; });

  yosys = toPythonModule (pkgs.yosys.override { python3 = python; });

  yq = callPackage ./non-by-name/yq { inherit (pkgs) jq; };

  yt-dlp = toPythonModule (pkgs.yt-dlp.override { python3Packages = self; });

  yt-dlp-light = toPythonModule (pkgs.yt-dlp-light.override { python3Packages = self; });

  z3-solver = (toPythonModule (pkgs.z3.override { python3Packages = self; })).python;

  zeek = (toPythonModule (pkgs.zeek.broker.override { python3 = python; })).py;

  zeitgeist = (toPythonModule (pkgs.zeitgeist.override { python3 = python; })).py;

  zlib-ng = callPackage ./non-by-name/zlib-ng { inherit (pkgs) zlib-ng; };

  zopfli = callPackage ./non-by-name/zopfli { inherit (pkgs) zopfli; };

  zstd = callPackage ./non-by-name/zstd { inherit (pkgs) zstd; };

  zxing-cpp = callPackage ./non-by-name/zxing-cpp { libzxing-cpp = pkgs.zxing-cpp; };

  # keep-sorted end
}
