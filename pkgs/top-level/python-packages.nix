# This file contains the Python packages set.
# Each attribute is a Python library or a helper function.
# Expressions for Python libraries are supposed to be in `pkgs/development/python-modules/<name>/default.nix`.
# Python packages that do not need to be available for each interpreter version do not belong in this packages set.
# Examples are Python-based cli tools.
#
# For more details, please see the Python section in the Nixpkgs manual.

self: super:
with self;

# Import packages from by-name structure
(import ./by-name-overlay.nix ../development/python-modules/by-name self super)

// {

  bootstrap = lib.recurseIntoAttrs {
    flit-core = toPythonModule (callPackage ../development/python-modules/bootstrap/flit-core { });
    installer = toPythonModule (
      callPackage ../development/python-modules/bootstrap/installer { inherit (bootstrap) flit-core; }
    );
    build = toPythonModule (
      callPackage ../development/python-modules/bootstrap/build {
        inherit (bootstrap) flit-core installer;
      }
    );
    packaging = toPythonModule (
      callPackage ../development/python-modules/bootstrap/packaging {
        inherit (bootstrap) flit-core installer;
      }
    );
  };

  setuptools = callPackage ../development/python-modules/setuptools { };

  # by_regex ensures inherit statements are sorted after the (first) attribute name that is inherited.
  # keep-sorted start block=yes newline_separated=yes by_regex=["(?:inherit\\s+\\([^)]+\\)\\n?\\s*)?(.+)"]
  adios2 = toPythonModule (
    pkgs.adios2.override {
      python3Packages = self;
      pythonSupport = true;
    }
  );

  agentic-threat-hunting-framework =
    callPackage ../development/python-modules/agentic-threat-hunting-framework
      { };

  aio-geojson-generic-client =
    callPackage ../development/python-modules/aio-geojson-generic-client
      { };

  aio-geojson-geonetnz-quakes =
    callPackage ../development/python-modules/aio-geojson-geonetnz-quakes
      { };

  aio-geojson-geonetnz-volcano =
    callPackage ../development/python-modules/aio-geojson-geonetnz-volcano
      { };

  aio-geojson-nsw-rfs-incidents =
    callPackage ../development/python-modules/aio-geojson-nsw-rfs-incidents
      { };

  aio-geojson-usgs-earthquakes =
    callPackage ../development/python-modules/aio-geojson-usgs-earthquakes
      { };

  aiomisc-pytest = callPackage ../development/python-modules/aiomisc-pytest { };

  alibabacloud-credentials-api =
    callPackage ../development/python-modules/alibabacloud-credentials-api
      { };

  alibabacloud-endpoint-util =
    callPackage ../development/python-modules/alibabacloud-endpoint-util
      { };

  aligator = callPackage ../development/python-modules/aligator { inherit (pkgs) aligator; };

  allure-pytest = callPackage ../development/python-modules/allure-pytest { };

  allure-python-commons-test =
    callPackage ../development/python-modules/allure-python-commons-test
      { };

  amazon-ion = callPackage ../development/python-modules/amazon-ion { inherit (pkgs) cmake; };

  anel-pwrctrl-homeassistant =
    callPackage ../development/python-modules/anel-pwrctrl-homeassistant
      { };

  angrcli = callPackage ../development/python-modules/angrcli { inherit (pkgs) coreutils; };

  ansible = callPackage ../development/python-modules/ansible { };

  ansible-builder = callPackage ../development/python-modules/ansible-builder {
    inherit (pkgs) podman;
  };

  ansible-compat = callPackage ../development/python-modules/ansible-compat { };

  ansible-core = callPackage ../development/python-modules/ansible/core.nix { };

  ansible-kernel = callPackage ../development/python-modules/ansible-kernel { };

  ansible-pylibssh = callPackage ../development/python-modules/ansible-pylibssh { };

  ansible-runner = callPackage ../development/python-modules/ansible-runner { };

  ansible-vault-rw = callPackage ../development/python-modules/ansible-vault-rw { };

  antlr4-python3-runtime = callPackage ../development/python-modules/antlr4-python3-runtime {
    inherit (pkgs) antlr4;
  };

  anytree = callPackage ../development/python-modules/anytree { inherit (pkgs) graphviz; };

  appthreat-vulnerability-db =
    callPackage ../development/python-modules/appthreat-vulnerability-db
      { };

  arelle = callPackage ../development/python-modules/arelle { gui = true; };

  arelle-headless = callPackage ../development/python-modules/arelle { gui = false; };

  argostranslate = callPackage ../development/python-modules/argostranslate {
    ctranslate2-cpp = pkgs.ctranslate2;
  };

  arro3-compute = (callPackage ../development/python-modules/arro3 { }).arro3-compute;

  arro3-core = (callPackage ../development/python-modules/arro3 { }).arro3-core;

  arro3-io = (callPackage ../development/python-modules/arro3 { }).arro3-io;

  atomicwrites-homeassistant =
    callPackage ../development/python-modules/atomicwrites-homeassistant
      { };

  audioop-lts =
    if pythonAtLeast "3.13" then callPackage ../development/python-modules/audioop-lts { } else null;

  audit = toPythonModule (
    pkgs.audit.override {
      python3Packages = self;
    }
  );

  auditwheel = callPackage ../development/python-modules/auditwheel {
    inherit (pkgs)
      bzip2
      gnutar
      patchelf
      unzip
      ;
  };

  augeas = callPackage ../development/python-modules/augeas { inherit (pkgs) augeas; };

  avahi = toPythonModule (
    pkgs.avahi.override {
      inherit python;
      withPython = true;
    }
  );

  awkward-cpp = callPackage ../development/python-modules/awkward-cpp { inherit (pkgs) cmake ninja; };

  aws-secretsmanager-caching =
    callPackage ../development/python-modules/aws-secretsmanager-caching
      { };

  awsipranges = callPackage ../development/python-modules/awsipranges { };

  azure-ai-documentintelligence =
    callPackage ../development/python-modules/azure-ai-documentintelligence
      { };

  azure-ai-vision-imageanalysis =
    callPackage ../development/python-modules/azure-ai-vision-imageanalysis
      { };

  azure-keyvault-administration =
    callPackage ../development/python-modules/azure-keyvault-administration
      { };

  azure-keyvault-certificates =
    callPackage ../development/python-modules/azure-keyvault-certificates
      { };

  azure-keyvault-securitydomain =
    callPackage ../development/python-modules/azure-keyvault-securitydomain
      { };

  azure-mgmt-appconfiguration =
    callPackage ../development/python-modules/azure-mgmt-appconfiguration
      { };

  azure-mgmt-applicationinsights =
    callPackage ../development/python-modules/azure-mgmt-applicationinsights
      { };

  azure-mgmt-cognitiveservices =
    callPackage ../development/python-modules/azure-mgmt-cognitiveservices
      { };

  azure-mgmt-containerinstance =
    callPackage ../development/python-modules/azure-mgmt-containerinstance
      { };

  azure-mgmt-containerregistry =
    callPackage ../development/python-modules/azure-mgmt-containerregistry
      { };

  azure-mgmt-containerservice =
    callPackage ../development/python-modules/azure-mgmt-containerservice
      { };

  azure-mgmt-datalake-analytics =
    callPackage ../development/python-modules/azure-mgmt-datalake-analytics
      { };

  azure-mgmt-deploymentmanager =
    callPackage ../development/python-modules/azure-mgmt-deploymentmanager
      { };

  azure-mgmt-extendedlocation =
    callPackage ../development/python-modules/azure-mgmt-extendedlocation
      { };

  azure-mgmt-iothubprovisioningservices =
    callPackage ../development/python-modules/azure-mgmt-iothubprovisioningservices
      { };

  azure-mgmt-machinelearningcompute =
    callPackage ../development/python-modules/azure-mgmt-machinelearningcompute
      { };

  azure-mgmt-managedservices =
    callPackage ../development/python-modules/azure-mgmt-managedservices
      { };

  azure-mgmt-managementgroups =
    callPackage ../development/python-modules/azure-mgmt-managementgroups
      { };

  azure-mgmt-managementpartner =
    callPackage ../development/python-modules/azure-mgmt-managementpartner
      { };

  azure-mgmt-marketplaceordering =
    callPackage ../development/python-modules/azure-mgmt-marketplaceordering
      { };

  azure-mgmt-mysqlflexibleservers =
    callPackage ../development/python-modules/azure-mgmt-mysqlflexibleservers
      { };

  azure-mgmt-notificationhubs =
    callPackage ../development/python-modules/azure-mgmt-notificationhubs
      { };

  azure-mgmt-postgresqlflexibleservers =
    callPackage ../development/python-modules/azure-mgmt-postgresqlflexibleservers
      { };

  azure-mgmt-powerbiembedded =
    callPackage ../development/python-modules/azure-mgmt-powerbiembedded
      { };

  azure-mgmt-recoveryservices =
    callPackage ../development/python-modules/azure-mgmt-recoveryservices
      { };

  azure-mgmt-recoveryservicesbackup =
    callPackage ../development/python-modules/azure-mgmt-recoveryservicesbackup
      { };

  azure-mgmt-redhatopenshift =
    callPackage ../development/python-modules/azure-mgmt-redhatopenshift
      { };

  azure-mgmt-resource-deployments =
    callPackage ../development/python-modules/azure-mgmt-resource-deployments
      { };

  azure-mgmt-resource-deploymentscripts =
    callPackage ../development/python-modules/azure-mgmt-resource-deploymentscripts
      { };

  azure-mgmt-resource-deploymentstacks =
    callPackage ../development/python-modules/azure-mgmt-resource-deploymentstacks
      { };

  azure-mgmt-resource-templatespecs =
    callPackage ../development/python-modules/azure-mgmt-resource-templatespecs
      { };

  azure-mgmt-servicefabricmanagedclusters =
    callPackage ../development/python-modules/azure-mgmt-servicefabricmanagedclusters
      { };

  azure-mgmt-sqlvirtualmachine =
    callPackage ../development/python-modules/azure-mgmt-sqlvirtualmachine
      { };

  azure-servicemanagement-legacy =
    callPackage ../development/python-modules/azure-servicemanagement-legacy
      { };

  azure-storage-file-datalake =
    callPackage ../development/python-modules/azure-storage-file-datalake
      { };

  azure-synapse-accesscontrol =
    callPackage ../development/python-modules/azure-synapse-accesscontrol
      { };

  azure-synapse-managedprivateendpoints =
    callPackage ../development/python-modules/azure-synapse-managedprivateendpoints
      { };

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
    if pythonAtLeast "3.12" then
      null
    else
      callPackage ../development/python-modules/backports-asyncio-runner { };

  backports-datetime-fromisoformat =
    callPackage ../development/python-modules/backports-datetime-fromisoformat
      { };

  backports-entry-points-selectable =
    callPackage ../development/python-modules/backports-entry-points-selectable
      { };

  backports-strenum =
    if pythonAtLeast "3.11" then
      null
    else
      callPackage ../development/python-modules/backports-strenum { };

  backports-zstd =
    if pythonAtLeast "3.14" then
      null
    else
      callPackage ../development/python-modules/backports-zstd {
        inherit (pkgs) zstd;
      };

  bap = callPackage ../development/python-modules/bap {
    inherit (pkgs.ocaml-ng.ocamlPackages_4_14) bap;
  };

  basedmypy = callPackage ../development/python-modules/basedmypy { };

  bcc = toPythonModule (pkgs.bcc.override { python3Packages = self; });

  bcrypt =
    if stdenv.hostPlatform.system == "i686-linux" then
      callPackage ../development/python-modules/bcrypt/3.nix { }
    else
      callPackage ../development/python-modules/bcrypt { };

  beancount = callPackage ../development/python-modules/beancount { };

  beancount-black = callPackage ../development/python-modules/beancount-black { };

  beancount-docverif = callPackage ../development/python-modules/beancount-docverif { };

  beancount-parser = callPackage ../development/python-modules/beancount-parser { };

  beancount-periodic = callPackage ../development/python-modules/beancount-periodic { };

  beancount-plugin-utils = callPackage ../development/python-modules/beancount-plugin-utils { };

  beancount_2 = callPackage ../development/python-modules/beancount/2.nix { };

  beets = callPackage ../development/python-modules/beets {
    inherit (pkgs) chromaprint;
  };

  beets-minimal = beets.override {
    disableAllPlugins = true;
  };

  bencodetools = callPackage ../development/python-modules/bencodetools {
    bencodetools = pkgs.bencodetools;
  };

  bibtexparser = callPackage ../development/python-modules/bibtexparser { };

  bibtexparser_2 = callPackage ../development/python-modules/bibtexparser/2.nix { };

  bitcoin-utils-fork-minimal =
    callPackage ../development/python-modules/bitcoin-utils-fork-minimal
      { };

  bluetooth-sensor-state-data =
    callPackage ../development/python-modules/bluetooth-sensor-state-data
      { };

  # Build boost for this specific Python version
  # TODO: use separate output for libboost_python.so
  boost = toPythonModule (
    pkgs.boost.override {
      inherit (self) python numpy;
      enablePython = true;
    }
  );

  boost-histogram = callPackage ../development/python-modules/boost-histogram {
    inherit (pkgs) boost;
  };

  botan3 = callPackage ../development/python-modules/botan3 { inherit (pkgs) botan3; };

  brainflow = callPackage ../development/python-modules/brainflow { inherit (pkgs) brainflow; };

  brotli = callPackage ../development/python-modules/brotli {
    inherit (pkgs) brotli;
  };

  brotlicffi = callPackage ../development/python-modules/brotlicffi { inherit (pkgs) brotli; };

  bytesize = toPythonModule (pkgs.libbytesize.override { python3Packages = self; });

  caffe = toPythonModule (
    pkgs.caffe.override {
      pythonSupport = true;
      inherit (self) python numpy boost;
    }
  );

  canonical-sphinx-extensions =
    callPackage ../development/python-modules/canonical-sphinx-extensions
      { };

  capstone = callPackage ../development/python-modules/capstone { inherit (pkgs) capstone; };

  capstone_4 = callPackage ../development/python-modules/capstone/4.nix {
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

  catboost = callPackage ../development/python-modules/catboost {
    catboost = pkgs.catboost.override {
      pythonSupport = true;
      python3Packages = self;
    };
  };

  cbor = callPackage ../development/python-modules/cbor { };

  cbor2 = callPackage ../development/python-modules/cbor2 { };

  cbor2WithoutCExtensions = callPackage ../development/python-modules/cbor2 {
    withCExtensions = false;
  };

  cccolutils = callPackage ../development/python-modules/cccolutils { krb5-c = pkgs.krb5; };

  cffi = if isPyPy then null else callPackage ../development/python-modules/cffi { };

  cgal = callPackage ../development/python-modules/cgal { inherit (pkgs) cgal; };

  chacha20poly1305-reuseable =
    callPackage ../development/python-modules/chacha20poly1305-reuseable
      { };

  chromadb = callPackage ../development/python-modules/chromadb { zstd-c = pkgs.zstd; };

  clarifai = callPackage ../development/python-modules/clarifai { };

  clarifai-protocol = callPackage ../development/python-modules/clarifai-protocol { };

  clingo = toPythonModule (
    pkgs.clingo.override {
      inherit python;
      withPython = true;
    }
  );

  cmake = callPackage ../development/python-modules/cmake { inherit (pkgs) cmake; };

  cmigemo = callPackage ../development/python-modules/cmigemo { inherit (pkgs) cmigemo; };

  coal = callPackage ../development/python-modules/coal { inherit (pkgs) coal; };

  coincurve = callPackage ../development/python-modules/coincurve { inherit (pkgs) secp256k1; };

  colcon-installed-package-information =
    callPackage ../development/python-modules/colcon-installed-package-information
      { };

  colcon-package-information =
    callPackage ../development/python-modules/colcon-package-information
      { };

  colcon-ros-domain-id-coordinator =
    callPackage ../development/python-modules/colcon-ros-domain-id-coordinator
      { };

  conduit = callPackage ../development/python-modules/conduit { };

  conduit-mpi = callPackage ../development/python-modules/conduit { mpiSupport = true; };

  cot = callPackage ../development/python-modules/cot { inherit (pkgs) qemu; };

  cppe = callPackage ../development/python-modules/cppe { inherit (pkgs) cppe; };

  crocoddyl = callPackage ../development/python-modules/crocoddyl { inherit (pkgs) crocoddyl; };

  ctranslate2 = callPackage ../development/python-modules/ctranslate2 {
    ctranslate2-cpp = pkgs.ctranslate2;
  };

  cupy = callPackage ../development/python-modules/cupy {
    cudaPackages =
      # CuDNN 9 is not supported:
      # https://github.com/cupy/cupy/issues/8215
      # NOTE: cupy 14 will drop support for cuDNN entirely.
      # https://github.com/cupy/cupy/pull/9326
      let
        version = if pkgs.cudaPackages.backendStdenv.hasJetsonCudaCapability then "8.9.5" else "8.9.7";
      in
      pkgs.cudaPackages.override (prevArgs: {
        manifests = prevArgs.manifests // {
          cudnn = pkgs._cuda.manifests.cudnn.${version};
        };
      });
  };

  cypari = callPackage ../development/python-modules/cypari {

    inherit (pkgs.pkgsStatic) gmp;

    pari = pkgs.pari.overrideAttrs rec {
      version = "2.15.4";
      src = pkgs.fetchurl {
        url = "https://pari.math.u-bordeaux.fr/pub/pari/OLD/${lib.versions.majorMinor version}/pari-${version}.tar.gz";
        hash = "sha256-w1Rb/uDG37QLd/tLurr5mdguYAabn20ovLbPAEyMXA8=";
      };
      installTargets = [
        "install"
        "install-lib-sta"
      ];
    };

  };

  cython = callPackage ../development/python-modules/cython { };

  cython-test-exception-raiser =
    callPackage ../development/python-modules/cython-test-exception-raiser
      { };

  cython_0 = callPackage ../development/python-modules/cython/0.nix { };

  dartsim = toPythonModule (
    pkgs.dartsim.override {
      pythonSupport = true;
      python3Packages = self;
    }
  );

  datafusion = callPackage ../development/python-modules/datafusion {
    protoc = pkgs.protobuf;
  };

  dbus-python = callPackage ../development/python-modules/dbus-python { inherit (pkgs) dbus; };

  deepsearch-glm = callPackage ../development/python-modules/deepsearch-glm {
    inherit (pkgs) loguru sentencepiece fasttext;
  };

  dftd4 = callPackage ../by-name/df/dftd4/python.nix {
    inherit (pkgs) dftd4;
  };

  distutils =
    if pythonOlder "3.12" then null else callPackage ../development/python-modules/distutils { };

  # LTS with mainsteam support
  django = self.django_5;

  django-auth-ldap = callPackage ../development/python-modules/django-auth-ldap {
    inherit (pkgs) openldap;
  };

  django-compression-middleware =
    callPackage ../development/python-modules/django-compression-middleware
      { };

  django-dynamic-preferences =
    callPackage ../development/python-modules/django-dynamic-preferences
      { };

  django-encrypted-model-fields =
    callPackage ../development/python-modules/django-encrypted-model-fields
      { };

  django-formset-js-improved =
    callPackage ../development/python-modules/django-formset-js-improved
      { };

  django-google-analytics-app =
    callPackage ../development/python-modules/django-google-analytics-app
      { };

  django-graphiql-debug-toolbar =
    callPackage ../development/python-modules/django-graphiql-debug-toolbar
      { };

  django-login-required-middleware =
    callPackage ../development/python-modules/django-login-required-middleware
      { };

  django-ninja-cursor-pagination =
    callPackage ../development/python-modules/django-ninja-cursor-pagination
      { };

  django-postgresql-netfields =
    callPackage ../development/python-modules/django-postgresql-netfields
      { };

  django-pydantic-field = callPackage ../development/python-modules/django-pydantic-field { };

  django-versatileimagefield =
    callPackage ../development/python-modules/django-versatileimagefield
      { };

  # LTS in extended support phase
  django_4 = callPackage ../development/python-modules/django/4.nix { };

  django_5 = callPackage ../development/python-modules/django/5.nix { };

  djangorestframework-camel-case =
    callPackage ../development/python-modules/djangorestframework-camel-case
      { };

  djangorestframework-dataclasses =
    callPackage ../development/python-modules/djangorestframework-dataclasses
      { };

  djangorestframework-guardian =
    callPackage ../development/python-modules/djangorestframework-guardian
      { };

  djangorestframework-recursive =
    callPackage ../development/python-modules/djangorestframework-recursive
      { };

  djangorestframework-simplejwt =
    callPackage ../development/python-modules/djangorestframework-simplejwt
      { };

  dlib = callPackage ../development/python-modules/dlib { inherit (pkgs) dlib; };

  dm-tree = callPackage ../development/python-modules/dm-tree {
    inherit (pkgs) abseil-cpp;
  };

  dnf4 = callPackage ../development/python-modules/dnf4 { };

  docling-parse = callPackage ../development/python-modules/docling-parse {
    loguru-cpp = pkgs.loguru;
  };

  dot2tex = callPackage ../development/python-modules/dot2tex { inherit (pkgs) graphviz; };

  doxmlparser = callPackage ../development/tools/documentation/doxygen/doxmlparser.nix { };

  drf-pydantic = callPackage ../development/python-modules/drf-pydantic { };

  duckdb = callPackage ../development/python-modules/duckdb { inherit (pkgs) duckdb; };

  dulwich = callPackage ../development/python-modules/dulwich { inherit (pkgs) gnupg; };

  dynd = callPackage ../development/python-modules/dynd { };

  ec2instanceconnectcli = callPackage ../tools/virtualization/ec2instanceconnectcli { };

  eccodes = toPythonModule (
    pkgs.eccodes.override {
      enablePython = true;
      python3Packages = self;
    }
  );

  echo = callPackage ../development/python-modules/echo {
    inherit (pkgs) mesa;
  };

  edlib = callPackage ../development/python-modules/edlib { inherit (pkgs) edlib; };

  eigenpy = callPackage ../development/python-modules/eigenpy {
    inherit (pkgs) graphviz; # need the `dot` program, not the python module
  };

  elasticsearchdsl = self.elasticsearch-dsl;

  elfdeps = toPythonModule (pkgs.elfdeps.override { python3Packages = self; });

  emborg = callPackage ../development/python-modules/emborg { };

  entrance = callPackage ../development/python-modules/entrance { routerFeatures = false; };

  entrance-with-router-features = callPackage ../development/python-modules/entrance {
    routerFeatures = true;
  };

  etcd3 = callPackage ../development/python-modules/etcd3 { inherit (pkgs) etcd; };

  example-robot-data = callPackage ../development/python-modules/example-robot-data {
    inherit (pkgs) example-robot-data;
  };

  exiv2 = callPackage ../development/python-modules/exiv2 { inherit (pkgs) exiv2; };

  extra-streamlit-components =
    callPackage ../development/python-modules/extra-streamlit-components
      { };

  extractcode = callPackage ../development/python-modules/extractcode { };

  extractcode-7z = callPackage ../development/python-modules/extractcode/7z.nix {
    inherit (pkgs) p7zip;
  };

  extractcode-libarchive = callPackage ../development/python-modules/extractcode/libarchive.nix {
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

  face-recognition = callPackage ../development/python-modules/face-recognition { };

  face-recognition-models = callPackage ../development/python-modules/face-recognition/models.nix { };

  faiss = callPackage ../development/python-modules/faiss {
    faiss-build = pkgs.faiss.override {
      pythonSupport = true;
      python3Packages = self;
    };
  };

  faraday-agent-parameters-types =
    callPackage ../development/python-modules/faraday-agent-parameters-types
      { };

  fastnlo-toolkit = toPythonModule (
    pkgs.fastnlo-toolkit.override {
      withPython = true;
      inherit (self) python;
    }
  );

  fatrop = toPythonModule (
    pkgs.fatrop.override {
      pythonSupport = true;
      python3Packages = self;
    }
  );

  flask-sqlalchemy = callPackage ../development/python-modules/flask-sqlalchemy { };

  flask-sqlalchemy-lite = callPackage ../development/python-modules/flask-sqlalchemy-lite { };

  flatbuffers = callPackage ../development/python-modules/flatbuffers { inherit (pkgs) flatbuffers; };

  fluent-pygments = callPackage ../development/python-modules/python-fluent/fluent-pygments.nix { };

  fluent-runtime = callPackage ../development/python-modules/python-fluent/fluent-runtime.nix { };

  fluent-syntax = callPackage ../development/python-modules/python-fluent/fluent-syntax.nix { };

  flufl-bounce = callPackage ../development/python-modules/flufl/bounce.nix { };

  flufl-i18n = callPackage ../development/python-modules/flufl/i18n.nix { };

  flufl-lock = callPackage ../development/python-modules/flufl/lock.nix { };

  fontforge = toPythonModule (
    pkgs.fontforge.override {
      withPython = true;
      python3 = python;
    }
  );

  foundationdb = callPackage ../development/python-modules/foundationdb {
    inherit (pkgs) foundationdb;
  };

  freesasa = callPackage ../development/python-modules/freesasa { inherit (pkgs) freesasa; };

  fuse = callPackage ../development/python-modules/fuse-python { inherit (pkgs) fuse; };

  galario = toPythonModule (
    pkgs.galario.override {
      enablePython = true;
      pythonPackages = self;
    }
  );

  gattlib = callPackage ../development/python-modules/gattlib {
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

  geoip = callPackage ../development/python-modules/geoip { libgeoip = pkgs.geoip; };

  georss-ign-sismologia-client =
    callPackage ../development/python-modules/georss-ign-sismologia-client
      { };

  georss-ingv-centro-nazionale-terremoti-client =
    callPackage ../development/python-modules/georss-ingv-centro-nazionale-terremoti-client
      { };

  georss-nrcan-earthquakes-client =
    callPackage ../development/python-modules/georss-nrcan-earthquakes-client
      { };

  georss-qld-bushfire-alert-client =
    callPackage ../development/python-modules/georss-qld-bushfire-alert-client
      { };

  georss-tfs-incidents-client =
    callPackage ../development/python-modules/georss-tfs-incidents-client
      { };

  gepetto-gui = toPythonModule (gepetto-viewer.withPlugins [ gepetto-viewer-corba ]);

  gepetto-viewer = toPythonModule (pkgs.gepetto-viewer.override { python3Packages = self; });

  gepetto-viewer-corba = toPythonModule (
    pkgs.gepetto-viewer-corba.override { python3Packages = self; }
  );

  gfal2-util = callPackage ../development/python-modules/gfal2-util { inherit (pkgs) xrootd; };

  gios = callPackage ../development/python-modules/gios { };

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

  google-ai-generativelanguage =
    callPackage ../development/python-modules/google-ai-generativelanguage
      { };

  google-cloud-access-context-manager =
    callPackage ../development/python-modules/google-cloud-access-context-manager
      { };

  google-cloud-appengine-logging =
    callPackage ../development/python-modules/google-cloud-appengine-logging
      { };

  google-cloud-artifact-registry =
    callPackage ../development/python-modules/google-cloud-artifact-registry
      { };

  google-cloud-bigquery-datatransfer =
    callPackage ../development/python-modules/google-cloud-bigquery-datatransfer
      { };

  google-cloud-bigquery-logging =
    callPackage ../development/python-modules/google-cloud-bigquery-logging
      { };

  google-cloud-bigquery-storage =
    callPackage ../development/python-modules/google-cloud-bigquery-storage
      { };

  google-cloud-error-reporting =
    callPackage ../development/python-modules/google-cloud-error-reporting
      { };

  google-cloud-network-connectivity =
    callPackage ../development/python-modules/google-cloud-network-connectivity
      { };

  google-cloud-resource-manager =
    callPackage ../development/python-modules/google-cloud-resource-manager
      { };

  google-cloud-runtimeconfig =
    callPackage ../development/python-modules/google-cloud-runtimeconfig
      { };

  google-cloud-secret-manager =
    callPackage ../development/python-modules/google-cloud-secret-manager
      { };

  google-cloud-securitycenter =
    callPackage ../development/python-modules/google-cloud-securitycenter
      { };

  google-cloud-videointelligence =
    callPackage ../development/python-modules/google-cloud-videointelligence
      { };

  google-cloud-websecurityscanner =
    callPackage ../development/python-modules/google-cloud-websecurityscanner
      { };

  google-compute-engine = callPackage ../tools/virtualization/google-compute-engine { };

  google-crc32c = callPackage ../development/python-modules/google-crc32c { inherit (pkgs) crc32c; };

  gpaw = callPackage ../development/python-modules/gpaw {
    inherit (pkgs) libxc;
  };

  gpgme = callPackage ../development/python-modules/gpgme { inherit (pkgs) gpgme; };

  gprof2dot = callPackage ../development/python-modules/gprof2dot { inherit (pkgs) graphviz; };

  gradio = callPackage ../development/python-modules/gradio { };

  gradio-client = callPackage ../development/python-modules/gradio/client.nix { };

  gradio-pdf = callPackage ../development/python-modules/gradio-pdf { };

  grafanalib = callPackage ../development/python-modules/grafanalib/default.nix { };

  graph-tool = callPackage ../development/python-modules/graph-tool { inherit (pkgs) cgal graphviz; };

  graphql-subscription-manager =
    callPackage ../development/python-modules/graphql-subscription-manager
      { };

  # built-in for pypi
  greenlet = if isPyPy then null else callPackage ../development/python-modules/greenlet { };

  gruut-ipa = callPackage ../development/python-modules/gruut-ipa { inherit (pkgs) espeak; };

  gssapi = callPackage ../development/python-modules/gssapi {
    krb5-c = pkgs.krb5;
  };

  gst-python = callPackage ../development/python-modules/gst-python {
    # inherit (pkgs) meson won't work because it won't be spliced
    inherit (pkgs.buildPackages) meson;
  };

  gstools-cython = callPackage ../development/python-modules/gstools-cython { };

  gudhi = callPackage ../development/python-modules/gudhi { inherit (pkgs) cgal; };

  guestfs = toPythonModule (
    pkgs.libguestfs.override {
      python3 = python;
    }
  );

  h3 = callPackage ../development/python-modules/h3 { h3 = pkgs.h3_4; };

  h5py-mpi = self.h5py.override { hdf5 = pkgs.hdf5-mpi; };

  halide =
    toPythonModule
      (pkgs.halide.override {
        pythonSupport = true;
        python3Packages = self;
      }).lib;

  hatch-docstring-description =
    callPackage ../development/python-modules/hatch-docstring-description
      { };

  hdf5plugin = callPackage ../development/python-modules/hdf5plugin {
    inherit (pkgs) zstd lz4;
  };

  hepmc3 = toPythonModule (pkgs.hepmc3.override { inherit python; });

  hg-commitsigs = callPackage ../development/python-modules/hg-commitsigs { };

  hid = callPackage ../development/python-modules/hid { inherit (pkgs) hidapi; };

  hidapi = callPackage ../development/python-modules/hidapi { inherit (pkgs) hidapi udev; };

  hnswlib = callPackage ../development/python-modules/hnswlib { inherit (pkgs) hnswlib; };

  home-assistant-chip-clusters =
    callPackage ../development/python-modules/home-assistant-chip-clusters
      { };

  home-assistant-chip-wheels = toPythonModule (
    callPackage ../development/python-modules/home-assistant-chip-wheels { }
  );

  homeassistant-stubs = callPackage ../servers/home-assistant/stubs.nix { };

  horizon-eda = callPackage ../development/python-modules/horizon-eda { inherit (pkgs) horizon-eda; };

  hyperglot = callPackage ../development/python-modules/hyperglot { };

  i2c-tools = callPackage ../development/python-modules/i2c-tools { inherit (pkgs) i2c-tools; };

  icoextract = toPythonModule (pkgs.icoextract.override { python3Packages = self; });

  ifcopenshell = callPackage ../development/python-modules/ifcopenshell {
    inherit (pkgs) cgal_5 libxml2;
  };

  igraph = callPackage ../development/python-modules/igraph { inherit (pkgs) igraph; };

  imread = callPackage ../development/python-modules/imread {
    inherit (pkgs)
      libjpeg
      libpng
      libtiff
      libwebp
      ;
  };

  indexed-gzip = callPackage ../development/python-modules/indexed-gzip { inherit (pkgs) zlib; };

  indexed-zstd = callPackage ../development/python-modules/indexed-zstd { inherit (pkgs) zstd; };

  insteon-frontend-home-assistant =
    callPackage ../development/python-modules/insteon-frontend-home-assistant
      { };

  islpy = callPackage ../development/python-modules/islpy { isl = pkgs.isl_0_27; };

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

  jaxlib-bin = callPackage ../development/python-modules/jaxlib/bin.nix { };

  jaxlib-build = callPackage ../development/python-modules/jaxlib {
    snappy-cpp = pkgs.snappy;
  };

  jinja2-ansible-filters = callPackage ../development/python-modules/jinja2-ansible-filters { };

  jq = callPackage ../development/python-modules/jq { inherit (pkgs) jq; };

  jupyter-highlight-selected-word =
    callPackage ../development/python-modules/jupyter-highlight-selected-word
      { };

  jupyter-nbextensions-configurator =
    callPackage ../development/python-modules/jupyter-nbextensions-configurator
      { };

  jupyter-repo2docker = callPackage ../development/python-modules/jupyter-repo2docker {
    pkgs-docker = pkgs.docker;
  };

  jupyterhub-ldapauthenticator =
    callPackage ../development/python-modules/jupyterhub-ldapauthenticator
      { };

  jupyterhub-tmpauthenticator =
    callPackage ../development/python-modules/jupyterhub-tmpauthenticator
      { };

  k5test = callPackage ../development/python-modules/k5test {
    inherit (pkgs) findutils;
    krb5-c = pkgs.krb5;
  };

  kaa-base = callPackage ../development/python-modules/kaa-base { };

  kaa-metadata = callPackage ../development/python-modules/kaa-metadata { };

  kahip = toPythonModule (
    pkgs.kahip.override {
      pythonSupport = true;
      python3Packages = self;
    }
  );

  keyrings-google-artifactregistry-auth =
    callPackage ../development/python-modules/keyrings-google-artifactregistry-auth
      { };

  keyutils = callPackage ../development/python-modules/keyutils { inherit (pkgs) keyutils; };

  kicad = toPythonModule (pkgs.kicad.override { python3 = python; }).src;

  kmsxx = toPythonModule (
    pkgs.kmsxx.override {
      withPython = true;
      python3Packages = self;
    }
  );

  krb5 = callPackage ../development/python-modules/krb5 { krb5-c = pkgs.krb5; };

  kubernetes-validate = callPackage ../by-name/ku/kubernetes-validate/unwrapped.nix { };

  lammps = callPackage ../development/python-modules/lammps { inherit (pkgs) lammps; };

  lance-namespace-urllib3-client =
    callPackage ../development/python-modules/lance-namespace-urllib3-client
      { };

  lancedb = callPackage ../development/python-modules/lancedb { inherit (pkgs) protobuf; };

  langchain-azure-dynamic-sessions =
    callPackage ../development/python-modules/langchain-azure-dynamic-sessions
      { };

  langgraph-checkpoint-mongodb =
    callPackage ../development/python-modules/langgraph-checkpoint-mongodb
      { };

  langgraph-checkpoint-postgres =
    callPackage ../development/python-modules/langgraph-checkpoint-postgres
      { };

  langgraph-checkpoint-sqlite =
    callPackage ../development/python-modules/langgraph-checkpoint-sqlite
      { };

  laszip = callPackage ../development/python-modules/laszip {
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

  legacy-cgi =
    if pythonOlder "3.13" then null else callPackage ../development/python-modules/legacy-cgi { };

  leidenalg = callPackage ../development/python-modules/leidenalg { igraph-c = pkgs.igraph; };

  lgpio = toPythonModule (
    pkgs.lgpio.override {
      inherit buildPythonPackage;
      pyProject = "PY_LGPIO";
      lgpioWithoutPython = pkgs.lgpio;
    }
  );

  lhapdf = toPythonModule (pkgs.lhapdf.override { python3 = python; });

  libapparmor = toPythonModule (
    pkgs.libapparmor.override {
      python3Packages = self;
    }
  );

  libarchive-c = callPackage ../development/python-modules/libarchive-c {
    inherit (pkgs) libarchive;
  };

  libarcus = callPackage ../development/python-modules/libarcus { protobuf = pkgs.protobuf_21; };

  libasyncns = callPackage ../development/python-modules/libasyncns { inherit (pkgs) libasyncns; };

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

  libgpiod = callPackage ../development/python-modules/libgpiod { inherit (pkgs) libgpiod; };

  libiio =
    (toPythonModule (
      pkgs.libiio.override {
        pythonSupport = true;
        python3 = python;
      }
    )).python;

  liblzfse = callPackage ../development/python-modules/liblzfse { inherit (pkgs) lzfse; };

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

  libnacl = callPackage ../development/python-modules/libnacl { inherit (pkgs) libsodium; };

  libnbd = toPythonModule (
    pkgs.libnbd.override {
      buildPythonBindings = true;
      python3 = python;
    }
  );

  libparse-python = callPackage ../development/python-modules/libparse-python/package.nix { };

  libpcap = callPackage ../development/python-modules/libpcap {
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

  libsass = callPackage ../development/python-modules/libsass { inherit (pkgs) libsass; };

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
          broken = super.meta.broken or isPy27;
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

  libsixel = callPackage ../development/python-modules/libsixel { inherit (pkgs) libsixel; };

  libtorrent-rasterbar =
    (toPythonModule (pkgs.libtorrent-rasterbar.override { python3 = python; })).python;

  libusb-package = callPackage ../development/python-modules/libusb-package {
    inherit (pkgs) libusb1;
  };

  libusb1 = callPackage ../development/python-modules/libusb1 { inherit (pkgs) libusb1; };

  libusbsio = callPackage ../development/python-modules/libusbsio { inherit (pkgs) libusbsio; };

  libversion = callPackage ../development/python-modules/libversion { inherit (pkgs) libversion; };

  libvirt = callPackage ../development/python-modules/libvirt { inherit (pkgs) libvirt; };

  libxc = callPackage ../by-name/li/libxc/python.nix {
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

  llama-index-embeddings-gemini =
    callPackage ../development/python-modules/llama-index-embeddings-gemini
      { };

  llama-index-embeddings-google =
    callPackage ../development/python-modules/llama-index-embeddings-google
      { };

  llama-index-embeddings-huggingface =
    callPackage ../development/python-modules/llama-index-embeddings-huggingface
      { };

  llama-index-embeddings-ollama =
    callPackage ../development/python-modules/llama-index-embeddings-ollama
      { };

  llama-index-embeddings-openai =
    callPackage ../development/python-modules/llama-index-embeddings-openai
      { };

  llama-index-graph-stores-nebula =
    callPackage ../development/python-modules/llama-index-graph-stores-nebula
      { };

  llama-index-graph-stores-neo4j =
    callPackage ../development/python-modules/llama-index-graph-stores-neo4j
      { };

  llama-index-graph-stores-neptune =
    callPackage ../development/python-modules/llama-index-graph-stores-neptune
      { };

  llama-index-indices-managed-llama-cloud =
    callPackage ../development/python-modules/llama-index-indices-managed-llama-cloud
      { };

  llama-index-instrumentation =
    callPackage ../development/python-modules/llama-index-instrumentation
      { };

  llama-index-llms-openai-like =
    callPackage ../development/python-modules/llama-index-llms-openai-like
      { };

  llama-index-multi-modal-llms-openai =
    callPackage ../development/python-modules/llama-index-multi-modal-llms-openai
      { };

  llama-index-node-parser-docling =
    callPackage ../development/python-modules/llama-index-node-parser-docling
      { };

  llama-index-readers-database =
    callPackage ../development/python-modules/llama-index-readers-database
      { };

  llama-index-readers-docling =
    callPackage ../development/python-modules/llama-index-readers-docling
      { };

  llama-index-readers-llama-parse =
    callPackage ../development/python-modules/llama-index-readers-llama-parse
      { };

  llama-index-readers-twitter =
    callPackage ../development/python-modules/llama-index-readers-twitter
      { };

  llama-index-readers-weather =
    callPackage ../development/python-modules/llama-index-readers-weather
      { };

  llama-index-vector-stores-chroma =
    callPackage ../development/python-modules/llama-index-vector-stores-chroma
      { };

  llama-index-vector-stores-google =
    callPackage ../development/python-modules/llama-index-vector-stores-google
      { };

  llama-index-vector-stores-milvus =
    callPackage ../development/python-modules/llama-index-vector-stores-milvus
      { };

  llama-index-vector-stores-postgres =
    callPackage ../development/python-modules/llama-index-vector-stores-postgres
      { };

  llama-index-vector-stores-qdrant =
    callPackage ../development/python-modules/llama-index-vector-stores-qdrant
      { };

  llfuse = callPackage ../development/python-modules/llfuse { inherit (pkgs) fuse; };

  llvmlite = callPackage ../development/python-modules/llvmlite {
    inherit (pkgs) cmake ninja;
  };

  lmdb = callPackage ../development/python-modules/lmdb { inherit (pkgs) lmdb; };

  logilab-common = callPackage ../development/python-modules/logilab/common.nix {
    pytestCheckHook = pytest7CheckHook;
  };

  logilab-constraint = callPackage ../development/python-modules/logilab/constraint.nix { };

  lsprotocol = callPackage ../development/python-modules/lsprotocol { };

  lsprotocol_2023 = callPackage ../development/python-modules/lsprotocol/2023.nix { };

  lxml = callPackage ../development/python-modules/lxml { inherit (pkgs) libxml2 libxslt zlib; };

  magic-wormhole-mailbox-server =
    callPackage ../development/python-modules/magic-wormhole-mailbox-server
      { };

  magic-wormhole-transit-relay =
    callPackage ../development/python-modules/magic-wormhole-transit-relay
      { };

  manifestparser =
    callPackage ../development/python-modules/marionette-harness/manifestparser.nix
      { };

  marisa = callPackage ../development/python-modules/marisa { inherit (pkgs) marisa; };

  marisa-trie = callPackage ../development/python-modules/marisa-trie {
    marisa-cpp = pkgs.marisa;
  };

  marshmallow-sqlalchemy = callPackage ../development/python-modules/marshmallow-sqlalchemy { };

  matplotlib = callPackage ../development/python-modules/matplotlib {
    stdenv = if stdenv.hostPlatform.isDarwin then pkgs.clangStdenv else pkgs.stdenv;
  };

  maubot = callPackage ../tools/networking/maubot { };

  mautrix-appservice = self.mautrix; # alias 2019-12-28

  mayavi = pkgs.libsForQt5.callPackage ../development/python-modules/mayavi {
    inherit buildPythonPackage;
    inherit (self)
      pyface
      pygments
      numpy
      packaging
      vtk
      traitsui
      envisage
      apptools
      pyqt5
      ;
  };

  mercurial = toPythonModule (pkgs.mercurial.override { python3Packages = self; });

  meson = toPythonModule (
    (pkgs.meson.override { python3 = python; }).overridePythonAttrs (oldAttrs: {
      # We do not want the setup hook in Python packages because the build is performed differently.
      setupHook = null;
    })
  );

  meson-python = callPackage ../development/python-modules/meson-python { inherit (pkgs) ninja; };

  microsoft-kiota-abstractions =
    callPackage ../development/python-modules/microsoft-kiota-abstractions
      { };

  microsoft-kiota-authentication-azure =
    callPackage ../development/python-modules/microsoft-kiota-authentication-azure
      { };

  microsoft-kiota-serialization-form =
    callPackage ../development/python-modules/microsoft-kiota-serialization-form
      { };

  microsoft-kiota-serialization-json =
    callPackage ../development/python-modules/microsoft-kiota-serialization-json
      { };

  microsoft-kiota-serialization-multipart =
    callPackage ../development/python-modules/microsoft-kiota-serialization-multipart
      { };

  microsoft-kiota-serialization-text =
    callPackage ../development/python-modules/microsoft-kiota-serialization-text
      { };

  microsoft-security-utilities-secret-masker =
    callPackage ../development/python-modules/microsoft-security-utilities-secret-masker
      { };

  mim-solvers = callPackage ../development/python-modules/mim-solvers { inherit (pkgs) mim-solvers; };

  minichain = callPackage ../development/python-modules/minichain { };

  mininet-python = (toPythonModule (pkgs.mininet.override { python3 = python; })).py;

  mkdocs-git-committers-plugin-2 =
    callPackage ../development/python-modules/mkdocs-git-committers-plugin-2
      { };

  mkdocs-git-revision-date-localized-plugin =
    callPackage ../development/python-modules/mkdocs-git-revision-date-localized-plugin
      { };

  mkdocs-include-markdown-plugin =
    callPackage ../development/python-modules/mkdocs-include-markdown-plugin
      { };

  mkdocs-material = callPackage ../development/python-modules/mkdocs-material { };

  mkdocs-material-extensions =
    callPackage ../development/python-modules/mkdocs-material/mkdocs-material-extensions.nix
      { };

  mkdocs-table-reader-plugin =
    callPackage ../development/python-modules/mkdocs-table-reader-plugin
      { };

  mlt = toPythonModule (
    pkgs.mlt.override {
      python3 = python;
      enablePython = true;
    }
  );

  mmpython = callPackage ../development/python-modules/mmpython { };

  model-hosting-container-standards =
    callPackage ../development/python-modules/model-hosting-container-standards
      { };

  moderngl-window = callPackage ../development/python-modules/moderngl-window {
    inherit (pkgs) mesa;
  };

  molecule = callPackage ../development/python-modules/molecule { };

  molecule-plugins = callPackage ../development/python-modules/molecule/plugins.nix { };

  monosat = pkgs.monosat.python {
    inherit buildPythonPackage;
    inherit (self) cython pytestCheckHook;
  };

  monotonic-alignment-search =
    callPackage ../development/python-modules/monotonic-alignment-search
      { };

  mozjpeg_lossless_optimization =
    callPackage ../development/python-modules/mozjpeg_lossless_optimization
      { };

  mpi-pytest = callPackage ../development/python-modules/mpi-pytest { };

  mpl-typst = callPackage ../development/python-modules/mpl-typst {
    inherit (pkgs) typst;
  };

  mpv = callPackage ../development/python-modules/mpv { inherit (pkgs) mpv; };

  mujoco = callPackage ../development/python-modules/mujoco { inherit (pkgs) mujoco; };

  mujoco-mjx = callPackage ../development/python-modules/mujoco-mjx { mujoco-main = pkgs.mujoco; };

  myhdl = callPackage ../development/python-modules/myhdl { inherit (pkgs) ghdl iverilog; };

  mypy = callPackage ../development/python-modules/mypy { };

  inherit (callPackage ../development/python-modules/mypy-boto3 { })
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

  mypy-boto3-builder = callPackage ../development/python-modules/mypy-boto3-builder { };

  mypy-extensions = callPackage ../development/python-modules/mypy/extensions.nix { };

  mypy-protobuf = callPackage ../development/python-modules/mypy-protobuf { };

  mypyllant = callPackage ../development/python-modules/mypyllant { };

  nanomsg-python = callPackage ../development/python-modules/nanomsg-python {
    inherit (pkgs) nanomsg;
  };

  napalm = callPackage ../development/python-modules/napalm { };

  napalm-hp-procurve = callPackage ../development/python-modules/napalm/hp-procurve.nix { };

  napalm-ros = callPackage ../development/python-modules/napalm/ros.nix { };

  napari = callPackage ../development/python-modules/napari {
    inherit (pkgs.libsForQt5) mkDerivationWith wrapQtAppsHook;
  };

  ndcurves = callPackage ../development/python-modules/ndcurves { inherit (pkgs) ndcurves; };

  nest = toPythonModule (
    pkgs.nest-mpi.override {
      withPython = true;
      python3 = python;
    }
  );

  netbox-interface-synchronization =
    callPackage ../development/python-modules/netbox-interface-synchronization
      { };

  netbox-napalm-plugin = callPackage ../development/python-modules/netbox-napalm-plugin { };

  netbox-plugin-prometheus-sd =
    callPackage ../development/python-modules/netbox-plugin-prometheus-sd
      { };

  netgen-mesher = toPythonModule (pkgs.netgen.override { python3Packages = self; });

  neuron-full = pkgs.neuron-full.override { python3 = python; };

  neuronpy = toPythonModule neuron-full;

  nevow = callPackage ../development/python-modules/nevow { };

  nftables = callPackage ../os-specific/linux/nftables/python.nix { inherit (pkgs) nftables; };

  ninja = callPackage ../development/python-modules/ninja { inherit (pkgs) ninja; };

  nipype = callPackage ../development/python-modules/nipype { inherit (pkgs) which; };

  nix-kernel = callPackage ../development/python-modules/nix-kernel { inherit (pkgs) nix; };

  nnpdf = toPythonModule (pkgs.nnpdf.override { python3 = python; });

  nominatim-api = callPackage ../by-name/no/nominatim/nominatim-api.nix { };

  nose2pytest = callPackage ../development/python-modules/nose2pytest { };

  notifications-python-client =
    callPackage ../development/python-modules/notifications-python-client
      { };

  notmuch = callPackage ../development/python-modules/notmuch { inherit (pkgs) notmuch; };

  notmuch2 = callPackage ../development/python-modules/notmuch2 { inherit (pkgs) notmuch; };

  numba = callPackage ../development/python-modules/numba { inherit (pkgs.config) cudaSupport; };

  numbaWithCuda = self.numba.override { cudaSupport = true; };

  numcodecs = callPackage ../development/python-modules/numcodecs {
    inherit (pkgs) zstd;
  };

  numpy = numpy_2;

  numpy_1 = callPackage ../development/python-modules/numpy/1.nix { };

  numpy_2 = callPackage ../development/python-modules/numpy/2.nix { };

  nvidia-dlprof-pytorch-nvtx =
    callPackage ../development/python-modules/nvidia-dlprof-pytorch-nvtx
      { };

  obfsproxy = callPackage ../development/python-modules/obfsproxy { };

  objgraph = callPackage ../development/python-modules/objgraph {
    # requires both the graphviz package and python package
    graphvizPkgs = pkgs.graphviz;
  };

  ocrmypdf = callPackage ../development/python-modules/ocrmypdf { tesseract = pkgs.tesseract5; };

  omniorb = toPythonModule (pkgs.omniorb.override { python3 = self.python; });

  online-judge-verify-helper =
    callPackage ../development/python-modules/online-judge-verify-helper
      { };

  onnx = callPackage ../development/python-modules/onnx {
    onnx = pkgs.onnx.override {
      python3Packages = self;
    };
  };

  onnxruntime = callPackage ../development/python-modules/onnxruntime {
    onnxruntime = pkgs.onnxruntime.override {
      python3Packages = self;
      pythonSupport = true;
    };
  };

  openapi-pydantic = callPackage ../development/python-modules/openapi-pydantic { };

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
      enableGtk2 = true;
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

  openmm = toPythonModule (
    pkgs.openmm.override {
      python3Packages = self;
      enablePython = true;
    }
  );

  openpaperwork-core = callPackage ../applications/office/paperwork/openpaperwork-core.nix { };

  openpaperwork-gtk = callPackage ../applications/office/paperwork/openpaperwork-gtk.nix { };

  openrazer = callPackage ../development/python-modules/openrazer/pylib.nix { };

  openrazer-daemon = callPackage ../development/python-modules/openrazer/daemon.nix { };

  openslide = callPackage ../development/python-modules/openslide { inherit (pkgs) openslide; };

  opentelemetry-exporter-otlp =
    callPackage ../development/python-modules/opentelemetry-exporter-otlp
      { };

  opentelemetry-exporter-otlp-proto-common =
    callPackage ../development/python-modules/opentelemetry-exporter-otlp-proto-common
      { };

  opentelemetry-exporter-otlp-proto-grpc =
    callPackage ../development/python-modules/opentelemetry-exporter-otlp-proto-grpc
      { };

  opentelemetry-exporter-otlp-proto-http =
    callPackage ../development/python-modules/opentelemetry-exporter-otlp-proto-http
      { };

  opentelemetry-exporter-prometheus =
    callPackage ../development/python-modules/opentelemetry-exporter-prometheus
      { };

  opentelemetry-instrumentation =
    callPackage ../development/python-modules/opentelemetry-instrumentation
      { };

  opentelemetry-instrumentation-aiohttp-client =
    callPackage ../development/python-modules/opentelemetry-instrumentation-aiohttp-client
      { };

  opentelemetry-instrumentation-asgi =
    callPackage ../development/python-modules/opentelemetry-instrumentation-asgi
      { };

  opentelemetry-instrumentation-botocore =
    callPackage ../development/python-modules/opentelemetry-instrumentation-botocore
      { };

  opentelemetry-instrumentation-celery =
    callPackage ../development/python-modules/opentelemetry-instrumentation-celery
      { };

  opentelemetry-instrumentation-dbapi =
    callPackage ../development/python-modules/opentelemetry-instrumentation-dbapi
      { };

  opentelemetry-instrumentation-django =
    callPackage ../development/python-modules/opentelemetry-instrumentation-django
      { };

  opentelemetry-instrumentation-fastapi =
    callPackage ../development/python-modules/opentelemetry-instrumentation-fastapi
      { };

  opentelemetry-instrumentation-flask =
    callPackage ../development/python-modules/opentelemetry-instrumentation-flask
      { };

  opentelemetry-instrumentation-grpc =
    callPackage ../development/python-modules/opentelemetry-instrumentation-grpc
      { };

  opentelemetry-instrumentation-httpx =
    callPackage ../development/python-modules/opentelemetry-instrumentation-httpx
      { };

  opentelemetry-instrumentation-logging =
    callPackage ../development/python-modules/opentelemetry-instrumentation-logging
      { };

  opentelemetry-instrumentation-psycopg2 =
    callPackage ../development/python-modules/opentelemetry-instrumentation-psycopg2
      { };

  opentelemetry-instrumentation-redis =
    callPackage ../development/python-modules/opentelemetry-instrumentation-redis
      { };

  opentelemetry-instrumentation-requests =
    callPackage ../development/python-modules/opentelemetry-instrumentation-requests
      { };

  opentelemetry-instrumentation-sqlalchemy =
    callPackage ../development/python-modules/opentelemetry-instrumentation-sqlalchemy
      { };

  opentelemetry-instrumentation-urllib3 =
    callPackage ../development/python-modules/opentelemetry-instrumentation-urllib3
      { };

  opentelemetry-instrumentation-wsgi =
    callPackage ../development/python-modules/opentelemetry-instrumentation-wsgi
      { };

  opentelemetry-propagator-aws-xray =
    callPackage ../development/python-modules/opentelemetry-propagator-aws-xray
      { };

  opentelemetry-semantic-conventions =
    callPackage ../development/python-modules/opentelemetry-semantic-conventions
      { };

  openturns = toPythonModule (
    pkgs.openturns.override {
      python3Packages = self;
      enablePython = true;
    }
  );

  openusd = callPackage ../development/python-modules/openusd { alembic = pkgs.alembic; };

  openvino = callPackage ../development/python-modules/openvino {
    openvino-native = pkgs.openvino.override { python3Packages = self; };
  };

  ortools = (toPythonModule (pkgs.or-tools.override { python3 = self.python; })).python;

  paho-mqtt = callPackage ../development/python-modules/paho-mqtt/default.nix { };

  pandas = callPackage ../development/python-modules/pandas { inherit (pkgs.darwin) adv_cmds; };

  paperwork-backend = callPackage ../applications/office/paperwork/paperwork-backend.nix { };

  paperwork-shell = callPackage ../applications/office/paperwork/paperwork-shell.nix { };

  parameter-expansion-patched =
    callPackage ../development/python-modules/parameter-expansion-patched
      { };

  paranoid-crypto = callPackage ../development/python-modules/paranoid-crypto { };

  pcapy-ng = callPackage ../development/python-modules/pcapy-ng {
    inherit (pkgs) libpcap; # Avoid confusion with python package of the same name
  };

  pelican = callPackage ../development/python-modules/pelican { inherit (pkgs) glibcLocales git; };

  petsc4py = toPythonModule (
    pkgs.petsc.override {
      python3Packages = self;
      pythonSupport = true;
    }
  );

  piano-transcription-inference =
    callPackage ../development/python-modules/piano-transcription-inference
      { };

  pigpio = toPythonModule (
    pkgs.pigpio.override {
      inherit buildPythonPackage;
    }
  );

  pillow = callPackage ../development/python-modules/pillow {
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
      ;
    inherit (pkgs.xorg) libxcb;
  };

  pinocchio = callPackage ../development/python-modules/pinocchio { inherit (pkgs) pinocchio; };

  piper-phonemize = callPackage ../development/python-modules/piper-phonemize {
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

  plantuml-markdown = callPackage ../development/python-modules/plantuml-markdown {
    inherit (pkgs) plantuml;
  };

  plfit = toPythonModule (pkgs.plfit.override { inherit (self) python; });

  pocketsphinx = callPackage ../development/python-modules/pocketsphinx {
    inherit (pkgs) pocketsphinx;
  };

  poppler-qt5 = callPackage ../development/python-modules/poppler-qt5 {
    inherit (pkgs.qt5) qtbase qmake;
    inherit (pkgs.libsForQt5) poppler;
  };

  prayer-times-calculator-offline =
    callPackage ../development/python-modules/prayer-times-calculator-offline
      { };

  prefect = toPythonModule pkgs.prefect;

  prometheus-fastapi-instrumentator =
    callPackage ../development/python-modules/prometheus-fastapi-instrumentator
      { };

  # If a protobuf upgrade causes many Python packages to fail, please pin it here to the previous version.
  protobuf = protobuf6;

  # Protobuf 4.x
  protobuf4 = callPackage ../development/python-modules/protobuf/4.nix {
    protobuf = pkgs.protobuf_25;
  };

  # Protobuf 5.x
  protobuf5 = callPackage ../development/python-modules/protobuf/5.nix {
    protobuf = pkgs.__splicedPackages.protobuf_29;
  };

  # Protobuf 6.x
  protobuf6 = callPackage ../development/python-modules/protobuf/6.nix {
    inherit (pkgs.__splicedPackages) protobuf;
  };

  proxsuite = toPythonModule (
    pkgs.proxsuite.override {
      pythonSupport = true;
      python3Packages = self;
    }
  );

  psycopg-c = psycopg.c;

  psycopg-pool = psycopg.pool;

  pulumi-aws-native = pkgs.pulumiPackages.pulumi-aws-native.sdks.python;

  pulumi-azure-native = pkgs.pulumiPackages.pulumi-azure-native.sdks.python;

  pulumi-command = pkgs.pulumiPackages.pulumi-command.sdks.python;

  pulumi-hcloud = pkgs.pulumiPackages.pulumi-hcloud.sdks.python;

  pulumi-random = pkgs.pulumiPackages.pulumi-random.sdks.python;

  pure-python-adb-homeassistant =
    callPackage ../development/python-modules/pure-python-adb-homeassistant
      { };

  pwntools = callPackage ../development/python-modules/pwntools { debugger = pkgs.gdb; };

  py-desmume = callPackage ../development/python-modules/py-desmume {
    inherit (pkgs) libpcap; # Avoid confusion with python package of the same name
  };

  py3exiv2 = callPackage ../development/python-modules/py3exiv2 { inherit (pkgs) exiv2; };

  pyabpoa = toPythonModule (
    pkgs.abpoa.override {
      enablePython = true;
      python3Packages = self;
    }
  );

  pyarrow = callPackage ../development/python-modules/pyarrow { inherit (pkgs) arrow-cpp cmake; };

  pyatspi = callPackage ../development/python-modules/pyatspi { inherit (pkgs.buildPackages) meson; };

  pybluez = callPackage ../development/python-modules/pybluez { inherit (pkgs) bluez; };

  pycairo = callPackage ../development/python-modules/pycairo { inherit (pkgs.buildPackages) meson; };

  pycangjie = callPackage ../development/python-modules/pycangjie {
    inherit (pkgs.buildPackages) meson;
  };

  pycflow2dot = callPackage ../development/python-modules/pycflow2dot { inherit (pkgs) graphviz; };

  pycuda = callPackage ../development/python-modules/pycuda { inherit (pkgs.stdenv) mkDerivation; };

  pydantic = callPackage ../development/python-modules/pydantic { };

  pydantic-argparse-extensible =
    callPackage ../development/python-modules/pydantic-argparse-extensible
      { };

  pydantic-compat = callPackage ../development/python-modules/pydantic-compat { };

  pydantic-core = callPackage ../development/python-modules/pydantic-core { };

  pydantic-extra-types = callPackage ../development/python-modules/pydantic-extra-types { };

  pydantic-scim = callPackage ../development/python-modules/pydantic-scim { };

  pydantic-settings = callPackage ../development/python-modules/pydantic-settings { };

  pydantic_1 = callPackage ../development/python-modules/pydantic/1.nix { };

  pydeps = callPackage ../development/python-modules/pydeps { inherit (pkgs) graphviz; };

  pydot = callPackage ../development/python-modules/pydot { inherit (pkgs) graphviz; };

  pyenchant = callPackage ../development/python-modules/pyenchant { inherit (pkgs) enchant_2; };

  pyfwup = callPackage ../development/python-modules/pyfwup { inherit (pkgs) libusb1; };

  pyfzf = callPackage ../development/python-modules/pyfzf { inherit (pkgs) fzf; };

  # pygame-ce is better maintained upstream, the breaking point was https://github.com/NixOS/nixpkgs/pull/475917#issuecomment-3706940043
  pygame = if pythonAtLeast "3.14" then pygame-ce else pygame-original;

  pygls = callPackage ../development/python-modules/pygls { };

  pygls_1 = callPackage ../development/python-modules/pygls/1.nix { };

  pygobject3 = callPackage ../development/python-modules/pygobject/3.nix {
    # inherit (pkgs) meson won't work because it won't be spliced
    inherit (pkgs.buildPackages) meson;
  };

  pygraphviz = callPackage ../development/python-modules/pygraphviz { inherit (pkgs) graphviz; };

  pygsl = callPackage ../development/python-modules/pygsl { inherit (pkgs) gsl swig; };

  pyimpfuzzy = callPackage ../development/python-modules/pyimpfuzzy { inherit (pkgs) ssdeep; };

  pykdtree = callPackage ../development/python-modules/pykdtree {
    inherit (pkgs.llvmPackages) openmp;
  };

  pykerberos = callPackage ../development/python-modules/pykerberos { krb5-c = pkgs.krb5; };

  pylibftdi = callPackage ../development/python-modules/pylibftdi { inherit (pkgs) libusb1; };

  pylsp-mypy = callPackage ../development/python-modules/pylsp-mypy { };

  pymorphy2 = callPackage ../development/python-modules/pymorphy2 { };

  pymorphy2-dicts-ru = callPackage ../development/python-modules/pymorphy2-dicts-ru { };

  pymorphy3 = callPackage ../development/python-modules/pymorphy3 { };

  pymorphy3-dicts-ru = callPackage ../development/python-modules/pymorphy3-dicts-ru { };

  pymorphy3-dicts-uk = callPackage ../development/python-modules/pymorphy3-dicts-uk { };

  pymssql = callPackage ../development/python-modules/pymssql { krb5-c = pkgs.krb5; };

  pync = callPackage ../development/python-modules/pync { inherit (pkgs) which; };

  pyobjc-framework-CoreBluetooth =
    callPackage ../development/python-modules/pyobjc-framework-CoreBluetooth
      { };

  pyobjc-framework-libdispatch =
    callPackage ../development/python-modules/pyobjc-framework-libdispatch
      { };

  pyocr = callPackage ../development/python-modules/pyocr { tesseract = pkgs.tesseract4; };

  pyopen-wakeword = callPackage ../development/python-modules/pyopen-wakeword/default.nix { };

  pyopengl = callPackage ../development/python-modules/pyopengl {
    inherit (pkgs) mesa;
  };

  pyosmium = callPackage ../development/python-modules/pyosmium { inherit (pkgs) lz4; };

  pypamtest = toPythonModule (
    pkgs.libpam-wrapper.override {
      enablePython = true;
      inherit python;
    }
  );

  pyprecice = callPackage ../development/python-modules/pyprecice {
    precice = pkgs.precice.override {
      python3Packages = self;
    };
  };

  pyptlib = callPackage ../development/python-modules/pyptlib { };

  pyqt3d = pkgs.libsForQt5.callPackage ../development/python-modules/pyqt3d {
    inherit (self)
      buildPythonPackage
      pyqt5
      pyqt-builder
      python
      setuptools
      sip
      ;
  };

  pyqt5 = callPackage ../development/python-modules/pyqt/5.x.nix { inherit (pkgs) mesa; };

  pyqt5-multimedia = self.pyqt5.override { withMultimedia = true; };

  pyqt5-sip = callPackage ../development/python-modules/pyqt/sip.nix {
    inherit (pkgs) mesa;
  };

  # `pyqt5-webkit` should not be used by python libraries in
  # pkgs/development/python-modules/*. Putting this attribute in
  # `propagatedBuildInputs` may cause collisions.
  pyqt5-webkit = self.pyqt5.override { withWebKit = true; };

  pyqt6 = callPackage ../development/python-modules/pyqt/6.x.nix {
    inherit (pkgs) mesa;
  };

  pyqt6-charts = callPackage ../development/python-modules/pyqt6-charts {
    inherit (pkgs) mesa;
  };

  pyqt6-sip = callPackage ../development/python-modules/pyqt/pyqt6-sip.nix {
    inherit (pkgs) mesa;
  };

  pyqt6-webengine = callPackage ../development/python-modules/pyqt6-webengine {
    inherit (pkgs) mesa;
  };

  pyqtchart = pkgs.libsForQt5.callPackage ../development/python-modules/pyqtchart {
    inherit (self)
      buildPythonPackage
      pyqt5
      pyqt-builder
      python
      setuptools
      sip
      ;
  };

  pyqtdatavisualization =
    pkgs.libsForQt5.callPackage ../development/python-modules/pyqtdatavisualization
      {
        inherit (self)
          buildPythonPackage
          pyqt5
          pyqt-builder
          python
          setuptools
          sip
          ;
      };

  pyqtwebengine = callPackage ../development/python-modules/pyqtwebengine {
    inherit (pkgs) mesa;
  };

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

  pyrender = callPackage ../development/python-modules/pyrender {
    inherit (pkgs) mesa;
  };

  pysaml2 = callPackage ../development/python-modules/pysaml2 { inherit (pkgs) xmlsec; };

  pysc2 = callPackage ../development/python-modules/pysc2 { };

  pyscaffoldext-cookiecutter =
    callPackage ../development/python-modules/pyscaffoldext-cookiecutter
      { };

  pyscaffoldext-custom-extension =
    callPackage ../development/python-modules/pyscaffoldext-custom-extension
      { };

  pyscf = callPackage ../development/python-modules/pyscf {
    inherit (pkgs) libxc;
  };

  pysearpc = toPythonModule (pkgs.libsearpc.override { python3 = self.python; });

  pyside2 = toPythonModule (
    callPackage ../development/python-modules/pyside2 { inherit (pkgs) cmake ninja qt5; }
  );

  pyside2-tools = toPythonModule (
    callPackage ../development/python-modules/pyside2-tools { inherit (pkgs) cmake qt5; }
  );

  pyside6 = toPythonModule (
    callPackage ../development/python-modules/pyside6 { inherit (pkgs) cmake ninja; }
  );

  pysigma-backend-elasticsearch =
    callPackage ../development/python-modules/pysigma-backend-elasticsearch
      { };

  pysigma-backend-insightidr =
    callPackage ../development/python-modules/pysigma-backend-insightidr
      { };

  pysigma-backend-opensearch =
    callPackage ../development/python-modules/pysigma-backend-opensearch
      { };

  pysigma-pipeline-crowdstrike =
    callPackage ../development/python-modules/pysigma-pipeline-crowdstrike
      { };

  pyslurm = callPackage ../development/python-modules/pyslurm { inherit (pkgs) slurm; };

  pysoundfile = self.soundfile; # Alias added 23-06-2019

  pystemd = callPackage ../development/python-modules/pystemd { inherit (pkgs) systemd; };

  pysvn = callPackage ../development/python-modules/pysvn {
    inherit (pkgs)
      bash
      subversion
      apr
      aprutil
      ;
  };

  pytest = callPackage ../development/python-modules/pytest { };

  pytest-aio = callPackage ../development/python-modules/pytest-aio { };

  pytest-aiohttp = callPackage ../development/python-modules/pytest-aiohttp { };

  pytest-aioresponses = callPackage ../development/python-modules/pytest-aioresponses { };

  pytest-annotate = callPackage ../development/python-modules/pytest-annotate { };

  pytest-ansible = callPackage ../development/python-modules/pytest-ansible { };

  pytest-archon = callPackage ../development/python-modules/pytest-archon { };

  pytest-arraydiff = callPackage ../development/python-modules/pytest-arraydiff { };

  pytest-astropy = callPackage ../development/python-modules/pytest-astropy { };

  pytest-astropy-header = callPackage ../development/python-modules/pytest-astropy-header { };

  pytest-asyncio = callPackage ../development/python-modules/pytest-asyncio { };

  pytest-asyncio-cooperative =
    callPackage ../development/python-modules/pytest-asyncio-cooperative
      { };

  pytest-asyncio_0 = callPackage ../development/python-modules/pytest-asyncio/0.nix { };

  pytest-base-url = callPackage ../development/python-modules/pytest-base-url { };

  pytest-bdd = callPackage ../development/python-modules/pytest-bdd { };

  pytest-benchmark = callPackage ../development/python-modules/pytest-benchmark { };

  pytest-black = callPackage ../development/python-modules/pytest-black { };

  pytest-cache = self.pytestcache; # added 2021-01-04

  pytest-cases = callPackage ../development/python-modules/pytest-cases { };

  pytest-catchlog = callPackage ../development/python-modules/pytest-catchlog { };

  pytest-celery = callPackage ../development/python-modules/pytest-celery { };

  pytest-check = callPackage ../development/python-modules/pytest-check { };

  pytest-cid = callPackage ../development/python-modules/pytest-cid { };

  pytest-click = callPackage ../development/python-modules/pytest-click { };

  pytest-codspeed = callPackage ../development/python-modules/pytest-codspeed { };

  pytest-console-scripts = callPackage ../development/python-modules/pytest-console-scripts { };

  pytest-cov = callPackage ../development/python-modules/pytest-cov { };

  pytest-cov-stub = callPackage ../development/python-modules/pytest-cov-stub { };

  pytest-cram = callPackage ../development/python-modules/pytest-cram { };

  pytest-datadir = callPackage ../development/python-modules/pytest-datadir { };

  pytest-datafiles = callPackage ../development/python-modules/pytest-datafiles { };

  pytest-dependency = callPackage ../development/python-modules/pytest-dependency { };

  pytest-describe = callPackage ../development/python-modules/pytest-describe { };

  pytest-django = callPackage ../development/python-modules/pytest-django { };

  pytest-docker = callPackage ../development/python-modules/pytest-docker { };

  pytest-docker-tools = callPackage ../development/python-modules/pytest-docker-tools { };

  pytest-doctestplus = callPackage ../development/python-modules/pytest-doctestplus { };

  pytest-dotenv = callPackage ../development/python-modules/pytest-dotenv { };

  pytest-emoji = callPackage ../development/python-modules/pytest-emoji { };

  pytest-env = callPackage ../development/python-modules/pytest-env { };

  pytest-error-for-skips = callPackage ../development/python-modules/pytest-error-for-skips { };

  pytest-examples = callPackage ../development/python-modules/pytest-examples { };

  pytest-expect = callPackage ../development/python-modules/pytest-expect { };

  pytest-factoryboy = callPackage ../development/python-modules/pytest-factoryboy { };

  pytest-filter-subpackage = callPackage ../development/python-modules/pytest-filter-subpackage { };

  pytest-fixture-config = callPackage ../development/python-modules/pytest-fixture-config { };

  pytest-flake8 = callPackage ../development/python-modules/pytest-flake8 { };

  pytest-flakes = callPackage ../development/python-modules/pytest-flakes { };

  pytest-flask = callPackage ../development/python-modules/pytest-flask { };

  pytest-forked = callPackage ../development/python-modules/pytest-forked { };

  pytest-freezegun = callPackage ../development/python-modules/pytest-freezegun { };

  pytest-freezer = callPackage ../development/python-modules/pytest-freezer { };

  pytest-gitconfig = callPackage ../development/python-modules/pytest-gitconfig { };

  pytest-golden = callPackage ../development/python-modules/pytest-golden { };

  pytest-grpc = callPackage ../development/python-modules/pytest-grpc { };

  pytest-harvest = callPackage ../development/python-modules/pytest-harvest { };

  pytest-helpers-namespace = callPackage ../development/python-modules/pytest-helpers-namespace { };

  pytest-html = callPackage ../development/python-modules/pytest-html { };

  pytest-httpbin = callPackage ../development/python-modules/pytest-httpbin { };

  pytest-httpserver = callPackage ../development/python-modules/pytest-httpserver { };

  pytest-httpx = callPackage ../development/python-modules/pytest-httpx { };

  pytest-icdiff = callPackage ../development/python-modules/pytest-icdiff { };

  pytest-image-diff = callPackage ../development/python-modules/pytest-image-diff { };

  pytest-instafail = callPackage ../development/python-modules/pytest-instafail { };

  pytest-integration = callPackage ../development/python-modules/pytest-integration { };

  pytest-isort = callPackage ../development/python-modules/pytest-isort { };

  pytest-json-report = callPackage ../development/python-modules/pytest-json-report { };

  pytest-jupyter = callPackage ../development/python-modules/pytest-jupyter { };

  pytest-kafka = callPackage ../development/python-modules/pytest-kafka { };

  pytest-lazy-fixture = callPackage ../development/python-modules/pytest-lazy-fixture { };

  pytest-lazy-fixtures = callPackage ../development/python-modules/pytest-lazy-fixtures { };

  pytest-localserver = callPackage ../development/python-modules/pytest-localserver { };

  pytest-logdog = callPackage ../development/python-modules/pytest-logdog { };

  pytest-lsp = callPackage ../development/python-modules/pytest-lsp { };

  pytest-markdown-docs = callPackage ../development/python-modules/pytest-markdown-docs { };

  pytest-md-report = callPackage ../development/python-modules/pytest-md-report { };

  pytest-metadata = callPackage ../development/python-modules/pytest-metadata { };

  pytest-mock = callPackage ../development/python-modules/pytest-mock { };

  pytest-mockito = callPackage ../development/python-modules/pytest-mockito { };

  pytest-mockservers = callPackage ../development/python-modules/pytest-mockservers { };

  pytest-mpi = callPackage ../development/python-modules/pytest-mpi { };

  pytest-mpl = callPackage ../development/python-modules/pytest-mpl { };

  pytest-mypy = callPackage ../development/python-modules/pytest-mypy { };

  pytest-mypy-plugins = callPackage ../development/python-modules/pytest-mypy-plugins { };

  pytest-notebook = callPackage ../development/python-modules/pytest-notebook { };

  pytest-order = callPackage ../development/python-modules/pytest-order { };

  pytest-parallel = callPackage ../development/python-modules/pytest-parallel { };

  pytest-param-files = callPackage ../development/python-modules/pytest-param-files { };

  pytest-playwright = callPackage ../development/python-modules/pytest-playwright { };

  pytest-plt = callPackage ../development/python-modules/pytest-plt { };

  pytest-plus = callPackage ../development/python-modules/pytest-plus { };

  pytest-pook = callPackage ../development/python-modules/pytest-pook { };

  pytest-postgresql = callPackage ../development/python-modules/pytest-postgresql { };

  pytest-pudb = callPackage ../development/python-modules/pytest-pudb { };

  pytest-pycodestyle = callPackage ../development/python-modules/pytest-pycodestyle { };

  pytest-pylint = callPackage ../development/python-modules/pytest-pylint { };

  pytest-pytestrail = callPackage ../development/python-modules/pytest-pytestrail { };

  pytest-qt = callPackage ../development/python-modules/pytest-qt { };

  pytest-quickcheck = callPackage ../development/python-modules/pytest-quickcheck { };

  pytest-raises = callPackage ../development/python-modules/pytest-raises { };

  pytest-raisesregexp = callPackage ../development/python-modules/pytest-raisesregexp { };

  pytest-raisin = callPackage ../development/python-modules/pytest-raisin { };

  pytest-random-order = callPackage ../development/python-modules/pytest-random-order { };

  pytest-randomly = callPackage ../development/python-modules/pytest-randomly { };

  pytest-recording = callPackage ../development/python-modules/pytest-recording { };

  pytest-regressions = callPackage ../development/python-modules/pytest-regressions { };

  pytest-relaxed = callPackage ../development/python-modules/pytest-relaxed { };

  pytest-remotedata = callPackage ../development/python-modules/pytest-remotedata { };

  pytest-repeat = callPackage ../development/python-modules/pytest-repeat { };

  pytest-reraise = callPackage ../development/python-modules/pytest-reraise { };

  pytest-rerunfailures = callPackage ../development/python-modules/pytest-rerunfailures { };

  pytest-resource-path = callPackage ../development/python-modules/pytest-resource-path { };

  pytest-responses = callPackage ../development/python-modules/pytest-responses { };

  pytest-retry = callPackage ../development/python-modules/pytest-retry { };

  pytest-reverse = callPackage ../development/python-modules/pytest-reverse { };

  pytest-ruff = callPackage ../development/python-modules/pytest-ruff { };

  pytest-run-parallel = callPackage ../development/python-modules/pytest-run-parallel { };

  pytest-scim2-server = callPackage ../development/python-modules/pytest-scim2-server { };

  pytest-selenium = callPackage ../development/python-modules/pytest-selenium { };

  pytest-server-fixtures = callPackage ../development/python-modules/pytest-server-fixtures { };

  pytest-services = callPackage ../development/python-modules/pytest-services { };

  pytest-shared-session-scope =
    callPackage ../development/python-modules/pytest-shared-session-scope
      { };

  pytest-shutil = callPackage ../development/python-modules/pytest-shutil { };

  pytest-smtpd = callPackage ../development/python-modules/pytest-smtpd { };

  pytest-snapshot = callPackage ../development/python-modules/pytest-snapshot { };

  pytest-socket = callPackage ../development/python-modules/pytest-socket { };

  pytest-spec = callPackage ../development/python-modules/pytest-spec { };

  pytest-subprocess = callPackage ../development/python-modules/pytest-subprocess { };

  pytest-subtesthack = callPackage ../development/python-modules/pytest-subtesthack { };

  pytest-subtests = callPackage ../development/python-modules/pytest-subtests { };

  pytest-sugar = callPackage ../development/python-modules/pytest-sugar { };

  pytest-tap = callPackage ../development/python-modules/pytest-tap { };

  pytest-test-utils = callPackage ../development/python-modules/pytest-test-utils { };

  pytest-testinfra = callPackage ../development/python-modules/pytest-testinfra { };

  pytest-testmon = callPackage ../development/python-modules/pytest-testmon { };

  pytest-textual-snapshot = callPackage ../development/python-modules/pytest-textual-snapshot { };

  pytest-timeout = callPackage ../development/python-modules/pytest-timeout { };

  pytest-tornado = callPackage ../development/python-modules/pytest-tornado { };

  pytest-tornasync = callPackage ../development/python-modules/pytest-tornasync { };

  pytest-trio = callPackage ../development/python-modules/pytest-trio { };

  pytest-twisted = callPackage ../development/python-modules/pytest-twisted { };

  pytest-unmagic = callPackage ../development/python-modules/pytest-unmagic { };

  pytest-unordered = callPackage ../development/python-modules/pytest-unordered { };

  pytest-variables = callPackage ../development/python-modules/pytest-variables { };

  pytest-vcr = callPackage ../development/python-modules/pytest-vcr { };

  pytest-virtualenv = callPackage ../development/python-modules/pytest-virtualenv { };

  pytest-voluptuous = callPackage ../development/python-modules/pytest-voluptuous { };

  pytest-warnings = callPackage ../development/python-modules/pytest-warnings { };

  pytest-watch = callPackage ../development/python-modules/pytest-watch { };

  pytest-xdist = callPackage ../development/python-modules/pytest-xdist { };

  pytest-xprocess = callPackage ../development/python-modules/pytest-xprocess { };

  pytest-xvfb = callPackage ../development/python-modules/pytest-xvfb { };

  pytest7CheckHook = pytestCheckHook.override { pytest = pytest_7; };

  pytest8_3CheckHook = pytestCheckHook.override { pytest = pytest_8_3; };

  pytest_7 = callPackage ../development/python-modules/pytest/7.nix { };

  pytest_8_3 = callPackage ../development/python-modules/pytest/8_3.nix { };

  pytestcache = callPackage ../development/python-modules/pytestcache { };

  python-homeassistant-analytics =
    callPackage ../development/python-modules/python-homeassistant-analytics
      { };

  python-ldap = callPackage ../development/python-modules/python-ldap {
    inherit (pkgs) openldap cyrus_sasl;
  };

  python-lzo = callPackage ../development/python-modules/python-lzo { inherit (pkgs) lzo; };

  python-mapnik = callPackage ../development/python-modules/python-mapnik rec {
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

  python-memcached = callPackage ../development/python-modules/python-memcached {
    inherit (pkgs) memcached;
  };

  python-pam = callPackage ../development/python-modules/python-pam { inherit (pkgs) pam; };

  python-snap7 = callPackage ../development/python-modules/python-snap7 { inherit (pkgs) snap7; };

  python-snappy = callPackage ../development/python-modules/python-snappy {
    snappy-cpp = pkgs.snappy;
  };

  python-transip = callPackage ../development/python-modules/python-transip { };

  python-unrar = callPackage ../development/python-modules/python-unrar { inherit (pkgs) unrar; };

  python-xapp = callPackage ../development/python-modules/python-xapp {
    inherit (pkgs.buildPackages) meson;
    inherit (pkgs)
      gtk3
      gobject-introspection
      polkit
      xapp
      ;
  };

  python3-sipsimple = callPackage ../development/python-modules/python3-sipsimple { };

  pythonocc-core = toPythonModule (
    callPackage ../development/python-modules/pythonocc-core {
      inherit (pkgs) fontconfig rapidjson;
      inherit (pkgs.xorg)
        libX11
        libXi
        libXmu
        libXext
        ;
    }
  );

  pythran = callPackage ../development/python-modules/pythran { inherit (pkgs.llvmPackages) openmp; };

  pytz = callPackage ../development/python-modules/pytz {
    inherit (pkgs) tzdata;
  };

  pyudev = callPackage ../development/python-modules/pyudev { inherit (pkgs) udev; };

  pyusb = callPackage ../development/python-modules/pyusb { inherit (pkgs) libusb1; };

  pyvips = callPackage ../development/python-modules/pyvips { inherit (pkgs) vips glib; };

  pywbem = callPackage ../development/python-modules/pywbem { inherit (pkgs) libxml2; };

  pywlroots = callPackage ../development/python-modules/pywlroots { wlroots = pkgs.wlroots_0_17; };

  pyzstd = callPackage ../development/python-modules/pyzstd { zstd-c = pkgs.zstd; };

  qdldl = callPackage ../development/python-modules/qdldl { inherit (pkgs) qdldl; };

  qemu = callPackage ../development/python-modules/qemu { qemu = pkgs.qemu; };

  qh3 = callPackage ../development/python-modules/qh3 {
    inherit (pkgs) cmake;
  };

  qrcodegen = callPackage ../development/python-modules/qrcodegen { qrcodegen = pkgs.qrcodegen; };

  qscintilla = self.qscintilla-qt5;

  qscintilla-qt5 = pkgs.libsForQt5.callPackage ../development/python-modules/qscintilla {
    pythonPackages = self;
  };

  qscintilla-qt6 = pkgs.qt6Packages.callPackage ../development/python-modules/qscintilla {
    pythonPackages = self;
  };

  qt6 = pkgs.qt6.override { python3 = self.python; };

  qtile = callPackage ../development/python-modules/qtile { wlroots = pkgs.wlroots_0_19; };

  radicale-infcloud = callPackage ../development/python-modules/radicale-infcloud {
    radicale = pkgs.radicale.override { python3 = python; };
  };

  rapidgzip = callPackage ../development/python-modules/rapidgzip { inherit (pkgs) nasm; };

  rarfile = callPackage ../development/python-modules/rarfile { inherit (pkgs) libarchive; };

  rasterio = callPackage ../development/python-modules/rasterio {
    gdal-cpp = pkgs.gdal;
  };

  ratarmountcore = callPackage ../development/python-modules/ratarmountcore { inherit (pkgs) zstd; };

  rdkit = callPackage ../development/python-modules/rdkit {
    boost = pkgs.boost.override {
      enablePython = true;
      inherit python;
    };
  };

  recoll = toPythonModule (pkgs.recoll.override { python3Packages = self; });

  recursive-pth-loader = toPythonModule (
    callPackage ../development/python-modules/recursive-pth-loader { }
  );

  remctl = callPackage ../development/python-modules/remctl { remctl-c = pkgs.remctl; };

  reno = callPackage ../development/python-modules/reno { };

  repoze-sphinx-autointerface =
    callPackage ../development/python-modules/repoze-sphinx-autointerface
      { };

  requests-http-message-signatures =
    callPackage ../development/python-modules/requests-http-message-signatures
      { };

  rgpio = toPythonModule (
    pkgs.lgpio.override {
      inherit buildPythonPackage;
      pyProject = "PY_RGPIO";
    }
  );

  rivet = toPythonModule (pkgs.rivet.override { python3 = python; });

  robotframework-assertion-engine =
    callPackage ../development/python-modules/robotframework-assertion-engine
      { };

  robotframework-databaselibrary =
    callPackage ../development/python-modules/robotframework-databaselibrary
      { };

  robotframework-pythonlibcore =
    callPackage ../development/python-modules/robotframework-pythonlibcore
      { };

  robotframework-selenium2library =
    callPackage ../development/python-modules/robotframework-selenium2library
      { };

  robotframework-seleniumlibrary =
    callPackage ../development/python-modules/robotframework-seleniumlibrary
      { };

  root = callPackage ../development/python-modules/root {
    inherit (pkgs) root;
  };

  rpm = toPythonModule (pkgs.rpm.override { python3 = self.python; });

  rpy2-rinterface = callPackage ../development/python-modules/rpy2-rinterface {
    inherit (pkgs) zstd;
  };

  rtree = callPackage ../development/python-modules/rtree { inherit (pkgs) libspatialindex; };

  ruff = callPackage ../development/python-modules/ruff { inherit (pkgs) ruff; };

  samplerate = callPackage ../development/python-modules/samplerate { inherit (pkgs) libsamplerate; };

  sane = callPackage ../development/python-modules/sane { inherit (pkgs) sane-backends; };

  sanic = callPackage ../development/python-modules/sanic {
    # Don't pass any `sanic` to avoid dependency loops.  `sanic-testing`
    # has special logic to disable tests when this is the case.
    sanic-testing = self.sanic-testing.override { sanic = null; };
  };

  scapy = callPackage ../development/python-modules/scapy {
    inherit (pkgs) libpcap; # Avoid confusion with python package of the same name
  };

  secp256k1 = callPackage ../development/python-modules/secp256k1 { inherit (pkgs) secp256k1; };

  segyio = callPackage ../development/python-modules/segyio { inherit (pkgs) cmake ninja; };

  semgrep = callPackage ../development/python-modules/semgrep {
    semgrep-core = callPackage ../development/python-modules/semgrep/semgrep-core.nix { };
  };

  sentencepiece = callPackage ../development/python-modules/sentencepiece {
    inherit (pkgs) sentencepiece;
  };

  sentry-sdk = callPackage ../development/python-modules/sentry-sdk/default.nix { };

  setuptools-changelog-shortener =
    callPackage ../development/python-modules/setuptools-changelog-shortener
      { };

  setuptools-declarative-requirements =
    callPackage ../development/python-modules/setuptools-declarative-requirements
      { };

  setuptools-dso = callPackage ../development/python-modules/setuptools-dso { };

  setuptools-generate = callPackage ../development/python-modules/setuptools-generate { };

  setuptools-gettext = callPackage ../development/python-modules/setuptools-gettext { };

  setuptools-git = callPackage ../development/python-modules/setuptools-git { };

  setuptools-git-versioning = callPackage ../development/python-modules/setuptools-git-versioning { };

  setuptools-lint = callPackage ../development/python-modules/setuptools-lint { };

  setuptools-odoo = callPackage ../development/python-modules/setuptools-odoo { };

  setuptools-rust = callPackage ../development/python-modules/setuptools-rust { };

  setuptools-scm = callPackage ../development/python-modules/setuptools-scm { };

  setuptools-scm-git-archive =
    callPackage ../development/python-modules/setuptools-scm-git-archive
      { };

  setuptools-trial = callPackage ../development/python-modules/setuptools-trial { };

  shiboken2 = toPythonModule (
    callPackage ../development/python-modules/shiboken2 { inherit (pkgs) cmake llvmPackages qt5; }
  );

  shiboken6 = toPythonModule (
    callPackage ../development/python-modules/shiboken6 { inherit (pkgs) cmake llvmPackages; }
  );

  simple-dftd3 = callPackage ../development/libraries/science/chemistry/simple-dftd3/python.nix {
    inherit (pkgs) simple-dftd3;
  };

  simpleitk = callPackage ../development/python-modules/simpleitk { inherit (pkgs) itk simpleitk; };

  sip = callPackage ../development/python-modules/sip { };

  sip4 = callPackage ../development/python-modules/sip/4.x.nix { };

  siphash24 = callPackage ../development/python-modules/siphash24 { };

  siphashc = callPackage ../development/python-modules/siphashc { };

  sipyco = callPackage ../development/python-modules/sipyco { };

  sirius = toPythonModule (
    pkgs.sirius.override {
      enablePython = true;
      pythonPackages = self;
    }
  );

  skytemple-ssb-emulator = callPackage ../development/python-modules/skytemple-ssb-emulator {
    inherit (pkgs) libpcap;
  };

  sleekxmpp = callPackage ../development/python-modules/sleekxmpp { };

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

  slixmpp = callPackage ../development/python-modules/slixmpp { inherit (pkgs) gnupg; };

  snack = toPythonModule (pkgs.newt.override { python3 = self.python; });

  snakemake = toPythonModule (pkgs.snakemake.override { python3Packages = self; });

  snakemake-executor-plugin-cluster-generic =
    callPackage ../development/python-modules/snakemake-executor-plugin-cluster-generic
      { };

  snakemake-interface-common =
    callPackage ../development/python-modules/snakemake-interface-common
      { };

  snakemake-interface-executor-plugins =
    callPackage ../development/python-modules/snakemake-interface-executor-plugins
      { };

  snakemake-interface-logger-plugins =
    callPackage ../development/python-modules/snakemake-interface-logger-plugins
      { };

  snakemake-interface-report-plugins =
    callPackage ../development/python-modules/snakemake-interface-report-plugins
      { };

  snakemake-interface-scheduler-plugins =
    callPackage ../development/python-modules/snakemake-interface-scheduler-plugins
      { };

  snakemake-interface-storage-plugins =
    callPackage ../development/python-modules/snakemake-interface-storage-plugins
      { };

  snakemake-storage-plugin-fs =
    callPackage ../development/python-modules/snakemake-storage-plugin-fs
      { };

  snakemake-storage-plugin-s3 =
    callPackage ../development/python-modules/snakemake-storage-plugin-s3
      { };

  snakemake-storage-plugin-xrootd =
    callPackage ../development/python-modules/snakemake-storage-plugin-xrootd
      { };

  snowflake-connector-python =
    callPackage ../development/python-modules/snowflake-connector-python
      { };

  snowflake-sqlalchemy = callPackage ../development/python-modules/snowflake-sqlalchemy { };

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

  socksipy-branch = callPackage ../development/python-modules/socksipy-branch { };

  soxr = callPackage ../development/python-modules/soxr { libsoxr = pkgs.soxr; };

  spacy = callPackage ../development/python-modules/spacy { };

  spacy-alignments = callPackage ../development/python-modules/spacy-alignments { };

  spacy-curated-transformers =
    callPackage ../development/python-modules/spacy-curated-transformers
      { };

  spacy-legacy = callPackage ../development/python-modules/spacy/legacy.nix { };

  spacy-loggers = callPackage ../development/python-modules/spacy-loggers { };

  spacy-lookups-data = callPackage ../development/python-modules/spacy/lookups-data.nix { };

  spacy-models = callPackage ../development/python-modules/spacy/models.nix { inherit (pkgs) jq; };

  spacy-pkuseg = callPackage ../development/python-modules/spacy-pkuseg { };

  spacy-transformers = callPackage ../development/python-modules/spacy-transformers { };

  sphinx-automodapi = callPackage ../development/python-modules/sphinx-automodapi {
    graphviz = pkgs.graphviz;
  };

  sphinx-last-updated-by-git =
    callPackage ../development/python-modules/sphinx-last-updated-by-git
      { };

  sphinx-pytest = callPackage ../development/python-modules/sphinx-pytest { };

  sphinxcontrib-confluencebuilder =
    callPackage ../development/python-modules/sphinxcontrib-confluencebuilder
      { };

  sphinxcontrib-moderncmakedomain =
    callPackage ../development/python-modules/sphinxcontrib-moderncmakedomain
      { };

  sphinxcontrib-mscgen = callPackage ../development/python-modules/sphinxcontrib-mscgen {
    inherit (pkgs) mscgen;
  };

  sphinxcontrib-plantuml = callPackage ../development/python-modules/sphinxcontrib-plantuml {
    inherit (pkgs) plantuml;
  };

  sphinxcontrib-programoutput =
    callPackage ../development/python-modules/sphinxcontrib-programoutput
      { };

  sphinxcontrib-serializinghtml =
    callPackage ../development/python-modules/sphinxcontrib-serializinghtml
      { };

  sphinxcontrib-svg2pdfconverter =
    callPackage ../development/python-modules/sphinxcontrib-svg2pdfconverter
      { };

  sqlalchemy = callPackage ../development/python-modules/sqlalchemy { };

  sqlalchemy-citext = callPackage ../development/python-modules/sqlalchemy-citext { };

  sqlalchemy-cockroachdb = callPackage ../development/python-modules/sqlalchemy-cockroachdb { };

  sqlalchemy-continuum = callPackage ../development/python-modules/sqlalchemy-continuum { };

  sqlalchemy-file = callPackage ../development/python-modules/sqlalchemy-file { };

  sqlalchemy-i18n = callPackage ../development/python-modules/sqlalchemy-i18n { };

  sqlalchemy-json = callPackage ../development/python-modules/sqlalchemy-json { };

  sqlalchemy-jsonfield = callPackage ../development/python-modules/sqlalchemy-jsonfield { };

  sqlalchemy-mixins = callPackage ../development/python-modules/sqlalchemy-mixins { };

  sqlalchemy-utc = callPackage ../development/python-modules/sqlalchemy-utc { };

  sqlalchemy-utils = callPackage ../development/python-modules/sqlalchemy-utils { };

  sqlalchemy_1_4 = callPackage ../development/python-modules/sqlalchemy/1_4.nix { };

  sqlite-vec = callPackage ../development/python-modules/sqlite-vec {
    sqlite-vec-c = pkgs.sqlite-vec;
  };

  ssdeep = callPackage ../development/python-modules/ssdeep { inherit (pkgs) ssdeep; };

  standard-aifc =
    if pythonAtLeast "3.13" then callPackage ../development/python-modules/standard-aifc { } else null;

  standard-cgi =
    if pythonAtLeast "3.13" then callPackage ../development/python-modules/standard-cgi { } else null;

  standard-chunk =
    if pythonAtLeast "3.13" then callPackage ../development/python-modules/standard-chunk { } else null;

  standard-imghdr =
    if pythonAtLeast "3.13" then
      callPackage ../development/python-modules/standard-imghdr { }
    else
      null;

  standard-mailcap =
    if pythonOlder "3.13" then null else callPackage ../development/python-modules/standard-mailcap { };

  standard-nntplib =
    if pythonOlder "3.13" then null else callPackage ../development/python-modules/standard-nntplib { };

  standard-pipes =
    if pythonAtLeast "3.13" then callPackage ../development/python-modules/standard-pipes { } else null;

  standard-sndhdr =
    if pythonAtLeast "3.13" then
      callPackage ../development/python-modules/standard-sndhdr { }
    else
      null;

  standard-sunau =
    if pythonAtLeast "3.13" then callPackage ../development/python-modules/standard-sunau { } else null;

  standard-telnetlib =
    if pythonAtLeast "3.13" then
      callPackage ../development/python-modules/standard-telnetlib { }
    else
      null;

  stp = toPythonModule (pkgs.stp.override { python3 = self.python; });

  streamcontroller-plugin-tools =
    callPackage ../development/python-modules/streamcontroller-plugin-tools
      { };

  streamcontroller-streamdeck =
    callPackage ../development/python-modules/streamcontroller-streamdeck
      { };

  subunit = callPackage ../development/python-modules/subunit {
    inherit (pkgs) subunit cppunit check;
  };

  sudachidict-core = callPackage ../development/python-modules/sudachidict { };

  sudachidict-full = callPackage ../development/python-modules/sudachidict {
    sudachidict = pkgs.sudachidict.override { dict-type = "full"; };
  };

  sudachidict-small = callPackage ../development/python-modules/sudachidict {
    sudachidict = pkgs.sudachidict.override { dict-type = "small"; };
  };

  supabase-functions = self.supafunc;

  symengine = callPackage ../development/python-modules/symengine { inherit (pkgs) symengine; };

  syndication-domination = toPythonModule (
    pkgs.syndication-domination.override {
      enablePython = true;
      python3Packages = self;
    }
  );

  systemd-python = callPackage ../development/python-modules/systemd-python {
    inherit (pkgs) systemd;
  };

  taco = toPythonModule (
    pkgs.taco.override {
      inherit (self) python;
      enablePython = true;
    }
  );

  tblite = callPackage ../development/libraries/science/chemistry/tblite/python.nix {
    inherit (pkgs)
      tblite
      meson
      simple-dftd3
      dftd4
      ;
  };

  telethon = callPackage ../development/python-modules/telethon { inherit (pkgs) openssl; };

  telethon-session-sqlalchemy =
    callPackage ../development/python-modules/telethon-session-sqlalchemy
      { };

  tensorboard-plugin-profile =
    callPackage ../development/python-modules/tensorboard-plugin-profile
      { };

  tensorflow = self.tensorflow-bin;

  tensorflow-bin = callPackage ../development/python-modules/tensorflow/bin.nix {
    inherit (pkgs.config) cudaSupport;
  };

  tensorflow-build =
    let
      compat = rec {
        #protobufTF = pkgs.protobuf_21.override { abseil-cpp = pkgs.abseil-cpp_202301; };
        protobufTF = pkgs.protobuf;
        # https://www.tensorflow.org/install/source#gpu
        #cudaPackagesTF = pkgs.cudaPackages_11;
        cudaPackagesTF = pkgs.cudaPackages;
        grpcTF =
          (pkgs.grpc.overrideAttrs (oldAttrs: rec {
            # nvcc fails on recent grpc versions, so we use the latest patch level
            #  of the grpc version bundled by upstream tensorflow to allow CUDA
            #  support
            version = "1.27.3";
            src = pkgs.fetchFromGitHub {
              owner = "grpc";
              repo = "grpc";
              rev = "v${version}";
              hash = "sha256-PpiOT4ZJe1uMp5j+ReQulC9jpT0xoR2sAl6vRYKA0AA=";
              fetchSubmodules = true;
            };
            patches = [ ];
            postPatch = ''
              sed -i "s/-std=c++11/-std=c++17/" CMakeLists.txt
              echo "set(CMAKE_CXX_STANDARD 17)" >> CMakeLists.txt
            '';
          })).override
            { protobuf = protobufTF; };
        protobuf-pythonTF = self.protobuf4.override { protobuf = protobufTF; };
        grpcioTF = self.grpcio.override { protobuf = protobufTF; };
        tensorboardTF = self.tensorboard.override {
          grpcio = grpcioTF;
          protobuf = protobuf-pythonTF;
        };
      };
    in
    callPackage ../development/python-modules/tensorflow {
      inherit (pkgs.config) cudaSupport;
      flatbuffers-core = pkgs.flatbuffers;
      flatbuffers-python = self.flatbuffers;
      cudaPackages = compat.cudaPackagesTF;
      protobuf-core = compat.protobufTF;
      protobuf-python = compat.protobuf-pythonTF;
      grpc = compat.grpcTF;
      grpcio = compat.grpcioTF;
      tensorboard = compat.tensorboardTF;
      #abseil-cpp = pkgs.abseil-cpp_202301;
      snappy-cpp = pkgs.snappy;

      # Tensorflow 2.13 doesn't support gcc13:
      # https://github.com/tensorflow/tensorflow/issues/61289
      #
      # We use the nixpkgs' default libstdc++ to stay compatible with other
      # python modules
      #stdenv = pkgs.stdenvAdapters.useLibsFrom stdenv pkgs.gcc12Stdenv;
    };

  tensorflow-estimator-bin =
    callPackage ../development/python-modules/tensorflow-estimator/bin.nix
      { };

  tensorflowWithCuda = self.tensorflow.override { cudaSupport = true; };

  tensorflowWithoutCuda = self.tensorflow.override { cudaSupport = false; };

  textnets = callPackage ../development/python-modules/textnets {
    en_core_web_sm = spacy-models.en_core_web_sm;
  };

  textual-universal-directorytree =
    callPackage ../development/python-modules/textual-universal-directorytree
      { };

  tiledb = callPackage ../development/python-modules/tiledb { inherit (pkgs) tiledb; };

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
      callPackage ../development/python-modules/tkinter {
        # Tcl/Tk 9.0 support in Tkinter is not quite ready yet:
        # - https://github.com/python/cpython/issues/124111
        # - https://github.com/python/cpython/issues/104568
        tcl = pkgs.tcl-8_6;
        tk = pkgs.tk-8_6;
      };

  torch = callPackage ../development/python-modules/torch/source { };

  torch-bin = callPackage ../development/python-modules/torch/bin { triton = self.triton-bin; };

  # Required to test triton
  torch-no-triton = self.torch.override { tritonSupport = false; };

  torch-tb-profiler = callPackage ../development/python-modules/torch-tb-profiler/default.nix { };

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

  torchaudio = callPackage ../development/python-modules/torchaudio { };

  torchaudio-bin = callPackage ../development/python-modules/torchaudio/bin.nix { };

  torchvision = callPackage ../development/python-modules/torchvision { };

  torchvision-bin = callPackage ../development/python-modules/torchvision/bin.nix { };

  towncrier = callPackage ../development/python-modules/towncrier { inherit (pkgs) git; };

  tree-sitter-embedded-template =
    callPackage ../development/python-modules/tree-sitter-embedded-template
      { };

  tree-sitter-grammars = lib.recurseIntoAttrs (
    lib.mapAttrs
      (
        name: grammarDrv:
        callPackage ../development/python-modules/tree-sitter-grammars { inherit name grammarDrv; }
      )
      (
        # Filtering grammars not compatible with current py-tree-sitter version
        lib.filterAttrs (
          name: value:
          !(builtins.elem name [
            "tree-sitter-go-template"
            "tree-sitter-sql"
            "tree-sitter-templ"
          ])
        ) pkgs.tree-sitter.builtGrammars
      )
  );

  trezor-agent = callPackage ../development/python-modules/trezor-agent {
    pinentry = pkgs.pinentry-curses;
  };

  triton = callPackage ../development/python-modules/triton { llvm = pkgs.triton-llvm; };

  triton-bin = callPackage ../development/python-modules/triton/bin.nix { };

  triton-cuda = self.triton.override { cudaSupport = true; };

  triton-no-cuda = self.triton.override { cudaSupport = false; };

  trlib = toPythonModule (
    pkgs.trlib.override {
      pythonSupport = true;
      python3Packages = self;
    }
  );

  tsid = callPackage ../development/python-modules/tsid { inherit (pkgs) tsid; };

  txtai = callPackage ../development/python-modules/txtai { sqlite-vec-c = pkgs.sqlite-vec; };

  typecode = callPackage ../development/python-modules/typecode { };

  typecode-libmagic = callPackage ../development/python-modules/typecode/libmagic.nix {
    inherit (pkgs) file zlib;
  };

  inherit (callPackage ../development/python-modules/types-aiobotocore-packages { })
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

  types-setuptools = callPackage ../development/python-modules/types-setuptools { };

  typesense = callPackage ../development/python-modules/typesense {
    inherit (pkgs) typesense curl;
  };

  typing = null;

  ueberzug = callPackage ../development/python-modules/ueberzug {
    inherit (pkgs.xorg) libX11 libXext;
  };

  unicorn = callPackage ../development/python-modules/unicorn { inherit (pkgs) unicorn; };

  unicorn-angr = callPackage ../development/python-modules/unicorn-angr {
    inherit (pkgs) unicorn-angr;
  };

  units-llnl = callPackage ../development/python-modules/units-llnl {
    inherit (pkgs) units-llnl;
  };

  usbrelay-py = callPackage ../os-specific/linux/usbrelay/python.nix { };

  uv = callPackage ../development/python-modules/uv { inherit (pkgs) uv; };

  vacuum-map-parser-roborock =
    callPackage ../development/python-modules/vacuum-map-parser-roborock
      { };

  vapoursynth = callPackage ../development/python-modules/vapoursynth { inherit (pkgs) vapoursynth; };

  viennarna = toPythonModule (pkgs.viennarna.override { python3 = self.python; });

  vina = callPackage ../applications/science/chemistry/autodock-vina/python-bindings.nix { };

  vivisect = callPackage ../development/python-modules/vivisect {
    inherit (pkgs.libsForQt5) wrapQtAppsHook;
  };

  vl-convert-python = callPackage ../development/python-modules/vl-convert-python {
    inherit (pkgs) protobuf;
  };

  vtk = toPythonModule (
    pkgs.vtk.override {
      pythonSupport = true;
      python3Packages = self;
    }
  );

  vyper = callPackage ../development/compilers/vyper { };

  warp-lang = callPackage ../development/python-modules/warp-lang {
    stdenv = if stdenv.hostPlatform.isDarwin then pkgs.llvmPackages_19.stdenv else pkgs.stdenv;
    llvmPackages = pkgs.llvmPackages_19;
  };

  inherit (self.wasmerPackages)
    wasmer
    wasmer-compiler-cranelift
    wasmer-compiler-llvm
    wasmer-compiler-singlepass
    ;

  wasmerPackages = lib.recurseIntoAttrs (callPackage ../development/python-modules/wasmer { });

  whisperx = callPackage ../development/python-modules/whisperx {
    inherit (pkgs) ffmpeg;
    ctranslate2-cpp = pkgs.ctranslate2;
  };

  wtforms-sqlalchemy = callPackage ../development/python-modules/wtforms-sqlalchemy { };

  wxpython = callPackage ../development/python-modules/wxpython/4.2.nix {
    wxGTK = pkgs.wxGTK32.override { withWebKit = true; };
  };

  xapian = callPackage ../development/python-modules/xapian { inherit (pkgs) xapian; };

  xdot = callPackage ../development/python-modules/xdot { inherit (pkgs) graphviz; };

  xeddsa = toPythonModule (callPackage ../development/python-modules/xeddsa { });

  xen = toPythonModule (pkgs.xen.override { python3Packages = self; });

  xformers = callPackage ../development/python-modules/xformers {
    inherit (pkgs.llvmPackages) openmp;
  };

  xgboost = callPackage ../development/python-modules/xgboost { inherit (pkgs) xgboost; };

  xmlsec = callPackage ../development/python-modules/xmlsec {
    inherit (pkgs)
      libxslt
      libxml2
      libtool
      pkg-config
      xmlsec
      ;
  };

  xonsh = callPackage ../by-name/xo/xonsh/unwrapped.nix { };

  xrootd = callPackage ../development/python-modules/xrootd { inherit (pkgs) xrootd; };

  xsdata-pydantic = callPackage ../development/python-modules/xsdata-pydantic { };

  xstatic-jquery-file-upload =
    callPackage ../development/python-modules/xstatic-jquery-file-upload
      { };

  yoda = toPythonModule (pkgs.yoda.override { python3 = python; });

  yosys = toPythonModule (pkgs.yosys.override { python3 = python; });

  youtube-dl = callPackage ../tools/misc/youtube-dl { };

  youtube-dl-light = callPackage ../tools/misc/youtube-dl { ffmpegSupport = false; };

  yq = callPackage ../development/python-modules/yq { inherit (pkgs) jq; };

  yt-dlp = toPythonModule (pkgs.yt-dlp.override { python3Packages = self; });

  yt-dlp-light = toPythonModule (pkgs.yt-dlp-light.override { python3Packages = self; });

  z3-solver = (toPythonModule (pkgs.z3.override { python3Packages = self; })).python;

  zcbor = callPackage ../development/python-modules/zcbor { };

  zeek = (toPythonModule (pkgs.zeek.broker.override { python3 = python; })).py;

  zeitgeist = (toPythonModule (pkgs.zeitgeist.override { python3 = python; })).py;

  zimports = callPackage ../development/python-modules/zimports { };

  zlib-ng = callPackage ../development/python-modules/zlib-ng { inherit (pkgs) zlib-ng; };

  zopfli = callPackage ../development/python-modules/zopfli { inherit (pkgs) zopfli; };

  zstd = callPackage ../development/python-modules/zstd { inherit (pkgs) zstd; };

  zxing-cpp = callPackage ../development/python-modules/zxing-cpp { libzxing-cpp = pkgs.zxing-cpp; };

  # keep-sorted end
}
