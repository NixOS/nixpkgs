# This file contains the Python packages set.
# Each attribute is a Python library or a helper function.
# Expressions for Python libraries are supposed to be in `pkgs/development/python-modules/<name>/default.nix`.
# Python packages that do not need to be available for each interpreter version do not belong in this packages set.
# Examples are Python-based cli tools.
#
# For more details, please see the Python section in the Nixpkgs manual.

{ pkgs
, stdenv
, python
, overrides ? (self: super: {})
}:

with pkgs.lib;

let
  packages = ( self:

let
  pythonAtLeast = versionAtLeast python.pythonVersion;
  pythonOlder = versionOlder python.pythonVersion;
  isPy26 = python.pythonVersion == "2.6";
  isPy27 = python.pythonVersion == "2.7";
  isPy33 = python.pythonVersion == "3.3";
  isPy34 = python.pythonVersion == "3.4";
  isPy35 = python.pythonVersion == "3.5";
  isPy36 = python.pythonVersion == "3.6";
  isPyPy = python.executable == "pypy";
  isPy3k = strings.substring 0 1 python.pythonVersion == "3";

  callPackage = pkgs.newScope self;

  bootstrapped-pip = callPackage ../development/python-modules/bootstrapped-pip { };

  mkPythonDerivation = makeOverridable( callPackage ../development/interpreters/python/mk-python-derivation.nix {
  });

  # Derivations built with `buildPythonPackage` can already be overriden with `override`, `overrideAttrs`, and `overrideDerivation`.
  # This function introduces `overridePythonAttrs` and it overrides the call to `buildPythonPackage`.
  makeOverridablePythonPackage = f: origArgs:
    let
      ff = f origArgs;
      overrideWith = newArgs: origArgs // (if builtins.isFunction newArgs then newArgs origArgs else newArgs);
    in
      if builtins.isAttrs ff then (ff // {
        overridePythonAttrs = newArgs: makeOverridable f (overrideWith newArgs);
      })
      else if builtins.isFunction ff then {
        overridePythonAttrs = newArgs: makeOverridable f (overrideWith newArgs);
        __functor = self: ff;
      }
      else ff;

  buildPythonPackage = makeOverridablePythonPackage (callPackage ../development/interpreters/python/build-python-package.nix {
    inherit mkPythonDerivation;
    inherit bootstrapped-pip;
    flit = self.flit;
  });

  buildPythonApplication = args: buildPythonPackage ({namePrefix="";} // args );

  graphiteVersion = "1.0.2";

  fetchPypi = makeOverridable( {format ? "setuptools", ... } @attrs:
    let
      fetchWheel = {pname, version, sha256, python ? "py2.py3", abi ? "none", platform ? "any"}:
      # Fetch a wheel. By default we fetch an universal wheel.
      # See https://www.python.org/dev/peps/pep-0427/#file-name-convention for details regarding the optional arguments.
        let
          url = "https://files.pythonhosted.org/packages/${python}/${builtins.substring 0 1 pname}/${pname}/${pname}-${version}-${python}-${abi}-${platform}.whl";
        in pkgs.fetchurl {inherit url sha256;};
      fetchSource = {pname, version, sha256, extension ? "tar.gz"}:
      # Fetch a source tarball.
        let
          url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${pname}-${version}.${extension}";
        in pkgs.fetchurl {inherit url sha256;};
      fetcher = (if format == "wheel" then fetchWheel
        else if format == "setuptools" then fetchSource
        else throw "Unsupported kind ${kind}");
    in fetcher (builtins.removeAttrs attrs ["format"]) );

in {

  inherit python bootstrapped-pip pythonAtLeast pythonOlder isPy26 isPy27 isPy33 isPy34 isPy35 isPy36 isPyPy isPy3k mkPythonDerivation buildPythonPackage buildPythonApplication;
  inherit fetchPypi callPackage;

  # helpers

  wrapPython = callPackage ../development/interpreters/python/wrap-python.nix {inherit python; inherit (pkgs) makeSetupHook makeWrapper; };

  # specials

  recursivePthLoader = callPackage ../development/python-modules/recursive-pth-loader { };

  setuptools = callPackage ../development/python-modules/setuptools { };

  vowpalwabbit = callPackage ../development/python-modules/vowpalwabbit {
    pythonPackages = self;
    boost = pkgs.boost160;
  };

  acoustics = callPackage ../development/python-modules/acoustics { };

  py3to2 = callPackage ../development/python-modules/3to2 { };
  # Left for backwards compatibility
  "3to2" = self.py3to2;

  absl-py = callPackage ../development/python-modules/absl-py { };

  aenum = callPackage ../development/python-modules/aenum { };

  affinity = callPackage ../development/python-modules/affinity { };

  agate = callPackage ../development/python-modules/agate { };

  agate-dbf = callPackage ../development/python-modules/agate-dbf { };

  phonenumbers = callPackage ../development/python-modules/phonenumbers { };

  agate-excel = callPackage ../development/python-modules/agate-excel { };

  agate-sql = callPackage ../development/python-modules/agate-sql { };

  aioamqp = callPackage ../development/python-modules/aioamqp { };

  ansicolor = callPackage ../development/python-modules/ansicolor { };

  asana = callPackage ../development/python-modules/asana { };

  asn1crypto = callPackage ../development/python-modules/asn1crypto { };

  astropy = callPackage ../development/python-modules/astropy {  };

  augeas = callPackage ../development/python-modules/augeas {
    inherit (pkgs) augeas;
  };

  automat = callPackage ../development/python-modules/automat { };

  # packages defined elsewhere

  backports_csv = callPackage ../development/python-modules/backports_csv {};

  bap = callPackage ../development/python-modules/bap {
    bap = pkgs.ocamlPackages_4_02.bap;
  };

  bayespy = callPackage ../development/python-modules/bayespy { };

  bitcoin-price-api = callPackage ../development/python-modules/bitcoin-price-api { };

  blivet = callPackage ../development/python-modules/blivet { };

  breathe = callPackage ../development/python-modules/breathe { };

  browsermob-proxy = if ! isPy3k then
    callPackage ../development/python-modules/browsermob-proxy {}
  else throw "browsermob-proxy is not supported for ${python.executable}";

  bugseverywhere = callPackage ../applications/version-management/bugseverywhere {};

  dbf = callPackage ../development/python-modules/dbf { };

  dbfread = callPackage ../development/python-modules/dbfread { };

  dkimpy = callPackage ../development/python-modules/dkimpy { };

  emcee = callPackage ../development/python-modules/emcee { };

  email_validator = callPackage ../development/python-modules/email-validator { };

  dbus-python = callPackage ../development/python-modules/dbus {
    dbus = pkgs.dbus;
  };

  discid = callPackage ../development/python-modules/discid { };

  discordpy = callPackage ../development/python-modules/discordpy { };

  distorm3 = callPackage ../development/python-modules/distorm3 { };

  diff-match-patch = callPackage ../development/python-modules/diff-match-patch { };

  h5py = callPackage ../development/python-modules/h5py {
    hdf5 = pkgs.hdf5;
  };

  h5py-mpi = self.h5py.override {
    hdf5 = pkgs.hdf5-mpi;
  };

  intelhex = callPackage ../development/python-modules/intelhex { };

  mpi4py = callPackage ../development/python-modules/mpi4py {
    mpi = pkgs.openmpi;
  };

  neuron = pkgs.neuron.override {
    inherit python;
  };

  neuron-mpi = pkgs.neuron-mpi.override {
    inherit python;
  };

  nixpart = callPackage ../tools/filesystems/nixpart { };

  # This is used for NixOps to make sure we won't break it with the next major
  # version of nixpart.
  nixpart0 = callPackage ../tools/filesystems/nixpart/0.4 { };

  nltk = callPackage ../development/python-modules/nltk { };

  ntlm-auth = callPackage ../development/python-modules/ntlm-auth { };

  plantuml = callPackage ../tools/misc/plantuml { };

  Pmw = callPackage ../development/python-modules/Pmw { };

  pyaes = callPackage ../development/python-modules/pyaes { };

  pyamf = callPackage ../development/python-modules/pyamf { };

  pyatspi = if isPy3k then callPackage ../development/python-modules/pyatspi { } else throw "pyatspi not supported for interpreter ${python.executable}";

  pycairo = callPackage ../development/python-modules/pycairo { };

  pycangjie = if isPy3k then callPackage ../development/python-modules/pycangjie { } else throw "pycangjie not supported for interpreter ${python.executable}";

  pycrypto = callPackage ../development/python-modules/pycrypto { };

  pycryptodome = callPackage ../development/python-modules/pycryptodome { };

  pycryptodomex = callPackage ../development/python-modules/pycryptodomex { };

  PyChromecast = callPackage ../development/python-modules/pychromecast { };

  pyexiv2 = if (!isPy3k) then callPackage ../development/python-modules/pyexiv2 {} else throw "pyexiv2 not supported for interpreter ${python.executable}";

  py3exiv2 = callPackage ../development/python-modules/py3exiv2 { };

  pygame = callPackage ../development/python-modules/pygame { };

  pygame-git = callPackage ../development/python-modules/pygame/git.nix { };

  pygame_sdl2 = callPackage ../development/python-modules/pygame_sdl2 { };

  pygobject2 = callPackage ../development/python-modules/pygobject { };

  pygobject3 = callPackage ../development/python-modules/pygobject/3.nix { };

  pygtk = callPackage ../development/python-modules/pygtk { libglade = null; };

  pygtksourceview = callPackage ../development/python-modules/pygtksourceview { };

  pyGtkGlade = self.pygtk.override {
    libglade = pkgs.gnome2.libglade;
  };

  pyjwkest = callPackage ../development/python-modules/pyjwkest { };

  pyqt4 = callPackage ../development/python-modules/pyqt/4.x.nix {
    pythonPackages = self;
  };

  pyqt56 = pkgs.libsForQt56.callPackage ../development/python-modules/pyqt/5.x.nix {
    pythonPackages = self;
  };

  pyqt5 = pkgs.libsForQt5.callPackage ../development/python-modules/pyqt/5.x.nix {
    pythonPackages = self;
  };

  pysc2 = callPackage ../development/python-modules/pysc2 { };

  pyscard = callPackage ../development/python-modules/pyscard { inherit (pkgs.darwin.apple_sdk.frameworks) PCSC; };

  pyside = callPackage ../development/python-modules/pyside { };

  pysideShiboken = callPackage ../development/python-modules/pyside/shiboken.nix {
    inherit (pkgs) libxml2 libxslt; # Do not need the Python bindings.
  };

  pysideTools = callPackage ../development/python-modules/pyside/tools.nix { };

  pyslurm = callPackage ../development/python-modules/pyslurm {
    slurm = pkgs.slurm;
  };

  python-sql = callPackage ../development/python-modules/python-sql { };

  python-stdnum = callPackage ../development/python-modules/python-stdnum { };

  python-utils = callPackage ../development/python-modules/python-utils { };

  pytimeparse =  callPackage ../development/python-modules/pytimeparse { };

  PyWebDAV = callPackage ../development/python-modules/pywebdav { };

  pyxml = if !isPy3k then callPackage ../development/python-modules/pyxml{ } else throw "pyxml not supported for interpreter ${python.executable}";

  relatorio = callPackage ../development/python-modules/relatorio { };

  pyzufall = callPackage ../development/python-modules/pyzufall { };

  rhpl = if !isPy3k then callPackage ../development/python-modules/rhpl {} else throw "rhpl not supported for interpreter ${python.executable}";

  simpleeval = callPackage ../development/python-modules/simpleeval { };

  sip = callPackage ../development/python-modules/sip { };

  supervise_api = callPackage ../development/python-modules/supervise_api { };

  tables = callPackage ../development/python-modules/tables {
    hdf5 = pkgs.hdf5.override { zlib = pkgs.zlib; };
  };

  unifi = callPackage ../development/python-modules/unifi { };

  pyunbound = callPackage ../tools/networking/unbound/python.nix { };

  # packages defined here

  aafigure = callPackage ../development/python-modules/aafigure { };

  altair = callPackage ../development/python-modules/altair { };

  vega = callPackage ../development/python-modules/vega { };

  acme = callPackage ../development/python-modules/acme { };

  acme-tiny = callPackage ../development/python-modules/acme-tiny { };

  actdiag = callPackage ../development/python-modules/actdiag { };

  adal = callPackage ../development/python-modules/adal { };

  afew = callPackage ../development/python-modules/afew { };

  aiodns = callPackage ../development/python-modules/aiodns { };

  aiofiles = callPackage ../development/python-modules/aiofiles { };

  aiohttp = callPackage ../development/python-modules/aiohttp { };

  aiohttp-cors = callPackage ../development/python-modules/aiohttp/cors.nix { };

  alabaster = callPackage ../development/python-modules/alabaster {};

  alembic = callPackage ../development/python-modules/alembic {};

  ansicolors = callPackage ../development/python-modules/ansicolors {};

  aniso8601 = callPackage ../development/python-modules/aniso8601 {};

  asgiref = callPackage ../development/python-modules/asgiref { };

  asgi_ipc = callPackage ../development/python-modules/asgi_ipc { };

  asgi_redis = callPackage ../development/python-modules/asgi_redis { };

  python-editor = callPackage ../development/python-modules/python-editor { };

  python-gnupg = callPackage ../development/python-modules/python-gnupg {};

  python-uinput = callPackage ../development/python-modules/python-uinput {};

  python-sybase = callPackage ../development/python-modules/sybase {};

  alot = buildPythonPackage rec {
    rev = "0.5.1";
    name = "alot-${rev}";

    disabled = isPy3k;

    src = pkgs.fetchFromGitHub {
      owner = "pazz";
      repo = "alot";
      inherit rev;
      sha256 = "0ipkhc5wllfq78lg47aiq4qih0yjq8ad9xkrbgc88xk8pk9166i8";
    };

    postPatch = ''
      substituteInPlace alot/defaults/alot.rc.spec \
        --replace "themes_dir = string(default=None)" \
                  "themes_dir = string(default='$out/share/themes')"
    '';

    propagatedBuildInputs =
      [ self.notmuch
        self.urwid
        self.urwidtrees
        self.twisted
        self.python_magic
        self.configobj
        self.pygpgme
        self.mock
      ];

    postInstall = ''
      mkdir -p $out/share
      cp -r extra/themes $out/share
      wrapProgram $out/bin/alot \
        --prefix LD_LIBRARY_PATH : '${pkgs.lib.makeLibraryPath [ pkgs.notmuch pkgs.file pkgs.gpgme ]}'
    '';

    meta = {
      homepage = https://github.com/pazz/alot;
      description = "Terminal MUA using notmuch mail";
      platforms = platforms.linux;
      maintainers = with maintainers; [ garbas profpatsch ];
    };
  };

  anyjson = buildPythonPackage rec {
    name = "anyjson-0.3.3";

    # The tests are written in a python2 syntax but anyjson is python3 valid
    doCheck = !isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/a/anyjson/${name}.tar.gz";
      sha256 = "37812d863c9ad3e35c0734c42e0bf0320ce8c3bed82cd20ad54cb34d158157ba";
    };

    buildInputs = with self; [ self.nose ];

    meta = {
      homepage = https://pypi.python.org/pypi/anyjson/;
      description = "Wrapper that selects the best available JSON implementation";
    };
  };

  amqp_1 = buildPythonPackage rec {
    name = "amqp-${version}";
    version = "1.4.9";
    disabled = pythonOlder "2.6";

    src = pkgs.fetchurl {
      url = "mirror://pypi/a/amqp/${name}.tar.gz";
      sha256 = "06n6q0kxhjnbfz3vn8x9yz09lwmn1xi9d6wxp31h5jbks0b4vsid";
    };

    buildInputs = with self; [ mock coverage nose-cover3 unittest2 ];

    meta = {
      homepage = https://github.com/celery/py-amqp;
      description = "Python client for the Advanced Message Queuing Procotol (AMQP). This is a fork of amqplib which is maintained by the Celery project";
      license = licenses.lgpl21;
    };
  };

  amqp = buildPythonPackage rec {
    name = "amqp-${version}";
    version = "2.1.4";
    disabled = pythonOlder "2.6";

    src = pkgs.fetchurl {
      url = "mirror://pypi/a/amqp/${name}.tar.gz";
      sha256 = "1ybywzkd840v1qvb1p2bs08js260vq1jscjg8182hv7bmwacqy0k";
    };

    buildInputs = with self; [ pytest case ];
    propagatedBuildInputs = with self; [ vine ];

    meta = {
      homepage = https://github.com/celery/py-amqp;
      description = "Python client for the Advanced Message Queuing Procotol (AMQP). This is a fork of amqplib which is maintained by the Celery project";
      license = licenses.lgpl21;
    };
  };


  amqplib = callPackage ../development/python-modules/amqplib {};

  apipkg = callPackage ../development/python-modules/apipkg {};

  appdirs = callPackage ../development/python-modules/appdirs { };

  application = buildPythonPackage rec {
    pname = "python-application";
    name = "${pname}-${version}";
    version = "2.0.2";
    disabled = isPy3k;

    src = pkgs.fetchdarcs {
      url = "http://devel.ag-projects.com/repositories/${pname}";
      rev = "release-${version}";
      sha256 = "19dszv44py8qrq0jcjdycxpa7z2p8hi3ijq9gnqdsazbbjzf9svn";
    };
    buildInputs = with self; [ zope_interface ];

  };

  appnope = buildPythonPackage rec {
    version = "0.1.0";
    name = "appnope-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/a/appnope/${name}.tar.gz";
      sha256 = "8b995ffe925347a2138d7ac0fe77155e4311a0ea6d6da4f5128fe4b3cbe5ed71";
    };

    meta = {
      description = "Disable App Nap on macOS";
      homepage    = https://pypi.python.org/pypi/appnope;
      platforms   = platforms.darwin;
      license     = licenses.bsd3;
    };
  };

  apsw = callPackage ../development/python-modules/apsw {};

  astor = callPackage ../development/python-modules/astor {};

  asyncio = if (pythonAtLeast "3.3") then buildPythonPackage rec {
    name = "asyncio-${version}";
    version = "3.4.3";


    src = pkgs.fetchurl {
      url = "mirror://pypi/a/asyncio/${name}.tar.gz";
      sha256 = "0hfbqwk9y0bbfgxzg93s2wyk6gcjsdxlr5jwy97hx64ppkw0ydl3";
    };

    meta = {
      description = "Reference implementation of PEP 3156";
      homepage = http://www.python.org/dev/peps/pep-3156;
      license = licenses.free;
    };
  } else null;

  python-fontconfig = callPackage ../development/python-modules/python-fontconfig { };

  funcsigs = callPackage ../development/python-modules/funcsigs { };

  APScheduler = callPackage ../development/python-modules/APScheduler { };

  args = callPackage ../development/python-modules/args { };

  argcomplete = callPackage ../development/python-modules/argcomplete { };

  area53 = callPackage ../development/python-modules/area53 { };

  chai = callPackage ../development/python-modules/chai { };

  chainmap = callPackage ../development/python-modules/chainmap { };

  arelle = callPackage ../development/python-modules/arelle {
    gui = true;
  };

  arelle-headless = callPackage ../development/python-modules/arelle {
    gui = false;
  };


  arrow = callPackage ../development/python-modules/arrow { };

  async = buildPythonPackage rec {
    name = "async-0.6.1";
    disabled = isPy3k;
    meta.maintainers = with maintainers; [ mornfall ];

    buildInputs = with self; [ pkgs.zlib ];
    doCheck = false;

    src = pkgs.fetchurl {
      url = "mirror://pypi/a/async/${name}.tar.gz";
      sha256 = "1lfmjm8apy9qpnpbq8g641fd01qxh9jlya5g2d6z60vf8p04rla1";
    };
  };

  async-timeout = callPackage ../development/python-modules/async_timeout { };

  asn1ate = callPackage ../development/python-modules/asn1ate { };

  atomiclong = buildPythonPackage rec {
    version = "0.1.1";
    name = "atomiclong-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/a/atomiclong/atomiclong-${version}.tar.gz";
      sha256 = "1gjbc9lvpkgg8vj7dspif1gz9aq4flkhxia16qj6yvb7rp27h4yb";
    };
    buildInputs = with self; [ pytest ];
    propagatedBuildInputs = with self; [ cffi ];

    meta = {
      description = "Long data type with atomic operations using CFFI";
      homepage = https://github.com/dreid/atomiclong;
      license = licenses.mit;
      maintainers = with maintainers; [ robbinch ];
    };

  };

  atomicwrites = buildPythonPackage rec {
    version = "0.1.9";
    name = "atomicwrites-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/a/atomicwrites/atomicwrites-${version}.tar.gz";
      sha256 = "08s05h211r07vs66r4din3swrbzb344vli041fihpg34q3lcxpvw";
    };

    meta = {
      description = "Atomic file writes on POSIX";
      homepage = https://pypi.python.org/pypi/atomicwrites/0.1.0;
      maintainers = with maintainers; [ matthiasbeyer ];
    };

  };

  # argparse is part of stdlib in 2.7 and 3.2+
  argparse = null;

  astroid = callPackage ../development/python-modules/astroid { };

  attrdict = buildPythonPackage (rec {
    name = "attrdict-2.0.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/a/attrdict/${name}.tar.gz";
      sha256 = "86aeb6d3809e0344409f8148d7cac9eabce5f0b577c160b5e90d10df3f8d2ad3";
    };

    propagatedBuildInputs = with self; [ coverage nose six ];

    meta = {
      description = "A dict with attribute-style access";
      homepage = https://github.com/bcj/AttrDict;
      license = licenses.mit;
    };
  });

  attrs = callPackage ../development/python-modules/attrs { };

  audioread = callPackage ../development/python-modules/audioread { };

  audiotools = buildPythonPackage rec {
    name = "audiotools-${version}";
    version = "3.1.1";

    buildInputs = optionals stdenv.isDarwin (with pkgs.darwin.apple_sdk.frameworks; [
      AudioToolbox
      AudioUnit
      CoreServices
    ]);

    src = pkgs.fetchurl {
      url = "https://github.com/tuffy/python-audio-tools/archive/v${version}.tar.gz";
      sha256 = "0ymlxvqkqhzk4q088qwir3dq0zgwqlrrdfnq7f0iq97g05qshm2c";
    };

    meta = {
      description = "Utilities and Python modules for handling audio";
      homepage = "http://audiotools.sourceforge.net/";
      license = licenses.gpl2Plus;
    };
  };

  autopep8 = callPackage ../development/python-modules/autopep8 { };

  av = buildPythonPackage rec {
    name = "av-${version}";
    version = "0.2.4";

    src = pkgs.fetchurl {
      url = "mirror://pypi/a/av/${name}.tar.gz";
      sha256 = "bdc7e2e213cb9041d9c5c0497e6f8c47e84f89f1f2673a46d891cca0fb0d19a0";
    };

    buildInputs
      =  (with self; [ nose pillow numpy ])
      ++ (with pkgs; [ ffmpeg_2 git libav pkgconfig ]);

    # Because of https://github.com/mikeboers/PyAV/issues/152
    doCheck = false;

    meta = {
      description = "Pythonic bindings for FFmpeg/Libav";
      homepage = https://github.com/mikeboers/PyAV/;
      license = licenses.bsd2;
    };
  };

  avro = buildPythonPackage (rec {
    name = "avro-1.7.6";

    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/a/avro/${name}.tar.gz";
      sha256 = "edf14143cabb2891f05a73d60a57a9fc5a9ebd305c2188abb3f5db777c707ad5";
    };

    meta = {
      description = "A serialization and RPC framework";
      homepage = "https://pypi.python.org/pypi/avro/";
    };
  });

  avro3k = pkgs.lowPrio (buildPythonPackage (rec {
    name = "avro3k-1.7.7-SNAPSHOT";

    disabled = (!isPy3k);

    src = pkgs.fetchurl {
      url = "mirror://pypi/a/avro3k/${name}.tar.gz";
      sha256 = "15ahl0irwwj558s964abdxg4vp6iwlabri7klsm2am6q5r0ngsky";
    };

    doCheck = false;        # No such file or directory: './run_tests.py

    meta = {
      description = "A serialization and RPC framework";
      homepage = "https://pypi.python.org/pypi/avro3k/";
    };
  }));

  python-slugify = callPackage ../development/python-modules/python-slugify { };

  awesome-slugify = callPackage ../development/python-modules/awesome-slugify {};

  noise = buildPythonPackage rec {
    name = "noise-${version}";
    version = "1.2.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/n/noise/${name}.tar.gz";
      sha256 = "0rcv40dcshqpchwkdlhsv3n68h9swm9fh4d1cgzr2hsp6rs7k8jp";
    };

    meta = with stdenv.lib; {
      homepage = "https://github.com/caseman/noise";
      description = "Native-code and shader implementations of Perlin noise";
      license = licenses.mit;
      platforms = platforms.all;
    };
  };

  azure = buildPythonPackage rec {
    version = "0.11.0";
    name = "azure-${version}";
    disabled = pythonOlder "2.7";

    src = pkgs.fetchurl {
      url = "mirror://pypi/a/azure/${name}.zip";
      sha256 = "89c20b2efaaed3c6f56345d55c32a8d4e7d2a16c032d0acb92f8f490c508fe24";
    };

    propagatedBuildInputs = with self; [ dateutil futures pyopenssl requests ];

    meta = {
      description = "Microsoft Azure SDK for Python";
      homepage = "http://azure.microsoft.com/en-us/develop/python/";
      license = licenses.asl20;
      maintainers = with maintainers; [ olcai ];
    };
  };

  azure-nspkg = buildPythonPackage rec {
    version = "1.0.0";
    name = "azure-nspkg-${version}";
    src = pkgs.fetchurl {
      url = mirror://pypi/a/azure-nspkg/azure-nspkg-1.0.0.zip;
      sha256 = "1xqvc8by1lbd7j9dxyly03jz3rgbmnsiqnqgydhkf4pa2mn2hgr9";
    };
    meta = {
      description = "Microsoft Azure SDK for Python";
      homepage = "http://azure.microsoft.com/en-us/develop/python/";
      license = licenses.asl20;
      maintainers = with maintainers; [ olcai ];
    };
  };

  azure-common = buildPythonPackage rec {
    version = "1.0.0";
    name = "azure-common-${version}";
    disabled = isPyPy;
    src = pkgs.fetchurl {
      url = mirror://pypi/a/azure-common/azure-common-1.0.0.zip;
      sha256 = "074rwwy8zzs7zw3nww5q2wg5lxgdc4rmypp2gfc9mwsz0gb70491";
    };
    propagatedBuildInputs = with self; [ azure-nspkg ];
    postInstall = ''
      echo "__import__('pkg_resources').declare_namespace(__name__)" >> "$out/lib/${python.libPrefix}"/site-packages/azure/__init__.py
    '';
    meta = {
      description = "Microsoft Azure SDK for Python";
      homepage = "http://azure.microsoft.com/en-us/develop/python/";
      license = licenses.asl20;
      maintainers = with maintainers; [ olcai ];
    };
  };

  azure-mgmt-common = buildPythonPackage rec {
    version = "0.20.0";
    name = "azure-mgmt-common-${version}";
    src = pkgs.fetchurl {
      url = mirror://pypi/a/azure-mgmt-common/azure-mgmt-common-0.20.0.zip;
      sha256 = "1rmzpz3733wv31rsnqpdy4bbafvk5dhbqx7q0xf62dlz7p0i4f66";
    };
    propagatedBuildInputs = with self; [ azure-common azure-mgmt-nspkg requests ];
    postInstall = ''
      echo "__import__('pkg_resources').declare_namespace(__name__)" >> "$out/lib/${python.libPrefix}"/site-packages/azure/__init__.py
      echo "__import__('pkg_resources').declare_namespace(__name__)" >> "$out/lib/${python.libPrefix}"/site-packages/azure/mgmt/__init__.py
    '';
    meta = {
      description = "Microsoft Azure SDK for Python";
      homepage = "http://azure.microsoft.com/en-us/develop/python/";
      license = licenses.asl20;
      maintainers = with maintainers; [ olcai ];
    };
  };

  azure-mgmt-compute = buildPythonPackage rec {
    version = "0.20.0";
    name = "azure-mgmt-compute-${version}";
    src = pkgs.fetchurl {
      url = mirror://pypi/a/azure-mgmt-compute/azure-mgmt-compute-0.20.0.zip;
      sha256 = "12hr5vxdg2sk2fzr608a37f4i8nbchca7dgdmly2w5fc7x88jx2v";
    };
    preConfigure = ''
      # Patch to make this package work on requests >= 2.11.x
      # CAN BE REMOVED ON NEXT PACKAGE UPDATE
      sed -i 's|len(request_content)|str(len(request_content))|' azure/mgmt/compute/computemanagement.py
    '';
    postInstall = ''
      echo "__import__('pkg_resources').declare_namespace(__name__)" >> "$out/lib/${python.libPrefix}"/site-packages/azure/__init__.py
      echo "__import__('pkg_resources').declare_namespace(__name__)" >> "$out/lib/${python.libPrefix}"/site-packages/azure/mgmt/__init__.py
    '';
    propagatedBuildInputs = with self; [ azure-mgmt-common ];
    meta = {
      description = "Microsoft Azure SDK for Python";
      homepage = "http://azure.microsoft.com/en-us/develop/python/";
      license = licenses.asl20;
      maintainers = with maintainers; [ olcai ];
    };
  };

  azure-mgmt-network = buildPythonPackage rec {
    version = "0.20.1";
    name = "azure-mgmt-network-${version}";
    src = pkgs.fetchurl {
      url = mirror://pypi/a/azure-mgmt-network/azure-mgmt-network-0.20.1.zip;
      sha256 = "10vj22h6nxpw0qpvib5x2g6qs5j8z31142icvh4qk8k40fcrs9hx";
    };
    preConfigure = ''
      # Patch to make this package work on requests >= 2.11.x
      # CAN BE REMOVED ON NEXT PACKAGE UPDATE
      sed -i 's|len(request_content)|str(len(request_content))|' azure/mgmt/network/networkresourceprovider.py
    '';
    postInstall = ''
      echo "__import__('pkg_resources').declare_namespace(__name__)" >> "$out/lib/${python.libPrefix}"/site-packages/azure/__init__.py
      echo "__import__('pkg_resources').declare_namespace(__name__)" >> "$out/lib/${python.libPrefix}"/site-packages/azure/mgmt/__init__.py
    '';
    propagatedBuildInputs = with self; [ azure-mgmt-common ];
    meta = {
      description = "Microsoft Azure SDK for Python";
      homepage = "http://azure.microsoft.com/en-us/develop/python/";
      license = licenses.asl20;
      maintainers = with maintainers; [ olcai ];
    };
  };

  azure-mgmt-nspkg = buildPythonPackage rec {
    version = "1.0.0";
    name = "azure-mgmt-nspkg-${version}";
    src = pkgs.fetchurl {
      url = mirror://pypi/a/azure-mgmt-nspkg/azure-mgmt-nspkg-1.0.0.zip;
      sha256 = "1rq92fj3kvnqkk18596dybw0kvhgscvc6cd8hp1dhy3wrkqnhwmq";
    };
    propagatedBuildInputs = with self; [ azure-nspkg ];
    meta = {
      description = "Microsoft Azure SDK for Python";
      homepage = "http://azure.microsoft.com/en-us/develop/python/";
      license = licenses.asl20;
      maintainers = with maintainers; [ olcai ];
    };
  };

  azure-mgmt-resource = buildPythonPackage rec {
    version = "0.20.1";
    name = "azure-mgmt-resource-${version}";
    src = pkgs.fetchurl {
      url = mirror://pypi/a/azure-mgmt-resource/azure-mgmt-resource-0.20.1.zip;
      sha256 = "0slh9qfm5nfacrdm3lid0sr8kwqzgxvrwf27laf9v38kylkfqvml";
    };
    preConfigure = ''
      # Patch to make this package work on requests >= 2.11.x
      # CAN BE REMOVED ON NEXT PACKAGE UPDATE
      sed -i 's|len(request_content)|str(len(request_content))|' azure/mgmt/resource/resourcemanagement.py
    '';
    postInstall = ''
      echo "__import__('pkg_resources').declare_namespace(__name__)" >> "$out/lib/${python.libPrefix}"/site-packages/azure/__init__.py
      echo "__import__('pkg_resources').declare_namespace(__name__)" >> "$out/lib/${python.libPrefix}"/site-packages/azure/mgmt/__init__.py
    '';
    propagatedBuildInputs = with self; [ azure-mgmt-common ];
    meta = {
      description = "Microsoft Azure SDK for Python";
      homepage = "http://azure.microsoft.com/en-us/develop/python/";
      license = licenses.asl20;
      maintainers = with maintainers; [ olcai ];
    };
  };

  azure-mgmt-storage = buildPythonPackage rec {
    version = "0.20.0";
    name = "azure-mgmt-storage-${version}";
    src = pkgs.fetchurl {
      url = mirror://pypi/a/azure-mgmt-storage/azure-mgmt-storage-0.20.0.zip;
      sha256 = "16iw7hqhq97vlzfwixarfnirc60l5mz951p57brpcwyylphl3yim";
    };
    preConfigure = ''
      # Patch to make this package work on requests >= 2.11.x
      # CAN BE REMOVED ON NEXT PACKAGE UPDATE
      sed -i 's|len(request_content)|str(len(request_content))|' azure/mgmt/storage/storagemanagement.py
    '';
    postInstall = ''
      echo "__import__('pkg_resources').declare_namespace(__name__)" >> "$out/lib/${python.libPrefix}"/site-packages/azure/__init__.py
      echo "__import__('pkg_resources').declare_namespace(__name__)" >> "$out/lib/${python.libPrefix}"/site-packages/azure/mgmt/__init__.py
    '';
    propagatedBuildInputs = with self; [ azure-mgmt-common ];
    meta = {
      description = "Microsoft Azure SDK for Python";
      homepage = "http://azure.microsoft.com/en-us/develop/python/";
      license = licenses.asl20;
      maintainers = with maintainers; [ olcai ];
    };
  };

  azure-storage = buildPythonPackage rec {
    version = "0.20.3";
    name = "azure-storage-${version}";
    src = pkgs.fetchurl {
      url = mirror://pypi/a/azure-storage/azure-storage-0.20.3.zip;
      sha256 = "06bmw6k2000kln5jwk5r9bgcalqbyvqirmdh9gq4s6nb4fv3c0jb";
    };
    propagatedBuildInputs = with self; [ azure-common futures dateutil requests ];
    postInstall = ''
      echo "__import__('pkg_resources').declare_namespace(__name__)" >> "$out/lib/${python.libPrefix}"/site-packages/azure/__init__.py
    '';
    meta = {
      description = "Microsoft Azure SDK for Python";
      homepage = "http://azure.microsoft.com/en-us/develop/python/";
      license = licenses.asl20;
      maintainers = with maintainers; [ olcai ];
    };
  };

  azure-servicemanagement-legacy = buildPythonPackage rec {
    version = "0.20.1";
    name = "azure-servicemanagement-legacy-${version}";
    src = pkgs.fetchurl {
      url = mirror://pypi/a/azure-servicemanagement-legacy/azure-servicemanagement-legacy-0.20.1.zip;
      sha256 = "17dwrp99sx5x9cm4vldkaxhki9gbd6dlafa0lpr2n92xhh2838zs";
    };
    propagatedBuildInputs = with self; [ azure-common requests ];
    postInstall = ''
      echo "__import__('pkg_resources').declare_namespace(__name__)" >> "$out/lib/${python.libPrefix}"/site-packages/azure/__init__.py
    '';
    meta = {
      description = "Microsoft Azure SDK for Python";
      homepage = "http://azure.microsoft.com/en-us/develop/python/";
      license = licenses.asl20;
      maintainers = with maintainers; [ olcai ];
    };
  };

  backports_abc = buildPythonPackage rec {
    name = "backports_abc-${version}";
    version = "0.4";

    src = pkgs.fetchurl {
      url = "mirror://pypi/b/backports_abc/${name}.tar.gz";
      sha256 = "8b3e4092ba3d541c7a2f9b7d0d9c0275b21c6a01c53a61c731eba6686939d0a5";
    };

    checkPhase = ''
      ${python.interpreter} -m unittest discover
    '';

    meta = {
      homepage = https://github.com/cython/backports_abc;
      license = licenses.psfl;
      description = "A backport of recent additions to the 'collections.abc' module";
    };
  };

  backports_functools_lru_cache = buildPythonPackage rec {
    name = "backports.functools_lru_cache-${version}";
    version = "1.3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/b/backports_functools_lru_cache/${name}.tar.gz";
      sha256 = "444a21bcec4ae177da554321f81a78dc879eaa8f6ea9920cb904830585d31e95";
    };

    buildInputs = with self; [ setuptools_scm ];
    doCheck = false; # No proper test

    meta = {
      description = "Backport of functools.lru_cache";
      homepage = https://github.com/jaraco/backports.functools_lru_cache;
      license = licenses.mit;
    };
  };

  backports_shutil_get_terminal_size = if !(pythonOlder "3.3") then null else buildPythonPackage rec {
    name = "backports.shutil_get_terminal_size-${version}";
    version = "1.0.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/b/backports.shutil_get_terminal_size/${name}.tar.gz";
      sha256 = "713e7a8228ae80341c70586d1cc0a8caa5207346927e23d09dcbcaf18eadec80";
    };

    meta = {
      description = "A backport of the get_terminal_size function from Python 3.3’s shutil.";
      homepage = https://github.com/chrippa/backports.shutil_get_terminal_size;
      license = with licenses; [ mit ];
    };
  };

  backports_ssl_match_hostname_3_4_0_2 = self.buildPythonPackage rec {
    name = "backports.ssl_match_hostname-3.4.0.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/b/backports.ssl_match_hostname/backports.ssl_match_hostname-3.4.0.2.tar.gz";
      sha256 = "07410e7fb09aab7bdaf5e618de66c3dac84e2e3d628352814dc4c37de321d6ae";
    };

    meta = {
      description = "The Secure Sockets layer is only actually *secure*";
      homepage = https://bitbucket.org/brandon/backports.ssl_match_hostname;
    };
  };

  backports_ssl_match_hostname = self.buildPythonPackage rec {
    name = "backports.ssl_match_hostname-${version}";
    version = "3.5.0.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/b/backports.ssl_match_hostname/${name}.tar.gz";
      sha256 = "1wndipik52cyqy0677zdgp90i435pmvwd89cz98lm7ri0y3xjajh";
    };

    meta = {
      description = "The Secure Sockets layer is only actually *secure*";
      homepage = https://bitbucket.org/brandon/backports.ssl_match_hostname;
    };
  };

  backports_lzma = self.buildPythonPackage rec {
    name = "backports.lzma-0.0.3";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/b/backports.lzma/${name}.tar.gz";
      sha256 = "bac58aec8d39ac3d22250840fb24830d0e4a0ef05ad8f3f09172dc0cc80cdbca";
    };

    buildInputs = [ pkgs.lzma ];

    meta = {
      describe = "Backport of Python 3.3's 'lzma' module for XZ/LZMA compressed files";
      homepage = https://github.com/peterjc/backports.lzma;
      license = licenses.bsd3;
    };
  };

  backports_tempfile = callPackage ../development/python-modules/backports_tempfile { };

  backports_unittest-mock = callPackage ../development/python-modules/backports_unittest-mock {};

  babelfish = buildPythonPackage rec {
    version = "0.5.5";
    name = "babelfish-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/b/babelfish/${name}.tar.gz";
      sha256 = "8380879fa51164ac54a3e393f83c4551a275f03617f54a99d70151358e444104";
    };

    meta = {
      homepage = https://pypi.python.org/pypi/babelfish;
      description = "A module to work with countries and languages";
      license = licenses.bsd3;
    };
  };

  basiciw = buildPythonPackage rec {
    name = "${pname}-${version}";
    version = "0.2.2";
    pname = "basiciw";
    disabled = isPy26 || isPy27 || isPyPy;

    src = pkgs.fetchurl {
      url = "mirror://pypi/b/${pname}/${name}.tar.gz";
      sha256 = "1ajmflvvlkflrcmqmkrx0zaira84z8kv4ssb2jprfwvjh8vfkysb";
    };

    buildInputs = [ pkgs.gcc ];
    propagatedBuildInputs = [ pkgs.wirelesstools ];

    meta = {
      description = "Get info about wireless interfaces using libiw";
      homepage = https://github.com/enkore/basiciw;
      platforms = platforms.linux;
      license = licenses.gpl2;
    };
  };

  batinfo = buildPythonPackage rec {
    version = "0.3";
    name = "batinfo-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/b/batinfo/${name}.tar.gz";
      sha256 = "0gyzkxzvj5l6qrw706bnm3cckqzzzbrjr7jkxc087d7775a73499";
    };

    # No tests included
    doCheck = false;

    meta = {
      homepage = https://github.com/nicolargo/batinfo;
      description = "A simple Python lib to retrieve battery information";
      license = licenses.lgpl3;
      platforms = platforms.all;
      maintainers = with maintainers; [ koral ];
    };
  };

  bcdoc = buildPythonPackage rec {
    name = "bcdoc-0.14.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/b/bcdoc/${name}.tar.gz";
      sha256 = "1s2kdqs1n2mj7wq3w0pq30zs7vxq0l3abik2clqnc4hm2j7crbk8";
    };

    buildInputs = with self; [ docutils six ];

    # Tests fail due to nix file timestamp normalization.
    doCheck = false;

    meta = {
      homepage = https://github.com/botocore/bcdoc;
      license = licenses.asl20;
      description = "ReST document generation tools for botocore";
    };
  };

  beautifulsoup4 = callPackage ../development/python-modules/beautifulsoup4 { };

  beaker = buildPythonPackage rec {
    name = "Beaker-${version}";
    version = "1.8.0";

    # The pypy release do not contains the tests
    src = pkgs.fetchFromGitHub {
      owner = "bbangert";
      repo = "beaker";
      rev = "${version}";
      sha256 = "17yfr7a307n8rdl09was4j60xqk2s0hk0hywdkigrpj4qnw0is7g";
    };

    buildInputs =
      [ self.nose
        self.mock
        self.webtest
      ];
    propagatedBuildInputs = [
      self.sqlalchemy
      self.pycrypto
    ] ++ optionals (isPy26 || isPy27) [
      self.funcsigs
      self.pycryptopp
    ];

    meta = {
      description = "A Session and Caching library with WSGI Middleware";
      maintainers = with maintainers; [ garbas domenkozar ];
      platforms = platforms.all;
    };
  };

  betamax = buildPythonPackage rec {
    name = "betamax-0.8.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/b/betamax/${name}.tar.gz";
      sha256 = "18f8v5gng3j773jlbbzx4rg1i4y2zw3m2l1zpmbvp8bh5a2q1i42";
    };

    propagatedBuildInputs = [ self.requests ];

    doCheck = false;

    meta = with stdenv.lib; {
      homepage = https://betamax.readthedocs.org/en/latest/;
      description = "A VCR imitation for requests";
      license = licenses.asl20;
      maintainers = with maintainers; [ pSub ];
    };
  };

  betamax-matchers = callPackage ../development/python-modules/betamax-matchers { };

  betamax-serializers = callPackage ../development/python-modules/betamax-serializers { };

  bibtexparser = callPackage ../development/python-modules/bibtexparser { };

  binwalk_fun = { visualizationSupport ? false, pyqtgraph ? null }:
    assert visualizationSupport -> pyqtgraph != null;

    buildPythonPackage rec {
    name = "binwalk-${version}";
    version = "2.1.1";

    src = pkgs.fetchFromGitHub {
      owner = "devttys0";
      repo = "binwalk";
      rev = "291a03595d17f848c73b74cb6ca508da782cd8f7";
      sha256 = "0grid93yz6i6jb2zggrqncp5awdf7qi88j5y2k7dq0k9r6b8zydw";
    };

    propagatedBuildInputs = with stdenv.lib; with pkgs; [ zlib xz ncompress gzip bzip2 gnutar p7zip cabextract lzma self.pycrypto ]
      ++ optional visualizationSupport pyqtgraph;

    meta = with stdenv.lib; {
      homepage = "http://binwalk.org";
      description = "A tool for searching a given binary image for embedded files";
      platforms = platforms.all;
      maintainers = [ maintainers.koral ];
    };
  };

  binwalk = self.binwalk_fun { };
  binwalk-full = self.binwalk_fun { visualizationSupport = true; pyqtgraph = self.pyqtgraph; };

  caldavclientlibrary-asynk = buildPythonPackage rec {
    version = "asynkdev";
    name = "caldavclientlibrary-asynk-${version}";

    src = pkgs.fetchgit {
      url = "https://github.com/skarra/CalDAVClientLibrary.git";
      rev = "06699b08190d50cc2636b921a654d67db0a967d1";
      sha256 = "157q32251ac9x3gdshgrjwsy48nq74vrzviswvph56h9wa8ksnnk";
    };

    disabled = isPy3k;

    meta = {
      description = "A Python library and tool for CalDAV";

      longDescription = ''
        CalDAVCLientLibrary is a Python library and tool for CalDAV.

        This package is the unofficial CalDAVCLientLibrary Python
        library maintained by the author of Asynk and is needed for
        that package.
      '';

      homepage = https://github.com/skarra/CalDAVClientLibrary/tree/asynkdev/;
      maintainers = with maintainers; [ pjones ];
    };
  };

  biopython = buildPythonPackage rec {
    name = "biopython-${version}";
    version = "1.68";

    src = pkgs.fetchurl {
      url = "mirror://pypi/b/biopython/${name}.tar.gz";
      sha256 = "07qc7nz0k77y8hf8s18rscvibvm91zw0kkq7ylrhisf8vp8hkp6i";
    };

    propagatedBuildInputs = with self; [ numpy ];
    # Checks try to write to $HOME, which does not work with nix
    doCheck = false;
    meta = {
      description = "Python library for bioinformatics";

      longDescription = ''
        Biopython is a set of freely available tools for biological computation
        written in Python by an international team of developers. It is a
        distributed collaborative effort to develop Python libraries and
        applications which address the needs of current and future work in
        bioinformatics.
      '';

      homepage = http://biopython.org/wiki/Documentation;
      maintainers = with maintainers; [ luispedro ];
    };
  };

  bedup = buildPythonPackage rec {
    version = "0.10.1";
    name = "bedup-${version}";

    src = pkgs.fetchFromGitHub {
      owner = "g2p";
      repo = "bedup";
      rev = "v${version}";
      sha256 = "0sp8pmjkxcqq0alianfp41mwq7qj10rk1qy31pjjp9kiph1rn0x6";
    };

    buildInputs = with self; [ pkgs.btrfs-progs ];
    propagatedBuildInputs = with self; [ contextlib2 pyxdg pycparser alembic ]
      ++ optionals (!isPyPy) [ cffi ];

    disabled = pythonOlder "3.3";

    meta = {
      description = "Deduplication for Btrfs";
      longDescription = ''
        Deduplication for Btrfs. bedup looks for new and changed files, making sure that multiple
        copies of identical files share space on disk. It integrates deeply with btrfs so that scans
        are incremental and low-impact.
      '';
      homepage = https://github.com/g2p/bedup;
      license = licenses.gpl2;

      platforms = platforms.linux;

      maintainers = with maintainers; [ bluescreen303 ];
    };
  };

  blessed = callPackage ../development/python-modules/blessed {};

  # Build boost for this specific Python version
  # TODO: use separate output for libboost_python.so
  boost = pkgs.boost.override {
    inherit (self) python numpy;
    enablePython = true;
  };

  buttersink = buildPythonPackage rec {
    name = "buttersink-0.6.8";

    src = pkgs.fetchurl {
      sha256 = "04gc63kfcqkw4qba5rijqk01xiphf04yk7hky9180ii64v2ip0j3";
      url = "mirror://pypi/b/buttersink/${name}.tar.gz";
    };

    # Python 2 syntax
    disabled = isPy3k;

    meta = {
      description = "Synchronise btrfs snapshots";
      longDescription = ''
        ButterSink is like rsync, but for btrfs subvolumes instead of files,
        which makes it much more efficient for things like archiving backup
        snapshots. It is built on top of btrfs send and receive capabilities.
        Sources and destinations can be local btrfs file systems, remote btrfs
        file systems over SSH, or S3 buckets.
      '';
      homepage = https://github.com/AmesCornish/buttersink/wiki;
      license = licenses.gpl3;
      platforms = platforms.linux;
      maintainers = with maintainers; [ nckx ];
    };

    propagatedBuildInputs = with self; [ boto crcmod psutil ];
  };

  cached-property = buildPythonPackage rec {
    version = "1.3.0";
    name = "cached-property-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/c/cached-property/${name}.tar.gz";
      sha256 = "10dwi3s6f154ag9dvqy5jiwp31fs57lbxjcjgn4cwvi8qyqpi3j5";
    };

    buildInputs = with self; [ freezegun ];

    meta = {
      description = "A decorator for caching properties in classes";
      homepage = https://github.com/pydanny/cached-property;
      license = licenses.bsd3;
      platforms = platforms.unix;
      maintainers = with maintainers; [ ericsagnes ];
    };
  };

  caffe = pkgs.caffe.override {
    python = self.python;
    boost = self.boost;
    numpy = self.numpy;
  };

  capstone = buildPythonPackage rec {
    name = "capstone-3.0.4";
    src = pkgs.fetchurl {
      url = "mirror://pypi/c/capstone/${name}.tar.gz";
      sha256 = "945d3b8c3646a1c3914824c416439e2cf2df8969dd722c8979cdcc23b40ad225";
    };
    patches = [
      (pkgs.fetchpatch {
        stripLen = 2;
        url = "https://patch-diff.githubusercontent.com/raw/aquynh/capstone/pull/783/commits/23fe9f36622573c747e2bab6119ff245437bf276.patch";
        sha256 = "0yizqrdlxqxn16873593kdx2vrr7gvvilhgcf9xy6hr0603d3m5r";
      })
    ];
    postPatch = ''
      patchShebangs src/make.sh
    '';
    propagatedBuildInputs = [ ];
    preCheck = ''
      mv src/libcapstone.so capstone
    '';
    meta = with pkgs.stdenv.lib; {
      homepage = "http://www.capstone-engine.org/";
      license = licenses.bsdOriginal;
      description = "Capstone disassembly engine";
      maintainers = with maintainers; [ bennofs ];
    };
  };

  cement = callPackage ../development/python-modules/cement {};

  cgroup-utils = callPackage ../development/python-modules/cgroup-utils {};
    postPatch = ''
      substituteInPlace setup.py --replace "argparse" ""
    '';


  channels = callPackage ../development/python-modules/channels {};

  cheroot = callPackage ../development/python-modules/cheroot {};

  circus = buildPythonPackage rec {
    name = "circus-0.11.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/c/circus/${name}.tar.gz";
      sha256 = "3757344aa5073ea29e6e2607b3de8ba1652502c61964316116931884293fe846";
    };

    doCheck = false; # weird error

    propagatedBuildInputs = with self; [ iowait psutil pyzmq tornado mock ];
  };

  colorclass = buildPythonPackage rec {
    pname = "colorclass";
    version = "2.2.0";
    name = "${pname}-${version}";

    src = fetchPypi {
      inherit pname version;
      sha256 = "b05c2a348dfc1aff2d502527d78a5b7b7e2f85da94a96c5081210d8e9ee8e18b";
    };

    # No tests in archive
    doCheck = false;

    meta = {
      homepage = "https://github.com/Robpol86/colorclass";
      license = licenses.mit;
      description = "Automatic support for console colors";
    };
  };

  colorlog = buildPythonPackage rec {
    name = "colorlog-${version}";
    version = "2.6.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/c/colorlog/${name}.tar.gz";
      sha256 = "0djv6ky1yk28s1l093w8plg19kp88q4nyrm1vfxyq0s9j4pix29l";
    };

    # No tests included
    doCheck = false;

    meta = {
      description = "Log formatting with colors";
      homepage = https://github.com/borntyping/python-colorlog;
      license = licenses.free; # BSD-like
    };
  };

  colour = buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "colour";
    version = "0.1.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/c/${pname}/${name}.tar.gz";
      sha256 = "0w1j43l76zw10dvs2kk7jz7kqj2ss7gfgfdxyls27pckwin89gxb";
    };

    buildInputs = with self; [ d2to1 ];

    meta = {
      description = "Converts and manipulates common color representation (RGB, HSV, web, ...)";
      homepage = https://github.com/vaab/colour;
      license = licenses.bsd2;
    };
  };

  constantly = callPackage ../development/python-modules/constantly { };

  cornice = buildPythonPackage rec {
    name = "cornice-${version}";
    version = "1.2.1";
    src = pkgs.fetchgit {
      url = https://github.com/mozilla-services/cornice.git;
      rev = "refs/tags/${version}";
      sha256 = "0688vrkl324jmpi8jkjh1s8nsyjinw149g3x8qlis8vz6j6a01wv";
    };

    propagatedBuildInputs = with self; [ pyramid simplejson ];

    doCheck = false; # lazy packager
  };

  cram = callPackage ../development/python-modules/cram { };

  csscompressor = callPackage ../development/python-modules/csscompressor {};

  csvkit =  callPackage ../development/python-modules/csvkit { };

  cufflinks = callPackage ../development/python-modules/cufflinks { };

  cx_Freeze = callPackage ../development/python-modules/cx_freeze {};

  cvxopt = buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "cvxopt";
    version = "1.1.7";
    disabled = isPyPy;
    src = pkgs.fetchurl {
      url = "mirror://pypi/c/${pname}/${name}.tar.gz";
      sha256 = "f856ea2e9e2947abc1a6557625cc6b0e45228984f397a90c420b2f468dc4cb97";
    };
    doCheck = false;
    buildInputs = with pkgs; [ openblasCompat ];
    preConfigure = ''
      export CVXOPT_BLAS_LIB_DIR=${pkgs.openblasCompat}/lib
      export CVXOPT_BLAS_LIB=openblas
      export CVXOPT_LAPACK_LIB=openblas
    '';
    meta = {
      homepage = "http://cvxopt.org/";
      description = "Python Software for Convex Optimization";
      maintainers = with maintainers; [ edwtjo ];
      license = licenses.gpl3Plus;
    };
  };

  cycler = callPackage ../development/python-modules/cycler { };

  dlib = buildPythonPackage rec {
    inherit (pkgs.dlib) name src nativeBuildInputs meta;

    buildInputs = pkgs.dlib.buildInputs ++ [ self.boost ];
  };

  datadog = buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "datadog";
    version = "0.10.0";
    src = pkgs.fetchurl {
      url = "mirror://pypi/d/${pname}/${name}.tar.gz";
      sha256 = "0y2if4jj43n5jis20imragvhhyhr840w4m1g7j7fxh9bn7h273zp";
    };

    buildInputs = with self; [ pillow tox mock six nose ];
    propagatedBuildInputs = with self; [ requests decorator simplejson ];

    meta = {
      description = "The Datadog Python library ";
      license = licenses.bsd3;
      homepage = https://github.com/DataDog/datadogpy;
    };
  };

  debian = buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "python-debian";
    version = "0.1.23";
    src = pkgs.fetchurl {
      url = "mirror://pypi/p/${pname}/${name}.tar.gz";
      sha256 = "193faznwnjc3n5991wyzim6h9gyq1zxifmfrnpm3avgkh7ahyynh";
    };
    propagatedBuildInputs = with self; [ chardet six ];
  };

  defusedxml = buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "defusedxml";
    version = "0.5.0";
    src = pkgs.fetchurl {
      url = "mirror://pypi/d/${pname}/${name}.tar.gz";
      sha256 = "1x54n0h8hl92vvwyymx883fbqpqjwn2mc8fb383bcg3z9zwz5mr4";
    };
  };

  dosage = buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "dosage";
    version = "2016.03.17";
    PBR_VERSION = version;
    src = pkgs.fetchFromGitHub {
      owner = "webcomics";
      repo = "dosage";
      rev = "1af022895e5f86bc43da95754c4c4ed305790f5b";
      sha256 = "1bkqhlzigy656pam0znp2ddp1y5sqzyhw3c4fyy58spcafldq4j6";
    };
    buildInputs = with self; [ pytest ];
    propagatedBuildInputs = with self; [ requests lxml pbr ];
    # prompt_toolkit doesn't work on 3.5 on OSX.
    doCheck = !isPy35;

    meta = {
      description = "A comic strip downloader and archiver";
      homepage = http://dosage.rocks/;
      broken = true; # ctypes error
    };
  };

  dugong = buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "dugong";
    version = "3.5";
    src = pkgs.fetchurl {
      url = "mirror://pypi/d/${pname}/${name}.tar.bz2";
      sha256 = "0y0rdxbiwm03zv6vpvapqilrird3h8ijz7xmb0j7ds5j4p6q3g24";
    };

    disabled = pythonOlder "3.3"; # Library does not support versions older than 3.3
  };

  iowait = buildPythonPackage rec {
    name = "iowait-0.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/i/iowait/${name}.tar.gz";
      sha256 = "ab1bc2eb84c22ccf61f17a0024f9fb6df781b39f1852764a66a7769d5adfb299";
    };

    meta = {
      description = "Platform-independent module for I/O completion events";
      homepage = https://launchpad.net/python-iowait;
    };
  };

  responses = self.buildPythonPackage rec {
    name = "responses-0.4.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/r/responses/${name}.tar.gz";
      sha256 = "0fs7a4cf4f12mjhcjd5vfh0f3ixcy2nawzxpgsfr3ahf0rg7ppx5";
    };

    propagatedBuildInputs = with self; [ cookies mock requests six ];

    doCheck = false;

  };

  rarfile = callPackage ../development/python-modules/rarfile { inherit (pkgs) libarchive; };

  proboscis = buildPythonPackage rec {
    name = "proboscis-1.2.6.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/proboscis/proboscis-1.2.6.0.tar.gz";
      sha256 = "b822b243a7c82030fce0de97bdc432345941306d2c24ef227ca561dd019cd238";
    };

    propagatedBuildInputs = with self; [ nose ];
    doCheck = false;

    meta = {
      description = "A Python test framework that extends Python's built-in unittest module and Nose with features from TestNG";
      homepage = https://github.com/rackspace/python-proboscis;
      license = licenses.asl20;
    };
  };

  pyechonest = self.buildPythonPackage rec {
    name = "pyechonest-8.0.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pyechonest/pyechonest-8.0.2.tar.gz";
      sha256 = "496265f4b7d33483ec153b9e1b8333fe959b115f7e781510089c8313b7d86560";
    };

    meta = {
      description = "Tap into The Echo Nest's Musical Brain for the best music search, information, recommendations and remix tools on the web";
      homepage = https://github.com/echonest/pyechonest;
    };
  };

  billiard = buildPythonPackage rec {
    name = "billiard-${version}";
    version = "3.5.0.2";

    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "mirror://pypi/b/billiard/${name}.tar.gz";
      sha256 = "1anw68rkja1dbgvndxz5mq6f89hmxwaha0fjcdnsl5j1wj7imc1y";
    };

    buildInputs = with self; [ pytest case ];

    meta = {
      homepage = https://github.com/celery/billiard;
      description = "Python multiprocessing fork with improvements and bugfixes";
      license = licenses.bsd3;
    };
  };


  binaryornot = buildPythonPackage rec {
    name = "binaryornot-${version}";
    version = "0.4.0";

    src = pkgs.fetchurl {
      url ="mirror://pypi/b/binaryornot/${name}.tar.gz";
      sha256 = "1j4f51dxic39mdwf6alj7gd769wy6mhk916v031wjali51xkh3xb";
    };

    buildInputs = with self; [ hypothesis ];

    propagatedBuildInputs = with self; [ chardet ];

    meta = {
      homepage = https://github.com/audreyr/binaryornot;
      description = "Ultra-lightweight pure Python package to check if a file is binary or text";
      license = licenses.bsd3;
    };
  };


  bitbucket_api = buildPythonPackage rec {
    name = "bitbucket-api-0.4.4";
    # python3 does not support relative imports
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/b/bitbucket-api/${name}.tar.gz";
      sha256 = "e890bc3893d59a6f203c1eb2bae60e78ac4d3869da7ea4fb104dca588aea85b2";
    };

    propagatedBuildInputs = with self; [ requests_oauthlib nose sh ];

    doCheck = false;

    meta = {
      homepage = https://github.com/Sheeprider/BitBucket-api;
      description = "Python library to interact with BitBucket REST API";
      license = licenses.mit;
    };
  };

  # Should be moved out of python-packages.nix
  bitbucket-cli = buildPythonPackage rec {
    name = "bitbucket-cli-0.5.1";
    src = pkgs.fetchurl {
       url = "mirror://pypi/b/bitbucket-cli/${name}.tar.gz";
       sha256 = "d881e21ec7ebfa006cfca6d10a5b7229aa59990568f8c6b8e3364769fa38b6f6";
    };

    propagatedBuildInputs = [ self.requests ];

    # No tests
    doCheck = false;

    disabled = isPy3k;

    meta = {
      description = "Bitbucket command line interface";
      homepage = "https://bitbucket.org/zhemao/bitbucket-cli";
      maintainers = with maintainers; [ refnil ];
    };
  };

  bitstring = callPackage ../development/python-modules/bitstring { };

  blaze = callPackage ../development/python-modules/blaze { };

  # Needed for bleach 1.5.0
  html5lib_0_9999999 = self.html5lib.overridePythonAttrs rec {
    name = "html5lib-${version}";
    disabled = isPy3k && pythonAtLeast "3.6";
    buildInputs = with self; [ nose flake8 ];
    propagatedBuildInputs = with self; [ six ];
    checkPhase = ''
      nosetests
    '';

    version = "0.9999999";
    src = pkgs.fetchurl {
      url = "https://github.com/html5lib/html5lib-python/archive/0.9999999.tar.gz";
      sha256 = "1s6wdbrjzw5jhyfbskf4nj1i5bjpjqq9f89a7r1rl59rhpwmfhhq";
    };
  };

  html5-parser = callPackage ../development/python-modules/html5-parser {};

  httpserver = callPackage ../development/python-modules/httpserver {};

  bleach = buildPythonPackage rec {
    pname = "bleach";
    version = "2.0.0";
    name = "${pname}-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
      sha256 = "0c5w7hh70lqzca7ir71j891csvch1899r8q09zgswk1y00q22lmr";
    };

    buildInputs = with self; [ pytest pytestrunner ];
    propagatedBuildInputs = with self; [ six html5lib ];

    meta = {
      description = "An easy, HTML5, whitelisting HTML sanitizer";
      longDescription = ''
        Bleach is an HTML sanitizing library that escapes or strips markup and
        attributes based on a white list. Bleach can also linkify text safely,
        applying filters that Django's urlize filter cannot, and optionally
        setting rel attributes, even on links already in the text.

        Bleach is intended for sanitizing text from untrusted sources. If you
        find yourself jumping through hoops to allow your site administrators
        to do lots of things, you're probably outside the use cases. Either
        trust those users, or don't.
      '';
      homepage = https://github.com/mozilla/bleach;
      downloadPage = https://github.com/mozilla/bleach/releases;
      license = licenses.asl20;
      maintainers = with maintainers; [ prikhi ];
    };
  };

  # needed for tensorflow-tensorboard
  bleach_1_5_0 = self.bleach.overridePythonAttrs rec {
    version = "1.5.0";
    pname = "bleach";
    name = "${pname}-${version}";

    propagatedBuildInputs = with self; [ six html5lib_0_9999999 ];

    preCheck = ''
      sed -i 's,pytest==[0-9.]*,pytest,' setup.py
    '';

    src = fetchPypi {
      inherit pname version;
      sha256 = "0rdwb3piwwl30wfqg4ywm07276w7090xfq71lb5d6k5mk62pb3lp";
    };
  };

  blinker = buildPythonPackage rec {
    name = "blinker-${version}";
    version = "1.4";

    src = pkgs.fetchurl {
      url = "mirror://pypi/b/blinker/${name}.tar.gz";
      sha256 = "1dpq0vb01p36jjwbhhd08ylvrnyvcc82yxx3mwjx6awrycjyw6j7";
    };

    meta = {
      homepage = http://pythonhosted.org/blinker/;
      description = "Fast, simple object-to-object and broadcast signaling";
      license = licenses.mit;
      maintainers = with maintainers; [ garbas ];
    };
  };

  blockdiag = callPackage ../development/python-modules/blockdiag { };

  bpython = callPackage ../development/python-modules/bpython {};

  bsddb3 = buildPythonPackage rec {
    name = "bsddb3-${version}";
    version = "6.1.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/b/bsddb3/${name}.tar.gz";
      sha256 = "6f21b0252125c07798d784c164ef135ad153d226c01b290258ee1c5b9e7c4dd3";
    };

    buildInputs = [ pkgs.db ];

    # Judging from SyntaxError in test
#    disabled = isPy3k;
    doCheck = false; # test suite breaks python3 compatibility

    # Path to database need to be set.
    # Somehow the setup.py flag is not propagated.
    #setupPyBuildFlags = [ "--berkeley-db=${pkgs.db}" ];
    # We can also use a variable
    preConfigure = ''
      export BERKELEYDB_DIR=${pkgs.db};
    '';

    meta = {
      description = "Python bindings for Oracle Berkeley DB";
      homepage = http://www.jcea.es/programacion/pybsddb.htm;
      license = with licenses; [ agpl3 ]; # License changed from bsd3 to agpl3 since 6.x
    };
  };

  bkcharts = callPackage ../development/python-modules/bkcharts { };

  bokeh = callPackage ../development/python-modules/bokeh { };

  boto = buildPythonPackage rec {
    name = "boto-${version}";
    version = "2.47.0";

    src = pkgs.fetchurl {
      url = "https://github.com/boto/boto/archive/${version}.tar.gz";
      sha256 = "051gq8z9m2cir03jhc00qs36bnpla7zkqm9xqiqcqvdknmi2ndbq";
    };

    checkPhase = ''
      ${python.interpreter} tests/test.py default
    '';

    buildInputs = [ self.nose self.mock ];
    propagatedBuildInputs = [ self.requests self.httpretty ];

    meta = {
      homepage = https://github.com/boto/boto;

      license = "bsd";

      description = "Python interface to Amazon Web Services";

      longDescription = ''
        The boto module is an integrated interface to current and
        future infrastructural services offered by Amazon Web
        Services.  This includes S3, SQS, EC2, among others.
      '';
    };
  };

  boto3 = buildPythonPackage rec {
    name = "boto3-${version}";
    version = "1.4.7";

    src = pkgs.fetchFromGitHub {
      owner = "boto";
      repo  = "boto3";
      rev   = version;
      sha256 = "0ca08xkkx6py08gqgn1aci9pklidwivxbvpwjv7623jr21avakdi";
    };

    propagatedBuildInputs = [ self.botocore self.jmespath self.s3transfer ] ++
                            (if isPy3k then [] else [self.futures]);
    buildInputs = [ self.docutils self.nose self.mock ];
    checkPhase = ''
      runHook preCheck
      # This method is not in mock. It might have appeared in some versions.
      sed -i 's/action.assert_called_once()/self.assertEqual(action.call_count, 1)/' \
        tests/unit/resources/test_factory.py
      nosetests -d tests/unit --verbose
      runHook postCheck
    '';

    # Network access
    doCheck = false;

    meta = {
      homepage = https://github.com/boto/boto3;
      license = stdenv.lib.licenses.asl20;
      description = "AWS SDK for Python";
      longDescription = ''
        Boto3 is the Amazon Web Services (AWS) Software Development Kit (SDK) for
        Python, which allows Python developers to write software that makes use of
        services like Amazon S3 and Amazon EC2.
      '';
    };
  };

  botocore = callPackage ../development/python-modules/botocore { };

  bottle = buildPythonPackage rec {
    version = "0.12.11";
    name = "bottle-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/b/bottle/${name}.tar.gz";
      sha256 = "0cd787lzggs933qfav6xicx5c78dz6npwgg3xc4rhah44nbqz5d1";
    };

    propagatedBuildInputs = with self; [ setuptools ];

    meta = {
      homepage = http://bottlepy.org;
      description = "A fast and simple micro-framework for small web-applications";
      license = licenses.mit;
      platforms = platforms.all;
      maintainers = with maintainers; [ koral ];
    };
  };

  box2d = buildPythonPackage rec {
    name = "box2d-${version}";
    version = "2.3b0";
    disabled = (!isPy27);

    src = pkgs.fetchurl {
      url = "mirror://pypi/B/Box2D/Box2D-2.3b0.zip";
      sha256 = "4519842c650b0153550eb0c9864da46b5a4ec8555c68b70f5cd2952a21c788b0";
    };

    patches = [ ../development/python-modules/box2d/disable-test.patch ];

    propagatedBuildInputs = [ pkgs.swig2 pkgs.box2d ];

    meta = {
      homepage = https://code.google.com/p/pybox2d/;
      description = ''
        A 2D game physics library for Python under
        the very liberal zlib license
      '';
      license = licenses.zlib;
      platforms = platforms.all;
      maintainers = with maintainers; [ sepi ];
    };
  };

  branca = callPackage ../development/python-modules/branca { };

  bugwarrior = buildPythonPackage rec {
    name = "bugwarrior-${version}";
    version = "1.4.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/b/bugwarrior/${name}.tar.gz";
      sha256 = "1jkz5vzbwspi1jcb3qsgcl619yip77khb696pc3ryk0pdhjhgs5w";
    };

    buildInputs = with self; [ mock unittest2 nose /* jira megaplan */ ];
    propagatedBuildInputs = with self; [
      twiggy requests offtrac bugzilla taskw dateutil pytz keyring six
      jinja2 pycurl dogpile_cache lockfile click pyxdg
    ];

    # for the moment jira>=0.22 and megaplan>=1.4 are missing for running the test suite.
    doCheck = false;

    meta = {
      homepage =  http://github.com/ralphbean/bugwarrior;
      description = "Sync github, bitbucket, bugzilla, and trac issues with taskwarrior";
      license = licenses.gpl3Plus;
      platforms = platforms.all;
      maintainers = with maintainers; [ pierron ];
    };
  };

  # bugz = buildPythonPackage (rec {
  #   name = "bugz-0.9.3";
  #
  #   src = pkgs.fetchgit {
  #     url = "https://github.com/williamh/pybugz.git";
  #     rev = "refs/tags/0.9.3";
  #   };
  #
  #   propagatedBuildInputs = with self; [ self.argparse ];
  #
  #   doCheck = false;
  #
  #   meta = {
  #     homepage = http://www.liquidx.net/pybugz/;
  #     description = "Command line interface for Bugzilla";
  #   };
  # });

  bugzilla = buildPythonPackage rec {
    name = "bugzilla-${version}";
    version = "1.1.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/python-bugzilla/python-${name}.tar.gz";
      sha256 = "11361635a4f1613803a0b9b93ba9126f7fd36180653f953e2590b1536d107d46";
    };

    patches = [ ../development/python-modules/bugzilla/checkPhase-fix-cookie-compare.patch ];

    buildInputs = with self; [ pep8 coverage logilab_common ];
    propagatedBuildInputs = [ self.requests ];

    preCheck = ''
      mkdir -p check-phase
      export HOME=$(pwd)/check-phase
    '';

    meta = {
      homepage = https://fedorahosted.org/python-bugzilla/;
      description = "Bugzilla XMLRPC access module";
      license = licenses.gpl2;
      platforms = platforms.all;
      maintainers = with maintainers; [ pierron ];
    };
  };

  check-manifest = buildPythonPackage rec {
    name = "check-manifest";
    version = "0.30";

    src = pkgs.fetchurl {
      url = "mirror://pypi/c/check-manifest/check-manifest-${version}.tar.gz";
      sha256 = "b19fd0d8b9286532ba3dc0282484fd76d11200cf24b340dc3d08f293c7dd0500";
    };

    doCheck = false;

    meta = {
      homepage = https://github.com/mgedmin/check-manifest;
      description = "Check MANIFEST.in in a Python source package for completeness";
      license = licenses.mit;
      maintainers = with maintainers; [ lewo ];
    };
  };

  devpi-common = callPackage ../development/python-modules/devpi-common { };
  # A patched version of buildout, useful for buildout based development on Nix
  zc_buildout_nix = callPackage ../development/python-modules/buildout-nix { };

  zc_buildout = self.zc_buildout221;

  zc_buildout221 = buildPythonPackage rec {
    name = "zc.buildout-2.2.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/z/zc.buildout/${name}.tar.gz";
      sha256 = "a6122ea5c06c6c044a9efce4a3df452c8573e1aebfda7b24262655daac894ef5";
    };

   meta = {
      homepage = "http://www.buildout.org";
      description = "A software build and configuration system";
      license = licenses.zpl21;
      maintainers = with maintainers; [ garbas ];
    };
  };

  bunch = buildPythonPackage (rec {
    name = "bunch-1.0.1";
    meta.maintainers = with maintainers; [ mornfall ];

    src = pkgs.fetchurl {
      url = "mirror://pypi/b/bunch/${name}.tar.gz";
      sha256 = "1akalx2pd1fjlvrq69plvcx783ppslvikqdm93z2sdybq07pmish";
    };
    doCheck = false;
  });


  cairocffi = buildPythonPackage rec {
    name = "cairocffi-0.7.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/c/cairocffi/${name}.tar.gz";
      sha256 = "e42b4256d27bd960cbf3b91a6c55d602defcdbc2a73f7317849c80279feeb975";
    };

    LC_ALL = "en_US.UTF-8";

    # checkPhase require at least one 'normal' font and one 'monospace',
    # otherwise glyph tests fails
    FONTCONFIG_FILE = pkgs.makeFontsConf {
      fontDirectories = [ pkgs.freefont_ttf ];
    };

    buildInputs = with self; [ pytest pkgs.glibcLocales ];
    propagatedBuildInputs = with self; [ pkgs.cairo cffi ];

    checkPhase = ''
      py.test $out/${python.sitePackages}
    '';

    # FIXME: make gdk_pixbuf dependency optional (as wel as xcfffi)
    # Happens with 0.7.1 and 0.7.2
    # OSError: dlopen() failed to load a library: gdk_pixbuf-2.0 / gdk_pixbuf-2.0-0

    patches = [
      # This patch from PR substituted upstream
      (pkgs.fetchpatch {
          url = "https://github.com/avnik/cairocffi/commit/2266882e263c5efc87350cf016d117b2ec6a1d59.patch";
          sha256 = "0gb570z3ivf1b0ixsk526n3h29m8c5rhjsiyam7rr3x80dp65cdl";
      })

      ../development/python-modules/cairocffi/dlopen-paths.patch
      ../development/python-modules/cairocffi/fix_test_scaled_font.patch
    ];

    postPatch = ''
      # Hardcode cairo library path
      substituteInPlace cairocffi/__init__.py --subst-var-by cairo ${pkgs.cairo.out}
      substituteInPlace cairocffi/__init__.py --subst-var-by glib ${pkgs.glib.out}
      substituteInPlace cairocffi/__init__.py --subst-var-by gdk_pixbuf ${pkgs.gdk_pixbuf.out}
    '';

    meta = {
      homepage = https://github.com/SimonSapin/cairocffi;
      license = "bsd";
      description = "cffi-based cairo bindings for Python";
    };
  };


  cairosvg = buildPythonPackage rec {
    version = "1.0.18";
    name = "cairosvg-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/C/CairoSVG/CairoSVG-${version}.tar.gz";
      sha256 = "01lpm38qp7xlnv8jv7qg48j44p5088dwfsrcllgs5fz355lrfds1";
    };

    propagatedBuildInputs = with self; [ cairocffi ];

    meta = {
      homepage = https://cairosvg.org;
      license = licenses.lgpl3;
      description = "SVG converter based on Cairo";
    };
  };


  carrot = buildPythonPackage rec {
    name = "carrot-0.10.7";

    src = pkgs.fetchurl {
      url = "mirror://pypi/c/carrot/${name}.tar.gz";
      sha256 = "cb46374f3c883c580d142a79d2609883713a867cc86e0514163adce784ce2468";
    };

    buildInputs = with self; [ self.nose ];

    propagatedBuildInputs =
      [ self.amqplib
        self.anyjson
      ];

    doCheck = false; # depends on the network

    meta = {
      homepage = https://pypi.python.org/pypi/carrot;
      description = "AMQP Messaging Framework for Python";
    };
  };

  github-cli = buildPythonPackage rec {
    version = "1.0.0";
    name = "github-cli-${version}";
    src = pkgs.fetchFromGitHub {
      owner = "jsmits";
      repo = "github-cli";
      rev = version;
      sha256 = "16bwn42wqd76zs97v8p6mqk79p5i2mb06ljk67lf8gy6kvqc1x8y";
    };

    buildInputs = with self; [ nose pkgs.git ];
    propagatedBuildInputs = with self; [ simplejson ];

    # skipping test_issues_cli.py since it requires access to the github.com
    patchPhase = "rm tests/test_issues_cli.py";
    checkPhase = "nosetests tests/";

    meta.maintainers = with maintainers; [ garbas ];
  };

  case = buildPythonPackage rec {
    name = "case-${version}";
    version = "1.5.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/c/case/${name}.tar.gz";
      sha256 = "1zbhbw87izcxj9rvqg432a7r69ps2ks20mqq3g3hgd42sckcy3ca";
    };

    propagatedBuildInputs = with self; [ six nose unittest2 mock ];

    meta = {
      homepage = https://github.com/celery/case;
      description = "unittests utilities";
      license = licenses.bsd3;
    };

  };

  cassandra-driver = buildPythonPackage rec {
    name = "cassandra-driver-3.6.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/c/cassandra-driver/${name}.tar.gz";
      sha256 = "1aqmy3psn12lxgp659d0zsxkirxzy5lnbnzxf9xjq1a93s3qm704";
    };

    buildInputs = with self; [ pkgs.libev cython ] ++ optionals doCheck [ scales eventlet twisted mock gevent nose pytz pyyaml sure ];

    propagatedBuildInputs = with self; [ futures six ];

    postPatch = ''
      sed -i "s/<=1.0.1//" setup.py
    '';

    checkPhase = ''
      ${python.interpreter} setup.py gevent_nosetests
      ${python.interpreter} setup.py eventlet_nosetests
    '';

    # Could not get tests running
    doCheck = false;

    meta = {
      homepage = http://datastax.github.io/python-driver/;
      description = "A Python client driver for Apache Cassandra";
      license = licenses.asl20;
    };
  };

  cccolutils = callPackage ../development/python-modules/cccolutils/default.nix {};

  CDDB = buildPythonPackage rec {
    name = "CDDB-1.4";

    disabled = !isPy27;

    src = pkgs.fetchurl {
      url = "http://cddb-py.sourceforge.net/${name}.tar.gz";
      sha256 = "098xhd575ibvdx7i3dny3lwi851yxhjg2hn5jbbgrwj833rg5l5w";
    };

    meta = {
      homepage = http://cddb-py.sourceforge.net/;
      description = "CDDB and FreeDB audio CD track info access";
      license = licenses.gpl2Plus;
    };
  };

  cntk = buildPythonPackage rec {
    inherit (pkgs.cntk) name version src meta;

    buildInputs = [ pkgs.cntk pkgs.swig pkgs.openmpi ];
    propagatedBuildInputs = with self; [ numpy scipy enum34 protobuf pip ];

    CNTK_LIB_PATH = "${pkgs.cntk}/lib";
    CNTK_COMPONENT_VERSION = pkgs.cntk.version;

    postPatch = ''
      cd bindings/python
    '';

    postInstall = ''
      rm -rf $out/${python.sitePackages}/cntk/libs
      ln -s ${pkgs.cntk}/lib $out/${python.sitePackages}/cntk/libs
      # It's not installed for some reason.
      cp cntk/cntk_py.py $out/${python.sitePackages}/cntk
    '';
  };

  celery = buildPythonPackage rec {
    name = "celery-${version}";
    version = "4.0.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/c/celery/${name}.tar.gz";
      sha256 = "0kgmbs3fl9879n48p4m79nxy9by2yhvxq1jdvlnqzzvkdb2sdmg3";
    };

    # Fixes testsuite for python-3.6
    # From ubuntu packaging: https://launchpad.net/ubuntu/+archive/primary/+files/celery_4.0.2-0ubuntu1.debian.tar.xz
    # (linked from https://launchpad.net/ubuntu/+source/celery)
    # https://github.com/celery/celery/pull/3736#issuecomment-274155454 from upstream
    patches = [ ../development/python-modules/celery/fix_endless_python3.6_loop_logger_isa.patch ];

    # make /etc/protocols accessible to fix socket.getprotobyname('tcp') in sandbox
    preCheck = ''
      export NIX_REDIRECTS=/etc/protocols=${pkgs.iana-etc}/etc/protocols \
        LD_PRELOAD=${pkgs.libredirect}/lib/libredirect.so
    '';
    postCheck = ''
      unset NIX_REDIRECTS LD_PRELOAD
    '';

    buildInputs = with self; [ pytest case ];
    propagatedBuildInputs = with self; [ kombu billiard pytz anyjson amqp eventlet ];

    meta = {
      homepage = https://github.com/celery/celery/;
      description = "Distributed task queue";
      license = licenses.bsd3;
    };
  };

  cerberus = buildPythonPackage rec {
    name = "Cerberus-${version}";
    version = "0.9.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/C/Cerberus/${name}.tar.gz";
      sha256 = "1km7hvns1snrmcwz58bssi4wv3gwd34zm1z1hwjylmpqrfrcf8mi";
    };

    meta = {
      homepage = http://python-cerberus.org/;
      description = "Lightweight, extensible schema and data validation tool for Python dictionaries";
      license = licenses.mit;
    };
  };

  certifi = callPackage ../development/python-modules/certifi { };

  characteristic = callPackage ../development/python-modules/characteristic { };

  cheetah = buildPythonPackage rec {
    version = "2.4.4";
    name = "cheetah-${version}";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/C/Cheetah/Cheetah-${version}.tar.gz";
      sha256 = "be308229f0c1e5e5af4f27d7ee06d90bb19e6af3059794e5fd536a6f29a9b550";
    };

    propagatedBuildInputs = with self; [ self.markdown ];

    meta = {
      homepage = http://www.cheetahtemplate.org/;
      description = "A template engine and code generation tool";
    };
  };

  cherrypy = callPackage ../development/python-modules/cherrypy {};

  cjson = buildPythonPackage rec {
    name = "python-cjson-${version}";
    version = "1.1.0";
    disabled = isPy3k || isPyPy;

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/python-cjson/${name}.tar.gz";
      sha256 = "a01fabb7593728c3d851e1cd9a3efbd18f72650a31a5aa8a74018640da3de8b3";
    };

    meta = {
      description = "A very fast JSON encoder/decoder for Python";
      homepage    = "http://ag-projects.com/";
      license     = licenses.lgpl2;
      platforms   = platforms.all;
    };
  };

  cld2-cffi = callPackage ../development/python-modules/cld2-cffi {};

  clf = buildPythonPackage rec {
    name = "clf-${version}";
    version = "0.5.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/c/clf/${name}.tar.gz";
      sha256 = "04lqd2i4fjs606b0q075yi9xksk567m0sfph6v6j80za0hvzqyy5";
    };

    patchPhase = ''
      sed -i 's/==/>=/' requirements.txt
    '';

    propagatedBuildInputs = with self; [ docopt requests pygments ];

    # Error when running tests:
    # No local packages or download links found for requests
    doCheck = false;

    meta = {
      homepage = https://github.com/ncrocfer/clf;
      description = "Command line tool to search snippets on Commandlinefu.com";
      license = licenses.mit;
      maintainers = with maintainers; [ koral ];
    };
  };

  click = buildPythonPackage rec {
    name = "click-6.7";

    src = pkgs.fetchurl {
      url = "mirror://pypi/c/click/${name}.tar.gz";
      sha256 = "02qkfpykbq35id8glfgwc38yc430427yd05z1wc5cnld8zgicmgi";
    };

    buildInputs = with self; [ pytest ];

    checkPhase = ''
      py.test tests
    '';

    # https://github.com/pallets/click/issues/823
    doCheck = false;

    meta = {
      homepage = http://click.pocoo.org/;
      description = "Create beautiful command line interfaces in Python";
      longDescription = ''
        A Python package for creating beautiful command line interfaces in a
        composable way, with as little code as necessary.
      '';
      license = licenses.bsd3;
      maintainers = with maintainers; [ nckx ];
    };
  };

  click_5 = buildPythonPackage rec {
    name = "click-5.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/c/click/${name}.tar.gz";
      sha256 = "0njsm0wn31l21bi118g5825ma5sa3rwn7v2x4wjd7yiiahkri337";
    };

    meta = {
      homepage = http://click.pocoo.org/;
      description = "Create beautiful command line interfaces in Python";
      longDescription = ''
        A Python package for creating beautiful command line interfaces in a
        composable way, with as little code as necessary.
      '';
      license = licenses.bsd3;
      maintainers = with maintainers; [ mog ];
    };
  };

  click-log = buildPythonPackage rec {
    version = "0.2.1";
    name = "click-log-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/c/click-log/${name}.tar.gz";
      sha256 = "1r1x85023cslb2pwldd089jjk573mk3w78cnashs77wrx7yz8fj9";
    };

    propagatedBuildInputs = with self; [ click ];

    meta = {
      homepage = https://github.com/click-contrib/click-log/;
      description = "Logging integration for Click";
      license = licenses.mit;
      maintainers = with maintainers; [ ];
    };
  };

  click-plugins = callPackage ../development/python-modules/click-plugins {};

  click-threading = buildPythonPackage rec {
    version = "0.4.2";
    name = "click-threading-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/c/click-threading/${name}.tar.gz";
      sha256 = "400b0bb63d9096b6bf2806efaf742a1cc8b6c88e0484f0afe7d7a7f0e9870609";
    };

    checkInputs = with self; [ pytest_29 ];
    propagatedBuildInputs = with self; [ click ] ++ optional (!isPy3k) futures;

    checkPhase = ''
      py.test
    '';

    # Tests are broken on 3.x
    doCheck = !isPy3k;

    meta = {
      homepage = https://github.com/click-contrib/click-threading/;
      description = "Multithreaded Click apps made easy";
      license = licenses.mit;
      maintainers = with maintainers; [ ];
    };
  };

  cligj = callPackage ../development/python-modules/cligj { };

  /* There is a project called "closure-linter" on PyPI that is the
     same as this, but it does not appear to be owned by Google.
     So we're pulling from Google's GitHub repo instead. */
  closure-linter = buildPythonPackage rec {
    name = "closure-linter-${version}";
    version = "2.3.19";

    /* This project has no Python 3 support, as noted by
       https://github.com/google/closure-linter/issues/81 */
    disabled = isPy3k;

    propagatedBuildInputs = with self; [ gflags ];
    src = pkgs.fetchgit {
      url = "https://github.com/google/closure-linter";
      rev = "5c27529075bb88bdc45e73008f496dec8438d658";
      sha256 = "076c7q7pr7akfvq5y8lxr1ab81wwps07gw00igdkcxnc5k9dzxwc";
    };
    meta = {
      description = "Checks JavaScript files against Google's style guide.";
      homepage = "https://developers.google.com/closure/utilities/";
      license = with licenses; [ asl20 ];
    };
  };

  cloudpickle = buildPythonPackage rec {
    name = "cloudpickle-${version}";
    version = "0.2.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/c/cloudpickle/${name}.tar.gz";
      sha256 = "0x4fbycipkhfax7lydaxcnc14g42g274qba17j51shr5gbq6m8lx";
    };

    buildInputs = with self; [ pytest mock ];

    # See README for tests invocation
    checkPhase = ''
      PYTHONPATH=$PYTHONPATH:'.:tests' py.test
    '';

    # TypeError: cannot serialize '_io.FileIO' object
    doCheck = false;

    meta = {
      description = "Extended pickling support for Python objects";
      homepage = https://github.com/cloudpipe/cloudpickle;
      license = with licenses; [ bsd3 ];
    };
  };

  cmdline = buildPythonPackage rec {
    pname = "cmdline";
    version = "0.1.6";
    name = "${pname}-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/c/${pname}/${name}.tar.gz";
      sha256 = "be2cb4711e9111bb7386a408e3c66a730c36dd6ac05851a9f03d0f4eae63536a";
    };

    # No tests, https://github.com/rca/cmdline/issues/1
    doCheck = false;
    propagatedBuildInputs = with self; [ pyyaml ];
    meta = {
      description = "Utilities for consistent command line tools";
      homepage = https://github.com/rca/cmdline;
      license = licenses.asl20;
    };
  };

  codecov = callPackage ../development/python-modules/codecov {};

  cogapp = buildPythonPackage rec {
    version = "2.3";
    name    = "cogapp-${version}";

    src = pkgs.fetchurl {
      url    = "mirror://pypi/c/cogapp/${name}.tar.gz";
      sha256 = "0gzmzbsk54r1qa6wd0yg4zzdxvn2f19ciprr2acldxaknzrpllnn";
    };

    # there are no tests
    doCheck = false;

    meta = {
      description = "A code generator for executing Python snippets in source files";
      homepage    = http://nedbatchelder.com/code/cog;
      license     = licenses.mit;
      maintainers = with maintainers; [ lovek323 ];
      platforms   = platforms.unix;
    };
  };

  colorama = callPackage ../development/python-modules/colorama { };

  colorlover = callPackage ../development/python-modules/colorlover { };

  CommonMark = buildPythonPackage rec {
    name = "CommonMark-${version}";
    version = "0.6.3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/C/CommonMark/${name}.tar.gz";
      sha256 = "ee5a88f23678794592efe3fc11033f17fc77b3296a85f5e1d5b715f8e110a773";
    };

    LC_ALL="en_US.UTF-8";

    doCheck = false;

    buildInputs = with self; [ flake8 pkgs.glibcLocales ];
    propagatedBuildInputs = with self; [ future ];

    meta = {
      description = "Python parser for the CommonMark Markdown spec";
      homepage = https://github.com/rolandshoemaker/CommonMark-py;
      license = licenses.bsd3;
    };
  };

  CommonMark_54 = self.CommonMark.override rec {
    name = "CommonMark-0.5.4";
    src = pkgs.fetchurl {
      url = "mirror://pypi/C/CommonMark/${name}.tar.gz";
      sha256 = "34d73ec8085923c023930dfc0bcd1c4286e28a2a82de094bb72fabcc0281cbe5";
    };
  };


  coilmq = buildPythonPackage (rec {
    name = "CoilMQ-${version}";
    version = "1.0.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/C/CoilMQ/${name}.tar.gz";
      sha256 = "0wwa6fsqw1mxsryvgp0yrdjil8axyj0kslzi7lr45cnhgp5ab375";
    };

    propagatedBuildInputs = with self; [ stompclient pythondaemon redis pid];

    buildInputs = with self; [ pytest six click coverage sqlalchemy ];

    # The teste data is not included in the distribution
    doCheck = false;

    meta = {
      description = "Simple, lightweight, and easily extensible STOMP message broker";
      homepage = http://code.google.com/p/coilmq/;
      license = licenses.asl20;
    };
  });


  colander = buildPythonPackage rec {
    name = "colander-1.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/c/colander/${name}.tar.gz";
      sha256 = "7389413266b9e680c9529c16d56284edf87e0d5de557948e75f41d65683c23b3";
    };

    propagatedBuildInputs = with self; [ self.translationstring self.iso8601 ];

    meta = {
      maintainers = with maintainers; [ garbas domenkozar ];
      platforms = platforms.all;
    };
  };

  # Backported version of the ConfigParser library of Python 3.3
  configparser = if isPy3k then null else buildPythonPackage rec {
    name = "configparser-${version}";
    version = "3.5.0";

    # running install_egg_info
    # error: [Errno 9] Bad file descriptor: '<stdout>'
    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "mirror://pypi/c/configparser/${name}.tar.gz";
      sha256 = "5308b47021bc2340965c371f0f058cc6971a04502638d4244225c49d80db273a";
    };

    # No tests available
    doCheck = false;

    # Fix issue when used together with other namespace packages
    # https://github.com/NixOS/nixpkgs/issues/23855
    patches = [
      ./../development/python-modules/configparser/0001-namespace-fix.patch
    ];

    meta = {
      maintainers = [ ];
      platforms = platforms.all;
    };
  };


  ColanderAlchemy = buildPythonPackage rec {
    name = "ColanderAlchemy-${version}";
    version = "0.3.3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/C/ColanderAlchemy/${name}.tar.gz";
      sha256 = "11wcni2xmfmy001rj62q2pwf305vvngkrfm5c4zlwvgbvlsrvnnw";
    };

    patches = [
      (pkgs.fetchpatch {
          url = "https://github.com/stefanofontanelli/ColanderAlchemy/commit/b45fe35f2936a5ccb705e9344075191e550af6c9.patch";
          sha256 = "1kf278wjq49zd6fhpp55vdcawzdd107767shzfck522sv8gr6qvx";
      })
    ];

    buildInputs = with self; [ unittest2 ];
    propagatedBuildInputs = with self; [ colander sqlalchemy ];

    meta = {
      description = "Autogenerate Colander schemas based on SQLAlchemy models";
      homepage = https://github.com/stefanofontanelli/ColanderAlchemy;
      license = licenses.mit;
    };
  };


  configobj = buildPythonPackage (rec {
    name = "configobj-5.0.6";

    src = pkgs.fetchurl {
      url = "mirror://pypi/c/configobj/${name}.tar.gz";
      sha256 = "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902";
    };

    # error: invalid command 'test'
    doCheck = false;

    propagatedBuildInputs = with self; [ six ];

    meta = {
      description = "Config file reading, writing and validation";
      homepage = https://pypi.python.org/pypi/configobj;
      license = licenses.bsd3;
      maintainers = with maintainers; [ garbas ];
    };
  });


  confluent-kafka = callPackage ../development/python-modules/confluent-kafka {};

  construct = callPackage ../development/python-modules/construct {};

  consul = buildPythonPackage (rec {
    name = "python-consul-0.7.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/python-consul/${name}.tar.gz";
      sha256 = "18gs5myk9wkkq5zvj0n0s68ngj3mrbdcifshxfj1j0bgb1km0wpm";
    };

    buildInputs = with self; [ requests six pytest ];

    # No tests distributed. https://github.com/cablehead/python-consul/issues/133
    doCheck = false;

    meta = {
      description = "Python client for Consul (https://www.consul.io/)";
      homepage = https://github.com/cablehead/python-consul;
      license = licenses.mit;
      maintainers = with maintainers; [ desiderius ];
    };
  });

  contexter = buildPythonPackage rec {
    name = "contexter-${version}";
    version = "0.1.3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/c/contexter/${name}.tar.gz";
      sha256 = "0xrnkjya29ya0hkj8y4k9ni2mnr58i6r0xfqlj7wk07v4jfrkc8n";
    };
  };


  contextlib2 = callPackage ../development/python-modules/contextlib2 { };

  cookiecutter = buildPythonPackage rec {
    version = "1.4.0";
    name = "cookiecutter-${version}";

    # not sure why this is broken
    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "https://github.com/audreyr/cookiecutter/archive/${version}.tar.gz";
      sha256 = "1clxnabmc5s4b519r1sxyj1163x833ir8xcypmdfpf6r9kbb35vn";
    };

    buildInputs = with self; [ itsdangerous pytest freezegun docutils ];
    propagatedBuildInputs = with self; [
          jinja2 future binaryornot click whichcraft poyo jinja2_time ];

    meta = {
      homepage = https://github.com/audreyr/cookiecutter;
      description = "A command-line utility that creates projects from project templates";
      license = licenses.bsd3;
      maintainers = with maintainers; [ kragniz ];
    };
  };

  cookies = buildPythonPackage rec {
    name = "cookies-2.2.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/c/cookies/${name}.tar.gz";
      sha256 = "13pfndz8vbk4p2a44cfbjsypjarkrall71pgc97glk5fiiw9idnn";
    };

    doCheck = false;

    meta = {
      description = "Friendlier RFC 6265-compliant cookie parser/renderer";
      homepage = https://github.com/sashahart/cookies;
      license = licenses.mit;
    };
  };

  coveralls = callPackage ../development/python-modules/coveralls { };

  coverage = callPackage ../development/python-modules/coverage { };

  covCore = buildPythonPackage rec {
    name = "cov-core-1.15.0";
    src = pkgs.fetchurl {
      url = "mirror://pypi/c/cov-core/${name}.tar.gz";
      sha256 = "4a14c67d520fda9d42b0da6134638578caae1d374b9bb462d8de00587dba764c";
    };
    meta = {
      description = "Plugin core for use by pytest-cov, nose-cov and nose2-cov";
    };
    propagatedBuildInputs = with self; [ self.coverage ];
  };

  crcmod = buildPythonPackage rec {
    name = "crcmod-1.7";
    src = pkgs.fetchurl {
      url = mirror://pypi/c/crcmod/crcmod-1.7.tar.gz;
      sha256 = "07k0hgr42vw2j92cln3klxka81f33knd7459cn3d8aszvfh52w6w";
    };
    meta = {
      description = "Python module for generating objects that compute the Cyclic Redundancy Check (CRC)";
      homepage = http://crcmod.sourceforge.net/;
      license = licenses.mit;
    };
  };

  credstash = callPackage ../development/python-modules/credstash { };

  cython = callPackage ../development/python-modules/Cython { };

  cytoolz = callPackage ../development/python-modules/cytoolz { };

  cryptacular = buildPythonPackage rec {
    name = "cryptacular-1.4.1";

    buildInputs = with self; [ coverage nose ];
    propagatedBuildInputs = with self; [ pbkdf2 ];

    src = pkgs.fetchurl {
      url = "mirror://pypi/c/cryptacular/${name}.tar.gz";
      sha256 = "273f03d03f9b316671ae4f1c1c6b8d3c883da19a5706873e8f3d6543e13dd4a1";
    };

    # TODO: tests fail: TypeError: object of type 'NoneType' has no len()
    doCheck = false;

    meta = {
      maintainers = with maintainers; [ domenkozar ];
    };
  };

  cryptography = buildPythonPackage rec {
    # also bump cryptography_vectors
    pname = "cryptography";
    name = "${pname}-${version}";
    version = "2.0.3";

    src = fetchPypi {
      inherit pname version;
      sha256 = "d04bb2425086c3fe86f7bc48915290b13e798497839fbb18ab7f6dffcf98cc3a";
    };

    outputs = [ "out" "dev" ];

    buildInputs = [ pkgs.openssl self.cryptography_vectors ]
               ++ optional stdenv.isDarwin pkgs.darwin.apple_sdk.frameworks.Security;
    propagatedBuildInputs = with self; [
      idna
      asn1crypto
      packaging
      six
    ] ++ optional (pythonOlder "3.4") enum34
    ++ optional (pythonOlder "3.3") ipaddress
    ++ optional (!isPyPy) cffi;

    checkInputs = with self; [
      pytest
      pretend
      iso8601
      pytz
      hypothesis
    ];

    # The test assumes that if we're on Sierra or higher, that we use `getentropy`, but for binary
    # compatibility with pre-Sierra for binary caches, we hide that symbol so the library doesn't
    # use it. This boils down to them checking compatibility with `getentropy` in two different places,
    # so let's neuter the second test.
    postPatch = ''
      substituteInPlace ./tests/hazmat/backends/test_openssl.py --replace '"16.0"' '"99.0"'
    '';

    # IOKit's dependencies are inconsistent between OSX versions, so this is the best we
    # can do until nix 1.11's release
    __impureHostDeps = [ "/usr/lib" ];
  };

  cryptography_vectors = buildPythonPackage rec {
      # also bump cryptography
    pname = "cryptography_vectors";
    version = self.cryptography.version;
    name = "${pname}-${version}";

    src = fetchPypi {
      inherit pname version;
      sha256 = "beb831aa73663a224f4d7520483ed02da544533bb03b26ec07a5f9a0dd0941e1";
    };

    # No tests included
    doCheck = false;
  };

  curtsies = callPackage ../development/python-modules/curtsies { };

  oslo-vmware = buildPythonPackage rec {
    name = "oslo.vmware-${version}";
    version = "1.22.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/o/oslo.vmware/${name}.tar.gz";
      sha256 = "1119q3x2y3hjz3p784byr13aqay75pbj4cb8v43gjq5piqlpp16x";
    };

    propagatedBuildInputs = with self; [
      pbr stevedore netaddr iso8601 six oslo-i18n oslo-utils Babel pyyaml eventlet
      requests urllib3 oslo-concurrency suds-jurko
    ];
    buildInputs = with self; [
      bandit oslosphinx coverage testtools testscenarios testrepository mock

    ];
  };

  barbicanclient = buildPythonPackage rec {
    name = "barbicanclient-${version}";
    version = "3.3.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/python-barbicanclient/python-barbicanclient-${version}.tar.gz";
      sha256 = "1kxnxiijvkkc8ahlfbkslpzxcbah7y5pi86hvkyac62xzda87inm";
    };

    propagatedBuildInputs = with self; [
      pbr argparse requests six keystoneclient cliff oslo-i18n oslo-serialization
      oslo-utils
    ];
    buildInputs = with self; [
      oslosphinx oslotest requests-mock
    ];

    patchPhase = ''
      sed -i 's@python@${python.interpreter}@' .testr.conf
    '';
  };


  ironicclient = buildPythonPackage rec {
    name = "ironicclient-${version}";
    version = "0.9.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/python-ironicclient/python-ironicclient-${version}.tar.gz";
      sha256 = "16kaixrmnx6a32mfv281w22h8lavjh0k9yiqikmwc986ydh85s4d";
    };

    propagatedBuildInputs = with self; [
      six keystoneclient prettytable oslo-utils oslo-i18n lxml httplib2 cliff
      dogpile_cache appdirs anyjson pbr openstackclient
    ];
    buildInputs = with self; [
      httpretty
    ];

    meta = with stdenv.lib; {
      description = "Python bindings for the Ironic API";
      homepage = "http://www.openstack.org/";
    };
  };

  novaclient = buildPythonPackage rec {
    name = "novaclient-${version}";
    version = "2.31.0";

    src = pkgs.fetchurl {
      url = "https://github.com/openstack/python-novaclient/archive/${version}.tar.gz";
      sha256 = "0cd49yz9qhpv1srg6wwjnivyb3i8zjxda0h439158qv9w6bfqhdf";
    };

    PBR_VERSION = "${version}";

    buildInputs = with self; [
      pbr testtools testscenarios testrepository requests-mock fixtures ];
    propagatedBuildInputs = with self; [
      Babel argparse prettytable requests simplejson six iso8601
      keystoneclient tempest-lib ];

    # TODO: check if removing this test is really harmless
    preCheck = ''
      substituteInPlace novaclient/tests/unit/v2/test_servers.py --replace "test_get_password" "noop"
    '';

    patchPhase = ''
      sed -i 's@python@${python.interpreter}@' .testr.conf
    '';

    meta = {
      homepage = https://github.com/openstack/python-novaclient/;
      description = "Client library and command line tool for the OpenStack Nova API";
      license = stdenv.lib.licenses.asl20;
      platforms = stdenv.lib.platforms.linux;
    };
  };

  tablib = buildPythonPackage rec {
    name = "tablib-${version}";
    version = "0.10.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/tablib/tablib-${version}.tar.gz";
      sha256 = "14wc8bmz60g35r6gsyhdzfvgfqpd3gw9lfkq49z5bxciykbxmhj1";
    };

    buildInputs = with self; [ pytest ];

    meta = with stdenv.lib; {
      description = "Tablib: format-agnostic tabular dataset library";
      homepage = "http://python-tablib.org";
    };
  };


  cliff-tablib = buildPythonPackage rec {
    name = "cliff-tablib-${version}";
    version = "1.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/c/cliff-tablib/cliff-tablib-${version}.tar.gz";
      sha256 = "0fa1qw41lwda5ac3z822qhzbilp51y6p1wlp0h76vrvqcqgxi3ja";
    };

    propagatedBuildInputs = with self; [
      argparse pyyaml pbr six cmd2 tablib unicodecsv prettytable stevedore pyparsing cliff
    ];
    buildInputs = with self; [

    ];

    meta = with stdenv.lib; {
      homepage = "https://github.com/dreamhost/cliff-tablib";
    };
  };

  openant = buildPythonPackage rec {
    name = "openant-unstable-2017-02-11";

    meta = with stdenv.lib; {
      homepage = "https://github.com/Tigge/openant";
      description = "ANT and ANT-FS Python Library";
      license = licenses.mit;
      platforms = platforms.linux;
    };

    src = pkgs.fetchFromGitHub {
      owner = "Tigge";
      repo = "openant";
      rev = "ed89281e37f65d768641e87356cef38877952397";
      sha256 = "1g81l9arqdy09ijswn3sp4d6i3z18d44lzyb78bwnvdb14q22k19";
    };

    # Removes some setup.py hacks intended to install udev rules.
    # We do the job ourselves in postInstall below.
    postPatch = ''
      sed -i -e '/cmdclass=.*/d' setup.py
    '';

    postInstall = ''
      install -dm755 "$out/etc/udev/rules.d"
      install -m644 resources/ant-usb-sticks.rules "$out/etc/udev/rules.d/99-ant-usb-sticks.rules"
    '';

    propagatedBuildInputs = with self; [ pyusb ];
  };

  opencv = pkgs.opencv.override {
    enablePython = true;
    pythonPackages = self;
  };

  opencv3 = pkgs.opencv3.override {
    enablePython = true;
    pythonPackages = self;
  };

  openidc-client = callPackage ../development/python-modules/openidc-client/default.nix {};

  openstackclient = buildPythonPackage rec {
    name = "openstackclient-${version}";
    version = "1.7.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/python-openstackclient/python-openstackclient-${version}.tar.gz";
      sha256 = "0h1jkrwx06l32k50zq5gs9iba132q2x2jjb3z5gkxxlcd3apk8y9";
    };

    propagatedBuildInputs = with self; [
     pbr six Babel cliff os-client-config oslo-config oslo-i18n oslo-utils
     glanceclient keystoneclient novaclient cinderclient neutronclient requests
     stevedore cliff-tablib
    ];
    buildInputs = with self; [
     requests-mock
    ];
    patchPhase = ''
      sed -i 's@python@${python.interpreter}@' .testr.conf
    '';

    meta = with stdenv.lib; {
      homepage = "http://wiki.openstack.org/OpenStackClient";
    };
  };



  idna = buildPythonPackage rec {
    pname = "idna";
    version = "2.5";
    name = "${pname}-${version}";

    src = fetchPypi {
      inherit pname version;
      sha256 = "3cb5ce08046c4e3a560fc02f138d0ac63e00f8ce5901a56b32ec8b7994082aab";
    };

    meta = {
      homepage = "http://github.com/kjd/idna/";
      description = "Internationalized Domain Names in Applications (IDNA)";
      license = "licenses.bsd3";
    };
  };

  mahotas = buildPythonPackage rec {
    name = "python-mahotas-${version}";
    version = "1.4.2";

    src = pkgs.fetchurl {
      url = "https://github.com/luispedro/mahotas/archive/v${version}.tar.gz";
      sha256 = "1mvsxh0pa5vdvbknlv1m68n7gw2cv4pyqgqp3r770rnmf6nxbp7m";
    };

    buildInputs = with self; [
      nose
      pillow
      scipy
    ];
    propagatedBuildInputs = with self; [
      numpy
      imread
    ];

    disabled = stdenv.isi686; # Failing tests

    meta = with stdenv.lib; {
      description = "Computer vision package based on numpy";
      homepage = http://mahotas.readthedocs.io/;
      maintainers = with maintainers; [ luispedro ];
      license = licenses.mit;
      platforms = platforms.linux;
    };
  };

  MDP = callPackage ../development/python-modules/mdp {};

  minidb = buildPythonPackage rec {
    name = "minidb-2.0.1";

    src = pkgs.fetchurl {
      url = "https://thp.io/2010/minidb/${name}.tar.gz";
      sha256 = "1x958zr9jc26vaqij451qb9m2l7apcpz34ir9fwfjg4fwv24z2dy";
    };

    meta = {
      description = "A simple SQLite3-based store for Python objects";
      homepage = https://thp.io/2010/minidb/;
      license = stdenv.lib.licenses.isc;
      maintainers = [ stdenv.lib.maintainers.tv ];
    };
  };

  mixpanel = buildPythonPackage rec {
    version = "4.0.2";
    name = "mixpanel-${version}";
    disabled = isPy3k;

    src = pkgs.fetchzip {
      url = "https://github.com/mixpanel/mixpanel-python/archive/${version}.zip";
      sha256 = "0yq1bcsjzsz7yz4rp69izsdn47rvkld4wki2xmapp8gg2s9i8709";
    };

    buildInputs = with self; [ pytest mock ];
    propagatedBuildInputs = with self; [ six ];
    checkPhase = "py.test tests.py";

    meta = {
      homepage = https://github.com/mixpanel/mixpanel-python;
      description = "This is the official Mixpanel Python library. This library
                     allows for server-side integration of Mixpanel.";
      license = stdenv.lib.licenses.asl20;
    };
  };

  mpyq = callPackage ../development/python-modules/mpyq { };

  mxnet = buildPythonPackage rec {
    inherit (pkgs.mxnet) name version src meta;

    buildInputs = [ pkgs.mxnet ];
    propagatedBuildInputs = with self; [ requests numpy graphviz ];

    LD_LIBRARY_PATH = makeLibraryPath [ pkgs.mxnet ];

    doCheck = !isPy3k;

    preConfigure = ''
      cd python
    '';

    postInstall = ''
      rm -rf $out/mxnet
      ln -s ${pkgs.mxnet}/lib/libmxnet.so $out/${python.sitePackages}/mxnet
    '';
  };

  portpicker = callPackage ../development/python-modules/portpicker { };

  pkginfo = buildPythonPackage rec {
    version = "1.3.2";
    name = "pkginfo-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pkginfo/${name}.tar.gz";
      sha256 = "0qg4sq3m0pxvjahc3sncwhw42z5rfw22k0ybskmdqkl2agykay7q";
    };

    doCheck = false; # I don't know why, but with doCheck = true it fails.

    meta = {
      homepage = https://pypi.python.org/pypi/pkginfo;
      license = licenses.mit;
      description = "Query metadatdata from sdists / bdists / installed packages";

      longDescription = ''
        This package provides an API for querying the distutils metadata
        written in the PKG-INFO file inside a source distriubtion (an sdist)
        or a binary distribution (e.g., created by running bdist_egg). It can
        also query the EGG-INFO directory of an installed distribution, and the
        *.egg-info stored in a “development checkout” (e.g, created by running
        setup.py develop).
      '';
    };
  };

  pretend = buildPythonPackage rec {
    name = "pretend-1.0.8";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pretend/pretend-1.0.8.tar.gz";
      sha256 = "0r5r7ygz9m6d2bklflbl84cqhjkc2q12xgis8268ygjh30g2q3wk";
    };

    # No tests in archive
    doCheck = false;

    meta = {
      homepage = https://github.com/alex/pretend;
      license = licenses.bsd3;
    };
  };


  detox = self.buildPythonPackage rec {
    name = "detox-0.10.0";

    buildInputs = with self; [ pytest ];
    propagatedBuildInputs = with self; [ tox py eventlet ];

    src = pkgs.fetchurl {
      url = "mirror://pypi/d/detox/${name}.tar.gz";
      sha256 = "33b704c2a5657366850072fb2aa839df14dd2e692c0c1c2642c3ac30d5c0baec";
    };

    checkPhase = ''
      py.test
    '';

    # eventlet timeout, and broken invokation 3.5
    doCheck = false;

    meta = {
      description = "What is detox?";
      homepage = https://bitbucket.org/hpk42/detox;
    };
  };


  pbkdf2 = buildPythonPackage rec {
    name = "pbkdf2-1.3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pbkdf2/${name}.tar.gz";
      sha256 = "ac6397369f128212c43064a2b4878038dab78dab41875364554aaf2a684e6979";
    };

    # ImportError: No module named test
    doCheck = false;

    meta = {
      maintainers = with maintainers; [ domenkozar ];
    };
  };

  bcrypt = callPackage ../development/python-modules/bcrypt { };

  cffi = callPackage ../development/python-modules/cffi { };

  pycollada = callPackage ../development/python-modules/pycollada { };

  pycontracts = buildPythonPackage rec {
    version = "1.7.9";
    name = "PyContracts-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/P/PyContracts/${name}.tar.gz";
      sha256 = "0rdc9pz08885vqkazjc3lyrrghmf3jzxnlsgpn8akl808x1qrfqf";
    };

    buildInputs = with self; [ nose ];

    propagatedBuildInputs = with self; [ pyparsing decorator six ];

    meta = {
      description = "Allows to declare constraints on function parameters and return values";
      homepage = https://pypi.python.org/pypi/PyContracts;
      license = licenses.lgpl2;
    };
  };

  pycparser = buildPythonPackage rec {
    name = "pycparser-${version}";
    version = "2.14";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pycparser/${name}.tar.gz";
      sha256 = "7959b4a74abdc27b312fed1c21e6caf9309ce0b29ea86b591fd2e99ecdf27f73";
    };

    checkPhase = ''
      ${python.interpreter} -m unittest discover -s tests
    '';

    meta = {
      description = "C parser in Python";
      homepage = https://github.com/eliben/pycparser;
      license = licenses.bsd3;
      maintainers = with maintainers; [ domenkozar ];
    };
  };

  pydub = callPackage ../development/python-modules/pydub {};

  pyjade = buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "pyjade";
    version = "4.0.0";
    src = pkgs.fetchurl {
      url = "mirror://pypi/p/${pname}/${name}.tar.gz";
      sha256 = "1mycn5cc9cp4fb0i2vzgkkk6d0glnkbilggwb4i99i09vr0vg5cd";
    };
    buildInputs = with self; [ pyramid_mako nose django jinja2 tornado pyramid Mako ];
    propagatedBuildInputs = with self; [ six ];
    patchPhase = ''
      sed -i 's/1.4.99/1.99/' setup.py
    '';
    checkPhase = ''
      nosetests pyjade
    '';
    # No tests distributed. https://github.com/syrusakbary/pyjade/issues/262
    doCheck = false;
    meta = {
      description = "Jade syntax template adapter for Django, Jinja2, Mako and Tornado templates";
      homepage    = "http://github.com/syrusakbary/pyjade";
      license     = licenses.mit;
      maintainers = with maintainers; [ nand0p ];
      platforms   = platforms.all;
    };
  };

  PyLD = callPackage ../development/python-modules/PyLD { };

  python-jose = callPackage ../development/python-modules/python-jose {};

  pyhepmc = buildPythonPackage rec {
    name = "pyhepmc-${version}";
    version = "0.5.0";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pyhepmc/${name}.tar.gz";
      sha256 = "1rbi8gqgclfvaibv9kzhfis11gw101x8amc93qf9y08ny4jfyr1d";
    };

    patches = [
      # merge PR https://bitbucket.org/andybuckley/pyhepmc/pull-requests/1/add-incoming-outgoing-generators-for/diff
      ../development/python-modules/pyhepmc_export_edges.patch
      # add bindings to Flow class
      ../development/python-modules/pyhepmc_export_flow.patch
    ];

    # regenerate python wrapper
    preConfigure = ''
      rm hepmc/hepmcwrap.py
      swig -c++ -I${pkgs.hepmc}/include -python hepmc/hepmcwrap.i
    '';

    buildInputs = with pkgs; [ swig hepmc ];

    HEPMCPATH = pkgs.hepmc;

    meta = {
      description = "A simple wrapper on the main classes of the HepMC event simulation representation, making it possible to create, read and manipulate HepMC events from Python code";
      license     = licenses.gpl2;
      maintainers = with maintainers; [ veprbl ];
      platforms   = platforms.all;
    };
  };

  pytest = self.pytest_32;

  pytest_27 = callPackage ../development/python-modules/pytest/2_7.nix {};

  pytest_28 = callPackage ../development/python-modules/pytest/2_8.nix {};

  pytest_29 = callPackage ../development/python-modules/pytest/2_9.nix {};

  pytest_30 = callPackage ../development/python-modules/pytest/3_0.nix {
    hypothesis = self.hypothesis.override {
      # hypothesis requires pytest that causes dependency cycle
      doCheck = false;
      pytest = null;
    };
  };
  pytest_32 = callPackage ../development/python-modules/pytest{
    hypothesis = self.hypothesis.override {
      # hypothesis requires pytest that causes dependency cycle
      doCheck = false;
      pytest = null;
    };
  };

  pytest-httpbin = callPackage ../development/python-modules/pytest-httpbin { };

  pytest-asyncio = callPackage ../development/python-modules/pytest-asyncio { };

  pytestcache = buildPythonPackage rec {
    name = "pytest-cache-1.0";
    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pytest-cache/pytest-cache-1.0.tar.gz";
      sha256 = "1a873fihw4rhshc722j4h6j7g3nj7xpgsna9hhg3zn6ksknnhx5y";
    };

    buildInputs = with self; [ pytest];
    propagatedBuildInputs = with self ; [ execnet ];

    checkPhase = ''
      py.test
    '';

    # Too many failing tests. Are they maintained?
    doCheck = false;

    meta = {
      license = licenses.mit;
      homepage = "https://pypi.python.org/pypi/pytest-cache/";
      description = "pytest plugin with mechanisms for caching across test runs";
    };
  };

  pytest-catchlog = buildPythonPackage rec {
    name = "pytest-catchlog-1.2.2";
    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pytest-catchlog/${name}.zip";
      sha256 = "1w7wxh27sbqwm4jgwrjr9c2gy384aca5jzw9c0wzhl0pmk2mvqab";
    };

    buildInputs = with self; [ pytest ];

    checkPhase = "make test";

    # Requires pytest < 3.1
    doCheck = false;

    meta = {
      license = licenses.mit;
      homepage = https://pypi.python.org/pypi/pytest-catchlog/;
      description = "py.test plugin to catch log messages. This is a fork of pytest-capturelog.";
    };
  };

  pytest-cram = callPackage ../development/python-modules/pytest-cram { };

  pytest-datafiles = callPackage ../development/python-modules/pytest-datafiles { };

  pytest-django = callPackage ../development/python-modules/pytest-django { };

  pytest-fixture-config = buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "pytest-fixture-config";
    version = "1.0.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/${pname}/${name}.tar.gz";
      sha256 = "7d7cc1cb25f88a707f083b1dc2e3c2fdfc6f37709567a2587dd0cd0bcd70edb6";
    };

    buildInputs = with self; [ pytest ];
    propagatedBuildInputs = with self; [ coverage virtualenv pytestcov six ];

    checkPhase = ''
      py.test -k "not test_yield_requires_config_doesnt_skip and not test_yield_requires_config_skips"
    '';

    meta = {
      description = "Simple configuration objects for Py.test fixtures. Allows you to skip tests when their required config variables aren’t set.";
      homepage = https://github.com/manahl/pytest-plugins;
      license = licenses.mit;
      maintainers = with maintainers; [ ryansydnor ];
      platforms   = platforms.all;
    };
  };

  pytest-forked = callPackage ../development/python-modules/pytest-forked { };

  pytest-rerunfailures = buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "pytest-rerunfailures";
    version = "2.0.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/${pname}/${name}.tar.gz";
      sha256 = "1zzxlswbny8dp3c1sbhpyms1xkknxb6qfji3y3azc7gc95324xsv";
    };

    buildInputs = with self; [ pytest ];

    checkPhase = ''
      py.test
    '';

    meta = {
      description = "pytest plugin to re-run tests to eliminate flaky failures.";
      homepage = https://github.com/pytest-dev/pytest-rerunfailures;
      license = licenses.mpl20;
      maintainers = with maintainers; [ jgeerds ];
      platforms = platforms.all;
    };
  };

  pytest-flake8 = callPackage ../development/python-modules/pytest-flake8 { };

  pytestflakes = buildPythonPackage rec {
    name = "pytest-flakes-${version}";
    version = "1.0.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pytest-flakes/${name}.tar.gz";
      sha256 = "9c2271654294020e134624020a2144cb93b7334809d70fb3f470cd31ec788a3a";
    };

    buildInputs = with self; [ pytestpep8 pytest ];
    propagatedBuildInputs = with self; [ pyflakes pytestcache ];

    checkPhase = ''
      py.test test_flakes.py
    '';

    meta = {
      license = licenses.mit;
      homepage = "https://pypi.python.org/pypi/pytest-flakes";
      description = "pytest plugin to check source code with pyflakes";
    };
  };

  pytest-mock = buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "pytest-mock";
    version = "1.6.0";

    buildInputs = with self; [ pytest setuptools_scm ];
    propagatedBuildInputs = with self; [ mock ];

    meta = {
      description = "Thin-wrapper around the mock package for easier use with py.test.";
      homepage    = "https://github.com/pytest-dev/pytest-mock";
      license     = licenses.mit;
      maintainers = with maintainers; [ nand0p ];
      platforms   = platforms.all;
    };

    src = fetchPypi {
      inherit pname version;
      sha256 = "07qccww4bq9jxlc0fbhlspr13kcsixchsnl8vk4wdiyvsjy7r8c3";
    };
  };

  pytest-warnings = callPackage ../development/python-modules/pytest-warnings { };

  pytestpep8 = buildPythonPackage rec {
    name = "pytest-pep8";
    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pytest-pep8/pytest-pep8-1.0.6.tar.gz";
      sha256 = "06032agzhw1i9d9qlhfblnl3dw5hcyxhagn7b120zhrszbjzfbh3";
    };

    buildInputs = with self; [ pytest ];
    propagatedBuildInputs = with self; [ pytestcache pep8 ];

    checkPhase = ''
      py.test
    '';

    # Fails
    doCheck = false;

    meta = {
      license = licenses.mit;
      homepage = "https://pypi.python.org/pypi/pytest-pep8";
      description = "pytest plugin to check PEP8 requirements";
    };
  };

  pytest-pep257 = callPackage ../development/python-modules/pytest-pep257 { };

  pytest-raisesregexp = buildPythonPackage rec {
    name = "pytest-raisesregexp-${version}";
    version = "2.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pytest-raisesregexp/${name}.tar.gz";
      sha256 = "0fde8aac1a54f9b56e5f9c61fda76727542ed24968c27c6e3688c6f1885f1e61";
    };

    buildInputs = with self; [ py pytest ];

    # https://github.com/kissgyorgy/pytest-raisesregexp/pull/3
    prePatch = ''
      sed -i '3i\import io' setup.py
      substituteInPlace setup.py --replace "long_description=open('README.rst').read()," "long_description=io.open('README.rst', encoding='utf-8').read(),"
    '';

    meta = {
      description = "Simple pytest plugin to look for regex in Exceptions";
      homepage = https://github.com/Walkman/pytest_raisesregexp;
      license = with licenses; [ mit ];
    };
  };

  pytestrunner = buildPythonPackage rec {
    version = "2.6.2";
    name = "pytest-runner-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pytest-runner/${name}.tar.gz";
      sha256 = "e775a40ee4a3a1d45018b199c44cc20bbe7f3df2dc8882f61465bb4141c78cdb";
    };

    buildInputs = with self; [setuptools_scm pytest];

    meta = {
      description = "Invoke py.test as distutils command with dependency resolution";
      homepage = https://bitbucket.org/pytest-dev/pytest-runner;
      license = licenses.mit;
    };

    # Trying to run tests fails with # RuntimeError: dictionary changed size during iteration
    doCheck = false;
  };

  pytestquickcheck = buildPythonPackage rec {
    name = "pytest-quickcheck-0.8.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pytest-quickcheck/pytest-quickcheck-0.8.2.tar.gz";
      sha256 = "047w4zwdsnlzmsc5f3rapzbzd2frlvz9nnp8v4b48fjmqmxassh3";
    };

    buildInputs = with self; [ pytest ];
    propagatedBuildInputs = with self; [ pytestflakes pytestpep8 tox ];

    meta = {
      license = licenses.asl20;
      homepage = "https://pypi.python.org/pypi/pytest-quickcheck";
      description = "pytest plugin to generate random data inspired by QuickCheck";
    };
  };

  pytest-server-fixtures = buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "pytest-server-fixtures";
    version = "1.1.0";

    buildInputs = with self; [ pytest ];
    propagatedBuildInputs = with self; [ setuptools-git pytest-shutil pytest-fixture-config psutil requests ];

    meta = {
      description = "Extensible server fixures for py.test";
      homepage    = "https://github.com/manahl/pytest-plugins";
      license     = licenses.mit;
      maintainers = with maintainers; [ nand0p ];
      platforms   = platforms.all;
    };

    doCheck = false;
    # RuntimeError: Unable to find a free server number to start Xvfb

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/${pname}/${name}.tar.gz";
      sha256 = "1gs9qimcn8q6xi9d6i5624l0dziwvn6nj2rda07fg15g1cq66s8l";
    };
  };

  pytest-shutil = buildPythonPackage rec {
    name = "pytest-shutil-${version}";
    version = "1.2.8";
    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pytest-shutil/${name}.tar.gz";
      sha256 = "924accaec3f3781416139e580386ab4f849cb8662bc1072405a81d3a5e56bf3d";
    };
    buildInputs = with self; [ cmdline pytest ];
    propagatedBuildInputs = with self; [ pytestcov coverage setuptools-git mock pathpy execnet contextlib2 ];
    meta = {
      description = "A goodie-bag of unix shell and environment tools for py.test";
      homepage = https://github.com/manahl/pytest-plugins;
      maintainers = with maintainers; [ ryansydnor ];
      platforms   = platforms.all;
      license = licenses.mit;
    };

    checkPhase = ''
      py.test
    '';
  };

  pytestcov = buildPythonPackage rec {
    name = "pytest-cov-2.4.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pytest-cov/${name}.tar.gz";
      sha256 = "03c2qc42r4bczyw93gd7n0qi1h1jfhw7fnbhi33c3vp1hs81gm2k";
    };

   buildInputs = with self; [ pytest pytest_xdist virtualenv process-tests ];
   propagatedBuildInputs = with self; [ coverage ];

   # xdist related tests fail with the following error
   # OSError: [Errno 13] Permission denied: 'py/_code'
   doCheck = false;
   checkPhase = ''
     # allow to find the module helper during the test run
     export PYTHONPATH=$PYTHONPATH:$PWD/tests
     py.test tests
   '';

    meta = {
      description = "Plugin for coverage reporting with support for both centralised and distributed testing, including subprocesses and multiprocessing";
      homepage = https://github.com/pytest-dev/pytest-cov;
      license = licenses.mit;
    };
  };

  pytest-expect = callPackage ../development/python-modules/pytest-expect { };

  pytest-virtualenv = buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "pytest-virtualenv";
    version = "1.2.7";
    src = pkgs.fetchurl {
      url = "mirror://pypi/p/${pname}/${name}.tar.gz";
      sha256 = "51fb6468670624b2315aecaf1a2bbd698509e3ea6a1e28b094984c45e1376755";
    };
    buildInputs = with self; [ pytest pytestcov mock cmdline ];
    propagatedBuildInputs = with self; [ pytest-fixture-config pytest-shutil ];
    checkPhase = '' py.test tests/unit '';
    meta = {
      description = "Create a Python virtual environment in your test that cleans up on teardown. The fixture has utility methods to install packages and list what’s installed.";
      homepage = https://github.com/manahl/pytest-plugins;
      license = licenses.mit;
      maintainers = with maintainers; [ ryansydnor ];
      platforms   = platforms.all;
    };
  };

  pytest_xdist = callPackage ../development/python-modules/pytest-xdist { };

  pytest-localserver = callPackage ../development/python-modules/pytest-localserver { };

  pytest-subtesthack = buildPythonPackage rec {
    name = "pytest-subtesthack-${version}";
    version = "0.1.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pytest-subtesthack/${name}.tar.gz";
      sha256 = "15kzcr5pchf3id4ikdvlv752rc0j4d912n589l4rifp8qsj19l1x";
    };

    buildInputs = with self; [ pytest ];

    # no upstream test
    doCheck = false;

    meta = {
      description = "Terrible plugin to set up and tear down fixtures within the test function itself";
      homepage = https://github.com/untitaker/pytest-subtesthack;
      license = licenses.publicDomain;
    };
  };

  pytest-sugar = callPackage ../development/python-modules/pytest-sugar { };

  tinycss = buildPythonPackage rec {
    name = "tinycss-${version}";
    version = "0.3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/tinycss/${name}.tar.gz";
      sha256 = "1pichqra4wk86142hqgvy9s5x6c5k5zhy8l9qxr0620pqk8spbd4";
    };

    buildInputs = with self; [ pytest ];

    propagatedBuildInputs = with self; [ cssutils ];

    checkPhase = ''
      py.test $out/${python.sitePackages}
    '';

    # Disable Cython tests for PyPy
    TINYCSS_SKIP_SPEEDUPS_TESTS = optional isPyPy true;

    meta = {
      description = "Complete yet simple CSS parser for Python";
      license = licenses.bsd3;
      homepage = http://pythonhosted.org/tinycss/;
    };
  };


  cssselect = buildPythonPackage rec {
    name = "cssselect-${version}";
    version = "0.9.1";
    src = pkgs.fetchurl {
      url = "mirror://pypi/c/cssselect/${name}.tar.gz";
      sha256 = "10h623qnp6dp1191jri7lvgmnd4yfkl36k9smqklp1qlf3iafd85";
    };
    # AttributeError: 'module' object has no attribute 'tests'
    doCheck = false;
  };

  cssutils = buildPythonPackage (rec {
    name = "cssutils-1.0.1";

    src = pkgs.fetchurl {
      url = mirror://pypi/c/cssutils/cssutils-1.0.1.tar.gz;
      sha256 = "0qwha9x1wml2qmipbcz03gndnlwhzrjdvw9i09si247a90l8p8fq";
    };

    buildInputs = with self; [ self.mock ];

    # couple of failing tests
    doCheck = false;

    meta = {
      description = "A Python package to parse and build CSS";

      homepage = http://code.google.com/p/cssutils/;

      license = licenses.lgpl3Plus;
    };
  });

  darcsver = buildPythonPackage (rec {
    name = "darcsver-1.7.4";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/d/darcsver/${name}.tar.gz";
      sha256 = "1yb1c3jxqvy4r3qiwvnb86qi5plw6018h15r3yk5ji3nk54qdcb6";
    };

    buildInputs = with self; [ self.mock ];

    # Note: We don't actually need to provide Darcs as a build input.
    # Darcsver will DTRT when Darcs isn't available.  See news.gmane.org
    # http://thread.gmane.org/gmane.comp.file-systems.tahoe.devel/3200 for a
    # discussion.

    # AttributeError: 'module' object has no attribute 'test_darcsver'
    doCheck = false;

    meta = {
      description = "Darcsver, generate a version number from Darcs history";

      homepage = https://pypi.python.org/pypi/darcsver;

      license = "BSD-style";
    };
  });

  dask = callPackage ../development/python-modules/dask { };

  datrie = buildPythonPackage rec {
    name = "datrie";
    version = "0.7.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/d/datrie/datrie-${version}.tar.gz";
      sha256 = "08r0if7dry2q7p34gf7ffyrlnf4bdvnprxgydlfxgfnvq8f3f4bs";
    };

    buildInputs = with self; [ pytest pytestrunner hypothesis ];
    meta = {
      description = "Super-fast, efficiently stored Trie for Python";
      homepage = "https://github.com/kmike/datrie";
      license = licenses.lgpl2;
      maintainers = with maintainers; [ lewo ];
    };
  };

  heapdict = buildPythonPackage rec {
    name = "HeapDict-${version}";
    version = "1.0.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/H/HeapDict/${name}.tar.gz";
      sha256 = "0nhvxyjq6fp6zd7jzmk5x4fg6xhakqx9lhkp5yadzkqn0rlf7ja0";
    };
    doCheck = !isPy3k;
    meta = {
      description = "a heap with decrease-key and increase-key operations.";
      homepage = http://stutzbachenterprises.com;
      license = licenses.bsd3;
      maintainers = with maintainers; [ teh ];
    };
  };

  zict = buildPythonPackage rec {

    name = "zict-${version}";
    version = "0.1.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/z/zict/${name}.tar.gz";
      sha256 = "12h95vbkbar1hc6cr1kpr6zr486grj3mpx4lznvmnai0iy6pbqp4";
    };

    buildInputs = with self; [ pytest ];
    propagatedBuildInputs = with self; [ heapdict ];

    meta = {
      description = "Mutable mapping tools.";
      homepage = https://github.com/dask/zict;
      license = licenses.bsd3;
      maintainers = with maintainers; [ teh ];
    };
  };

  distributed = buildPythonPackage rec {

    name = "distributed-${version}";
    version = "1.15.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/d/distributed/${name}.tar.gz";
      sha256 = "037a07sdf2ch1d360nqwqz3b4ld8msydng7mw4i5s902v7xr05l6";
    };

    buildInputs = with self; [ pytest docutils ];
    propagatedBuildInputs = with self; [
      dask six boto3 s3fs tblib locket msgpack click cloudpickle tornado
      psutil botocore zict lz4 sortedcollections sortedcontainers
    ] ++ (if !isPy3k then [ singledispatch ] else []);

    # py.test not picking up local config file, even when running
    # manually: E ValueError: no option named '--runslow'
    doCheck = false;

    meta = {
      description = "Distributed computation in Python.";
      homepage = "http://distributed.readthedocs.io/en/latest/";
      license = licenses.bsd3;
      maintainers = with maintainers; [ teh ];
    };
  };

  digital-ocean = buildPythonPackage rec {
    name = "python-digitalocean-1.10.1";

    propagatedBuildInputs = with self; [ requests ];

    # Package doesn't distribute tests.
    doCheck = false;

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/python-digitalocean/${name}.tar.gz";
      sha256 = "12qybflfnl08acspz7rpaprmlabgrzimacbd7gm9qs5537hl3qnp";
    };

    meta = {
      description = "digitalocean.com API to manage Droplets and Images";
      homepage = https://pypi.python.org/pypi/python-digitalocean;
      license = licenses.lgpl3;
      maintainers = with maintainers; [ teh ];
    };
  };

  leather = callPackage ../development/python-modules/leather { };

  libais = callPackage ../development/python-modules/libais { };

  libtmux = callPackage ../development/python-modules/libtmux { };

  linuxfd = callPackage ../development/python-modules/linuxfd { };

  locket = buildPythonPackage rec {
    name = "locket-${version}";
    version = "0.2.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/l/locket/${name}.tar.gz";
      sha256 = "1d4z2zngrpqkrfhnd4yhysh66kjn4mblys2l06sh5dix2p0n7vhz";
    };

    buildInputs = with self; [ pytest ];
    propagatedBuildInputs = with self; [  ];

    # weird test requirements (spur.local>=0.3.7,<0.4)
    doCheck = false;

    meta = {
      description = "Locket implements a lock that can be used by multiple processes provided they use the same path.";
      homepage = "https://github.com/mwilliamson/locket.py";
      license = licenses.bsd2;
      maintainers = with maintainers; [ teh ];
    };
  };

  tblib = buildPythonPackage rec {
    name = "tblib-${version}";
    version = "1.3.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/tblib/${name}.tar.gz";
      sha256 = "02iahfkfa927hb4jq2bak36ldihwapzacfiq5lyxg8llwn98a1yi";
    };

    meta = {
      description = "Traceback fiddling library. Allows you to pickle tracebacks.";
      homepage = "https://github.com/ionelmc/python-tblib";
      license = licenses.bsd2;
      maintainers = with maintainers; [ teh ];
    };
  };

  s3fs = buildPythonPackage rec {
    name = "s3fs-${version}";
    version = "0.0.8";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/s3fs/${name}.tar.gz";
      sha256 = "0zbdzqrim0zig94fk1hswg4vfdjplw6jpx3pdi42qc830h0nscn8";
    };

    buildInputs = with self; [ docutils ];
    propagatedBuildInputs = with self; [ boto3 ];

    # Depends on `moto` which has a long dependency chain with exact
    # version requirements that can't be made to work with current
    # pythonPackages.
    doCheck = false;

    meta = {
      description = "S3FS builds on boto3 to provide a convenient Python filesystem interface for S3.";
      homepage = "http://github.com/dask/s3fs/";
      license = licenses.bsd3;
      maintainers = with maintainers; [ teh ];
    };
  };

  datashape = callPackage ../development/python-modules/datashape { };

  requests-cache = buildPythonPackage (rec {
    name = "requests-cache-${version}";
    version = "0.4.13";

    src = pkgs.fetchurl {
      url = "mirror://pypi/r/requests-cache/${name}.tar.gz";
      sha256 = "18jpyivnq5pjbkymk3i473rihpj2bgikafpha7xvr6w736hiqmpy";
    };

    buildInputs = with self; [ mock ];

    propagatedBuildInputs = with self; [ requests six urllib3 ];

    meta = {
      description = "Persistent cache for requests library";
      homepage = https://pypi.python.org/pypi/requests-cache;
      license = licenses.bsd3;
    };
  });

  howdoi = buildPythonPackage (rec {
    name = "howdoi-${version}";
    version = "1.1.7";

    src = pkgs.fetchurl {
      url = "mirror://pypi/h/howdoi/${name}.tar.gz";
      sha256 = "df4e49a219872324875d588e7699a1a82174a267e8487505e86bfcb180aea9b7";
    };

    propagatedBuildInputs = with self; [ self.six requests-cache pygments pyquery ];

    meta = {
      description = "Instant coding answers via the command line";
      homepage = https://pypi.python.org/pypi/howdoi;
      license = licenses.mit;
    };
  });

  nose-parameterized = buildPythonPackage (rec {
    name = "nose-parameterized-${version}";
    version = "0.5.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/n/nose-parameterized/${name}.tar.gz";
      sha256 = "a11c41b0cf8218e7cdc19ab7a1bdf5c141d161cd2350daee819473cc63cd0685";
    };

    # Tests require some python3-isms but code works without.
    doCheck = isPy3k;

    LC_ALL = "en_US.UTF-8";
    buildInputs = with self; [ nose pkgs.glibcLocales ];
    propagatedBuildInputs = with self; [ self.six ];

    checkPhase = ''
      nosetests -v
    '';


    meta = {
      description = "Parameterized testing with any Python test framework";
      homepage = https://pypi.python.org/pypi/nose-parameterized;
      license = licenses.bsd3;
    };
  });

  neurotools = buildPythonPackage (rec {
    name = "NeuroTools-${version}";
    version = "0.3.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/N/NeuroTools/${name}.tar.gz";
      sha256 = "0ly6qa87l3afhksab06vp1iimlbm1kdnsw98mxcnpzz9q07l4nd4";
    };

    disabled = isPy3k;

    # Tests are not automatically run
    # Many tests fail (using py.test), and some need R
    doCheck = false;

    propagatedBuildInputs = with self; [
      scipy
      numpy
      matplotlib
      tables
      pyaml
      urllib3
      rpy2
      mpi4py
    ];

    meta = {
      description = "Collection of tools to support analysis of neural activity";
      homepage = https://pypi.python.org/pypi/NeuroTools;
      license = licenses.gpl2;
      maintainers = with maintainers; [ nico202 ];
    };
  });

  jdatetime = buildPythonPackage (rec {
    name = "jdatetime-${version}";
    version = "1.7.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/j/jdatetime/${name}.tar.gz";
      sha256 = "c08ba5791c2350b26e87ddf478bf223108146e241b6c949538221b54afd633ac";
    };

    propagatedBuildInputs = with self; [ self.six ];

    meta = {
      description = "Jalali datetime binding for python";
      homepage = https://pypi.python.org/pypi/jdatetime;
      license = licenses.psfl;
    };
  });

  daphne = callPackage ../development/python-modules/daphne { };

  dateparser = buildPythonPackage rec {
    name = "dateparser-${version}";
    version = "0.3.2-pre-2016-01-21"; # Fix assert year 2016 == 2015

    src = pkgs.fetchgit {
      url = "https://github.com/scrapinghub/dateparser.git";
      rev = "d20a63f1d1cee5b4bd19c9f745774cfa9f219549";
      sha256 = "0na7b4hvf7vykrk48482gxiq5xny67rvs8ilamxcxw3y9gfgdjfd";
    };

    # Does not seem to work on Python 3 because of relative import.
    # Upstream Travis configuration is wrong and tests only 2.7
    disabled = isPy3k;

    LC_ALL = "en_US.UTF-8";

    buildInputs = with self; [ nose nose-parameterized mock pkgs.glibcLocales ];

    propagatedBuildInputs = with self; [ six jdatetime pyyaml dateutil umalqurra pytz ];

    meta = {
      description = "Date parsing library designed to parse dates from HTML pages";
      homepage = https://pypi.python.org/pypi/dateparser;
      license = licenses.bsd3;
      broken = true;
    };
  };

  # Actual name of package
  python-dateutil = callPackage ../development/python-modules/dateutil { };
  # Alias that we should deprecate
  dateutil = self.python-dateutil;

  # Buildbot 0.8.7p1 needs dateutil==1.5
  dateutil_1_5 = buildPythonPackage (rec {
    name = "dateutil-1.5";

    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/python-dateutil/python-${name}.tar.gz";
      sha256 = "02dhw57jf5kjcp7ng1if7vdrbnlpb9yjmz7wygwwvf3gni4766bg";
    };

    propagatedBuildInputs = with self; [ self.six ];

    meta = {
      description = "Powerful extensions to the standard datetime module";
      homepage = https://pypi.python.org/pypi/python-dateutil;
      license = "BSD-style";
    };
  });

  ddar = buildPythonPackage {
    name = "ddar-1.0";

    src = pkgs.fetchurl {
      url = "https://github.com/basak/ddar/archive/v1.0.tar.gz";
      sha256 = "08lv7hrbhcv6hbl01sx8fgx3l8s2nn8rvcicdidafwm87bvi2nmr";
    };

    preBuild = ''
      make -f Makefile.prep synctus/ddar_pb2.py
    '';

    propagatedBuildInputs = with self; [ protobuf ];

    meta = {
      description = "Unix de-duplicating archiver";
      license = licenses.gpl3;
      homepage = https://github.com/basak/ddar;
    };
  };

  decorator = buildPythonPackage rec {
    name = "decorator-${version}";
    version = "4.0.11";

    src = pkgs.fetchurl {
      url = "mirror://pypi/d/decorator/${name}.tar.gz";
      sha256 = "953d6bf082b100f43229cf547f4f97f97e970f5ad645ee7601d55ff87afdfe76";
    };

    meta = {
      homepage = https://pypi.python.org/pypi/decorator;
      description = "Better living through Python with decorators";
      license = licenses.mit;
    };
  };

  deform = buildPythonPackage rec {
    name = "deform-2.0a2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/d/deform/${name}.tar.gz";
      sha256 = "3fa4d287c8da77a83556e4a5686de006ddd69da359272120b915dc8f5a70cabd";
    };

    buildInputs = with self; [] ++ optional isPy26 unittest2;

    propagatedBuildInputs =
      [ self.beautifulsoup4
        self.peppercorn
        self.colander
        self.translationstring
        self.chameleon
        self.zope_deprecation
        self.coverage
        self.nose
      ];

    meta = {
      maintainers = with maintainers; [ garbas domenkozar ];
      platforms = platforms.all;
    };
  };

  derpconf = self.buildPythonPackage rec {
    name = "derpconf-0.4.9";

    propagatedBuildInputs = with self; [ six ];

    src = pkgs.fetchurl {
      url = "mirror://pypi/d/derpconf/${name}.tar.gz";
      sha256 = "9129419e3a6477fe6366c339d2df8c614bdde82a639f33f2f40d4de9a1ed236a";
    };

    meta = {
      description = "derpconf abstracts loading configuration files for your app";
      homepage = https://github.com/globocom/derpconf;
      license = licenses.mit;
    };
  };

  deskcon = self.buildPythonPackage rec {
    name = "deskcon-0.3";
    disabled = !isPy27;

    src = pkgs.fetchFromGitHub {
      owner= "screenfreeze";
      repo = "deskcon-desktop";
      rev = "267804122188fa79c37f2b21f54fe05c898610e6";
      sha256 ="0i1dd85ls6n14m9q7lkympms1w3x0pqyaxvalq82s4xnjdv585j3";
    };

    phases = [ "unpackPhase" "installPhase" ];

    pythonPath = [ self.pyopenssl pkgs.gtk3 ];

    installPhase = ''
      substituteInPlace server/deskcon-server --replace "python2" "python"

      mkdir -p $out/bin
      mkdir -p $out/lib/${python.libPrefix}/site-packages
      cp -r "server/"* $out/lib/${python.libPrefix}/site-packages
      mv $out/lib/${python.libPrefix}/site-packages/deskcon-server $out/bin/deskcon-server

      wrapPythonProgramsIn $out/bin "$out $pythonPath"
    '';

    meta = {
      description = "Integrates an Android device into a desktop";
      homepage = https://github.com/screenfreeze/deskcon-desktop;
      license = licenses.gpl3;
    };
  };


  dill = callPackage ../development/python-modules/dill { };

  discogs_client = callPackage ../development/python-modules/discogs_client { };

  dns = callPackage ../development/python-modules/dns { };

  docker = callPackage ../development/python-modules/docker {};

  dockerpty = buildPythonPackage rec {
    name = "dockerpty-0.4.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/d/dockerpty/${name}.tar.gz";
      sha256 = "1kjn64wx23jmr8dcc6g7bwlmrhfmxr77gh6iphqsl39sayfxdab9";
    };

    propagatedBuildInputs = with self; [ six ];

    meta = {
      description = "Functionality needed to operate the pseudo-tty (PTY) allocated to a docker container";
      homepage = https://github.com/d11wtq/dockerpty;
      license = licenses.asl20;
    };
  };

  docker_pycreds = buildPythonPackage rec {
    name = "docker-pycreds-${version}";
    version = "0.2.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/d/docker-pycreds/${name}.tar.gz";
      sha256 = "0j3k5wk3bww5y0f2rvgzsin0q98k0i9j308vpsmxidw0y8n3m0wk";
    };

    doCheck = false; # require docker-credential-helpers binaries

    propagatedBuildInputs = with self; [
      six
    ];

    meta = {
      description = "Python bindings for the docker credentials store API.";
      homepage = https://github.com/shin-/dockerpy-creds;
      license = licenses.asl20;
    };
  };

  docker_registry_core = buildPythonPackage rec {
    name = "docker-registry-core-2.0.3";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/d/docker-registry-core/${name}.tar.gz";
      sha256 = "347e804f1f35b28dbe27bf8d7a0b630fca29d684032139bf26e3940572360360";
    };

    DEPS = "loose";

    doCheck = false;
    propagatedBuildInputs = with self; [
      boto redis setuptools simplejson
    ];

    patchPhase = "> requirements/main.txt";

    meta = {
      description = "Docker registry core package";
      homepage = https://github.com/docker/docker-registry;
      license = licenses.asl20;
    };
  };

  docker_registry = buildPythonPackage rec {
    name = "docker-registry-0.9.1";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/d/docker-registry/${name}.tar.gz";
      sha256 = "1svm1h59sg4bwj5cy10m016gj0xpiin15nrz5z66h47sbkndvlw3";
    };

    DEPS = "loose";

    doCheck = false; # requires redis server
    propagatedBuildInputs = with self; [
      setuptools docker_registry_core blinker flask gevent gunicorn pyyaml
      requests rsa sqlalchemy setuptools backports_lzma m2crypto
    ];

    patchPhase = "> requirements/main.txt";

    # Default config uses needed env variables
    postInstall = ''
      ln -s $out/lib/python2.7/site-packages/config/config_sample.yml $out/lib/python2.7/site-packages/config/config.yml
    '';

    meta = {
      description = "Docker registry core package";
      homepage = https://github.com/docker/docker-registry;
      license = licenses.asl20;
    };
  };

  docopt = buildPythonPackage rec {
    name = "docopt-0.6.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/d/docopt/${name}.tar.gz";
      sha256 = "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491";
    };

    meta = {
      description = "Pythonic argument parser, that will make you smile";
      homepage = http://docopt.org/;
      license = licenses.mit;
    };
  };

  doctest-ignore-unicode = buildPythonPackage rec {
    name = "doctest-ignore-unicode-${version}";
    version = "0.1.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/d/doctest-ignore-unicode/${name}.tar.gz";
      sha256= "fc90b2d0846477285c6b67fc4cb4d6f39fcf76d8752f4df0a241486f31512ad5";
    };

    propagatedBuildInputs = with self; [ nose ];

    meta = {
      description = "Add flag to ignore unicode literal prefixes in doctests";
      license = with licenses; [ asl20 ];
      homepage = https://github.com/gnublade/doctest-ignore-unicode;
    };
  };

  dogpile_cache = callPackage ../development/python-modules/dogpile.cache { };

  dogpile_core = buildPythonPackage rec {
    name = "dogpile.core-0.4.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/d/dogpile.core/dogpile.core-0.4.1.tar.gz";
      sha256 = "be652fb11a8eaf66f7e5c94d418d2eaa60a2fe81dae500f3743a863cc9dbed76";
    };

    doCheck = false;

    meta = {
      description = "A 'dogpile' lock, typically used as a component of a larger caching solution";
      homepage = https://bitbucket.org/zzzeek/dogpile.core;
      license = licenses.bsd3;
    };
  };

  dopy = buildPythonPackage rec {
    version = "2016-01-04";
    name = "dopy-${version}";

    src = pkgs.fetchFromGitHub {
      owner = "Wiredcraft";
      repo = "dopy";
      rev = "cb443214166a4e91b17c925f40009ac883336dc3";
      sha256 ="0ams289qcgna96aak96jbz6wybs6qb95h2gn8lb4lmx2p5sq4q56";
    };

    propagatedBuildInputs = with self; [ requests six ];

    meta = {
      description = "Digital Ocean API python wrapper";
      homepage = "https://github.com/Wiredcraft/dopy";
      license = licenses.mit;
      maintainers = with maintainers; [ lihop ];
      platforms = platforms.all;
    };
  };

  dpkt = callPackage ../development/python-modules/dpkt {};

  urllib3 = callPackage ../development/python-modules/urllib3 {};

  dropbox = buildPythonPackage rec {
    name = "dropbox-${version}";
    version = "8.0.0";
    doCheck = false; # Set DROPBOX_TOKEN environment variable to a valid token.

    src = pkgs.fetchurl {
      url = "mirror://pypi/d/dropbox/${name}.tar.gz";
      sha256 = "0bixx80zjq0286dwm4zhg8bdhc8pqlrqy4n2jg7i6m6a4gv4gak5";
    };

    buildInputs = with self; [ pytestrunner ];
    propagatedBuildInputs = with self; [ requests urllib3 mock setuptools ];

    meta = {
      description = "A Python library for Dropbox's HTTP-based Core and Datastore APIs";
      homepage = https://www.dropbox.com/developers/core/docs;
      license = licenses.mit;
    };
  };

  ds4drv = callPackage ../development/python-modules/ds4drv {
    inherit (pkgs) fetchFromGitHub bluez;
  };

  dyn = callPackage ../development/python-modules/dyn { };

  easydict = callPackage ../development/python-modules/easydict { };

  EasyProcess = buildPythonPackage rec {
    name = "EasyProcess-0.2.3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/E/EasyProcess/${name}.tar.gz";
      sha256 = "94e241cadc9a46f55b5c06000df85618849602e7e1865b8de87576b90a22e61f";
    };

    # No tests
    doCheck = false;

    meta = {
      description = "Easy to use python subprocess interface";
      homepage = "https://github.com/ponty/EasyProcess";
      license = licenses.bsdOriginal;
      maintainers = with maintainers; [ layus ];
    };
  };

  easy-thumbnails = callPackage ../development/python-modules/easy-thumbnails { };

  eccodes = if (isPy27) then
      (pkgs.eccodes.overrideAttrs (oldattrs: {
    name = "${python.libPrefix}-" + oldattrs.name;
  })).override {
    enablePython = true;
    pythonPackages = self;
  } else throw "eccodes not supported for interpreter ${python.executable}";

  EditorConfig = buildPythonPackage rec {
    name = "EditorConfig-${version}";
    version = "0.12.0";

    # fetchgit used to ensure test submodule is available
    src = pkgs.fetchgit {
      url = "https://github.com/editorconfig/editorconfig-core-py";
      rev = "refs/tags/v${version}";
      sha256 = "0svk7id7ncygj2rnxhm7602xizljyidk4xgrl6i0xgq3829cz4bl";
    };

    buildInputs = [ pkgs.cmake ];
    checkPhase = ''
      cmake .
      # utf_8_char fails with python3
      ctest -E "utf_8_char" .
    '';

    meta = {
      homepage = "http://editorconfig.org";
      description = "EditorConfig File Locator and Interpreter for Python";
      license = stdenv.lib.licenses.psfl;
    };
  };

  edward = callPackage ../development/python-modules/edward { };

  elasticsearch = buildPythonPackage (rec {
    name = "elasticsearch-1.9.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/e/elasticsearch/${name}.tar.gz";
      sha256 = "091s60ziwhyl9kjfm833i86rcpjx46v9h16jkgjgkk5441dln3gb";
    };

    # Check is disabled because running them destroy the content of the local cluster!
    # https://github.com/elasticsearch/elasticsearch-py/tree/master/test_elasticsearch
    doCheck = false;
    propagatedBuildInputs = with self; [ urllib3 requests ];
    buildInputs = with self; [ nosexcover mock ];

    meta = {
      description = "Official low-level client for Elasticsearch";
      homepage = https://github.com/elasticsearch/elasticsearch-py;
      license = licenses.asl20;
      maintainers = with maintainers; [ desiderius ];
    };
  });


  elasticsearchdsl = buildPythonPackage (rec {
    name = "elasticsearch-dsl-0.0.9";

    src = pkgs.fetchurl {
      url = "mirror://pypi/e/elasticsearch-dsl/${name}.tar.gz";
      sha256 = "1gdcdshk881vy18p0czcmbb3i4s5hl8llnfg6961b6x7jkvhihbj";
    };

    buildInputs = with self; [ covCore dateutil elasticsearch mock pytest pytestcov unittest2 urllib3 pytz ];

    # ImportError: No module named test_elasticsearch_dsl
    # Tests require a local instance of elasticsearch
    doCheck = false;

    meta = {
      description = "Python client for Elasticsearch";
      homepage = https://github.com/elasticsearch/elasticsearch-dsl-py;
      license = licenses.asl20;
      maintainers = with maintainers; [ desiderius ];
    };
  });

  entrypoints = callPackage ../development/python-modules/entrypoints { };

  enzyme = callPackage ../development/python-modules/enzyme {};

  escapism = buildPythonPackage rec {
    name = "escapism-${version}";
    version = "0.0.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/e/escapism/${name}.tar.gz";
      sha256 = "1yfyxwxb864xrmrrqgp85xgsh4yrrq5mmzvkdg19jwr7rm6sqx9p";
    };

    # No tests distributed
    doCheck = false;

    meta = {
      description = "Simple, generic API for escaping strings";
      homepage = "https://github.com/minrk/escapism";
      license = licenses.mit;
      maintainers = with maintainers; [ bzizou ];
    };
  };

  etcd = buildPythonPackage rec {
    name = "etcd-${version}";
    version = "2.0.8";

    # PyPI package is incomplete
    src = pkgs.fetchurl {
      url = "https://github.com/dsoprea/PythonEtcdClient/archive/${version}.tar.gz";
      sha256 = "0fi6rxa1yxvz7nwrc7dw6fax3041d6bj3iyhywjgbkg7nadi9i8v";
    };

    patchPhase = ''
      sed -i -e '13,14d;37d' setup.py
    '';

    propagatedBuildInputs = with self; [ simplejson pytz requests ];

    # No proper tests are available
    doCheck = false;

    meta = {
      description = "A Python etcd client that just works";
      homepage = https://github.com/dsoprea/PythonEtcdClient;
      license = licenses.gpl2;
    };
  };

  evdev = buildPythonPackage rec {
    version = "0.6.4";
    name = "evdev-${version}";
    disabled = isPy34;  # see http://bugs.python.org/issue21121

    src = pkgs.fetchurl {
      url = "mirror://pypi/e/evdev/${name}.tar.gz";
      sha256 = "1wkag91s8j0f45jx5n619z354n8pz8in9krn81hp7hlkhi6p8s2j";
    };

    buildInputs = with self; [ pkgs.linuxHeaders ];

    patchPhase = "sed -e 's#/usr/include/linux/#${pkgs.linuxHeaders}/include/linux/#g' -i setup.py";

    doCheck = false;

    meta = {
      description = "Provides bindings to the generic input event interface in Linux";
      homepage = http://pythonhosted.org/evdev;
      license = licenses.bsd3;
      maintainers = with maintainers; [ goibhniu ];
      platforms = platforms.linux;
    };
  };

  eve = callPackage ../development/python-modules/eve {};

  eventlib = buildPythonPackage rec {
    pname = "python-eventlib";
    name = "${pname}-${version}";
    version = "0.2.2";

    # Judging from SyntaxError
    disabled = isPy3k;

    src = pkgs.fetchdarcs {
      url = "http://devel.ag-projects.com/repositories/${pname}";
      rev = "release-${version}";
      sha256 = "1zxhpq8i4jwsk7wmfncqfm211hqikj3hp38cfv509924bi76wak8";
    };

    propagatedBuildInputs = with self; [ greenlet ];

    meta = {
      description = "Eventlib bindings for python";
      homepage    = "http://ag-projects.com/";
      license     = licenses.lgpl2;
      platforms   = platforms.all;
    };
  };

  events = buildPythonPackage rec {
    name = "Events-${version}";
    version = "0.2.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/E/Events/${name}.tar.gz";
      sha256 = "0rymyfvarjdi2fdhfz2iqmp4wgd2n2sm0p2mx44c3spm7ylnqzqa";
    };

    meta = {
      homepage = "http://events.readthedocs.org";
      description = "Bringing the elegance of C# EventHanlder to Python";
      license = licenses.bsd3;
    };
  };


  eyeD3 = buildPythonPackage rec {
    version = "0.7.8";
    name    = "eyeD3-${version}";
    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "http://eyed3.nicfit.net/releases/${name}.tar.gz";
      sha256 = "1nv7nhfn1d0qm7rgkzksbccgqisng8klf97np0nwaqwd5dbmdf86";
    };

    buildInputs = with self; [ paver ];

    postInstall = ''
      for prog in "$out/bin/"*; do
        wrapProgram "$prog" --prefix PYTHONPATH : "$PYTHONPATH" \
                            --prefix PATH : ${python}/bin
      done
    '';

    meta = {
      description = "A Python module and command line program for processing ID3 tags";
      homepage    = http://eyed3.nicfit.net/;
      license     = licenses.gpl2;
      maintainers = with maintainers; [ lovek323 ];
      platforms   = platforms.unix;

      longDescription = ''
        eyeD3 is a Python module and command line program for processing ID3
        tags. Information about mp3 files (i.e bit rate, sample frequency, play
        time, etc.) is also provided. The formats supported are ID3 v1.0/v1.1
        and v2.3/v2.4.
      '';
    };
  };

  execnet = buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "execnet";
    version = "1.4.1";
    src = pkgs.fetchurl {
      url = "mirror://pypi/e/${pname}/${name}.tar.gz";
      sha256 = "1rpk1vyclhg911p3hql0m0nrpq7q7mysxnaaw6vs29cpa6kx8vgn";
    };
    buildInputs = with self; [ pytest setuptools_scm ];
    propagatedBuildInputs = with self; [ apipkg ];
    # remove vbox tests
    postPatch = ''
      rm -v testing/test_termination.py
      rm -v testing/test_channel.py
      rm -v testing/test_xspec.py
      rm -v testing/test_gateway.py
    '';
    checkPhase = ''
      py.test testing
    '';
    meta = {
      description = "Rapid multi-Python deployment";
      license = licenses.gpl2;
      homepage = "http://codespeak.net/execnet";
      maintainers = with maintainers; [ nand0p ];
    };
  };

  ezdxf = callPackage ../development/python-modules/ezdxf {};

  facebook-sdk = buildPythonPackage rec {
    name = "facebook-sdk-0.4.0";

    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/f/facebook-sdk/facebook-sdk-0.4.0.tar.gz";
      sha256 = "5a96c54d06213039dff1fe1fabc51972e394666cd6d83ea70f7c2e67472d9b72";
    };

    meta = with pkgs.stdenv.lib; {
      description = "Client library that supports the Facebook Graph API and the official Facebook JavaScript SDK";
      homepage = https://github.com/pythonforfacebook/facebook-sdk;
      license = licenses.asl20 ;
    };
  };

  faker = callPackage ../development/python-modules/faker { };

  fake_factory = buildPythonPackage rec {
    name = "fake-factory-${version}";
    version = "0.6.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/f/fake-factory/${name}.tar.gz";
      sha256 = "09sgk0kylsshs64a1xsz3qr187sbnqrbf4z8k3dgsy32lsgyffv2";
    };

    propagatedBuildInputs = with self; [ six dateutil ipaddress mock ];
    checkPhase = ''
      ${python.interpreter} -m unittest faker.tests
    '';

    meta = {
      description = "A Python package that generates fake data for you";
      homepage    = https://pypi.python.org/pypi/fake-factory;
      license     = licenses.mit;
      maintainers = with maintainers; [ lovek323 ];
      platforms   = platforms.unix;
    };
  };

  factory_boy = buildPythonPackage rec {
    name = "factory_boy-${version}";
    version = "2.6.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/f/factory_boy/${name}.tar.gz";
      sha256 = "0a21f8kq917fj8xgmyp6gy8vcrlzzgwn80qas0d76h3vjbdy0bdq";
    };

    propagatedBuildInputs = with self; [ fake_factory ];

    meta = {
      description = "A Python package to create factories for complex objects";
      homepage    = https://github.com/rbarrois/factory_boy;
      license     = licenses.mit;
    };
  };

  Fabric = buildPythonPackage rec {
    name = "Fabric-${version}";
    version = "1.13.2";
    src = pkgs.fetchurl {
      url = "mirror://pypi/F/Fabric/${name}.tar.gz";
      sha256 = "0k944dxr41whw7ib6380q9x15wyskx7fqni656icdn8rzshn9bwq";
    };
    disabled = isPy3k;
    doCheck = (!isPyPy);  # https://github.com/fabric/fabric/issues/11891
    propagatedBuildInputs = with self; [ paramiko pycrypto ];
    buildInputs = with self; [ fudge_9 nose ];
  };

  faulthandler = if ! isPy3k
    then callPackage ../development/python-modules/faulthandler {}
    else throw "faulthandler is built into ${python.executable}";

  fedpkg = callPackage ../development/python-modules/fedpkg { };

  flit = callPackage ../development/python-modules/flit { };

  Flootty = buildPythonPackage rec {
    name = "Flootty-3.2.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/F/Flootty/${name}.tar.gz";
      sha256 = "14n2q2k388xbmp5rda5ss879bg5cbibk4zzz7c8mrjsmxhgagmmg";
    };

    meta = with pkgs.stdenv.lib; {
      description = "Floobits collaborative terminal";
      homepage = "https://github.com/Floobits/flootty/";
      maintainers = with maintainers; [ garbas ];
      license = licenses.asl20;
    };
  };

  flowlogs_reader = buildPythonPackage rec {
    name = "flowlogs_reader-1.0.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/f/flowlogs_reader/${name}.tar.gz";
      sha256 = "0158aki6m3pkf98hpd60088qyhrfxkmybdf8hv3qfl8nb61vaiwf";
    };

    propagatedBuildInputs = with self; [
      botocore boto3 docutils
    ];
    buildInputs = with self; [
      unittest2 mock
    ];

    meta = with pkgs.stdenv.lib; {
      description = "Python library to make retrieving Amazon VPC Flow Logs from CloudWatch Logs a bit easier";
      homepage = "https://github.com/obsrvbl/flowlogs-reader";
      maintainers = with maintainers; [ cransom ];
      license = licenses.asl20;
    };
  };

  frozendict = buildPythonPackage rec {
    name = "frozendict-0.5";

    src = pkgs.fetchurl {
      url = "mirror://pypi/f/frozendict/${name}.tar.gz";
      sha256 = "0m4kg6hbadvf99if78nx01q7qnbyhdw3x4znl5dasgciyi54432n";
    };

    meta = {
      homepage = https://github.com/slezica/python-frozendict;
      description = "An immutable dictionary";
      license = stdenv.lib.licenses.mit;
    };
  };

  ftputil = buildPythonPackage rec {
    version = "3.3";
    name = "ftputil-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/f/ftputil/${name}.tar.gz";
      sha256 = "1714w0v6icw2xjx5m54yv2qgkq49qwxwllq4gdb7wkz25iiapr8b";
    };

    disabled = isPy3k;

    meta = {
      description = "High-level FTP client library (virtual file system and more)";
      homepage    = https://pypi.python.org/pypi/ftputil;
      platforms   = platforms.linux;
      license     = licenses.bsd2; # "Modified BSD license, says pypi"
    };
  };

  fudge = buildPythonPackage rec {
    name = "fudge-1.1.0";
    src = pkgs.fetchurl {
      url = "mirror://pypi/f/fudge/${name}.tar.gz";
      sha256 = "eba59a926fa1df1ab6dddd69a7a8af21865b16cad800cb4d1af75070b0f52afb";
    };
    buildInputs = with self; [ nose nosejs ];
    propagatedBuildInputs = with self; [ sphinx ];

    disabled = isPy3k;

    checkPhase = ''
      nosetests -v
    '';
  };

  fudge_9 = self.fudge.override rec {
    name = "fudge-0.9.6";
    src = pkgs.fetchurl {
      url = "mirror://pypi/f/fudge/${name}.tar.gz";
      sha256 = "34690c4692e8717f4d6a2ab7d841070c93c8d0ea0d2615b47064e291f750b1a0";
    };
  };


  funcparserlib = buildPythonPackage rec {
    name = "funcparserlib-0.3.6";

    src = pkgs.fetchurl {
      url = "mirror://pypi/f/funcparserlib/${name}.tar.gz";
      sha256 = "b7992eac1a3eb97b3d91faa342bfda0729e990bd8a43774c1592c091e563c91d";
    };

    checkPhase = ''
      ${python.interpreter} -m unittest discover
    '';

    # Tests are Python 2.x only judging from SyntaxError
    doCheck = !(isPy3k);

    meta = {
      description = "Recursive descent parsing library based on functional combinators";
      homepage = https://code.google.com/p/funcparserlib/;
      license = licenses.mit;
      platforms = platforms.unix;
    };
  };

  singledispatch = buildPythonPackage rec {
    name = "singledispatch-3.4.0.3";

    propagatedBuildInputs = with self; [ six ];

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/singledispatch/${name}.tar.gz";
      sha256 = "5b06af87df13818d14f08a028e42f566640aef80805c3b50c5056b086e3c2b9c";
    };

    meta = {
      homepage = http://docs.python.org/3/library/functools.html;
    };
  };

  functools32 = if isPy3k then null else buildPythonPackage rec {
    name = "functools32-${version}";
    version = "3.2.3-2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/f/functools32/functools32-${version}.tar.gz";
      sha256 = "0v8ya0b58x47wp216n1zamimv4iw57cxz3xxhzix52jkw3xks9gn";
    };


    meta = with stdenv.lib; {
      description = "This is a backport of the functools standard library module from";
      homepage = "https://github.com/MiCHiLU/python-functools32";
    };
  };

  gateone = buildPythonPackage rec {
    name = "gateone-1.2-0d57c3";
    disabled = ! isPy27;
    src = pkgs.fetchFromGitHub {
      rev = "1d0e8037fbfb7c270f3710ce24154e24b7031bea";
      owner= "liftoff";
      repo = "GateOne";
      sha256 = "1ghrawlqwv7wnck6alqpbwy9mpv0y21cw2jirrvsxaracmvgk6vv";
    };
    propagatedBuildInputs = with self; [tornado futures html5lib pkgs.openssl pkgs.cacert pkgs.openssh];
    meta = {
      homepage = https://liftoffsoftware.com/;
      description = "GateOne is a web-based terminal emulator and SSH client";
      maintainers = with maintainers; [ tomberek ];

    };
    postInstall=''
    cp -R "$out/gateone/"* $out/lib/python2.7/site-packages/gateone
    '';
  };

  gcutil = buildPythonPackage rec {
    name = "gcutil-1.16.1";

    src = pkgs.fetchurl {
      url = https://dl.google.com/dl/cloudsdk/release/artifacts/gcutil-1.16.1.tar.gz;
      sha256 = "00jaf7x1ji9y46fbkww2sg6r6almrqfsprydz3q2swr4jrnrsx9x";
    };

    propagatedBuildInputs = with self; [
      gflags
      iso8601
      ipaddr
      httplib2
      google_apputils
      google_api_python_client
    ];

    prePatch = ''
      sed -i -e "s|google-apputils==0.4.0|google-apputils==0.4.1|g" setup.py
      substituteInPlace setup.py \
        --replace "httplib2==0.8" "httplib2" \
        --replace "iso8601==0.1.4" "iso8601"
    '';

    meta = {
      description = "Command-line tool for interacting with Google Compute Engine";
      homepage = "https://cloud.google.com/compute/docs/gcutil/";
      license = licenses.asl20;
      maintainers = with maintainers; [ phreedom ];
      broken = true;
    };
  };

  GeoIP = callPackage ../development/python-modules/GeoIP { };

  gmpy = buildPythonPackage rec {
    name = "gmpy-1.17";
    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "mirror://pypi/g/gmpy/${name}.zip";
      sha256 = "1a79118a5332b40aba6aa24b051ead3a31b9b3b9642288934da754515da8fa14";
    };

    buildInputs = [
      pkgs.gcc
      pkgs.gmp
    ];

    meta = {
      description = "GMP or MPIR interface to Python 2.4+ and 3.x";
      homepage = http://code.google.com/p/gmpy/;
    };
  };

  gmpy2 = buildPythonPackage rec {
    name = "gmpy2-2.0.6";
    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "mirror://pypi/g/gmpy2/${name}.zip";
      sha256 = "5041d0ae24407c24487106099f5bcc4abb1a5f58d90e6712cc95321975eddbd4";
    };

    buildInputs = [
      pkgs.gcc
      pkgs.gmp
      pkgs.mpfr
      pkgs.libmpc
    ];

    meta = {
      description = "GMP/MPIR, MPFR, and MPC interface to Python 2.6+ and 3.x";
      homepage = http://code.google.com/p/gmpy/;
      license = licenses.gpl3Plus;
    };
  };

  gmusicapi = with pkgs; buildPythonPackage rec {
    name = "gmusicapi-10.1.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/g/gmusicapi/gmusicapi-10.1.0.tar.gz";
      sha256 = "0smlrafh1bjzrcjzl7im8pf8f04gcnx92lf3g5qr7yzgq8k20xa2";
    };

    propagatedBuildInputs = with self; [
      validictory
      decorator
      mutagen
      protobuf
      setuptools
      requests
      dateutil
      proboscis
      mock
      appdirs
      oauth2client
      pyopenssl
      gpsoauth
      MechanicalSoup
      future
    ];

    meta = {
      description = "An unofficial API for Google Play Music";
      homepage = https://pypi.python.org/pypi/gmusicapi/;
      license = licenses.bsd3;
    };
  };

  gnureadline = buildPythonPackage rec {
    version = "6.3.3";
    name = "gnureadline-${version}";
    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "mirror://pypi/g/gnureadline/${name}.tar.gz";
      sha256 = "1ghck2zz4xbqa3wz73brgjhrqj55p9hc1fq6c9zb09dnyhwb0nd2";
    };

    buildInputs = [ pkgs.ncurses ];
    patchPhase = ''
      substituteInPlace setup.py --replace "/bin/bash" "${pkgs.bash}/bin/bash"
    '';
  };

  gnutls = buildPythonPackage rec {
    name = "python-gnutls";
    src = pkgs.fetchurl {
      url = "mirror://pypi/p/python-gnutls/python-gnutls-3.0.0.tar.gz";
      sha256 = "1yrdxcj5rzvz8iglircz6icvyggz5fmdcd010n6w3j60yp4p84kc";
    };

    # https://github.com/AGProjects/python-gnutls/issues/2
    disabled = isPy3k;

    propagatedBuildInputs = with self; [ pkgs.gnutls ];
    patchPhase = ''
      substituteInPlace gnutls/library/__init__.py --replace "/usr/local/lib" "${pkgs.gnutls.out}/lib"
    '';
  };

  gpy = callPackage ../development/python-modules/gpy { };

  gitdb = buildPythonPackage rec {
    name = "gitdb-0.6.4";

    src = pkgs.fetchurl {
      url = "mirror://pypi/g/gitdb/${name}.tar.gz";
      sha256 = "0n4n2c7rxph9vs2l6xlafyda5x1mdr8xy16r9s3jwnh3pqkvrsx3";
    };

    buildInputs = with self; [ nose ];
    propagatedBuildInputs = with self; [ smmap ];

    checkPhase = ''
      nosetests
    '';

    doCheck = false; # Bunch of tests fail because they need an actual git repo

    meta = {
      description = "Git Object Database";
      maintainers = with maintainers; [ mornfall ];
      homepage = https://github.com/gitpython-developers/gitdb;
      license = licenses.bsd3;
    };

  };

  GitPython = buildPythonPackage rec {
    version = "2.0.8";
    name = "GitPython-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/G/GitPython/GitPython-${version}.tar.gz";
      sha256 = "7c03d1130f903aafba6ae5b89ccf8eb433a995cd3120cbb781370e53fc4eb222";
    };

    buildInputs = with self; [ mock nose ];
    propagatedBuildInputs = with self; [ gitdb ];

    # All tests error with
    # InvalidGitRepositoryError: /tmp/nix-build-python2.7-GitPython-1.0.1.drv-0/GitPython-1.0.1
    # Maybe due to being in a chroot?
    doCheck = false;

    meta = {
      description = "Python Git Library";
      maintainers = with maintainers; [ mornfall ];
      homepage = https://github.com/gitpython-developers/GitPython;
      license = licenses.bsd3;
    };
  };

  google-cloud-sdk = callPackage ../tools/admin/google-cloud-sdk { };
  google-cloud-sdk-gce = callPackage ../tools/admin/google-cloud-sdk { with-gce=true; };

  google-compute-engine = callPackage ../tools/virtualization/google-compute-engine { };

  gplaycli = buildPythonPackage rec {
    version = "0.1.2";
    name = "gplaycli-${version}";

    src = pkgs.fetchFromGitHub {
      owner = "matlink";
      repo = "gplaycli";
      rev = "${version}";
      sha256 = "0yc09inzs3aggj0gw4irlhlzw5q562fsp0sks352y6z0vx31hcp3";
    };

   disabled = ! isPy27;

   propagatedBuildInputs = with self; [ pkgs.libffi pyasn1 clint ndg-httpsclient protobuf requests args ];

   preBuild = ''
     substituteInPlace setup.py --replace "/etc" "$out/etc"
     substituteInPlace gplaycli/gplaycli.py --replace "/etc" "$out/etc"
   '';

    meta = {
      homepage = https://github.com/matlink/gplaycli;
      description = "Google Play Downloader via Command line";
      license = licenses.agpl3Plus;
      maintainers = with maintainers; [ ];
    };
  };

  gpsoauth = buildPythonPackage rec {
    version = "0.2.0";
    name = "gpsoauth-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/g/gpsoauth/${name}.tar.gz";
      sha256 = "01zxw8rhml8xfwda7ba8983890bzwkfa55ijd6qf8qrdy6ja1ncn";
    };

    propagatedBuildInputs = with self; [
      cffi
      cryptography
      enum34
      idna
      ipaddress
      ndg-httpsclient
      pyopenssl
      pyasn1
      pycparser
      pycryptodome
      requests
      six
    ];

    meta = {
      description = "A python client library for Google Play Services OAuth";
      homepage = "https://github.com/simon-weber/gpsoauth";
      license = licenses.mit;
      maintainers = with maintainers; [ jgillich ];
    };
  };

  grip = buildPythonPackage rec {
    version = "4.3.2";
    name = "grip-${version}";

    src = pkgs.fetchFromGitHub {
      owner = "joeyespo";
      repo = "grip";
      rev = "v${version}";
      sha256 = "05a169sfaj280k7gibbc1rznjn43l5m6l1gpl6a5cmp5r8827khs";
    };
    buildInputs = with self; [ pytest responses ];

    propagatedBuildInputs = with self; [ docopt flask markdown path-and-address pygments requests ];

    checkPhase = ''
      export PATH="$PATH:$out/bin"
      py.test -xm "not assumption"
    '';

    meta = with stdenv.lib; {
      description = "Preview GitHub Markdown files like Readme locally before committing them";
      homepage = https://github.com/joeyespo/grip;
      license = licenses.mit;
      maintainers = with maintainers; [ koral ];
    };
  };

  gst-python = callPackage ../development/python-modules/gst-python {
    gst-plugins-base = pkgs.gst_all_1.gst-plugins-base;
  };

  gtimelog = buildPythonPackage rec {
    name = "gtimelog-${version}";
    version = "0.9.1";

    disabled = isPy26;

    src = pkgs.fetchurl {
      url = "https://github.com/gtimelog/gtimelog/archive/${version}.tar.gz";
      sha256 = "0qk8fv8cszzqpdi3wl9vvkym1jil502ycn6sic4jrxckw5s9jsfj";
    };

    buildInputs = [ pkgs.glibcLocales ];

    LC_ALL="en_US.UTF-8";

    # TODO: AppIndicator
    propagatedBuildInputs = with self; [ pkgs.gobjectIntrospection pygobject3 pkgs.makeWrapper pkgs.gtk3 ];

    checkPhase = ''
      substituteInPlace runtests --replace "/usr/bin/env python" "${python}/bin/${python.executable}"
      ./runtests
    '';

    preFixup = ''
        wrapProgram $out/bin/gtimelog \
          --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
          --prefix LD_LIBRARY_PATH ":" "${pkgs.gtk3.out}/lib" \

    '';

    meta = {
      description = "A small Gtk+ app for keeping track of your time. It's main goal is to be as unintrusive as possible";
      homepage = http://mg.pov.lt/gtimelog/;
      license = licenses.gpl2Plus;
      maintainers = with maintainers; [ ocharles ];
      platforms = platforms.unix;
    };
  };

  helper = buildPythonPackage rec {
    pname = "helper";
    version = "2.4.1";
    name = "${pname}-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/h/${pname}/${name}.tar.gz";
      sha256 = "4e33dde42ad4df30fb7790689f93d77252cff26a565610d03ff2e434865a53a2";
    };

    buildInputs = with self; [ mock ];
    propagatedBuildInputs = with self; [ pyyaml ];

    # No tests
    doCheck = false;

    meta = {
      description = "Development library for quickly writing configurable applications and daemons";
      homepage = https://helper.readthedocs.org/;
      license = licenses.bsd3;
    };


  };

  hglib = callPackage ../development/python-modules/hglib {};

  humanize = buildPythonPackage rec {
    version = "0.5.1";
    name = "humanize-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/h/humanize/${name}.tar.gz";
      sha256 = "a43f57115831ac7c70de098e6ac46ac13be00d69abbf60bdcac251344785bb19";
    };

    buildInputs = with self; [ mock ];

    doCheck = false;

    meta = {
      description = "Python humanize utilities";
      homepage = https://github.com/jmoiron/humanize;
      license = licenses.mit;
      maintainers = with maintainers; [ matthiasbeyer ];
      platforms = platforms.linux; # can only test on linux
    };

  };

  hupper = callPackage ../development/python-modules/hupper {};

  hovercraft = buildPythonPackage rec {
    disabled = ! isPy3k;
    name = "hovercraft-${version}";
    version = "2.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/h/hovercraft/${name}.tar.gz";
      sha256 = "0lqxr816lymgnywln8bbv9nrmkyahjjcjkm9kjyny9bflayz4f1g";
    };

    propagatedBuildInputs = with self; [ docutils lxml manuel pygments svg-path watchdog ];

    # one test assumes we have docutils 0.12
    # TODO: enable tests after upgrading docutils to 0.12
    doCheck = false;

    meta = {
      description = "A tool to make impress.js presentations from reStructuredText";
      homepage = https://github.com/regebro/hovercraft;
      license = licenses.mit;
      maintainers = with maintainers; [ goibhniu ];
    };
  };

  hsaudiotag = buildPythonPackage (rec {
    name = "hsaudiotag-1.1.1";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/h/hsaudiotag/${name}.tar.gz";
      sha256 = "15hgm128p8nysfi0jb127awga3vlj0iw82l50swjpvdh01m7rda8";
    };

    # no tests
    doCheck = false;

    meta = {
      description = "A pure Python library that lets one to read metadata from media files";
      homepage = http://hg.hardcoded.net/hsaudiotag/;
      license = licenses.bsd3;
    };
  });

  hsaudiotag3k = buildPythonPackage (rec {
    name = "hsaudiotag3k-1.1.3";
    disabled = !isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/h/hsaudiotag3k/${name}.tar.gz";
      sha256 = "0bv5k5594byr2bmhh77xv10fkdpckcmxg3w380yp30aqf83rcsx3";
    };

    # no tests
    doCheck = false;

    meta = {
      description = "A pure Python library that lets one to read metadata from media files";
      homepage = http://hg.hardcoded.net/hsaudiotag/;
      license = licenses.bsd3;
    };
  });


  htmlmin = callPackage ../development/python-modules/htmlmin {};

  httpauth = buildPythonPackage rec {
    version = "0.3";
    name = "httpauth-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/h/httpauth/${name}.tar.gz";
      sha256 = "0qas7876igyz978pgldp5r7n7pis8n4vf0v87gxr9l7p7if5lr3l";
    };

    doCheck = false;

    meta = {
      description = "WSGI HTTP Digest Authentication middleware";
      homepage = https://github.com/jonashaag/httpauth;
      license = licenses.bsd2;
      maintainers = with maintainers; [ matthiasbeyer ];
    };
  };

  ijson = callPackage ../development/python-modules/ijson/default.nix {};

  imagesize = buildPythonPackage rec {
    name = "imagesize-${version}";
    version = "0.7.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/i/imagesize/${name}.tar.gz";
      sha256 = "0msgz4ncp2nb5nbsxnf8kvxsl6nhwvc3b46ik097fvznl3y10gdv";
    };

    meta = {
      description = "Getting image size from png/jpeg/jpeg2000/gif file";
      homepage = https://github.com/shibukawa/imagesize_py;
      license = with licenses; [ mit ];
    };

  };

  imread = buildPythonPackage rec {
    name = "python-imread-${version}";
    version = "0.6";

    src = pkgs.fetchurl {
      url = "https://github.com/luispedro/imread/archive/release-${version}.tar.gz";
      sha256 = "0i14bc67200zhzxc41g5dfp2m0pr1zaa2gv59p2va1xw0ji2dc0f";
    };

    nativeBuildInputs = [ pkgs.pkgconfig ];
    buildInputs = with self; [
      nose
      pkgs.libjpeg
      pkgs.libpng
      pkgs.libtiff
      pkgs.libwebp
    ];
    propagatedBuildInputs = with self; [ numpy ];

    meta = with stdenv.lib; {
      description = "Python package to load images as numpy arrays";
      homepage = https://imread.readthedocs.io/en/latest/;
      maintainers = with maintainers; [ luispedro ];
      license = licenses.mit;
      platforms = platforms.linux;
    };
  };

  ipfsapi = buildPythonPackage rec {
    name = "ipfsapi-${version}";
    version = "0.4.2.post1";
    disabled = isPy26 || isPy27;

    src = pkgs.fetchFromGitHub {
      owner = "ipfs";
      repo = "py-ipfs-api";
      rev = "0c485544a114f580c65e2ffbb5782efbf7fd9f61";
      sha256 = "1v7f77cv95yv0v80gisdh71mj7jcq41xcfip6bqm57zfdbsa0xpn";
    };

    propagatedBuildInputs = with self; [ six requests ];

    meta = {
      description = "A python client library for the IPFS API";
      license = licenses.mit;
      maintainers = with maintainers; [ mguentner ];
      homepage = "https://pypi.python.org/pypi/ipfsapi";
    };
  };

  itsdangerous = buildPythonPackage rec {
    name = "itsdangerous-0.24";

    src = pkgs.fetchurl {
      url = "mirror://pypi/i/itsdangerous/${name}.tar.gz";
      sha256 = "06856q6x675ly542ig0plbqcyab6ksfzijlyf1hzhgg3sgwgrcyb";
    };

    meta = {
      description = "Helpers to pass trusted data to untrusted environments and back";
      homepage = "https://pypi.python.org/pypi/itsdangerous/";
    };
  };

  iniparse = buildPythonPackage rec {

    name = "iniparse-${version}";
    version = "0.4";

    src = pkgs.fetchurl {
      url = "mirror://pypi/i/iniparse/iniparse-${version}.tar.gz";
      sha256 = "0m60k46vr03x68jckachzsipav0bwhhnqb8715hm1cngs89fxhdb";
    };

    checkPhase = ''
      ${python.interpreter} runtests.py
    '';

    # Does not install tests
    doCheck = false;

    meta = with stdenv.lib; {
      description = "Accessing and Modifying INI files";
      license = licenses.mit;
      maintainers = with maintainers; [ danbst ];
    };
  };

  i3-py = buildPythonPackage rec {
    version = "0.6.4";
    name = "i3-py-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/i/i3-py/i3-py-${version}.tar.gz";
      sha256 = "1sgl438jrb4cdyl7hbc3ymwsf7y3zy09g1gh7ynilxpllp37jc8y";
    };

    # no tests in tarball
    doCheck = false;

    meta = {
      description = "Tools for i3 users and developers";
      homepage =  "https://github.com/ziberna/i3-py";
      license = licenses.gpl3;
      platforms = platforms.linux;
    };
  };

  jdcal = buildPythonPackage rec {
    version = "1.0";
    name = "jdcal-${version}";

    src = pkgs.fetchFromGitHub {
      owner = "phn";
      repo = "jdcal";
      rev = "v${version}";
      sha256 = "0jjgrrylraqzk3n97hay4gj00ky6vlvkfaapfgqlbcxyq30j24vq";
    };

    meta = {
      description = "A module containing functions for converting between Julian dates and calendar dates";
      homepage = "https://github.com/phn/jdcal";
      license = licenses.bsd2;
      maintainers = with maintainers; [ lihop ];
      platforms = platforms.all;
    };
  };

  internetarchive = callPackage ../development/python-modules/internetarchive {};

  jsbeautifier = callPackage ../development/python-modules/jsbeautifier {};

  jug = callPackage ../development/python-modules/jug {};

  jsmin = callPackage ../development/python-modules/jsmin { };

  jsonpatch = callPackage ../development/python-modules/jsonpatch { };

  jsonpointer = buildPythonPackage rec {
    name = "jsonpointer-1.9";

    src = pkgs.fetchurl {
      url = "mirror://pypi/j/jsonpointer/${name}.tar.gz";
      sha256 = "39403b47a71aa782de6d80db3b78f8a5f68ad8dfc9e674ca3bb5b32c15ec7308";
    };

    meta = {
      description = "Resolve JSON Pointers in Python";
      homepage = "https://github.com/stefankoegl/python-json-pointer";
      license = stdenv.lib.licenses.bsd2; # "Modified BSD license, says pypi"
    };
  };

  jsonrpclib = buildPythonPackage rec {
    name = "jsonrpclib-${version}";
    version = "0.1.7";

    disabled = !isPy27;

    src = pkgs.fetchurl {
      url = "mirror://pypi/j/jsonrpclib/${name}.tar.gz";
      sha256 = "02vgirw2bcgvpcxhv5hf3yvvb4h5wzd1lpjx8na5psdmaffj6l3z";
    };

    propagatedBuildInputs = with self; [ cjson ];

    meta = {
      description = "JSON RPC client library";
      homepage = https://pypi.python.org/pypi/jsonrpclib/;
      license = stdenv.lib.licenses.asl20;
      maintainers = [ stdenv.lib.maintainers.joachifm ];
    };
  };

  jsonwatch = buildPythonPackage rec {
    name = "jsonwatch-0.2.0";

    disabled = isPyPy; # doesn't find setuptools

    src = pkgs.fetchurl {
      url = "https://github.com/dbohdan/jsonwatch/archive/v0.2.0.tar.gz";
      sha256 = "04b616ef97b9d8c3887004995420e52b72a4e0480a92dbf60aa6c50317261e06";
    };

    propagatedBuildInputs = with self; [ six ];

    meta = {
      description = "Like watch -d but for JSON";
      longDescription = ''
        jsonwatch is a command line utility with which you can track changes in
        JSON data delivered by a shell command or a web (HTTP/HTTPS) API.
        jsonwatch requests data from the designated source repeatedly at a set
        interval and displays the differences when the data changes. It is
        similar in its behavior to how watch(1) with the -d switch works
        for plain-text data.
      '';
      homepage = "https://github.com/dbohdan/jsonwatch";
      license = licenses.mit;
      platforms = platforms.all;
    };
  };

  libsexy = callPackage ../development/python-modules/libsexy {
    libsexy = pkgs.libsexy;
  };

  libsoundtouch = callPackage ../development/python-modules/libsoundtouch { };

  libthumbor = buildPythonPackage rec {
    name = "libthumbor-${version}";
    version = "1.3.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/l/libthumbor/${name}.tar.gz";
      sha256 = "1vjhszsf8wl9k16wyg2rfjycjnawzl7z8j39bhiysbz5x4lqg91b";
    };

    buildInputs = with self; [ django ];

    propagatedBuildInputs = with self; [ six pycrypto ];

    doCheck = false;

    meta = {
      description = "libthumbor is the python extension to thumbor";
      homepage = https://github.com/heynemann/libthumbor;
      license = licenses.mit;
    };
  };

  lightblue = buildPythonPackage rec {
    pname = "lightblue";
    version = "0.4";
    name = "${pname}-${version}";

    src = pkgs.fetchurl {
      url = "mirror://sourceforge/${pname}/${name}.tar.gz";
      sha256 = "016h1mlhpqxjj25lcvl4fqc19k8ifmsv6df7rhr12fyfcrp5i14d";
    };

    buildInputs = [ pkgs.bluez pkgs.openobex ];


    meta = {
      homepage = http://lightblue.sourceforge.net;
      description = "Cross-platform Bluetooth API for Python";
      maintainers = with maintainers; [ leenaars ];
      license = licenses.gpl3;
      platforms = platforms.all;
    };
  };


  lightning = buildPythonPackage rec {
    version = "1.2.1";
    name = "lightning-python-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/l/lightning-python/${name}.tar.gz";
      sha256 = "3987d7d4a634bdb6db9bcf212cf4d2f72bab5bc039f4f6cbc02c9d01c4ade792";
    };

    buildInputs = with self; [ pytest ];

    propagatedBuildInputs = with self; [
      jinja2
      matplotlib
      numpy
      requests
      six
    ];

    meta = {
      description = "A Python client library for the Lightning data visualization server";
      homepage = http://lightning-viz.org;
      license = licenses.mit;
    };
  };

  jupyter = buildPythonPackage rec {
    version = "1.0.0";
    name = "jupyter-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/j/jupyter/${name}.tar.gz";
      sha256 = "d9dc4b3318f310e34c82951ea5d6683f67bed7def4b259fafbfe4f1beb1d8e5f";
    };

    propagatedBuildInputs = with self; [
      notebook
      qtconsole
      jupyter_console
      nbconvert
      ipykernel
      ipywidgets
    ];

    # Meta-package, no tests
    doCheck = false;

    meta = {
      description = "Installs all the Jupyter components in one go";
      homepage = "http://jupyter.org/";
      license = licenses.bsd3;
      platforms = platforms.all;
      priority = 100; # This is a metapackage which is unimportant
    };
  };

  jupyter_console = callPackage ../development/python-modules/jupyter_console { };

  jupyterlab = buildPythonPackage rec {
    name = "jupyterlab-${version}";
    version = "0.4.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/j/jupyterlab/${name}.tar.gz";
      sha256 = "91dc4d7dfb1e6ab97e28d6e3a2fc38f5f65d368201c00fd0ed077519258e67bb";
    };

    propagatedBuildInputs = with self; [ notebook ];

    # No tests in archive
    doCheck = false;

    meta = {
      description = "Jupyter lab environment notebook server extension.";
      license = with licenses; [ bsd3 ];
      homepage = "http://jupyter.org/";
    };
  };

  PyLTI = buildPythonPackage rec {
    version = "0.4.1";
    name = "PyLTI-${version}";

    disabled = !isPy27;

    # There is no need to fix mock. https://github.com/mitodl/pylti/pull/48
    postPatch = ''
      substituteInPlace setup.py --replace "mock==1.0.1" "mock"
    '';

    propagatedBuildInputs = with self; [ httplib2 oauth oauth2 semantic-version ];
    buildInputs = with self; [
      flask httpretty oauthlib pyflakes pytest_27 pytestcache pytestcov covCore
      pytestflakes pytestpep8 sphinx mock
    ];

    src = pkgs.fetchurl {
      url = "mirror://pypi/P/PyLTI/${name}.tar.gz";
      sha256 = "076llj10j85zw3zq2gygx2pcfqi9rgcld5m4vq1iai1fk15x60fz";
    };

    meta = {
      description = "Implementation of IMS LTI interface that works with edX";
      homepage = "https://github.com/mitodl/pylti";
      license = licenses.bsdOriginal;
      maintainers = with maintainers; [ layus ];
    };
  };

  lmdb = buildPythonPackage rec {
    pname = "lmdb";
    version = "0.92";
    name = "${pname}-${version}";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "01nw6r08jkipx6v92kw49z34wmwikrpvc5j9xawdiyg1n2526wrx";
    };

    # Some sort of mysterious failure with lmdb.tool
    doCheck = !isPy3k;

    meta = {
      description = "Universal Python binding for the LMDB 'Lightning' Database";
      homepage = "https://github.com/dw/py-lmdb";
      license = licenses.openldap;
      maintainers = with maintainers; [ copumpkin ];
    };
  };

  logilab_astng = buildPythonPackage rec {
    name = "logilab-astng-0.24.3";

    src = pkgs.fetchurl {
      url = "http://download.logilab.org/pub/astng/${name}.tar.gz";
      sha256 = "0np4wpxyha7013vkkrdy54dvnil67gzi871lg60z8lap0l5h67wn";
    };

    propagatedBuildInputs = with self; [ logilab_common ];
  };

  lpod = buildPythonPackage rec {
    version = "1.1.7";
    name = "python-lpod-${version}";
    # lpod library currently does not support Python 3.x
    disabled = isPy3k;

    propagatedBuildInputs = with self; [ lxml docutils pillow ];

    src = pkgs.fetchFromGitHub {
      owner = "lpod";
      repo = "lpod-python";
      rev = "dee32120ee582ff337b0c52a95a9a87cca71fd67";
      sha256 = "1mikvzp27wxkzpr2lii4wg1hhx8h610agckqynvsrdc8v3nw9ciw";
    };

    meta = {
      homepage = https://github.com/lpod/lpod-python/;
      description = "Library implementing the ISO/IEC 26300 OpenDocument Format standard (ODF) ";
      license = licenses.gpl3;
    };
  };

  m2r = callPackage ../development/python-modules/m2r { };

  mailchimp = buildPythonPackage rec {
    version = "2.0.9";
    name = "mailchimp-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/m/mailchimp/mailchimp-${version}.tar.gz";
      sha256 = "0351ai0jqv3dzx0xxm1138sa7mb42si6xfygl5ak8wnfc95ff770";
    };

    buildInputs = with self; [ docopt ];
    propagatedBuildInputs = with self; [ requests ];
    patchPhase = ''
      sed -i 's/==/>=/' setup.py
    '';

    meta = {
      description = "A CLI client and Python API library for the MailChimp email platform";
      homepage = "http://apidocs.mailchimp.com/api/2.0/";
      license = licenses.mit;
    };
  };

  python-mapnik = buildPythonPackage rec {
    name = "python-mapnik-${version}";
    version = "3.0.13";

    src = pkgs.fetchFromGitHub {
      owner = "mapnik";
      repo = "python-mapnik";
      rev = "v${version}";
      sha256 = "0biw9bfkbsgfyjihyvkj4abx9s9r3h81rk6dc1y32022rypsqhkp";
    };

    disabled = isPyPy;
    doCheck = false; # doesn't find needed test data files
    buildInputs = with pkgs;
      [ boost cairo harfbuzz icu libjpeg libpng libtiff libwebp mapnik proj zlib ];
    propagatedBuildInputs = with self; [ pillow pycairo ];

    meta = with stdenv.lib; {
      description = "Python bindings for Mapnik";
      homepage = http://mapnik.org;
      license  = licenses.lgpl21;
    };
  };

  mwlib = let
    pyparsing = buildPythonPackage rec {
      name = "pyparsing-1.5.7";
      disabled = isPy3k;

      src = pkgs.fetchurl {
        url = "mirror://pypi/p/pyparsing/${name}.tar.gz";
        sha256 = "646e14f90b3689b005c19ac9b6b390c9a39bf976481849993e277d7380e6e79f";
      };
      meta = {
        homepage = http://pyparsing.wikispaces.com/;
        description = "An alternative approach to creating and executing simple grammars, vs. the traditional lex/yacc approach, or the use of regular expressions";
      };
    };
  in buildPythonPackage rec {
    version = "0.15.15";
    name = "mwlib-${version}";

    src = pkgs.fetchurl {
      url = "http://pypi.pediapress.com/packages/mirror/${name}.tar.gz";
      sha256 = "1dnmnkc21zdfaypskbpvkwl0wpkpn0nagj1fc338w64mbxrk8ny7";
    };

    propagatedBuildInputs = with self; [
        apipkg
        bottle
        gevent
        lxml
        odfpy
        pillow
        py
        pyPdf
        pyparsing
        qserve
        roman
        simplejson
        sqlite3dbm
        timelib
    ];

    checkInputs = with self; [ pytest ];

    checkPhase = ''
      py.test
    '';

    # Tests are in build directory but we need extension modules that are in $out
    doCheck = false;

    meta = {
      description = "Library for parsing MediaWiki articles and converting them to different output formats";
      homepage = "http://pediapress.com/code/";
      license = licenses.bsd3;
      broken = true; # Requires different versions of packages
    };
  };

  mwlib-ext = buildPythonPackage rec {
    version = "0.13.2";
    name = "mwlib.ext-${version}";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "http://pypi.pediapress.com/packages/mirror/${name}.zip";
      sha256 = "9229193ee719568d482192d9d913b3c4bb96af7c589d6c31ed4a62caf5054278";
    };

    meta = {
      description = "Dependencies for mwlib markup";
      homepage = "http://pediapress.com/code/";
      license = licenses.bsd3;
    };
  };

  mwlib-rl = buildPythonPackage rec {
    version = "0.14.6";
    name = "mwlib.rl-${version}";

    src = pkgs.fetchurl {
      url = "http://pypi.pediapress.com/packages/mirror/${name}.zip";
      sha256 = "7f596fd60eb24d8d3da3ab4880f095294028880eafb653810a7bdaabdb031238";
    };

    buildInputs = with self;
      [
        mwlib
        mwlib-ext
        pygments
      ];

    meta = {
      description = "Generate pdfs from mediawiki markup";
      homepage = "http://pediapress.com/code/";
      license = licenses.bsd3;
    };
  };

  natsort = callPackage ../development/python-modules/natsort { };

  logster = buildPythonPackage {
    name = "logster-7475c53822";
    src = pkgs.fetchgit {
      url = git://github.com/etsy/logster;
      rev = "7475c53822";
      sha256 = "0565wxxiwksnly8rakb2r77k7lwzniq16kv861qd2ns9hgsjgy31";
    };
  };

  logfury = callPackage ../development/python-modules/logfury { };

  ndg-httpsclient = buildPythonPackage rec {
    version = "0.4.2";
    name = "ndg-httpsclient-${version}";

    propagatedBuildInputs = with self; [ pyopenssl ];

    src = pkgs.fetchFromGitHub {
      owner = "cedadev";
      repo = "ndg_httpsclient";
      rev = version;
      sha256 = "1kk4knv029j0cicfiv23c1rayc1n3f1j3rhl0527gxiv0qv4jw8h";
    };

    # uses networking
    doCheck = false;

    meta = {
      homepage = https://github.com/cedadev/ndg_httpsclient/;
      description = "Provide enhanced HTTPS support for httplib and urllib2 using PyOpenSSL";
      license = licenses.bsd2;
      maintainers = with maintainers; [ ];
    };
  };

  netcdf4 = callPackage ../development/python-modules/netcdf4 { };

  Nikola = callPackage ../development/python-modules/Nikola { };

  nxt-python = buildPythonPackage rec {
    version = "unstable-20160819";
    pname = "nxt-python";
    name = "${pname}-${version}";

    propagatedBuildInputs = with self; [ pyusb pybluez pyfantom pkgs.git ];
    disabled = isPy3k;

    src = pkgs.fetchgit {
      url = "http://github.com/Eelviny/nxt-python";
      rev = "479e20b7491b28567035f4cee294c4a2af629297";
      sha256 = "0mcsajhgm2wy4iy2lhmyi3xibgmbixbchanzmlhsxk6qyjccn9r9";
      branchName= "pyusb";
    };

    # Tests fail on Mac dependency
    doCheck = false;

    meta = {
      description = "Python driver/interface for Lego Mindstorms NXT robot";
      homepage = https://github.com/Eelviny/nxt-python;
      license = licenses.gpl3;
      platforms = platforms.linux;
      maintainers = with maintainers; [ leenaars ];
    };
  };

  odfpy = callPackage ../development/python-modules/odfpy { };


  pamela = buildPythonPackage rec {
    name = "pamela-${version}";
    version = "0.3.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pamela/${name}.tar.gz";
      sha256 = "0ssxbqsshrm8p642g3h6wsq20z1fsqhpdvqdm827gn6dlr38868y";
    };

    doCheck = false;

    meta = {
      description = "PAM interface using ctypes";
      homepage = "http://github.com/minrk/pamela";
      license = licenses.mit;
    };
  };

  # These used to be here but were moved to all-packages, but I'll leave them around for a while.
  pants = pkgs.pants;

  paperwork-backend = callPackage ../applications/office/paperwork/backend.nix { };

  pathspec = callPackage ../development/python-modules/pathspec { };

  pathtools = buildPythonPackage rec {
    name = "pathtools-${version}";
    version = "0.1.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pathtools/${name}.tar.gz";
      sha256 = "1h7iam33vwxk8bvslfj4qlsdprdnwf8bvzhqh3jq5frr391cadbw";
    };

    meta = {
      description = "Pattern matching and various utilities for file systems paths";
      homepage = https://github.com/gorakhargosh/pathtools;
      license = licenses.mit;
      maintainers = with maintainers; [ goibhniu ];
    };
  };

  paver = buildPythonPackage rec {
    version = "1.2.2";
    name    = "Paver-${version}";

    src = pkgs.fetchurl {
      url    = "mirror://pypi/P/Paver/Paver-${version}.tar.gz";
      sha256 = "0lix9d33ndb3yk56sm1zlj80fbmxp0w60yk0d9pr2xqxiwi88sqy";
    };

    buildInputs = with self; [ cogapp mock virtualenv ];

    propagatedBuildInputs = with self; [ nose ];

    # the tests do not pass
    doCheck = false;

    meta = {
      description = "A Python-based build/distribution/deployment scripting tool";
      homepage    = http://github.com/paver/paver;
      maintainers = with maintainers; [ lovek323 ];
      platforms   = platforms.unix;
    };
  };

  passlib = callPackage ../development/python-modules/passlib { };

  path-and-address = buildPythonPackage rec {
    version = "2.0.1";
    name = "path-and-address-${version}";

    buildInputs = with self; [ pytest ];

    checkPhase = "py.test";

    src = pkgs.fetchFromGitHub {
      owner = "joeyespo";
      repo = "path-and-address";
      rev = "v${version}";
      sha256 = "0b0afpsaim06mv3lhbpm8fmawcraggc11jhzr6h72kdj1cqjk5h6";
    };

    meta = {
      description = "Functions for server CLI applications used by humans";
      homepage = https://github.com/joeyespo/path-and-address;
      license = licenses.mit;
      maintainers = with maintainers; [ koral];
    };
  };


  pdfminer = buildPythonPackage rec {
    version = "20140328";
    name = "pdfminer-${version}";

    disabled = ! isPy27;

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pdfminer/pdfminer-${version}.tar.gz";
      sha256 = "0qpjv4b776dwvpf5a7v19g41qsz97bv0qqsyvm7a31k50n9pn65s";
    };

    propagatedBuildInputs = with self; [  ];

    meta = {
      description = "Tool for extracting information from PDF documents";
      homepage = http://euske.github.io/pdfminer/index.html;
      license = licenses.mit;
      maintainers = with maintainers; [ ];
    };
  };

  peppercorn = buildPythonPackage rec {
    name = "peppercorn-0.5";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/peppercorn/${name}.tar.gz";
      sha256 = "921cba5d51fa211e6da0fbd2120b9a98d663422a80f5bb669ad81ffb0909774b";
    };

    meta = {
      maintainers = with maintainers; [ garbas domenkozar ];
      platforms = platforms.all;
    };
  };

  pex = buildPythonPackage rec {
    name = "pex-${version}";
    version = "1.2.7";

    src = self.fetchPypi {
      pname  = "pex";
      sha256 = "1m0gx9182w1dybkyjwwjyd6i87x2dzv252ks2fj8yn6avlcp5z4q";
      inherit version;
    };

    prePatch = ''
      substituteInPlace setup.py --replace 'SETUPTOOLS_REQUIREMENT,' '"setuptools"'
    '';

    # A few more dependencies I don't want to handle right now...
    doCheck = false;

    meta = {
      description = "A library and tool for generating .pex (Python EXecutable) files";
      homepage = "https://github.com/pantsbuild/pex";
      license = licenses.asl20;
      maintainers = with maintainers; [ copumpkin ];
    };
  };

  phpserialize = callPackage ../development/python-modules/phpserialize { };

  plaster = callPackage ../development/python-modules/plaster {};

  plaster-pastedeploy = callPackage ../development/python-modules/plaster-pastedeploy {};

  plotly = callPackage ../development/python-modules/plotly { };

  plyfile = callPackage ../development/python-modules/plyfile { };

  podcastparser = callPackage ../development/python-modules/podcastparser { };

  pomegranate = callPackage ../development/python-modules/pomegranate { };

  poppler-qt4 = buildPythonPackage rec {
    name = "poppler-qt4-${version}";
    version = "0.18.1";
    disabled = isPy3k || isPyPy;

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/python-poppler-qt4/" +
            "python-poppler-qt4-${version}.tar.gz";
      sha256 = "00e3f89f4e23a844844d082918a89c2cbb1e8231ecb011b81d592e7e3c33a74c";
    };

    propagatedBuildInputs = [ self.pyqt4 pkgs.pkgconfig pkgs.poppler_qt4 ];

    preBuild = "${python}/bin/${python.executable} setup.py build_ext" +
               " --include-dirs=${pkgs.poppler_qt4.dev}/include/poppler/";

    NIX_CFLAGS_COMPILE = "-I${pkgs.poppler_qt4.dev}/include/poppler/";

    meta = {
      description = "A Python binding to Poppler-Qt4";
      longDescription = ''
        A Python binding to Poppler-Qt4 that aims for completeness
        and for being actively maintained.
      '';
      license = licenses.lgpl21Plus;
      maintainers = with maintainers; [ sepi ];
      platforms = platforms.all;
    };
  };

  poyo = buildPythonPackage rec {
    version = "0.4.0";
    name = "poyo-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/poyo/${name}.tar.gz";
      sha256 = "1f48ffl0j1f2lmgabajps7v8w90ppxbp5168gh8kh27bjd8xk5ca";
    };

    meta = {
      homepage = https://github.com/hackebrot/poyo;
      description = "A lightweight YAML Parser for Python";
      license = licenses.mit;
    };
  };

  pudb = buildPythonPackage rec {
    name = "pudb-2016.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pudb/${name}.tar.gz";
      sha256 = "0njhi49d9fxbwh5p8yjx8m3jlfyzfm00b5aff6bz473pn7vxfn79";
    };

    propagatedBuildInputs = with self; [ pygments urwid ];

    # Tests fail on python 3 due to writes to the read-only home directory
    doCheck = !isPy3k;

    meta = {
      description = "A full-screen, console-based Python debugger";
      license = licenses.mit;
      platforms = platforms.all;
    };
  };

  pycallgraph = buildPythonPackage rec {
    name = "pycallgraph-${version}";
    version = "1.0.1";

    src = pkgs.fetchurl {
      url = mirror://pypi/p/pycallgraph/pycallgraph-1.0.1.tar.gz;
      sha256 = "0w8yr43scnckqcv5nbyd2dq4kpv74ai856lsdsf8iniik07jn9mi";
    };

    buildInputs = with self; [ pytest ];

    # Tests do not work due to this bug: https://github.com/gak/pycallgraph/issues/118
    doCheck = false;

    meta = {
      homepage = http://pycallgraph.slowchop.com;
      description = "Call graph visualizations for Python applications";
      maintainers = with maintainers; [ auntie ];
      license = licenses.gpl2;
      platforms = platforms.all;
    };
  };

  pycassa = callPackage ../development/python-modules/pycassa { };

  pyblake2 = callPackage ../development/python-modules/pyblake2 { };

  pybluez = buildPythonPackage rec {
    version = "unstable-20160819";
    pname = "pybluez";
    name = "${pname}-${version}";

    propagatedBuildInputs = with self; [ pkgs.bluez ];

    src = pkgs.fetchFromGitHub {
      owner = "karulis";
      repo = "${pname}";
      rev = "a0b226a61b166e170d48539778525b31e47a4731";
      sha256 = "104dm5ngfhqisv1aszdlr3szcav2g3bhsgzmg4qfs09b3i5zj047";
    };

    # the tests do not pass
    doCheck = false;

    meta = {
      description = "Bluetooth Python extension module";
      license = licenses.gpl2;
      maintainers = with maintainers; [ leenaars ];
    };
  };

  pycares = buildPythonPackage rec {
    name = "pycares-${version}";
    version = "1.0.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pycares/${name}.tar.gz";
      sha256 = "a18341ea030e2cc0743acdf4aa72302bdf6b820938b36ce4bd76e43faa2276a3";
    };

    propagatedBuildInputs = [ pkgs.c-ares ];

    # No tests included
    doCheck = false;

    meta = {
      homepage = https://github.com/saghul/pycares;
      description = "Interface for c-ares";
      license = licenses.mit;
    };
  };

  pycuda = callPackage ../development/python-modules/pycuda rec {
    cudatoolkit = pkgs.cudatoolkit75;
    inherit (pkgs.stdenv) mkDerivation;
    inherit pythonOlder;
  };

  pyphen = callPackage ../development/python-modules/pyphen {};

  pypoppler = buildPythonPackage rec {
    name = "pypoppler-${version}";
    version = "0.12.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pypoppler/${name}.tar.gz";
      sha256 = "47e6ac99e5b114b9abf2d1dd1bca06f22c028d025432512989f659142470810f";
    };

    NIX_CFLAGS_COMPILE="-I${pkgs.poppler.dev}/include/poppler/";
    nativeBuildInputs = [ pkgs.pkgconfig ];
    buildInputs = [ pkgs.poppler.dev ];
    propagatedBuildInputs = with self; [ pycairo pygobject2 ];

    patches = [
      ../development/python-modules/pypoppler-0.39.0.patch
      ../development/python-modules/pypoppler-poppler.c.patch
    ];

    # Not supported.
    disabled = isPy3k;

    # No tests in archive
    doCheck = false;

    meta = {
      homepage = https://code.launchpad.net/~mriedesel/poppler-python/main;
      description = "Python bindings for poppler-glib, unofficial branch including bug fixes, and removal of gtk dependencies";
      license = licenses.gpl2;
    };
  };

  pypillowfight = buildPythonPackage rec {
    name = "pypillowfight-${version}";
    version = "0.2.1";

    src = pkgs.fetchFromGitHub {
      owner = "jflesch";
      repo = "libpillowfight";
      rev = version;
      sha256 = "1rwmajsy9qhl3qhhy5mw0xmr3n8abxcq8baidpn0sxv6yjg2369z";
    };

    # Disable tests because they're designed to only work on Debian:
    # https://github.com/jflesch/libpillowfight/issues/2#issuecomment-268259174
    doCheck = false;

    # Python 2.x is not supported, see:
    # https://github.com/jflesch/libpillowfight/issues/1
    disabled = !isPy3k && !isPyPy;

    # This is needed by setup.py regardless of whether tests are enabled.
    buildInputs = [ self.nose ];
    propagatedBuildInputs = [ self.pillow ];

    meta = {
      description = "Library containing various image processing algorithms";
      homepage = "https://github.com/jflesch/libpillowfight";
      license = licenses.gpl3Plus;
    };
  };

  python-axolotl = buildPythonPackage rec {
    name = "python-axolotl-${version}";
    version = "0.1.39";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/python-axolotl/${name}.tar.gz";
      sha256 = "09bf5gfip9x2wr0ij43p39ac6z2iqzn7kgpi2jjbwpnhs0vwkycs";
    };

    propagatedBuildInputs = with self; [ python-axolotl-curve25519 protobuf pycrypto ];
    # IV == 0 in tests is not supported by pycrytpodom (our pycrypto drop-in)
    doCheck = !isPy3k;

    meta = {
      homepage = "https://github.com/tgalal/python-axolotl";
      description = "Python port of libaxolotl-android";
      maintainers = with maintainers; [ abbradar ];
      license = licenses.gpl3;
      platforms = platforms.all;
    };
  };

  python-axolotl-curve25519 = buildPythonPackage rec {
    name = "python-axolotl-curve25519-${version}";
    version = "0.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/python-axolotl-curve25519/${name}.tar.gz";
      sha256 = "1h1rsdr7m8lvgxwrwng7qv0xxmyc9k0q7g9nbcr6ks2ipyjzcnf5";
    };

    meta = {
      homepage = "https://github.com/tgalal/python-axolotl-curve25519";
      description = "Curve25519 with ed25519 signatures";
      maintainers = with maintainers; [ abbradar ];
      license = licenses.gpl3;
      platforms = platforms.all;
    };
  };

  pypolicyd-spf = buildPythonPackage rec {
    name = "pypolicyd-spf-${version}";
    majorVersion = "2.0";
    version = "${majorVersion}.1";
    disabled = !isPy3k;

    src = pkgs.fetchurl {
      url = "https://launchpad.net/pypolicyd-spf/${majorVersion}/${version}/+download/${name}.tar.gz";
      sha256 = "09yi8y7pij5vzzrkc9sdw01x8w5n758d0qg7wv5hxd1l6if8c94i";
    };

    propagatedBuildInputs = with self; [ pyspf ];

    preBuild = ''
      substituteInPlace setup.py --replace "'/etc'" "'$out/etc'"
    '';

    meta = {
      homepage = "https://launchpad.net/pypolicyd-spf/";
      description = "Postfix policy engine for Sender Policy Framework (SPF) checking";
      maintainers = with maintainers; [ abbradar ];
      license = licenses.asl20;
      platforms = platforms.all;
    };
  };

  pyramid = buildPythonPackage rec {
    pname = "pyramid";
    version = "1.9.1";
    name = "${pname}-${version}";

    src = fetchPypi {
      inherit pname version;
      sha256 = "0dhbzc4q0vsnv3aihy728aczg56xs6h9s1rmvr096q4lb6yln3w4";
    };

    checkInputs = with self; [
      docutils
      virtualenv
      webtest
      zope_component
    ] ++ optional isPy26 unittest2;

    propagatedBuildInputs = with self; [
      hupper
      PasteDeploy
      plaster
      plaster-pastedeploy
      repoze_lru
      repoze_sphinx_autointerface
      translationstring
      venusian
      webob
      zope_deprecation
      zope_interface
    ];

    meta = {
      maintainers = with maintainers; [ garbas domenkozar ];
      platforms = platforms.all;
    };

    # Failing tests
    # https://github.com/Pylons/pyramid/issues/1899
    doCheck = !isPy35;

  };

  pyramid_beaker = callPackage ../development/python-modules/pyramid_beaker { };

  pyramid_chameleon = buildPythonPackage rec {
    name = "pyramid_chameleon-0.3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pyramid_chameleon/${name}.tar.gz";
      sha256 = "d176792a50eb015d7865b44bd9b24a7bd0489fa9a5cebbd17b9e05048cef9017";
    };

    propagatedBuildInputs = with self; [
      chameleon
      pyramid
      zope_interface
      setuptools
    ];

    meta = {
      maintainers = with maintainers; [ domenkozar ];
    };
  };


  pyramid_jinja2 = buildPythonPackage rec {
    name = "pyramid_jinja2-${version}";
    version = "2.5";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pyramid_jinja2/${name}.tar.gz";
      sha256 = "93c86e3103b454301f4d66640191aba047f2ab85ba75647aa18667b7448396bd";
    };

    buildInputs = with self; [ webtest ];
    propagatedBuildInputs = with self; [ jinja2 pyramid ];

    meta = {
      maintainers = with maintainers; [ domenkozar ];
      platforms = platforms.all;
    };
  };


  pyramid_mako = buildPythonPackage rec {
    name = "pyramid_mako-0.3.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pyramid_mako/${name}.tar.gz";
      sha256 = "00811djmsc4rz20kpy2paam05fbx6dmrv2i5jf90f6xp6zw4isy6";
    };

    buildInputs = with self; [ webtest ];
    propagatedBuildInputs = with self; [ pyramid Mako ];
  };


  pyramid_exclog = buildPythonPackage rec {
    name = "pyramid_exclog-0.7";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pyramid_exclog/${name}.tar.gz";
      sha256 = "a58c82866c3e1a350684e6b83b440d5dc5e92ca5d23794b56d53aac06fb65a2c";
    };

    propagatedBuildInputs = with self; [ pyramid ];

    meta = {
      maintainers = with maintainers; [ garbas domenkozar ];
      platforms = platforms.all;
    };
  };


  pyramid_multiauth = buildPythonPackage rec {
    name = "pyramid_multiauth-${version}";
    version = "0.8.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pyramid_multiauth/${name}.tar.gz";
      sha256 = "1lq292qakrm4ixi4vaif8dqywzj08pn6qy0wi4gw28blh39p0msk";
    };

    propagatedBuildInputs = with self; [ pyramid ];

    meta = {
      description = "Authentication policy for Pyramid that proxies to a stack of other authentication policies";
      homepage = https://github.com/mozilla-services/pyramid_multiauth;
    };
  };

  pyramid_hawkauth = buildPythonPackage rec {
    name = "pyramidhawkauth-${version}";
    version = "0.1.0";
    src = pkgs.fetchgit {
      url = https://github.com/mozilla-services/pyramid_hawkauth.git;
      rev = "refs/tags/v${version}";
      sha256 = "038ign7qlavlmvrhb2y8bygbxvy4j7bx2k1zg0i3wblg2ja50w7h";
    };

    propagatedBuildInputs = with self; [ pyramid hawkauthlib tokenlib ];
    buildInputs = with self; [ webtest ];
  };

  pyroute2 = callPackage ../development/python-modules/pyroute2 { };

  pyspf = buildPythonPackage rec {
    name = "pyspf-${version}";
    version = "2.0.12";

    src = pkgs.fetchurl {
      url = "mirror://sourceforge/pymilter/pyspf/${name}/${name}.tar.gz";
      sha256 = "18j1rmbmhih7q6y12grcj169q7sx1986qn4gmpla9y5gwfh1p8la";
    };

    propagatedBuildInputs = with self; [ pydns ];

    meta = {
      homepage = "http://bmsi.com/python/milter.html";
      description = "Python API for Sendmail Milters (SPF)";
      maintainers = with maintainers; [ abbradar ];
      license = licenses.gpl2;
      platforms = platforms.all;
    };
  };

  pysrt = callPackage ../development/python-modules/pysrt { };

  pytools = buildPythonPackage rec {
    name = "pytools-${version}";
    version = "2017.4";

    src = pkgs.fetchFromGitHub {
      owner = "inducer";
      repo = "pytools";
      rev = "8078e74265bb5a3c9676c698595ab5450cd2bfe7";
      sha256 = "17q61l79fcxkj5jxg3fnymi652sdjp5s6kpsabgxp22kma9crr28";
    };

    buildInputs = with self; [
      decorator
      appdirs
      six
      numpy
      pytest
    ];

    checkPhase = ''
      py.test -k 'not test_persistent_dict'
    '';

    meta = {
      homepage = https://github.com/inducer/pytools/;
      description = "Miscellaneous Python lifesavers.";
      license = licenses.mit;
      maintainers = with maintainers; [ artuuge ];
    };

  };

  pytun = buildPythonPackage rec {
    name = "pytun-${version}";
    version = "2.2.1";
    rev = "v${version}";

    src = pkgs.fetchFromGitHub {
      inherit rev;
      owner = "montag451";
      repo = "pytun";
      sha256 = "1bxk0z0v8m0b01xg94f039j3bsclkshb7girvjqfzk5whbd2nryh";
    };

    doCheck = false;

    meta = {
      homepage = https://github.com/montag451/pytun;
      description = "Linux TUN/TAP wrapper for Python";
      license = licenses.mit;
      maintainers = with maintainers; [ montag451 ];
      platforms = platforms.linux;
    };
  };

  raven = callPackage ../development/python-modules/raven { };

  rethinkdb = buildPythonPackage rec {
    name = "rethinkdb-${version}";
    version = "2.3.0.post6";

    src = pkgs.fetchurl {
      url = "mirror://pypi/r/rethinkdb/${name}.tar.gz";
      sha256 = "05qwkmq6kn437ywyjs02jxbry720gw39q4z4jdb0cnbbi76lwddm";
    };

    doCheck = false;

    meta = {
      description = "Python driver library for the RethinkDB database server";
      homepage = "https://pypi.python.org/pypi/rethinkdb";
      license = licenses.agpl3;
    };
  };

  roman = buildPythonPackage rec {
    version = "2.0.0";
    name = "roman-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/r/roman/${name}.zip";
      sha256 = "90e83b512b44dd7fc83d67eb45aa5eb707df623e6fc6e66e7f273abd4b2613ae";
    };

    buildInputs = with self; with pkgs; [ ];

    propagatedBuildInputs = with self; [ ];

    meta = {
      description = "Integer to Roman numerals converter";
      homepage = "https://pypi.python.org/pypi/roman";
      license = licenses.psfl;
    };
  };



  librosa = buildPythonPackage rec {
    pname = "librosa";
    name = "${pname}-${version}";
    version = "0.4.3";
    src = pkgs.fetchurl {
      url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
      sha256 = "209626c53556ca3922e52d2fae767bf5b398948c867fcc8898f948695dacb247";
    };

    propagatedBuildInputs = with self; [ joblib matplotlib six scikitlearn
      decorator audioread resampy ];

    # No tests
    doCheck = false;

    meta = {
      description = "Python module for audio and music processing";
      homepage = http://librosa.github.io/;
      license = licenses.isc;
    };
  };

  joblib = callPackage ../development/python-modules/joblib { };

  safe = buildPythonPackage rec {
    version = "0.4";
    name = "Safe-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/S/Safe/${name}.tar.gz";
      sha256 = "a2fdac9fe8a9dcf02b438201d6ce0b7be78f85dc6492d03edfb89be2adf489de";
    };

    buildInputs = with self; [ nose ];
    meta = {
      homepage = "https://github.com/lepture/safe";
      license = licenses.bsd3;
      description = "Check password strength";
    };
  };

  samplerate = buildPythonPackage rec {
    name = "scikits.samplerate-${version}";
    version = "0.3.3";
    src = pkgs.fetchgit {
      url = https://github.com/cournape/samplerate;
      rev = "a536c97eb2d6195b5f266ea3cc3a35364c4c2210";
      sha256 = "0mgic7bs5zv5ji05vr527jlxxlb70f9dg93hy1lzyz2plm1kf7gg";
    };

    buildInputs = with self;  [ pkgs.libsamplerate ];

    propagatedBuildInputs = with self; [ numpy ];

    preConfigure = ''
       cat > site.cfg << END
       [samplerate]
       library_dirs=${pkgs.libsamplerate.out}/lib
       include_dirs=${pkgs.libsamplerate.dev}/include
       END
    '';

    doCheck = false;
  };

  sarge = buildPythonPackage rec {
    name = "sarge-${version}";
    version = "0.1.4";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/sarge/${name}.tar.gz";
      sha256 = "08s8896973bz1gg0pkr592w6g4p6v47bkfvws5i91p9xf8b35yar";
    };

    meta = {
      homepage = "http://sarge.readthedocs.org/";
      description = "A wrapper for subprocess which provides command pipeline functionality";
      license = licenses.bsd3;
      platforms = platforms.all;
      maintainers = with maintainers; [ abbradar ];
    };
  };

  subliminal = callPackage ../development/python-modules/subliminal {};

  hyperlink = callPackage ../development/python-modules/hyperlink {};

  zope_copy = buildPythonPackage rec {
    name = "zope.copy-4.0.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/z/zope.copy/${name}.zip";
      sha256 = "eb2a95866df1377741876a3ee62d8600e80089e6246e1a235e86791b29534457";
    };

    buildInputs = with self; [ zope_interface zope_location zope_schema ];

    meta = {
      maintainers = with maintainers; [ domenkozar ];
    };
  };


  ssdeep = buildPythonPackage rec {
    name = "ssdeep-3.1.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/ssdeep/${name}.tar.gz";
      sha256 = "1p9dpykmnfb73cszdiic5wbz5bmbbmkiih08pb4dah5mwq4n7im6";
    };

    buildInputs = with pkgs; [ ssdeep ];
    propagatedBuildInputs = with self; [ cffi six ];
    meta.broken = true; # Tests fail, and no reverse-dependencies anyway
  };

  s2clientprotocol = callPackage ../development/python-modules/s2clientprotocol { };

  statsd = buildPythonPackage rec {
    name = "statsd-${version}";
    version = "3.2.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/statsd/${name}.tar.gz";
      sha256 = "3fa92bf0192af926f7a0d9be031fe3fd0fbaa1992d42cf2f07e68f76ac18288e";
    };

    buildInputs = with self; [ nose mock ];

    meta = {
      maintainers = with maintainers; [ domenkozar ];
      description = "A simple statsd client";
      license = licenses.mit;
      homepage = https://github.com/jsocol/pystatsd;
    };

    patchPhase = ''
      # Failing test: ERROR: statsd.tests.test_ipv6_resolution_udp
      sed -i 's/test_ipv6_resolution_udp/noop/' statsd/tests.py
      # well this is a noop, but so it was before
      sed -i 's/assert_called_once()/called/' statsd/tests.py
    '';

  };

  py3status = buildPythonPackage rec {
    version = "3.6";
    name = "py3status-${version}";
    src = pkgs.fetchFromGitHub {
      owner = "ultrabug";
      repo = "py3status";
      rev = version;
      sha256 = "01qvrwgkphb0lr7g9dm0hncbxcds05kg4qgbsrvnc7d5j2vhfdkr";
    };
    doCheck = false;
    propagatedBuildInputs = with self; [ requests ];
    buildInputs = with pkgs; [ file ];
    prePatch = ''
      sed -i -e "s|'file|'${pkgs.file}/bin/file|" py3status/parse_config.py
      sed -i -e "s|\[\"acpi\"|\[\"${pkgs.acpi}/bin/acpi\"|" py3status/modules/battery_level.py
      sed -i -e "s|notify-send|${pkgs.libnotify}/bin/notify-send|" py3status/modules/battery_level.py
      sed -i -e "s|/usr/bin/whoami|${pkgs.coreutils}/bin/whoami|" py3status/modules/external_script.py
      sed -i -e "s|'amixer|'${pkgs.alsaUtils}/bin/amixer|" py3status/modules/volume_status.py
      sed -i -e "s|'i3-nagbar|'${pkgs.i3}/bin/i3-nagbar|" py3status/modules/pomodoro.py
      sed -i -e "s|'free|'${pkgs.procps}/bin/free|" py3status/modules/sysdata.py
      sed -i -e "s|'sensors|'${pkgs.lm_sensors}/bin/sensors|" py3status/modules/sysdata.py
      sed -i -e "s|'setxkbmap|'${pkgs.xorg.setxkbmap}/bin/setxkbmap|" py3status/modules/keyboard_layout.py
      sed -i -e "s|'xset|'${pkgs.xorg.xset}/bin/xset|" py3status/modules/keyboard_layout.py
    '';
    meta = {
      maintainers = with maintainers; [ garbas ];
    };
  };

  multi_key_dict = buildPythonPackage rec {
    name = "multi_key_dict-${version}";
    version = "2.0.3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/m/multi_key_dict/multi_key_dict-${version}.tar.gz";
      sha256 = "17lkx4rf4waglwbhc31aak0f28c63zl3gx5k5i1iq2m3gb0xxsyy";
    };

    meta = with stdenv.lib; {
      description = "multi_key_dict";
      homepage = "https://github.com/formiaczek/multi_key_dict";
    };
  };


  pyrtlsdr = callPackage ../development/python-modules/pyrtlsdr { };

  random2 = self.buildPythonPackage rec {
    name = "random2-1.0.1";

    doCheck = !isPyPy;

    src = pkgs.fetchurl {
      url = "mirror://pypi/r/random2/${name}.zip";
      sha256 = "34ad30aac341039872401595df9ab2c9dc36d0b7c077db1cea9ade430ed1c007";
    };
  };

  scandir = self.buildPythonPackage rec {
    name = "scandir-${version}";
    version = "1.4";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/scandir/${name}.tar.gz";
      sha256 = "0yjrgp0mxp3d8bjkq2m1ac2ys8n76wykksvgyjrnil9gr3fx7a5d";
    };

    meta = with stdenv.lib; {
      description = "A better directory iterator and faster os.walk()";
      homepage = "https://github.com/benhoyt/scandir";
      license = licenses.gpl3;
      maintainers = with maintainers; [ abbradar ];
    };
  };

  scfbuild = self.buildPythonPackage rec {
    name = "scfbuild-${version}";
    version = "1.0.3";

    disabled = isPy3k;

    src = pkgs.fetchFromGitHub {
      owner = "eosrei";
      repo = "scfbuild";
      rev = "c179c8d279b7cc0a9a3536a713ac880ac6010318";
      sha256 = "1bsi7k4kkj914pycp1g92050hjxscyvc9qflqb3cv5yz3c93cs46";
    };

    phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

    propagatedBuildInputs = with self; [ pyyaml fonttools fontforge ];

    installPhase = ''
      mkdir -p $out/${python.sitePackages}
      cp -r scfbuild $out/${python.sitePackages}
      cp -r bin $out
    '';

    meta = with stdenv.lib; {
      description = "SVGinOT color font builder";
      homepage = "https://github.com/eosrei/scfbuild";
      license = licenses.gpl3;
      maintainers = with maintainers; [ abbradar ];
    };
  };

  schedule = buildPythonPackage rec {
    name = "schedule-0.3.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/10/96/d101fab391753ebc81fa3bb0e744df1ddcfb032c31b036d38083f8994db1/schedule-0.3.2.tar.gz";
      sha256 = "1h0waw4jd5ql68y5kxb9irwapkbkwfs1w0asvbl24fq5f8czdijm";
    };

    buildInputs = with self; [ mock ];

    meta = with stdenv.lib; {
      description = "Python job scheduling for humans";
      homepage = https://github.com/dbader/schedule;
      license = licenses.mit;
    };
  };

  schema = callPackage ../development/python-modules/schema {};

  svg-path = buildPythonPackage rec {
    name = "svg.path-${version}";
    version = "2.0b1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/svg.path/${name}.zip";
      sha256 = "038x4wqkbvcs71x6n6kzr4kn99csyv8v4gqzssr8pqylqpxi56bm";
    };

    meta = {
      description = "SVG path objects and parser";
      homepage = https://github.com/regebro/svg.path;
      license = licenses.cc0;
      maintainers = with maintainers; [ goibhniu ];
    };
  };

  regex = buildPythonPackage rec {
    name = "regex-${version}";
    version = "2016.11.18";

    src = pkgs.fetchurl {
      url = "mirror://pypi/r/regex/${name}.tar.gz";
      sha256 = "126ds2b355n3pgl7brshhscpxn14ycs0yznzl8k4akj4sps1i6c6";
    };

    meta = {
      description = "Alternative regular expression module, to replace re";
      homepage = "https://bitbucket.org/mrabarnett/mrab-regex";
      license = licenses.psfl;
      platforms = platforms.linux;
      maintainers = with maintainers; [ abbradar ];
    };
  };

  repoze_lru = buildPythonPackage rec {
    name = "repoze.lru-0.6";

    src = pkgs.fetchurl {
      url = "mirror://pypi/r/repoze.lru/${name}.tar.gz";
      sha256 = "0f7a323bf716d3cb6cb3910cd4fccbee0b3d3793322738566ecce163b01bbd31";
    };

    meta = {
      maintainers = with maintainers; [ garbas domenkozar ];
      platforms = platforms.all;
    };
  };



  repoze_sphinx_autointerface = buildPythonPackage rec {
    name = "repoze.sphinx.autointerface-0.7.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/r/repoze.sphinx.autointerface/${name}.tar.gz";
      sha256 = "97ef5fac0ab0a96f1578017f04aea448651fa9f063fc43393a8253bff8d8d504";
    };

    propagatedBuildInputs = with self; [ zope_interface sphinx ];

    meta = {
      maintainers = with maintainers; [ domenkozar ];
      platforms = platforms.all;
    };
  };


  setuptools-git = buildPythonPackage rec {
    name = "setuptools-git-${version}";
    version = "1.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/setuptools-git/${name}.tar.gz";
      sha256 = "047d7595546635edebef226bc566579d422ccc48a8a91c7d32d8bd174f68f831";
    };

    propagatedBuildInputs = [ pkgs.git ];
    doCheck = false;

    meta = {
      description = "Setuptools revision control system plugin for Git";
      homepage = https://pypi.python.org/pypi/setuptools-git;
      license = licenses.bsd3;
    };
  };


  watchdog = buildPythonPackage rec {
    name = "watchdog-${version}";
    version = "0.8.3";

    propagatedBuildInputs = with self; [ argh pathtools pyyaml ];

    buildInputs = stdenv.lib.optionals stdenv.isDarwin
      [ pkgs.darwin.apple_sdk.frameworks.CoreServices pkgs.darwin.cf-private ];

    doCheck = false;

    src = pkgs.fetchurl {
      url = "mirror://pypi/w/watchdog/${name}.tar.gz";
      sha256 = "0qj1vqszxwfx6d1s66s96jmfmy2j94bywxiqdydh6ikpvcm8hrby";
    };

    meta = {
      description = "Python API and shell utilities to monitor file system events";
      homepage = https://github.com/gorakhargosh/watchdog;
      license = licenses.asl20;
      maintainers = with maintainers; [ goibhniu ];
    };
  };

  pywatchman = buildPythonPackage rec {
    name = "pywatchman-${version}";
    version = "1.3.0";
    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pywatchman/pywatchman-${version}.tar.gz";
      sha256 = "c3d5be183b5b04f6ad575fc71b06dd196185dea1558d9f4d0598ba9beaab8245";
    };
    postPatch = ''
      substituteInPlace pywatchman/__init__.py \
        --replace "'watchman'" "'${pkgs.watchman}/bin/watchman'"
    '';
    # SyntaxError
    disabled = isPy3k;
    # No tests in archive
    doCheck = false;

  };

  zope_deprecation = buildPythonPackage rec {
    name = "zope.deprecation-4.1.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/z/zope.deprecation/${name}.tar.gz";
      sha256 = "fed622b51ffc600c13cc5a5b6916b8514c115f34f7ea2730409f30c061eb0b78";
    };

    buildInputs = with self; [ zope_testing ];

    meta = {
      maintainers = with maintainers; [ garbas domenkozar ];
      platforms = platforms.all;
    };
  };

  validictory = buildPythonPackage rec {
    name = "validictory-1.0.0a2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/v/validictory/validictory-1.0.0a2.tar.gz";
      sha256 = "c02388a70f5b854e71e2e09bd6d762a2d8c2a017557562e866d8ffafb0934b07";
    };

    doCheck = false;

    meta = {
      description = "Validate dicts against a schema";
      homepage = https://github.com/sunlightlabs/validictory;
      license = licenses.mit;
    };
  };

  vcrpy = callPackage ../development/python-modules/vcrpy { };

  venusian = buildPythonPackage rec {
    name = "venusian-1.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/v/venusian/${name}.tar.gz";
      sha256 = "1720cff2ca9c369c840c1d685a7c7a21da1afa687bfe62edd93cae4bf429ca5a";
    };

    # TODO: https://github.com/Pylons/venusian/issues/23
    doCheck = false;

    meta = {
      maintainers = with maintainers; [ garbas domenkozar ];
      platforms = platforms.all;
    };
  };


  chameleon = buildPythonPackage rec {
    name = "Chameleon-2.25";

    src = pkgs.fetchurl {
      url = "mirror://pypi/C/Chameleon/${name}.tar.gz";
      sha256 = "0va95cml7wfjpvgj3dc9xdn8psyjh3zbk6v51b0hcqv2fzh409vb";
    } ;

    buildInputs = with self; [] ++ optionals isPy26 [ ordereddict unittest2 ];

    meta = {
       maintainers = with maintainers; [ garbas domenkozar ];
      platforms = platforms.all;
    };
  };

  ddt = buildPythonPackage (rec {
    name = "ddt-1.0.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/d/ddt/${name}.tar.gz";
      sha256 = "e24ecb7e2cf0bf43fa9d4255d3ae2bd0b7ce30b1d1b89ace7aa68aca1152f37a";
    };

    meta = {
      description = "Data-Driven/Decorated Tests, a library to multiply test cases";

      homepage = https://github.com/txels/ddt;

      license = licenses.mit;
    };
  });

  descartes = callPackage ../development/python-modules/descartes { };

  distutils_extra = buildPythonPackage rec {
    name = "distutils-extra-${version}";
    version = "2.39";

    src = pkgs.fetchurl {
      url = "http://launchpad.net/python-distutils-extra/trunk/${version}/+download/python-${name}.tar.gz";
      sha256 = "1bv3h2p9ffbzyddhi5sccsfwrm3i6yxzn0m06fdxkj2zsvs28gvj";
    };

    meta = {
      homepage = https://launchpad.net/python-distutils-extra;
      description = "Enhancements to Python's distutils";
      license = licenses.gpl2;
    };
  };

  pyxdg = buildPythonPackage rec {
    name = "pyxdg-0.25";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pyxdg/${name}.tar.gz";
      sha256 = "81e883e0b9517d624e8b0499eb267b82a815c0b7146d5269f364988ae031279d";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://freedesktop.org/wiki/Software/pyxdg;
      description = "Contains implementations of freedesktop.org standards";
      license = licenses.lgpl2;
      maintainers = with maintainers; [ domenkozar ];
    };
  };

  chardet = callPackage ../development/python-modules/chardet { };

  django = self.django_1_11;

  django_1_11 = callPackage ../development/python-modules/django/1_11.nix {
    gdal = self.gdal;
  };

  django_1_8 = buildPythonPackage rec {
    name = "Django-${version}";
    version = "1.8.18";
    disabled = pythonOlder "2.7";

    src = pkgs.fetchurl {
      url = "http://www.djangoproject.com/m/releases/1.8/${name}.tar.gz";
      sha256 = "1ishvbihr9pain0486qafb18dnb7v2ppq34nnx1s8f95bvfiqqf7";
    };

    # too complicated to setup
    doCheck = false;

    # patch only $out/bin to avoid problems with starter templates (see #3134)
    postFixup = ''
      wrapPythonProgramsIn $out/bin "$out $pythonPath"
    '';

    meta = {
      description = "A high-level Python Web framework";
      homepage = https://www.djangoproject.com/;
    };
  };

  django_appconf = callPackage ../development/python-modules/django_appconf { };

  django_colorful = buildPythonPackage rec {
    name = "django-colorful-${version}";
    version = "1.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/d/django-colorful/${name}.tar.gz";
      sha256 = "0y34hzvfrm1xbxrd8frybc9yzgqvz4c07frafipjikw7kfjsw8az";
    };

    # Tests aren't run
    doCheck = false;

    # Requires Django >= 1.8
    buildInputs = with self; [ django ];

    meta = {
      description = "Django extension that provides database and form color fields";
      homepage = https://github.com/charettes/django-colorful;
      license = licenses.mit;
    };
  };

  django_compressor = callPackage ../development/python-modules/django_compressor { };

  django_compat = callPackage ../development/python-modules/django-compat { };

  django_environ = buildPythonPackage rec {
    name = "django-environ-${version}";
    version = "0.4.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/d/django-environ/${name}.tar.gz";
      sha256 = "0i32vsgk1xmwpi7i6f6v5hg653y9dl0fsz5qmv94skz6hwgm5kvh";
    };

    # The testsuite fails to modify the base environment
    doCheck = false;
    propagatedBuildInputs = with self ; [ django six ];

    meta = {
      description = "Utilize environment variables to configure your Django application";
      homepage = https://github.com/joke2k/django-environ/;
      license = licenses.mit;
    };
  };

  django_evolution = buildPythonPackage rec {
    name = "django_evolution-0.7.5";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/d/django_evolution/${name}.tar.gz";
      sha256 = "1qbcx54hq8iy3n2n6cki3bka1m9rp39np4hqddrm9knc954fb7nv";
    };

    propagatedBuildInputs = with self; [ django ];

    meta = {
      description = "A database schema evolution tool for the Django web framework";
      homepage = http://code.google.com/p/django-evolution/;
    };
  };

  django_extensions = callPackage ../development/python-modules/django-extensions { };

  django_guardian = callPackage ../development/python-modules/django_guardian { };

  django-ipware = callPackage ../development/python-modules/django-ipware { };

  django-jinja = callPackage ../development/python-modules/django-jinja2 { };

  django-pglocks = callPackage ../development/python-modules/django-pglocks { };

  django-picklefield = callPackage ../development/python-modules/django-picklefield { };

  django_polymorphic = callPackage ../development/python-modules/django-polymorphic { };

  django-sampledatahelper = callPackage ../development/python-modules/django-sampledatahelper { };

  django-sites = callPackage ../development/python-modules/django-sites { };

  django-sr = callPackage ../development/python-modules/django-sr { };

  django_tagging = callPackage ../development/python-modules/django_tagging { };

  django_tagging_0_4_3 = if
       self.django != self.django_1_8
  then throw "django_tagging_0_4_3 should be build with django_1_8"
  else (callPackage ../development/python-modules/django_tagging {}).overrideAttrs (attrs: rec {
    name = "django-tagging-0.4.3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/d/django-tagging/${name}.tar.gz";
      sha256 = "0617azpmp6jpg3d88v2ir97qrc9aqcs2s9gyvv9bgf2cp55khxhs";
    };
    propagatedBuildInputs = with self; [ django ];
  });

  django_classytags = buildPythonPackage rec {
    name = "django-classy-tags-${version}";
    version = "0.6.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/d/django-classy-tags/${name}.tar.gz";
      sha256 = "0wxvpmjdzk0aajk33y4himn3wqjx7k0aqlka9j8ay3yfav78bdq0";
    };

    propagatedBuildInputs = with self; [ django ];

    # tests appear to be broken on 0.6.1 at least
    doCheck = ( version != "0.6.1" );

    meta = {
      description = "Class based template tags for Django";
      homepage = https://github.com/ojii/django-classy-tags;
      license = licenses.bsd3;
    };
  };

  # This package may need an older version of Django.
  # Override the package set and set e.g. `django = super.django_1_9`.
  # See the Nixpkgs manual for examples on how to override the package set.
  django_hijack = callPackage ../development/python-modules/django-hijack { };

  django_nose = buildPythonPackage rec {
    name = "django-nose-${version}";
    version = "1.4.4";

    src = pkgs.fetchurl {
      url = "mirror://pypi/d/django-nose/${name}.tar.gz";
      sha256 = "1fm47fkza2lk0xgc6qpi9vs78zg7q8cgl6mdan69sbycgy909ff0";
    };

    # vast dependency list
    doCheck = false;

    propagatedBuildInputs = with self; [ django nose ];

    meta = {
      description = "Provides all the goodness of nose in your Django tests";
      homepage = https://github.com/django-nose/django-nose;
      license = licenses.bsd3;
    };
  };

  django_modelcluster = buildPythonPackage rec {
    name = "django-modelcluster-${version}";
    version = "0.6.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/d/django-modelcluster/django-modelcluster-${version}.tar.gz";
      sha256 = "1plsdi44dvsj2sfx79lsrccjfg0ymajcsf5n0mln4cwd4qi5mwpx";
    };

    doCheck = false;

    propagatedBuildInputs = with self; [ pytz six ];

    meta = {
      description = "Django extension to allow working with 'clusters' of models as a single unit, independently of the database";
      homepage = https://github.com/torchbox/django-modelcluster/;
      license = licenses.bsd2;
      maintainers = with maintainers; [ desiderius ];
    };
  };

  djangorestframework = callPackage ../development/python-modules/djangorestframework { };

  django-raster = callPackage ../development/python-modules/django-raster { };

  django_redis = callPackage ../development/python-modules/django_redis { };

  django_reversion = buildPythonPackage rec {
    name = "django-reversion-${version}";
    version = "1.10.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/d/django-reversion/${name}.tar.gz";
      sha256 = "01iv8w6lmmq98qjhxmnp8ddjxifmhxcmp612ijd91wc8nv8lk12w";
    };

    propagatedBuildInputs = with self; [ django ] ++
      (optionals (pythonOlder "2.7") [ importlib ordereddict ]);

    meta = {
      description = "An extension to the Django web framework that provides comprehensive version control facilities";
      homepage = https://github.com/etianen/django-reversion;
      license = licenses.bsd3;
    };
  };

  django_silk = buildPythonPackage rec {
    name = "django-silk-${version}";
    version = "0.5.6";

    src = pkgs.fetchurl {
      url = "mirror://pypi/d/django-silk/${name}.tar.gz";
      sha256 = "845abc688738858ce06e993c4b7dbbcfcecf33029e828f143463ff96f9a78947";
    };

    doCheck = false;

    buildInputs = [ self.mock ];

    propagatedBuildInputs = with self; [
      django
      pygments
      simplejson
      dateutil
      requests
      sqlparse
      jinja2
      autopep8
      pytz
      pillow
    ];

    meta = {
      description = "Silky smooth profiling for the Django Framework";
      homepage = https://github.com/mtford90/silk;
      license = licenses.mit;
    };
  };

  django_taggit = buildPythonPackage rec {
    name = "django-taggit-${version}";
    version = "0.17.0";
    disabled = pythonOlder "2.7";

    src = pkgs.fetchurl {
      url = "mirror://pypi/d/django-taggit/django-taggit-${version}.tar.gz";
      sha256 = "1xy4mm1y6z6bpakw907859wz7fiw7jfm586dj89w0ggdqlb0767b";
    };

    doCheck = false;

    meta = {
      description = "django-taggit is a reusable Django application for simple tagging";
      homepage = https://github.com/alex/django-taggit/tree/master/;
      license = licenses.bsd2;
      maintainers = with maintainers; [ desiderius ];
    };
  };

  django_treebeard = buildPythonPackage rec {
    name = "django-treebeard-${version}";
    version = "3.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/d/django-treebeard/${name}.tar.gz";
      sha256 = "10p9rb2m1zccszg7590fjd0in6rabzsh86f5m7qm369mapc3b6dc";
    };

    buildInputs = with self; [ pytest ];
    propagatedBuildInputs = with self; [ django ];

    meta = {
      description = "Efficient tree implementations for Django 1.6+";
      homepage = https://tabo.pe/projects/django-treebeard/;
      maintainers = with maintainers; [ desiderius ];
      license = licenses.asl20;
    };
  };

  django_pipeline = buildPythonPackage rec {
    name = "django-pipeline-${version}";
    version = "1.5.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/d/django-pipeline/${name}.tar.gz";
      sha256 = "1y49fa8jj7x9qjj5wzhns3zxwj0s73sggvkrv660cqw5qb7d8hha";
    };

    propagatedBuildInputs = with self; [ django futures ];

    meta = with stdenv.lib; {
      description = "Pipeline is an asset packaging library for Django";
      homepage = https://github.com/cyberdelia/django-pipeline;
      license = stdenv.lib.licenses.mit;
    };
  };

  django_pipeline_1_3 = self.django_pipeline.overrideDerivation (super: rec {
    name = "django-pipeline-1.3.27";
    src = pkgs.fetchurl {
      url = "mirror://pypi/d/django-pipeline/${name}.tar.gz";
      sha256 = "0iva3cmnh5jw54c7w83nx9nqv523hjvkbjchzd2pb6vzilxf557k";
    };
  });


  djblets = if (versionOlder self.django.version "1.6.11") ||
               (versionAtLeast self.django.version "1.9")
            then throw "djblets only suported for Django<1.8.999,>=1.6.11"
            else buildPythonPackage rec {
    name = "Djblets-0.9";

    src = pkgs.fetchurl {
      url = "http://downloads.reviewboard.org/releases/Djblets/0.9/${name}.tar.gz";
      sha256 = "1rr5vjwiiw3kih4k9nawislf701l838dbk5xgizadvwp6lpbpdpl";
    };

    propagatedBuildInputs = with self; [
      django feedparser django_pipeline_1_3 pillowfight pytz ];

    meta = {
      description = "A collection of useful extensions for Django";
      homepage = https://github.com/djblets/djblets;
    };
  };

  djmail = callPackage ../development/python-modules/djmail { };

  pillowfight = buildPythonPackage rec {
    name = "pillowfight-${version}";
    version = "0.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pillowfight/pillowfight-${version}.tar.gz";
      sha256 = "1mh1nhcjjgv7x134sv0krri59ng8bp2w6cwsxc698rixba9f3g0m";
    };

    propagatedBuildInputs = with self; [
      pillow
    ];
    meta = with stdenv.lib; {
      description = "Pillow Fight";
      homepage = "https://github.com/beanbaginc/pillowfight";
    };
  };

  kaptan = buildPythonPackage rec {
    name = "kaptan-${version}";
    version = "0.5.8";

    src = pkgs.fetchurl {
      url = "mirror://pypi/k/kaptan/${name}.tar.gz";
      sha256 = "1b8r86yyvdvyxd6f10mhkl6cr2jhxm80jjqr4zch96w9hs9rh5vq";
    };

    propagatedBuildInputs = with self; [ pyyaml ];

    meta = with stdenv.lib; {
      description = "Configuration manager for python applications";
      homepage = https://emre.github.io/kaptan/;
      license = licenses.bsd3;
      platforms = platforms.linux;
      maintainers = with maintainers; [ jgeerds ];
    };
  };

  keepalive = buildPythonPackage rec {
    name = "keepalive-${version}";
    version = "0.5";

    src = pkgs.fetchurl {
      url = "mirror://pypi/k/keepalive/keepalive-${version}.tar.gz";
      sha256 = "3c6b96f9062a5a76022f0c9d41e9ef5552d80b1cadd4fccc1bf8f183ba1d1ec1";
    };

    # No tests included
    doCheck = false;

    meta = with stdenv.lib; {
      description = "An HTTP handler for `urllib2` that supports HTTP 1.1 and keepalive";
      homepage = "https://github.com/wikier/keepalive";
    };
  };


  SPARQLWrapper = buildPythonPackage rec {
    name = "SPARQLWrapper-${version}";
    version = "1.7.6";

    src = pkgs.fetchurl {
      url = "mirror://pypi/S/SPARQLWrapper/SPARQLWrapper-${version}.tar.gz";
      sha256 = "1y12hpsfjd779yi29bhvl6g4vszadjvd8jw38z5rg77b034vxjnw";
    };

    # break circular dependency loop
    patchPhase = ''
      sed -i '/rdflib/d' requirements.txt
    '';

    # Doesn't actually run tests
    doCheck = false;

    propagatedBuildInputs = with self; [
      six isodate pyparsing html5lib keepalive
    ];

    meta = with stdenv.lib; {
      description = "This is a wrapper around a SPARQL service. It helps in creating the query URI and, possibly, convert the result into a more manageable format";
      homepage = "http://rdflib.github.io/sparqlwrapper";
    };
  };

  dulwich = callPackage ../development/python-modules/dulwich {
    inherit (pkgs) git glibcLocales;
  };

  hg-git = buildPythonPackage rec {
    name = "hg-git-${version}";
    version = "0.8.10";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/h/hg-git/${name}.tar.gz";
      sha256 = "03dzcs4l7hzq59sgjhngxgmi34xfyd7jcxyjl0f68rwq8b1yqrp3";
    };

    propagatedBuildInputs = with self; [ dulwich ];

    meta = {
      description = "Push and pull from a Git server using Mercurial";
      homepage = http://hg-git.github.com/;
      maintainers = with maintainers; [ koral ];
    };
  };


  docutils = buildPythonPackage rec {
    name = "docutils-${version}";
    version = "0.13.1";

    src = pkgs.fetchurl {
      url = "mirror://sourceforge/docutils/${name}.tar.gz";
      sha256 = "1gkma47i609jfs7dssxn4y9vsz06qi0l5q41nws0zgkpnrghz33i";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      description = "An open-source text processing system for processing plaintext documentation into useful formats, such as HTML or LaTeX";
      homepage = http://docutils.sourceforge.net/;
      maintainers = with maintainers; [ garbas AndersonTorres ];
    };
  };


  dtopt = buildPythonPackage rec {
    name = "dtopt-0.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/d/dtopt/${name}.tar.gz";
      sha256 = "06ae07a12294a7ba708abaa63f838017d1a2faf6147a1e7a14ca4fa28f86da7f";
    };

    meta = {
      description = "Add options to doctest examples while they are running";
      homepage = https://pypi.python.org/pypi/dtopt;
    };
    # Test contain Python 2 print
    disabled = isPy3k;
  };


  ecdsa = buildPythonPackage rec {
    name = "ecdsa-${version}";
    version = "0.13";

    src = pkgs.fetchurl {
      url = "mirror://pypi/e/ecdsa/${name}.tar.gz";
      sha256 = "1yj31j0asmrx4an9xvsaj2icdmzy6pw0glfpqrrkrphwdpi1xkv4";
    };

    # Only needed for tests
    buildInputs = with self; [ pkgs.openssl ];

    meta = {
      description = "ECDSA cryptographic signature library";
      homepage = "https://github.com/warner/python-ecdsa";
      license = licenses.mit;
      maintainers = with maintainers; [ aszlig ];
    };
  };


  elpy = buildPythonPackage rec {
    name = "elpy-${version}";
    version = "1.9.0";
    src = pkgs.fetchurl {
      url = "mirror://pypi/e/elpy/${name}.tar.gz";
      sha256 = "419f7b05b19182bc1aedde1ae80812c1534e59a0493476aa01ea819e76ba26f0";
    };
    python2Deps = if isPy3k then [ ] else [ self.rope ];
    propagatedBuildInputs = with self; [ flake8 autopep8 jedi importmagic ] ++ python2Deps;

    doCheck = false; # there are no tests

    meta = {
      description = "Backend for the elpy Emacs mode";
      homepage = "https://github.com/jorgenschaefer/elpy";
    };
  };


  enum = buildPythonPackage rec {
    name = "enum-0.4.4";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/e/enum/${name}.tar.gz";
      sha256 = "9bdfacf543baf2350df7613eb37f598a802f346985ca0dc1548be6494140fdff";
    };

    doCheck = !isPyPy;

    buildInputs = with self; [ ];

    propagatedBuildInputs = with self; [ ];

    meta = {
      homepage = https://pypi.python.org/pypi/enum/;
      description = "Robust enumerated type support in Python";
    };
  };

  enum-compat = buildPythonPackage rec {
    pname = "enum-compat";
    version = "0.0.2";
    name = "${pname}-${version}";

    src = fetchPypi {
      inherit pname version;
      sha256 = "14j1i963jic2vncbf9k5nq1vvv8pw2zsg7yvwhm7d9c6h7qyz74k";
    };

    propagatedBuildInputs = with self; [ enum34 ];

    meta = {
      homepage = "https://github.com/jstasiak/enum-compat";
      description = "enum/enum34 compatibility package";
      license = licenses.mit;
      maintainers = with maintainers; [ abbradar ];
    };
  };

  enum34 = if pythonAtLeast "3.4" then null else buildPythonPackage rec {
    pname = "enum34";
    version = "1.1.6";
    name = "${pname}-${version}";

    src = fetchPypi {
      inherit pname version;
      sha256 = "8ad8c4783bf61ded74527bffb48ed9b54166685e4230386a9ed9b1279e2df5b1";
    };

    buildInputs = optional isPy26 self.ordereddict;
    checkPhase = ''
      ${python.interpreter} -m unittest discover
    '';


    meta = {
      homepage = https://pypi.python.org/pypi/enum34;
      description = "Python 3.4 Enum backported to 3.3, 3.2, 3.1, 2.7, 2.6, 2.5, and 2.4";
      license = "BSD";
    };
  };

  epc = buildPythonPackage rec {
    name = "epc-0.0.3";
    src = pkgs.fetchurl {
      url = "mirror://pypi/e/epc/${name}.tar.gz";
      sha256 = "30b594bd4a4acbd5bda0d3fa3d25b4e8117f2ff8f24d2d1e3e36c90374f3c55e";
    };

    propagatedBuildInputs = with self; [ sexpdata ];
    doCheck = false;

    meta = {
      description = "EPC (RPC stack for Emacs Lisp) implementation in Python";
      homepage = "https://github.com/tkf/python-epc";
    };
  };

  et_xmlfile = buildPythonPackage rec {
    version = "1.0.1";
    name = "et_xmlfile-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/e/et_xmlfile/${name}.tar.gz";
      sha256="0nrkhcb6jdrlb6pwkvd4rycw34y3s931hjf409ij9xkjsli9fkb1";
    };

    buildInputs = with self; [ lxml pytest ];
    checkPhase = ''
      py.test $out
    '';

    meta = {
      description = "An implementation of lxml.xmlfile for the standard library";
      longDescription = ''
        et_xmlfile is a low memory library for creating large XML files.

        It is based upon the xmlfile module from lxml with the aim of allowing
        code to be developed that will work with both libraries. It was developed
        initially for the openpyxl project but is now a standalone module.

        The code was written by Elias Rabel as part of the Python Düsseldorf
        openpyxl sprint in September 2014.
      '';
      homepage = "https://pypi.python.org/pypi/et_xmlfile";
      license = licenses.mit;
      maintainers = with maintainers; [ sjourdois ];
    };
  };

  eventlet = buildPythonPackage rec {
    pname = "eventlet";
    version = "0.20.0";
    name = "${pname}-${version}";

    src = fetchPypi {
      inherit pname version;
      sha256 = "15bq5ybbigxnp5xwkps53zyhlg15lmcnq3ny2dppj0r0bylcs5rf";
    };

    buildInputs = with self; [ nose httplib2 pyopenssl  ];

    doCheck = false;  # too much transient errors to bother

    propagatedBuildInputs = optionals (!isPyPy) [ self.greenlet ] ++
      (with self; [ enum-compat ]) ;

    meta = {
      homepage = https://pypi.python.org/pypi/eventlet/;
      description = "A concurrent networking library for Python";
    };
  };

  exifread = buildPythonPackage rec {
    name = "ExifRead-2.1.2";

    meta = {
      description = "Easy to use Python module to extract Exif metadata from tiff and jpeg files";
      homepage    = "https://github.com/ianare/exif-py";
      license     = "BSD";
      maintainers = with maintainers; [ vozz ];
    };

    src = pkgs.fetchurl {
      url = "mirror://pypi/E/ExifRead/${name}.tar.gz";
      sha256 = "1b90jf6m9vxh9nanhpyvqdq7hmfx5iggw1l8kq10jrs6xgr49qkr";
    };
  };

  fastimport = callPackage ../development/python-modules/fastimport { };

  feedgen = callPackage ../development/python-modules/feedgen { };

  feedgenerator = callPackage ../development/python-modules/feedgenerator {
    inherit (pkgs) glibcLocales;
  };

  feedparser = buildPythonPackage (rec {
    name = "feedparser-5.2.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/f/feedparser/${name}.tar.gz";
      sha256 = "1ycva69bqssalhqg45rbrfipz3l6hmycszy26k0351fhq990c0xx";
    };

    # lots of networking failures
    doCheck = false;

    meta = {
      homepage = http://code.google.com/p/feedparser/;
      description = "Universal feed parser";
      license = licenses.bsd2;
      maintainers = with maintainers; [ domenkozar ];
    };
  });

  pyfribidi = buildPythonPackage rec {
    version = "0.11.0";
    name = "pyfribidi-${version}";
    disabled = isPy3k || isPyPy;

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pyfribidi/${name}.zip";
      sha256 = "6f7d83c09eae0cb98a40b85ba3dedc31af4dbff8fc4425f244c1e9f44392fded";
    };

    meta = {
      description = "A simple wrapper around fribidi";
      homepage = https://github.com/pediapress/pyfribidi;
      license = stdenv.lib.licenses.gpl2;
    };
  };

  docker_compose = callPackage ../development/python-modules/docker_compose {};

  fdroidserver = buildPythonPackage rec {
    version = "2016-05-31";
    name = "fdroidserver-git-${version}";

    disabled = ! isPy3k;

    src = pkgs.fetchFromGitLab {
      owner = "fdroid";
      repo = "fdroidserver";
      rev = "401649e0365e6e365fc48ae8a3af94768af865f3";
      sha256 = "1mmi2ffpym1qw694yj938kc7b4xhq0blri7wkjaqddcyykjyr94d";
    };

    propagatedBuildInputs = with self; [ libcloud pyyaml paramiko pyasn1 pyasn1-modules pillow mwclient GitPython ];

    meta = {
      homepage = https://f-droid.org;
      description = "Server and tools for F-Droid, the Free Software repository system for Android";
      maintainers = with maintainers; [ ];
      license = licenses.agpl3;
    };
  };

  filebrowser_safe = buildPythonPackage rec {
    version = "0.3.6";
    name = "filebrowser_safe-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/f/filebrowser_safe/${name}.tar.gz";
      sha256 = "02bn60fdslvng2ckn65fms3hjbzgsa8qa5161a8lr720wbx8gpj2";
    };

    buildInputs = [ self.django ];

    # There is no test embedded
    doCheck = false;

    meta = {
      description = "A snapshot of django-filebrowser for the Mezzanine CMS";
      longDescription = ''
        filebrowser_safe was created to provide a snapshot of the FileBrowser
        asset manager for Django, to be referenced as a dependency for the
        Mezzanine CMS for Django.

        At the time of filebrowser_safe's creation, FileBrowser was incorrectly
        packaged on PyPI, and had also dropped compatibility with Django 1.1 -
        filebrowser_safe was therefore created to address these specific
        issues.
      '';
      homepage = https://github.com/stephenmcd/filebrowser-safe;
      downloadPage = https://pypi.python.org/pypi/filebrowser_safe/;
      license = licenses.free;
      maintainers = with maintainers; [ prikhi ];
      platforms = platforms.linux;
    };
  };

  pycodestyle = callPackage ../development/python-modules/pycodestyle { };

  filebytes = buildPythonPackage rec {
    name = "filebytes-0.9.12";
    src = pkgs.fetchurl {
      url = "mirror://pypi/f/filebytes/${name}.tar.gz";
      sha256 = "6cd1c4ca823f6541c963a317e55382609789802dedad08209f4d038369e3f0ac";
    };
    propagatedBuildInputs = [ ];
    meta = with pkgs.stdenv.lib; {
      homepage = "https://scoding.de/filebytes-introduction";
      license = licenses.gpl2;
      description = "Scripts to parse ELF, PE, Mach-O and OAT (Android Runtime)";
      maintainers = with maintainers; [ bennofs ];
    };
  };

  fiona = callPackage ../development/python-modules/fiona { gdal = pkgs.gdal; };

  flake8 = callPackage ../development/python-modules/flake8 { };

  flake8-blind-except = callPackage ../development/python-modules/flake8-blind-except { };

  flake8-debugger = callPackage ../development/python-modules/flake8-debugger { };

  flake8-future-import = callPackage ../development/python-modules/flake8-future-import { };

  flaky = buildPythonPackage rec {
    name = "flaky-${version}";
    version = "3.1.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/f/flaky/${name}.tar.gz";
      sha256 = "1x9ixika7wqjj52x8wnsh1vk7jadkdqpx01plj7mlh8slwyq4s41";
    };

    buildInputs = with self; [ mock pytest ];

    # waiting for feedback https://github.com/box/flaky/issues/97
    doCheck = false;

    meta = {
      homepage = https://github.com/box/flaky;
      description = "Plugin for nose or py.test that automatically reruns flaky tests";
      license = licenses.asl20;
    };
  };

  flask = callPackage ../development/python-modules/flask { };

  flask_assets = buildPythonPackage rec {
    name = "Flask-Assets-${version}";
    version = "0.12";

    src = pkgs.fetchurl {
      url = "mirror://pypi/F/Flask-Assets/${name}.tar.gz";
      sha256 = "0ivqsihk994rxw58vdgzrx4d77d7lpzjm4qxb38hjdgvi5xm4cb0";
    };

    propagatedBuildInputs = with self; [ flask webassets flask_script nose ];

    meta = {
      homepage = "http://github.com/miracle2k/flask-assets";
      description = "Asset management for Flask, to compress and merge CSS and Javascript files";
      license = licenses.bsd2;
      maintainers = with maintainers; [ abbradar ];
    };
  };

  flask_cache = buildPythonPackage rec {
    name = "Flask-Cache-0.13.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/F/Flask-Cache/${name}.tar.gz";
      sha256 = "90126ca9bc063854ef8ee276e95d38b2b4ec8e45fd77d5751d37971ee27c7ef4";
    };

    propagatedBuildInputs = with self; [ werkzeug flask ];

    meta = {
      homepage = https://github.com/thadeusb/flask-cache;
      description = "Adds cache support to your Flask application";
      license = "BSD";
    };
  };

  flask-compress = callPackage ../development/python-modules/flask-compress { };

  flask-cors = callPackage ../development/python-modules/flask-cors { };

  flask_elastic = callPackage ../development/python-modules/flask-elastic { };

  flask_login = callPackage ../development/python-modules/flask-login { };

  flask_ldap_login = callPackage ../development/python-modules/flask-ldap-login { };

  flask_mail = callPackage ../development/python-modules/flask-mail { };

  flask_marshmallow = callPackage ../development/python-modules/flask-marshmallow { };

  flask_migrate = callPackage ../development/python-modules/flask-migrate { };

  flask_oauthlib = callPackage ../development/python-modules/flask-oauthlib { };

  flask_principal = buildPythonPackage rec {
    name = "Flask-Principal-${version}";
    version = "0.4.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/F/Flask-Principal/${name}.tar.gz";
      sha256 = "0lwlr5smz8vfm5h9a9i7da3q1c24xqc6vm9jdywdpgxfbi5i7mpm";
    };

    propagatedBuildInputs = with self; [ flask blinker nose ];

    meta = {
      homepage = "http://packages.python.org/Flask-Principal/";
      description = "Identity management for flask";
      license = licenses.bsd2;
      platforms = platforms.all;
      maintainers = with maintainers; [ abbradar ];
    };
  };

  flask-pymongo = callPackage ../development/python-modules/Flask-PyMongo { };

  flask-restful = callPackage ../development/python-modules/flask-restful { };

  flask-restplus = callPackage ../development/python-modules/flask-restplus { };

  flask_script = buildPythonPackage rec {
    name = "Flask-Script-${version}";
    version = "2.0.5";

    src = pkgs.fetchurl {
      url = "mirror://pypi/F/Flask-Script/${name}.tar.gz";
      sha256 = "0zqh2yq8zk7m9b4xw1ryqmrljkdigfb3hk5155a3b5hkfnn6xxyf";
    };

    nativeBuildInputs = with self; [ pytest ];
    propagatedBuildInputs = with self; [ flask ];

    meta = {
      homepage = "http://github.com/smurfix/flask-script";
      description = "Scripting support for Flask";
      license = licenses.bsd3;
      platforms = platforms.all;
      maintainers = with maintainers; [ abbradar ];
    };
  };

  flask_sqlalchemy = buildPythonPackage rec {
    name = "Flask-SQLAlchemy-${version}";
    version = "2.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/F/Flask-SQLAlchemy/${name}.tar.gz";
      sha256 = "1i9ps5d5snih9xlqhrvmi3qfiygkmqzxh92n25kj4pf89kj4s965";
    };

    propagatedBuildInputs = with self ; [ flask sqlalchemy ];

    meta = {
      description = "SQLAlchemy extension for Flask";
      homepage = http://flask-sqlalchemy.pocoo.org/;
      license = licenses.bsd3;
    };
  };

  flask_testing = callPackage ../development/python-modules/flask-testing { };

  flask_wtf = callPackage ../development/python-modules/flask-wtf { };

  wtforms = buildPythonPackage rec {
    version = "2.1";
    name = "wtforms-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/W/WTForms/WTForms-${version}.zip";
      sha256 = "0vyl26y9cg409cfyj8rhqxazsdnd0jipgjw06civhrd53yyi1pzz";
    };

    # Django tests are broken "django.core.exceptions.AppRegistryNotReady: Apps aren't loaded yet."
    # This is fixed in master I believe but not yet in 2.1;
    doCheck = false;

    propagatedBuildInputs = with self; ([ Babel ] ++ (optionals isPy26 [ ordereddict ]));

    meta = {
      homepage = https://github.com/wtforms/wtforms;
      description = "A flexible forms validation and rendering library for Python";
      license = licenses.bsd3;
    };
  };

  # py3k disabled, see https://travis-ci.org/NixOS/nixpkgs/builds/48759067
  graph-tool = if isPy3k then throw "graph-tool in Nix doesn't support py3k yet"
    else callPackage ../development/python-modules/graph-tool/2.x.x.nix { boost = pkgs.boost159; };

  grappelli_safe = buildPythonPackage rec {
    version = "0.3.13";
    name = "grappelli_safe-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/g/grappelli_safe/${name}.tar.gz";
      sha256 = "8b21b4724bce449cc4f22dc74ed0be9b3e841d968f3271850bf4836864304eb6";
    };

    meta = {
      description = "A snapshot of django-grappelli for the Mezzanine CMS";
      longDescription = ''
        grappelli_safe was created to provide a snapshot of the Grappelli admin
        skin for Django, to be referenced as a dependency for the Mezzanine CMS
        for Django.

        At the time of grappelli_safe's creation, Grappelli was incorrectly
        packaged on PyPI, and had also dropped compatibility with Django 1.1 -
        grappelli_safe was therefore created to address these specific issues.
      '';
      homepage = https://github.com/stephenmcd/grappelli-safe;
      downloadPage = http://pypi.python.org/pypi/grappelli_safe/;
      license = licenses.free;
      maintainers = with maintainers; [ prikhi ];
      platforms = platforms.linux;
    };
  };

  pytorch = callPackage ../development/python-modules/pytorch { };

  python2-pythondialog = buildPythonPackage rec {
    name = "python2-pythondialog-${version}";
    version = "3.3.0";
    disabled = !isPy27;

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/python2-pythondialog/python2-pythondialog-${version}.tar.gz";
      sha256 = "1yhkagsh99bfi592ymczf8rnw8rk6n9hdqy3dd98m3yrx8zmjvry";
    };

    patchPhase = ''
      substituteInPlace dialog.py --replace ":/bin:/usr/bin" ":$out/bin"
    '';

    meta = with stdenv.lib; {
      homepage = "http://pythondialog.sourceforge.net/";
    };
  };

  pyRFC3339 = buildPythonPackage rec {
    name = "pyRFC3339-${version}";
    version = "0.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pyRFC3339/pyRFC3339-${version}.tar.gz";
      sha256 = "1pp648xsjaw9h1xq2mgwzda5wis2ypjmzxlksc1a8grnrdmzy155";
    };

    propagatedBuildInputs = with self; [ pytz ];
    buildInputs = with self; [ nose ];
  };

  ConfigArgParse = callPackage ../development/python-modules/configargparse { };

  jsonschema = callPackage ../development/python-modules/jsonschema { };

  vcversioner = callPackage ../development/python-modules/vcversioner { };

  falcon = buildPythonPackage (rec {
    name = "falcon-1.0.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/f/falcon/${name}.tar.gz";
      sha256 = "ddce23a2dd0abba6d19775e9bf7ba64e184b15a0e7163e65f62af63354193f63";
    };

    buildInputs = with self; stdenv.lib.optionals doCheck [coverage ddt nose pyyaml requests testtools];
    propagatedBuildInputs = with self; [ six python_mimeparse ];

    # The travis build fails since the migration from multiprocessing to threading for hosting the API under test.
    # OSError: [Errno 98] Address already in use
    doCheck = false;

    meta = {
      description = "An unladen web framework for building APIs and app backends";
      homepage = http://falconframework.org;
      license = licenses.asl20;
      maintainers = with maintainers; [ desiderius ];
    };
  });
  hug = buildPythonPackage rec {
    name = "hug-2.1.2";
    src = pkgs.fetchurl {
      url = "mirror://pypi/h/hug/${name}.tar.gz";
      sha256 = "93325e13706594933a9afb0d4f0b0748134494299038f07df41152baf6f89f4c";
    };
    disabled = !isPy3k;

    propagatedBuildInputs = with self; [ falcon requests ];

    # tests are not shipped in the tarball
    doCheck = false;

    meta = {
      description = "A Python framework that makes developing APIs as simple as possible, but no simpler";
      homepage = https://github.com/timothycrosley/hug;
      license = licenses.mit;
    };
  };
  flup = buildPythonPackage (rec {
    name = "flup-1.0.2";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "http://www.saddi.com/software/flup/dist/${name}.tar.gz";
      sha256 = "1nbx174g40l1z3a8arw72qz05a1qxi3didp9wm7kvkn1bxx33bab";
    };

    meta = {
      homepage = "http://trac.saddi.com/flup";
      description = "FastCGI Python module set";
    };
  });

  fn = callPackage ../development/python-modules/fn { };

  folium = callPackage ../development/python-modules/folium { };

  fontforge = pkgs.fontforge.override {
    withPython = true;
    inherit python;
  };

  fonttools = callPackage ../development/python-modules/fonttools { };

  foolscap = buildPythonPackage (rec {
    name = "foolscap-${version}";
    version = "0.12.6";

    src = pkgs.fetchurl {
      url = "mirror://pypi/f/foolscap/${name}.tar.gz";
      sha256 = "1bpmqq6485mmr5jza9q2c55l9m1bfsvsbd9drsip7p5qcsi22jrz";
    };

    propagatedBuildInputs = with self; [ mock twisted pyopenssl service-identity ];

    checkPhase = ''
      # Either uncomment this, or remove this custom check phase entirely, if
      # you wish to do battle with the foolscap tests. ~ C.
      # trial foolscap
    '';

    meta = {
      homepage = http://foolscap.lothar.com/;

      description = "Foolscap, an RPC protocol for Python that follows the distributed object-capability model";

      longDescription = ''
        "Foolscap" is the name for the next-generation RPC protocol,
        intended to replace Perspective Broker (part of Twisted).
        Foolscap is a protocol to implement a distributed
        object-capabilities model in Python.
      '';

      # See http://foolscap.lothar.com/trac/browser/LICENSE.
      license = licenses.mit;

      maintainers = [ ];
    };
  });

  forbiddenfruit = buildPythonPackage rec {
    version = "0.1.0";
    name = "forbiddenfruit-${version}";

    src = pkgs.fetchurl {
      url= "mirror://pypi/f/forbiddenfruit/${name}.tar.gz";
      sha256 = "0xra2kw6m8ag29ifwmhi5zqksh4cr0yy1waqd488rm59kcr3zl79";
    };

    meta = {
      description = "Patch python built-in objects";
      homepage = https://pypi.python.org/pypi/forbiddenfruit;
      license = licenses.mit;
    };
  };

  fs = buildPythonPackage rec {
    name = "fs-0.5.4";

    src = pkgs.fetchurl {
      url    = "mirror://pypi/f/fs/${name}.tar.gz";
      sha256 = "ba2cca8773435a7c86059d57cb4b8ea30fda40f8610941f7822d1ce3ffd36197";
    };

    LC_ALL = "en_US.UTF-8";
    buildInputs = [ pkgs.glibcLocales ];
    propagatedBuildInputs = [ self.six ];

    checkPhase = ''
      ${python.interpreter} -m unittest discover
    '';

    # Because 2to3 is used the tests in $out need to be run.
    # Both when using unittest and pytest this resulted in many errors,
    # some Python byte/str errors, and others specific to resources tested.
    # Failing tests due to the latter is to be expected with this type of package.
    # Tests are therefore disabled.
    doCheck = false;

    meta = {
      description = "Filesystem abstraction";
      homepage    = http://pypi.python.org/pypi/fs;
      license     = licenses.bsd3;
      maintainers = with maintainers; [ lovek323 ];
      platforms   = platforms.unix;
    };
  };

  fuse = callPackage ../development/python-modules/python-fuse { fuse = pkgs.fuse; };

  fusepy = buildPythonPackage rec {
    name = "fusepy-2.0.4";

    src = pkgs.fetchurl {
      url = "mirror://pypi/f/fusepy/${name}.tar.gz";
      sha256 = "0v5grm4zyf58hsplwsxfbihddw95lz9w8cy3rpzbyha287swgx8h";
    };

    propagatedBuildInputs = [ pkgs.fuse ];

    # No tests included
    doCheck = false;

    patchPhase = ''
      substituteInPlace fuse.py --replace \
        "find_library('fuse')" "'${pkgs.fuse}/lib/libfuse.so'"
    '';

    meta = {
      description = "Simple ctypes bindings for FUSE";
      longDescription = ''
        Python module that provides a simple interface to FUSE and MacFUSE.
        It's just one file and is implemented using ctypes.
      '';
      homepage = https://github.com/terencehonles/fusepy;
      license = licenses.isc;
      platforms = platforms.unix;
      maintainers = with maintainers; [ nckx ];
    };
  };

  future = callPackage ../development/python-modules/future { };

  futures = buildPythonPackage rec {
    name = "futures-${version}";
    version = "3.1.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/f/futures/${name}.tar.gz";
      sha256 = "1z9j05fdj2yszjmz4pmjhl2jdnwhdw80cjwfqq3ci0yx19gv9v2i";
    };

    # This module is for backporting functionality to Python 2.x, it's builtin in py3k
    disabled = isPy3k;

    checkPhase = ''
        ${python.interpreter} -m unittest discover
    '';

    # Tests fail
    doCheck = false;

    meta = with pkgs.stdenv.lib; {
      description = "Backport of the concurrent.futures package from Python 3.2";
      homepage = "https://github.com/agronholm/pythonfutures";
      license = licenses.bsd2;
      maintainers = with maintainers; [ garbas ];
    };
  };

  futures_2_2 = self.futures.override rec {
    version = "2.2.0";
    name = "futures-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/f/futures/${name}.tar.gz";
      sha256 = "1lqfzl3z3pkxakgbcrfy6x7x0fp3q18mj5lpz103ljj7fdqha70m";
    };
  };

  gcovr = buildPythonPackage rec {
    name = "gcovr-2.4";

    src = pkgs.fetchurl {
      url = "mirror://pypi/g/gcovr/${name}.tar.gz";
      sha256 = "2c878e03c2eff2282e64035bec0a30532b2b1173aadf08486401883b79e4dab1";
    };

    meta = {
      description = "A Python script for summarizing gcov data";
      license = "BSD";
    };
  };

  gdal = (pkgs.gdal.overrideDerivation (oldattrs: {
    name = "${python.libPrefix}-" + oldattrs.name;
  })).override {
    pythonPackages = self;
  };

  gdrivefs = buildPythonPackage rec {
    version = "0.14.8";
    name = "gdrivefs-${version}";
    namePrefix = "";
    disabled = !isPy27;

    src = pkgs.fetchurl {
      url = "https://github.com/dsoprea/GDriveFS/archive/${version}.tar.gz";
      sha256 = "1dch10ajkp567pwvssvz1v5c0hxfyd8wf9qd7j1gfybh7f7hyzvw";
    };

    buildInputs = with self; [ gipc greenlet httplib2 six ];
    propagatedBuildInputs = with self; [ dateutil fusepy google_api_python_client ];

    patchPhase = ''
      substituteInPlace gdrivefs/resources/requirements.txt \
        --replace "==" ">="
    '';

    meta = {
      description = "Mount Google Drive as a local file system";
      longDescription = ''
        GDriveFS is a FUSE wrapper for Google Drive developed. Design goals:
        - Thread for monitoring changes via "changes" functionality of API.
        - Complete stat() implementation.
        - Seamlessly work around duplicate-file allowances in Google Drive.
        - Seamlessly manage file-type versatility in Google Drive
          (Google Doc files do not have a particular format).
        - Allow for the same file at multiple paths.
      '';
      homepage = https://github.com/dsoprea/GDriveFS;
      license = licenses.gpl2;
      platforms = platforms.unix;
      maintainers = with maintainers; [ nckx ];
    };
  };

  genshi = buildPythonPackage {
    name = "genshi-0.7";

    src = pkgs.fetchurl {
      url = http://ftp.edgewall.com/pub/genshi/Genshi-0.7.tar.gz;
      sha256 = "0lkkbp6fbwzv0zda5iqc21rr7rdldkwh3hfabfjl9i4bwq14858x";
    };

    # FAIL: test_sanitize_remove_script_elem (genshi.filters.tests.html.HTMLSanitizerTestCase)
    # FAIL: test_sanitize_remove_src_javascript (genshi.filters.tests.html.HTMLSanitizerTestCase)
    doCheck = false;

    buildInputs = with self; [ setuptools ];

    meta = {
      description = "Python components for parsing HTML, XML and other textual content";

      longDescription = ''
        Python library that provides an integrated set of
        components for parsing, generating, and processing HTML, XML or other
        textual content for output generation on the web.
      '';

      license = "BSD";
    };
  };

  gevent = callPackage ../development/python-modules/gevent { };

  geventhttpclient = buildPythonPackage rec {
    name = "geventhttpclient-${version}";
    version = "1.3.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/g/geventhttpclient/${name}.tar.gz";
      sha256 = "bd87af8854f5fb05738916c8973671f7035568aec69b7c842887d6faf9c0a01d";
    };

    buildInputs = with self; [ pytest ];
    propagatedBuildInputs = with self; [ gevent certifi six backports_ssl_match_hostname ];

    # Several tests fail that require network
    doCheck = false;
    checkPhase = ''
      py.test $out
    '';

    meta = {
      homepage = https://github.com/gwik/geventhttpclient;
      description = "HTTP client library for gevent";
      license = licenses.mit;
      maintainers = with maintainers; [ koral ];
    };
  };

  gevent-socketio = buildPythonPackage rec {
    name = "gevent-socketio-0.3.6";

    src = pkgs.fetchurl {
      url = "mirror://pypi/g/gevent-socketio/${name}.tar.gz";
      sha256 = "1zra86hg2l1jcpl9nsnqagy3nl3akws8bvrbpgdxk15x7ywllfak";
    };

    buildInputs = with self; [ versiontools gevent-websocket mock pytest ];
    propagatedBuildInputs = with self; [ gevent ];

  };

  geopandas = callPackage ../development/python-modules/geopandas { };

  gevent-websocket = buildPythonPackage rec {
    name = "gevent-websocket-0.9.3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/g/gevent-websocket/${name}.tar.gz";
      sha256 = "07rqwfpbv13mk6gg8mf0bmvcf6siyffjpgai1xd8ky7r801j4xb4";
    };

    # SyntaxError in tests.
    disabled = isPy3k;

    propagatedBuildInputs = with self; [ gevent ];

  };

  genzshcomp = buildPythonPackage {
    name = "genzshcomp-0.5.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/g/genzshcomp/genzshcomp-0.5.1.tar.gz";
      sha256 = "c77d007cc32cdff836ecf8df6192371767976c108a75b055e057bb6f4a09cd42";
    };

    buildInputs = with self; [ setuptools ] ++ (optional isPy26 argparse);

    meta = {
      description = "Automatically generated zsh completion function for Python's option parser modules";
      license = "BSD";
    };
  };


  gflags = callPackage ../development/python-modules/gflags { };

  ghdiff = callPackage ../development/python-modules/ghdiff { };

  gipc = buildPythonPackage rec {
    name = "gipc-0.5.0";
    disabled = !isPy26 && !isPy27;

    src = pkgs.fetchurl {
      url = "mirror://pypi/g/gipc/${name}.zip";
      sha256 = "08c35xzv7nr12d9xwlywlbyzzz2igy0yy6y52q2nrkmh5d4slbpc";
    };

    propagatedBuildInputs = with self; [ gevent ];

    meta = {
      description = "gevent-cooperative child processes and IPC";
      longDescription = ''
        Usage of Python's multiprocessing package in a gevent-powered
        application may raise problems and most likely breaks the application
        in various subtle ways. gipc (pronunciation "gipsy") is developed with
        the motivation to solve many of these issues transparently. With gipc,
        multiprocessing. Process-based child processes can safely be created
        anywhere within your gevent-powered application.
      '';
      homepage = http://gehrcke.de/gipc;
      license = licenses.mit;
      maintainers = with maintainers; [ nckx ];
    };
  };

  git-sweep = buildPythonPackage rec {
    name = "git-sweep-0.1.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/g/git-sweep/${name}.tar.gz";
      sha256 = "1csp0zd049d643d409rfivbswwzrayb4i6gkypp5mc27fb1z2afd";
    };

    propagatedBuildInputs = with self; [ GitPython ];

    meta = {
      description = "A command-line tool that helps you clean up Git branches";
      homepage = https://github.com/arc90/git-sweep;
      license = licenses.mit;
      maintainers = with maintainers; [ pSub ];
    };
  };

  glances = buildPythonPackage rec {
    name = "glances-${version}";
    version = "2.11.1";
    disabled = isPyPy;

    src = pkgs.fetchFromGitHub {
      owner = "nicolargo";
      repo = "glances";
      rev = "v${version}";
      sha256 = "1n3x0bkydlqmxdr0wdgfgichp8fyldzkaijj618y5ns2k5qiwsxr";
    };

    doCheck = false;

    buildInputs = with self; [ unittest2 ];
    propagatedBuildInputs = with self; [ psutil setuptools bottle batinfo pkgs.hddtemp pysnmp ];

    preConfigure = ''
      sed -i 's/data_files\.append((conf_path/data_files.append(("etc\/glances"/' setup.py;
    '';

    meta = {
      homepage = "https://nicolargo.github.io/glances/";
      description = "Cross-platform curses-based monitoring tool";
      license = licenses.lgpl3;
      maintainers = with maintainers; [ primeos koral ];
    };
  };

  github3_py = buildPythonPackage rec {
    name = "github3.py-${version}";
    version = "1.0.0a4";

    src = pkgs.fetchurl {
      url = "mirror://pypi/g/github3.py/${name}.tar.gz";
      sha256 = "0rhnrhb7qc60h82hkd4wnj1jh544yzrf4pjmn4rqacdi59p7f3jp";
    };

    buildInputs = with self; [ unittest2 pytest mock betamax betamax-matchers ];

    propagatedBuildInputs = with self; [ requests pyopenssl uritemplate_py
      ndg-httpsclient requests_toolbelt pyasn1 ];

    postPatch = ''
      sed -i -e 's/mock ==1.0.1/mock>=1.0.1/' setup.py
      sed -i -e 's/unittest2 ==0.5.1/unittest2>=0.5.1/' setup.py
    '';

    # TODO: only disable the tests that require network
    doCheck = false;

    meta = with stdenv.lib; {
      homepage = http://github3py.readthedocs.org/en/master/;
      description = "A wrapper for the GitHub API written in python";
      license = licenses.bsd3;
      maintainers = with maintainers; [ pSub ];
    };
  };

  github-webhook = buildPythonPackage rec {
    name = "github-webhook-${version}";
    version = "unstable-2016-03-11";

    # There is a PyPI package but an older one.
    src = pkgs.fetchgit {
      url = "https://github.com/bloomberg/python-github-webhook.git";
      rev = "ca1855479ee59c4373da5425dbdce08567605d49";
      sha256 = "0mqwig9281iyzbphp1d21a4pqdrf98vs9k8lqpqx6spzgqaczx5f";
    };

    propagatedBuildInputs = with self; [ flask ];
    # No tests
    doCheck = false;

    meta = {
      description = "A framework for writing webhooks for GitHub";
      license = licenses.mit;
      homepage = https://github.com/bloomberg/python-github-webhook;
    };
  };

  goobook = buildPythonPackage rec {
    name = "goobook-1.9";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url    = "mirror://pypi/g/goobook/${name}.tar.gz";
      sha256 = "02xmq8sjavza17av44ks510934wrshxnsm6lvhvazs45s92b671i";
    };

    buildInputs = with self; [ ];

    preConfigure = ''
      sed -i '/distribute/d' setup.py
    '';

    meta = {
      description = "Search your google contacts from the command-line or mutt";
      homepage    = https://pypi.python.org/pypi/goobook;
      license     = licenses.gpl3;
      maintainers = with maintainers; [ lovek323 hbunke ];
      platforms   = platforms.unix;
    };

    propagatedBuildInputs = with self; [ oauth2client gdata simplejson httplib2 keyring six rsa ];
  };

  google_api_python_client = buildPythonPackage rec {
    name = "google-api-python-client-${version}";
    version = "1.5.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/g/google-api-python-client/${name}.tar.gz";
      sha256 = "1ggxk094vqr4ia6yq7qcpa74b4x5cjd5mj74rq0xx9wp2jkrxmig";
    };

    # No tests included in archive
    doCheck = false;

    propagatedBuildInputs = with self; [ httplib2 six oauth2client uritemplate ];

    meta = {
      description = "The core Python library for accessing Google APIs";
      homepage = "https://code.google.com/p/google-api-python-client/";
      license = licenses.asl20;
      platforms = platforms.unix;
    };
  };

  google_apputils = buildPythonPackage rec {
    name = "google-apputils-0.4.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/g/google-apputils/${name}.tar.gz";
      sha256 = "1sxsm5q9vr44qzynj8l7p3l7ffb0zl1jdqhmmzmalkx941nbnj1b";
    };

    preConfigure = ''
      sed -i '/ez_setup/d' setup.py
    '';

    propagatedBuildInputs = with self; [ pytz gflags dateutil mox ];

    checkPhase = ''
      ${python.executable} setup.py google_test
    '';

    doCheck = true;

    meta = {
      description = "Google Application Utilities for Python";
      homepage = http://code.google.com/p/google-apputils-python;
    };
  };

  grammalecte = callPackage ../development/python-modules/grammalecte { };

  greenlet = buildPythonPackage rec {
    name = "greenlet-${version}";
    version = "0.4.10";
    disabled = isPyPy;  # builtin for pypy

    src = pkgs.fetchurl {
      url = "mirror://pypi/g/greenlet/${name}.tar.gz";
      sha256 = "c4417624aa88380cdf0fe110a8a6e0dbcc26f80887197fe5df0427dfa348ae62";
    };

    propagatedBuildInputs = with self; [ six ];

    # see https://github.com/python-greenlet/greenlet/issues/85
    preCheck = ''
      rm tests/test_leaks.py
    '';

    meta = {
      homepage = https://pypi.python.org/pypi/greenlet;
      description = "Module for lightweight in-process concurrent programming";
      license     = licenses.lgpl2;
      platforms   = platforms.all;
    };
  };

  grib-api = if (isPy27) then
      (pkgs.grib-api.overrideAttrs (oldattrs: {
    name = "${python.libPrefix}-" + oldattrs.name;
  })).override {
    enablePython = true;
    pythonPackages = self;
  } else throw "grib-api not supported for interpreter ${python.executable}";

  gspread = buildPythonPackage rec {
    version = "0.2.3";
    name = "gspread-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/g/gspread/${name}.tar.gz";
      sha256 = "dba45ef9e652dcd8cf561ae65569bd6ecd18fcc77b991521490698fb2d847106";
    };

    meta = {
      description = "Google Spreadsheets client library";
      homepage = "https://github.com/burnash/gspread";
      license = licenses.mit;
    };
  };

  gssapi = buildPythonPackage rec {
    version = "1.1.4";
    name = "gssapi-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/g/gssapi/${name}.tar.gz";
      sha256 = "0mdl7m6h57n0zkfmm6fqz0hldfxrb2d7d48k2lhc8hqbr3962c7x";
    };

    GSSAPI_SUPPORT_DETECT = "false";
    LD_LIBRARY_PATH="${pkgs.krb5Full}/lib";

    buildInputs = [ pkgs.gss pkgs.krb5Full pkgs.which
                    self.nose self.shouldbe ];

    propagatedBuildInputs = with self; [ decorator enum34 six ];

    doCheck = false; # No such file or directory: '/usr/sbin/kadmin.local'

    meta = {
      homepage = https://pypi.python.org/pypi/gssapi;
      description = "Python GSSAPI Wrapper";
      license = licenses.mit;
    };
  };

  gyp = buildPythonPackage rec {
    name = "gyp-${version}";
    version = "2015-06-11";

    src = pkgs.fetchgit {
      url = "https://chromium.googlesource.com/external/gyp.git";
      rev = "fdc7b812f99e48c00e9a487bd56751bbeae07043";
      sha256 = "1imgxsl4mr1662vsj2mlnpvvrbz71yk00w8p85vi5bkgmc6awgiz";
    };

    prePatch = optionals pkgs.stdenv.isDarwin ''
      sed -i 's/raise.*No Xcode or CLT version detected.*/version = "7.0.0"/' pylib/gyp/xcode_emulation.py
    '';

    patches = optionals pkgs.stdenv.isDarwin [
      ../development/python-modules/gyp/no-darwin-cflags.patch
      ../development/python-modules/gyp/no-xcode.patch
    ];

    disabled = isPy3k;

    meta = {
      description = "A tool to generate native build files";
      homepage = https://chromium.googlesource.com/external/gyp/+/master/README.md;
      license = licenses.bsd3;
      maintainers = with maintainers; [ codyopel ];
      platforms = platforms.all;
    };
  };

  guessit = callPackage ../development/python-modules/guessit { };

  # used by flexget
  guessit_2_0 = callPackage ../development/python-modules/guessit/2.0.nix { };

  rebulk = callPackage ../development/python-modules/rebulk { };

  gunicorn = callPackage ../development/python-modules/gunicorn { };

  hawkauthlib = buildPythonPackage rec {
    name = "hawkauthlib-${version}";
    version = "0.1.1";
    src = pkgs.fetchgit {
      url = https://github.com/mozilla-services/hawkauthlib.git;
      rev = "refs/tags/v${version}";
      sha256 = "0mr1mpx4j9q7sch9arwfvpysnpf2p7ijy7072wilxm8pnj0bwvsi";
    };

    propagatedBuildInputs = with self; [ requests webob ];
  };

  hmmlearn = callPackage ../development/python-modules/hmmlearn { };

  hcs_utils = callPackage ../development/python-modules/hcs_utils { };

  hetzner = buildPythonPackage rec {
    name = "hetzner-${version}";
    version = "0.7.5";

    src = pkgs.fetchFromGitHub {
      repo = "hetzner";
      owner = "RedMoonStudios";
      rev = "v${version}";
      sha256 = "1fw7i1z4a39i1ljd9qd4f5p1p3a4257jfglkdpw90xjwl7fdpq42";
    };

    # not there yet, but coming soon.
    doCheck = false;

    meta = {
      homepage = "https://github.com/RedMoonStudios/hetzner";
      description = "High-level Python API for accessing the Hetzner robot";
      license = licenses.bsd3;
      maintainers = with maintainers; [ aszlig ];
    };
  };


  htmllaundry = buildPythonPackage rec {
    name = "htmllaundry-2.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/h/htmllaundry/${name}.tar.gz";
      sha256 = "e428cba78d5a965e959f5dac2eb7d5f7d627dd889990d5efa8d4e03f3dd768d9";
    };

    buildInputs = with self; [ nose ];
    propagatedBuildInputs = with self; [ six lxml ];

    # some tests fail, probably because of changes in lxml
    # not relevant for me, if releavnt for you, fix it...
    doCheck = false;

    meta = {
      description = "Simple HTML cleanup utilities";
      license = licenses.bsd3;
    };
  };


  html5lib = buildPythonPackage (rec {
    version = "0.999999999";
    name = "html5lib-${version}";

    src = pkgs.fetchurl {
      url = "http://github.com/html5lib/html5lib-python/archive/${version}.tar.gz";
      sha256 = "09j6194f5mlnd5xwbavwvnndwl1x91jw74shxl6hcxjp4fxg3h05";
    };

    buildInputs = with self; [ flake8 pytest pytest-expect mock ];
    propagatedBuildInputs = with self; [
      six webencodings
    ] ++ optionals isPy26 [ ordereddict ];

    checkPhase = ''
      py.test
    '';

    meta = {
      homepage = https://github.com/html5lib/html5lib-python;
      downloadPage = https://github.com/html5lib/html5lib-python/releases;
      description = "HTML parser based on WHAT-WG HTML5 specification";
      longDescription = ''
        html5lib is a pure-python library for parsing HTML. It is designed to
        conform to the WHATWG HTML specification, as is implemented by all
        major web browsers.
      '';
      license = licenses.mit;
      maintainers = with maintainers; [ domenkozar prikhi ];
    };
  });

  http_signature = buildPythonPackage (rec {
    name = "http_signature-0.1.4";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/h/http_signature/${name}.tar.gz";
      sha256 = "14acc192ef20459d5e11b4e800dd3a4542f6bd2ab191bf5717c696bf30936c62";
    };

    propagatedBuildInputs = with self; [pycrypto];

    meta = {
      homepage = https://github.com/atl/py-http-signature;
      description = "";
      license = licenses.mit;
    };
  });

  httpbin = callPackage ../development/python-modules/httpbin { };

  httplib2 = buildPythonPackage rec {
    name = "httplib2-0.9.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/h/httplib2/${name}.tar.gz";
      sha256 = "126rsryvw9vhbf3qmsfw9lf4l4xm2srmgs439lgma4cpag4s3ay3";
    };

    meta = {
      homepage = http://code.google.com/p/httplib2;
      description = "A comprehensive HTTP client library";
      license = licenses.mit;
      maintainers = with maintainers; [ garbas ];
    };
  };

  hvac = buildPythonPackage rec {
    name    = "hvac-${version}";
    version = "0.2.15";

    src = pkgs.fetchurl {
      url    = "https://pypi.python.org/packages/11/ba/6101780891b9d55f6174fa78b47d462c8c1f0cde34072b45fc39f7f8a77c/hvac-0.2.15.tar.gz";
      sha256 = "0qxa4g1ij1bj27mbp8l54lcr7d5krkb2rayisc6shkpf2b51ip4c";
    };

    propagatedBuildInputs = with self; [ requests ];
  };

  hypothesis = callPackage ../development/python-modules/hypothesis { };

  colored = buildPythonPackage rec {
    name = "colored-${version}";
    version = "1.1.5";
    src = pkgs.fetchurl {
      url = "mirror://pypi/c/colored/${name}.tar.gz";
      sha256 = "1r1vsypk8v7az82d66bidbxlndx1h7xd4m43hpg1a6hsjr30wrm3";
    };

    # No proper test suite
    doCheck = false;
  };


  xdis = buildPythonPackage rec {
    name = "xdis-${version}";
    version = "3.2.4";
    src = pkgs.fetchurl {
      url = "mirror://pypi/x/xdis/${name}.tar.gz";
      sha256 = "0g2lh70837vigcbc1i58349wp2xzrhlsg2ahc92sn8d3jwxja4dk";
    };
    propagatedBuildInputs = with self; [ nose six ];

    meta = {
      description = "Python cross-version byte-code disassembler and marshal routines";
      homepage = https://github.com/rocky/python-xdis/;
      license = licenses.mit;
    };
  };

  uncompyle6 = buildPythonPackage rec {
    name = "uncompyle6-${version}";
    version = "2.8.3";
    src = pkgs.fetchurl {
      url = "mirror://pypi/u/uncompyle6/${name}.tar.gz";
      sha256 = "0hx5sji6qjvnq1p0zhvyk5hgracpv2w6iar1j59qwllxv115ffi1";
    };
    propagatedBuildInputs = with self; [ spark_parser xdis ];
    meta = {
      description = "Python cross-version byte-code deparser";
      homepage = https://github.com/rocky/python-uncompyle6/;
      license = licenses.mit;
    };
  };

  lsi = buildPythonPackage rec {
    name = "lsi-${version}";
    version = "0.2.2";
    disabled = isPy3k;
    src = pkgs.fetchurl {
      url = "mirror://pypi/l/lsi/${name}.tar.gz";
      sha256 = "0429iilb06yhsmvj3xp6wyhfh1rp4ndxlhwrm80r97z0w7plrk94";
    };
    propagatedBuildInputs = [
      self.colored
      self.boto
      pkgs.openssh
      pkgs.which
    ];
    meta = {
      description = "CLI for querying and SSHing onto AWS EC2 instances";
      homepage = https://github.com/NarrativeScience/lsi;
      maintainers = [maintainers.adnelson];
      license = licenses.mit;
    };
  };

  hkdf = buildPythonPackage rec {
    name = "hkdf-${version}";
    version = "0.0.3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/h/hkdf/${name}.tar.gz";
      sha256 = "1jhxk5vhxmxxjp3zj526ry521v9inzzl8jqaaf0ma65w6k332ak2";
    };

    buildInputs = with self; [ nose ];

    checkPhase = ''
      nosetests
    '';

    meta = {
      description = "HMAC-based Extract-and-Expand Key Derivation Function (HKDF)";
      homepage = "https://github.com/casebeer/python-hkdf";
      license = licenses.bsd2;
    };
  };

  httpretty = buildPythonPackage rec {
    name = "httpretty-${version}";
    version = "0.8.10";
    doCheck = false;

    src = pkgs.fetchurl {
      url = "mirror://pypi/h/httpretty/${name}.tar.gz";
      sha256 = "1nmdk6d89z14x3wg4yxywlxjdip16zc8bqnfb471z1365mr74jj7";
    };

    buildInputs = with self; [ tornado requests httplib2 sure nose coverage certifi ];

    propagatedBuildInputs = with self; [ urllib3 ];

    postPatch = ''
      sed -i -e 's/==.*$//' *requirements.txt
      # XXX: Drop this after version 0.8.4 is released.
      patch httpretty/core.py <<DIFF
      ***************
      *** 566 ****
      !                 'content-length': len(self.body)
      --- 566 ----
      !                 'content-length': str(len(self.body))
      DIFF

      # Explicit encoding flag is required with python3, unless locale is set.
      ${if !self.isPy3k then "" else
        "patch -p0 -i ${../development/python-modules/httpretty/setup.py.patch}"}
    '';

    meta = {
      homepage = "http://falcao.it/HTTPretty/";
      description = "HTTP client request mocking tool";
      license = licenses.mit;
    };
  };

  icalendar = buildPythonPackage rec {
    version = "3.9.0";
    name = "icalendar-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/i/icalendar/${name}.tar.gz";
      sha256 = "93d0b94eab23d08f62962542309916a9681f16de3d5eca1c75497f30f1b07792";
    };

    buildInputs = with self; [ setuptools ];
    propagatedBuildInputs = with self; [ dateutil pytz ];

    meta = {
      description = "A parser/generator of iCalendar files";
      homepage = "http://icalendar.readthedocs.org/";
      license = licenses.bsd2;
      maintainers = with maintainers; [ olcai ];
    };
  };

  imageio = buildPythonPackage rec {
    name = "imageio-${version}";
    version = "1.6";

    src = pkgs.fetchurl {
      url = "https://github.com/imageio/imageio/archive/v${version}.tar.gz";
      sha256 = "195snkk3fsbjqd5g1cfsd9alzs5q45gdbi2ka9ph4yxqb31ijrbv";
    };

    buildInputs = with self; [ pytest ];
    propagatedBuildInputs = with self; [ numpy ];

    checkPhase = ''
      py.test
    '';

    # Tries to write in /var/tmp/.imageio
    doCheck = false;

    meta = {
      description = "Library for reading and writing a wide range of image, video, scientific, and volumetric data formats";
      homepage = http://imageio.github.io/;
      license = licenses.bsd2;
    };
  };

  importlib = buildPythonPackage rec {
    name = "importlib-1.0.2";

    disabled = (!isPy26) || isPyPy;

    src = pkgs.fetchurl {
      url = "mirror://pypi/i/importlib/importlib-1.0.2.tar.gz";
      sha256 = "131jvp6ahllcqblszjg6fxrzh4k50w8g60sq924b4nb8lxm9dl14";
    };
  };


  inflection = buildPythonPackage rec {
     version = "0.3.1";
     name = "inflection-${version}";

     src = pkgs.fetchurl {
       url= "mirror://pypi/i/inflection/${name}.tar.gz";
       sha256 = "1jhnxgnw8y3mbzjssixh6qkc7a3afc4fygajhqrqalnilyvpzshq";
     };

     disabled = isPy3k;

     meta = {
       homepage = https://github.com/jpvanhal/inflection;
       description = "A port of Ruby on Rails inflector to Python";
       maintainers = with maintainers; [ NikolaMandic ];
     };
  };

  influxdb = buildPythonPackage rec {
    name = "influxdb-4.0.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/i/influxdb/${name}.tar.gz";
      sha256 = "0injsml6zmb3hkgc03117fdlg573kbfgjbijpd5npf0vsy0xnpvz";
    };

    # ImportError: No module named tests
    doCheck = false;
    propagatedBuildInputs = with self; [ requests dateutil pytz six ];

    meta = {
      description = "Python client for InfluxDB";
      homepage = https://github.com/influxdb/influxdb-python;
      license = licenses.mit;
    };
  };

  infoqscraper = buildPythonPackage rec {
    name = pname + "-" + version;
    version = "0.1.0";
    pname = "infoqscraper";

    src = pkgs.fetchFromGitHub {
      owner = "cykl";
      repo = pname;
      rev = "v" + version;
      sha256 = "07mxp4mla7fwfc032f3mxrhjarnhkjqdxxibf9ba87c93z3dq8jj";
    };

    # requires network
    doCheck = false;

    buildInputs = with self; [ html5lib ];
    propagatedBuildInputs = (with self; [ six beautifulsoup4 ])
                         ++ (with pkgs; [ ffmpeg swftools rtmpdump ]);

    meta = {
      description = "Discover presentations and/or create a movie consisting of slides and audio track from an infoq url";
      homepage = "https://github.com/cykl/infoqscraper/wiki";
      license = licenses.mit;
      maintainers = with maintainers; [ edwtjo ];
    };
  };

  inifile = buildPythonPackage rec {
    name = "inifile-0.3";

    meta = {
      description = "A small INI library for Python";
      homepage    = "https://github.com/mitsuhiko/python-inifile";
      license     = "BSD";
      maintainers = with maintainers; [ vozz ];
    };

    src = pkgs.fetchurl {
      url = "mirror://pypi/i/inifile/${name}.tar.gz";
      sha256 = "0zgd53czc1irwx6b5zip8xlmyfr40hz2pd498d8yv61znj6lm16h";
    };
  };

  interruptingcow = callPackage ../development/python-modules/interruptingcow {};

  iptools = buildPythonPackage rec {
    version = "0.6.1";
    name = "iptools-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/i/iptools/iptools-${version}.tar.gz";
      sha256 = "0f03875a5bed740ba4bf44decb6a78679cca914a1ee8a6cc468114485c4d98e3";
    };

    buildInputs = with self; [ nose ];

    meta = {
      description = "Utilities for manipulating IP addresses including a class that can be used to include CIDR network blocks in Django's INTERNAL_IPS setting";
      homepage = https://pypi.python.org/pypi/iptools;
    };
  };


  ipy = buildPythonPackage rec {
    version = "0.74";
    name = "ipy-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/I/IPy/IPy-${version}.tar.gz";
      sha256 = "5d6abb870c25f946c45c35cf50e66155598660f2765b35cb12e36ed5223c2b89";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      description = "Class and tools for handling of IPv4 and IPv6 addresses and networks";
      homepage = https://pypi.python.org/pypi/IPy;
    };
  };

  ipykernel = callPackage ../development/python-modules/ipykernel { };

  ipyparallel = callPackage ../development/python-modules/ipyparallel { };

  # Newer versions of IPython no longer support Python 2.7.
  ipython = if isPy27 then self.ipython_5 else self.ipython_6;

  ipython_5 = callPackage ../development/python-modules/ipython/5.nix { };

  ipython_6 = callPackage ../development/python-modules/ipython { };

  ipython_genutils = callPackage ../development/python-modules/ipython_genutils { };

  ipywidgets = callPackage ../development/python-modules/ipywidgets { };

  ipaddr = buildPythonPackage rec {
    name = "ipaddr-${version}";
    version = "2.1.11";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/i/ipaddr/${name}.tar.gz";
      sha256 = "1dwq3ngsapjc93fw61rp17fvzggmab5x1drjzvd4y4q0i255nm8v";
    };

    meta = {
      description = "Google's IP address manipulation library";
      homepage = http://code.google.com/p/ipaddr-py/;
      license = licenses.asl20;
    };
  };

  ipaddress = if (pythonAtLeast "3.3") then null else buildPythonPackage rec {
    name = "ipaddress-1.0.18";

    src = pkgs.fetchurl {
      url = "mirror://pypi/i/ipaddress/${name}.tar.gz";
      sha256 = "1q8klj9d84cmxgz66073x1j35cplr3r77vx1znhxiwl5w74391ax";
    };

    checkPhase = ''
      ${python.interpreter} test_ipaddress.py
    '';

    meta = {
      description = "Port of the 3.3+ ipaddress module to 2.6, 2.7, and 3.2";
      homepage = https://github.com/phihag/ipaddress;
      license = licenses.psfl;
    };
  };

  ipdb = buildPythonPackage rec {
    name = "ipdb-${version}";
    version = "0.8.1";

    disabled = isPyPy;  # setupterm: could not find terminfo database
    src = pkgs.fetchurl {
      url = "mirror://pypi/i/ipdb/${name}.zip";
      sha256 = "1763d1564113f5eb89df77879a8d3213273c4d7ff93dcb37a3070cdf0c34fd7c";
    };
    propagatedBuildInputs = with self; [ ipython ];
  };

  ipdbplugin = buildPythonPackage {
    name = "ipdbplugin-1.4";
    src = pkgs.fetchurl {
      url = "mirror://pypi/i/ipdbplugin/ipdbplugin-1.4.tar.gz";
      sha256 = "4778d78b5d0af1a2a6d341aed9e72eb73b1df6b179e145b4845d3a209137029c";
    };
    propagatedBuildInputs = with self; [ self.nose self.ipython ];
  };

  pythonIRClib = buildPythonPackage rec {
    name = "irclib-${version}";
    version = "0.4.8";

    src = pkgs.fetchurl {
      url = "mirror://sourceforge/python-irclib/python-irclib-${version}.tar.gz";
      sha256 = "1x5456y4rbxmnw4yblhb4as5791glcw394bm36px3x6l05j3mvl1";
    };

    patches = [(pkgs.fetchurl {
      url = "http://trac.uwc.ac.za/trac/python_tools/browser/xmpp/resources/irc-transport/irclib.py.diff?rev=387&format=raw";
      name = "irclib.py.diff";
      sha256 = "5fb8d95d6c95c93eaa400b38447c63e7a176b9502bc49b2f9b788c9905f4ec5e";
    })];

    patchFlags = "irclib.py";

    propagatedBuildInputs = with self; [ paver ];

    disabled = isPy3k;
    meta = {
      description = "Python IRC library";
      homepage = https://bitbucket.org/jaraco/irc;
      license = with licenses; [ lgpl21 ];
    };
  };

  iso-639 = callPackage ../development/python-modules/iso-639 {};

  iso3166 = callPackage ../development/python-modules/iso3166 {};

  iso8601 = buildPythonPackage rec {
    name = "iso8601-${version}";
    version = "0.1.11";
    src = pkgs.fetchurl {
      url = "mirror://pypi/i/iso8601/${name}.tar.gz";
      sha256 = "e8fb52f78880ae063336c94eb5b87b181e6a0cc33a6c008511bac9a6e980ef30";
    };

    buildInputs = [ self.pytest ];

    checkPhase = ''
      py.test iso8601
    '';

    meta = {
      homepage = https://bitbucket.org/micktwomey/pyiso8601/;
      description = "Simple module to parse ISO 8601 dates";
      maintainers = with maintainers; [ phreedom ];
    };
  };

  isort = buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "isort";
    version = "4.2.5";
    src = pkgs.fetchurl {
      url = "mirror://pypi/i/${pname}/${name}.tar.gz";
      sha256 = "0p7a6xaq7zxxq5vr5gizshnsbk2afm70apg97xwfdxiwyi201cjn";
    };
    buildInputs = with self; [ mock pytest ];
    # No tests distributed
    doCheck = false;
    meta = {
      description = "A Python utility / library to sort Python imports";
      homepage = https://github.com/timothycrosley/isort;
      license = licenses.mit;
      maintainers = with maintainers; [ couchemar nand0p ];
    };
  };

  jabberbot = callPackage ../development/python-modules/jabberbot {};

  jedi = callPackage ../development/python-modules/jedi { };

  jellyfish = buildPythonPackage rec {
    version = "0.5.2";
    name = "jellyfish-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/j/jellyfish/${name}.tar.gz";
      sha256 = "15xk0kbr1gig9r1mp22lk9mk3jyi886h8ywn9diixhnyl4q6dacn";
    };

    buildInputs = with self; [ pytest unicodecsv ];

    meta = {
      homepage = https://github.com/sunlightlabs/jellyfish;
      description = "Approximate and phonetic matching of strings";
      maintainers = with maintainers; [ koral ];
    };
  };

  j2cli = buildPythonPackage rec {
    name = "j2cli-${version}";
    version = "0.3.1-0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/j/j2cli/${name}.tar.gz";
      sha256 = "0y3w1x9935qzx8w6m2r6g4ghyjmxn33wryiif6xb56q7cj9w1433";
    };

    disabled = ! (isPy26 || isPy27);

    buildInputs = [ self.nose ];

    propagatedBuildInputs = with self; [ jinja2 pyyaml ];

    meta = {
      homepage = https://github.com/kolypto/j2cli;
      description = "Jinja2 Command-Line Tool";
      license = licenses.bsd3;
      longDescription = ''
        J2Cli is a command-line tool for templating in shell-scripts,
        leveraging the Jinja2 library.
      '';
      platforms = platforms.all;
      maintainers = with maintainers; [ rushmorem ];
    };
  };

  jinja2 = callPackage ../development/python-modules/jinja2 { };

  jinja2_time = buildPythonPackage rec {
    version = "0.2.0";
    name = "jinja2-time-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/j/jinja2-time/${name}.tar.gz";
      sha256 = "0h0dr7cfpjnjj8bgl2vk9063a53649pn37wnlkd8hxjy656slkni";
    };

    propagatedBuildInputs = with self; [ arrow jinja2 ];

    meta = {
      homepage = https://github.com/hackebrot/jinja2-time;
      description = "Jinja2 Extension for Dates and Times";
      license = licenses.mit;
    };
  };

  jmespath = buildPythonPackage rec {
    name = "jmespath-0.9.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/j/jmespath/${name}.tar.gz";
      sha256 = "0g9xvl69y7nr3w7ag4fsp6sm4fqf6vrqjw7504x2hzrrsh3ampq8";
    };

    buildInputs = with self; [ nose ];
    propagatedBuildInputs = with self; [ ply ];

    meta = {
      homepage = https://github.com/boto/jmespath;
      description = "JMESPath allows you to declaratively specify how to extract elements from a JSON document";
      license = "BSD";
    };
  };

  journalwatch = callPackage ../tools/system/journalwatch {
    inherit (self) systemd pytest;
  };

  jsonnet = buildPythonPackage {
    inherit (pkgs.jsonnet) name src;
    # Python 3 is not yet supported https://github.com/google/jsonnet/pull/335
    disabled = isPy3k;
  };

  jupyter_client = callPackage ../development/python-modules/jupyter_client { };

  jupyter_core = callPackage ../development/python-modules/jupyter_core { };

  jsonpath_rw = buildPythonPackage rec {
    name = "jsonpath-rw-${version}";
    version = "1.4.0";
    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "mirror://pypi/j/jsonpath-rw/${name}.tar.gz";
      sha256 = "05c471281c45ae113f6103d1268ec7a4831a2e96aa80de45edc89b11fac4fbec";
    };

    propagatedBuildInputs = with self; [
      ply
      six
      decorator
    ];

    # ImportError: No module named tests
    doCheck = false;

    meta = {
      homepage = https://github.com/kennknowles/python-jsonpath-rw;
      description = "A robust and significantly extended implementation of JSONPath for Python, with a clear AST for metaprogramming";
      license = licenses.asl20;
    };
  };

  kerberos = buildPythonPackage rec {
    name = "kerberos-1.2.4";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/k/kerberos/${name}.tar.gz";
      sha256 = "11q9jhzdl88jh8jgn7cycq034m36g2ncxds7mr3vqkngpcirkx6n";
    };

    buildInputs = [ pkgs.kerberos ];

    meta = {
      description = "Kerberos high-level interface";
      homepage = https://pypi.python.org/pypi/kerberos;
      license = licenses.asl20;
    };
  };

  keyring = callPackage ../development/python-modules/keyring { };

  keyutils = callPackage ../development/python-modules/keyutils { };

  klaus = buildPythonPackage rec {
    version = "0.9.1";
    name = "klaus-${version}";

    src = pkgs.fetchurl {
      url = "https://github.com/jonashaag/klaus/archive/${version}.tar.gz";
      sha256 = "0k3v3p56hq8alm083grrp98znxkz1zqx0pczm2lah8qddbyrdkgm";
    };

    propagatedBuildInputs = with self;
      [ humanize httpauth dulwich pygments flask six ];

    meta = {
      description = "The first Git web viewer that Just Works";
      homepage    = "https://github.com/jonashaag/klaus";
      #license     = licenses.mit; # I'm not sure about the license
      maintainers = with maintainers; [ matthiasbeyer ];
      platforms   = platforms.linux; # Can only test linux
    };
  };

  klein = buildPythonPackage rec {
    name = "klein-15.3.1";
    src = pkgs.fetchurl {
      url = "mirror://pypi/k/klein/${name}.tar.gz";
      sha256 = "1hl2psnn1chm698rimyn9dgcpl1mxgc8dj11b3ipp8z37yfjs3z9";
    };

    disabled = isPy3k;

    propagatedBuildInputs = with self; [ werkzeug twisted ];

    meta = {
      description = "Klein Web Micro-Framework";
      homepage    = "https://github.com/twisted/klein";
      license     = licenses.mit;
    };
  };

  koji = callPackage ../development/python-modules/koji { };

  kombu_3 = buildPythonPackage rec {
    name = "kombu-${version}";
    version = "3.0.35";

    disabled = pythonOlder "2.6";

    src = pkgs.fetchurl {
      url = "mirror://pypi/k/kombu/${name}.tar.gz";
      sha256 = "09xpxpjz9nk8d14dj361dqdwyjwda3jlf1a7v6jif9wn2xm37ar2";
    };

    # most of these are simply to allow the test suite to do its job
    buildInputs = with self; optionals isPy27 [ mock unittest2 nose redis qpid-python pymongo sqlalchemy pyyaml msgpack boto ];

    propagatedBuildInputs = with self; [ amqp_1 anyjson ] ++
      (optionals (pythonOlder "2.7") [ importlib ordereddict ]);

    # tests broken on python 2.6? https://github.com/nose-devs/nose/issues/806
    doCheck = isPy27;

    meta = {
      description = "Messaging library for Python";
      homepage    = "http://github.com/celery/kombu";
      license     = licenses.bsd3;
    };
  };

  kombu = buildPythonPackage rec {
    name = "kombu-${version}";
    version = "4.0.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/k/kombu/${name}.tar.gz";
      sha256 = "18hiricdnbnlz6hx3hbaa4dni6npv8rbid4dhf7k02k16qm6zz6h";
    };

    # Backport fix for python-3.6 from master (see issue https://github.com/celery/kombu/issues/675)
    # TODO remove at next update
    patches = [ (pkgs.fetchpatch {
      url = "https://github.com/celery/kombu/commit/dc3fceff59d79ceac3f8f11a5d697beabb4b7a7f.patch";
      sha256 = "0s6gsihzjvmpffc7xrrcijw00r56yb74jg0sbjgng2v1324z1da9";
      name = "don-t-modify-dict-size-while-iterating-over-it";
    }) ];

    buildInputs = with self; [ pytest case pytz ];

    propagatedBuildInputs = with self; [ amqp ];

    meta = {
      description = "Messaging library for Python";
      homepage    = "http://github.com/celery/kombu";
      license     = licenses.bsd3;
    };
  };

  konfig = buildPythonPackage rec {
    name = "konfig-${version}";
    version = "1.1";

    # konfig unconditionaly depend on configparser, even if it is part of
    # the standard library in python 3.2 or above.
    disabled = isPy3k;

    src = pkgs.fetchgit {
      url = https://github.com/mozilla-services/konfig.git;
      rev = "refs/tags/${version}";
      sha256 = "1h780fbrv275dcik4cs3rincza805z6q726b48r4a0qmh5d8160c";
    };

    propagatedBuildInputs = with self; [ configparser six ];

    patches = [ (pkgs.writeText "konfig.patch" ''
      diff --git a/setup.py b/setup.py
      index 96fd858..bb4db06 100644
      --- a/setup.py
      +++ b/setup.py
      @@ -20,7 +20,7 @@ setup(name='konfig',
             author_email="tarek@mozilla.com",
             include_package_data=True,
             install_requires = [
      -        'configparser', 'argparse', 'six'
      +        'configparser', 'six'
             ],
             zip_safe=False,
             classifiers=classifiers,
    '') ];

    meta = {
      description = "Yet Another Config Parser";
      homepage    = "https://github.com/mozilla-services/konfig";
      license     = licenses.mpl20;
    };
  };

  kitchen = callPackage ../development/python-modules/kitchen/default.nix { };

  pylast = callPackage ../development/python-modules/pylast/default.nix { };

  pylru = buildPythonPackage rec {
    name = "pylru-${version}";
    version = "1.0.9";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pylru/${name}.tar.gz";
      sha256 = "0b0pq0l7xv83dfsajsc49jcxzc99kb9jfx1a1dlx22hzcy962dvi";
    };

    meta = {
      homepage = "https://github.com/jlhutch/pylru";
      description = "A least recently used (LRU) cache implementation";
      license = licenses.gpl2;
      platforms = platforms.all;
      maintainers = with maintainers; [ abbradar ];
    };
  };

  lazy-object-proxy = buildPythonPackage rec {
    name = "lazy-object-proxy-${version}";
    version = "1.2.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/l/lazy-object-proxy/${name}.tar.gz";
      sha256 = "22ed751a2c63c6cf718674fd7461b1dfc45215bab4751ca32b6c9b8cb2734cb3";
    };

    buildInputs = with self; [ pytest ];
    checkPhase = ''
      py.test tests
    '';

    # Broken tests. Seem to be fixed upstream according to Travis.
    doCheck = false;

    meta = {
      description = "A fast and thorough lazy object proxy";
      homepage = https://github.com/ionelmc/python-lazy-object-proxy;
      license = with licenses; [ bsd2 ];
    };

  };

  le = buildPythonPackage rec {
    name = "le-${version}";
    version = "1.4.29";

    src = pkgs.fetchurl {
      url = "https://github.com/logentries/le/archive/v${version}.tar.gz";
      sha256 = "d29738937cb6e714b6ec2ae74b66b1983482ffd54b4faa40767af18509521d4c";
    };

    disabled = isPy3k;

    doCheck = false;

    propagatedBuildInputs = with self; [ simplejson psutil ];

    meta = {
      homepage = "https://github.com/logentries/le";
      description = "Logentries agent";
    };
  };

  lektor = buildPythonPackage rec {
    name = "lektor-${version}";

    version = "2.3";

    src = pkgs.fetchgit {
      url = "https://github.com/lektor/lektor";
      rev = "refs/tags/${version}";
      sha256 = "1n0ylh1sbpvi9li3g6a7j7m28njfibn10y6s2gayjxwm6fpphqxy";
    };

    LC_ALL="en_US.UTF-8";

    meta = {
      description = "A static content management system";
      homepage    = "https://www.getlektor.com/";
      license     = "BSD";
      maintainers = with maintainers; [ vozz ];
    };

    # No tests included in archive
    doCheck = false;

    propagatedBuildInputs = with self; [
      click watchdog exifread requests mistune inifile Babel jinja2
      flask pyopenssl ndg-httpsclient pkgs.glibcLocales
    ];
  };

  python-Levenshtein = buildPythonPackage rec {
    name = "python-Levenshtein-${version}";
    version = "0.12.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/python-Levenshtein/${name}.tar.gz";
      sha256 = "1c9ybqcja31nghfcc8xxbbz9h60s9qi12b9hr4jyl69xbvg12fh3";
    };

    # No tests included in archive
    doCheck = false;

    meta = {
      description = "Functions for fast computation of Levenshtein distance and string similarity";
      homepage    = "https://github.com/ztane/python-Levenshtein";
      license     = licenses.gpl2;
      maintainers = with maintainers; [ aske ];
    };
  };

  libcloud = buildPythonPackage (rec {
    name = "libcloud-1.2.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/a/apache-libcloud/apache-${name}.tar.bz2";
      sha256 = "0qlhyz5f32xg8i10biyzqscks8d28vklk63hvj45vzy1amw60kqz";
    };

    buildInputs = with self; [ mock ];

    propagatedBuildInputs = with self; [ pycrypto ];
    preConfigure = "cp libcloud/test/secrets.py-dist libcloud/test/secrets.py";

    # failing tests for 26 and 27
    doCheck = false;

    meta = {
      description = "A unified interface to many cloud providers";
      homepage = http://incubator.apache.org/libcloud/;
    };
  });

  libgpuarray = callPackage ../development/python-modules/libgpuarray {
    clblas = pkgs.clblas.override { boost = self.boost; };
    cudaSupport = pkgs.config.cudaSupport or false;
  };

  libnacl = callPackage ../development/python-modules/libnacl {
    inherit (pkgs) libsodium;
  };

  libplist = if isPy3k then throw "libplist not supported for interpreter ${python.executable}" else
    (pkgs.libplist.override{python2Packages=self; }).py;

  libxml2 = if isPy3k then throw "libxml2 not supported for interpreter ${python.executable}" else
    (pkgs.libxml2.override{pythonSupport=true; python2=python;}).py;

  libxslt = if isPy3k then throw "libxslt not supported for interpreter ${python.executable}" else
    (pkgs.libxslt.override{pythonSupport=true; python2=python; inherit (self) libxml2;}).py;

  limnoria = buildPythonPackage rec {
    name = "limnoria-${version}";
    version = "2016.05.06";

    src = pkgs.fetchurl {
      url = "mirror://pypi/l/limnoria/${name}.tar.gz";
      sha256 = "09kbii5559d09jjb6cryj8rva1050r54dvb67hlcvxhy8g3gr1y3";
    };

    patchPhase = ''
      sed -i 's/version=version/version="${version}"/' setup.py
    '';
    buildInputs = with self; [ pkgs.git ];
    propagatedBuildInputs = with self; [  ];

    doCheck = false;

    meta = {
      description = "A modified version of Supybot, an IRC bot";
      homepage = http://supybot.fr.cr;
      license = licenses.bsd3;
      maintainers = with maintainers; [ goibhniu ];
    };
  };

  line_profiler = callPackage ../development/python-modules/line_profiler { };

  linode = buildPythonPackage rec {
    name = "linode-${version}";
    version = "0.4";

    src = pkgs.fetchurl {
      url = "mirror://pypi/l/linode/linode-${version}.tar.gz";
      sha256 = "db3c2a7fab8966d903a63f16c515bff241533e4ef2d746aa7aae4a49bba5e573";
    };

    propagatedBuildInputs = with self; [ requests ];

    meta = {
      homepage = "https://github.com/ghickman/linode";
      description = "A thin python wrapper around Linode's API";
      license = licenses.mit;
      maintainers = with maintainers; [ nslqqq ];
    };
  };

  linode-api = callPackage ../development/python-modules/linode-api { };

  livereload = callPackage ../development/python-modules/livereload { };

  llfuse = callPackage ../development/python-modules/llfuse {
    fuse = pkgs.fuse;  # use "real" fuse, not the python module
  };

  locustio = buildPythonPackage rec {
    name = "locustio-0.7.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/l/locustio/${name}.tar.gz";
      sha256 = "c9ca6fdfe6a6fb187a3d54ddf9b1518196348e8f20537f0a14ca81a264ffafa2";
    };

    propagatedBuildInputs = [ self.msgpack self.requests self.flask self.gevent self.pyzmq ];
    buildInputs = [ self.mock self.unittest2 ];

    meta = {
      homepage = http://locust.io/;
      description = "A load testing tool";
    };
  };

  llvmlite = callPackage ../development/python-modules/llvmlite {llvm=pkgs.llvm_4;};

  lockfile = buildPythonPackage rec {
    pname = "lockfile";
    version = "0.12.2";
    name = "${pname}-${version}";
    src = pkgs.fetchurl {
      url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
      sha256 = "6aed02de03cba24efabcd600b30540140634fc06cfa603822d508d5361e9f799";
    };

    buildInputs = with self; [
      pbr nose
    ];

    checkPhase = ''
      nosetests
    '';

    meta = {
      homepage = http://launchpad.net/pylockfile;
      description = "Platform-independent advisory file locking capability for Python applications";
      license = licenses.asl20;
    };
  };

  logilab_common = callPackage ../development/python-modules/logilab/common.nix {};

  logilab-constraint = callPackage ../development/python-modules/logilab/constraint.nix {};

  lxml = buildPythonPackage ( rec {
    name = "lxml-3.8.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/l/lxml/${name}.tar.gz";
      sha256 = "15nvf6n285n282682qyw3wihsncb0x5amdhyi4b83bfa2nz74vvk";
    };

    buildInputs = with self; [ pkgs.libxml2 pkgs.libxslt ];

    hardeningDisable = stdenv.lib.optional stdenv.isDarwin "format";

    meta = {
      description = "Pythonic binding for the libxml2 and libxslt libraries";
      homepage = http://lxml.de;
      license = licenses.bsd3;
      maintainers = with maintainers; [ sjourdois ];
    };
  });

  lxc = buildPythonPackage (rec {
    name = "python-lxc-unstable-2016-08-25";
    disabled = !isPy27;

    src = pkgs.fetchFromGitHub {
      owner = "lxc";
      repo = "python2-lxc";
      rev = "0553f05d23b56b59bf3015fa5e45bfbfab9021ef";
      sha256 = "0p9kb20xvq91gx2wfs3vppb7vsp8kmd90i3q95l4nl1y4aismdn4";
    };

    buildInputs = [ pkgs.lxc ];

    meta = {
      description = "Out of tree python 2.7 binding for liblxc";
      homepage = https://github.com/lxc/python2-lxc;
      license = licenses.lgpl2;
      maintainers = with maintainers; [ mic92 ];
    };
  });

  ltc_scrypt = callPackage ../development/python-modules/ltc_scrypt/default.nix { };

  python_magic = buildPythonPackage rec {
    name = "python-magic-0.4.10";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/python-magic/${name}.tar.gz";
      sha256 = "1hx2sjd4fdswswj3yydn2azxb59rjmi9b7jzh94lf1wnxijjizbr";
    };

    propagatedBuildInputs = with self; [ pkgs.file ];

    patchPhase = ''
      substituteInPlace magic.py --replace "ctypes.util.find_library('magic')" "'${pkgs.file}/lib/libmagic${stdenv.hostPlatform.extensions.sharedLibrary}'"
    '';

    doCheck = false;

    # TODO: tests are failing
    #checkPhase = ''
    #  ${python}/bin/${python.executable} ./test.py
    #'';

    meta = {
      description = "A python interface to the libmagic file type identification library";
      homepage = https://github.com/ahupp/python-magic;
    };
  };

  magic = buildPythonPackage rec {
    name = "${pkgs.file.name}";

    src = pkgs.file.src;

    patchPhase = ''
      substituteInPlace python/magic.py --replace "find_library('magic')" "'${pkgs.file}/lib/libmagic${stdenv.hostPlatform.extensions.sharedLibrary}'"
    '';

    buildInputs = with self; [ pkgs.file ];

    preConfigure = "cd python";

    # No test suite
    doCheck = false;

    meta = {
      description = "A Python wrapper around libmagic";
      homepage = http://www.darwinsys.com/file/;
    };
  };

  m2crypto = buildPythonPackage rec {
    version = "0.24.0";
    name = "m2crypto-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/M/M2Crypto/M2Crypto-${version}.tar.gz";
      sha256 = "1s2y0pf2zg7xf4nfwrw7zhwbk615r5a7bgi5wwkwzh6jl50n99c0";
    };

    buildInputs = with self; [ pkgs.swig2 pkgs.openssl ];

    preConfigure = ''
      substituteInPlace setup.py --replace "self.openssl = '/usr'" "self.openssl = '${pkgs.openssl.dev}'"
    '';

    doCheck = false; # another test that depends on the network.

    meta = {
      description = "A Python crypto and SSL toolkit";
      homepage = http://chandlerproject.org/Projects/MeTooCrypto;
    };
  };


  Mako = buildPythonPackage rec {
    name = "Mako-1.0.4";

    src = pkgs.fetchurl {
      url = "mirror://pypi/M/Mako/${name}.tar.gz";
      sha256 = "0nchpw6akfcsg8w6irjlx0gyzadc123hv4g47sijgnqd9nz9vngy";
    };

    buildInputs = with self; [ markupsafe nose mock pytest ];
    propagatedBuildInputs = with self; [ markupsafe ];

    doCheck = !isPyPy;  # https://bitbucket.org/zzzeek/mako/issue/238/2-tests-failed-on-pypy-24-25

    meta = {
      description = "Super-fast templating language";
      homepage = http://www.makotemplates.org;
      license = licenses.mit;
      platforms = platforms.unix;
      maintainers = with maintainers; [ domenkozar ];
    };
  };

  manifestparser = callPackage ../development/python-modules/marionette-harness/manifestparser.nix {};
  marionette_driver = callPackage ../development/python-modules/marionette-harness/marionette_driver.nix {};
  mozcrash = callPackage ../development/python-modules/marionette-harness/mozcrash.nix {};
  mozdevice = callPackage ../development/python-modules/marionette-harness/mozdevice.nix {};
  mozfile = callPackage ../development/python-modules/marionette-harness/mozfile.nix {};
  mozhttpd = callPackage ../development/python-modules/marionette-harness/mozhttpd.nix {};
  mozinfo = callPackage ../development/python-modules/marionette-harness/mozinfo.nix {};
  mozlog = callPackage ../development/python-modules/marionette-harness/mozlog.nix {};
  moznetwork = callPackage ../development/python-modules/marionette-harness/moznetwork.nix {};
  mozprocess = callPackage ../development/python-modules/marionette-harness/mozprocess.nix {};
  mozprofile = callPackage ../development/python-modules/marionette-harness/mozprofile.nix {};
  mozrunner = callPackage ../development/python-modules/marionette-harness/mozrunner.nix {};
  moztest = callPackage ../development/python-modules/marionette-harness/moztest.nix {};
  mozversion = callPackage ../development/python-modules/marionette-harness/mozversion.nix {};
  marionette-harness = callPackage ../development/python-modules/marionette-harness {};

  markupsafe = buildPythonPackage rec {
    name = "markupsafe-${version}";
    version = "1.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/M/MarkupSafe/MarkupSafe-${version}.tar.gz";
      sha256 = "0rdn1s8x9ni7ss8rfiacj7x1085lx8mh2zdwqslnw8xc3l4nkgm6";
    };

    meta = {
      description = "Implements a XML/HTML/XHTML Markup safe string";
      homepage = http://dev.pocoo.org;
      license = licenses.bsd3;
      maintainers = with maintainers; [ domenkozar garbas ];
    };
  };

  marshmallow = callPackage ../development/python-modules/marshmallow { };

  marshmallow-sqlalchemy = callPackage ../development/python-modules/marshmallow-sqlalchemy { };

  manuel = buildPythonPackage rec {
    name = "manuel-${version}";
    version = "1.8.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/m/manuel/${name}.tar.gz";
      sha256 = "1diyj6a8bvz2cdf9m0g2bbx9z2yjjnn3ylbg1zinpcjj6vldfx59";
    };

    propagatedBuildInputs = with self; [ six zope_testing ];

    meta = {
      description = "A documentation builder";
      homepage = https://pypi.python.org/pypi/manuel;
      license = licenses.zpl20;
    };
  };

  markdown = buildPythonPackage rec {
    version = "2.6.8";
    name = "markdown-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/M/Markdown/Markdown-${version}.tar.gz";
      sha256 = "0cqfhr1km2s5d8jm6hbwgkrrj9hvkjf2gab3s2axlrw1clgaij0a";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://www.freewisdom.org/projects/python-markdown;
    };
  };

  markdownsuperscript = callPackage ../development/python-modules/markdownsuperscript {};

  markdown-macros = buildPythonPackage rec {
    name = "markdown-macros-${version}";
    version = "0.1.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/m/markdown-macros/${name}.tar.gz";
      sha256 = "1lzvrb7nci22yp21ab2qqc9p0fhkazqj29vw0wln2r4ckb2nbawv";
    };

    patches = [
      # Fixes a bug with markdown>2.4
      (pkgs.fetchpatch {
        url = "https://github.com/wnielson/markdown-macros/pull/1.patch";
        sha256 = "17njbgq2srzkf03ar6yn92frnsbda3g45cdi529fdh0x8mmyxci0";
      })
    ];

    prePatch = ''
      substituteInPlace setup.py --replace "distribute" "setuptools"
    '';

    propagatedBuildInputs = with self; [ markdown ];

    doCheck = false;

    meta = {
      description = "An extension for python-markdown that makes writing trac-like macros easy";
      homepage = https://github.com/wnielson/markdown-macros;
      license = licenses.mit;
      maintainers = [ maintainers.abigailbuccaneer ];
    };
  };

  mathics = if (versionOlder self.django.version "1.8") ||
               (versionAtLeast self.django.version "1.9")
            then throw "mathics only supports django-1.8.x"
            else buildPythonPackage rec {
    name = "mathics-${version}";
    version = "0.9";
    src = pkgs.fetchFromGitHub {
      owner = "mathics";
      repo = "Mathics";
      rev = "v${version}";
      sha256 = "0xzz7j8xskj5y6as178mjmm0i2xbhd4q4mwmdnvghpd2aqq3qx1c";
    };

    disabled = isPy26;

    buildInputs = with self; [ pexpect ];

    prePatch = ''
      substituteInPlace setup.py --replace "sympy==0.7.6" "sympy"
    '';

    postFixup = ''
      wrapPythonProgramsIn $out/bin $out
      patchPythonScript $out/${python.sitePackages}/mathics/manage.py
    '';

    propagatedBuildInputs = with self; [
      cython
      sympy
      django
      ply
      mpmath
      dateutil
      colorama
      six
    ];

    meta = {
      description = "A general-purpose computer algebra system";
      homepage = http://www.mathics.org;
      license = licenses.gpl3;
      maintainers = [ maintainers.benley ];
    };
  };


  matplotlib = callPackage ../development/python-modules/matplotlib/default.nix {
    stdenv = if stdenv.isDarwin then pkgs.clangStdenv else pkgs.stdenv;
    enableGhostscript = true;
    inherit (pkgs.darwin.apple_sdk.frameworks) Cocoa;
  };

  matrix-client = callPackage ../development/python-modules/matrix-client/default.nix { };

  mccabe = callPackage ../development/python-modules/mccabe { };

  mechanize = buildPythonPackage (rec {
    name = "mechanize-0.3.5";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/m/mechanize/${name}.tar.gz";
      sha256 = "0rki9nl4y42q694parafcsdcdqvkdjckrbg6n0691302lfsrkyfl";
    };

    propagatedBuildInputs = with self; [ html5lib ];

    doCheck = false;

    meta = {
      description = "Stateful programmatic web browsing in Python";

      homepage = http://wwwsearch.sourceforge.net/;

      license = "BSD-style";
    };
  });

  MechanicalSoup = callPackage ../development/python-modules/MechanicalSoup/default.nix { };

  meld3 = buildPythonPackage rec {
    name = "meld3-1.0.0";

    src = pkgs.fetchurl {
      url = mirror://pypi/m/meld3/meld3-1.0.0.tar.gz;
      sha256 = "57b41eebbb5a82d4a928608962616442e239ec6d611fe6f46343e765e36f0b2b";
    };

    doCheck = false;

    meta = {
      description = "An HTML/XML templating engine used by supervisor";
      homepage = https://github.com/supervisor/meld3;
      license = licenses.free;
    };
  };

  meliae = callPackage ../development/python-modules/meliae {};

  memcached = buildPythonPackage rec {
    name = "memcached-1.51";

    src = if isPy3k then pkgs.fetchurl {
      url = "mirror://pypi/p/python3-memcached/python3-${name}.tar.gz";
      sha256 = "0na8b369q8fivh3y0nvzbvhh3lgvxiyyv9xp93cnkvwfsr8mkgkw";
    } else pkgs.fetchurl {
      url = "http://ftp.tummy.com/pub/python-memcached/old-releases/python-${name}.tar.gz";
      sha256 = "124s98m6hvxj6x90d7aynsjfz878zli771q96ns767r2mbqn7192";
    };

    meta = {
      description = "Python API for communicating with the memcached distributed memory object cache daemon";
      homepage = http://www.tummy.com/Community/software/python-memcached/;
    };
  };


  memory_profiler = buildPythonPackage rec {
    name = "memory_profiler-${version}";
    version = "0.41";

    src = pkgs.fetchurl {
      url = "mirror://pypi/m/memory_profiler/${name}.tar.gz";
      sha256 = "dce6e931c281662a500b142595517d095267216472c2926e5ec8edab89898d10";
    };

    # Tests don't import profile
    doCheck = false;

    meta = {
      description = "A module for monitoring memory usage of a python program";
      homepage = https://pypi.python.org/pypi/memory_profiler;
      license = licenses.bsd3;
    };
  };

  metaphone = callPackage ../development/python-modules/metaphone { };

  mezzanine = buildPythonPackage rec {
    version = "3.1.10";
    name = "mezzanine-${version}";

    src = pkgs.fetchurl {
      url = "https://github.com/stephenmcd/mezzanine/archive/${version}.tar.gz";
      sha256 = "1cd7d3dji8q4mvcnf9asxn8j109pd5g5d5shr6xvn0iwr35qprgi";
    };
    patches = [ ../development/python-modules/mezzanine/writable_settings.patch ];

    disabled = isPyPy;

    buildInputs = with self; [ pyflakes pep8 ];
    propagatedBuildInputs = with self; [
      django filebrowser_safe grappelli_safe bleach tzlocal beautifulsoup4
      requests requests_oauthlib future pillow
    ];

    # Tests Fail Due to Syntax Warning, Fixed for v3.1.11+
    doCheck = false;
    # sed calls will be unecessary in v3.1.11+
    preConfigure = ''
      sed -i 's/==/>=/' setup.py
    '';

    LC_ALL="en_US.UTF-8";

    meta = {
      description = ''
        A content management platform built using the Django framework
      '';
      longDescription = ''
        Mezzanine is a powerful, consistent, and flexible content management
        platform. Built using the Django framework, Mezzanine provides a
        simple yet highly extensible architecture that encourages diving in and
        hacking on the code. Mezzanine is BSD licensed and supported by a
        diverse and active community.

        In some ways, Mezzanine resembles tools such as Wordpress that provide
        an intuitive interface for managing pages, blog posts, form data, store
        products, and other types of content. But Mezzanine is also different.
        Unlike many other platforms that make extensive use of modules or
        reusable applications, Mezzanine provides most of its functionality by
        default. This approach yields a more integrated and efficient platform.
      '';
      homepage = http://mezzanine.jupo.org/;
      downloadPage = https://github.com/stephenmcd/mezzanine/releases;
      license = licenses.free;
      maintainers = with maintainers; [ prikhi ];
      platforms = platforms.linux;
      broken = true; # broken dependency of django within filebrowser_safe
    };
  };

  minimock = buildPythonPackage rec {
    version = "1.2.8";
    name = "minimock-${version}";

    src = pkgs.fetchurl {
      url = "https://bitbucket.org/jab/minimock/get/${version}.zip";
      sha256 = "c88fa8a7120623f23990a7f086a9657f6ced09025a55e3be8649a30b4945441a";
    };

    buildInputs = with self; [ nose ];

    checkPhase = "./test";

    meta = {
      description = "A minimalistic mocking library for python";
      homepage = https://pypi.python.org/pypi/MiniMock;
    };
  };

  moviepy = buildPythonPackage rec {
    name = "moviepy-${version}";
    version = "0.2.2.11";

    src = pkgs.fetchurl {
      url = "mirror://pypi/m/moviepy/${name}.tar.gz";
      sha256 = "d937d817e534efc54eaee2fc4c0e70b48fcd81e1528cd6425f22178704681dc3";
    };

    # No tests
    doCheck = false;
    propagatedBuildInputs = with self; [ numpy decorator imageio tqdm ];

    meta = {
      description = "Video editing with Python";
      homepage = http://zulko.github.io/moviepy/;
      license = licenses.mit;
    };
  };

  mplleaflet = callPackage ../development/python-modules/mplleaflet { };

  multidict = callPackage ../development/python-modules/multidict { };

  munch = buildPythonPackage rec {
    name = "munch-${version}";
    version = "2.0.4";

    src = pkgs.fetchurl {
      url = "mirror://pypi/m/munch/${name}.tar.gz";
      sha256 = "1420683a94f3a2ffc77935ddd28aa9ccb540dd02b75e02ed7ea863db437ab8b2";
    };

    meta = {
      description = "A dot-accessible dictionary (a la JavaScript objects)";
      license = licenses.mit;
      homepage = https://github.com/Infinidat/munch;
    };
  };

  notoTools = callPackage ../data/fonts/noto-fonts/tools.nix { };

  rainbowstream = buildPythonPackage rec {
    name = "rainbowstream-${version}";
    version = "1.3.7";

    src = pkgs.fetchurl {
      url    = "mirror://pypi/r/rainbowstream/${name}.tar.gz";
      sha256 = "0zpi1x3b535pwx8rkq57nnrb5d5ma65vvlalar9vi6ilp124x1w2";
    };

    patches = [
      ../development/python-modules/rainbowstream/image.patch
    ];

    postPatch = ''
      clib=$out/${python.sitePackages}/rainbowstream/image.so
      substituteInPlace rainbowstream/c_image.py \
        --replace @CLIB@ $clib
      sed -i 's/requests.*"/requests"/' setup.py
    '';

    LC_ALL="en_US.UTF-8";

    postInstall = ''
      mkdir -p $out/lib
      cc -fPIC -shared -o $clib rainbowstream/image.c
      for prog in "$out/bin/"*; do
        wrapProgram "$prog" \
          --prefix PYTHONPATH : "$PYTHONPATH"
      done
    '';

    buildInputs = with self; [
      pkgs.libjpeg pkgs.freetype pkgs.zlib pkgs.glibcLocales
      pillow twitter pyfiglet requests arrow dateutil pysocks
      pocket
    ];

    meta = {
      description = "Streaming command-line twitter client";
      homepage    = "http://www.rainbowstream.org/";
      license     = licenses.mit;
      maintainers = with maintainers; [ thoughtpolice ];
    };
  };

  pocket = buildPythonPackage rec {
    name = "pocket-${version}";
    version = "0.3.6";

    src = pkgs.fetchurl {
      url    = "mirror://pypi/p/pocket/${name}.tar.gz";
      sha256 = "1fc9vc5nyzf1kzmnrs18dmns7nn8wjfrg7br1w4c5sgs35mg2ywh";
    };

    buildInputs = with self; [
      requests
    ];

    meta = {
      description = "Wrapper for the pocket API";
      homepage    = "https://github.com/tapanpandita/pocket";
      license     = licenses.bsd3;
      maintainers = with maintainers; [ ericsagnes ];
    };
  };

  mistune = callPackage ../development/python-modules/mistune { };

  brotlipy = buildPythonPackage rec {
    name = "brotlipy-${version}";
    version = "0.6.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/b/brotlipy/${name}.tar.gz";
      sha256 = "10s2y19zywfkf3sksrw81czhva759aki0clld2pnnlgf64sz7016";
    };

    propagatedBuildInputs = with self; [ cffi enum34 construct ];

    meta = {
      description = "Python bindings for the reference Brotli encoder/decoder";
      homepage = "https://github.com/python-hyper/brotlipy/";
      license = licenses.mit;
    };
  };

  sortedcontainers = buildPythonPackage rec {
    name = "sortedcontainers-${version}";
    version = "1.5.7";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/sortedcontainers/${name}.tar.gz";
      sha256 = "1sjh8lccbmvwna91mlhl5m3z4320p07h063b8x8br4p4cll49w0g";
    };

    # tries to run tests for all python versions and uses virtualenv weirdly
    doCheck = false;
    #buildInputs = with self; [ tox nose ];

    meta = {
      description = "Python Sorted Container Types: SortedList, SortedDict, and SortedSet";
      homepage = "http://www.grantjenks.com/docs/sortedcontainers/";
      license = licenses.asl20;
    };
  };

  sortedcollections = buildPythonPackage rec {
    name = "sortedcollections-${version}";
    version = "0.4.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/sortedcollections/${name}.tar.gz";
      sha256 = "12dlzln9gyv8smsy2k6d6dmr0ywrpwyrr1cjy649ia5h1g7xdvwa";
    };
    buildInputs = [ self.sortedcontainers ];

    # wants to test all python versions with tox:
    doCheck = false;

    meta = {
      description = "Python Sorted Collections";
      homepage = http://www.grantjenks.com/docs/sortedcollections/;
      license = licenses.asl20;
    };
  };

  hyperframe = callPackage ../development/python-modules/hyperframe { };

  h2 = callPackage ../development/python-modules/h2 { };

  editorconfig = buildPythonPackage rec {
    name = "EditorConfig-${version}";
    version = "0.12.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/e/editorconfig/${name}.tar.gz";
      sha256 = "1qxqy9wfrpb2ldrk5nzidkpymc55lpf9lg3m8c8a5531jmbwhlwb";
    };

    meta = {
      description = "EditorConfig File Locator and Interpreter for Python";
      homepage = "http://editorconfig.org/";
      license = licenses.psfl;
    };
  };

  mock = buildPythonPackage (rec {
    name = "mock-2.0.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/m/mock/${name}.tar.gz";
      sha256 = "1flbpksir5sqrvq2z0dp8sl4bzbadg21sj4d42w3klpdfvgvcn5i";
    };

    buildInputs = with self; [ unittest2 ];
    propagatedBuildInputs = with self; [ funcsigs six pbr ];

    checkPhase = ''
      ${python.interpreter} -m unittest discover
    '';

    meta = {
      description = "Mock objects for Python";
      homepage = http://python-mock.sourceforge.net/;
      license = stdenv.lib.licenses.bsd2;
    };
  });

  modestmaps = buildPythonPackage rec {
    name = "ModestMaps-1.4.6";

    src = pkgs.fetchurl {
      url = "mirror://pypi/M/ModestMaps/${name}.tar.gz";
      sha256 = "0vyi1m9q4pc34i6rq5agb4x3qicx5sjlbxwmxfk70k2l5mnbjca3";
    };

    disabled = !isPy27;
    propagatedBuildInputs = with self; [ pillow ];

    meta = {
      description = "A library for building interactive maps";
      homepage = http://modestmaps.com;
      license = stdenv.lib.licenses.bsd3;
    };
  };

  moinmoin = buildPythonPackage (rec {
    name = "moinmoin-${ver}";
    disabled = isPy3k;
    ver = "1.9.8";

    src = pkgs.fetchurl {
      url = "http://static.moinmo.in/files/moin-${ver}.tar.gz";
      sha256 = "19hi16iy75lpx9ch799djc4hr4gai5rmvi542n29x6zhikysfjx7";
    };

    meta = {
      description = "Advanced, easy to use and extensible WikiEngine";

      homepage = http://moinmo.in/;

      license = licenses.gpl2Plus;
    };
  });

  moretools = callPackage ../development/python-modules/moretools { };

  moto = callPackage ../development/python-modules/moto {};

  mox = buildPythonPackage rec {
    name = "mox-0.5.3";

    src = pkgs.fetchurl {
      url = "http://pymox.googlecode.com/files/${name}.tar.gz";
      sha256 = "4d18a4577d14da13d032be21cbdfceed302171c275b72adaa4c5997d589a5030";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://code.google.com/p/pymox/;
      description = "A mock object framework for Python";
    };
  };

  mozsvc = buildPythonPackage rec {
    name = "mozsvc-${version}";
    version = "0.8";

    src = pkgs.fetchgit {
      url = https://github.com/mozilla-services/mozservices.git;
      rev = "refs/tags/${version}";
      sha256 = "1zci2ikk83mf7va88c83dr6snfh4ddjqw0lsg3y29qk5nxf80vx2";
    };

    patches = singleton (pkgs.fetchurl {
      url = https://github.com/nbp/mozservices/commit/f86c0b0b870cd8f80ce90accde9e16ecb2e88863.diff;
      sha256 = "1lnghx821f6dqp3pa382ka07cncdz7hq0mkrh44d0q3grvrlrp9n";
    });

    doCheck = false; # lazy packager
    propagatedBuildInputs = with self; [ pyramid simplejson konfig ];

    meta = {
      homepage = https://github.com/mozilla-services/mozservices;
      description = "Various utilities for Mozilla apps";
    };
  };

  mpmath = buildPythonPackage rec {
    name = "mpmath-0.19";

    src = pkgs.fetchurl {
      url = "mirror://pypi/m/mpmath/${name}.tar.gz";
      sha256 = "08ijsr4ifrqv3cjc26mkw0dbvyygsa99in376hr4b96ddm1gdpb8";
    };

    meta = {
      homepage    = http://mpmath.googlecode.com;
      description = "A pure-Python library for multiprecision floating arithmetic";
      license     = licenses.bsd3;
      maintainers = with maintainers; [ lovek323 ];
      platforms   = platforms.unix;
    };

    # error: invalid command 'test'
    doCheck = false;
  };


  mpd = buildPythonPackage rec {
    name = "python-mpd-0.3.0";

    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/python-mpd/python-mpd-0.3.0.tar.gz";
      sha256 = "02812eba1d2e0f46e37457f5a6fa23ba203622e4bcab0a19b265e66b08cd21b4";
    };

    meta = with pkgs.stdenv.lib; {
      description = "An MPD (Music Player Daemon) client library written in pure Python";
      homepage = http://jatreuman.indefero.net/p/python-mpd/;
      license = licenses.gpl3;
    };
  };

  mpd2 = buildPythonPackage rec {
    name = "mpd2-${version}";
    version = "0.5.5";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/python-mpd2/python-mpd2-${version}.tar.bz2";
      sha256 = "1gfrxf71xll1w6zb69znqg5c9j0g7036fsalkvqprh2id640cl3a";
    };

    buildInputs = with self; [ mock ];
    patchPhase = ''
      sed -i -e '/tests_require/d' \
          -e 's/cmdclass.*/test_suite="mpd_test",/' setup.py
    '';

    meta = {
      description = "A Python client module for the Music Player Daemon";
      homepage = "https://github.com/Mic92/python-mpd2";
      license = licenses.lgpl3Plus;
      maintainers = with maintainers; [ rvl mic92 ];
    };
  };

  mpv = buildPythonPackage rec {
    name = "mpv-0.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/m/mpv/${name}.tar.gz";
      sha256 = "0b9kd70mshdr713f3l1lbnz1q0vlg2y76h5d8liy1bzqm7hjcgfw";
    };
    buildInputs = [ pkgs.mpv ];
    patchPhase = "substituteInPlace mpv.py --replace libmpv.so ${pkgs.mpv}/lib/libmpv.so";

    meta = with pkgs.stdenv.lib; {
      description = "A python interface to the mpv media player";
      homepage = "https://github.com/jaseg/python-mpv";
      license = licenses.agpl3;
    };

  };


  mrbob = buildPythonPackage rec {
    name = "mrbob-${version}";
    version = "0.1.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/m/mr.bob/mr.bob-${version}.tar.gz";
      sha256 = "6737eaf98aaeae85e07ebef844ee5156df2f06a8b28d7c3dcb056f811c588121";
    };

    buildInputs = [ pkgs.glibcLocales self.mock ];

    disabled = isPy3k;

    LC_ALL="en_US.UTF-8";

    propagatedBuildInputs = with self; [ argparse jinja2 six ] ++
                            (optionals isPy26 [ importlib ordereddict ]);

    meta = {
      homepage = https://github.com/domenkozar/mr.bob.git;
      description = "A tool to generate code skeletons from templates";
    };
  };

  msgpack = buildPythonPackage rec {
    name = "msgpack-python-${version}";
    version = "0.4.7";

    src = pkgs.fetchurl {
      url = "mirror://pypi/m/msgpack-python/${name}.tar.gz";
      sha256 = "0syd7bs83qs9qmxw540jbgsildbqk4yb57fmrlns1021llli402y";
    };

    checkPhase = ''
      py.test
    '';

    buildInputs = with self; [ pytest ];
    propagatedBuildInputs = with self; [ ];
  };

  msrplib = buildPythonPackage rec {
    pname = "python-msrplib";
    name = "${pname}-${version}";
    version = "0.19";

    src = pkgs.fetchdarcs {
      url = "http://devel.ag-projects.com/repositories/${pname}";
      rev = "release-${version}";
      sha256 = "0jqvvssbwzq7bwqn3wrjfnpj8zb558mynn2visnlrcma6b57yhwd";
    };

    propagatedBuildInputs = with self; [ eventlib application gnutls ];
  };

  multipledispatch = callPackage ../development/python-modules/multipledispatch { };

  multiprocess = buildPythonPackage rec {
    name = "multiprocess-${version}";
    version = "0.70.4";

    src = pkgs.fetchurl {
      url = "mirror://pypi/m/multiprocess/${name}.tgz";
      sha256 = "73f8b9b7009860e3c3c8b9bdcad7e8366b130929775f89c114d4346a9cfcb31b";
    };

    propagatedBuildInputs = with self; [ dill ];

    # Python-version dependent tests
    doCheck = false;

    meta = {
      description = "Better multiprocessing and multithreading in python";
      homepage = https://github.com/uqfoundation;
      license = licenses.bsd3;
    };
  };

  munkres = buildPythonPackage rec {
    name = "munkres-1.0.6";

    src = pkgs.fetchurl {
      url = "mirror://pypi/m/munkres/${name}.tar.gz";
      sha256 = "c78f803b9b776bfb20a25c9c7bb44adbf0f9202c2024d51aa5969d21e560208d";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://bmc.github.com/munkres/;
      description = "Munkres algorithm for the Assignment Problem";
      license = licenses.bsd3;
      maintainers = with maintainers; [ domenkozar ];
    };
  };


  musicbrainzngs = buildPythonPackage rec {
    name = "musicbrainzngs-0.5";

    src = pkgs.fetchurl {
      url = "mirror://pypi/m/musicbrainzngs/${name}.tar.gz";
      sha256 = "281388ab750d2996e9feca4580fd4215d616a698e02cd6719cb9b8562945c489";
    };

    buildInputs = [ pkgs.glibcLocales ];

    LC_ALL="en_US.UTF-8";

    meta = {
      homepage = http://alastair/python-musicbrainz-ngs;
      description = "Python bindings for musicbrainz NGS webservice";
      license = licenses.bsd2;
      maintainers = with maintainers; [ domenkozar ];
    };
  };

  mutag = buildPythonPackage rec {
    disabled = ! isPy3k;
    name = "mutag-0.0.2-2ffa0258ca";
    src = pkgs.fetchgit {
      url = "https://github.com/aroig/mutag.git";
      sha256 = "0axdnwdypfd74a9dnw0g25m16xx1yygyl828xy0kpj8gyqdc6gb1";
      rev = "2ffa0258cadaf79313241f43bf2c1caaf197d9c2";
    };

    propagatedBuildInputs = with self; [ pyparsing ];

    meta = {
      homepage = https://github.com/aroig/mutag;
      license = licenses.gpl3;
      maintainers = with maintainers; [ ];
    };
  };

  mutagen = buildPythonPackage (rec {
    name = "mutagen-1.36";

    src = pkgs.fetchurl {
      url = "mirror://pypi/m/mutagen/${name}.tar.gz";
      sha256 = "1kabb9b81hgvpd3wcznww549vss12b1xlvpnxg1r6n4c7gikgvnp";
    };

    # Needed for tests only
    buildInputs = with self; [ pkgs.faad2 pkgs.flac pkgs.vorbis-tools pkgs.liboggz
      pkgs.glibcLocales pytest
    ];
    LC_ALL = "en_US.UTF-8";

    # Remove test that fails due to missing encoding in nix_run_setup.py, a
    # file that buildPythonPackage copies to source trees at build time.
    # PR with fix: https://github.com/NixOS/nixpkgs/pull/17430
    # ("python: add file encoding to run_setup.py")
    preBuild = ''
      rm tests/test_encoding.py
    '';

    meta = {
      description = "Python multimedia tagging library";
      homepage = http://code.google.com/p/mutagen;
      license = licenses.lgpl2;
    };
  });


  muttils = buildPythonPackage (rec {
    name = "muttils-1.3";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = http://www.blacktrash.org/hg/muttils/archive/8bb26094df06.tar.bz2;
      sha256 = "1a4kxa0fpgg6rdj5p4kggfn8xpniqh8v5kbiaqc6wids02m7kag6";
    };

    # Tests don't work
    doCheck = false;

    meta = {
      description = "Utilities for use with console mail clients, like mutt";
      homepage = http://www.blacktrash.org/hg/muttils;
      license = licenses.gpl2Plus;
    };
  });

  mygpoclient = buildPythonPackage rec {
    name = "mygpoclient-${version}";
    version = "1.7";

    src = pkgs.fetchurl {
      url = "https://thp.io/2010/mygpoclient/${name}.tar.gz";
      sha256 = "6a0b7b1fe2b046875456e14eda3e42430e493bf2251a64481cf4fd1a1e21a80e";
    };

    buildInputs = with self; [ nose minimock ];

    checkPhase = ''
      nosetests
    '';

    disabled = isPy3k;

    meta = {
      description = "A gpodder.net client library";
      longDescription = ''
        The mygpoclient library allows developers to utilize a Pythonic interface
        to the gpodder.net web services.
      '';
      homepage = https://thp.io/2010/mygpoclient/;
      license = with licenses; [ gpl3 ];
      platforms = with platforms; linux ++ darwin;
      maintainers = with maintainers; [ skeidel ];
    };
  };

  mwclient = buildPythonPackage rec {
    version = "0.8.3";
    pname = "mwclient";
    name = "${pname}-${version}";

    src = pkgs.fetchFromGitHub {
      owner = "mwclient";
      repo = "mwclient";
      rev = "v${version}";
      sha256 = "0kl1yp9z5f1wl6lkm0vix87zkrbl9wcmkrrj1x5c35xvf95laf53";
    };

    buildInputs = with self; [ mock responses pytestcov pytest pytestcache pytestpep8 coverage ];

    propagatedBuildInputs = with self; [ six requests requests_oauthlib ];

    checkPhase = ''
      py.test
    '';

    meta = {
      description = "Python client library to the MediaWiki API";
      maintainers = with maintainers; [ ];
      license = licenses.mit;
      homepage = https://github.com/mwclient/mwclient;
    };
  };

  neuronpy = buildPythonPackage rec {
    name = "neuronpy-${version}";
    version = "0.1.6";
    disabled = !isPy27;

    propagatedBuildInputs = with self; [ numpy matplotlib scipy ];

    meta = {
      description = "Interfaces and utilities for the NEURON simulator and analysis of neural data";
      maintainers = [ maintainers.nico202 ];
      license = licenses.mit;
    };

    #No tests included
    doCheck = false;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/n/neuronpy/neuronpy-${version}.tar.gz";
      sha256 = "1clhc2b5fy2l8nfrji4dagmj9419nj6kam090yqxhq5c28sngk25";
    };
  };

  pint = buildPythonPackage rec {
    name = "pint-${version}";
    version = "0.7.2";

    meta = {
      description = "Physical quantities module";
      license = licenses.bsd3;
      homepage = "https://github.com/hgrecco/pint/";
    };

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pint/Pint-${version}.tar.gz";
      sha256 = "1bbp5s34gcb9il2wyz4spznshahwbjvwi5bhjm7bnxk358spvf9q";
    };
  };

  pygal = buildPythonPackage rec {
    pname = "pygal";
    version = "2.3.1";
    name = "${pname}-${version}";

    doCheck = !isPyPy;  # one check fails with pypy

    src = fetchPypi {
      inherit pname version;
      sha256 = "7ba5a191233d0c2d8bf4b4d26b06e42bd77483a59ba7d3e5b884d81d1a870667";
    };

    buildInputs = with self; [ flask pyquery pytest ];
    propagatedBuildInputs = with self; [ cairosvg tinycss cssselect ] ++ optionals (!isPyPy) [ lxml ];

    meta = {
      description = "Sexy and simple python charting";
      homepage = http://www.pygal.org;
      license = licenses.lgpl3;
      maintainers = with maintainers; [ sjourdois ];
    };
  };

  pyte = callPackage ../development/python-modules/pyte { };

  graphviz = buildPythonPackage rec {
    name = "graphviz-${version}";
    version = "0.5.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/g/graphviz/${name}.zip";
      sha256 = "0jh31nlm0qbxwylhdkwnb69pcjlc5z03fcfbs0gvgzp3hfrngsk0";
    };

    propagatedBuildInputs = [ pkgs.graphviz ];

    meta = {
      description = "Simple Python interface for Graphviz";
      homepage = https://github.com/xflr6/graphviz;
      license = licenses.mit;
    };
  };

  pygraphviz = callPackage ../development/python-modules/pygraphviz { };

  pympler = buildPythonPackage rec {
    pname = "Pympler";
    version = "0.4.3";
    name = "${pname}-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/P/${pname}/${name}.tar.gz";
      sha256 = "0mhyxqlkha98y8mi5zqcjg23r30mgdjdzs05lghbmqfdyvzjh1a3";
    };

  # Remove test asizeof.flatsize(), broken and can be missed as
  # test is only useful on python 2.5, see https://github.com/pympler/pympler/issues/22
   patchPhase = ''
     substituteInPlace ./test/asizeof/test_asizeof.py --replace "n, e = test_flatsize" "#n, e = test_flatsize"
     substituteInPlace ./test/asizeof/test_asizeof.py --replace "self.assert_(n," "#self.assert_(n,"
     substituteInPlace ./test/asizeof/test_asizeof.py --replace "self.assert_(not e" "#self.assert_(not e"
    '';

    doCheck = stdenv.hostPlatform.isLinux;

    meta = {
      description = "Tool to measure, monitor and analyze memory behavior";
      homepage = http://pythonhosted.org/Pympler/;
      license = licenses.asl20;
    };
  };

  pymysql = buildPythonPackage rec {
    name = "pymysql-${version}";
    version = "0.6.6";
    src = pkgs.fetchgit {
      url = https://github.com/PyMySQL/PyMySQL.git;
      rev = "refs/tags/pymysql-${version}";
      sha256 = "0kpw11rxpyyhs9b139hxhbnx9n5kzjjw10wgwvhnf9m3mv7j4n71";
    };

    buildInputs = with self; [ unittest2 ];

    checkPhase = ''
      ${python.interpreter} runtests.py
    '';

    # Wants to connect to MySQL
    doCheck = false;
  };

  pymysqlsa = self.buildPythonPackage rec {
    name = "pymysqlsa-${version}";
    version = "1.0";

    propagatedBuildInputs = with self; [ pymysql sqlalchemy ];

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pymysql_sa/pymysql_sa-1.0.tar.gz";
      sha256 = "a2676bce514a29b2d6ab418812259b0c2f7564150ac53455420a20bd7935314a";
    };

    meta = {
      description = "PyMySQL dialect for SQL Alchemy";
      homepage = https://pypi.python.org/pypi/pymysql_sa;
      license = licenses.mit;
    };
  };

  monotonic = buildPythonPackage rec {
    pname = "monotonic";
    version = "1.3";
    name = "${pname}-${version}";

    __propagatedImpureHostDeps = stdenv.lib.optional stdenv.isDarwin "/usr/lib/libc.dylib";

    src = fetchPypi {
      inherit pname version;
      sha256 = "06vw7jwq96106plhlc5vz1v1xvjismdgw9wjyzvzf0ylglnrwiib";
    };

    patchPhase = optionalString stdenv.isLinux ''
      substituteInPlace monotonic.py --replace \
        "ctypes.util.find_library('c')" "'${stdenv.glibc.out}/lib/libc.so.6'"
    '';
  };

  MySQL_python = buildPythonPackage rec {
    name = "MySQL-python-1.2.5";

    disabled = isPy3k;

    # plenty of failing tests
    doCheck = false;

    src = pkgs.fetchurl {
      url = "mirror://pypi/M/MySQL-python/${name}.zip";
      sha256 = "0x0c2jg0bb3pp84njaqiic050qkyd7ymwhfvhipnimg58yv40441";
    };

    buildInputs = with self; [ nose pkgs.openssl ];

    propagatedBuildInputs = with self; [ pkgs.mysql.lib pkgs.zlib ];

    meta = {
      description = "MySQL database binding for Python";

      homepage = https://sourceforge.net/projects/mysql-python;
    };
  };


  mysql_connector_repackaged = buildPythonPackage rec {
    name = "mysql-connector-repackaged-0.3.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/m/mysql-connector-repackaged/${name}.tar.gz";
      sha256 = "170fbf11c54def1b5fcc919be0a890b760bb2eca81f56123a5dda0c69b5b099e";
    };

    # Judging from SyntaxError
    disabled = isPy3k;

    meta = {
      maintainers = with maintainers; [ garbas domenkozar ];
      platforms = platforms.linux;
    };
  };


  namebench = buildPythonPackage (rec {
    name = "namebench-1.3.1";
    disabled = isPy3k || isPyPy;

    src = pkgs.fetchurl {
      url = "http://namebench.googlecode.com/files/${name}-source.tgz";
      sha256 = "09clbcd6wxgk4r6qw7hb78h818mvca7lijigy1mlq5y1f3lgkk1h";
    };

    # error: invalid command 'test'
    doCheck = false;

    propagatedBuildInputs = [ self.tkinter ];

    # namebench expects to be run from its own source tree (it uses relative
    # paths to various resources), make it work.
    postInstall = ''
      sed -i "s|import os|import os; os.chdir(\"$out/namebench\")|" "$out/bin/namebench.py"
    '';

    meta = {
      homepage = http://namebench.googlecode.com/;
      description = "Find fastest DNS servers available";
      license = with licenses; [
        asl20
        # third-party program licenses (embedded in the sources)
        "LGPL" # Crystal_Clear
        free # dns
        asl20 # graphy
        "BSD" # jinja2
      ];
      longDescription = ''
        It hunts down the fastest DNS servers available for your computer to
        use. namebench runs a fair and thorough benchmark using your web
        browser history, tcpdump output, or standardized datasets in order
        to provide an individualized recommendation. namebench is completely
        free and does not modify your system in any way.
      '';
    };
  });


  nameparser = buildPythonPackage rec {
    name = "nameparser-${version}";
    version = "0.3.4";

    src = pkgs.fetchurl {
      url = "mirror://pypi/n/nameparser/${name}.tar.gz";
      sha256 = "1zi94m99ziwwd6kkip3w2xpnl05r2cfv9iq68inz7np81c3g8vag";
    };

    meta = {
      description = "A simple Python module for parsing human names into their individual components";
      homepage = https://github.com/derek73/python-nameparser;
      license = licenses.lgpl21Plus;
    };
  };

  nbconvert = callPackage ../development/python-modules/nbconvert { };

  nbformat = callPackage ../development/python-modules/nbformat { };

  nbmerge = callPackage ../development/python-modules/nbmerge { };

  nbxmpp = callPackage ../development/python-modules/nbxmpp { };

  sleekxmpp = buildPythonPackage rec {
    name = "sleekxmpp-${version}";
    version = "1.3.1";

    propagatedBuildInputs = with self ; [ dns pyasn1 ];

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/sleekxmpp/${name}.tar.gz";
      sha256 = "1krkhkvj8xw5a6c2xlf7h1rg9xdcm9d8x2niivwjahahpvbl6krr";
    };

    meta = {
      description = "XMPP library for Python";
      license = licenses.mit;
      homepage = "http://sleekxmpp.com/";
    };
  };

  slixmpp = buildPythonPackage rec {
    name = "slixmpp-${version}";
    version = "1.2.4.post1";

    disabled = pythonOlder "3.4";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/slixmpp/${name}.tar.gz";
      sha256 = "0v6430dczai8a2nmznhja2dxl6pxa8c5j20nhc5737bqjg7245jk";
    };

    patchPhase = ''
      substituteInPlace slixmpp/thirdparty/gnupg.py \
        --replace "gpgbinary='gpg'" "gpgbinary='${pkgs.gnupg1}/bin/gpg'"
    '';

    propagatedBuildInputs = with self ; [ aiodns pyasn1 pkgs.gnupg1 pyasn1-modules];

    meta = {
      description = "Elegant Python library for XMPP";
      license = licenses.mit;
      homepage = https://dev.louiz.org/projects/slixmpp;
    };
  };

  netaddr = buildPythonPackage rec {
    pname = "netaddr";
    version = "0.7.19";
    name = "${pname}-${version}";

    src = fetchPypi {
      inherit pname version;
      sha256 = "38aeec7cdd035081d3a4c306394b19d677623bf76fa0913f6695127c7753aefd";
    };

    LC_ALL = "en_US.UTF-8";
    buildInputs = with self; [ pkgs.glibcLocales pytest ];

    checkPhase = ''
      py.test netaddr/tests
    '';

    patches = [
      (pkgs.fetchpatch {
        url = https://github.com/drkjam/netaddr/commit/2ab73f10be7069c9412e853d2d0caf29bd624012.patch;
        sha256 = "0s1cdn9v5alpviabhcjmzc0m2pnpq9dh2fnnk2x96dnry1pshg39";
      })
    ];

    meta = {
      homepage = https://github.com/drkjam/netaddr/;
      description = "A network address manipulation library for Python";
    };
  };

  netifaces = buildPythonPackage rec {
    version = "0.10.6";
    name = "netifaces-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/n/netifaces/${name}.tar.gz";
      sha256 = "1q7bi5k2r955rlcpspx4salvkkpk28jky67fjbpz2dkdycisak8c";
    };

    meta = {
      homepage = http://alastairs-place.net/projects/netifaces/;
      description = "Portable access to network interfaces from Python";
    };
  };

  hpack = buildPythonPackage rec {
    name = "hpack-${version}";
    version = "2.3.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/h/hpack/hpack-${version}.tar.gz";
      sha256 = "1ad0fx4d7a52zf441qzhjc7vwy9v3qdrk1zyf06ikz8y2nl9mgai";
    };

    meta = with stdenv.lib; {
      description = "========================================";
      homepage = "http://hyper.rtfd.org";
    };
  };

  nevow = buildPythonPackage (rec {
    name = "nevow-${version}";
    version = "0.14.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/N/Nevow/Nevow-${version}.tar.gz";
      sha256 = "0wsh40ysj5gvfc777nrdvf5vbkr606r1gh7ibvw7x8b5g8afdy3y";
      name = "${name}.tar.gz";
    };

    disabled = isPy3k;

    propagatedBuildInputs = with self; [ twisted ];

    postInstall = "twistd --help > /dev/null";

    meta = {
      description = "Nevow, a web application construction kit for Python";

      longDescription = ''
        Nevow - Pronounced as the French "nouveau", or "noo-voh", Nevow
        is a web application construction kit written in Python.  It is
        designed to allow the programmer to express as much of the view
        logic as desired in Python, and includes a pure Python XML
        expression syntax named stan to facilitate this.  However it
        also provides rich support for designer-edited templates, using
        a very small XML attribute language to provide bi-directional
        template manipulation capability.

        Nevow also includes formless, a declarative syntax for
        specifying the types of method parameters and exposing these
        methods to the web.  Forms can be rendered automatically, and
        form posts will be validated and input coerced, rendering error
        pages if appropriate.  Once a form post has validated
        successfully, the method will be called with the coerced values.
      '';

      homepage = http://divmod.org/trac/wiki/DivmodNevow;

      license = "BSD-style";
    };
  });

  nibabel = buildPythonPackage rec {
    version = "2.0.2";
    name = "nibabel-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/n/nibabel/${name}.tar.gz";
      sha256 = "0k8mv5zmwb6vc8kwrydl3pp0pnw937rf5mz10figkxczrw6dkk7h";
    };

    propagatedBuildInputs = with self; [
      numpy
      nose
    ];

    # Failing tests
    # nibabel.tests.test_minc1.test_old_namespace
    # nisext.tests.test_testers.test_back_tick
    doCheck = false;

    meta = {
      homepage = http://nipy.org/nibabel/;
      description = "Access a multitude of neuroimaging data formats";
      license = licenses.mit;
    };
  };

  nilearn = callPackage ../development/python-modules/nilearn {};

  nipy = buildPythonPackage rec {
    version = "0.4.0";
    name = "nipy-${version}";

    disabled = pythonOlder "2.6";

    checkPhase = ''    # wants to be run in a different directory
      mkdir nosetests
      cd nosetests
      ${python.interpreter} -c "import nipy; nipy.test()"
      rm -rf .
    '';
    # failing test:
    # nipy.algorithms.statistics.models.tests.test_olsR.test_results(11.593139639404727, 11.593140144880794, 6)  # disagrees by 1 at 6th decimal place
    # erroring tests:
    # nipy.modalities.fmri.fmristat.tests.test_FIAC.test_altprotocol
    # nipy.modalities.fmri.fmristat.tests.test_FIAC.test_agreement
    # nipy.tests.test_scripts.test_nipy_4d_realign   # because `nipy_4d_realign` script isn't found at test time; works from nix-shell, so could be patched
    # nipy.tests.test_scripts.test_nipy_3_4d         # ditto re.: `nipy_3_4d` script
    doCheck = false;

    src = pkgs.fetchurl {
      url = "mirror://pypi/n/nipy/${name}.tar.gz";
      sha256 = "1hnbn2i4fjxflaaz082s2c57hfp59jfra1zayz1iras5p2dy21nr";
    };

    buildInputs = stdenv.lib.optional doCheck [ self.nose ];

    propagatedBuildInputs = with self; [
      matplotlib
      nibabel
      numpy
      scipy
      sympy
    ];

    meta = {
      homepage = http://nipy.org/nipy/;
      description = "Software for structural and functional neuroimaging analysis";
      license = licenses.bsd3;
    };
  };

  nipype = buildPythonPackage rec {
    version = "0.10.0";
    name = "nipype-${version}";

    # Uses python 2 print. Master seems to be Py3 compatible.
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/n/nipype/${name}.tar.gz";
      sha256 = "7fb143cd4d05f18db1cb7f0b83dba13d3dcf55b4eb3d16df08c97033ccae507b";
    };

    # Tests fail due to getcwd returning ENOENT???
    doCheck = false;

    propagatedBuildInputs = with self; [
     numpy
     dateutil
     nose
     traits
     scipy
     nibabel
     networkx
   ];

    meta = {
      homepage = http://nipy.org/nipype/;
      description = "Neuroimaging in Python: Pipelines and Interfaces";
      license = licenses.bsd3;
    };
  };

  nose = buildPythonPackage rec {
    version = "1.3.7";
    name = "nose-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/n/nose/${name}.tar.gz";
      sha256 = "f1bffef9cbc82628f6e7d7b40d7e255aefaa1adb6a1b1d26c69a8b79e6208a98";
    };

    propagatedBuildInputs = [ self.coverage ];

    doCheck = false;  # lot's of transient errors, too much hassle
    checkPhase = if python.is_py3k or false then ''
      ${python}/bin/${python.executable} setup.py build_tests
    '' else "" + ''
      rm functional_tests/test_multiprocessing/test_concurrent_shared.py* # see https://github.com/nose-devs/nose/commit/226bc671c73643887b36b8467b34ad485c2df062
      ${python}/bin/${python.executable} selftest.py
    '';

    meta = {
      description = "A unittest-based testing framework for python that makes writing and running tests easier";
    };
  };

  nose-exclude = callPackage ../development/python-modules/nose-exclude { };

  nose2 = if isPy26 then null else (buildPythonPackage rec {
    name = "nose2-0.5.0";
    src = pkgs.fetchurl {
      url = "mirror://pypi/n/nose2/${name}.tar.gz";
      sha256 = "0595rh6b6dncbj0jigsyrgrh6h8fsl6w1fr69h76mxv9nllv0rlr";
    };
    meta = {
      description = "nose2 is the next generation of nicer testing for Python";
    };
    propagatedBuildInputs = with self; [ six ];
    # AttributeError: 'module' object has no attribute 'collector'
    doCheck = false;
  });

  nose-cover3 = buildPythonPackage rec {
    name = "nose-cover3-${version}";
    version = "0.1.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/n/nose-cover3/${name}.tar.gz";
      sha256 = "1la4hhc1yszjpcchvkqk5xmzlb2g1b3fgxj9wwc58qc549whlcc1";
    };

    propagatedBuildInputs = with self; [ nose ];

    # No tests included
    doCheck = false;

    meta = {
      description = "Coverage 3.x support for Nose";
      homepage = https://github.com/ask/nosecover3;
      license = licenses.lgpl21;
    };
  };

  nosexcover = buildPythonPackage (rec {
    name = "nosexcover-1.0.10";

    src = pkgs.fetchurl {
      url = "mirror://pypi/n/nosexcover/${name}.tar.gz";
      sha256 = "f5b3a7c936c4f703f15418c1f325775098184b69fa572f868edb8a99f8f144a8";
    };

    propagatedBuildInputs = with self; [ coverage nose ];

    meta = {
      description = "Extends nose.plugins.cover to add Cobertura-style XML reports";

      homepage = https://github.com/cmheisel/nose-xcover/;

      license = licenses.bsd3;
    };
  });

  nosejs = buildPythonPackage {
    name = "nosejs-0.9.4";
    src = pkgs.fetchurl {
      url = mirror://pypi/N/NoseJS/NoseJS-0.9.4.tar.gz;
      sha256 = "0qrhkd3sga56qf6k0sqyhwfcladwi05gl6aqmr0xriiq1sgva5dy";
    };
    buildInputs = with self; [ nose ];

    checkPhase = ''
      nosetests -v
    '';

  };

  nose-cprof = buildPythonPackage rec {
    name = "nose-cprof-${version}";
    version = "0.1.4";

    src = pkgs.fetchurl {
      url = "mirror://pypi/n/nose-cprof/${name}.tar.gz";
      sha256 = "0ayy5mbjly9aa9dkgpz0l06flspnxmnj6wxdl6zr59byrrr8fqhw";
    };

    meta = {
      description = "A python nose plugin to profile using cProfile rather than the default Hotshot profiler";
    };

    buildInputs = with self; [ nose ];
  };

  nose_warnings_filters = callPackage ../development/python-modules/nose_warnings_filters { };

  notebook = callPackage ../development/python-modules/notebook { };

  notify = pkgs.stdenv.mkDerivation (rec {
    name = "python-notify-0.1.1";

    src = pkgs.fetchurl {
      url = http://www.galago-project.org/files/releases/source/notify-python/notify-python-0.1.1.tar.bz2;
      sha256 = "1kh4spwgqxm534qlzzf2ijchckvs0pwjxl1irhicjmlg7mybnfvx";
    };

    patches = singleton (pkgs.fetchurl {
      name = "libnotify07.patch";
      url = "http://pkgs.fedoraproject.org/cgit/notify-python.git/plain/"
          + "libnotify07.patch?id2=289573d50ae4838a1658d573d2c9f4c75e86db0c";
      sha256 = "1lqdli13mfb59xxbq4rbq1f0znh6xr17ljjhwmzqb79jl3dig12z";
    });

    postPatch = ''
      sed -i -e '/^PYGTK_CODEGEN/s|=.*|="${self.pygtk}/bin/pygtk-codegen-2.0"|' \
        configure
    '';

    nativeBuildInputs = [ pkgs.pkgconfig ];
    buildInputs = with self; [ python pkgs.libnotify pygobject2 pygtk pkgs.glib pkgs.gtk2 pkgs.dbus_glib ];

    postInstall = "cd $out/lib/python*/site-packages && ln -s gtk-*/pynotify .";

    meta = {
      description = "Python bindings for libnotify";
      homepage = http://www.galago-project.org/;
    };
  });

  notmuch = buildPythonPackage rec {
    name = "python-${pkgs.notmuch.name}";

    src = pkgs.notmuch.src;

    sourceRoot = pkgs.notmuch.pythonSourceRoot;

    buildInputs = with self; [ python pkgs.notmuch ];

    postPatch = ''
      sed -i -e '/CDLL/s@"libnotmuch\.@"${pkgs.notmuch}/lib/libnotmuch.@' \
        notmuch/globals.py
    '';

    meta = {
      description = "A Python wrapper around notmuch";
      homepage = http://notmuchmail.org/;
      maintainers = with maintainers; [ garbas ];
    };
  };

  emoji = callPackage ../development/python-modules/emoji { };

  ntfy = buildPythonPackage rec {
    version = "1.2.0";
    name = "ntfy-${version}";
    src = pkgs.fetchFromGitHub {
      owner = "dschep";
      repo = "ntfy";
      rev = "v${version}";
      sha256 = "0yjxwisxpxy3vpnqk9nw5k3db3xx6wyf6sk1px9m94s30glcq2cc";
    };

    propagatedBuildInputs = with self; [ appdirs pyyaml requests dbus-python emoji sleekxmpp mock ];

    meta = {
      description = "A utility for sending notifications, on demand and when commands finish";
      homepage = http://ntfy.rtfd.org/;
      license = licenses.gpl3;
      maintainers = with maintainers; [ kamilchm ];
    };
  };

  ntplib = buildPythonPackage rec {
    name = "ntplib-0.3.3";
    src = pkgs.fetchurl {
      url = mirror://pypi/n/ntplib/ntplib-0.3.3.tar.gz;
      sha256 = "c4621b64d50be9461d9bd9a71ba0b4af06fbbf818bbd483752d95c1a4e273ede";
    };

    # Require networking
    doCheck = false;

    meta = {
      description = "Python NTP library";
      license = licenses.mit;
    };
  };

  numba = callPackage ../development/python-modules/numba { };

  numexpr = buildPythonPackage rec {
    version = "2.6.2";
    name = "numexpr-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/n/numexpr/${name}.tar.gz";
      sha256 = "6ab8ff5c19e7f452966bf5a3220b845cf3244fe0b96544f7f9acedcc2db5c705";
    };

    propagatedBuildInputs = with self; [ numpy ];

    # Run the test suite.
    # It requires the build path to be in the python search path.
    checkPhase = ''
      ${python}/bin/${python.executable} <<EOF
      import sysconfig
      import sys
      import os
      f = "lib.{platform}-{version[0]}.{version[1]}"
      lib = f.format(platform=sysconfig.get_platform(),
                     version=sys.version_info)
      build = os.path.join(os.getcwd(), 'build', lib)
      sys.path.insert(0, build)
      import numexpr
      r = numexpr.test()
      if not r.wasSuccessful():
          sys.exit(1)
      EOF
    '';

    meta = {
      description = "Fast numerical array expression evaluator for NumPy";
      homepage = "https://github.com/pydata/numexpr";
      license = licenses.mit;
    };
  };

  Nuitka = let
    # scons is needed but using it requires Python 2.7
    # Therefore we create a separate env for it.
    scons = pkgs.python27.withPackages(ps: [ pkgs.scons ]);
  in buildPythonPackage rec {
    version = "0.5.25";
    name = "Nuitka-${version}";

    # Latest version is not yet on PyPi
    src = pkgs.fetchurl {
      url = "https://github.com/kayhayen/Nuitka/archive/${version}.tar.gz";
      sha256 = "11psz0pyj56adv4b3f47hl8jakvp2mc2c85s092a5rsv1la1a0aa";
    };

    buildInputs = with self; stdenv.lib.optionals doCheck [ vmprof pyqt4 ];

    propagatedBuildInputs = [ scons ];

    postPatch = ''
      patchShebangs tests/run-tests
    '' + stdenv.lib.optionalString stdenv.isLinux ''
      substituteInPlace nuitka/plugins/standard/ImplicitImports.py --replace 'locateDLL("uuid")' '"${pkgs.utillinux.out}/lib/libuuid.so"'
    '';

    # We do not want any wrappers here.
    postFixup = '''';

    checkPhase = ''
      tests/run-tests
    '';

    # Problem with a subprocess (parts)
    doCheck = false;

    # Requires CPython
    disabled = isPyPy;

    meta = {
      description = "Python compiler with full language support and CPython compatibility";
      license = licenses.asl20;
      homepage = http://nuitka.net/;
    };
  };

  numpy = callPackage ../development/python-modules/numpy {
    blas = pkgs.openblasCompat;
  };

  numpydoc = buildPythonPackage rec {
    pname = "numpydoc";
    name = "${pname}-${version}";
    version = "0.6.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
      sha256 = "1ec573e91f6d868a9940d90a6599f3e834a2d6c064030fbe078d922ee21dcfa1";
    };

    buildInputs = [ self.nose ];
    propagatedBuildInputs = [ self.sphinx self.matplotlib ];

    meta = {
      description = "Sphinx extension to support docstrings in Numpy format";
      homepage = "https://github.com/numpy/numpydoc";
      license = licenses.free;
    };
  };

  numpy-stl = callPackage ../development/python-modules/numpy-stl { };

  numtraits = callPackage ../development/python-modules/numtraits { };

  nwdiag = callPackage ../development/python-modules/nwdiag { };

  dynd = buildPythonPackage rec {
    version = "0.7.2";
    name = "dynd-${version}";
    disabled = isPyPy;

    src = pkgs.fetchFromGitHub {
      owner = "libdynd";
      repo = "dynd-python";
      rev = "v${version}";
      sha256 = "19igd6ibf9araqhq9bxmzbzdz05vp089zxvddkiik3b5gb7l17nh";
    };

    # setup.py invokes git on build but we're fetching a tarball, so
    # can't retrieve git version. We hardcode:
    preConfigure = ''
      substituteInPlace setup.py --replace "ver = check_output(['git', 'describe', '--dirty'," "ver = '${version}'"
      substituteInPlace setup.py --replace "'--always', '--match', 'v*']).decode('ascii').strip('\n')" ""
    '';

    # Python 3 works but has a broken import test that I couldn't
    # figure out.
    doCheck = !isPy3k;
    buildInputs = with pkgs; [ cmake libdynd.dev self.cython ];
    propagatedBuildInputs = with self; [ numpy pkgs.libdynd ];

    meta = {
      homepage = http://libdynd.org;
      license = licenses.bsd2;
      description = "Python exposure of dynd";
      maintainers = with maintainers; [ teh ];
    };
  };

  livestreamer = buildPythonPackage rec {
    version = "1.12.2";
    name = "livestreamer-${version}";
    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "https://github.com/chrippa/livestreamer/archive/v${version}.tar.gz";
      sha256 = "1fp3d3z2grb1ls97smjkraazpxnvajda2d1g1378s6gzmda2jvjd";
    };

    buildInputs = [ pkgs.makeWrapper ];

    propagatedBuildInputs = with self; [ pkgs.rtmpdump pycrypto requests ]
      ++ optionals isPy26 [ singledispatch futures argparse ]
      ++ optionals isPy27 [ singledispatch futures ]
      ++ optionals isPy33 [ singledispatch ];

    postInstall = ''
      wrapProgram $out/bin/livestreamer --prefix PATH : ${pkgs.rtmpdump}/bin
    '';

    meta = {
      homepage = http://livestreamer.tanuki.se;
      description = ''
        Livestreamer is CLI program that extracts streams from various
        services and pipes them into a video player of choice.
      '';
      license = licenses.bsd2;
      maintainers = with maintainers; [ fuuzetsu ];
    };
  };

  livestreamer-curses = buildPythonPackage rec {
    version = "1.5.2";
    name = "livestreamer-curses-${version}";
    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "https://github.com/gapato/livestreamer-curses/archive/v${version}.tar.gz";
      sha256 = "1v49sym6mrci9dxy0a7cpbp4bv6fg2ijj6rwk4wzg18c2x4qzkhn";
    };

    propagatedBuildInputs = with self; [ livestreamer ];

    meta = {
      homepage = https://github.com/gapato/livestreamer-curses;
      description = "Curses frontend for livestreamer";
      license = licenses.mit;
    };
  };

  oauth = buildPythonPackage (rec {
    name = "oauth-1.0.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/o/oauth/oauth-1.0.1.tar.gz";
      sha256 = "0pdgi35hczsslil4890xqawnbpdazkgf2v1443847h5hy2gq2sg7";
    };

    # No tests included in archive
    doCheck = false;

    meta = {
      homepage = http://code.google.com/p/oauth;
      description = "Library for OAuth version 1.0a";
      license = licenses.mit;
      platforms = platforms.all;
    };
  });

  oauth2 = buildPythonPackage (rec {
    name = "oauth2-${version}";
    version = "1.9.0.post1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/o/oauth2/${name}.tar.gz";
      sha256 = "c006a85e7c60107c7cc6da1b184b5c719f6dd7202098196dfa6e55df669b59bf";
    };

    propagatedBuildInputs = with self; [ httplib2 ];

    buildInputs = with self; [ mock coverage ];

    # ServerNotFoundError: Unable to find the server at oauth-sandbox.sevengoslings.net
    doCheck = false;

    meta = {
      homepage = "https://github.com/simplegeo/python-oauth2";
      description = "Library for OAuth version 1.0";
      license = licenses.mit;
      maintainers = with maintainers; [ garbas ];
      platforms = platforms.linux;
    };
  });

  oauth2client = buildPythonPackage rec {
    name = "oauth2client-1.4.12";

    src = pkgs.fetchurl {
      url = "mirror://pypi/o/oauth2client/${name}.tar.gz";
      sha256 = "0phfk6s8bgpap5xihdk1xv2lakdk1pb3rg6hp2wsg94hxcxnrakl";
    };

    propagatedBuildInputs = with self; [ six httplib2 pyasn1-modules rsa ];
    doCheck = false;

    meta = {
      description = "A client library for OAuth 2.0";
      homepage = https://github.com/google/oauth2client/;
      license = licenses.bsd2;
    };
  };

  oauthlib = buildPythonPackage rec {
    version = "2.0.0";
    name = "oauthlib-${version}";

    src = pkgs.fetchurl {
      url = "https://github.com/idan/oauthlib/archive/v${version}.tar.gz";
      sha256 = "02b645a8rqh4xfs1cmj8sss8wqppiadd1ndq3av1cdjz2frfqcjf";
    };

    buildInputs = with self; [ mock nose unittest2 ];

    propagatedBuildInputs = with self; [ cryptography blinker pyjwt ];

    meta = {
      homepage = https://github.com/idan/oauthlib;
      downloadPage = https://github.com/idan/oauthlib/releases;
      description = "A generic, spec-compliant, thorough implementation of the OAuth request-signing logic";
      maintainers = with maintainers; [ prikhi ];
    };
  };


  obfsproxy = buildPythonPackage ( rec {
    name = "obfsproxy-${version}";
    version = "0.2.13";

    src = pkgs.fetchgit {
      url = meta.repositories.git;
      rev = "refs/tags/${name}";
      sha256 = "04ja1cl8xzqnwrd2gi6nlnxbmjri141bzwa5gybvr44d8h3k2nfa";
    };

    postPatch = ''
      substituteInPlace setup.py --replace "version=versioneer.get_version()" "version='${version}'"
      substituteInPlace setup.py --replace "argparse" ""
    '';

    propagatedBuildInputs = with self;
      [ pyptlib argparse twisted pycrypto pyyaml ];

    # No tests in archive
    doCheck = false;

    meta = {
      description = "A pluggable transport proxy";
      homepage = https://www.torproject.org/projects/obfsproxy;
      repositories.git = https://git.torproject.org/pluggable-transports/obfsproxy.git;
      maintainers = with maintainers; [ phreedom thoughtpolice ];
    };
  });

  objgraph = buildPythonPackage rec {
    name = "objgraph-${version}";
    version = "2.0.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/o/objgraph/${name}.tar.gz";
      sha256 = "841de52715774ec1d0e97d9b4462d6e3e10406155f9b61f54ba7db984c45442a";
    };

    # Tests fail with PyPy.
    disabled = isPyPy;

    propagatedBuildInputs = with self; [pkgs.graphviz];

    meta = {
      description = "Draws Python object reference graphs with graphviz";
      homepage = http://mg.pov.lt/objgraph/;
      license = licenses.mit;
    };
  };

  odo = callPackage ../development/python-modules/odo { };

  offtrac = buildPythonPackage rec {
    name = "offtrac-0.1.0";
    meta.maintainers = with maintainers; [ mornfall ];

    src = pkgs.fetchurl {
      url = "mirror://pypi/o/offtrac/${name}.tar.gz";
      sha256 = "06vd010pa1z7lyfj1na30iqzffr4kzj2k2sba09spik7drlvvl56";
    };
    doCheck = false;
  };

  openpyxl = callPackage ../development/python-modules/openpyxl { };

  ordereddict = buildPythonPackage rec {
    name = "ordereddict-${version}";
    version = "1.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/o/ordereddict/${name}.tar.gz";
      sha256 = "07qvy11nvgxpzarrni3wrww3vpc9yafgi2bch4j2vvvc42nb8d8w";
    };

    meta = {
      description = "A drop-in substitute for Py2.7's new collections.OrderedDict that works in Python 2.4-2.6";
      license = licenses.bsd3;
      maintainers = with maintainers; [ garbas ];
    };
  };

  python-otr = buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "python-otr";
    version = "1.2.0";

    disabled = isPy3k;

    src = pkgs.fetchFromGitHub {
      owner = "AGProjects";
      repo = pname;
      rev = "release-" + version;
      sha256 = "0p3b1n8jlxwd65gbk2k5007fkhdyjwcvr4982s42hncivxvabzzy";
    };

    propagatedBuildInputs = with self; [ zope_interface cryptography application gmpy2 ];

    meta = {
      description = "A pure python implementation of OTR";
      homepage = https://github.com/AGProjects/otr;
      license = licenses.lgpl21Plus;
      platforms = platforms.linux;
      maintainers = with maintainers; [ edwtjo ];
    };
  };

  ply = buildPythonPackage (rec {
    name = "ply-3.8";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/ply/${name}.tar.gz";
      sha256 = "e7d1bdff026beb159c9942f7a17e102c375638d9478a7ecd4cc0c76afd8de0b8";
    };

    checkPhase = ''
      ${python.interpreter} test/testlex.py
      ${python.interpreter} test/testyacc.py
    '';

    # Test suite appears broken
    doCheck = false;

    meta = {
      homepage = http://www.dabeaz.com/ply/;

      description = "PLY (Python Lex-Yacc), an implementation of the lex and yacc parsing tools for Python";

      longDescription = ''
        PLY is an implementation of lex and yacc parsing tools for Python.
        In a nutshell, PLY is nothing more than a straightforward lex/yacc
        implementation.  Here is a list of its essential features: It's
        implemented entirely in Python; It uses LR-parsing which is
        reasonably efficient and well suited for larger grammars; PLY
        provides most of the standard lex/yacc features including support for
        empty productions, precedence rules, error recovery, and support for
        ambiguous grammars; PLY is straightforward to use and provides very
        extensive error checking; PLY doesn't try to do anything more or less
        than provide the basic lex/yacc functionality.  In other words, it's
        not a large parsing framework or a component of some larger system.
      '';

      license = licenses.bsd3;

      maintainers = [ ];
    };
  });

  plyvel = buildPythonPackage (rec {
    name = "plyvel-0.9";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/plyvel/${name}.tar.gz";
      sha256 = "1scq75qyks9vmjd19bx57f2y60mkdr44ajvb12p3cjg439l96zaq";
    };

    buildInputs = with self; [ pkgs.leveldb ]
                            ++ optional isPy3k pytest;

    # no tests for python2
    doCheck = isPy3k;

    meta = {
      description = "Fast and feature-rich Python interface to LevelDB";
      homepage = https://github.com/wbolster/plyvel;
      license = licenses.bsd3;
    };
  });

  osc = buildPythonPackage {
    name = "osc-0.159.0-4-g2d44589";
    disabled = isPy3k;
    src = pkgs.fetchFromGitHub {
      owner = "openSUSE";
      repo = "osc";
      rev = "2d44589886845af7da911aaec9403344e396cd91";
      sha256 = "0s8p7gkp64w6r5rnxpbvl2dgb5p85kq2skcqm6qxn5ddadhw2sfz";
    };
    buildInputs = with pkgs; [ bashInteractive ]; # needed for bash-completion helper
    propagatedBuildInputs = with self; [ urlgrabber m2crypto pyyaml ];
    postInstall = ''
      ln -s $out/bin/osc-wrapper.py $out/bin/osc
      install -D -m444 osc.fish $out/etc/fish/completions/osc.fish
      install -D -m555 dist/osc.complete $out/share/bash-completion/helpers/osc-helper
      mkdir -p $out/share/bash-completion/completions
      cat >>$out/share/bash-completion/completions/osc <<EOF
      test -z "\$BASH_VERSION" && return
      complete -o default _nullcommand >/dev/null 2>&1 || return
      complete -r _nullcommand >/dev/null 2>&1         || return
      complete -o default -C $out/share/bash-completion/helpers/osc-helper osc
      EOF
    '';
    meta = {
      description = "opensuse-commander with svn like handling";
      maintainers = [ maintainers.peti ];
      license = licenses.gpl2;
    };
  };

  oslosphinx = buildPythonPackage rec {
    name = "oslosphinx-3.3.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/o/oslosphinx/${name}.tar.gz";
      sha256 = "1rjiiahw2y7pg5rl15fvhmfyh26vm433000nwp7c94khx7w85w75";
    };

    doCheck = false;

    propagatedBuildInputs = with self; [
      pbr requests sphinx_1_2
    ];
  };

  tempest-lib = buildPythonPackage rec {
    name = "tempest-lib-${version}";
    version = "0.10.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/tempest-lib/${name}.tar.gz";
      sha256 = "0x842a67k9f7yk3zr6755s4qldkfngljqy5whd4jb553y4hn5lyj";
    };

    patchPhase = ''
      substituteInPlace tempest_lib/tests/cli/test_execute.py --replace "/bin/ls" "${pkgs.coreutils}/bin/ls"
      sed -i 's@python@${python.interpreter}@' .testr.conf
    '';

    buildInputs = with self; [ testtools testrepository subunit oslotest ];
    propagatedBuildInputs = with self; [
      pbr six paramiko httplib2 jsonschema iso8601 fixtures Babel oslo-log
      os-testr ];

  };

  os-testr = callPackage ../development/python-modules/os-testr { };

  bandit = buildPythonPackage rec {
    name = "bandit-${version}";
    version = "0.16.1";
    disabled = isPy33;
    doCheck = !isPyPy; # a test fails

    src = pkgs.fetchurl {
      url = "mirror://pypi/b/bandit/${name}.tar.gz";
      sha256 = "0qd9kxknac5n5xfl5zjnlmk6jr94krkcx29zgyna8p9lyb828hsk";
    };

    propagatedBuildInputs = with self; [ pbr six pyyaml appdirs stevedore ];
    buildInputs = with self; [ beautifulsoup4 oslosphinx testtools testscenarios
                               testrepository fixtures mock ];
    patchPhase = ''
      sed -i 's@python@${python.interpreter}@' .testr.conf
    '';
  };

  oslo-serialization = buildPythonPackage rec {
    pname = "oslo.serialization";
    version = "2.20.0";
    name = "${pname}-${version}";

    src = fetchPypi {
      inherit pname version;
      sha256 = "00j8hn8f0shk4anzb6zwn8w1sfxcil9a3jgxljwalq6ma2rzp9pw";
    };

    patchPhase = ''
      sed -i 's@python@${python.interpreter}@' .testr.conf
    '';

    propagatedBuildInputs = with self; [ pbr Babel six iso8601 pytz oslo-utils msgpack netaddr ];
    buildInputs = with self; [ oslotest mock coverage simplejson oslo-i18n ];
  };

  rfc3986 = callPackage ../development/python-modules/rfc3986 { };

  pycadf = buildPythonPackage rec {
    name = "pycadf-${version}";
    version = "1.1.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pycadf/pycadf-1.1.0.tar.gz";
      sha256 = "0lv9nhbvj1pa8qgn3qvyk9k4q8f7w541074n1rhdjnjkinh4n4dg";
    };

    propagatedBuildInputs = with self; [
      oslo-i18n argparse six wrapt oslo-utils pbr oslo-config Babel netaddr
      monotonic iso8601 pytz stevedore oslo-serialization msgpack
      debtcollector netifaces
    ];
    buildInputs = with self; [
      oslosphinx testtools testrepository oslotest
    ];

    patchPhase = ''
      sed -i 's@python@${python.interpreter}@' .testr.conf
    '';

    meta = with stdenv.lib; {
      homepage = https://launchpad.net/pycadf;
    };
  };


  oslo-utils = buildPythonPackage rec {
    pname = "oslo.utils";
    version = "3.29.0";
    name = "${pname}-${version}";

    src = fetchPypi {
      inherit pname version;
      sha256 = "0l90ijw96czjd6z8bw88983rsnq5753iw86rhk1wi064w4rs19ig";
    };

    propagatedBuildInputs = with self; [ pbr Babel six iso8601 pytz netaddr netifaces
                                         monotonic oslo-i18n wrapt debtcollector ];
    buildInputs = with self; [ oslotest mock coverage oslosphinx ];
    patchPhase = ''
      sed -i 's@python@${python.interpreter}@' .testr.conf
    '';
  };

  oslo-middleware = buildPythonPackage rec {
    name = "oslo.middleware-${version}";
    version = "2.9.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/o/oslo.middleware/${name}.tar.gz";
      sha256 = "14acinchdpmc1in39mz9kh1h2rd1ygwg3zdhbwzrlhy8wbzzi4w9";
    };

    propagatedBuildInputs = with self; [
      oslo-i18n six oslo-utils pbr oslo-config Babel oslo-context stevedore
      jinja2 webob debtcollector
    ];
    buildInputs = with self; [
      coverage testtools oslosphinx oslotest
    ];
    patchPhase = ''
      sed -i 's@python@${python.interpreter}@' .testr.conf
      sed -i '/ordereddict/d' requirements.txt
    '';

    meta = with stdenv.lib; {
      homepage = "http://wiki.openstack.org/wiki/Oslo#oslo.middleware";
    };
  };

  oslo-versionedobjects = buildPythonPackage rec {
     name = "oslo.versionedobjects-${version}";
     version = "0.11.0";

     src = pkgs.fetchurl {
       url = "mirror://pypi/o/oslo.versionedobjects/${name}.tar.gz";
       sha256 = "1ddcb2zf7a3544ay4sxw200a4mz7p0n1f7826h3vibfdqjlc80y7";
     };

     propagatedBuildInputs = with self; [
       six Babel oslo-concurrency oslo-config oslo-context oslo-messaging
       oslo-serialization oslo-utils iso8601 oslo-log oslo-i18n webob
     ];
     buildInputs = with self; [
       oslo-middleware cachetools_1 oslo-service futurist anyjson oslosphinx
       testtools oslotest
     ];

     meta = with stdenv.lib; {
       homepage = "http://launchpad.net/oslo";
     };
   };

   cachetools_1 = callPackage ../development/python-modules/cachetools/1.nix {};
   cachetools = callPackage ../development/python-modules/cachetools {};

   futurist = buildPythonPackage rec {
     name = "futurist-${version}";
     version = "0.7.0";

     src = pkgs.fetchurl {
       url = "mirror://pypi/f/futurist/${name}.tar.gz";
       sha256 = "0wf0k9xf5xzmi79418xq8zxwr7w7a4g4alv3dds9afb2l8bh9crg";
     };

     patchPhase = ''
       sed -i "s/test_gather_stats/noop/" futurist/tests/test_executors.py
     '';

     propagatedBuildInputs = with self; [
       contextlib2 pbr six monotonic futures eventlet
     ];
     buildInputs = with self; [
       testtools testscenarios testrepository oslotest subunit
     ];

     # breaks in sandboxing
     doCheck = false;
   };

  oslo-messaging = buildPythonPackage rec {
    name = "oslo.messaging-${version}";
    version = "2.7.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/o/oslo.messaging/${name}.tar.gz";
      sha256 = "1af7l4ri3xfjcnjp2yhngz34h3ls00yyj1x8i64dxb86ryy43kd1";
    };

    propagatedBuildInputs = with self; [
      pbr oslo-config oslo-context oslo-log oslo-utils oslo-serialization
      oslo-i18n stevedore six eventlet greenlet webob pyyaml kombu_3 trollius
      aioeventlet cachetools_1 oslo-middleware futurist redis oslo-service
      eventlet pyzmq
    ];

    buildInputs = with self; [
      oslotest mock mox3 subunit testtools testscenarios testrepository
      fixtures oslosphinx
    ];

    preBuild = ''
      # transient failure https://bugs.launchpad.net/oslo.messaging/+bug/1510481
      sed -i 's/test_send_receive/noop/' oslo_messaging/tests/drivers/test_impl_rabbit.py
    '';
  };

  os-brick = buildPythonPackage rec {
   name = "os-brick-${version}";
   version = "0.5.0";

   src = pkgs.fetchurl {
     url = "mirror://pypi/o/os-brick/${name}.tar.gz";
     sha256 = "1q05yk5hada470rwsv3hfjn7pdp9n7pprmnslm723l7cfhf7cgm6";
   };

   propagatedBuildInputs = with self; [
     six retrying oslo-utils oslo-service oslo-i18n oslo-serialization oslo-log
     oslo-concurrency eventlet Babel pbr
   ];
   buildInputs = with self; [
     testtools testscenarios testrepository requests
   ];

   checkPhase = ''
     ${python.interpreter} -m subunit.run discover -t ./ .
   '';

   meta = with stdenv.lib; {
     homepage = "http://www.openstack.org/";
   };
  };

  oslo-reports = buildPythonPackage rec {
    name = "oslo.reports-${version}";
    version = "0.6.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/o/oslo.reports/${name}.tar.gz";
      sha256 = "0j27mbsa5y1fn9lxn98xs7p9vipcig47srm5sgbgma0ilv125b65";
    };

    propagatedBuildInputs = with self; [
      oslo-i18n oslo-utils oslo-serialization six psutil_1 Babel jinja2 pbr psutil_1
    ];
    buildInputs = with self; [
      coverage greenlet eventlet oslosphinx oslotest
    ];

    patchPhase = ''
      sed -i 's@python@${python.interpreter}@' .testr.conf
    '';
  };

  cinderclient = buildPythonPackage rec {
    name = "cinderclient-${version}";
    version = "1.4.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/python-cinderclient/python-cinderclient-${version}.tar.gz";
      sha256 = "1vfcjljfad3034bfhfcrfhphym1ik6qk42nrxzl0gqb9408n6k3l";
    };

    propagatedBuildInputs = with self; [
      six Babel simplejson requests keystoneclient prettytable argparse pbr
    ];
    buildInputs = with self; [
      testrepository requests-mock
    ];
    patchPhase = ''
      sed -i 's@python@${python.interpreter}@' .testr.conf
    '';

    meta = with stdenv.lib; {
      description = "Python bindings to the OpenStack Cinder API";
      homepage = "http://www.openstack.org/";
      broken = true;
    };
  };

  neutronclient = buildPythonPackage rec {
    name = "neutronclient-${version}";
    version = "3.1.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/python-neutronclient/python-neutronclient-${version}.tar.gz";
      sha256 = "0g96x5b8lz407in70j6v7jbj613y6sd61b21j1y03x06b2rk5i02";
    };

    propagatedBuildInputs = with self; [
      pbr six simplejson keystoneclient requests oslo-utils oslo-serialization
      oslo-i18n netaddr iso8601 cliff argparse
    ];
    buildInputs = with self; [
      tempest-lib mox3 oslotest requests-mock
    ];

    patchPhase = ''
      sed -i 's@python@${python.interpreter}@' .testr.conf
      # test fails on py3k
      ${if isPy3k then "substituteInPlace neutronclient/tests/unit/test_cli20_port.py --replace 'test_list_ports_with_fixed_ips_in_csv' 'noop'" else ""}
    '';

    meta = with stdenv.lib; {
      description = "Python bindings to the Neutron API";
      homepage = "http://www.openstack.org/";
    };
  };

  cliff = buildPythonPackage rec {
    name = "cliff-${version}";
    version = "1.15.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/c/cliff/${name}.tar.gz";
      sha256 = "1rrbq1nvc84x417hbfm9sc1scia16nilr8nm8ycm8iq5jkh6zfpm";
    };

    propagatedBuildInputs = with self; [
      argparse pyyaml pbr six cmd2 stevedore unicodecsv prettytable pyparsing
    ];
    buildInputs = with self; [
      httplib2 oslosphinx coverage mock nose tempest-lib
    ];

    meta = with stdenv.lib; {
      homepage = "https://launchpad.net/python-cliff";
      # requires an update, incompatible with current dependencies (pbr)
      broken = true;
    };
  };

  cmd2 = buildPythonPackage rec {
    name = "cmd2-${version}";
    version = "0.7.7";

    src = pkgs.fetchurl {
      url = "mirror://pypi/c/cmd2/${name}.tar.gz";
      sha256 = "0widbir8ay1fd4zm8l0rjq78j1cvbammbz8xs32crbanqsgzpqml";
    };

    # No tests included
    doCheck = false;

    propagatedBuildInputs = with self; [
      pyperclip
      six
      pyparsing
    ];

    meta = with stdenv.lib; {
      description = "Enhancements for standard library's cmd module";
      homepage = "http://packages.python.org/cmd2/";
    };
  };


  oslo-db = buildPythonPackage rec {
    name = "oslo.db-${version}";
    version = "3.0.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/o/oslo.db/${name}.tar.gz";
      sha256 = "0jjimsfl53wigzf92dhns813n65qcwilcqlj32m86rxrcz0pjgph";
    };

    propagatedBuildInputs = with self; [
      six stevedore sqlalchemy_migrate sqlalchemy oslo-utils oslo-context
      oslo-config oslo-i18n iso8601 Babel alembic pbr psycopg2
    ];
    buildInputs = with self; [
      tempest-lib testresources mock oslotest
    ];
  };

  oslo-rootwrap = buildPythonPackage rec {
    name = "oslo.rootwrap-${version}";
    version = "2.4.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/o/oslo.rootwrap/${name}.tar.gz";
      sha256 = "1711rlmykizw675ihbaqmk3ph6ah0njbygxr9lrdnacy6yrlmbd5";
    };

    # https://bugs.launchpad.net/oslo.rootwrap/+bug/1519839
    patchPhase = ''
     substituteInPlace oslo_rootwrap/filters.py \
       --replace "/bin/cat" "${pkgs.coreutils}/bin/cat" \
       --replace "/bin/kill" "${pkgs.coreutils}/bin/kill"
    '';

    buildInputs = with self; [ eventlet mock oslotest ];
    propagatedBuildInputs = with self; [
      six pbr
    ];

    # way too many assumptions
    doCheck = false;
  };

  glanceclient = buildPythonPackage rec {
   name = "glanceclient-${version}";
   version = "1.1.0";

   src = pkgs.fetchurl {
     url = "mirror://pypi/p/python-glanceclient/python-glanceclient-${version}.tar.gz";
     sha256 = "0ppjafsmf29ps23jsw6g2xm66pdi5jdzpywglqqm28b8fj931zsr";
   };

   propagatedBuildInputs = with self; [
     oslo-i18n oslo-utils six requests keystoneclient prettytable Babel pbr
     argparse warlock
   ];
   buildInputs = with self; [
     tempest-lib requests-mock
   ];

   checkPhase = ''
     ${python.interpreter} -m subunit.run discover -t ./ .
   '';

   meta = with stdenv.lib; {
     description = "Python bindings to the OpenStack Images API";
     homepage = "http://www.openstack.org/";

     # requires an update, incompatible with current dependencies (pbr)
     broken = true;
   };
 };

 warlock = buildPythonPackage rec {
   name = "warlock-${version}";
   version = "1.2.0";

   src = pkgs.fetchurl {
     url = "mirror://pypi/w/warlock/${name}.tar.gz";
     sha256 = "0npgi4ks0nww2d6ci791iayab0j6kz6dx3jr7bhpgkql3s4if3bw";
   };

   propagatedBuildInputs = with self; [
     six jsonpatch jsonschema jsonpointer
   ];
   buildInputs = with self; [

   ];

   meta = with stdenv.lib; {
     homepage = "http://github.com/bcwaldon/warlock";
   };
 };


  oslo-service = buildPythonPackage rec {
    pname = "oslo.service";
    version = "1.26.0";

    name = "${pname}-${version}";

    src = fetchPypi {
      inherit pname version;
      sha256 = "083q7z6nrska5fq12vnd70blphxscd7ivca2d78jk84d99h0m5n5";
    };

    propagatedBuildInputs = with self; [
      repoze_lru PasteDeploy Babel oslo-context debtcollector
      oslo-concurrency wrapt eventlet six oslo-serialization greenlet paste
      oslo-config monotonic iso8601 oslo-log pytz routes msgpack
      oslo-i18n argparse oslo-utils pbr enum34 netaddr stevedore netifaces
      pyinotify webob retrying pyinotify oslo-log ];
    buildInputs = with self; [
      oslosphinx oslotest pkgs.procps mock mox3 fixtures subunit testrepository
      testtools testscenarios
    ];

    ## cannot import eventlet due to:
    # _proto_tcp = socket.getprotobyname('tcp')
    doCheck = false;

    meta = with stdenv.lib; {
      homepage = "http://wiki.openstack.org/wiki/Oslo#oslo.service";
    };
  };

  oslo-cache = buildPythonPackage rec {
    name = "oslo.cache-${version}";
    version = "0.9.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/o/oslo.cache/${name}.tar.gz";
      sha256 = "0dzvm5xkfj1alf469d7v3syig9f91kjh4p55k57ykgaww3y4cdjp";
    };

    propagatedBuildInputs = with self; [
      Babel dogpile_cache six oslo-config oslo-i18n oslo-log oslo-utils
    ];
    buildInputs = with self; [
      oslosphinx oslotest memcached pymongo
    ];
    patchPhase = ''
      sed -i 's@python@${python.interpreter}@' .testr.conf
    '';
  };

  pecan = callPackage ../development/python-modules/pecan { };

  kaitaistruct = callPackage ../development/python-modules/kaitaistruct { };

  Kajiki = buildPythonPackage rec {
    name = "Kajiki-${version}";
    version = "0.5.5";

    src = pkgs.fetchurl {
      url = "mirror://pypi/K/Kajiki/${name}.tar.gz";
      sha256 = "effcae388e25c3358eb0bbd733448509d11a1ec500e46c69241fc673021f0517";
    };

    propagatedBuildInputs = with self; [
      Babel pytz nine
    ];
    meta = with stdenv.lib; {
      description = "Kajiki provides fast well-formed XML templates";
      homepage = "https://github.com/nandoflorestan/kajiki";
    };
  };

  ryu = buildPythonPackage rec {
    name = "ryu-${version}";
    version = "3.26";

    propagatedBuildInputs = with self; [
      pbr paramiko lxml
    ];
    buildInputs = with self; [
      webtest routes oslo-config msgpack eventlet FormEncode
    ];

    preCheck = ''
      # we don't really need linters
      sed -i '/pylint/d' tools/test-requires
      sed -i '/pep8/d' tools/test-requires
    '';

    src = pkgs.fetchurl {
      url = "mirror://pypi/r/ryu/${name}.tar.gz";
      sha256 = "1fhriqi7qnvvx9mbvlfm94i5drh920lg204zy3v0qjz43sinkih6";
    };

    meta.broken = true;
  };

  WSME = buildPythonPackage rec {
    name = "WSME-${version}";
    version = "0.8.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/W/WSME/${name}.tar.gz";
      sha256 = "1nw827iz5g9jlfnfbdi8kva565v0kdjzba2lccziimj09r71w900";
    };

    checkPhase = ''
      # remove turbogears tests as we don't have it packaged
      rm tests/test_tg*
      # remove flask since we don't have flask-restful
      rm tests/test_flask*
      # https://bugs.launchpad.net/wsme/+bug/1510823
      ${if isPy3k then "rm tests/test_cornice.py" else ""}

      nosetests tests/
    '';

    propagatedBuildInputs = with self; [
      pbr six simplegeneric netaddr pytz webob
    ];
    buildInputs = with self; [
      cornice nose webtest pecan transaction cherrypy sphinx
    ];
  };

  taskflow = buildPythonPackage rec {
    name = "taskflow-${version}";
    version = "1.23.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/taskflow/${name}.tar.gz";
      sha256 = "15np1rc6g9vksgdj0y930ysx5wbmhvc082g264j5zbj6c479g8qa";
    };

    propagatedBuildInputs = with self; [
      pbr futures enum34 debtcollector cachetools_1 oslo-serialization oslo-utils
      jsonschema monotonic stevedore networkx futurist pbr automaton fasteners
    ];
    buildInputs = with self; [
      oslosphinx pymysql psycopg2 alembic redis eventlet kazoo zake kombu
      testscenarios testtools mock oslotest
    ];

    preBuild = ''
      # too many transient failures
      rm taskflow/tests/unit/test_engines.py
    '';

    checkPhase = ''
      sed -i '/doc8/d' test-requirements.txt
      ${python.interpreter} setup.py test
    '';
  };

  glance_store = buildPythonPackage rec {
    name = "glance_store-${version}";
    version = "0.9.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/g/glance_store/${name}.tar.gz";
      sha256 = "16az3lq9szl0ixna9rd82dmn4sfxqyivhn4z3z79vk8qdfip1sr9";
    };

    # remove on next version bump
    patches = [
       ../development/python-modules/fix_swiftclient_mocking.patch
    ];

    propagatedBuildInputs = with self; [
      oslo-config oslo-i18n oslo-serialization oslo-utils oslo-concurrency stevedore
      enum34 eventlet six jsonschema swiftclient httplib2 pymongo
    ];
    buildInputs = with self; [
      mock fixtures subunit requests-mock testrepository testscenarios testtools
      oslotest oslosphinx boto oslo-vmware
    ];

    meta = with stdenv.lib; {
      description = "Glance Store Library";
      homepage = "http://www.openstack.org/";
    };
  };

  swiftclient = buildPythonPackage rec {
    name = "swiftclient-${version}";
    version = "2.6.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/python-swiftclient/python-swiftclient-${version}.tar.gz";
      sha256 = "1j33l4z9vqh0scfncl4fxg01zr1hgqxhhai6gvcih1gccqm4nd7p";
    };

    propagatedBuildInputs = with self; [
      pbr requests futures six
    ];
    buildInputs = with self; [
      testtools testrepository mock
    ];

    patchPhase = ''
      sed -i 's@python@${python.interpreter}@' .testr.conf
    '';

    meta = with stdenv.lib; {
      description = "Python bindings to the OpenStack Object Storage API";
      homepage = "http://www.openstack.org/";
    };
  };


  castellan = buildPythonPackage rec {
    name = "castellan-${version}";
    version = "0.2.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/c/castellan/${name}.tar.gz";
      sha256 = "1im9b4qzq4yhn17jjc8927b3hn06h404vsx8chddw2jfp0v4ryfj";
    };

    propagatedBuildInputs = with self; [
      pbr Babel cryptography oslo-config oslo-context oslo-log oslo-policy
      oslo-serialization oslo-utils
    ];
    buildInputs = with self; [
      subunit barbicanclient oslosphinx oslotest testrepository testtools
      testscenarios
    ];

    preCheck = ''
      # uses /etc/castellan/castellan-functional.conf
      rm castellan/tests/functional/key_manager/test_barbican_key_manager.py
    '';

    meta = with stdenv.lib; {
      homepage = "https://github.com/yahoo/Zake";
    };
  };

  zake = buildPythonPackage rec {
    name = "zake-${version}";
    version = "0.2.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/z/zake/${name}.tar.gz";
      sha256 = "1rp4xxy7qp0s0wnq3ig4ji8xsl31g901qkdp339ndxn466cqal2s";
    };

    propagatedBuildInputs = with self; [ kazoo six ];
    buildInputs = with self; [ testtools ];
    checkPhase = ''
      ${python.interpreter} -m unittest discover zake/tests
    '';

    meta = with stdenv.lib; {
      homepage = "https://github.com/yahoo/Zake";
    };
  };

  automaton = buildPythonPackage rec {
    name = "automaton-${version}";
    version = "0.8.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/a/automaton/${name}.tar.gz";
      sha256 = "040rw7w92mp34a15vzvbfvhv1cg8zf81s9jbdd9rmwxr0gmgp2ya";
    };

    propagatedBuildInputs = with self; [
      wrapt pbr Babel six pytz prettytable debtcollector
    ];
    buildInputs = with self; [
      testtools testscenarios testrepository
    ];
    patchPhase = ''
      sed -i 's@python@${python.interpreter}@' .testr.conf
    '';
  };

  networking-hyperv = buildPythonPackage rec {
    name = "networking-hyperv-${version}";
    version = "2015.1.0";
    disabled = isPy3k;  # failing tests

    src = pkgs.fetchurl {
      url = "mirror://pypi/n/networking-hyperv/${name}.tar.gz";
      sha256 = "04wfkl8rffxp6gp7qvhhc8y80cy0akmh3z7k7y2sj6savg9q7jdj";
    };

    propagatedBuildInputs = with self; [
      pbr Babel oslo-config oslo-i18n oslo-serialization oslo-utils oslo-log
    ];
    buildInputs = with self; [
      testtools testscenarios testrepository oslotest oslosphinx subunit eventlet
      fixtures mock
    ];

    patchPhase = ''
      sed -i 's@python@${python.interpreter}@' .testr.conf
      # it has pinned pbr<1.0
      sed -i '/pbr/d' requirements.txt
      # https://github.com/openstack/networking-hyperv/commit/56d66fc012846620a60cb8f18df5a1c889fe0e26
      sed -i 's/from oslo import i18n/import oslo_i18n as i18n/' hyperv/common/i18n.py
    '';
  };

  kazoo = buildPythonPackage rec {
    name = "kazoo-${version}";
    version = "2.2.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/k/kazoo/${name}.tar.gz";
      sha256 = "10pb864if9qi2pq9lfb9m8f7z7ss6rml80gf1d9h64lap5crjnjj";
    };

    propagatedBuildInputs = with self; [
      six
    ];
    buildInputs = with self; [
      eventlet gevent nose mock coverage pkgs.openjdk8
    ];

    # not really needed
    preBuild = ''
      sed -i '/flake8/d' setup.py
    '';

    preCheck = ''
      sed -i 's/test_unicode_auth/noop/' kazoo/tests/test_client.py
    '';

    # tests take a long time to run and leave threads hanging
    doCheck = false;
    #ZOOKEEPER_PATH = "${pkgs.zookeeper}";

    meta = with stdenv.lib; {
      homepage = "https://kazoo.readthedocs.org";
    };
  };

  osprofiler = buildPythonPackage rec {
    name = "osprofiler-${version}";
    version = "0.3.0";
    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "mirror://pypi/o/osprofiler/${name}.tar.gz";
      sha256 = "01rjym49nn4ry1pr2n8fyal1hf17jqhp2yihg8gr15nfjc5iszkx";
    };

    propagatedBuildInputs = with self; [
      pbr six webob
    ];
    buildInputs = with self; [
      oslosphinx coverage mock subunit testrepository testtools
    ];

    patchPhase = ''
      sed -i 's@python@${python.interpreter}@' .testr.conf
      substituteInPlace requirements.txt --replace "argparse" ""
    '';
  };

  FormEncode = callPackage ../development/python-modules/FormEncode { };

  pycountry = buildPythonPackage rec {
    name = "pycountry-${version}";
    version = "1.17";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pycountry/${name}.tar.gz";
      sha256 = "1qvhq0c9xsh6d4apcvjphfzl6xnwhnk4jvhr8x2fdfnmb034lc26";
    };
  };

  nine = buildPythonPackage rec {
    name = "nine-${version}";
    version = "0.3.4";

    src = pkgs.fetchurl {
      url = "mirror://pypi/n/nine/${name}.tar.gz";
      sha256 = "1zrsbm0hajfvklkhgysp81hy632a3bdakp31m0lcpd9xbp5265zy";
    };

    meta = with stdenv.lib; {
      description = "Let's write Python 3 right now!";
      homepage = "https://github.com/nandoflorestan/nine";
    };
  };


  logutils = buildPythonPackage rec {
    name = "logutils-${version}";
    version = "0.3.3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/l/logutils/${name}.tar.gz";
      sha256 = "173w55fg3hp5dhx7xvssmgqkcv5fjlaik11w5dah2fxygkjvhhj0";
    };
  };

  oslo-policy = buildPythonPackage rec {
    name = "oslo.policy-${version}";
    version = "0.12.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/o/oslo.policy/${name}.tar.gz";
      sha256 = "06apaj6fwg7f2g5psmxzr5a9apj2l4k2y8kl1hqzyssykblij8ss";
    };

    propagatedBuildInputs = with self; [
      requests oslo-config oslo-i18n oslo-serialization oslo-utils six
    ];
    buildInputs = with self; [
      oslosphinx httpretty oslotest
    ];
  };

  ldappool = buildPythonPackage rec {
    name = "ldappool-${version}";
    version = "1.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/l/ldappool/${name}.tar.gz";
      sha256 = "1akmzf51cjfvmd0nvvm562z1w9vq45zsx6fa72kraqgsgxhnrhqz";
    };

    # Judging from SyntaxError
    disabled = isPy3k;

    meta = with stdenv.lib; {
      homepage = "https://github.com/mozilla-services/ldappool";
    };
  };


  lz4 = buildPythonPackage rec {
    name = "lz4-0.8.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/b5/f0/e1de2bb7feb54011f3c4dcf35b7cca3536e19526764db051b50ea26b58e7/lz4-0.8.2.tar.gz";
      sha256 = "1irad4sq4hdr30fr53smvv3zzk4rddcf9b4jx19w8s9xsxhr1x3b";
    };

    buildInputs= with self; [ nose ];

    meta = with stdenv.lib; {
      description = "Compression library";
      homepage = https://github.com/python-lz4/python-lz4;
      license = licenses.bsd3;
    };
  };


  oslo-concurrency = buildPythonPackage rec {
    pname = "oslo.concurrency";
    version = "3.22.0";
    name = "${pname}-${version}";

    src = fetchPypi {
      inherit pname version;
      sha256 = "0nh1ycc2s6w05g5w63bsmmda0gw7qsrwlax3as8a0piai99z4m51";
    };

   propagatedBuildInputs = with self; [
     oslo-i18n argparse six wrapt oslo-utils pbr enum34 Babel netaddr monotonic
     iso8601 oslo-config pytz netifaces stevedore debtcollector retrying fasteners
     eventlet
   ];
   buildInputs = with self; [
     oslosphinx fixtures coverage oslotest
   ] ++ (optional (!isPy3k) futures);

   # too much magic in tests
   doCheck = false;

   meta = with stdenv.lib; {
     homepage = http://launchpad.net/oslo;
   };
 };

 retrying = buildPythonPackage rec {
    name = "retrying-${version}";
    version = "1.3.3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/r/retrying/retrying-1.3.3.tar.gz";
      sha256 = "0fwp86xv0rvkncjdvy2mwcvbglw4w9k0fva25i7zx8kd19b3kh08";
    };

    propagatedBuildInputs = with self; [ six ];

    # doesn't ship tests in tarball
    doCheck = false;

    meta = with stdenv.lib; {
      homepage = https://github.com/rholder/retrying;
    };
  };

  fasteners = buildPythonPackage rec {
    name = "fasteners-${version}";
    version = "0.14.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/f/fasteners/${name}.tar.gz";
      sha256 = "063y20kx01ihbz2mziapmjxi2cd0dq48jzg587xdsdp07xvpcz22";
    };

    propagatedBuildInputs = with self; [ six monotonic testtools ];

    checkPhase = ''
      ${python.interpreter} -m unittest discover
    '';
    # Tests are written for Python 3.x only (concurrent.futures)
    doCheck = isPy3k;


    meta = with stdenv.lib; {
      description = "Fasteners";
      homepage = https://github.com/harlowja/fasteners;
    };
  };

  aioeventlet = buildPythonPackage rec {
    name = "aioeventlet-${version}";
    version = "0.4";

    src = pkgs.fetchurl {
      url = "mirror://pypi/a/aioeventlet/aioeventlet-0.4.tar.gz";
      sha256 = "19krvycaiximchhv1hcfhz81249m3w3jrbp2h4apn1yf4yrc4y7y";
    };

    propagatedBuildInputs = with self; [ eventlet trollius asyncio ];
    buildInputs = with self; [ mock ];

    # 2 tests error out
    doCheck = false;
    checkPhase = ''
      ${python.interpreter} runtests.py
    '';

    meta = with stdenv.lib; {
      description = "aioeventlet implements the asyncio API (PEP 3156) on top of eventlet. It makes";
      homepage = http://aioeventlet.readthedocs.org/;
    };
  };

  olefile = callPackage ../development/python-modules/olefile { };

  oslo-log = buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "oslo.log";
    version = "3.31.0";

    src = fetchPypi {
      inherit pname version;
      sha256 = "1w08cl98n8592pvb2gw01mqlwi8nnnpg1zy10mvj6xdpvfk2yqzz";
    };

    propagatedBuildInputs = with self; [
      pbr Babel six iso8601 debtcollector dateutil
      oslo-utils oslo-i18n oslo-config oslo-serialization oslo-context
    ] ++ stdenv.lib.optional stdenv.isLinux pyinotify;
    buildInputs = with self; [ oslotest oslosphinx ];
    patchPhase = ''
      sed -i 's@python@${python.interpreter}@' .testr.conf
    '';
  };

  oslo-context = buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "oslo.context";
    version = "2.18.1";

    src = fetchPypi {
      inherit pname version;
      sha256 = "1sc7qrwffsm15m91c17k0xiglv6bxh9sbksvxvrrgja82m57mgh6";
    };

    propagatedBuildInputs = with self; [ pbr Babel ];
    buildInputs = with self; [ oslotest coverage oslosphinx ];
    patchPhase = ''
      sed -i 's@python@${python.interpreter}@' .testr.conf
    '';
  };

  oslo-i18n = buildPythonPackage rec {
    name = "oslo.i18n-${version}";
    version = "3.18.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/o/oslo.i18n/${name}.tar.gz";
      sha256 = "19w6wil588fgppc7d42fqkrjs0y81ap62svzbij8hlb3w2d4a91n";
    };

    propagatedBuildInputs = with self; [ pbr Babel six ];
    buildInputs = with self; [ mock coverage oslotest ];
    patchPhase = ''
      sed -i 's@python@${python.interpreter}@' .testr.conf
    '';
  };

  oslo-config = callPackage ../development/python-modules/oslo-config { };

  oslotest = buildPythonPackage rec {
    name = "oslotest-${version}";
    version = "2.18.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/o/oslotest/${name}.tar.gz";
      sha256 = "0a0zhpb4yp7g6d290jk7a4pfci4ciwhsrqzhbwbl2szi50gp7km1";
    };

    patchPhase = ''
      sed -i 's@python@${python.interpreter}@' .testr.conf
    '';

    propagatedBuildInputs = with self; [ pbr fixtures subunit six testrepository
      os-client-config debtcollector testscenarios testtools mock mox3 os-client-config ];
  };

  os-client-config = buildPythonPackage rec {
    name = "os-client-config-${version}";
    version = "1.28.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/o/os-client-config/${name}.tar.gz";
      sha256 = "1f7q384b9drp3fqcg0w8aihv9k4idaay8vr3an187zjpgbx9rgp5";
    };

    # requires oslotest but is a dependency of that package ...
    doCheck = false;

    buildInputs = with self; [ pbr testtools testscenarios testrepository fixtures jsonschema ];
    propagatedBuildInputs = with self; [ appdirs pyyaml keystoneauth1 requestsexceptions ];

    patchPhase = ''
      sed -i 's@python@${python.interpreter}@' .testr.conf
    '';
  };

  keystoneauth1 = callPackage ../development/python-modules/keystoneauth1 {};

  requests-mock = buildPythonPackage rec {
    name = "requests-mock-${version}";
    version = "1.3.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/r/requests-mock/${name}.tar.gz";
      sha256 = "0jr997dvk6zbmhvbpcv3rajrgag69mcsm1ai3w3rgk2jdh6rg1mx";
    };

    patchPhase = ''
      sed -i 's@python@${python.interpreter}@' .testr.conf
    '';

    buildInputs = with self; [ pbr testtools testrepository mock ];
    propagatedBuildInputs = with self; [ six requests ];
  };

  mox3 = buildPythonPackage rec {
    name = "mox3-${version}";
    version = "0.23.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/m/mox3/${name}.tar.gz";
      sha256 = "0q26sg0jasday52a7y0cch13l0ssjvr4yqnvswqxsinj1lv5ld88";
    };

    patchPhase = ''
      sed -i 's@python@${python.interpreter}@' .testr.conf
    '';

    #  FAIL: mox3.tests.test_mox.RegexTest.testReprWithFlags
    #  ValueError: cannot use LOCALE flag with a str pattern
    doCheck = !isPy36;

    buildInputs = with self; [ subunit testrepository testtools six ];
    propagatedBuildInputs = with self; [ pbr fixtures ];
  };

  debtcollector = buildPythonPackage rec {
    name = "debtcollector-${version}";
    version = "1.17.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/d/debtcollector/${name}.tar.gz";
      sha256 = "0rh47fd5kgjcdv9dxr7xf0x308cvfic3h2zk03ifvb4pdc5kbqvi";
    };
    patchPhase = ''
      sed -i 's@python@${python.interpreter}@' .testr.conf
    '';

    buildInputs = with self; [ pbr ];
    propagatedBuildInputs = with self; [ wrapt Babel six doc8 ] ++
                              (optional (isPy26 || isPy27) funcsigs);
    checkInputs = with self; [ pbr Babel six wrapt testtools testscenarios
                               testrepository subunit coverage ];
  };

  doc8 = callPackage ../development/python-modules/doc8 { };

  wrapt = buildPythonPackage rec {
    name = "wrapt-${version}";
    version = "1.10.5";

    # No tests in archive
    doCheck = false;

    src = pkgs.fetchurl {
      url = "mirror://pypi/w/wrapt/${name}.tar.gz";
      sha256 = "0cq8rlpzkxzk48b50yrfhzn1d1hrq4gjcdqlrgq4v5palgiv9jwr";
    };
  };

  pagerduty = buildPythonPackage rec {
    name = "pagerduty-${version}";
    version = "0.2.1";
    disabled = isPy3k;

    src = pkgs.fetchurl {
        url = "mirror://pypi/p/pagerduty/pagerduty-${version}.tar.gz";
        sha256 = "e8c237239d3ffb061069aa04fc5b3d8ae4fb0af16a9713fe0977f02261d323e9";
    };
  };

  pandas = callPackage ../development/python-modules/pandas { };

  pandas_0_17_1 = callPackage ../development/python-modules/pandas/0.17.1.nix { };

  xlrd = buildPythonPackage rec {
    name = "xlrd-${version}";

    version = "0.9.4";
    src = pkgs.fetchurl {
      url = "mirror://pypi/x/xlrd/xlrd-${version}.tar.gz";
      sha256 = "8e8d3359f39541a6ff937f4030db54864836a06e42988c452db5b6b86d29ea72";
    };

    buildInputs = with self; [ nose ];
    checkPhase = ''
      nosetests -v
    '';

  };

  bottleneck = callPackage ../development/python-modules/bottleneck { };

  paho-mqtt = buildPythonPackage rec {
    name = "paho-mqtt-${version}";
    version = "1.1";

    disabled = isPyPy || isPy26;

    src = pkgs.fetchurl {
        url = "mirror://pypi/p/paho-mqtt/${name}.tar.gz";
        sha256 = "07i6k9mw66kgbvjgsrcsd2sjji9ckym50dcxnmhjqfkfzsg64yhg";
    };

    meta = {
      homepage = "https://eclipse.org/paho/";
      description = "mqtt library for machine to machine and internet of things";
      license = licenses.epl10;
      maintainers = with maintainers; [ mog ];
    };
  };

  pamqp = buildPythonPackage rec {
    version = "1.6.1";
    name = "pamqp-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pamqp/${name}.tar.gz";
      sha256 = "1vmyvynqzx5zvbipaxff4fnzy3h3dvl3zicyr15yb816j93jl2ca";
    };

    buildInputs = with self; [ mock nose pep8 pylint mccabe ];

    meta = {
      description = "RabbitMQ Focused AMQP low-level library";
      homepage = https://pypi.python.org/pypi/pamqp;
      license = licenses.bsd3;
    };
  };

  parsedatetime = buildPythonPackage rec {
    name = "parsedatetime-${version}";
    version = "2.3";

    meta = {
      description = "Parse human-readable date/time text";
      homepage = "https://github.com/bear/parsedatetime";
      license = licenses.asl20;
    };

    buildInputs = with self; [ pytest pytestrunner ];
    propagatedBuildInputs = with self; [ future ];

    src = pkgs.fetchurl {
        url = "mirror://pypi/p/parsedatetime/${name}.tar.gz";
        sha256 = "1vkrmd398s11h1zn3zaqqsiqhj9lwy1ikcg6irx2lrgjzjg3rjll";
    };
  };

  paramiko = buildPythonPackage rec {
    pname = "paramiko";
    version = "2.1.1";
    name = "${pname}-${version}";

    src = fetchPypi {
      inherit pname version;
      sha256 = "0xdmamqgx2ymhdm46q8flpj4fncj4wv2dqxzz0bc2dh7mnkss7fm";
    };

    propagatedBuildInputs = with self; [ cryptography pyasn1 ];

    # https://github.com/paramiko/paramiko/issues/449
    doCheck = !(isPyPy || isPy33);
    checkPhase = ''
      # test_util needs to resolve an hostname, thus failing when the fw blocks it
      sed '/UtilTest/d' -i test.py

      ${python}/bin/${python.executable} test.py --no-sftp --no-big-file
    '';

    meta = {
      homepage = "https://github.com/paramiko/paramiko/";
      description = "Native Python SSHv2 protocol library";
      license = licenses.lgpl21Plus;
      maintainers = with maintainers; [ aszlig ];

      longDescription = ''
        This is a library for making SSH2 connections (client or server).
        Emphasis is on using SSH2 as an alternative to SSL for making secure
        connections between python scripts. All major ciphers and hash methods
        are supported. SFTP client and server mode are both supported too.
      '';
    };
  };

  paramz = callPackage ../development/python-modules/paramz { };

  parsel = buildPythonPackage rec {
    name = "parsel-${version}";
    version = "1.1.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/parsel/${name}.tar.gz";
      sha256 = "0a34d1c0bj1fzb5dk5744m2ag6v3b8glk4xp0amqxdan9ldbcd97";
    };

    buildInputs = with self; [ pytest pytestrunner ];
    propagatedBuildInputs = with self; [ six w3lib lxml cssselect ];

    checkPhase = ''
      py.test
    '';

    meta = {
      homepage = "https://github.com/scrapy/parsel";
      description = "Parsel is a library to extract data from HTML and XML using XPath and CSS selectors";
      license = licenses.bsd3;
    };
  };

  parso = callPackage ../development/python-modules/parso { };

  partd = buildPythonPackage rec {
    name = "partd-${version}";
    version = "0.3.7";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/partd/${name}.tar.gz";
      sha256 = "066d254d2dh9xcanffgkjgwxpz5v0059b063bij10fvzl2y49hzx";
    };

    buildInputs = with self; [ pytest ];

    propagatedBuildInputs = with self; [ locket numpy pandas pyzmq toolz ];

    checkPhase = ''
      rm partd/tests/test_zmq.py # requires network & fails
      py.test
    '';

    meta = {
      description = "Appendable key-value storage";
      license = with licenses; [ bsd3 ];
      homepage = https://github.com/dask/partd/;
    };
  };

  patch = buildPythonPackage rec {
    name = "${pname}-${version}";
    version = "1.16";
    pname = "patch";

    src = pkgs.fetchzip {
      url = "mirror://pypi/p/${pname}/${name}.zip";
      sha256 = "1nj55hvyvzax4lxq7vkyfbw91pianzr3hp7ka7j12pgjxccac50g";
      stripRoot = false;
    };

    # No tests included in archive
    doCheck = false;

    meta = {
      description = "A library to parse and apply unified diffs";
      homepage = https://github.com/techtonik/python-patch/;
      license = licenses.mit;
      platforms = platforms.all;
      maintainers = [ maintainers.igsha ];
    };
  };

  pathos = buildPythonPackage rec {
    name = "pathos-${version}";
    version = "0.2.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pathos/${name}.tgz";
      sha256 = "e35418af733bf434da83746d46acca94375d6e306b3df330b2a1808db026a188";
    };

    propagatedBuildInputs = with self; [ dill pox ppft multiprocess ];

    # Require network
    doCheck = false;

    meta = {
      description = "Parallel graph management and execution in heterogeneous computing";
      homepage = http://www.cacr.caltech.edu/~mmckerns/pathos.htm;
      license = licenses.bsd3;
    };
  };

  patsy = buildPythonPackage rec {
    name = "patsy-${version}";
    version = "0.3.0";

    src = pkgs.fetchurl{
      url = "mirror://pypi/p/patsy/${name}.zip";
      sha256 = "a55dd4ca09af4b9608b81f30322beb450510964c022708ab50e83a065ccf15f0";
    };

    buildInputs = with self; [ nose ];
    propagatedBuildInputs = with self; [six numpy];

    meta = {
      description = "A Python package for describing statistical models";
      homepage = "https://github.com/pydata/patsy";
      license = licenses.bsd2;
    };
  };

  paste = buildPythonPackage rec {
    name = "paste-${version}";
    version = "2.0.3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/P/Paste/Paste-${version}.tar.gz";
      sha256 = "062jk0nlxf6lb2wwj6zc20rlvrwsnikpkh90y0dn8cjch93s6ii3";
    };

    checkInputs = with self; [ nose ];
    propagatedBuildInputs = with self; [ six ];

    # Certain tests require network
    checkPhase = ''
      NOSE_EXCLUDE=test_ok,test_form,test_error,test_stderr,test_paste_website nosetests
    '';

    meta = {
      description = "Tools for using a Web Server Gateway Interface stack";
      homepage = http://pythonpaste.org/;
    };
  };


  PasteDeploy = buildPythonPackage rec {
    version = "1.5.2";
    name = "paste-deploy-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/P/PasteDeploy/PasteDeploy-${version}.tar.gz";
      sha256 = "d5858f89a255e6294e63ed46b73613c56e3b9a2d82a42f1df4d06c8421a9e3cb";
    };

    buildInputs = with self; [ nose ];

    meta = {
      description = "Load, configure, and compose WSGI applications and servers";
      homepage = http://pythonpaste.org/deploy/;
      platforms = platforms.all;
    };
  };

   pasteScript = buildPythonPackage rec {
    version = "1.7.5";
    name = "PasteScript-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/P/PasteScript/${name}.tar.gz";
      sha256 = "2b685be69d6ac8bc0fe6f558f119660259db26a15e16a4943c515fbee8093539";
    };

    doCheck = false;
    buildInputs = with self; [ nose ];
    propagatedBuildInputs = with self; [ six paste PasteDeploy cheetah argparse ];

    meta = {
      description = "A pluggable command-line frontend, including commands to setup package file layouts";
      homepage = http://pythonpaste.org/script/;
      platforms = platforms.all;
    };
  };

  pathlib = buildPythonPackage rec {
    name = "pathlib-${version}";
    version = "1.0.1";
    disabled = pythonAtLeast "3.4"; # Was added to std library in Python 3.4

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pathlib/${name}.tar.gz";
      sha256 = "17zajiw4mjbkkv6ahp3xf025qglkj0805m9s41c45zryzj6p2h39";
    };

    checkPhase = ''
      ${python.interpreter} -m unittest discover
    '';

    meta = {
      description = "Object-oriented filesystem paths";
      homepage = "https://pathlib.readthedocs.org/";
      license = licenses.mit;
    };
  };

  pathlib2 = if !(pythonOlder "3.4") then null else buildPythonPackage rec {
    name = "pathlib2-${version}";
    version = "2.2.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pathlib2/${name}.tar.gz";
      sha256 = "ce9007df617ef6b7bd8a31cd2089ed0c1fed1f7c23cf2bf1ba140b3dd563175d";
    };

    propagatedBuildInputs = with self; [ six ] ++ optional (pythonOlder "3.5") scandir;

    meta = {
      description = "This module offers classes representing filesystem paths with semantics appropriate for different operating systems.";
      homepage = https://pypi.python.org/pypi/pathlib2/;
      license = with licenses; [ mit ];
    };

  };

  pathpy = callPackage ../development/python-modules/path.py { };

  paypalrestsdk = buildPythonPackage rec {
    name = "paypalrestsdk-0.7.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/paypalrestsdk/${name}.tar.gz";
      sha256 = "117kfipzfahf9ysv414bh1mmm5cc9ck5zb6rhpslx1f8gk3frvd6";
    };

    propagatedBuildInputs = with self; [ httplib2 ];

    meta = {
      homepage = https://developer.paypal.com/;
      description = "Python APIs to create, process and manage payment";
      license = "PayPal SDK License";
    };
  };

  pbr = callPackage ../development/python-modules/pbr { };

  fixtures = callPackage ../development/python-modules/fixtures { };

  pelican = callPackage ../development/python-modules/pelican {
    inherit (pkgs) glibcLocales pandoc git;
  };

  pep8 = buildPythonPackage rec {
    name = "pep8-${version}";
    version = "1.7.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pep8/${name}.tar.gz";
      sha256 = "a113d5f5ad7a7abacef9df5ec3f2af23a20a28005921577b15dd584d099d5900";
    };

    meta = {
      homepage = "http://pep8.readthedocs.org/";
      description = "Python style guide checker";
      license = licenses.mit;
      maintainers = with maintainers; [ garbas ];
    };
  };

  pep257 = callPackage ../development/python-modules/pep257 { };

  percol = buildPythonPackage rec {
    name = "percol-${version}";
    version = "0.0.8";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/percol/${name}.tar.gz";
      sha256 = "169s5mhw1s60qbsd6pkf9bb2x6wfgx8hn8nw9d4qgc68qnnpp2cj";
    };

    propagatedBuildInputs = with self; [ ];

    meta = {
      homepage = https://github.com/mooz/percol;
      description = "Adds flavor of interactive filtering to the traditional pipe concept of shell";
      license = licenses.mit;
      maintainers = with maintainers; [ koral ];
    };
  };

  pexif = buildPythonPackage rec {
    name = "pexif-${version}";
    version = "0.15";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pexif/pexif-0.15.tar.gz";
      sha256 = "45a3be037c7ba8b64bbfc48f3586402cc17de55bb9d7357ef2bc99954a18da3f";
    };

    meta = {
      description = "A module for editing JPEG EXIF data";
      homepage = http://www.benno.id.au/code/pexif/;
      license = licenses.mit;
    };
  };


  pexpect = buildPythonPackage rec {
    version = "4.2.1";
    name = "pexpect-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pexpect/${name}.tar.gz";
      sha256 = "3d132465a75b57aa818341c6521392a06cc660feb3988d7f1074f39bd23c9a92";
    };

    # Wants to run pythonin a subprocess
    doCheck = false;

    propagatedBuildInputs = with self; [ ptyprocess ];

    meta = {
      homepage = http://www.noah.org/wiki/Pexpect;
      description = "Automate interactive console applications such as ssh, ftp, etc";
      license = licenses.mit;

      longDescription = ''
        Pexpect is similar to the Don Libes "Expect" system, but Pexpect
        as a different interface that is easier to understand. Pexpect
        is basically a pattern matching system. It runs programs and
        watches output. When output matches a given pattern Pexpect can
        respond as if a human were typing responses. Pexpect can be used
        for automation, testing, and screen scraping. Pexpect can be
        used for automating interactive console applications such as
        ssh, ftp, passwd, telnet, etc. It can also be used to control
        web applications via "lynx", "w3m", or some other text-based web
        browser. Pexpect is pure Python. Unlike other Expect-like
        modules for Python Pexpect does not require TCL or Expect nor
        does it require C extensions to be compiled. It should work on
        any platform that supports the standard Python pty module.
      '';
    };
  };

  pdfkit = buildPythonPackage rec {
    name = "pdfkit-${version}";
    version = "0.5.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pdfkit/${name}.zip";
      sha256 = "1p1m6gp51ql3wzjs2iwds8sc3hg1i48yysii9inrky6qc3s6q5vf";
    };

    buildInputs = with self; [ ];
    # tests are not distributed
    doCheck = false;

    meta = {
      homepage = https://pypi.python.org/pypi/pdfkit;
      description = "Wkhtmltopdf python wrapper to convert html to pdf using the webkit rendering engine and qt";
      license = licenses.mit;
    };
  };

  pg8000 = buildPythonPackage rec {
    name = "pg8000-1.10.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pg8000/${name}.tar.gz";
      sha256 = "188658db63c2ca931ae1bf0167b34efaac0ecc743b707f0118cc4b87e90ce488";
    };

    propagatedBuildInputs = with self; [ pytz ];

    meta = {
      maintainers = with maintainers; [ garbas domenkozar ];
      platforms = platforms.linux;
    };
  };

  pgspecial = buildPythonPackage rec {
    pname = "pgspecial";
    version = "1.8.0";
    name = "${pname}-${version}";

    src = fetchPypi {
      inherit pname version;
      sha256 = "1dwlv3m4jl34zsakmvxg6hgbfv786jl8dcffxsrlnmcpks829xc9";
    };

    buildInputs = with self; [ pytest psycopg2 ];

    checkPhase = ''
      find tests -name \*.pyc -delete
      py.test tests
    '';

    propagatedBuildInputs = with self; [ click sqlparse ];

    meta = {
      description = "Meta-commands handler for Postgres Database";
      homepage = https://pypi.python.org/pypi/pgspecial;
      license = licenses.bsd3;
      maintainers = with maintainers; [ nckx ];
    };
  };

  pickleshare = buildPythonPackage rec {
    version = "0.7.4";
    name = "pickleshare-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pickleshare/${name}.tar.gz";
      sha256 = "84a9257227dfdd6fe1b4be1319096c20eb85ff1e82c7932f36efccfe1b09737b";
    };

    propagatedBuildInputs = with self; [pathpy] ++ optional (pythonOlder "3.4") pathlib2;

    # No proper test suite
    doCheck = false;

    meta = {
      description = "Tiny 'shelve'-like database with concurrency support";
      homepage = https://github.com/vivainio/pickleshare;
      license = licenses.mit;
    };
  };

  piep = buildPythonPackage rec {
    version = "0.8.0";
    name = "piep-${version}";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/piep/piep-${version}.tar.gz";
      sha256 = "1wgkg1kc28jpya5k4zvbc9jmpa60b3d5c3gwxfbp15hw6smyqirj";
    };

    propagatedBuildInputs = with self; [pygments];

    meta = {
      description = "Bringing the power of python to stream editing";
      homepage = https://github.com/timbertson/piep;
      maintainers = with maintainers; [ timbertson ];
      license = licenses.gpl3;
    };
  };

  piexif = callPackage ../development/python-modules/piexif { };

  pip = buildPythonPackage rec {
    pname = "pip";
    version = "9.0.1";
    name = "${pname}-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
      sha256 = "09f243e1a7b461f654c26a725fa373211bb7ff17a9300058b205c61658ca940d";
    };

    # pip detects that we already have bootstrapped_pip "installed", so we need
    # to force it a little.
    installFlags = [ "--ignore-installed" ];

    checkInputs = with self; [ mock scripttest virtualenv pretend pytest ];
    # Pip wants pytest, but tests are not distributed
    doCheck = false;

    meta = {
      description = "The PyPA recommended tool for installing Python packages";
      license = licenses.mit;
      homepage = https://pip.pypa.io/;
      priority = 10;
    };
  };

  pip-tools = callPackage ../development/python-modules/pip-tools {
    git = pkgs.gitMinimal;
    glibcLocales = pkgs.glibcLocales;
  };

  pika = buildPythonPackage rec {
    name = "pika-${version}";
    version = "0.10.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pika/${name}.tar.gz";
      sha256 = "0nb4h08di432lv7dy2v9kpwgk0w92f24sqc2hw2s9vwr5b8v8xvj";
    };

    # Tests require twisted which is only availalble for python-2.x
    doCheck = !isPy3k;

    buildInputs = with self; [ nose mock pyyaml unittest2 pyev ] ++ optionals (!isPy3k) [ twisted tornado ];

    meta = {
      description = "Pure-Python implementation of the AMQP 0-9-1 protocol";
      homepage = https://pika.readthedocs.org;
      license = licenses.bsd3;
    };
  };

  pika-pool = callPackage ../development/python-modules/pika-pool { };
  platformio = callPackage ../development/python-modules/platformio { };

  kmsxx = callPackage ../development/libraries/kmsxx { };

  pylibconfig2 = buildPythonPackage rec {
    name = "pylibconfig2-${version}";
    version = "0.2.4";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pylibconfig2/${name}.tar.gz";
      sha256 = "0kyg6gldj6hi2jhc5xhi834bb2mcaiy24dvfik963shnldqr7kqg";
    };

    doCheck = false;

    propagatedBuildInputs = with self ; [ pyparsing ];

    meta = {
      homepage = https://github.com/heinzK1X/pylibconfig2;
      description = "Pure python library for libconfig syntax";
      license = licenses.gpl3;
    };
  };

  pylibmc = callPackage ../development/python-modules/pylibmc {};

  pymetar = buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "pymetar";
    version = "0.20";

    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/${pname}/${name}.tar.gz";
      sha256 = "1rxyg9465cp6nc47pqxqf092wmbvv2zhffzvaf2w74laal43pgxw";
    };

    meta = {
      description = "A command-line tool to show the weather report by a given station ID";
      homepage = http://www.schwarzvogel.de/software/pymetar.html;
      license = licenses.gpl2;
    };
  };

  pysftp = buildPythonPackage rec {
    name = "pysftp-${version}";
    version = "0.2.9";
    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pysftp/${name}.tar.gz";
      sha256 = "0jl5qix5cxzrv4lb8rfpjkpcghbkacnxkb006ikn7mkl5s05mxgv";
    };

    propagatedBuildInputs = with self; [ paramiko ];

    meta = {
      homepage = https://bitbucket.org/dundeemt/pysftp;
      description = "A friendly face on SFTP";
      license = licenses.mit;
      longDescription = ''
        A simple interface to SFTP. The module offers high level abstractions
        and task based routines to handle your SFTP needs. Checkout the Cook
        Book, in the docs, to see what pysftp can do for you.
      '';
    };
  };

  pysoundfile = callPackage ../development/python-modules/pysoundfile { };

  python3pika = buildPythonPackage {
    name = "python3-pika-0.9.14";
    disabled = !isPy3k;

    # Unit tests adds dependencies on pyev, tornado and twisted (and twisted is disabled for Python 3)
    doCheck = false;

    src = pkgs.fetchurl {
      url = mirror://pypi/p/python3-pika/python3-pika-0.9.14.tar.gz;
      sha256 = "1c3hifwvn04kvlja88iawf0awyz726jynwnpcb6gn7376b4nfch7";
    };
    buildInputs = with self; [ nose mock pyyaml ];

    propagatedBuildInputs = with self; [ unittest2 ];
  };


  python-jenkins = buildPythonPackage rec {
    name = "python-jenkins-${version}";
    version = "0.4.14";
    src = pkgs.fetchurl {
      url = "mirror://pypi/p/python-jenkins/${name}.tar.gz";
      sha256 = "1n8ikvd9jf4dlki7nqlwjlsn8wpsx4x7wg4h3d6bkvyvhwwf8yqf";
    };
    patchPhase = ''
      sed -i 's@python@${python.interpreter}@' .testr.conf
    '';

    buildInputs = with self; [ mock ];
    propagatedBuildInputs = with self; [ pbr pyyaml six multi_key_dict testtools
     testscenarios testrepository kerberos ];

    meta = {
      description = "Python bindings for the remote Jenkins API";
      homepage = https://pypi.python.org/pypi/python-jenkins;
      license = licenses.bsd3;
    };
  };

  pystringtemplate = callPackage ../development/python-modules/stringtemplate { };

  pillow = callPackage ../development/python-modules/pillow {
    inherit (pkgs) freetype libjpeg zlib libtiff libwebp tcl lcms2 tk;
    inherit (pkgs.xorg) libX11;
  };

  pkgconfig = buildPythonPackage rec {
    name = "pkgconfig-${version}";
    version = "1.1.0";

    # pypy: SyntaxError: __future__ statements must appear at beginning of file
    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pkgconfig/${name}.tar.gz";
      sha256 = "709daaf077aa2b33bedac12706373412c3683576a43013bbaa529fc2769d80df";
    };

    buildInputs = with self; [ nose ];

    propagatedBuildInputs = with self; [pkgs.pkgconfig];

    meta = {
      description = "Interface Python with pkg-config";
      homepage = https://github.com/matze/pkgconfig;
      license = licenses.mit;
    };

    # nosetests needs to be run explicitly.
    # Note that the distributed archive does not actually contain any tests.
    # https://github.com/matze/pkgconfig/issues/9
    checkPhase = ''
      nosetests
    '';

  };

  plumbum = callPackage ../development/python-modules/plumbum { };


  polib = buildPythonPackage rec {
    name = "polib-${version}";
    version = "1.0.4";

    src = pkgs.fetchurl {
      url = "http://bitbucket.org/izi/polib/downloads/${name}.tar.gz";
      sha256 = "16klwlswfbgmkzrra80fgzhic9447pk3mnr75r2fkz72bkvpcclb";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      description = "A library to manipulate gettext files (po and mo files)";
      homepage = "http://bitbucket.org/izi/polib/";
      license = licenses.mit;
    };
  };

  posix_ipc = buildPythonPackage rec {
    name = "posix_ipc-${version}";
    version = "1.0.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/posix_ipc/${name}.tar.gz";
      sha256 = "1jzg66708pi5n9w07fbz6rlxx30cjds9hp2yawjjfryafh1hg4ww";
    };

    meta = {
      description = "POSIX IPC primitives (semaphores, shared memory and message queues)";
      license = licenses.bsd3;
      homepage = http://semanchuk.com/philip/posix_ipc/;
    };
  };

  portend = callPackage ../development/python-modules/portend { };

  powerline = callPackage ../development/python-modules/powerline { };

  pox = buildPythonPackage rec {
    name = "pox-${version}";
    version = "0.2.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pox/${name}.tgz";
      sha256 = "22e97ac6d2918c754e65a9581dbe02e9d00ae4a54ca48d05118f87c1ea92aa19";
    };

    meta = {
      description = "Utilities for filesystem exploration and automated builds";
      license = licenses.bsd3;
      homepage = http://www.cacr.caltech.edu/~mmckerns/pox.htm;
    };
  };

  ppft = buildPythonPackage rec {
    name = "ppft-${version}";
    version = "1.6.4.6";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/ppft/${name}.tgz";
      sha256 = "6f99c861822884cb00badbd5f364ee32b90a157084a6768040793988c6b92bff";
    };

    propagatedBuildInputs = with self; [ six ];

    meta = {
      description = "Distributed and parallel python";
      homepage = https://github.com/uqfoundation;
      license = licenses.bsd3;
    };
  };

  praw = callPackage ../development/python-modules/praw { };

  prawcore = callPackage ../development/python-modules/prawcore { };

  premailer = callPackage ../development/python-modules/premailer { };

  prettytable = buildPythonPackage rec {
    name = "prettytable-0.7.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/P/PrettyTable/${name}.tar.bz2";
      sha256 = "599bc5b4b9602e28294cf795733c889c26dd934aa7e0ee9cff9b905d4fbad188";
    };

    buildInputs = [ pkgs.glibcLocales ];

    preCheck = ''
      export LANG="en_US.UTF-8"
    '';

    meta = {
      description = "Simple Python library for easily displaying tabular data in a visually appealing ASCII table format";
      homepage = http://code.google.com/p/prettytable/;
    };
  };


  prompt_toolkit = callPackage ../development/python-modules/prompt_toolkit { };

  prompt_toolkit_52 = self.prompt_toolkit.overridePythonAttrs(oldAttrs: rec {
    name = "${oldAttrs.pname}-${version}";
    version = "0.52";
    src = oldAttrs.src.override {
      inherit version;
      sha256 = "00h9ldqmb33nhg2kpks7paldf3n3023ipp124alwp96yz16s7f1m";
    };

    # No tests included in archive
    doCheck = false;

    #Only <3.4 expressly supported.
    disabled = isPy35;

  });

  protobuf = callPackage ../development/python-modules/protobuf {
    disabled = isPyPy;
    doCheck = !isPy3k;
    protobuf = pkgs.protobuf;
  };

  protobuf3_1 = callPackage ../development/python-modules/protobuf {
    disabled = isPyPy;
    doCheck = !isPy3k;
    protobuf = pkgs.protobuf3_1;
  };

  psd-tools = callPackage ../development/python-modules/psd-tools { };

  psutil = buildPythonPackage rec {
    name = "psutil-${version}";
    version = "4.3.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/psutil/${name}.tar.gz";
      sha256 = "1w4r09fvn6kd80m5mx4ws1wz100brkaq6hzzpwrns8cgjzjpl6c6";
    };

    # Certain tests fail due to being in a chroot.
    # See also the older issue: https://code.google.com/p/psutil/issues/detail?id=434
    doCheck = false;

    buildInputs = with self; [ mock ] ++ optionals stdenv.isDarwin [ pkgs.darwin.IOKit ];

    meta = {
      description = "Process and system utilization information interface for python";
      homepage = https://github.com/giampaolo/psutil;
    };
  };

  psutil_1 = self.psutil.overrideDerivation (self: rec {
    name = "psutil-1.2.1";
    src = pkgs.fetchurl {
      url = "mirror://pypi/p/psutil/${name}.tar.gz";
      sha256 = "0ibclqy6a4qmkjhlk3g8jhpvnk0v9aywknc61xm3hfi5r124m3jh";
    };
  });

  psycopg2 = buildPythonPackage rec {
    name = "psycopg2-2.7.1";
    disabled = isPyPy;
    src = pkgs.fetchurl {
      url = "mirror://pypi/p/psycopg2/${name}.tar.gz";
      sha256 = "86c9355f5374b008c8479bc00023b295c07d508f7c3b91dbd2e74f8925b1d9c6";
    };
    buildInputs = optional stdenv.isDarwin pkgs.openssl;
    propagatedBuildInputs = with self; [ pkgs.postgresql ];
    doCheck = false;
    meta = {
      description = "PostgreSQL database adapter for the Python programming language";
      license = with licenses; [ gpl2 zpl20 ];
    };
  };

  ptpython = callPackage ../development/python-modules/ptpython {};

  publicsuffix = buildPythonPackage rec {
    name = "publicsuffix-${version}";
    version = "1.1.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/publicsuffix/${name}.tar.gz";
      sha256 = "1adx520249z2cy7ykwjr1k190mn2888wqn9jf8qm27ly4qymjxxf";
    };

    # fix the ASCII-mode LICENSE file read
    # disable test_fetch and the doctests (which also invoke fetch)
    patchPhase = optionalString isPy3k ''
      sed -i "s/)\.read(/,encoding='utf-8'\0/" setup.py
    '' + ''
      sed -i -e "/def test_fetch/i\\
      \\t@unittest.skip('requires internet')" -e "/def additional_tests():/,+1d" tests.py
    '';

    meta = {
      description = "Allows to get the public suffix of a domain name";
      homepage = "http://pypi.python.org/pypi/publicsuffix/";
      license = licenses.mit;
    };
  };


  py = callPackage ../development/python-modules/py { };


  pyacoustid = buildPythonPackage rec {
    name = "pyacoustid-1.1.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pyacoustid/${name}.tar.gz";
      sha256 = "0117039cb116af245e6866e8e8bf3c9c8b2853ad087142bd0c2dfc0acc09d452";
    };

    propagatedBuildInputs = with self; [ requests audioread ];

    patches = [ ../development/python-modules/pyacoustid-py3.patch ];

    postPatch = ''
      sed -i \
          -e '/^FPCALC_COMMAND *=/s|=.*|= "${pkgs.chromaprint}/bin/fpcalc"|' \
          acoustid.py
    '';

    meta = {
      description = "Bindings for Chromaprint acoustic fingerprinting";
      homepage = "https://github.com/sampsyo/pyacoustid";
      license = licenses.mit;
    };
  };


  pyalgotrade = buildPythonPackage {
    name = "pyalgotrade-0.16";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/P/PyAlgoTrade/PyAlgoTrade-0.16.tar.gz";
      sha256 = "a253617254194b91cfebae7bfd184cb109d4e48a8c70051b9560000a2c0f94b3";
    };

    propagatedBuildInputs = with self; [ numpy scipy pytz ];

    meta = {
      description = "Python Algorithmic Trading";
      homepage = http://gbeced.github.io/pyalgotrade/;
      license = licenses.asl20;
    };
  };


  pyasn1 = callPackage ../development/python-modules/pyasn1 { };

  pyasn1-modules = callPackage ../development/python-modules/pyasn1-modules { };

  pyaudio = buildPythonPackage rec {
    name = "python-pyaudio-${version}";
    version = "0.2.9";

    src = pkgs.fetchurl {
      url = "mirror://pypi/P/PyAudio/PyAudio-${version}.tar.gz";
      sha256 = "bfd694272b3d1efc51726d0c27650b3c3ba1345f7f8fdada7e86c9751ce0f2a1";
    };

    disabled = isPyPy;

    buildInputs = with self; [ pkgs.portaudio ];

    meta = {
      description = "Python bindings for PortAudio";
      homepage = "http://people.csail.mit.edu/hubert/pyaudio/";
      license = licenses.mit;
    };
  };

  pysaml2 = buildPythonPackage rec {
    name = "pysaml2-${version}";
    version = "3.0.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pysaml2/${name}.tar.gz";
      sha256 = "0y2iw1dddcvi13xjh3l52z1mvnrbc41ik9k4nn7lwj8x5kimnk9n";
    };

    patches = [
      (pkgs.fetchpatch {
        name = "CVE-2016-10127.patch";
        url = "https://sources.debian.net/data/main/p/python-pysaml2/3.0.0-5/debian/patches/fix-xxe-in-xml-parsing.patch";
        sha256 = "184lkwdayjqiahzsn4yp15parqpmphjsb1z7zwd636jvarxqgs2q";
      })
    ];

    propagatedBuildInputs = with self; [
      repoze_who paste cryptography pycrypto pyopenssl ipaddress six cffi idna
      enum34 pytz setuptools zope_interface dateutil requests pyasn1 webob decorator pycparser
      defusedxml
    ];
    buildInputs = with self; [
      Mako pytest memcached pymongo mongodict pkgs.xmlsec
    ];

    preConfigure = ''
      sed -i 's/pymongo==3.0.1/pymongo/' setup.py
    '';

    # 16 failed, 427 passed, 17 error in 88.85 seconds
    doCheck = false;

    meta = with stdenv.lib; {
      homepage = "https://github.com/rohe/pysaml2";
    };
  };

  mongodict = buildPythonPackage rec {
    name = "mongodict-${version}";
    version = "0.3.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/m/mongodict/${name}.tar.gz";
      sha256 = "0nv5amfs337m0gbxpjb0585s20rndqfc3mfrzq1iwgnds5gxcrlw";
    };

    propagatedBuildInputs = with self; [
      pymongo
    ];

    meta = with stdenv.lib; {
      description = "MongoDB-backed Python dict-like interface";
      homepage = "https://github.com/turicas/mongodict/";
    };
  };


  repoze_who = buildPythonPackage rec {
    name = "repoze.who-${version}";
    version = "2.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/r/repoze.who/${name}.tar.gz";
      sha256 = "12wsviar45nwn35w2y4i8b929dq2219vmwz8013wx7bpgkn2j9ij";
    };

    propagatedBuildInputs = with self; [
      zope_interface webob
    ];
    buildInputs = with self; [

    ];

    meta = with stdenv.lib; {
      description = "WSGI Authentication Middleware / API";
      homepage = "http://www.repoze.org";
    };
  };



  vobject = buildPythonPackage rec {
    version = "0.9.3";
    name = "vobject-${version}";

    src = pkgs.fetchFromGitHub {
      owner = "eventable";
      repo = "vobject";
      sha256 = "00vbii5awwqwfh5hfklj1q79w7d85gjigvf2imgyb71g03sb8cjv";
      rev = version;
    };

    disabled = isPyPy;

    propagatedBuildInputs = with self; [ dateutil ];

    checkPhase = "${python.interpreter} tests.py";

    meta = {
      description = "Module for reading vCard and vCalendar files";
      homepage = http://eventable.github.io/vobject/;
      license = licenses.asl20;
      maintainers = with maintainers; [ ];
    };
  };

  pycarddav = buildPythonPackage rec {
    version = "0.7.0";
    name = "pycarddav-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pyCardDAV/pyCardDAV-${version}.tar.gz";
      sha256 = "0avkrcpisfvhz103v7vmq2jd83hvmpqrb4mlbx6ikkk1wcvclsx8";
    };

    disabled = isPy3k || isPyPy;

    propagatedBuildInputs = with self; [ vobject lxml requests urwid pyxdg ];

    meta = {
      description = "Command-line interface carddav client";
      homepage = http://lostpackets.de/pycarddav;
      license = licenses.mit;
      maintainers = with maintainers; [ ];
    };
  };

  pycosat = buildPythonPackage rec {
    name = "pycosat-0.6.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pycosat/${name}.tar.gz";
      sha256 = "02sdn2998jlrm35smn1530hix3kzwyc1jv49cjdcnvfvrqqi3rww";
    };

    meta = {
      description = "Python bindings for PicoSAT";
      longDescription = ''PicoSAT is a popular SAT solver written by Armin
          Biere in pure C. This package provides efficient Python bindings
          to picosat on the C level, i.e. when importing pycosat, the
          picosat solver becomes part of the Python process itself. For
          ease of deployment, the picosat source (namely picosat.c and
          picosat.h) is included in this project.'';
      homepage = https://github.com/ContinuumIO/pycosat;
      license = licenses.mit;
    };
  };

  pygit2 = callPackage ../development/python-modules/pygit2 { };

  Babel = buildPythonPackage (rec {
    name = "Babel-2.3.4";

    src = pkgs.fetchurl {
      url = "mirror://pypi/B/Babel/${name}.tar.gz";
      sha256 = "0x98qqqw35xllpcama013a9788ly84z8dm1w2wwfpxh2710c8df5";
    };

    buildInputs = with self; [ pytest ];
    propagatedBuildInputs = with self; [ pytz ];

    meta = {
      homepage = http://babel.edgewall.org;
      description = "A collection of tools for internationalizing Python applications";
      license = licenses.bsd3;
      maintainers = with maintainers; [ garbas ];
    };
  });

  pybfd = callPackage ../development/python-modules/pybfd { };

  pyblock = stdenv.mkDerivation rec {
    name = "pyblock-${version}";
    version = "0.53";
    md5_path = "f6d33a8362dee358517d0a9e2ebdd044";

    src = pkgs.fetchurl rec {
      url = "http://pkgs.fedoraproject.org/repo/pkgs/python-pyblock/"
          + "${name}.tar.bz2/${md5_path}/${name}.tar.bz2";
      sha256 = "f6cef88969300a6564498557eeea1d8da58acceae238077852ff261a2cb1d815";
    };

    postPatch = ''
      sed -i -e 's|/usr/include/python|${python}/include/python|' \
             -e 's/-Werror *//' -e 's|/usr/|'"$out"'/|' Makefile
    '';

    buildInputs = with self; [ python pkgs.lvm2 pkgs.dmraid ];

    makeFlags = [
      "USESELINUX=0"
      "SITELIB=$(out)/${python.sitePackages}"
    ];

    meta = {
      description = "Interface for working with block devices";
      license = licenses.gpl2Plus;
    };
  };

  pybcrypt = buildPythonPackage rec {
    name = "pybcrypt";
    version = "0.4";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/py-bcrypt/py-bcrypt-${version}.tar.gz";
      sha256 = "5fa13bce551468350d66c4883694850570f3da28d6866bb638ba44fe5eabda78";
    };

    meta = {
      description = "bcrypt password hashing and key derivation";
      homepage = https://code.google.com/p/py-bcrypt2;
      license = "BSD";
    };
  };

  pyblosxom = buildPythonPackage rec {
    name = "pyblosxom-${version}";
    disabled = isPy3k;
    version = "1.5.3";
    # FAIL:test_generate_entry and test_time
    # both tests fail due to time issue that doesn't seem to matter in practice
    doCheck = false;
    src = pkgs.fetchurl {
      url = "https://github.com/pyblosxom/pyblosxom/archive/v${version}.tar.gz";
      sha256 = "0de9a7418f4e6d1c45acecf1e77f61c8f96f036ce034493ac67124626fd0d885";
    };

    propagatedBuildInputs = with self; [ pygments markdown ];

    meta = {
      homepage = "http://pyblosxom.github.io";
      description = "File-based blogging engine";
      license = licenses.mit;
    };
  };


  pycapnp = buildPythonPackage rec {
    name = "pycapnp-0.5.1";
    disabled = isPyPy || isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pycapnp/${name}.tar.gz";
      sha256 = "1kp97il34419gcrhn866n6a10lvh8qr13bnllnnh9473n4cq0cvk";
    };

    buildInputs = with pkgs; [ capnproto self.cython ];

    # import setuptools as soon as possible, to minimize monkeypatching mayhem.
    postConfigure = ''
      sed -i '3iimport setuptools' setup.py
    '';

    meta = {
      maintainers = with maintainers; [ cstrahan ];
      license = licenses.bsd2;
      platforms = platforms.all;
      homepage = "http://jparyani.github.io/pycapnp/index.html";
    };
  };


  pycdio = buildPythonPackage rec {
    name = "pycdio-0.21";
    disabled = !isPy27;

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pycdio/${name}.tar.gz";
      sha256 = "1bkcmg838l2yffsw5lln93ap5f8ks3vmqwg02mygmdmay647rc3v";
    };

    prePatch = ''
      sed -i -e "s|if type(driver_id)==int|if type(driver_id) in (int, long)|g" cdio.py
    '';

    preConfigure = ''
      patchShebangs .
    '';

    nativeBuildInputs = [ pkgs.pkgconfig ];
    buildInputs = [ self.setuptools self.nose pkgs.swig pkgs.libcdio ]
      ++ stdenv.lib.optional stdenv.isDarwin pkgs.libiconv;

    # Run tests using nosetests but first need to install the binaries
    # to the root source directory where they can be found.
    checkPhase = ''
      ./setup.py install_lib -d .
      nosetests
    '';

    meta = {
      homepage = http://www.gnu.org/software/libcdio/;
      description = "Wrapper around libcdio (CD Input and Control library)";
      maintainers = with maintainers; [ rycee ];
      license = licenses.gpl3Plus;
    };

  };


  pycryptopp = buildPythonPackage (rec {
    name = "pycryptopp-0.6.0.1206569328141510525648634803928199668821045408958";
    disabled = isPy3k || isPyPy;  # see https://bitbucket.org/pypy/pypy/issue/1190/

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pycryptopp/${name}.tar.gz";
      sha256 = "0n90h1yg7bfvlbhnc54xb6dbqm286ykaksyg04kxlhyjgf8mhq8i";
    };

    # Prefer crypto++ library from the Nix store over the one that's included
    # in the pycryptopp distribution.
    preConfigure = "export PYCRYPTOPP_DISABLE_EMBEDDED_CRYPTOPP=1";

    buildInputs = with self; [ setuptoolsDarcs darcsver pkgs.cryptopp ];

    meta = {
      homepage = http://allmydata.org/trac/pycryptopp;

      description = "Python wrappers for the Crypto++ library";

      license = licenses.gpl2Plus;

      maintainers = [ ];
      platforms = platforms.linux;
    };
  });

  pycups = buildPythonPackage rec {
    name = "pycups-${version}";
    version = "1.9.73";

    src = pkgs.fetchurl {
      url = "http://cyberelk.net/tim/data/pycups/pycups-${version}.tar.bz2";
      sha256 = "c381be011889ca6f728598578c89c8ac9f7ab1e95b614474df9f2fa831ae5335";
    };

    buildInputs = [ pkgs.cups ];

    # Wants to connect to CUPS
    doCheck = false;

    meta = {
      description = "Python bindings for libcups";
      homepage = http://cyberelk.net/tim/software/pycups/;
      license = with licenses; [ gpl2Plus ];
    };

  };

  pycurl = buildPythonPackage (rec {
    name = "pycurl-7.19.5.1";
    disabled = isPyPy; # https://github.com/pycurl/pycurl/issues/208

    src = pkgs.fetchurl {
      url = "http://pycurl.sourceforge.net/download/${name}.tar.gz";
      sha256 = "0v5w66ir3siimfzg3kc8hfrrilwwnbxq5bvipmrpyxar0kw715vf";
    };

    buildInputs = with self; [ pkgs.curl pkgs.openssl.out ];

    # error: invalid command 'test'
    doCheck = false;

    preConfigure = ''
      substituteInPlace setup.py --replace '--static-libs' '--libs'
      export PYCURL_SSL_LIBRARY=openssl
    '';

    #TODO no idea why this is needed
    postInstall = ''
      ln -s ${pkgs.openssl.out}/lib/libcrypto* $out/lib/
    '';

    meta = {
      homepage = http://pycurl.sourceforge.net/;
      description = "Python wrapper for libcurl";
      platforms = platforms.linux;
    };
  });

  pycurl2 = buildPythonPackage (rec {
    name = "pycurl2-7.20.0";
    disabled = isPy3k;

    src = pkgs.fetchgit {
      url = "https://github.com/Lispython/pycurl.git";
      rev = "0f00109950b883d680bd85dc6e8a9c731a7d0d13";
      sha256 = "1qmw3cm93kxj94s71a8db9lwv2cxmr2wjv7kp1r8zildwdzhaw7j";
    };

    # error: (6, "Couldn't resolve host 'h.wrttn.me'")
    doCheck = false;

    buildInputs = with self; [ pkgs.curl simplejson unittest2 nose ];

    meta = {
      homepage = https://pypi.python.org/pypi/pycurl2;
      description = "A fork from original PycURL library that no maintained from 7.19.0";
      platforms = platforms.linux;
    };
  });

  pydispatcher = buildPythonPackage (rec {
    version = "2.0.5";
    name = "pydispatcher-${version}";
    src = pkgs.fetchurl {
      url = "mirror://pypi/P/PyDispatcher/PyDispatcher-${version}.tar.gz";
      sha256 = "1bswbmhlbqdxlgbxlb6xrlm4k253sg8nvpl1whgsys8p3fg0cw2m";
    };

    buildInputs = with self; [ pytest ];

    checkPhase = ''
      py.test
    '';

    meta = {
      homepage = http://pydispatcher.sourceforge.net/;
      description = "Signal-registration and routing infrastructure for use in multiple contexts";
      license = licenses.bsd3;
    };
   });

  pydot = callPackage ../development/python-modules/pydot { };

  pydot_ng = buildPythonPackage rec {
    name = "pydot_ng-1.0.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pydot-ng/${name}.tar.gz";
      sha256 = "0h8k8wlzvnb40v4js7afgfyhp3wasmb1kg4gr6z7ck63iv8fq864";
    };

    buildInputs = [ self.pytest self.unittest2 ];
    propagatedBuildInputs = [ pkgs.graphviz self.pyparsing ];

    checkPhase = ''
      mkdir test/my_tests
      py.test test
    '';

    meta = {
      homepage = "https://pypi.python.org/pypi/pydot-ng";
      description = "Python 3-compatible update of pydot, a Python interface to Graphviz's Dot";
      license = licenses.mit;
      maintainers = [ maintainers.bcdarwin ];
    };
  };

  pyelasticsearch = buildPythonPackage (rec {
    name = "pyelasticsearch-1.4";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pyelasticsearch/${name}.tar.gz";
      sha256 = "18wp6llfjv6hvyhr3f6i8dm9wc5rf46wiqsfxwpvnf6mdrvk6xr7";
    };

    # Tests require a local instance of elasticsearch
    doCheck = false;
    propagatedBuildInputs = with self; [ elasticsearch six simplejson certifi ];
    buildInputs = with self; [ nose mock ];

    meta = {
      description = "A clean, future-proof, high-scale API to elasticsearch";
      homepage = https://pyelasticsearch.readthedocs.org;
      license = licenses.bsd3;
    };
  });

  pyelftools = buildPythonPackage rec {
    pname = "pyelftools";
    version = "0.24";
    name = "${pname}-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/${pname}/${name}.tar.gz";
      sha256 = "17259kf6hwwsmizr5myp9jv3k9g5i3dvmnl8m646pfd5hpb9gpg9";
    };

    checkPhase = ''
      ${python.interpreter} test/all_tests.py
    '';
    # Tests cannot pass against system-wide readelf
    # https://github.com/eliben/pyelftools/issues/65
    doCheck = false;

    meta = {
      description = "A library for analyzing ELF files and DWARF debugging information";
      homepage = https://github.com/eliben/pyelftools;
      license = licenses.publicDomain;
      platforms = platforms.all;
      maintainers = [ maintainers.igsha ];
    };
  };

  pyenchant = buildPythonPackage rec {
    name = "pyenchant-1.6.6";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pyenchant/pyenchant-1.6.6.tar.gz";
      sha256 = "25c9d2667d512f8fc4410465fdd2e868377ca07eb3d56e2b6e534a86281d64d3";
    };

    propagatedBuildInputs = [ pkgs.enchant ];

    patchPhase = let
      path_hack_script = "s|LoadLibrary(e_path)|LoadLibrary('${pkgs.enchant}/lib/' + e_path)|";
    in ''
      sed -i "${path_hack_script}" enchant/_enchant.py

      # They hardcode a bad path for Darwin in their library search code
      substituteInPlace enchant/_enchant.py --replace '/opt/local/lib/' ""
    '';

    # dictionaries needed for tests
    doCheck = false;

    meta = {
      description = "pyenchant: Python bindings for the Enchant spellchecker";
      homepage = https://pythonhosted.org/pyenchant/;
      license = licenses.lgpl21;
    };
  };

  pyev = callPackage ../development/python-modules/pyev { };

  pyexcelerator = buildPythonPackage rec {
    name = "pyexcelerator-${version}";
    version = "0.6.4.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pyexcelerator/${name}.tar.bz2";
      sha256 = "18rcnc9f71lj06h8nppnv6idzb7xfmh2rp1zfqayskcg686lilrb";
    };

    disabled = isPy3k;

    # No tests are included in archive
    doCheck = false;

    meta = {
      description = "library for generating Excel 97/2000/XP/2003 and OpenOffice Calc compatible spreadsheets.";
      homepage = "https://sourceforge.net/projects/pyexcelerator";
      license = licenses.bsdOriginal;
      maintainers = with maintainers; [ womfoo ];
    };
  };

  pyext = callPackage ../development/python-modules/pyext { };

  pyfantom = buildPythonPackage rec {
     name = "pyfantom-${version}";
     version = "unstable-2013-12-18";

     src = pkgs.fetchgit {
       url = "http://git.ni.fr.eu.org/pyfantom.git";
       sha256 = "1m53n8bxslq5zmvcf7i1xzsgq5bdsf1z529br5ypmj5bg0s86j4q";
     };

     # No tests included
     doCheck = false;

     meta = {
       homepage = http://pyfantom.ni.fr.eu.org/;
       description = "Wrapper for the LEGO Mindstorms Fantom Driver";
       license = licenses.gpl2;
     };
   };

  pyfftw = callPackage ../development/python-modules/pyfftw { };

  pyfiglet = callPackage ../development/python-modules/pyfiglet { };

  pyflakes = callPackage ../development/python-modules/pyflakes { };

  pyftgl = callPackage ../development/python-modules/pyftgl { };

  pygeoip = callPackage ../development/python-modules/pygeoip {};

  PyGithub = callPackage ../development/python-modules/pyGithub {};

  pyglet = callPackage ../development/python-modules/pyglet {};

  pygments = callPackage ../development/python-modules/Pygments { };

  # For Pelican 3.6.3
  pygments_2_0 = self.pygments.overrideAttrs( oldAttrs: rec {
    version = "2.0.2";
    name = "Pygments-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/P/Pygments/${name}.tar.gz";
      sha256 = "7320919084e6dac8f4540638a46447a3bd730fca172afc17d2c03eed22cf4f51";
    };
  });

  pygpgme = callPackage ../development/python-modules/pygpgme { };

  pylint = callPackage ../development/python-modules/pylint { };

  pyopencl = callPackage ../development/python-modules/pyopencl { };

  pyproj = callPackage ../development/python-modules/pyproj {
    # pyproj does *work* if you want to use a system supplied proj, but with the current version(s) the tests fail by
    # a few decimal places, so caveat emptor.
    proj = null;
  };

  pyrr = callPackage ../development/python-modules/pyrr { };

  pyshp = callPackage ../development/python-modules/pyshp { };

  pysmbc = callPackage ../development/python-modules/pysmbc { };

  pyspread = callPackage ../development/python-modules/pyspread { };

  pyx = buildPythonPackage rec {
    name = "pyx-${version}";
    version = "0.14.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/P/PyX/PyX-${version}.tar.gz";
      sha256 = "05d1b7fc813379d2c12fcb5bd0195cab522b5aabafac88f72913f1d47becd912";
    };

    disabled = !isPy3k;

    # No tests in archive
    doCheck = false;

    meta = {
      description = "Python package for the generation of PostScript, PDF, and SVG files";
      homepage = http://pyx.sourceforge.net/;
      license = with licenses; [ gpl2 ];
    };
  };

  mmpython = buildPythonPackage rec {
    version = "0.4.10";
    name = "mmpython-${version}";

    src = pkgs.fetchurl {
      url = http://sourceforge.net/projects/mmpython/files/latest/download;
      sha256 = "1b7qfad3shgakj37gcj1b9h78j1hxlz6wp9k7h76pb4sq4bfyihy";
      name = "${name}.tar.gz";
    };

    disabled = isPyPy || isPy3k;

    meta = {
      description = "Media Meta Data retrieval framework";
      homepage = https://sourceforge.net/projects/mmpython/;
      license = licenses.gpl2;
      maintainers = with maintainers; [ ];
    };
  };

  kaa-base = buildPythonPackage rec {
    version = "0.99.2dev-384-2b73caca";
    name = "kaa-base-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/k/kaa-base/kaa-base-0.99.2dev-384-2b73caca.tar.gz";
      sha256 = "0k3zzz84wzz9q1fl3vvqr2ys96z9pcf4viq9q6s2a63zaysmcfd2";
    };

    doCheck = false;

    disabled = isPyPy || isPy3k;

    # Same as in buildPythonPackage except that it does not pass --old-and-unmanageable
    installPhase = ''
      runHook preInstall

      mkdir -p "$out/lib/${python.libPrefix}/site-packages"

      export PYTHONPATH="$out/lib/${python.libPrefix}/site-packages:$PYTHONPATH"

      ${python}/bin/${python.executable} setup.py install \
        --install-lib=$out/lib/${python.libPrefix}/site-packages \
        --prefix="$out"

      eapth="$out/lib/${python.libPrefix}"/site-packages/easy-install.pth
      if [ -e "$eapth" ]; then
          mv "$eapth" $(dirname "$eapth")/${name}.pth
      fi

      rm -f "$out/lib/${python.libPrefix}"/site-packages/site.py*

      runHook postInstall
    '';

    meta = {
      description = "Generic application framework, providing the foundation for other modules";
      homepage = https://github.com/freevo/kaa-base;
      license = licenses.lgpl21;
      maintainers = with maintainers; [ ];
    };
  };

  kaa-metadata = buildPythonPackage rec {
    version = "0.7.8dev-r4569-20111003";
    name = "kaa-metadata-${version}";

    doCheck = false;

    buildInputs = [ pkgs.libdvdread ];

    disabled = isPyPy || isPy3k;

    # Same as in buildPythonPackage except that it does not pass --old-and-unmanageable
    installPhase = ''
      runHook preInstall

      mkdir -p "$out/lib/${python.libPrefix}/site-packages"

      export PYTHONPATH="$out/lib/${python.libPrefix}/site-packages:$PYTHONPATH"

      ${python}/bin/${python.executable} setup.py install \
        --install-lib=$out/lib/${python.libPrefix}/site-packages \
        --prefix="$out"

      eapth="$out/lib/${python.libPrefix}"/site-packages/easy-install.pth
      if [ -e "$eapth" ]; then
          mv "$eapth" $(dirname "$eapth")/${name}.pth
      fi

      rm -f "$out/lib/${python.libPrefix}"/site-packages/site.py*

      runHook postInstall
    '';

    src = pkgs.fetchurl {
      url = "mirror://pypi/k/kaa-metadata/kaa-metadata-0.7.8dev-r4569-20111003.tar.gz";
      sha256 = "0bkbzfgxvmby8lvzkqjp86anxvv3vjd9nksv2g4l7shsk1n7y27a";
    };

    propagatedBuildInputs = with self; [ kaa-base ];

    meta = {
      description = "Python library for parsing media metadata, which can extract metadata (e.g., such as id3 tags) from a wide range of media files";
      homepage = https://github.com/freevo/kaa-metadata;
      license = licenses.gpl2;
      maintainers = with maintainers; [ ];
    };
  };

  PyICU = buildPythonPackage rec {
    name = "PyICU-1.9.7";

    src = pkgs.fetchurl {
      url = "mirror://pypi/P/PyICU/${name}.tar.gz";
      sha256 = "0qavhngmn7c90fz25a8a2k50wd5gzp3vwwjq8v2pkf2hq4fcs9yv";
    };

    buildInputs = [ pkgs.icu self.pytest ];

    propagatedBuildInputs = [ self.six ];

    meta = {
      homepage = https://pypi.python.org/pypi/PyICU/;
      description = "Python extension wrapping the ICU C++ API";
      license = licenses.mit;
      platforms = with platforms; allBut darwin;
      maintainers = [ maintainers.rycee ];
    };
  };

  pyinputevent = buildPythonPackage rec {
    name = "pyinputevent-2016-10-18";

    src = pkgs.fetchFromGitHub {
      owner = "ntzrmtthihu777";
      repo = "pyinputevent";
      rev = "d2075fa5db5d8a402735fe788bb33cf9fe272a5b";
      sha256 = "0rkis0xp8f9jc00x7jb9kbvhdla24z1vl30djqa6wy6fx0cr6sib";
    };

    meta = {
      homepage = "https://github.com/ntzrmtthihu777/pyinputevent";
      description = "Python interface to the Input Subsystem's input_event and uinput";
      license = licenses.bsd3;
      platforms = platforms.linux;
    };
  };

  pyinotify = buildPythonPackage rec {
    name = "pyinotify-${version}";
    version = "0.9.6";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/${name}/${name}.tar.gz";
      sha256 = "1x3i9wmzw33fpkis203alygfnrkcmq9w1aydcm887jh6frfqm6cw";
    };

    # No tests distributed
    doCheck = false;

    meta = {
      homepage = https://github.com/seb-m/pyinotify/wiki;
      description = "Monitor filesystems events on Linux platforms with inotify";
      license = licenses.mit;
      platforms = platforms.linux;
    };
  };

  pyinsane2 = buildPythonPackage rec {
    name = "pyinsane2-${version}";
    version = "2.0.10";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pyinsane2/${name}.tar.gz";
      sha256 = "00d1wqb3w9bn1rxb2dwmdqbar2lr96izq855l5vzprc17dkgip3j";
    };

    postPatch = ''
      # pyinsane2 forks itself, so we need to re-inject the PYTHONPATH.
      sed -i -e '/os.putenv.*PYINSANE_DAEMON/ {
        a \        os.putenv("PYTHONPATH", ":".join(sys.path))
      }' pyinsane2/sane/abstract_proc.py

      sed -i -e 's,"libsane.so.1","${pkgs.sane-backends}/lib/libsane.so",' \
        pyinsane2/sane/rawapi.py
    '';

    # Tests require a scanner to be physically connected, so let's just do a
    # quick check whether initialization works.
    checkPhase = ''
      python -c 'import pyinsane2; pyinsane2.init()'
    '';

    # This is needed by setup.py regardless of whether tests are enabled.
    buildInputs = [ self.nose ];

    propagatedBuildInputs = [ self.pillow ];

    meta = {
      homepage = "https://github.com/jflesch/pyinsane";
      description = "Access and use image scanners";
      license = licenses.gpl3Plus;
      platforms = platforms.linux;
    };
  };

  pyjwt = buildPythonPackage rec {
    version = "1.5.3";
    name = "pyjwt-${version}";

    src = pkgs.fetchFromGitHub {
      owner = "progrium";
      repo = "pyjwt";
      rev = version;
      sha256 = "109zb3ka2lvp00r9nawa0lmljfikvhcj5yny19kcipz8mqia1gs8";
    };

    buildInputs = with self; [ pytestrunner pytestcov pytest coverage ];
    propagatedBuildInputs = with self; [ cryptography ecdsa ];

    # We don't need this specific version
    postPatch = ''
      substituteInPlace setup.py --replace "pytest==2.7.3" "pytest"
    '';

    meta = {
      description = "JSON Web Token implementation in Python";
      longDescription = "A Python implementation of JSON Web Token draft 01";
      homepage = https://github.com/progrium/pyjwt;
      downloadPage = https://github.com/progrium/pyjwt/releases;
      license = licenses.mit;
      maintainers = with maintainers; [ prikhi ];
      platforms = platforms.unix;
    };
  };

  pykickstart = buildPythonPackage rec {
    name = "pykickstart-${version}";
    version = "1.99.39";
    md5_path = "d249f60aa89b1b4facd63f776925116d";

    src = pkgs.fetchurl rec {
      url = "http://pkgs.fedoraproject.org/repo/pkgs/pykickstart/"
          + "${name}.tar.gz/${md5_path}/${name}.tar.gz";
      sha256 = "e0d0f98ac4c5607e6a48d5c1fba2d50cc804de1081043f9da68cbfc69cad957a";
    };

    postPatch = ''
      sed -i -e "s/for tst in tstList/for tst in sorted(tstList, \
                 key=lambda m: m.__name__)/" tests/baseclass.py
    '';

    propagatedBuildInputs = with self; [ urlgrabber ];

    checkPhase = ''
      ${python.interpreter} tests/baseclass.py -vv
    '';

    meta = {
      homepage = "http://fedoraproject.org/wiki/Pykickstart";
      description = "Read and write Fedora kickstart files";
      license = licenses.gpl2Plus;
    };
  };

  pyobjc = if stdenv.isDarwin
    then callPackage ../development/python-modules/pyobjc {}
    else throw "pyobjc can only be built on Mac OS";

  pyodbc = callPackage ../development/python-modules/pyodbc { };

  pyocr = callPackage ../development/python-modules/pyocr { };

  pyparsing = callPackage ../development/python-modules/pyparsing { };

  pyparted = buildPythonPackage rec {
    name = "pyparted-${version}";
    version = "3.10.7";
    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "https://github.com/rhinstaller/pyparted/archive/v${version}.tar.gz";
      sha256 = "0c9ljrdggwawd8wdzqqqzrna9prrlpj6xs59b0vkxzip0jkf652r";
    };

    postPatch = ''
      sed -i -e 's|mke2fs|${pkgs.e2fsprogs}/bin/mke2fs|' tests/baseclass.py
      sed -i -e '
        s|e\.path\.startswith("/tmp/temp-device-")|"temp-device-" in e.path|
      ' tests/test__ped_ped.py
    '' + optionalString stdenv.isi686 ''
      # remove some integers in this test case which overflow on 32bit systems
      sed -i -r -e '/class *UnitGetSizeTestCase/,/^$/{/[0-9]{11}/d}' \
        tests/test__ped_ped.py
    '';

    preConfigure = ''
      PATH="${pkgs.parted}/sbin:$PATH"
    '';

    nativeBuildInputs = [ pkgs.pkgconfig ];

    propagatedBuildInputs = with self; [ pkgs.parted ];

    checkPhase = ''
      patchShebangs Makefile
      make test PYTHON=${python.executable}
    '';

    meta = {
      homepage = "https://fedorahosted.org/pyparted/";
      description = "Python interface for libparted";
      license = licenses.gpl2Plus;
      platforms = platforms.linux;
    };
  };


  pyptlib = buildPythonPackage (rec {
    name = "pyptlib-${version}";
    disabled = isPyPy || isPy3k;
    version = "0.0.6";

    doCheck = false;  # No such file or directory errors on 32bit

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pyptlib/pyptlib-${version}.tar.gz";
      sha256 = "01y6vbwncqb0hxlnin6whd9wrrm5my4qzjhk76fnix78v7ip515r";
    };
    meta = {
      description = "A python implementation of the Pluggable Transports for Circumvention specification for Tor";
      license = licenses.bsd2;
    };
  });

  pyqtgraph = buildPythonPackage rec {
    name = "pyqtgraph-${version}";
    version = "0.9.10";

    doCheck = false;  # "PyQtGraph requires either PyQt4 or PySide; neither package could be imported."

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pyqtgraph/${name}.tar.gz";
      sha256 = "188pcxf3sxxjf0aipjn820lx2rf9f42zzp0sibmcl90955a3ipf1";
    };

    propagatedBuildInputs = with self; [ scipy numpy pyqt4 pyopengl ];

    meta = {
      description = "Scientific Graphics and GUI Library for Python";
      homepage = http://www.pyqtgraph.org/;
      license = licenses.mit;
      platforms = platforms.unix;
      maintainers = with maintainers; [ koral ];
    };
  };

  pystache = buildPythonPackage rec {
    name = "pystache-${version}";
    version = "0.5.4";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pystache/${name}.tar.gz";
      sha256 = "f7bbc265fb957b4d6c7c042b336563179444ab313fb93a719759111eabd3b85a";
    };

    LC_ALL = "en_US.UTF-8";

    buildInputs = [ pkgs.glibcLocales ];

    checkPhase = ''
      ${python.interpreter} -m unittest discover
    '';

    # SyntaxError Python 3
    # https://github.com/defunkt/pystache/issues/181
    doCheck = !isPy3k;

    meta = {
      description = "A framework-agnostic, logic-free templating system inspired by ctemplate and et";
      homepage = https://github.com/defunkt/pystache;
      license = licenses.mit;
    };
  };

  PyStemmer = buildPythonPackage (rec {
    name = "PyStemmer-1.3.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/P/PyStemmer/${name}.tar.gz";
      sha256 = "d1ac14eb64978c1697fcfba76e3ac7ebe24357c9428e775390f634648947cb91";
    };

    checkPhase = ''
      ${python.interpreter} runtests.py
    '';

    meta = {
      description = "Snowball stemming algorithms, for information retrieval";
      homepage = http://snowball.tartarus.org/;
      license = licenses.mit;
      platforms = platforms.unix;
    };
  });

  Pyro = callPackage ../development/python-modules/pyro { };

  pyrsistent = buildPythonPackage (rec {
    name = "pyrsistent-0.11.12";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pyrsistent/${name}.tar.gz";
      sha256 = "0jgyhkkq36wn36rymn4jiyqh2vdslmradq4a2mjkxfbk2cz6wpi5";
    };

    propagatedBuildInputs = with self; [ six ];
    buildInputs = with self; [ pytest hypothesis ];

    checkPhase = ''
      py.test
    '';

    meta = {
      homepage = https://github.com/tobgu/pyrsistent/;
      description = "Persistent/Functional/Immutable data structures";
      license = licenses.mit;
      maintainers = with maintainers; [ desiderius ];
    };
  });

  PyRSS2Gen = buildPythonPackage (rec {
    pname = "PyRSS2Gen";
    version = "1.1";
    name = "${pname}-${version}";

    src = fetchPypi {
      inherit pname version;
      sha256 = "1rvf5jw9hknqz02rp1vg8abgb1lpa0bc65l7ylmlillqx7bswq3r";
    };

    # No tests in archive
    doCheck = false;

    meta = {
      homepage = http://www.dalkescientific.om/Python/PyRSS2Gen.html;
      description = "Library for generating RSS 2.0 feeds";
      license = licenses.bsd2;
      maintainers = with maintainers; [ domenkozar ];
    };
  });

  pysmi = buildPythonPackage rec {
    version = "0.0.7";
    name = "pysmi-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pysmi/${name}.tar.gz";
      sha256 = "05h1lv2a687b9qjc399w6728ildx7majbn338a0c4k3gw6wnv7wr";
    };

    # Tests require pysnmp, which in turn requires pysmi => infinite recursion
    doCheck = false;

    propagatedBuildInputs = with self; [ ply ];

    meta = {
      homepage = http://pysmi.sf.net;
      description = "SNMP SMI/MIB Parser";
      license = licenses.bsd2;
      platforms = platforms.all;
      maintainers = with maintainers; [ koral ];
    };
  };

  pysnmp = buildPythonPackage rec {
    version = "4.3.2";
    name = "pysnmp-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pysnmp/${name}.tar.gz";
      sha256 = "0xw925f3p02vdpb3f0ls60qj59w44aiyfs3s0nhdr9vsy4fxhavw";
    };

    # NameError: name 'mibBuilder' is not defined
    doCheck = false;

    propagatedBuildInputs = with self; [ pyasn1 pycrypto pysmi ];

    meta = {
      homepage = http://pysnmp.sf.net;
      description = "A pure-Python SNMPv1/v2c/v3 library";
      license = licenses.bsd2;
      platforms = platforms.all;
      maintainers = with maintainers; [ koral ];
    };
  };

  pysocks = buildPythonPackage rec {
    name = "pysocks-${version}";
    version = "1.6.6";

    src = pkgs.fetchurl {
      url    = "mirror://pypi/P/PySocks/PySocks-${version}.tar.gz";
      sha256 = "0h9zwr8z9j6l313ns335irjrkk6qnk4qzvwmjqygrp7mbwi9lh82";
    };

    doCheck = false;

    meta = {
      description = "SOCKS module for Python";
      license     = licenses.bsd3;
      maintainers = with maintainers; [ thoughtpolice ];
    };
  };

  python_fedora = callPackage ../development/python-modules/python_fedora/default.nix {};

  python-simple-hipchat = callPackage ../development/python-modules/python-simple-hipchat {};
  python_simple_hipchat = self.python-simple-hipchat;

  python_keyczar = buildPythonPackage rec {
    name = "python-keyczar-0.71c";

    src = pkgs.fetchurl {
      url    = "mirror://pypi/p/python-keyczar/${name}.tar.gz";
      sha256 = "18mhiwqq6vp65ykmi8x3i5l3gvrvrrr8z2kv11z1rpixmyr7sw1p";
    };

    meta = {
      description = "Toolkit for safe and simple cryptography";
      homepage    = https://pypi.python.org/pypi/python-keyczar;
      license     = licenses.asl20;
      maintainers = with maintainers; [ lovek323 ];
      platforms   = platforms.unix;
    };

    buildInputs = with self; [ pyasn1 pycrypto ];
  };

  pyudev = callPackage ../development/python-modules/pyudev {
    inherit (pkgs) fetchurl systemd;
  };

  pynzb = buildPythonPackage (rec {
    name = "pynzb-0.1.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pynzb/${name}.tar.gz";
      sha256 = "0735b3889a1174bbb65418ee503629d3f5e4a63f04b16f46ffba18253ec3ef17";
    };

    # Can't get them working
    doCheck = false;
    checkPhase = ''
      ${python.interpreter} -m unittest -s pynzb -t .
    '';

    meta = {
      homepage = https://github.com/ericflo/pynzb;
      description = "Unified API for parsing NZB files";
      license = licenses.bsd3;
      maintainers = with maintainers; [ domenkozar ];
    };
  });

  process-tests = buildPythonPackage rec {
    pname = "process-tests";
    name = "${pname}-${version}";
    version = "1.2.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/${pname}/${name}.tar.gz";
      sha256 = "65c9d7a0260f31c15b4a22a851757e61f7072d0557db5f8a976112fbe81ff7e9";
    };

    # No tests
    doCheck = false;

    meta = {
      description = "Tools for testing processes";
      license = licenses.bsd2;
      homepage = https://github.com/ionelmc/python-process-tests;
    };
  };

  progressbar = buildPythonPackage (rec {
    name = "progressbar-2.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/progressbar/${name}.tar.gz";
      sha256 = "dfee5201237ca0e942baa4d451fee8bf8a54065a337fabe7378b8585aeda56a3";
    };

    # invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://code.google.com/p/python-progressbar/;
      description = "Text progressbar library for python";
      license = licenses.lgpl3Plus;
      maintainers = with maintainers; [ domenkozar ];
    };
  });

  ldap = callPackage ../development/python-modules/ldap {
    inherit (pkgs) openldap cyrus_sasl openssl;
  };

  ldap3 = callPackage ../development/python-modules/ldap3 {};

  ptest = buildPythonPackage rec {
    name = pname + "-" + version;
    pname = "ptest";
    version =  "1.5.3";
    src = pkgs.fetchFromGitHub {
      owner = "KarlGong";
      repo = pname;
      rev = version + "-release";
      sha256 = "1r50lm6n59jzdwpp53n0c0hp3aj1jxn304bk5gh830226gsaf2hn";
    };
    meta = {
      description = "Test classes and test cases using decorators, execute test cases by command line, and get clear reports";
      homepage = https://pypi.python.org/pypi/ptest;
      license = licenses.asl20;
    };
  };

  ptyprocess = buildPythonPackage rec {
    name = "ptyprocess-${version}";
    version = "0.5";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/ptyprocess/${name}.tar.gz";
      sha256= "dcb78fb2197b49ca1b7b2f37b047bc89c0da7a90f90bd5bc17c3ce388bb6ef59";
    };

    meta = {
      description = "Run a subprocess in a pseudo terminal";
      homepage = https://github.com/pexpect/ptyprocess;
      license = licenses.isc;
    };
  };

  pylibacl = callPackage ../development/python-modules/pylibacl { };

  pyliblo = buildPythonPackage rec {
    name = "pyliblo-${version}";
    version = "0.9.2";

    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "http://das.nasophon.de/download/${name}.tar.gz";
      sha256 = "382ee7360aa00aeebf1b955eef65f8491366657a626254574c647521b36e0eb0";
    };

    propagatedBuildInputs = with self ; [ pkgs.liblo ];

    meta = {
      homepage = http://das.nasophon.de/pyliblo/;
      description = "Python wrapper for the liblo OSC library";
      license = licenses.lgpl21;
    };
  };

  pypcap = callPackage ../development/python-modules/pypcap {};

  pyplatec = buildPythonPackage rec {
    name = "PyPlatec-${version}";
    version = "1.4.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/P/PyPlatec/${name}.tar.gz";
      sha256 = "0kqx33flcrrlipccmqs78d14pj5749bp85b6k5fgaq2c7yzz02jg";
    };

    meta = {
      description = "Library to simulate plate tectonics with Python bindings";
      homepage    = https://github.com/Mindwerks/plate-tectonics;
      license     = licenses.lgpl3;
    };
  };

  purepng = buildPythonPackage rec {
    name = "purepng-${version}";
    version = "0.2.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/purepng/${name}.tar.gz";
      sha256 = "1kcl7a6d7d59360fbz2jwfk6ha6pmqgn396962p4s62j893d2r0d";
    };

    meta = {
      description = "Pure Python library for PNG image encoding/decoding";
      homepage    = https://github.com/scondo/purepng;
      license     = licenses.mit;
    };
  };

  pymaging = buildPythonPackage rec {
    name = "pymaging-unstable-2016-11-16";

    src = pkgs.fetchFromGitHub {
      owner = "ojii";
      repo = "pymaging";
      rev = "596a08fce5664e58d6e8c96847393fbe987783f2";
      sha256 = "18g3n7kfrark30l4vzykh0gdbnfv5wb1zvvjbs17sj6yampypn38";
    };

    meta = {
      description = "Pure Python imaging library with Python 2.6, 2.7, 3.1+ support";
      homepage    = http://pymaging.rtfd.org;
      license     = licenses.mit;
      maintainers = with maintainers; [ mic92 ];
    };
  };

  pymaging_png = buildPythonPackage rec {
    name = "pymaging-png-unstable-2016-11-16";

    src = pkgs.fetchFromGitHub {
      owner = "ojii";
      repo = "pymaging-png";
      rev = "83d85c44e4b2342818e6c068065e031a9f81bb9f";
      sha256 = "1mknxvsq0lr1ffm8amzm3w2prn043c6ghqgpxlkw83r988p5fn57";
    };

    propagatedBuildInputs = with self; [ pymaging ];

    meta = {
      description = "Pure Python imaging library with Python 2.6, 2.7, 3.1+ support";
      homepage    = https://github.com/ojii/pymaging-png/;
      license     = licenses.mit;
      maintainers = with maintainers; [ mic92 ];
    };
  };

  pyPdf = buildPythonPackage rec {
    name = "pyPdf-1.13";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pyPdf/${name}.tar.gz";
      sha256 = "3aede4c3c9c6ad07c98f059f90db0b09ed383f7c791c46100f649e1cabda0e3b";
    };

    buildInputs = with self; [ ];

    # Not supported. Package is no longer maintained.
    disabled = isPy3k;

    meta = {
      description = "Pure-Python PDF toolkit";
      homepage = "http://pybrary.net/pyPdf/";
      license = licenses.bsd3;
    };
  };

  pypdf2 = buildPythonPackage rec {
    name = "PyPDF2-${version}";
    version = "1.26.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/P/PyPDF2/${name}.tar.gz";
      sha256 = "11a3aqljg4sawjijkvzhs3irpw0y67zivqpbjpm065ha5wpr13z2";
    };

    LC_ALL = "en_US.UTF-8";
    buildInputs = [ pkgs.glibcLocales ];

    checkPhase = ''
      ${python.interpreter} -m unittest discover -s Tests
    '';

    # Tests broken on Python 3.x
    doCheck = !(isPy3k);

    meta = {
      description = "A Pure-Python library built as a PDF toolkit";
      homepage = "http://mstamy2.github.com/PyPDF2/";
      license = licenses.bsd3;
      maintainers = with maintainers; [ desiderius vrthra ];
    };
  };

  pyopengl = buildPythonPackage rec {
    name = "pyopengl-${version}";
    version = "3.1.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/P/PyOpenGL/PyOpenGL-${version}.tar.gz";
      sha256 = "9b47c5c3a094fa518ca88aeed35ae75834d53e4285512c61879f67a48c94ddaf";
    };
    propagatedBuildInputs = [ pkgs.mesa pkgs.freeglut self.pillow ];
    patchPhase = ''
      sed -i "s|util.find_library( name )|name|" OpenGL/platform/ctypesloader.py
      sed -i "s|'GL',|'libGL.so',|" OpenGL/platform/glx.py
      sed -i "s|'GLU',|'${pkgs.mesa}/lib/libGLU.so',|" OpenGL/platform/glx.py
      sed -i "s|'glut',|'${pkgs.freeglut}/lib/libglut.so',|" OpenGL/platform/glx.py
    '';
    meta = {
      homepage = http://pyopengl.sourceforge.net/;
      description = "PyOpenGL, the Python OpenGL bindings";
      longDescription = ''
        PyOpenGL is the cross platform Python binding to OpenGL and
        related APIs.  The binding is created using the standard (in
        Python 2.5) ctypes library, and is provided under an extremely
        liberal BSD-style Open-Source license.
      '';
      license = "BSD-style";
      platforms = platforms.mesaPlatforms;
    };

    # Need to fix test runner
    # Tests have many dependencies
    # Extension types could not be found.
    # Should run test suite from $out/${python.sitePackages}
    doCheck = false;
  };

  pyopenssl = buildPythonPackage rec {
    pname = "pyOpenSSL";
    name = "${pname}-${version}";
    version = "17.2.0";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "0d283g4zi0hr9papd24mjl70mi15gyzq6fx618rizi87dgipqqax";
    };

    outputs = [ "out" "dev" ];

    preCheck = ''
      sed -i 's/test_set_default_verify_paths/noop/' tests/test_ssl.py
      # https://github.com/pyca/pyopenssl/issues/692
      sed -i 's/test_fallback_default_verify_paths/noop/' tests/test_ssl.py
    '';

    checkPhase = ''
      runHook preCheck
      export LANG="en_US.UTF-8"
      py.test
      runHook postCheck
    '';

    # Seems to fail unpredictably on Darwin. See http://hydra.nixos.org/build/49877419/nixlog/1
    # for one example, but I've also seen ContextTests.test_set_verify_callback_exception fail.
    doCheck = !stdenv.isDarwin;

    buildInputs = [ pkgs.openssl self.pytest pkgs.glibcLocales self.pretend self.flaky ];
    propagatedBuildInputs = [ self.cryptography self.pyasn1 self.idna ];
  };


  pyquery = buildPythonPackage rec {
    name = "pyquery-${version}";
    version = "1.2.9";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pyquery/${name}.zip";
      sha256 = "00p6f1dfma65192hc72dxd506491lsq3g5wgxqafi1xpg2w1xia6";
    };

    propagatedBuildInputs = with self; [ cssselect lxml webob ];
    # circular dependency on webtest
    doCheck = false;
  };

  rackspace-novaclient = callPackage ../development/python-modules/rackspace-novaclient { };

  pyrax = callPackage ../development/python-modules/pyrax {
    glibcLocales = pkgs.glibcLocales;
  };

  pyreport = buildPythonPackage (rec {
    name = "pyreport-0.3.4c";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pyreport/${name}.tar.gz";
      sha256 = "1584607596b7b310bf0b6ce79f424bd44238a017fd870aede11cd6732dbe0d4d";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = https://pypi.python.org/pypi/pyreport;
      license = "BSD";
      description = "Pyreport makes notes out of a python script";
    };
  });

  pyscss = buildPythonPackage rec {
    name = "pyScss-${version}";
    version = "1.3.5";

    src = pkgs.fetchFromGitHub {
      sha256 = "0lfsan74vcw6dypb196gmbprvlbran8p7w6czy8hyl2b1l728mhz";
      rev = "v1.3.5";
      repo = "pyScss";
      owner = "Kronuz";
    };

    checkInputs = with self; [ pytest ];

    propagatedBuildInputs = with self; [ six ]
      ++ (optionals (pythonOlder "3.4") [ enum34 pathlib ])
      ++ (optionals (pythonOlder "2.7") [ ordereddict ]);

    checkPhase = ''
      py.test
    '';

    meta = {
      description = "A Scss compiler for Python";
      homepage = http://pyscss.readthedocs.org/en/latest/;
      license = licenses.mit;
    };
  };

  pyserial = callPackage ../development/python-modules/pyserial {};

  pymongo = callPackage ../development/python-modules/pymongo {};

  pymongo_2_9_1 = buildPythonPackage rec {
    name = "pymongo-2.9.1";
    version = "2.9.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pymongo/${name}.tar.gz";
      sha256 = "1nrr1fxyrlxd69bgxl7bvaj2j4z7v3zaciij5sbhxg0vqiz6ny50";
    };

    # Tests call a running mongodb instance
    doCheck = false;

    meta = {
      homepage = "http://github.com/mongodb/mongo-python-driver";
      license = licenses.asl20;
      description = "Python driver for MongoDB ";
    };
  };

  pyperclip = buildPythonPackage rec {
    version = "1.5.27";
    name = "pyperclip-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pyperclip/${name}.zip";
      sha256 = "1i9zxm7qc49n9yxfb41c0jbmmp2hpzx98kaizjl7qmgiv3snvjx3";
    };

    doCheck = false;

    meta = {
      homepage = "https://github.com/asweigart/pyperclip";
      license = licenses.bsdOriginal;
      description = "Cross-platform clipboard module";
    };
  };

  pysphere = buildPythonPackage rec {
    name = "pysphere-0.1.8";

    src = pkgs.fetchurl {
      url = "http://pysphere.googlecode.com/files/${name}.zip";
      sha256 = "b3f9ba1f67afb17ac41725b01737cd42e8a39d9e745282dd9b692ae631af0add";
    };

    disabled = isPy3k;

    meta = {
      homepage    = "https://code.google.com/p/pysphere/";
      license     = "BSD";
      description = "Python API for interaction with the VMWare vSphere";
    };
  };

  pysqlite = buildPythonPackage rec {
    name = "pysqlite-2.8.3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pysqlite/${name}.tar.gz";
      sha256 = "17d3335863e8cf8392eea71add33dab3f96d060666fe68ab7382469d307f4490";
    };

    # Need to use the builtin sqlite3 on Python 3
    disabled = isPy3k;

    # Since the `.egg' file is zipped, the `NEEDED' of the `.so' files
    # it contains is not taken into account.  Thus, we must explicitly make
    # it a propagated input.
    propagatedBuildInputs = with self; [ pkgs.sqlite ];

    patchPhase = ''
      substituteInPlace "setup.cfg"                                     \
              --replace "/usr/local/include" "${pkgs.sqlite.dev}/include"   \
              --replace "/usr/local/lib" "${pkgs.sqlite.out}/lib"
    '';

    meta = {
      homepage = http://pysqlite.org/;
      description = "Python bindings for the SQLite embedded relational database engine";
      longDescription = ''
        pysqlite is a DB-API 2.0-compliant database interface for SQLite.

        SQLite is a relational database management system contained in
        a relatively small C library.  It is a public domain project
        created by D. Richard Hipp.  Unlike the usual client-server
        paradigm, the SQLite engine is not a standalone process with
        which the program communicates, but is linked in and thus
        becomes an integral part of the program.  The library
        implements most of SQL-92 standard, including transactions,
        triggers and most of complex queries.

        pysqlite makes this powerful embedded SQL engine available to
        Python programmers.  It stays compatible with the Python
        database API specification 2.0 as much as possible, but also
        exposes most of SQLite's native API, so that it is for example
        possible to create user-defined SQL functions and aggregates
        in Python.
      '';
      license = licenses.bsd3;
      maintainers = [ ];
    };
  };


  pysvn = buildPythonPackage rec {
    name = "pysvn-1.8.0";
    format = "other";

    src = pkgs.fetchurl {
      url = "http://pysvn.barrys-emacs.org/source_kits/${name}.tar.gz";
      sha256 = "0srjr2qgxfs69p65d9vvdib2lc142x10w8afbbdrqs7dhi46yn9r";
    };

    buildInputs = with self; [ pkgs.subversion pkgs.apr pkgs.aprutil pkgs.expat pkgs.neon pkgs.openssl ]
      ++ (if stdenv.isLinux then [pkgs.e2fsprogs] else []);

    # There seems to be no way to pass that path to configure.
    NIX_CFLAGS_COMPILE="-I${pkgs.aprutil.dev}/include/apr-1";

    preConfigure = ''
      cd Source
      ${python.interpreter} setup.py backport
      ${python.interpreter} setup.py configure \
        --apr-inc-dir=${pkgs.apr.dev}/include \
        --apu-inc-dir=${pkgs.aprutil.dev}/include \
        --apr-lib-dir=${pkgs.apr.out}/lib \
        --svn-lib-dir=${pkgs.subversion.out}/lib \
        --svn-bin-dir=${pkgs.subversion.out}/bin \
        --svn-root-dir=${pkgs.subversion.dev}
    '' + (if !stdenv.isDarwin then "" else ''
      sed -i -e 's|libpython2.7.dylib|lib/libpython2.7.dylib|' Makefile
    '');

    checkPhase = "make -C ../Tests";

    disabled = isPy3k;

    installPhase = ''
      dest=$(toPythonPath $out)/pysvn
      mkdir -p $dest
      cp pysvn/__init__.py $dest/
      cp pysvn/_pysvn*.so $dest/
      mkdir -p $out/share/doc
      mv -v ../Docs $out/share/doc/pysvn-1.7.2
      rm -v $out/share/doc/pysvn-1.7.2/generate_cpp_docs_from_html_docs.py
    '';

    meta = {
      description = "Python bindings for Subversion";
      homepage = "http://pysvn.tigris.org/";
    };
  };

  python-wifi = buildPythonPackage rec {
    name = "python-wifi-${version}";
    version = "0.6.0";
    disabled = ! (isPy26 || isPy27 );

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/python-wifi/${name}.tar.bz2";
      sha256 = "504639e5953eaec0e41758900fbe143d33d82ea86762b19b659a118c77d8403d";
    };

    meta = {
      inherit version;
      description = "Read & write wireless card capabilities using the Linux Wireless Extensions";
      homepage = http://pythonwifi.tuxfamily.org/;
      # From the README: "pythonwifi is licensed under LGPLv2+, however, the
      # examples (e.g. iwconfig.py and iwlist.py) are licensed under GPLv2+."
      license = with licenses; [ lgpl2Plus gpl2Plus ];
      maintainers = with maintainers; [ nckx ];
    };
  };

  python-etcd = buildPythonPackage rec {
    name = "python-etcd-${version}";
    version = "0.4.3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/python-etcd/${name}.tar.gz";
      sha256 = "cf53262b3890d185fe637eed15fe39c8d7a8261864ddcd7037b22c961456d7fc";
    };

    buildInputs = with self; [ nose mock pyopenssl ];

    propagatedBuildInputs = with self; [ urllib3 dns];

    postPatch = ''
      sed -i '19s/dns/"dnspython"/' setup.py
    '';

    # Some issues with etcd not in path even though most tests passed
    doCheck = false;

    meta = {
      description = "A python client for Etcd";
      homepage = https://github.com/jplana/python-etcd;
      license = licenses.mit;
    };
  };

  pytz = buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "pytz";
    version = "2017.2";

    src = fetchPypi {
      inherit pname version;
      sha256 = "12cmd3j46d2gcw08bspvp6s9icfcvx88zjz52n1bli9dyvl5dh7m";
      extension = "zip";
    };

    checkPhase = ''
      python -m unittest discover -s pytz/tests
    '';

    meta = {
      description = "World timezone definitions, modern and historical";
      homepage = "http://pythonhosted.org/pytz";
      license = licenses.mit;
    };
  };

  pyutil = buildPythonPackage (rec {
    name = "pyutil-2.0.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pyutil/${name}.tar.gz";
      sha256 = "1fsg9yz5mi2sb0h6c1vvcqchx56i89nbvdb5gfgv1ia3b2w5ra8c";
    };

    buildInputs = with self; [ setuptoolsDarcs setuptoolsTrial ] ++ (if doCheck then [ simplejson ] else []);
    propagatedBuildInputs = with self; [ zbase32 argparse twisted ];
    # Tests fail because they try to write new code into the twisted
    # package, apparently some kind of plugin.
    doCheck = false;

    prePatch = optionalString isPyPy ''
      grep -rl 'utf-8-with-signature-unix' ./ | xargs sed -i -e "s|utf-8-with-signature-unix|utf-8|g"
    '';

    meta = {
      description = "Pyutil, a collection of mature utilities for Python programmers";

      longDescription = ''
        These are a few data structures, classes and functions which
        we've needed over many years of Python programming and which
        seem to be of general use to other Python programmers. Many of
        the modules that have existed in pyutil over the years have
        subsequently been obsoleted by new features added to the
        Python language or its standard library, thus showing that
        we're not alone in wanting tools like these.
      '';

      homepage = http://allmydata.org/trac/pyutil;

      license = licenses.gpl2Plus;
    };
  });


  pywebkitgtk = buildPythonPackage rec {
    name = "pywebkitgtk-${version}";
    version = "1.1.8";
    format = "other";

    src = pkgs.fetchurl {
      url = "http://pywebkitgtk.googlecode.com/files/${name}.tar.bz2";
      sha256 = "1svlwyl61rvbqbcbalkg6pbf38yjyv7qkq9sx4x35yk69lscaac2";
    };

    nativeBuildInputs = [ pkgs.pkgconfig ];
    buildInputs = [
      pkgs.gtk2 self.pygtk pkgs.libxml2
      pkgs.libxslt pkgs.libsoup pkgs.webkitgtk24x-gtk2 pkgs.icu
    ];

    meta = {
      homepage = "https://code.google.com/p/pywebkitgtk/";
      description = "Python bindings for the WebKit GTK+ port";
      license = licenses.lgpl2Plus;
    };
  };

  pywinrm = callPackage ../development/python-modules/pywinrm { };

  pyxattr = callPackage ../development/python-modules/pyxattr { };

  pyaml = buildPythonPackage (rec {
    name = "pyaml-15.02.1";
    disabled = !isPy27;

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pyaml/${name}.tar.gz";
      sha256 = "8dfe1b295116115695752acc84d15ecf5c1c469975fbed7672bf41a6bc6d6d51";
    };

    buildInputs = with self; [ pyyaml ];

    meta = {
      description = "PyYAML-based module to produce pretty and readable YAML-serialized data";
      homepage = https://github.com/mk-fg/pretty-yaml;
    };
  });


  pyyaml = buildPythonPackage (rec {
    name = "PyYAML-3.12";

    src = pkgs.fetchurl {
      url = "http://pyyaml.org/download/pyyaml/${name}.zip";
      sha256 = "19s1lxi0idq4a0bpvld866pv5b16lqxypyswmsdi5ys4210jxj2s";
    };

    buildInputs = with self; [ pkgs.pyrex ];
    propagatedBuildInputs = with self; [ pkgs.libyaml ];

    meta = {
      description = "The next generation YAML parser and emitter for Python";
      homepage = http://pyyaml.org;
      license = licenses.free; # !?
    };
  });

  rabbitpy = buildPythonPackage rec {
    version = "0.26.2";
    name = "rabbitpy-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/r/rabbitpy/${name}.tar.gz";
      sha256 = "0pgijv7mgxc4sm7p9s716dhl600l8isisxzyg4hz7ng1sk09p1w3";
    };

    buildInputs = with self; [ mock nose ];

    propagatedBuildInputs = with self; [ pamqp ];

    meta = {
      description = "A pure python, thread-safe, minimalistic and pythonic RabbitMQ client library";
      homepage = https://pypi.python.org/pypi/rabbitpy;
      license = licenses.bsd3;
    };
  };

  radicale_infcloud = callPackage ../development/python-modules/radicale_infcloud {};

  recaptcha_client = buildPythonPackage rec {
    name = "recaptcha-client-1.0.6";

    src = pkgs.fetchurl {
      url = "mirror://pypi/r/recaptcha-client/${name}.tar.gz";
      sha256 = "28c6853c1d13d365b7dc71a6b05e5ffb56471f70a850de318af50d3d7c0dea2f";
    };

    disabled = isPy35 || isPy36;

    meta = {
      description = "A CAPTCHA for Python using the reCAPTCHA service";
      homepage = http://recaptcha.net/;
    };
  };

  rbtools = buildPythonPackage rec {
    name = "rbtools-0.7.2";

    src = pkgs.fetchurl {
      url = "http://downloads.reviewboard.org/releases/RBTools/0.7/RBTools-0.7.2.tar.gz";
      sha256 = "1ng8l8cx81cz23ls7fq9wz4ijs0zbbaqh4kj0mj6plzcqcf8na4i";
    };

    buildInputs = with self; [ nose ];
    propagatedBuildInputs = with self; [ six ];

    checkPhase = "nosetests";

    disabled = isPy3k;

    meta = {
      maintainers = with maintainers; [ domenkozar ];
    };
  };

  rencode = buildPythonPackage rec {
    name = "rencode-${version}";
    version = "git20150810";
    disabled = isPy33;

    src = pkgs.fetchgit {
      url = https://github.com/aresch/rencode;
      rev = "b45e04abdca0dea36e383a8199783269f186c99e";
      sha256 = "b4bd82852d4220e8a9493d3cfaecbc57b1325708a2d48c0f8acf262edb10dc40";
    };

    buildInputs = with self; [ cython ];

    meta = {
      homepage = https://github.com/aresch/rencode;
      description = "Fast (basic) object serialization similar to bencode";
      license = licenses.gpl3;
    };
  };

  reportlab = callPackage ../development/python-modules/reportlab { };

  requests2 = throw "requests2 has been deprecated. Use requests instead.";

  # use requests, not requests_2
  requests = callPackage ../development/python-modules/requests { };

  requests_download = callPackage ../development/python-modules/requests_download { };

  requestsexceptions = callPackage ../development/python-modules/requestsexceptions {};

  requests_ntlm = callPackage ../development/python-modules/requests_ntlm { };

  requests_oauthlib = callPackage ../development/python-modules/requests-oauthlib { };

  requests-toolbelt = callPackage ../development/python-modules/requests-toolbelt { };
  requests_toolbelt = self.requests-toolbelt; # Old attr, 2017-09-26

  retry_decorator = buildPythonPackage rec {
    name = "retry_decorator-1.0.0";
    src = pkgs.fetchurl {
      url = mirror://pypi/r/retry_decorator/retry_decorator-1.0.0.tar.gz;
      sha256 = "086zahyb6yn7ggpc58909c5r5h3jz321i1694l1c28bbpaxnlk88";
    };
    meta = {
      homepage = https://github.com/pnpnpn/retry-decorator;
      license = licenses.mit;
    };
  };

  qscintilla = if isPy3k || isPyPy
    then throw "qscintilla-${pkgs.qscintilla.version} not supported for interpreter ${python.executable}"
    else buildPythonPackage rec {
      # TODO: Qt5 support
      name = "qscintilla-${version}";
      version = pkgs.qscintilla.version;
      format = "other";

      src = pkgs.qscintilla.src;

      buildInputs = with self; [ pkgs.xorg.lndir pyqt4.qt pyqt4 ];

      preConfigure = ''
        mkdir -p $out
        lndir ${self.pyqt4} $out
        rm -rf "$out/nix-support"
        cd Python
        ${python.executable} ./configure-old.py \
            --destdir $out/lib/${python.libPrefix}/site-packages/PyQt4 \
            --apidir $out/api/${python.libPrefix} \
            -n ${pkgs.qscintilla}/include \
            -o ${pkgs.qscintilla}/lib \
            --sipdir $out/share/sip
      '';

      meta = with stdenv.lib; {
        description = "A Python binding to QScintilla, Qt based text editing control";
        license = licenses.lgpl21Plus;
        maintainers = with maintainers; [ danbst ];
        platforms = platforms.linux;
      };
    };


  qserve = buildPythonPackage rec {
    name = "qserve-0.2.8";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/q/qserve/${name}.zip";
      sha256 = "0b04b2d4d11b464ff1efd42a9ea9f8136187d59f4076f57c9ba95361d41cd7ed";
    };

    buildInputs = with self; [ ];

    meta = {
      description = "Job queue server";
      homepage = "https://github.com/pediapress/qserve";
      license = licenses.bsd3;
    };
  };

  qtawesome = callPackage ../development/python-modules/qtawesome { };

  qtconsole = callPackage ../development/python-modules/qtconsole { };

  qtpy = callPackage ../development/python-modules/qtpy { };

  quantities = buildPythonPackage rec {
    name = "quantities-0.10.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/q/quantities/quantities-0.10.1.tar.gz";
      sha256 = "2d27caf31a5e0c37130ac0c14bfa8f9412a5ff1fbf3378a1d6085594776c4315";
    };

    meta = with pkgs.stdenv.lib; {
      description = "Quantities is designed to handle arithmetic and";
      homepage = http://packages.python.org/quantities;
      license = licenses.bsd2;
    };
  };

  qutip = buildPythonPackage rec {
    name = "qutip-2.2.0";

    src = pkgs.fetchurl {
      url = "https://qutip.googlecode.com/files/QuTiP-2.2.0.tar.gz";
      sha256 = "a26a639d74b2754b3a1e329d91300e587e8c399d8a81d8f18a4a74c6d6f02ba3";
    };

    propagatedBuildInputs = with self; [ numpy scipy matplotlib pyqt4
      cython ];

    buildInputs = [ pkgs.gcc pkgs.qt4 pkgs.blas self.nose ];

    meta = {
      description = "QuTiP - Quantum Toolbox in Python";
      longDescription = ''
        QuTiP is open-source software for simulating the dynamics of
        open quantum systems. The QuTiP library depends on the
        excellent Numpy and Scipy numerical packages. In addition,
        graphical output is provided by Matplotlib. QuTiP aims to
        provide user-friendly and efficient numerical simulations of a
        wide variety of Hamiltonians, including those with arbitrary
        time-dependence, commonly found in a wide range of physics
        applications such as quantum optics, trapped ions,
        superconducting circuits, and quantum nanomechanical
        resonators.
      '';
      homepage = http://qutip.org/;
    };
  };

  rcssmin = callPackage ../development/python-modules/rcssmin { };

  recommonmark = callPackage ../development/python-modules/recommonmark { };

  redis = callPackage ../development/python-modules/redis { };

  rednose = buildPythonPackage rec {
    name = "rednose-${version}";
    version = "1.2.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/r/rednose/${name}.tar.gz";
      sha256 = "0b0bsna217lr1nykyhl5fgjly15zhdvqd4prg4wy1zrgfv7al6m0";
    };

    meta = {
      description = "A python nose plugin adding color to console results.";
    };

    buildInputs = with self; [ nose six ];
    propagatedBuildInputs = with self; [ colorama termstyle ];
  };

  reikna = callPackage ../development/python-modules/reikna { };

  repocheck = buildPythonPackage rec {
    name = "repocheck-2015-08-05";
    disabled = isPy26 || isPy27;

    src = pkgs.fetchFromGitHub {
      sha256 = "1jc4v5zy7z7xlfmbfzvyzkyz893f5x2k6kvb3ni3rn2df7jqhc81";
      rev = "ee48d0e88d3f5814d24a8d1f22d5d83732824688";
      repo = "repocheck";
      owner = "kynikos";
    };

    meta = {
      inherit (src.meta) homepage;
      description = "Check the status of code repositories under a root directory";
      license = licenses.gpl3Plus;
      maintainers = with maintainers; [ nckx ];
    };
  };

  restview = callPackage ../development/python-modules/restview { };

  readme = buildPythonPackage rec {
    name = "readme-${version}";
    version = "0.6.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/r/readme/readme-${version}.tar.gz";
      sha256 = "08j2w67nilczn1i5r7h22vag9673i6vnfhyq2rv27r1bdmi5a30m";
    };

    buildInputs = with self; [ pytest ];
    propagatedBuildInputs = with self; [
      six docutils pygments bleach html5lib
    ];

    checkPhase = ''
      py.test
    '';

    # Tests fail, possibly broken.
    doCheck = false;

    meta = with stdenv.lib; {
      description = "Readme";
      homepage = "https://github.com/pypa/readme";
    };
  };

  readme_renderer = callPackage ../development/python-modules/readme_renderer { };

  rjsmin = callPackage ../development/python-modules/rjsmin { };

  pysolr = buildPythonPackage rec {
    name = "pysolr-${version}";
    version = "3.3.3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pysolr/pysolr-${version}.tar.gz";
      sha256 = "1wapg9n7myn7c82r3nzs2gisfzx52nip8w2mrfy0yih1zn02mnd6";
    };

    propagatedBuildInputs = with self; [
      requests
    ];
    buildInputs = with self; [

    ];

    meta = with stdenv.lib; {
      homepage = "http://github.com/toastdriven/pysolr/";
    };
  };


  django-haystack = buildPythonPackage rec {
    name = "django-haystack-${version}";
    version = "2.4.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/d/django-haystack/django-haystack-${version}.tar.gz";
      sha256 = "04cva8qg79xig4zqhb4dwkpm7734dvhzqclzvrdz70fh59ki5b4f";
    };

    doCheck = false;  # no tests in source

    buildInputs = with self; [ coverage mock nose geopy ];
    propagatedBuildInputs = with self; [
      django dateutil_1_5 whoosh pysolr elasticsearch
    ];

    patchPhase = ''
      sed -i 's/geopy==/geopy>=/' setup.py
      sed -i 's/whoosh==/Whoosh>=/' setup.py
    '';

    meta = with stdenv.lib; {
      homepage = "http://haystacksearch.org/";
    };
  };

  geoalchemy2 = buildPythonPackage rec {
    name = "GeoAlchemy2-${version}";
    version = "0.3.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/G/GeoAlchemy2/${name}.tar.gz";
      sha256 = "0p2h1kgl5b0jz8wadx485vjh1mmm5s67p71yxh9lhp1441hkfswf";
    };

    propagatedBuildInputs = with self ; [ sqlalchemy shapely ];

    meta = {
      homepage =  http://geoalchemy.org/;
      license = licenses.mit;
      description = "Toolkit for working with spatial databases";
    };
  };

  geopy = buildPythonPackage rec {
    name = "geopy-${version}";
    version = "1.11.0";
    disabled = !isPy27;

    src = pkgs.fetchurl {
      url = "mirror://pypi/g/geopy/geopy-${version}.tar.gz";
      sha256 = "04j1lxcsfyv03h0n0q7p2ig7a4n13x4x20fzxn8bkazpx6lyal22";
    };

    doCheck = false;  # too much

    buildInputs = with self; [ mock tox pylint ];
    meta = with stdenv.lib; {
      homepage = "https://github.com/geopy/geopy";
    };
  };

  django-multiselectfield = callPackage ../development/python-modules/django-multiselectfield { };

  reviewboard = buildPythonPackage rec {
    name = "ReviewBoard-2.5.1.1";

    src = pkgs.fetchurl {
      url = "http://downloads.reviewboard.org/releases/ReviewBoard/2.5/${name}.tar.gz";
      sha256 = "14m8yy2aqxnnzi822b797wc9nmkfkp2fqmq24asdnm66bxhyzjwn";
    };

    patchPhase = ''
      sed -i 's/mimeparse/python-mimeparse/' setup.py
      sed -i 's/markdown>=2.4.0,<2.4.999/markdown/' setup.py
    '';

    propagatedBuildInputs = with self;
      [ django recaptcha_client pytz memcached dateutil_1_5 paramiko flup
        pygments djblets django_evolution pycrypto pysvn pillow
        psycopg2 django-haystack python_mimeparse markdown django-multiselectfield
      ];
  };


  rdflib = buildPythonPackage (rec {
    name = "rdflib-4.1.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/r/rdflib/${name}.tar.gz";
      sha256 = "0kvaf332cqbi47rqzlpdx4mbkvw12mkrzkj8n9l19wk713d4py9w";
    };

    # error: invalid command 'test'
    doCheck = false;

    propagatedBuildInputs = with self; [ isodate html5lib SPARQLWrapper ];

    meta = {
      description = "A Python library for working with RDF, a simple yet powerful language for representing information";
      homepage = http://www.rdflib.net/;
    };
  });

  isodate = buildPythonPackage rec {
    name = "isodate-${version}";
    version = "0.5.4";

    src = pkgs.fetchurl {
      url = "mirror://pypi/i/isodate/${name}.tar.gz";
      sha256 = "42105c41d037246dc1987e36d96f3752ffd5c0c24834dd12e4fdbe1e79544e31";
    };

    # Judging from SyntaxError
    doCheck = !(isPy3k);

    checkPhase = ''
      ${python.interpreter} -m unittest discover -s src/isodate/tests
    '';

    meta = {
      description = "ISO 8601 date/time parser";
      homepage = http://cheeseshop.python.org/pypi/isodate;
    };
  };

  resampy = buildPythonPackage rec {
    pname = "resampy";
    version = "0.1.4";
    name = "${pname}-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
      sha256 = "cf4f149d8699af70a1b4b0769fa16fab21835d936ea7ff25e98446aa49e743d4";
    };

    checkInputs = with self; [ pytest pytestcov ];
    # No tests included
    doCheck = false;
    propagatedBuildInputs = with self; [ numpy scipy cython six ];

    meta = {
      homepage = https://github.com/bmcfee/resampy;
      description = "Efficient signal resampling";
      license = licenses.isc;
    };
  };

  restructuredtext_lint = callPackage ../development/python-modules/restructuredtext_lint { };

  robomachine = callPackage ../development/python-modules/robomachine { };

  robotframework = callPackage ../development/python-modules/robotframework { };

  robotframework-selenium2library = buildPythonPackage rec {
    version = "1.6.0";
    name = "robotframework-selenium2library-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/r/robotframework-selenium2library/${name}.tar.gz";
      sha256 = "1asdwrpb4s7q08bx641yrh3yicgba14n3hxmsqs58mqf86ignwly";
    };

    # error: invalid command 'test'
    #doCheck = false;

    propagatedBuildInputs = with self; [ robotframework selenium docutils decorator ];

    meta = {
      description = "";
      homepage = http://robotframework.org/;
      license = licenses.asl20;
    };
  };


  robotframework-tools = buildPythonPackage rec {
    version = "0.1a115";
    name = "robotframework-tools-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/r/robotframework-tools/${name}.tar.gz";
      sha256 = "04gkn1zpf3rsvbqdxrrjqqi8sa0md9gqwh6n5w2m03fdwjg4lc7q";
    };

    propagatedBuildInputs = with self; [ robotframework moretools pathpy six setuptools ];

    meta = {
      description = "Python Tools for Robot Framework and Test Libraries";
      homepage = https://bitbucket.org/userzimmermann/robotframework-tools;
      license = licenses.gpl3;
      platforms = platforms.linux;
    };
  };

  robotsuite = callPackage ../development/python-modules/robotsuite { };

  robotframework-ride = callPackage ../development/python-modules/robotframework-ride { };

  robotframework-requests = buildPythonPackage rec {
    version = "0.4.6";
    name = "robotframework-requests-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/ad/da/51359b11d2005ff425984205677890fafaf270a71b03df22c255501bc99d/robotframework-requests-0.4.6.tar.gz";
      sha256 = "0416rxg7g0pfg77akljnkass0xz0id26v4saag2q2h1fgwrm7n4q";
    };

    buildInputs = with self; [ unittest2 ];
    propagatedBuildInputs = with self; [ robotframework lxml requests ];

    meta = {
      description = "Robot Framework keyword library wrapper around the HTTP client library requests";
      homepage = https://github.com/bulkan/robotframework-requests;
    };
  };

  root_numpy = callPackage ../development/python-modules/root_numpy { };

  rootpy = callPackage ../development/python-modules/rootpy { };

  rope = callPackage ../development/python-modules/rope { };

  ropper = callPackage ../development/python-modules/ropper { };

  routes = buildPythonPackage rec {
    pname = "Routes";
    version = "2.4.1";
    name = "${pname}-${version}";

    src = fetchPypi {
      inherit pname version;
      sha256 = "1zamff3m0kc4vyfniyhxpkkcqv1rrgnmh37ykxv34nna1ws47vi6";
    };

    propagatedBuildInputs = with self; [ paste webtest repoze_lru ];

    meta = {
      description = "A Python re-implementation of the Rails routes system for mapping URLs to application actions";
      homepage = http://routes.groovie.org/;
    };
  };

  rpkg = callPackage ../development/python-modules/rpkg/default.nix {};

  rply = callPackage ../development/python-modules/rply/default.nix {};

  rpm = (pkgs.rpm.override{inherit python;});

  rpmfluff = callPackage ../development/python-modules/rpmfluff {};

  rpy2 = buildPythonPackage rec {
    name = "rpy2-2.8.2";
    disabled = isPyPy;
    src = pkgs.fetchurl {
      url = "mirror://pypi/r/rpy2/${name}.tar.gz";
      sha256 = "2c1a313df4e64236dcfe1078ce847b8e3c180656c894928d3a4b391aacb9b24c";
    };
    buildInputs = with pkgs; [ readline R pcre lzma bzip2 zlib icu ];
    propagatedBuildInputs = with self; [ singledispatch six ];

    # According to manual this is how the testsuite should be invoked
    checkPhase = ''
      ${python.interpreter}  -m rpy2.tests
    '';
    meta = {
      homepage = http://rpy.sourceforge.net/rpy2;
      description = "Python interface to R";
      license = licenses.gpl2Plus;
      maintainers = with maintainers; [ joelmo ];
      broken = true;
    };
  };

  rpyc = buildPythonPackage rec {
    name = "rpyc-${version}";
    version = "3.3.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/r/rpyc/${name}.tar.gz";
      sha256 = "43fa845314f0bf442f5f5fab15bb1d1b5fe2011a8fc603f92d8022575cef8b4b";
    };

    propagatedBuildInputs = with self; [ nose plumbum ];

    meta = {
      description = "Remote Python Call (RPyC), a transparent and symmetric RPC library";
      homepage = http://rpyc.readthedocs.org;
      license = licenses.mit;
    };
  };

  rsa = buildPythonPackage rec {
    name = "rsa-${version}";
    version = "3.4.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/r/rsa/${name}.tar.gz";
      sha256 = "1dcxvszbikgzh99ybdc7jq0zb9wspy2ds8z9mjsqiyv3q884xpr5";
    };

    nativeBuildInputs = with self; [ unittest2 ];
    propagatedBuildInputs = with self; [ pyasn1 ];

    meta = {
      homepage = "http://stuvel.eu/rsa";
      license = licenses.asl20;
      description = "A pure-Python RSA implementation";
    };
  };

  squaremap = buildPythonPackage rec {
    name = "squaremap-1.0.4";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/S/SquareMap/SquareMap-1.0.4.tar.gz";
      sha256 = "feab6cb3b222993df68440e34825d8a16de2c74fdb290ae3974c86b1d5f3eef8";
    };

    meta = {
      description = "Hierarchic visualization control for wxPython";
      homepage = https://launchpad.net/squaremap;
      license = licenses.bsd3;
    };
  };

  ruamel_base = buildPythonPackage rec {
    name = "ruamel.base-${version}";
    version = "1.0.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/r/ruamel.base/${name}.tar.gz";
      sha256 = "1wswxrn4givsm917mfl39rafgadimf1sldpbjdjws00g1wx36hf0";
    };

    meta = {
      description = "Common routines for ruamel packages";
      homepage = https://bitbucket.org/ruamel/base;
      license = licenses.mit;
    };
  };

  ruamel_ordereddict = buildPythonPackage rec {
    name = "ruamel.ordereddict-${version}";
    version = "0.4.9";
    disabled = isPy3k || isPyPy;

    src = pkgs.fetchurl {
      url = "mirror://pypi/r/ruamel.ordereddict/${name}.tar.gz";
      sha256 = "1xmkl8v9l9inm2pyxgc1fm5005yxm7fkd5gv74q7lj1iy5qc8n3h";
    };

    meta = {
      description = "A version of dict that keeps keys in insertion resp. sorted order";
      homepage = https://bitbucket.org/ruamel/ordereddict;
      license = licenses.mit;
    };
  };

  typing = buildPythonPackage rec {
    name = "typing-${version}";
    version = "3.5.3.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/typing/${name}.tar.gz";
      sha256 = "08gz3grrh3vph5ib1w5x1ssnpzvj077x030lx63fxs4kwg3slbfa";
    };

    meta = {
      description = "Backport of typing module to Python versions older than 3.5";
      homepage = "https://docs.python.org/3.5/library/typing.html";
      license = licenses.psfl;
    };
  };

  typeguard = callPackage ../development/python-modules/typeguard { };

  ruamel_yaml = buildPythonPackage rec {
    name = "ruamel.yaml-${version}";
    version = "0.13.7";

    # needs ruamel_ordereddict for python2 support
    disabled = !isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/r/ruamel.yaml/${name}.tar.gz";
      sha256 = "1vca2552k0kmhr9msg1bbfdvp3p9im17x1a6npaw221vlgg15z7h";
    };

    # Tests cannot load the module to test
    doCheck = false;

    propagatedBuildInputs = with self; [ ruamel_base typing ];

    meta = {
      description = "YAML parser/emitter that supports roundtrip preservation of comments, seq/map flow style, and map key order";
      homepage = https://bitbucket.org/ruamel/yaml;
      license = licenses.mit;
    };
  };

  runsnakerun = buildPythonPackage rec {
    name = "runsnakerun-2.0.4";

    src = pkgs.fetchurl {
      url = "mirror://pypi/R/RunSnakeRun/RunSnakeRun-2.0.4.tar.gz";
      sha256 = "61d03a13f1dcb3c1829f5a146da1fe0cc0e27947558a51e848b6d469902815ef";
    };

    propagatedBuildInputs = with self; [ squaremap wxPython ];

    meta = {
      description = "GUI Viewer for Python profiling runs";
      homepage = http://www.vrplumber.com/programming/runsnakerun/;
      license = licenses.bsd3;
    };
  };

  s3transfer = callPackage ../development/python-modules/s3transfer { };

  seqdiag = callPackage ../development/python-modules/seqdiag { };

  pysendfile = buildPythonPackage rec {
    name = "pysendfile-${version}";
    version = "2.0.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pysendfile/pysendfile-${version}.tar.gz";
      sha256 = "05qf0m32isflln1zjgxlpw0wf469lj86vdwwqyizp1h94x5l22ji";
    };

    checkPhase = ''
      # this test takes too long
      sed -i 's/test_big_file/noop/' test/test_sendfile.py
      ${self.python.executable} test/test_sendfile.py
    '';

    meta = with stdenv.lib; {
      homepage = "https://github.com/giampaolo/pysendfile";
    };
  };

  qpid-python = buildPythonPackage rec {
    name = "qpid-python-${version}";
    version = "0.32";
    disabled = isPy3k;  # not supported

    src = pkgs.fetchurl {
      url = "http://www.us.apache.org/dist/qpid/${version}/${name}.tar.gz";
      sha256 = "09hdfjgk8z4s3dr8ym2r6xn97j1f9mkb2743pr6zd0bnj01vhsv4";
    };

    # needs a broker running and then ./qpid-python-test
    doCheck = false;

  };

  xattr = buildPythonPackage rec {
    name = "xattr-0.7.8";

    src = pkgs.fetchurl {
      url = "mirror://pypi/x/xattr/${name}.tar.gz";
      sha256 = "0nbqfghgy26jyp5q7wl3rj78wr8s39m5042df2jlldg3fx6j0417";
    };

    # https://github.com/xattr/xattr/issues/43
    doCheck = false;

    postBuild = ''
      ${python.interpreter} -m compileall -f xattr
    '';

    propagatedBuildInputs = [ self.cffi ];
  };

  sampledata = callPackage ../development/python-modules/sampledata { };

  scapy = callPackage ../development/python-modules/scapy { };

  scipy = callPackage ../development/python-modules/scipy { };

  scikitimage = buildPythonPackage rec {
    name = "scikit-image-${version}";
    version = "0.12.3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/scikit-image/${name}.tar.gz";
      sha256 = "1iypjww5hk46i9vzg2zlfc9w4vdw029cfyakkkl02isj1qpiknl2";
    };

    buildInputs = with self; [ cython dask nose numpy scipy six ];

    propagatedBuildInputs = with self; [ pillow matplotlib networkx scipy six numpy ];

    # the test fails because the loader cannot create test objects!
    doCheck = false;

    meta = {
      description = "Image processing routines for SciPy";
      homepage = http://scikit-image.org;
      license = licenses.bsd3;
    };
  };

  scikitlearn = callPackage ../development/python-modules/scikitlearn {
    inherit (pkgs) gfortran glibcLocales;
  };

  scripttest = buildPythonPackage rec {
    version = "1.3";
    name = "scripttest-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/scripttest/scripttest-${version}.tar.gz";
      sha256 = "951cfc25219b0cd003493a565f2e621fd791beaae9f9a3bdd7024d8626419c38";
    };

    buildInputs = with self; [ pytest ];

    # Tests are not included. See https://github.com/pypa/scripttest/issues/11
    doCheck = false;

    meta = {
      description = "A library for testing interactive command-line applications";
      homepage = https://pypi.python.org/pypi/ScriptTest/;
    };
  };

  seaborn = callPackage ../development/python-modules/seaborn { };

  selenium = callPackage ../development/python-modules/selenium { };

  serpy = callPackage ../development/python-modules/serpy { };

  setuptools_scm = callPackage ../development/python-modules/setuptools_scm { };

  setuptoolsDarcs = buildPythonPackage rec {
    name = "setuptools_darcs-${version}";
    version = "1.2.11";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/setuptools_darcs/${name}.tar.gz";
      sha256 = "1wsh0g1fn10msqk87l5jrvzs0yj5mp6q9ld3gghz6zrhl9kqzdn1";
    };

    # In order to break the dependency on darcs -> ghc, we don't add
    # darcs as a propagated build input.
    propagatedBuildInputs = with self; [ darcsver ];

    # ugly hack to specify version that should otherwise come from darcs
    patchPhase = ''
      substituteInPlace setup.py --replace "name=PKG" "name=PKG, version='${version}'"
    '';

    meta = {
      description = "Setuptools plugin for the Darcs version control system";
      homepage = http://allmydata.org/trac/setuptools_darcs;
      license = "BSD";
    };
  };

  setuptoolsTrial = buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "setuptools_trial";
    version = "0.6.0";
    src = pkgs.fetchurl {
      url = "mirror://pypi/s/${pname}/${name}.tar.gz";
      sha256 = "14220f8f761c48ba1e2526f087195077cf54fad7098b382ce220422f0ff59b12";
    };
    buildInputs = with self; [ pytest virtualenv pytestrunner pytest-virtualenv ];
    propagatedBuildInputs = with self; [ twisted pathlib2 ];
    postPatch = ''
      sed -i '12,$d' tests/test_main.py
    '';

    # Couldn't get tests working
    doCheck = false;

    meta = {
      description = "Setuptools plugin that makes unit tests execute with trial instead of pyunit.";
      homepage = "https://github.com/rutsky/setuptools-trial";
      license = licenses.bsd2;
      maintainers = with maintainers; [ ryansydnor nand0p ];
      platforms   = platforms.all;
    };
  };

  simanneal = callPackage ../development/python-modules/simanneal { };

  simplebayes = buildPythonPackage rec {
    name = "simplebayes-${version}";
    version = "1.5.8";

    # Use GitHub instead of pypi, because it contains tests.
    src = pkgs.fetchFromGitHub {
      repo = "simplebayes";
      owner = "hickeroar";
      # NOTE: This is actually 1.5.8 but the tag is wrong!
      rev = "1.5.7";
      sha256 = "0mp7rvfdmpfxnka4czw3lv5kkh6gdxh6dm4r6hcln1zzfg9lxp4h";
    };

    checkInputs = [ self.nose self.mock ];

    postPatch = optionalString isPy3k ''
      sed -i -e 's/open *(\([^)]*\))/open(\1, encoding="utf-8")/' setup.py
    '';

    checkPhase = "nosetests tests/test.py";

    meta = {
      description = "Memory-based naive bayesian text classifier";
      homepage = "https://github.com/hickeroar/simplebayes";
      license = licenses.mit;
      platforms = platforms.all;
    };
  };

  simplegeneric = buildPythonPackage rec {
    version = "0.8.1";
    name = "simplegeneric-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/simplegeneric/${name}.zip";
      sha256 = "dc972e06094b9af5b855b3df4a646395e43d1c9d0d39ed345b7393560d0b9173";
    };

    meta = {
      description = "Simple generic functions";
      homepage = http://cheeseshop.python.org/pypi/simplegeneric;
      license = licenses.zpl21;
    };
  };


  shortuuid = buildPythonPackage rec {
    name = "shortuuid-${version}";
    version = "0.4.3";

    disabled = isPy26;

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/shortuuid/${name}.tar.gz";
      sha256 = "4606dbb19124d98109c00e2cafae2df8117aec02115623e18fb2abe3f766d293";
    };

    buildInputs = with self; [pep8];

    meta = {
      description = "A generator library for concise, unambiguous and URL-safe UUIDs";
      homepage = https://github.com/stochastic-technologies/shortuuid/;
      license = licenses.bsd3;
      maintainers = with maintainers; [ zagy ];
    };
  };

  shouldbe = buildPythonPackage rec {
    version = "0.1.0";
    name = "shouldbe-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/shouldbe/${name}.tar.gz";
      sha256 = "07pchxpv1xvjbck0xy44k3a1jrvklg0wbyccn14w0i7d135d4174";
    };

    buildInputs = with self; [ nose ];

    propagatedBuildInputs = with self; [ forbiddenfruit ];

    doCheck = false;  # Segmentation fault on py 3.5

    meta = {
      description = "Python Assertion Helpers inspired by Shouldly";
      homepage =  https://pypi.python.org/pypi/shouldbe/;
      license = licenses.mit;
    };
  };

  simplejson = callPackage ../development/python-modules/simplejson { };

  simpleldap = buildPythonPackage rec {
    version = "0.8";
    name = "simpleldap-${version}";

    propagatedBuildInputs = with self; [ ldap ];
    buildInputs = with self; [ pep8 pytest tox ];

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/simpleldap/simpleldap-${version}.tar.gz";
      sha256 = "a5916680a7fe1b2c5d74dc76351be2941d03b7b94a50d8520280e3f588a84e61";
    };

    meta = {
      description = "A module that makes simple LDAP usage simple";
      longDescription = ''
        A small wrapper around the python-ldap library that provides a more
        Pythonic interface for LDAP server connections, LDAP objects, and the
        common get and search operations.
      '';
      license = licenses.mit;
      maintainers = with maintainers; [ layus ];
    };
  };

  simpleparse = buildPythonPackage rec {
    version = "2.1.1";
    name = "simpleparse-${version}";

    disabled = isPy3k || isPyPy;

    src = pkgs.fetchurl {
      url = "mirror://pypi/S/SimpleParse/SimpleParse-${version}.tar.gz";
      sha256 = "1n8msk71lpl3kv086xr2sv68ppgz6228575xfnbszc6p1mwr64rg";
    };

    doCheck = false;  # weird error

    meta = {
      description = "A Parser Generator for Python";
      homepage = https://pypi.python.org/pypi/SimpleParse;
      platforms = platforms.all;
      maintainers = with maintainers; [ ];
    };
  };

  sigal = buildPythonPackage rec {
    name = "sigal-1.0.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/sigal/${name}.tar.gz";
      sha256 = "198g2r8bii6a0p44mlk1wg07jjv95xpfvnqhhxxziqpizc776b34";
    };

    buildInputs = with self; [ pytest ];
    propagatedBuildInputs = with self; [ jinja2 markdown pillow pilkit clint click blinker ];

    # No tests included
    doCheck = false;


    meta = {
      description = "Yet another simple static gallery generator";
      homepage = http://sigal.saimon.org/en/latest/index.html;
      license = licenses.mit;
      maintainers = with maintainers; [ domenkozar ];
    };
  };

  slob = buildPythonPackage rec {
    name = "slob-unstable-2016-11-03";

    disabled = !isPy3k;

    src = pkgs.fetchFromGitHub {
      owner = "itkach";
      repo = "slob";
      rev = "d1ed71e4778729ecdfc2fe27ed783689a220a6cd";
      sha256 = "1r510s4r124s121wwdm9qgap6zivlqqxrhxljz8nx0kv0cdyypi5";
    };

    propagatedBuildInputs = [ self.PyICU ];

    checkPhase = "python3 -m unittest slob";

    meta = {
      homepage = https://github.com/itkach/slob/;
      description = "Reference implementation of the slob (sorted list of blobs) format";
      license = licenses.gpl3;
      platforms = platforms.all;
      maintainers = [ maintainers.rycee ];
    };
  };

  slowaes = buildPythonPackage rec {
    name = "slowaes-${version}";
    version = "0.1a1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/slowaes/${name}.tar.gz";
      sha256 = "83658ae54cc116b96f7fdb12fdd0efac3a4e8c7c7064e3fac3f4a881aa54bf09";
    };

    disabled = isPy3k;

    meta = {
      homepage = "http://code.google.com/p/slowaes/";
      description = "AES implemented in pure python";
      license = with licenses; [ asl20 ];
    };
  };

  snowballstemmer = buildPythonPackage rec {
    name = "snowballstemmer-1.2.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/snowballstemmer/${name}.tar.gz";
      sha256 = "919f26a68b2c17a7634da993d91339e288964f93c274f1343e3bbbe2096e1128";
    };

    # No tests included
    doCheck = false;

    propagatedBuildInputs = with self; [ PyStemmer ];

    meta = {
      description = "16 stemmer algorithms (15 + Poerter English stemmer) generated from Snowball algorithms";
      homepage = http://sigal.saimon.org/en/latest/index.html;
      license = licenses.bsd3;
      platforms = platforms.unix;
    };
  };

  spake2 = buildPythonPackage rec {
    name = "spake2-${version}";
    version = "0.7";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/spake2/${name}.tar.gz";
      sha256 = "0rmplicbbid41qrvwc1ckyp211ban01ardms5yqqq16ixrc18a6j";
    };

    buildInputs = with self; [ pytest ];

    propagatedBuildInputs = with self; [ hkdf ];

    checkPhase = ''
      py.test $out
    '';

    meta = {
      description = "SPAKE2 password-authenticated key exchange library";
      homepage = "http://github.com/warner/python-spake2";
      license = licenses.mit;
    };
  };

  sphfile = callPackage ../development/python-modules/sphfile { };

  sqlite3dbm = buildPythonPackage rec {
    name = "sqlite3dbm-0.1.4";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/sqlite3dbm/${name}.tar.gz";
      sha256 = "4721607e0b817b89efdba7e79cab881a03164b94777f4cf796ad5dd59a7612c5";
    };

    meta = {
      description = "sqlite-backed dictionary";
      homepage = "http://github.com/Yelp/sqlite3dbm";
      license = licenses.asl20;
    };
  };

  sqlobject = buildPythonPackage rec {
    pname = "SQLObject";
    version = "3.3.0";
    name = "${pname}-${version}";

    src = fetchPypi {
      inherit pname version;
      sha256 = "0p2dxrxh7xrv5yys09v5z95d0z40w22aq3xc01ghdidd7hr79xy9";
    };

    checkInputs = with self; [ pytest ];

    propagatedBuildInputs = with self; [
      FormEncode
      PasteDeploy
      paste
      pydispatcher
    ];

    meta = {
      description = "Object Relational Manager for providing an object interface to your database";
      homepage = "http://www.sqlobject.org/";
      license = licenses.lgpl21;
    };
  };

  sqlmap = callPackage ../development/python-modules/sqlmap { };
  pgpdump = self.buildPythonPackage rec {
    pname = "pgpdump";
    version = "1.5";
    name = "${pname}-${version}";

    src = fetchPypi {
      inherit pname version;
      sha256 = "0s4nh8h7qsdj2yf29bspjs1zvxd4lcd11r6g11dp7fppgf2h0iqw";
    };

    # Disabling check because of: https://github.com/toofishes/python-pgpdump/issues/18
    doCheck = false;

    meta = {
      description = "Python library for parsing PGP packets";
      homepage = https://github.com/toofishes/python-pgpdump;
      license = licenses.bsd3;
    };
  };

  spambayes = callPackage ../development/python-modules/spambayes { };

  shapely = callPackage ../development/python-modules/shapely { };

  sopel = buildPythonPackage rec {
    name = "sopel-6.3.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/sopel/${name}.tar.gz";
      sha256 = "1swvw7xw8n5anb8ah8jilk4vk1y30y62fkibfd9vm9fbk45d1q48";
    };

    buildInputs = with self; [ pytest ];
    propagatedBuildInputs = with self; [ praw xmltodict pytz pyenchant pygeoip ];

    disabled = isPyPy || isPy26 || isPy27;

    checkPhase = ''
    ${python.interpreter} test/*.py                                         #*/
    '';
    meta = {
      description = "Simple and extensible IRC bot";
      homepage = "http://sopel.chat";
      license = licenses.efl20;
      maintainers = with maintainers; [ mog ];
    };
  };

  sounddevice = callPackage ../development/python-modules/sounddevice { };

  stevedore = callPackage ../development/python-modules/stevedore {};

  Theano = callPackage ../development/python-modules/Theano rec {
    cudaSupport = pkgs.config.cudaSupport or false;
    cudnnSupport = cudaSupport;
  };

  TheanoWithoutCuda = self.Theano.override {
    cudaSupport = true;
    cudnnSupport = true;
  };

  TheanoWithCuda = self.Theano.override {
    cudaSupport = false;
    cudnnSupport = false;
  };

  tidylib = buildPythonPackage rec {
    version = "0.2.4";
    name = "pytidylib-${version}";

    propagatedBuildInputs = [ pkgs.html-tidy ];

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pytidylib/pytidylib-${version}.tar.gz";
      sha256 = "0af07bd8ebd256af70ca925ada9337faf16d85b3072624f975136a5134150ab6";
    };

    # Judging from SyntaxError in tests
    disabled = isPy3k;

    checkPhase = ''
      ${python.interpreter} -m unittest discover
    '';

    # Bunch of tests fail
    # https://github.com/countergram/pytidylib/issues/13
    doCheck = false;

    patchPhase = ''
      sed -i 's#load_library(name)#load_library("${pkgs.html-tidy}/lib/libtidy.so")#' tidylib/__init__.py
    '';

    meta = {
      homepage = " http://countergram.com/open-source/pytidylib/";
      maintainers = with maintainers; [ layus ];
    };
  };

  tilestache = self.buildPythonPackage rec {
    name = "tilestache-${version}";
    version = "1.50.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/T/TileStache/TileStache-${version}.tar.gz";
      sha256 = "1z1j35pz77lhhjdn69sq5rmz62b5m444507d8zjnp0in5xqaj6rj";
    };

    disabled = !isPy27;

    propagatedBuildInputs = with self;
      [ modestmaps pillow pycairo python-mapnik simplejson werkzeug ];

    meta = {
      description = "A tile server for rendered geographic data";
      homepage = http://tilestache.org;
      license = licenses.bsd3;
    };
  };

  timelib = buildPythonPackage rec {
    name = "timelib-0.2.4";

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/timelib/${name}.zip";
      sha256 = "49142233bdb5971d64a41e05a1f80a408a02be0dc7d9f8c99e7bdd0613ba81cb";
    };

    buildInputs = with self; [ ];

    meta = {
      description = "Parse english textual date descriptions";
      homepage = "https://github.com/pediapress/timelib/";
      license = licenses.zlib;
    };
  };

  timeout-decorator = buildPythonPackage rec {
    name    = "timeout-decorator-${version}";
    version = "0.3.2";

    src = pkgs.fetchurl {
      url    = "http://pypi.python.org/packages/source/t/timeout-decorator/${name}.tar.gz";
      sha256 = "1x9l8bwdk72if2d5h5mi4lcaidbsmyh0iz114cfyyj1rzz5rxqaf";
    };
  };

  pid = buildPythonPackage rec {
    name = "pid-${version}";
    version = "2.0.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pid/${name}.tar.gz";
      sha256 = "0cylj8p25nwkdfgy4pzai21wyzmrxdqlwwbzqag9gb5qcjfdwk05";
    };

    buildInputs = with self; [ nose ];

    # No tests included
    doCheck = false;

    meta = {
      description = "Pidfile featuring stale detection and file-locking";
      homepage = https://github.com/trbs/pid/;
      license = licenses.asl20;
    };
  };

  pip2nix = buildPythonPackage rec {
    name = "pip2nix-${version}";
    version = "0.3.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pip2nix/${name}.tar.gz";
      sha256 = "1s76i8r4khq8y5r6g4218jg2c6qldmw5xhzymxad51ii8hafpwq6";
    };

    propagatedBuildInputs = with self; [ click configobj contexter jinja2 pytest ];

    meta.broken = true;
  };

  pychef = buildPythonPackage rec {
    name    = "PyChef-${version}";
    version = "0.3.0";

    src = pkgs.fetchurl {
      url    = "https://pypi.python.org/packages/f9/31/17cde137e3b8ada4d7c80fd4504264f2abed329a9a8100c3622a044c485e/PyChef-0.3.0.tar.gz";
      sha256 = "0zdz8lw545cd3a34cpib7mdwnad83gr2mrrxyj3v74h4zhwabhmg";
    };

    propagatedBuildInputs = with self; [ six requests mock unittest2 ];

    # FIXME
    doCheck = false;
  };

  pydns =
    let
      py3 = buildPythonPackage rec {
        name = "${pname}-${version}";
        pname = "py3dns";
        version = "3.1.1a";

        src = fetchPypi {
          inherit pname version;
          sha256 = "0z0qmx9j1ivpgg54gqqmh42ljnzxaychc5inz2gbgv0vls765smz";
        };

        preConfigure = ''
          sed -i \
            -e '/import DNS/d' \
            -e 's/DNS.__version__/"${version}"/g' \
            setup.py
        '';

        doCheck = false;
      };

      py2 = buildPythonPackage rec {
        name = "${pname}-${version}";
        pname = "pydns";
        version = "2.3.6";

        src = fetchPypi {
          inherit pname version;
          sha256 = "0qnv7i9824nb5h9psj0rwzjyprwgfiwh5s5raa9avbqazy5hv5pi";
        };

        doCheck = false;
      };
    in if isPy3k then py3 else py2;

  pythondaemon = buildPythonPackage rec {
    name = "python-daemon-${version}";
    version = "2.1.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/python-daemon/${name}.tar.gz";
      sha256 = "17v80qb98p1gv4j9mq6wb55cv7hc4j1hzw5y2f4s5hrpxs3w3a2q";
    };

    # A test fail within chroot builds.
    doCheck = false;

    buildInputs = with self; [ mock testscenarios ];
    propagatedBuildInputs = with self; [ docutils lockfile ];

    meta = {
      description = "Library to implement a well-behaved Unix daemon process";
      homepage = https://alioth.debian.org/projects/python-daemon/;
      licenses =  [ licenses.gpl3Plus licenses.asl20 ];
    };
  };

  sympy = buildPythonPackage rec {
    name = "sympy-1.0";

    src = pkgs.fetchurl {
      url    = "mirror://pypi/s/sympy/${name}.tar.gz";
      sha256 = "1bpzjwr9hrr7w88v4vgnj9lr6vxcldc94si13n8xpr1rv08d5b1y";
    };

    buildInputs = [ pkgs.glibcLocales ];

    propagatedBuildInputs = with self; [ mpmath ];

    # Bunch of failures including transients.
    doCheck = false;

    preCheck = ''
      export LANG="en_US.UTF-8"
    '';

    meta = {
      description = "A Python library for symbolic mathematics";
      homepage    = http://www.sympy.org/;
      license     = licenses.bsd3;
      maintainers = with maintainers; [ lovek323 ];
      platforms   = platforms.unix;
    };
  };

  pilkit = buildPythonPackage rec {
    name = "pilkit-1.1.4";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pilkit/${name}.tar.gz";
      sha256 = "e00585f5466654ea2cdbf7decef9862cb00e16fd363017fa7ef6623a16b0d2c7";
    };

    preConfigure = ''
      substituteInPlace setup.py --replace 'nose==1.2.1' 'nose'
    '';

    # tests fail, see https://github.com/matthewwithanm/pilkit/issues/9
    doCheck = false;

    buildInputs = with self; [ pillow nose_progressive nose mock blessings ];

    meta = {
      maintainers = with maintainers; [ domenkozar ];
    };
  };

  clint = buildPythonPackage rec {
    name = "clint-0.5.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/c/clint/${name}.tar.gz";
      sha256 = "1an5lkkqk1zha47198p42ji3m94xmzx1a03dn7866m87n4r4q8h5";
    };


    LC_ALL="en_US.UTF-8";

    checkPhase = ''
      ${python.interpreter} test_clint.py
    '';

    buildInputs = with self; [ mock blessings nose nose_progressive pkgs.glibcLocales ];
    propagatedBuildInputs = with self; [ pillow blessings args ];

    meta = {
      maintainers = with maintainers; [ domenkozar ];
    };
  };

  argh = buildPythonPackage rec {
    name = "argh-0.26.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/a/argh/${name}.tar.gz";
      sha256 = "1nqham81ihffc9xmw85dz3rg3v90rw7h0dp3dy0bh3qkp4n499q6";
    };

    checkPhase = ''
      export LANG="en_US.UTF-8"
      py.test
    '';

    buildInputs = with self; [ pytest py mock pkgs.glibcLocales ];

    meta = {
      maintainers = with maintainers; [ domenkozar ];
    };
  };

  nose_progressive = buildPythonPackage rec {
    name = "nose-progressive-1.5.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/n/nose-progressive/${name}.tar.gz";
      sha256 = "0mfbjv3dcg23q0a130670g7xpfyvgza4wxkj991xxh8w9hs43ga4";
    };

    buildInputs = with self; [ nose ];
    propagatedBuildInputs = with self; [ pillow blessings ];

    # fails with obscure error
    doCheck = !isPy3k;

    meta = {
      maintainers = with maintainers; [ domenkozar ];
    };
  };

  blessings = buildPythonPackage rec {
    name = "blessings-1.6";

    src = pkgs.fetchurl {
      url = "mirror://pypi/b/blessings/${name}.tar.gz";
      sha256 = "01rhgn2c3xjf9h1lxij9m05iwf2ba6d0vd7nic26c2gic4q73igd";
    };

    # 4 failing tests, 2to3
    doCheck = false;

    propagatedBuildInputs = with self; [ ];

    meta = {
      maintainers = with maintainers; [ domenkozar ];
    };
  };

  secretstorage = callPackage ../development/python-modules/secretstorage { };

  semantic = buildPythonPackage rec {
    name = "semantic-1.0.3";

    disabled = isPy3k;

    propagatedBuildInputs = with self; [ quantities numpy ];

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/semantic/semantic-1.0.3.tar.gz";
      sha256 = "bbc47dad03dddb1ba5895612fdfa1e43cfb3c497534976cebacd4f3684b505b4";
    };

    # strange setuptools error (can not import semantic.test)
    doCheck = false;

    meta = with pkgs.stdenv.lib; {
      description = "Common Natural Language Processing Tasks for Python";
      homepage = https://github.com/crm416/semantic;
      license = licenses.mit;
    };
  };

  sandboxlib = buildPythonPackage rec {
    name = "sandboxlib-${version}";
    version = "0.31";

    disabled = isPy3k;

    buildInputs = [ self.pbr ];

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/sandboxlib/sandboxlib-0.3.1.tar.gz";
      sha256 = "0csj8hbpylqdkxcpqkcfs73dfvdqkyj23axi8m9drqdi4dhxb41h";
    };

    meta = {
      description = "Sandboxing Library for Python";
      homepage = https://pypi.python.org/pypi/sandboxlib/0.3.1;
      license = licenses.gpl2;
    };
  };

  scales = buildPythonPackage rec {
    name = "scales-${version}";
    version = "1.0.9";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/scales/${name}.tar.gz";
      sha256 = "8b6930f7d4bf115192290b44c757af5e254e3fcfcb75ff9a51f5c96a404e2753";
    };

    buildInputs = with self; optionals doCheck [ nose ];
    # No tests included
    doCheck = false;

    propagatedBuildInputs = with self; [ six ];

    meta = {
      description = "Stats for Python processes";
      homepage = https://www.github.com/Cue/scales;
      license = licenses.asl20;
    };
  };

  secp256k1 = buildPythonPackage rec {
    name = "secp256k1-${version}";
    version = "0.12.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/secp256k1/${name}.tar.gz";
      sha256 = "0zrjxvzxqm4bz2jcy8sras8jircgbs6dkrw8j3nc6jhvzlikwwxl";
    };

    nativeBuildInputs = [ pkgs.pkgconfig ];
    buildInputs = [ self.pytest_28 self.pytestrunner ];
    propagatedBuildInputs = [ self.cffi pkgs.secp256k1 ];

    # Tests are not included in archive
    doCheck = false;

    preConfigure = ''
      cp -r ${pkgs.secp256k1.src} libsecp256k1
      touch libsecp256k1/autogen.sh
      export INCLUDE_DIR=${pkgs.secp256k1}/include
      export LIB_DIR=${pkgs.secp256k1}/lib
    '';

    checkPhase = ''
      py.test tests
    '';

    meta = {
      homepage = https://github.com/ludbb/secp256k1-py;
      description = "Python FFI bindings for secp256k1";
      license = with licenses; [ mit ];
      maintainers = with maintainers; [ chris-martin ];
    };
  };

  semantic-version = callPackage ../development/python-modules/semantic-version { };

  sexpdata = buildPythonPackage rec {
    name = "sexpdata-0.0.2";
    src = pkgs.fetchurl {
      url = "mirror://pypi/s/sexpdata/${name}.tar.gz";
      sha256 = "eb696bc66b35def5fb356de09481447dff4e9a3ed926823134e1d0f35eade428";
    };

    doCheck = false;

    meta = {
      description = "S-expression parser for Python";
      homepage = "https://github.com/tkf/sexpdata";
    };
  };


  sh = buildPythonPackage rec {
    name = "sh-1.11";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/sh/${name}.tar.gz";
      sha256 = "590fb9b84abf8b1f560df92d73d87965f1e85c6b8330f8a5f6b336b36f0559a4";
    };

    doCheck = false;

    meta = {
      description = "Python subprocess interface";
      homepage = https://pypi.python.org/pypi/sh/;
    };
  };


  sipsimple = buildPythonPackage rec {
    name = "sipsimple-${version}";
    version = "3.0.0";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "http://download.ag-projects.com/SipClient/python-${name}.tar.gz";
      sha256 = "1q35kgz151rr99240jq55rs39y741m8shh9yihl3x95rkjxchji4";
    };

    nativeBuildInputs = [ pkgs.pkgconfig ];
    buildInputs = with pkgs; [ alsaLib ffmpeg libv4l sqlite libvpx ];
    propagatedBuildInputs = with self; [ cython pkgs.openssl dns dateutil xcaplib msrplib lxml python-otr ];
  };


  six = callPackage ../development/python-modules/six { };

  smartdc = buildPythonPackage rec {
    name = "smartdc-0.1.12";

    src = pkgs.fetchurl {
      url = mirror://pypi/s/smartdc/smartdc-0.1.12.tar.gz;
      sha256 = "36206f4fddecae080c66faf756712537e650936b879abb23a8c428731d2415fe";
    };

    propagatedBuildInputs = with self; [ requests http_signature ];

    meta = {
      description = "Joyent SmartDataCenter CloudAPI connector using http-signature authentication via Requests";
      homepage = https://github.com/atl/py-smartdc;
      license = licenses.mit;
    };
  };

  socksipy-branch = buildPythonPackage rec {
    name = "SocksiPy-branch-1.01";
    src = pkgs.fetchurl {
      url = mirror://pypi/S/SocksiPy-branch/SocksiPy-branch-1.01.tar.gz;
      sha256 = "01l41v4g7fy9fzvinmjxy6zcbhgqaif8dhdqm4w90fwcw9h51a8p";
    };
    meta = {
      homepage = http://code.google.com/p/socksipy-branch/;
      description = "This Python module allows you to create TCP connections through a SOCKS proxy without any special effort";
      license = licenses.bsd3;
    };
  };

  sockjs-tornado = buildPythonPackage rec {
    name = "sockjs-tornado-${version}";
    version = "1.0.3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/sockjs-tornado/${name}.tar.gz";
      sha256 = "16cff40nniqsyvda1pb2j3b4zwmrw7y2g1vqq78lp20xpmhnwwkd";
    };

    propagatedBuildInputs = with self; [ tornado ];

    meta = {
      homepage = "http://github.com/mrjoes/sockjs-tornado/";
      description = "SockJS python server implementation on top of Tornado framework";
      license = licenses.mit;
      maintainers = with maintainers; [ abbradar ];
    };
  };

  sorl_thumbnail = buildPythonPackage rec {
    name = "sorl-thumbnail-11.12";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/sorl-thumbnail/${name}.tar.gz";
      sha256 = "050b9kzbx7jvs3qwfxxshhis090hk128maasy8pi5wss6nx5kyw4";
    };

    # Disabled due to an improper configuration error when tested against django. This looks like something broken in the test cases for sorl.
    doCheck = false;

    meta = {
      homepage = http://sorl-thumbnail.readthedocs.org/en/latest/;
      description = "Thumbnails for Django";
      license = licenses.bsd3;
    };
  };

  supervisor = buildPythonPackage rec {
    name = "supervisor-3.1.4";

    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/supervisor/${name}.tar.gz";
      sha256 = "0kk0sv7780m4dzmrcb2m284krz907jh8jp7khz5a79qryy4m1xw2";
    };

    buildInputs = with self; [ mock ];
    propagatedBuildInputs = with self; [ meld3 ];

    # failing tests when building under chroot as root user doesn't exist
    doCheck = false;

    meta = {
      description = "A system for controlling process state under UNIX";
      homepage = http://supervisord.org/;
    };
  };

  subprocess32 = callPackage ../development/python-modules/subprocess32 { };

  spark_parser = buildPythonPackage (rec {
    name = "${pname}-${version}";
    pname = "spark_parser";
    version = "1.4.0";
    src = pkgs.fetchurl {
      url = "mirror://pypi/s/${pname}/${name}.tar.gz";
      sha256 = "1r7d07kw4asgajvhq1gzln4g1qi2r13jw0s8c7d5z3g4kp8y0br8";
    };
    buildInputs = with self; [nose];
    propagatedBuildInputs = [];
    meta = {
      description = ''An Early-Algorithm Context-free grammar Parser'';
      homepage = "https://github.com/rocky/python-spark";
      license = licenses.mit;
      maintainers = with maintainers; [raskin];
      platforms = platforms.all;
    };
  });

  sphinx = callPackage ../development/python-modules/sphinx { };

  sphinx_1_2 = self.sphinx.overridePythonAttrs rec {
    name = "sphinx-1.2.3";
    src = pkgs.fetchurl {
      url = "mirror://pypi/s/sphinx/sphinx-1.2.3.tar.gz";
      sha256 = "94933b64e2fe0807da0612c574a021c0dac28c7bd3c4a23723ae5a39ea8f3d04";
    };
    postPatch = '''';
    # Tests requires Pygments >=2.0.2 which isn't worth keeping around for this:
    doCheck = false;
  };

  sphinxcontrib-websupport = callPackage ../development/python-modules/sphinxcontrib-websupport { };

  hieroglyph = callPackage ../development/python-modules/hieroglyph { };

  sphinx_rtd_theme = buildPythonPackage (rec {
    name = "sphinx_rtd_theme-0.1.9";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/sphinx_rtd_theme/${name}.tar.gz";
      sha256 = "18d0r63w7jpdrk4q5qy26n08vdlmnj9sar93akwjphyambw4cf17";
    };

    postPatch = ''
      rm requirements.txt
      touch requirements.txt
    '';

    meta = {
      description = "ReadTheDocs.org theme for Sphinx, 2013 version";
      homepage = https://github.com/snide/sphinx_rtd_theme/;
      license = licenses.bsd3;
      platforms = platforms.unix;
    };
  });

  guzzle_sphinx_theme = callPackage ../development/python-modules/guzzle_sphinx_theme { };

  sphinx-testing = callPackage ../development/python-modules/sphinx-testing { };

  sphinxcontrib-blockdiag = buildPythonPackage (rec {
    name = "${pname}-${version}";
    pname = "sphinxcontrib-blockdiag";
    version = "1.5.5";
    src = pkgs.fetchurl {
      url = "mirror://pypi/s/${pname}/${name}.tar.gz";
      sha256 = "1w7q2hhpzk159wd35hlbwkh80hnglqa475blcd9vjwpkv1kgkpvw";
    };

    buildInputs = with self; [ mock sphinx-testing ];
    propagatedBuildInputs = with self; [ sphinx blockdiag ];

    # Seems to look for files in the wrong dir
    doCheck = false;
    checkPhase = ''
      ${python.interpreter} -m unittest discover -s tests
    '';

    meta = {
      description = "Sphinx blockdiag extension";
      homepage = "https://github.com/blockdiag/sphinxcontrib-blockdiag";
      maintainers = with maintainers; [ nand0p ];
      license = licenses.bsd2;
    };
  });

  sphinxcontrib-openapi = buildPythonPackage (rec {
    name = "sphinxcontrib-openapi-0.3.0";

    doCheck = false;

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/sphinxcontrib-openapi/${name}.tar.gz";
      sha256 = "0fyniq37nnmhrk4j7mzvg6vfcpb624hb9x70g6mccyw4xrnhadv6";
    };

    propagatedBuildInputs = with self; [setuptools_scm pyyaml jsonschema sphinxcontrib_httpdomain];
  });

  sphinxcontrib_httpdomain = buildPythonPackage (rec {
    name = "sphinxcontrib-httpdomain-1.5.0";

    # Check is disabled due to this issue:
    # https://bitbucket.org/pypa/setuptools/issue/137/typeerror-unorderable-types-str-nonetype
    doCheck = false;

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/sphinxcontrib-httpdomain/${name}.tar.gz";
      sha256 = "0srg8lwf4m1hyhz942fcdfxh689xphndngiidb575qmfbi89gc7a";
    };

    propagatedBuildInputs = with self; [sphinx];

    meta = {
      description = "Provides a Sphinx domain for describing RESTful HTTP APIs";

      homepage = https://bitbucket.org/birkenfeld/sphinx-contrib;

      license = "BSD";
    };
  });

  sphinxcontrib_newsfeed = buildPythonPackage (rec {
    name = "sphinxcontrib-newsfeed-${version}";
    version = "0.1.4";
    src = pkgs.fetchurl {
      url = "mirror://pypi/s/sphinxcontrib-newsfeed/${name}.tar.gz";
      sha256 = "1d7gam3mn8v4in4p16yn3v10vps7nnaz6ilw99j4klij39dqd37p";
    };

    propagatedBuildInputs = with self; [sphinx];

    meta = {
      description = "Extension for adding a simple Blog, News or Announcements section to a Sphinx website";
      homepage = https://bitbucket.org/prometheus/sphinxcontrib-newsfeed;
      license = licenses.bsd2;
    };
  });

  sphinxcontrib_plantuml = buildPythonPackage (rec {
    name = "sphinxcontrib-plantuml-0.7";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/sphinxcontrib-plantuml/${name}.tar.gz";
      sha256 = "011yprqf41dcm1824zgk2w8vi9115286pmli6apwhlrsxc6b6cwv";
    };

    # No tests included.
    doCheck = false;

    propagatedBuildInputs = with self; [sphinx plantuml];

    meta = {
      description = "Provides a Sphinx domain for embedding UML diagram with PlantUML";
      homepage = https://bitbucket.org/birkenfeld/sphinx-contrib;
      license = with licenses; [ bsd2 ];
    };
  });

  sphinxcontrib-spelling = buildPythonPackage (rec {
    name = "${pname}-${version}";
    pname = "sphinxcontrib-spelling";
    version = "2.2.0";
    src = pkgs.fetchurl {
      url = "mirror://pypi/s/${pname}/${name}.tar.gz";
      sha256 = "1f0fymrk4kvhqs0vj9gay4lhacxkfrlrpj4gvg0p4wjdczplxd3z";
    };
    propagatedBuildInputs = with self; [ sphinx pyenchant pbr ];
    # No tests included
    doCheck = false;
    meta = {
      description = "Sphinx spelling extension";
      homepage = "http://bitbucket.org/dhellmann/sphinxcontrib-spelling";
      maintainers = with maintainers; [ nand0p ];
      license = licenses.bsd2;
    };
  });

  sphinx-jinja = buildPythonPackage (rec {
    name = "${pname}-${version}";
    pname = "sphinx-jinja";
    version = "0.2.1";
    src = pkgs.fetchurl {
      url = "mirror://pypi/s/${pname}/${name}.tar.gz";
      sha256 = "1zsnhc573rvaww9qqyzs4f5h4hhvxklvppv14450vi5dk8rij81z";
    };
    buildInputs = with self; [ sphinx-testing pytest pbr];
    propagatedBuildInputs = with self; [ sphinx blockdiag ];
    checkPhase = ''
      py.test -k "not test_build_epub"
    '';
    disabled = isPy3k;
    meta = {
      description = "includes jinja templates in a documentation";
      maintainers = with maintainers; [ nand0p ];
      license = licenses.mit;
    };
  });

  sphinx_pypi_upload = buildPythonPackage (rec {
    name = "Sphinx-PyPI-upload-0.2.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/S/Sphinx-PyPI-upload/${name}.tar.gz";
      sha256 = "5f919a47ce7a7e6028dba809de81ae1297ac192347cf6fc54efca919d4865159";
    };

    meta = {
      description = "Setuptools command for uploading Sphinx documentation to PyPI";

      homepage = https://bitbucket.org/jezdez/sphinx-pypi-upload/;

      license = "BSD";
    };
  });

  spotipy = callPackage ../development/python-modules/spotipy { };

  Pweave = buildPythonPackage (rec {
    name = "Pweave-0.25";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/f6/2f/e9735b04747ae5ef29d64e0b215fb0e11f1c89826097ac17342efebbbb84/Pweave-0.25.tar.gz";
      sha256 = "1isqjz66c7vxdaqfwpkspki9p4054dsfx7pznwz28ik634hnj3qw";
    };

    buildInputs = with self; [ mock pkgs.glibcLocales ];

    propagatedBuildInputs = with self; [
      matplotlib
    ];

    # fails due to trying to run CSS as test
    doCheck = false;

    meta = {
      description = "Scientific reports with embedded python computations with reST, LaTeX or markdown";
      homepage = http://mpastell.com/pweave/ ;
      license = licenses.bsd3;
    };
  });

  spyder = callPackage ../applications/science/spyder { };

  sqlalchemy = callPackage ../development/python-modules/sqlalchemy { };

  SQLAlchemy-ImageAttach = buildPythonPackage rec {
    pname = "SQLAlchemy-ImageAttach";
    version = "1.0.0";
    name = "${pname}-${version}";

    src = pkgs.fetchFromGitHub {
      repo = "sqlalchemy-imageattach";
      owner = "dahlia";
      rev = "${version}";
      sha256 = "0ba97pn5dh00qvxyjbr0mr3pilxqw5kb3a6jd4wwbsfcv6nngqig";
    };

    checkInputs = with self; [ pytest Wand.imagemagick webob ];
    propagatedBuildInputs = with self; [ sqlalchemy Wand ];

    checkPhase = ''
      cd tests
      export MAGICK_HOME="${pkgs.imagemagick.dev}"
      export PYTHONPATH=$PYTHONPATH:../
      py.test
      cd ..
    '';
    doCheck = !isPyPy;  # failures due to sqla version mismatch

    meta = {
      homepage = https://github.com/dahlia/sqlalchemy-imageattach;
      description = "SQLAlchemy extension for attaching images to entity objects";
      license = licenses.mit;
    };
  };

  sqlalchemy_migrate = callPackage ../development/python-modules/sqlalchemy-migrate { };

  sqlparse = buildPythonPackage rec {
    name = "sqlparse-${version}";
    version = "0.2.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/sqlparse/${name}.tar.gz";
      sha256 = "08dszglfhf1c4rwqinkbp4x55v0b90rgm1fxc1l4dy965imjjinl";
    };

    buildInputs = with self; [ pytest ];
    checkPhase = ''
      py.test
    '';

    # Package supports 3.x, but tests are clearly 2.x only.
    doCheck = !isPy3k;

    meta = {
      description = "Non-validating SQL parser for Python";
      longDescription = ''
        Provides support for parsing, splitting and formatting SQL statements.
      '';
      homepage = https://github.com/andialbrecht/sqlparse;
      license = licenses.bsd3;
      maintainers = with maintainers; [ nckx ];
    };
  };

  statsmodels = callPackage ../development/python-modules/statsmodels { };

  python_statsd = buildPythonPackage rec {
    name = "python-statsd-${version}";
    version = "1.6.0";
    disabled = isPy3k;  # next release will be py3k compatible

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/python-statsd/${name}.tar.gz";
      sha256 = "3d2fc153e0d894aa9983531ef47d20d75bd4ee9fd0e46a9d82f452dde58a0a71";
    };

    buildInputs = with self; [ mock nose coverage ];

    meta = {
      description = "A client for Etsy's node-js statsd server";
      homepage = https://github.com/WoLpH/python-statsd;
      license = licenses.bsd3;
    };
  };


  stompclient = buildPythonPackage (rec {
    name = "stompclient-0.3.2";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/stompclient/${name}.tar.gz";
      sha256 = "95a4e98dd0bba348714439ea11a25ee8a74acb8953f95a683924b5bf2a527e4e";
    };

    buildInputs = with self; [ mock nose ];

    # XXX: Ran 0 tests in 0.217s

    meta = {
      description = "Lightweight and extensible STOMP messaging client";
      homepage = https://bitbucket.org/hozn/stompclient;
      license = licenses.asl20;
    };
  });

  subdownloader = buildPythonPackage rec {
    version = "2.0.18";
    name = "subdownloader-${version}";

    src = pkgs.fetchurl {
      url = "https://launchpad.net/subdownloader/trunk/2.0.18/+download/subdownloader_2.0.18.orig.tar.gz";
      sha256 = "0manlfdpb585niw23ibb8n21mindd1bazp0pnxvmdjrp2mnw97ig";
    };

    propagatedBuildInputs = with self; [ mmpython pyqt4 ];

    setup = ''
      import os
      import sys

      try:
          if os.environ.get("NO_SETUPTOOLS"):
              raise ImportError()
          from setuptools import setup, Extension
          SETUPTOOLS = True
      except ImportError:
          SETUPTOOLS = False
          # Use distutils.core as a fallback.
          # We won t be able to build the Wheel file on Windows.
          from distutils.core import setup, Extension

      with open("README") as fp:
          long_description = fp.read()

      requirements = [ ]

      install_options = {
          "name": "subdownloader",
          "version": "2.0.18",
          "description": "Tool for automatic download/upload subtitles for videofiles using fast hashing",
          "long_description": long_description,
          "url": "http://www.subdownloader.net",

          "scripts": ["run.py"],
          "packages": ["cli", "FileManagement", "gui", "languages", "modules"],

      }
      if SETUPTOOLS:
          install_options["install_requires"] = requirements

      setup(**install_options)
    '';

    postUnpack = ''
      echo '${setup}' > $sourceRoot/setup.py
    '';

    meta = {
      description = "Tool for automatic download/upload subtitles for videofiles using fast hashing";
      homepage = http://www.subdownloader.net;
      license = licenses.gpl3;
      maintainers = with maintainers; [ ];
    };
  };

  subunit = buildPythonPackage rec {
    name = pkgs.subunit.name;
    src = pkgs.subunit.src;

    propagatedBuildInputs = with self; [ testtools testscenarios ];
    nativeBuildInputs = [ pkgs.pkgconfig ];
    buildInputs = [ pkgs.check pkgs.cppunit ];

    patchPhase = ''
      sed -i 's/version=VERSION/version="${pkgs.subunit.version}"/' setup.py
    '';

    meta = pkgs.subunit.meta;
  };

  sure = buildPythonPackage rec {
    name = "sure-${version}";
    version = "1.2.24";

    LC_ALL="en_US.UTF-8";

    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/sure/${name}.tar.gz";
      sha256 = "1lyjq0rvkbv585dppjdq90lbkm6gyvag3wgrggjzyh7cpyh5c12w";
    };

    buildInputs = with self; [ nose pkgs.glibcLocales ];

    propagatedBuildInputs = with self; [ six mock ];

    meta = {
      description = "Utility belt for automated testing";
      homepage = "http://falcao.it/sure/";
      license = licenses.gpl3Plus;
    };
  };

  structlog = buildPythonPackage rec {
    name = "structlog-16.1.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/structlog/${name}.tar.gz";
      sha256 = "00dywyg3bqlkrmbrfrql21hpjjjkc4zjd6xxjyxyd15brfnzlkdl";
    };

    buildInputs = with self; [ pytest pretend freezegun ];
    propagatedBuildInputs = with self; [ simplejson ];

    checkPhase = ''
      rm tests/test_twisted.py*
      py.test
    '';

    meta = {
      description = "Painless structural logging";
      homepage = http://www.structlog.org/;
      license = licenses.asl20;
    };
  };

  svgwrite = buildPythonPackage rec {
    name = "svgwrite-${version}";
    version = "1.1.6";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/svgwrite/${name}.tar.gz";
      sha256 = "1f018813072aa4d7e95e58f133acb3f68fa7de0a0d89ec9402cc38406a0ec5b8";
    };

    buildInputs = with self; [ setuptools ];
    propagatedBuildInputs = with self; [ pyparsing ];

    meta = {
      description = "A Python library to create SVG drawings";
      homepage = https://bitbucket.org/mozman/svgwrite;
      license = licenses.mit;
    };
  };

  freezegun = buildPythonPackage rec {
    name = "freezegun-${version}";
    version = "0.3.8";

    src = pkgs.fetchurl {
      url = "mirror://pypi/f/freezegun/freezegun-${version}.tar.gz";
      sha256 = "1sf38d3ibv1jhhvr52x7dhrsiyqk1hm165dfv8w8wh0fhmgxg151";
    };

    propagatedBuildInputs = with self; [
      dateutil six
    ];
    buildInputs = [ self.mock self.nose ];

    meta = with stdenv.lib; {
      description = "FreezeGun: Let your Python tests travel through time";
      homepage = "https://github.com/spulec/freezegun";
      license = licenses.asl20;
    };
  };

  sybil = callPackage ../development/python-modules/sybil { };

  syncthing-gtk = buildPythonPackage rec {
    version = "0.9.2.3";
    name = "syncthing-gtk-${version}";
    src = pkgs.fetchFromGitHub {
      owner = "syncthing";
      repo = "syncthing-gtk";
      rev = "v${version}";
      sha256 = "0chl0f0kp6z0z00d1f3xjlicjfr9rzabw39wmjr66fwb5w5hcc42";
    };

    disabled = isPy3k;

    propagatedBuildInputs = with self; [ pkgs.syncthing dateutil pyinotify
      pkgs.libnotify
      (pkgs.librsvg.override { withGTK = true; })
      pkgs.psmisc pygobject3 pkgs.gtk3
    ];

    preFixup = ''
      wrapProgram $out/bin/syncthing-gtk \
        --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
        --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH"
    '';

    patchPhase = ''
        substituteInPlace setup.py --replace "version = get_version()" "version = '${version}'"
        substituteInPlace scripts/syncthing-gtk --replace "/usr/share" "$out/share"
        substituteInPlace syncthing_gtk/app.py --replace "/usr/share" "$out/share"
        substituteInPlace syncthing_gtk/wizard.py --replace "/usr/share" "$out/share"
        substituteInPlace syncthing-gtk.desktop --replace "/usr/bin/syncthing-gtk" "$out/bin/syncthing-gtk"
    '';

    meta = {
      description = " GTK3 & python based GUI for Syncthing ";
      maintainers = with maintainers; [ ];
      platforms = pkgs.syncthing.meta.platforms;
      homepage = "https://github.com/syncthing/syncthing-gtk";
      license = licenses.gpl2;
    };
  };

  systemd = callPackage ../development/python-modules/systemd {
    inherit (pkgs) pkgconfig systemd;
  };

  tabulate = callPackage ../development/python-modules/tabulate { };

  taskw = buildPythonPackage rec {
    version = "1.0.3";
    name = "taskw-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/taskw/${name}.tar.gz";
      sha256 = "1fa7bv5996ppfbryv02lpnlhk5dra63lhlwrb1i4ifqbziqfqh5n";
    };

    patches = [ ../development/python-modules/taskw/use-template-for-taskwarrior-install-path.patch ];
    postPatch = ''
      substituteInPlace taskw/warrior.py \
        --replace '@@taskwarrior@@' '${pkgs.taskwarrior}'
    '';

    # https://github.com/ralphbean/taskw/issues/98
    doCheck = false;

    buildInputs = with self; [ nose pkgs.taskwarrior tox ];
    propagatedBuildInputs = with self; [ six dateutil pytz ];

    meta = {
      homepage =  http://github.com/ralphbean/taskw;
      description = "Python bindings for your taskwarrior database";
      license = licenses.gpl3Plus;
      platforms = platforms.all;
      maintainers = with maintainers; [ pierron ];
    };
  };

  tempita = buildPythonPackage rec {
    version = "0.5.2";
    name = "tempita-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/T/Tempita/Tempita-${version}.tar.gz";
      sha256 = "cacecf0baa674d356641f1d406b8bff1d756d739c46b869a54de515d08e6fc9c";
    };

    disabled = isPy3k;

    buildInputs = with self; [ nose ];

    meta = {
      homepage = http://pythonpaste.org/tempita/;
      description = "A very small text templating language";
    };
  };

  terminado = buildPythonPackage rec {
    name = "terminado-${version}";
    version = "0.6";

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/terminado/${name}.tar.gz";
      sha256 = "2c0ba1f624067dccaaead7d2247cfe029806355cef124dc2ccb53c83229f0126";
    };

    propagatedBuildInputs = with self; [ ptyprocess tornado ];

    meta = {
      description = "Terminals served to term.js using Tornado websockets";
      homepage = https://github.com/takluyver/terminado;
      license = licenses.bsd2;
    };
  };

  terminaltables = buildPythonPackage rec {
    name = "terminaltables-${version}";
    version = "3.1.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/terminaltables/${name}.tar.gz";
      sha256 = "f3eb0eb92e3833972ac36796293ca0906e998dc3be91fbe1f8615b331b853b81";
    };

    meta = {
      description = "Display simple tables in terminals";
      homepage = "https://github.com/Robpol86/terminaltables";
      license = licenses.mit;
    };
  };

  keystoneclient = callPackage ../development/python-modules/keystoneclient { };

  keystonemiddleware = buildPythonPackage rec {
    name = "keystonemiddleware-${version}";
    version = "2.4.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/k/keystonemiddleware/${name}.tar.gz";
      sha256 = "0avrn1f897rnam9wfdanpdwsmn8is3ncfh3nnzq3d1m31b1yqqr6";
    };

    buildInputs = with self; [
      fixtures mock pycrypto oslosphinx oslotest stevedore testrepository
      testresources testtools bandit requests-mock memcached
      pkgs.openssl
    ];
    propagatedBuildInputs = with self; [
      pbr Babel oslo-config oslo-context oslo-i18n oslo-serialization oslo-utils
      requests six webob keystoneclient pycadf oslo-messaging
    ];

    # lots of "unhashable type" errors
    doCheck = false;
  };

  testscenarios = buildPythonPackage rec {
    name = "testscenarios-${version}";
    version = "0.4";

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/testscenarios/${name}.tar.gz";
      sha256 = "1671jvrvqlmbnc42j7pc5y6vc37q44aiwrq0zic652pxyy2fxvjg";
    };

    propagatedBuildInputs = with self; [ testtools ];

    meta = {
      description = "A pyunit extension for dependency injection";
      homepage = https://pypi.python.org/pypi/testscenarios;
      license = licenses.asl20;
    };
  };

  testpath = buildPythonPackage rec {
    pname = "testpath";
    version = "0.3";
    name = "${pname}-${version}";

    #format = "flit";
    #src = pkgs.fetchFromGitHub {
    #  owner = "jupyter";
    #  repo = pname;
    #  rev = "${version}";
    #  sha256 = "1ghzmkrsrk9xrj42pjsq5gl7v3g2v0ji0xy0xzzxp5aizd3wrvl9";
    #};
    #doCheck = true;
    #checkPhase = ''
    #  ${python.interpreter} -m unittest discover
    #'';
    format = "wheel";
    src = fetchPypi {
      inherit pname version format;
      sha256 = "f16b2cb3b03e1ada4fb0200b265a4446f92f3ba4b9d88ace34f51c54ab6d294e";
    };

    meta = {
      description = "Test utilities for code working with files and commands";
      license = licenses.mit;
      homepage = https://github.com/jupyter/testpath;
    };
  };

  testrepository = buildPythonPackage rec {
    name = "testrepository-${version}";
    version = "0.0.20";

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/testrepository/${name}.tar.gz";
      sha256 = "1ssqb07c277010i6gzzkbdd46gd9mrj0bi0i8vn560n2k2y4j93m";
    };

    buildInputs = with self; [ testtools testresources ];
    propagatedBuildInputs = with self; [ pbr subunit fixtures ];

    checkPhase = ''
      ${python.interpreter} ./testr
    '';

    meta = {
      description = "A database of test results which can be used as part of developer workflow";
      homepage = https://pypi.python.org/pypi/testrepository;
      license = licenses.bsd2;
    };
  };

  testresources = buildPythonPackage rec {
    name = "testresources-${version}";
    version = "0.2.7";

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/testresources/${name}.tar.gz";
      sha256 = "0cbj3plbllyz42c4b5xxgwaa7mml54lakslrn4kkhinxhdri22md";
    };

    meta = {
      description = "Pyunit extension for managing expensive test resources";
      homepage = https://pypi.python.org/pypi/testresources/;
      license = licenses.bsd2;
    };
  };

  testtools = callPackage ../development/python-modules/testtools { };

  traitlets = callPackage ../development/python-modules/traitlets { };

  python_mimeparse = buildPythonPackage rec {
    name = "python-mimeparse-${version}";
    version = "0.1.4";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/python-mimeparse/${name}.tar.gz";
      sha256 = "1hyxg09kaj02ri0rmwjqi86wk4nd1akvv7n0dx77azz76wga4s9w";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      description = "A module provides basic functions for parsing mime-type names and matching them against a list of media-ranges";
      homepage = https://code.google.com/p/mimeparse/;
      license = licenses.mit;
    };
  };


  extras = buildPythonPackage rec {
    name = "extras-${version}";
    version = "0.0.3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/e/extras/extras-${version}.tar.gz";
      sha256 = "1h7zx4dfyclalg0fqnfjijpn0f793a9mx8sy3b27gd31nr6dhq3s";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      description = "A module provides basic functions for parsing mime-type names and matching them against a list of media-ranges";
      homepage = https://code.google.com/p/mimeparse/;
      license = licenses.mit;
    };
  };

  texttable = self.buildPythonPackage rec {
    name = "texttable-0.8.4";

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/texttable/${name}.tar.gz";
      sha256 = "0bkhs4dx9s6g7fpb969hygq56hyz4ncfamlynw72s0n6nqfbd1w5";
    };

    meta = {
      description = "A module to generate a formatted text table, using ASCII characters";
      homepage = http://foutaise.org/code/;
      license = licenses.lgpl2;
    };
  };

  tiros = callPackage ../development/python-modules/tiros { };

  # Tkinter/tkinter is part of the Python standard library.
  # The Python interpreters in Nixpkgs come without tkinter by default.
  # To make the module available, we make it available as any other
  # Python package.
  tkinter = let
    py = python.override{x11Support=true;};
  in buildPythonPackage rec {
    name = "tkinter-${python.version}";
    src = py;
    format = "other";

    disabled = isPy26 || isPyPy;

    installPhase = ''
      # Move the tkinter module
      mkdir -p $out/${py.sitePackages}
      mv lib/${py.libPrefix}/lib-dynload/_tkinter* $out/${py.sitePackages}/
      # Update the rpath to point to python without x11Support
      old_rpath=$(patchelf --print-rpath $out/${py.sitePackages}/_tkinter*)
      new_rpath=$(sed "s#${py}#${python}#g" <<< "$old_rpath" )
      patchelf --set-rpath $new_rpath $out/${py.sitePackages}/_tkinter*
    '';

    inherit (py) meta;
  };

  tlslite = buildPythonPackage rec {
    name = "tlslite-${version}";
    version = "0.4.8";

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/tlslite/${name}.tar.gz";
      sha256 = "1fxx6d3nw5r1hqna1h2jvqhcygn9fyshlm0gh3gp0b1ji824gd6r";
    };

    meta = {
      description = "A pure Python implementation of SSL and TLS";
      homepage = https://pypi.python.org/pypi/tlslite;
      license = licenses.bsd3;
    };
  };

  qrcode = buildPythonPackage rec {
    name = "qrcode-${version}";
    version = "5.3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/q/qrcode/${name}.tar.gz";
      sha256 = "0kljfrfq0c2rmxf8am57333ia41kd0snbm2rnqbdy816hgpcq5a1";
    };

    propagatedBuildInputs = with self; [ six pillow pymaging_png ];

    meta = {
      description = "Quick Response code generation for Python";
      homepage = "https://pypi.python.org/pypi/qrcode";
      license = licenses.bsd3;
    };
  };

  tmdb3 = buildPythonPackage rec {
    name = "tmdb3-${version}";
    version = "0.6.17";

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/tmdb3/${name}.zip";
      sha256 = "64a6c3f1a60a9d8bf18f96a5403f3735b334040345ac3646064931c209720972";
    };

    meta = {
      description = "Python implementation of the v3 API for TheMovieDB.org, allowing access to movie and cast information";
      homepage = https://pypi.python.org/pypi/tmdb3;
      license = licenses.bsd3;
    };
  };

  toolz = callPackage ../development/python-modules/toolz { };

  tox = buildPythonPackage rec {
    name = "tox-${version}";
    version = "2.4.1";

    propagatedBuildInputs = with self; [ py virtualenv pluggy ];

    doCheck = false;

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/tox/${name}.tar.gz";
      sha256 = "1nwn4jz8ns53n17bm1xkzlz4zyyxbgjwrcg2cjsn25ab7hd5fwv6";
    };
  };

  tqdm = callPackage ../development/python-modules/tqdm { };

  smmap = buildPythonPackage rec {
    name = "smmap-0.9.0";
    disabled = isPyPy;  # This fails the tests if built with pypy
    meta.maintainers = with maintainers; [ mornfall ];

    buildInputs = with self; [ nosexcover ];

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/smmap/${name}.tar.gz";
      sha256 = "0qlx25f6n2n9ff37w9gg62f217fzj16xlbh0pkz0lpxxjys64aqf";
    };
  };

  traits = buildPythonPackage rec {
    name = "traits-${version}";
    version = "4.5.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/traits/${name}.tar.gz";
      sha256 = "5293a8786030b0b243e059f52004355b6939d7c0f1be2eb5a605b63cca484c84";
    };

    # Use pytest because its easier to discover tests
    buildInputs = with self; [ pytest ];
    checkPhase = ''
      py.test $out/${python.sitePackages}
    '';

    # Test suite is broken for 3.x on latest release
    # https://github.com/enthought/traits/issues/187
    # https://github.com/enthought/traits/pull/188
    # Furthermore, some tests fail due to being in a chroot
    doCheck = false;

    propagatedBuildInputs = with self; [ numpy ];

    meta = {
      description = "Explicitly typed attributes for Python";
      homepage = https://pypi.python.org/pypi/traits;
      license = "BSD";
    };
  };


  transaction = callPackage ../development/python-modules/transaction { };


  transmissionrpc = buildPythonPackage rec {
    name = "transmissionrpc-${version}";
    version = "0.11";

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/transmissionrpc/${name}.tar.gz";
      sha256 = "ec43b460f9fde2faedbfa6d663ef495b3fd69df855a135eebe8f8a741c0dde60";
    };

    propagatedBuildInputs = with self; [ six ];

    meta = {
      description = "Python implementation of the Transmission bittorent client RPC protocol";
      homepage = https://pypi.python.org/pypi/transmissionrpc/;
      license = licenses.mit;
    };
  };

  eggdeps  = buildPythonPackage rec {
     name = "eggdeps-${version}";
     version = "0.4";

     src = pkgs.fetchurl {
       url = "mirror://pypi/t/tl.eggdeps/tl.${name}.tar.gz";
       sha256 = "a99de5e4652865224daab09b2e2574a4f7c1d0d9a267048f9836aa914a2caf3a";
     };

     # tests fail, see http://hydra.nixos.org/build/4316603/log/raw
     doCheck = false;

     propagatedBuildInputs = with self; [ zope_interface zope_testing ];
     meta = {
       description = "A tool which computes a dependency graph between active Python eggs";
       homepage = http://thomas-lotze.de/en/software/eggdeps/;
       license = licenses.zpl20;
     };
   };


  tweepy = buildPythonPackage (rec {
    name = "tweepy-3.5.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/tweepy/${name}.tar.gz";
      sha256 = "0n2shilamgwhzmvf534xg7f6hrnznbixyl5pw2f5a3f391gwy37h";
    };

    doCheck = false;
    propagatedBuildInputs = with self; [ requests six requests_oauthlib ];

    meta = {
      homepage = "https://github.com/tweepy/tweepy";
      description = "Twitter library for python";
      license = licenses.mit;
      maintainers = with maintainers; [ garbas ];
      platforms = platforms.linux;
    };
  });

  twiggy = buildPythonPackage rec {
    name = "Twiggy-${version}";
    version = "0.4.5";

    src = pkgs.fetchurl {
      url    = "mirror://pypi/T/Twiggy/Twiggy-0.4.5.tar.gz";
      sha256 = "4e8f1894e5aee522db6cb245ccbfde3c5d1aa08d31330c7e3af783b0e66eec23";
    };

    doCheck = false;

    meta = {
      homepage = http://twiggy.wearpants.org;
      # Taken from http://i.wearpants.org/blog/meet-twiggy/
      description = "Twiggy is the first totally new design for a logger since log4j";
      license     = licenses.bsd3;
      platforms = platforms.all;
      maintainers = with maintainers; [ pierron ];
    };
  };

  twill = callPackage ../development/python-modules/twill { };

  twitter = buildPythonPackage rec {
    name = "twitter-${version}";
    version = "1.15.0";

    src = pkgs.fetchurl {
      url    = "mirror://pypi/t/twitter/${name}.tar.gz";
      sha256 = "1m6b17irb9klc345k8174pni724jzy2973z2x2jg69h83hipjw2c";
    };

    doCheck = false;

    meta = {
      description = "Twitter API library";
      license     = licenses.mit;
      maintainers = with maintainers; [ thoughtpolice ];
    };
  };

  twitter-common-collections = buildPythonPackage rec {
    pname   = "twitter.common.collections";
    version = "0.3.9";
    name    = "${pname}-${version}";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "0wf8ks6y2kalx2inzayq0w4kh3kg25daik1ac7r6y79i03fslsc5";
    };

    propagatedBuildInputs = with self; [ twitter-common-lang ];

    meta = {
      description = "Twitter's common collections";
      homepage    = "https://twitter.github.io/commons/";
      license     = licenses.asl20;
      maintainers = with maintainers; [ copumpkin ];
    };
  };

  twitter-common-confluence = buildPythonPackage rec {
    pname   = "twitter.common.confluence";
    version = "0.3.9";
    name    = "${pname}-${version}";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1i2fjn23cmms81f1fhvvkg6hgzqpw07dlqg3ydz6cqv2glw7zq26";
    };

    propagatedBuildInputs = with self; [ twitter-common-log ];

    meta = {
      description = "Twitter's API to the confluence wiki";
      homepage    = "https://twitter.github.io/commons/";
      license     = licenses.asl20;
      maintainers = with maintainers; [ copumpkin ];
    };
  };

  twitter-common-dirutil = buildPythonPackage rec {
    pname   = "twitter.common.dirutil";
    version = "0.3.9";
    name    = "${pname}-${version}";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1wpjfmmxsdwnbx5dl13is4zkkpfcm94ksbzas9y2qhgswfa9jqha";
    };

    propagatedBuildInputs = with self; [ twitter-common-lang ];

    meta = {
      description = "Utilities for manipulating and finding files and directories";
      homepage    = "https://twitter.github.io/commons/";
      license     = licenses.asl20;
      maintainers = with maintainers; [ copumpkin ];
    };
  };

  twitter-common-lang = buildPythonPackage rec {
    pname   = "twitter.common.lang";
    version = "0.3.9";
    name    = "${pname}-${version}";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1l8fmnsrx7hgg3ivslg588rnl9n1gfjn2w6224fr8rs7zmkd5lan";
    };

    meta = {
      description = "Twitter's 2.x / 3.x compatibility swiss-army knife";
      homepage    = "https://twitter.github.io/commons/";
      license     = licenses.asl20;
      maintainers = with maintainers; [ copumpkin ];
    };
  };

  twitter-common-log = buildPythonPackage rec {
    pname   = "twitter.common.log";
    version = "0.3.9";
    name    = "${pname}-${version}";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1bdzbxx2bxwpf57xaxfz1nblzgfvhlidz8xqd7s84c62r3prh02v";
    };

    propagatedBuildInputs = with self; [ twitter-common-options twitter-common-dirutil ];

    meta = {
      description = "Twitter's common logging library";
      homepage    = "https://twitter.github.io/commons/";
      license     = licenses.asl20;
      maintainers = with maintainers; [ copumpkin ];
    };
  };

  twitter-common-options = buildPythonPackage rec {
    pname   = "twitter.common.options";
    version = "0.3.9";
    name    = "${pname}-${version}";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "0d1czag5mcxg0vcnlklspl2dvdab9kmznsycj04d3vggi158ljrd";
    };

    meta = {
      description = "Twitter's optparse wrapper";
      homepage    = "https://twitter.github.io/commons/";
      license     = licenses.asl20;
      maintainers = with maintainers; [ copumpkin ];
    };
  };

  twine = callPackage ../development/python-modules/twine { };

  twisted = callPackage ../development/python-modules/twisted { };

  txtorcon = callPackage ../development/python-modules/txtorcon { };

  tzlocal = callPackage ../development/python-modules/tzlocal { };

  u-msgpack-python = callPackage ../development/python-modules/u-msgpack-python { };

  ukpostcodeparser = callPackage ../development/python-modules/ukpostcodeparser { };

  umalqurra = buildPythonPackage rec {
    name = "umalqurra-${version}";
    version = "0.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/u/umalqurra/umalqurra-0.2.tar.gz";
      sha256 = "719f6a36f908ada1c29dae0d934dd0f1e1f6e3305784edbec23ad719397de678";
    };

    # No tests included
    doCheck = false;

    # See for license
    # https://github.com/tytkal/python-hijiri-ummalqura/issues/4
    meta = {
      description = "Date Api that support Hijri Umalqurra calendar";
      homepage = https://github.com/tytkal/python-hijiri-ummalqura;
      license = with licenses; [ publicDomain ];
    };

  };

  umemcache = callPackage ../development/python-modules/umemcache {};

  unicodecsv = buildPythonPackage rec {
    version = "0.14.1";
    name = "unicodecsv-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/u/unicodecsv/${name}.tar.gz";
      sha256 = "1z7pdwkr6lpsa7xbyvaly7pq3akflbnz8gq62829lr28gl1hi301";
    };

    # ImportError: No module named runtests
    doCheck = false;

    meta = {
      description = "Drop-in replacement for Python2's stdlib csv module, with unicode support";
      homepage = https://github.com/jdunck/python-unicodecsv;
      maintainers = with maintainers; [ koral ];
    };
  };

  unittest2 = buildPythonPackage rec {
    version = "1.1.0";
    name = "unittest2-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/u/unittest2/unittest2-${version}.tar.gz";
      sha256 = "0y855kmx7a8rnf81d3lh5lyxai1908xjp0laf4glwa4c8472m212";
    };

    # # 1.0.0 and up create a circle dependency with traceback2/pbr
    doCheck = false;

    postPatch = ''
      # argparse is needed for python < 2.7, which we do not support anymore.
      substituteInPlace setup.py --replace "argparse" ""

      # # fixes a transient error when collecting tests, see https://bugs.launchpad.net/python-neutronclient/+bug/1508547
      sed -i '510i\        return None, False' unittest2/loader.py
      # https://github.com/pypa/packaging/pull/36
      sed -i 's/version=VERSION/version=str(VERSION)/' setup.py
    '';

    propagatedBuildInputs = with self; [ six traceback2 ];

    meta = {
      description = "A backport of the new features added to the unittest testing framework";
      homepage = https://pypi.python.org/pypi/unittest2;
    };
  };

  uritemplate_py = buildPythonPackage rec {
    name = "uritemplate.py-${version}";
    version = "0.3.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/u/uritemplate.py/${name}.tar.gz";
      sha256 = "0xvvdiwnag2pdi96hjf7v8asdia98flk2rxcjqnwcs3rk99alygx";
    };

    meta = with stdenv.lib; {
      homepage = https://github.com/uri-templates/uritemplate-py;
      description = "Python implementation of URI Template";
      license = licenses.asl20;
      maintainers = with maintainers; [ pSub ];
    };
  };

  uritools = callPackage ../development/python-modules/uritools { };

  traceback2 = buildPythonPackage rec {
    version = "1.4.0";
    name = "traceback2-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/traceback2/traceback2-${version}.tar.gz";
      sha256 = "0c1h3jas1jp1fdbn9z2mrgn3jj0hw1x3yhnkxp7jw34q15xcdb05";
    };

    propagatedBuildInputs = with self; [ pbr linecache2 ];
    # circular dependencies for tests
    doCheck = false;

    meta = {
      description = "A backport of traceback to older supported Pythons";
      homepage = https://pypi.python.org/pypi/traceback2/;
    };
  };

  linecache2 = buildPythonPackage rec {
    name = "linecache2-${version}";
    version = "1.0.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/l/linecache2/${name}.tar.gz";
      sha256 = "0z79g3ds5wk2lvnqw0y2jpakjf32h95bd9zmnvp7dnqhf57gy9jb";
    };

    buildInputs = with self; [ pbr ];
    # circular dependencies for tests
    doCheck = false;

    meta = with stdenv.lib; {
      description = "A backport of linecache to older supported Pythons";
      homepage = "https://github.com/testing-cabal/linecache2";
    };
  };

  upass = buildPythonPackage rec {
    version = "0.1.4";
    name = "upass-${version}";

    src = pkgs.fetchurl {
      url = "https://github.com/Kwpolska/upass/archive/v${version}.tar.gz";
      sha256 = "0f2lyi7xhvb60pvzx82dpc13ksdj5k92ww09czclkdz8k0dxa7hb";
    };

    propagatedBuildInputs = with self; [
      pyperclip
      urwid
    ];

    doCheck = false;

    meta = {
      description = "Console UI for pass";
      homepage = https://github.com/Kwpolska/upass;
      license = licenses.bsd3;
    };
  };

  update_checker = callPackage ../development/python-modules/update_checker {};

  uritemplate = buildPythonPackage rec {
    name = "uritemplate-${version}";
    version = "0.6";

    src = pkgs.fetchurl {
      url = "mirror://pypi/u/uritemplate/${name}.tar.gz";
      sha256 = "1zapwg406vkwsirnzc6mwq9fac4az8brm6d9bp5xpgkyxc5263m3";
    };

    # No tests in archive
    doCheck = false;

    propagatedBuildInputs = with self; [ simplejson ];

    meta = with stdenv.lib; {
      homepage = https://github.com/uri-templates/uritemplate-py;
      description = "Python implementation of URI Template";
      license = licenses.asl20;
      maintainers = with maintainers; [ matthiasbeyer ];
    };
  };

  uptime = buildPythonPackage rec {
    name = "uptime-${version}";
    version = "3.0.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/u/uptime/${name}.tar.gz";
      sha256 = "0wr9jkixprlywz0plyn5p42a5fd31aiwvjrxdvj7r02vfxa04c3w";
    };

    meta = with stdenv.lib; {
      homepage = https://github.com/Cairnarvon/uptime;
      description = "Cross-platform way to retrieve system uptime and boot time";
      license = licenses.bsd2;
      maintainers = with maintainers; [ rob ];
    };
  };

  urlgrabber = callPackage ../development/python-modules/urlgrabber {};

  urwid = callPackage ../development/python-modules/urwid {};

  urwidtrees = buildPythonPackage rec {
    name = "urwidtrees-${rev}";
    rev = "1.0";

    src = pkgs.fetchFromGitHub {
      owner = "pazz";
      repo = "urwidtrees";
      inherit rev;
      sha256 = "03gpcdi45z2idy1fd9zv8v9naivmpfx65hshm8r984k9wklv1dsa";
    };

    propagatedBuildInputs = with self; [ urwid ];

    meta = {
      description = "Tree widgets for urwid";
      license = licenses.gpl3;
      maintainers = with maintainers; [ profpatsch ];
    };
  };

  pyuv = buildPythonPackage rec {
    name = "pyuv-1.2.0";
    disabled = isPyPy;  # see https://github.com/saghul/pyuv/issues/49

    src = pkgs.fetchurl {
      url = "https://github.com/saghul/pyuv/archive/${name}.tar.gz";
      sha256 = "19yl1l5l6dq1xr8xcv6dhx1avm350nr4v2358iggcx4ma631rycx";
    };

    patches = [ ../development/python-modules/pyuv-external-libuv.patch ];

    buildInputs = with self; [ pkgs.libuv ];

    meta = {
      description = "Python interface for libuv";
      homepage = https://github.com/saghul/pyuv;
      repositories.git = git://github.com/saghul/pyuv.git;
      license = licenses.mit;
    };
  };

  virtkey = buildPythonPackage rec {
    name = "virtkey-${version}";
    majorVersion = "0.63";
    version = "${majorVersion}.0";

    src = pkgs.fetchurl {
      url = "https://launchpad.net/virtkey/${majorVersion}/${version}/+download/virtkey-${version}.tar.gz";
      sha256 = "0hd99hrxn6bh3rxcrdnad5cqjsphrn1s6fzx91q07d44k6cg6qcr";
    };

    nativeBuildInputs = [ pkgs.pkgconfig ];

    buildInputs =
         [ pkgs.gtk2 ]
      ++ (with pkgs.xorg; [ libX11 libXtst libXi libxkbfile xextproto xproto ]);

    meta = {
      description = "Extension to emulate keypresses and to get the layout information from the X server";
      homepage = "https://launchpad.net/virtkey";
      license = licenses.gpl3;
      maintainers = with maintainers; [ abbradar ];
    };
  };



  virtual-display = buildPythonPackage rec {
    name = "PyVirtualDisplay-0.1.5";

    propagatedBuildInputs = with self; [ EasyProcess ];

    src = pkgs.fetchurl {
      url = "mirror://pypi/P/PyVirtualDisplay/${name}.tar.gz";
      sha256 = "aa6aef08995e14c20cc670d933bfa6e70d736d0b555af309b2e989e2faa9ee53";
    };

    meta = {
      description = "Python wrapper for Xvfb, Xephyr and Xvnc";
      homepage = "https://github.com/ponty/pyvirtualdisplay";
      license = licenses.bsdOriginal;
      maintainers = with maintainers; [ layus ];
    };
  };

  virtualenv = callPackage ../development/python-modules/virtualenv { };

  virtualenv-clone = buildPythonPackage rec {
    name = "virtualenv-clone-0.2.5";

    src = pkgs.fetchurl {
      url = "mirror://pypi/v/virtualenv-clone/${name}.tar.gz";
      sha256 = "7087ba4eb48acfd5209a3fd03e15d072f28742619127c98333057e32748d91c4";
    };

    buildInputs = with self; [pytest];
    propagatedBuildInputs = with self; [virtualenv];

    # needs tox to run the tests
    doCheck = false;

    meta = {
      description = "Script to clone virtualenvs";
      license = licenses.mit;
      platforms = platforms.all;
    };
  };

  virtualenvwrapper = buildPythonPackage (rec {
    name = "virtualenvwrapper-4.3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/v/virtualenvwrapper/${name}.tar.gz";
      sha256 = "514cbc22218347bf7b54bdbe49e1a5f550d2d53b1ad2491c10e91ddf48fb528f";
    };

    # pip depend on $HOME setting
    preConfigure = "export HOME=$TMPDIR";

    buildInputs = with self; [ pbr pip pkgs.which ];
    propagatedBuildInputs = with self; [
      stevedore
      virtualenv
      virtualenv-clone
    ];

    postPatch = ''
      for file in "virtualenvwrapper.sh" "virtualenvwrapper_lazy.sh"; do
        substituteInPlace "$file" --replace "which" "${pkgs.which}/bin/which"

        # We can't set PYTHONPATH in a normal way (like exporting in a wrapper
        # script) because the user has to evaluate the script and we don't want
        # modify the global PYTHONPATH which would affect the user's
        # environment.
        # Furthermore it isn't possible to just use VIRTUALENVWRAPPER_PYTHON
        # for this workaround, because this variable is well quoted inside the
        # shell script.
        # (the trailing " -" is required to only replace things like these one:
        # "$VIRTUALENVWRAPPER_PYTHON" -c "import os,[...] and not in
        # if-statements or anything like that.
        # ...and yes, this "patch" is hacky :)
        substituteInPlace "$file" --replace '"$VIRTUALENVWRAPPER_PYTHON" -' 'env PYTHONPATH="$VIRTUALENVWRAPPER_PYTHONPATH" "$VIRTUALENVWRAPPER_PYTHON" -'
      done
    '';

    postInstall = ''
      # This might look like a dirty hack but we can't use the makeWrapper function because
      # the wrapped file were then called via "exec". The virtualenvwrapper shell scripts
      # aren't normal executables. Instead, the user has to evaluate them.

      for file in "virtualenvwrapper.sh" "virtualenvwrapper_lazy.sh"; do
        local wrapper="$out/bin/$file"
        local wrapped="$out/bin/.$file-wrapped"
        mv "$wrapper" "$wrapped"

        # WARNING: Don't indent the lines below because that would break EOF
        cat > "$wrapper" << EOF
export PATH="${python}/bin:\$PATH"
export VIRTUALENVWRAPPER_PYTHONPATH="$PYTHONPATH:$(toPythonPath $out)"
source "$wrapped"
EOF

        chmod -x "$wrapped"
        chmod +x "$wrapper"
      done
    '';

    meta = {
      description = "Enhancements to virtualenv";
      homepage = "https://pypi.python.org/pypi/virtualenvwrapper";
      license = licenses.mit;
    };
  });

  vmprof = buildPythonPackage rec {
    version = "0.3.3";
    name = "vmprof-${version}";

    # Url using old scheme doesn't seem to work
    src = pkgs.fetchurl {
      url = "https://files.pythonhosted.org/packages/c3/f3/f039ca77e727c5c2d3e61967a2a5c9ecc0ef6ca235012fd5559febb77cd0/vmprof-0.3.3.tar.gz";
      sha256 = "991bc2f1dc824c63e9b399f9e8606deded92a52378d0e449f258807d7556b039";
    };

    propagatedBuildInputs = with self; [ requests six];

    # No tests included
    doCheck = false;

    meta = {
      description = "A vmprof client";
      license = licenses.mit;
      homepage = https://vmprof.readthedocs.org/;
    };

  };

  vultr = buildPythonPackage rec {
    version = "0.1.2";
    name = "vultr-${version}";

    src = pkgs.fetchFromGitHub {
        owner = "spry-group";
        repo = "python-vultr";
        rev = "${version}";
        sha256 = "1qjvvr2v9gfnwskdl0ayazpcmiyw9zlgnijnhgq9mcri5gq9jw5h";
    };

    propagatedBuildInputs = with self; [ requests ];

    # Tests disabled. They fail because they try to access the network
    doCheck = false;

    meta = {
      description = "Vultr.com API Client";
      homepage = "https://github.com/spry-group/python-vultr";
      license = licenses.mit;
      maintainers = with maintainers; [ lihop ];
      platforms = platforms.all;
    };
  };

  waitress = buildPythonPackage rec {
    name = "waitress-1.0.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/w/waitress/${name}.tar.gz";
      sha256 = "0pw6yyxi348r2xpq3ykqnf7gwi881azv2422d2ixb0xi5jws2ky7";
    };

    doCheck = false;

    meta = {
       maintainers = with maintainers; [ garbas domenkozar ];
       platforms = platforms.all;
    };
  };

  waitress-django = callPackage ../development/python-modules/waitress-django { };

  webassets = buildPythonPackage rec {
    name = "webassets-${version}";
    version = "0.12.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/w/webassets/${name}.tar.gz";
      sha256 = "1nrqkpb7z46h2b77xafxihqv3322cwqv6293ngaky4j3ff4cing7";
    };

    buildInputs = with self; [ nose jinja2 mock pytest ];
    propagatedBuildInputs = with self; [ pyyaml ];

    doCheck = false;

    checkPhase = ''
      py.test
    '';

    meta = {
      description = "Media asset management for Python, with glue code for various web frameworks";
      homepage = "http://github.com/miracle2k/webassets/";
      license = licenses.bsd2;
      platforms = platforms.all;
      maintainers = with maintainers; [ abbradar ];
    };
  };

  webcolors = buildPythonPackage rec {
    name = "webcolors-1.4";

    src = pkgs.fetchurl {
      url = "mirror://pypi/w/webcolors/${name}.tar.gz";
      sha256 = "304fc95dab2848c7bf64f378356766e692c2f8b4a8b15fa3509544e6412936e8";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      description = "Library for working with color names/values defined by the HTML and CSS specifications";
      homepage = https://bitbucket.org/ubernostrum/webcolors/overview/;
      license = licenses.bsd3;
      platforms = platforms.unix;
    };
  };

  webencodings = callPackage ../development/python-modules/webencodings { };

  websockets = callPackage ../development/python-modules/websockets { };

  Wand = callPackage ../development/python-modules/Wand {
    imagemagick = pkgs.imagemagickBig;
  };

  wcwidth = buildPythonPackage rec {
    name = "wcwidth-${version}";
    version = "0.1.6";

    src = pkgs.fetchurl {
      url = "mirror://pypi/w/wcwidth/${name}.tar.gz";
      sha256 = "02wjrpf001gjdjsaxxbzcwfg19crlk2dbddayrfc2v06f53yrcyw";
    };

    # Checks fail due to missing tox.ini file:
    doCheck = false;

    meta = {
      description = "Measures number of Terminal column cells of wide-character codes";
      longDescription = ''
        This API is mainly for Terminal Emulator implementors -- any Python
        program that attempts to determine the printable width of a string on
        a Terminal. It is implemented in python (no C library calls) and has
        no 3rd-party dependencies.
      '';
      homepage = https://github.com/jquast/wcwidth;
      license = licenses.mit;
      maintainers = with maintainers; [ nckx ];
    };
  };

  web = buildPythonPackage rec {
    version = "0.37";
    name = "web.py-${version}";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/w/web.py/web.py-${version}.tar.gz";
      sha256 = "748c7e99ad9e36f62ea19f7965eb7dd7860b530e8f563ed60ce3e53e7409a550";
    };

    meta = {
      description = "Makes web apps";
      longDescription = ''
        Think about the ideal way to write a web app.
        Write the code to make it happen.
      '';
      homepage = "http://webpy.org/";
      license = licenses.publicDomain;
      maintainers = with maintainers; [ layus ];
    };
  };

  webob = buildPythonPackage rec {
    pname = "WebOb";
    version = "1.7.3";
    name = "${pname}-${version}";

    src = fetchPypi {
      inherit pname version;
      sha256 = "10vjp2rvqiyvw157fk3sy7yds1gknzw97z4gk0qv1raskx5s2p76";
    };

    propagatedBuildInputs = with self; [ nose pytest ];

    meta = {
      description = "WSGI request and response object";
      homepage = http://pythonpaste.org/webob/;
      platforms = platforms.all;
    };
  };


  websockify = buildPythonPackage rec {
    version = "0.7.0";
    name = "websockify-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/w/websockify/websockify-${version}.tar.gz";
      sha256 = "1v6pmamjprv2x55fvbdaml26ppxdw8v6xz8p0sav3368ajwwgcqc";
    };

    propagatedBuildInputs = with self; [ numpy ];

    meta = {
      description = "WebSockets support for any application/server";
      homepage = https://github.com/kanaka/websockify;
    };
  };


  webtest = buildPythonPackage rec {
    version = "2.0.20";
    name = "webtest-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/W/WebTest/WebTest-${version}.tar.gz";
      sha256 = "0bv0qhdjakdsdgj4sk21gnpp8xp8bga4x03p6gjb83ihrsb7n4xv";
    };

    preConfigure = ''
      substituteInPlace setup.py --replace "nose<1.3.0" "nose"
    '';

    # XXX: skipping two tests fails in python2.6
    doCheck = ! isPy26;

    buildInputs = with self; optionals isPy26 [ ordereddict unittest2 ];

    propagatedBuildInputs = with self; [
      nose
      webob
      six
      beautifulsoup4
      waitress
      mock
      pyquery
      wsgiproxy2
      PasteDeploy
      coverage
    ];

    meta = {
      description = "Helper to test WSGI applications";
      homepage = http://webtest.readthedocs.org/en/latest/;
      platforms = platforms.all;
    };
  };

  werkzeug = callPackage ../development/python-modules/werkzeug { };

  wheel = callPackage ../development/python-modules/wheel { };

  widgetsnbextension = callPackage ../development/python-modules/widgetsnbextension { };

  magic-wormhole = callPackage ../development/python-modules/magic-wormhole { };

  wsgiproxy2 = buildPythonPackage rec {
    name = "WSGIProxy2-0.4.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/W/WSGIProxy2/${name}.zip";
      sha256 = "13kf9bdxrc95y9vriaz0viry3ah11nz4rlrykcfvb8nlqpx3dcm4";
    };

    # circular dep on webtest
    doCheck = false;
    propagatedBuildInputs = with self; [ six webob ];

    meta = {
      maintainers = with maintainers; [ garbas domenkozar ];
    };
  };

  wxPython = self.wxPython30;

  wxPython30 = callPackage ../development/python-modules/wxPython/3.0.nix {
    wxGTK = pkgs.wxGTK30;
  };

  xcaplib = buildPythonPackage rec {
    pname = "python-xcaplib";
    name = "${pname}-${version}";
    version = "1.2.0";
    disabled = isPy3k;

    src = pkgs.fetchdarcs {
      url = "http://devel.ag-projects.com/repositories/${pname}";
      rev = "release-${version}";
      sha256 = "0vna5r4ihv7z1yx6r93954jqskcxky77znzy1m9dg9vna1dgwfdn";
    };

    propagatedBuildInputs = with self; [ eventlib application ];
  };

  xlib = buildPythonPackage (rec {
    name = "xlib-${version}";
    version = "0.17";

    src = pkgs.fetchFromGitHub {
      owner = "python-xlib";
      repo = "python-xlib";
      rev = "${version}";
      sha256 = "1iiz2nq2hq9x6laavngvfngnmxbgnwh54wdbq6ncx4va7v98liyi";
    };

    # Tests require `pyutil' so disable them to avoid circular references.
    doCheck = false;

    propagatedBuildInputs = with self; [ six setuptools_scm pkgs.xorg.libX11 ];

    meta = {
      description = "Fully functional X client library for Python programs";

      homepage = http://python-xlib.sourceforge.net/;

      license = licenses.gpl2Plus;
    };
  });

  xmltodict = buildPythonPackage (rec {
    name = "xmltodict-0.9.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/x/xmltodict/${name}.tar.gz";
      sha256 = "00crqnjh1kbvcgfnn3b8c7vq30lf4ykkxp1xf3pf7mswr5l1wp97";
    };

    buildInputs = with self; [ coverage nose ];

    meta = {
      description = "Makes working with XML feel like you are working with JSON";
      homepage = https://github.com/martinblech/xmltodict;
      license = licenses.mit;
    };
  });

  xarray = callPackage ../development/python-modules/xarray { };

  xlwt = callPackage ../development/python-modules/xlwt { };

  youtube-dl = callPackage ../tools/misc/youtube-dl {};

  youtube-dl-light = callPackage ../tools/misc/youtube-dl {
    ffmpegSupport = false;
  };

  zbase32 = buildPythonPackage (rec {
    name = "zbase32-1.1.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/z/zbase32/${name}.tar.gz";
      sha256 = "2f44b338f750bd37b56e7887591bf2f1965bfa79f163b6afcbccf28da642ec56";
    };

    # Tests require `pyutil' so disable them to avoid circular references.
    doCheck = false;

    propagatedBuildInputs = with self; [ setuptoolsDarcs ];

    meta = {
      description = "zbase32, a base32 encoder/decoder";
      homepage = https://pypi.python.org/pypi/zbase32;
      license = "BSD";
    };
  });


  zconfig = callPackage ../development/python-modules/zconfig { };


  zc_lockfile = callPackage ../development/python-modules/zc_lockfile { };

  zdaemon = buildPythonPackage rec {
    name = "zdaemon-${version}";
    version = "4.0.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/z/zdaemon/${name}.tar.gz";
      sha256 = "82d7eaa4d831ff1ecdcffcb274f3457e095c0cc86e630bc72009a863c341ab9f";
    };

    propagatedBuildInputs = [ self.zconfig ];

    # too many deps..
    doCheck = false;

    meta = {
      description = "A daemon process control library and tools for Unix-based systems";
      homepage = https://pypi.python.org/pypi/zdaemon;
      license = licenses.zpl20;
      maintainers = with maintainers; [ goibhniu ];
    };
  };


  zfec = buildPythonPackage (rec {
    name = "zfec-1.4.24";
    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "mirror://pypi/z/zfec/${name}.tar.gz";
      sha256 = "1ks94zlpy7n8sb8380gf90gx85qy0p9073wi1wngg6mccxp9xsg3";
    };

    buildInputs = with self; [ setuptoolsDarcs ];
    propagatedBuildInputs = with self; [ pyutil argparse ];

    meta = {
      homepage = http://allmydata.org/trac/zfec;

      description = "Zfec, a fast erasure codec which can be used with the command-line, C, Python, or Haskell";

      longDescription = ''
        Fast, portable, programmable erasure coding a.k.a. "forward
        error correction": the generation of redundant blocks of
        information such that if some blocks are lost then the
        original data can be recovered from the remaining blocks. The
        zfec package includes command-line tools, C API, Python API,
        and Haskell API.
      '';

      license = licenses.gpl2Plus;
    };
  });

  zipstream = callPackage ../development/python-modules/zipstream { };

  zodb = callPackage ../development/python-modules/zodb {};

  zodbpickle = callPackage ../development/python-modules/zodbpickle {};

  BTrees = callPackage ../development/python-modules/btrees {};

  persistent = callPackage ../development/python-modules/persistent {};

  xdot = buildPythonPackage rec {
    name = "xdot-0.7";

    src = pkgs.fetchurl {
      url = "mirror://pypi/x/xdot/xdot-0.7.tar.gz";
      sha256 = "1q0f3pskb09saw1qkd2s6vmk80rq5zjhq8l93dfr2x6r04r0q46j";
    };

    nativeBuildInputs = with pkgs; [ wrapGAppsHook ];
    propagatedBuildInputs = with self; [ pkgs.gobjectIntrospection pygobject3 pkgs.graphviz pkgs.gnome3.gtk ];

    meta = {
      description = "xdot.py is an interactive viewer for graphs written in Graphviz's dot";
      homepage = https://github.com/jrfonseca/xdot.py;
      license = licenses.lgpl3Plus;
    };
  };

  you-get = buildPythonApplication rec {
    version = "0.4.390";
    name = "you-get-${version}";
    disabled = !isPy3k;

    # Tests aren't packaged, but they all hit the real network so
    # probably aren't suitable for a build environment anyway.
    doCheck = false;

    src = pkgs.fetchurl {
      url = "mirror://pypi/y/you-get/${name}.tar.gz";
      sha256 = "17hs0g9yvgvkmr7p1cz39mbbvb40q65qkc31j3ixc2f873gahagw";
    };

    meta = {
      description = "A tiny command line utility to download media contents from the web";
      homepage = https://you-get.org;
      license = licenses.mit;
      maintainers = with maintainers; [ ryneeverett ];
      platforms = platforms.all;
    };
  };

  zetup = callPackage ../development/python-modules/zetup { };

  zope_broken = buildPythonPackage rec {
    name = "zope.broken-3.6.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/z/zope.broken/${name}.zip";
      sha256 = "b9b8776002da4f7b6b12dfcce77eb642ae62b39586dbf60e1d9bdc992c9f2999";
    };

    buildInputs = with self; [ zope_interface ];

    meta = {
        maintainers = with maintainers; [ goibhniu ];
    };
  };


  zope_component = buildPythonPackage rec {
    name = "zope.component-4.2.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/z/zope.component/zope.component-4.2.1.tar.gz";
      sha256 = "1gzbr0j6c2h0cqnpi2cjss38wrz1bcwx8xahl3vykgz5laid15l6";
    };

    propagatedBuildInputs = with self; [
      zope_configuration zope_event zope_i18nmessageid zope_interface
      zope_testing
    ];

    # ignore tests because of a circular dependency on zope_security
    doCheck = false;

    meta = {
        maintainers = with maintainers; [ goibhniu ];
    };
  };


  zope_configuration = buildPythonPackage rec {
    name = "zope.configuration-4.0.3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/z/zope.configuration/zope.configuration-4.0.3.tar.gz";
      sha256 = "1x9dfqypgympnlm25p9m43xh4qv3p7d75vksv9pzqibrb4cggw5n";
    };

    propagatedBuildInputs = with self; [ zope_i18nmessageid zope_schema ];

    # Trouble with implicit namespace packages on Python3
    # see https://github.com/pypa/setuptools/issues/912
    doCheck = !isPy3k;

    meta = {
        maintainers = with maintainers; [ goibhniu ];
    };
  };


  zope_contenttype = buildPythonPackage rec {
    name = "zope.contenttype-4.0.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/z/zope.contenttype/${name}.tar.gz";
      sha256 = "9decc7531ad6925057f1a667ac0ef9d658577a92b0b48dafa7daa97b78a02bbb";
    };

    meta = {
        maintainers = with maintainers; [ goibhniu ];
    };
  };


  zope_dottedname = buildPythonPackage rec {
    name = "zope.dottedname-3.4.6";

    src = pkgs.fetchurl {
      url = "mirror://pypi/z/zope.dottedname/${name}.tar.gz";
      sha256 = "331d801d98e539fa6c5d50c3835ecc144c429667f483281505de53fc771e6bf5";
    };
    meta = {
        maintainers = with maintainers; [ goibhniu ];
    };
  };


  zope_event = buildPythonPackage rec {
    name = "zope.event-${version}";
    version = "4.0.3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/z/zope.event/${name}.tar.gz";
      sha256 = "1w858k9kmgzfj36h65kp27m9slrmykvi5cjq6c119xqnaz5gdzgm";
    };

    meta = {
      description = "An event publishing system";
      homepage = https://pypi.python.org/pypi/zope.event;
      license = licenses.zpl20;
      maintainers = with maintainers; [ goibhniu ];
    };
  };


  zope_exceptions = buildPythonPackage rec {
     name = "zope.exceptions-${version}";
     version = "4.0.8";

     src = pkgs.fetchurl {
       url = "mirror://pypi/z/zope.exceptions/${name}.tar.gz";
       sha256 = "0zwxaaa66sqxg5k7zcrvs0fbg9ym1njnxnr28dfmchzhwjvwnfzl";
     };

     propagatedBuildInputs = with self; [ zope_interface ];

     # circular deps
     doCheck = false;

     meta = {
       description = "Exception interfaces and implementations";
       homepage = https://pypi.python.org/pypi/zope.exceptions;
       license = licenses.zpl20;
       maintainers = with maintainers; [ goibhniu ];
     };
   };


  zope_filerepresentation = buildPythonPackage rec {
    name = "zope.filerepresentation-3.6.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/z/zope.filerepresentation/${name}.tar.gz";
      sha256 = "d775ebba4aff7687e0381f050ebda4e48ce50900c1438f3f7e901220634ed3e0";
    };

    propagatedBuildInputs = with self; [ zope_schema ];

    meta = {
        maintainers = with maintainers; [ goibhniu ];
    };
  };


  zope_i18n = buildPythonPackage rec {
    name = "zope.i18n-3.8.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/z/zope.i18n/${name}.tar.gz";
      sha256 = "045nnimmshibcq71yym2d8yrs6wzzhxq5gl7wxjnkpyjm5y0hfkm";
    };

    propagatedBuildInputs = with self; [ pytz zope_component ];

    meta = {
        maintainers = with maintainers; [ goibhniu ];
    };
  };


  zope_i18nmessageid = buildPythonPackage rec {
    name = "zope.i18nmessageid-4.0.3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/z/zope.i18nmessageid/zope.i18nmessageid-4.0.3.tar.gz";
      sha256 = "1rslyph0klk58dmjjy4j0jxy21k03azksixc3x2xhqbkv97cmzml";
    };

    meta = {
        maintainers = with maintainers; [ goibhniu ];
    };
  };


  zope_lifecycleevent = buildPythonPackage rec {
    name = "zope.lifecycleevent-3.7.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/z/zope.lifecycleevent/${name}.tar.gz";
      sha256 = "0s5brphqzzz89cykg61gy7zcmz0ryq1jj2va7gh2n1b3cccllp95";
    };

    propagatedBuildInputs = with self; [ zope_event zope_component ];

    meta = {
        maintainers = with maintainers; [ goibhniu ];
    };
  };


  zope_location = buildPythonPackage rec {
    name = "zope.location-4.0.3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/z/zope.location/zope.location-4.0.3.tar.gz";
      sha256 = "1nj9da4ksiyv3h8n2vpzwd0pb03mdsh7zy87hfpx72b6p2zcwg74";
    };

    propagatedBuildInputs = with self; [ zope_proxy ];

    # ignore circular dependency on zope_schema
    preBuild = ''
      sed -i '/zope.schema/d' setup.py
    '';

    doCheck = false;

    meta = {
        maintainers = with maintainers; [ goibhniu ];
    };
  };


  zope_proxy = buildPythonPackage rec {
    name = "zope.proxy-4.1.6";

    src = pkgs.fetchurl {
      url = "mirror://pypi/z/zope.proxy/${name}.tar.gz";
      sha256 = "0pqwwmvm1prhwv1ziv9lp8iirz7xkwb6n2kyj36p2h0ppyyhjnm4";
    };

    propagatedBuildInputs = with self; [ zope_interface ];

    # circular deps
    doCheck = false;

    meta = {
        maintainers = with maintainers; [ goibhniu ];
    };
  };


  zope_schema = buildPythonPackage rec {
    name = "zope.schema-4.4.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/z/zope.schema/${name}.tar.gz";
      sha256 = "1p943jdxb587dh7php4vx04qvn7b2877hr4qs5zyckvp5afhhank";
    };

    propagatedBuildInputs = with self; [ zope_location zope_event zope_interface zope_testing ] ++ optional isPy26 ordereddict;

    # ImportError: No module named 'zope.event'
    # even though zope_event has been included.
    # Package seems to work fine.
    doCheck = false;

    meta = {
        maintainers = with maintainers; [ goibhniu ];
    };
  };


  zope_size = buildPythonPackage rec {
    name = "zope.size-3.5.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/z/zope.size/${name}.tar.gz";
      sha256 = "006xfkhvmypwd3ww9gbba4zly7n9w30bpp1h74d53la7l7fiqk2f";
    };

    propagatedBuildInputs = with self; [ zope_i18nmessageid zope_interface ];

    meta = {
        maintainers = with maintainers; [ goibhniu ];
    };
  };


  zope_testing = buildPythonPackage rec {
    name = "zope.testing-${version}";
    version = "4.6.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/z/zope.testing/${name}.tar.gz";
      sha256 = "1vvxhjmzl7vw2i1akfj1xbggwn36270ym7f2ic9xwbaswfw1ap56";
    };

    doCheck = !isPyPy;

    propagatedBuildInputs = with self; [ zope_interface zope_exceptions zope_location ];

    meta = {
      description = "Zope testing helpers";
      homepage =  http://pypi.python.org/pypi/zope.testing;
      license = licenses.zpl20;
      maintainers = with maintainers; [ goibhniu ];
    };
  };


  zope_testrunner = callPackage ../development/python-modules/zope_testrunner { };


  zope_interface = callPackage ../development/python-modules/zope_interface { };


  hgsvn = buildPythonPackage rec {
    name = "hgsvn-0.3.11";
    src = pkgs.fetchurl rec {
      url = "mirror://pypi/h/hgsvn/${name}-hotfix.zip";
      sha256 = "0yvhwdh8xx8rvaqd3pnnyb99hfa0zjdciadlc933p27hp9rf880p";
    };
    disabled = isPy3k || isPyPy;
    doCheck = false;  # too many assumptions

    buildInputs = with self; [ nose ];
    propagatedBuildInputs = with self; [ hglib ];

    meta = {
      homepage = https://pypi.python.org/pypi/hgsvn;
    };
  };

  cliapp = buildPythonPackage rec {
    name = "cliapp-${version}";
    version = "1.20150305";
    disabled = isPy3k;

    src = pkgs.fetchgit {
        url = "http://git.liw.fi/cgi-bin/cgit/cgit.cgi/cliapp";
        rev = "569df8a5959cd8ef46f78c9497461240a5aa1123";
        sha256 = "882c5daf933e4cf089842995efc721e54361d98f64e0a075e7373b734cd899f3";
    };

    buildInputs = with self; [ sphinx ];

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://liw.fi/cliapp/;
      description = "Python framework for Unix command line programs";
      maintainers = with maintainers; [ rickynils ];
    };
  };

  cmdtest = buildPythonPackage rec {
    name = "cmdtest-${version}";
    version = "0.18";
    disabled = isPy3k || isPyPy;

    propagatedBuildInputs = with self; [ cliapp ttystatus markdown ];

    # TODO: cmdtest tests must be run before the buildPhase
    doCheck = false;

    src = pkgs.fetchurl {
      url = "http://code.liw.fi/debian/pool/main/c/cmdtest/cmdtest_0.18.orig.tar.xz";
      sha256 = "068f24k8ad520hcf8g3gj7wvq1wspyd46ay0k9xa360jlb4dv2mn";
    };

    meta = {
      homepage = http://liw.fi/cmdtest/;
      description = "Black box tests Unix command line tools";
    };
  };

  tornado = callPackage ../development/python-modules/tornado { };

  tokenlib = buildPythonPackage rec {
    name = "tokenlib-${version}";
    version = "0.3.1";
    src = pkgs.fetchgit {
      url = https://github.com/mozilla-services/tokenlib.git;
      rev = "refs/tags/${version}";
      sha256 = "0bq6dqyfwh29pg8ngmrm4mx4q27an9lsj0p9l79p9snn4g2rxzc8";
    };

    propagatedBuildInputs = with self; [ requests webob ];
  };

  tunigo = buildPythonPackage rec {
    name = "tunigo-${version}";
    version = "1.0.0";
    propagatedBuildInputs = with self; [ requests ];

    src = pkgs.fetchFromGitHub {
      owner = "trygveaa";
      repo = "python-tunigo";
      rev = "v${version}";
      sha256 = "07q9girrjjffzkn8xj4l3ynf9m4psi809zf6f81f54jdb330p2fs";
    };

    buildInputs = with self; [ mock nose ];

    meta = {
      description = "Python API for the browse feature of Spotify";
      homepage = https://github.com/trygveaa/python-tunigo;
      license = licenses.asl20;
    };
  };

  screenkey = buildPythonPackage rec {
    version = "0.2-b3634a2c6eb6d6936c3b2c1ef5078bf3a84c40c6";
    name = "screenkey-${version}";

    propagatedBuildInputs = with self; [ pygtk distutils_extra xlib pkgs.xorg.xmodmap ];

    preConfigure = ''
      substituteInPlace setup.py --replace "/usr/share" "./share"

      # disable the feature that binds a shortcut to turning on/off
      # screenkey. This is because keybinder is not packages in Nix as
      # of today.
      substituteInPlace Screenkey/screenkey.py \
        --replace "import keybinder" "" \
        --replace "        keybinder.bind(self.options['hotkey'], self.hotkey_cb, show_item)" ""
    '';

    src = pkgs.fetchgit {
        url = https://github.com/scs3jb/screenkey.git;
        rev = "b3634a2c6eb6d6936c3b2c1ef5078bf3a84c40c6";
        sha256 = "1535mpm5x6v85d4ghxhdiianhjrsz280dwvs61ss0yyjx4kivx3s";
    };

    meta = {
      homepage = https://github.com/scs3jb/screenkey;
      description = "A screencast tool to show your keys";
      license = licenses.gpl3Plus;
      maintainers = with maintainers; [ ];
      platforms = platforms.linux;
    };
  };

  tarman = buildPythonPackage rec {
    version = "0.1.3";
    name = "tarman-${version}";

    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/tarman/tarman-${version}.zip";
      sha256 = "0ri6gj883k042xaxa2d5ymmhbw2bfcxdzhh4bz7700ibxwxxj62h";
    };

    buildInputs = with self; [ unittest2 nose mock ];
    propagatedBuildInputs = with self; [ libarchive ];

    # tests are still failing
    doCheck = false;
  };


  libarchive = self.python-libarchive; # The latter is the name upstream uses
  python-libarchive = buildPythonPackage rec {
    version = "3.1.2-1";
    name = "libarchive-${version}";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "http://python-libarchive.googlecode.com/files/python-libarchive-${version}.tar.gz";
      sha256 = "0j4ibc4mvq64ljya9max8832jafi04jciff9ia9qy0xhhlwkcx8x";
    };

    propagatedBuildInputs = with self; [ pkgs.libarchive.lib ];
    meta.broken = true;
  };

  libarchive-c = buildPythonPackage rec {
    name = "libarchive-c-${version}";
    version = "2.7";

    src = pkgs.fetchurl {
      url = "mirror://pypi/l/libarchive-c/${name}.tar.gz";
      sha256 = "011bfsmqpcwd6920kckllh7zhw2y4rrasgmddb7wjzn2hg1xpsjn";
    };

    LC_ALL="en_US.UTF-8";

    postPatch = ''
      substituteInPlace libarchive/ffi.py --replace \
        "find_library('archive')" "'${pkgs.libarchive.lib}/lib/libarchive.so'"
    '';
    checkPhase = ''
      py.test tests -k 'not test_check_archiveentry_with_unicode_entries_and_name_zip and not test_check_archiveentry_using_python_testtar'
    '';

    buildInputs = with self; [ pytest pkgs.glibcLocales ];
  };

  libasyncns = callPackage ../development/python-modules/libasyncns {
    inherit (pkgs) libasyncns pkgconfig;
  };

  libarcus = callPackage ../development/python-modules/libarcus { };

  pybrowserid = buildPythonPackage rec {
    name = "PyBrowserID-${version}";
    version = "0.9.2";
    disabled = isPy3k; # Errors in the test suite.

    src = pkgs.fetchgit {
      url = https://github.com/mozilla/PyBrowserID.git;
      rev = "refs/tags/${version}";
      sha256 = "0zsljr45gm8a4c0lxh6mgfc60a5fijhs4pwijb9fdkq16zw0pmf0";
    };

    doCheck = false;  # some tests use networking

    buildInputs = with self; [ mock unittest2 ];
    propagatedBuildInputs = with self; [ requests ];

    meta = {
      description = "Python library for the BrowserID Protocol";
      homepage    = "https://github.com/mozilla/PyBrowserID";
      license     = licenses.mpl20;
    };
  };

  pyzmq = buildPythonPackage rec {
    name = "pyzmq-16.0.2";
    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pyzmq/${name}.tar.gz";
      sha256 = "0322543fff5ab6f87d11a8a099c4c07dd8a1719040084b6ce9162bcdf5c45c9d";
    };
    buildInputs = with self; [ pkgs.zeromq3 pytest tornado ];
    propagatedBuildInputs = [ self.py ];

    # Disable broken test
    # https://github.com/zeromq/pyzmq/issues/799
    checkPhase = ''
      py.test $out/${python.sitePackages}/zmq/ -k "not test_large_send and not test_recv_json_cancelled"
    '';
  };

  tokenserver = buildPythonPackage rec {
    name = "tokenserver-${version}";
    version = "1.2.11";

    src = pkgs.fetchgit {
      url = https://github.com/mozilla-services/tokenserver.git;
      rev = "refs/tags/${version}";
      sha256 = "1cvkvxcday1qc3zyarasj3l7322w8afhrcxcsvb5wac1ryh1w6y2";
    };

    doCheck = false;
    buildInputs = [ self.testfixtures ];
    propagatedBuildInputs = with self; [ cornice mozsvc pybrowserid tokenlib ];

    meta = {
      platforms = platforms.all;
    };
  };

  testfixtures = callPackage ../development/python-modules/testfixtures {};

  tissue = buildPythonPackage rec {
    name = "tissue-0.9.2";
    src = pkgs.fetchurl {
      url = "mirror://pypi/t/tissue/${name}.tar.gz";
      sha256 = "7e34726c3ec8fae358a7faf62de172db15716f5582e5192a109e33348bd76c2e";
    };

    buildInputs = with self; [ nose ];
    propagatedBuildInputs = with self; [ pep8 ];

    meta = {
      maintainers = with maintainers; [ garbas domenkozar ];
      platforms = platforms.all;
    };
  };


  tracing = buildPythonPackage rec {
    name = "tracing-${version}";
    version = "0.8";

    src = pkgs.fetchurl rec {
      url = "http://code.liw.fi/debian/pool/main/p/python-tracing/python-tracing_${version}.orig.tar.gz";
      sha256 = "1l4ybj5rvrrcxf8csyq7qx52izybd502pmx70zxp46gxqm60d2l0";
    };

    buildInputs = with self; [ sphinx ];

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://liw.fi/tracing/;
      description = "Python debug logging helper";
      maintainers = with maintainers; [ rickynils ];
    };
  };

  translationstring = buildPythonPackage rec {
    name = "translationstring-1.3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/translationstring/${name}.tar.gz";
      sha256 = "4ee44cfa58c52ade8910ea0ebc3d2d84bdcad9fa0422405b1801ec9b9a65b72d";
    };

    meta = {
      maintainers = with maintainers; [ garbas domenkozar ];
      platforms = platforms.all;
    };
  };


  ttystatus = buildPythonPackage rec {
    name = "ttystatus-${version}";
    version = "0.23";
    disabled = isPy3k;

    src = pkgs.fetchurl rec {
      url = "http://code.liw.fi/debian/pool/main/p/python-ttystatus/python-ttystatus_${version}.orig.tar.gz";
      sha256 = "0ymimviyjyh2iizqilg88g4p26f5vpq1zm3cvg7dr7q4y3gmik8y";
    };

    buildInputs = with self; [ sphinx ];

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://liw.fi/ttystatus/;
      description = "Progress and status updates on terminals for Python";
      maintainers = with maintainers; [ rickynils ];
    };
  };

  larch = buildPythonPackage rec {
    name = "larch-${version}";
    version = "1.20131130";

    src = pkgs.fetchurl rec {
      url = "http://code.liw.fi/debian/pool/main/p/python-larch/python-larch_${version}.orig.tar.gz";
      sha256 = "1hfanp9l6yc5348i3f5sb8c5s4r43y382hflnbl6cnz4pm8yh5r7";
    };

    buildInputs = with self; [ sphinx ];
    propagatedBuildInputs = with self; [ tracing ttystatus cliapp ];

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://liw.fi/larch/;
      description = "Python B-tree library";
      maintainers = with maintainers; [ rickynils ];
    };
  };


  websocket_client = buildPythonPackage rec {
    name = "websocket_client-0.40.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/w/websocket-client/${name}.tar.gz";
      sha256 = "1yz67wdjijrvwpx0a0f6wdfy8ajsvr9xbj5514ld452fqnh19b20";
    };

    propagatedBuildInputs = with self; [ six backports_ssl_match_hostname unittest2 argparse ];

    meta = {
      homepage = https://github.com/liris/websocket-client;
      description = "Websocket client for python";
      license = licenses.lgpl2;
    };
  };


  webhelpers = buildPythonPackage rec {
    name = "WebHelpers-1.3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/W/WebHelpers/${name}.tar.gz";
      sha256 = "ea86f284e929366b77424ba9a89341f43ae8dee3cbeb8702f73bcf86058aa583";
    };

    buildInputs = with self; [ routes markupsafe webob nose ];

    # TODO: failing tests https://bitbucket.org/bbangert/webhelpers/pull-request/1/fix-error-on-webob-123/diff
    doCheck = false;

    meta = {
      maintainers = with maintainers; [ garbas domenkozar ];
      platforms = platforms.all;
    };
  };


  whichcraft = buildPythonPackage rec {
    name = "whichcraft-${version}";
    version = "0.1.1";

    src = pkgs.fetchurl {
      url = "https://github.com/pydanny/whichcraft/archive/${version}.tar.gz";
      sha256 = "1xqp66knzlb01k30qic40vzwl51jmlsb8r96iv60m2ca6623abbv";
    };

    buildInputs = with self; [ pytest ];

    meta = {
      homepage = https://github.com/pydanny/whichcraft;
      description = "Cross-platform cross-python shutil.which functionality";
      license = licenses.bsd3;
    };
  };


  whisper = buildPythonPackage rec {
    name = "whisper-${version}";
    version = graphiteVersion;

    src = pkgs.fetchurl {
      url = "mirror://pypi/w/whisper/${name}.tar.gz";
      sha256 = "1v1bi3fl1i6p4z4ki692bykrkw6907dn3mfq0151f70lvi3zpns3";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://graphite.wikidot.com/;
      description = "Fixed size round-robin style database";
      maintainers = with maintainers; [ rickynils offline ];
    };
  };

  worldengine = buildPythonPackage rec {
    name = "worldengine-${version}";
    version = "0.19.0";

    src = pkgs.fetchFromGitHub {
      owner = "Mindwerks";
      repo = "worldengine";
      rev = "v${version}";
      sha256 = "1xrckb0dn2841gvp32n18gib14bpi77hmjw3r9jiyhg402iip7ry";
    };

    src-data = pkgs.fetchFromGitHub {
      owner = "Mindwerks";
      repo = "worldengine-data";
      rev = "029051e";
      sha256 = "06xbf8gj3ljgr11v1n8jbs2q8pdf9wz53xdgkhpm8hdnjahgdxdm";
    };

    postUnpack = ''
      ln -s ${src-data} worldengine-data
    '';

    buildInputs = with self; [ nose ];
    propagatedBuildInputs = with self; [ noise numpy pyplatec protobuf purepng argparse h5py gdal ];

    prePatch = ''
      substituteInPlace setup.py \
        --replace pypng>=0.0.18 purepng \
        --replace 'numpy>=1.9.2, <= 1.10.0.post2' 'numpy' \
        --replace 'argparse==1.2.1' "" \
        --replace 'protobuf==3.0.0a3' 'protobuf' \
        --replace 'noise==1.2.2' 'noise' \
        --replace 'PyPlatec==1.4.0' 'PyPlatec' \
    '';

    doCheck = true;
    postCheck = ''
      nosetests tests
    '';

    meta = {
      homepage = http://world-engine.org;
      description = "World generator using simulation of plates, rain shadow, erosion, etc";
      platforms = platforms.all;
      maintainers = with maintainers; [ rardiol ];
    };
  };

  carbon = buildPythonPackage rec {
    name = "carbon-${version}";
    version = graphiteVersion;

    src = pkgs.fetchurl {
      url = "mirror://pypi/c/carbon/${name}.tar.gz";
      sha256 = "142smpmgbnjinvfb6s4ijazish4vfgzyd8zcmdkh55y051fkixkn";
    };

    propagatedBuildInputs = with self; [ whisper txamqp zope_interface twisted ];

    meta = {
      homepage = http://graphite.wikidot.com/;
      description = "Backend data caching and persistence daemon for Graphite";
      maintainers = with maintainers; [ rickynils offline ];
    };
  };


  ujson = buildPythonPackage rec {
    name = "ujson-1.35";

    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "mirror://pypi/u/ujson/${name}.tar.gz";
      sha256 = "11jz5wi7mbgqcsz52iqhpyykiaasila4lq8cmc2d54bfa3jp6q7n";
    };

    meta = {
      homepage = https://pypi.python.org/pypi/ujson;
      description = "Ultra fast JSON encoder and decoder for Python";
      license = licenses.bsd3;
    };
  };


  unidecode = callPackage ../development/python-modules/unidecode {};

  pyusb = callPackage ../development/python-modules/pyusb {};

  BlinkStick = buildPythonPackage rec {
    name = "BlinkStick-${version}";
    version = "1.1.8";

    src = pkgs.fetchurl {
      url = "mirror://pypi/B/BlinkStick/${name}.tar.gz";
      sha256 = "3edf4b83a3fa1a7bd953b452b76542d54285ff6f1145b6e19f9b5438120fa408";
    };

    # Requires pyusb 1.0.0b1.
    # Likely current pyusb will work but we need to patch the hard requirement then.
    broken = true;

    patchPhase = "substituteInPlace setup.py --replace pyusb==1.0.0b1 pyusb==1.0.0";

    propagatedBuildInputs = with self; [ pyusb ];

    meta = {
      description = "Python package to control BlinkStick USB devices";
      homepage = https://pypi.python.org/pypi/BlinkStick/;
      license = licenses.bsd3;
      maintainers = with maintainers; [ np ];
    };
  };

  usbtmc = callPackage ../development/python-modules/usbtmc {};

  txgithub = buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "txgithub";
    version = "15.0.0";
    src = pkgs.fetchurl {
      url = "mirror://pypi/t/${pname}/${name}.tar.gz";
      sha256 = "16gbizy8vkxasxylwzj4p66yw8979nvzxdj6csidgmng7gi2k8nx";
    };
    propagatedBuildInputs = with self; [ pyopenssl twisted service-identity ];
    # fix python3 issues
    patchPhase = ''
      sed -i 's/except usage.UsageError, errortext/except usage.UsageError as errortext/' txgithub/scripts/create_token.py
      sed -i 's/except usage.UsageError, errortext/except usage.UsageError as errortext/' txgithub/scripts/gist.py
      sed -i 's/print response\[\x27html_url\x27\]/print(response\[\x27html_url\x27\])/' txgithub/scripts/gist.py
      sed -i '41d' txgithub/scripts/gist.py
      sed -i '41d' txgithub/scripts/gist.py
    '';

    # No tests distributed
    doCheck = false;
    meta = {
      description = "GitHub API client implemented using Twisted.";
      homepage    = "https://github.com/tomprince/txgithub";
      license     = licenses.mit;
      maintainers = with maintainers; [ nand0p ];
      platforms   = platforms.all;
    };
  };

  txrequests = buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "txrequests";
    version = "0.9.2";
    src = pkgs.fetchurl {
      url = "mirror://pypi/t/${pname}/${name}.tar.gz";
      sha256 = "0kkxxd17ar5gyjkz9yrrdr15a64qw6ym60ndi0zbwx2s634yfafw";
    };
    propagatedBuildInputs = with self; [ twisted requests cryptography ];

    # Require network access
    doCheck = false;
    checkPhase = ''
      ${python.interpreter} -m unittest discover
    '';
    meta = {
      description = "Asynchronous Python HTTP for Humans.";
      homepage    = "https://github.com/tardyp/txrequests";
      license     = licenses.asl20;
      maintainers = with maintainers; [ nand0p ];
      platforms   = platforms.all;
    };
  };

  txamqp = buildPythonPackage rec {
    name = "txamqp-${version}";
    version = "0.3";

    src = pkgs.fetchurl rec {
      url = "https://launchpad.net/txamqp/trunk/${version}/+download/python-txamqp_${version}.orig.tar.gz";
      sha256 = "1r2ha0r7g14i4b5figv2spizjrmgfpspdbl1m031lw9px2hhm463";
    };

    buildInputs = with self; [ twisted ];

    meta = {
      homepage = https://launchpad.net/txamqp;
      description = "Library for communicating with AMQP peers and brokers using Twisted";
      maintainers = with maintainers; [ rickynils ];
    };
  };

  versiontools = buildPythonPackage rec {
    name = "versiontools-1.9.1";
    doCheck = (!isPy3k);

    src = pkgs.fetchurl {
      url = "mirror://pypi/v/versiontools/${name}.tar.gz";
      sha256 = "1xhl6kl7f4srgnw6zw4lr8j2z5vmrbaa83nzn2c9r2m1hwl36sd9";
    };

  };

  veryprettytable = buildPythonPackage rec {
    name = "veryprettytable-${version}";
    version = "0.8.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/v/veryprettytable/${name}.tar.gz";
      sha256 = "1k1rifz8x6qcicmx2is9vgxcj0qb2f5pvzrp7zhmvbmci3yack3f";
    };

    propagatedBuildInputs = [ self.termcolor self.colorama ];

    meta = {
      description = "A simple Python library for easily displaying tabular data in a visually appealing ASCII table format";
      homepage = https://github.com/smeggingsmegger/VeryPrettyTable;
      license = licenses.free;
    };
  };

  graphite_web = if
          self.django != self.django_1_8
       || self.django_tagging != self.django_tagging_0_4_3
  then throw "graphite_web should be build with django_1_8 and django_tagging_0_4_3"
  else buildPythonPackage rec {
    name = "graphite-web-${version}";
    disabled = isPy3k;
    version = graphiteVersion;

    src = pkgs.fetchurl rec {
      url = "mirror://pypi/g/graphite-web/${name}.tar.gz";
      sha256 = "0q8bwlj75jqyzmazfsi5sa26xl58ssa8wdxm2l4j0jqyn8xpfnmc";
    };

    propagatedBuildInputs = with self; [
      django django_tagging whisper pycairo cairocffi
      ldap memcached pytz urllib3 scandir
    ];

    postInstall = ''
      wrapProgram $out/bin/run-graphite-devel-server.py \
        --prefix PATH : ${pkgs.which}/bin
    '';

    preConfigure = ''
      # graphite is configured by storing a local_settings.py file inside the
      # graphite python package. Since that package is stored in the immutable
      # Nix store we can't modify it. So how do we configure graphite?
      #
      # First of all we rename "graphite.local_settings" to
      # "graphite_local_settings" so that the settings are not looked up in the
      # graphite package anymore. Secondly we place a directory containing a
      # graphite_local_settings.py on the PYTHONPATH in the graphite module
      # <nixpkgs/nixos/modules/services/monitoring/graphite.nix>.
      substituteInPlace webapp/graphite/settings.py \
        --replace "graphite.local_settings" " graphite_local_settings"

      substituteInPlace webapp/graphite/settings.py \
        --replace "join(WEBAPP_DIR, 'content')" "join('$out', 'webapp', 'content')"
    '';

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://graphite.wikidot.com/;
      description = "Enterprise scalable realtime graphing";
      maintainers = with maintainers; [ rickynils offline ];
    };
  };

  graphite_api = buildPythonPackage rec {
    name = "graphite-api-1.0.1";
    disabled = isPyPy;

    src = pkgs.fetchgit {
      url = "https://github.com/brutasse/graphite-api.git";
      rev = "b6f75e8a08fae695c094fece6de611b893fc65fb";
      sha256 = "1n8h5krhv7hzmn336y9vjrmv6b6009lz5hj0d9wz7v1k2500ws5k";
    };

    checkPhase = "nosetests";

    propagatedBuildInputs = with self; [
      flask
      flask_cache
      cairocffi
      pyparsing
      pytz
      pyyaml
      raven
      six
      structlog
      tzlocal
    ];

    buildInputs = with self; [
      nose
      mock
    ];

    LD_LIBRARY_PATH = "${pkgs.cairo.out}/lib";

    meta = {
      description = "Graphite-web, without the interface. Just the rendering HTTP API";
      homepage = https://github.com/brutasse/graphite-api;
      license = licenses.asl20;
    };
  };

  graphite_beacon = buildPythonPackage rec {
    name = "graphite_beacon-0.27.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/g/graphite_beacon/${name}.tar.gz";
      sha256 = "03bp4wyfn3xhcqyvs5hnk1n87m4smsmm1p7qp459m7j8hwpbq2ks";
    };

    propagatedBuildInputs = [ self.tornado self.pyyaml self.funcparserlib ];

    preBuild = "> requirements.txt";

    meta = {
      description = "A simple alerting application for Graphite metrics";
      homepage = https://github.com/klen/graphite-beacon;
      maintainers = [ maintainers.offline ];
      license = licenses.mit;
    };
  };

  graphite_influxdb = buildPythonPackage rec {
    name = "graphite-influxdb-0.3";

    src = pkgs.fetchgit {
      url = "https://github.com/vimeo/graphite-influxdb.git";
      rev = "2273d12a24e1d804685a36debfd4224b7416b62f";
      sha256 = "1v00fgrnmsd9c0ahggyw9sia5m7dyzz16i5pa4vy6w2sbfyrmm4v";
    };

    propagatedBuildInputs = with self; [ influxdb graphite_api ];

    passthru.moduleName = "graphite_influxdb.InfluxdbFinder";

    meta = {
      description = "An influxdb backend for Graphite-web and graphite-api";
      homepage = https://github.com/vimeo/graphite-influxdb;
      license = licenses.asl20;
    };
  };

  graphite_pager = buildPythonPackage rec {
    name = "graphite-pager-${version}";
    version = "2bbfe91220ec1e0ca1cdf4b5564386482a44ed7d";

    src = pkgs.fetchgit {
      url = "https://github.com/offlinehacker/graphite-pager.git";
      sha256 = "0ylal0vkc2yrjvssfz1gls84yk9vkvvkx3pyv4lx15jm2qqzdmxd";
      rev = version;
    };

    buildInputs = with self; [ nose mock ];
    propagatedBuildInputs = with self; [
      jinja2 pyyaml redis requests pagerduty
      python-simple-hipchat pushbullet
    ];

    patchPhase = "> requirements.txt";
    checkPhase = "nosetests";

    meta = {
      description = "A simple alerting application for Graphite metrics";
      homepage = https://github.com/seatgeek/graphite-pager;
      maintainers = with maintainers; [ offline ];
      license = licenses.bsd2;
    };
  };


  pyspotify = buildPythonPackage rec {
    name = "pyspotify-${version}";

    version = "2.0.5";

    src = pkgs.fetchurl {
      url = "https://github.com/mopidy/pyspotify/archive/v${version}.tar.gz";
      sha256 = "1ilbz2w1gw3f1bpapfa09p84dwh08bf7qcrkmd3aj0psz57p2rls";
    };

    propagatedBuildInputs = with self; [ cffi ];
    buildInputs = [ pkgs.libspotify ];

    # python zip complains about old timestamps
    preConfigure = ''
      find -print0 | xargs -0 touch
    '';

    postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
      find "$out" -name _spotify.so -exec \
          install_name_tool -change \
          @loader_path/../Frameworks/libspotify.framework/libspotify \
          ${pkgs.libspotify}/lib/libspotify.dylib \
          {} \;
    '';

    # There are no tests
    doCheck = false;

    meta = {
      homepage    = http://pyspotify.mopidy.com;
      description = "A Python interface to Spotify’s online music streaming service";
      license     = licenses.unfree;
      maintainers = with maintainers; [ lovek323 rickynils ];
      platforms   = platforms.unix;
    };
  };

  pykka = buildPythonPackage rec {
    name = "pykka-${version}";

    version = "1.2.0";

    src = pkgs.fetchgit {
      url = "https://github.com/jodal/pykka.git";
      rev = "refs/tags/v${version}";
      sha256 = "0qlfw1054ap0cha1m6dbnq51kjxqxaf338g7jwnwy33b3gr8x0hg";
    };

    # There are no tests
    doCheck = false;

    meta = {
      homepage = http://www.pykka.org;
      description = "A Python implementation of the actor model";
      maintainers = with maintainers; [ rickynils ];
    };
  };

  ws4py = callPackage ../development/python-modules/ws4py {};

  gdata = buildPythonPackage rec {
    name = "gdata-${version}";
    version = "2.0.18";

    src = pkgs.fetchurl {
      url = "https://gdata-python-client.googlecode.com/files/${name}.tar.gz";
      sha256 = "1dpxl5hwyyqd71avpm5vkvw8fhlvf9liizmhrq9jphhrx0nx5rsn";
    };

    # Fails with "error: invalid command 'test'"
    doCheck = false;

    meta = {
      homepage = https://code.google.com/p/gdata-python-client/;
      description = "Python client library for Google data APIs";
      license = licenses.asl20;
    };
  };

  IMAPClient = buildPythonPackage rec {
    name = "IMAPClient-${version}";
    version = "0.13";
    disabled = isPy34 || isPy35;

    src = pkgs.fetchurl {
      url = "http://freshfoo.com/projects/IMAPClient/${name}.tar.gz";
      sha256 = "0v7kd1crdbff0rmh4ddm5qszkis6hpk9084qh94al8h7g4y9l3is";
    };

    buildInputs = with self; [ mock ];

    preConfigure = ''
      sed -i '/distribute_setup/d' setup.py
      substituteInPlace setup.py --replace "mock==0.8.0" "mock"
    '';

    meta = {
      homepage = http://imapclient.freshfoo.com/;
      description = "Easy-to-use, Pythonic and complete IMAP client library";
      license = licenses.bsd3;
    };
  };

  Logbook = buildPythonPackage rec {
    name = "Logbook-${version}";
    version = "1.0.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/L/Logbook/${name}.tar.gz";
      sha256 = "0whqbx5p0zkf7gmb5ssnsnhm4kn4drd4x7fbhdi8dnxklqajbnl7";
    };

    buildInputs = [ self.pytest ] ++ optionals (!isPy3k) [ self.mock ];

    checkPhase = ''
      find tests -name \*.pyc -delete
      py.test tests
    '';

    meta = {
      homepage = http://pythonhosted.org/Logbook/;
      description = "A logging replacement for Python";
      license = licenses.bsd3;
    };
  };

  libvirt = let
    version = "3.8.0";
  in assert version == pkgs.libvirt.version; pkgs.stdenv.mkDerivation rec {
    name = "libvirt-python-${version}";

    src = pkgs.fetchurl {
      url = "http://libvirt.org/sources/python/${name}.tar.gz";
      sha256 = "02spx8kfcsnqwsshd7bk2plyic2lbpwzg16sf3csh0avck5akjsz";
    };

    nativeBuildInputs = [ pkgs.pkgconfig ];
    buildInputs = with self; [ python pkgs.libvirt lxml ];

    buildPhase = "${python.interpreter} setup.py build";

    installPhase = "${python.interpreter} setup.py install --prefix=$out";

    meta = {
      homepage = http://www.libvirt.org/;
      description = "libvirt Python bindings";
      license = licenses.lgpl2;
      maintainers = [ maintainers.fpletz ];
    };
  };

  rpdb = buildPythonPackage rec {
    name = "rpdb-0.1.5";

    src = pkgs.fetchurl {
      url = "mirror://pypi/r/rpdb/${name}.tar.gz";
      sha256 = "0rql1hq3lziwcql0h3dy05w074cn866p397ng9bv6qbz85ifw1bk";
    };

    meta = {
      description = "pdb wrapper with remote access via tcp socket";
      homepage = https://github.com/tamentis/rpdb;
      license = licenses.bsd2;
    };
  };


  grequests = buildPythonPackage rec {
    pname = "grequests";
    version = "0.3.0";
    name = "${pname}-${version}";

    src = fetchPypi {
      inherit pname version;
      sha256 = "0lafzax5igbh8y4x0krizr573wjsxz7bhvwygiah6qwrzv83kv5c";
    };

    # No tests in archive
    doCheck = false;

    propagatedBuildInputs = with self; [ requests gevent ];

    meta = {
      description = "Asynchronous HTTP requests";
      homepage = https://github.com/kennethreitz/grequests;
      license = with licenses; [ bsd2 ];
      maintainers = with maintainers; [ matejc ];
    };
  };

  first = callPackage ../development/python-modules/first {};

  flaskbabel = buildPythonPackage rec {
    name = "Flask-Babel-0.11.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/F/Flask-Babel/${name}.tar.gz";
      sha256 = "16b80cipdba9xj3jlaiaq6wgrgpjb70w3j01jjy9hbp4k71kd6yj";
    };

    propagatedBuildInputs = with self; [ flask jinja2 speaklater Babel pytz ];

    meta = {
      description = "Adds i18n/l10n support to Flask applications";
      homepage = https://github.com/mitsuhiko/flask-babel;
      license = "bsd";
      maintainers = with maintainers; [ matejc ];
    };
  };

  speaklater = buildPythonPackage rec {
    name = "speaklater-1.3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/speaklater/${name}.tar.gz";
      sha256 = "1ab5dbfzzgz6cnz4xlwx79gz83id4bhiw67k1cgqrlzfs0va7zjr";
    };

    meta = {
      description = "Implements a lazy string for python useful for use with gettext";
      homepage = https://github.com/mitsuhiko/speaklater;
      license = "bsd";
      maintainers = with maintainers; [ matejc ];
    };
  };

  pushbullet = buildPythonPackage rec {
    name = "pushbullet.py-${version}";
    version = "0.10.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pushbullet.py/pushbullet.py-0.10.0.tar.gz";
      sha256 = "537d3132e1dbc91e31ade4cccf4c7def6f9d48e904a67f341d35b8a54a9be74d";
    };

    propagatedBuildInputs = with self; [requests websocket_client python_magic ];
  };

  power = buildPythonPackage rec {
    name = "power-1.4";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/power/${name}.tar.gz";
      sha256 = "7d7d60ec332acbe3a7d00379b45e39abf650bf7ee311d61da5ab921f52f060f0";
    };

    # Tests can't work because there is no power information available.
    doCheck = false;

    meta = {
      description = "Cross-platform system power status information";
      homepage = https://github.com/Kentzo/Power;
      license = licenses.mit;
    };
  };

  # For backwards compatibility. Please use nixpkgs.udiskie instead.
  udiskie = pkgs.udiskie.override { pythonPackages = self; };

  # Should be bumped along with EFL!
  pythonefl = buildPythonPackage rec {
    name = "python-efl-${version}";
    version = "1.20.0";
    src = pkgs.fetchurl {
      url = "http://download.enlightenment.org/rel/bindings/python/${name}.tar.xz";
      sha256 = "18qfqdkkjydqjk0nxs7wnnzdnqlbj3fhkjm0bbd927myzbihxpkh";
    };

    hardeningDisable = [ "format" ];

    preConfigure = ''
      export NIX_CFLAGS_COMPILE="$(pkg-config --cflags efl) -I${self.dbus-python}/include/dbus-1.0 $NIX_CFLAGS_COMPILE"
    '';
    preBuild = "${python}/bin/${python.executable} setup.py build_ext";
    installPhase= "${python}/bin/${python.executable} setup.py install --prefix=$out";

    nativeBuildInputs = [ pkgs.pkgconfig ];
    buildInputs = with self; [ pkgs.enlightenment.efl ];
    doCheck = false;

    meta = {
      description = "Python bindings for EFL and Elementary";
      homepage = http://enlightenment.org/;
      platforms = platforms.linux;
      license = licenses.gpl3;
      maintainers = with maintainers; [ matejc tstrobel ftrvxmtrx ];
    };
  };

  tlsh = buildPythonPackage rec {
    name = "tlsh-3.4.5";
    src = pkgs.fetchFromGitHub {
      owner = "trendmicro";
      repo = "tlsh";
      rev = "22fa9a62068b92c63f2b5a87004a7a7ceaac1930";
      sha256 = "1ydliir308xn4ywy705mmsh7863ldlixdvpqwdhbipzq9vfpmvll";
    };
    buildInputs = with pkgs; [ cmake ];
    # no test data
    doCheck = false;
    preConfigure = ''
      mkdir build
      cd build
      cmake ..
      cd ../py_ext
    '';
    meta = with stdenv.lib; {
      description = "Trend Micro Locality Sensitive Hash";
      homepage = https://github.com/trendmicro/tlsh;
      license = licenses.asl20;
      platforms = platforms.linux;
    };
  };

  toposort = buildPythonPackage rec {
    name = "toposort-${version}";
    version = "1.1";
    src = pkgs.fetchurl {
      url = "mirror://pypi/t/toposort/toposort-1.1.tar.gz";
      sha256 = "1izmirbwmd9xrk7rq83p486cvnsslfa5ljvl7rijj1r64zkcnf3a";
    };
    meta = {
      description = "A topological sort algorithm";
      homepage = https://pypi.python.org/pypi/toposort/1.1;
      maintainers = with maintainers; [ tstrobel ];
      platforms = platforms.linux;
      #license = licenses.apache;
    };
  };

  snapperGUI = buildPythonPackage rec {
    name = "Snapper-GUI";

    src = pkgs.fetchgit {
      url = "https://github.com/ricardomv/snapper-gui";
      rev = "11d98586b122180c75a86fccda45c4d7e3137591";
      sha256 = "7a9f86fc17dbf130526e70c3e925eac30e2c74d6b932efbf7e7cd9fbba6dc4b1";
    };

    # no tests available
    doCheck = false;

    propagatedBuildInputs = with self; [ pygobject3 dbus-python ];

    meta = {
      homepage = https://github.com/ricardomv/snapper-gui;
      description = "Graphical frontend for snapper";
      license = licenses.gpl2;
      maintainers = with maintainers; [ tstrobel ];
    };
  };

  redNotebook = pkgs.rednotebook; # Backwards compatibility alias.

  uncertainties = callPackage ../development/python-modules/uncertainties { };

  funcy = buildPythonPackage rec {
    name = "funcy-1.6";

    src = pkgs.fetchurl {
        url = "mirror://pypi/f/funcy/${name}.tar.gz";
        sha256 = "511495db0c5660af18d3151b008c6ce698ae7fbf60887278e79675e35eed1f01";
    };

    # No tests
    doCheck = false;

    meta = {
      description = "Collection of fancy functional tools focused on practicality";
      homepage = "http://funcy.readthedocs.org/";
      license = licenses.bsd3;

    };
  };

  svg2tikz = self.buildPythonPackage {
    name = "svg2tikz-1.0.0";
    disabled = ! isPy27;

    propagatedBuildInputs = with self; [lxml];

    src = pkgs.fetchgit {
      url = "https://github.com/kjellmf/svg2tikz";
      sha256 = "429428ec435e53672b85cdfbb89bb8af0ff9f8238f5d05970729e5177d252d5f";
      rev = "ad36f2c3818da13c4136d70a0fd8153acf8daef4";
    };

    meta = {
      homepage = https://github.com/kjellmf/svg2tikz;
      description = "An SVG to TikZ converter";
      license = licenses.gpl2Plus;
      maintainers =  with maintainers; [ gal_bolle ];
    };
  };

  syncserver = buildPythonPackage rec {
    name = "syncserver-${version}";
    version = "1.5.2";
    disabled = ! isPy27;

    src = pkgs.fetchgit {
      url = https://github.com/mozilla-services/syncserver.git;
      rev = "refs/tags/${version}";
      sha256 = "1pk4rvwvsd1vxbpzg39hxqi8pi9v6b4s6m0mqbpg88s6s7i6ks3m";
    };

    buildInputs = with self; [ unittest2 ];
    propagatedBuildInputs = with self; [
      cornice gunicorn pyramid requests simplejson sqlalchemy mozsvc tokenserver
      serversyncstorage configparser
    ];

    meta = {
      maintainers = [ ];
      platforms = platforms.all;
    };
  };

  serversyncstorage = buildPythonPackage rec {
    name = "serversyncstorage-${version}";
    version = "1.5.13";
    disabled = !isPy27;

    src = pkgs.fetchgit {
      url = https://github.com/mozilla-services/server-syncstorage.git;
      rev = "refs/tags/${version}";
      sha256 = "0m14v7n105y06w3mdp35pyxyzjj5vqwbznzdbixhkms3df6md2lq";
    };

    propagatedBuildInputs = with self; [
      pyramid sqlalchemy simplejson mozsvc cornice pyramid_hawkauth pymysql
      pymysqlsa umemcache WSGIProxy requests pybrowserid
    ];
    buildInputs = with self; [ testfixtures unittest2 webtest ];

    #doCheck = false; # lazy packager
  };

  WSGIProxy = buildPythonPackage rec {
    name = "WSGIProxy-${version}";
    version = "0.2.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/W/WSGIProxy/WSGIProxy-${version}.tar.gz";
      sha256 = "0wqz1q8cvb81a37gb4kkxxpv4w7k8192a08qzyz67rn68ln2wcig";
    };

    propagatedBuildInputs = with self; [
      paste six
    ];

    disabled = isPy3k; # Judging from SyntaxError

    meta = with stdenv.lib; {
      description = "WSGIProxy gives tools to proxy arbitrary(ish) WSGI requests to other";
      homepage = "http://pythonpaste.org/wsgiproxy/";
    };
  };

  blist = buildPythonPackage rec {
    name = "blist-${version}";
    version = "1.3.6";
    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "mirror://pypi/b/blist/blist-${version}.tar.gz";
      sha256 = "1hqz9pqbwx0czvq9bjdqjqh5bwfksva1is0anfazig81n18c84is";
    };
  };

  canonicaljson = buildPythonPackage rec {
    name = "canonicaljson-${version}";
    version = "1.0.0";

    src = pkgs.fetchgit {
      url = "https://github.com/matrix-org/python-canonicaljson.git";
      rev = "refs/tags/v${version}";
      sha256 = "0r82zlip93y169ijkn8xpbp0yr22mf92pni6dw420vb53l27sprq";
    };

    propagatedBuildInputs = with self; [
      frozendict simplejson
    ];
  };

  daemonize = buildPythonPackage rec {
    name = "daemonize-${version}";
    version = "2.4.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/d/daemonize/daemonize-${version}.tar.gz";
      sha256 = "0y139sq657bpzfv6k0aqm4071z4s40i6ybpni9qvngvdcz6r86n2";
    };
  };

  pydenticon = buildPythonPackage rec {
    name = "pydenticon-${version}";
    version = "0.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pydenticon/pydenticon-0.2.tar.gz";
      sha256 = "035dawcspgjw2rksbnn863s7b0i9ac8cc1nshshvd1l837ir1czp";
    };
    propagatedBuildInputs = with self; [
      pillow mock
    ];
  };

  pynac = buildPythonPackage rec {
    name = "pynac-${version}";
    version = "0.2";

    src = pkgs.fetchurl {
      url = "mirror://sourceforge/project/pynac/pynac/pynac-0.2/pynac-0.2.tar.gz";
      sha256 = "0avzqqcxl54karjmla9jbsyid98mva36lxahwmrsx5h40ys2ggxp";
    };

    propagatedBuildInputs = with self; [];
  };

  pymacaroons-pynacl = buildPythonPackage rec {
    name = "pymacaroons-pynacl-${version}";
    version = "0.9.3";

    src = pkgs.fetchgit {
      url = "https://github.com/matrix-org/pymacaroons.git";
      rev = "refs/tags/v${version}";
      sha256 = "0bykjk01zdndp6gjr30x46blsn0cvxa7j0zh5g8raxwaawchjhii";
    };

    propagatedBuildInputs = with self; [ pynacl six ];
  };

  pynacl = buildPythonPackage rec {
    name = "pynacl-${version}";
    version = "0.3.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/P/PyNaCl/PyNaCl-0.3.0.tar.gz";
      sha256 = "1hknxlp3a3f8njn19w92p8nhzl9jkfwzhv5fmxhmyq2m8hqrfj8j";
    };

    buildInputs = with self; [ pytest coverage ];
    propagatedBuildInputs = with self; [pkgs.libsodium six cffi pycparser];

    checkPhase = ''
      coverage run --source nacl --branch -m pytest
    '';

  };

  service-identity = callPackage ../development/python-modules/service_identity { };

  signedjson = buildPythonPackage rec {
    name = "signedjson-${version}";
    version = "1.0.0";

    src = pkgs.fetchgit {
      url = "https://github.com/matrix-org/python-signedjson.git";
      rev = "refs/tags/v${version}";
      sha256 = "0b8xxhc3npd4567kqapfp4gs7m0h057xam3an7424az262ind82n";
    };

    propagatedBuildInputs = with self; [
      canonicaljson unpaddedbase64 pynacl
    ];
  };

  unpaddedbase64 = buildPythonPackage rec {
    name = "unpaddedbase64-${version}";
    version = "1.1.0";

    src = pkgs.fetchgit {
      url = "https://github.com/matrix-org/python-unpaddedbase64.git";
      rev = "refs/tags/v${version}";
      sha256 = "0if3fjfxga0bwdq47v77fs9hrcqpmwdxry2i2a7pdqsp95258nxd";
    };
  };


  thumbor = buildPythonPackage rec {
    name = "thumbor-${version}";
    version = "6.3.2";

    disabled = ! isPy27;

    buildInputs = with self; [ statsd nose ];

    propagatedBuildInputs = with self; [
      tornado
      pycrypto
      pycurl
      pytz
      pillow
      derpconf
      python_magic
      # thumborPexif
      pexif
      libthumbor
      opencv
    ] ++ optionals (!isPy3k) [ futures ];

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/thumbor/${name}.tar.gz";
      sha256 = "0787245x4yci34cdfc9xaxhds0lv60476qgp132pwa78hrpc9m31";
    };

    patches = [
      (pkgs.fetchurl {
          url = "https://github.com/thumbor/thumbor/commit/376f688a8a0b82e50388c885d9d733572f2eb3e6.patch";
          sha256 = "1j2434yqb6pz61d65dsy8w6lvyzvh5ksizadi5hgjzfw6s46v6yn";
      })
    ];

    prePatch = ''
      substituteInPlace setup.py \
        --replace '"argparse",' ""
    '';

    meta = {
      description = "A smart imaging service";
      homepage = https://github.com/globocom/thumbor/wiki;
      license = licenses.mit;
    };
  };

  thumborPexif = self.buildPythonPackage rec {
    name = "thumbor-pexif-0.14";
    disabled = ! isPy27;

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/thumbor-pexif/${name}.tar.gz";
      sha256 = "715cd24760c7c28d6270c79c9e29b55b8d952a24e0e56833d827c2c62451bc3c";
    };

    meta = {
      description = "Module to parse and edit the EXIF data tags in a JPEG image";
      homepage = http://www.benno.id.au/code/pexif/;
      license = licenses.mit;
    };
  };

  pync = buildPythonPackage rec {
    version  = "1.4";
    baseName = "pync";
    name     = "${baseName}-${version}";
    disabled = ! isPy27;

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/${baseName}/${name}.tar.gz";
      sha256 = "0lc1x0pai85avm1r452xnvxc12wijnhz87xv20yp3is9fs6rnkrh";
    };

    buildInputs = with self; [ pkgs.coreutils ];

    propagatedBuildInputs = with self; [ dateutil ];

    preInstall = stdenv.lib.optionalString stdenv.isDarwin ''
      sed -i 's|^\([ ]*\)self.bin_path.*$|\1self.bin_path = "${pkgs.terminal-notifier}/bin/terminal-notifier"|' build/lib/pync/TerminalNotifier.py
    '';

    meta = {
      description = "Python Wrapper for Mac OS 10.8 Notification Center";
      homepage    = https://pypi.python.org/pypi/pync/1.4;
      license     = licenses.mit;
      platforms   = platforms.darwin;
      maintainers = with maintainers; [ lovek323 ];
    };
  };

  weboob = buildPythonPackage rec {
    name = "weboob-1.1";
    disabled = ! isPy27;

    src = pkgs.fetchurl {
      url = "https://symlink.me/attachments/download/324/${name}.tar.gz";
      sha256 = "0736c5wsck2abxlwvx8i4496kafk9xchkkzhg4dcfbj0isldih6b";
    };

    setupPyBuildFlags = ["--qt" "--xdg"];

    propagatedBuildInputs = with self; [ pillow prettytable pyyaml dateutil gdata requests mechanize feedparser lxml pkgs.gnupg pyqt4 pkgs.libyaml simplejson cssselect futures pdfminer termcolor ];

    meta = {
      homepage = http://weboob.org;
      description = "Collection of applications and APIs to interact with websites without requiring the user to open a browser";
      license = licenses.agpl3;
      maintainers = with maintainers; [ ];
    };
  };

  datadiff = buildPythonPackage rec {
    name = "datadiff-1.1.6";
    disabled = ! isPy27;

    src = pkgs.fetchurl {
      url = "mirror://pypi/d/datadiff/datadiff-1.1.6.zip";
      sha256 = "f1402701063998f6a70609789aae8dc05703f3ad0a34882f6199653654c55543";
    };

    buildInputs = with self; [ nose ];

    meta = {
      description = "DataDiff";
      homepage = https://sourceforge.net/projects/datadiff/;
      license = licenses.asl20;
    };
  };

  termcolor = buildPythonPackage rec {
    name = "termcolor-1.1.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/termcolor/termcolor-1.1.0.tar.gz";
      sha256 = "1d6d69ce66211143803fbc56652b41d73b4a400a2891d7bf7a1cdf4c02de613b";
    };

    meta = {
      description = "Termcolor";
      homepage = https://pypi.python.org/pypi/termcolor;
      license = licenses.mit;
    };
  };

  html2text = buildPythonPackage rec {
    name = "html2text-2016.9.19";

    src = pkgs.fetchurl {
      url = "mirror://pypi/h/html2text/${name}.tar.gz";
      sha256 = "554ef5fd6c6cf6e3e4f725a62a3e9ec86a0e4d33cd0928136d1c79dbeb7b2d55";
    };

    meta = {
      description = "Turn HTML into equivalent Markdown-structured text";
      homepage = https://github.com/Alir3z4/html2text/;
      license = licenses.gpl3;
    };
  };

  pychart = buildPythonPackage rec {
    name = "pychart-1.39";
    disabled = ! isPy27;

    src = pkgs.fetchurl {
      url = "http://download.gna.org/pychart/PyChart-1.39.tar.gz";
      sha256 = "882650928776a7ca72e67054a9e0ac98f78645f279c0cfb5910db28f03f07c2e";
    };

    meta = {
      description = "Library for creating high quality encapsulated Postscript, PDF, PNG, or SVG charts";
      homepage = http://home.gna.org/pychart/;
      license = licenses.gpl2;
    };
  };

  parsimonious = buildPythonPackage rec {
    version = "0.7.0";
    name = "parsimonious-${version}";
    src = pkgs.fetchFromGitHub {
      repo = "parsimonious";
      owner = "erikrose";
      rev = version;
      sha256 = "087npc8ccryrxabmqifcz56w4wd0hzmv0mc91wrbhc1sil196j0a";
    };

    propagatedBuildInputs = with self; [ nose six ];

    meta = {
      homepage = "https://github.com/erikrose/parsimonious";
      description = "Fast arbitrary-lookahead parser written in pure Python";
      license = licenses.mit;
    };
  };

  networkx = buildPythonPackage rec {
    version = "1.11";
    name = "networkx-${version}";

    # Currently broken on PyPy.
    # https://github.com/networkx/networkx/pull/1361
    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "mirror://pypi/n/networkx/${name}.tar.gz";
      sha256 = "1f74s56xb4ggixiq0vxyfxsfk8p20c7a099lpcf60izv1php03hd";
    };

    buildInputs = with self; [ nose ];
    propagatedBuildInputs = with self; [ decorator ];

    # 17 failures with 3.6 https://github.com/networkx/networkx/issues/2396#issuecomment-304437299
    doCheck = !(isPy36);

    meta = {
      homepage = "https://networkx.github.io/";
      description = "Library for the creation, manipulation, and study of the structure, dynamics, and functions of complex networks";
      license = licenses.bsd3;
    };
  };

  ofxclient = callPackage ../development/python-modules/ofxclient {};

  ofxhome = buildPythonPackage rec {
    name = "ofxhome-0.3.1";
    src = pkgs.fetchurl {
      url = "mirror://pypi/o/ofxhome/${name}.tar.gz";
      sha256 = "0000db437fd1a8c7c65cea5d88ce9d3b54642a1f4844dde04f860e29330ac68d";
    };

    buildInputs = with self; [ nose ];

    # ImportError: No module named tests
    doCheck = false;

    meta = {
      homepage = "https://github.com/captin411/ofxhome";
      description = "ofxhome.com financial institution lookup REST client";
      license = licenses.mit;
    };
  };

  ofxparse = buildPythonPackage rec {
    name = "ofxparse-0.14";
    src = pkgs.fetchurl {
      url = "mirror://pypi/o/ofxparse/${name}.tar.gz";
      sha256 = "d8c486126a94d912442d040121db44fbc4a646ea70fa935df33b5b4dbfbbe42a";
    };

    propagatedBuildInputs = with self; [ six beautifulsoup4 ];

    meta = {
      homepage = "http://sites.google.com/site/ofxparse";
      description = "Tools for working with the OFX (Open Financial Exchange) file format";
      license = licenses.mit;
    };
  };

  ofxtools = buildPythonPackage rec {
    name = "ofxtools-0.3.8";
    src = pkgs.fetchurl {
      url = "mirror://pypi/o/ofxtools/${name}.tar.gz";
      sha256 = "88f289a60f4312a1599c38a8fb3216e2b46d10cc34476f9a16a33ac8aac7ec35";
    };

    checkPhase = ''
      ${python.interpreter} -m unittest discover -s ofxtools
    '';

    buildInputs = with self; [ sqlalchemy ];

    meta = {
      homepage = "https://github.com/csingley/ofxtools";
      description = "Library for working with Open Financial Exchange (OFX) formatted data used by financial institutions";
      license = licenses.mit;
      broken = true;
    };
  };

  basemap = buildPythonPackage rec {
    name = "basemap-1.0.7";

    src = pkgs.fetchurl {
      url = "mirror://sourceforge/project/matplotlib/matplotlib-toolkits/basemap-1.0.7/basemap-1.0.7.tar.gz";
      sha256 = "0ca522zirj5sj10vg3fshlmgi615zy5gw2assapcj91vsvhc4zp0";
    };

    propagatedBuildInputs = with self; [ numpy matplotlib pillow ];
    buildInputs = with self; with pkgs ; [ setuptools geos proj ];

    # Standard configurePhase from `buildPythonPackage` seems to break the setup.py script
    configurePhase = ''
      export GEOS_DIR=${pkgs.geos}
    '';

    # The 'check' target is not supported by the `setup.py` script.
    # TODO : do the post install checks (`cd examples && ${python.interpreter} run_all.py`)
    doCheck = false;

    meta = {
      homepage = "http://matplotlib.org/basemap/";
      description = "Plot data on map projections with matplotlib";
      longDescription = ''
        An add-on toolkit for matplotlib that lets you plot data on map projections with
        coastlines, lakes, rivers and political boundaries. See
        http://matplotlib.github.com/basemap/users/examples.html for examples of what it can do.
      '';
      license = with licenses; [ mit gpl2 ];
    };
  };

  dicttoxml = buildPythonPackage rec {
    name = "dicttoxml-1.6.4";

    src = pkgs.fetchurl {
      url = "mirror://pypi/d/dicttoxml/dicttoxml-1.6.4.tar.gz";
      sha256 = "5f29e95fec56680823dc41911c04c2af08727ee53c1b60e83c489212bab71161";
    };

    propagatedBuildInputs = with self; [  ];

    meta = {
      description = "Summary";
      homepage = https://github.com/quandyfactory/dicttoxml;
    };
  };

  markdown2 = callPackage ../development/python-modules/markdown2 { };

  evernote = buildPythonPackage rec {
    name = "evernote-${version}";
    version = "1.25.0";
    disabled = ! isPy27; #some dependencies do not work with py3

    src = pkgs.fetchurl {
      url = "mirror://pypi/e/evernote/${name}.tar.gz";
      sha256 = "1lwlg6fpi3530245jzham1400a5b855bm4sbdyck229h9kg1v02d";
    };

     propagatedBuildInputs = with self; [ oauth2 ];

     meta = {
      description = "Evernote SDK for Python";
      homepage = http://dev.evernote.com;
      license = licenses.asl20;
      maintainers = with maintainers; [ hbunke ];
     };
  };

  setproctitle = buildPythonPackage rec {
    name = "python-setproctitle-${version}";
    version = "1.1.9";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/setproctitle/setproctitle-${version}.tar.gz";
      sha256 = "1mqadassxcm0m9r1l02m5vr4bbandn48xz8gifvxmb4wiz8i8d0w";
    };

    meta = {
      description = "Allows a process to change its title (as displayed by system tools such as ps and top)";
      homepage =  https://github.com/dvarrazzo/py-setproctitle;
      license = licenses.bsdOriginal;
      maintainers = with maintainers; [ exi ];
    };
  };

  thrift = buildPythonPackage rec {
    name = "thrift-${version}";
    version = "0.9.3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/thrift/${name}.tar.gz";
      sha256 = "dfbc3d3bd19d396718dab05abaf46d93ae8005e2df798ef02e32793cd963877e";
    };

    # No tests. Breaks when not disabling.
    doCheck = false;

    meta = {
      description = "Python bindings for the Apache Thrift RPC system";
      homepage = http://thrift.apache.org/;
      license = licenses.asl20;
      maintainers = with maintainers; [ hbunke ];

    };
  };

  geeknote = buildPythonPackage rec {
    version = "2015-05-11";
    name = "geeknote-${version}";
    disabled = ! isPy27;

    src = pkgs.fetchFromGitHub {
      owner = "VitaliyRodnenko";
      repo = "geeknote";
      rev = "8489a87d044e164edb321ba9acca8d4631de3dca";
      sha256 = "0l16v4xnyqnsf84b1pma0jmdyxvmfwcv3sm8slrv3zv7zpmcm3lf";
    };

    /* build with tests fails with "Can not create application dirictory :
     /homeless-shelter/.geeknotebuilder". */
    doCheck = false;

    propagatedBuildInputs = with self; [
        thrift
        beautifulsoup4
        markdown2
        sqlalchemy
        html2text
        evernote
    ];

    meta = {
      description = "Work with Evernote from command line";
      homepage = http://www.geeknote.me;
      license = licenses.gpl1;
      maintainers = with maintainers; [ hbunke ];

    };
  };

  trollius = callPackage ../development/python-modules/trollius {};

  neovim = buildPythonPackage rec {
    version = "0.2.0";
    name = "neovim-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/n/neovim/${name}.tar.gz";
      sha256 = "1ywkgbrxd95cwlglihydmffcw2d2aji6562aqncymxs3ld5y02yn";
    };

    buildInputs = with self; [ nose ];

    checkPhase = ''
      nosetests
    '';

    # Tests require pkgs.neovim,
    # which we cannot add because of circular dependency.
    doCheck = false;

    propagatedBuildInputs = with self; [ msgpack ]
      ++ optional (!isPyPy) greenlet
      ++ optional (pythonOlder "3.4") trollius;

    meta = {
      description = "Python client for Neovim";
      homepage = "https://github.com/neovim/python-client";
      license = licenses.asl20;
      maintainers = with maintainers; [ garbas ];
    };
  };

  neovim_gui = buildPythonPackage rec {
    name = "neovim-pygui-${self.neovim.version}";
    version = "0.1.3";
    disabled = !isPy27;

    src = pkgs.fetchFromGitHub {
      owner = "neovim";
      repo = "python-gui";
      rev = version;
      sha256 = "1vpvr3zm3f9sxg1z1cl7f7gi8v1xksjdvxj62qnw65aqj3zqxnkz";
    };

    propagatedBuildInputs = [
      self.neovim
      self.click
      self.pygobject3
      pkgs.gobjectIntrospection
      pkgs.makeWrapper
      pkgs.gtk3
    ];

    patchPhase = ''
      sed -i -e "s|entry_points=entry_points,|entry_points=dict(console_scripts=['pynvim=neovim.ui.cli:main [GUI]']),|" setup.py
    '';

    postInstall = ''
      wrapProgram $out/bin/pynvim \
        --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
        --prefix PYTHONPATH : "${self.pygobject3}/lib/python2.7/site-packages:$PYTHONPATH"
    '';
  };

  ghp-import = buildPythonPackage rec {
    version = "0.4.1";
    name = "ghp-import-${version}";
    src = pkgs.fetchurl {
      url = "mirror://pypi/g/ghp-import/${name}.tar.gz";
      sha256 = "6058810e1c46dd3b5b1eee87e203bdfbd566e10cfc77566edda7aa4dbf6a3053";
    };
    disabled = isPyPy;
    buildInputs = [ pkgs.glibcLocales ];

    LC_ALL="en_US.UTF-8";

    # No tests available
    doCheck = false;

    meta = {
      description = "Copy your docs directly to the gh-pages branch";
      homepage = "http://github.com/davisp/ghp-import";
      license = "Tumbolia Public License";
      maintainers = with maintainers; [ garbas ];
    };
  };

  typogrify = buildPythonPackage rec {
    name = "typogrify-2.0.7";
    src = pkgs.fetchurl {
      url = "mirror://pypi/t/typogrify/${name}.tar.gz";
      sha256 = "8be4668cda434163ce229d87ca273a11922cb1614cb359970b7dc96eed13cb38";
    };
    disabled = isPyPy;
    # Wants to set up Django
    doCheck = false;
    propagatedBuildInputs = with self; [ django smartypants jinja2 ];
    meta = {
      description = "Filters to enhance web typography, including support for Django & Jinja templates";
      homepage = "https://github.com/mintchaos/typogrify";
      license = licenses.bsd3;
      maintainers = with maintainers; [ garbas ];
    };
  };

  smartypants = buildPythonPackage rec {
    version = "1.8.6";
    name = "smartypants-${version}";
    src = pkgs.fetchhg {
      url = "https://bitbucket.org/livibetter/smartypants.py";
      rev = "v${version}";
      sha256 = "1cmzz44d2hm6y8jj2xcq1wfr26760gi7iq92ha8xbhb1axzd7nq6";
    };
    disabled = isPyPy;
    buildInputs = with self; [ ]; #docutils pygments ];
    meta = {
      description = "Python with the SmartyPants";
      homepage = "https://bitbucket.org/livibetter/smartypants.py";
      license = licenses.bsd3;
      maintainers = with maintainers; [ garbas ];
    };
  };

  pypeg2 = buildPythonPackage rec {
    version = "2.15.2";
    name = "pypeg2-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pyPEG2/pyPEG2-${version}.tar.gz";
      sha256 = "0v8ziaam2r637v94ra4dbjw6jzxz99gs5x4i585kgag1v204yb9b";
    };

    #https://bitbucket.org/fdik/pypeg/issues/36/test-failures-on-py35
    doCheck = !isPy3k;

    meta = {
      description = "PEG parser interpreter in Python";
      homepage = http://fdik.org/pyPEG;
      license = licenses.gpl2;
    };
  };

  torchvision = callPackage ../development/python-modules/torchvision { };

  jenkinsapi = buildPythonPackage rec {
    name = "jenkinsapi-${version}";
    version = "0.2.32";

    src = pkgs.fetchurl {
      url = "mirror://pypi/j/jenkinsapi/${name}.tar.gz";
      sha256 = "0fcc78b8dfc87237942aad2a8be54dbc08bc4afceaa7f6897f3d894e7d4bfd22";
    };

    propagatedBuildInputs = with self; [ pytz requests ];

    buildInputs = with self; [ coverage mock nose unittest2 ];

    meta = {
      description = "A Python API for accessing resources on a Jenkins continuous-integration server";
      homepage = https://github.com/salimfadhley/jenkinsapi;
      maintainers = with maintainers; [ drets ];
      license = licenses.mit;
    };
  };

  jenkins-job-builder = buildPythonPackage rec {
    name = "jenkins-job-builder-2.0.0.0b2";
    disabled = ! (isPy26 || isPy27);

    src = pkgs.fetchurl {
      url = "mirror://pypi/j/jenkins-job-builder/${name}.tar.gz";
      sha256 = "1y0yl2w6c9c91f9xbjkvff1ag8p72r24nzparrzrw9sl8kn9632x";
    };

    patchPhase = ''
      export HOME=$TMPDIR
    '';

    buildInputs = with self; [
      pip
    ];

    propagatedBuildInputs = with self; [
      pbr
      mock
      python-jenkins
      pyyaml
      six
      stevedore
    ] ++ optionals isPy26 [
      ordereddict
      argparse
      ordereddict
    ];

    meta = {
      description = "Jenkins Job Builder is a system for configuring Jenkins jobs using simple YAML files stored in Git";
      homepage = "http://docs.openstack.org/infra/system-config/jjb.html";
      license = licenses.asl20;
      maintainers = with maintainers; [ garbas ];
    };
  };

  dot2tex = buildPythonPackage rec {
    name = "dot2tex-2.9.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/d/dot2tex/dot2tex-2.9.0.tar.gz";
      sha256 = "7d3e54add7dccdaeb6cc9e61ceaf7b587914cf8ebd6821cfea008acdc1e50d4a";
    };

    # Tests fail with 3.x. Furthermore, package is no longer maintained.
    disabled = isPy3k;

    propagatedBuildInputs = with self; [
      pyparsing
    ];

    meta = {
      description = "Convert graphs generated by Graphviz to LaTeX friendly formats";
      homepage = "https://github.com/kjellmf/dot2tex";
      license = licenses.mit;
    };
  };

  poezio = buildPythonApplication rec {
    name = "poezio-${version}";
    version = "0.11";

    disabled = pythonOlder "3.4";

    buildInputs = with self; [ pytest ];
    propagatedBuildInputs = with self ; [ aiodns slixmpp pyinotify potr mpd2 ];

    src = pkgs.fetchurl {
      url = "http://dev.louiz.org/attachments/download/118/${name}.tar.gz";
      sha256 = "07cn3717swarjv47yw8x95bvngz4nvlyyy9m7ck9fhycjgdy82r0";
    };

    patches = [
      ../development/python-modules/poezio/fix_gnupg_import.patch
    ];

    checkPhase = ''
      py.test
    '';

    meta = {
      description = "Free console XMPP client";
      homepage = http://poez.io;
      license = licenses.mit;
      maintainers = [ maintainers.lsix ];
    };
  };

  potr = buildPythonPackage rec {
    version = "1.0.1";
    name = "potr-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/python-potr/python-${name}.zip";
      sha256 = "1b3vjbv8hvynwj6amw3rg5zj8bagynbj0ipy09xwksf1mb0kz8m8";
    };

    propagatedBuildInputs = with self ; [ pycrypto ];

    meta = {
      description = "A pure Python OTR implementation";
      homepage = "http://python-otr.pentabarf.de/";
      license = licenses.lgpl3Plus;
      maintainers = with maintainers; [ globin ];
    };
  };

  pluggy = buildPythonPackage rec {
    name = "pluggy-${version}";
    version = "0.3.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pluggy/${name}.tar.gz";
      sha256 = "18qfzfm40bgx672lkg8q9x5hdh76n7vax99aank7vh2nw21wg70m";
    };

    meta = {
      description = "Plugin and hook calling mechanisms for Python";
      homepage = "https://pypi.python.org/pypi/pluggy";
      license = licenses.mit;
      maintainers = with maintainers; [ jgeerds ];
    };
  };

  xcffib = buildPythonPackage rec {
    version = "0.3.2";
    name = "xcffib-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/x/xcffib/${name}.tar.gz";
      sha256 = "a84eecd5a1bb7570e26c83aca87a2016578ca4e353e1fa56189e95bdef063e6a";
    };

    patchPhase = ''
      # Hardcode cairo library path
      sed -e 's,ffi\.dlopen(,&"${pkgs.xorg.libxcb.out}/lib/" + ,' -i xcffib/__init__.py
    '';

    propagatedBuildInputs = [ self.cffi self.six ];

    meta = {
      description = "A drop in replacement for xpyb, an XCB python binding";
      homepage = "https://github.com/tych0/xcffib";
      license = licenses.asl20;
      maintainers = with maintainers; [ kamilchm ];
    };
  };

  pafy = callPackage ../development/python-modules/pafy { };

  suds = buildPythonPackage rec {
    name = "suds-0.4";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/suds/suds-0.4.tar.gz";
      sha256 = "1w4s9051iv90c0gs73k80c3d51y2wbx1xgfdgg2hk7mv4gjlllnm";
    };

    patches = [ ../development/python-modules/suds-0.4-CVE-2013-2217.patch ];

    meta = with stdenv.lib; {
      # Broken for security issues:
      # - https://github.com/NixOS/nixpkgs/issues/19678
      # - https://lwn.net/Vulnerabilities/559200/
      broken = true;
      description = "Lightweight SOAP client";
      homepage = https://fedorahosted.org/suds;
      license = licenses.lgpl3Plus;
    };
  };

  suds-jurko = buildPythonPackage rec {
    name = "suds-jurko-${version}";
    version = "0.6";
    disabled = isPyPy;  # lots of failures

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/suds-jurko/${name}.zip";
      sha256 = "1s4radwf38kdh3jrn5acbidqlr66sx786fkwi0rgq61hn4n2bdqw";
    };

    buildInputs = [ self.pytest ];

    preBuild = ''
      # fails
      substituteInPlace tests/test_transport_http.py \
        --replace "test_sending_unicode_data" "noop"
    '';

    meta = with stdenv.lib; {
      description = "Lightweight SOAP client (Jurko's fork)";
      homepage = "http://bitbucket.org/jurko/suds";
    };
  };

  mailcap-fix = buildPythonPackage rec {
    name = "mailcap-fix-${version}";
    version = "1.0.1";

    disabled = isPy36; # this fix is merged into python 3.6

    src = pkgs.fetchurl {
      url = "mirror://pypi/m/mailcap-fix/${name}.tar.gz";
      sha256 = "02lijkq6v379r8zkqg9q2srin3i80m4wvwik3hcbih0s14v0ng0i";
    };

    meta = with stdenv.lib; {
      description = "A patched mailcap module that conforms to RFC 1524";
      homepage = "https://github.com/michael-lazar/mailcap_fix";
      license = licenses.unlicense;
    };
  };

  maildir-deduplicate = buildPythonPackage rec {
    name = "maildir-deduplicate-${version}";
    version = "1.0.2";

    disabled = !isPy27;

    src = pkgs.fetchurl {
      url = "mirror://pypi/m/maildir-deduplicate/${name}.tar.gz";
      sha256 = "1xy5z756alrjgpl9qx2gdx898rw1mryrqkwmipbh39mgrvkl3fz9";
    };

    propagatedBuildInputs = with self; [ click ];

    meta = with stdenv.lib; {
      description = "Command-line tool to deduplicate mails from a set of maildir folders";
      homepage = "https://github.com/kdeldycke/maildir-deduplicate";
      license = licenses.gpl2;
    };
  };


  mps-youtube = buildPythonPackage rec {
    name = "mps-youtube-${version}";
    version = "0.2.7.1";

    disabled = (!isPy3k);

    # disabled due to error in loading unittest
    # don't know how to make test from: <mps_youtube. ...>
    doCheck = false;

    # before check create a directory and redirect XDG_CONFIG_HOME to it
    preCheck = ''
      mkdir -p check-phase
      export XDG_CONFIG_HOME=$(pwd)/check-phase
    '';

    src = pkgs.fetchFromGitHub {
      owner = "mps-youtube";
      repo = "mps-youtube";
      rev = "v${version}";
      sha256 = "16zn5gwb3568w95lr21b88zkqlay61p1541sa9c3x69zpi8v0pys";
    };

    propagatedBuildInputs = with self; [ pafy ];

    meta = with stdenv.lib; {
      description = "Terminal based YouTube player and downloader";
      homepage = https://github.com/np1/mps-youtube;
      license = licenses.gpl3;
      maintainers = with maintainers; [ odi ];
    };
  };

  d2to1 = buildPythonPackage rec {
    name = "d2to1-${version}";
    version = "0.2.11";

    buildInputs = with self; [ nose ];
    src = pkgs.fetchurl {
      url = "mirror://pypi/d/d2to1/d2to1-${version}.tar.gz";
      sha256 = "1a5z367b7dpd6dgi0w8pymb68aj2pblk8w04l2c8hibhj8dpl2b4";
    };

    meta = {
      description = "Support for distutils2-like setup.cfg files as package metadata";
      homepage = https://pypi.python.org/pypi/d2to1;
      license = licenses.bsd2;
      maintainers = [ maintainers.makefu ];
    };
  };

  ovh = buildPythonPackage rec {
    name = "ovh-${version}";
    version = "0.4.5";
    doCheck = false; #test needs packages too explicit
    buildInputs = with self; [ d2to1 ];
    propagatedBuildInputs = with self; [ requests ];

    src = pkgs.fetchurl {
      url = "mirror://pypi/o/ovh/ovh-${version}.tar.gz";
      sha256 = "1wf2p1sbg34jpj97r3w5nx9pj6vp0mlprry3vw2xav3dv02qv2af";
    };

    meta = {
      description = "Thin wrapper around OVH's APIs";
      homepage = https://pypi.python.org/pypi/ovh;
      license = licenses.bsd2;
      maintainers = [ maintainers.makefu ];
    };
  };

  willow = buildPythonPackage rec {
    name = "willow-${version}";
    version = "0.2.2";
    disabled = pythonOlder "2.7";

    src = pkgs.fetchurl {
      url = "mirror://pypi/W/Willow/Willow-${version}.tar.gz";
      sha256 = "111c82fbfcda2710ce6201b0b7e0cfa1ff3c4f2f0dc788cc8dfc8db933c39c73";
    };

    propagatedBuildInputs = with self; [ six pillow ];

    # Test data is not included
    # https://github.com/torchbox/Willow/issues/34
    doCheck = false;

    meta = {
      description = "A Python image library that sits on top of Pillow, Wand and OpenCV";
      homepage = https://github.com/torchbox/Willow/;
      license = licenses.bsd2;
      maintainers = with maintainers; [ desiderius ];
    };
  };

  importmagic = buildPythonPackage rec {
    simpleName = "importmagic";
    name = "${simpleName}-${version}";
    version = "0.1.3";
    doCheck = false;  # missing json file from tarball

    src = pkgs.fetchurl {
      url = "mirror://pypi/i/${simpleName}/${name}.tar.gz";
      sha256 = "194bl8l8sc2ibwi6g5kz6xydkbngdqpaj6r2gcsaw1fc73iswwrj";
    };

    propagatedBuildInputs = with self; [ six ];

    meta = {
      description = "Python Import Magic - automagically add, remove and manage imports";
      homepage = https://github.com/alecthomas/importmagic;
      license = "bsd";
    };
  };

  xgboost = buildPythonPackage rec {
    name = "xgboost-${version}";

    inherit (pkgs.xgboost) version src meta;

    propagatedBuildInputs = with self; [ scipy ];
    buildInputs = with self; [ nose ];

    postPatch = ''
      cd python-package

      sed "s/CURRENT_DIR = os.path.dirname(__file__)/CURRENT_DIR = os.path.abspath(os.path.dirname(__file__))/g" -i setup.py
      sed "/^LIB_PATH.*/a LIB_PATH = [os.path.relpath(LIB_PATH[0], CURRENT_DIR)]" -i setup.py
      cat <<EOF >xgboost/libpath.py
      def find_lib_path():
        return ["${pkgs.xgboost}/lib/libxgboost.so"]
      EOF
    '';

    postInstall = ''
      rm -rf $out/xgboost
    '';
  };

  xkcdpass = buildPythonPackage rec {
    name = "xkcdpass-${version}";
    version = "1.4.2";
    src = pkgs.fetchurl {
      url = "mirror://pypi/x/xkcdpass/xkcdpass-1.4.2.tar.gz";
      sha256 = "4c1f8bee886820c42ccc64c15c3a2275dc6d01028cf6af7c481ded87267d8269";
    };

    # No tests included
    # https://github.com/redacted/XKCD-password-generator/issues/32
    doCheck = false;

    meta = {
      homepage = https://pypi.python.org/pypi/xkcdpass/;
      description = "Generate secure multiword passwords/passphrases, inspired by XKCD";
      license = licenses.bsd3;
      maintainers = [ ];
    };
  };

  xstatic = buildPythonPackage rec {
    name = "XStatic-${version}";
    version = "1.0.1";
    src = pkgs.fetchurl {
      url = "mirror://pypi/X/XStatic/XStatic-${version}.tar.gz";
      sha256 = "09npcsyf1ccygjs0qc8kdsv4qqy8gm1m6iv63g9y1fgbcry3vj8f";
    };
    meta = {
      homepage = https://bitbucket.org/thomaswaldmann/xstatic;
      description = "Base packaged static files for python";
      license = licenses.mit;
      maintainers = [ maintainers.makefu ];
    };
  };

  xlsx2csv = buildPythonPackage rec {
    name = "xlsx2csv-${version}";
    version = "0.7.2";
    src = pkgs.fetchurl {
      url = "mirror://pypi/x/xlsx2csv/${name}.tar.gz";
      sha256 = "7c6c8fa6c2774224d03a6a96049e116822484dccfa3634893397212ebcd23866";
    };
    meta = {
      homepage = https://github.com/bitprophet/alabaster;
      description = "Convert xlsx to csv";
      license = licenses.bsd3;
      maintainers = with maintainers; [ jb55 ];
    };
  };

  xmpppy = callPackage ../development/python-modules/xmpppy {};

  xstatic-bootbox = buildPythonPackage rec {
    name = "XStatic-Bootbox-${version}";
    version = "4.3.0.1";
    src = pkgs.fetchurl {
      url = "mirror://pypi/X/XStatic-Bootbox/XStatic-Bootbox-${version}.tar.gz";
      sha256 = "0wks1lsqngn3gvlhzrvaan1zj8w4wr58xi0pfqhrzckbghvvr0gj";
    };

    meta = {
      homepage =  http://bootboxjs.com;
      description = "bootboxjs packaged static files for python";
      license = licenses.mit;
      maintainers = [ maintainers.makefu ];
    };
  };

  xstatic-bootstrap = buildPythonPackage rec {
    name = "XStatic-Bootstrap-${version}";
    version = "3.3.5.1";
    src = pkgs.fetchurl {
      url = "mirror://pypi/X/XStatic-Bootstrap/XStatic-Bootstrap-${version}.tar.gz";
      sha256 = "0jzjq3d4vp2shd2n20f9y53jnnk1cvphkj1v0awgrf18qsy2bmin";
    };

    meta = {
      homepage =  http://getbootstrap.com;
      description = "bootstrap packaged static files for python";
      license = licenses.mit;
      maintainers = [ maintainers.makefu ];
    };
  };

  xstatic-jquery = buildPythonPackage rec {
    name = "XStatic-jQuery-${version}";
    version = "1.10.2.1";
    src = pkgs.fetchurl {
      url = "mirror://pypi/X/XStatic-jQuery/XStatic-jQuery-${version}.tar.gz";
      sha256 = "018kx4zijflcq8081xx6kmiqf748bsjdq7adij2k91bfp1mnlhc3";
    };

    meta = {
      homepage =  http://jquery.org;
      description = "jquery packaged static files for python";
      license = licenses.mit;
      maintainers = [ maintainers.makefu ];
    };
  };

  xstatic-jquery-file-upload = buildPythonPackage rec {
    name = "XStatic-jQuery-File-Upload-${version}";
    version = "9.7.0.1";
    propagatedBuildInputs = with self;[ xstatic-jquery ];
    src = pkgs.fetchurl {
      url = "mirror://pypi/X/XStatic-jQuery-File-Upload/XStatic-jQuery-File-Upload-${version}.tar.gz";
      sha256 = "0d5za18lhzhb54baxq8z73wazq801n3qfj5vgcz7ri3ngx7nb0cg";
    };

    meta = {
      homepage =  http://plugins.jquery.com/project/jQuery-File-Upload;
      description = "jquery-file-upload packaged static files for python";
      license = licenses.mit;
      maintainers = [ maintainers.makefu ];
    };
  };

  xstatic-jquery-ui = buildPythonPackage rec {
    name = "XStatic-jquery-ui-${version}";
    version = "1.12.0.1";
    propagatedBuildInputs = with self; [ xstatic-jquery ];
    src = pkgs.fetchurl {
      url = "mirror://pypi/X/XStatic-jquery-ui/XStatic-jquery-ui-${version}.tar.gz";
      sha256 = "0w7mabv6qflpd47g33j3ggp5rv17mqk0xz3bsdswcj97wqpga2l2";
    };

    meta = {
      homepage = http://jqueryui.com/;
      description = "jquery-ui packaged static files for python";
      license = licenses.mit;
      maintainers = [ maintainers.makefu ];
    };
  };

  xstatic-pygments = buildPythonPackage rec {
    name = "XStatic-Pygments-${version}";
    version = "1.6.0.1";
    src = pkgs.fetchurl {
      url = "mirror://pypi/X/XStatic-Pygments/XStatic-Pygments-${version}.tar.gz";
      sha256 = "0fjqgg433wfdnswn7fad1g6k2x6mf24wfnay2j82j0fwgkdxrr7m";
    };

    meta = {
      homepage = http://pygments.org;
      description = "pygments packaged static files for python";
      license = licenses.bsd2;
      maintainers = [ maintainers.makefu ];
    };
  };

  hidapi = callPackage ../development/python-modules/hidapi {
    inherit (pkgs) udev libusb1;
  };

  mnemonic = callPackage ../development/python-modules/mnemonic { };

  keepkey = callPackage ../development/python-modules/keepkey { };

  libagent = callPackage ../development/python-modules/libagent { };

  ledgerblue = callPackage ../development/python-modules/ledgerblue { };

  ecpy = callPackage ../development/python-modules/ecpy { };

  semver = callPackage ../development/python-modules/semver { };

  ed25519 = callPackage ../development/python-modules/ed25519 { };

  trezor = callPackage ../development/python-modules/trezor { };

  trezor_agent = buildPythonPackage rec{
    name = "${pname}-${version}";
    pname = "trezor_agent";
    version = "0.9.0";

    src = fetchPypi {
      inherit pname version;
      sha256 = "1i5cdamlf3c0ym600pjklij74p8ifj9cv7xrpnrfl1b8nkadswbz";
    };

    propagatedBuildInputs = with self; [
      trezor libagent ecdsa ed25519
      mnemonic keepkey semver
    ];

    meta = {
      description = "Using Trezor as hardware SSH agent";
      homepage = https://github.com/romanz/trezor-agent;
      license = licenses.gpl3;
      maintainers = with maintainers; [ np ];
    };
  };

  x11_hash = buildPythonPackage rec{
    version = "1.4";
    name = "x11_hash-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/x/x11_hash/${name}.tar.gz";
      sha256 = "172skm9xbbrivy1p4xabxihx9lsnzi53hvzryfw64m799k2fmp22";
    };

    meta = {
      description = "Binding for X11 proof of work hashing";
      homepage = https://github.com/mazaclub/x11_hash;
      license = licenses.mit;
      maintainers = with maintainers; [ np ];
    };
  };

  termstyle = buildPythonPackage rec {
    name = "python-termstyle-${version}";
    version = "0.1.10";
    src = pkgs.fetchurl {
      url = "mirror://pypi/p/python-termstyle/${name}.tar.gz";
      sha256 = "1qllzkx1alf14zcfapppf8w87si4cpa7lgjmdp3f5idzdyqnnapl";
    };

    meta = {
      description = "Console colouring for python";
      homepage = "https://pypi.python.org/pypi/python-termstyle/0.1.10";
      license = licenses.bsdOriginal;
    };

  };

  green = buildPythonPackage rec {
    name = "green-${version}";
    version = "2.3.0";
    src = pkgs.fetchurl {
      url = "mirror://pypi/g/green/${name}.tar.gz";
      sha256 = "1888khfl9yxb8yfxq9b48dxwplqlxx8s0l530z5j7c6bx74v08b4";
    };

    propagatedBuildInputs = with self; [ termstyle colorama ];
    buildInputs = with self; [ mock ];

    meta = {
      description = "Python test runner";
      homepage = "https://github.com/CleanCut/green";
      license = licenses.mit;
    };
  };

  topydo = throw "python3Packages.topydo was moved to topydo"; # 2017-09-22

  w3lib = buildPythonPackage rec {
    name = "w3lib-${version}";
    version = "1.17.0";

    buildInputs = with self ; [ six pytest ];

    src = pkgs.fetchurl {
      url = "mirror://pypi/w/w3lib/${name}.tar.gz";
      sha256 = "0vshh300ay5wn5hwl9qcb32m71pz5s6miy0if56vm4nggy159inq";
    };

    meta = {
      description = "A library of web-related functions";
      homepage = "https://github.com/scrapy/w3lib";
      license = licenses.bsd3;
      maintainers = with maintainers; [ drewkett ];
    };
  };

  Quandl = buildPythonPackage rec {
    version = "3.0.0";
    name = "Quandl-${version}";

    src = pkgs.fetchurl {
      url= "mirror://pypi/q/quandl/${name}.tar.gz";
      sha256 = "d4e698eb39291e0b281975813054101f3dfb379dead10d34d7b536e1aad60584";
    };

    propagatedBuildInputs = with self; [
      numpy
      ndg-httpsclient
      dateutil
      inflection
      more-itertools
      requests
      pandas
    ];

    # No tests in archive
    doCheck = false;

    meta = {
      homepage = https://github.com/quandl/quandl-python;
      description = "A Python library for Quandl’s RESTful API";
      maintainers = with maintainers; [ NikolaMandic ];
    };
  };

  queuelib = buildPythonPackage rec {
    name = "queuelib-${version}";
    version = "1.4.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/q/queuelib/${name}.tar.gz";
      sha256 = "a6829918157ed433fafa87b0bb1e93e3e63c885270166db5884a02c34c86f914";
    };

    buildInputs = with self ; [ pytest ];

    meta = {
      description = "A collection of persistent (disk-based) queues for Python";
      homepage = "https://github.com/scrapy/queuelib";
      license = licenses.bsd3;
      maintainers = with maintainers; [ drewkett ];
    };
  };

  scrapy = callPackage ../development/python-modules/scrapy { };

  pandocfilters = buildPythonPackage rec{
    version = "1.4.1";
    pname = "pandocfilters";
    name = pname + "-${version}";

    src = fetchPypi{
      inherit pname version;
      sha256 = "ec8bcd100d081db092c57f93462b1861bcfa1286ef126f34da5cb1d969538acd";
    };
    # No tests available
    doCheck = false;

    meta = {
      description = "A python module for writing pandoc filters, with a collection of examples";
      homepage = https://github.com/jgm/pandocfilters;
      license = licenses.mit;
      maintainers = with maintainers; [];
    };
  };

  htmltreediff = buildPythonPackage rec{
    version = "0.1.2";
    pname = "htmltreediff";
    name = pname + "-${version}";

    # Does not work with Py >= 3
    disabled = !isPy27;

    src = pkgs.fetchFromGitHub {
      owner = "christian-oudard";
      repo = pname;
      rev = "v" + version;
      sha256 = "16mqp2jyznrw1mgd3qzybq28h2k5wz7vmmz1m6xpgscazyjhvvd1";
    };

    propagatedBuildInputs = with self; [ lxml html5lib ];

    meta = {
      description = " Structure-aware diff for html and xml documents";
      homepage = https://github.com/christian-oudard/htmltreediff;
      license = licenses.bsdOriginal;
      maintainers = with maintainers; [];
    };
  };

  repeated_test = buildPythonPackage rec {
    name = "repeated_test-${version}";
    version = "0.1a3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/r/repeated-test/${name}.tar.gz";
      sha256 = "062syp7kl2g0x6qx3z8zb5sdycpi7qcpxp9iml2v8dqzqnij9bpg";
    };

    buildInputs = with self; [
      unittest2
    ];
    propagatedBuildInputs = with self; [
      six
    ];

    meta = {
      description = "A quick unittest-compatible framework for repeating a test function over many fixtures";
      homepage = "https://github.com/epsy/repeated_test";
      license = licenses.mit;
    };
  };

  Keras = callPackage ../development/python-modules/keras { };

  Lasagne = buildPythonPackage rec {
    name = "Lasagne-${version}";
    version = "0.1";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://pypi/l/lasagne/${name}.tar.gz";
      sha256 = "0cqj86rdm6c7y5vq3i13qy76fg5xi3yjp4r0hpqy8hvynv54wqrw";
    };

    propagatedBuildInputs = with self; [
      numpy
      Theano
    ];

    # there are no tests
    doCheck = false;

    meta = {
      description = "Lightweight library to build and train neural networks in Theano";
      homepage = "https://github.com/Lasagne/Lasagne";
      maintainers = with maintainers; [ NikolaMandic ];
      license = licenses.mit;
    };
  };

  send2trash = buildPythonPackage (rec {
    name = "Send2Trash-1.3.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/S/Send2Trash/${name}.tar.gz";
      sha256 = "1zjq5ki02l0vl4f1xymsnqyxipx6q81a435p46db07l3mqg4dx1k";
    };

    # no tests
    doCheck = false;

    meta = {
      description = "Send file to trash natively under macOS, Windows and Linux";
      homepage = https://github.com/hsoft/send2trash;
      license = licenses.bsd3;
    };
  });

  sigtools = buildPythonPackage rec {
    name = "sigtools-${version}";
    version = "1.1a3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/sigtools/${name}.tar.gz";
      sha256 = "190w14vzbiyvxcl9jmyyimpahar5b0bq69v9iv7chi852yi71w6w";
    };

    buildInputs = with self; [
      repeated_test
      sphinx
      mock
      coverage
      unittest2
    ];
    propagatedBuildInputs = with self; [
      funcsigs
      six
    ];

    patchPhase = ''sed -i s/test_suite="'"sigtools.tests"'"/test_suite="'"unittest2.collector"'"/ setup.py'';

    meta = {
      description = "Utilities for working with 3.3's inspect.Signature objects.";
      homepage = "https://pypi.python.org/pypi/sigtools";
      license = licenses.mit;
    };
  };

  clize = buildPythonPackage rec {
    name = "clize-${version}";
    version = "3.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/c/clize/${name}.tar.gz";
      sha256 = "1xkr3h404d7pgj5gdpg6bddv3v3yq2hgx8qlwkgw5abg218k53hm";
    };

    buildInputs = with self; [
      dateutil
    ];
    propagatedBuildInputs = with self; [
      sigtools
    ];

    meta = {
      description = "Command-line argument parsing for Python";
      homepage = "https://github.com/epsy/clize";
      license = licenses.mit;
    };
  };

  zerobin = buildPythonPackage rec {
    name = "zerobin-${version}";
    version = "20160108";

    src = pkgs.fetchFromGitHub {
      owner = "sametmax";
      repo = "0bin";
      rev = "7da1615";
      sha256 = "1pzcwy454kn5216pvwjqzz311s6jbh7viw9s6kw4xps6f5h44bid";
    };

    propagatedBuildInputs = with self; [
      cherrypy
      bottle
      lockfile
      clize
    ];
    # zerobin doesn't have any tests, but includes a copy of cherrypy which
    # can wrongly fail the check phase.
    doCheck = false;
    meta = {
      description = "A client side encrypted pastebin";
      homepage = "http://0bin.net/";
      license = licenses.wtfpl;
    };
  };

  tensorflow-tensorboard = callPackage ../development/python-modules/tensorflow-tensorboard { };

  tensorflow = callPackage ../development/python-modules/tensorflow rec {
    bazel = pkgs.bazel_0_4;
    cudaSupport = pkgs.config.cudaSupport or false;
    inherit (pkgs.linuxPackages) nvidia_x11;
    cudatoolkit = pkgs.cudatoolkit8;
    cudnn = pkgs.cudnn6_cudatoolkit8;
  };

  tensorflowWithoutCuda = self.tensorflow.override {
    cudaSupport = false;
  };

  tensorflowWithCuda = self.tensorflow.override {
    cudaSupport = true;
  };

  tflearn = buildPythonPackage rec {
    name = "tflearn-0.2.1";

    meta = {
      description = "Deep learning library featuring a higher-level API for TensorFlow";
      homepage    = "https://github.com/tflearn/tflearn";
      license     = licenses.mit;
    };

    propagatedBuildInputs = with self; [ scipy h5py pillow tensorflow ];

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/tflearn/${name}.tar.gz";
      sha256 = "1n884c4j35409id2bncyj5fvmmfpdqj3pk6wrv0s1znnvs0lkii0";
    };
  };

  simpleai = buildPythonPackage rec {
     version = "0.7.11";
     name = "simpleai-${version}";

     src = pkgs.fetchurl {
       url= "https://pypi.python.org/packages/source/s/simpleai/${name}.tar.gz";
       sha256 = "03frjc5jxsz9xm24jz7qa4hcp0dicgazrxkdsa2rsnir672lwkwz";
     };

     propagatedBuildInputs = with self; [ numpy ];

     disabled = isPy3k;

     #No tests in archive
     doCheck = false;

     meta = {
       homepage = https://github.com/simpleai-team/simpleai;
       description = "This lib implements many of the artificial intelligence algorithms described on the book 'Artificial Intelligence, a Modern Approach'";
       maintainers = with maintainers; [ NikolaMandic ];
     };
  };

  word2vec = buildPythonPackage rec {
    name = "word2vec-${version}";
    version = "0.9.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/w/word2vec/${name}.tar.gz";
      sha256 = "a811e3e98a8e6dfe7bc851ebbbc2d6e5ab5142f2a134dd3c03daac997b546faa";
    };

    propagatedBuildInputs = with self; [ cython numpy ];

    checkPhase = ''
     cd word2vec/tests;
      ${python.interpreter} test_word2vec.py
    '';

    meta = {
      description = "Tool for computing continuous distributed representations of words";
      homepage = "https://github.com/danielfrg/word2vec";
      license     = licenses.asl20;
      maintainers = with maintainers; [ NikolaMandic ];
    };
  };

  tvdb_api = buildPythonPackage rec {
    name = "tvdb_api-${version}";
    version = "1.10";

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/tvdb_api/${name}.tar.gz";
      sha256 = "0hq887yb3rwc0rcw32lh7xdkk9bbrqy274aspzqkd6f7dyhp73ih";
    };

    propagatedBuildInputs = with self; [ requests-cache ];

    meta = {
      description = "Simple to use TVDB (thetvdb.com) API in Python.";
      homepage = "https://github.com/dbr/tvdb_api";
      license = licenses.unlicense;
      maintainers = with maintainers; [ peterhoeg ];
    };
  };

  tvnamer = buildPythonPackage rec {
    name = "tvnamer-${version}";
    version = "2.4";

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/tvnamer/${name}.tar.gz";
      sha256 = "10iizmwna2xpyc2694hsrvny68y3bdq576p8kxsvg5gj2spnsxav";
    };

    buildInputs = with self; [ pytest ];
    propagatedBuildInputs = with self; [ tvdb_api ];

    # a ton of tests fail with: IOError: tvnamer/main.py could not be found in . or ..
    doCheck = false;

    meta = {
      description = "Automatic TV episode file renamer, uses data from thetvdb.com via tvdb_api.";
      homepage = "https://github.com/dbr/tvnamer";
      license = licenses.unlicense;
      maintainers = with maintainers; [ peterhoeg ];
    };
  };

  pybrain = buildPythonPackage rec {
    name = "pybrain-${version}";
    version = "0.3.3";

    src = pkgs.fetchurl {
      url = "https://github.com/pybrain/pybrain/archive/${version}.tar.gz";
      sha256 = "114m99vsrps2gjqfm3i3kxx4nibjhjdzphsy2bhrxa5q3h2q14dz";
    };

    propagatedBuildInputs = with self; [ scipy ];

    meta = {
      homepage = "http://pybrain.org/";
      description = "Modular Machine Learning Library for Python";
      license = licenses.bsd3;
      maintainers = with maintainers; [ NikolaMandic ];
      broken = true; # See https://github.com/NixOS/nixpkgs/pull/29198
    };
  };

  threadpool = buildPythonPackage rec {
    name = "threadpool-${version}";
    version = "1.3.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/threadpool/${name}.tar.bz2";
      sha256 = "197gzrxn9lbk0q1v079814c6s05cr4rwzyl6c1m6inkyif4yzr6c";
    };
  };

  rocket-errbot = buildPythonPackage rec {
    name = "rocket-errbot-${version}";
    version = "1.2.5";

    src = pkgs.fetchurl {
      url = "mirror://pypi/r/rocket-errbot/${name}.tar.gz";
      sha256 = "181y1wqjvlry5xdzbliajvrxvswzh3myh795jnj1pm92r5grqzda";
    };
  };

  Yapsy = buildPythonPackage rec {
    name = "Yapsy-${version}";
    version = "1.11.223";

    src = pkgs.fetchurl {
      url = "mirror://pypi/y/yapsy/${name}.tar.gz";
      sha256 = "19pjsnqizswnczhlav4lb7zlzs0n73ijrsgksy4374b14jkkkfs5";
    };

    doCheck = false;
  };

  ansi = buildPythonPackage rec {
    name = "ansi-${version}";
    version = "0.1.3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/a/ansi/${name}.tar.gz";
      sha256 = "06y6470bzvlqys3zi2vc68rmk9n05v1ibral14gbfpgfa8fzy7pg";
    };
  };

  pygments-markdown-lexer = buildPythonPackage rec {
    name = "pygments-markdown-lexer-${version}";
    version = "0.1.0.dev39";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pygments-markdown-lexer/${name}.zip";
      sha256 = "1pzb5wy23q3fhs0rqzasjnw6hdzwjngpakb73i98cn0b8lk8q4jc";
    };

    doCheck = false;

    propagatedBuildInputs = with self; [ pygments ];
  };

  telegram = buildPythonPackage rec {
    name = "telegram-${version}";
    version = "0.0.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/t/telegram/${name}.tar.gz";
      sha256 = "1495l2ml8mg120wfvqhikqkfczhwwaby40vdmsz8v2l69jps01fl";
    };
  };

  irc = buildPythonPackage rec {
    name = "irc-${version}";
    version = "14.2.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/i/irc/${name}.tar.gz";
      sha256 = "0a6qjl4fjj98wxc8gaf5rxg94v7a0ydjdiw6pcka5fy814xl2i28";
    };

    doCheck = false;

    buildInputs = with self; [ setuptools_scm ];

    propagatedBuildInputs = with self; [
      six jaraco_logging jaraco_text jaraco_stream jaraco_stream pytz
      jaraco_itertools
    ];
  };

  jaraco_logging = buildPythonPackage rec {
    name = "jaraco.logging-${version}";
    version = "1.5";

    src = pkgs.fetchurl {
      url = "mirror://pypi/j/jaraco.logging/${name}.tar.gz";
      sha256 = "1lvw9zphiymiiar47kd0x0dbc9x2jks8w1kirg3ff8nd80k95j05";
    };

    doCheck = false;

    buildInputs = with self; [ setuptools_scm ];

    propagatedBuildInputs = with self; [ tempora six ];
  };

  jaraco_text = buildPythonPackage rec {
    name = "jaraco.text-${version}";
    version = "1.7";

    src = pkgs.fetchurl {
      url = "mirror://pypi/j/jaraco.text/${name}.tar.gz";
      sha256 = "07ccc0zc28sb1kyfyviw3n8f581qynrshqvqg1xsp4gkf1m2ibhh";
    };

    doCheck = false;

    buildInputs = with self; [ setuptools_scm ];

    propagatedBuildInputs = with self; [ jaraco_functools jaraco_collections ];
  };

  jaraco_collections = buildPythonPackage rec {
    name = "jaraco.collections-${version}";
    version = "1.3.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/j/jaraco.collections/${name}.tar.gz";
      sha256 = "0mvyn9d4bs5zw9z84wwsbgff6s28vg6h4i8qhyb667fqi7xgr1w5";
    };

    doCheck = false;

    buildInputs = with self; [ setuptools_scm ];

    propagatedBuildInputs = with self; [ six jaraco_classes ];

    # break dependency cycle
    patchPhase = ''
      sed -i "/'jaraco.text',/d" setup.py
    '';
  };

  jaraco_itertools = buildPythonPackage rec {
    name = "jaraco.itertools-${version}";
    version = "1.7.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/j/jaraco.itertools/${name}.tar.gz";
      sha256 = "0yvxp5nwhy4wc4naq5v152vbnxqcn5k031g089chq2lk5kr7np5z";
    };

    doCheck = false;

    buildInputs = with self; [ setuptools_scm ];

    propagatedBuildInputs = with self; [ inflect more-itertools six ];
  };

  inflect = buildPythonPackage rec {
    name = "inflect-${version}";
    version = "0.2.5";

    src = pkgs.fetchurl {
      url = "mirror://pypi/i/inflect/${name}.tar.gz";
      sha256 = "065866j9msrivbr74yrag53ch0lav7xz18qvjkiblkhinbfch510";
    };
  };

  moreItertools = self.more-itertools;

  more-itertools = buildPythonPackage rec {
    name = "more-itertools-${version}";
    version = "2.4.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/m/more-itertools/${name}.tar.gz";
      sha256 = "95a222d01df60c888d56d86f91219bfbd47106a534e89ca7f80fb555cfbe08c1";
    };

    buildInputs = with self; [ nose ];
    propagatedBuildInputs = with self; [ six ];

    meta = {
      homepage = https://more-itertools.readthedocs.org;
      description = "Expansion of the itertools module";
      license = licenses.mit;
    };
  };

  jaraco_functools = buildPythonPackage rec {
    name = "jaraco.functools-${version}";
    version = "1.15.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/j/jaraco.functools/${name}.tar.gz";
      sha256 = "1nhl0pjc7acxznhadg9wq1a6ls17ja2np8vf9psq8j66716mk2ya";
    };

    propagatedBuildInputs = with self; [ more-itertools backports_functools_lru_cache ];

    doCheck = false;

    buildInputs = with self; [ setuptools_scm ];
  };

  jaraco_classes = buildPythonPackage rec {
    name = "jaraco.classes-${version}";
    version = "1.4";

    src = pkgs.fetchurl {
      url = "mirror://pypi/j/jaraco.classes/${name}.tar.gz";
      sha256 = "1yn1wa6m5rdhk4grmnycx3i5pzzdlwfx83h944c9g5rqggmg612h";
    };

    doCheck = false;

    buildInputs = with self; [ setuptools_scm ];
  };

  jaraco_stream = buildPythonPackage rec {
    name = "jaraco.stream-${version}";
    version = "1.1.1";

    src = pkgs.fetchurl {
      url = "mirror://pypi/j/jaraco.stream/${name}.tar.gz";
      sha256 = "0iwg5ljc2z8wwyl2wv7lldwviwd0q4rsccascyqvqqs0l2rcn4gi";
    };

    doCheck = false;

    buildInputs = with self; [ setuptools_scm ];

    propagatedBuildInputs = with self; [ six ];
  };

  slackclient = buildPythonPackage rec {
    name = "slackclient-${version}";
    version = "1.0.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/s/slackclient/${name}.tar.gz";
      sha256 = "063cbzp1fbdipv53gb0hnban1pg80pls0lbld98lhnykzkcb6vf0";
    };

    propagatedBuildInputs = with self; [ websocket_client requests ];
  };

  tempora= callPackage ../development/python-modules/tempora { };

  hypchat = callPackage ../development/python-modules/hypchat { };

  pivy = buildPythonPackage rec {
    version = "20101207";
    name = "pivy-${version}";
    src = pkgs.fetchhg {
      url = "https://bitbucket.org/Coin3D/pivy";
      rev = "8eab90908f2a3adcc414347566f4434636202344";
      sha256 = "18n14ha2d3j3ghg2f2aqnf2mks94nn7ma9ii7vkiwcay93zm82cf";
    };
    disabled = isPy3k; # Judging from SyntaxError
    buildInputs = with self; [ pkgs.swig1 pkgs.coin3d pkgs.soqt pkgs.mesa pkgs.xorg.libXi ];
  };

  smugpy = callPackage ../development/python-modules/smugpy { };

  smugline = stdenv.mkDerivation rec {
    name    = pname + "-" + version;
    pname   = "smugline";
    version = "20160106";

    src = pkgs.fetchFromGitHub {
      owner  = "gingerlime";
      repo   = pname;
      rev    = "134554c574c2d282112ba60165a8c5ffe0f16fd4";
      sha256 = "00n012ijkdrx8wsl8x3ghdcxcdp29s4kwr3yxvlyj79g5yhfvaj6";
    };

    phases = [ "unpackPhase" "installPhase" ];

    buildInputs = [ python pkgs.makeWrapper ];

    propagatedBuildInputs = with self; [ docopt requests smugpy ];

    installPhase = ''
      mkdir -p $out/bin $out/libexec
      cp smugline.py $out/libexec
      makeWrapper ${python.interpreter} $out/bin/smugline \
        --add-flags "$out/libexec/smugline.py" \
        --prefix PYTHONPATH : "$PYTHONPATH"
    '';
  };

  txaio = callPackage ../development/python-modules/txaio { };

  ramlfications = callPackage ../development/python-modules/ramlfications { };

  yapf = callPackage ../development/python-modules/yapf { };

  autobahn = callPackage ../development/python-modules/autobahn { };

  jsonref = callPackage ../development/python-modules/jsonref { };

  whoosh = callPackage ../development/python-modules/whoosh { };

  packet-python = buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "packet-python";
    version = "1.33";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/eb/82/f0506bd964501f958ac6a37e843ccb7bd9e712732886258314d55f0ec710/packet-python-1.33.tar.gz";
      sha256 = "0bmvfmvjm8jx0y8sv0jf5mhv0h3v8idx0sc5myxs7ig200584dd3";
    };
    propagatedBuildInputs = with self; [ requests ];

    meta = {
      description = "A Python client for the Packet API.";
      homepage    = "https://github.com/packethost/packet-python";
      license     = licenses.lgpl3;
      maintainers = with maintainers; [ dipinhora ];
      platforms   = platforms.all;
    };
  };

  pwntools = callPackage ../development/python-modules/pwntools { };

  ROPGadget = callPackage ../development/python-modules/ROPGadget { };

  # We need "normal" libxml2 and not the python package by the same name.
  pywbem = if !(isPy36)
    then callPackage ../development/python-modules/pywbem { libxml2 = pkgs.libxml2; }
    else throw "pywbem not supported for interpreter ${python.executable}";

  unicorn = callPackage ../development/python-modules/unicorn { };

  intervaltree = callPackage ../development/python-modules/intervaltree { };

  packaging = callPackage ../development/python-modules/packaging { };

  pytoml = callPackage ../development/python-modules/pytoml { };

  pypandoc = callPackage ../development/python-modules/pypandoc { };

  yamllint = callPackage ../development/python-modules/yamllint { };

  yarl = callPackage ../development/python-modules/yarl { };

  suseapi = buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "suseapi";
    version = "0.24-5-g9937e3b";

    src = pkgs.fetchFromGitHub {
      owner = "openSUSE";
      repo = "python-${pname}";
      rev = version;
      sha256 = "1144h26wrzazzy6y3yy163fccqmggk5hazjkk8l9a547390ilgrv";
    };

    propagatedBuildInputs = with self; [
      django suds-jurko ldap mechanize beautifulsoup4 pyxdg dateutil requests
    ];

    meta = {
      homepage = "https://github.com/openSUSE/python-suseapi/";
      description = "Python module to work with various SUSE services";
      license = licenses.gpl3Plus;
    };
  };

  typed-ast = callPackage ../development/python-modules/typed-ast { };

  stripe = callPackage ../development/python-modules/stripe { };

  twilio = callPackage ../development/python-modules/twilio { };

  uranium = callPackage ../development/python-modules/uranium {
    # https://github.com/Ultimaker/Cura/issues/2596
    pyqt5 = self.pyqt56;
  };

  vine = callPackage ../development/python-modules/vine { };

  wp_export_parser = buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "wp_export_parser";
    version = "1.0";
    src = pkgs.fetchFromGitHub {
      owner = "RealGeeks";
      repo = "wp_export_parser";
      rev = "479211f6c5a7d034fd77762dfed381c3315cd773";
      sha256 = "1ad0mkixc0s86djwsvhp1qlvcfs25086nh0qw7bys49gz8shczzi";
    };
  };

  yowsup = callPackage ../development/python-modules/yowsup { };

  wptserve = callPackage ../development/python-modules/wptserve { };

  yenc = callPackage ../development/python-modules/yenc { };

  zeep = callPackage ../development/python-modules/zeep { };

  zeitgeist = if isPy3k then throw "zeitgeist not supported for interpreter ${python.executable}" else
    (pkgs.zeitgeist.override{python2Packages=self;}).py;

  zeroconf = callPackage ../development/python-modules/zeroconf { };

  zipfile36 = callPackage ../development/python-modules/zipfile36 { };

  todoist = callPackage ../development/python-modules/todoist { };

  zxcvbn-python = callPackage ../development/python-modules/zxcvbn-python { };

  incremental = callPackage ../development/python-modules/incremental { };

  treq = callPackage ../development/python-modules/treq { };

  snakeviz = callPackage ../development/python-modules/snakeviz { };

  nitpick = callPackage ../applications/version-management/nitpick { };

  pluginbase = callPackage ../development/python-modules/pluginbase { };

  node-semver = callPackage ../development/python-modules/node-semver { };

  distro = callPackage ../development/python-modules/distro { };

  bz2file =  callPackage ../development/python-modules/bz2file { };

  smart_open =  callPackage ../development/python-modules/smart_open { };

  gensim = callPackage  ../development/python-modules/gensim { };

  cymem = callPackage ../development/python-modules/cymem { };

  ftfy = callPackage ../development/python-modules/ftfy { };

  murmurhash = callPackage ../development/python-modules/murmurhash { };

  plac = callPackage ../development/python-modules/plac { };

  preshed = callPackage ../development/python-modules/preshed { };

  backports_weakref = callPackage ../development/python-modules/backports_weakref { };

  thinc = callPackage ../development/python-modules/thinc { };

  spacy = callPackage ../development/python-modules/spacy { };

  spacy_models = callPackage ../development/python-modules/spacy/models.nix { };

  textacy = callPackage ../development/python-modules/textacy { };

  pyemd  = callPackage ../development/python-modules/pyemd { };

  behave = callPackage ../development/python-modules/behave { };

  pyhamcrest = callPackage ../development/python-modules/pyhamcrest { };

  parse = callPackage ../development/python-modules/parse { };

  parse-type = callPackage ../development/python-modules/parse-type { };

  ephem = callPackage ../development/python-modules/ephem { };
});

in fix' (extends overrides packages)
