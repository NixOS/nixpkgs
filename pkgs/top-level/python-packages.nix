{ pkgs, stdenv, python, self }:

with pkgs.lib;

let
  pythonAtLeast = versionAtLeast python.pythonVersion;
  pythonOlder = versionOlder python.pythonVersion;
  isPy26 = python.majorVersion == "2.6";
  isPy27 = python.majorVersion == "2.7";
  isPy33 = python.majorVersion == "3.3";
  isPy34 = python.majorVersion == "3.4";
  isPy35 = python.majorVersion == "3.5";
  isPyPy = python.executable == "pypy";
  isPy3k = strings.substring 0 1 python.majorVersion == "3";

  callPackage = pkgs.newScope self;

  buildPythonPackage = makeOverridable (callPackage ../development/python-modules/generic {
    bootstrapped-pip = callPackage ../development/python-modules/bootstrapped-pip { };
  });

  buildPythonApplication = args: buildPythonPackage ({namePrefix="";} // args );

  # Unique python version identifier
  pythonName =
    if isPy26 then "python26" else
    if isPy27 then "python27" else
    if isPy33 then "python33" else
    if isPy34 then "python34" else
    if isPy35 then "python35" else
    if isPyPy then "pypy" else "";

  modules = python.modules or {
    readline = null;
    sqlite3 = null;
    curses = null;
    curses_panel = null;
    crypt = null;
  };

in modules // {

  inherit python isPy26 isPy27 isPy33 isPy34 isPy35 isPyPy isPy3k pythonName buildPythonPackage buildPythonApplication;

  # helpers

  wrapPython = pkgs.makeSetupHook
    { deps = pkgs.makeWrapper;
      substitutions.libPrefix = python.libPrefix;
      substitutions.executable = python.interpreter;
      substitutions.magicalSedExpression = let
        # Looks weird? Of course, it's between single quoted shell strings.
        # NOTE: Order DOES matter here, so single character quotes need to be
        #       at the last position.
        quoteVariants = [ "'\"'''\"'" "\"\"\"" "\"" "'\"'\"'" ]; # hey Vim: ''

        mkStringSkipper = labelNum: quote: let
          label = "q${toString labelNum}";
          isSingle = elem quote [ "\"" "'\"'\"'" ];
          endQuote = if isSingle then "[^\\\\]${quote}" else quote;
        in ''
          /^ *[a-z]?${quote}/ {
            /${quote}${quote}|${quote}.*${endQuote}/{n;br}
            :${label}; n; /^${quote}/{n;br}; /${endQuote}/{n;br}; b${label}
          }
        '';

      in ''
        1 {
          /^#!/!b; :r
          /\\$/{N;br}
          /__future__|^ *(#.*)?$/{n;br}
          ${concatImapStrings mkStringSkipper quoteVariants}
          /^ *[^# ]/i import sys; sys.argv[0] = '"'$(basename "$f")'"'
        }
      '';
    }
   ../development/python-modules/generic/wrap.sh;

  # specials

  recursivePthLoader = callPackage ../development/python-modules/recursive-pth-loader { };

  setuptools = callPackage ../development/python-modules/setuptools { };

  # packages defined elsewhere

  blivet = callPackage ../development/python-modules/blivet { };

  dbus = callPackage ../development/python-modules/dbus {
    dbus = pkgs.dbus;
  };

  discid = buildPythonPackage rec {
    name = "discid-1.1.0";

    meta = {
      description = "Python binding of libdiscid";
      homepage    = "https://python-discid.readthedocs.org/";
      license     = licenses.lgpl3Plus;
      platforms   = platforms.linux;
    };

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/discid/${name}.tar.gz";
      sha256 = "b39d443051b26d0230be7a6c616243daae93337a8711dd5d4119bb6a0e516fa8";
    };

    patchPhase = ''
      substituteInPlace discid/libdiscid.py \
        --replace '_open_library(_LIB_NAME)' "_open_library('${pkgs.libdiscid}/lib/libdiscid.so.0')"
    '';
  };

  h5py = callPackage ../development/python-modules/h5py {
    hdf5 = pkgs.hdf5.override { mpi = null; };
  };

  h5py-mpi = self.h5py.override {
    mpiSupport = true;
    mpi = pkgs.openmpi;
    hdf5 = pkgs.hdf5.override { mpi = pkgs.openmpi; enableShared = true; };
  };

  mpi4py = callPackage ../development/python-modules/mpi4py {
    mpi = pkgs.openmpi;
  };

  nixpart = callPackage ../tools/filesystems/nixpart { };

  # This is used for NixOps to make sure we won't break it with the next major
  # version of nixpart.
  nixpart0 = callPackage ../tools/filesystems/nixpart/0.4 { };

  pitz = callPackage ../applications/misc/pitz { };

  plantuml = callPackage ../tools/misc/plantuml { };

  pycairo = callPackage ../development/python-modules/pycairo {
  };

  pycangjie = if isPy3k then callPackage ../development/python-modules/pycangjie { } else throw "pycangjie not supported for interpreter ${python.executable}";

  pycrypto = callPackage ../development/python-modules/pycrypto { };

  pygame = callPackage ../development/python-modules/pygame { };

  pygobject = callPackage ../development/python-modules/pygobject { };

  pygobject3 = callPackage ../development/python-modules/pygobject/3.nix { };

  pygtk = callPackage ../development/python-modules/pygtk { libglade = null; };

  pygtksourceview = callPackage ../development/python-modules/pygtksourceview { };

  pyGtkGlade = self.pygtk.override {
    libglade = pkgs.gnome.libglade;
  };

  pyqt4 = callPackage ../development/python-modules/pyqt/4.x.nix {
    pythonDBus = self.dbus;
    pythonPackages = self;
  };

  pyqt5 = callPackage ../development/python-modules/pyqt/5.x.nix {
    sip = self.sip_4_16;
    pythonDBus = self.dbus;
    inherit (pkgs.qt55) qtbase qtsvg qtwebkit;
  };

  pyside = callPackage ../development/python-modules/pyside { };

  pysideApiextractor = callPackage ../development/python-modules/pyside/apiextractor.nix { };

  pysideGeneratorrunner = callPackage ../development/python-modules/pyside/generatorrunner.nix { };

  pysideShiboken = callPackage ../development/python-modules/pyside/shiboken.nix { };

  pysideTools = callPackage ../development/python-modules/pyside/tools.nix { };

  pyxml = if !isPy3k then callPackage ../development/python-modules/pyxml{ } else throw "pyxml not supported for interpreter ${python.executable}";

  sip = callPackage ../development/python-modules/sip { };

  sip_4_16 = callPackage ../development/python-modules/sip/4.16.nix { };

  tables = callPackage ../development/python-modules/tables {
    hdf5 = pkgs.hdf5.override { zlib = pkgs.zlib; };
  };

  # packages defined here

  aafigure = buildPythonPackage rec {
    name = "aafigure-0.5";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/a/aafigure/${name}.tar.gz";
      sha256 = "090c88beb091d28a233f854e239713aa15d8d1906ea16211855345c912e8a091";
    };

    propagatedBuildInputs = with self; [ pillow ];

    # error: invalid command 'test'
    doCheck = false;

    # Fix impurity. TODO: Do the font lookup using fontconfig instead of this
    # manual method. Until that is fixed, we get this whenever we run aafigure:
    #   WARNING: font not found, using PIL default font
    patchPhase = ''
      sed -i "s|/usr/share/fonts|/nonexisting-fonts-path|" aafigure/PILhelper.py
    '';

    meta = {
      description = "ASCII art to image converter";
      homepage = https://launchpad.net/aafigure/;
      license = licenses.bsd2;
      platforms = platforms.linux;
      maintainers = with maintainers; [ bjornfor ];
    };
  };

  acd_cli = buildPythonPackage rec {
    name = pname + "-" + version;
    pname = "acd_cli";
    version = "0.3.1";

    disabled = !isPy33;
    doCheck = !isPy33;

    src = pkgs.fetchFromGitHub {
      owner = "yadayada";
      repo = pname;
      rev = version;
      sha256 = "1ywimbisgb5g7xl9nrfwcm7dv3j8fsrjfp7bxb3l58zbsrzj6z2s";
    };

    propagatedBuildInputs = with self; [ appdirs colorama dateutil requests2 requests_toolbelt sqlalchemy7 ];

    makeWrapperArgs = [ "--prefix LIBFUSE_PATH : ${pkgs.fuse}/lib/libfuse.so" ];

    meta = {
      description = "A command line interface and FUSE filesystem for Amazon Cloud Drive";
      homepage = https://github.com/yadayada/acd_cli;
      license = licenses.gpl2;
      platforms = platforms.linux;
      maintainers = with maintainers; [ edwtjo ];
    };
  };

  acme_0_1_0 = buildPythonPackage rec {
    version = "0.1.0";
    name = "acme-${version}";

    src = pkgs.fetchFromGitHub {
      owner = "letsencrypt";
      repo = "letsencrypt";
      rev = "v${version}";
      sha256 = "1f7406nnybsdbwxf7r9qjf6hzkfd7cg6qp8l9l7hrzwscsq5hicj";
    };

    propagatedBuildInputs = with self; [
      cryptography pyasn1 pyopenssl pyRFC3339 pytz requests2 six werkzeug mock
      ndg-httpsclient
    ];

    buildInputs = with self; [ nose ];

    sourceRoot = "letsencrypt-v${version}-src/acme";
  };

  acme = buildPythonPackage rec {
    inherit (pkgs.letsencrypt) src version;

    name = "acme-${version}";

    propagatedBuildInputs = with self; [
      cryptography pyasn1 pyopenssl pyRFC3339 pytz requests2 six werkzeug mock
      ndg-httpsclient
    ];

    buildInputs = with self; [ nose ];

    sourceRoot = "letsencrypt-v${version}-src/acme";
  };

  # Maintained for simp_le compatibility
  acme_0_1 = buildPythonPackage rec {
    version = "0.1.0";

    name = "acme-${version}";

    src = pkgs.fetchFromGitHub {
      owner = "letsencrypt";
      repo = "letsencrypt";
      rev = "v${version}";
      sha256 = "1f7406nnybsdbwxf7r9qjf6hzkfd7cg6qp8l9l7hrzwscsq5hicj";
    };

    propagatedBuildInputs = with self; [
      cryptography pyasn1 pyopenssl pyRFC3339 pytz requests2 six werkzeug mock
      ndg-httpsclient
    ];

    buildInputs = with self; [ nose ];

    sourceRoot = "letsencrypt-v${version}-src/acme";
  };

  acme-tiny = buildPythonPackage rec {
    name = "acme-tiny-${version}";
    version = "20151229";
    rev = "f61f72c212cea27f388eb4a26ede0d65035bdb53";

    src = pkgs.fetchgit {
      inherit rev;
      url = "https://github.com/diafygi/acme-tiny.git";
      sha256 = "dde59354e483bdff3dfd06717c094889ae673efb568e40b150b4695b0c539649";
    };

    # source doesn't have any python "packaging" as such
    configurePhase = " ";
    buildPhase = " ";
    # the tests are... complex
    doCheck = false;

    patchPhase = ''
      substituteInPlace acme_tiny.py --replace "openssl" "${pkgs.openssl}/bin/openssl"
      substituteInPlace letsencrypt/le_util.py --replace '"sw_vers"' '"/usr/bin/sw_vers"'
    '';

    installPhase = ''
      mkdir -p $out/${python.sitePackages}/
      cp acme_tiny.py $out/${python.sitePackages}/
      mkdir -p $out/bin
      ln -s $out/${python.sitePackages}/acme_tiny.py $out/bin/acme_tiny
      chmod +x $out/bin/acme_tiny
    '';

    meta = {
      description = "A tiny script to issue and renew TLS certs from Let's Encrypt";
      homepage = https://github.com/diafygi/acme-tiny;
      license = licenses.mit;
    };
  };

  actdiag = buildPythonPackage rec {
    name = "actdiag-0.5.3";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/a/actdiag/${name}.tar.gz";
      sha256 = "1vr4hnkr0gcvvpaycd8q3vcx029b2f5yv8swhdr8kwspaqb0dvfa";
    };

    buildInputs = with self; [ pep8 nose unittest2 docutils ];

    propagatedBuildInputs = with self; [ blockdiag ];

    # One test fails:
    #   UnicodeEncodeError: 'ascii' codec can't encode character u'\u3042' in position 0: ordinal not in range(128)
    doCheck = false;

    meta = {
      description = "Generate activity-diagram image from spec-text file (similar to Graphviz)";
      homepage = http://blockdiag.com/;
      license = licenses.asl20;
      platforms = platforms.linux;
      maintainers = with maintainers; [ bjornfor ];
    };
  };

  adal = buildPythonPackage rec {
    version = "0.1.0";
    name = "adal-${version}";

    src = pkgs.fetchurl {
      url = https://pypi.python.org/packages/source/a/adal/adal-0.1.0.tar.gz;
      sha256 = "1f32k18ck54adqlgvh6fjhy4yavcyrwy813prjyqppqqq4bn1a09";
    };

    propagatedBuildInputs = with self; [ requests2 pyjwt ];

    meta = {
      description = "Library to make it easy for python application to authenticate to Azure Active Directory (AAD) in order to access AAD protected web resources";
      homepage = https://github.com/AzureAD/azure-activedirectory-library-for-python;
      license = licenses.mit;
      maintainers = with maintainers; [ phreedom ];
    };
  };

  afew = buildPythonPackage rec {
    rev = "3f1e5e93119788984c2193292c988ac81ecb0a45";
    name = "afew-git-2016-01-04";

    src = pkgs.fetchurl {
      url = "https://github.com/teythoon/afew/tarball/${rev}";
      name = "${name}.tar.bz";
      sha256 = "1fi19g2j1qilh7ikp7pzn6sagkn76g740zdxgnsqmmvl2zk2yhrw";
    };

    buildInputs = with self; [ pkgs.dbacl ];

    propagatedBuildInputs = with self; [
      self.notmuch
      self.chardet
    ] ++ optional (!isPy3k) self.subprocess32;

    doCheck = false;

    preConfigure = ''
      substituteInPlace afew/DBACL.py --replace "'dbacl'" "'${pkgs.dbacl}/bin/dbacl'"
    '';

    postInstall = ''
      wrapProgram $out/bin/afew \
        --prefix LD_LIBRARY_PATH : ${pkgs.notmuch}/lib
    '';

    meta = {
      homepage = https://github.com/teythoon/afew;
      description = "An initial tagging script for notmuch mail";
      maintainers = with maintainers; [ garbas ];
    };
  };

  aiodns = buildPythonPackage rec {
    name = "aiodns-${version}";
    version = "1.0.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/a/aiodns/${name}.tar.gz";
      sha256 = "595b78b8d54115d937cf60d778c02dad76b6f789fd527dab308f99e5601e7f3d";
    };

    propagatedBuildInputs = with self; [ pycares ] ++ optional isPy33 asyncio ++ optional (isPy26 || isPy27 || isPyPy) trollius;

    checkPhase = ''
      ${python.interpreter} tests.py
    '';

    # 'Could not contact DNS servers'
    doCheck = false;

    meta = {
      homepage = http://github.com/saghul/aiodns;
      license = licenses.mit;
      description = "Simple DNS resolver for asyncio";
    };
  };

  aiohttp = buildPythonPackage rec {
    name = "aiohttp-${version}";
    version = "0.19.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/a/aiohttp/${name}.tar.gz";
      sha256 = "9bfb173baec179431a1c8f3566185e8ebbd1517cf4450217087d79e26e44c287";
    };

    disabled = pythonOlder "3.4";

    doCheck = false; # Too many tests fail.

    buildInputs = with self; [ pytest gunicorn pytest-raisesregexp ];
    propagatedBuildInputs = with self; [ chardet ];

    meta = {
      description = "http client/server for asyncio";
      license = with licenses; [ asl20 ];
      homepage = https://github.com/KeepSafe/aiohttp/;
    };
  };

  alabaster = buildPythonPackage rec {
    name = "alabaster-0.7.7";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/a/alabaster/${name}.tar.gz";
      sha256 = "f416a84e0d0ddbc288f6b8f2c276d10b40ca1238562cd9ed5a751292ec647b71";
    };

    propagatedBuildInputs = with self; [ pygments ];

    # No tests included
    doCheck = false;

    meta = {
      homepage = https://github.com/bitprophet/alabaster;
      description = "a Sphinx theme";
      license = licenses.bsd3;
    };
  };


  alembic = buildPythonPackage rec {
    name = "alembic-0.8.3";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/a/alembic/${name}.tar.gz";
      sha256 = "1sgwvwylzd5h14130mwr0cbyy0fil0a1bq0d0ki97wqvkic3db7f";
    };

    buildInputs = with self; [ pytest pytestcov mock coverage ];
    propagatedBuildInputs = with self; [ Mako sqlalchemy python-editor ];

    meta = {
      homepage = http://bitbucket.org/zzzeek/alembic;
      description = "A database migration tool for SQLAlchemy";
      license = licenses.mit;
    };
  };

  python-editor = buildPythonPackage rec {
    name = "python-editor-${version}";
    version = "0.4";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/python-editor/${name}.tar.gz";
      sha256 = "1gykxn16anmsbcrwhx3rrhwjif95mmwvq9gjcrr9bbzkdc8sf8a4";
    };

    meta = with stdenv.lib; {
      description = "`python-editor` is a library that provides the `editor` module for programmatically";
      homepage = "https://github.com/fmoo/python-editor";
    };
  };

  python-gnupg = buildPythonPackage rec {
    name    = "python-gnupg-${version}";
    version = "0.3.8";

    src = pkgs.fetchurl {
      url    = "https://pypi.python.org/packages/source/p/python-gnupg/${name}.tar.gz";
      sha256 = "0nkbs9c8f30lra7ca39kg91x8cyxn0jb61vih4qky839gpbwwwiq";
    };

    # Let's make the library default to our gpg binary
    patchPhase = ''
      substituteInPlace gnupg.py \
        --replace "gpgbinary='gpg'" "gpgbinary='${pkgs.gnupg1}/bin/gpg'"
    '';

    meta = {
      description = "A wrapper for the Gnu Privacy Guard";
      homepage    = "https://pypi.python.org/pypi/python-gnupg";
      license     = licenses.bsd3;
      maintainers = with maintainers; [ copumpkin ];
      platforms   = platforms.unix;
    };
  };

  almir = buildPythonPackage rec {
    name = "almir-0.1.8";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/a/almir/${name}.zip";
      sha256 = "5dc0b8a5071f3ff46cd2d92608f567ba446e4c733c063b17d89703caeb9868fe";
    };

    buildInputs = with self; [
      pkgs.which
      self.coverage
      self.mock
      self.tissue
      self.unittest2
      self.webtest
    ];

    propagatedBuildInputs = with self; [
      pkgs.makeWrapper
      pkgs.bacula
      self.colander
      self.deform
      self.deform_bootstrap
      self.docutils
      self.nose
      self.mysql_connector_repackaged
      self.pg8000
      self.pyramid
      self.pyramid_beaker
      self.pyramid_exclog
      self.pyramid_jinja2
      self.pyramid_tm
      self.pytz
      self.sqlalchemy8
      self.transaction
      self.waitress
      self.webhelpers
      self.psycopg2
      (self.zope_sqlalchemy.override rec {propagatedBuildInputs = with self; [ sqlalchemy8 transaction ];})
    ];

    postInstall = ''
      ln -s ${pkgs.bacula}/bin/bconsole $out/bin
    '';

    meta = {
      maintainers = with maintainers; [ iElectric ];
      platforms = platforms.all;
    };
  };


  alot = buildPythonPackage rec {
    rev = "0.3.7";
    name = "alot-${rev}";

    src = pkgs.fetchFromGitHub {
      owner = "pazz";
      repo = "alot";
      inherit rev;
      sha256 = "0sscmmf42gsrjbisi6wm01alzlnq6wqhpwkm8pc557075jfg19il";
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
      ];

    postInstall = ''
      mkdir -p $out/share
      cp -r extra/themes $out/share
      wrapProgram $out/bin/alot \
        --prefix LD_LIBRARY_PATH : ${pkgs.notmuch}/lib:${pkgs.file}/lib:${pkgs.gpgme}/lib
    '';

    meta = {
      homepage = https://github.com/pazz/alot;
      description = "Terminal MUA using notmuch mail";
      maintainers = with maintainers; [ garbas profpatsch ];
    };
  };

  anyjson = buildPythonPackage rec {
    name = "anyjson-0.3.3";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/a/anyjson/${name}.tar.gz";
      sha256 = "37812d863c9ad3e35c0734c42e0bf0320ce8c3bed82cd20ad54cb34d158157ba";
    };

    buildInputs = with self; [ self.nose ];

    meta = {
      homepage = http://pypi.python.org/pypi/anyjson/;
      description = "Wrapper that selects the best available JSON implementation";
    };
  };


  amqp = buildPythonPackage rec {
    name = "amqp-${version}";
    version = "1.4.9";
    disabled = pythonOlder "2.6";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/a/amqp/${name}.tar.gz";
      sha256 = "06n6q0kxhjnbfz3vn8x9yz09lwmn1xi9d6wxp31h5jbks0b4vsid";
    };

    buildInputs = with self; [ mock coverage nose-cover3 unittest2 ];

    meta = {
      homepage = http://github.com/celery/py-amqp;
      description = "Python client for the Advanced Message Queuing Procotol (AMQP). This is a fork of amqplib which is maintained by the Celery project";
      license = licenses.lgpl21;
    };
  };


  amqplib = buildPythonPackage rec {
    name = "amqplib-0.6.1";

    src = pkgs.fetchurl {
      url = "http://py-amqplib.googlecode.com/files/${name}.tgz";
      sha256 = "0f2618b74d95cd360a6d46a309a3fb1c37d881a237e269ac195a69a34e0e2f62";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://code.google.com/p/py-amqplib/;
      description = "Python client for the Advanced Message Queuing Procotol (AMQP)";
    };
  };

  ansible = buildPythonPackage rec {
    version = "1.9.4";
    name = "ansible-${version}";

    src = pkgs.fetchurl {
      url = "https://releases.ansible.com/ansible/${name}.tar.gz";
      sha256 = "1qvgzb66nlyc2ncmgmqhzdk0x0p2px09967p1yypf5czwjn2yb4p";
    };

    prePatch = ''
      sed -i "s,/usr/,$out," lib/ansible/constants.py
    '';

    doCheck = false;
    dontStrip = true;
    dontPatchELF = true;
    dontPatchShebangs = true;
    windowsSupport = true;

    propagatedBuildInputs = with self; [
      paramiko jinja2 pyyaml httplib2 boto six
    ] ++ optional windowsSupport pywinrm;

    meta = {
      homepage = "http://www.ansible.com";
      description = "A simple automation tool";
      license = with licenses; [ gpl3] ;
      maintainers = with maintainers; [ joamaki ];
      platforms = with platforms; linux ++ darwin;
    };
  };

  ansible2 = buildPythonPackage rec {
    version    = "v2.0.0.2";
    name       = "ansible-${version}";

    src = pkgs.fetchurl {
      url    = "http://releases.ansible.com/ansible/ansible-2.0.0.2.tar.gz";
      sha256 = "0a2qgshbpbg2c8rz36jcc5f7zam0j1viqdhc8fqqbarz26chpnr7";
    };

    prePatch = ''
      sed -i "s,/usr/,$out," lib/ansible/constants.py
    '';

    doCheck = false;
    dontStrip = true;
    dontPatchELF = true;
    dontPatchShebangs = true;
    windowsSupport = true;

    propagatedBuildInputs = with self; [
      paramiko jinja2 pyyaml httplib2 boto six
    ] ++ optional windowsSupport pywinrm;

    meta = with stdenv.lib; {
      homepage    = "http://www.ansible.com";
      description = "A simple automation tool";
      license     = with licenses; [ gpl3 ];
      maintainers = with maintainers; [ copumpkin ];
      platforms   = with platforms; linux ++ darwin;
    };
  };

  apipkg = buildPythonPackage rec {
    name = "apipkg-1.4";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/a/apipkg/${name}.tar.gz";
      sha256 = "2e38399dbe842891fe85392601aab8f40a8f4cc5a9053c326de35a1cc0297ac6";
    };

    buildInputs = with self; [ pytest ];

    meta = {
      description = "namespace control and lazy-import mechanism";
      homepage = "http://bitbucket.org/hpk42/apipkg";
      license = licenses.mit;
    };
  };

  appdirs = buildPythonPackage rec {
    name = "appdirs-1.4.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/a/appdirs/appdirs-1.4.0.tar.gz";
      sha256 = "8fc245efb4387a4e3e0ac8ebcc704582df7d72ff6a42a53f5600bbb18fdaadc5";
    };

    meta = {
      description = "A python module for determining appropriate platform-specific dirs";
      homepage = http://github.com/ActiveState/appdirs;
      license = licenses.mit;
    };
  };

  application = buildPythonPackage rec {
    name = "python-application-${version}";
    version = "1.5.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/python-application/${name}.tar.gz";
      sha256 = "9bc00c2c639bf633e2c5e08d4bf1bb5d7edaad6ccdd473692f0362df08f8aafc";
    };
  };

  appnope = buildPythonPackage rec {
    version = "0.1.0";
    name = "appnope-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/a/appnope/${name}.tar.gz";
      sha256 = "8b995ffe925347a2138d7ac0fe77155e4311a0ea6d6da4f5128fe4b3cbe5ed71";
    };

    meta = {
      description = "Disable App Nap on OS X";
      homepage    = https://pypi.python.org/pypi/appnope;
      platforms   = platforms.darwin;
      license     = licenses.bsd3;
    };
  };

  apsw = buildPythonPackage rec {
    name = "apsw-3.7.6.2-r1";
    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "http://apsw.googlecode.com/files/${name}.zip";
      sha256 = "cb121b2bce052609570a2f6def914c0aa526ede07b7096dddb78624d77f013eb";
    };

    buildInputs = with self; [ pkgs.sqlite ];

    # python: double free or corruption (fasttop): 0x0000000002fd4660 ***
    doCheck = false;

    meta = {
      description = "A Python wrapper for the SQLite embedded relational database engine";
      homepage = http://code.google.com/p/apsw/;
    };
  };

  asyncio = if (pythonAtLeast "3.3") then buildPythonPackage rec {
    name = "asyncio-${version}";
    version = "3.4.3";


    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/a/asyncio/${name}.tar.gz";
      sha256 = "0hfbqwk9y0bbfgxzg93s2wyk6gcjsdxlr5jwy97hx64ppkw0ydl3";
    };

    meta = {
      description = "reference implementation of PEP 3156";
      homepage = http://www.python.org/dev/peps/pep-3156;
      license = licenses.free;
    };
  } else null;

  funcsigs = buildPythonPackage rec {
    name = "funcsigs-0.4";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/f/funcsigs/${name}.tar.gz";
      sha256 = "d83ce6df0b0ea6618700fe1db353526391a8a3ada1b7aba52fed7a61da772033";
    };

    buildInputs = with self; [
      unittest2
    ];

    meta = with pkgs.stdenv.lib; {
      description = "Python function signatures from PEP362 for Python 2.6, 2.7 and 3.2+";
      homepage = "https://github.com/aliles/funcsigs";
      maintainers = with maintainers; [ garbas ];
      license = licenses.asl20;
    };
  };

  apscheduler = buildPythonPackage rec {
    name = "APScheduler-3.0.4";
    disabled = !isPy27;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/A/APScheduler/${name}.tar.gz";
      sha256 = "1ljjhn6cv8b1pccsi3mgc887ypi2vim317r9p0zh0amd0bhkk6wb";
    };

    buildInputs = with self; [
      pytest
      sqlalchemy9
      tornado
      twisted
      mock
      trollius
      funcsigs
      gevent
    ];

    propagatedBuildInputs = with self; [
      six
      pytz
      tzlocal
      futures
    ];

    meta = with pkgs.stdenv.lib; {
      description = "A Python library that lets you schedule your Python code to be executed";
      homepage = http://pypi.python.org/pypi/APScheduler/;
      license = licenses.mit;
    };
  };

  args = buildPythonPackage rec {
    name = "args-0.1.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/a/args/${name}.tar.gz";
      sha256 = "a785b8d837625e9b61c39108532d95b85274acd679693b71ebb5156848fcf814";
    };

    meta = {
      description = "Command Arguments for Humans";
      homepage = "https://github.com/kennethreitz/args";
    };
  };

  area53 = buildPythonPackage (rec {
    name = "Area53-0.94";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/A/Area53/${name}.tar.gz";
      sha256 = "0v9b7f8b6v21y410anx5sr52k2ac8jrzdf19q6m6p0zsdsf9vr42";
    };

    # error: invalid command 'test'
    doCheck = false;

    propagatedBuildInputs = with self; [ self.boto ];

  });

  arrow = buildPythonPackage rec {
    name = "arrow-${version}";
    version = "0.5.0";

    src = pkgs.fetchurl {
      url    = "https://pypi.python.org/packages/source/a/arrow/${name}.tar.gz";
      sha256 = "1q3a6arjm6ysl2ff6lgdm504np7b1rbivrzspybjypq1nczcb7qy";
    };

    doCheck = false;
    propagatedBuildInputs = with self; [ dateutil ];

    meta = {
      description = "Twitter API library";
      license     = "apache";
      maintainers = with maintainers; [ thoughtpolice ];
    };
  };

  async = buildPythonPackage rec {
    name = "async-0.6.1";
    disabled = isPy3k;
    meta.maintainers = with maintainers; [ mornfall ];

    buildInputs = with self; [ pkgs.zlib ];
    doCheck = false;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/a/async/${name}.tar.gz";
      sha256 = "1lfmjm8apy9qpnpbq8g641fd01qxh9jlya5g2d6z60vf8p04rla1";
    };
  };

  atomiclong = buildPythonPackage rec {
    version = "0.1.1";
    name = "atomiclong-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/a/atomiclong/atomiclong-${version}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/a/atomicwrites/atomicwrites-${version}.tar.gz";
      sha256 = "08s05h211r07vs66r4din3swrbzb344vli041fihpg34q3lcxpvw";
    };

    meta = {
      description = "Atomic file writes on POSIX";
      homepage = https://pypi.python.org/pypi/atomicwrites/0.1.0;
      maintainers = with maintainers; [ matthiasbeyer ];
    };

  };

  argparse = buildPythonPackage (rec {
    name = "argparse-1.4.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/a/argparse/${name}.tar.gz";
      sha256 = "1r6nznp64j68ih1k537wms7h57nvppq0szmwsaf99n71bfjqkc32";
    };

    checkPhase = ''
      export PYTHONPATH=`pwd`/build/lib:$PYTHONPATH
      ${python.interpreter} test/test_argparse.py
    '';

    # ordering issues in tests
    doCheck = !isPy3k;

    meta = {
      homepage = http://code.google.com/p/argparse/;
      license = licenses.asl20;
      description = "argparse: Python command line parser";
      longDescription = ''
        The argparse module makes writing command line tools in Python
        easy.  Just briefly describe your command line interface and
        argparse will take care of the rest, including: parsing the
        arguments and flags from sys.argv, converting arg strings into
        objects for your program, formatting and printing any help
        messages, and much more.
      '';
    };
  });

  astroid = buildPythonPackage rec {
    name = "astroid-1.4.4";

    propagatedBuildInputs = with self; [ logilab_common six lazy-object-proxy wrapt ];

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/a/astroid/${name}.tar.gz";
      sha256 = "7f7e5512efe515098e77cbd3a60e87c8db8954097b0e025d8d6f72f2e8ddc298";
    };

    checkPhase = ''
        ${python.interpreter} -m unittest discover
    '';

    # Tests cannot be found because they're named unittest_...
    # instead of test_...

    meta = {
      description = "A abstract syntax tree for Python with inference support";
      homepage = http://bitbucket.org/logilab/astroid;
      license = with licenses; [ lgpl2 ];
    };
  };

  attrdict = buildPythonPackage (rec {
    name = "attrdict-2.0.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/a/attrdict/${name}.tar.gz";
      sha256 = "86aeb6d3809e0344409f8148d7cac9eabce5f0b577c160b5e90d10df3f8d2ad3";
    };

    propagatedBuildInputs = with self; [ coverage nose six ];

    meta = {
      description = "A dict with attribute-style access";
      homepage = https://github.com/bcj/AttrDict;
      license = licenses.mit;
    };
  });

  audioread = buildPythonPackage rec {
    name = "audioread-${version}";
    version = "2.1.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/a/audioread/${name}.tar.gz";
      sha256 = "ffb601de7a9e40850d4ec3256a3a6bbe8fa40466dafb5c65f41b08e4bb963f1e";
    };

    # No tests, need to disable or py3k breaks
    doCheck = false;

    meta = {
      description = "Cross-platform audio decoding";
      homepage = "https://github.com/sampsyo/audioread";
      license = licenses.mit;
    };
  };

  audiotools = buildPythonPackage rec {
    name = "audiotools-${version}";
    version = "3.1.1";

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

  autopep8 = buildPythonPackage (rec {
    name = "autopep8-1.0.4";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/a/autopep8/${name}.tar.gz";
      sha256 = "17lydqm8y9a5qadp6iifxrb5mb0g9fr1vxn5qy1fjpyhazxaw8n1";
    };

    propagatedBuildInputs = with self; [ pep8 ];

    # One test fails:
    # FAIL: test_recursive_should_not_crash_on_unicode_filename (test.test_autopep8.CommandLineTests)
    doCheck = false;

    meta = {
      description = "A tool that automatically formats Python code to conform to the PEP 8 style guide";
      homepage = https://pypi.python.org/pypi/autopep8/;
      license = licenses.mit;
      platforms = platforms.all;
      maintainers = with maintainers; [ bjornfor ];
    };
  });

  av = buildPythonPackage rec {
    name = "av-${version}";
    version = "0.2.4";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/a/av/${name}.tar.gz";
      sha256 = "bdc7e2e213cb9041d9c5c0497e6f8c47e84f89f1f2673a46d891cca0fb0d19a0";
    };

    buildInputs
      =  (with self; [ nose pillow numpy ])
      ++ (with pkgs; [ ffmpeg git libav pkgconfig ]);

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
      url = "https://pypi.python.org/packages/source/a/avro/${name}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/a/avro3k/${name}.tar.gz";
      sha256 = "15ahl0irwwj558s964abdxg4vp6iwlabri7klsm2am6q5r0ngsky";
    };

    doCheck = false;        # No such file or directory: './run_tests.py

    meta = {
      description = "A serialization and RPC framework";
      homepage = "https://pypi.python.org/pypi/avro3k/";
    };
  }));

  awesome-slugify = buildPythonPackage rec {
    name = "awesome-slugify-${version}";
    version = "1.6.5";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/a/awesome-slugify/${name}.tar.gz";
      sha256 = "0wgxrhr8s5vk2xmcz9s1z1aml4ppawmhkbggl9rp94c747xc7pmv";
    };

    propagatedBuildInputs = with self; [ unidecode regex ];

    meta = with stdenv.lib; {
      homepage = https://github.com/dimka665/awesome-slugify;
      description = "Python flexible slugify function";
      license = licenses.gpl3;
      platforms = platforms.all;
      maintainers = with maintainers; [ abbradar ];
    };
  };

  awscli = buildPythonPackage rec {
    name = "awscli-${version}";
    version = "1.10.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/a/awscli/${name}.tar.gz";
      sha256 = "159c8nfcighlkcbdzck102cp06g7rpgbbvxpb73vjymgqrzqywvb";
    };

    # No tests included
    doCheck = false;

    propagatedBuildInputs = with self; [
      botocore
      bcdoc
      six
      colorama
      docutils
      rsa
      pkgs.groff
      pkgs.less
    ];

    postInstall = ''
      mkdir -p $out/etc/bash_completion.d
      echo "complete -C $out/bin/aws_completer aws" > $out/etc/bash_completion.d/awscli
      mkdir -p $out/share/zsh/site-functions
      mv $out/bin/aws_zsh_completer.sh $out/share/zsh/site-functions
      rm $out/bin/aws.cmd
    '';

    meta = {
      homepage = https://aws.amazon.com/cli/;
      description = "Unified tool to manage your AWS services";
      license = stdenv.lib.licenses.asl20;
      maintainers = with maintainers; [ muflax ];
    };
  };

  aws_shell = buildPythonPackage rec {
    name = "aws-shell-${version}";
    version = "0.1.0";
    src = pkgs.fetchurl {
        sha256 = "05isyrqbk16dg1bc3mnc4ynxr3nchslvia5wr1sdmxvc3v2y729d";
        url = "https://pypi.python.org/packages/source/a/aws-shell/aws-shell-0.1.0.tar.gz";
      };
    propagatedBuildInputs = with self; [
      configobj prompt_toolkit_52 awscli boto3 pygments sqlite3 mock pytest
      pytestcov unittest2 tox
    ];

    #Checks are failing due to missing TTY, which won't exist.
    doCheck = false;
    preCheck = ''
      mkdir -p check-phase
      export HOME=$(pwd)/check-phase
    '';

    disabled = isPy35;


    meta = {
      homepage = https://github.com/awslabs/aws-shell;
      description = "An integrated shell for working with the AWS CLI";
      license = licenses.asl20;
      maintainers = [ ];
    };
  };

  azure = buildPythonPackage rec {
    version = "0.11.0";
    name = "azure-${version}";
    disabled = pythonOlder "2.7";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/a/azure/${name}.zip";
      sha256 = "89c20b2efaaed3c6f56345d55c32a8d4e7d2a16c032d0acb92f8f490c508fe24";
    };

    propagatedBuildInputs = with self; [ dateutil futures pyopenssl requests2 ];

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
      url = https://pypi.python.org/packages/source/a/azure-nspkg/azure-nspkg-1.0.0.zip;
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
      url = https://pypi.python.org/packages/source/a/azure-common/azure-common-1.0.0.zip;
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
      url = https://pypi.python.org/packages/source/a/azure-mgmt-common/azure-mgmt-common-0.20.0.zip;
      sha256 = "1rmzpz3733wv31rsnqpdy4bbafvk5dhbqx7q0xf62dlz7p0i4f66";
    };
    propagatedBuildInputs = with self; [ azure-common azure-mgmt-nspkg requests2 ];
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
      url = https://pypi.python.org/packages/source/a/azure-mgmt-compute/azure-mgmt-compute-0.20.0.zip;
      sha256 = "12hr5vxdg2sk2fzr608a37f4i8nbchca7dgdmly2w5fc7x88jx2v";
    };
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
      url = https://pypi.python.org/packages/source/a/azure-mgmt-network/azure-mgmt-network-0.20.1.zip;
      sha256 = "10vj22h6nxpw0qpvib5x2g6qs5j8z31142icvh4qk8k40fcrs9hx";
    };
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
      url = https://pypi.python.org/packages/source/a/azure-mgmt-nspkg/azure-mgmt-nspkg-1.0.0.zip;
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
      url = https://pypi.python.org/packages/source/a/azure-mgmt-resource/azure-mgmt-resource-0.20.1.zip;
      sha256 = "0slh9qfm5nfacrdm3lid0sr8kwqzgxvrwf27laf9v38kylkfqvml";
    };
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
      url = https://pypi.python.org/packages/source/a/azure-mgmt-storage/azure-mgmt-storage-0.20.0.zip;
      sha256 = "16iw7hqhq97vlzfwixarfnirc60l5mz951p57brpcwyylphl3yim";
    };
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
      url = https://pypi.python.org/packages/source/a/azure-storage/azure-storage-0.20.3.zip;
      sha256 = "06bmw6k2000kln5jwk5r9bgcalqbyvqirmdh9gq4s6nb4fv3c0jb";
    };
    propagatedBuildInputs = with self; [ azure-common futures dateutil requests2 ];
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
      url = https://pypi.python.org/packages/source/a/azure-servicemanagement-legacy/azure-servicemanagement-legacy-0.20.1.zip;
      sha256 = "17dwrp99sx5x9cm4vldkaxhki9gbd6dlafa0lpr2n92xhh2838zs";
    };
    propagatedBuildInputs = with self; [ azure-common requests2 ];
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

  backports_ssl_match_hostname_3_4_0_2 = self.buildPythonPackage rec {
    name = "backports.ssl_match_hostname-3.4.0.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/b/backports.ssl_match_hostname/backports.ssl_match_hostname-3.4.0.2.tar.gz";
      sha256 = "07410e7fb09aab7bdaf5e618de66c3dac84e2e3d628352814dc4c37de321d6ae";
    };

    meta = {
      description = "The Secure Sockets layer is only actually *secure*";
      homepage = http://bitbucket.org/brandon/backports.ssl_match_hostname;
    };
  };

  backports_lzma = self.buildPythonPackage rec {
    name = "backports.lzma-0.0.3";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/b/backports.lzma/${name}.tar.gz";
      sha256 = "bac58aec8d39ac3d22250840fb24830d0e4a0ef05ad8f3f09172dc0cc80cdbca";
    };

    buildInputs = [ pkgs.lzma ];

    meta = {
      describe = "Backport of Python 3.3's 'lzma' module for XZ/LZMA compressed files";
      homepage = https://github.com/peterjc/backports.lzma;
      license = licenses.bsd3;
    };
  };

  babelfish = buildPythonPackage rec {
    version = "0.5.3";
    name = "babelfish-${version}";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/b/babelfish/${name}.tar.gz";
      sha256 = "0wrw21dyq7v6lbffwvi1ik43d7dhmcv8xvgrrihhiv7ys1rd3gag";
    };

    meta = {
      homepage = http://pypi.python.org/pypi/babelfish;
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
      url = "https://pypi.python.org/packages/source/b/${pname}/${name}.tar.gz";
      sha256 = "1ajmflvvlkflrcmqmkrx0zaira84z8kv4ssb2jprfwvjh8vfkysb";
    };

    buildInputs = [ pkgs.gcc ];
    propagatedBuildInputs = [ pkgs.wirelesstools ];

    meta = {
      description = "Get info about wireless interfaces using libiw";
      homepage = http://github.com/enkore/basiciw;
      platforms = platforms.linux;
      license = licenses.gpl2;
    };
  };

  batinfo = buildPythonPackage rec {
    version = "0.2";
    name = "batinfo-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/b/batinfo/${name}.tar.gz";
      sha256 = "1kmrdr1c2ivpqgp2csln7vbanga3sh3nvaqmgbsg96z6fbg7f7w8";
    };

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
      url = "https://pypi.python.org/packages/source/b/bcdoc/${name}.tar.gz";
      sha256 = "1s2kdqs1n2mj7wq3w0pq30zs7vxq0l3abik2clqnc4hm2j7crbk8";
    };

    buildInputs = with self; [ docutils six ];

    meta = {
      homepage = https://github.com/botocore/bcdoc;
      license = licenses.asl20;
      description = "ReST document generation tools for botocore";
    };
  };

  beautifulsoup = buildPythonPackage (rec {
    name = "beautifulsoup-3.2.1";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "http://www.crummy.com/software/BeautifulSoup/download/3.x/BeautifulSoup-3.2.1.tar.gz";
      sha256 = "1nshbcpdn0jpcj51x0spzjp519pkmqz0n0748j7dgpz70zlqbfpm";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://www.crummy.com/software/BeautifulSoup/;
      license = "bsd";
      description = "Undemanding HTML/XML parser";
    };
  });

  beautifulsoup4 = buildPythonPackage (rec {
    name = "beautifulsoup4-4.4.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/b/beautifulsoup4/${name}.tar.gz";
      sha256 = "1d36lc4pfkvl74fmzdib2nqnvknm0jddgf2n9yd7im150qyh3m47";
    };

    buildInputs = [ self.nose ];
    checkPhase = ''
      nosetests build/
    '';

    meta = {
      homepage = http://crummy.com/software/BeautifulSoup/bs4/;
      description = "HTML and XML parser";
      license = licenses.mit;
      maintainers = with maintainers; [ iElectric ];
    };
  });

  # flexget needs beatifulsoup < 4.4 for now
  beautifulsoup_4_1_3 = buildPythonPackage (rec {
    name = "beautifulsoup4-4.1.3";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/b/beautifulsoup4/${name}.tar.gz";
      sha256 = "0cbcml88bkx9gf1wznxa0kqz1wpyakfbyh9gmxw0wljhda1q0zk1";
    };

    meta = {
      homepage = http://crummy.com/software/BeautifulSoup/bs4/;
      description = "HTML and XML parser";
      license = licenses.mit;
      maintainers = with maintainers; [ iElectric ];
    };

    disabled = isPy3k;

  });

  beaker = buildPythonPackage rec {
    name = "Beaker-1.7.0";

    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/B/Beaker/${name}.tar.gz";
      sha256 = "0vv4y22b3ly1212n9nnhgvc8yz32adlfl7w7s1wj0i5srpjcgvlq";
    };

    buildInputs =
      [ self.sqlalchemy7
        self.pycryptopp
        self.nose
        self.mock
        self.webtest
      ];

    # http://hydra.nixos.org/build/4511591/log/raw
    doCheck = false;

    meta = {
      maintainers = with maintainers; [ garbas iElectric ];
      platforms = platforms.all;
    };
  };

  betamax = buildPythonPackage rec {
    name = "betamax-0.5.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/b/betamax/${name}.tar.gz";
      sha256 = "1glzigrbip9w2jr2gcmwa96rffhi9x9l1455dhbcx2gh3pmcykl6";
    };

    propagatedBuildInputs = [ self.requests2 ];

    meta = with stdenv.lib; {
      homepage = https://betamax.readthedocs.org/en/latest/;
      description = "A VCR imitation for requests";
      license = licenses.asl20;
      maintainers = with maintainers; [ pSub ];
    };
  };

  betamax-matchers = buildPythonPackage rec {
    name = "betamax-matchers-${version}";
    version = "0.2.0";

    src = pkgs.fetchurl {
       url = "https://pypi.python.org/packages/source/b/betamax-matchers/${name}.tar.gz";
      sha256 = "13n2dy8s2jx8x8bbx684bff3444584bnmg0zhkfxhxndpy18p4is";
    };

    buildInputs = with self; [ betamax requests_toolbelt ];

    meta = with stdenv.lib; {
      homepage = https://github.com/sigmavirus24/betamax_matchers;
      description = "A group of experimental matchers for Betamax";
      license = licenses.asl20;
      maintainers = with maintainers; [ pSub ];
    };
  };

  caldavclientlibrary-asynk = buildPythonPackage rec {
    version = "asynkdev";
    name = "caldavclientlibrary-asynk-${version}";

    src = pkgs.fetchgit {
      url = "https://github.com/skarra/CalDAVClientLibrary.git";
      rev = "06699b08190d50cc2636b921a654d67db0a967d1";
      sha256 = "1i6is7lv4v9by4panrd9w63m4xsmhwlp3rq4jjj3azwg5jm10940";
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

  bedup = buildPythonPackage rec {
    name = "bedup-20140413";

    src = pkgs.fetchgit {
      url = "https://github.com/g2p/bedup.git";
      rev = "5189e166145b8954ac41883f81ef3c3b50dc96ab";
      sha256 = "e61768fa19934bd176799f90bda3ea9f49a5def21fa2523a8e47df8a48e730e9";
    };

    buildInputs = with self; [ pkgs.btrfs-progs ];
    propagatedBuildInputs = with self; [ contextlib2 pyxdg pycparser alembic ]
      ++ optionals (!isPyPy) [ cffi ];

    # No proper test suite. Included tests cannot be run because of relative import
    doCheck = false;

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

  buttersink = buildPythonPackage rec {
    name = "buttersink-0.6.7";

    src = pkgs.fetchurl {
      sha256 = "1azd0g0p9qk9wp344jmvqp4wk5f3wpsz3lb750xvnmd7qzf6v377";
      url = "https://pypi.python.org/packages/source/b/buttersink/${name}.tar.gz";
    };

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

  cgroup-utils = buildPythonPackage rec {
    version = "0.6";
    name = "cgroup-utils-${version}";

    propagatedBuildInputs = with self; [ argparse ];
    buildInputs = with self; [ pep8 nose ];
    # Pep8 tests fail...
    doCheck = false;

    src = pkgs.fetchFromGitHub {
      owner = "peo3";
      repo = "cgroup-utils";
      rev = "v${version}";
      sha256 = "1ck0aijzrg9xf6hjdxnynkapnyxw0y385jb0q7wyq4jf77ayfszc";
    };

    meta = {
      description = "Utility tools for control groups of Linux";
      maintainers = with maintainers; [ layus ];
      license = licenses.gpl2;
    };
  };

  circus = buildPythonPackage rec {
    name = "circus-0.11.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/c/circus/${name}.tar.gz";
      sha256 = "3757344aa5073ea29e6e2607b3de8ba1652502c61964316116931884293fe846";
    };

    doCheck = false; # weird error

    propagatedBuildInputs = with self; [ iowait psutil pyzmq tornado mock ];
  };

  colorlog = buildPythonPackage rec {
    name = "colorlog-${version}";
    version = "2.6.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/c/colorlog/${name}.tar.gz";
      sha256 = "1s8z9zr4r18igr4rri71nba01arnpppifrkaxhi2xb51500sw0qg";
    };

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
      url = "https://pypi.python.org/packages/source/c/${pname}/${name}.tar.gz";
      sha256 = "0w1j43l76zw10dvs2kk7jz7kqj2ss7gfgfdxyls27pckwin89gxb";
    };

    buildInputs = with self; [ d2to1 ];

    meta = {
      description = "Converts and manipulates common color representation (RGB, HSV, web, ...)";
      homepage = https://github.com/vaab/colour;
      license = licenses.bsd2;
    };
  };

  cornice = buildPythonPackage rec {
    name = "cornice-${version}";
    version = "0.17.0";
    src = pkgs.fetchgit {
      url = https://github.com/mozilla-services/cornice.git;
      rev = "refs/tags/${version}";
      sha256 = "12yrcsv1sdl5w308y1cc939ppq7pi2490s54zfcbs481cvsyr1lg";
    };

    propagatedBuildInputs = with self; [ pyramid simplejson ];

    doCheck = false; # lazy packager
  };

  cvxopt = buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "cvxopt";
    version = "1.1.7";
    disabled = isPyPy;
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/c/${pname}/${name}.tar.gz";
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

  cycler = buildPythonPackage rec {
    name = "cycler-${version}";
    version = "0.10.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/C/Cycler/${name}.tar.gz";
      sha256 = "cd7b2d1018258d7247a71425e9f26463dfb444d411c39569972f4ce586b0c9d8";
    };

    buildInputs = with self; [ coverage nose ];
    propagatedBuildInputs = with self; [ six ];

    checkPhase = ''
      ${python.interpreter} run_tests.py
    '';

    # Tests were not included in release.
    # https://github.com/matplotlib/cycler/issues/31
    doCheck = false;

    meta = {
      description = "Composable style cycles";
      homepage = http://github.com/matplotlib/cycler;
      license = licenses.bsd3;
      maintainers = with maintainers; [ fridh ];
    };
  };

  datadog = buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "datadog";
    version = "0.10.0";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/${pname}/${name}.tar.gz";
      sha256 = "0y2if4jj43n5jis20imragvhhyhr840w4m1g7j7fxh9bn7h273zp";
    };

    buildInputs = with self; [ pillow tox mock six nose ];
    propagatedBuildInputs = with self; [ requests2 decorator simplejson ];

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
      url = "https://pypi.python.org/packages/source/p/${pname}/${name}.tar.gz";
      sha256 = "193faznwnjc3n5991wyzim6h9gyq1zxifmfrnpm3avgkh7ahyynh";
    };
    propagatedBuildInputs = with self; [ chardet six ];
  };

  defusedxml = buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "defusedxml";
    version = "0.4.1";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/${pname}/${name}.tar.gz";
      sha256 = "0y147zy3jqmk6ly7fbhqmzn1hf41xcb53f2vcc3m8x4ba5d1smfd";
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
    propagatedBuildInputs = with self; [ requests2 lxml pbr ];
    # prompt_toolkit doesn't work on 3.5 on OSX.
    doCheck = !isPy35;

    meta = {
      description = "A comic strip downloader and archiver";
      homepage = http://dosage.rocks/;
    };
  };

  dugong = buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "dugong";
    version = "3.5";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/${pname}/${name}.tar.bz2";
      sha256 = "0y0rdxbiwm03zv6vpvapqilrird3h8ijz7xmb0j7ds5j4p6q3g24";
    };

    disabled = pythonOlder "3.3";	# Library does not support versions older than 3.3
  };

  iowait = buildPythonPackage rec {
    name = "iowait-0.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/i/iowait/${name}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/r/responses/${name}.tar.gz";
      sha256 = "0fs7a4cf4f12mjhcjd5vfh0f3ixcy2nawzxpgsfr3ahf0rg7ppx5";
    };

    propagatedBuildInputs = with self; [ cookies mock requests2 six ];

    doCheck = false;

  };

  rarfile = self.buildPythonPackage rec {
    name = "rarfile-2.6";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/r/rarfile/rarfile-2.6.tar.gz";
      sha256 = "326700c5450cfb367f612e918866ea27551bac02f4656f340003c88873fa1a56";
    };

    meta = {
      description = "rarfile - RAR archive reader for Python";
      homepage = https://github.com/markokr/rarfile;
    };
  };

  proboscis = buildPythonPackage rec {
    name = "proboscis-1.2.6.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/proboscis/proboscis-1.2.6.0.tar.gz";
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
      url = "https://pypi.python.org/packages/source/p/pyechonest/pyechonest-8.0.2.tar.gz";
      sha256 = "496265f4b7d33483ec153b9e1b8333fe959b115f7e781510089c8313b7d86560";
    };

    meta = {
      description = "Tap into The Echo Nest's Musical Brain for the best music search, information, recommendations and remix tools on the web";
      homepage = https://github.com/echonest/pyechonest;
    };
  };


  billiard = buildPythonPackage rec {
    name = "billiard-${version}";
    version = "3.3.0.21";

    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/b/billiard/${name}.tar.gz";
      sha256 = "1sfsrkm5xv820wp2mz5zn2rnw6s0c9wal69v1fkr26wp1a7zf1cp";
    };

    buildInputs = with self; [ nose unittest2 mock ];

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
      url ="https://pypi.python.org/packages/source/b/binaryornot/${name}.tar.gz";
      sha256 = "1j4f51dxic39mdwf6alj7gd769wy6mhk916v031wjali51xkh3xb";
    };

    buildInputs = with self; [ hypothesis1 sqlite3 ];

    propagatedBuildInputs = with self; [ chardet ];

    meta = {
      homepage = https://github.com/audreyr/binaryornot;
      description = "Ultra-lightweight pure Python package to check if a file is binary or text";
      license = licenses.bsd3;
    };
  };


  bitbucket_api = buildPythonPackage rec {
    name = "bitbucket-api-0.4.4";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/b/bitbucket-api/${name}.tar.gz";
      sha256 = "e890bc3893d59a6f203c1eb2bae60e78ac4d3869da7ea4fb104dca588aea85b2";
    };

    propagatedBuildInputs = with self; [ requests_oauth2 nose sh ];

    doCheck = false;

    meta = {
      homepage = https://github.com/Sheeprider/BitBucket-api;
      description = "Python library to interact with BitBucket REST API";
      license = licenses.mit;
    };
  };

  bitbucket-cli = buildPythonPackage rec {
    name = "bitbucket-cli-0.4.1";
    src = pkgs.fetchurl {
       url = "https://pypi.python.org/packages/source/b/bitbucket-cli/${name}.tar.gz";
       sha256 = "d8909627ae7a46519379c6343698d49f9ffd5de839ff44796974828d843a9419";
    };

    pythonPath = [ self.requests ];

    meta = {
      description = "Bitbucket command line interface";
      homepage = "https://bitbucket.org/zhemao/bitbucket-cli";
      maintainers = with maintainers; [ refnil ];
    };
  };


  bitstring = buildPythonPackage rec {
    name = "bitstring-3.1.2";

    src = pkgs.fetchurl {
      url = "https://python-bitstring.googlecode.com/files/${name}.zip";
      sha256 = "1i1p3rkj4ad108f23xyib34r4rcy571gy65paml6fk77knh0k66p";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      description = "Module for binary data manipulation";
      homepage = https://code.google.com/p/python-bitstring/;
      license = licenses.mit;
      platforms = platforms.linux;
      maintainers = with maintainers; [ bjornfor ];
    };
  };

  blaze = buildPythonPackage rec {
    name = "blaze-${version}";
    version = "0.9.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/b/blaze/${name}.tar.gz";
      sha256 = "fde4fd5733d8574345521581078a4fd89bb51ad3814eda88f1f467faa3a9784a";
    };

    buildInputs = with self; [ pytest ];
    propagatedBuildInputs = with self; [
      cytoolz
      datashape
      flask
      flask-cors
      h5py
      multipledispatch
      numba
      numpy
      odo
      pandas
      psutil
      pymongo
      pyyaml
      requests2
      sqlalchemy
      tables
      toolz
    ];

    checkPhase = ''
      py.test blaze/tests
    '';

    meta = {
      homepage = https://github.com/ContinuumIO/blaze;
      description = "Allows Python users a familiar interface to query data living in other data storage systems";
      license = licenses.bsdOriginal;
      maintainers = with maintainers; [ fridh ];
    };
  };

  bleach = buildPythonPackage rec {
    version = "v1.4";
    name = "bleach-${version}";

    src = pkgs.fetchurl {
      url = "http://github.com/jsocol/bleach/archive/${version}.tar.gz";
      sha256 = "19v0zhvchz89w179rwkc4ah3cj2gbcng9alwa2yla89691g8b0b0";
    };

    buildInputs = with self; [ nose ];
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
      homepage = https://github.com/jsocol/bleach;
      downloadPage = https://github.com/jsocol/bleach/releases;
      license = licenses.asl20;
      maintainers = with maintainers; [ prikhi ];
      platforms = platforms.linux;
    };
  };

  blinker = buildPythonPackage rec {
    name = "blinker-${version}";
    version = "1.3";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/b/blinker/${name}.tar.gz";
      sha256 = "6811010809262261e41ab7b92f3f6d23f35cf816fbec2bc05077992eebec6e2f";
    };

    meta = {
      homepage = http://pythonhosted.org/blinker/;
      description = "Fast, simple object-to-object and broadcast signaling";
      license = licenses.mit;
      maintainers = with maintainers; [ garbas ];
    };
  };


  blockdiag = buildPythonPackage rec {
    name = "blockdiag-1.4.7";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/b/blockdiag/${name}.tar.gz";
      sha256 = "0bc29sh8hj3hmhclifh1by0n6vg2pl9wkxb7fmljyw0arjas54bf";
    };

    buildInputs = with self; [ pep8 nose unittest2 docutils ];

    propagatedBuildInputs = with self; [ pillow webcolors funcparserlib ];

    # One test fails:
    #   ...
    #   FAIL: test_auto_font_detection (blockdiag.tests.test_boot_params.TestBootParams)
    doCheck = false;

    meta = {
      description = "Generate block-diagram image from spec-text file (similar to Graphviz)";
      homepage = http://blockdiag.com/;
      license = licenses.asl20;
      platforms = platforms.linux;
      maintainers = with maintainers; [ bjornfor ];
    };
  };


  bpython = buildPythonPackage rec {
     name = "bpython-0.12";
     src = pkgs.fetchurl {
       url = "http://www.bpython-interpreter.org/releases/bpython-0.12.tar.gz";
       sha256 = "1ilf58qq7sazmcgg4f1wswbhcn2gb8qbbrpgm6gf0j2lbm60gabl";
     };

     propagatedBuildInputs = with self; [ modules.curses pygments ];
     doCheck = false;

     meta = {
       description = "UNKNOWN";
       homepage = "UNKNOWN";
       maintainers = with maintainers; [ iElectric ];
     };
   };

  bsddb3 = buildPythonPackage rec {
    name = "bsddb3-${version}";
    version = "6.1.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/b/bsddb3/${name}.tar.gz";
      sha256 = "6f21b0252125c07798d784c164ef135ad153d226c01b290258ee1c5b9e7c4dd3";
    };

    buildInputs = [ pkgs.db ];

    # Judging from SyntaxError in test
    disabled = isPy3k;

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

  bokeh = buildPythonPackage rec {
    name = "bokeh-${version}";
    version = "0.10.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/b/bokeh/${name}.tar.gz";
      sha256 = "2d8bd8c98e2f62b2a28328d3cc95bfbe257742fa7efc9c382b4c8ae4a141df14";
    };

    disabled = isPyPy;

    propagatedBuildInputs = with self; [
      flask
      jinja2
      markupsafe
      werkzeug
      itsdangerous
      dateutil
      requests
      six
      pygments
      pystache
      markdown
      pyyaml
      pyzmq
      tornado
      colorama
      ]
      ++ optionals ( isPy26 ) [ argparse ]
      ++ optionals ( !isPy3k && !isPyPy ) [ websocket_client ]
      ++ optionals ( !isPyPy ) [ numpy pandas greenlet ];

    meta = {
      description = "Statistical and novel interactive HTML plots for Python";
      homepage = "http://github.com/bokeh/bokeh";
      license = licenses.bsd3;
    };
  };

  boto = buildPythonPackage rec {
    name = "boto-${version}";
    version = "2.38.0";

    src = pkgs.fetchurl {
      url = "https://github.com/boto/boto/archive/${version}.tar.gz";
      sha256 = "0l7m3lmxmnknnz9svzc7z26rklwckzwqgz6hgackl62gkndryrgj";
    };

    checkPhase = ''
      ${python.interpreter} tests/test.py default
    '';

    buildInputs = [ self.nose self.mock ];
    propagatedBuildInputs = [ self.requests2 self.httpretty ];

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
    version = "1.2.2";

    src = pkgs.fetchFromGitHub {
      owner = "boto";
      repo  = "boto3";
      rev   = version;
      sha256 = "1w53lhhdzi29d31qzhflb5mcwb24mfrj4frv70w6qyn8vmqznnjy";
    };

    propagatedBuildInputs = [ self.botocore
                              self.jmespath
                            ] ++ (if isPy3k then [] else [self.futures_2_2]);
    buildInputs = [ self.docutils self.nose self.mock ];

    # Tests are failing with `botocore.exceptions.NoCredentialsError:
    # Unable to locate credentials`. There also seems to be some mock
    # issues (`assert_called_once` doesn't exist in mock but boto
    # seems to think it is?).
    doCheck = false;

    meta = {
      homepage = https://github.com/boto3/boto;

      license = stdenv.lib.licenses.asl20;

      description = "AWS SDK for Python";

      longDescription = ''
        Boto3 is the Amazon Web Services (AWS) Software Development Kit (SDK) for
        Python, which allows Python developers to write software that makes use of
        services like Amazon S3 and Amazon EC2.
      '';
    };
  };

  botocore = buildPythonPackage rec {
    version = "1.3.23"; # This version is required by awscli
    name = "botocore-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/b/botocore/${name}.tar.gz";
      sha256 = "00iaapmy07zdhm2y23fk9igrskzdkix53j7g45lc5dg9nfyngq6j";
    };

    propagatedBuildInputs =
      [ self.dateutil
        self.requests2
        self.jmespath
      ];

    buildInputs = with self; [ docutils mock nose ];

    checkPhase = ''
      nosetests -v
    '';

    # Network access
    doCheck = false;

    meta = {
      homepage = https://github.com/boto/botocore;
      license = "bsd";
      description = "A low-level interface to a growing number of Amazon Web Services";
    };
  };

  bottle = buildPythonPackage rec {
    version = "0.12.8";
    name = "bottle-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/b/bottle/${name}.tar.gz";
      sha256 = "1b2hq0l4nwh75s2w6wgiqlkj4q1qvyx6a94axl2k4lsym1aifpfd";
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
      url = "https://pypi.python.org/packages/source/B/Box2D/Box2D-2.3b0.zip";
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

  bugwarrior = buildPythonPackage rec {
    name = "bugwarrior-${version}";
    version = "1.0.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/b/bugwarrior/${name}.tar.gz";
      # md5 = "09c93f86a27ffc092e69b46889a3bf50"; # provided by pypi website.
      sha256 = "efe41756c152789f39006f157add9bedfa2b85d2cac15c067e635e37c70cb8f8";
    };

    buildInputs = with self; [ mock unittest2 nose /* jira megaplan */ ];
    propagatedBuildInputs = with self; [
      twiggy requests2 offtrac bugzilla taskw dateutil pytz keyring six
      jinja2 pycurl dogpile_cache lockfile click
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
      url = "https://pypi.python.org/packages/source/p/python-bugzilla/python-${name}.tar.gz";
      # md5 = "c95befd1fecad21f742beaa8180538c0"; # provided by pypi website.
      sha256 = "11361635a4f1613803a0b9b93ba9126f7fd36180653f953e2590b1536d107d46";
    };

    patches = [ ../development/python-modules/bugzilla/checkPhase-fix-cookie-compare.patch ];

    buildInputs = with self; [ pep8 coverage logilab_common ];
    propagatedBuildInputs = [ self.requests2 ];

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

  buildout = self.zc_buildout;
  buildout152 = self.zc_buildout152;

  check-manifest = buildPythonPackage rec {
    name = "check-manifest";
    version = "0.30";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/c/check-manifest/check-manifest-${version}.tar.gz";
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

  devpi-common = buildPythonPackage rec {
    name = "devpi-common";
    version = "2.0.8";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/devpi-common/devpi-common-${version}.tar.gz";
      sha256 = "a059c4099002d4af8f3ccfc8a9f4bf133b20ea404049b21a31fc1003e1d79452";
    };

    propagatedBuildInputs = [ self.requests2 self.py ];

    meta = {
      homepage = https://bitbucket.org/hpk42/devpi;
      description = "Utilities jointly used by devpi-server and devpi-client";
      license = licenses.mit;
      maintainers = with maintainers; [ lewo ];
    };
  };

  # A patched version of buildout, useful for buildout based development on Nix
  zc_buildout_nix = callPackage ../development/python-modules/buildout-nix { };

  zc_recipe_egg = self.zc_recipe_egg_buildout171;
  zc_buildout = self.zc_buildout171;
  zc_buildout2 = self.zc_buildout221;
  zc_buildout221 = buildPythonPackage rec {
    name = "zc.buildout-2.2.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zc.buildout/${name}.tar.gz";
      sha256 = "a6122ea5c06c6c044a9efce4a3df452c8573e1aebfda7b24262655daac894ef5";
    };

   meta = {
      homepage = "http://www.buildout.org";
      description = "A software build and configuration system";
      license = licenses.zpt21;
      maintainers = with maintainers; [ garbas ];
    };
  };

  zc_buildout171 = buildPythonPackage rec {
    name = "zc.buildout-1.7.1";

    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zc.buildout/${name}.tar.gz";
      sha256 = "a5c2fafa4d073ad3dabec267c44a996cbc624700a9a49467cd6b1ef63d35e029";
    };

   meta = {
      homepage = "http://www.buildout.org";
      description = "A software build and configuration system";
      license = licenses.zpt21;
      maintainers = with maintainers; [ garbas ];
    };
  };

  zc_buildout152 = buildPythonPackage rec {
    name = "zc.buildout-1.5.2";

    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zc.buildout/${name}.tar.gz";
      sha256 = "0ac5a325d3ffbc5a988fb3ba87f4159d4769cc73e3331cb5234edc8839b6506b";
    };

   # TODO: consider if this patch should be an option
   # It makes buildout useful in a nix profile, but this alters the default functionality
   patchPhase = ''
     sed -i "s/return (stdlib, site_paths)/return (stdlib, sys.path)/g" src/zc/buildout/easy_install.py
   '';

   meta = {
      homepage = "http://www.buildout.org";
      description = "A software build and configuration system";
      license = licenses.zpt21;
      maintainers = with maintainers; [ garbas ];
    };
  };

  zc_recipe_egg_fun = { buildout, version, md5 }: buildPythonPackage rec {
    inherit version;
    name = "zc.recipe.egg-${version}";

    buildInputs = with self; [ buildout ];
    doCheck = false;

    src = pkgs.fetchurl {
      inherit md5;
      url = "https://pypi.python.org/packages/source/z/zc.recipe.egg/zc.recipe.egg-${version}.tar.gz";
    };
    meta.broken = true;  # https://bitbucket.org/pypa/setuptools/issues/462/pkg_resourcesfind_on_path-thinks-the
  };
  zc_recipe_egg_buildout171 = self.zc_recipe_egg_fun {
    buildout = self.zc_buildout171;
    version = "1.3.2";
    md5 = "1cb6af73f527490dde461d3614a36475";
  };
  zc_recipe_egg_buildout2 = self.zc_recipe_egg_fun {
    buildout = self.zc_buildout2;
    version = "2.0.3";
    md5 = "69a8ce276029390a36008150444aa0b4";
  };

  bunch = buildPythonPackage (rec {
    name = "bunch-1.0.1";
    meta.maintainers = with maintainers; [ mornfall ];

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/b/bunch/${name}.tar.gz";
      sha256 = "1akalx2pd1fjlvrq69plvcx783ppslvikqdm93z2sdybq07pmish";
    };
    doCheck = false;
  });


  cairocffi = buildPythonPackage rec {
    name = "cairocffi-0.7.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/c/cairocffi/${name}.tar.gz";
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
    ];

    postPatch = ''
      # Hardcode cairo library path
      # FIXME: for closure-size branch all pkgs.foo should be replaced with pkgs.foo.lib
      substituteInPlace cairocffi/__init__.py --subst-var-by cairo ${pkgs.cairo}
      substituteInPlace cairocffi/__init__.py --subst-var-by glib ${pkgs.glib}
      substituteInPlace cairocffi/__init__.py --subst-var-by gdk_pixbuf ${pkgs.gdk_pixbuf}
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
      url = "http://pypi.python.org/packages/source/C/CairoSVG/CairoSVG-${version}.tar.gz";
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
      url = "http://pypi.python.org/packages/source/c/carrot/${name}.tar.gz";
      sha256 = "cb46374f3c883c580d142a79d2609883713a867cc86e0514163adce784ce2468";
    };

    buildInputs = with self; [ self.nose ];

    propagatedBuildInputs =
      [ self.amqplib
        self.anyjson
      ];

    doCheck = false; # depends on the network

    meta = {
      homepage = http://pypi.python.org/pypi/carrot;
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

  cassandra-driver = buildPythonPackage rec {
    name = "cassandra-driver-2.6.0c2";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/c/cassandra-driver/${name}.tar.gz";
      sha256 = "00cc2rkvkxaxn7sf2qzy29s6h394fla73rbdh9krxbswp5nvp27r";
    };

    propagatedBuildInputs = with self; [
      futures
      nose
      six
      sure
      pytz
      pyyaml
    ];

    meta = {
      homepage = http://datastax.github.io/python-driver/;
      description = "A Python client driver for Apache Cassandra";
    };
  };

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


  celery = buildPythonPackage rec {
    name = "celery-${version}";
    version = "3.1.19";

    disabled = pythonOlder "2.6";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/c/celery/${name}.tar.gz";
      sha256 = "0wbbsrg3vfq8v7y2nylal1gqmn3h4a5vqzbsjiwcybl21hlj2smx";
    };

    buildInputs = with self; [ mock nose unittest2 ];
    propagatedBuildInputs = with self; [ kombu billiard pytz anyjson amqp ];

    checkPhase = ''
      nosetests $out/${python.sitePackages}/celery/tests/
    '';

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
      url = "https://pypi.python.org/packages/source/C/Cerberus/${name}.tar.gz";
      sha256 = "1km7hvns1snrmcwz58bssi4wv3gwd34zm1z1hwjylmpqrfrcf8mi";
    };

    meta = {
      homepage = http://python-cerberus.org/;
      description = "Lightweight, extensible schema and data validation tool for Python dictionaries";
      license = licenses.mit;
    };
  };

  certifi = buildPythonPackage rec {
    name = "certifi-${version}";
    version = "2015.9.6.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/c/certifi/${name}.tar.gz";
      sha256 = "19mfly763c6bzya9dwm6qgc48z4x3gk6ldl6fprdncqhklnjnfnw";
    };

    meta = {
      homepage = http://certifi.io/;
      description = "Python package for providing Mozilla's CA Bundle";
      license = licenses.isc;
      maintainers = with maintainers; [ koral ];
    };
  };

  characteristic = buildPythonPackage rec {
    name = "characteristic-14.1.0";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/c/characteristic/${name}.tar.gz";
      sha256 = "91e254948180678dd69e6143202b4686f2fa47cce136936079bb4d9a3b82419d";
    };

    buildInputs = with self; [ self.pytest ];

    meta = {
      description = "Python attributes without boilerplate";
      homepage = https://characteristic.readthedocs.org;
    };
  };


  cheetah = buildPythonPackage rec {
    version = "2.4.4";
    name = "cheetah-${version}";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/C/Cheetah/Cheetah-${version}.tar.gz";
      sha256 = "be308229f0c1e5e5af4f27d7ee06d90bb19e6af3059794e5fd536a6f29a9b550";
    };

    propagatedBuildInputs = with self; [ self.markdown ];

    meta = {
      homepage = http://www.cheetahtemplate.org/;
      description = "A template engine and code generation tool";
    };
  };


  cherrypy = buildPythonPackage (rec {
    name = "cherrypy-${version}";
    version = "3.2.2";

    src = pkgs.fetchurl {
      url = "http://download.cherrypy.org/cherrypy/${version}/CherryPy-${version}.tar.gz";
      sha256 = "14dn129h69wj0h8yr0bjwbrk8kygl6mkfnxc5m3fxhlm4xb8hnnw";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = "http://www.cherrypy.org";
      description = "A pythonic, object-oriented HTTP framework";
    };
  });


  cjson = buildPythonPackage rec {
    name = "python-cjson-${version}";
    version = "1.1.0";
    disabled = isPy3k || isPyPy;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/python-cjson/${name}.tar.gz";
      sha256 = "a01fabb7593728c3d851e1cd9a3efbd18f72650a31a5aa8a74018640da3de8b3";
    };

    meta = {
      description = "A very fast JSON encoder/decoder for Python";
      homepage    = "http://ag-projects.com/";
      license     = licenses.lgpl2;
      platforms   = platforms.all;
    };
  };

  clf = buildPythonPackage rec {
    name = "clf-${version}";
    version = "0.5.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/c/clf/${name}.tar.gz";
      sha256 = "04lqd2i4fjs606b0q075yi9xksk567m0sfph6v6j80za0hvzqyy5";
    };

    patchPhase = ''
      sed -i 's/==/>=/' requirements.txt
    '';

    propagatedBuildInputs = with self; [ docopt requests2 pygments ];

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
    name = "click-6.3";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/c/click/${name}.tar.gz";
      sha256 = "076cr1xbhfyfrzkvflz1i0950jgjn2161hp3f5xji4z1mgxdj85p";
    };

    buildInputs = with self; [ pytest ];

    checkPhase = ''
      py.test tests
    '';

    # Python 3.5 str/bytes-like errors with reading files
    doCheck = !isPy3k;

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
      url = "https://pypi.python.org/packages/source/c/click/${name}.tar.gz";
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
    version = "0.1.3";
    name = "click-log-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/c/click-log/${name}.tar.gz";
      sha256 = "0kdd1vminxpcfczxl2kkf285n0dr1gxh2cdbx1p6vkj7b7bci3gx";
    };

    propagatedBuildInputs = with self; [ click ];

    meta = {
      homepage = https://github.com/click-contrib/click-log/;
      description = "Logging integration for Click";
      license = licenses.mit;
      maintainers = with maintainers; [ DamienCassou ];
    };
  };

  click-threading = buildPythonPackage rec {
    version = "0.1.2";
    name = "click-threading-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/c/click-threading/${name}.tar.gz";
      sha256 = "0jmrv4334lfxa2ss53c06dafdwqbk1pb3ihd26izn5igw1bm8145";
    };

    propagatedBuildInputs = with self; [ click ];

    meta = {
      homepage = https://github.com/click-contrib/click-threading/;
      description = "Multithreaded Click apps made easy";
      license = licenses.mit;
      maintainers = with maintainers; [ DamienCassou ];
    };
  };

  clepy = buildPythonPackage rec {
    name = "clepy-0.3.20";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/c/clepy/${name}.tar.gz";
      sha256 = "16vibfxms5z4ld8gbkra6dkhqm2cc3jnn0fwp7mw70nlwxnmm51c";
    };

    buildInputs = with self; [ self.mock self.nose self.decorator ];

    meta = {
      homepage = http://code.google.com/p/clepy/;
      description = "Utilities created by the Cleveland Python users group";
    };
  };


  clientform = buildPythonPackage (rec {
    name = "clientform-0.2.10";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/C/ClientForm/ClientForm-0.2.10.tar.gz";
      sha256 = "0dydh3i1sx7rrj6d0gj375wkjpiivm7jjlsimw6hmwv4ck7yf1wm";
    };

    meta = {
      homepage = http://wwwsearch.sourceforge.net/ClientForm/;

      license = "bsd";

      description = "Python module for handling HTML forms on the client side";
    };
  });

  cloudpickle = buildPythonPackage rec {
    name = "cloudpickle-${version}";
    version = "0.1.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/c/cloudpickle/${name}.tar.gz";
      sha256 = "3418303f44c6c4daa184f1dc36c8c0b7ff8261c56d1f922ffd8d09e79caa4b74";
    };

    buildInputs = with self; [ pytest mock ];

    checkPhase = ''
      py.test tests
    '';

    # ImportError of test suite
    doCheck = false;

    meta = {
      description = "Extended pickling support for Python objects";
      homepage = https://github.com/cloudpipe/cloudpickle;
      license = with licenses; [ bsd3 ];
    };
  };


  cogapp = buildPythonPackage rec {
    version = "2.3";
    name    = "cogapp-${version}";

    src = pkgs.fetchurl {
      url    = "https://pypi.python.org/packages/source/c/cogapp/${name}.tar.gz";
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


  colorama = buildPythonPackage rec {
    name = "colorama-${version}";
    version = "0.3.3";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/c/colorama/${name}.tar.gz";
      sha256 = "eb21f2ba718fbf357afdfdf6f641ab393901c7ca8d9f37edd0bee4806ffa269c";
    };

    meta = {
      homepage = https://github.com/tartley/colorama;
      license = "bsd";
      description = "Cross-platform colored terminal text";
    };
  };


  CommonMark = buildPythonPackage rec {
    name = "CommonMark-${version}";
    version = "0.6.3";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/C/CommonMark/${name}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/C/CommonMark/${name}.tar.gz";
      sha256 = "34d73ec8085923c023930dfc0bcd1c4286e28a2a82de094bb72fabcc0281cbe5";
    };
  };


  coilmq = buildPythonPackage (rec {
    name = "coilmq-0.6.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/C/CoilMQ/CoilMQ-0.6.1.tar.gz";
      sha256 = "9755733bdae33a9d87630232d166a7da2382f68c2cffb3bb81503806e8d310cb";
    };

    propagatedBuildInputs = with self; [ self.stompclient ];

    preConfigure = ''
      sed -i '/distribute/d' setup.py
    '';

    buildInputs = with self; [ self.coverage self.sqlalchemy7 ];

    # ValueError: Could not parse auth file:
    # /tmp/nix-build-.../CoilMQ-0.6.1/coilmq/tests/resources/auth.ini
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
      url = "http://pypi.python.org/packages/source/c/colander/${name}.tar.gz";
      sha256 = "7389413266b9e680c9529c16d56284edf87e0d5de557948e75f41d65683c23b3";
    };

    propagatedBuildInputs = with self; [ self.translationstring self.iso8601 ];

    meta = {
      maintainers = with maintainers; [ garbas iElectric ];
      platforms = platforms.all;
    };
  };

  # Backported version of the ConfigParser library of Python 3.3
  configparser = if isPy3k then null else buildPythonPackage rec {
    name = "configparser-${version}";
    version = "3.3.0r2";

    # running install_egg_info
    # error: [Errno 9] Bad file descriptor: '<stdout>'
    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/c/configparser/${name}.tar.gz";
      sha256 = "6a2318590dfc4013fc5bf53c2bec14a8cb455a232295eb282a13f94786c4b0b2";
    };

    meta = {
      maintainers = [ ];
      platforms = platforms.all;
    };
  };


  ColanderAlchemy = buildPythonPackage rec {
    name = "ColanderAlchemy-0.2.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/C/ColanderAlchemy/${name}.tar.gz";
      sha256 = "d10e97b5f4648dcdc38c5e5c9f9b77fe39c8fa7f594d89d558b0d82e5631bfd7";
    };

    buildInputs = with self; [ unittest2 ];
    propagatedBuildInputs = with self; [ colander sqlalchemy9 ];

    # string: argument name cannot be overridden via info kwarg.
    doCheck = false;

    meta = {
      description = "Autogenerate Colander schemas based on SQLAlchemy models";
      homepage = https://github.com/stefanofontanelli/ColanderAlchemy;
      license = licenses.mit;
    };
  };


  configobj = buildPythonPackage (rec {
    name = "configobj-5.0.6";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/c/configobj/${name}.tar.gz";
      sha256 = "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902";
    };

    # error: invalid command 'test'
    doCheck = false;

    propagatedBuildInputs = with self; [ six ];

    meta = {
      description = "Config file reading, writing and validation";
      homepage = http://pypi.python.org/pypi/configobj;
      license = licenses.bsd3;
      maintainers = with maintainers; [ garbas ];
    };
  });


  configshell_fb = buildPythonPackage rec {
    version = "1.1.fb10";
    name = "configshell-fb-${version}";

    src = pkgs.fetchurl {
      url = "https://github.com/agrover/configshell-fb/archive/v${version}.tar.gz";
      sha256 = "1dd87xvm98nk3jzybb041gjdahi2z9b53pwqhyxcfj4a91y82ndy";
    };

    propagatedBuildInputs = with self; [
      pyparsing
      modules.readline
      urwid
    ];

    meta = {
      description = "A Python library for building configuration shells";
      homepage = "https://github.com/agrover/configshell-fb";
      platforms = platforms.linux;
    };
  };


  construct = buildPythonPackage rec {
    name = "construct-2.5.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/c/construct/${name}.tar.gz";
      sha256 = "084h02p0m8lhmlywlwjdg0kd0hd6sz481c96qwcm5wddxrqn4nv6";
    };

    propagatedBuildInputs = with self; [ six ];

    meta = {
      description = "Powerful declarative parser (and builder) for binary data";
      homepage = http://construct.readthedocs.org/;
      license = licenses.mit;
      platforms = platforms.linux;
      maintainers = with maintainers; [ bjornfor ];
    };
  };


  consul = buildPythonPackage (rec {
    name = "python-consul-0.6.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/python-consul/${name}.tar.gz";
      sha256 = "0vfyr499sbc4nnhhijp2lznyj507nnak95bvv9w8y78ngxggskbh";
    };

    buildInputs = with self; [ requests2 six pytest ];

    meta = {
      description = "Python client for Consul (http://www.consul.io/)";
      homepage = https://github.com/cablehead/python-consul;
      license = licenses.mit;
      maintainers = with maintainers; [ desiderius ];
    };
  });


  contextlib2 = buildPythonPackage rec {
    name = "contextlib2-0.4.0";

    src = pkgs.fetchurl rec {
      url = "https://pypi.python.org/packages/source/c/contextlib2/${name}.tar.gz";
      sha256 = "55a5dc78f7a742a0e756645134ffb39bbe11da0fea2bc0f7070d40dac208b732";
    };
  };

  cookiecutter = buildPythonPackage rec {
    version = "1.3.0";
    name = "cookiecutter-${version}";

    # dependency problems, next release of cookiecutter should unblock these
    disabled = isPy3k || isPyPy;

    src = pkgs.fetchurl {
      url = "https://github.com/audreyr/cookiecutter/archive/${version}.tar.gz";
      sha256 = "1vchjvh7591nczz2zz55aghk9mhpm6kqgm62d05d4mjrx9xjkdcg";
    };

    buildInputs = with self; [ itsdangerous  ];
    propagatedBuildInputs = with self; [
          jinja2 future binaryornot click whichcraft ruamel_yaml ];

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
      url = "https://pypi.python.org/packages/source/c/cookies/${name}.tar.gz";
      sha256 = "13pfndz8vbk4p2a44cfbjsypjarkrall71pgc97glk5fiiw9idnn";
    };

    doCheck = false;

    meta = {
      description = "Friendlier RFC 6265-compliant cookie parser/renderer";
      homepage = https://github.com/sashahart/cookies;
      license = licenses.mit;
    };
  };

  coverage = buildPythonPackage rec {
    name = "coverage-4.0.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/c/coverage/${name}.tar.gz";
      sha256 = "0nrd817pzjw1haaz6gambgwf4jdjnh9kyxkgj6l8qgl6hdxga45w";
    };

    # TypeError: __call__() takes 1 positional argument but 2 were given
    doCheck = !isPy3k;
    buildInputs = with self; [ mock ];

    meta = {
      description = "Code coverage measurement for python";
      homepage = http://nedbatchelder.com/code/coverage/;
      license = licenses.bsd3;
    };
  };

  covCore = buildPythonPackage rec {
    name = "cov-core-1.15.0";
    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/c/cov-core/${name}.tar.gz";
      sha256 = "4a14c67d520fda9d42b0da6134638578caae1d374b9bb462d8de00587dba764c";
    };
    meta = {
      description = "plugin core for use by pytest-cov, nose-cov and nose2-cov";
    };
    propagatedBuildInputs = with self; [ self.coverage ];
  };

  crcmod = buildPythonPackage rec {
    name = "crcmod-1.7";
    src = pkgs.fetchurl {
      url = https://pypi.python.org/packages/source/c/crcmod/crcmod-1.7.tar.gz;
      sha256 = "07k0hgr42vw2j92cln3klxka81f33knd7459cn3d8aszvfh52w6w";
    };
    meta = {
      description = "Python module for generating objects that compute the Cyclic Redundancy Check (CRC)";
      homepage = http://crcmod.sourceforge.net/;
      license = licenses.mit;
    };
  };

  cython = buildPythonPackage rec {
    name = "Cython-${version}";
    version = "0.23.4";

    src = pkgs.fetchurl {
      url = "http://www.cython.org/release/${name}.tar.gz";
      sha256 = "13hdffhd37mx3gjby018xl179jaj957fy7kzi01crmimxvn2zi7y";
    };

    buildInputs = with self; [ pkgs.pkgconfig pkgs.gdb ];

    checkPhase = ''
      ${python.interpreter} runtests.py
    '';

    doCheck = false; # Lots of weird compiler errors

    meta = {
      description = "An optimising static compiler for both the Python programming language and the extended Cython programming language";
      platforms = platforms.all;
      homepage = http://cython.org;
      license = licenses.asl20;
      maintainers = with maintainers; [ fridh ];
    };
  };

  cytoolz = buildPythonPackage rec {
    name = "cytoolz-${version}";
    version = "0.7.4";

    src = pkgs.fetchurl{
      url = "https://pypi.python.org/packages/source/c/cytoolz/cytoolz-${version}.tar.gz";
      sha256 = "9c2e3dda8232b6cd5b84b8c8df6c8155c2adeb8734eb7ec38e189affc0f2eba5";
    };

    # Extension types
    disabled = isPyPy;

    buildInputs = with self; [ nose ];

    checkPhase = ''
      nosetests -v $out/${python.sitePackages}
    '';

    # Several tests fail with Python 3.5
    # https://github.com/pytoolz/cytoolz/issues/73
    doCheck = !isPy35;

    meta = {
      homepage = "http://github.com/pytoolz/cytoolz/";
      description = "Cython implementation of Toolz: High performance functional utilities";
      license = "licenses.bsd3";
      maintainers = with maintainers; [ fridh ];
    };
  };

  cryptacular = buildPythonPackage rec {
    name = "cryptacular-1.4.1";

    buildInputs = with self; [ coverage nose ];
    propagatedBuildInputs = with self; [ pbkdf2 modules.crypt ];

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/c/cryptacular/${name}.tar.gz";
      sha256 = "273f03d03f9b316671ae4f1c1c6b8d3c883da19a5706873e8f3d6543e13dd4a1";
    };

    # TODO: tests fail: TypeError: object of type 'NoneType' has no len()
    doCheck = false;

    meta = {
      maintainers = with maintainers; [ iElectric ];
    };
  };

  cryptography = buildPythonPackage rec {
    # also bump cryptography_vectors
    name = "cryptography-1.1.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/c/cryptography/${name}.tar.gz";
      sha256 = "1q5snbnn2am85zb5jrnxwzncl4kwa11740ws8g9b4ps5ywx944i9";
    };

    buildInputs = [ pkgs.openssl self.pretend self.cryptography_vectors
                    self.iso8601 self.pyasn1 self.pytest self.py self.hypothesis1 ]
               ++ optional stdenv.isDarwin pkgs.darwin.apple_sdk.frameworks.Security;
    propagatedBuildInputs = with self; [ six idna ipaddress pyasn1 cffi pyasn1-modules modules.sqlite3 ]
     ++ optional (pythonOlder "3.4") self.enum34;

    # IOKit's dependencies are inconsistent between OSX versions, so this is the best we
    # can do until nix 1.11's release
    __impureHostDeps = [ "/usr/lib" ];
  };

  cryptography_vectors = buildPythonPackage rec {
      # also bump cryptography
    name = "cryptography_vectors-1.1.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/c/cryptography-vectors/${name}.tar.gz";
      sha256 = "17gi301p3wi39dr4dhrmpfflid3k004jp9cnvdp46b7p5lm6hb3w";
    };
  };

  oslo-vmware = buildPythonPackage rec {
    name = "oslo.vmware-${version}";
    version = "1.22.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/o/oslo.vmware/${name}.tar.gz";
      sha256 = "1119q3x2y3hjz3p784byr13aqay75pbj4cb8v43gjq5piqlpp16x";
    };

    propagatedBuildInputs = with self; [
      pbr stevedore netaddr iso8601 six oslo-i18n oslo-utils Babel pyyaml eventlet
      requests2 urllib3 oslo-concurrency suds-jurko
    ];
    buildInputs = with self; [
      bandit oslosphinx coverage testtools testscenarios testrepository mock

    ];
  };

  barbicanclient = buildPythonPackage rec {
    name = "barbicanclient-${version}";
    version = "3.3.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/python-barbicanclient/python-barbicanclient-${version}.tar.gz";
      sha256 = "1kxnxiijvkkc8ahlfbkslpzxcbah7y5pi86hvkyac62xzda87inm";
    };

    propagatedBuildInputs = with self; [
      pbr argparse requests2 six keystoneclient cliff oslo-i18n oslo-serialization
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
      url = "https://pypi.python.org/packages/source/p/python-ironicclient/python-ironicclient-${version}.tar.gz";
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
      Babel argparse prettytable requests2 simplejson six iso8601
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
      url = "https://pypi.python.org/packages/source/t/tablib/tablib-${version}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/c/cliff-tablib/cliff-tablib-${version}.tar.gz";
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

  openstackclient = buildPythonPackage rec {
    name = "openstackclient-${version}";
    version = "1.7.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/python-openstackclient/python-openstackclient-${version}.tar.gz";
      sha256 = "0h1jkrwx06l32k50zq5gs9iba132q2x2jjb3z5gkxxlcd3apk8y9";
    };

    propagatedBuildInputs = with self; [
     pbr six Babel cliff os-client-config oslo-config oslo-i18n oslo-utils
     glanceclient keystoneclient novaclient cinderclient neutronclient requests2
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
    name = "idna-2.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/i/idna/${name}.tar.gz";
      sha256 = "0frxgmgi234lr9hylg62j69j4ik5zhg0wz05w5dhyacbjfnrl68n";
    };

    meta = {
      homepage = "http://github.com/kjd/idna/";
      description = "Internationalized Domain Names in Applications (IDNA)";
      license = "licenses.bsd3";
    };
  };

  mahotas = buildPythonPackage rec {
    name = "python-mahotas-${version}";
    version = "1.4.1";

    src = pkgs.fetchurl {
      url = "https://github.com/luispedro/mahotas/archive/release-${version}.tar.gz";
      sha256 = "a684d339a3a4135f6f7161851161174755e9ea643b856b0bb48abd5515041ab6";
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
      homepage = https://readthedocs.org/projects/mahotas/;
      maintainers = with maintainers; [ luispedro ];
      license = licenses.mit;
      platforms = platforms.linux;
    };
  };

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


  pkginfo = buildPythonPackage rec {
    version = "1.2.1";
    name = "pkginfo-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pkginfo/${name}.tar.gz";
      sha256 = "0g0g6avplfqw1adzqybbrh1a2z0kfjl8qn3annkrc7w3ibz6sgxd";
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
      url = "https://pypi.python.org/packages/source/p/pretend/pretend-1.0.8.tar.gz";
      sha256 = "0r5r7ygz9m6d2bklflbl84cqhjkc2q12xgis8268ygjh30g2q3wk";
    };

    meta = {
      homepage = https://github.com/alex/pretend;
      license = licenses.bsd3;
    };
  };


  detox = self.buildPythonPackage rec {
    name = "detox-0.9.3";

    propagatedBuildInputs = with self; [ tox py eventlet ];

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/detox/detox-0.9.3.tar.gz";
      sha256 = "39d48b6758c43ba579f694507d54da96931195eb1b72ad79b46f50af9520b2f3";
    };

    meta = {
      description = "What is detox?";
      homepage = http://bitbucket.org/hpk42/detox;
    };
  };


  pbkdf2 = buildPythonPackage rec {
    name = "pbkdf2-1.3";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pbkdf2/${name}.tar.gz";
      sha256 = "ac6397369f128212c43064a2b4878038dab78dab41875364554aaf2a684e6979";
    };

    # ImportError: No module named test
    doCheck = false;

    meta = {
      maintainers = with maintainers; [ iElectric ];
    };
  };

  bcrypt = buildPythonPackage rec {
    name = "bcrypt-2.0.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/b/bcrypt/${name}.tar.gz";
      sha256 = "8b2d197ef220d10eb74625dde7af3b10daa973ae9a1eadd6366f763fad4387fa";
    };

    buildInputs = with self; [ pycparser mock pytest py ] ++ optionals (!isPyPy) [ cffi ];

    meta = {
      maintainers = with maintainers; [ iElectric ];
      description = "Modern password hashing for your software and your servers";
      license = licenses.asl20;
      homepage = https://github.com/pyca/bcrypt/;
    };
  };

  cffi = if isPyPy then null else buildPythonPackage rec {
    name = "cffi-1.3.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/c/cffi/${name}.tar.gz";
      sha256 = "1s9lcwmyhshrmvgcwy0vww70v23ncz7bgshhbk469kxmy2pm7alx";
    };

    propagatedBuildInputs = with self; [ pkgs.libffi pycparser ];
    buildInputs = with self; [ pytest ];

    meta = {
      maintainers = with maintainers; [ iElectric ];
    };
  };

  pycollada = buildPythonPackage rec {
    name = "pycollada-0.4.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pycollada/${name}.tar.gz";
      sha256 = "0i50lh98550pwr95zgzrgiqzsspm09wl52xlv83y5nrsz4mblylv";
    };

    buildInputs = with self; [ numpy ] ++ (if isPy3k then [dateutil] else [dateutil_1_5]);

    # Some tests fail because they refer to test data files that don't exist
    # (upstream packaging issue)
    doCheck = false;

    meta = {
      description = "Python library for reading and writing collada documents";
      homepage = http://pycollada.github.io/;
      license = "BSD"; # they don't specify which BSD variant
      platforms = with platforms; linux ++ darwin;
      maintainers = with maintainers; [ bjornfor ];
    };
  };

  pycontracts = buildPythonPackage rec {
    version = "1.7.9";
    name = "PyContracts-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/P/PyContracts/${name}.tar.gz";
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
      url = "http://pypi.python.org/packages/source/p/pycparser/${name}.tar.gz";
      sha256 = "7959b4a74abdc27b312fed1c21e6caf9309ce0b29ea86b591fd2e99ecdf27f73";
    };

    # 3.5 is not supported but has been working fine
    doCheck = !isPy35;

    meta = {
      description = "C parser in Python";
      homepage = https://github.com/eliben/pycparser;
      license = licenses.bsd3;
      maintainers = with maintainers; [ iElectric ];
    };
  };

  pytest = buildPythonPackage rec {
    name = "pytest-2.7.3";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pytest/${name}.tar.gz";
      sha256 = "1z4yi986f9n0p8qmzmn21m21m8j1x78hk3505f89baqm6pdw7afm";
    };

    preCheck = ''
      # don't test bash builtins
      rm testing/test_argcomplete.py
    '';

    propagatedBuildInputs = with self; [ py ]
      ++ (optional isPy26 argparse)
      ++ stdenv.lib.optional
        pkgs.config.pythonPackages.pytest.selenium or false
        self.selenium;

    meta = {
      maintainers = with maintainers; [ iElectric lovek323 madjar ];
      platforms = platforms.unix;
    };
  };

  pytest_28 = self.pytest.override rec {
    name = "pytest-2.8.6";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pytest/${name}.tar.gz";
      sha256 = "ed38a3725b8e4478555dfdb549a4219ca3ba57955751141a1aaa45b706d84194";
    };
  };

  pytestcache = buildPythonPackage rec {
    name = "pytest-cache-1.0";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pytest-cache/pytest-cache-1.0.tar.gz";
      sha256 = "1a873fihw4rhshc722j4h6j7g3nj7xpgsna9hhg3zn6ksknnhx5y";
    };

    propagatedBuildInputs = with self ; [ pytest execnet ];

    meta = {
      license = licenses.mit;
      website = "https://pypi.python.org/pypi/pytest-cache/";
      description = "pytest plugin with mechanisms for caching across test runs";
    };
  };

  pytestflakes = buildPythonPackage rec {
    name = "pytest-flakes-${version}";
    version = "1.0.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pytest-flakes/${name}.tar.gz";
      sha256 = "0vvfprga6k4v2zq1qsr3yq1bjl22vygfsnvyn3hh80cc2386dk6h";
    };

    propagatedBuildInputs = with self ; [ pytest pyflakes pytestcache ];

    meta = {
      license = licenses.mit;
      website = "https://pypi.python.org/pypi/pytest-flakes";
      description = "pytest plugin to check source code with pyflakes";
    };
  };

  pytestpep8 = buildPythonPackage rec {
    name = "pytest-pep8";
    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pytest-pep8/pytest-pep8-1.0.6.tar.gz";
      sha256 = "06032agzhw1i9d9qlhfblnl3dw5hcyxhagn7b120zhrszbjzfbh3";
    };

    propagatedBuildInputs = with self ; [ pytest pytestcache pep8 ];

    meta = {
      license = licenses.mit;
      website = "https://pypi.python.org/pypi/pytest-pep8";
      description = "pytest plugin to check PEP8 requirements";
    };
  };

  pytestpep257 = buildPythonPackage rec {
     name = "pytest-pep257-${version}";
     version = "0.0.1";

     src = pkgs.fetchurl {
       url = "https://pypi.python.org/packages/source/p/pytest-pep257/${name}.tar.gz";
       sha256 = "003vdkxpx37n0kjqpwgj3314hwk2jfz3nz58db7xh68bf8xy75lk";
     };

     propagatedBuildInputs = with self ; [ pytest pep257 ];

     meta = {
       homepage = https://github.com/anderslime/pytest-pep257;
       description = "py.test plugin for PEP257";
       license = licenses.mit;
     };
  };

  pytest-raisesregexp = buildPythonPackage rec {
    name = "pytest-raisesregexp-${version}";
    version = "2.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pytest-raisesregexp/${name}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/p/pytest-runner/${name}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/p/pytest-quickcheck/pytest-quickcheck-0.8.2.tar.gz";
      sha256 = "047w4zwdsnlzmsc5f3rapzbzd2frlvz9nnp8v4b48fjmqmxassh3";
    };

    propagatedBuildInputs = with self ; [ pytest pytestflakes pytestpep8 tox ];

    meta = {
      license = licenses.asl20;
      website = "https://pypi.python.org/pypi/pytest-quickcheck";
      description = "pytest plugin to generate random data inspired by QuickCheck";
    };
  };

  pytestcov = buildPythonPackage (rec {
    name = "pytest-cov-2.2.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pytest-cov/${name}.tar.gz";
      sha256 = "1lf9jsmhqk5nc4w3kzwglmdzjvmi7ajvrsnwv826j3bn0wzx8c92";
    };

   buildInputs = with self; [ covCore pytest ];

    meta = {
      description = "plugin for coverage reporting with support for both centralised and distributed testing, including subprocesses and multiprocessing";
      homepage = https://github.com/schlamar/pytest-cov;
      license = licenses.mit;
    };
  });

  pytest_xdist = buildPythonPackage rec {
    name = "pytest-xdist-1.8";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pytest-xdist/pytest-xdist-1.8.zip";
      sha256 = "b02135db7080c0978b7ce5d8f43a5879231441c2062a4791bc42b6f98c94fa69";
    };

    buildInputs = with self; [ pytest ];
    propagatedBuildInputs = with self; [ execnet ];

    meta = {
      description = "py.test xdist plugin for distributed testing and loop-on-failing modes";
      homepage = http://bitbucket.org/hpk42/pytest-xdist;
    };
  };

  pytest-localserver = buildPythonPackage rec {
    name = "pytest-localserver-${version}";
    version = "0.3.5";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pytest-localserver/${name}.tar.gz";
      sha256 = "0dvqspjr6va55zwmnnc2mmpqc7mm65kxig9ya44x1z8aadzxpa4p";
    };

    propagatedBuildInputs = with self; [ werkzeug ];
    buildInputs = with self; [ pytest six requests2 ];

    checkPhase = ''
      py.test
    '';

    meta = {
      description = "Plugin for the pytest testing framework to test server connections locally";
      homepage = https://pypi.python.org/pypi/pytest-localserver;
      license = licenses.mit;
    };
  };

  pytest-subtesthack = buildPythonPackage rec {
    name = "pytest-subtesthack-${version}";
    version = "0.1.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pytest-subtesthack/${name}.tar.gz";
      sha256 = "15kzcr5pchf3id4ikdvlv752rc0j4d912n589l4rifp8qsj19l1x";
    };

    propagatedBuildInputs = with self; [ pytest ];

    # no upstream test
    doCheck = false;

    meta = {
      description = "Terrible plugin to set up and tear down fixtures within the test function itself";
      homepage = https://github.com/untitaker/pytest-subtesthack;
      license = licenses.publicDomain;
    };
  };

  tinycss = buildPythonPackage rec {
    name = "tinycss-${version}";
    version = "0.3";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/t/tinycss/${name}.tar.gz";
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
      description = "complete yet simple CSS parser for Python";
      license = licenses.bsd3;
      homepage = http://pythonhosted.org/tinycss/;
    };
  };


  cssselect = buildPythonPackage rec {
    name = "cssselect-${version}";
    version = "0.9.1";
    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/c/cssselect/${name}.tar.gz";
      sha256 = "10h623qnp6dp1191jri7lvgmnd4yfkl36k9smqklp1qlf3iafd85";
    };
    # AttributeError: 'module' object has no attribute 'tests'
    doCheck = false;
  };

  cssutils = buildPythonPackage (rec {
    name = "cssutils-0.9.9";

    src = pkgs.fetchurl {
      url = http://pypi.python.org/packages/source/c/cssutils/cssutils-0.9.9.zip;
      sha256 = "139yfm9yz9k33kgqw4khsljs10rkhhxyywbq9i82bh2r31cil1pp";
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
      url = "http://pypi.python.org/packages/source/d/darcsver/${name}.tar.gz";
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

      homepage = http://pypi.python.org/pypi/darcsver;

      license = "BSD-style";
    };
  });

  dask = buildPythonPackage rec {
    name = "dask-${version}";
    version = "0.7.6";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/dask/${name}.tar.gz";
      sha256 = "ff27419e059715907afefe6cbcc1f8c748855c7a93be25be211dabcb689cee3b";
    };

    buildInputs = with self; [ pytest ];
    propagatedBuildInputs = with self; [numpy toolz dill pandas ];

    checkPhase = ''
      py.test dask
    '';

    # Segfault, likely in numpy
    doCheck = false;

    meta = {
      description = "Minimal task scheduling abstraction";
      homepage = "http://github.com/ContinuumIO/dask/";
      license = licenses.bsd3;
      maintainers = with maintainers; [ fridh ];
    };
  };

  datashape = buildPythonPackage rec {
    name = "datashape-${version}";
    version = "0.5.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/D/DataShape/${name}.tar.gz";
      sha256 = "21c424f11604873da9a36d4c55ef1d15cc3960cd208d7828b82315c494bff96a";
    };

    buildInputs = with self; [ pytest mock ];
    propagatedBuildInputs = with self; [ numpy multipledispatch dateutil ];

    checkPhase = ''
      py.test datashape/tests
    '';

    meta = {
      homepage = https://github.com/ContinuumIO/datashape;
      description = "A data description language";
      license = licenses.bsd2;
      maintainers = with maintainers; [ fridh ];
    };
  };

  requests-cache = buildPythonPackage (rec {
    name = "requests-cache-${version}";
    version = "0.4.10";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/r/requests-cache/${name}.tar.gz";
      sha256 = "671969d00719fa3e80476b128dc9232025926884d0110d4d235abdd9c3508fc0";
    };

    buildInputs = with self; [ mock sqlite3 ];

    propagatedBuildInputs = with self; [ self.six requests2 ];

    meta = {
      description = "Persistent cache for requests library";
      homepage = http://pypi.python.org/pypi/requests-cache;
      license = licenses.bsd3;
    };
  });

  howdoi = buildPythonPackage (rec {
    name = "howdoi-${version}";
    version = "1.1.7";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/h/howdoi/${name}.tar.gz";
      sha256 = "df4e49a219872324875d588e7699a1a82174a267e8487505e86bfcb180aea9b7";
    };

    propagatedBuildInputs = with self; [ self.six requests-cache pygments pyquery ];

    meta = {
      description = "Instant coding answers via the command line";
      homepage = http://pypi.python.org/pypi/howdoi;
      license = licenses.mit;
    };
  });

  nose-parameterized = buildPythonPackage (rec {
    name = "nose-parameterized-${version}";
    version = "0.5.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/n/nose-parameterized/${name}.tar.gz";
      sha256 = "a11c41b0cf8218e7cdc19ab7a1bdf5c141d161cd2350daee819473cc63cd0685";
    };

    disabled = !isPy3k;

    LC_ALL = "en_US.UTF-8";
    buildInputs = with self; [ nose pkgs.glibcLocales ];
    propagatedBuildInputs = with self; [ self.six ];

    checkPhase = ''
      nosetests -v
    '';


    meta = {
      description = "Parameterized testing with any Python test framework";
      homepage = http://pypi.python.org/pypi/nose-parameterized;
      license = licenses.bsd3;
    };
  });

  jdatetime = buildPythonPackage (rec {
    name = "jdatetime-${version}";
    version = "1.7.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/j/jdatetime/${name}.tar.gz";
      sha256 = "c08ba5791c2350b26e87ddf478bf223108146e241b6c949538221b54afd633ac";
    };

    propagatedBuildInputs = with self; [ self.six ];

    meta = {
      description = "Jalali datetime binding for python";
      homepage = http://pypi.python.org/pypi/jdatetime;
      license = licenses.psfl;
    };
  });

  dateparser = buildPythonPackage rec {
    name = "dateparser-${version}";
    version = "0.3.2-pre-2016-01-21"; # Fix assert year 2016 == 2015

    src = pkgs.fetchgit {
      url = "https://github.com/scrapinghub/dateparser.git";
      rev = "d20a63f1d1cee5b4bd19c9f745774cfa9f219549";
      sha256 = "f04f75d013ba2896681ffeb3669d78e4c496236121da751b89ff0b4a4053f771";
    };

    # Does not seem to work on Python 3 because of relative import.
    # Upstream Travis configuration is wrong and tests only 2.7
    disabled = isPy3k;

    LC_ALL = "en_US.UTF-8";

    buildInputs = with self; [ nose nose-parameterized mock pkgs.glibcLocales ];

    propagatedBuildInputs = with self; [ six jdatetime pyyaml dateutil umalqurra pytz ];

    meta = {
      description = "Date parsing library designed to parse dates from HTML pages";
      homepage = http://pypi.python.org/pypi/dateparser;
      license = licenses.bsd3;
    };
  };

  dateutil = buildPythonPackage (rec {
    name = "dateutil-${version}";
    version = "2.4.2";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/python-dateutil/python-${name}.tar.gz";
      sha256 = "3e95445c1db500a344079a47b171c45ef18f57d188dffdb0e4165c71bea8eb3d";
    };

    propagatedBuildInputs = with self; [ self.six ];

    meta = {
      description = "Powerful extensions to the standard datetime module";
      homepage = http://pypi.python.org/pypi/python-dateutil;
      license = "BSD-style";
    };
  });

  # Buildbot 0.8.7p1 needs dateutil==1.5
  dateutil_1_5 = buildPythonPackage (rec {
    name = "dateutil-1.5";

    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/python-dateutil/python-${name}.tar.gz";
      sha256 = "02dhw57jf5kjcp7ng1if7vdrbnlpb9yjmz7wygwwvf3gni4766bg";
    };

    propagatedBuildInputs = with self; [ self.six ];

    meta = {
      description = "Powerful extensions to the standard datetime module";
      homepage = http://pypi.python.org/pypi/python-dateutil;
      license = "BSD-style";
    };
  });

  # flexget requires 2.1
  dateutil_2_1 = buildPythonPackage (rec {
    name = "dateutil-2.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/python-dateutil/python-${name}.tar.gz";
      sha256 = "1vlx0lpsxjxz64pz87csx800cwfqznjyr2y7nk3vhmzhkwzyqi2c";
    };

    propagatedBuildInputs = with self; [ self.six ];

    buildInputs = [ pkgs.glibcLocales ];

    LC_ALL="en_US.UTF-8";

    meta = {
      description = "Powerful extensions to the standard datetime module";
      homepage = http://pypi.python.org/pypi/python-dateutil;
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

    propagatedBuildInputs = with self; [ protobuf modules.sqlite3 ];

    meta = {
      description = "Unix de-duplicating archiver";
      license = licenses.gpl3;
      homepage = https://github.com/basak/ddar;
    };
  };

  decorator = buildPythonPackage rec {
    name = "decorator-${version}";
    version = "4.0.6";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/d/decorator/${name}.tar.gz";
      sha256 = "1c6254597777fd003da2e8fb503c3dbf3d9e8f8d55f054709c0e65be3467209c";
    };

    meta = {
      homepage = http://pypi.python.org/pypi/decorator;
      description = "Better living through Python with decorators";
      license = licenses.mit;
    };
  };

  deform = buildPythonPackage rec {
    name = "deform-2.0a2";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/d/deform/${name}.tar.gz";
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
      maintainers = with maintainers; [ garbas iElectric ];
      platforms = platforms.all;
    };
  };

  deform2 = buildPythonPackage rec {
    name = "deform-2.0a2";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/d/deform/${name}.tar.gz";
      sha256 = "1gfaf1d8zp0mp4h229srlffxdp86w1nni9g4aqsshxysr23x591z";
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
      maintainers = with maintainers; [ garbas iElectric ];
      platforms = platforms.all;
    };
  };


  deform_bootstrap = buildPythonPackage rec {
    name = "deform_bootstrap-0.2.9";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/d/deform_bootstrap/${name}.tar.gz";
      sha256 = "1hgq3vqsfqdmlyahnlc40w13viawhpzqf4jzigsggdb41x545fda";
    };

    buildInputs = [ self.mock ];
    propagatedBuildInputs = with self; [ deform pyramid ];

    # demo is removed as it depends on deformdemo
    patchPhase = ''
      rm -rf deform_bootstrap/demo
    '';

    meta = {
      maintainers = with maintainers; [ iElectric ];
      platforms = platforms.all;
    };
  };


  demjson = buildPythonPackage rec {
    name = "demjson-1.6";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/demjson/${name}.tar.gz";
      sha256 = "0abf7wqqq7rk1sycy47ayn5p93yy7gjq50cb2z69wmik1qqrr60x";
    };

    doCheck = false; # there are no tests

    preFixup = ''
      mkdir -p "$out/bin"
      cp jsonlint "$out/bin/"
    '';

    meta = {
      description = "Encoder/decoder and lint/validator for JSON (JavaScript Object Notation)";
      homepage = http://deron.meranda.us/python/demjson/;
      license = licenses.lgpl3Plus;
      maintainers = with maintainers; [ bjornfor ];
      platforms = platforms.all;
    };
  };

  derpconf = self.buildPythonPackage rec {
    name = "derpconf-0.4.9";

    propagatedBuildInputs = with self; [ six ];

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/derpconf/${name}.tar.gz";
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
      description = "integrates an Android device into a desktop";
      homepage = https://github.com/screenfreeze/deskcon-desktop;
      license = licenses.gpl3;
    };
  };


  dill = buildPythonPackage rec {
    name = "dill-${version}";
    version = "0.2.4";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/dill/${name}.tgz";
      sha256 = "deca57da33ad2121ab1b9c4493bf8eb2b3a72b6426d4b9a3a853a073c68b97ca";
    };

    propagatedBuildInputs = with self; [objgraph];

    # failing tests
    doCheck = false;

    meta = {
      description = "Serialize all of python (almost)";
      homepage = http://www.cacr.caltech.edu/~mmckerns/dill.htm;
      license = licenses.bsd3;
    };
  };

  discogs_client = buildPythonPackage rec {
    name = "discogs-client-2.0.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/discogs-client/${name}.tar.gz";
      sha256 = "0a3616a818dd9fa61a61c3d9731d176e9123130d1b1b97a6beee63b4c72306b7";
    };

    propagatedBuildInputs = with self; [ oauth2 requests2 ];

    meta = {
      description = "Official Python API client for Discogs";
      license = licenses.bsd2;
      homepage = "https://github.com/discogs/discogs_client";
    };
  };

  dns = buildPythonPackage rec {
    name = "dnspython-${version}";
    version = "1.12.0";

    src = if isPy3k then pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/dnspython3/dnspython3-${version}.zip";
      sha256 = "138wxj702vx6zni9g2y8dbgbpin95v6hk23rh2kwfr3q4130jqz9";
    } else pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/dnspython/${name}.tar.gz";
      sha256 = "0kvjlkp96qzh3j31szpjlzqbp02brixh4j4clnpw80b0hspq5yq3";
    };

    meta = {
      description = "A DNS toolkit for Python 3.x";
      homepage = http://www.dnspython.org;
      # BSD-like, check http://www.dnspython.org/LICENSE for details
      license = licenses.free;
    };
  };

  docker = buildPythonPackage rec {
    name = "docker-py-1.5.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/docker-py/${name}.tar.gz";
      sha256 = "1l7q0179y4lmv24z4q12653141wc1b1zzgbfw46yzbs6mj7i4939";
    };

    propagatedBuildInputs = with self; [ six requests2 websocket_client ];

    # Version conflict
    doCheck = false;

    meta = {
      description = "An API client for docker written in Python";
      homepage = https://github.com/docker/docker-py;
      license = licenses.asl20;
    };
  };

  dockerpty = buildPythonPackage rec {
    name = "dockerpty-0.3.4";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/dockerpty/${name}.tar.gz";
      sha256 = "a51044cc49089a2408fdf6769a63eebe0b16d91f34716ecee681984446ce467d";
    };

    propagatedBuildInputs = with self; [ six ];

    meta = {
      description = "Functionality needed to operate the pseudo-tty (PTY) allocated to a docker container";
      homepage = https://github.com/d11wtq/dockerpty;
      license = licenses.asl20;
    };
  };

  docker_registry_core = buildPythonPackage rec {
    name = "docker-registry-core-2.0.3";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/docker-registry-core/${name}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/d/docker-registry/${name}.tar.gz";
      sha256 = "1svm1h59sg4bwj5cy10m016gj0xpiin15nrz5z66h47sbkndvlw3";
    };

    DEPS = "loose";

    doCheck = false; # requires redis server
    propagatedBuildInputs = with self; [
      setuptools docker_registry_core blinker flask gevent gunicorn pyyaml
      requests2 rsa sqlalchemy9 setuptools backports_lzma m2crypto
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
      url = "https://pypi.python.org/packages/source/d/docopt/${name}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/d/doctest-ignore-unicode/${name}.tar.gz";
      sha256= "fc90b2d0846477285c6b67fc4cb4d6f39fcf76d8752f4df0a241486f31512ad5";
    };

    propagatedBuildInputs = with self; [ nose ];

    meta = {
      description = "Add flag to ignore unicode literal prefixes in doctests";
      license = with licenses; [ asl20 ];
      homepage = http://github.com/gnublade/doctest-ignore-unicode;
    };
  };

  dogpile_cache = buildPythonPackage rec {
    name = "dogpile.cache-0.5.4";

    propagatedBuildInputs = with self; [ dogpile_core ];

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/dogpile.cache/dogpile.cache-0.5.4.tar.gz";
      sha256 = "9eab7a5dc05ad1b6573144c4a2717226b5c38811f9ec29b514e774535a91ea24";
    };

    doCheck = false;

    meta = {
      description = "A caching front-end based on the Dogpile lock";
      homepage = http://bitbucket.org/zzzeek/dogpile.cache;
      license = licenses.bsd3;
    };
  };

  dogpile_core = buildPythonPackage rec {
    name = "dogpile.core-0.4.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/dogpile.core/dogpile.core-0.4.1.tar.gz";
      sha256 = "be652fb11a8eaf66f7e5c94d418d2eaa60a2fe81dae500f3743a863cc9dbed76";
    };

    doCheck = false;

    meta = {
      description = "A 'dogpile' lock, typically used as a component of a larger caching solution";
      homepage = http://bitbucket.org/zzzeek/dogpile.core;
      license = licenses.bsd3;
    };
  };

  dotfiles = buildPythonPackage rec {
    name = "dotfiles-0.6.3";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/dotfiles/${name}.tar.gz";
      sha256 = "45ecfd7f2ed9d0f2a7ac632c9bd0ebdca758d8bbc2b6f11562579d525f0467b8";
    };

    doCheck = true;

    meta = {
      description = "Easily manage your dotfiles";
      homepage = https://github.com/jbernard/dotfiles;
      license = licenses.isc;
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

    propagatedBuildInputs = with self; [ requests2 six ];

    meta = {
      description = "Digital Ocean API python wrapper";
      homepage = "https://github.com/Wiredcraft/dopy";
      license = licenses.mit;
      maintainers = with maintainers; [ lihop ];
      platforms = platforms.all;
    };
  };

  dpkt = buildPythonPackage rec {
    name = "dpkt-1.8";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "https://dpkt.googlecode.com/files/${name}.tar.gz";
      sha256 = "01q5prynymaqyfsfi2296xncicdpid2hs3yyasim8iigvkwy4vf5";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      description = "Fast, simple packet creation / parsing, with definitions for the basic TCP/IP protocols";
      homepage = https://code.google.com/p/dpkt/;
      license = licenses.bsd3;
      maintainers = with maintainers; [ bjornfor ];
      platforms = platforms.all;
    };
  };

  urllib3 = buildPythonPackage rec {
    name = "urllib3-1.12";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/u/urllib3/${name}.tar.gz";
      sha256 = "1ikj72kd4cdcq7pmmcd5p6s9dvp7wi0zw01635v4xzkid5vi598f";
    };

    preConfigure = ''
      substituteInPlace test-requirements.txt --replace 'nose==1.3' 'nose'
    '';

    doCheck = !isPy3k;  # lots of transient failures
    checkPhase = ''
      # Not worth the trouble
      rm test/with_dummyserver/test_poolmanager.py
      rm test/with_dummyserver/test_proxy_poolmanager.py
      rm test/with_dummyserver/test_socketlevel.py
      # pypy: https://github.com/shazow/urllib3/issues/736
      rm test/with_dummyserver/test_connectionpool.py

      nosetests -v --cover-min-percentage 1
    '';


    buildInputs = with self; [ coverage tornado mock nose ];

    patches = [ ../development/python-modules/urllib3-fix-sslv3-test.patch ];

    meta = {
      description = "A Python library for Dropbox's HTTP-based Core and Datastore APIs";
      homepage = https://www.dropbox.com/developers/core/docs;
      license = licenses.mit;
    };
  };


  dropbox = buildPythonPackage rec {
    name = "dropbox-${version}";
    version = "3.37";
    #doCheck = false; # python 2.7.9 does verify ssl certificates

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/dropbox/${name}.tar.gz";
      sha256 = "f65c12bd97f09e29a951bc7cb30a74e005fc4b2f8bb48778796be3f73866b173";
    };

    propagatedBuildInputs = with self; [ requests2 urllib3 mock setuptools ];

    meta = {
      description = "A Python library for Dropbox's HTTP-based Core and Datastore APIs";
      homepage = https://www.dropbox.com/developers/core/docs;
      license = licenses.mit;
    };
  };


  ds4drv = buildPythonPackage rec {
    name = "ds4drv-${version}";
    version = "0.5.0";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/ds4drv/${name}.tar.gz";
      sha256 = "0dq2z1z09zxa6rn3v94vwqaaz29jwiydkss8hbjglixf20krmw3b";
    };

    propagatedBuildInputs = with self; [ evdev pyudev ];

    buildInputs = [ pkgs.bluez ];

    meta = {
      description = "Userspace driver for the DualShock 4 controller";
      homepage = "https://github.com/chrippa/ds4drv";
      license = licenses.mit;
    };

  };

  dyn = buildPythonPackage rec {
    version = "1.5.0";
    name = "dyn-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/dyn/${name}.tar.gz";
      sha256 = "dc4b4b2a5d9d26f683230fd822641b39494df5fcbfa716281d126ea6425dd4c3";
    };

    buildInputs = with self; [
      pytest
      pytestcov
      mock
      pytestpep8
      pytest_xdist
      covCore
      pkgs.glibcLocales
    ];

    LC_ALL="en_US.UTF-8";

    meta = {
      description = "Dynect dns lib";
      homepage = "http://dyn.readthedocs.org/en/latest/intro.html";
      license = licenses.bsd3;
    };
  };

  easy-process = buildPythonPackage rec {
    name = "EasyProcess-0.1.9";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/E/EasyProcess/${name}.tar.gz";
      sha256 = "c9980c0b0eeab97969305d8829bed966a3e28a77284e4f45a9b38fb23ce83633";
    };

    meta = {
      description = "Easy to use python subprocess interface";
      homepage = "https://github.com/ponty/EasyProcess";
      license = licenses.bsdOriginal;
      maintainers = with maintainers; [ layus ];
    };
  };

  elasticsearch = buildPythonPackage (rec {
    name = "elasticsearch-1.9.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/e/elasticsearch/${name}.tar.gz";
      sha256 = "091s60ziwhyl9kjfm833i86rcpjx46v9h16jkgjgkk5441dln3gb";
    };

    # Check is disabled because running them destroy the content of the local cluster!
    # https://github.com/elasticsearch/elasticsearch-py/tree/master/test_elasticsearch
    doCheck = false;
    propagatedBuildInputs = with self; [ urllib3 requests2 ];
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
      url = "https://pypi.python.org/packages/source/e/elasticsearch-dsl/${name}.tar.gz";
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


  evdev = buildPythonPackage rec {
    version = "0.4.7";
    name = "evdev-${version}";
    disabled = isPy34;  # see http://bugs.python.org/issue21121

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/e/evdev/${name}.tar.gz";
      sha256 = "1mz8cfncpxc1wbk2nj7apl0ssqc0vfndysxchq3wabd9vzx5p71k";
    };

    buildInputs = with self; [ pkgs.linuxHeaders ];

    patchPhase = "sed -e 's#/usr/include/linux/input.h#${pkgs.linuxHeaders}/include/linux/input.h#' -i setup.py";

    doCheck = false;

    meta = {
      description = "Provides bindings to the generic input event interface in Linux";
      homepage = http://pythonhosted.org/evdev;
      license = licenses.bsd3;
      maintainers = with maintainers; [ goibhniu ];
      platforms = platforms.linux;
    };
  };

  eve = buildPythonPackage rec {
    version = "0.6.1";
    name = "Eve-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/E/Eve/${name}.tar.gz";
      sha256 = "0wf1x8qixkld6liz5syqi8i9nrfrhq4lpmh0p9cy3jbkhk34km69";
    };

    propagatedBuildInputs = with self; [
      cerberus
      events
      flask-pymongo
      flask
      itsdangerous
      jinja2
      markupsafe
      pymongo_2_9_1
      simplejson
      werkzeug

    ];

    # tests call a running mongodb instance
    doCheck = false;

    meta = {
      homepage = "http://python-eve.org/";
      description = "open source Python REST API framework designed for human beings";
      license = licenses.bsd3;
    };
  };


  eventlib = buildPythonPackage rec {
    name = "python-eventlib-${version}";
    version = "0.2.1";

    # Judging from SyntaxError
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "http://download.ag-projects.com/SipClient/${name}.tar.gz";
      sha256 = "25224794420f430946fe46932718b521a6264903fe8c0ed3563dfdb844c623e7";
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
      url = "https://pypi.python.org/packages/source/E/Events/${name}.tar.gz";
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
    name = "execnet-1.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/e/execnet/${name}.zip";
      sha256 = "fa1d8bd6b6d2282ff4df474b8ac687e1775bff4fc6462b219a5f89d5e9e6908c";
    };

    doCheck = !isPy3k;  # failures..

    meta = {
      description = "rapid multi-Python deployment";
      license = licenses.gpl2;
    };
  };

  facebook-sdk = buildPythonPackage rec {
    name = "facebook-sdk-0.4.0";

    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/f/facebook-sdk/facebook-sdk-0.4.0.tar.gz";
      sha256 = "5a96c54d06213039dff1fe1fabc51972e394666cd6d83ea70f7c2e67472d9b72";
    };

    meta = with pkgs.stdenv.lib; {
      description = "Client library that supports the Facebook Graph API and the official Facebook JavaScript SDK";
      homepage = https://github.com/pythonforfacebook/facebook-sdk;
      license = licenses.asl20 ;
    };
  };

  faker = buildPythonPackage rec {
    name = "faker-0.0.4";
    disabled = isPy3k;
    src = pkgs.fetchurl {
      url = https://pypi.python.org/packages/source/F/Faker/Faker-0.0.4.tar.gz;
      sha256 = "09q5jna3j8di0gw5yjx0dvlndkrk2x9vvqzwyfsvg3nlp8h38js1";
    };
    buildInputs = with self; [ nose ];
    meta = {
      description = "A Python library for generating fake user data";
      homepage    = http://pypi.python.org/pypi/Faker;
      license     = licenses.mit;
      maintainers = with maintainers; [ lovek323 ];
      platforms   = platforms.unix;
    };
  };

  fake_factory = buildPythonPackage rec {
    name = "fake-factory-0.2";
    src = pkgs.fetchurl {
      url = https://pypi.python.org/packages/source/f/fake-factory/fake-factory-0.2.tar.gz;
      sha256 = "0qdmk8p4anrj9mf95dh9v7bkhv1pz69hvhlw380kj4iz7b44b6zn";
    };
    meta = {
      description = "A Python package that generates fake data for you";
      homepage    = https://pypi.python.org/pypi/fake-factory;
      license     = licenses.mit;
      maintainers = with maintainers; [ lovek323 ];
      platforms   = platforms.unix;
    };
  };

  Fabric = buildPythonPackage rec {
    name = "Fabric-${version}";
    version = "1.10.2";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/F/Fabric/${name}.tar.gz";
      sha256 = "0nikc05iz1fx2c9pvxrhrs819cpmg566azm99450yq2m8qmp1cpd";
    };
    disabled = isPy3k;
    doCheck = (!isPyPy);  # https://github.com/fabric/fabric/issues/11891
    propagatedBuildInputs = with self; [ paramiko pycrypto ];
    buildInputs = with self; [ fudge_9 nose ];
  };

  fedora_cert = stdenv.mkDerivation (rec {
    name = "fedora-cert-0.5.9.2";
    meta.maintainers = with maintainers; [ mornfall ];

    src = pkgs.fetchurl {
      url = "https://fedorahosted.org/releases/f/e/fedora-packager/fedora-packager-0.5.9.2.tar.bz2";
      sha256 = "105swvzshgn3g6bjwk67xd8pslnhpxwa63mdsw6cl4c7cjp2blx9";
    };

    propagatedBuildInputs = with self; [ python python_fedora wrapPython ];
    postInstall = "mv $out/bin/fedpkg $out/bin/fedora-cert-fedpkg";
    doCheck = false;

    postFixup = "wrapPythonPrograms";
  });

  fedpkg = buildPythonPackage (rec {
    name = "fedpkg-1.14";
    meta.maintainers = with maintainers; [ mornfall ];

    src = pkgs.fetchurl {
      url = "https://fedorahosted.org/releases/f/e/fedpkg/${name}.tar.bz2";
      sha256 = "0rj60525f2sv34g5llafnkmpvbwrfbmfajxjc14ldwzymp8clc02";
    };

    patches = [ ../development/python-modules/fedpkg-buildfix.diff ];
    propagatedBuildInputs = with self; [ rpkg offtrac urlgrabber fedora_cert ];
  });

  frozendict = buildPythonPackage rec {
    name = "frozendict-0.5";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/f/frozendict/${name}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/f/ftputil/${name}.tar.gz";
      sha256 = "1714w0v6icw2xjx5m54yv2qgkq49qwxwllq4gdb7wkz25iiapr8b";
    };

    disabled = isPy3k;

    meta = {
      description = "High-level FTP client library (virtual file system and more)";
      homepage    = https://pypi.python.org/pypi/ftputil;
      platforms   = platforms.linux;
      license     = licenses.bsd2; # "Modified BSD licence, says pypi"
    };
  };

  fudge = buildPythonPackage rec {
    name = "fudge-1.1.0";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/f/fudge/${name}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/f/fudge/${name}.tar.gz";
      sha256 = "34690c4692e8717f4d6a2ab7d841070c93c8d0ea0d2615b47064e291f750b1a0";
    };
  };


  funcparserlib = buildPythonPackage rec {
    name = "funcparserlib-0.3.6";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/f/funcparserlib/${name}.tar.gz";
      sha256 = "b7992eac1a3eb97b3d91faa342bfda0729e990bd8a43774c1592c091e563c91d";
    };

    checkPhase = ''
      ${python.interpreter} -m unittest discover
    '';

    # Judging from SyntaxError in tests.
    disabled = isPy3k;

    meta = {
      description = "Recursive descent parsing library based on functional combinators";
      homepage = https://code.google.com/p/funcparserlib/;
      license = licenses.mit;
      platforms = platforms.linux;
    };
  };

  singledispatch = buildPythonPackage rec {
    name = "singledispatch-3.4.0.3";

    propagatedBuildInputs = with self; [ six ];

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/s/singledispatch/${name}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/f/functools32/functools32-${version}.tar.gz";
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
    propagatedBuildInputs = with self; [tornado futures html5lib readline pkgs.openssl pkgs.cacert pkgs.openssh];
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
    };
  };

  gmpy = buildPythonPackage rec {
    name = "gmpy-1.17";
    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/g/gmpy/${name}.zip";
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
      url = "https://pypi.python.org/packages/source/g/gmpy2/${name}.zip";
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
    name = "gmusicapi-7.0.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/g/gmusicapi/gmusicapi-7.0.0.tar.gz";
      sha256 = "1zji4cgylyzz97cz69lywkbsn5nvvzrhk7iaqnpqpfvj9gwdchwn";
    };

    propagatedBuildInputs = with self; [
      validictory
      decorator
      mutagen
      protobuf
      setuptools
      requests2
      dateutil
      proboscis
      mock
      appdirs
      oauth2client
      pyopenssl
      gpsoauth
      MechanicalSoup
    ];

    meta = {
      description = "An unofficial API for Google Play Music";
      homepage = http://pypi.python.org/pypi/gmusicapi/;
      license = licenses.bsd3;
    };
  };

  gnureadline = buildPythonPackage rec {
    version = "6.3.3";
    name = "gnureadline-${version}";
    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/g/gnureadline/${name}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/p/python-gnutls/python-gnutls-2.0.1.tar.gz";
      sha256 = "d8fb368c6a4dd58bc6cd5e61d4a12d119c4506fd344a371b3429b3ac2623b9ac";
    };

    propagatedBuildInputs = with self; [ pkgs.gnutls ];
  };

  gitdb = buildPythonPackage rec {
    name = "gitdb-0.6.4";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/g/gitdb/${name}.tar.gz";
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
    version = "1.0.1";
    name = "GitPython-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/G/GitPython/GitPython-${version}.tar.gz";
      sha256 = "0q7plxnbbkp5dd0k73736l7gf932a89yy920yrgl8amfpixw324w";
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

  googlecl = buildPythonPackage rec {
    version = "0.9.14";
    name    = "googlecl-${version}";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url    = "https://googlecl.googlecode.com/files/${name}.tar.gz";
      sha256 = "0nnf7xkr780wivr5xnchfcrahlzy9bi2dxcs1w1bh1014jql0iha";
    };

    meta = {
      description = "Brings Google services to the command line";
      homepage    = https://code.google.com/p/googlecl/;
      license     = licenses.asl20;
      maintainers = with maintainers; [ lovek323 ];
      platforms   = platforms.unix;
    };

    propagatedBuildInputs = with self; [ gdata ];
  };

  googleplaydownloader = buildPythonPackage rec {
    version = "1.8";
    name = "googleplaydownloader-${version}";

    src = pkgs.fetchurl {
       url = "https://codingteam.net/project/googleplaydownloader/download/file/googleplaydownloader_${version}.orig.tar.gz";
       sha256 = "1hxl4wdbiyq8ay6vnf3m7789jg0kc63kycjj01x1wm4gcm4qvbkx";
     };

    disabled = ! isPy27;

    propagatedBuildInputs = with self; [ configparser pyasn1 ndg-httpsclient requests protobuf wxPython];

    preBuild = ''
      substituteInPlace googleplaydownloader/__init__.py --replace \
        'open(os.path.join(HERE, "googleplaydownloader"' \
        'open(os.path.join(HERE'
    '';

    postInstall = ''
      cp -R googleplaydownloader/ext_libs $out/${python.sitePackages}/
    '';

    meta = {
      homepage = https://codingteam.net/project/googleplaydownloader;
      description = "Graphical software to download APKs from the Google Play store";
      license = licenses.agpl3;
      maintainers = with maintainers; [ DamienCassou ];
    };
  };

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
      maintainers = with maintainers; [ DamienCassou ];
    };
  };

  gpsoauth = buildPythonPackage rec {
    version = "0.0.4";
    name = "gpsoauth-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/g/gpsoauth/${name}.tar.gz";
      sha256 = "1mhd2lkl1f4fmia1cwxwik8gvqr5q16scjip7kfwzadh9a11n9kw";
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
      pycrypto
      requests2
      six
    ];

    meta = {
      description = "A python client library for Google Play Services OAuth";
      homepage = "https://github.com/simon-weber/gpsoauth";
      license = licenses.mit;
      maintainers = with maintainers; [ jgillich ];
    };
  };

  gst-python = callPackage ../development/libraries/gstreamer/python {
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
          --prefix LD_LIBRARY_PATH ":" "${pkgs.gtk3}/lib" \

    '';

    meta = {
      description = "A small Gtk+ app for keeping track of your time. It's main goal is to be as unintrusive as possible";
      homepage = http://mg.pov.lt/gtimelog/;
      license = licenses.gpl2Plus;
      maintainers = with maintainers; [ ocharles ];
      platforms = platforms.unix;
    };
  };

  hglib = buildPythonPackage rec {
    version = "1.7";
    name = "hglib-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/python-hglib/python-hglib-${version}.tar.gz";
      sha256 = "0dc087d15b774cda82d3c8096fb0e514caeb2ddb60eed38e9056b16e279ba3c5";
    };

    meta = {
      description = "Mercurial Python library";
      homepage = "http://selenic.com/repo/python-hglib";
      license = licenses.mit;
      maintainers = with maintainers; [ dfoxfranke ];
      platforms = platforms.all;
    };
  };

  humanize = buildPythonPackage rec {
    version = "0.5.1";
    name = "humanize-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/h/humanize/${name}.tar.gz";
      sha256 = "a43f57115831ac7c70de098e6ac46ac13be00d69abbf60bdcac251344785bb19";
    };

    buildInputs = with self; [ mock ];

    doCheck = false;

    meta = {
      description = "python humanize utilities";
      homepage = https://github.com/jmoiron/humanize;
      license = licenses.mit;
      maintainers = with maintainers; [ matthiasbeyer ];
      platforms = platforms.linux; # can only test on linux
    };

  };

  hovercraft = buildPythonPackage rec {
    disabled = ! isPy3k;
    name = "hovercraft-${version}";
    version = "2.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/h/hovercraft/${name}.tar.gz";
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

  httpauth = buildPythonPackage rec {
    version = "0.2";
    name = "httpauth-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/h/httpauth/${name}.tar.gz";
      sha256 = "294029b5dfed27bca5746a31e3ffb5ed99268761536705e8bbd44231b7ca15ec";
    };

    doCheck = false;

    meta = {
      description = "WSGI HTTP Digest Authentication middleware";
      homepage = https://github.com/jonashaag/httpauth;
      license = licenses.bsd2;
      maintainers = with maintainers; [ matthiasbeyer ];
    };
  };

  imread = buildPythonPackage rec {
    name = "python-imread-${version}";
    version = "0.5.1";

    src = pkgs.fetchurl {
      url = "https://github.com/luispedro/imread/archive/release-${version}.tar.gz";
      sha256 = "12d7ba3523ba50d67d526e9797e041021dd9cd4acf9567a9bf73c8ae0b689d4a";
    };

    buildInputs = with self; [
      nose
      pkgs.libjpeg
      pkgs.libpng
      pkgs.libtiff
      pkgs.libwebp
      pkgs.pkgconfig
    ];
    propagatedBuildInputs = with self; [ numpy ];

    meta = with stdenv.lib; {
      description = "Python package to load images as numpy arrays";
      homepage = https://readthedocs.org/projects/imread/;
      maintainers = with maintainers; [ luispedro ];
      license = licenses.mit;
      platforms = platforms.linux;
    };
  };

  itsdangerous = buildPythonPackage rec {
    name = "itsdangerous-0.24";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/i/itsdangerous/${name}.tar.gz";
      sha256 = "06856q6x675ly542ig0plbqcyab6ksfzijlyf1hzhgg3sgwgrcyb";
    };

    meta = {
      description = "helpers to pass trusted data to untrusted environments and back";
      homepage = "https://pypi.python.org/pypi/itsdangerous/";
    };
  };

  iniparse = buildPythonPackage rec {

    name = "iniparse-${version}";
    version = "0.4";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/i/iniparse/iniparse-${version}.tar.gz";
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
      maintainers = [ "abcz2.uprola@gmail.com" ];
    };
  };

  i3-py = buildPythonPackage rec {
    version = "0.6.4";
    name = "i3-py-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/i/i3-py/i3-py-${version}.tar.gz";
      sha256 = "1sgl438jrb4cdyl7hbc3ymwsf7y3zy09g1gh7ynilxpllp37jc8y";
    };

    # no tests in tarball
    doCheck = false;

    meta = {
      description = "tools for i3 users and developers";
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

  internetarchive = let ver = "0.8.3"; in buildPythonPackage rec {
    name = "internetarchive-${ver}";

    src = pkgs.fetchurl {
      url = "https://github.com/jjjake/internetarchive/archive/v${ver}.tar.gz";
      sha256 = "0j3l13zvbx50j66l6pnf8y8y8m6gk1sc3yssvfd2scvmv4gnmm8n";
    };

    # It is hardcoded to specific versions, I don't know why.
    preConfigure = ''
        sed 's/==/>=/' -i setup.py
    '';

    propagatedBuildInputs = with self; [ six clint pyyaml docopt pytest
      requests2 jsonpatch args ];

    meta = with stdenv.lib; {
      description = "A python wrapper for the various Internet Archive APIs";
      homepage = "https://github.com/jjjake/internetarchive";
    };
  };

  jsonpatch = buildPythonPackage rec {
    name = "jsonpatch-1.11";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/j/jsonpatch/${name}.tar.gz";
      sha256 = "22d0bc0f5522a4a03dd9fb4c4cdf7c1f03256546c88be4c61e5ceabd22280e47";
    };

    propagatedBuildInputs = with self; [ jsonpointer ];

    meta = {
      description = "Library to apply JSON Patches according to RFC 6902";
      homepage = "https://github.com/stefankoegl/python-json-patch";
      license = stdenv.lib.licenses.bsd2; # "Modified BSD licence, says pypi"
    };
  };

  jsonpointer = buildPythonPackage rec {
    name = "jsonpointer-1.9";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/j/jsonpointer/${name}.tar.gz";
      sha256 = "39403b47a71aa782de6d80db3b78f8a5f68ad8dfc9e674ca3bb5b32c15ec7308";
    };

    meta = {
      description = "Resolve JSON Pointers in Python";
      homepage = "https://github.com/stefankoegl/python-json-pointer";
      license = stdenv.lib.licenses.bsd2; # "Modified BSD licence, says pypi"
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

  ledger-autosync = buildPythonPackage rec {
    name = "ledger-autosync-${version}";
    version = "0.2.3";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/l/ledger-autosync/ledger-autosync-${version}.tar.gz";
      sha256 = "f19fa66e656309825887171d84a462e64676b1cc36b62e4dd8679ff63926a469";
    };

    propagatedBuildInputs = with self; [ ofxclient ];

    buildInputs = with self; [
      mock
      nose
      # Used at runtime to translate ofx entries to the ledger
      # format. In fact, user could use either ledger or hledger.
      pkgs.which
      pkgs.ledger ];

    # Tests are disable since they require hledger and python-ledger
    doCheck = false;

    meta = {
      homepage = https://gitlab.com/egh/ledger-autosync;
      description = "ledger-autosync is a program to pull down transactions from your bank and create ledger transactions for them";
      license = licenses.gpl3;
      maintainers = with maintainers; [ lewo ];
    };
  };


  libthumbor = buildPythonPackage rec {
    name = "libthumbor-${version}";
    version = "1.2.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/l/libthumbor/${name}.tar.gz";
      sha256 = "09bbaf08124ee33ea4ef99881625bd20450b0b43ab90fd678479beba8c03f86e";
    };

    propagatedBuildInputs = with self; [ six pycrypto ];

    meta = {
      description = "libthumbor is the python extension to thumbor";
      homepage = http://github.com/heynemann/libthumbor;
      license = licenses.mit;
    };
  };

  lightning = buildPythonPackage rec {
    version = "1.2.1";
    name = "lightning-python-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/l/lightning-python/${name}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/j/jupyter/${name}.tar.gz";
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

    meta = {
      description = "Installs all the Jupyter components in one go";
      homepage = "http://jupyter.org/";
      license = licenses.bsd3;
      platforms = platforms.all;
    };
  };

  jupyter_console = buildPythonPackage rec {
    version = "4.1.1";
    name = "jupyter_console-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/j/jupyter_console/${name}.tar.gz";
      sha256 = "1qsa9h7db8qzd4hg9l5mfl8299y4i7jkd6p3vpksk3r5ip8wym6p";
    };

    buildInputs = with self; [ nose ];
    propagatedBuildInputs = with self; [
      jupyter_client
      ipython
      ipykernel
    ];

    meta = {
      description = "Jupyter terminal console";
      homepage = "http://jupyter.org/";
      license = licenses.bsd3;
      platforms = platforms.all;
    };
  };

  lti = buildPythonPackage rec {
    version = "0.4.0";
    name = "PyLTI-${version}";

    propagatedBuildInputs = with self; [ httplib2 oauth oauth2 semantic-version ];
    buildInputs = with self; [
      flask httpretty oauthlib pyflakes pytest pytestcache pytestcov covCore
      pytestflakes pytestpep8 sphinx mock
    ];

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/P/PyLTI/${name}.tar.gz";
      sha256 = "1lkk6qx8yfx1h0rhi4abnd44x0wakggi6zs0nvi572lajf6ydmdh";
    };

    meta = {
      description = "Implementation of IMS LTI interface that works with edX";
      homepage = "https://github.com/mitodl/pylti";
      license = licenses.bsdOriginal;
      maintainers = with maintainers; [ layus ];
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

    propagatedBuildInputs = with self; [ ];

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

  mailchimp = buildPythonPackage rec {
    version = "2.0.9";
    name = "mailchimp-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/m/mailchimp/mailchimp-${version}.tar.gz";
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

  python-mapnik = buildPythonPackage {
    name = "python-mapnik-fae6388";

    src = pkgs.fetchgit {
      url = https://github.com/mapnik/python-mapnik.git;
      rev = "fae63881ed0945829e73f711d52740240b740936";
      sha256 = "13i9zsy0dk9pa947vfq26a3nrn1ddknqliyb0ljcmi5w5x0z758k";
    };

    disabled = isPyPy;
    doCheck = false; # doesn't find needed test data files
    buildInputs = with pkgs; [ boost harfbuzz icu mapnik ];
    propagatedBuildInputs = with self; [ pillow pycairo ];

    meta = with stdenv.lib; {
      description = "Python bindings for Mapnik";
      homepage = http://mapnik.org;
      license  = licenses.lgpl21;
    };
  };

  mwlib = buildPythonPackage rec {
    version = "0.15.15";
    name = "mwlib-${version}";

    src = pkgs.fetchurl {
      url = "http://pypi.pediapress.com/packages/mirror/${name}.tar.gz";
      sha256 = "1dnmnkc21zdfaypskbpvkwl0wpkpn0nagj1fc338w64mbxrk8ny7";
    };

    propagatedBuildInputs = with self;
      [
        apipkg
        bottle
        gevent
        lxml
        odfpy
        pillow
        py
        pyPdf
        pyparsing1
        qserve
        roman
        simplejson
        sqlite3dbm
        timelib
      ] ++ optionals (!isPy3k) [ modules.sqlite3 ];

    meta = {
      description = "Library for parsing MediaWiki articles and converting them to different output formats";
      homepage = "http://pediapress.com/code/";
      license = licenses.bsd3;
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
      description = "dependencies for mwlib markup";
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
      description = "generate pdfs from mediawiki markup";
      homepage = "http://pediapress.com/code/";
      license = licenses.bsd3;
    };
  };

  natsort = buildPythonPackage rec {
    name = "natsort-4.0.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/n/natsort/${name}.tar.gz";
      sha256 = "a0d4239bd609eae5cd5163db6f9794378ce0e3f43ae16c10c35472d866ae20cd";
    };

    buildInputs = with self;
      [
        hypothesis1
        pytestcov
        pytestflakes
        pytestpep8
        covCore
      ];

    meta = {
      description = "Natural sorting for python";
      homepage = https://github.com/SethMMorton/natsort;
      license = licenses.mit;
    };
  };

  logster = buildPythonPackage {
    name = "logster-7475c53822";
    src = pkgs.fetchgit {
      url = git://github.com/etsy/logster;
      rev = "7475c53822";
      sha256 = "1ls007qmziwb50c5iikxhqin0xbn673gbd25m5k09861435cknvr";
    };
  };

  ndg-httpsclient = buildPythonPackage rec {
    version = "0.4.0";
    name = "ndg-httpsclient-${version}";

    propagatedBuildInputs = with self; [ pyopenssl ];

    src = pkgs.fetchFromGitHub {
      owner = "cedadev";
      repo = "ndg_httpsclient";
      rev = "v${version}";
      sha256 = "1prv4j3wcy9kl5ndd5by543xp4cji9k35qncsl995w6sway34s1a";
    };

    # uses networking
    doCheck = false;

    meta = {
      homepage = https://github.com/cedadev/ndg_httpsclient/;
      description = "Provide enhanced HTTPS support for httplib and urllib2 using PyOpenSSL";
      license = licenses.bsd2;
      maintainers = with maintainers; [ DamienCassou ];
    };
  };

  netcdf4 = buildPythonPackage rec {
    name = "netCDF4-${version}";
    version = "1.2.1";

    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/n/netCDF4/${name}.tar.gz";
      sha256 = "0wzg73zyjjhns4209vrcvh71gs392d16ynz76x3pl1xg2by723iy";
    };

    propagatedBuildInputs = with self ; [
      numpy
      pkgs.zlib
      pkgs.netcdf
      pkgs.hdf5
      pkgs.curl
      pkgs.libjpeg
    ];

    # Variables used to configure the build process
    USE_NCCONFIG="0";
    HDF5_DIR="${pkgs.hdf5}";
    NETCDF4_DIR="${pkgs.netcdf}";
    CURL_DIR="${pkgs.curl}";
    JPEG_DIR="${pkgs.libjpeg}";

    meta = {
      description = "interface to netCDF library (versions 3 and 4)";
      homepage = https://pypi.python.org/pypi/netCDF4;
      license = licenses.free;  # Mix of license (all MIT* like)
    };
  };

  odfpy = buildPythonPackage rec {
    version = "0.9.6";
    name = "odfpy-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/o/odfpy/${name}.tar.gz";
      sha256 = "e458f969f1ccd7ed77d70a45fe69ad656ac61b39e36e4d32c42d4e3216030891";
    };

    buildInputs = with self; with pkgs; [ ];

    propagatedBuildInputs = with self; [ ];

    meta = {
      description = "Python API and tools to manipulate OpenDocument files";
      homepage = "https://joinup.ec.europa.eu/software/odfpy/home";
      license = licenses.asl20;
    };
  };

  pathtools = buildPythonPackage rec {
    name = "pathtools-${version}";
    version = "0.1.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pathtools/${name}.tar.gz";
      sha256 = "1h7iam33vwxk8bvslfj4qlsdprdnwf8bvzhqh3jq5frr391cadbw";
    };

    meta = {
      description = "Pattern matching and various utilities for file systems paths";
      homepage = http://github.com/gorakhargosh/pathtools;
      license = licenses.mit;
      maintainers = with maintainers; [ goibhniu ];
    };
  };

  paver = buildPythonPackage rec {
    version = "1.2.2";
    name    = "Paver-${version}";

    src = pkgs.fetchurl {
      url    = "https://pypi.python.org/packages/source/P/Paver/Paver-${version}.tar.gz";
      sha256 = "0lix9d33ndb3yk56sm1zlj80fbmxp0w60yk0d9pr2xqxiwi88sqy";
    };

    buildInputs = with self; [ cogapp mock virtualenv ];

    propagatedBuildInputs = with self; [ nose ];

    # the tests do not pass
    doCheck = false;

    meta = {
      description = "A Python-based build/distribution/deployment scripting tool";
      homepage    = http://github.com/paver/paver;
      matinainers = with maintainers; [ lovek323 ];
      platforms   = platforms.unix;
    };
  };

  passlib = buildPythonPackage rec {
    version = "1.6.2";
    name    = "passlib-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/passlib/passlib-${version}.tar.gz";
      sha256 = "e987f6000d16272f75314c7147eb015727e8532a3b747b1a8fb58e154c68392d";
    };

    buildInputs = with self; [ nose pybcrypt];

    meta = {
      description = "A password hashing library for Python";
      homepage    = https://code.google.com/p/passlib/;
    };
  };

  pdfminer = buildPythonPackage rec {
    version = "20140328";
    name = "pdfminer-${version}";

    disabled = ! isPy27;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pdfminer/pdfminer-${version}.tar.gz";
      sha256 = "0qpjv4b776dwvpf5a7v19g41qsz97bv0qqsyvm7a31k50n9pn65s";
    };

    propagatedBuildInputs = with self; [  ];

    meta = {
      description = "Tool for extracting information from PDF documents";
      homepage = http://euske.github.io/pdfminer/index.html;
      license = licenses.mit;
      maintainers = with maintainers; [ DamienCassou ];
    };
  };

  peppercorn = buildPythonPackage rec {
    name = "peppercorn-0.5";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/peppercorn/${name}.tar.gz";
      sha256 = "921cba5d51fa211e6da0fbd2120b9a98d663422a80f5bb669ad81ffb0909774b";
    };

    meta = {
      maintainers = with maintainers; [ garbas iElectric ];
      platforms = platforms.all;
    };
  };

  pew = buildPythonPackage rec {
    name = "pew-0.1.14";
    namePrefix = "";

    disabled = pythonOlder "3.4"; # old versions require backported libraries

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pew/${name}.tar.gz";
      md5 = "0a06ab0885b39f1ef3890893942f3225";
    };

    propagatedBuildInputs = with self; [ virtualenv virtualenv-clone ];

    meta = {
      description = "Tools to manage multiple virtualenvs written in pure python, a virtualenvwrapper rewrite";
      license = licenses.mit;
      platforms = platforms.all;
      maintainers = with maintainers; [ berdario ];
    };
  };

  pies = buildPythonPackage rec {
    name = "pies-2.6.5";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pies/${name}.tar.gz";
      sha256 = "d8d6ae4faa0a7da5d634ad8c6ca4bb22b70ad53bb7ecd91af23d490fcd2a88e8";
    };

    deps = if !isPy3k then [ self.pies2overrides self.enum34 ]
           else if isPy33 then [ self.enum34 ]
           else [];

    propagatedBuildInputs = deps;

    meta = {
      description = "The simplest way to write one program that runs on both Python 2 and Python 3";
      homepage = https://github.com/timothycrosley/pies;
      license = licenses.mit;
    };
  };

  pies2overrides = buildPythonPackage rec {
    name = "pies2overrides-2.6.5";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pies2overrides/${name}.tar.gz";
      sha256 = "2a91445afc7f692bdbabfbf00d3defb1d47ad7825eb568a6464359758ab35763";
    };

    propagatedBuildInputs = with self; [ ipaddress ];

    meta = {
      description = "Defines override classes that should be included with pies only if running on Python2";
      homepage = https://github.com/timothycrosley/pies;
      license = licenses.mit;
    };
  };

  pirate-get = buildPythonPackage rec {
    name = "pirate-get-${version}";
    version = "0.2.8";

    disabled = !isPy3k;
    doCheck = false;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pirate-get/${name}.tar.gz";
      sha256 = "033dwv0w9fx3dwrna3fzvmynsfhb2qjhx6f2i9sfv82ijvkm8ynz";
    };

    propagatedBuildInputs = with self; [ colorama veryprettytable pyquery ];

    meta = {
      description = "A command line interface for The Pirate Bay";
      homepage = https://github.com/vikstrous/pirate-get;
      license = licenses.gpl1;
      maintainers = with maintainers; [ rnhmjoj ];
      platforms = platforms.unix;
    };
  };

  plotly = self.buildPythonPackage rec {
    name = "plotly-1.9.5";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/plotly/${name}.tar.gz";
      sha256 = "628679e880caab22e2a46273e85e1d1ce1382b631e1c7bbfe539f804c5269b21";
    };

    propagatedBuildInputs = with self; [ self.pytz self.six self.requests ];

    meta = {
      description = "Python plotting library for collaborative, interactive, publication-quality graphs";
      homepage = https://plot.ly/python/;
      license = licenses.mit;
    };
  };


  poppler-qt4 = buildPythonPackage rec {
    name = "poppler-qt4-${version}";
    version = "0.18.1";
    disabled = isPy3k || isPyPy;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/python-poppler-qt4/" +
            "python-poppler-qt4-${version}.tar.gz";
      sha256 = "00e3f89f4e23a844844d082918a89c2cbb1e8231ecb011b81d592e7e3c33a74c";
    };

    propagatedBuildInputs = [ pkgs.pyqt4 pkgs.pkgconfig pkgs.poppler_qt4 ];

    preBuild = "${python}/bin/${python.executable} setup.py build_ext" +
               " --include-dirs=${pkgs.poppler_qt4}/include/poppler/";

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

  pudb = buildPythonPackage rec {
    name = "pudb-2013.3.6";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pudb/${name}.tar.gz";
      sha256 = "81b20a995803c4be513e6d36c8ec9a531d3ccb24670b2416abc20f3933ddb8be";
    };

    propagatedBuildInputs = with self; [ self.pygments self.urwid ];

    meta = {
      description = "A full-screen, console-based Python debugger";
      license = licenses.mit;
      platforms = platforms.all;
    };
  };

  pycares = buildPythonPackage rec {
    name = "pycares-${version}";
    version = "1.0.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pycares/${name}.tar.gz";
      sha256 = "a18341ea030e2cc0743acdf4aa72302bdf6b820938b36ce4bd76e43faa2276a3";
    };

    propagatedBuildInputs = [ pkgs.c-ares ];

    # No tests included
    doCheck = false;

    meta = {
      homepage = http://github.com/saghul/pycares;
      description = "Interface for c-ares";
      license = licenses.mit;
    };
  };

  python-axolotl = buildPythonPackage rec {
    name = "python-axolotl-${version}";
    version = "0.1.7";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/python-axolotl/${name}.tar.gz";
      sha256 = "1i3id1mjl67n4sca31s5zwq96kswgsi6lga6np83ayb45rxggvhx";
    };

    propagatedBuildInputs = with self; [ python-axolotl-curve25519 protobuf pycrypto ];

    meta = {
      homepage = https://github.com/tgalal/python-axolotl;
      description = "Python port of libaxolotl-android";
      maintainers = with maintainers; [ abbradar ];
      license = licenses.gpl3;
      platform = platforms.all;
    };
  };

  python-axolotl-curve25519 = buildPythonPackage rec {
    name = "python-axolotl-curve25519-${version}";
    version = "0.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/python-axolotl-curve25519/${name}.tar.gz";
      sha256 = "1h1rsdr7m8lvgxwrwng7qv0xxmyc9k0q7g9nbcr6ks2ipyjzcnf5";
    };

    meta = {
      homepage = https://github.com/tgalal/python-axolotl;
      description = "Curve25519 with ed25519 signatures";
      maintainers = with maintainers; [ abbradar ];
      license = licenses.gpl3;
      platform = platforms.all;
    };
  };

  pypolicyd-spf = buildPythonPackage rec {
    name = "pypolicyd-spf-${version}";
    majorVersion = "1.3";
    version = "${majorVersion}.2";

    src = pkgs.fetchurl {
      url = "https://launchpad.net/pypolicyd-spf/${majorVersion}/${version}/+download/${name}.tar.gz";
      sha256 = "0ri9bdwn1k8xlyfhrgzns7wjvp5h08dq5fnxcq6mphy94rmc8x3i";
    };

    propagatedBuildInputs = with self; [ pyspf pydns ipaddr ];

    preBuild = ''
      substituteInPlace setup.py --replace "'/etc'" "'$out/etc'"
    '';

    meta = {
      homepage = https://launchpad.net/pypolicyd-spf/;
      description = "Postfix policy engine for Sender Policy Framework (SPF) checking";
      maintainers = with maintainers; [ abbradar ];
      license = licenses.asl20;
      platform = platforms.all;
    };
  };

  pyramid = buildPythonPackage rec {
    name = "pyramid-1.5.7";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyramid/${name}.tar.gz";
      sha256 = "1d29fj86724z68zcj9ximl2nrn34pflrlr6v9mwyhcv8rdf2sc61";
    };

    preCheck = ''
      # this will be fixed for 1.6 release, see https://github.com/Pylons/pyramid/issues/1405
      rm pyramid/tests/test_response.py
    '';

    buildInputs = with self; [
      docutils
      virtualenv
      webtest
      zope_component
      zope_interface
    ] ++ optional isPy26 unittest2;

    propagatedBuildInputs = with self; [
      PasteDeploy
      repoze_lru
      repoze_sphinx_autointerface
      translationstring
      venusian
      webob
      zope_deprecation
      zope_interface
    ];

    meta = {
      maintainers = with maintainers; [ garbas iElectric ];
      platforms = platforms.all;
    };

    # Failing tests
    # https://github.com/Pylons/pyramid/issues/1899
    doCheck = !isPy35;

  };


  pyramid_beaker = buildPythonPackage rec {
    name = "pyramid_beaker-0.7";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyramid_beaker/${name}.tar.gz";
      sha256 = "c76578dac3ea717e9ca89c327daf13975987d0b8827d15157319c20614fab74a";
    };

    propagatedBuildInputs = with self; [ beaker pyramid ];

    meta = {
      maintainers = with maintainers; [ iElectric ];
      platforms = platforms.all;
    };
  };


  pyramid_chameleon = buildPythonPackage rec {
    name = "pyramid_chameleon-0.3";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pyramid_chameleon/${name}.tar.gz";
      sha256 = "d176792a50eb015d7865b44bd9b24a7bd0489fa9a5cebbd17b9e05048cef9017";
    };

    propagatedBuildInputs = with self; [
      chameleon
      pyramid
      zope_interface
      setuptools
    ];

    meta = {
      maintainers = with maintainers; [ iElectric ];
    };
  };


  pyramid_jinja2 = buildPythonPackage rec {
    name = "pyramid_jinja2-${version}";
    version = "2.5";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyramid_jinja2/${name}.tar.gz";
      sha256 = "93c86e3103b454301f4d66640191aba047f2ab85ba75647aa18667b7448396bd";
    };

    buildInputs = with self; [ webtest ];
    propagatedBuildInputs = with self; [ jinja2 pyramid ];

    meta = {
      maintainers = with maintainers; [ iElectric ];
      platforms = platforms.all;
    };
  };


  pyramid_debugtoolbar = buildPythonPackage rec {
    name = "pyramid_debugtoolbar-1.0.9";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyramid_debugtoolbar/${name}.tar.gz";
      sha256 = "1vnzg1qnnyisv7znxg7pasayfyr3nz7rrs5nqr4fmdgwj9q2pyv0";
    };

    buildInputs = with self; [ ];
    propagatedBuildInputs = with self; [ pyramid pyramid_mako ];
  };


  pyramid_mako = buildPythonPackage rec {
    name = "pyramid_mako-0.3.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyramid_mako/${name}.tar.gz";
      sha256 = "00811djmsc4rz20kpy2paam05fbx6dmrv2i5jf90f6xp6zw4isy6";
    };

    buildInputs = with self; [ webtest ];
    propagatedBuildInputs = with self; [ pyramid Mako ];
  };


  pyramid_exclog = buildPythonPackage rec {
    name = "pyramid_exclog-0.7";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyramid_exclog/${name}.tar.gz";
      sha256 = "a58c82866c3e1a350684e6b83b440d5dc5e92ca5d23794b56d53aac06fb65a2c";
    };

    propagatedBuildInputs = with self; [ pyramid ];

    meta = {
      maintainers = with maintainers; [ garbas iElectric ];
      platforms = platforms.all;
    };
  };


  pyramid_tm = buildPythonPackage rec {
    name = "pyramid_tm-0.10";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyramid_tm/${name}.tar.gz";
      sha256 = "99528c54accf2bd5860d10634fe8972e8375b2d0f50ee08f208ed0484ffafc1d";
    };

    propagatedBuildInputs = with self; [ transaction pyramid ];
    meta = {
      maintainers = with maintainers; [ garbas iElectric matejc ];
      platforms = platforms.all;
    };
  };


  pyramid_multiauth = buildPythonPackage rec {
    name = "pyramid_multiauth-${version}";
    version = "0.3.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pyramid_multiauth/${name}.tar.gz";
      sha256 = "c33f357e0a216cd6ef7d143d40d4679c9fb0796a1eabaf1249aeef63ed000828";
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
      sha256 = "1ic7xl72qnz382xaqhcy9ql17gx7pxbs78znp8xr66sp3dcx2s3c";
    };

    propagatedBuildInputs = with self; [ pyramid hawkauthlib tokenlib webtest ];
  };

  pyspf = buildPythonPackage rec {
    name = "pyspf-${version}";
    version = "2.0.12";

    src = pkgs.fetchurl {
      url = "mirror://sourceforge/pymilter/pyspf/${name}/${name}.tar.gz";
      sha256 = "18j1rmbmhih7q6y12grcj169q7sx1986qn4gmpla9y5gwfh1p8la";
    };

    meta = {
      homepage = http://bmsi.com/python/milter.html;
      description = "Python API for Sendmail Milters (SPF)";
      maintainers = with maintainers; [ abbradar ];
      license = licenses.gpl2;
      platform = platforms.all;
    };
  };

  radicale = buildPythonPackage rec {
    name = "radicale-${version}";
    namePrefix = "";
    version = "1.1.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/R/Radicale/Radicale-${version}.tar.gz";
      sha256 = "1c5lv8qca21mndkx350wxv34qypqh6gb4rhzms4anr642clq3jg2";
    };

    propagatedBuildInputs = with self; [
      flup
      ldap
      sqlalchemy7
    ];

    doCheck = true;

    meta = {
      homepage = http://www.radicale.org/;
      description = "CalDAV CardDAV server";
      longDescription = ''
        The Radicale Project is a complete CalDAV (calendar) and CardDAV
        (contact) server solution. Calendars and address books are available for
        both local and remote access, possibly limited through authentication
        policies. They can be viewed and edited by calendar and contact clients
        on mobile phones or computers.
      '';
      license = licenses.gpl3Plus;
      maintainers = with maintainers; [ edwtjo pSub ];
    };
  };

  raven = buildPythonPackage rec {
    name = "raven-3.4.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/r/raven/${name}.tar.gz";
      sha256 = "c27e40ab3ccf37f30a9f77acb4917370d9341e25abda8e94b9bd48c7127f7d48";
    };

    # way too many dependencies to run tests
    # see https://github.com/getsentry/raven-python/blob/master/setup.py
    doCheck = false;

    meta = {
      maintainers = with maintainers; [ iElectric ];
    };
  };

  roman = buildPythonPackage rec {
    version = "2.0.0";
    name = "roman-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/r/roman/${name}.zip";
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
    name = "librosa-${version}";
    version = "0.4.0";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/l/librosa/librosa-0.4.0.tar.gz";
      sha256 = "cc11dcc41f51c08e442292e8a2fc7d7ee77e0d47ff771259eb63f57fcee6f6e7";
    };

    propagatedBuildInputs = with self;
      [ joblib matplotlib six scikitlearn decorator audioread samplerate ];
  };

  joblib = buildPythonPackage rec {
    name = "joblib-${version}";
    version = "0.9.4";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/j/joblib/${name}.tar.gz";
      sha256 = "e5faacf0da7b3035dbca9d56210962b86564aafca71a25f4ea376a405455cd60";
    };

    buildInputs = with self; [ nose ];

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
       library_dirs=${pkgs.libsamplerate}/lib
       include_dirs=${pkgs.libsamplerate}/include
       END
    '';

    doCheck = false;
  };

  sarge = buildPythonPackage rec {
    name = "sarge-${version}";
    version = "0.1.4";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/s/sarge/${name}.tar.gz";
      sha256 = "08s8896973bz1gg0pkr592w6g4p6v47bkfvws5i91p9xf8b35yar";
    };

    meta = {
      homepage = http://sarge.readthedocs.org/;
      description = "A wrapper for subprocess which provides command pipeline functionality";
      license = licenses.bsd3;
      platform = platforms.all;
      maintainers = with maintainers; [ abbradar ];
    };
  };

  hyp = buildPythonPackage rec {
    name = "hyp-server-${version}";
    version = "1.2.0";
    disabled = !isPy3k;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/h/hyp-server/${name}.tar.gz";
      sha256 = "1lafjdcn9nnq6xc3hhyizfwh6l69lc7rixn6dx65aq71c913jc15";
    };

    meta = {
      description = "Hyperminimal https server";
      homepage = https://github.com/rnhmjoj/hyp;
      license = with licenses; [gpl3Plus mit];
      maintainers = with maintainers; [ rnhmjoj ];
      platforms = platforms.unix;
    };
  };

  hypatia = buildPythonPackage rec {
    name = "hypatia-0.3";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/h/hypatia/${name}.tar.gz";
      sha256 = "fb4d394eeac4b06ff2259cada6174aebbe77edd243ffd1deda320cb327f98bd9";
    };

    buildInputs = with self; [ zope_interface zodb ];

    meta = {
      maintainers = with maintainers; [ iElectric ];
    };
  };


  zope_copy = buildPythonPackage rec {
    name = "zope.copy-4.0.2";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.copy/${name}.zip";
      sha256 = "eb2a95866df1377741876a3ee62d8600e80089e6246e1a235e86791b29534457";
    };

    buildInputs = with self; [ zope_interface zope_location zope_schema ];

    meta = {
      maintainers = with maintainers; [ iElectric ];
    };
  };


  ssdeep = buildPythonPackage rec {
    name = "ssdeep-3.1.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/s/ssdeep/${name}.tar.gz";
      sha256 = "1p9dpykmnfb73cszdiic5wbz5bmbbmkiih08pb4dah5mwq4n7im6";
    };

    buildInputs = with pkgs; [ ssdeep ];
    propagatedBuildInputs = with self; [ cffi six ];
  };


  statsd = buildPythonPackage rec {
    name = "statsd-${version}";
    version = "3.2.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/s/statsd/${name}.tar.gz";
      sha256 = "3fa92bf0192af926f7a0d9be031fe3fd0fbaa1992d42cf2f07e68f76ac18288e";
    };

    buildInputs = with self; [ nose mock ];

    meta = {
      maintainers = with maintainers; [ iElectric ];
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
    name = "py3status-2.8";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/py3status/${name}.tar.gz";
      sha256 = "1aq4l1lj6j54a8mh9y3yscbxv41bbhz89fiwnydj2gx0md5sq5v5";
    };
    propagatedBuildInputs = with self; [ requests2 ];
    prePatch = ''
      sed -i -e "s|\[\"acpi\"|\[\"${pkgs.acpi}/bin/acpi\"|" py3status/modules/battery_level.py
    '';
    meta = {
      maintainers = with maintainers; [ garbas ];
    };
  };

  multi_key_dict = buildPythonPackage rec {
    name = "multi_key_dict-${version}";
    version = "2.0.3";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/m/multi_key_dict/multi_key_dict-${version}.tar.gz";
      sha256 = "17lkx4rf4waglwbhc31aak0f28c63zl3gx5k5i1iq2m3gb0xxsyy";
    };

    meta = with stdenv.lib; {
      description = "multi_key_dict";
      homepage = "https://github.com/formiaczek/multi_key_dict";
    };
  };

  pyramid_zodbconn = buildPythonPackage rec {
    name = "pyramid_zodbconn-0.7";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyramid_zodbconn/${name}.tar.gz";
      sha256 = "56cfdb6b13dc87b1c51c7abc1557c63960d6b858e14a2d4c9693c3f7877f5f63";
    };

    # should be fixed in next release
    doCheck = false;

    buildInputs = with self; [ mock ];
    propagatedBuildInputs = with self; [ pyramid zodb zodburi ZEO ];

    meta = {
      maintainers = with maintainers; [ iElectric ];
    };
  };


  pyramid_mailer = buildPythonPackage rec {
    name = "pyramid_mailer-0.13";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyramid_mailer/${name}.tar.gz";
      sha256 = "4debfad05ee65a05ba6f43e2af913e6e30db75ba42254e4aa0291500c4caa1fc";
    };

    buildInputs = with self; [ pyramid transaction ];
    propagatedBuildInputs = with self; [ repoze_sendmail ];

    meta = {
      maintainers = with maintainers; [ iElectric ];
    };
  };

  pyrtlsdr = buildPythonPackage rec {
    name = "pyrtlsdr-0.2.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyrtlsdr/${name}.zip";
      sha256 = "cbb9086efe4320858c48f4856d09f7face191c4156510b1459ef4e5588935b6a";
    };

    postPatch = ''
      sed "s|driver_files =.*|driver_files = ['${pkgs.rtl-sdr}/lib/librtlsdr.so']|" -i rtlsdr/librtlsdr.py
    '';

    meta = {
      description = "Python wrapper for librtlsdr (a driver for Realtek RTL2832U based SDR's)";
      homepage = https://github.com/roger-/pyrtlsdr;
      license = licenses.gpl3;
      platforms = platforms.linux;
      maintainers = with maintainers; [ bjornfor ];
    };
  };


  repoze_sendmail = buildPythonPackage rec {
    name = "repoze.sendmail-4.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/r/repoze.sendmail/${name}.tar.gz";
      sha256 = "51813730adc24728d5ce2609038f7bb81aa1632539d7a79045ef4aa6942eaba2";
    };

    buildInputs = with self; [ transaction ];

    meta = {
      maintainers = with maintainers; [ iElectric ];
    };
  };


  zodburi = buildPythonPackage rec {
    name = "zodburi-2.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zodburi/${name}.tar.gz";
      sha256 = "c04b9beca032bb7b968a3464417596ba4607a927c5e65929860962ddba1cccc0";
    };

    buildInputs = with self; [ zodb mock ZEO ];

    meta = {
      maintainers = with maintainers; [ iElectric ];
    };
  };

  ZEO = self.buildPythonPackage rec {
    name = "ZEO-4.0.0";

    propagatedBuildInputs = with self; [ random2 zodb six transaction persistent zc_lockfile zconfig zdaemon zope_interface ];

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/Z/ZEO/${name}.tar.gz";
      sha256 = "63555b6d2b5f98d215c4b5fdce004fb0475daa6efc8b70f39c77d646c12d7e51";
    };

    meta = {
      homepage = https://pypi.python.org/pypi/ZEO;
    };
  };

  random2 = self.buildPythonPackage rec {
    name = "random2-1.0.1";

    doCheck = !isPyPy;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/r/random2/${name}.zip";
      sha256 = "34ad30aac341039872401595df9ab2c9dc36d0b7c077db1cea9ade430ed1c007";
    };
  };


  substanced = buildPythonPackage rec {
    # no release yet
    rev = "089818bc61c3dc5eca023254e37a280b041ea8cc";
    name = "substanced-${rev}";

    src = pkgs.fetchgit {
      inherit rev;
      url = "https://github.com/Pylons/substanced.git";
      sha256 = "17s7sdvydw9a9d2d36c70lq962ryny3dv9nzdxqpfvwiry9iy3jx";
    };

    buildInputs = with self; [ mock ];
    patchPhase = ''
      sed -i 's/assert_call(/assert_called_with(/' substanced/workflow/tests/test_workflow.py
    '';

    propagatedBuildInputs = with self; [
      pyramid
      pytz
      zodb
      venusian
      colander
      deform2
      python_magic
      pyyaml
      cryptacular
      hypatia
      zope_copy
      zope_component
      zope_deprecation
      statsd
      pyramid_zodbconn
      pyramid_mailer
      pyramid_chameleon
      ZEO
    ];

    meta = {
      maintainers = with maintainers; [ iElectric ];
    };
  };


  svg-path = buildPythonPackage rec {
    name = "svg.path-${version}";
    version = "2.0b1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/s/svg.path/${name}.zip";
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
    version = "2016.01.10";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/r/regex/${name}.tar.gz";
      sha256 = "1q3rbmnijjzn7y3cm3qy49b5lqw1fq38zv974xma387lwc37d9q2";
    };

    meta = {
      description = "Alternative regular expression module, to replace re";
      homepage = https://bitbucket.org/mrabarnett/mrab-regex;
      license = licenses.psfl;
      platforms = platforms.linux;
      maintainers = with maintainers; [ abbradar ];
    };
  };

  repoze_lru = buildPythonPackage rec {
    name = "repoze.lru-0.6";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/r/repoze.lru/${name}.tar.gz";
      sha256 = "0f7a323bf716d3cb6cb3910cd4fccbee0b3d3793322738566ecce163b01bbd31";
    };

    meta = {
      maintainers = with maintainers; [ garbas iElectric ];
      platforms = platforms.all;
    };
  };



  repoze_sphinx_autointerface = buildPythonPackage rec {
    name = "repoze.sphinx.autointerface-0.7.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/r/repoze.sphinx.autointerface/${name}.tar.gz";
      sha256 = "97ef5fac0ab0a96f1578017f04aea448651fa9f063fc43393a8253bff8d8d504";
    };

    propagatedBuildInputs = with self; [ zope_interface sphinx ];

    meta = {
      maintainers = with maintainers; [ iElectric ];
      platforms = platforms.all;
    };
  };


  rtmidi = buildPythonPackage rec {
    version = "0.3a";
    name = "rtmidi-${version}";

    src = pkgs.fetchurl {
      url = "http://chrisarndt.de/projects/python-rtmidi/download/python-${name}.tar.bz2";
      sha256 = "0d2if633m3kbiricd5hgn1csccd8xab6lnab1bq9prdr9ks9i8h6";
    };

    preConfigure = ''
      sed -i "/use_setuptools/d" setup.py
    '';

    buildInputs = with self; [ pkgs.alsaLib pkgs.libjack2 ];

    meta = {
      description = "A Python wrapper for the RtMidi C++ library written with Cython";
      homepage = http://trac.chrisarndt.de/code/wiki/python-rtmidi;
      license = licenses.mit;
      maintainers = with maintainers; [ goibhniu ];
    };
  };


  setuptools-git = buildPythonPackage rec {
    name = "setuptools-git-${version}";
    version = "1.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/s/setuptools-git/${name}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/w/watchdog/${name}.tar.gz";
      sha256 = "0qj1vqszxwfx6d1s66s96jmfmy2j94bywxiqdydh6ikpvcm8hrby";
    };

    meta = {
      description = "Python API and shell utilities to monitor file system events";
      homepage = http://github.com/gorakhargosh/watchdog;
      license = licenses.asl20;
      maintainers = with maintainers; [ goibhniu ];
    };
  };

  pywatchman = buildPythonPackage rec {
    name = "pywatchman-${version}";
    version = "1.3.0";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pywatchman/pywatchman-${version}.tar.gz";
      sha256 = "c3d5be183b5b04f6ad575fc71b06dd196185dea1558d9f4d0598ba9beaab8245";
    };
    postPatch = ''
      substituteInPlace pywatchman/__init__.py \
        --replace "'watchman'" "'${pkgs.watchman}/bin/watchman'"
    '';
  };

  zope_tales = buildPythonPackage rec {
    name = "zope.tales-4.0.2";

    propagatedBuildInputs = with self; [ zope_interface six zope_testrunner ];

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/z/zope.tales/${name}.zip";
      sha256 = "c0485f09c3f23c7a0ceddabcb02d4a40ebecf8f8f36c87fa9a02c415f96c969e";
    };
  };


  zope_deprecation = buildPythonPackage rec {
    name = "zope.deprecation-4.1.2";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.deprecation/${name}.tar.gz";
      sha256 = "fed622b51ffc600c13cc5a5b6916b8514c115f34f7ea2730409f30c061eb0b78";
    };

    buildInputs = with self; [ zope_testing ];

    meta = {
      maintainers = with maintainers; [ garbas iElectric ];
      platforms = platforms.all;
    };
  };

  validictory = buildPythonPackage rec {
    name = "validictory-1.0.0a2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/v/validictory/validictory-1.0.0a2.tar.gz";
      sha256 = "c02388a70f5b854e71e2e09bd6d762a2d8c2a017557562e866d8ffafb0934b07";
    };

    doCheck = false;

    meta = {
      description = "Validate dicts against a schema";
      homepage = http://github.com/sunlightlabs/validictory;
      license = licenses.mit;
    };
  };

  venusian = buildPythonPackage rec {
    name = "venusian-1.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/v/venusian/${name}.tar.gz";
      sha256 = "1720cff2ca9c369c840c1d685a7c7a21da1afa687bfe62edd93cae4bf429ca5a";
    };

    # TODO: https://github.com/Pylons/venusian/issues/23
    doCheck = false;

    meta = {
      maintainers = with maintainers; [ garbas iElectric ];
      platforms = platforms.all;
    };
  };


  chameleon = buildPythonPackage rec {
    name = "Chameleon-2.15";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/C/Chameleon/${name}.tar.gz";
      sha256 = "bd1dfc96742c2a5b0b2adcab823bdd848e70c45a994dc4e51dd2cc31e2bae3be";
    };

    buildInputs = with self; [] ++ optionals isPy26 [ ordereddict unittest2 ];

    # TODO: https://github.com/malthe/chameleon/issues/139
    doCheck = false;

    meta = {
       maintainers = with maintainers; [ garbas iElectric ];
      platforms = platforms.all;
    };
  };

  ddt = buildPythonPackage (rec {
    name = "ddt-1.0.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/ddt/${name}.tar.gz";
      sha256 = "e24ecb7e2cf0bf43fa9d4255d3ae2bd0b7ce30b1d1b89ace7aa68aca1152f37a";
    };

    meta = {
      description = "Data-Driven/Decorated Tests, a library to multiply test cases";

      homepage = https://github.com/txels/ddt;

      license = licenses.mit;
    };
  });

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

  deluge = buildPythonPackage rec {
    name = "deluge-1.3.12";

    src = pkgs.fetchurl {
      url = "http://download.deluge-torrent.org/source/${name}.tar.bz2";
      sha256 = "14rwc5k7q0d36b4jxnmxgnyvx9lnmaifxpyv0z07ymphlfr4amsn";
    };

    propagatedBuildInputs = with self; [
      pyGtkGlade pkgs.libtorrentRasterbar twisted Mako chardet pyxdg self.pyopenssl modules.curses
    ];

    nativeBuildInputs = [ pkgs.intltool ];

    postInstall = ''
       mkdir -p $out/share/applications
       cp -R deluge/data/pixmaps $out/share/
       cp -R deluge/data/icons $out/share/
       cp deluge/data/share/applications/deluge.desktop $out/share/applications
    '';

    meta = {
      homepage = http://deluge-torrent.org;
      description = "Torrent client";
      license = licenses.gpl3Plus;
      maintainers = with maintainers; [ iElectric ebzzry ];
      platforms = platforms.all;
    };
  };

  pyxdg = buildPythonPackage rec {
    name = "pyxdg-0.25";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyxdg/${name}.tar.gz";
      sha256 = "81e883e0b9517d624e8b0499eb267b82a815c0b7146d5269f364988ae031279d";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://freedesktop.org/wiki/Software/pyxdg;
      description = "Contains implementations of freedesktop.org standards";
      license = licenses.lgpl2;
      maintainers = with maintainers; [ iElectric ];
    };
  };

  chardet = buildPythonPackage rec {
    name = "chardet-2.3.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/c/chardet/${name}.tar.gz";
      sha256 = "e53e38b3a4afe6d1132de62b7400a4ac363452dc5dfcf8d88e8e0cce663c68aa";
    };

    meta = {
      homepage = https://github.com/chardet/chardet;
      description = "Universal encoding detector";
      license = licenses.lgpl2;
      maintainers = with maintainers; [ iElectric ];
    };
  };

  django = self.django_1_7;

  django_gis = self.django.override rec {
    patches = [
      (pkgs.substituteAll {
        src = ../development/python-modules/django/1.7.7-gis-libs.template.patch;
        geos = pkgs.geos;
        gdal = pkgs.gdal;
      })
    ];
  };

  django_1_9 = buildPythonPackage rec {
    name = "Django-${version}";
    version = "1.9.4";
    disabled = pythonOlder "2.7";

    src = pkgs.fetchurl {
      url = "http://www.djangoproject.com/m/releases/1.9/${name}.tar.gz";
      sha256 = "1sdxixj4p3wx245dm608bqw5bdabl701qab0ar5wjivyd6mfga5d";
    };

    # patch only $out/bin to avoid problems with starter templates (see #3134)
    postFixup = ''
      wrapPythonProgramsIn $out/bin "$out $pythonPath"
    '';

    # too complicated to setup
    doCheck = false;

    meta = {
      description = "A high-level Python Web framework";
      homepage = https://www.djangoproject.com/;
    };
  };

  django_1_8 = buildPythonPackage rec {
    name = "Django-${version}";
    version = "1.8.11";
    disabled = pythonOlder "2.7";

    src = pkgs.fetchurl {
      url = "http://www.djangoproject.com/m/releases/1.8/${name}.tar.gz";
      sha256 = "1yrmlj3h2hp5kc5m11ybya21x2wfr5bqqbkcsw6hknj86pkqn57c";
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


  django_1_7 = buildPythonPackage rec {
    name = "Django-${version}";
    version = "1.7.11";
    disabled = pythonOlder "2.7";

    src = pkgs.fetchurl {
      url = "http://www.djangoproject.com/m/releases/1.7/${name}.tar.gz";
      sha256 = "18arf0zr98q2gxhimm2fgh0avwcdax1mcnps0cyn06wgrr7i8f90";
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

  django_1_6 = buildPythonPackage rec {
    name = "Django-${version}";
    version = "1.6.11";

    src = pkgs.fetchurl {
      url = "http://www.djangoproject.com/m/releases/1.6/${name}.tar.gz";
      sha256 = "0misvia78c14y07zs5xsb9lv54q0v217jpaindrmhhw4wiryal3y";
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

  django_1_5 = buildPythonPackage rec {
    name = "Django-${version}";
    version = "1.5.12";

    src = pkgs.fetchurl {
      url = "http://www.djangoproject.com/m/releases/1.5/${name}.tar.gz";
      sha256 = "1vbcvn6ncg7hq5i1w95h746vkq9lmp120vx63h3p56z5nsz7gpmk";
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

  django_appconf = buildPythonPackage rec {
    name = "django-appconf-${version}";
    version = "1.0.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/django-appconf/django-appconf-${version}.tar.gz";
      sha256 = "0q3fg17qi4vwpipbj075zn4wk58p6a946kah8wayks1423xpa4xs";
    };

    propagatedBuildInputs = with self; [ six ];

    meta = {
      description = "A helper class for handling configuration defaults of packaged apps gracefully";
      homepage = http://django-appconf.readthedocs.org/;
      license = licenses.bsd2;
      maintainers = with maintainers; [ desiderius ];
    };
  };

  django_compressor = buildPythonPackage rec {
    name = "django-compressor-${version}";
    version = "1.5";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/django_compressor/django_compressor-${version}.tar.gz";
      sha256 = "0bp2acagc6b1mmcajlmjf5vvp6zj429bq7p2wks05n47pwfzv281";
    };

    propagatedBuildInputs = with self; [ django_appconf ];

    meta = {
      description = "Compresses linked and inline JavaScript or CSS into single cached files";
      homepage = http://django-compressor.readthedocs.org/en/latest/;
      license = licenses.mit;
      maintainers = with maintainers; [ desiderius ];
    };
  };

  django_compat = buildPythonPackage rec {
    name = "django-compat-${version}";
    version = "1.0.8";

    # build process attempts to access a missing README.rst
    disabled = isPy35;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/django-compat/${name}.tar.gz";
      sha256 = "195dgr55vzpw1fbjvbw2h35k9bfhvm5zchh2p7nzbq57xmwb3sra";
    };

    buildInputs = with self; [ django_nose ];
    propagatedBuildInputs = with self; [ django six ];

    meta = {
      description = "Forward and backwards compatibility layer for Django 1.4, 1.7, 1.8, and 1.9";
      homepage = https://github.com/arteria/django-compat;
      license = licenses.mit;
    };
  };

  django_evolution = buildPythonPackage rec {
    name = "django_evolution-0.7.5";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/django_evolution/${name}.tar.gz";
      sha256 = "1qbcx54hq8iy3n2n6cki3bka1m9rp39np4hqddrm9knc954fb7nv";
    };

    propagatedBuildInputs = with self; [ django_1_6 ];

    meta = {
      description = "A database schema evolution tool for the Django web framework";
      homepage = http://code.google.com/p/django-evolution/;
    };
  };


  django_tagging = buildPythonPackage rec {
    name = "django-tagging-0.3.6";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/d/django-tagging/${name}.tar.gz";
      sha256 = "e5fbeb7ca6e0c22a9a96239095dff508040ec95171e51c69e6f8ada72ea4bce2";
    };

    # error: invalid command 'test'
    doCheck = false;

    propagatedBuildInputs = with self; [ django_1_5 ];

    meta = {
      description = "A generic tagging application for Django projects";
      homepage = http://code.google.com/p/django-tagging/;
    };
  };


  django_classytags = buildPythonPackage rec {
    name = "django-classy-tags-${version}";
    version = "0.6.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/d/django-classy-tags/${name}.tar.gz";
      md5 = "eb686aa767ad8cf88c1fa0f400a42516";
      sha256 = "0wxvpmjdzk0aajk33y4himn3wqjx7k0aqlka9j8ay3yfav78bdq0";
    };

    propagatedBuildInputs = with self; [ django_1_7 ];

    # tests appear to be broken on 0.6.1 at least
    doCheck = ( version != "0.6.1" );

    meta = {
      description = "Class based template tags for Django";
      homepage = https://github.com/ojii/django-classy-tags;
      license = licenses.bsd3;
    };
  };

  django_hijack = buildPythonPackage rec {
    name = "django-hijack-${version}";
    version = "2.0.7";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/django-hijack/${name}.tar.gz";
      sha256 = "0rpi1bkfx74xfbb2nk874kfdra1jcqp2vzky1r3z7zidlc9kah04";
    };

    propagatedBuildInputs = with self; [ django django_compat ];

    meta = {
      description = "Allows superusers to hijack (=login as) and work on behalf of another user";
      homepage = https://github.com/arteria/django-hijack;
      license = licenses.mit;
    };
  };

  django_nose = buildPythonPackage rec {
    name = "django-nose-${version}";
    version = "1.4.3";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/django-nose/${name}.tar.gz";
      sha256 = "0rl9ipa98smprlw56xqlhzhps28p84wg0640qlyn0rjyrpsdmf0r";
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
      url = "https://pypi.python.org/packages/source/d/django-modelcluster/django-modelcluster-${version}.tar.gz";
      sha256 = "1plsdi44dvsj2sfx79lsrccjfg0ymajcsf5n0mln4cwd4qi5mwpx";
    };

    propagatedBuildInputs = with self; [ pytz six ];

    meta = {
      description = "Django extension to allow working with 'clusters' of models as a single unit, independently of the database";
      homepage = https://github.com/torchbox/django-modelcluster/;
      license = licenses.bsd2;
      maintainers = with maintainers; [ desiderius ];
    };
  };

  djangorestframework = buildPythonPackage rec {
    name = "djangorestframework-${version}";
    version = "3.2.3";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/djangorestframework/${name}.tar.gz";
      sha256 = "06kp4hg3y4bqy2ixlb1q6bw81gwgsb86l4lanbav7bp1grrbbnj1";
    };

    propagatedBuildInputs = with self; [ django ];

    meta = {
      description = "Web APIs for Django, made easy";
      homepage = http://www.django-rest-framework.org/;
      maintainers = with maintainers; [ desiderius ];
      license = licenses.bsd2;
    };
  };

  django_redis = makeOverridable ({ django ? self.django }: buildPythonPackage rec {
    name = "django-redis-${version}";
    version = "4.2.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/d/django-redis/${name}.tar.gz";
      sha256 = "9ad6b299458f7e6bfaefa8905f52560017369d82fb8fb0ed4b41adc048dbf11c";
    };

    buildInputs = [ self.mock ];

    propagatedBuildInputs = [ django ] ++
      (with self; [
        redis
        msgpack
      ]);

    meta = {
      description = "Full featured redis cache backend for Django";
      homepage = https://github.com/niwibe/django-redis;
      license = licenses.bsd3;
    };
  }) {};

  django_reversion = buildPythonPackage rec {
    name = "django-reversion-${version}";
    version = "1.8.5";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/d/django-reversion/${name}.tar.gz";
      md5 = "2de5a3fe82aaf505c134570f96fcc7a8";
      sha256 = "0z8fxvxgbxfnalr5br74rsw6g42nry2q656rx7rsgmicd8n42v2r";
    };

    propagatedBuildInputs = with self; [ django_1_7 ] ++
      (optionals (pythonOlder "2.7") [ importlib ordereddict ]);

    meta = {
      description = "An extension to the Django web framework that provides comprehensive version control facilities";
      homepage = https://github.com/etianen/django-reversion;
      license = licenses.bsd3;
    };
  };

  django_silk = makeOverridable ({ django ? self.django }: buildPythonPackage rec {
    name = "django-silk-${version}";
    version = "0.5.6";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/django-silk/${name}.tar.gz";
      sha256 = "845abc688738858ce06e993c4b7dbbcfcecf33029e828f143463ff96f9a78947";
    };

    buildInputs = [ self.mock ];

    propagatedBuildInputs = [ django ] ++
      (with self; [
        pygments
        simplejson
        dateutil
        requests2
        sqlparse
        jinja2
        autopep8
        pytz
        pillow
      ]);

    meta = {
      description = "Silky smooth profiling for the Django Framework";
      homepage = https://github.com/mtford90/silk;
      license = licenses.mit;
    };
  }) {};

  django_taggit = buildPythonPackage rec {
    name = "django-taggit-${version}";
    version = "0.17.0";
    disabled = pythonOlder "2.7";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/django-taggit/django-taggit-${version}.tar.gz";
      sha256 = "1xy4mm1y6z6bpakw907859wz7fiw7jfm586dj89w0ggdqlb0767b";
    };

    meta = {
      description = "django-taggit is a reusable Django application for simple tagging";
      homepage = http://github.com/alex/django-taggit/tree/master/;
      license = licenses.bsd2;
      maintainers = with maintainers; [ desiderius ];
    };
  };

  django_treebeard = buildPythonPackage rec {
    name = "django-treebeard-${version}";
    version = "3.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/django-treebeard/${name}.tar.gz";
      sha256 = "10p9rb2m1zccszg7590fjd0in6rabzsh86f5m7qm369mapc3b6dc";
    };

    propagatedBuildInputs = with self; [ django pytest ];

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
      url = "http://pypi.python.org/packages/source/d/django-pipeline/${name}.tar.gz";
      sha256 = "1y49fa8jj7x9qjj5wzhns3zxwj0s73sggvkrv660cqw5qb7d8hha";
    };

    propagatedBuildInputs = with self; [ django_1_6 futures ];

    meta = with stdenv.lib; {
      description = "Pipeline is an asset packaging library for Django";
      homepage = https://github.com/cyberdelia/django-pipeline;
      license = stdenv.lib.licenses.mit;
    };
  };

  django_pipeline_1_3 = self.django_pipeline.overrideDerivation (super: rec {
    name = "django-pipeline-1.3.27";
    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/d/django-pipeline/${name}.tar.gz";
      sha256 = "0iva3cmnh5jw54c7w83nx9nqv523hjvkbjchzd2pb6vzilxf557k";
    };
  });


  djblets = buildPythonPackage rec {
    name = "Djblets-0.9";

    src = pkgs.fetchurl {
      url = "http://downloads.reviewboard.org/releases/Djblets/0.9/${name}.tar.gz";
      sha256 = "1rr5vjwiiw3kih4k9nawislf701l838dbk5xgizadvwp6lpbpdpl";
    };

    propagatedBuildInputs = with self; [
      django_1_6 feedparser django_pipeline_1_3 pillowfight pytz ];

    meta = {
      description = "A collection of useful extensions for Django";
      homepage = https://github.com/djblets/djblets;
    };
  };

  pillowfight = buildPythonPackage rec {
    name = "pillowfight-${version}";
    version = "0.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pillowfight/pillowfight-${version}.tar.gz";
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


  keepalive = buildPythonPackage rec {
    name = "keepalive-${version}";
    version = "0.5";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/k/keepalive/keepalive-${version}.tar.gz";
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
    version = "1.7.4";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/S/SPARQLWrapper/SPARQLWrapper-${version}.tar.gz";
      sha256 = "1dpwwlcdk4m8wr3d9lb24g1xcvs202c0ir4q3jcijy88is3bvgmp";
    };

    # break circular dependency loop
    patchPhase = ''
      sed -i '/rdflib/d' requirements.txt
    '';

    propagatedBuildInputs = with self; [
      six isodate pyparsing html5lib keepalive
    ];

    meta = with stdenv.lib; {
      description = "This is a wrapper around a SPARQL service. It helps in creating the query URI and, possibly, convert the result into a more manageable format";
      homepage = "http://rdflib.github.io/sparqlwrapper";
    };
  };


  dulwich = buildPythonPackage rec {
    name = "dulwich-${version}";
    version = "0.10.1a";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/dulwich/${name}.tar.gz";
      sha256 = "02rknqarwy7p50693cqswbibqwgxzrfzdq4yhwqxbdmhbsmh0rk6";
    };

    # Only test dependencies
    buildInputs = with self; [ pkgs.git gevent geventhttpclient mock fastimport ];

    meta = {
      description = "Simple Python implementation of the Git file formats and protocols";
      homepage = http://samba.org/~jelmer/dulwich/;
      license = licenses.gpl2Plus;
      maintainers = with maintainers; [ koral ];
    };
  };


  hg-git = buildPythonPackage rec {
    name = "hg-git-${version}";
    version = "0.8.2";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/h/hg-git/${name}.tar.gz";
      sha256 = "0hz0i6qgcn3ic292sny86mdl1psj1bnczcai1b1kzvwcla6z99py";
    };

    propagatedBuildInputs = with self; [ dulwich ];

    meta = {
      description = "Push and pull from a Git server using Mercurial";
      homepage = http://hg-git.github.com/;
      maintainers = with maintainers; [ koral ];
    };
  };


  docutils = buildPythonPackage rec {
    name = "docutils-0.12";

    src = pkgs.fetchurl {
      url = "mirror://sourceforge/docutils/${name}.tar.gz";
      sha256 = "c7db717810ab6965f66c8cf0398a98c9d8df982da39b4cd7f162911eb89596fa";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      description = "An open-source text processing system for processing plaintext documentation into useful formats, such as HTML or LaTeX";
      homepage = http://docutils.sourceforge.net/;
      maintainers = with maintainers; [ garbas ];
    };
  };

  doxypy = buildPythonPackage rec {
    name = "doxypy-0.4.2";

    src = pkgs.fetchurl {
      url = "http://code.foosel.org/files/${name}.tar.gz";
      sha256 = "1afmb30zmy7942b53qa5vd3js883wwqqls35n8xfb3rnj0qnll8g";
    };

    meta = {
      homepage = http://code.foosel.org/doxypy;
      description = "An input filter for Doxygen";
    };

    doCheck = false;
  };


  dtopt = buildPythonPackage rec {
    name = "dtopt-0.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/d/dtopt/${name}.tar.gz";
      sha256 = "06ae07a12294a7ba708abaa63f838017d1a2faf6147a1e7a14ca4fa28f86da7f";
    };

    meta = {
      description = "Add options to doctest examples while they are running";
      homepage = http://pypi.python.org/pypi/dtopt;
    };
    # Test contain Python 2 print
    disabled = isPy3k;
  };


  ecdsa = buildPythonPackage rec {
    name = "ecdsa-${version}";
    version = "0.13";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/e/ecdsa/${name}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/e/elpy/${name}.tar.gz";
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
      url = "http://pypi.python.org/packages/source/e/enum/${name}.tar.gz";
      sha256 = "9bdfacf543baf2350df7613eb37f598a802f346985ca0dc1548be6494140fdff";
    };

    doCheck = !isPyPy;

    buildInputs = with self; [ ];

    propagatedBuildInputs = with self; [ ];

    meta = {
      homepage = http://pypi.python.org/pypi/enum/;
      description = "Robust enumerated type support in Python";
    };
  };

  enum34 = if pythonAtLeast "3.4" then null else buildPythonPackage rec {
    name = "enum34-${version}";
    version = "1.0.4";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/e/enum34/${name}.tar.gz";
      sha256 = "0iz4jjdvdgvfllnpmd92qxj5fnfxqpgmjpvpik0jjim3lqk9zhfk";
    };

    buildInputs = optional isPy26 self.ordereddict;

    meta = {
      homepage = https://pypi.python.org/pypi/enum34;
      description = "Python 3.4 Enum backported to 3.3, 3.2, 3.1, 2.7, 2.6, 2.5, and 2.4";
      license = "BSD";
    };
  };

  epc = buildPythonPackage rec {
    name = "epc-0.0.3";
    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/e/epc/${name}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/e/et_xmlfile/${name}.tar.gz";
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
    name = "eventlet-0.17.4";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/e/eventlet/${name}.tar.gz";
      sha256 = "0vam0qfm8p5jkpp2cv12r5bnpnv902ld7q074h7x5y5g9rqyj8c7";
    };

    buildInputs = with self; [ nose httplib2 pyopenssl  ];

    doCheck = false;  # too much transient errors to bother

    propagatedBuildInputs = optionals (!isPyPy) [ self.greenlet ];

    meta = {
      homepage = http://pypi.python.org/pypi/eventlet/;
      description = "A concurrent networking library for Python";
    };
  };

  fastimport = buildPythonPackage rec {
    name = "fastimport-${version}";
    version = "0.9.4";

    # Judging from SyntaxError
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/f/fastimport/${name}.tar.gz";
      sha256 = "0k8x7552ypx9rc14vbsvg2lc6z0r8pv9laah28pdwyynbq10825d";
    };

    checkPhase = ''
      ${python.interpreter} -m unittest discover
    '';

    meta = {
      homepage = https://launchpad.net/python-fastimport;
      description = "VCS fastimport/fastexport parser";
      maintainers = with maintainers; [ koral ];
      license = licenses.gpl2Plus;
    };
  };

  feedgenerator = buildPythonPackage (rec {
    name = "feedgenerator-1.7";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/f/feedgenerator/${name}.tar.gz";
      sha256 = "5d6b0b10134ac392be0c0c3a39c0e1d7e9c17cc7894590f75981e3f497a4a60f";
    };

    buildInputs = [ pkgs.glibcLocales ];

    LC_ALL="en_US.UTF-8";

    propagatedBuildInputs = with self; [ six pytz ];

    meta = {
      description = "Standalone version of django.utils.feedgenerator,  compatible with Py3k";
      homepage = https://github.com/dmdm/feedgenerator-py3k.git;
      maintainers = with maintainers; [ garbas ];
    };
  });

  feedparser = buildPythonPackage (rec {
    name = "feedparser-5.2.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/f/feedparser/${name}.tar.gz";
      sha256 = "1ycva69bqssalhqg45rbrfipz3l6hmycszy26k0351fhq990c0xx";
    };

    # lots of networking failures
    doCheck = false;

    meta = {
      homepage = http://code.google.com/p/feedparser/;
      description = "Universal feed parser";
      license = licenses.bsd2;
      maintainers = with maintainers; [ iElectric ];
    };
  });

  pyfribidi = buildPythonPackage rec {
    version = "0.11.0";
    name = "pyfribidi-${version}";
    disabled = isPy3k || isPyPy;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pyfribidi/${name}.zip";
      sha256 = "6f7d83c09eae0cb98a40b85ba3dedc31af4dbff8fc4425f244c1e9f44392fded";
    };

    meta = {
      description = "A simple wrapper around fribidi";
      homepage = https://github.com/pediapress/pyfribidi;
      license = stdenv.lib.licenses.gpl2;
    };
  };

  docker_compose = buildPythonPackage rec {
    version = "1.5.2";
    name = "docker-compose-${version}";
    namePrefix = "";
    disabled = isPy3k || isPyPy;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/docker-compose/${name}.tar.gz";
      sha256 = "79aa7e2e6ef9ab1936f8777476ffd4bb329875ec3d3664d239896d2f2a3c4f4f";
    };

    # lots of networking and other fails
    doCheck = false;
    buildInputs = with self; [ mock pytest nose ];
    propagatedBuildInputs = with self; [
      requests2 six pyyaml texttable docopt docker dockerpty websocket_client
      enum34 jsonschema
    ];
    patchPhase = ''
      sed -i "s/'requests >= 2.6.1, < 2.8'/'requests'/" setup.py
    '';

    meta = {
      homepage = "https://docs.docker.com/compose/";
      description = "Multi-container orchestration for Docker";
      license = licenses.asl20;
    };
  };

  filebrowser_safe = buildPythonPackage rec {
    version = "0.3.6";
    name = "filebrowser_safe-${version}";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/f/filebrowser_safe/${name}.tar.gz";
      sha256 = "02bn60fdslvng2ckn65fms3hjbzgsa8qa5161a8lr720wbx8gpj2";
    };

    buildInputs = [ self.django ];

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

  flake8 = buildPythonPackage rec {
    name = "flake8-${version}";
    version = "2.5.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/f/flake8/${name}.tar.gz";
      sha256 = "448aed48b0671fe6062f47b98c3081f3a4b36fbe99ddb8ac2a3be6e6cb135603";
    };

    buildInputs = with self; [ nose mock ];
    propagatedBuildInputs = with self; [ pyflakes pep8 mccabe ];

    meta = {
      description = "Code checking using pep8 and pyflakes";
      homepage = http://pypi.python.org/pypi/flake8;
      license = licenses.mit;
      maintainers = with maintainers; [ garbas ];
    };
  };

  flaky = buildPythonPackage rec {
    name = "flaky-${version}";
    version = "3.1.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/f/flaky/${name}.tar.gz";
      sha256 = "1x9ixika7wqjj52x8wnsh1vk7jadkdqpx01plj7mlh8slwyq4s41";
    };

    propagatedBuildInputs = with self; [ pytest ];
    buildInputs = with self; [ mock ];

    # waiting for feedback https://github.com/box/flaky/issues/97
    doCheck = false;

    meta = {
      homepage = https://github.com/box/flaky;
      description = "Plugin for nose or py.test that automatically reruns flaky tests";
      license = licenses.asl20;
    };
  };

  flask = buildPythonPackage {
    name = "flask-0.10.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/F/Flask/Flask-0.10.1.tar.gz";
      sha256 = "4c83829ff83d408b5e1d4995472265411d2c414112298f2eb4b359d9e4563373";
    };

    propagatedBuildInputs = with self; [ itsdangerous click werkzeug jinja2 ];

    meta = {
      homepage = http://flask.pocoo.org/;
      description = "A microframework based on Werkzeug, Jinja 2, and good intentions";
      license = licenses.bsd3;
    };
  };

  flask_assets = buildPythonPackage rec {
    name = "Flask-Assets-${version}";
    version = "0.10";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/F/Flask-Assets/${name}.tar.gz";
      sha256 = "1v6ika3ias21xzhg7kglki99nwfx1i33rdhnw9kdqbwxkpwbwkyl";
    };

    propagatedBuildInputs = with self; [ flask webassets flask_script nose ];

    meta = {
      homepage = http://github.com/miracle2k/flask-assets;
      description = "Asset management for Flask, to compress and merge CSS and Javascript files";
      license = licenses.bsd2;
      platforms = platforms.all;
      maintainers = with maintainers; [ abbradar ];
    };
  };

  flask_cache = buildPythonPackage rec {
    name = "Flask-Cache-0.13.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/F/Flask-Cache/${name}.tar.gz";
      sha256 = "90126ca9bc063854ef8ee276e95d38b2b4ec8e45fd77d5751d37971ee27c7ef4";
    };

    propagatedBuildInputs = with self; [ werkzeug flask ];

    meta = {
      homepage = https://github.com/thadeusb/flask-cache;
      description = "Adds cache support to your Flask application";
      license = "BSD";
    };
  };

  flask-cors = buildPythonPackage rec {
    name = "Flask-Cors-${version}";
    version = "2.1.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/F/Flask-Cors/${name}.tar.gz";
      sha256 = "0fd618a4f88ykqx4x55viz47cm9rl214q1b45a0b4mz5vhxffqpj";
    };

    buildInputs = with self; [ nose ];
    propagatedBuildInputs = with self; [ flask six ];

    meta = {
      description = "A Flask extension adding a decorator for CORS support";
      homepage = https://github.com/corydolphin/flask-cors;
      license = with licenses; [ mit ];
    };
  };

  flask_login = buildPythonPackage rec {
    name = "Flask-Login-${version}";
    version = "0.2.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/F/Flask-Login/${name}.tar.gz";
      sha256 = "09ygn0r3i3jz065a5psng6bhlsqm78msnly4z6x39bs48r5ww17p";
    };

    propagatedBuildInputs = with self; [ flask ];

    # FIXME
    doCheck = false;

    meta = {
      homepage = http://github.com/miracle2k/flask-assets;
      description = "User session management for Flask";
      license = licenses.mit;
      platforms = platforms.all;
      maintainers = with maintainers; [ abbradar ];
    };
  };

  flask_migrate = buildPythonPackage rec {
    name = "Flask-Migrate-${version}";
    version = "1.7.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/F/Flask-Migrate/Flask-Migrate-1.7.0.tar.gz";
      sha256 = "16d7vnaj9xmxvb3qbcmhahm3ldfdhzzi6y221h62x4v1v1jayx7v";
    };

    # When tests run with python3*, tests should run commands as "python3 <args>",
    # not "python <args>"
    patchPhase = ''
      substituteInPlace tests/test_migrate.py --replace "python" "${python.executable}"
      substituteInPlace tests/test_multidb_migrate.py --replace "python" "${python.executable}"
    '';

    propagatedBuildInputs = with self ; [ flask flask_sqlalchemy flask_script alembic ];

    meta = {
      description = "SQLAlchemy database migrations for Flask applications using Alembic";
      license = licenses.mit;
      homepage = https://github.com/miguelgrinberg/Flask-Migrate;
    };
  };

  flask_principal = buildPythonPackage rec {
    name = "Flask-Principal-${version}";
    version = "0.4.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/F/Flask-Principal/${name}.tar.gz";
      sha256 = "0lwlr5smz8vfm5h9a9i7da3q1c24xqc6vm9jdywdpgxfbi5i7mpm";
    };

    propagatedBuildInputs = with self; [ flask blinker nose ];

    meta = {
      homepage = http://packages.python.org/Flask-Principal/;
      description = "Identity management for flask";
      license = licenses.bsd2;
      platforms = platforms.all;
      maintainers = with maintainers; [ abbradar ];
    };
  };

  flask-pymongo = buildPythonPackage rec {
    name = "Flask-PyMongo-${version}";
    version = "0.3.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/F/Flask-PyMongo/${name}.tar.gz";
      sha256 = "0305qngvjrjyyabf8gxqgqvd9ffh00gr5yfrjf4nncr2my9svbyd";
    };

    propagatedBuildInputs = with self; [ flask pymongo_2_9_1 ];

    meta = {
      homepage = "http://flask-pymongo.readthedocs.org/";
      description = "PyMongo support for Flask applications";
      license = licenses.bsd2;
    };
  };

  flask_script = buildPythonPackage rec {
    name = "Flask-Script-${version}";
    version = "2.0.5";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/F/Flask-Script/${name}.tar.gz";
      sha256 = "0zqh2yq8zk7m9b4xw1ryqmrljkdigfb3hk5155a3b5hkfnn6xxyf";
    };

    nativeBuildInputs = with self; [ pytest ];
    propagatedBuildInputs = with self; [ flask ];

    meta = {
      homepage = http://github.com/smurfix/flask-script;
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
      url = "https://pypi.python.org/packages/source/F/Flask-SQLAlchemy/${name}.tar.gz";
      sha256 = "1i9ps5d5snih9xlqhrvmi3qfiygkmqzxh92n25kj4pf89kj4s965";
    };

    propagatedBuildInputs = with self ; [ flask sqlalchemy ];

    meta = {
      description = "SQLAlchemy extension for Flask";
      homepage = http://flask-sqlalchemy.pocoo.org/;
      license = licenses.bsd3;
    };
  };

  wtforms = buildPythonPackage rec {
    version = "2.1";
    name = "wtforms-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/W/WTForms/WTForms-${version}.zip";
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

  flexget = buildPythonPackage rec {
    version = "1.2.337";
    name = "FlexGet-${version}";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/F/FlexGet/${name}.tar.gz";
      sha256 = "0f7aaf0bf37860f0c5adfb0ba59ca228aa3f5c582131445623a4c3bc82d45346";
    };

    doCheck = false;

    buildInputs = with self; [ nose ];
    propagatedBuildInputs = with self; [ paver feedparser sqlalchemy9 pyyaml rpyc
	    beautifulsoup_4_1_3 html5lib pyrss2gen pynzb progressbar jinja2 flask
	    cherrypy requests dateutil_2_1 jsonschema python_tvrage tmdb3
      guessit pathpy apscheduler ]
	# enable deluge and transmission plugin support, if they're installed
	++ stdenv.lib.optional (pkgs.config.pythonPackages.deluge or false)
	    pythonpackages.deluge
	++ stdenv.lib.optional (pkgs.transmission != null)
	    self.transmissionrpc;

    meta = {
      homepage = http://flexget.com/;
      description = "Multipurpose automation tool for content like torrents";
      license = licenses.mit;
      maintainers = with maintainers; [ iElectric ];
    };
  };

  # py3k disabled, see https://travis-ci.org/NixOS/nixpkgs/builds/48759067
  graph-tool = if isPy3k then throw "graph-tool in Nix doesn't support py3k yet"
    else callPackage ../development/python-modules/graph-tool/2.x.x.nix { boost = pkgs.boost159; };

  grappelli_safe = buildPythonPackage rec {
    version = "0.3.13";
    name = "grappelli_safe-${version}";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/g/grappelli_safe/${name}.tar.gz";
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

  python_tvrage = buildPythonPackage (rec {
    version = "0.4.1";
    name = "tvrage-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/python-tvrage/python-tvrage-${version}.tar.gz";
      sha256 = "f8a530376c5cf1bc573d1945a8504c3394b228c731a3eff5100c705997a72063";
    };

    # has mostly networking dependent tests
    doCheck = false;
    propagatedBuildInputs = with self; [ beautifulsoup ];

    meta = {
      homepage = https://github.com/ckreutzer/python-tvrage;
      description = "Client interface for tvrage.com's XML-based api feeds";
      license = licenses.bsd3;
      maintainers = with maintainers; [ iElectric ];
    };
  });

  python2-pythondialog = buildPythonPackage rec {
    name = "python2-pythondialog-${version}";
    version = "3.3.0";
    disabled = !isPy27;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/python2-pythondialog/python2-pythondialog-${version}.tar.gz";
      sha256 = "1yhkagsh99bfi592ymczf8rnw8rk6n9hdqy3dd98m3yrx8zmjvry";
    };

    patchPhase = ''
      substituteInPlace dialog.py ":/bin:/usr/bin" ":$out/bin"
    '';

    meta = with stdenv.lib; {
      homepage = "http://pythondialog.sourceforge.net/";
    };
  };

  pyRFC3339 = buildPythonPackage rec {
    name = "pyRFC3339-${version}";
    version = "0.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pyRFC3339/pyRFC3339-${version}.tar.gz";
      sha256 = "1pp648xsjaw9h1xq2mgwzda5wis2ypjmzxlksc1a8grnrdmzy155";
    };

    propagatedBuildInputs = with self; [ pytz ];
    buildInputs = with self; [ nose ];
  };

  ConfigArgParse = buildPythonPackage rec {
    name = "ConfigArgParse-${version}";
    version = "0.9.3";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/C/ConfigArgParse/ConfigArgParse-${version}.tar.gz";
      sha256 = "0a984pvv7370yz7zbkl6s6i7yyl9myahx0m9jkjvg3hz5q8mf70l";
    };

    # no tests in tarball
    doCheck = false;
    propagatedBuildInputs = with self; [

    ];
    buildInputs = with self; [

    ];

    meta = with stdenv.lib; {
      homepage = "https://github.com/zorro3/ConfigArgParse";
    };
  };

  jsonschema = buildPythonPackage (rec {
    version = "2.5.1";
    name = "jsonschema-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/j/jsonschema/jsonschema-${version}.tar.gz";
      sha256 = "0hddbqjm4jq63y8jf44nswina1crjs16l9snb6m3vvgyg31klrrn";
    };

    buildInputs = with self; [ nose mock vcversioner ];
    propagatedBuildInputs = with self; [ functools32 ];

    patchPhase = ''
      substituteInPlace jsonschema/tests/test_jsonschema_test_suite.py --replace "python" "${python}/bin/${python.executable}"
    '';

    checkPhase = ''
      nosetests
    '';

    meta = {
      homepage = https://github.com/Julian/jsonschema;
      description = "An implementation of JSON Schema validation for Python";
      license = licenses.mit;
      maintainers = with maintainers; [ iElectric ];
    };
  });

  vcversioner = buildPythonPackage rec {
    name = "vcversioner-${version}";
    version = "2.14.0.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/v/vcversioner/vcversioner-${version}.tar.gz";
      sha256 = "11ivq1bm7v0yb4nsfbv9m7g7lyjn112gbvpjnjz8nv1fx633dm5c";
    };

    meta = with stdenv.lib; {
      homepage = "https://github.com/habnabit/vcversioner";
    };
  };

  falcon = buildPythonPackage (rec {
    name = "falcon-0.3.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/f/falcon/${name}.tar.gz";
      sha256 = "10ivzk88m8nn3bqbg6xgv6yfy2dgp6yzbcvr645y93pzlash4xpj";
    };

    propagatedBuildInputs = with self; [ coverage ddt nose pyyaml requests2 six testtools python_mimeparse ];

    # The travis build fails since the migration from multiprocessing to threading for hosting the API under test.
    # OSError: [Errno 98] Address already in use
    doCheck = false;

    # This patch is required if the tests are enabled
    # See https://github.com/falconry/falcon/issues/572
    #patches = singleton (pkgs.fetchurl {
    #  name = "falcon-572.patch";
    #  url = "https://github.com/desiderius/falcon/commit/088bd3f2204eb6368acb3a1bf6c6b54c415225c2.patch";
    #  sha256 = "19102dlzc4890skmam2v20va2vk5xr56fi4nzibzfvl7vyq68060";
    #});

    meta = {
      description = "An unladen web framework for building APIs and app backends";
      homepage = http://falconframework.org;
      license = licenses.asl20;
      maintainers = with maintainers; [ desiderius ];
    };
  });

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

  fonttools = buildPythonPackage (rec {
    version = "3.0";
    name = "fonttools-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/F/FontTools/fonttools-${version}.tar.gz";
      sha256 = "0f4iblpbf3y3ghajiccvdwk2f46cim6dsj6fq1kkrbqfv05dr4nz";
    };

    buildInputs = with self; [
      numpy
    ];

    meta = {
      homepage = "https://github.com/behdad/fonttools";
      description = "Font file processing tools";
    };
  });

  foolscap = buildPythonPackage (rec {
    name = "foolscap-0.10.1";

    src = pkgs.fetchurl {
      url = "http://foolscap.lothar.com/releases/${name}.tar.gz";
      sha256 = "1wrnbdq3y3lfxnhx30yj9xbr3iy9512jb60k8qi1da1phalnwz5x";
    };

    propagatedBuildInputs = [ self.twisted self.pyopenssl self.service-identity ];

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
      url= "https://pypi.python.org/packages/source/f/forbiddenfruit/${name}.tar.gz";
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
      url    = "https://pypi.python.org/packages/source/f/fs/${name}.tar.gz";
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

  fuse = buildPythonPackage (rec {
    baseName = "fuse";
    version = "0.2.1";
    name = "${baseName}-${version}";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://sourceforge/fuse/fuse-python-${version}.tar.gz";
      sha256 = "06rmp1ap6flh64m81j0n3a357ij2vj9zwcvvw0p31y6hz1id9shi";
    };

    buildInputs = with self; [ pkgs.pkgconfig pkgs.fuse ];

    meta = {
      description = "Python bindings for FUSE";
      license = licenses.lgpl21;
    };
  });

  fusepy = buildPythonPackage rec {
    name = "fusepy-2.0.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/f/fusepy/${name}.tar.gz";
      sha256 = "1z0va3z1hzjw167skl21k9dsklbmr46k66j80qadibjc8vajjnda";
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
      homepage = http://github.com/terencehonles/fusepy;
      license = licenses.isc;
      platforms = platforms.unix;
      maintainers = with maintainers; [ nckx ];
    };
  };

  future = buildPythonPackage rec {
    version = "0.15.2";
    name = "future-${version}";

    src = pkgs.fetchurl {
      url = "http://github.com/PythonCharmers/python-future/archive/v${version}.tar.gz";
      sha256 = "0vm61j5br6jiry6pgcxnwvxhki8ksnirp7k9mcbmxmgib3r60xd3";
    };

    propagatedBuildInputs = with self; optionals isPy26 [ importlib argparse ];
    doCheck = false;

    meta = {
      description = "Clean single-source support for Python 3 and 2";
      longDescription = ''
        python-future is the missing compatibility layer between Python 2 and
        Python 3. It allows you to use a single, clean Python 3.x-compatible
        codebase to support both Python 2 and Python 3 with minimal overhead.

        It provides future and past packages with backports and forward ports
        of features from Python 3 and 2. It also comes with futurize and
        pasteurize, customized 2to3-based scripts that helps you to convert
        either Py2 or Py3 code easily to support both Python 2 and 3 in a
        single clean Py3-style codebase, module by module.
      '';
      homepage = https://python-future.org;
      downloadPage = https://github.com/PythonCharmers/python-future/releases;
      license = licenses.mit;
      maintainers = with maintainers; [ prikhi ];
      platforms = platforms.linux;
    };
  };

  futures = buildPythonPackage rec {
    name = "futures-${version}";
    version = "3.0.4";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/f/futures/${name}.tar.gz";
      sha256 = "19485d83f7bd2151c0aeaf88fbba3ee50dadfb222ffc3b66a344ef4952b782a3";
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
      url = "https://pypi.python.org/packages/source/f/futures/${name}.tar.gz";
      sha256 = "1lqfzl3z3pkxakgbcrfy6x7x0fp3q18mj5lpz103ljj7fdqha70m";
    };
  };

  gcovr = buildPythonPackage rec {
    name = "gcovr-2.4";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/g/gcovr/${name}.tar.gz";
      sha256 = "2c878e03c2eff2282e64035bec0a30532b2b1173aadf08486401883b79e4dab1";
    };

    meta = {
      description = "A Python script for summarizing gcov data";
      license = "BSD";
    };
  };

  gdrivefs = buildPythonPackage rec {
    version = "0.14.3";
    name = "gdrivefs-${version}";
    disabled = !isPy27;

    src = pkgs.fetchFromGitHub {
      sha256 = "1ljkh1871lwzn5lhhgbmbf2hfnbnajr3ddz3q5n1kid25qb3l086";
      rev = version;
      repo = "GDriveFS";
      owner = "dsoprea";
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

    buildInputs = with self; [ pkgs.setuptools ];

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

  gevent = buildPythonPackage rec {
    name = "gevent-1.0.2";
    disabled = isPy3k || isPyPy;  # see https://github.com/surfly/gevent/issues/248

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/g/gevent/${name}.tar.gz";
      sha256 = "0cds7yvwdlqmd590i59vzxaviwxk4js6dkhnmdxb3p1xac7wmq9s";
    };

    patchPhase = ''
      substituteInPlace libev/ev.c --replace \
        "ecb_inline void ecb_unreachable (void) ecb_noreturn" \
        "ecb_inline ecb_noreturn void ecb_unreachable (void)"
    '';

    buildInputs = with self; [ pkgs.libev ];
    propagatedBuildInputs = optionals (!isPyPy) [ self.greenlet ];

    meta = {
      description = "Coroutine-based networking library";
      homepage = http://www.gevent.org/;
      license = licenses.mit;
      platforms = platforms.unix;
      maintainers = with maintainers; [ bjornfor ];
    };
  };

  geventhttpclient = buildPythonPackage rec {
    name = "geventhttpclient-${version}";
    version = "1.2.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/g/geventhttpclient/${name}.tar.gz";
      sha256 = "0s1qd1qz0zyzksd5h38ynw06d1012h0k7z8522zhb6mzaq4144yz";
    };

    propagatedBuildInputs = with self; [ gevent certifi backports_ssl_match_hostname_3_4_0_2 ];

    meta = {
      homepage = http://github.com/gwik/geventhttpclient;
      description = "HTTP client library for gevent";
      license = licenses.mit;
      maintainers = with maintainers; [ koral ];
    };
  };

  gevent-socketio = buildPythonPackage rec {
    name = "gevent-socketio-0.3.6";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/g/gevent-socketio/${name}.tar.gz";
      sha256 = "1zra86hg2l1jcpl9nsnqagy3nl3akws8bvrbpgdxk15x7ywllfak";
    };

    buildInputs = with self; [ versiontools gevent-websocket mock pytest ];
    propagatedBuildInputs = with self; [ gevent ];

  };

  gevent-websocket = buildPythonPackage rec {
    name = "gevent-websocket-0.9.3";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/g/gevent-websocket/${name}.tar.gz";
      sha256 = "07rqwfpbv13mk6gg8mf0bmvcf6siyffjpgai1xd8ky7r801j4xb4";
    };

    propagatedBuildInputs = with self; [ gevent ];

  };

  genzshcomp = buildPythonPackage {
    name = "genzshcomp-0.5.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/g/genzshcomp/genzshcomp-0.5.1.tar.gz";
      sha256 = "c77d007cc32cdff836ecf8df6192371767976c108a75b055e057bb6f4a09cd42";
    };

    buildInputs = with self; [ pkgs.setuptools ] ++ (optional isPy26 argparse);

    meta = {
      description = "automatically generated zsh completion function for Python's option parser modules";
      license = "BSD";
    };
  };


  gflags = buildPythonPackage rec {
    name = "gflags-2.0";

    src = pkgs.fetchurl {
      url = "http://python-gflags.googlecode.com/files/python-${name}.tar.gz";
      sha256 = "1mkc7315bpmh39vbn0jq237jpw34zsrjr1sck98xi36bg8hnc41i";
    };

    meta = {
      homepage = http://code.google.com/p/python-gflags/;
      description = "A module for command line handling, similar to Google's gflags for C++";
    };
  };

  gipc = buildPythonPackage rec {
    name = "gipc-0.5.0";
    disabled = !isPy26 && !isPy27;

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/g/gipc/${name}.zip";
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
      url = "https://pypi.python.org/packages/source/g/git-sweep/${name}.tar.gz";
      sha256 = "1csp0zd049d643d409rfivbswwzrayb4i6gkypp5mc27fb1z2afd";
    };

    propagatedBuildInputs = with self; [ GitPython ];

    meta = {
      description = "A command-line tool that helps you clean up Git branches";
      homepage = http://lab.arc90.com/2012/04/03/git-sweep/;
      license = licenses.mit;
      maintainers = with maintainers; [ pSub ];
    };
  };

  glances = buildPythonPackage rec {
    name = "glances-${version}";
    version = "2.4.2";
    disabled = isPyPy;

    src = pkgs.fetchFromGitHub {
      owner = "nicolargo";
      repo = "glances";
      rev = "v${version}";
      sha256 = "1ghx62z63yyf8wv4bcvfxwxs5mc7b4nrcss6lc1i5s0yjvzvyi6h";
    };

    doCheck = false;

    buildInputs = with self; [ unittest2 ];
    propagatedBuildInputs = with self; [ modules.curses modules.curses_panel psutil setuptools bottle batinfo pkgs.hddtemp pysnmp ];

    preConfigure = ''
      sed -i 's/data_files\.append((conf_path/data_files.append(("etc\/glances"/' setup.py;
    '';

    meta = {
      homepage = "http://nicolargo.github.io/glances/";
      description = "Cross-platform curses-based monitoring tool";
    };
  };

  github3_py = buildPythonPackage rec {
    name = "github3.py-${version}";
    version = "1.0.0a2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/g/github3.py/${name}.tar.gz";
      sha256 = "11xvwbzfy04vwbjnpc8wcrjjzghbrbdzffrdfk70v0zdnxqg8hc5";
    };

    buildInputs = with self; [ unittest2 pytest mock betamax betamax-matchers ];

    propagatedBuildInputs = with self; [ requests2 pyopenssl uritemplate_py
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

  goobook = buildPythonPackage rec {
    name = "goobook-1.9";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url    = "https://pypi.python.org/packages/source/g/goobook/${name}.tar.gz";
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
    name = "google-api-python-client-1.2";

    src = pkgs.fetchurl {
      url = "https://google-api-python-client.googlecode.com/files/google-api-python-client-1.2.tar.gz";
      sha256 = "0xd619w71xk4ldmikxqhaaqn985rc2hy4ljgwfp50jb39afg7crw";
    };

    propagatedBuildInputs = with self; [ httplib2 ];

    meta = {
      description = "The core Python library for accessing Google APIs";
      homepage = "https://code.google.com/p/google-api-python-client/";
      license = licenses.asl20;
      platforms = platforms.unix;
    };
  };

  google_apputils = buildPythonPackage rec {
    name = "google-apputils-0.4.1";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/g/google-apputils/${name}.tar.gz";
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


  greenlet = buildPythonPackage rec {
    name = "greenlet-${version}";
    version = "0.4.7";
    disabled = isPyPy;  # builtin for pypy

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/g/greenlet/${name}.zip";
      sha256 = "1zlmsygjw69xlq56vz1z5ivzy9bwc7knjaykn2yy2hv4w2j4yb7k";
    };

    # see https://github.com/python-greenlet/greenlet/issues/85
    preCheck = ''
      rm tests/test_leaks.py
    '';

    meta = {
      homepage = http://pypi.python.org/pypi/greenlet;
      description = "Module for lightweight in-process concurrent programming";
      license     = licenses.lgpl2;
      platforms   = platforms.all;
    };
  };

  gspread = buildPythonPackage rec {
    version = "0.2.3";
    name = "gspread-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/g/gspread/${name}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/g/gssapi/${name}.tar.gz";
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
      sha256 = "176sdxkva2irr1v645nn4q6rwc6grbb1wxj82n7x9hh09q4bxqcz";
    };

    patches = optionals pkgs.stdenv.isDarwin [
      ../development/python-modules/gyp/no-darwin-cflags.patch
    ];

    meta = {
      description = "A tool to generate native build files";
      homepage = https://chromium.googlesource.com/external/gyp/+/master/README.md;
      license = licenses.bsd3;
      maintainers = with maintainers; [ codyopel ];
      platforms = platforms.all;
    };
  };

  guessit = buildPythonPackage rec {
    version = "0.9.4";
    name = "guessit-${version}";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/g/guessit/${name}.tar.gz";
      sha256 = "068d3dmyk4v04p2zna0340lsdnpkm10gyza62apd9akgjh9rfs48";
    };

    propagatedBuildInputs = with self; [
      dateutil_2_1 requests stevedore babelfish pyyaml
    ];

    # A unicode test fails
    doCheck = false;

    meta = {
      homepage = http://pypi.python.org/pypi/guessit;
      license = licenses.lgpl3;
      description = "A library for guessing information from video files";
    };
  };

  gunicorn = buildPythonPackage rec {
    name = "gunicorn-19.1.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/g/gunicorn/${name}.tar.gz";
      sha256 = "ae1dd6452f62b3470bc9acaf62cb5301545fbb9c697d863a5bfe35097ed7a0b3";
    };

    buildInputs = with self; [ pytest ];

    meta = {
      homepage = http://pypi.python.org/pypi/gunicorn;
      description = "WSGI HTTP Server for UNIX";
    };
  };

  hawkauthlib = buildPythonPackage rec {
    name = "hawkauthlib-${version}";
    version = "0.1.1";
    src = pkgs.fetchgit {
      url = https://github.com/mozilla-services/hawkauthlib.git;
      rev = "refs/tags/v${version}";
      sha256 = "0b3xydii50ifs8qkgbpdlidfs2rzw63f807ahrq9flz90ahf582h";
    };

    propagatedBuildInputs = with self; [ requests webob ];
  };

  hcs_utils = buildPythonPackage rec {
    name = "hcs_utils-1.5";

    src = pkgs.fetchurl {
      url    = "https://pypi.python.org/packages/source/h/hcs_utils/${name}.tar.gz";
      sha256 = "1d2za9crkgzildx610w3zif2i8phcqhh6n8nzg3yvy2mg0s18mkl";
    };

    LC_ALL="en_US.UTF-8";

    buildInputs = with self; [ six pkgs.glibcLocales ];

    meta = {
      description = "Library collecting some useful snippets";
      homepage    = https://pypi.python.org/pypi/hcs_utils/1.3;
      license     = licenses.isc;
      maintainers = with maintainers; [ lovek323 ];
      platforms   = platforms.unix;
    };
  };


  hetzner = buildPythonPackage rec {
    name = "hetzner-${version}";
    version = "0.7.4";

    src = pkgs.fetchFromGitHub {
      repo = "hetzner";
      owner = "RedMoonStudios";
      rev = "v${version}";
      sha256 = "04dlixczzvpimk48p87ix7j9q54jy46cwn4f05n2dlzsyc5vvxin";
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
      url = "https://pypi.python.org/packages/source/h/htmllaundry/${name}.tar.gz";
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
    version = "0.999";
    name = "html5lib-${version}";

    src = pkgs.fetchurl {
      url = "http://github.com/html5lib/html5lib-python/archive/${version}.tar.gz";
      sha256 = "1kxl36p0csssaf37zbbc9p4h8l1s7yb1qnfv3d4nixplvrxqkybp";
    };

    buildInputs = with self; [ nose flake8 ];
    propagatedBuildInputs = with self; [
      six
    ] ++ optionals isPy26 [ ordereddict ];

    checkPhase = "nosetests";

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
      maintainers = with maintainers; [ iElectric prikhi ];
    };
  });

  http_signature = buildPythonPackage (rec {
    name = "http_signature-0.1.4";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/h/http_signature/${name}.tar.gz";
      sha256 = "14acc192ef20459d5e11b4e800dd3a4542f6bd2ab191bf5717c696bf30936c62";
    };

    propagatedBuildInputs = with self; [pycrypto];

    meta = {
      homepage = https://github.com/atl/py-http-signature;
      description = "";
      license = licenses.mit;
    };
  });

  httpbin = buildPythonPackage rec {
    name = "httpbin-0.2.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/h/httpbin/${name}.tar.gz";
      sha256 = "6b57f563900ecfe126015223a259463848daafbdc2687442317c0992773b9054";
    };

    propagatedBuildInputs = with self; [ flask markupsafe decorator itsdangerous six ];

    meta = {
      homepage = https://github.com/kennethreitz/httpbin;
      description = "HTTP Request & Response Service";
      license = licenses.mit;
    };

  };

  httplib2 = buildPythonPackage rec {
    name = "httplib2-0.9.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/h/httplib2/${name}.tar.gz";
      sha256 = "1xc3clbrf77r0600kja71j7hk1218sjiq0gfmb8vjdajka8kjqxw";
    };

    meta = {
      homepage = http://code.google.com/p/httplib2;
      description = "A comprehensive HTTP client library";
      license = licenses.mit;
      maintainers = with maintainers; [ garbas ];
    };
  };

  hypothesis1 = buildPythonPackage rec {
    name = "hypothesis-1.14.0";

    buildInputs = with self; [fake_factory django numpy pytz flake8 pytest ];

    doCheck = false;  # no tests in source

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/h/hypothesis/${name}.tar.gz";
      sha256 = "12dxrvn108q2j20brrk6zcb8w00kn3af1c07c0fv572nf2ngyaxy";
    };

    meta = {
      description = "A Python library for property based testing";
      homepage = https://github.com/DRMacIver/hypothesis;
      license = licenses.mpl20;
    };
  };

  hypothesis = buildPythonPackage rec {
    # http://hypothesis.readthedocs.org/en/latest/packaging.html

    name = "hypothesis-${version}";
    version = "3.1.0";

    # Upstream prefers github tarballs
    src = pkgs.fetchFromGitHub {
      owner = "DRMacIver";
      repo = "hypothesis";
      rev = "${version}";
      sha256 = "1fhdb2vwc4blas5fvcly6pmha8psqm4bhi67jz32ypjryzk09iyf";
    };

    buildInputs = with self; [ flake8 pytest flaky ];
    propagatedBuildInputs = with self; ([ pytz fake_factory django numpy ] ++ optionals isPy27 [ enum34 modules.sqlite3 ]);

    # https://github.com/DRMacIver/hypothesis/issues/300
    checkPhase = ''
      ${python.interpreter} -m pytest tests/cover
    '';

    meta = {
      description = "A Python library for property based testing";
      homepage = https://github.com/DRMacIver/hypothesis;
      license = licenses.mpl20;
    };
  };

  httpretty = buildPythonPackage rec {
    name = "httpretty-${version}";
    version = "0.8.6";
    disabled = isPy3k;
    doCheck = false;

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/h/httpretty/${name}.tar.gz";
      sha256 = "0f295zj272plr9lhf80kgz19dxkargwv3ar83rwavrcy516mgg9n";
    };

    buildInputs = with self; [ tornado requests2 httplib2 sure nose coverage certifi ];

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
      url = "https://pypi.python.org/packages/source/i/icalendar/${name}.tar.gz";
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

  importlib = buildPythonPackage rec {
    name = "importlib-1.0.2";

    disabled = (!isPy26) || isPyPy;

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/i/importlib/importlib-1.0.2.tar.gz";
      md5 = "4aa23397da8bd7c7426864e88e4db7e1";
    };
  };

  influxdb = buildPythonPackage rec {
    name = "influxdb-0.1.12";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/i/influxdb/${name}.tar.gz";
      sha256 = "6b5ea154454b86d14f2a3960d180e666ba9863da964032dacf2b50628e774a33";
    };

    # ImportError: No module named tests
    doCheck = false;
    propagatedBuildInputs = with self; [ requests ];

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

  inginious = let
    # patched version of docker bindings.
    docker-custom = self.docker.override {
      name = "docker-1.3.0-dirty";
      src = pkgs.fetchFromGitHub {
        owner = "GuillaumeDerval";
        repo = "docker-py";
        # tip of branch "master"
        rev = "966becd0af514e67de5afbf885257a5005e49626";
        sha256 = "09k41dh86cbb7z4b8926fi5b2qq670mm6agl5py3giacakrap66c";
      };
    };

    webpy-custom = self.web.override {
      name = "web.py-INGI";
      src = pkgs.fetchFromGitHub {
        owner = "UCL-INGI";
        repo = "webpy-INGI";
        # tip of branch "ingi"
        rev = "f487e78d65d6569eb70003e588d5c6ace54c384f";
        sha256 = "159vwmb8554xk98rw380p3ah170r6gm861r1nqf2l452vvdfxscd";
      };
    };
   in buildPythonPackage rec {
    version = "0.3a2.dev0";
    name = "inginious-${version}";

    disabled = isPy3k;

    patchPhase = ''
      # transient failures
      substituteInPlace inginious/backend/tests/TestRemoteAgent.py \
        --replace "test_update_task_directory" "noop"
    '';

    propagatedBuildInputs = with self; [
      requests2
      cgroup-utils docker-custom docutils lti mock pygments
      pymongo pyyaml rpyc sh simpleldap sphinx_rtd_theme tidylib
      websocket_client watchdog webpy-custom
    ];

    buildInputs = with self; [ nose selenium virtual-display ];

    /* Hydra fix exists only on github for now.
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/I/INGInious/INGInious-${version}.tar.gz";
      md5 = "40474dd6b6d4fc26e47a1d9c77bcf943";
    };
    */
    src = pkgs.fetchFromGitHub {
      owner = "UCL-INGI";
      repo = "INGInious";
      rev = "e019a0e28c442b4201ec4a0be2a816c4ab639683";
      sha256 = "1pwbm7f7xn50rxzwrqpji58n2ami5r3lgbdpb61q0w3dwkxvvvfk";
    };

    meta = {
      description = "An intelligent grader that allows secured and automated testing of code made by students";
      homepage = "https://github.com/UCL-INGI/INGInious";
      license = licenses.agpl3;
      maintainers = with maintainers; [ layus ];
    };
  };

  interruptingcow = buildPythonPackage rec {
    name = "interruptingcow-${version}";
    version = "0.6";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/i/interruptingcow/${name}.tar.gz";
      sha256 = "1cv4pm2h0f87n9w4r3l1f96skwmng95sawn7j00ns0rdp1zshr9d";
    };

    meta = {
      description = "A watchdog that interrupts long running code";
      homepage = https://bitbucket.org/evzijst/interruptingcow;
      license = licenses.mit;
      maintainers = with maintainers; [ benley ];
    };
  };

  iptools = buildPythonPackage rec {
    version = "0.6.1";
    name = "iptools-${version}";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/i/iptools/iptools-${version}.tar.gz";
      sha256 = "0f03875a5bed740ba4bf44decb6a78679cca914a1ee8a6cc468114485c4d98e3";
    };

    buildInputs = with self; [ nose ];

    meta = {
      description = "Utilities for manipulating IP addresses including a class that can be used to include CIDR network blocks in Django's INTERNAL_IPS setting";
      homepage = http://pypi.python.org/pypi/iptools;
    };
  };


  ipy = buildPythonPackage rec {
    version = "0.74";
    name = "ipy-${version}";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/I/IPy/IPy-${version}.tar.gz";
      sha256 = "5d6abb870c25f946c45c35cf50e66155598660f2765b35cb12e36ed5223c2b89";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      description = "Class and tools for handling of IPv4 and IPv6 addresses and networks";
      homepage = http://pypi.python.org/pypi/IPy;
    };
  };

  ipykernel = buildPythonPackage rec {
    version = "4.3.0";
    name = "ipykernel-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/i/ipykernel/${name}.tar.gz";
      sha256 = "1av769gbzfm1zy9p94wicwwwxmyc7s7zk1ginq16x0wc69hwc57j";
    };

    buildInputs = with self; [ nose ] ++ optionals isPy27 [mock];
    propagatedBuildInputs = with self; [
      ipython
      jupyter_client
      pexpect
      traitlets
      tornado
    ];

    # Tests require backends.
    # I don't want to add all supported backends as propagatedBuildInputs
    doCheck = false;

    meta = {
      description = "IPython Kernel for Jupyter";
      homepage = http://ipython.org/;
      license = licenses.bsd3;
      maintainers = with maintainers; [ fridh ];
    };
  };

  ipyparallel = buildPythonPackage rec {
    version = "5.0.0";
    name = "ipyparallel-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/i/ipyparallel/${name}.tar.gz";
      sha256 = "ffa7e2e29fdc4844b3c1721f46b42eee5a1abe5cbb851ccf79d0f4f89b9fe21a";
    };

    buildInputs = with self; [ nose ];

    propagatedBuildInputs = with self; [ipython_genutils decorator pyzmq ipython jupyter_client ipykernel tornado
    ] ++ optionals (!isPy3k) [ futures ];

    # Requires access to cluster
    doCheck = false;

    meta = {
      description = "Interactive Parallel Computing with IPython";
      homepage = http://ipython.org/;
      license = licenses.bsd3;
      maintainers = with maintainers; [ fridh ];
    };

  };

  ipython = buildPythonPackage rec {
    version = "4.1.2";
    name = "ipython-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/i/ipython/${name}.tar.gz";
      sha256 = "14hnf3m087z39ndn5irj1ficc6l197bmdj6fpvz8bwi7la99cbq5";
    };

    prePatch = stdenv.lib.optionalString stdenv.isDarwin ''
      substituteInPlace setup.py --replace "'gnureadline'" " "
    '';

    buildInputs = with self; [ nose pkgs.glibcLocales pygments ] ++ optionals isPy27 [mock];

    propagatedBuildInputs = with self;
      [decorator pickleshare simplegeneric traitlets readline requests2 pexpect sqlite3]
      ++ optionals stdenv.isDarwin [appnope gnureadline];

    LC_ALL="en_US.UTF-8";

    doCheck = false; # Circular dependency with ipykernel

    checkPhase = ''
      nosetests
    '';
    meta = {
      description = "IPython: Productive Interactive Computing";
      homepage = http://ipython.org/;
      license = licenses.bsd3;
      maintainers = with maintainers; [ bjornfor jgeerds fridh ];
    };
  };

  ipython_genutils = buildPythonPackage rec {
    version = "0.1.0";
    name = "ipython_genutils-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/i/ipython_genutils/${name}.tar.gz";
      sha256 = "3a0624a251a26463c9dfa0ffa635ec51c4265380980d9a50d65611c3c2bd82a6";
    };

    LC_ALL = "en_US.UTF-8";
    buildInputs = with self; [ nose pkgs.glibcLocales ];

    checkPhase = ''
      nosetests -v ipython_genutils/tests
    '';

    meta = {
      description = "Vestigial utilities from IPython";
      homepage = http://ipython.org/;
      license = licenses.bsd3;
      maintainers = with maintainers; [ fridh ];
    };
  };


  ipywidgets = buildPythonPackage rec {
    version = "4.1.1";
    name = "ipywidgets-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/i/ipywidgets/${name}.tar.gz";
      sha256 = "ceeb325e45ade9537c2d115fed9d522e5c6e90bb161592e2f0807375dc661028";
    };

    buildInputs = with self; [ nose ];
    propagatedBuildInputs = with self; [ipython ipykernel traitlets notebook];

    meta = {
      description = "IPython HTML widgets for Jupyter";
      homepage = http://ipython.org/;
      license = licenses.bsd3;
      maintainers = with maintainers; [ fridh ];
    };
  };

  ipaddr = buildPythonPackage rec {
    name = "ipaddr-2.1.10";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/i/ipaddr/${name}.tar.gz";
      sha256 = "18ycwkfk3ypb1yd09wg20r7j7zq2a73d7j6j10qpgra7a7abzhyj";
    };

    meta = {
      description = "Google's IP address manipulation library";
      homepage = http://code.google.com/p/ipaddr-py/;
      license = licenses.asl20;
    };
  };

  ipaddress = if (pythonAtLeast "3.3") then null else buildPythonPackage rec {
    name = "ipaddress-1.0.15";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/i/ipaddress/${name}.tar.gz";
      sha256 = "0dk6ky7akh5j4y3qbpnbi0qby64nyprbkrjm2s32pcfdr77qav5g";
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
      url = "http://pypi.python.org/packages/source/i/ipdb/${name}.zip";
      sha256 = "1763d1564113f5eb89df77879a8d3213273c4d7ff93dcb37a3070cdf0c34fd7c";
    };
    propagatedBuildInputs = with self; [ ipython ];
  };

  ipdbplugin = buildPythonPackage {
    name = "ipdbplugin-1.4";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/i/ipdbplugin/ipdbplugin-1.4.tar.gz";
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

  iso8601 = buildPythonPackage rec {
    name = "iso8601-${version}";
    version = "0.1.11";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/i/iso8601/${name}.tar.gz";
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
    name = "isort-4.2.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/i/isort/${name}.tar.gz";
      sha256 = "0xqxnkli3j69mj1m0i1r9n68bfkdxfcgxi602lqgy491m21q1rpj";
    };

    buildInputs = with self; [ mock pytest ];

    meta = {
      description = "A Python utility / library to sort Python imports";
      homepage = https://github.com/timothycrosley/isort;
      license = licenses.mit;
      maintainers = with maintainers; [ couchemar ];
    };
  };

  jedi = buildPythonPackage (rec {
    name = "jedi-0.9.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/j/jedi/${name}.tar.gz";
      sha256 = "0c8x962ynpx001fdvp07m2q5jk4igkxbj3rmnydavphvlgxijk1v";
    };

    buildInputs = [ self.pytest ];

    checkPhase = ''
      py.test test
    '';

    # 7 failed
    doCheck = false;

    meta = {
      homepage = https://github.com/davidhalter/jedi;
      description = "An autocompletion tool for Python that can be used for text editors";
      license = licenses.lgpl3Plus;
      maintainers = with maintainers; [ garbas ];
    };
  });

  jellyfish = buildPythonPackage rec {
    version = "0.5.0";
    name = "jellyfish-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/j/jellyfish/${name}.tar.gz";
      sha256 = "04p80gwwlhxjp8zpjf70a62x69l9rlvnz1pwi5ar52gyajn8z6z1";
    };

    buildInputs = with self; [ pytest unicodecsv ];

    meta = {
      homepage = http://github.com/sunlightlabs/jellyfish;
      description = "Approximate and phonetic matching of strings";
      maintainers = with maintainers; [ koral ];
    };
  };

  j2cli = buildPythonPackage rec {
    name = "j2cli-${version}";
    version = "0.3.1-0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/j/j2cli/${name}.tar.gz";
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

  jinja2 = buildPythonPackage rec {
    name = "Jinja2-2.8";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/J/Jinja2/${name}.tar.gz";
      sha256 = "1x0v41lp5m1pjix3l46zx02b7lqp2hflgpnxwkywxynvi3zz47xw";
    };

    propagatedBuildInputs = with self; [ markupsafe ];

    meta = {
      homepage = http://jinja.pocoo.org/;
      description = "Stand-alone template engine";
      license = licenses.bsd3;
      longDescription = ''
        Jinja2 is a template engine written in pure Python. It provides a
        Django inspired non-XML syntax but supports inline expressions and
        an optional sandboxed environment.
      '';
      platforms = platforms.all;
      maintainers = with maintainers; [ pierron garbas sjourdois ];
    };
  };


  jmespath = buildPythonPackage rec {
    name = "jmespath-0.7.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/j/jmespath/${name}.tar.gz";
      sha256 = "1lazbx65imassd7h24z49za001rvx1lmx8r0l21h4izs7pp14nnd";
    };

    buildInputs = with self; [ nose ];
    propagatedBuildInputs = with self; [ ply ];

    meta = {
      homepage = https://github.com/boto/jmespath;
      description = "JMESPath allows you to declaratively specify how to extract elements from a JSON document";
      license = "BSD";
    };
  };


  jrnl = buildPythonPackage rec {
    name = "jrnl-1.9.7";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/j/jrnl/${name}.tar.gz";
      sha256 = "af599a863ac298533685a7236fb86307eebc00a38eb8bb96f4f67b5d83227ec8";
    };

    propagatedBuildInputs = with self; [
      pytz six tzlocal keyring modules.readline argparse dateutil_1_5
      parsedatetime
    ];

    meta = {
      homepage = http://maebert.github.io/jrnl/;
      description = "A simple command line journal application that stores your journal in a plain text file";
      license = licenses.mit;
    };
  };

  jupyter_client = buildPythonPackage rec {
    version = "4.1.1";
    name = "jupyter_client-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/j/jupyter_client/${name}.tar.gz";
      sha256 = "ff1ef5c6c3031a62db46ec6329867b4cb1595e6102a7819b3b5252b0c524bdb8";
    };

    buildInputs = with self; [ nose ];
    propagatedBuildInputs = with self; [traitlets jupyter_core pyzmq] ++ optional isPyPy py;

    checkPhase = ''
      nosetests -v
    '';

    # Circular dependency with ipykernel
    doCheck = false;

    meta = {
      description = "Jupyter protocol implementation and client libraries";
      homepage = http://jupyter.org/;
      license = licenses.bsd3;
      maintainers = with maintainers; [ fridh ];
    };
  };

  jupyter_core = buildPythonPackage rec {
    version = "4.0.6";
    name = "jupyter_core-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/j/jupyter_core/${name}.tar.gz";
      sha256 = "96a68a3b1d018ff7776270b26b7cb0cfd7a18a53ef2061421daff435707d198c";
    };

    buildInputs = with self; [ pytest mock ];
    propagatedBuildInputs = with self; [ ipython traitlets];

    checkPhase = ''
      py.test
    '';

    # Several tests fail due to being in a chroot
    doCheck = false;

    meta = {
      description = "Jupyter core package. A base package on which Jupyter projects rely";
      homepage = http://jupyter.org/;
      license = licenses.bsd3;
      maintainers = with maintainers; [ fridh ];
    };
  };


  jsonpath_rw = buildPythonPackage rec {
    name = "jsonpath-rw-${version}";
    version = "1.4.0";
    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/j/jsonpath-rw/${name}.tar.gz";
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


  keyring = buildPythonPackage rec {
    name = "keyring-8.4.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/k/keyring/${name}.tar.gz";
      sha256 = "1286sh5g53168qxbl4g5bmns9ci0ld0jl3h44b7h8is5nw1421ar";
    };

    buildInputs = with self;
      [ fs gdata python_keyczar mock pyasn1 pycrypto pytest_28 six setuptools_scm pytestrunner ];

    checkPhase = ''
      py.test $out
    '';

    meta = {
      description = "Store and access your passwords safely";
      homepage    = "https://pypi.python.org/pypi/keyring";
      license     = licenses.psfl;
      maintainers = with maintainers; [ lovek323 ];
      platforms   = platforms.unix;
    };
  };

  klaus = buildPythonPackage rec {
    version = "0.6.0";
    name = "klaus-${version}";

    src = pkgs.fetchurl {
      url = "https://github.com/jonashaag/klaus/archive/${version}.tar.gz";
      sha256 = "0ab3lxbysnvsx7irlxhiy78clbk4d0gzv2241pqkkvlmqq3968p4";
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

  kombu = buildPythonPackage rec {
    name = "kombu-${version}";
    version = "3.0.33";

    disabled = pythonOlder "2.6";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/k/kombu/${name}.tar.gz";
      sha256 = "16brjx2lgwbj2a37d0pjbfb84nvld6irghmqrs3qfncajp51hgc5";
    };

    buildInputs = with self; optionals (!isPy3k) [ anyjson mock unittest2 nose ];

    propagatedBuildInputs = with self; [ amqp anyjson ] ++
      (optionals (pythonOlder "2.7") [ importlib ordereddict ]);

    # tests broken on python 2.6? https://github.com/nose-devs/nose/issues/806
    # tests also appear to depend on anyjson, which has Py3k problems
    doCheck = (pythonAtLeast "2.7") && !isPy3k ;

    meta = {
      description = "Messaging library for Python";
      homepage    = "http://github.com/celery/kombu";
      license     = licenses.bsd3;
    };
  };

  konfig = buildPythonPackage rec {
    name = "konfig-${version}";
    version = "0.9";

    # konfig unconditionaly depend on configparser, even if it is part of
    # the standard library in python 3.2 or above.
    disabled = isPy3k;

    src = pkgs.fetchgit {
      url = https://github.com/mozilla-services/konfig.git;
      rev = "refs/tags/${version}";
      sha256 = "1v9pjb9idapjlc75p6h06kx7bi8zxhfgj93yxq1bn337kmyk1xdf";
    };

    propagatedBuildInputs = with self; [ configparser argparse ];

    meta = {
      description = "Yet Another Config Parser";
      homepage    = "https://github.com/mozilla-services/konfig";
      license     = licenses.mpl20;
    };
  };

  kitchen = buildPythonPackage (rec {
    name = "kitchen-1.1.1";
    disabled = isPy3k;

    meta.maintainers = with maintainers; [ mornfall ];

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/k/kitchen/kitchen-1.1.1.tar.gz";
      sha256 = "0ki840hjk1q19w6icv0dj2jxb00966nwy9b1jib0dgdspj00yrr5";
    };
  });

  pylast = buildPythonPackage rec {
    name = "pylast-${version}";
    version = "0.5.11";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pylast/${name}.tar.gz";
      sha256 = "bf35820be35447d55564d36072d40b09ac8a7fd41a6f1a7a9d408f4d0eaefac4";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://code.google.com/p/pylast/;
      description = "A python interface to last.fm (and compatibles)";
      license = licenses.asl20;
    };
  };

  pylru = buildPythonPackage rec {
    name = "pylru-${version}";
    version = "1.0.9";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pylru/${name}.tar.gz";
      sha256 = "0b0pq0l7xv83dfsajsc49jcxzc99kb9jfx1a1dlx22hzcy962dvi";
    };

    meta = {
      homepage = https://github.com/jlhutch/pylru;
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
      url = "https://pypi.python.org/packages/source/l/lazy-object-proxy/${name}.tar.gz";
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


  libcloud = buildPythonPackage (rec {
    name = "libcloud-0.18.0";

    src = pkgs.fetchurl {
      url = https://pypi.python.org/packages/source/a/apache-libcloud/apache-libcloud-0.18.0.tar.bz2;
      sha256 = "0ahdp14ddly074qg5cksxdhqaws0kj445xmhz1y7lzspsp6fk1xg";
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


  limnoria = buildPythonPackage rec {
    name = "limnoria-${version}";
    version = "2015.10.04";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/l/limnoria/${name}.tar.gz";
      sha256 = "1hwwwr0z2vsirgwd92z17nbhnhsz0m25bpxn5sanqlbcjbwhyk9z";
    };

    patchPhase = ''
      sed -i 's/version=version/version="${version}"/' setup.py
    '';
    buildInputs = with self; [ pkgs.git ];
    propagatedBuildInputs = with self; [ modules.sqlite3 ];

    doCheck = false;

    meta = {
      description = "A modified version of Supybot, an IRC bot";
      homepage = http://supybot.fr.cr;
      license = licenses.bsd3;
      maintainers = with maintainers; [ goibhniu ];
    };
  };

  line_profiler = buildPythonPackage rec{
    version = "1.0";
    name = "line_profiler-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/l/line_profiler/${name}.tar.gz";
      sha256 = "a9e0c9ffa814f1215107c86c890afa8e63bec5a37d951f6f9d3668c1df2b1900";
    };

    buildInputs = with self; [ cython ];

    disabled = isPyPy;

    meta = {
      description = "Line-by-line profiler";
      homepage = https://github.com/rkern/line_profiler;
      license = licenses.bsd3;
      maintainers = with maintainers; [ fridh ];
    };
  };

  linode = buildPythonPackage rec {
    name = "linode-${version}";
    version = "0.4";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/l/linode/linode-${version}.tar.gz";
      sha256 = "db3c2a7fab8966d903a63f16c515bff241533e4ef2d746aa7aae4a49bba5e573";
    };

    propagatedBuildInputs = with self; [ requests2 ];

    meta = {
      homepage = "https://github.com/ghickman/linode";
      description = "A thin python wrapper around Linode's API";
      license = licenses.mit;
      maintainers = with maintainers; [ nslqqq ];
    };
  };

  llfuse = buildPythonPackage rec {
    name = "llfuse-1.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/l/llfuse/${name}.tar.bz2";
      md5 = "6e71af191381da135a222e3c0e7569a1";
    };

    buildInputs = [ pkgs.pkgconfig pkgs.fuse pkgs.attr ];

    meta = {
      description = "Python bindings for the low-level FUSE API";
      homepage = https://code.google.com/p/python-llfuse/;
      license = licenses.lgpl2Plus;
      platforms = platforms.unix;
      maintainers = with maintainers; [ bjornfor ];
    };
  };

  locustio = buildPythonPackage rec {
    name = "locustio-0.7.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/l/locustio/${name}.tar.gz";
      sha256 = "c9ca6fdfe6a6fb187a3d54ddf9b1518196348e8f20537f0a14ca81a264ffafa2";
    };

    propagatedBuildInputs = [ self.msgpack self.requests2 self.flask self.gevent self.pyzmq ];
    buildInputs = [ self.mock self.unittest2 ];

    meta = {
      homepage = http://locust.io/;
      description = "A load testing tool";
    };
  };

  llvmlite = buildPythonPackage rec {
    name = "llvmlite-${version}";
    version = "0.8.0";

    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/l/llvmlite/${name}.tar.gz";
      sha256 = "a10d8d5e597c6a54ec418baddd31a51a0b7937a895d75b240d890aead946081c";
    };

    llvm = pkgs.llvm_36;

    propagatedBuildInputs = with self; [ llvm ] ++ optional (pythonOlder "3.4") enum34;

    # Disable static linking
    # https://github.com/numba/llvmlite/issues/93
    patchPhase = ''
      substituteInPlace ffi/Makefile.linux --replace "-static-libstdc++" ""
    '';
    # Set directory containing llvm-config binary
    preConfigure = ''
      export LLVM_CONFIG=${llvm}/bin/llvm-config
    '';
    checkPhase = ''
      ${self.python.executable} runtests.py
    '';

    __impureHostDeps = optionals stdenv.isDarwin [ "/usr/lib/libm.dylib" ];

    meta = {
      description = "A lightweight LLVM python binding for writing JIT compilers";
      homepage = "http://llvmlite.pydata.org/";
      license = licenses.bsd2;
      maintainers = with maintainers; [ fridh ];
    };
  };

  lockfile = buildPythonPackage rec {
    name = "lockfile-${version}";
    version = "0.10.2";
    src = pkgs.fetchurl {
      sha256 = "0zi7amj3y55lp6339w217zksn1a0ssfvscmv059g2wvnyjqi6f95";
      url = "https://github.com/openstack/pylockfile/archive/${version}.tar.gz";
    };

    doCheck = true;
    OSLO_PACKAGE_VERSION = "${version}";
    buildInputs = with self; [
      pbr nose sphinx_1_2
    ];

    meta = {
      homepage = http://launchpad.net/pylockfile;
      description = "Platform-independent advisory file locking capability for Python applications";
      license = licenses.asl20;
    };
  };

  logilab_common = buildPythonPackage rec {
    name = "logilab-common-0.63.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/l/logilab-common/${name}.tar.gz";
      sha256 = "1rr81zlmlgdma3s75i5c1l8q2m25v4ac41i9pniik4mhkc6a0fv0";
    };

    propagatedBuildInputs = with self; [ unittest2 six ];
  };

  logilab-constraint = buildPythonPackage rec {
    name = "logilab-constraint-${version}";
    version = "0.6.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/l/logilab-constraint/${name}.tar.gz";
      sha256 = "1n0xim4ij1n4yvyqqvyc0wllhjs22szglsd5av0j8k2qmck4njcg";
    };

    propagatedBuildInputs = with self; [
      logilab_common six
    ];

    meta = with stdenv.lib; {
      description = "logilab-database provides some classes to make unified access to different";
      homepage = "http://www.logilab.org/project/logilab-database";
    };
  };


  lxml = buildPythonPackage ( rec {
    name = "lxml-3.4.4";
    # Warning : as of nov. 9th, 2015, version 3.5.0b1 breaks a lot of things,
    # more work is needed before upgrading

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/l/lxml/${name}.tar.gz";
      sha256 = "16a0fa97hym9ysdk3rmqz32xdjqmy4w34ld3rm3jf5viqjx65lxk";
    };

    buildInputs = with self; [ pkgs.libxml2 pkgs.libxslt ];

    meta = {
      description = "Pythonic binding for the libxml2 and libxslt libraries";
      homepage = http://lxml.de;
      license = licenses.bsd3;
      maintainers = with maintainers; [ sjourdois ];
    };
  });


  python_magic = buildPythonPackage rec {
    name = "python-magic-0.4.10";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/python-magic/${name}.tar.gz";
      sha256 = "1hx2sjd4fdswswj3yydn2azxb59rjmi9b7jzh94lf1wnxijjizbr";
    };

    propagatedBuildInputs = with self; [ pkgs.file ];

    patchPhase = ''
      substituteInPlace magic.py --replace "ctypes.util.find_library('magic')" "'${pkgs.file}/lib/libmagic.so'"
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
      substituteInPlace python/magic.py --replace "find_library('magic')" "'${pkgs.file}/lib/libmagic.so'"
    '';

    buildInputs = with self; [ python pkgs.file ];

    preConfigure = "cd python";

    meta = {
      description = "A Python wrapper around libmagic";
      homepage = http://www.darwinsys.com/file/;
    };
  };


  m2crypto = buildPythonPackage rec {
    version = "0.23.0";
    name = "m2crypto-${version}";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/M/M2Crypto/M2Crypto-${version}.tar.gz";
      sha256 = "1ac3b6eafa5ff7e2a0796675316d7569b28aada45a7ab74042ad089d15a9567f";
    };

    buildInputs = with self; [ pkgs.swig2 pkgs.openssl ];

    preConfigure = ''
      substituteInPlace setup.py --replace "self.openssl = '/usr'" "self.openssl = '${pkgs.openssl}'"
    '';

    doCheck = false; # another test that depends on the network.

    meta = {
      description = "A Python crypto and SSL toolkit";
      homepage = http://chandlerproject.org/Projects/MeTooCrypto;
    };
  };


  Mako = buildPythonPackage rec {
    name = "Mako-1.0.2";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/M/Mako/${name}.tar.gz";
      sha256 = "17k7jy3byi4hj6ksszib6gxbf6n7snnnirnbrdldn848abjc4l15";
    };

    buildInputs = with self; [ markupsafe nose mock ];
    propagatedBuildInputs = with self; [ markupsafe ];

    doCheck = !isPyPy;  # https://bitbucket.org/zzzeek/mako/issue/238/2-tests-failed-on-pypy-24-25

    meta = {
      description = "Super-fast templating language";
      homepage = http://www.makotemplates.org;
      license = licenses.mit;
      maintainers = with maintainers; [ iElectric ];
    };
  };


  markupsafe = buildPythonPackage rec {
    name = "markupsafe-${version}";
    version = "0.23";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-${version}.tar.gz";
      sha256 = "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3";
    };

    meta = {
      description = "Implements a XML/HTML/XHTML Markup safe string";
      homepage = http://dev.pocoo.org;
      license = licenses.bsd3;
      maintainers = with maintainers; [ iElectric garbas ];
    };
  };

  manuel = buildPythonPackage rec {
    name = "manuel-${version}";
    version = "1.8.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/m/manuel/${name}.tar.gz";
      sha256 = "1diyj6a8bvz2cdf9m0g2bbx9z2yjjnn3ylbg1zinpcjj6vldfx59";
    };

    propagatedBuildInputs = with self; [ six zope_testing ];

    meta = {
      description = "A documentation builder";
      homepage = http://pypi.python.org/pypi/manuel;
      license = licenses.zpt20;
    };
  };

  markdown = buildPythonPackage rec {
    version = "2.6.4";
    name = "markdown-${version}";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/M/Markdown/Markdown-${version}.tar.gz";
      sha256 = "1kll5b35wqkhvniwm2kh6rqc43wakv9ls0qm6g5318pjmbkywdp4";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://www.freewisdom.org/projects/python-markdown;
    };
  };


  mathics = buildPythonPackage rec {
    name = "mathics-${version}";
    version = "0.8";
    src = pkgs.fetchFromGitHub {
      owner = "mathics";
      repo = "Mathics";
      rev = "v${version}";
      sha256 = "1hyrxnhxw35vn00k55hp9bkg8vg4dsphrpfg1yg4cn53y78rk1im";
    };

    disabled = isPy3k;

    patches = [ ../development/python-modules/mathics/disable_console_tests.patch ];

    buildInputs = with self; [ pexpect ];

    prePatch = ''
      substituteInPlace setup.py --replace "sympy==0.7.6" "sympy"
    '';

    propagatedBuildInputs = with self; [
      argparse
      cython
      colorama
      dateutil
      django_1_6
      mpmath
      readline
      interruptingcow
      ply
      sqlite3
      sympy
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
    inherit (pkgs.darwin.apple_sdk.frameworks) Cocoa Foundation CoreData;
    inherit (pkgs.darwin) cf-private libobjc;
  };


  mccabe = buildPythonPackage (rec {
    name = "mccabe-0.3";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/m/mccabe/${name}.tar.gz";
      sha256 = "3d8ca9bf65c5014f469180544d1dd5bb5b9df709aad6304f9c2e4370ae0a7b7c";
    };

    # See https://github.com/flintwork/mccabe/issues/31
    postPatch = ''
      cp "${pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/flintwork/mccabe/"
            + "e8aea16d28e92bd3c62601275762fc9c16808f6c/test_mccabe.py";
        sha256 = "0xhjxpnaxvbpi4myj9byrban7a5nrw931br9sgvfk42ayg4sn6lm";
      }}" test_mccabe.py
    '';

    meta = {
      description = "McCabe checker, plugin for flake8";
      homepage = "https://github.com/flintwork/mccabe";
      license = licenses.mit;
      maintainers = with maintainers; [ garbas ];
    };
  });


  mechanize = buildPythonPackage (rec {
    name = "mechanize-0.2.5";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/m/mechanize/${name}.tar.gz";
      sha256 = "0rj7r166i1dyrq0ihm5rijfmvhs8a04im28lv05c0c3v206v4rrf";
    };

    propagatedBuildInputs = with self; [ clientform ];

    doCheck = false;

    meta = {
      description = "Stateful programmatic web browsing in Python";

      homepage = http://wwwsearch.sourceforge.net/;

      license = "BSD-style";
    };
  });

  MechanicalSoup = buildPythonPackage rec {
    name = "MechanicalSoup-${version}";
    version = "0.4.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/M/MechanicalSoup/${name}.zip";
      sha256 = "02jkwly4gw1jqm55l4wwn0j0ggnysx55inw9j96bif5l49z5cacd";
    };

    propagatedBuildInputs = with self; [ requests2 beautifulsoup4 six ];

    meta = {
      description = "A Python library for automating interaction with websites";
      homepage = https://github.com/hickford/MechanicalSoup;
      license = licenses.mit;
      maintainers = with maintainers; [ jgillich ];
    };
  };


  meld3 = buildPythonPackage rec {
    name = "meld3-1.0.0";

    src = pkgs.fetchurl {
      url = https://pypi.python.org/packages/source/m/meld3/meld3-1.0.0.tar.gz;
      sha256 = "57b41eebbb5a82d4a928608962616442e239ec6d611fe6f46343e765e36f0b2b";
    };

    doCheck = false;

    meta = {
      description = "An HTML/XML templating engine used by supervisor";
      homepage = https://github.com/supervisor/meld3;
      license = licenses.free;
    };
  };

  memcached = buildPythonPackage rec {
    name = "memcached-1.51";

    src = if isPy3k then pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/python3-memcached/python3-${name}.tar.gz";
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
    version = "0.39";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/m/memory_profiler/${name}.tar.gz";
      sha256 = "61021f2dade7edd6cc09d7924bfdccc453bd1949608412a3e021d44a410d3a23";
    };

    meta = {
      description = "A module for monitoring memory usage of a python program";
      homepage = http://pypi.python.org/pypi/memory_profiler;
      license = licenses.bsd3;
    };
  };

  mezzanine = buildPythonPackage rec {
    version = "3.1.10";
    name = "mezzanine-${version}";

    src = pkgs.fetchurl {
      url = "https://github.com/stephenmcd/mezzanine/archive/${version}.tar.gz";
      sha256 = "1cd7d3dji8q4mvcnf9asxn8j109pd5g5d5shr6xvn0iwr35qprgi";
    };

    disabled = isPyPy;

    buildInputs = with self; [ pyflakes pep8 ];
    propagatedBuildInputs = with self; [
      django_1_6 filebrowser_safe grappelli_safe bleach tzlocal beautifulsoup4
      requests2 requests_oauthlib future pillow modules.sqlite3
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

  munch = buildPythonPackage rec {
    name = "munch-${version}";
    version = "2.0.4";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/m/munch/${name}.tar.gz";
      sha256 = "1420683a94f3a2ffc77935ddd28aa9ccb540dd02b75e02ed7ea863db437ab8b2";
    };

    meta = {
      description = "A dot-accessible dictionary (a la JavaScript objects)";
      license = licenses.mit;
      homepage = http://github.com/Infinidat/munch;
    };
  };

  nototools = buildPythonPackage rec {
    version = "git-2015-09-16";
    name = "nototools-${version}";
    disabled = isPy3k;

    pythonPath = with self; [ fonttools numpy ];

    postPatch = ''
      sed -ie "s^join(_DATA_DIR_PATH,^join(\"$out/third_party/ucd\",^" nototools/unicode_data.py
    '';

    postInstall = ''
      cp -r third_party $out
    '';

    src = pkgs.fetchFromGitHub {
      owner = "googlei18n";
      repo = "nototools";
      rev = "5a79bee819941849da7b414447929fc7ba6c2c08";
      sha256 = "0srrmyrjgksk4c6smgi1flyq325r4ma8r6bpkvbn731q3yykhmaa";
    };
  };

  rainbowstream = buildPythonPackage rec {
    name = "rainbowstream-${version}";
    version = "1.3.3";

    src = pkgs.fetchurl {
      url    = "https://pypi.python.org/packages/source/r/rainbowstream/${name}.tar.gz";
      sha256 = "08598slbn8sm2hjs0q1041fv7m56k2ky4q66rsihacjw0mg7blai";
    };

    doCheck = false;

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
      pillow twitter pyfiglet requests2 arrow dateutil modules.readline pysocks
    ];

    meta = {
      description = "Streaming command-line twitter client";
      homepage    = "http://www.rainbowstream.org/";
      license     = licenses.mit;
      maintainers = with maintainers; [ thoughtpolice ];
    };
  };

  mistune = buildPythonPackage rec {
    version = "0.7.1";
    name = "mistune-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/m/mistune/${name}.tar.gz";
      sha256 = "6076dedf768348927d991f4371e5a799c6a0158b16091df08ee85ee231d929a7";
    };

    buildInputs = with self; [nose];

    meta = {
      decription = "The fastest markdown parser in pure Python";
      homepage = https://github.com/lepture/mistune;
      license = licenses.bsd3;
    };
  };


  mitmproxy = buildPythonPackage rec {
    baseName = "mitmproxy";
    name = "${baseName}-${version}";
    version = "0.14.0";

    src = pkgs.fetchurl {
      url = "${meta.homepage}/download/${name}.tar.gz";
      sha256 = "0mbd3m8x9a5v9skvzayjwaccn5kpgjb5p7hal5rrrcj69d8xrz6f";
    };

    propagatedBuildInputs = with self; [
      pyopenssl pyasn1 urwid pillow lxml flask protobuf netlib click
      ConfigArgParse pyperclip blinker construct pyparsing html2text tornado
    ];

    doCheck = false;

    postInstall = ''
      for prog in "$out/bin/"*; do
        wrapProgram "$prog" \
          --prefix PYTHONPATH : "$PYTHONPATH"
      done
    '';

    meta = {
      description = ''Man-in-the-middle proxy'';
      homepage = "http://mitmproxy.org/";
      license = licenses.mit;
    };
  };

  mock = buildPythonPackage (rec {
    name = "mock-1.3.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/m/mock/${name}.tar.gz";
      sha256 = "1xm0xkaz8d8d26kdk09f2n9vn543ssd03vmpkqlmgq3crjz7s90y";
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
      url = "https://pypi.python.org/packages/source/M/ModestMaps/${name}.tar.gz";
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
    ver = "1.9.7";

    src = pkgs.fetchurl {
      url = "http://static.moinmo.in/files/moin-${ver}.tar.gz";
      sha256 = "f4ba1b5c956bd96d2a61e27e68d297aa63d1afbc80d5740e139dcdf0affb4db5";
    };

    meta = {
      description = "Advanced, easy to use and extensible WikiEngine";

      homepage = http://moinmo.in/;

      license = licenses.gpl2Plus;
    };
  });

  moretools = buildPythonPackage rec {
    name = "moretools-0.1a41";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/m/moretools/${name}.tar.gz";
      sha256 = "1n442wprbl3cmg08233m1sr3g4z0i8hv9g6bhch7kzdmbl21399f";
    };

    buildInputs = with self; [ six pathpy setuptools ];
    propagatedBuildInputs = with self; [ decorator ];

    meta = {
      description = "Many more basic tools for python 2/3 extending itertools, functools, operator and collections";
      homepage = https://bitbucket.org/userzimmermann/python-moretools;
      license = licenses.gpl3Plus;
      platforms = platforms.linux;
    };
  };

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
      sha256 = "0k1d7v8aa4xd3f9h8m5crl647136ba15i9nzdrpxg5aqmv2n0i0p";
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
      url = "https://pypi.python.org/packages/source/m/mpmath/${name}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/p/python-mpd/python-mpd-0.3.0.tar.gz";
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
      url = "https://pypi.python.org/packages/source/p/python-mpd2/python-mpd2-${version}.tar.bz2";
      sha256 = "1gfrxf71xll1w6zb69znqg5c9j0g7036fsalkvqprh2id640cl3a";
    };

    propagatedBuildInputs = [ pkgs.mpd_clientlib ];

    buildInputs = with self; [ mock ];
    patchPhase = ''
      sed -i -e '/tests_require/d' \
          -e 's/cmdclass.*/test_suite="mpd_test",/' setup.py
    '';

    meta = {
      description = "A Python client module for the Music Player Daemon";
      homepage = "https://github.com/Mic92/python-mpd2";
      license = licenses.lgpl3Plus;
      maintainers = with maintainers; [ rvl ];
    };
  };

  mpv = buildPythonPackage rec {
    name = "mpv-0.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/m/mpv/${name}.tar.gz";
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
      url = "http://pypi.python.org/packages/source/m/mr.bob/mr.bob-${version}.tar.gz";
      sha256 = "6737eaf98aaeae85e07ebef844ee5156df2f06a8b28d7c3dcb056f811c588121";
    };

    buildInputs = [ pkgs.glibcLocales self.mock ];

    disabled = isPy3k;

    LC_ALL="en_US.UTF-8";

    propagatedBuildInputs = with self; [ argparse jinja2 six modules.readline ] ++
                            (optionals isPy26 [ importlib ordereddict ]);

    meta = {
      homepage = https://github.com/iElectric/mr.bob.git;
      description = "A tool to generate code skeletons from templates";
    };
  };

  msgpack = buildPythonPackage rec {
    name = "msgpack-python-${version}";
    version = "0.4.6";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/m/msgpack-python/${name}.tar.gz";
      sha256 = "bfcc581c9dbbf07cc2f951baf30c3249a57e20dcbd60f7e6ffc43ab3cc614794";
    };

    propagatedBuildInputs = with self; [ ];
  };

  msrplib = buildPythonPackage rec {
    name = "python-msrplib-${version}";
    version = "0.18.0";

    src = pkgs.fetchurl {
      url = "http://download.ag-projects.com/MSRP/${name}.tar.gz";
      sha256 = "0vp9g5p015g3f67rl4vz0qnn6x7hciry6nmvwf82h9h5rx11r43j";
    };

    propagatedBuildInputs = with self; [ eventlib application gnutls ];
  };

  multipledispatch = buildPythonPackage rec {
    name = "multipledispatch-${version}";
    version = "0.4.8";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/m/multipledispatch/${name}.tar.gz";
      sha256 = "07d41fb3ed25e8424536e48a8566f88a0f9926ca4b6174bff6aa16c98251b92e";
    };

    meta = {
      homepage = http://github.com/mrocklin/multipledispatch/;
      description = "A relatively sane approach to multiple dispatch in Python";
      license = licenses.bsd3;
      maintainers = with maintainers; [ fridh ];
    };
  };

  munkres = buildPythonPackage rec {
    name = "munkres-1.0.6";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/m/munkres/${name}.tar.gz";
      sha256 = "c78f803b9b776bfb20a25c9c7bb44adbf0f9202c2024d51aa5969d21e560208d";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://bmc.github.com/munkres/;
      description = "Munkres algorithm for the Assignment Problem";
      license = licenses.bsd3;
      maintainers = with maintainers; [ iElectric ];
    };
  };


  musicbrainzngs = buildPythonPackage rec {
    name = "musicbrainzngs-0.5";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/m/musicbrainzngs/${name}.tar.gz";
      sha256 = "281388ab750d2996e9feca4580fd4215d616a698e02cd6719cb9b8562945c489";
    };

    buildInputs = [ pkgs.glibcLocales ];

    LC_ALL="en_US.UTF-8";

    meta = {
      homepage = http://alastair/python-musicbrainz-ngs;
      description = "Python bindings for musicbrainz NGS webservice";
      license = licenses.bsd2;
      maintainers = with maintainers; [ iElectric ];
    };
  };

  mutag = buildPythonPackage rec {
    disabled = ! isPy3k;
    name = "mutag-0.0.2-2ffa0258ca";
    src = pkgs.fetchgit {
      url = "https://github.com/aroig/mutag.git";
      sha256 = "0azq2sb32mv6wyjlw1hk01c23isl4x1hya52lqnhknak299s5fml";
      rev = "2ffa0258cadaf79313241f43bf2c1caaf197d9c2";
    };

    propagatedBuildInputs = with self; [ pyparsing ];

    meta = {
      homepage = https://github.com/aroig/mutag;
      license = licenses.gpl3;
      maintainers = with maintainers; [ DamienCassou ];
    };
  };

  mutagen = buildPythonPackage (rec {
    name = "mutagen-1.27";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/m/mutagen/${name}.tar.gz";
      sha256 = "cc884fe1e20fe220be7ce7c3b269f4cadc69a8310150a3a41162fba1ca9c88bd";
    };

    # Needed for tests only
    buildInputs = [ pkgs.faad2 pkgs.flac pkgs.vorbis-tools pkgs.liboggz ];

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

  plover = buildPythonPackage rec {
    name = "plover-${version}";
    version = "2.5.8";
    disabled = !isPy27;

    meta = {
      description = "OpenSteno Plover stenography software";
      maintainers = [ maintainers.twey ];
      license = licenses.gpl2;
    };

    src = pkgs.fetchurl {
      url = "https://github.com/openstenoproject/plover/archive/v${version}.tar.gz";
      sha256 = "23f7824a715f93eb2c41d5bafd0c6f3adda92998e9321e1ee029abe7a6ab41e5";
    };

    propagatedBuildInputs = with self; [ wxPython pyserial xlib appdirs pkgs.wmctrl ];
    preConfigure = "substituteInPlace setup.py --replace /usr/share usr/share";
  };

  pygal = buildPythonPackage rec {
    version = "2.0.10";
    name = "pygal-${version}";

    doCheck = !isPyPy;  # one check fails with pypy

    src = pkgs.fetchFromGitHub {
      owner = "Kozea";
      repo = "pygal";
      rev = version;
      sha256 = "1j7qjgraapvfc80yp8xcbddqrw8379gqi7pwkvfml3qcqm0z0d33";
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

  pygraphviz = buildPythonPackage rec {
    name = "pygraphviz-1.3.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pygraphviz/${name}.tar.gz";
      sha256 = "7c294cbc9d88946be671cc0d8602aac176d8c56695c0a7d871eadea75a958408";
    };

    buildInputs = with self; [ doctest-ignore-unicode ];
    propagatedBuildInputs = [ pkgs.graphviz pkgs.pkgconfig ];

    meta = {
      description = "Python interface to Graphviz graph drawing package";
      homepage = https://github.com/pygraphviz/pygraphviz;
      license = licenses.bsd3;
      maintainers = with maintainers; [ matthiasbeyer ];
    };
  };

  pymysql = buildPythonPackage rec {
    name = "pymysql-${version}";
    version = "0.6.6";
    src = pkgs.fetchgit {
      url = https://github.com/PyMySQL/PyMySQL.git;
      rev = "refs/tags/pymysql-${version}";
      sha256 = "12v8bw7pp455zqkwraxk69qycz2ngk18bbz60v72kdbp6kssnqhz";
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

    propagatedBuildInputs = with self; [ pymysql sqlalchemy9 ];

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pymysql_sa/pymysql_sa-1.0.tar.gz";
      sha256 = "a2676bce514a29b2d6ab418812259b0c2f7564150ac53455420a20bd7935314a";
    };

    meta = {
      description = "PyMySQL dialect for SQL Alchemy";
      homepage = https://pypi.python.org/pypi/pymysql_sa;
      license = licenses.mit;
    };
  };

  monotonic = buildPythonPackage rec {
    name = "monotonic-0.4";

    __propagatedImpureHostDeps = stdenv.lib.optional stdenv.isDarwin "/usr/lib/libc.dylib";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/m/monotonic/${name}.tar.gz";
      sha256 = "1diab6hfh3jpa1f0scpqaqrawk4g97ss4v7gkn2yw8znvdm6abw5";
    };

    patchPhase = optionalString stdenv.isLinux ''
      substituteInPlace monotonic.py --replace \
        "ctypes.util.find_library('c')" "'${stdenv.glibc}/lib/libc.so.6'"
    '';
  };

  MySQL_python = buildPythonPackage rec {
    name = "MySQL-python-1.2.5";

    disabled = isPy3k;

    # plenty of failing tests
    doCheck = false;

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/M/MySQL-python/${name}.zip";
      sha256 = "0x0c2jg0bb3pp84njaqiic050qkyd7ymwhfvhipnimg58yv40441";
    };

    buildInputs = with self; [ nose pkgs.openssl ];

    propagatedBuildInputs = with self; [ pkgs.mysql.lib pkgs.zlib ];

    meta = {
      description = "MySQL database binding for Python";

      homepage = http://sourceforge.net/projects/mysql-python;
    };
  };


  mysql_connector_repackaged = buildPythonPackage rec {
    name = "mysql-connector-repackaged-0.3.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/m/mysql-connector-repackaged/${name}.tar.gz";
      sha256 = "170fbf11c54def1b5fcc919be0a890b760bb2eca81f56123a5dda0c69b5b099e";
    };

    meta = {
      maintainers = with maintainers; [ garbas iElectric ];
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
      url = "https://pypi.python.org/packages/source/n/nameparser/${name}.tar.gz";
      sha256 = "1zi94m99ziwwd6kkip3w2xpnl05r2cfv9iq68inz7np81c3g8vag";
    };

    meta = {
      description = "A simple Python module for parsing human names into their individual components";
      homepage = https://github.com/derek73/python-nameparser;
      license = licenses.lgpl21Plus;
    };
  };

  nbconvert = buildPythonPackage rec {
    version = "4.1.0";
    name = "nbconvert-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/n/nbconvert/${name}.tar.gz";
      sha256 = "e0296e45293dd127d028f678e3b6aba3f1db3283a134178bdb49eea402d4cf1c";
    };

    buildInputs = with self; [nose ipykernel ];

    propagatedBuildInputs = with self; [mistune jinja2 pygments traitlets jupyter_core nbformat ipykernel tornado jupyter_client];

    checkPhase = ''
      nosetests -v
    '';

    # PermissionError. Likely due to being in a chroot
    doCheck = false;

    meta = {
      description = "Converting Jupyter Notebooks";
      homepage = http://jupyter.org/;
      license = licenses.bsd3;
      maintainers = with maintainers; [ fridh ];
    };
  };

  nbformat = buildPythonPackage rec {
    version = "4.0.1";
    name = "nbformat-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/n/nbformat/${name}.tar.gz";
      sha256 = "5261c957589b9dfcd387c338d59375162ba9ca82c69e378961a1f4e641285db5";
    };

    buildInputs = with self; [ nose ];
    propagatedBuildInputs = with self; [ipython_genutils traitlets jsonschema jupyter_core];

    meta = {
      description = "The Jupyter Notebook format";
      homepage = "http://jupyter.org/";
      license = licenses.bsd3;
      maintainers = with maintainers; [ fridh ];
    };
  };

  nbxmpp = buildPythonPackage rec {
    name = "nbxmpp-0.5.3";

    src = pkgs.fetchurl {
      name = "${name}.tar.gz";
      url = "https://python-nbxmpp.gajim.org/downloads/8";
      sha256 = "0dcr786dyips1fdvgsn8yvpgcz5j7217fi05c29cfypdl8jnp6mp";
    };

    meta = {
      homepage = "https://python-nbxmpp.gajim.org/";
      description = "Non-blocking Jabber/XMPP module";
      license = licenses.gpl3;
    };
  };

  sleekxmpp = buildPythonPackage rec {
    name = "sleekxmpp-${version}";
    version = "1.3.1";

    propagatedBuildInputs = with self ; [ dns pyasn1 ];

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/s/sleekxmpp/${name}.tar.gz";
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
    version = "1.1";

    disabled = (!isPy34);

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/s/slixmpp/${name}.tar.gz";
      sha256 = "030ca7e71cbb7e17fb48f83db97779fdbac0b4424cef01245f3276a110b30a6c";
    };

    propagatedBuildInputs = with self ; [ aiodns pyasn1 pkgs.gnupg1 pyasn1-modules];

    meta = {
      meta = "Elegant Python library for XMPP";
      license = licenses.mit;
      homepage = https://dev.louiz.org/projects/slixmpp;
    };
  };

  netaddr = buildPythonPackage rec {
    name = "netaddr-0.7.18";
    disabled = isPy35;  # https://github.com/drkjam/netaddr/issues/117

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/n/netaddr/${name}.tar.gz";
      sha256 = "06dxjlbcicq7q3vqy8agq11ra01kvvd47j4mk6dmghjsyzyckxd1";
    };

    LC_ALL = "en_US.UTF-8";
    buildInputs = [ pkgs.glibcLocales ];

    meta = {
      homepage = https://github.com/drkjam/netaddr/;
      description = "A network address manipulation library for Python";
    };
  };

  netifaces = buildPythonPackage rec {
    version = "0.10.4";
    name = "netifaces-${version}";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/n/netifaces/${name}.tar.gz";
      sha256 = "1plw237a4zib4z8s62g0mrs8gm3kjfrp5sxh6bbk9nl3rdls2mln";
    };

    meta = {
      homepage = http://alastairs-place.net/projects/netifaces/;
      description = "Portable access to network interfaces from Python";
    };
  };

  hpack = buildPythonPackage rec {
    name = "hpack-${version}";
    version = "2.0.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/h/hpack/hpack-${version}.tar.gz";
      sha256 = "1k4wa8c52bd6x109bn6hc945595w6aqgzj6ipy6c2q7vxkzalzhd";
    };

    propagatedBuildInputs = with self; [

    ];
    buildInputs = with self; [

    ];

    meta = with stdenv.lib; {
      description = "========================================";
      homepage = "http://hyper.rtfd.org";
    };
  };


  netlib = buildPythonPackage rec {
    baseName = "netlib";
    name = "${baseName}-${version}";
    disabled = (!isPy27);
    version = "0.14.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/n/netlib/${name}.tar.gz";
      sha256 = "0xcfjym780wjr32p3g50w2gifqy3589898idzd3fwgj93akv04ng";
    };

    propagatedBuildInputs = with self; [ pyopenssl pyasn1 certifi passlib
      ipaddress backports_ssl_match_hostname_3_4_0_2 hpack ];

    doCheck = false;

    meta = {
      description = "Man-in-the-middle proxy";
      homepage = "https://github.com/cortesi/netlib";
      license = licenses.mit;
    };
  };

  nevow = buildPythonPackage (rec {
    name = "nevow-${version}";
    version = "0.11.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/N/Nevow/Nevow-${version}.tar.gz";
      sha256 = "1z0y8a5q4fa2nmh0dap7cs9pp5xs3jm6q0g4vpwcw77q7jagdmw9";
      name = "${name}.tar.gz";
    };

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
    version = "2.0.1";
    name = "nibabel-${version}";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/n/nibabel/${name}.tar.gz";
      sha256 = "e559bcb40ae395c7f75c51079f815a13a94cd8a035a47315fc9fba0d2ae2ecaf";
    };

    propagatedBuildInputs = with self; [
      numpy
      nose
      modules.sqlite3
    ];

    preCheck = ''
      # Test does not work on Py3k because it calls 'python'.
      # https://github.com/nipy/nibabel/issues/341
      rm nisext/tests/test_testers.py
      # Test fails with numpy 1.10.1: ERROR: nibabel.tests.test_proxy_api.TestPARRECAPI.test_proxy_slicing
      # See https://github.com/nipy/nibabel/pull/358
      # and https://github.com/numpy/numpy/issues/6491
      rm nibabel/tests/test_proxy_api.py
      # https://github.com/nipy/nibabel/issues/366
      rm nisext/tests/test_doctest_markup.py
    '';

    meta = {
      homepage = http://nipy.org/nibabel/;
      description = "Access a multitude of neuroimaging data formats";
      license = licenses.mit;
    };
  };

  nipype = buildPythonPackage rec {
    version = "0.10.0";
    name = "nipype-${version}";

    # Uses python 2 print. Master seems to be Py3 compatible.
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/n/nipype/${name}.tar.gz";
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
      url = "http://pypi.python.org/packages/source/n/nose/${name}.tar.gz";
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

  nose-exclude = buildPythonPackage rec {
    name = "nose-exclude-${version}";
    version = "0.4.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/n/nose-exclude/${name}.tar.gz";
      sha256 = "44466a9bcb56d2e568750f91504d1278c74eabb259a305b06e975b87b51635da";
    };

    propagatedBuildInputs = with self; [ nose ];

    meta = {
      license = licenses.lgpl21;
      description = "Exclude specific directories from nosetests runs";
      homepage = https://github.com/kgrandis/nose-exclude;
      maintainers = with maintainers; [ fridh ];
    };

  };

  nose-selecttests = buildPythonPackage rec {
    version = "0.4";
    name = "nose-selecttests-${version}";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/n/nose-selecttests/${name}.zip";
      sha256 = "0lgrfgp3sq8xi8d9grrg0z8jsyk0wl8a3rxw31hb7vdncin5b7n5";
    };

    propagatedBuildInputs = with self; [ nose ];

    meta = {
      description = "Simple nose plugin that enables developers to run subset of collected tests to spare some waiting time for better things";
    };
  };


  nose2 = if isPy26 then null else (buildPythonPackage rec {
    name = "nose2-0.5.0";
    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/n/nose2/${name}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/n/nose-cover3/${name}.tar.gz";
      sha256 = "1la4hhc1yszjpcchvkqk5xmzlb2g1b3fgxj9wwc58qc549whlcc1";
      md5 = "82f981eaa007b430679899256050fa0c";
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
      url = "https://pypi.python.org/packages/source/n/nosexcover/${name}.tar.gz";
      sha256 = "f5b3a7c936c4f703f15418c1f325775098184b69fa572f868edb8a99f8f144a8";
    };

    propagatedBuildInputs = with self; [ coverage nose ];

    meta = {
      description = "Extends nose.plugins.cover to add Cobertura-style XML reports";

      homepage = http://github.com/cmheisel/nose-xcover/;

      license = licenses.bsd3;
    };
  });

  nosejs = buildPythonPackage {
    name = "nosejs-0.9.4";
    src = pkgs.fetchurl {
      url = https://pypi.python.org/packages/source/N/NoseJS/NoseJS-0.9.4.tar.gz;
      sha256 = "0qrhkd3sga56qf6k0sqyhwfcladwi05gl6aqmr0xriiq1sgva5dy";
    };
    buildInputs = with self; [ nose ];

    checkPhase = ''
      nosetests -v
    '';

  };

  nose-cprof = buildPythonPackage rec {
    name = "nose-cprof-0.1-0";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/n/nose-cprof/${name}.tar.gz";
      sha256 = "d1edd5cb3139e897752294d2968bfb066abdd754743fa416e024e5c688893344";
    };

    meta = {
      description = "A python nose plugin to profile using cProfile rather than the default Hotshot profiler";
    };

    buildInputs = with self; [ nose ];
  };

  notebook = buildPythonPackage rec {
    version = "4.1.0";
    name = "notebook-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/n/notebook/${name}.tar.gz";
      sha256 = "b597437ba33538221008e21fea71cd01eda9da1515ca3963d7c74e44f4b03d90";
    };

    LC_ALL = "en_US.UTF-8";

    buildInputs = with self; [nose pkgs.glibcLocales]  ++ optionals isPy27 [mock];

    propagatedBuildInputs = with self; [jinja2 tornado ipython_genutils traitlets jupyter_core jupyter_client nbformat nbconvert ipykernel terminado requests2 pexpect];

    checkPhase = ''
      nosetests -v
    '';

    # Certain tests fail due to being in a chroot.
    # PermissionError
    doCheck = false;
    meta = {
      description = "The Jupyter HTML notebook is a web-based notebook environment for interactive computing";
      homepage = http://jupyter.org/;
      license = licenses.bsd3;
      maintainers = with maintainers; [ fridh ];
    };
  };

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

    buildInputs = with self; [ python pkgs.pkgconfig pkgs.libnotify pygobject pygtk pkgs.glib pkgs.gtk pkgs.dbus_glib ];

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

  emoji = buildPythonPackage rec {
    name = "emoji-${version}";
    version = "0.3.9";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/e/emoji/${name}.tar.gz";
      sha256 = "19p5c2nlq0w9972rf9fghyswnijwgig5f8cyzs32kppnmzvzbkxw";
    };

    buildInputs = with self; [ nose ];

    checkPhase = ''nosetests'';

    meta = {
      description = "Emoji for Python";
      homepage = https://pypi.python.org/pypi/emoji/;
      license = licenses.bsd3;
      maintainers = with maintainers; [ joachifm ];
    };
  };

  ntfy = buildPythonPackage rec {
    version = "1.2.0";
    name = "ntfy-${version}";
    src = pkgs.fetchFromGitHub {
      owner = "dschep";
      repo = "ntfy";
      rev = "v${version}";
      sha256 = "0yjxwisxpxy3vpnqk9nw5k3db3xx6wyf6sk1px9m94s30glcq2cc";
    };

    propagatedBuildInputs = with self; [ appdirs pyyaml requests2 dbus emoji sleekxmpp mock ];

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
      url = https://pypi.python.org/packages/source/n/ntplib/ntplib-0.3.3.tar.gz;

      sha256 = "c4621b64d50be9461d9bd9a71ba0b4af06fbbf818bbd483752d95c1a4e273ede";
    };

    meta = {
      description = "Python NTP library";
    };
  };

  numba = buildPythonPackage rec {
    version = "0.23.1";
    name = "numba-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/n/numba/${name}.tar.gz";
      sha256 = "80ce9968591db7c93e36258cc5e6734eb1e42826332799746dc6c073a6d5d317";
    };

    NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isDarwin "-I${pkgs.libcxx}/include/c++/v1";

    propagatedBuildInputs = with self; [numpy llvmlite argparse] ++ optional (!isPy3k) funcsigs ++ optional (isPy27 || isPy33) singledispatch;
    # Future work: add Cuda support.
    #propagatedBuildInputs = with self; [numpy llvmlite argparse pkgs.cudatoolkit6];
    #buildPhase = ''
    #  export NUMBAPRO_CUDA_DRIVER=
    #  export NUMBAPRO_NVVM=${pkgs.cudatoolkit6}
    #  export NUMBAPRO_LIBDEVICE=
    #'';

    # Copy test script into $out and run the test suite.
    checkPhase = ''
      cp runtests.py $out/${python.sitePackages}/numba/runtests.py
      ${python.interpreter} $out/${python.sitePackages}/numba/runtests.py
    '';
    # ImportError: cannot import name '_typeconv'
    doCheck = false;

    meta = {
      homepage = http://numba.pydata.org/;
      license = licenses.bsd2;
      description = "Compiling Python code using LLVM";
      maintainers = with maintainers; [ fridh ];
    };
  };

  numexpr = buildPythonPackage rec {
    version = "2.5";
    name = "numexpr-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/n/numexpr/${name}.tar.gz";
      sha256 = "319cdf4e402177a1c8ed4972cffd09f523446f186d347b7c1974787cdabf0294";
    };

    # Tests fail with python 3. https://github.com/pydata/numexpr/issues/177
    # doCheck = !isPy3k;

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

  buildNumpyPackage = callPackage ../development/python-modules/numpy.nix {
    gfortran = pkgs.gfortran;
    blas = pkgs.openblasCompat_2_14;
  };

  numpy = self.numpy_1_10;

  numpy_1_10 = self.buildNumpyPackage rec {
    version = "1.10.4";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/n/numpy/numpy-${version}.tar.gz";
      sha256 = "7356e98fbcc529e8d540666f5a919912752e569150e9a4f8d869c686f14c720b";
    };
  };

  numpydoc = buildPythonPackage rec {
    name = "numpydoc-${version}";
    version = "0.5";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/n/numpydoc/${name}.tar.gz";
      sha256 = "0d4dnifaxkll50jx6czj05y8cb4ny60njd2wz299sj2jxfy51w4k";
    };

    buildInputs = [ self.nose ];
    propagatedBuildInputs = [ self.sphinx self.matplotlib ];

    meta = {
      description = "Sphinx extension to support docstrings in Numpy format";
      homepage = "https://github.com/numpy/numpydoc";
      license = licenses.free;
    };
  };

  numtraits = buildPythonPackage rec {
    name = "numtraits-${version}";
    version = "0.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/n/numtraits/${name}.tar.gz";
      sha256 = "2fca9a6c9334f7358ef1a3e2e64ccaa6a479fc99fc096910e0d5fbe8edcdfd7e";
    };

    buildInputs = with self; [ pytest ];
    propagatedBuildInputs = with self; [ numpy traitlets];

    meta = {
      description = "Numerical traits for Python objects";
      license = licenses.bsd2;
      maintainers = with maintainers; [ fridh ];
      homepage = https://github.com/astrofrog/numtraits;
    };
  };

  nwdiag = buildPythonPackage rec {
    name = "nwdiag-1.0.3";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/n/nwdiag/${name}.tar.gz";
      sha256 = "0n7ary1fngxk8bk15vabc8fhnmxlh098piciwaviwn7l4a5q1zys";
    };

    buildInputs = with self; [ pep8 nose unittest2 docutils ];

    propagatedBuildInputs = with self; [ blockdiag ];

    # tests fail
    doCheck = false;

    meta = {
      description = "Generate network-diagram image from spec-text file (similar to Graphviz)";
      homepage = http://blockdiag.com/;
      license = licenses.asl20;
      platforms = platforms.linux;
      maintainers = with maintainers; [ bjornfor ];
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

    propagatedBuildInputs = with self; [ pkgs.rtmpdump pycrypto requests2 ]
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

  oauth = buildPythonPackage (rec {
    name = "oauth-1.0.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/o/oauth/oauth-1.0.1.tar.gz";
      sha256 = "0pdgi35hczsslil4890xqawnbpdazkgf2v1443847h5hy2gq2sg7";
    };

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
      url = "http://pypi.python.org/packages/source/o/oauth2/${name}.tar.gz";
      sha256 = "c006a85e7c60107c7cc6da1b184b5c719f6dd7202098196dfa6e55df669b59bf";
    };

    propagatedBuildInputs = with self; [ httplib2 ];

    buildInputs = with self; [ mock coverage ];

    # ServerNotFoundError: Unable to find the server at oauth-sandbox.sevengoslings.net
    doCheck = false;

    meta = {
      homepage = "https://github.com/simplegeo/python-oauth2";
      description = "library for OAuth version 1.0";
      license = licenses.mit;
      maintainers = with maintainers; [ garbas ];
      platforms = platforms.linux;
    };
  });

  oauth2client = buildPythonPackage rec {
    name = "oauth2client-1.4.12";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/o/oauth2client/${name}.tar.gz";
      sha256 = "0phfk6s8bgpap5xihdk1xv2lakdk1pb3rg6hp2wsg94hxcxnrakl";
    };

    propagatedBuildInputs = with self; [ six httplib2 pyasn1-modules rsa ];
    doCheck = false;

    meta = {
      description = "A client library for OAuth 2.0";
      homepage = http://github.com/google/oauth2client/;
      license = licenses.bsd2;
    };
  };

  oauthlib = buildPythonPackage rec {
    version = "0.7.2";
    name = "oauthlib-${version}";

    src = pkgs.fetchurl {
      url = "https://github.com/idan/oauthlib/archive/${version}.tar.gz";
      sha256 = "08b7swyswhxh90k9mp54rk1qks2l2s2pdcjap6x118y27p7dhp4h";
    };

    buildInputs = with self; [ mock nose unittest2 ];

    propagatedBuildInputs = with self; [ pycrypto blinker pyjwt ];

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
      sha256 = "16jb8x5hbs3g4dq10y6rqc1005bnffwnlws8x7j1d96n7k9mjn8h";
    };

    patchPhase = ''
      substituteInPlace setup.py --replace "version=versioneer.get_version()" "version='${version}'"
    '';

    propagatedBuildInputs = with self;
      [ pyptlib argparse twisted pycrypto pyyaml ];

    meta = {
      description = "a pluggable transport proxy";
      homepage = https://www.torproject.org/projects/obfsproxy;
      repositories.git = https://git.torproject.org/pluggable-transports/obfsproxy.git;
      maintainers = with maintainers; [ phreedom thoughtpolice ];
    };
  });

  objgraph = buildPythonPackage rec {
    name = "objgraph-${version}";
    version = "2.0.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/o/objgraph/${name}.tar.gz";
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

  odo = buildPythonPackage rec {
    name = "odo-${version}";
    version= "0.4.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/o/odo/${name}.tar.gz";
      sha256 = "f793df8b212994ea23ce34e90e2048d0237d3b95ecd066ef2cfbb1c2384b79e9";
    };

    buildInputs = with self; [ pytest ];
    propagatedBuildInputs = with self; [ datashape numpy pandas toolz multipledispatch networkx ];

    checkPhase = ''
      py.test odo/tests
    '';

    meta = {
      homepage = https://github.com/ContinuumIO/odo;
      description = "Data migration utilities";
      license = licenses.bsdOriginal;
      maintainers = with maintainers; [ fridh ];
    };
  };

  offtrac = buildPythonPackage rec {
    name = "offtrac-0.1.0";
    meta.maintainers = with maintainers; [ mornfall ];

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/o/offtrac/${name}.tar.gz";
      sha256 = "06vd010pa1z7lyfj1na30iqzffr4kzj2k2sba09spik7drlvvl56";
    };
    doCheck = false;
  };

  openpyxl = buildPythonPackage rec {
    version = "2.3.3";
    name = "openpyxl-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/o/openpyxl/${name}.tar.gz";
      sha256 = "1zigyvsq45izkhr1h5gisgi0ag5dm6kz09f01c2cgdfav1bl3mlk";
    };

    buildInputs = with self; [ pytest ];
    propagatedBuildInputs = with self; [ jdcal et_xmlfile lxml ];

    # Tests are not included in archive.
    # https://bitbucket.org/openpyxl/openpyxl/issues/610
    doCheck = false;

    meta = {
      description = "A Python library to read/write Excel 2007 xlsx/xlsm files";
      homepage = https://openpyxl.readthedocs.org;
      license = licenses.mit;
      maintainers = with maintainers; [ lihop sjourdois ];
      platforms = platforms.all;
    };
  };

  # optfunc = buildPythonPackage ( rec {
  #   name = "optfunc-git";
  #
  #   src = pkgs.fetchgit {
  #     url = "https://github.com/simonw/optfunc.git";
  #     rev = "e3fa034a545ed94ac5a039cf5b170c7d0ee21b7b";
  #   };
  #
  #   installCommand = ''
  #     dest=$(toPythonPath $out)/optfunc
  #     mkdir -p $dest
  #     cp * $dest/
  #   '';
  #
  #   doCheck = false;
  #
  #   meta = {
  #     description = "A new experimental interface to optparse which works by introspecting a function definition";
  #     homepage = "http://simonwillison.net/2009/May/28/optfunc/";
  #   };
  # });

  ordereddict = buildPythonPackage rec {
    name = "ordereddict-1.1";
    disabled = !isPy26;

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/o/ordereddict/${name}.tar.gz";
      md5 = "a0ed854ee442051b249bfad0f638bbec";
    };

    meta = {
      description = "A drop-in substitute for Py2.7's new collections.OrderedDict that works in Python 2.4-2.6";
      license = licenses.bsd3;
      maintainers = with maintainers; [ garbas ];
    };
  };

  ply = buildPythonPackage (rec {
    name = "ply-3.8";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/ply/${name}.tar.gz";
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

  osc = buildPythonPackage (rec {
    name = "osc-0.133+git";
    disabled = isPy3k;

    src = pkgs.fetchgit {
      url = https://github.com/openSUSE/osc;
      rev = "6cd541967ee2fca0b89e81470f18b97a3ffc23ce";
      sha256 = "a39ce0e321e40e9758bf7b9128d316c71b35b80eabc84f13df492083bb6f1cc6";
    };

    doCheck = false;
    postInstall = "ln -s $out/bin/osc-wrapper.py $out/bin/osc";

    propagatedBuildInputs = with self; [ self.m2crypto ];

  });

  oslosphinx = buildPythonPackage rec {
    name = "oslosphinx-3.3.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/o/oslosphinx/${name}.tar.gz";
      sha256 = "1rjiiahw2y7pg5rl15fvhmfyh26vm433000nwp7c94khx7w85w75";
    };

    doCheck = false;

    propagatedBuildInputs = with self; [
      pbr requests2 sphinx_1_2
    ];
  };

  tempest-lib = buildPythonPackage rec {
    name = "tempest-lib-${version}";
    version = "0.10.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/t/tempest-lib/${name}.tar.gz";
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

  os-testr = buildPythonPackage rec {
    name = "os-testr-${version}";
    version = "0.4.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/o/os-testr/${name}.tar.gz";
      sha256 = "0474z0mxb7y3vfk4s097wf1mzji5d135vh27cvlh9q17rq3x9r3w";
    };

    patchPhase = ''
      sed -i 's@python@${python.interpreter}@' .testr.conf
      sed -i 's@python@${python.interpreter}@' os_testr/tests/files/testr-conf
    '';

    checkPhase = ''
      export PATH=$PATH:$out/bin
      ${python.interpreter} setup.py test
    '';

    propagatedBuildInputs = with self; [ pbr Babel testrepository subunit testtools ];
    buildInputs = with self; [ coverage oslosphinx oslotest testscenarios six ddt ];
  };

  bandit = buildPythonPackage rec {
    name = "bandit-${version}";
    version = "0.16.1";
    disabled = isPy33;
    doCheck = !isPyPy; # a test fails

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/b/bandit/${name}.tar.gz";
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
    name = "oslo.serialization-${version}";
    version = "1.10.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/o/oslo.serialization/${name}.tar.gz";
      sha256 = "15k8aql2rx5jzv3hfvmd48vsyw172qa64bs3fmsyx25p37zyfy8a";
    };

    patchPhase = ''
      sed -i 's@python@${python.interpreter}@' .testr.conf
    '';

    propagatedBuildInputs = with self; [ pbr Babel six iso8601 pytz oslo-utils msgpack netaddr ];
    buildInputs = with self; [ oslotest mock coverage simplejson oslo-i18n ];
  };

  rfc3986 = buildPythonPackage rec {
    name = "rfc3986-${version}";
    version = "0.2.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/r/rfc3986/rfc3986-0.2.2.tar.gz";
      sha256 = "0yvzz7gp84qqdadbjdh9ch7dz4w19nmhwa704s9m11bljgp3hqmn";
    };

    LC_ALL = "en_US.UTF-8";
    buildInputs = [ pkgs.glibcLocales ];

    meta = with stdenv.lib; {
      description = "rfc3986";
      homepage = https://rfc3986.rtfd.org;
    };
  };

  pycadf = buildPythonPackage rec {
    name = "pycadf-${version}";
    version = "1.1.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pycadf/pycadf-1.1.0.tar.gz";
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
    name = "oslo.utils-${version}";
    version = "2.6.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/o/oslo.utils/${name}.tar.gz";
      sha256 = "1prgi03nxkcykyja821qkycsqlnpyzw17mpvj8qf3pjmgb9gv1fy";
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
      url = "https://pypi.python.org/packages/source/o/oslo.middleware/${name}.tar.gz";
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
       url = "https://pypi.python.org/packages/source/o/oslo.versionedobjects/${name}.tar.gz";
       sha256 = "1ddcb2zf7a3544ay4sxw200a4mz7p0n1f7826h3vibfdqjlc80y7";
     };

     propagatedBuildInputs = with self; [
       six Babel oslo-concurrency oslo-config oslo-context oslo-messaging
       oslo-serialization oslo-utils iso8601 oslo-log oslo-i18n webob
     ];
     buildInputs = with self; [
       oslo-middleware cachetools oslo-service futurist anyjson oslosphinx
       testtools oslotest
     ];

     meta = with stdenv.lib; {
       homepage = "http://launchpad.net/oslo";
     };
   };

   cachetools = buildPythonPackage rec {
     name = "cachetools-${version}";
     version = "1.1.3";
     disabled = isPyPy;  # a test fails

     src = pkgs.fetchurl {
       url = "https://pypi.python.org/packages/source/c/cachetools/${name}.tar.gz";
       sha256 = "0js7qx5pa8ibr8487lcf0x3a7w0xml0wa17snd6hjs0857kqhn20";
     };

     meta = with stdenv.lib; {
       homepage = "https://github.com/tkem/cachetools";
     };
   };

   futurist = buildPythonPackage rec {
     name = "futurist-${version}";
     version = "0.7.0";

     src = pkgs.fetchurl {
       url = "https://pypi.python.org/packages/source/f/futurist/${name}.tar.gz";
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

   };

  oslo-messaging = buildPythonPackage rec {
    name = "oslo.messaging-${version}";
    version = "2.7.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/o/oslo.messaging/${name}.tar.gz";
      sha256 = "1af7l4ri3xfjcnjp2yhngz34h3ls00yyj1x8i64dxb86ryy43kd1";
    };

    propagatedBuildInputs = with self; [
      pbr oslo-config oslo-context oslo-log oslo-utils oslo-serialization
      oslo-i18n stevedore six eventlet greenlet webob pyyaml kombu trollius
      aioeventlet cachetools oslo-middleware futurist redis oslo-service
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
     url = "https://pypi.python.org/packages/source/o/os-brick/${name}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/o/oslo.reports/${name}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/p/python-cinderclient/python-cinderclient-${version}.tar.gz";
      sha256 = "1vfcjljfad3034bfhfcrfhphym1ik6qk42nrxzl0gqb9408n6k3l";
    };

    propagatedBuildInputs = with self; [
      six Babel simplejson requests2 keystoneclient prettytable argparse pbr
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
    };
  };

  neutronclient = buildPythonPackage rec {
    name = "neutronclient-${version}";
    version = "3.1.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/python-neutronclient/python-neutronclient-${version}.tar.gz";
      sha256 = "0g96x5b8lz407in70j6v7jbj613y6sd61b21j1y03x06b2rk5i02";
    };

    propagatedBuildInputs = with self; [
      pbr six simplejson keystoneclient requests2 oslo-utils oslo-serialization
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
      url = "https://pypi.python.org/packages/source/c/cliff/${name}.tar.gz";
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
    };
  };

  cmd2 = buildPythonPackage rec {
    name = "cmd2-${version}";
    version = "0.6.8";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/c/cmd2/${name}.tar.gz";
      sha256 = "1a346zcd46c8gwbbp2cxsmvgfkyy26kwxjzdnkv7n47w6660sy5c";
    };

    # No tests included
    doCheck = false;

    propagatedBuildInputs = with self; [
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
      url = "https://pypi.python.org/packages/source/o/oslo.db/${name}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/o/oslo.rootwrap/${name}.tar.gz";
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
     url = "https://pypi.python.org/packages/source/p/python-glanceclient/python-glanceclient-${version}.tar.gz";
     sha256 = "0ppjafsmf29ps23jsw6g2xm66pdi5jdzpywglqqm28b8fj931zsr";
   };

   propagatedBuildInputs = with self; [
     oslo-i18n oslo-utils six requests2 keystoneclient prettytable Babel pbr
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
   };
 };

 warlock = buildPythonPackage rec {
   name = "warlock-${version}";
   version = "1.2.0";

   src = pkgs.fetchurl {
     url = "https://pypi.python.org/packages/source/w/warlock/${name}.tar.gz";
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
    name = "oslo.service-${version}";
    version = "0.10.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/o/oslo.service/oslo.service-0.10.0.tar.gz";
      sha256 = "1pcnimc2a50arcgq355ad9lramf6y1yv974swgfj6w90v5c6p9gz";
    };

    propagatedBuildInputs = with self; [
      repoze_lru PasteDeploy Babel oslo-context debtcollector
      oslo-concurrency wrapt eventlet six oslo-serialization greenlet paste
      oslo-config monotonic iso8601 oslo-log pytz routes msgpack
      oslo-i18n argparse oslo-utils pbr enum34 netaddr stevedore netifaces
      pyinotify webob retrying pyinotify ];
    buildInputs = with self; [
      oslosphinx oslotest pkgs.procps mock mox3 fixtures subunit testrepository
      testtools testscenarios
    ];

    # failing tests
    preCheck = ''
      rm oslo_service/tests/test_service.py
    '';

    meta = with stdenv.lib; {
      homepage = "http://wiki.openstack.org/wiki/Oslo#oslo.service";
    };
  };

  oslo-cache = buildPythonPackage rec {
    name = "oslo.cache-${version}";
    version = "0.9.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/o/oslo.cache/${name}.tar.gz";
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

  pecan = buildPythonPackage rec {
    name = "pecan-${version}";
    version = "1.0.3";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pecan/${name}.tar.gz";
      sha256 = "04abmybab8jzbwgmrr0fcpcfhcvvkdsv9q135dss02wyk9q9jv4d";
    };

    propagatedBuildInputs = with self; [
      singledispatch logutils
    ];
    buildInputs = with self; [
      webtest Mako genshi Kajiki sqlalchemy gunicorn jinja2 virtualenv
    ];

    meta = with stdenv.lib; {
      description = "Pecan";
      homepage = "http://github.com/pecan/pecan";
    };
  };

  Kajiki = buildPythonPackage rec {
    name = "Kajiki-${version}";
    version = "0.5.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/K/Kajiki/${name}.tar.gz";
      sha256 = "1ayhr4g5q2hhh50fd33dkb7l8z8n2hnnx3lmhivzg3paf47b3ssz";
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
      url = "https://pypi.python.org/packages/source/r/ryu/${name}.tar.gz";
      sha256 = "1fhriqi7qnvvx9mbvlfm94i5drh920lg204zy3v0qjz43sinkih6";
    };
  };

  WSME = buildPythonPackage rec {
    name = "WSME-${version}";
    version = "0.8.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/W/WSME/${name}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/t/taskflow/${name}.tar.gz";
      sha256 = "15np1rc6g9vksgdj0y930ysx5wbmhvc082g264j5zbj6c479g8qa";
    };

    propagatedBuildInputs = with self; [
      pbr futures enum34 debtcollector cachetools oslo-serialization oslo-utils
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
      url = "https://pypi.python.org/packages/source/g/glance_store/${name}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/p/python-swiftclient/python-swiftclient-${version}.tar.gz";
      sha256 = "1j33l4z9vqh0scfncl4fxg01zr1hgqxhhai6gvcih1gccqm4nd7p";
    };

    propagatedBuildInputs = with self; [
      pbr requests2 futures six
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
      url = "https://pypi.python.org/packages/source/c/castellan/${name}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/z/zake/${name}.tar.gz";
      sha256 = "1rp4xxy7qp0s0wnq3ig4ji8xsl31g901qkdp339ndxn466cqal2s";
    };

    propagatedBuildInputs = with self; [
      kazoo six
    ];
    buildInputs = with self; [

    ];

    meta = with stdenv.lib; {
      homepage = "https://github.com/yahoo/Zake";
    };
  };

  automaton = buildPythonPackage rec {
    name = "automaton-${version}";
    version = "0.8.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/a/automaton/${name}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/n/networking-hyperv/${name}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/k/kazoo/${name}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/o/osprofiler/${name}.tar.gz";
      sha256 = "01rjym49nn4ry1pr2n8fyal1hf17jqhp2yihg8gr15nfjc5iszkx";
    };

    propagatedBuildInputs = with self; [
      pbr argparse six webob
    ];
    buildInputs = with self; [
      oslosphinx coverage mock subunit testrepository testtools
    ];

    patchPhase = ''
      sed -i 's@python@${python.interpreter}@' .testr.conf
    '';
  };

  FormEncode = buildPythonPackage rec {
    name = "FormEncode-${version}";
    version = "1.3.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/F/FormEncode/${name}.zip";
      sha256 = "0y5gywq0l79l85ylr55p4xy0h921zgmfw6zmrvlh83aa4j074xg6";
    };

    buildInputs = with self; [
      dns pycountry nose
    ];

    preCheck = ''
      # two tests require dns resolving
      sed -i 's/test_cyrillic_email/noop/' formencode/tests/test_email.py
      sed -i 's/test_unicode_ascii_subgroup/noop/' formencode/tests/test_email.py
    '';

    meta = with stdenv.lib; {
      description = "FormEncode validates and converts nested structures";
      homepage = "http://formencode.org";
    };
  };

  pycountry = buildPythonPackage rec {
    name = "pycountry-${version}";
    version = "1.17";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pycountry/${name}.tar.gz";
      sha256 = "1qvhq0c9xsh6d4apcvjphfzl6xnwhnk4jvhr8x2fdfnmb034lc26";
    };
  };

  nine = buildPythonPackage rec {
    name = "nine-${version}";
    version = "0.3.4";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/n/nine/${name}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/l/logutils/${name}.tar.gz";
      sha256 = "173w55fg3hp5dhx7xvssmgqkcv5fjlaik11w5dah2fxygkjvhhj0";
    };
  };

  oslo-policy = buildPythonPackage rec {
    name = "oslo.policy-${version}";
    version = "0.12.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/o/oslo.policy/${name}.tar.gz";
      sha256 = "06apaj6fwg7f2g5psmxzr5a9apj2l4k2y8kl1hqzyssykblij8ss";
    };

    propagatedBuildInputs = with self; [
      requests2 oslo-config oslo-i18n oslo-serialization oslo-utils six
    ];
    buildInputs = with self; [
      oslosphinx httpretty oslotest
    ];
  };

  ldappool = buildPythonPackage rec {
    name = "ldappool-${version}";
    version = "1.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/l/ldappool/${name}.tar.gz";
      sha256 = "1akmzf51cjfvmd0nvvm562z1w9vq45zsx6fa72kraqgsgxhnrhqz";
    };

    # Judging from SyntaxError
    disabled = isPy3k;

    meta = with stdenv.lib; {
      homepage = "https://github.com/mozilla-services/ldappool";
    };
  };


  oslo-concurrency = buildPythonPackage rec {
   name = "oslo-concurrency-${version}";
   version = "2.7.0";

   src = pkgs.fetchurl {
     url = "https://pypi.python.org/packages/source/o/oslo.concurrency/oslo.concurrency-2.7.0.tar.gz";
     sha256 = "1yp8c87yi6fx1qbq4y1xkx47iiifg7jqzpcghivhxqra8vna185d";
   };

   propagatedBuildInputs = with self; [
     oslo-i18n argparse six wrapt oslo-utils pbr enum34 Babel netaddr monotonic
     iso8601 oslo-config pytz netifaces stevedore debtcollector retrying fasteners
     eventlet
   ];
   buildInputs = with self; [
     oslosphinx fixtures futures coverage oslotest
   ];

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
      url = "https://pypi.python.org/packages/source/r/retrying/retrying-1.3.3.tar.gz";
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
    version = "0.13.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/f/fasteners/fasteners-0.13.0.tar.gz";
      sha256 = "0nghdq3zihiqg10dp76ls7yn44m5wjncyz7fk8isagkrspkh9a3n";
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
      url = "https://pypi.python.org/packages/source/a/aioeventlet/aioeventlet-0.4.tar.gz";
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

  oslo-log = buildPythonPackage rec {
    name = "oslo.log-${version}";
    version = "1.12.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/o/oslo.log/${name}.tar.gz";
      sha256 = "10x596r19zjla5n1bf04j5vncx0c9gpc5wc2jlmgjbl3cyx3vgsv";
    };

    propagatedBuildInputs = with self; [
      pbr Babel six iso8601 debtcollector
      oslo-utils oslo-i18n oslo-config oslo-serialization oslo-context
    ] ++ stdenv.lib.optional stdenv.isLinux pyinotify;
    buildInputs = with self; [ oslotest oslosphinx ];
    patchPhase = ''
      sed -i 's@python@${python.interpreter}@' .testr.conf
    '';
  };

  oslo-context = buildPythonPackage rec {
    name = "oslo.context-${version}";
    version = "0.7.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/o/oslo.context/${name}.tar.gz";
      sha256 = "18fmg9dhgngshk63wfb3ddrgx5br8jxkk3x30z40741mslp1fdjy";
    };

    propagatedBuildInputs = with self; [ pbr Babel ];
    buildInputs = with self; [ oslotest coverage oslosphinx ];
    patchPhase = ''
      sed -i 's@python@${python.interpreter}@' .testr.conf
    '';
  };

  oslo-i18n = buildPythonPackage rec {
    name = "oslo.i18n-${version}";
    version = "2.7.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/o/oslo.i18n/${name}.tar.gz";
      sha256 = "11jgcvj36g97awh7fpar4xxgwrvzfahq6rw7xxqac32ia790ylcz";
    };

    propagatedBuildInputs = with self; [ pbr Babel six oslo-config ];
    buildInputs = with self; [ mock coverage oslotest ];
    patchPhase = ''
      sed -i 's@python@${python.interpreter}@' .testr.conf
    '';
  };

  oslo-config = buildPythonPackage rec {
    name = "oslo.config-${version}";
    version = "2.5.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/o/oslo.config/${name}.tar.gz";
      sha256 = "043mavrzj7vjn7kh1dddci4sf67qwqnnn6cm0k1d19alks9hismz";
    };

    propagatedBuildInputs = with self; [ argparse pbr six netaddr stevedore ];
    buildInputs = [ self.mock ];

    # TODO: circular import on oslo-i18n
    doCheck = false;
  };

  oslotest = buildPythonPackage rec {
    name = "oslotest-${version}";
    version = "1.12.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/o/oslotest/${name}.tar.gz";
      sha256 = "17i92hymw1dwmmb5yv90m2gam2x21mc960q1pr7bly93x49h8666";
    };

    patchPhase = ''
      sed -i 's@python@${python.interpreter}@' .testr.conf
    '';

    propagatedBuildInputs = with self; [ pbr fixtures subunit six testrepository
      testscenarios testtools mock mox3 oslo-config os-client-config ];
  };

  os-client-config = buildPythonPackage rec {
    name = "os-client-config-${version}";
    version = "1.8.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/o/os-client-config/${name}.tar.gz";
      sha256 = "10hz4yp594mi1p7v1pvgsmx5w2rnb9y8d0jvb2lfv03ljnwzv8jz";
    };

    buildInputs = with self; [ pbr testtools testscenarios testrepository fixtures ];
    propagatedBuildInputs = with self; [ appdirs pyyaml keystoneauth1 ];

    patchPhase = ''
      sed -i 's@python@${python.interpreter}@' .testr.conf
    '';
    # TODO: circular import on oslotest
    preCheck = ''
      rm os_client_config/tests/{test_config,test_cloud_config,test_environ}.py
    '';
  };

  keystoneauth1 = buildPythonPackage rec {
    name = "keystoneauth1-${version}";
    version = "1.1.0";
    disabled = isPyPy; # a test fails

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/k/keystoneauth1/${name}.tar.gz";
      sha256 = "05fc6xsp5mal52ijvj84sf7mrw706ihadfdf5mnq9zxn7pfl4118";
    };

    buildInputs = with self; [ pbr testtools testresources testrepository mock
                               pep8 fixtures mox3 requests-mock ];
    propagatedBuildInputs = with self; [ argparse iso8601 requests2 six stevedore
                                         webob oslo-config ];
    patchPhase = ''
      sed -i 's@python@${python.interpreter}@' .testr.conf
    '';
  };

  requests-mock = buildPythonPackage rec {
    name = "requests-mock-${version}";
    version = "0.6.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/r/requests-mock/${name}.tar.gz";
      sha256 = "0gmd88c224y53b1ai8cfsrcxm9kw3gdqzysclmnaqspg7zjhxwd1";
    };

    patchPhase = ''
      sed -i 's@python@${python.interpreter}@' .testr.conf
    '';

    buildInputs = with self; [ pbr testtools testrepository mock ];
    propagatedBuildInputs = with self; [ six requests2 ];
  };

  mox3 = buildPythonPackage rec {
    name = "mox3-${version}";
    version = "0.11.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/m/mox3/${name}.tar.gz";
      sha256 = "09dkgki21v5zqrx575h1aazxsq5akkv0a90z644bk1ry9a4zg1pn";
    };

    patchPhase = ''
      sed -i 's@python@${python.interpreter}@' .testr.conf
    '';

    buildInputs = with self; [ subunit testrepository testtools six ];
    propagatedBuildInputs = with self; [ pbr fixtures ];
  };

  debtcollector = buildPythonPackage rec {
    name = "debtcollector-${version}";
    version = "0.9.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/debtcollector/${name}.tar.gz";
      sha256 = "1mvdxdrnwlgfqg26s5himkjq6f06r2khlrignx36kkbyaix6j9xb";
    };
    patchPhase = ''
      sed -i 's@python@${python.interpreter}@' .testr.conf
    '';

    buildInputs = with self; [ pbr Babel six wrapt testtools testscenarios
      testrepository subunit coverage oslotest ];
  };

  wrapt = buildPythonPackage rec {
    name = "wrapt-${version}";
    version = "1.10.5";

    # No tests in archive
    doCheck = false;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/w/wrapt/${name}.tar.gz";
      sha256 = "0cq8rlpzkxzk48b50yrfhzn1d1hrq4gjcdqlrgq4v5palgiv9jwr";
    };
  };

  pagerduty = buildPythonPackage rec {
    name = "pagerduty-${version}";
    version = "0.2.1";
    disabled = isPy3k;

    src = pkgs.fetchurl {
        url = "https://pypi.python.org/packages/source/p/pagerduty/pagerduty-${version}.tar.gz";
        sha256 = "e8c237239d3ffb061069aa04fc5b3d8ae4fb0af16a9713fe0977f02261d323e9";
    };
  };

  pandas = self.pandas_18;

  pandas_17 = let
    inherit (pkgs.stdenv.lib) optional optionalString;
    inherit (pkgs.stdenv) isDarwin;
  in buildPythonPackage rec {
    name = "pandas-${version}";
    version = "0.17.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pandas/${name}.tar.gz";
      sha256 = "cfd7214a7223703fe6999fbe34837749540efee1c985e6aee9933f30e3f72837";
    };

    buildInputs = with self; [ nose ] ++ optional isDarwin pkgs.libcxx;
    propagatedBuildInputs = with self; [
      dateutil
      scipy_0_17
      numexpr
      pytz
      xlrd
      bottleneck
      sqlalchemy
      lxml
      html5lib
      modules.sqlite3
      beautifulsoup4
    ] ++ optional isDarwin pkgs.darwin.locale; # provides the locale command

    # For OSX, we need to add a dependency on libcxx, which provides
    # `complex.h` and other libraries that pandas depends on to build.
    patchPhase = optionalString isDarwin ''
      cpp_sdk="${pkgs.libcxx}/include/c++/v1";
      echo "Adding $cpp_sdk to the setup.py common_include variable"
      substituteInPlace setup.py \
        --replace "['pandas/src/klib', 'pandas/src']" \
                  "['pandas/src/klib', 'pandas/src', '$cpp_sdk']"

      # disable clipboard tests since pbcopy/pbpaste are not open source
      substituteInPlace pandas/io/tests/test_clipboard.py \
        --replace pandas.util.clipboard no_such_module \
        --replace OSError ImportError
    '';

    # The flag `-A 'not network'` will disable tests that use internet.
    # The `-e` flag disables a few problematic tests.
    # https://github.com/pydata/pandas/issues/11169
    # https://github.com/pydata/pandas/issues/11287
    # The test_sql checks fail specifically on python 3.5; see here:
    # https://github.com/pydata/pandas/issues/11112
    checkPhase = let
      testsToSkip = ["test_data" "test_excel" "test_html" "test_json"
                     "test_frequencies" "test_frame"
                     "test_read_clipboard_infer_excel"
                     "test_interp_alt_scipy" "test_nanops" "test_stats"] ++
                    optional isPy35 "test_sql";
    in ''
      runHook preCheck
      # The flag `-A 'not network'` will disable tests that use internet.
      # The `-e` flag disables a few problematic tests.
      ${python.executable} setup.py nosetests -A 'not slow and not network' --stop \
        -e '${concatStringsSep "|" testsToSkip}' --verbosity=3

      runHook postCheck
    '';

    meta = {
      homepage = "http://pandas.pydata.org/";
      description = "Python Data Analysis Library";
      license = licenses.bsd3;
      maintainers = with maintainers; [ raskin fridh ];
      platforms = platforms.unix;
    };
  };

  pandas_18 = let
    inherit (pkgs.stdenv.lib) optional optionalString;
    inherit (pkgs.stdenv) isDarwin;
  in buildPythonPackage rec {
    name = "pandas-${version}";
    version = "0.18.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pandas/${name}.tar.gz";
      sha256 = "050qw0ap5bhyv5flp78x3lcq1dlminl3xaj6kbrm0jqmx0672xf9";
    };


    LC_ALL = "en_US.UTF-8";
    buildInputs = with self; [ nose pkgs.glibcLocales ] ++ optional isDarwin pkgs.libcxx;
    propagatedBuildInputs = with self; [
      dateutil
      scipy
      numexpr
      pytz
      xlrd
      bottleneck
      sqlalchemy
      lxml
      html5lib
      modules.sqlite3
      beautifulsoup4
      openpyxl
      xlwt
    ] ++ optional isDarwin pkgs.darwin.locale; # provides the locale command

    # For OSX, we need to add a dependency on libcxx, which provides
    # `complex.h` and other libraries that pandas depends on to build.
    patchPhase = optionalString isDarwin ''
      cpp_sdk="${pkgs.libcxx}/include/c++/v1";
      echo "Adding $cpp_sdk to the setup.py common_include variable"
      substituteInPlace setup.py \
        --replace "['pandas/src/klib', 'pandas/src']" \
                  "['pandas/src/klib', 'pandas/src', '$cpp_sdk']"

      # disable clipboard tests since pbcopy/pbpaste are not open source
      substituteInPlace pandas/io/tests/test_clipboard.py \
        --replace pandas.util.clipboard no_such_module \
        --replace OSError ImportError
    '';

    # The flag `-A 'not network'` will disable tests that use internet.
    # The `-e` flag disables a few problematic tests.
    # https://github.com/pydata/pandas/issues/11169
    # https://github.com/pydata/pandas/issues/11287
    # The test_sql checks fail specifically on python 3.5; see here:
    # https://github.com/pydata/pandas/issues/11112
    checkPhase = let
      testsToSkip = [];
    in ''
      runHook preCheck
      # The flag `-A 'not network'` will disable tests that use internet.
      # The `-e` flag disables a few problematic tests.
      ${python.executable} setup.py nosetests -A 'not slow and not network' \
         --verbosity=3

      runHook postCheck
    '';

    meta = {
      homepage = "http://pandas.pydata.org/";
      description = "Python Data Analysis Library";
      license = licenses.bsd3;
      maintainers = with maintainers; [ raskin fridh ];
      platforms = platforms.unix;
    };
  };

  xlrd = buildPythonPackage rec {
    name = "xlrd-${version}";

    version = "0.9.4";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/x/xlrd/xlrd-${version}.tar.gz";
      sha256 = "8e8d3359f39541a6ff937f4030db54864836a06e42988c452db5b6b86d29ea72";
    };

    buildInputs = with self; [ nose ];
    checkPhase = ''
      nosetests -v
    '';

  };

  bottleneck = buildPythonPackage rec {
    name = "Bottleneck-${version}";
    version = "1.0.0";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/B/Bottleneck/Bottleneck-${version}.tar.gz";
      sha256 = "15dl0ll5xmfzj2fsvajzwxsb9dbw5i9fx9i4r6n4i5nzzba7m6wd";
    };

    buildInputs = with self; [ nose ];
    propagatedBuildInputs = [self.numpy];
    checkPhase = ''
      nosetests -v $out/${python.sitePackages}
    '';
  };

  paho-mqtt = buildPythonPackage rec {
    name = "paho-mqtt-${version}";
    version = "1.1";

    disabled = isPyPy || isPy26;

    src = pkgs.fetchurl {
        url = "https://pypi.python.org/packages/source/p/paho-mqtt/${name}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/p/pamqp/${name}.tar.gz";
      sha256 = "1vmyvynqzx5zvbipaxff4fnzy3h3dvl3zicyr15yb816j93jl2ca";
    };

    buildInputs = with self; [ mock nose pep8 pylint ];

    meta = {
      description = "RabbitMQ Focused AMQP low-level library";
      homepage = https://pypi.python.org/pypi/pamqp;
      license = licenses.bsd3;
    };
  };

  parsedatetime = buildPythonPackage rec {
    name = "parsedatetime-${version}";
    version = "1.4";

    src = pkgs.fetchurl {
        url = "https://pypi.python.org/packages/source/p/parsedatetime/${name}.tar.gz";
        sha256 = "09bfcd8f3c239c75e77b3ff05d782ab2c1aed0892f250ce2adf948d4308fe9dc";
    };
  };

  paramiko = buildPythonPackage rec {
    name = "paramiko-1.15.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/paramiko/${name}.tar.gz";
      sha256 = "6ed97e2281bb48728692cdc621f6b86a65fdc1d46b178ce250cfec10b977a04c";
    };

    propagatedBuildInputs = with self; [ pycrypto ecdsa ];

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

  patsy = buildPythonPackage rec {
    name = "patsy-${version}";
    version = "0.3.0";

    src = pkgs.fetchurl{
      url = "https://pypi.python.org/packages/source/p/patsy/${name}.zip";
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
    name = "paste-1.7.5.1";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = http://pypi.python.org/packages/source/P/Paste/Paste-1.7.5.1.tar.gz;
      sha256 = "11645842ba8ec986ae8cfbe4c6cacff5c35f0f4527abf4f5581ae8b4ad49c0b6";
    };

    buildInputs = with self; [ nose ];

    doCheck = false; # some files required by the test seem to be missing

    meta = {
      description = "Tools for using a Web Server Gateway Interface stack";
      homepage = http://pythonpaste.org/;
    };
  };


  PasteDeploy = buildPythonPackage rec {
    version = "1.5.2";
    name = "paste-deploy-${version}";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/P/PasteDeploy/PasteDeploy-${version}.tar.gz";
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
    name = "PasterScript-${version}";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/P/PasteScript/${name}.tar.gz";
      sha256 = "2b685be69d6ac8bc0fe6f558f119660259db26a15e16a4943c515fbee8093539";
    };

    doCheck = false;
    buildInputs = with self; [ nose ];
    propagatedBuildInputs = with self; [ paste PasteDeploy cheetah argparse ];

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
      url = "https://pypi.python.org/packages/source/p/pathlib/${name}.tar.gz";
      sha256 = "17zajiw4mjbkkv6ahp3xf025qglkj0805m9s41c45zryzj6p2h39";
    };

    meta = {
      description = "Object-oriented filesystem paths";
      homepage = "https://pathlib.readthedocs.org/";
      license = licenses.mit;
    };
  };

  pathpy = buildPythonPackage rec {
    version = "8.1.2";
    name = "path.py-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/path.py/${name}.tar.gz";
      sha256 = "ada95d117c4559abe64080961daf5badda68561afdd34c278f8ca20f2fa466d2";
    };

    buildInputs = with self; [setuptools_scm pytestrunner pytest pkgs.glibcLocales ];

    LC_ALL="en_US.UTF-8";

    meta = {
      description = "A module wrapper for os.path";
      homepage = http://github.com/jaraco/path.py;
      license = licenses.mit;
    };

    checkPhase = ''
      py.test test_path.py
    '';
  };

  paypalrestsdk = buildPythonPackage rec {
    name = "paypalrestsdk-0.7.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/paypalrestsdk/${name}.tar.gz";
      sha256 = "117kfipzfahf9ysv414bh1mmm5cc9ck5zb6rhpslx1f8gk3frvd6";
    };

    propagatedBuildInputs = with self; [ httplib2 ];

    meta = {
      homepage = https://developer.paypal.com/;
      description = "Python APIs to create, process and manage payment";
      license = "PayPal SDK License";
    };
  };

  pbr = buildPythonPackage rec {
    name = "pbr-${version}";
    version = "1.8.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pbr/${name}.tar.gz";
      sha256 = "0jcny36cf3s8ar5r4a575npz080hndnrfs4np1fqhv0ym4k7c4p2";
    };

    # circular dependencies with fixtures
    doCheck = false;
    #buildInputs = with self; [ testtools testscenarios testresources
    #  testrepository fixtures ];

    meta = {
      description = "Python Build Reasonableness";
      homepage = "http://docs.openstack.org/developer/pbr/";
      license = licenses.asl20;
    };
  };

  fixtures = buildPythonPackage rec {
    name = "fixtures-1.4.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/f/fixtures/${name}.tar.gz";
      sha256 = "0djxvdwm8s60dbfn7bhf40x6g818p3b3mlwijm1c3bqg7msn271y";
    };

    buildInputs = with self; [ pbr testtools mock ];

    meta = {
      description = "Reusable state for writing clean tests and more";
      homepage = "https://pypi.python.org/pypi/fixtures";
      license = licenses.asl20;
    };
  };

  pelican = buildPythonPackage rec {
    name = "pelican-${version}";
    version = "3.6.3";
    disabled = isPy26;

    src = pkgs.fetchFromGitHub {
      owner = "getpelican";
      repo = "pelican";
      rev = version;
      sha256 = "1k572anw39rws67mvxl2w6y93y8w8q5smnwc0dd2gnnr16cc2vsh";
    };

    patches = [ ../development/python-modules/pelican-fix-tests-with-pygments-2.1.patch ];

    buildInputs = with self; [
      pkgs.glibcLocales
      pkgs.pandoc
      pkgs.git
      mock
      nose
      markdown
      beautifulsoup4
      lxml
      typogrify
    ];

    propagatedBuildInputs = with self; [
      jinja2 pygments docutils pytz unidecode six dateutil feedgenerator
      blinker pillow beautifulsoup4 markupsafe
    ];

    postPatch= ''
      sed -i -e "s|'git'|'${pkgs.git}/bin/git'|" pelican/tests/test_pelican.py
    '';

    LC_ALL="en_US.UTF-8";

    meta = {
      description = "A tool to generate a static blog from reStructuredText or Markdown input files";
      homepage = "http://getpelican.com/";
      license = licenses.agpl3;
      maintainers = with maintainers; [ offline prikhi garbas ];
    };
  };

  pep8 = buildPythonPackage rec {
    name = "pep8-${version}";
    version = "1.7.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pep8/${name}.tar.gz";
      sha256 = "a113d5f5ad7a7abacef9df5ec3f2af23a20a28005921577b15dd584d099d5900";
    };

    meta = {
      homepage = "http://pep8.readthedocs.org/";
      description = "Python style guide checker";
      license = licenses.mit;
      maintainers = with maintainers; [ garbas ];
    };
  };

  pep257 = buildPythonPackage rec {
    name = "pep257-${version}";
    version = "0.3.2";

    src = pkgs.fetchurl {
      url = "https://github.com/GreenSteam/pep257/archive/${version}.tar.gz";
      sha256 = "0v8aq0xzsa7clazszxl42904c3jpq69lg8a5hg754bqcqf72hfrn";
    };
    buildInputs = with self; [ pytest ];

    meta = {
      homepage = https://github.com/GreenSteam/pep257/;
      description = "Python docstring style checker";
      longDescription = "Static analysis tool for checking compliance with Python PEP 257.";
      lecense = licenses.mit;
    };
  };

  percol = buildPythonPackage rec {
    name = "percol-${version}";
    version = "0.0.8";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/percol/${name}.tar.gz";
      sha256 = "169s5mhw1s60qbsd6pkf9bb2x6wfgx8hn8nw9d4qgc68qnnpp2cj";
    };

    propagatedBuildInputs = with self; [ modules.curses ];

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
      url = "https://pypi.python.org/packages/source/p/pexif/pexif-0.15.tar.gz";
      sha256 = "45a3be037c7ba8b64bbfc48f3586402cc17de55bb9d7357ef2bc99954a18da3f";
    };

    meta = {
      description = "A module for editing JPEG EXIF data";
      homepage = http://www.benno.id.au/code/pexif/;
      license = licenses.mit;
    };
  };


  pexpect = buildPythonPackage rec {
    version = "3.3";
    name = "pexpect-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pexpect/${name}.tar.gz";
      sha256 = "dfea618d43e83cfff21504f18f98019ba520f330e4142e5185ef7c73527de5ba";
    };

    # Wants to run python in a subprocess
    doCheck = false;

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


  pg8000 = buildPythonPackage rec {
    name = "pg8000-1.10.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pg8000/${name}.tar.gz";
      sha256 = "188658db63c2ca931ae1bf0167b34efaac0ecc743b707f0118cc4b87e90ce488";
    };

    propagatedBuildInputs = with self; [ pytz ];

    meta = {
      maintainers = with maintainers; [ garbas iElectric ];
      platforms = platforms.linux;
    };
  };

  pgcli = buildPythonPackage rec {
    name = "pgcli-${version}";
    version = "0.19.2";

    src = pkgs.fetchFromGitHub {
      sha256 = "1xl3yqwksnszd2vcgzb576m56613qcl82jfqmb9fbvcqlcpks6ln";
      rev = "v${version}";
      repo = "pgcli";
      owner = "dbcli";
    };

    propagatedBuildInputs = with self; [
      click configobj prompt_toolkit psycopg2 pygments sqlparse
    ];

    meta = {
      inherit version;
      description = "Command-line interface for PostgreSQL";
      longDescription = ''
        Rich command-line interface for PostgreSQL with auto-completion and
        syntax highlighting.
      '';
      homepage = http://pgcli.com;
      license = licenses.bsd3;
      maintainers = with maintainers; [ nckx ];
    };
  };

  mycli = buildPythonPackage rec {
    name = "mycli-${version}";
    version = "1.4.0";

    src = pkgs.fetchFromGitHub {
      sha256 = "175jcfixjkq17fbda9kifbljfd5iwjpjisvhs5xhxsyf6n5ykv2l";
      rev = "v${version}";
      repo = "mycli";
      owner = "dbcli";
    };

    propagatedBuildInputs = with self; [
      pymysql configobj sqlparse prompt_toolkit pygments click
    ];

    meta = {
      inherit version;
      description = "Command-line interface for MySQL";
      longDescription = ''
        Rich command-line interface for MySQL with auto-completion and
        syntax highlighting.
      '';
      homepage = http://mycli.net;
      license = licenses.bsd3;
    };
  };

  pickleshare = buildPythonPackage rec {
    version = "0.5";
    name = "pickleshare-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pickleshare/${name}.tar.gz";
      sha256 = "c0be5745035d437dbf55a96f60b7712345b12423f7d0951bd7d8dc2141ca9286";
    };

    propagatedBuildInputs = with self; [pathpy];

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
      url = "http://pypi.python.org/packages/source/p/piep/piep-${version}.tar.gz";
      sha256 = "1wgkg1kc28jpya5k4zvbc9jmpa60b3d5c3gwxfbp15hw6smyqirj";
    };

    propagatedBuildInputs = with self; [pygments];

    meta = {
      description = "Bringing the power of python to stream editing";
      homepage = https://github.com/timbertson/piep;
      maintainers = with maintainers; [ gfxmonk ];
      license = licenses.gpl3;
    };
  };

  pip = buildPythonPackage rec {
    version = "8.0.2";
    name = "pip-${version}";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pip/pip-${version}.tar.gz";
      sha256 = "46f4bd0d8dfd51125a554568d646fe4200a3c2c6c36b9f2d06d2212148439521";
    };

    # pip detects that we already have bootstrapped_pip "installed", so we need
    # to force it a little.
    installFlags = [ "--ignore-installed" ];

    buildInputs = with self; [ mock scripttest virtualenv pytest ];
  };


  pika = buildPythonPackage {
    name = "pika-0.9.12";
    disabled = isPy3k;
    src = pkgs.fetchurl {
      url = https://pypi.python.org/packages/source/p/pika/pika-0.9.12.tar.gz;
      sha256 = "670787ee6ade47cadd1ec8220876b9b7ae4df7bc4b9dd1d808261a6b47e9ce5d";
    };
    buildInputs = with self; [ nose mock pyyaml ];

    propagatedBuildInputs = with self; [ unittest2 ];
  };

  platformio =  buildPythonPackage rec {
    name = "platformio-${version}";
    version="2.8.3";

    disabled = isPy3k || isPyPy;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/platformio/platformio-${version}.tar.gz";
      sha256 = "1lz5f7xc53bk8ri4806xfpisvhyqdxdniwk0ywifinnhzx47jgp7";
     };

     propagatedBuildInputs = with self; [ click_5 requests2 bottle pyserial lockfile colorama];

     meta = with stdenv.lib; {
     description = "An open source ecosystem for IoT development";
     homepage = http://platformio.org;
     maintainers = with maintainers; [ mog ];
     license = licenses.asl20;
     };
  };

  pylibconfig2 = buildPythonPackage rec {
    name = "pylibconfig2-${version}";
    version = "0.2.4";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pylibconfig2/${name}.tar.gz";
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

  pymetar = buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "pymetar";
    version = "0.20";

    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/${pname}/${name}.tar.gz";
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
    version = "0.2.8";
    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pysftp/${name}.tar.gz";
      sha256 = "1d69z8yngciksch1i8rivy1xl8f6g6sb7c3kk5cm3pf8304q6hhm";
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


  py-sonic = buildPythonPackage rec {
    name = "py-sonic-${version}";
    version = "0.4.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/py-sonic/py-sonic-${version}.tar.gz";
      sha256 = "0wq4j56r6gnfhi9xjcn5jzyrg5ll41x0zg6xys7cw1v4fdsqd7hp";
    };

    patches = [ ../development/python-modules/py-sonic-ssl-security.patch ];

    meta = {
      description = "A python library to wrap the Subsonic REST API ";
      license = licenses.gpl3;
      maintainer = with maintainers; [ jgillich ];
    };
  };

  pysoundfile = buildPythonPackage rec {
    name = "pysoundfile-${version}";
    version = "0.8.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/P/PySoundFile/PySoundFile-${version}.tar.gz";
      sha256 = "72c3e23b7c9998460ec78176084ea101e3439596ab29df476bc8508708df84df";
    };

    buildInputs = with self; [ pytest ];
    propagatedBuildInputs = with self; [ numpy pkgs.libsndfile cffi ];

    meta = {
      description = "An audio library based on libsndfile, CFFI and NumPy";
      license = licenses.bsd3;
      homepage = https://github.com/bastibe/PySoundFile;
      maintainers = with maintainers; [ fridh ];
    };

    prePatch = ''
      substituteInPlace soundfile.py --replace "'sndfile'" "'${pkgs.libsndfile}/lib/libsndfile.so'"
    '';

    # https://github.com/bastibe/PySoundFile/issues/157
    disabled = isPyPy ||  stdenv.isi686;
  };

  python3pika = buildPythonPackage {
    name = "python3-pika-0.9.14";
    disabled = !isPy3k;

    # Unit tests adds dependencies on pyev, tornado and twisted (and twisted is disabled for Python 3)
    doCheck = false;

    src = pkgs.fetchurl {
      url = https://pypi.python.org/packages/source/p/python3-pika/python3-pika-0.9.14.tar.gz;
      md5 = "f3a3ee58afe0ae06f1fa553710e1aa28";
    };
    buildInputs = with self; [ nose mock pyyaml ];

    propagatedBuildInputs = with self; [ unittest2 ];
  };


  python-jenkins = buildPythonPackage rec {
    name = "python-jenkins-${version}";
    version = "0.4.11";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/python-jenkins/${name}.tar.gz";
      sha256 = "153gm7pmmn0bymglsgcr2ya0752r2v1hajkx73gl1pk4jifb2gdf";
    };
    patchPhase = ''
      sed -i 's@python@${python.interpreter}@' .testr.conf
    '';

    buildInputs = with self; [ mock ];
    propagatedBuildInputs = with self; [ pbr pyyaml six multi_key_dict testtools
     testscenarios testrepository ];

    meta = {
      description = "Python bindings for the remote Jenkins API";
      homepage = https://pypi.python.org/pypi/python-jenkins;
      license = licenses.bsd3;
    };
  };

  pillow = buildPythonPackage rec {
    name = "Pillow-2.9.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/P/Pillow/${name}.zip";
      sha256 = "1mal92cwh85z6zqx7lrmg0dbqb2gw2cbb2fm6xh0fivmszz8vnyi";
    };

    # Check is disabled because of assertion errors, see
    # https://github.com/python-pillow/Pillow/issues/1259
    doCheck = false;

    buildInputs = with self; [
      pkgs.freetype pkgs.libjpeg pkgs.zlib pkgs.libtiff pkgs.libwebp pkgs.tcl nose pkgs.lcms2 ]
      ++ optionals (isPyPy) [ pkgs.tk pkgs.xorg.libX11 ];

    # NOTE: we use LCMS_ROOT as WEBP root since there is not other setting for webp.
    preConfigure = ''
      sed -i "setup.py" \
          -e 's|^FREETYPE_ROOT =.*$|FREETYPE_ROOT = _lib_include("${pkgs.freetype}")|g ;
              s|^JPEG_ROOT =.*$|JPEG_ROOT = _lib_include("${pkgs.libjpeg}")|g ;
              s|^ZLIB_ROOT =.*$|ZLIB_ROOT = _lib_include("${pkgs.zlib}")|g ;
              s|^LCMS_ROOT =.*$|LCMS_ROOT = _lib_include("${pkgs.libwebp}")|g ;
              s|^TIFF_ROOT =.*$|TIFF_ROOT = _lib_include("${pkgs.libtiff}")|g ;
              s|^TCL_ROOT=.*$|TCL_ROOT = _lib_include("${pkgs.tcl}")|g ;'
    ''
    # Remove impurities
    + stdenv.lib.optionalString stdenv.isDarwin ''
      substituteInPlace setup.py \
        --replace '"/Library/Frameworks",' "" \
        --replace '"/System/Library/Frameworks"' ""
    '';

    meta = {
      homepage = "https://python-pillow.github.io/";

      description = "Fork of The Python Imaging Library (PIL)";

      longDescription = ''
        The Python Imaging Library (PIL) adds image processing
        capabilities to your Python interpreter.  This library
        supports many file formats, and provides powerful image
        processing and graphics capabilities.
      '';

      license = "http://www.pythonware.com/products/pil/license.htm";

      maintainers = with maintainers; [ goibhniu prikhi ];
    };
  };

  pkgconfig = buildPythonPackage rec {
    name = "pkgconfig-${version}";
    version = "1.1.0";

    # pypy: SyntaxError: __future__ statements must appear at beginning of file
    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pkgconfig/${name}.tar.gz";
      sha256 = "709daaf077aa2b33bedac12706373412c3683576a43013bbaa529fc2769d80df";
    };

    buildInputs = with self; [ nose ];

    propagatedBuildInputs = with self; [pkgs.pkgconfig];

    meta = {
      description = "Interface Python with pkg-config";
      homepage = http://github.com/matze/pkgconfig;
      license = licenses.mit;
    };

    # nosetests needs to be run explicitly.
    # Note that the distributed archive does not actually contain any tests.
    # https://github.com/matze/pkgconfig/issues/9
    checkPhase = ''
      nosetests
    '';

  };

  plumbum = buildPythonPackage rec {
    name = "plumbum-1.5.0";

    buildInputs = with self; [ self.six ];

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/plumbum/${name}.tar.gz";
      sha256 = "b759f9e3b6771dff3332f01bc0683d1a56218f44d97942dabd906a0cd1cfb756";
    };
  };


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


  powerline = buildPythonPackage rec {
    rev  = "2.1.4";
    name = "powerline-${rev}";
    src = pkgs.fetchurl {
      url    = "https://github.com/powerline/powerline/archive/${rev}.tar.gz";
      name   = "${name}.tar.gz";
      sha256 = "0gnh5yyackmqcphiympan48dm5lc834yzspss1lp4g1wq3vpyraf";
    };

    propagatedBuildInputs = with self; [ pkgs.git pkgs.mercurial pkgs.bazaar self.psutil self.pygit2 ];

    # error: This is still beta and some tests still fail
    doCheck = false;

    postInstall = ''
      install -dm755 "$out/share/fonts/OTF/"
      install -dm755 "$out/etc/fonts/conf.d"
      install -m644 "font/PowerlineSymbols.otf" "$out/share/fonts/OTF/PowerlineSymbols.otf"
      install -m644 "font/10-powerline-symbols.conf" "$out/etc/fonts/conf.d/10-powerline-symbols.conf"

      install -dm755 "$out/share/vim/vimfiles/plugin"
      install -m644 "powerline/bindings/vim/plugin/powerline.vim" "$out/share/vim/vimfiles/plugin/powerline.vim"

      install -dm755 "$out/share/zsh/site-contrib"
      install -m644 "powerline/bindings/zsh/powerline.zsh" "$out/share/zsh/site-contrib/powerline.zsh"

      install -dm755 "$out/share/tmux"
      install -m644 "powerline/bindings/tmux/powerline.conf" "$out/share/tmux/powerline.conf"
    '';

    meta = {
      homepage    = https://github.com/powerline/powerline;
      description = "The ultimate statusline/prompt utility";
      license     = licenses.mit;
      maintainers = with maintainers; [ lovek323 ];
      platforms   = platforms.all;
    };
  };



  praw = buildPythonPackage rec {
    name = "praw-3.3.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/praw/${name}.zip";
      sha256 = "17s8s4a1yk9rq21f3kmj9k4dbgvfa3650l8b39nhwybvxl3j5nfv";
    };

    propagatedBuildInputs = with self; [
      requests2
      decorator
      flake8
      mock
      six
      update_checker
    ];

    # can't find the tests module?
    doCheck = false;

    meta = {
      description = "Python Reddit API wrapper";
      homepage = http://praw.readthedocs.org/;
      license = licenses.gpl3;
      platforms = platforms.all;
      maintainers = with maintainers; [ jgeerds ];
    };
  };

  prettytable = buildPythonPackage rec {
    name = "prettytable-0.7.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/P/PrettyTable/${name}.tar.bz2";
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


  prompt_toolkit = buildPythonPackage rec {
    name = "prompt_toolkit-${version}";
    version = "0.46";

    src = pkgs.fetchurl {
      sha256 = "1yq9nis1b2rgpndi2rqh4divf6j22jjva83r5z8jf7iffywmr8hs";
      url = "https://pypi.python.org/packages/source/p/prompt_toolkit/${name}.tar.gz";
    };

    buildInputs = with self; [ jedi ipython pygments ];
    propagatedBuildInputs = with self; [ docopt six wcwidth ];

    meta = {
      description = "Python library for building powerful interactive command lines";
      longDescription = ''
        prompt_toolkit could be a replacement for readline, but it can be
        much more than that. It is cross-platform, everything that you build
        with it should run fine on both Unix and Windows systems. Also ships
        with a nice interactive Python shell (called ptpython) built on top.
      '';
      homepage = https://github.com/jonathanslenders/python-prompt-toolkit;
      license = licenses.bsd3;
      maintainers = with maintainers; [ nckx ];
    };
  };
  prompt_toolkit_52 = self.prompt_toolkit.override(self: rec {
    name = "prompt_toolkit-${version}";
    version = "0.52";
    src = pkgs.fetchurl {
      sha256 = "00h9ldqmb33nhg2kpks7paldf3n3023ipp124alwp96yz16s7f1m";
      url = "https://pypi.python.org/packages/source/p/prompt_toolkit/${name}.tar.gz";
    };

    #Only <3.4 expressly supported.
    disabled = isPy35;

  });

  protobuf = self.protobuf2_6;
  protobuf2_6 = self.protobufBuild pkgs.protobuf2_6;
  protobuf2_5 = self.protobufBuild pkgs.protobuf2_5;
  protobufBuild = protobuf: buildPythonPackage rec {
    inherit (protobuf) name src;
    disabled = isPy3k || isPyPy;

    propagatedBuildInputs = with self; [ protobuf google_apputils ];

    prePatch = ''
      while [ ! -d python ]; do
        cd *
      done
      cd python
    '';

    preConfigure = optionalString (versionAtLeast protobuf.version "2.6.0") ''
      PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=cpp
      PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION_VERSION=2
    '';

    checkPhase = if versionAtLeast protobuf.version "2.6.0" then ''
      ${python.executable} setup.py google_test --cpp_implementation
    '' else ''
      ${python.executable} setup.py test
    '';

    installFlags = optional (versionAtLeast protobuf.version "2.6.0") "--install-option='--cpp_implementation'";

    doCheck = true;

    meta = {
      description = "Protocol Buffers are Google's data interchange format";
      homepage = http://code.google.com/p/protobuf/;
    };

    passthru.protobuf = protobuf;
  };


  psutil = buildPythonPackage rec {
    name = "psutil-${version}";
    version = "3.4.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/psutil/${name}.tar.gz";
      sha256 = "b17fa01aa766daa388362d0eda5c215d77e03a8d37676b68971f37bf3913b725";
    };

    # Certain tests fail due to being in a chroot.
    # See also the older issue: https://code.google.com/p/psutil/issues/detail?id=434
    doCheck = false;

    checkPhase = ''
      ${python.interpreter} test/test_psutil.py
    '';

    # Test suite needs `free`, therefore we have pkgs.busybox
    buildInputs = with self; [ mock pkgs.busybox] ++ optionals stdenv.isDarwin [ pkgs.darwin.IOKit ];

    meta = {
      description = "Process and system utilization information interface for python";
      homepage = http://code.google.com/p/psutil/;
    };
  };

  psutil_1 = self.psutil.overrideDerivation (self: rec {
    name = "psutil-1.2.1";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/psutil/${name}.tar.gz";
      sha256 = "0ibclqy6a4qmkjhlk3g8jhpvnk0v9aywknc61xm3hfi5r124m3jh";
    };
  });

  psycopg2 = buildPythonPackage rec {
    name = "psycopg2-2.5.4";
    disabled = isPyPy;

    # error: invalid command 'test'
    doCheck = false;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/psycopg2/${name}.tar.gz";
      sha256 = "07ivzl7bq8bjcq5n90w4bsl29gjfm5l8yamw0paxh25si8r3zfi4";
    };

    buildInputs = optional stdenv.isDarwin pkgs.openssl;
    propagatedBuildInputs = with self; [ pkgs.postgresql ];

    meta = {
      description = "PostgreSQL database adapter for the Python programming language";
      license = with licenses; [ gpl2 zpt20 ];
    };
  };


  publicsuffix = buildPythonPackage rec {
    name = "publicsuffix-${version}";
    version = "1.0.2";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/publicsuffix/${name}.tar.gz";
      sha256 = "f6dfcb8a33fb3ac4f09e644cd26f8af6a09d1a45a019d105c8da58e289ca0096";
    };

    meta = {
      description = "Allows to get the public suffix of a domain name";
      homepage = "http://pypi.python.org/pypi/publicsuffix/";
      license = licenses.mit;
    };
  };


  py = buildPythonPackage rec {
    name = "py-${version}";
    version = "1.4.31";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/py/${name}.tar.gz";
      sha256 = "a6501963c725fc2554dabfece8ae9a8fb5e149c0ac0a42fd2b02c5c1c57fc114";
    };

    # Circular dependency on pytest
    doCheck = false;

    meta = {
      description = "Library with cross-python path, ini-parsing, io, code, log facilities";
      homepage = http://pylib.readthedocs.org/;
      license = licenses.mit;
    };
  };


  pyacoustid = buildPythonPackage rec {
    name = "pyacoustid-1.1.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pyacoustid/${name}.tar.gz";
      sha256 = "0117039cb116af245e6866e8e8bf3c9c8b2853ad087142bd0c2dfc0acc09d452";
    };

    propagatedBuildInputs = with self; [ requests2 audioread ];

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
    name = "pyalogotrade-0.16";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/P/PyAlgoTrade/PyAlgoTrade-0.16.tar.gz";
      sha256 = "a253617254194b91cfebae7bfd184cb109d4e48a8c70051b9560000a2c0f94b3";
    };

    propagatedBuildInputs = with self; [ numpy scipy pytz ];

    meta = {
      description = "Python Algorithmic Trading";
      homepage = http://gbeced.github.io/pyalgotrade/;
      license = licenses.asl20;
    };
  };


  pyasn1 = buildPythonPackage ({
    name = "pyasn1-0.1.8";

    src = pkgs.fetchurl {
      url = "mirror://sourceforge/pyasn1/0.1.8/pyasn1-0.1.8.tar.gz";
      sha256 = "0iw31d9l0zwx35szkzq72hiw002wnqrlrsi9dpbrfngcl1ybwcsx";
    };

    meta = {
      description = "ASN.1 tools for Python";
      homepage = http://pyasn1.sourceforge.net/;
      license = "mBSD";
      platforms = platforms.unix;  # arbitrary choice
    };
  });

  pyasn1-modules = buildPythonPackage rec {
    name = "pyasn1-modules-${version}";
    version = "0.0.5";
    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pyasn1-modules/${name}.tar.gz";
      sha256 = "0hcr6klrzmw4d9j9s5wrhqva5014735pg4zk3rppac4fs87g0rdy";
    };

    propagatedBuildInputs = with self; [ pyasn1 ];

    meta = {
      description = "A collection of ASN.1-based protocols modules";
      homepage = https://pypi.python.org/pypi/pyasn1-modules;
      license = licenses.bsd3;
      platforms = platforms.unix;  # same as pyasn1
    };
  };

  pyaudio = buildPythonPackage rec {
    name = "python-pyaudio-${version}";
    version = "0.2.9";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/P/PyAudio/PyAudio-${version}.tar.gz";
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
    version = "3.0.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pysaml2/${name}.tar.gz";
      sha256 = "1h2wvagvl59642jq0s63mfr01q637vq6526mr8riykrjnchcbbi2";
    };

    propagatedBuildInputs = with self; [
      repoze_who paste cryptography pycrypto pyopenssl ipaddress six cffi idna
      enum34 pytz setuptools zope_interface dateutil requests2 pyasn1 webob decorator pycparser
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
      url = "https://pypi.python.org/packages/source/m/mongodict/${name}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/r/repoze.who/${name}.tar.gz";
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
    version = "0.8.1d";
    name = "vobject-${version}";

    src = pkgs.fetchFromGitHub {
      owner = "adieu";
      repo = "vobject";
      sha256 = "04fz8g9i9pvrksbpzmp2ci8z34gwjdr7j0f0cxr60v5sdv6v88l9";
      rev = "ef870dfbb7642756d6b691ebf9f52285ec9e504f";
    };

    disabled = isPy3k || isPyPy;

    propagatedBuildInputs = with self; [ dateutil ];

    patchPhase = ''
      # fails due to hash randomization
      sed -i 's/RRULE:FREQ=MONTHLY;BYMONTHDAY=-1,-5/RRULE:FREQ=MONTHLY;BYMONTHDAY=.../' test_vobject.py
    '';

    meta = {
      description = "Module for reading vCard and vCalendar files";
      homepage = https://github.com/adieu/vobject/;
      license = licenses.asl20;
      maintainers = with maintainers; [ DamienCassou ];
    };
  };

  pycarddav = buildPythonPackage rec {
    version = "0.7.0";
    name = "pycarddav-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pyCardDAV/pyCardDAV-${version}.tar.gz";
      sha256 = "0avkrcpisfvhz103v7vmq2jd83hvmpqrb4mlbx6ikkk1wcvclsx8";
    };

    disabled = isPy3k || isPyPy;

    propagatedBuildInputs = with self; [ sqlite3 vobject lxml requests urwid pyxdg ];

    meta = {
      description = "Command-line interface carddav client";
      homepage = http://lostpackets.de/pycarddav;
      license = licenses.mit;
      maintainers = with maintainers; [ DamienCassou ];
    };
  };

  pycosat = buildPythonPackage rec {
    name = "pycosat-0.6.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pycosat/${name}.tar.gz";
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

  pygit2 = buildPythonPackage rec {
    name = "pygit2-0.23.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pygit2/${name}.tar.gz";
      sha256 = "04201vcal7jq8lbpk9ylscrhjxdcf2aihiw25k4imjjqgfmvldf7";
    };

    preConfigure = ( if stdenv.isDarwin then ''
      export DYLD_LIBRARY_PATH="${pkgs.libgit2}/lib"
    '' else "" );

    propagatedBuildInputs = with self; [ pkgs.libgit2 ] ++ optionals (!isPyPy) [ cffi ];

    preCheck = ''
      # disable tests that require networking
      rm test/test_repository.py
      rm test/test_credentials.py
    '';

    meta = {
      homepage = https://pypi.python.org/pypi/pygit2;
      description = "A set of Python bindings to the libgit2 shared library";
      license = licenses.gpl2;
      platforms = platforms.all;
    };
  };


  Babel = buildPythonPackage (rec {
    name = "Babel-2.2.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/B/Babel/${name}.tar.gz";
      sha256 = "d8cb4c0e78148aee89560f9fe21587aa57739c975bb89ff66b1e842cc697428f";
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

  pybfd = buildPythonPackage rec {
    name = "pybfd-0.1.1";

    disabled = isPyPy || isPy3k;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pybfd/${name}.tar.gz";
      sha256 = "d99b32ad077e704ddddc0b488c83cae851c14919e5cbc51715d00464a1932df4";
    };

    preConfigure = ''
      substituteInPlace setup.py \
        --replace '"/usr/include"' '"${pkgs.gdb}/include"' \
        --replace '"/usr/lib"' '"${pkgs.binutils}/lib"'
    '';

    meta = {
      homepage = https://github.com/Groundworkstech/pybfd;
      description = "A Python interface to the GNU Binary File Descriptor (BFD) library";
      license = licenses.gpl2;
      platforms = platforms.linux;
    };
  };

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
      url = "https://pypi.python.org/packages/source/p/py-bcrypt/py-bcrypt-${version}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/p/pycapnp/${name}.tar.gz";
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
    name = "pycdio-0.20";
    disabled = !isPy27;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pycdio/${name}.tar.gz";
      sha256 = "1mrh233pj584gf7la64d4xlmvdnfl4jwpxs95lnd3i4zd5drid14";
    };

    prePatch = ''
      sed -i -e "s|if type(driver_id)==int|if type(driver_id) in (int, long)|g" cdio.py
    '';

    preConfigure = ''
      patchShebangs .
    '';

    buildInputs = [
      self.setuptools self.nose pkgs.pkgconfig pkgs.swig pkgs.libcdio
    ];

    patches = [ ../development/python-modules/pycdio/add-cdtext-toc.patch ];

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
      url = "http://pypi.python.org/packages/source/p/pycryptopp/${name}.tar.gz";
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
    name = "pycurl-7.19.5";
    disabled = isPyPy; # https://github.com/pycurl/pycurl/issues/208

    src = pkgs.fetchurl {
      url = "http://pycurl.sourceforge.net/download/${name}.tar.gz";
      sha256 = "0hqsap82zklhi5fxhc69kxrwzb0g9566f7sdpz7f9gyxkmyam839";
    };

    propagatedBuildInputs = with self; [ pkgs.curlOpenssl pkgs.openssl_1_0_1 ];

    # error: invalid command 'test'
    doCheck = false;

    preConfigure = ''
      substituteInPlace setup.py --replace '--static-libs' '--libs'
      export PYCURL_SSL_LIBRARY=openssl
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
      sha256 = "0mhg7f9y5zl0m2xgz3rf1yqjd6l8n0qhfk7bpf36r44jfnhj75ld";
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


  pydot = buildPythonPackage rec {
    name = "pydot-1.0.2";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pydot/${name}.tar.gz";
      sha256 = "80ea01a7ba75671a3b7890375be0ad8d5321b07bfb6f572192c31409062b59f3";
    };
    propagatedBuildInputs = with self; [pyparsing pkgs.graphviz];
    meta = {
      homepage = http://code.google.com/p/pydot/;
      description = "Allows to easily create both directed and non directed graphs from Python";
    };
  };

  pyelasticsearch = buildPythonPackage (rec {
    name = "pyelasticsearch-1.4";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pyelasticsearch/${name}.tar.gz";
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
    version = "0.23";
    name = "${pname}-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/${pname}/${name}.tar.gz";
      sha256 = "1pi1mdzfffgl5qcz0prsa7hlbriycy7mgagi0fdrp3vf17fslmzw";
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
      url = "https://pypi.python.org/packages/source/p/pyenchant/pyenchant-1.6.6.tar.gz";
      sha256 = "25c9d2667d512f8fc4410465fdd2e868377ca07eb3d56e2b6e534a86281d64d3";
    };

    propagatedBuildInputs = [ pkgs.enchant ];

    patchPhase = let
      path_hack_script = "s|LoadLibrary(e_path)|LoadLibrary('${pkgs.enchant}/lib/' + e_path)|";
    in ''
      sed -i "${path_hack_script}" enchant/_enchant.py
    '';

    # dictionaries needed for tests
    doCheck = false;

    meta = {
      description = "pyenchant: Python bindings for the Enchant spellchecker";
      homepage = https://pythonhosted.org/pyenchant/;
      license = licenses.lgpl21;
    };
  };


  pyev = buildPythonPackage rec {
    name = "pyev-0.9.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pyev/${name}.tar.gz";
      sha256 = "0rf603lc0s6zpa1nb25vhd8g4y337wg2wyz56i0agsdh7jchl0sx";
    };

    buildInputs = [ pkgs.libev ];

    postPatch = ''
      libev_so=${pkgs.libev}/lib/libev.so.4
      test -f "$libev_so" || { echo "ERROR: File $libev_so does not exist, please fix nix expression for pyev"; exit 1; }
      sed -i -e "s|libev_dll_name = find_library(\"ev\")|libev_dll_name = \"$libev_so\"|" setup.py
    '';

    meta = {
      description = "Python bindings for libev";
      homepage = https://code.google.com/p/pyev/;
      license = licenses.gpl3;
      maintainers = [ maintainers.bjornfor ];
    };
  };


  pyfeed = buildPythonPackage rec {
    url = "http://www.blarg.net/%7Esteveha/pyfeed-0.7.4.tar.gz";
    name = stdenv.lib.nameFromURL url ".tar";
    src = pkgs.fetchurl {
      inherit url;
      sha256 = "1h4msq573m7wm46h3cqlx4rsn99f0l11rhdqgf50lv17j8a8vvy1";
    };
    propagatedBuildInputs = with self; [xe];

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = "http://home.blarg.net/~steveha/pyfeed.html";
      description = "Tools for syndication feeds";
    };
  };

  pyfftw = buildPythonPackage rec {
    name = "pyfftw-${version}";
    version = "0.9.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pyFFTW/pyFFTW-${version}.tar.gz";
      sha256 = "f6bbb6afa93085409ab24885a1a3cdb8909f095a142f4d49e346f2bd1b789074";
    };

    buildInputs = [ pkgs.fftw pkgs.fftwFloat pkgs.fftwLongDouble];

    propagatedBuildInputs = with self; [ numpy scipy ];

    # Tests cannot import pyfftw. pyfftw works fine though.
    doCheck = false;

    preConfigure = ''
      export LDFLAGS="-L${pkgs.fftw}/lib -L${pkgs.fftwFloat}/lib -L${pkgs.fftwLongDouble}/lib"
      export CFLAGS="-I${pkgs.fftw}/include -I${pkgs.fftwFloat}/include -I${pkgs.fftwLongDouble}/include"
    '';
    #+ optionalString isDarwin ''
    #  export DYLD_LIBRARY_PATH="${pkgs.fftw}/lib"
    #'';

    meta = {
      description = "A pythonic wrapper around FFTW, the FFT library, presenting a unified interface for all the supported transforms";
      homepage = http://hgomersall.github.com/pyFFTW/;
      license = with licenses; [ bsd2 bsd3 ];
      maintainers = with maintainers; [ fridh ];
    };
  };

  pyfiglet = buildPythonPackage rec {
    name = "pyfiglet-${version}";
    version = "0.7.2";

    src = pkgs.fetchurl {
      url    = "https://pypi.python.org/packages/source/p/pyfiglet/${name}.tar.gz";
      sha256 = "0v8a18wvaqnb1jksyv5dc5n6zj0vrkyhz0ivmm8gfwpa0ky6n68y";
    };

    doCheck = false;

    meta = {
      description = "FIGlet in pure Python";
      license     = licenses.gpl2Plus;
      maintainers = with maintainers; [ thoughtpolice ];
    };
  };

  pyflakes = buildPythonPackage rec {
    name = "pyflakes-${version}";
    version = "1.0.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyflakes/${name}.tar.gz";
      sha256 = "f39e33a4c03beead8774f005bd3ecf0c3f2f264fa0201de965fce0aff1d34263";
    };

    buildInputs = with self; [ unittest2 ];

    doCheck = !isPyPy;

    meta = {
      homepage = https://launchpad.net/pyflakes;
      description = "A simple program which checks Python source files for errors";
      license = licenses.mit;
      maintainers = with maintainers; [ garbas ];
    };
  };

  pygeoip = buildPythonPackage rec {
    name = "pygeoip-0.3.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pygeoip/pygeoip-0.3.2.tar.gz";
      sha256 = "f22c4e00ddf1213e0fae36dc60b46ee7c25a6339941ec1a975539014c1f9a96d";
    };

    # requires geoip samples
    doCheck = false;

    buildInputs = with self; [ nose ];

    meta = {
      description = "Pure Python GeoIP API";
      homepage = https://github.com/appliedsec/pygeoip;
      license = licenses.lgpl3Plus;
    };
  };

  pyglet = buildPythonPackage rec {
    name = "pyglet-${version}";
    version = "1.2.4";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pyglet/pyglet-${version}.tar.gz";
      sha256 = "9f62ffbbcf2b202d084bf158685e77d28b8f4f5f2738f4c5e63a947a07503445";
    };

    patchPhase = let
      libs = [ pkgs.mesa pkgs.xorg.libX11 pkgs.freetype pkgs.fontconfig ];
      paths = concatStringsSep "," (map (l: "\"${l}/lib\"") libs);
    in "sed -i -e 's|directories\.extend.*lib[^]]*|&,${paths}|' pyglet/lib.py";

    doCheck = false;

    meta = {
      homepage = "http://www.pyglet.org/";
      description = "A cross-platform windowing and multimedia library";
      license = licenses.bsd3;
      platforms = platforms.mesaPlatforms;
    };
  };

  pygments = buildPythonPackage rec {
    version = "2.1";
    name = "Pygments-${version}";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/P/Pygments/${name}.tar.gz";
      sha256 = "0yx4p3w9lw1kw24zr87xnaqxm007mdxgwa5wjpwnrcfpmxgyz80k";
    };

    propagatedBuildInputs = with self; [ docutils ];

    # Circular dependency with sphinx
    doCheck = false;

    meta = {
      homepage = http://pygments.org/;
      description = "A generic syntax highlighter";
      license = licenses.bsd2;
      maintainers = with maintainers; [ nckx garbas ];
    };
  };

  # For Pelican 3.6.3
  pygments_2_0 = self.pygments.override rec {
    version = "2.0.2";
    name = "Pygments-${version}";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/P/Pygments/${name}.tar.gz";
      sha256 = "7320919084e6dac8f4540638a46447a3bd730fca172afc17d2c03eed22cf4f51";
    };
  };

  pygpgme = buildPythonPackage rec {
    version = "0.3";
    name = "pygpgme-${version}";
    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "https://launchpad.net/pygpgme/trunk/${version}/+download/${name}.tar.gz";
      sha256 = "5fd887c407015296a8fd3f4b867fe0fcca3179de97ccde90449853a3dfb802e1";
    };

    # error: invalid command 'test'
    doCheck = false;

    propagatedBuildInputs = with self; [ pkgs.gpgme ];

    meta = {
      homepage = "https://launchpad.net/pygpgme";
      description = "A Python wrapper for the GPGME library";
      license = licenses.lgpl21;
      maintainers = with maintainers; [ garbas ];
    };
  };

  pylint = buildPythonPackage rec {
    name = "pylint-${version}";
    version = "1.5.4";

    src = pkgs.fetchurl {
        url = "https://pypi.python.org/packages/source/p/pylint/${name}.tar.gz";
        sha256 = "2fe3cc2fc66a56fdc35dbbc2bf1dd96a534abfc79ee6b2ad9ae4fe166e570c4b";
    };

    propagatedBuildInputs = with self; [ astroid ];

    checkPhase = ''
        cd pylint/test; ${python.interpreter} -m unittest discover -p "*test*"
    '';

    postInstall = ''
        mkdir -p $out/share/emacs/site-lisp
        cp "elisp/"*.el $out/share/emacs/site-lisp/
    '';

    meta = {
        homepage = http://www.logilab.org/project/pylint;
        description = "A bug and style checker for Python";
    };
  };

  pyrr = buildPythonPackage rec {
    name = "pyrr-${version}";
    version = "0.7.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pyrr/pyrr-${version}.tar.gz";
      sha256 = "04a65a9fb5c746b41209f55b21abf47a0ef80a4271159d670ca9579d9be3b4fa";
    };

    buildInputs = with self; [ setuptools ];
    propagatedBuildInputs = with self; [ multipledispatch numpy ];

    meta = {
      description = "3D mathematical functions using NumPy";
      homepage = https://github.com/adamlwgriffiths/Pyrr/;
      license = licenses.bsd2;
    };
  };

  pyshp = buildPythonPackage rec {
    name = "pyshp-${version}";
    version = "1.2.3";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pyshp/pyshp-${version}.tar.gz";
      sha256 = "e18cc19659dadc5ddaa891eb780a6958094da0cf105a1efe0f67e75b4fa1cdf9";
    };

    buildInputs = with self; [ setuptools ];

    meta = {
      description = "Pure Python read/write support for ESRI Shapefile format";
      homepage = https://github.com/GeospatialPython/pyshp;
      license = licenses.mit;
    };
  };

  pyx = buildPythonPackage rec {
    name = "pyx-${version}";
    version = "0.14.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/P/PyX/PyX-${version}.tar.gz";
      sha256 = "05d1b7fc813379d2c12fcb5bd0195cab522b5aabafac88f72913f1d47becd912";
    };

    disabled = !isPy3k;

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
      homepage = http://sourceforge.net/projects/mmpython/;
      license = licenses.gpl2;
      maintainers = with maintainers; [ DamienCassou ];
    };
  };

  kaa-base = buildPythonPackage rec {
    version = "0.99.2dev-384-2b73caca";
    name = "kaa-base-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/k/kaa-base/kaa-base-0.99.2dev-384-2b73caca.tar.gz";
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
      maintainers = with maintainers; [ DamienCassou ];
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
      url = "https://pypi.python.org/packages/source/k/kaa-metadata/kaa-metadata-0.7.8dev-r4569-20111003.tar.gz";
      sha256 = "0bkbzfgxvmby8lvzkqjp86anxvv3vjd9nksv2g4l7shsk1n7y27a";
    };

    propagatedBuildInputs = with self; [ kaa-base ];

    meta = {
      description = "Python library for parsing media metadata, which can extract metadata (e.g., such as id3 tags) from a wide range of media files";
      homepage = https://github.com/freevo/kaa-metadata;
      license = licenses.gpl2;
      maintainers = with maintainers; [ DamienCassou ];
    };
  };

  pyinotify = buildPythonPackage rec {
    name = "pyinotify";
    version = "0.9.6";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/${name}/${name}-${version}.tar.gz";
      sha256 = "1x3i9wmzw33fpkis203alygfnrkcmq9w1aydcm887jh6frfqm6cw";
    };

    meta = {
      homepage = https://github.com/seb-m/pyinotify/wiki;
      description = "Monitor filesystems events on Linux platforms with inotify";
      license = licenses.mit;
      platforms = platforms.linux;
    };
  };

  pyjwt = buildPythonPackage rec {
    version = "1.4.0";
    name = "pyjwt-${version}";

    src = pkgs.fetchurl {
      url = "http://github.com/progrium/pyjwt/archive/${version}.tar.gz";
      sha256 = "118rzhpyvx1h4hslms4fdizyv6mnyd4g34fv089lvs116pj08k9c";
    };

    propagatedBuildInputs = with self; [ pycrypto ecdsa ];

    meta = {
      description = "JSON Web Token implementation in Python";
      longDescription = "A Python implementation of JSON Web Token draft 01";
      homepage = https://github.com/progrium/pyjwt;
      downloadPage = https://github.com/progrium/pyjwt/releases;
      license = licenses.mit;
      maintainers = with maintainers; [ prikhi ];
      platforms = platforms.linux;
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


  pyodbc = buildPythonPackage rec {
    name = "pyodbc-3.0.7";
    disabled = isPyPy;  # use pypypdbc instead

    src = pkgs.fetchurl {
      url = "https://pyodbc.googlecode.com/files/${name}.zip";
      sha256 = "0ldkm8xws91j7zbvpqb413hvdz8r66bslr451q3qc0xi8cnmydfq";
    };

    buildInputs = with self; [ pkgs.libiodbc ];

    meta = {
      description = "Python ODBC module to connect to almost any database";
      homepage = https://code.google.com/p/pyodbc/;
      license = licenses.mit;
      platforms = platforms.linux;
      maintainers = with maintainers; [ bjornfor ];
    };
  };


  pyparsing = buildPythonPackage rec {
    name = "pyparsing-2.0.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyparsing/${name}.tar.gz";
      sha256 = "1r742rjbagf2i166k2w0r192adfw7l9lnsqz7wh4mflf00zws1q0";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://pyparsing.wikispaces.com/;
      description = "An alternative approach to creating and executing simple grammars, vs. the traditional lex/yacc approach, or the use of regular expressions";
    };
  };

  pyparsing1 = buildPythonPackage rec {
    name = "pyparsing-1.5.7";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyparsing/${name}.tar.gz";
      sha256 = "646e14f90b3689b005c19ac9b6b390c9a39bf976481849993e277d7380e6e79f";
    };

    meta = {
      homepage = http://pyparsing.wikispaces.com/;
      description = "An alternative approach to creating and executing simple grammars, vs. the traditional lex/yacc approach, or the use of regular expressions";
    };
  };


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

    buildInputs = with self; [ pkgs.pkgconfig ];

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
      url = "https://pypi.python.org/packages/source/p/pyptlib/pyptlib-${version}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/p/pyqtgraph/${name}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/p/pystache/${name}.tar.gz";
      sha256 = "f7bbc265fb957b4d6c7c042b336563179444ab313fb93a719759111eabd3b85a";
    };

    LC_ALL = "en_US.UTF-8";

    buildInputs = [ pkgs.glibcLocales ];

    checkPhase = ''
      ${python.interpreter} -m unittest discover
    '';

    # SyntaxError Python 3
    # https://github.com/defunkt/pystache/issues/181
    disabled = isPy3k;

    meta = {
      description = "A framework-agnostic, logic-free templating system inspired by ctemplate and et";
      homepage = https://github.com/defunkt/pystache;
      license = licenses.mit;
    };
  };

  PyStemmer = buildPythonPackage (rec {
    name = "PyStemmer-1.3.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/P/PyStemmer/${name}.tar.gz";
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

  pyro3 = buildPythonPackage (rec {
    name = "Pyro-3.16";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/P/Pyro/${name}.tar.gz";
      sha256 = "1bed508453ef7a7556b51424a58101af2349b662baab7e7331c5cb85dbe7e578";
    };

    meta = {
      description = "Distributed object middleware for Python (IPC/RPC)";
      homepage = http://pythonhosted.org/Pyro/;
      license = licenses.mit;
      platforms = platforms.unix;
      maintainers = with maintainers; [ bjornfor ];
    };
  });

  pyrsistent = buildPythonPackage (rec {
    name = "pyrsistent-0.11.12";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyrsistent/${name}.tar.gz";
      sha256 = "0jgyhkkq36wn36rymn4jiyqh2vdslmradq4a2mjkxfbk2cz6wpi5";
    };

    buildInputs = with self; [ six pytest hypothesis1 ] ++ optional (!isPy3k) modules.sqlite3;

    checkPhase = ''
      py.test
    '';

    meta = {
      homepage = http://github.com/tobgu/pyrsistent/;
      description = "Persistent/Functional/Immutable data structures";
      license = licenses.mit;
      maintainers = with maintainers; [ desiderius ];
    };
  });

  pyrss2gen = buildPythonPackage (rec {
    name = "PyRSS2Gen-1.0.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/P/PyRSS2Gen/${name}.tar.gz";
      sha256 = "4929d022713129401160fd47550d5158931e4ea6a7136b5d8dfe3b13ac16f2f0";
    };

    meta = {
      homepage = http://www.dalkescientific.om/Python/PyRSS2Gen.html;
      description = "Library for generating RSS 2.0 feeds";
      license = licenses.bsd2;
      maintainers = with maintainers; [ iElectric ];
    };
  });

  pysnmp = buildPythonPackage rec {
    version = "4.2.5";
    name = "pysnmp-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pysnmp/${name}.tar.gz";
      sha256 = "0zq7yx8732ad9dxpxqgpqyixj7kfwbvf402q7l5njkv0kbcnavn4";
    };

    propagatedBuildInputs = with self; [ pyasn1 pycrypto ];

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
    version = "1.5.0";

    src = pkgs.fetchurl {
      url    = "https://pypi.python.org/packages/source/P/PySocks/PySocks-${version}.tar.gz";
      sha256 = "10wq5311qrnk8rvzsh6gwzxi7h51pgvzw3d7s1mb39fsvf0vyjdk";
    };

    doCheck = false;

    meta = {
      description = "SOCKS module for Python";
      license     = licenses.bsd3;
      maintainers = with maintainers; [ thoughtpolice ];
    };
  };

  python_fedora = buildPythonPackage (rec {
    version = "0.5.5";
    name = "python-fedora-${version}";
    meta.maintainers = with maintainers; [ mornfall ];

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/python-fedora/${name}.tar.gz";
      sha256 = "15m8lvbb5q4rg508i4ah8my872qrq5xjwgcgca4d3kzjv2x6fhim";
    };
    propagatedBuildInputs = with self; [ kitchen requests bunch paver six munch urllib3
      beautifulsoup4 ];
    doCheck = false;

    # https://github.com/fedora-infra/python-fedora/issues/140
    preBuild = ''
      sed -i '4,15d' setup.py
    '';
  });

  python_simple_hipchat = buildPythonPackage rec {
    name = "python-simple-hipchat-${version}";
    version = "0.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/python-simple-hipchat/python-simple-hipchat-${version}.zip";
      sha256 = "404e5ff7187abb09c2227f22063d06baf0fd525725e9c9ad280176bed1c94a3f";
    };

    buildInputs = [ pkgs.unzip ];
  };

  python_keyczar = buildPythonPackage rec {
    name = "python-keyczar-0.71c";

    src = pkgs.fetchurl {
      url    = "https://pypi.python.org/packages/source/p/python-keyczar/${name}.tar.gz";
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

  pyudev = buildPythonPackage rec {
    name = "pyudev-${version}";
    version = "0.16.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pyudev/${name}.tar.gz";
      sha256 = "765d1c14bd9bd031f64e2612225621984cb2bbb8cbc0c03538bcc4c735ff1c95";
    };

    postPatch = ''
      sed -i -e '/udev_library_name/,/^ *libudev/ {
        s|CDLL([^,]*|CDLL("${pkgs.udev}/lib/libudev.so.1"|p; d
      }' pyudev/_libudev.py
    '';

    propagatedBuildInputs = with self; [ pkgs.udev ];

    meta = {
      homepage = "http://pyudev.readthedocs.org/";
      description = "Pure Python libudev binding";
      license = licenses.lgpl21Plus;
      platforms = platforms.linux;
    };
  };


  pynzb = buildPythonPackage (rec {
    name = "pynzb-0.1.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pynzb/${name}.tar.gz";
      sha256 = "0735b3889a1174bbb65418ee503629d3f5e4a63f04b16f46ffba18253ec3ef17";
    };

    meta = {
      homepage = http://github.com/ericflo/pynzb;
      description = "Unified API for parsing NZB files";
      license = licenses.bsd3;
      maintainers = with maintainers; [ iElectric ];
    };
  });

  progressbar = buildPythonPackage (rec {
    name = "progressbar-2.2";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/progressbar/${name}.tar.gz";
      sha256 = "dfee5201237ca0e942baa4d451fee8bf8a54065a337fabe7378b8585aeda56a3";
    };

    # invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://code.google.com/p/python-progressbar/;
      description = "Text progressbar library for python";
      license = licenses.lgpl3Plus;
      maintainers = with maintainers; [ iElectric ];
    };
  });

  ldap = buildPythonPackage rec {
    name = "ldap-2.4.19";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/python-ldap/python-${name}.tar.gz";
      sha256 = "0j5hzaar4d0vhnrlpmkczgwm7ci2wibr99a7zx04xddzrhxdpz82";
    };

    NIX_CFLAGS_COMPILE = "-I${pkgs.cyrus_sasl}/include/sasl";
    propagatedBuildInputs = with self; [pkgs.openldap pkgs.cyrus_sasl pkgs.openssl];
  };

  ldap3 = buildPythonPackage rec {
    version = "1.0.4";
    name = "ldap3-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/l/ldap3/${name}.tar.gz";
      sha256 = "0j4qqj9vq022hy7wfqn8s0j4vm2g6paabbzas1vbyspawvcfai98";
    };

    buildInputs = with self; [ gssapi ];

    propagatedBuildInputs = with self; [ pyasn1 ];

    meta = {
      homepage = https://pypi.python.org/pypi/ldap3;
      description = "A strictly RFC 4510 conforming LDAP V3 pure Python client library";
      license = licenses.lgpl3;
    };
  };

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
      url = "https://pypi.python.org/packages/source/p/ptyprocess/${name}.tar.gz";
      sha256= "dcb78fb2197b49ca1b7b2f37b047bc89c0da7a90f90bd5bc17c3ce388bb6ef59";
    };

    meta = {
      description = "Run a subprocess in a pseudo terminal";
      homepage = https://github.com/pexpect/ptyprocess;
      license = licenses.isc;
    };
  };

  pylibacl = buildPythonPackage (rec {
    name = "pylibacl-0.5.1";

    src = pkgs.fetchurl {
      url = "https://github.com/downloads/iustin/pylibacl/${name}.tar.gz";
      sha256 = "1idks7j9bn62xzsaxkvhl7bdq6ws8kv8aa0wahfh7724qlbbcf1k";
    };

    # ERROR: testExtended (tests.test_acls.AclExtensions)
    # IOError: [Errno 0] Error
    doCheck = false;

    buildInputs = with self; [ pkgs.acl ];

    meta = {
      description = "A Python extension module for POSIX ACLs, it can be used to query, list, add, and remove ACLs from files and directories under operating systems that support them";
      license = licenses.lgpl21Plus;
    };
  });

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

  pymacs = buildPythonPackage rec {
    version = "0.25";
    name = "pymacs-${version}";
    disabled = isPy3k || isPyPy;

    src = pkgs.fetchurl {
      url = "https://github.com/pinard/Pymacs/tarball/v${version}";
      name = "${name}.tar.gz";
      sha256 = "1hmy76c5igm95rqbld7gvk0az24smvc8hplfwx2f5rhn6frj3p2i";
    };

    configurePhase = "make";

    doCheck = false;

    meta = {
      description = "Emacs Lisp to Python interface";
      homepage = http://pymacs.progiciels-bpi.ca;
      license = licenses.gpl2;
      maintainers = with maintainers; [ goibhniu ];
    };
  };

  pyPdf = buildPythonPackage rec {
    name = "pyPdf-1.13";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pyPdf/${name}.tar.gz";
      sha256 = "3aede4c3c9c6ad07c98f059f90db0b09ed383f7c791c46100f649e1cabda0e3b";
    };

    buildInputs = with self; [ ];

    meta = {
      description = "Pure-Python PDF toolkit";
      homepage = "http://pybrary.net/pyPdf/";
      license = licenses.bsd3;
    };
  };

  pypdf2 = buildPythonPackage rec {
    name = "PyPDF2-${version}";
    version = "1.25.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/P/PyPDF2/${name}.tar.gz";
      sha256 = "1sw225j9fgsvg1zm7lrij96fihfmq8pc1vg611dc55491zvj9ls3";
    };

    LC_ALL = "en_US.UTF-8";
    buildInputs = [ pkgs.glibcLocales ];

    meta = {
      broken = true; # 2 tests, both fail
      description = "A Pure-Python library built as a PDF toolkit";
      homepage = "http://mstamy2.github.com/PyPDF2/";
      license = licenses.bsd3;
      maintainers = with maintainers; [ desiderius ];
    };
  };

  pyopengl = buildPythonPackage rec {
    name = "pyopengl-${version}";
    version = "3.1.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/P/PyOpenGL/PyOpenGL-${version}.tar.gz";
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
    name = "pyopenssl-${version}";
    version = "0.15.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pyOpenSSL/pyOpenSSL-${version}.tar.gz";
      sha256 = "0wnnq15rhj7fhdcd8ycwiw6r6g3w9f9lcy6cigg8226vsrq618ph";
    };

    # 12 tests failing, 26 error out
    doCheck = false;

    propagatedBuildInputs = [ self.cryptography self.pyasn1 self.idna ];
  };


  pyquery = buildPythonPackage rec {
    name = "pyquery-${version}";
    version = "1.2.9";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyquery/${name}.zip";
      sha256 = "00p6f1dfma65192hc72dxd506491lsq3g5wgxqafi1xpg2w1xia6";
    };

    propagatedBuildInputs = with self; [ cssselect lxml webob ];
    # circular dependency on webtest
    doCheck = false;
  };


  pyrax = buildPythonPackage rec {
    name = "pyrax-1.8.2";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyrax/${name}.tar.gz";
      sha256 = "0hvim60bhgfj91m7pp8jfmb49f087xqlgkqa505zw28r7yl0hcfp";
    };

    propagatedBuildInputs = with self; [ requests2 ];
    doCheck = false;

    meta = {
      broken = true;  # missing lots of dependencies with rackspace-novaclient
      homepage    = "https://github.com/rackspace/pyrax";
      license     = licenses.mit;
      description = "Python API to interface with Rackspace";
    };
  };


  pyreport = buildPythonPackage (rec {
    name = "pyreport-0.3.4c";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyreport/${name}.tar.gz";
      sha256 = "1584607596b7b310bf0b6ce79f424bd44238a017fd870aede11cd6732dbe0d4d";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://pypi.python.org/pypi/pyreport;
      license = "BSD";
      description = "Pyreport makes notes out of a python script";
    };
  });

  pyscss = buildPythonPackage rec {
    name = "pyScss-${version}";
    version = "1.3.4";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pyScss/${name}.tar.gz";
      sha256 = "03lcp853kgr66aqrw2jd1q9jhs9h049w7zlwp7bfmly7xh832cnh";
    };

    propagatedBuildInputs = with self; [ six ]
      ++ (optionals (pythonOlder "3.4") [ enum34 pathlib ])
      ++ (optionals (pythonOlder "2.7") [ ordereddict ]);

    meta = {
      description = "A Scss compiler for Python";
      homepage = http://pyscss.readthedocs.org/en/latest/;
      license = licenses.mit;
    };
  };

  pyserial = buildPythonPackage rec {
    name = "pyserial-2.7";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyserial/${name}.tar.gz";
      sha256 = "3542ec0838793e61d6224e27ff05e8ce4ba5a5c5cc4ec5c6a3e8d49247985477";
    };

    doCheck = false;

    meta = {
      homepage = "http://pyserial.sourceforge.net/";
      license = licenses.psfl;
      description = "Python serial port extension";
    };
  };

  pymongo = buildPythonPackage rec {
    name = "pymongo-3.0.3";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pymongo/${name}.tar.gz";
      sha256 = "3c6b2317f8031bc1e200fd1ea35f00a96f4569e3f3f220a5e66ab6227d96ccaf";
    };

    doCheck = false;

    meta = {
      homepage = "http://github.com/mongodb/mongo-python-driver";
      license = licenses.asl20;
      description = "Python driver for MongoDB ";
    };
  };

  pymongo_2_9_1 = buildPythonPackage rec {
    name = "pymongo-2.9.1";
    version = "2.9.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pymongo/${name}.tar.gz";
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
    version = "1.5.11";
    name = "pyperclip-${version}";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyperclip/${name}.zip";
      sha256 = "07q8krmi7phizzp192x3j7xbk1gzhc1kc3jp4mxrm32dn84sp1vh";
    };

    doCheck = false;

    meta = {
      homepage = "https://github.com/asweigart/pyperclip";
      license = licenses.bsdOriginal;
      description = "cross-platform clipboard module";
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

  pysqlite = buildPythonPackage (rec {
    name = "pysqlite-2.6.3";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pysqlite/${name}.tar.gz";
      sha256 = "13djzgnbi71znjjyaw4nybg6smilgszcid646j5qav7mdchkb77y";
    };

    # Since the `.egg' file is zipped, the `NEEDED' of the `.so' files
    # it contains is not taken into account.  Thus, we must explicitly make
    # it a propagated input.
    propagatedBuildInputs = with self; [ pkgs.sqlite ];

    patchPhase = ''
      substituteInPlace "setup.cfg"                                     \
              --replace "/usr/local/include" "${pkgs.sqlite}/include"   \
              --replace "/usr/local/lib" "${pkgs.sqlite}/lib"
    '';

    # error: invalid command 'test'
    doCheck = false;

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
  });


  pysvn = pkgs.stdenv.mkDerivation rec {
    name = "pysvn-1.8.0";

    src = pkgs.fetchurl {
      url = "http://pysvn.barrys-emacs.org/source_kits/${name}.tar.gz";
      sha256 = "0srjr2qgxfs69p65d9vvdib2lc142x10w8afbbdrqs7dhi46yn9r";
    };

    buildInputs = with self; [ python pkgs.subversion pkgs.apr pkgs.aprutil pkgs.expat pkgs.neon pkgs.openssl ]
      ++ (if stdenv.isLinux then [pkgs.e2fsprogs] else []);

    # There seems to be no way to pass that path to configure.
    NIX_CFLAGS_COMPILE="-I${pkgs.aprutil}/include/apr-1";

    preConfigure = ''
      cd Source
      python setup.py backport
      python setup.py configure \
        --apr-inc-dir=${pkgs.apr}/include/apr-1 \
        --apu-inc-dir=${pkgs.aprutil}/include/apr-1 \
        --apr-lib-dir=${pkgs.apr}/lib \
        --svn-root-dir=${pkgs.subversion}
    '' + (if !stdenv.isDarwin then "" else ''
      sed -i -e 's|libpython2.7.dylib|lib/libpython2.7.dylib|' Makefile
    '');

    checkPhase = "make -C ../Tests";

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
      url = "https://pypi.python.org/packages/source/p/python-wifi/${name}.tar.bz2";
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


  pytz = buildPythonPackage rec {
    name = "pytz-${version}";
    version = "2015.7";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pytz/${name}.tar.gz";
      sha256 = "99266ef30a37e43932deec2b7ca73e83c8dbc3b9ff703ec73eca6b1dae6befea";
    };

    meta = {
      description = "World timezone definitions, modern and historical";
      homepage = "http://pythonhosted.org/pytz";
      license = licenses.mit;
    };
  };


  pyutil = buildPythonPackage (rec {
    name = "pyutil-2.0.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyutil/${name}.tar.gz";
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


  pywebkitgtk = stdenv.mkDerivation rec {
    name = "pywebkitgtk-${version}";
    version = "1.1.8";

    src = pkgs.fetchurl {
      url = "http://pywebkitgtk.googlecode.com/files/${name}.tar.bz2";
      sha256 = "1svlwyl61rvbqbcbalkg6pbf38yjyv7qkq9sx4x35yk69lscaac2";
    };

    buildInputs = [
      pkgs.pkgconfig pkgs.gtk2 self.pygtk pkgs.libxml2
      pkgs.libxslt pkgs.libsoup pkgs.webkitgtk2 pkgs.icu
    ];

    meta = {
      homepage = "https://code.google.com/p/pywebkitgtk/";
      description = "Python bindings for the WebKit GTK+ port";
      license = licenses.lgpl2Plus;
    };
  };

  pywinrm = buildPythonPackage (rec {
    name = "pywinrm";

    src = pkgs.fetchgit {
      url = https://github.com/diyan/pywinrm.git;
      rev = "c9ce62d500007561ab31a8d0a5d417e779fb69d9";
      sha256 = "0n0qlcgin2g5lpby07qbdlnpq5v2qc2yns9zc4zm5prwh2mhs5za";
    };

    propagatedBuildInputs = with self; [ xmltodict isodate ];

    meta = {
      homepage = "http://github.com/diyan/pywinrm/";
      description = "Python library for Windows Remote Management";
      license = licenses.mit;
    };
  });

  PyXAPI = stdenv.mkDerivation rec {
    name = "PyXAPI-0.1";

    src = pkgs.fetchurl {
      url = "http://www.pps.univ-paris-diderot.fr/~ylg/PyXAPI/${name}.tar.gz";
      sha256 = "19lblwfq24bgsgfy7hhqkxdf4bxl40chcxdlpma7a0wfa0ngbn26";
    };

    buildInputs = [ self.python ];

    installPhase = ''
      mkdir -p "$out/lib/${python.libPrefix}/site-packages"

      export PYTHONPATH="$out/lib/${python.libPrefix}/site-packages:$PYTHONPATH"

      ${python}/bin/${python.executable} setup.py install \
        --install-lib=$out/lib/${python.libPrefix}/site-packages \
        --prefix="$out"
    '';

    meta = with stdenv.lib; {
      description = "Python socket module extension & RFC3542 IPv6 Advanced Sockets API";
      longDescription = ''
        PyXAPI consists of two modules: `socket_ext' and `rfc3542'.
        `socket_ext' extends the Python module `socket'. `socket' objects have
        two new methods: `recvmsg' and `sendmsg'. It defines `ancillary data'
        objects and some functions related to. `socket_ext' module also provides
        functions to manage interfaces indexes defined in RFC3494 and not
        available from standard Python module `socket'.
        `rfc3542' is a full implementation of RFC3542 (Advanced Sockets
        Application Program Interface (API) for IPv6).
      '';
      homepage = http://www.pps.univ-paris-diderot.fr/~ylg/PyXAPI/;
      license = licenses.gpl2Plus;
      maintainers = with maintainers; [ nckx ];
    };
  };

  pyxattr = buildPythonPackage (rec {
    name = "pyxattr-0.5.1";

    src = pkgs.fetchurl {
      url = "https://github.com/downloads/iustin/pyxattr/${name}.tar.gz";
      sha256 = "0jmkffik6hdzs7ng8c65bggss2ai40nm59jykswdf5lpd36cxddq";
    };

    # error: invalid command 'test'
    doCheck = false;

    buildInputs = with self; [ pkgs.attr ];

    meta = {
      description = "A Python extension module which gives access to the extended attributes for filesystem objects available in some operating systems";
      license = licenses.lgpl21Plus;
    };
  });


  pyaml = buildPythonPackage (rec {
    name = "pyaml-15.02.1";
    disabled = !isPy27;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pyaml/${name}.tar.gz";
      sha256 = "8dfe1b295116115695752acc84d15ecf5c1c469975fbed7672bf41a6bc6d6d51";
    };

    buildInputs = with self; [ pyyaml ];

    meta = {
      description = "PyYAML-based module to produce pretty and readable YAML-serialized data";
      homepage = https://github.com/mk-fg/pretty-yaml;
    };
  });


  pyyaml = buildPythonPackage (rec {
    name = "PyYAML-3.11";

    src = pkgs.fetchurl {
      url = "http://pyyaml.org/download/pyyaml/${name}.zip";
      sha256 = "19bb3ac350ef878dda84a62d37c7d5c17a137386dde9c2ce7249c7a21d7f6ac9";
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
      url = "https://pypi.python.org/packages/source/r/rabbitpy/${name}.tar.gz";
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

  recaptcha_client = buildPythonPackage rec {
    name = "recaptcha-client-1.0.6";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/r/recaptcha-client/${name}.tar.gz";
      sha256 = "28c6853c1d13d365b7dc71a6b05e5ffb56471f70a850de318af50d3d7c0dea2f";
    };

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
    propagatedBuildInputs = with self; [ modules.sqlite3 six ];

    checkPhase = "nosetests";

    disabled = isPy3k;

    meta = {
      maintainers = with maintainers; [ iElectric ];
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


  reportlab =
   let freetype = overrideDerivation pkgs.freetype (args: { configureFlags = "--enable-static --enable-shared"; });
   in buildPythonPackage rec {
    name = "reportlab-3.2.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/r/reportlab/${name}.tar.gz";
      sha256 = "14v212cq2w3p0j5xydfr8rav8c8qas1q845r0xj7fm6q5dk8grkj";
    };

    LC_ALL = "en_US.UTF-8";
    buildInputs = with self; [ freetype pillow pip pkgs.glibcLocales ];

    patchPhase = ''
      rm tests/test_graphics_barcode.py
      rm tests/test_graphics_render.py
    '';

    checkPhase = ''
      ${python.interpreter} tests/runAll.py
    '';

    # See https://bitbucket.org/pypy/compatibility/wiki/reportlab%20toolkit
    disabled = isPyPy;

    meta = {
      description = "An Open Source Python library for generating PDFs and graphics";
      homepage = http://www.reportlab.com/;
    };
  };


  requests = buildPythonPackage rec {
    name = "requests-1.2.3";
    disabled = !pythonOlder "3.4";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/r/requests/${name}.tar.gz";
      sha256 = "156bf3ec27ba9ec7e0cf8fbe02808718099d218de403eb64a714d73ba1a29ab1";
    };

    meta = {
      description = "An Apache2 licensed HTTP library, written in Python, for human beings";
      homepage = http://docs.python-requests.org/en/latest/;
    };
  };


  requests2 = buildPythonPackage rec {
    name = "requests-${version}";
    version = "2.9.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/r/requests/${name}.tar.gz";
      sha256 = "0zsqrzlybf25xscgi7ja4s48y2abf9wvjkn47wh984qgs1fq2xy5";
    };

    buildInputs = [ self.pytest ];
    # sadly, tests require networking
    doCheck = false;

    meta = {
      description = "An Apache2 licensed HTTP library, written in Python, for human beings";
      homepage = http://docs.python-requests.org/en/latest/;
      license = licenses.asl20;
    };
  };


  requests_oauthlib = buildPythonPackage rec {
    version = "0.4.1";
    name = "requests-oauthlib-${version}";

    src = pkgs.fetchurl {
      url = "http://github.com/requests/requests-oauthlib/archive/v${version}.tar.gz";
      sha256 = "0vx252nzq5h9m9brwnw2ph8aj526y26jr2dqcafzzcdx6z4l8vj4";
    };

    doCheck = false;        # Internet tests fail when building in chroot
    propagatedBuildInputs = with self; [ oauthlib requests2 ];

    meta = {
      description = "OAuthlib authentication support for Requests";
      homepage = https://github.com/requests/requests-oauthlib;
      maintainers = with maintainers; [ prikhi ];
    };
  };

  requests_toolbelt = buildPythonPackage rec {
    version = "0.6.0";
    name = "requests-toolbelt-${version}";

    src = pkgs.fetchurl {
      url = "https://github.com/sigmavirus24/requests-toolbelt/archive/${version}.tar.gz";
      sha256 = "192pz6i1fp8vc1qasg6ccxpdsmpbqi3fqf5bgx3vpadp5x0rrz4f";
    };

    propagatedBuildInputs = with self; [ requests2 ];

    buildInputs = with self; [ betamax mock pytest ];

    meta = {
      description = "A toolbelt of useful classes and functions to be used with python-requests";
      homepage = http://toolbelt.rtfd.org;
      maintainers = with maintainers; [ matthiasbeyer jgeerds ];
    };

  };

  retry_decorator = buildPythonPackage rec {
    name = "retry_decorator-1.0.0";
    src = pkgs.fetchurl {
      url = https://pypi.python.org/packages/source/r/retry_decorator/retry_decorator-1.0.0.tar.gz;
      sha256 = "086zahyb6yn7ggpc58909c5r5h3jz321i1694l1c28bbpaxnlk88";
    };
    meta = {
      homepage = https://github.com/pnpnpn/retry-decorator;
      license = licenses.mit;
    };
  };

  qscintilla = if isPy3k || isPyPy
    then throw "qscintilla-${pkgs.qscintilla.version} not supported for interpreter ${python.executable}"
    else pkgs.stdenv.mkDerivation rec {
      # TODO: Qt5 support
      name = "qscintilla-${version}";
      version = pkgs.qscintilla.version;

      src = pkgs.qscintilla.src;

      buildInputs = with pkgs; [ xorg.lndir qt4 pyqt4 python ];

      preConfigure = ''
        mkdir -p $out
        lndir ${pkgs.pyqt4} $out
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
        maintainers = [ "abcz2.uprola@gmail.com" ];
        platforms = platforms.linux;
      };
    };


  qserve = buildPythonPackage rec {
    name = "qserve-0.2.8";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/q/qserve/${name}.zip";
      sha256 = "0b04b2d4d11b464ff1efd42a9ea9f8136187d59f4076f57c9ba95361d41cd7ed";
    };

    buildInputs = with self; [ ];

    meta = {
      description = "job queue server";
      homepage = "https://github.com/pediapress/qserve";
      license = licenses.bsd3;
    };
  };

  qtconsole = buildPythonPackage rec {
    version = "4.1.1";
    name = "qtconsole-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/q/qtconsole/${name}.tar.gz";
      sha256 = "741906acae9e02c0df9138ac88b621ef22e438565aa96d783a9ef88faec3de46";
    };

    buildInputs = with self; [ nose ] ++ optionals isPy27 [mock];
    propagatedBuildInputs = with self; [traitlets jupyter_core jupyter_client pygments ipykernel pyqt4];

    # : cannot connect to X server
    doCheck = false;

    meta = {
      description = "Jupyter Qt console";
      homepage = http://jupyter.org/;
      license = licenses.bsd3;
      maintainers = with maintainers; [ fridh ];
    };
  };

  quantities = buildPythonPackage rec {
    name = "quantities-0.10.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/q/quantities/quantities-0.10.1.tar.gz";
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

  recommonmark = buildPythonPackage rec {
    name = "recommonmark-${version}";
    version = "0.4.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/r/recommonmark/${name}.tar.gz";
      sha256 = "6e29c723abcf5533842376d87c4589e62923ecb6002a8e059eb608345ddaff9d";
    };

    buildInputs = with self; [ pytest sphinx ];
    propagatedBuildInputs = with self; [ CommonMark_54 docutils ];

    meta = {
      description = "A docutils-compatibility bridge to CommonMark";
      homepage = https://github.com/rtfd/recommonmark;
      license = licenses.mit;
      maintainers = with maintainers; [ fridh ];
    };

  };

  redis = buildPythonPackage rec {
    name = "redis-2.10.5";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/r/redis/${name}.tar.gz";
      sha256 = "0csmrkxb29x7xs9b51zplwkkq2hwnbh9jns1g85dykn5rxmaxysx";
    };

    # tests require a running redis
    doCheck = false;

    meta = {
      description = "Python client for Redis key-value store";
      homepage = "https://pypi.python.org/pypi/redis/";
    };
  };

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

  requests_oauth2 = buildPythonPackage rec {
    name = "requests-oauth2-0.1.1";

    src = pkgs.fetchurl {
      url = https://github.com/maraujop/requests-oauth2/archive/0.1.1.tar.gz;
      sha256 = "1aij66qg9j5j4vzyh64nbg72y7pcafgjddxsi865racsay43xfqg";
    };

    propagatedBuildInputs = with self; [ requests_oauthlib ];

    meta = {
      description = "Python's Requests OAuth2 (Open Authentication) plugin";
      homepage = https://github.com/maraujop/requests-oauth2;
    };
  };


  restview = buildPythonPackage rec {
    name = "restview-${version}";
    version = "2.5.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/r/restview/${name}.tar.gz";
      sha256 = "18diqmh6vwz6imcmvwa7s2v4562y73n072d5d7az2r2ks0g2bzdb";
    };

    propagatedBuildInputs = with self; [ docutils readme pygments ];
    buildInputs = with self; [ mock ];

    patchPhase = ''
      # dict order breaking tests
      sed -i 's@<a href="http://www.example.com" rel="nofollow">@...@' src/restview/tests.py
    '';

    meta = {
      description = "ReStructuredText viewer";
      homepage = http://mg.pov.lt/restview/;
      license = licenses.gpl2;
      platforms = platforms.all;
      maintainers = with maintainers; [ koral ];
    };
  };

  readme = buildPythonPackage rec {
    name = "readme-${version}";
    version = "0.6.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/r/readme/readme-${version}.tar.gz";
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
      description = "readme";
      homepage = "https://github.com/pypa/readme";
    };
  };

  Whoosh = buildPythonPackage rec {
    name = "Whoosh-${version}";
    version = "2.7.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/W/Whoosh/Whoosh-${version}.tar.gz";
      sha256 = "1xx8rqk1v2xs7mxvy9q4sgz2qmgvhf6ygbqjng3pl83ka4f0xz6d";
    };

    propagatedBuildInputs = with self; [

    ];
    buildInputs = with self; [
      pytest
    ];

    meta = with stdenv.lib; {
      homepage = "http://bitbucket.org/mchaput/whoosh";
    };
  };

  pysolr = buildPythonPackage rec {
    name = "pysolr-${version}";
    version = "3.3.3";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pysolr/pysolr-${version}.tar.gz";
      sha256 = "1wapg9n7myn7c82r3nzs2gisfzx52nip8w2mrfy0yih1zn02mnd6";
    };

    propagatedBuildInputs = with self; [
      requests2
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
      url = "https://pypi.python.org/packages/source/d/django-haystack/django-haystack-${version}.tar.gz";
      sha256 = "04cva8qg79xig4zqhb4dwkpm7734dvhzqclzvrdz70fh59ki5b4f";
    };

    doCheck = false;  # no tests in source

    buildInputs = with self; [ coverage mock nose geopy ];
    propagatedBuildInputs = with self; [
      django_1_6 dateutil_1_5 Whoosh pysolr elasticsearch
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
    version = "0.3.0.dev1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/G/GeoAlchemy2/${name}.tar.gz";
      sha256 = "1j95p860ikpcpcirs5791yjpy8rf18zsz7vvsdy6v3x32hkim0k6";
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
      url = "https://pypi.python.org/packages/source/g/geopy/geopy-${version}.tar.gz";
      sha256 = "04j1lxcsfyv03h0n0q7p2ig7a4n13x4x20fzxn8bkazpx6lyal22";
    };

    doCheck = false;  # too much

    buildInputs = with self; [ mock tox pkgs.pylint ];
    meta = with stdenv.lib; {
      homepage = "https://github.com/geopy/geopy";
    };
  };

  django-multiselectfield = buildPythonPackage rec {
    name = "django-multiselectfield-${version}";
    version = "0.1.3";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/django-multiselectfield/django-multiselectfield-${version}.tar.gz";
      sha256 = "0v7wf82f8688srdsym9ajv1j54bxfxwvydypc03f8xyl4c1raziv";
    };

    propagatedBuildInputs = with self; [

    ];
    buildInputs = with self; [

    ];

    meta = with stdenv.lib; {
      description = "django-multiselectfield";
      homepage = "https://github.com/goinnn/django-multiselectfield";
    };
  };


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
      [ django_1_6 recaptcha_client pytz memcached dateutil_1_5 paramiko flup
        pygments djblets django_evolution pycrypto modules.sqlite3 pysvn pillow
        psycopg2 django-haystack python_mimeparse markdown django-multiselectfield
      ];
  };


  rdflib = buildPythonPackage (rec {
    name = "rdflib-4.1.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/r/rdflib/${name}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/i/isodate/${name}.tar.gz";
      sha256 = "42105c41d037246dc1987e36d96f3752ffd5c0c24834dd12e4fdbe1e79544e31";
    };

    meta = {
      description = "ISO 8601 date/time parser";
      homepage = http://cheeseshop.python.org/pypi/isodate;
    };
  };

  robomachine = buildPythonPackage rec {
    name = "robomachine-0.6";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/R/RoboMachine/RoboMachine-0.6.tar.gz";
      sha256 = "6c9a9bae7bffa272b2a09b05df06c29a3a776542c70cae8041a8975a061d2e54";
    };

    propagatedBuildInputs = with self; [ pyparsing argparse robotframework ];

    # Remove Windows .bat files
    postInstall = ''
      rm "$out/bin/"*.bat
    '';

    meta = {
      description = "Test data generator for Robot Framework";
      homepage = https://github.com/mkorpela/RoboMachine;
      license = licenses.asl20;
      maintainers = with maintainers; [ bjornfor ];
    };
  };

  robotframework = buildPythonPackage rec {
    version = "2.8.7";
    name = "robotframework-${version}";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/r/robotframework/${name}.tar.gz";
      sha256 = "0mfd0s989j3jrpl8q0lb4wsjy1x280chfr9r74m2dyi9c7rxzc58";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      description = "Generic test automation framework";
      homepage = http://robotframework.org/;
      license = licenses.asl20;
      platforms = platforms.linux;
      maintainers = with maintainers; [ bjornfor ];
    };
  };


  robotframework-selenium2library = buildPythonPackage rec {
    version = "1.6.0";
    name = "robotframework-selenium2library-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/r/robotframework-selenium2library/${name}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/r/robotframework-tools/${name}.tar.gz";
      sha256 = "04gkn1zpf3rsvbqdxrrjqqi8sa0md9gqwh6n5w2m03fdwjg4lc7q";
    };

    propagatedBuildInputs = with self; [ robotframework moretools pathpy six setuptools ];

    meta = {
      description = "Python Tools for Robot Framework and Test Libraries";
      homepage = http://bitbucket.org/userzimmermann/robotframework-tools;
      license = licenses.gpl3;
      platforms = platforms.linux;
    };
  };


  robotsuite = buildPythonPackage rec {
    version = "1.4.2";
    name = "robotsuite-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/r/robotsuite/${name}.zip";
      sha256 = "0sw09vrvwv3gzqb6jvhbrz09l6nzzj3i9av34qjddqfwq7cr1bla";
    };

    # error: invalid command 'test'
    #doCheck = false;

    buildInputs = with self; [ unittest2 ];
    propagatedBuildInputs = with self; [ robotframework lxml ];

    meta = {
      description = "Python unittest test suite for Robot Framework";
      homepage = http://github.com/collective/robotsuite/;
      license = licenses.gpl3;
    };
  };


  robotframework-ride = buildPythonPackage rec {
    version = "1.2.3";
    name = "robotframework-ride-${version}";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "https://robotframework-ride.googlecode.com/files/${name}.tar.gz";
      sha256 = "1lf5f4x80f7d983bmkx12sxcizzii21kghs8kf63a1mj022a5x5j";
    };

    propagatedBuildInputs = with self; [ pygments wxPython modules.sqlite3 ];

    # ride_postinstall.py checks that needed deps are installed and creates a
    # desktop shortcut. We don't really need it and it clutters up bin/ so
    # remove it.
    postInstall = ''
      rm -f "$out/bin/ride_postinstall.py"
    '';

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      description = "Light-weight and intuitive editor for Robot Framework test case files";
      homepage = https://code.google.com/p/robotframework-ride/;
      license = licenses.asl20;
      platforms = platforms.linux;
      maintainers = with maintainers; [ bjornfor ];
    };
  };


  rope = buildPythonPackage rec {
    version = "0.10.2";
    name = "rope-${version}";

    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/r/rope/${name}.tar.gz";
      sha256 = "0rdlvp8h74qs49wz1hx6qy8mgp2ddwlfs7z13h9139ynq04a3z7z";
    };

    meta = {
      description = "python refactoring library";
      homepage = http://rope.sf.net;
      maintainers = with maintainers; [ goibhniu ];
      license = licenses.gpl2;
    };
  };

  ropemacs = buildPythonPackage rec {
    version = "0.7";
    name = "ropemacs-${version}";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/r/ropemacs/${name}.tar.gz";
      sha256 = "1x5qf1drcdz9jfiiakc60kzqkb3ahsg9j902c5byf3gjfacdrmqj";
    };

    propagatedBuildInputs = with self; [ ropemode ];

     meta = {
       description = "a plugin for performing python refactorings in emacs";
       homepage = http://rope.sf.net/ropemacs.html;
       maintainers = with maintainers; [ goibhniu ];
       license = licenses.gpl2;
     };
  };

  ropemode = buildPythonPackage rec {
    version = "0.2";
    name = "ropemode-${version}";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/r/ropemode/${name}.tar.gz";
      sha256 = "0jw6h1wvk6wk0wknqdf7s9pw76m8472jv546lqdd88jbl2scgcjl";
    };

    propagatedBuildInputs = with self; [ rope ];

     meta = {
       description = "a plugin for performing python refactorings in emacs";
       homepage = http://rope.sf.net;
       maintainers = with maintainers; [ goibhniu ];
       license = licenses.gpl2;
     };
  };



  routes = buildPythonPackage rec {
    name = "routes-1.12.3";

    src = pkgs.fetchurl {
      url = http://pypi.python.org/packages/source/R/Routes/Routes-1.12.3.tar.gz;
      sha256 = "eacc0dfb7c883374e698cebaa01a740d8c78d364b6e7f3df0312de042f77aa36";
    };

    propagatedBuildInputs = with self; [ paste webtest ];

    meta = {
      description = "A Python re-implementation of the Rails routes system for mapping URLs to application actions";
      homepage = http://routes.groovie.org/;
    };
  };

  rpkg = buildPythonPackage (rec {
    name = "rpkg-1.14";
    disabled = !isPy27;
    meta.maintainers = with maintainers; [ mornfall ];

    src = pkgs.fetchurl {
      url = "https://fedorahosted.org/releases/r/p/rpkg/rpkg-1.14.tar.gz";
      sha256 = "0d053hdjz87aym1sfm6c4cxmzmy5g0gkrmrczly86skj957r77a7";
    };

    patches = [ ../development/python-modules/rpkg-buildfix.diff ];

    propagatedBuildInputs = with self; [ pycurl pkgs.koji GitPython pkgs.git
                              pkgs.rpm pkgs.pyopenssl ];

  });

  rpy2 = buildPythonPackage rec {
    name = "rpy2-2.5.6";
    disabled = isPyPy;
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/r/rpy2/${name}.tar.gz";
      sha256 = "d0d584c435b5ed376925a95a4525dbe87de7fa9260117e9f208029e0c919ad06";
    };
    buildInputs = with pkgs; [ readline R pcre lzma bzip2 zlib icu ];
    propagatedBuildInputs = [ self.singledispatch ];
    meta = {
      homepage = http://rpy.sourceforge.net/rpy2;
      description = "Python interface to R";
      license = licenses.gpl2Plus;
      maintainers = with maintainers; [ joelmo ];
    };
  };

  rpyc = buildPythonPackage rec {
    name = "rpyc-${version}";
    version = "3.3.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/r/rpyc/${name}.tar.gz";
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
    version = "3.3";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/r/rsa/${name}.tar.gz";
      sha256 = "03f3d9bebad06681771016b8752a40b12f615ff32363c7aa19b3798e73ccd615";
    };

    nativeBuildInputs = with self; [ unittest2 ];
    propagatedBuildInputs = with self; [ pyasn1 ];

    checkPhase = ''
      ${python.interpreter} run_tests.py
    '';

    meta = {
      homepage = http://stuvel.eu/rsa;
      license = licenses.asl20;
      description = "A pure-Python RSA implementation";
    };
  };

  squaremap = buildPythonPackage rec {
    name = "squaremap-1.0.4";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/S/SquareMap/SquareMap-1.0.4.tar.gz";
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
      url = "https://pypi.python.org/packages/source/r/ruamel.base/${name}.tar.gz";
      sha256 = "1wswxrn4givsm917mfl39rafgadimf1sldpbjdjws00g1wx36hf0";
    };

    meta = {
      description = "common routines for ruamel packages";
      homepage = https://bitbucket.org/ruamel/base;
      license = licenses.mit;
    };
  };

  ruamel_ordereddict = buildPythonPackage rec {
    name = "ruamel.ordereddict-${version}";
    version = "0.4.9";
    disabled = isPy3k || isPyPy;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/r/ruamel.ordereddict/${name}.tar.gz";
      sha256 = "1xmkl8v9l9inm2pyxgc1fm5005yxm7fkd5gv74q7lj1iy5qc8n3h";
    };

    meta = {
      description = "a version of dict that keeps keys in insertion resp. sorted order";
      homepage = https://bitbucket.org/ruamel/ordereddict;
      license = licenses.mit;
    };
  };

  ruamel_yaml = buildPythonPackage rec {
    name = "ruamel.yaml-${version}";
    version = "0.10.13";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/r/ruamel.yaml/${name}.tar.gz";
      sha256 = "0r9mn5lm9dcxpy0wpn18cp7i5hkvjvknv3dxg8d9ca6km39m4asn";
    };

    propagatedBuildInputs = with self; [ ruamel_base ruamel_ordereddict ];

    meta = {
      description = "YAML parser/emitter that supports roundtrip preservation of comments, seq/map flow style, and map key order";
      homepage = https://bitbucket.org/ruamel/yaml;
      license = licenses.mit;
    };
  };

  runsnakerun = buildPythonPackage rec {
    name = "runsnakerun-2.0.4";


    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/R/RunSnakeRun/RunSnakeRun-2.0.4.tar.gz";
      sha256 = "61d03a13f1dcb3c1829f5a146da1fe0cc0e27947558a51e848b6d469902815ef";
    };

    propagatedBuildInputs = [ self.squaremap self.wxPython28 ];

    meta = {
      description = "GUI Viewer for Python profiling runs";
      homepage = http://www.vrplumber.com/programming/runsnakerun/;
      license = licenses.bsd3;
    };
  };

  rtslib_fb = buildPythonPackage rec {
    version = "2.1.fb43";
    name = "rtslib-fb-${version}";

    src = pkgs.fetchurl {
      url = "https://github.com/agrover/rtslib-fb/archive/v${version}.tar.gz";
      sha256 = "1b59vyy12g6rix9l2fxx0hjiq33shkb79v57gwffs57vh74wc53v";
    };

    meta = {
      description = "A Python object API for managing the Linux LIO kernel target";
      homepage = "https://github.com/agrover/rtslib-fb";
      platforms = platforms.linux;
    };
  };

  seqdiag = buildPythonPackage rec {
    name = "seqdiag-0.9.4";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/s/seqdiag/${name}.tar.gz";
      sha256 = "1qa7d0m1wahvmrj95rxkb6128cbwd4w3gy8gbzncls66h46bifiz";
    };

    buildInputs = with self; [ pep8 nose unittest2 docutils ];

    propagatedBuildInputs = with self; [ blockdiag ];

    # Tests fail:
    #   ...
    #   ERROR: Failure: OSError ([Errno 2] No such file or directory: '/tmp/nix-build-python2.7-seqdiag-0.9.0.drv-0/seqdiag-0.9.0/src/seqdiag/tests/diagrams/')
    doCheck = false;

    meta = {
      description = "Generate sequence-diagram image from spec-text file (similar to Graphviz)";
      homepage = http://blockdiag.com/;
      license = licenses.asl20;
      platforms = platforms.linux;
      maintainers = with maintainers; [ bjornfor ];
    };
  };

  pysendfile = buildPythonPackage rec {
    name = "pysendfile-${version}";
    version = "2.0.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pysendfile/pysendfile-${version}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/x/xattr/${name}.tar.gz";
      sha256 = "0nbqfghgy26jyp5q7wl3rj78wr8s39m5042df2jlldg3fx6j0417";
    };

    # https://github.com/xattr/xattr/issues/43
    doCheck = false;

    postBuild = ''
      ${python.interpreter} -m compileall -f xattr
    '';

    propagatedBuildInputs = [ self.cffi ];
  };

  scapy = buildPythonPackage rec {
    name = "scapy-2.2.0";

    disabled = isPy3k || isPyPy;

    src = pkgs.fetchurl {
      url = "http://www.secdev.org/projects/scapy/files/${name}.tar.gz";
      sha256 = "1bqmp0xglkndrqgmybpwmzkv462mir8qlkfwsxwbvvzh9li3ndn5";
    };

    propagatedBuildInputs = [ modules.readline ];

    meta = {
      description = "Powerful interactive network packet manipulation program";
      homepage = http://www.secdev.org/projects/scapy/;
      license = licenses.gpl2;
      platforms = platforms.linux;
      maintainers = with maintainers; [ bjornfor ];
    };
  };

  buildScipyPackage = callPackage ../development/python-modules/scipy.nix {
    gfortran = pkgs.gfortran;
  };

  scipy = self.scipy_0_17;

  scipy_0_16 = self.buildScipyPackage rec {
    version = "0.16.1";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/s/scipy/scipy-${version}.tar.gz";
      sha256 = "ecd1efbb1c038accb0516151d1e6679809c6010288765eb5da6051550bf52260";
    };
    numpy = self.numpy_1_10;
  };

  scipy_0_17 = self.buildScipyPackage rec {
    version = "0.17.0";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/s/scipy/scipy-${version}.tar.gz";
      sha256 = "f600b755fb69437d0f70361f9e560ab4d304b1b66987ed5a28bdd9dd7793e089";
    };
    numpy = self.numpy_1_10;
  };

  scikitimage = buildPythonPackage rec {
    name = "scikit-image-${version}";
    version = "0.11.3";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/s/scikit-image/${name}.tar.gz";
      sha256 = "768e568f3299966c294b7eb8cd114fc648f7bfaef422ee9cc750dd8d9d09e44b";
    };

    buildInputs = with self; [ pkgs.cython nose numpy six ];

    propagatedBuildInputs = with self; [ pillow matplotlib networkx scipy ];

    meta = {
      description = "Image processing routines for SciPy";
      homepage = http://scikit-image.org;
      license = licenses.bsd3;
    };
  };


  scikitlearn = buildPythonPackage rec {
    name = "scikit-learn-${version}";
    version = "0.17.1";
    disabled = stdenv.isi686;  # https://github.com/scikit-learn/scikit-learn/issues/5534

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/s/scikit-learn/${name}.tar.gz";
      sha256 = "9f4cf58e57d81783289fc503caaed1f210bab49b7a6f680bf3c04b1e0a96e5f0";
    };

    buildInputs = with self; [ nose pillow pkgs.gfortran pkgs.glibcLocales ];
    propagatedBuildInputs = with self; [ numpy scipy numpy.blas ];

    LC_ALL="en_US.UTF-8";

    checkPhase = ''
      HOME=$TMPDIR OMP_NUM_THREADS=1 nosetests $out/${python.sitePackages}/sklearn/
    '';

    meta = {
      description = "A set of python modules for machine learning and data mining";
      homepage = http://scikit-learn.org;
      license = licenses.bsd3;
      maintainers = with maintainers; [ fridh ];
    };
  };

  scripttest = buildPythonPackage rec {
    version = "1.3";
    name = "scripttest-${version}";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/s/scripttest/scripttest-${version}.tar.gz";
      sha256 = "951cfc25219b0cd003493a565f2e621fd791beaae9f9a3bdd7024d8626419c38";
    };

    buildInputs = with self; [ pytest ];

    # Tests are not included. See https://github.com/pypa/scripttest/issues/11
    doCheck = false;

    meta = {
      description = "A library for testing interactive command-line applications";
      homepage = http://pypi.python.org/pypi/ScriptTest/;
    };
  };

  seaborn = buildPythonPackage rec {
    name = "seaborn-0.6.0";
    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/s/seaborn/${name}.tar.gz";
      sha256 = "e078399b56ed0d53a4aa8bd4d6bd4a9a9deebc0b4acad259d0ef81830affdb68";
    };

    buildInputs = with self; [ nose ];
    propagatedBuildInputs = with self; [ pandas matplotlib ];

    checkPhase = ''
      nosetests -v
    '';

    # Computationally very demanding tests
    doCheck = false;

    meta = {
      description = "statisitical data visualization";
      homepage = "http://stanford.edu/~mwaskom/software/seaborn/";
      license     = "BSD";
      maintainers = with maintainers; [ fridh ];
    };
  };

  selenium = buildPythonPackage rec {
    name = "selenium-2.44.0";
    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/s/selenium/${name}.tar.gz";
      sha256 = "0l70pqwg88imbylcd831vg8nj8ipy4zr331f6qjccss7vn56i2h5";
    };

    buildInputs = with self; [pkgs.xorg.libX11];

    # Recompiling x_ignore_nofocus.so as the original one dlopen's libX11.so.6 by some
    # absolute paths. Replaced by relative path so it is found when used in nix.
    x_ignore_nofocus =
      pkgs.fetchFromGitHub {
        owner = "SeleniumHQ";
        repo = "selenium";
        rev = "selenium-2.44.0";
        sha256 = "13aqm0dwy17ghimy7m2mxjwlyc1k7zk5icxzrs1sa896056f1dyy";
      };

    patchPhase = ''
      cp "${x_ignore_nofocus}/cpp/linux-specific/"* .
      substituteInPlace x_ignore_nofocus.c --replace "/usr/lib/libX11.so.6" "${pkgs.xorg.libX11}/lib/libX11.so.6"
      gcc -c -fPIC x_ignore_nofocus.c -o x_ignore_nofocus.o
      gcc -shared \
        -Wl,${if stdenv.isDarwin then "-install_name" else "-soname"},x_ignore_nofocus.so \
        -o x_ignore_nofocus.so \
        x_ignore_nofocus.o
      cp -v x_ignore_nofocus.so py/selenium/webdriver/firefox/${if pkgs.stdenv.is64bit then "amd64" else "x86"}/
    '';
  };

  setuptools_scm = buildPythonPackage rec {
    name = "setuptools_scm-${version}";
    version = "1.10.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/s/setuptools_scm/${name}.tar.bz2";
      sha256 = "1cdea91bbe1ec4d52b3e9c451ab32ae6e1f3aa3fd91e90580490a9eb75bea286";
    };

    buildInputs = with self; [ pip ];

    meta = with stdenv.lib; {
      homepage = https://bitbucket.org/pypa/setuptools_scm/;
      description = "Handles managing your python package versions in scm metadata";
      license = licenses.mit;
      maintainers = with maintainers; [ jgeerds ];
    };
  };

  setuptoolsDarcs = buildPythonPackage rec {
    name = "setuptools_darcs-${version}";
    version = "1.2.11";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/s/setuptools_darcs/${name}.tar.gz";
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


  setuptoolsTrial = buildPythonPackage {
    name = "setuptools-trial-0.5.12";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/s/setuptools_trial/setuptools_trial-0.5.12.tar.gz";
      sha256 = "9cc4ca5fd432944eb95e193f28b5a602e8b07201fea4d7077c0976a40f073432";
    };

    propagatedBuildInputs = with self; [ twisted ];

    meta = {
      description = "setuptools plug-in that helps run unit tests built with the \"Trial\" framework (from Twisted)";

      homepage = http://allmydata.org/trac/setuptools_trial;

      license = "unspecified"; # !
    };
  };

  simplegeneric = buildPythonPackage rec {
    version = "0.8.1";
    name = "simplegeneric-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/s/simplegeneric/${name}.zip";
      sha256 = "dc972e06094b9af5b855b3df4a646395e43d1c9d0d39ed345b7393560d0b9173";
    };

    meta = {
      description = "Simple generic functions";
      homepage = http://cheeseshop.python.org/pypi/simplegeneric;
      license = licenses.zpt21;
    };
  };


  shortuuid = buildPythonPackage rec {
    name = "shortuuid-${version}";
    version = "0.4.3";

    disabled = isPy26;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/s/shortuuid/${name}.tar.gz";
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
      url = "http://pypi.python.org/packages/source/s/shouldbe/${name}.tar.gz";
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

  simplejson = buildPythonPackage (rec {
    name = "simplejson-3.8.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/s/simplejson/${name}.tar.gz";
      sha256 = "14r4l4rcsyf87p2j4ycsbb017n4vzxfmv285rq2gny4w47rwi2j2";
    };

    meta = {
      description = "A simple, fast, extensible JSON encoder/decoder for Python";

      longDescription = ''
        simplejson is compatible with Python 2.4 and later with no
        external dependencies.  It covers the full JSON specification
        for both encoding and decoding, with unicode support.  By
        default, encoding is done in an encoding neutral fashion (plain
        ASCII with \uXXXX escapes for unicode characters).
      '';

      homepage = http://code.google.com/p/simplejson/;

      license = licenses.mit;
    };
  });

  simpleldap = buildPythonPackage rec {
    version = "0.8";
    name = "simpleldap-${version}";

    propagatedBuildInputs = with self; [ ldap ];
    buildInputs = with self; [ pep8 pytest tox ];

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/s/simpleldap/simpleldap-${version}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/S/SimpleParse/SimpleParse-${version}.tar.gz";
      sha256 = "1n8msk71lpl3kv086xr2sv68ppgz6228575xfnbszc6p1mwr64rg";
    };

    doCheck = false;  # weird error

    meta = {
      description = "A Parser Generator for Python";
      homepage = https://pypi.python.org/pypi/SimpleParse;
      platforms = platforms.all;
      maintainers = with maintainers; [ DamienCassou ];
    };
  };

  sigal = buildPythonPackage rec {
    name = "sigal-0.9.2";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/s/sigal/${name}.tar.gz";
      sha256 = "0mk3bzaxn9snx9lc0pj9zvgdgdyhkza6b8z5x91772mlv84sfw6c";
    };

    propagatedBuildInputs = with self; [ jinja2 markdown pillow pilkit clint click pytest blinker ];

    meta = {
      description = "Yet another simple static gallery generator";
      homepage = http://sigal.saimon.org/en/latest/index.html;
      license = licenses.mit;
      maintainers = with maintainers; [ iElectric ];
    };
  };

  slowaes = buildPythonPackage rec {
    name = "slowaes-${version}";
    version = "0.1a1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/s/slowaes/${name}.tar.gz";
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
      url = "http://pypi.python.org/packages/source/s/snowballstemmer/${name}.tar.gz";
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

  sqlite3dbm = buildPythonPackage rec {
    name = "sqlite3dbm-0.1.4";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/s/sqlite3dbm/${name}.tar.gz";
      sha256 = "4721607e0b817b89efdba7e79cab881a03164b94777f4cf796ad5dd59a7612c5";
    };

    buildInputs = with self; [ modules.sqlite3 ];

    meta = {
      description = "sqlite-backed dictionary";
      homepage = "http://github.com/Yelp/sqlite3dbm";
      license = licenses.asl20;
    };
  };

  pgpdump = self.buildPythonPackage rec {
    name = "pgpdump-1.5";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pgpdump/pgpdump-1.5.tar.gz";
      sha256 = "1c4700857bf7ba735b08cfe4101aa3a4f5fd839657af249c17b2697c20829668";
    };

    meta = {
      description = "Python library for parsing PGP packets";
      homepage = https://github.com/toofishes/python-pgpdump;
      license = licenses.bsd3;
    };
  };

  spambayes = buildPythonPackage rec {
    name = "spambayes-1.1b1";

    src = pkgs.fetchurl {
      url = "mirror://sourceforge/spambayes/${name}.tar.gz";
      sha256 = "0kqvjb89b02wp41p650ydfspi1s8d7akx1igcrw62diidqbxp04n";
    };

    propagatedBuildInputs = with self; [ pydns lockfile ];

    meta = {
      description = "Statistical anti-spam filter, initially based on the work of Paul Graham";
      homepage = http://spambayes.sourceforge.net/;
    };
  };

  shapely = buildPythonPackage rec {
    name = "Shapely-${version}";
    version = "1.5.13";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/S/Shapely/${name}.tar.gz";
      sha256 = "68f8efb43112e8ef1f7e56e2c9eef64e0cbc1c19528c627696fb07345075a348";
    };

    buildInputs = with self; [ pkgs.geos pkgs.glibcLocales pytest ];

    propagatedBuildInputs = with self; [ numpy ];

    preConfigure = ''
      export LANG="en_US.UTF-8";
    '';

    patchPhase = ''
      sed -i "s|_lgeos = load_dll('geos_c', fallbacks=.*)|_lgeos = load_dll('geos_c', fallbacks=['${pkgs.geos}/lib/libgeos_c.so'])|" shapely/geos.py
    '';

    checkPhase = ''
      py.test $out
    '';

    meta = {
      description = "Geometric objects, predicates, and operations";
      homepage = "https://pypi.python.org/pypi/Shapely/";
    };
  };

  sockjs-tornado = buildPythonPackage rec {
    name = "sockjs-tornado-${version}";
    version = "1.0.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/s/sockjs-tornado/${name}.tar.gz";
      sha256 = "15lcy40h2cm0l8aknbrk48p2sni5wzybsqjx1hxwpk9lfa1xryyv";
    };

    # This is needed for compatibility with OctoPrint
    propagatedBuildInputs = with self; [ tornado_4_0_1 ];

    meta = {
      description = "SockJS python server implementation on top of Tornado framework";
      homepage = http://github.com/mrjoes/sockjs-tornado/;
      license = licenses.mit;
      platforms = platforms.all;
      maintainers = with maintainers; [ abbradar ];
    };
  };

  sopel = buildPythonPackage rec {
    name = "sopel-6.3.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/s/sopel/${name}.tar.gz";
      sha256 = "10g3p603qiz4whacknnslmkza5y1f7a8blq1q07dfrny4442c6nb";
    };

    buildInputs = with self; [ pytest ];
    propagatedBuildInputs = with self; [ praw xmltodict pytz pyenchant pygeoip ];

    disabled = isPyPy || isPy26 || isPy27;

    checkPhase = ''
    ${python.interpreter} test/*.py
    '';
    meta = {
      description = "Simple and extensible IRC bot";
      homepage = "http://sopel.chat";
      license = licenses.efl20;
      maintainers = with maintainers; [ mog ];
    };
  };

  sounddevice = buildPythonPackage rec {
    name = "sounddevice-${version}";
    version = "0.3.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/s/sounddevice/${name}.tar.gz";
      sha256 = "8e5a6816b369c7aea77e06092b2fee99c8b6efbeef4851f53ea3cb208a7607f5";
    };

    propagatedBuildInputs = with self; [ cffi numpy pkgs.portaudio ];

    # No tests included nor upstream available.
    doCheck = false;

    prePatch = ''
      substituteInPlace sounddevice.py --replace "'portaudio'" "'${pkgs.portaudio}/lib/libportaudio.so.2'"
    '';

    meta = {
      description = "Play and Record Sound with Python";
      homepage = http://python-sounddevice.rtfd.org/;
      license = with licenses; [ mit ];
      maintainers = with maintainers; [ fridh ];
    };
  };

  stevedore = buildPythonPackage rec {
    name = "stevedore-1.7.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/s/stevedore/${name}.tar.gz";
      sha256 = "149pjc0c3z6khjisn4yil3f94qjnzwafz093wc8rrzbw828qdkv8";
    };

    doCheck = false;

    buildInputs = with self; [ oslosphinx ];
    propagatedBuildInputs = with self; [ pbr six argparse ];

    meta = {
      description = "Manage dynamic plugins for Python applications";
      homepage = "https://pypi.python.org/pypi/stevedore";
      license = licenses.asl20;
    };
  };

  tidylib = buildPythonPackage rec {
    version = "0.2.4";
    name = "pytidylib-${version}";

    propagatedBuildInputs = [ pkgs.html-tidy ];

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pytidylib/pytidylib-${version}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/T/TileStache/TileStache-${version}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/t/timelib/${name}.zip";
      sha256 = "49142233bdb5971d64a41e05a1f80a408a02be0dc7d9f8c99e7bdd0613ba81cb";
    };

    buildInputs = with self; [ ];

    meta = {
      description = "parse english textual date descriptions";
      homepage = "https://github.com/pediapress/timelib/";
      license = licenses.zlib;
    };
  };

  pydns = buildPythonPackage rec {
    name = "pydns-2.3.6";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pydns/${name}.tar.gz";
      sha256 = "0qnv7i9824nb5h9psj0rwzjyprwgfiwh5s5raa9avbqazy5hv5pi";
    };

    doCheck = false;

  };

  sympy = buildPythonPackage rec {
    name = "sympy-0.7.6.1";
    disabled = isPy34 || isPy35 || isPyPy;  # some tests fail

    src = pkgs.fetchurl {
      url    = "https://pypi.python.org/packages/source/s/sympy/${name}.tar.gz";
      sha256 = "1fc272b51091aabe7d07f1bf9f0a47f3e28657fb2bec52bf3ef0e8f159f5f564";
    };

    buildInputs = [ pkgs.glibcLocales ];

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
      url = "http://pypi.python.org/packages/source/p/pilkit/${name}.tar.gz";
      sha256 = "e00585f5466654ea2cdbf7decef9862cb00e16fd363017fa7ef6623a16b0d2c7";
    };

    preConfigure = ''
      substituteInPlace setup.py --replace 'nose==1.2.1' 'nose'
    '';

    # tests fail, see https://github.com/matthewwithanm/pilkit/issues/9
    doCheck = false;

    buildInputs = with self; [ pillow nose_progressive nose mock blessings ];

    meta = {
      maintainers = with maintainers; [ iElectric ];
    };
  };

  clint = buildPythonPackage rec {
    name = "clint-0.5.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/c/clint/${name}.tar.gz";
      sha256 = "1an5lkkqk1zha47198p42ji3m94xmzx1a03dn7866m87n4r4q8h5";
    };


    LC_ALL="en_US.UTF-8";

    checkPhase = ''
      ${python.interpreter} test_clint.py
    '';

    buildInputs = with self; [ mock blessings nose nose_progressive pkgs.glibcLocales ];
    propagatedBuildInputs = with self; [ pillow blessings args ];

    meta = {
      maintainers = with maintainers; [ iElectric ];
    };
  };

  argh = buildPythonPackage rec {
    name = "argh-0.26.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/a/argh/${name}.tar.gz";
      sha256 = "1nqham81ihffc9xmw85dz3rg3v90rw7h0dp3dy0bh3qkp4n499q6";
    };

    checkPhase = ''
      export LANG="en_US.UTF-8"
      py.test
    '';

    buildInputs = with self; [ pytest py mock pkgs.glibcLocales ];

    meta = {
      maintainers = with maintainers; [ iElectric ];
    };
  };

  nose_progressive = buildPythonPackage rec {
    name = "nose-progressive-1.5.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/n/nose-progressive/${name}.tar.gz";
      sha256 = "0mfbjv3dcg23q0a130670g7xpfyvgza4wxkj991xxh8w9hs43ga4";
    };

    buildInputs = with self; [ nose ];
    propagatedBuildInputs = with self; [ pillow blessings ];

    # fails with obscure error
    doCheck = !isPy3k;

    meta = {
      maintainers = with maintainers; [ iElectric ];
    };
  };

  blessings = buildPythonPackage rec {
    name = "blessings-1.6";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/b/blessings/${name}.tar.gz";
      sha256 = "01rhgn2c3xjf9h1lxij9m05iwf2ba6d0vd7nic26c2gic4q73igd";
    };

    # 4 failing tests, 2to3
    doCheck = false;

    propagatedBuildInputs = with self; [ modules.curses ];

    meta = {
      maintainers = with maintainers; [ iElectric ];
    };
  };

  semantic = buildPythonPackage rec {
    name = "semantic-1.0.3";

    disabled = isPy3k;

    propagatedBuildInputs = with self; [ quantities numpy ];

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/s/semantic/semantic-1.0.3.tar.gz";
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
      url = "https://pypi.python.org/packages/source/s/sandboxlib/sandboxlib-0.3.1.tar.gz";
      sha256 = "0csj8hbpylqdkxcpqkcfs73dfvdqkyj23axi8m9drqdi4dhxb41h";
    };

    meta = {
      description = "Sandboxing Library for Python";
      homepage = https://pypi.python.org/pypi/sandboxlib/0.3.1;
      license = licenses.gpl2;
    };
  };

  semantic-version = buildPythonPackage rec {
    name = "semantic_version-2.4.2";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/s/semantic_version/${name}.tar.gz";
      sha256 = "7e8b7fa74a3bc9b6e90b15b83b9bc2377c78eaeae3447516425f475d5d6932d2";
    };

    meta = {
      description = "A library implementing the 'SemVer' scheme";
      license = licenses.bsdOriginal;
      maintainers = with maintainers; [ layus ];
    };
  };

  sexpdata = buildPythonPackage rec {
    name = "sexpdata-0.0.2";
    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/s/sexpdata/${name}.tar.gz";
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
      url = "http://pypi.python.org/packages/source/s/sh/${name}.tar.gz";
      sha256 = "590fb9b84abf8b1f560df92d73d87965f1e85c6b8330f8a5f6b336b36f0559a4";
    };

    doCheck = false;

    meta = {
      description = "Python subprocess interface";
      homepage = http://pypi.python.org/pypi/sh/;
    };
  };


  sipsimple = buildPythonPackage rec {
    name = "sipsimple-${version}";
    version = "2.6.0";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "http://download.ag-projects.com/SipClient/python-${name}.tar.gz";
      sha256 = "0xcyasas28q1ad1hgw4vd62b72mf1sng7xwfcls6dc05k9p3q8v3";
    };

    propagatedBuildInputs = with self; [ cython pkgs.openssl dns dateutil xcaplib msrplib lxml ];
    buildInputs = with pkgs; [ alsaLib ffmpeg libv4l pkgconfig sqlite libvpx ];
  };


  six = buildPythonPackage rec {
    name = "six-1.10.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/s/six/${name}.tar.gz";
      sha256 = "0snmb8xffb3vsma0z67i0h0w2g2dy0p3gsgh9gi4i0kgc5l8spqh";
    };

    buildInputs = with self; [ pytest ];

    checkPhase = ''
      py.test test_six.py
    '';

    meta = {
      description = "A Python 2 and 3 compatibility library";
      homepage = http://pypi.python.org/pypi/six/;
    };
  };


  skype4py = buildPythonPackage (rec {
    name = "Skype4Py-1.0.32.0";
    disabled = isPy3k || isPyPy;

    src = pkgs.fetchurl {
      url = mirror://sourceforge/skype4py/Skype4Py-1.0.32.0.tar.gz;
      sha256 = "0cmkrv450wa8v50bng5dflpwkl5c1p9pzysjkb2956w5kvwh6f5b";
    };

    unpackPhase = ''
      tar xf $src
      find . -type d -exec chmod +rx {} \;
      sourceRoot=`pwd`/`ls -d S*`
    '';

    # error: invalid command 'test'
    doCheck = false;

    propagatedBuildInputs = with self; [ pkgs.xorg.libX11 pkgs.pythonDBus pygobject ];

    meta = {
      description = "High-level, platform independent Skype API wrapper for Python";

      # The advertisement says https://developer.skype.com/wiki/Skype4Py
      # but that url does not work. This following web page points to the
      # download link and has some information about the package.
      homepage = http://pypi.python.org/pypi/Skype4Py/1.0.32.0;

      license = "BSD";
    };
  });

  smartdc = buildPythonPackage rec {
    name = "smartdc-0.1.12";

    src = pkgs.fetchurl {
      url = https://pypi.python.org/packages/source/s/smartdc/smartdc-0.1.12.tar.gz;
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
      url = https://pypi.python.org/packages/source/S/SocksiPy-branch/SocksiPy-branch-1.01.tar.gz;
      sha256 = "01l41v4g7fy9fzvinmjxy6zcbhgqaif8dhdqm4w90fwcw9h51a8p";
    };
    meta = {
      homepage = http://code.google.com/p/socksipy-branch/;
      description = "This Python module allows you to create TCP connections through a SOCKS proxy without any special effort";
      license = licenses.bsd3;
    };
  };

  sorl_thumbnail = buildPythonPackage rec {
    name = "sorl-thumbnail-11.12";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/s/sorl-thumbnail/${name}.tar.gz";
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
    name = "supervisor-3.1.1";

    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/s/supervisor/${name}.tar.gz";
      sha256 = "e3c3b35804c24b6325b5ba462553ebee80d5f4d1766274737b5c532cd4a11d59";
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

  subprocess32 = buildPythonPackage rec {
    name = "subprocess32-3.2.6";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/s/subprocess32/${name}.tar.gz";
      sha256 = "ddf4d46ed2be2c7e7372dfd00c464cabb6b3e29ca4113d85e26f82b3d2c220f6";
    };

    buildInputs = [ pkgs.bash ];

    preConfigure = ''
      substituteInPlace test_subprocess32.py \
        --replace '/usr/' '${pkgs.bash}/'
    '';

    doCheck = !isPyPy;
    checkPhase = ''
      ${python.interpreter} test_subprocess32.py
    '';

    meta = {
      homepage = https://pypi.python.org/pypi/subprocess32;
      description = "Backport of the subprocess module from Python 3.2.5 for use on 2.x";
      maintainers = with maintainers; [ garbas ];
    };
  };


  sphinx = buildPythonPackage (rec {
    name = "Sphinx-1.3.4";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/S/Sphinx/${name}.tar.gz";
      sha256 = "0mw06q7bzzjylgwh0wnnaxmwc95hx8w95as4vcgpan579brw7b4a";
    };

    patches = [ ../development/python-modules/sphinx-fix-tests-with-pygments-2.1.patch ];
    LC_ALL = "en_US.UTF-8";
    checkPhase = ''
      PYTHON=${python.executable} make test
    '';

    buildInputs = with self; [ mock pkgs.glibcLocales ];
    propagatedBuildInputs = with self; [
      docutils jinja2 pygments sphinx_rtd_theme
      alabaster Babel snowballstemmer six nose
    ];

    meta = {
      description = "A tool that makes it easy to create intelligent and beautiful documentation for Python projects";
      homepage = http://sphinx.pocoo.org/;
      license = licenses.bsd3;
      platforms = platforms.unix;
    };
  });

  sphinx_1_2 = self.sphinx.override rec {
    name = "sphinx-1.2.3";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/s/sphinx/sphinx-1.2.3.tar.gz";
      sha256 = "94933b64e2fe0807da0612c574a021c0dac28c7bd3c4a23723ae5a39ea8f3d04";
    };
    patches = [];
    disabled = isPy35;
    # Tests requires Pygments >=2.0.2 which isn't worth keeping around for this:
    doCheck = false;
  };

  sphinx_rtd_theme = buildPythonPackage (rec {
    name = "sphinx_rtd_theme-0.1.8";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/s/sphinx_rtd_theme/${name}.tar.gz";
      sha256 = "12mnb7qscr07mllmyyqfpx37778sr21m8663b4fivnk17bnk7xkl";
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


  sphinxcontrib_httpdomain = buildPythonPackage (rec {
    name = "sphinxcontrib-httpdomain-1.3.0";

    # Check is disabled due to this issue:
    # https://bitbucket.org/pypa/setuptools/issue/137/typeerror-unorderable-types-str-nonetype
    doCheck = false;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/s/sphinxcontrib-httpdomain/${name}.tar.gz";
      sha256 = "ba8fbe82eddc96cfa9d7b975b0422801a14ace9d7e051b8b2c725b92ea6137b5";
    };

    propagatedBuildInputs = with self; [sphinx];

    meta = {
      description = "Provides a Sphinx domain for describing RESTful HTTP APIs";

      homepage = http://bitbucket.org/birkenfeld/sphinx-contrib;

      license = "BSD";
    };
  });


  sphinxcontrib_plantuml = buildPythonPackage (rec {
    name = "sphinxcontrib-plantuml-0.7";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/s/sphinxcontrib-plantuml/${name}.tar.gz";
      sha256 = "011yprqf41dcm1824zgk2w8vi9115286pmli6apwhlrsxc6b6cwv";
    };

    # No tests included.
    doCheck = false;

    propagatedBuildInputs = with self; [sphinx plantuml];

    meta = {
      description = "Provides a Sphinx domain for embedding UML diagram with PlantUML";
      homepage = http://bitbucket.org/birkenfeld/sphinx-contrib;
      license = with licenses; [ bsd2 ];
    };
  });


  sphinx_pypi_upload = buildPythonPackage (rec {
    name = "Sphinx-PyPI-upload-0.2.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/S/Sphinx-PyPI-upload/${name}.tar.gz";
      sha256 = "5f919a47ce7a7e6028dba809de81ae1297ac192347cf6fc54efca919d4865159";
    };

    meta = {
      description = "Setuptools command for uploading Sphinx documentation to PyPI";

      homepage = http://bitbucket.org/jezdez/sphinx-pypi-upload/;

      license = "BSD";
    };
  });

  spyder = callPackage ../applications/science/spyder {
    rope = if isPy3k then null else self.rope;
  };

  sqlalchemy7 = buildPythonPackage rec {
    name = "SQLAlchemy-0.7.10";
    disabled = isPy34 || isPy35;
    doCheck = !isPyPy;

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/S/SQLAlchemy/${name}.tar.gz";
      sha256 = "0rhxgr85xdhjn467qfs0dkyj8x46zxcv6ad3dfx3w14xbkb3kakp";
    };

    patches = [
      # see https://groups.google.com/forum/#!searchin/sqlalchemy/module$20logging$20handlers/sqlalchemy/ukuGhmQ2p6g/2_dOpBEYdDYJ
      # waiting for 0.7.11 release
      ../development/python-modules/sqlalchemy-0.7.10-test-failures.patch
    ];

    preConfigure = optionalString isPy3k ''
      python3 sa2to3.py --no-diffs -w lib test examples
    '';

    buildInputs = with self; [ nose mock ]
      ++ stdenv.lib.optional doCheck pysqlite;
    propagatedBuildInputs = with self; [ modules.sqlite3 ];

    checkPhase = ''
      ${python.executable} sqla_nose.py
    '';

    meta = {
      homepage = http://www.sqlalchemy.org/;
      description = "A Python SQL toolkit and Object Relational Mapper";
    };
  };

  sqlalchemy8 = buildPythonPackage rec {
    name = "SQLAlchemy-0.8.7";
    disabled = isPy34 || isPy35;
    doCheck = !isPyPy;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/S/SQLAlchemy/${name}.tar.gz";
      sha256 = "9edb47d137db42d57fd26673d6c841e189b1aeb9b566cca908962fcc8448c0bc";
    };

    preConfigure = optionalString isPy3k ''
      python3 sa2to3.py --no-diffs -w lib test examples
    '';

    buildInputs = with self; [ nose mock ]
      ++ stdenv.lib.optional doCheck pysqlite;
    propagatedBuildInputs = with self; [ modules.sqlite3 ];

    checkPhase = ''
      ${python.executable} sqla_nose.py
    '';

    meta = {
      homepage = http://www.sqlalchemy.org/;
      description = "A Python SQL toolkit and Object Relational Mapper";
    };
  };

  sqlalchemy9 = buildPythonPackage rec {
    name = "SQLAlchemy-0.9.9";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/S/SQLAlchemy/${name}.tar.gz";
      sha256 = "14az6hhrz4bgnicz4q373z119zmaf7j5zxl1jfbfl5lix5m1z9bj";
    };

    buildInputs = with self; [ nose mock ]
      ++ stdenv.lib.optional doCheck pysqlite;
    propagatedBuildInputs = with self; [ modules.sqlite3 ];

    # Test-only dependency pysqlite doesn't build on Python 3. This isn't an
    # acceptable reason to make all dependents unavailable on Python 3 as well
    doCheck = !(isPyPy || isPy3k);

    checkPhase = ''
      ${python.executable} sqla_nose.py
    '';

    meta = {
      homepage = http://www.sqlalchemy.org/;
      description = "A Python SQL toolkit and Object Relational Mapper";
    };
  };

  sqlalchemy = buildPythonPackage rec {
    name = "SQLAlchemy-${version}";
    version = "1.0.12";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/S/SQLAlchemy/${name}.tar.gz";
      sha256 = "1l8qclhd0s90w3pvwhi5mjxdwr5j7gw7cjka2fx6f2vqmq7f4yb6";
    };

    buildInputs = with self; [ nose mock ]
      ++ stdenv.lib.optional doCheck pysqlite;
    propagatedBuildInputs = with self; [ modules.sqlite3 ];

    # Test-only dependency pysqlite doesn't build on Python 3. This isn't an
    # acceptable reason to make all dependents unavailable on Python 3 as well
    doCheck = !(isPyPy || isPy3k);

    checkPhase = ''
      ${python.executable} sqla_nose.py
    '';

    meta = {
      homepage = http://www.sqlalchemy.org/;
      description = "A Python SQL toolkit and Object Relational Mapper";
      license = licenses.mit;
    };
  };

  sqlalchemy_imageattach = buildPythonPackage rec {
    name = "SQLAlchemy-ImageAttach-${version}";
    version = "0.8.2";
    disabled = isPy33;

    src = pkgs.fetchgit {
      url = https://github.com/crosspop/sqlalchemy-imageattach.git;
      rev = "refs/tags/${version}";
      md5 = "cffdcde30952176e35fccf385f579dda";
    };

    buildInputs = with self; [ pytest webob pkgs.imagemagick nose ];
    propagatedBuildInputs = with self; [ sqlalchemy8 wand ];

    checkPhase = ''
      cd tests
      export MAGICK_HOME="${pkgs.imagemagick}"
      export PYTHONPATH=$PYTHONPATH:../
      py.test
      cd ..
    '';
    doCheck = !isPyPy;  # failures due to sqla version mismatch

    meta = {
      homepage = https://github.com/crosspop/sqlalchemy-imageattach;
      description = "SQLAlchemy extension for attaching images to entity objects";
      license = licenses.mit;
    };
  };


  sqlalchemy_migrate_func = sqlalchemy: buildPythonPackage rec {
    name = "sqlalchemy-migrate-0.10.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/s/sqlalchemy-migrate/${name}.tar.gz";
      sha256 = "00z0lzjs4ksr9yr31zs26csyacjvavhpz6r74xaw1r89kk75qg7q";
    };

    buildInputs = with self; [ unittest2 scripttest pytz pkgs.pylint tempest-lib mock testtools ];
    propagatedBuildInputs = with self; [ pbr tempita decorator sqlalchemy six sqlparse ];

    checkPhase = ''
      export PATH=$PATH:$out/bin
      echo sqlite:///__tmp__ > test_db.cfg
      # depends on ibm_db_sa
      rm migrate/tests/changeset/databases/test_ibmdb2.py
      # wants very old testtools
      rm migrate/tests/versioning/test_schema.py
      # transient failures on py27
      substituteInPlace migrate/tests/versioning/test_util.py --replace "test_load_model" "noop"
      ${python.interpreter} setup.py test
    '';

    meta = {
      homepage = http://code.google.com/p/sqlalchemy-migrate/;
      description = "Schema migration tools for SQLAlchemy";
    };
  };

  sqlalchemy_migrate = self.sqlalchemy_migrate_func self.sqlalchemy;
  sqlalchemy_migrate_0_7 = self.sqlalchemy_migrate_func self.sqlalchemy7;

  sqlparse = buildPythonPackage rec {
    name = "sqlparse-${version}";
    version = "0.1.16";

    # the source wasn't transformed with 2to3 yet
    doCheck = !isPy3k;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/s/sqlparse/${name}.tar.gz";
      sha256 = "108gy82x7davjrn3jqn7yv4r5v4jrzp892ysfx8l00abr8v6r337";
    };

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

  statsmodels = buildPythonPackage rec {
    name = "statsmodels-${version}";
    version = "0.6.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/s/statsmodels/${name}.tar.gz";
      sha256 = "be4e44374aec9e848b73e5a230dee190ac0c4519e1d40f69a5813190b13ec676";
    };

    buildInputs = with self; [ nose ];
    propagatedBuildInputs = with self; [numpy scipy pandas patsy cython matplotlib];

    meta = {
      description = "Statistical computations and models for use with SciPy";
      homepage = "https://www.github.com/statsmodels/statsmodels";
      license = licenses.bsd3;
      maintainers = with maintainers; [ fridh ];
    };

    # Many tests fail when using latest numpy and pandas.
    # See also https://github.com/statsmodels/statsmodels/issues/2602
    doCheck = false;
  };

  python_statsd = buildPythonPackage rec {
    name = "python-statsd-${version}";
    version = "1.6.0";
    disabled = isPy3k;  # next release will be py3k compatible

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/python-statsd/${name}.tar.gz";
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
      url = "http://pypi.python.org/packages/source/s/stompclient/${name}.tar.gz";
      sha256 = "95a4e98dd0bba348714439ea11a25ee8a74acb8953f95a683924b5bf2a527e4e";
    };

    buildInputs = with self; [ mock nose ];

    # XXX: Ran 0 tests in 0.217s

    meta = {
      description = "Lightweight and extensible STOMP messaging client";
      homepage = http://bitbucket.org/hozn/stompclient;
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
      maintainers = with maintainers; [ DamienCassou ];
    };
  };

  subunit = buildPythonPackage rec {
    name = pkgs.subunit.name;
    src = pkgs.subunit.src;

    propagatedBuildInputs = with self; [ testtools testscenarios ];
    buildInputs = [ pkgs.pkgconfig pkgs.check pkgs.cppunit ];

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
      url = "http://pypi.python.org/packages/source/s/sure/${name}.tar.gz";
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
    name = "structlog-15.3.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/s/structlog/${name}.tar.gz";
      sha256 = "1h9qz4fsd7ph8rf80rqmlyj2q54xapgrmkpnyca01w1z8ww6f9w7";
    };

    buildInputs = with self; [ pytest pretend freezegun ];

    checkPhase = ''
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
      url = "https://pypi.python.org/packages/source/s/svgwrite/${name}.tar.gz";
      sha256 = "1f018813072aa4d7e95e58f133acb3f68fa7de0a0d89ec9402cc38406a0ec5b8";
    };

    buildInputs = with self; [ setuptools ];
    propagatedBuildInputs = with self; [ pyparsing ];

    meta = {
      description = "A Python library to create SVG drawings";
      homepage = http://bitbucket.org/mozman/svgwrite;
      license = licenses.mit;
    };
  };

  freezegun = buildPythonPackage rec {
    name = "freezegun-${version}";
    version = "0.3.5";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/f/freezegun/freezegun-${version}.tar.gz";
      sha256 = "02ly89wwn0plcw8clkkzvxaw6zlpm8qyqpm9x2mfw4a0vppb4ngf";
    };

    propagatedBuildInputs = with self; [
      dateutil six
    ];
    buildInputs = [ self.mock self.nose ];

    meta = with stdenv.lib; {
      description = "FreezeGun: Let your Python tests travel through time";
      homepage = "https://github.com/spulec/freezegun";
    };
  };

  syncthing-gtk = buildPythonPackage rec {
    version = "0.6.3";
    name = "syncthing-gtk-${version}";
    src = pkgs.fetchFromGitHub {
      owner = "syncthing";
      repo = "syncthing-gtk";
      rev = "v${version}";
      sha256 = "1qa5bw2qizjiqvkms8i31wsjf8cw9p0ciamxgfgq6n37wcalv6ms";
    };

    disabled = isPy3k;

    propagatedBuildInputs = with self; [ pkgs.syncthing dateutil pyinotify pkgs.libnotify pkgs.psmisc
      pygobject3 pkgs.gtk3 ];

    patchPhase = ''
      substituteInPlace "scripts/syncthing-gtk" \
              --replace "/usr/share" "$out/share"
      substituteInPlace setup.py --replace "version = get_version()" "version = '${version}'"
    '';

    meta = {
      description = " GTK3 & python based GUI for Syncthing ";
      maintainers = with maintainers; [ DamienCassou ];
      platforms = pkgs.syncthing.meta.platforms;
      homepage = "https://github.com/syncthing/syncthing-gtk";
      license = licenses.gpl2;
    };
  };

  systemd = buildPythonPackage rec {
    version = "231";
    name = "python-systemd-${version}";

    src = pkgs.fetchurl {
      url = "https://github.com/systemd/python-systemd/archive/v${version}.tar.gz";
      sha256 = "1sifq7mdg0y5ngab8vjy8995nz9c0hxny35dxs5qjx0k0hyzb71c";
    };

    buildInputs = with pkgs; [ systemd pkgconfig ];

    patchPhase = ''
      substituteInPlace setup.py \
          --replace "/usr/include" "${pkgs.systemd}/include"
      echo '#include <time.h>' >> systemd/pyutil.h
    '';

    meta = {
      description = "Python module for native access to the systemd facilities";
      homepage = http://www.freedesktop.org/software/systemd/python-systemd/;
      license = licenses.lgpl21;
    };
  };

  tabulate = buildPythonPackage rec {
    version = "0.7.5";
    name = "tabulate-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/t/tabulate/${name}.tar.gz";
      sha256 = "9071aacbd97a9a915096c1aaf0dc684ac2672904cd876db5904085d6dac9810e";
    };

    buildInputs = with self; [ nose ];

    # Tests: cannot import common (relative import).
    doCheck = false;

    meta = {
      description = "Pretty-print tabular data";
      homepage = https://bitbucket.org/astanin/python-tabulate;
      license = licenses.mit;
      maintainers = with maintainers; [ fridh ];
    };

  };

  targetcli_fb = buildPythonPackage rec {
    version = "2.1.fb33";
    name = "targetcli-fb-${version}";

    src = pkgs.fetchurl {
      url = "https://github.com/agrover/targetcli-fb/archive/v${version}.tar.gz";
      sha256 = "1zcm0agdpf866020b43fl8zyyyzz6r74mn1sz4xpaa0pinpwjk42";
    };

    propagatedBuildInputs = with self; [
      configshell_fb
      rtslib_fb
    ];

    meta = {
      description = "A command shell for managing the Linux LIO kernel target";
      homepage = "https://github.com/agrover/targetcli-fb";
      platforms = platforms.linux;
    };
  };

  tarsnapper = buildPythonPackage rec {
    name = "tarsnapper-0.2.1";
    disabled = isPy3k;

    src = pkgs.fetchgit {
      url = https://github.com/miracle2k/tarsnapper.git;
      rev = "620439bca68892f2ffaba1079a34b18496cc6596";
      sha256 = "06pp499qm2dxpja2jgmmq2jrcx3m4nq52x5hhil9r1jxvyiq962p";
    };

    propagatedBuildInputs = with self; [ argparse pyyaml ];

    patches = [ ../development/python-modules/tarsnapper-path.patch ];

    preConfigure = ''
      substituteInPlace src/tarsnapper/script.py \
        --replace '@NIXTARSNAPPATH@' '${pkgs.tarsnap}/bin/tarsnap'
    '';
  };

  taskcoach = buildPythonPackage rec {
    name = "TaskCoach-1.3.22";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "mirror://sourceforge/taskcoach/${name}.tar.gz";
      sha256 = "1ddx56bqmh347synhgjq625ijv5hqflr0apxg0nl4jqdsqk1zmxh";
    };

    propagatedBuildInputs = with self; [ wxPython ];

    # I don't know why I need to add these libraries. Shouldn't they
    # be part of wxPython?
    postInstall = ''
      libspaths=${pkgs.xorg.libSM}/lib:${pkgs.xorg.libXScrnSaver}/lib
      wrapProgram $out/bin/taskcoach.py \
        --prefix LD_LIBRARY_PATH : $libspaths
    '';

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://taskcoach.org/;
      description = "Todo manager to keep track of personal tasks and todo lists";
      license = licenses.gpl3Plus;
    };
  };

  taskw = buildPythonPackage rec {
    version = "1.0.3";
    name = "taskw-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/t/taskw/${name}.tar.gz";
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
      url = "http://pypi.python.org/packages/source/T/Tempita/Tempita-${version}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/t/terminado/${name}.tar.gz";
      sha256 = "2c0ba1f624067dccaaead7d2247cfe029806355cef124dc2ccb53c83229f0126";
    };

    propagatedBuildInputs = with self; [ ptyprocess tornado ];

    meta = {
      description = "Terminals served to term.js using Tornado websockets";
      homepage = https://github.com/takluyver/terminado;
      license = licenses.bsd2;
    };
  };

  keystoneclient = buildPythonPackage rec {
    name = "keystoneclient-${version}";
    version = "1.8.1";

    src = pkgs.fetchurl {
      url = "https://github.com/openstack/python-keystoneclient/archive/${version}.tar.gz";
      sha256 = "0lijri0xa5fvmynvq148z13kw4xd3bam4zrfd8aj0gb3lnzh9y6v";
    };

    PBR_VERSION = "${version}";

    buildInputs = with self; [
        pbr testtools testresources testrepository requests-mock fixtures pkgs.openssl
        oslotest pep8 ];
    propagatedBuildInputs = with self; [
        oslo-serialization oslo-config oslo-i18n oslo-utils
        Babel argparse prettytable requests2 six iso8601 stevedore
        netaddr debtcollector bandit webob mock pycrypto ];

    patchPhase = ''
      sed -i 's@python@${python.interpreter}@' .testr.conf
    '';
    doCheck = false;

    meta = {
      homepage = https://github.com/openstack/python-novaclient/;
      description = "Client library and command line tool for the OpenStack Nova API";
      license = stdenv.lib.licenses.asl20;
      platforms = stdenv.lib.platforms.linux;
    };
  };

  keystonemiddleware = buildPythonPackage rec {
    name = "keystonemiddleware-${version}";
    version = "2.4.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/k/keystonemiddleware/${name}.tar.gz";
      sha256 = "0avrn1f897rnam9wfdanpdwsmn8is3ncfh3nnzq3d1m31b1yqqr6";
    };

    buildInputs = with self; [
      fixtures mock pycrypto oslosphinx oslotest stevedore testrepository
      testresources testtools bandit requests-mock memcached
      pkgs.openssl
    ];
    propagatedBuildInputs = with self; [
      pbr Babel oslo-config oslo-context oslo-i18n oslo-serialization oslo-utils
      requests2 six webob keystoneclient pycadf oslo-messaging
    ];

    # lots of "unhashable type" errors
    doCheck = false;
  };

  testscenarios = buildPythonPackage rec {
    name = "testscenarios-${version}";
    version = "0.4";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/t/testscenarios/${name}.tar.gz";
      sha256 = "1671jvrvqlmbnc42j7pc5y6vc37q44aiwrq0zic652pxyy2fxvjg";
    };

    propagatedBuildInputs = with self; [ testtools ];

    meta = {
      description = "a pyunit extension for dependency injection";
      homepage = https://pypi.python.org/pypi/testscenarios;
      license = licenses.asl20;
    };
  };

  testrepository = buildPythonPackage rec {
    name = "testrepository-${version}";
    version = "0.0.20";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/t/testrepository/${name}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/t/testresources/${name}.tar.gz";
      sha256 = "0cbj3plbllyz42c4b5xxgwaa7mml54lakslrn4kkhinxhdri22md";
    };

    meta = {
      description = "Pyunit extension for managing expensive test resources";
      homepage = https://pypi.python.org/pypi/testresources/;
      license = licenses.bsd2;
    };
  };

  testtools = buildPythonPackage rec {
    name = "testtools-${version}";
    version = "1.8.0";

    # Python 2 only judging from SyntaxError
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/t/testtools/${name}.tar.gz";
      sha256 = "15yxz8d70iy1b1x6gd7spvblq0mjxjardl4vnaqasxafzc069zca";
    };

    propagatedBuildInputs = with self; [ pbr python_mimeparse extras lxml unittest2 ];
    buildInputs = with self; [ traceback2 ];
    patches = [ ../development/python-modules/testtools_support_unittest2.patch ];

    meta = {
      description = "A set of extensions to the Python standard library's unit testing framework";
      homepage = http://pypi.python.org/pypi/testtools;
      license = licenses.mit;
    };
  };

  traitlets = buildPythonPackage rec {
    version = "4.1.0";
    name = "traitlets-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/t/traitlets/${name}.tar.gz";
      sha256 = "440e38dfa5d2a26c086d4b427cfb7aed17d0a2dca78bce90c33354da2592af5b";
    };

    buildInputs = with self; [ nose mock ];
    propagatedBuildInputs = with self; [ipython_genutils decorator];

    checkPhase = ''
      nosetests -v
    '';

    meta = {
      description = "Traitlets Python config system";
      homepage = http://ipython.org/;
      license = licenses.bsd3;
      maintainers = with maintainers; [ fridh ];
    };
  };

  python_mimeparse = buildPythonPackage rec {
    name = "python-mimeparse-${version}";
    version = "0.1.4";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/python-mimeparse/${name}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/e/extras/extras-${version}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/t/texttable/${name}.tar.gz";
      sha256 = "0bkhs4dx9s6g7fpb969hygq56hyz4ncfamlynw72s0n6nqfbd1w5";
    };

    meta = {
      description = "A module to generate a formatted text table, using ASCII characters";
      homepage = http://foutaise.org/code/;
      license = licenses.lgpl2;
    };
  };

  tlslite = buildPythonPackage rec {
    name = "tlslite-${version}";
    version = "0.4.8";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/t/tlslite/${name}.tar.gz";
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
    version = "5.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/q/qrcode/${name}.tar.gz";
      sha256 = "0skzrvhjnnacrz52jml4i050vdx5lfcd3np172srxjaghdgfxg9k";
    };

    # Errors in several tests:
    # TypeError: must be str, not bytes
    disabled = isPy3k;

    propagatedBuildInputs = with self; [ six pillow ];

    meta = {
      description = "Quick Response code generation for Python";
      home = "https://pypi.python.org/pypi/qrcode";
      license = licenses.bsd3;
    };
  };

  tmdb3 = buildPythonPackage rec {
    name = "tmdb3-${version}";
    version = "0.6.17";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/t/tmdb3/${name}.zip";
      sha256 = "64a6c3f1a60a9d8bf18f96a5403f3735b334040345ac3646064931c209720972";
    };

    meta = {
      description = "Python implementation of the v3 API for TheMovieDB.org, allowing access to movie and cast information";
      homepage = http://pypi.python.org/pypi/tmdb3;
      license = licenses.bsd3;
    };
  };

  toolz = buildPythonPackage rec{
    name = "toolz-${version}";
    version = "0.7.4";

    src = pkgs.fetchurl{
      url = "https://pypi.python.org/packages/source/t/toolz/toolz-${version}.tar.gz";
      sha256 = "43c2c9e5e7a16b6c88ba3088a9bfc82f7db8e13378be7c78d6c14a5f8ed05afd";
    };

    buildInputs = with self; [ nose ];

    checkPhase = ''
      nosetests toolz/tests
    '';

    meta = {
      homepage = "http://github.com/pytoolz/toolz/";
      description = "List processing tools and functional utilities";
      license = "licenses.bsd3";
      maintainers = with maintainers; [ fridh ];
    };
  };

  tox = buildPythonPackage rec {
    name = "tox-${version}";
    version = "2.3.1";

    propagatedBuildInputs = with self; [ py virtualenv pluggy ];

    doCheck = false;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/t/tox/${name}.tar.gz";
      sha256 = "1vj73ar4rimq3fwy5r2z3jv4g9qbh8rmpmncsc00g0k310acqzxz";
    };
  };

  tqdm = buildPythonPackage rec {
    name = "tqdm-${version}";
    version = "3.7.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/t/tqdm/${name}.tar.gz";
      sha256 = "f12d792685f779e8754e623aff1a25a93b98a90457e3a2b7eb89b4401c2c239e";
    };

    buildInputs = with self; [ nose coverage pkgs.glibcLocales flake8 ];
    propagatedBuildInputs = with self; [ matplotlib pandas ];

    LC_ALL="en_US.UTF-8";

    doCheck = false; # Many transient failures in performance tests and due to use of sleep

    meta = {
      description = "A Fast, Extensible Progress Meter";
      homepage = https://github.com/tqdm/tqdm;
      license = with licenses; [ mit ];
    };
  };

  smmap = buildPythonPackage rec {
    name = "smmap-0.9.0";
    disabled = isPyPy;  # This fails the tests if built with pypy
    meta.maintainers = with maintainers; [ mornfall ];

    buildInputs = with self; [ nosexcover ];

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/s/smmap/${name}.tar.gz";
      sha256 = "0qlx25f6n2n9ff37w9gg62f217fzj16xlbh0pkz0lpxxjys64aqf";
    };
  };

  trac = buildPythonPackage {
    name = "trac-1.0.1";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = http://ftp.edgewall.com/pub/trac/Trac-1.0.1.tar.gz;
      sha256 = "1nqa95fcnkpyq4jk6az7l7sqgm3b3pjq3bx1n7y4v3bad5jr1m4x";
    };

    # couple of failing tests
    doCheck = false;

    PYTHON_EGG_CACHE = "`pwd`/.egg-cache";

    propagatedBuildInputs = with self; [ genshi pkgs.setuptools modules.sqlite3 ];

    meta = {
      description = "Enhanced wiki and issue tracking system for software development projects";

      license = "BSD";
    };
  };

  traits = buildPythonPackage rec {
    name = "traits-${version}";
    version = "4.5.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/t/traits/${name}.tar.gz";
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
      description = "explicitly typed attributes for Python";
      homepage = http://pypi.python.org/pypi/traits;
      license = "BSD";
    };
  };


  transaction = buildPythonPackage rec {
    name = "transaction-${version}";
    version = "1.4.3";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/t/transaction/${name}.tar.gz";
      sha256 = "1b2304a886a85ad014f73d93346c14350fc214ae22a4f565f42f6761cfb9ecc5";
    };

    propagatedBuildInputs = with self; [ zope_interface ];

    meta = {
      description = "Transaction management";
      homepage = http://pypi.python.org/pypi/transaction;
      license = licenses.zpt20;
    };
  };

  transmissionrpc = buildPythonPackage rec {
    name = "transmissionrpc-${version}";
    version = "0.11";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/t/transmissionrpc/${name}.tar.gz";
      sha256 = "ec43b460f9fde2faedbfa6d663ef495b3fd69df855a135eebe8f8a741c0dde60";
    };

    propagatedBuildInputs = with self; [ six ];

    meta = {
      description = "Python implementation of the Transmission bittorent client RPC protocol";
      homepage = http://pypi.python.org/pypi/transmissionrpc/;
      license = licenses.mit;
    };
  };

  eggdeps  = buildPythonPackage rec {
     name = "eggdeps-${version}";
     version = "0.4";

     src = pkgs.fetchurl {
       url = "http://pypi.python.org/packages/source/t/tl.eggdeps/tl.${name}.tar.gz";
       sha256 = "a99de5e4652865224daab09b2e2574a4f7c1d0d9a267048f9836aa914a2caf3a";
     };

     # tests fail, see http://hydra.nixos.org/build/4316603/log/raw
     doCheck = false;

     propagatedBuildInputs = with self; [ zope_interface zope_testing ];
     meta = {
       description = "A tool which computes a dependency graph between active Python eggs";
       homepage = http://thomas-lotze.de/en/software/eggdeps/;
       license = licenses.zpt20;
     };
   };


  turses = buildPythonPackage (rec {
    name = "turses-0.3.1";
    disabled = isPyPy || isPy3k;

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/t/turses/${name}.tar.gz";
      sha256 = "15mkhm3b5ka42h8qph0mhh8izfc1200v7651c62k7ldcs50ib9j6";
    };

    buildInputs = with self; [ mock pytest coverage tox ];
    propagatedBuildInputs = with self; [ urwid tweepy future ] ++ optional isPy26 argparse;

    checkPhase = ''
      TMP_TURSES=`echo turses-$RANDOM`
      mkdir $TMP_TURSES
      HOME=$TMP_TURSES py.test tests/
      rm -rf $TMP_TURSES
    '';

    patchPhase = ''
      sed -i -e "s|future==0.14.3|future==${pkgs.lib.getVersion self.future}|" setup.py
      sed -i -e "s|tweepy==3.3.0|tweepy==${pkgs.lib.getVersion self.tweepy}|" setup.py
      sed -i -e "s|config.generate_config_file.assert_called_once()|assert config.generate_config_file.call_count == 1|" tests/test_config.py
      sed -i -e "s|self.observer.update.assert_called_once()|assert self.observer.update.call_count == 1|" tests/test_meta.py
    '';

    meta = {
      homepage = https://github.com/alejandrogomez/turses;
      description = "A Twitter client for the console";
      license = licenses.gpl3;
      maintainers = with maintainers; [ garbas ];
      platforms = platforms.linux;
    };
  });

  tweepy = buildPythonPackage (rec {
    name = "tweepy-3.5.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/t/tweepy/${name}.tar.gz";
      sha256 = "0n2shilamgwhzmvf534xg7f6hrnznbixyl5pw2f5a3f391gwy37h";
    };

    propagatedBuildInputs = with self; [ requests2 six requests_oauthlib ];

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
      url    = "https://pypi.python.org/packages/source/T/Twiggy/Twiggy-0.4.5.tar.gz";
      # md5 = "b0dfbbb7f56342e448af4d22a47a339c"; # provided by pypi website.
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

  twitter = buildPythonPackage rec {
    name = "twitter-${version}";
    version = "1.15.0";

    src = pkgs.fetchurl {
      url    = "https://pypi.python.org/packages/source/t/twitter/${name}.tar.gz";
      sha256 = "1m6b17irb9klc345k8174pni724jzy2973z2x2jg69h83hipjw2c";
    };

    doCheck = false;

    meta = {
      description = "Twitter API library";
      license     = licenses.mit;
      maintainers = with maintainers; [ thoughtpolice ];
    };
  };

  twisted_11 = buildPythonPackage rec {
    # NOTE: When updating please check if new versions still cause issues
    # to packages like carbon (http://stackoverflow.com/questions/19894708/cant-start-carbon-12-04-python-error-importerror-cannot-import-name-daem)
    disabled = isPy3k;

    name = "Twisted-13.2.0";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/T/Twisted/${name}.tar.bz2";
      sha256 = "1wrcqv5lvgwk2aq83qb2s2ng2vx14hbjjk2gc30cg6h1iiipal89";
    };

    propagatedBuildInputs = with self; [ zope_interface ];

    # Generate Twisted's plug-in cache.  Twited users must do it as well.  See
    # http://twistedmatrix.com/documents/current/core/howto/plugin.html#auto3
    # and http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=477103 for
    # details.
    postInstall = "$out/bin/twistd --help > /dev/null";

    meta = {
      homepage = http://twistedmatrix.com/;
      description = "Twisted, an event-driven networking engine written in Python";
      longDescription = ''
        Twisted is an event-driven networking engine written in Python
        and licensed under the MIT license.
      '';
      license = licenses.mit;
      maintainers = [ ];
    };
  };

  twisted = buildPythonPackage rec {
    disabled = isPy3k;

    name = "Twisted-15.5.0";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/T/Twisted/${name}.tar.bz2";
      sha256 = "0zy18lcrris4aaslil5k12i13k56c32hzfdv6h10kbnzl026h158";
    };

    propagatedBuildInputs = with self; [ zope_interface ];

    # Generate Twisted's plug-in cache.  Twited users must do it as well.  See
    # http://twistedmatrix.com/documents/current/core/howto/plugin.html#auto3
    # and http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=477103 for
    # details.
    postInstall = "$out/bin/twistd --help > /dev/null";

    meta = {
      homepage = http://twistedmatrix.com/;
      description = "Twisted, an event-driven networking engine written in Python";
      longDescription = ''
        Twisted is an event-driven networking engine written in Python
        and licensed under the MIT license.
      '';
      license = licenses.mit;
      maintainers = [ ];
    };
  };

  tzlocal = buildPythonPackage rec {
    name = "tzlocal-1.1.1";

    propagatedBuildInputs = with self; [ pytz ];

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/t/tzlocal/tzlocal-1.1.1.zip";
      sha256 = "696bfd8d7c888de039af6c6fdf86fd52e32508277d89c75d200eb2c150487ed4";
    };

     # test fail (timezone test fail)
     doCheck = false;

    meta = with pkgs.stdenv.lib; {
      description = "Tzinfo object for the local timezone";
      homepage = https://github.com/regebro/tzlocal;
      license = licenses.cddl;
    };
  };

  umalqurra = buildPythonPackage rec {
    name = "umalqurra-${version}";
    version = "0.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/u/umalqurra/umalqurra-0.2.tar.gz";
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

  umemcache = buildPythonPackage rec {
    name = "umemcache-${version}";
    version = "1.6.3";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/u/umemcache/${name}.zip";
      sha256 = "211031a03576b7796bf277dbc9c9e3e754ba066bbb7fb601ab5c6291b8ec1918";
    };

    meta = {
      description = "Ultra fast memcache client written in highly optimized C++ with Python bindings";
      homepage = https://github.com/esnme/ultramemcache;
      license = licenses.bsdOriginal;
    };
  };

  unicodecsv = buildPythonPackage rec {
    version = "0.14.1";
    name = "unicodecsv-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/u/unicodecsv/${name}.tar.gz";
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
      url = "http://pypi.python.org/packages/source/u/unittest2/unittest2-${version}.tar.gz";
      sha256 = "0y855kmx7a8rnf81d3lh5lyxai1908xjp0laf4glwa4c8472m212";
    };

    # # 1.0.0 and up create a circle dependency with traceback2/pbr
    doCheck = false;

    patchPhase = ''
      # # fixes a transient error when collecting tests, see https://bugs.launchpad.net/python-neutronclient/+bug/1508547
      sed -i '510i\        return None, False' unittest2/loader.py
      # https://github.com/pypa/packaging/pull/36
      sed -i 's/version=VERSION/version=str(VERSION)/' setup.py
    '';

    propagatedBuildInputs = with self; [ six argparse traceback2 ];

    meta = {
      description = "A backport of the new features added to the unittest testing framework";
      homepage = http://pypi.python.org/pypi/unittest2;
    };
  };

  uritemplate_py = buildPythonPackage rec {
    name = "uritemplate.py-${version}";
    version = "0.3.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/u/uritemplate.py/${name}.tar.gz";
      sha256 = "0xvvdiwnag2pdi96hjf7v8asdia98flk2rxcjqnwcs3rk99alygx";
    };

    meta = with stdenv.lib; {
      homepage = https://github.com/uri-templates/uritemplate-py;
      description = "Python implementation of URI Template";
      license = licenses.asl20;
      maintainers = with maintainers; [ pSub ];
    };
  };

  traceback2 = buildPythonPackage rec {
    version = "1.4.0";
    name = "traceback2-${version}";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/t/traceback2/traceback2-${version}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/l/linecache2/${name}.tar.gz";
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

  update_checker = buildPythonPackage rec {
    name = "update_checker-0.11";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/u/update_checker/${name}.tar.gz";
      sha256 = "681bc7c26cffd1564eb6f0f3170d975a31c2a9f2224a32f80fe954232b86f173";
    };

    propagatedBuildInputs = with self; [ requests2 ];

    doCheck = false;

    meta = {
      description = "A python module that will check for package updates";
      homepage = https://github.com/bboe/update_checker;
      license = licenses.bsd2;
    };
  };

  urlgrabber =  buildPythonPackage rec {
    name = "urlgrabber-3.9.1";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "http://urlgrabber.baseurl.org/download/${name}.tar.gz";
      sha256 = "4437076c8708e5754ea04540e46c7f4f233734ee3590bb8a96389264fb0650d0";
    };

    # error: invalid command 'test'
    doCheck = false;

    propagatedBuildInputs = with self; [ pycurl ];

    meta = {
      homepage = "urlgrabber.baseurl.org";
      license = licenses.lgpl2Plus;
      description = "Python module for downloading files";
      maintainers = with maintainers; [ qknight ];
    };
  };


  urwid = buildPythonPackage (rec {
    name = "urwid-1.3.0";

    # multiple:  NameError: name 'evl' is not defined
    doCheck = false;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/u/urwid/${name}.tar.gz";
      sha256 = "29f04fad3bf0a79c5491f7ebec2d50fa086e9d16359896c9204c6a92bc07aba2";
    };

    meta = {
      description = "A full-featured console (xterm et al.) user interface library";
      homepage = http://excess.org/urwid;
      repositories.git = git://github.com/wardi/urwid.git;
      license = licenses.lgpl21;
      maintainers = with maintainers; [ garbas ];
    };
  });

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
    name = "pyuv-0.11.5";
    disabled = isPyPy;  # see https://github.com/saghul/pyuv/issues/49

    src = pkgs.fetchurl {
      url = "https://github.com/saghul/pyuv/archive/${name}.tar.gz";
      sha256 = "c251952cb4e54c92ab0e871decd13cf73d11ca5dba9f92962de51d12e3a310a9";
    };

    patches = [ ../development/python-modules/pyuv-external-libuv.patch ];

    buildInputs = with self; [ pkgs.libuvVersions.v0_11_29 ];

    meta = {
      description = "Python interface for libuv";
      homepage = https://github.com/saghul/pyuv;
      repositories.git = git://github.com/saghul/pyuv.git;
      license = licenses.mit;
    };
  };

  virtual-display = buildPythonPackage rec {
    name = "PyVirtualDisplay-0.1.5";

    propagatedBuildInputs = with self; [ easy-process ];

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/P/PyVirtualDisplay/${name}.tar.gz";
      sha256 = "aa6aef08995e14c20cc670d933bfa6e70d736d0b555af309b2e989e2faa9ee53";
    };

    meta = {
      description = "python wrapper for Xvfb, Xephyr and Xvnc";
      homepage = "https://github.com/ponty/pyvirtualdisplay";
      license = licenses.bsdOriginal;
      maintainers = with maintainers; [ layus ];
    };
  };

  virtualenv = buildPythonPackage rec {
    name = "virtualenv-13.1.2";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/v/virtualenv/${name}.tar.gz";
      sha256 = "1p732accxwqfjbdna39k8w8lp9gyw91vr4kzkhm8mgfxikqqxg5a";
    };

    pythonPath = [ self.recursivePthLoader ];

    patches = [ ../development/python-modules/virtualenv-change-prefix.patch ];

    propagatedBuildInputs = with self; [ modules.readline modules.sqlite3 modules.curses ];

    # Tarball doesn't contain tests
    doCheck = false;

    meta = {
      description = "a tool to create isolated Python environments";
      homepage = http://www.virtualenv.org;
      license = licenses.mit;
      maintainers = with maintainers; [ goibhniu ];
    };
  };

  virtualenv-clone = buildPythonPackage rec {
    name = "virtualenv-clone-0.2.5";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/v/virtualenv-clone/${name}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/v/virtualenvwrapper/${name}.tar.gz";
      sha256 = "514cbc22218347bf7b54bdbe49e1a5f550d2d53b1ad2491c10e91ddf48fb528f";
    };

    # pip depend on $HOME setting
    preConfigure = "export HOME=$TMPDIR";

    buildInputs = with self; [ pbr pip pkgs.which ];
    propagatedBuildInputs = with self; [
      stevedore
      virtualenv
      virtualenv-clone
    ] ++ optional isPy26 argparse;

    patchPhase = ''
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

        cat > "$wrapper" <<- EOF
	export PATH="$PATH:\$PATH"
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

  vultr = buildPythonPackage rec {
    version = "0.1.2";
    name = "vultr-${version}";

    src = pkgs.fetchFromGitHub {
        owner = "spry-group";
        repo = "python-vultr";
        rev = "${version}";
        sha256 = "1qjvvr2v9gfnwskdl0ayazpcmiyw9zlgnijnhgq9mcri5gq9jw5h";
    };

    propagatedBuildInputs = with self; [ requests2 ];

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
    name = "waitress-0.8.9";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/w/waitress/${name}.tar.gz";
      sha256 = "826527dc9d334ed4ed76cdae672fdcbbccf614186657db71679ab58df869458a";
    };

    doCheck = false;

    meta = {
       maintainers = with maintainers; [ garbas iElectric ];
       platforms = platforms.all;
    };
  };

  webassets = buildPythonPackage rec {
    name = "webassets-${version}";
    version = "0.11.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/w/webassets/${name}.tar.gz";
      sha256 = "0p1qypcbq9b88ipcylxh3bbnby5n6dr421wb4bwmrlcrgvj4r5lz";
    };

    propagatedBuildInputs = with self; [ pyyaml ];

    meta = {
      description = "Media asset management for Python, with glue code for various web frameworks";
      homepage = http://github.com/miracle2k/webassets/;
      license = licenses.bsd2;
      platforms = platforms.all;
      maintainers = with maintainers; [ abbradar ];
    };
  };

  webcolors = buildPythonPackage rec {
    name = "webcolors-1.4";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/w/webcolors/${name}.tar.gz";
      sha256 = "304fc95dab2848c7bf64f378356766e692c2f8b4a8b15fa3509544e6412936e8";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      description = "Library for working with color names/values defined by the HTML and CSS specifications";
      homepage = https://bitbucket.org/ubernostrum/webcolors/overview/;
      license = licenses.bsd3;
      platforms = platforms.linux;
    };
  };


  wand = buildPythonPackage rec {
    name = "Wand-0.3.5";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/W/Wand/${name}.tar.gz";
      sha256 = "31e2186ce8d1da0d2ea84d1428fc4d441c2e9d0e25156cc746b35b781026bcff";
    };

    buildInputs = with self; [ pkgs.imagemagick pytest psutil memory_profiler pytest_xdist ];

    meta = {
      description = "Ctypes-based simple MagickWand API binding for Python";
      homepage = http://wand-py.org/;
      platforms = platforms.all;
    };
  };


  wcwidth = buildPythonPackage rec {
    name = "wcwidth-${version}";
    version = "0.1.4";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/w/wcwidth/${name}.tar.gz";
      sha256 = "0awx28xi938nv55qlmai3b5ddqd1w5c294gy95xh4xsx0hik2vch";
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
      url = "https://pypi.python.org/packages/source/w/web.py/web.py-${version}.tar.gz";
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
    version = "1.4.1";
    name = "webob-${version}";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/W/WebOb/WebOb-${version}.tar.gz";
      sha256 = "1nz9m6ijf46wfn33zfza13c0k1n4kjnmn3icdlrlgz5yj21vky0j";
    };

    propagatedBuildInputs = with self; [ nose ];

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
      url = "http://pypi.python.org/packages/source/w/websockify/websockify-${version}.tar.gz";
      sha256 = "1v6pmamjprv2x55fvbdaml26ppxdw8v6xz8p0sav3368ajwwgcqc";
    };

    propagatedBuildInputs = with self; [ numpy ];

    meta = {
      description = "WebSockets support for any application/server";
      homepage = https://github.com/kanaka/websockify;
    };
  };


  webtest = buildPythonPackage rec {
    version = "2.0.15";
    name = "webtest-${version}";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/W/WebTest/WebTest-${version}.zip";
      sha256 = "c320adc2cd862ea71ca9e2012e6157eb12f5f8d1632d1541f2eabf984aaa3ecc";
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


  werkzeug = buildPythonPackage rec {
    name = "Werkzeug-0.10.4";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/W/Werkzeug/${name}.tar.gz";
      sha256 = "9d2771e4c89be127bc4bac056ab7ceaf0e0064c723d6b6e195739c3af4fd5c1d";
    };

    propagatedBuildInputs = with self; [ itsdangerous ];

    doCheck = false;            # tests fail, not sure why

    meta = {
      homepage = http://werkzeug.pocoo.org/;
      description = "A WSGI utility library for Python";
      license = "BSD";
    };
  };

  wheel = buildPythonPackage rec {
    name = "wheel-${version}";
    version = "0.29.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/w/wheel/${name}.tar.gz";
      sha256 = "1ebb8ad7e26b448e9caa4773d2357849bf80ff9e313964bcaf79cbf0201a1648";
    };

    buildInputs = with self; [ pytest pytestcov coverage ];

    propagatedBuildInputs = with self; [ jsonschema ];

    meta = {
      description = "A built-package format for Python";
      license = with licenses; [ mit ];
      homepage = https://bitbucket.org/pypa/wheel/;
    };
  };

  willie = buildPythonPackage rec {
    name = "willie-5.2.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/w/willie/willie-5.2.0.tar.gz";
      sha256 = "2da2e91b65c471b4c8e5e5e11471b25887635258d24aaf76b5354147b3ab577d";
    };

    propagatedBuildInputs = with self; [ feedparser pytz lxml praw pyenchant pygeoip backports_ssl_match_hostname_3_4_0_2 ];

    meta = {
      description = "A simple, lightweight, open source, easy-to-use IRC utility bot, written in Python";
      homepage = http://willie.dftba.net/;
      license = licenses.efl20;
    };
  };

  wokkel = buildPythonPackage (rec {
    url = "http://wokkel.ik.nu/releases/0.7.0/wokkel-0.7.0.tar.gz";
    name = nameFromURL url ".tar";
    src = pkgs.fetchurl {
      inherit url;
      sha256 = "0rnshrzw8605x05mpd8ndrx3ri8h6cx713mp8sl4f04f4gcrz8ml";
    };

    propagatedBuildInputs = with self; [twisted dateutil];

    meta = {
      description = "Some (mainly XMPP-related) additions to twisted";
      homepage = "http://wokkel.ik.nu/";
      license = licenses.mit;
    };
  });


  wsgiproxy2 = buildPythonPackage rec {
    name = "WSGIProxy2-0.4.2";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/W/WSGIProxy2/${name}.zip";
      sha256 = "13kf9bdxrc95y9vriaz0viry3ah11nz4rlrykcfvb8nlqpx3dcm4";
    };

    # circular dep on webtest
    doCheck = false;
    propagatedBuildInputs = with self; [ six webob ];

    meta = {
      maintainers = with maintainers; [ garbas iElectric ];
    };
  };

  wxPython = self.wxPython28;

  wxPython28 = import ../development/python-modules/wxPython/2.8.nix {
    inherit callPackage;
    wxGTK = pkgs.wxGTK28;
  };

  wxPython30 = import ../development/python-modules/wxPython/3.0.nix {
    inherit callPackage;
    wxGTK = pkgs.wxGTK30;
  };

  xcaplib = buildPythonPackage rec {
    name = "python-xcaplib-${version}";
    version = "1.1.0";

    src = pkgs.fetchurl {
      url = "http://download.ag-projects.com/XCAP/${name}.tar.gz";
      sha256 = "2f8ea6fe7d005104ef1d854aa87bd8ee85ca242a70cde42f409f8e5557f864b3";
    };

    propagatedBuildInputs = with self; [ eventlib application ];
  };

  xe = buildPythonPackage rec {
    url = "http://www.blarg.net/%7Esteveha/xe-0.7.4.tar.gz";
    name = stdenv.lib.nameFromURL url ".tar";
    src = pkgs.fetchurl {
      inherit url;
      sha256 = "0v9878cl0y9cczdsr6xjy8v9l139lc23h4m5f86p4kpf2wlnpi42";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = "http://home.blarg.net/~steveha/xe.html";
      description = "XML elements";
    };
  };

  xlib = buildPythonPackage (rec {
    name = "xlib-0.15rc1";

    src = pkgs.fetchurl {
      url = "mirror://sourceforge/python-xlib/python-${name}.tar.bz2";
      sha256 = "0mvzz605pxzj7lfp2w6z4qglmr4rjza9xrb7sl8yn12cklzfky0m";
    };

    # Tests require `pyutil' so disable them to avoid circular references.
    doCheck = false;

    propagatedBuildInputs = with self; [ pkgs.xorg.libX11 ];

    meta = {
      description = "Fully functional X client library for Python programs";

      homepage = http://python-xlib.sourceforge.net/;

      license = licenses.gpl2Plus;
    };
  });

  xmltodict = buildPythonPackage (rec {
    name = "xmltodict-0.9.2";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/x/xmltodict/${name}.tar.gz";
      sha256 = "00crqnjh1kbvcgfnn3b8c7vq30lf4ykkxp1xf3pf7mswr5l1wp97";
    };

    buildInputs = with self; [ coverage nose ];

    meta = {
      description = "Makes working with XML feel like you are working with JSON";
      homepage = https://github.com/martinblech/xmltodict;
      license = licenses.mit;
    };
  });

  xarray = buildPythonPackage rec {
    name = "xarray-${version}";
    version = "0.7.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/x/xarray/${name}.tar.gz";
      sha256 = "1swcpq8x0p5pp94r9j4hr2anz1rqh7fnqax16xn9xsgrikdjipj5";
    };

    buildInputs = with self; [ pytest ];
    propagatedBuildInputs = with self; [numpy pandas];

    checkPhase = ''
      py.test $out/${python.sitePackages}
    '';

    meta = {
      description = "N-D labeled arrays and datasets in Python";
      homepage = https://github.com/pydata/xarray;
      license = licenses.asl20;
      maintainers = with maintainers; [ fridh ];
    };
  };

  xlwt = buildPythonPackage rec {
    name = "xlwt-${version}";
    version = "1.0.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/x/xlwt/${name}.tar.gz";
      sha256 = "1y8w5imsicp01gn749qhw6j0grh9y19zz57ribwaknn8xqwjjhxc";
    };

    buildInputs = with self; [ nose ];
    checkPhase = ''
      nosetests -v
    '';

    meta = {
      description = "Library to create spreadsheet files compatible with MS";
      homepage = https://github.com/python-excel/xlwt;
      license = with licenses; [ bsdOriginal bsd3 lgpl21 ];
    };
  };

  youtube-dl = callPackage ../tools/misc/youtube-dl {
    # Release versions don't need pandoc because the formatted man page
    # is included in the tarball.
    pandoc = null;
  };

  youtube-dl-light = callPackage ../tools/misc/youtube-dl {
    # Release versions don't need pandoc because the formatted man page
    # is included in the tarball.
    ffmpeg = null;
    pandoc = null;
  };

  zbase32 = buildPythonPackage (rec {
    name = "zbase32-1.1.2";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zbase32/${name}.tar.gz";
      sha256 = "2f44b338f750bd37b56e7887591bf2f1965bfa79f163b6afcbccf28da642ec56";
    };

    # Tests require `pyutil' so disable them to avoid circular references.
    doCheck = false;

    propagatedBuildInputs = with self; [ setuptoolsDarcs ];

    meta = {
      description = "zbase32, a base32 encoder/decoder";
      homepage = http://pypi.python.org/pypi/zbase32;
      license = "BSD";
    };
  });

  zconfig = buildPythonPackage rec {
    name = "zconfig-${version}";
    version = "3.0.3";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/Z/ZConfig/ZConfig-${version}.tar.gz";
      sha256 = "6577da957511d8c2f805fefd2e31cacc4117bb5c54aec03ad8ce374020c021f3";
    };

    propagatedBuildInputs = with self; [ zope_testrunner ];

    meta = {
      description = "Structured Configuration Library";
      homepage = http://pypi.python.org/pypi/ZConfig;
      license = licenses.zpt20;
      maintainers = with maintainers; [ goibhniu ];
    };
  };


  zc_lockfile = buildPythonPackage rec {
    name = "zc.lockfile-${version}";
    version = "1.0.2";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zc.lockfile/${name}.tar.gz";
      sha256 = "96bb2aa0438f3e29a31e4702316f832ec1482837daef729a92e28c202d8fba5c";
    };

    meta = {
      description = "Inter-process locks";
      homepage =  http://www.python.org/pypi/zc.lockfile;
      license = licenses.zpt20;
      maintainers = with maintainers; [ goibhniu ];
    };
  };


  zdaemon = buildPythonPackage rec {
    name = "zdaemon-${version}";
    version = "4.0.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zdaemon/${name}.tar.gz";
      sha256 = "82d7eaa4d831ff1ecdcffcb274f3457e095c0cc86e630bc72009a863c341ab9f";
    };

    propagatedBuildInputs = [ self.zconfig ];

    # too many deps..
    doCheck = false;

    meta = {
      description = "A daemon process control library and tools for Unix-based systems";
      homepage = http://pypi.python.org/pypi/zdaemon;
      license = licenses.zpt20;
      maintainers = with maintainers; [ goibhniu ];
    };
  };


  zfec = buildPythonPackage (rec {
    name = "zfec-1.4.24";
    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zfec/${name}.tar.gz";
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

  zodb3 = buildPythonPackage rec {
    name = "zodb3-${version}";
    version = "3.11.0";
    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/Z/ZODB3/ZODB3-${version}.tar.gz";
      sha256 = "b5767028e732c619f45c27189dd001e14ec155d7984807991fce751b35b4fcb0";
    };

    propagatedBuildInputs = with self; [ manuel transaction zc_lockfile zconfig zdaemon zope_interface zope_event BTrees persistent ZEO ];

    meta = {
      description = "An object-oriented database for Python";
      homepage = http://pypi.python.org/pypi/ZODB3;
      license = licenses.zpt20;
      maintainers = with maintainers; [ goibhniu ];
    };
  };

  zodb = buildPythonPackage rec {
    name = "zodb-${version}";
    disabled = isPyPy;

    version = "4.0.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/Z/ZODB/ZODB-${version}.tar.gz";
      sha256 = "c5d8ffcca37ab4d0a9bfffead6228d58c00cf1c78135abc98a8dbf05b8c8fb58";
    };

    propagatedBuildInputs = with self; [ manuel transaction zc_lockfile zconfig zdaemon zope_interface persistent BTrees ]
      ++ optionals isPy3k [ zodbpickle ];

    preCheck = if isPy3k then ''
      # test failure on py3.4
      rm src/ZODB/tests/testDB.py
    '' else "";

    meta = {
      description = "An object-oriented database for Python";
      homepage = http://pypi.python.org/pypi/ZODB;
      license = licenses.zpt20;
      maintainers = with maintainers; [ goibhniu ];
    };
  };

  zodbpickle = self.buildPythonPackage rec {
    name = "zodbpickle-0.5.2";
    disabled = isPyPy; # https://github.com/zopefoundation/zodbpickle/issues/10

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/z/zodbpickle/${name}.tar.gz";
      sha256 = "f65c00fbc13523fced63de6cc11747aa1a6343aeb2895c89838ed55a5ab12cca";
    };

    # fails..
    doCheck = false;

    meta = {
      homepage = http://pypi.python.org/pypi/zodbpickle;
    };
  };


  BTrees = self.buildPythonPackage rec {
    name = "BTrees-4.1.4";

    propagatedBuildInputs = with self; [ persistent zope_interface transaction ];

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/B/BTrees/${name}.tar.gz";
      sha256 = "1avvhkd7rvp3rzhw20v6ank8a8m9a1lmh99c4gjjsa1ry0zsri3y";
    };

    patches = [ ../development/python-modules/btrees-py35.patch ];

    meta = {
      description = "scalable persistent components";
      homepage = http://packages.python.org/BTrees;
    };
  };


  persistent = self.buildPythonPackage rec {
    name = "persistent-4.0.8";

    propagatedBuildInputs = with self; [ zope_interface ];

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/persistent/${name}.tar.gz";
      sha256 = "678902217c5370d33694c6dc95b89e1e6284b4dc41f04c056326194a3f6f3e22";
    };

    meta = {
      description = "automatic persistence for Python objects";
      homepage = http://www.zope.org/Products/ZODB;
    };
  };

  xdot = buildPythonPackage rec {
    name = "xdot-0.6";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/x/xdot/xdot-0.6.tar.gz";
      sha256 = "c71d82bad0fec696af36af788c2a1dbb5d9975bd70bfbdc14bda15b5c7319e6c";
    };

    propagatedBuildInputs = with self; [ pygtk pygobject pkgs.graphviz ];

    meta = {
      description = "xdot.py is an interactive viewer for graphs written in Graphviz's dot";
      homepage = https://github.com/jrfonseca/xdot.py;
      license = licenses.lgpl3Plus;
    };
  };

  zope_broken = buildPythonPackage rec {
    name = "zope.broken-3.6.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.broken/${name}.zip";
      sha256 = "b9b8776002da4f7b6b12dfcce77eb642ae62b39586dbf60e1d9bdc992c9f2999";
    };

    buildInputs = with self; [ zope_interface ];

    meta = {
        maintainers = with maintainers; [ goibhniu ];
    };
  };


  zope_browser = buildPythonPackage rec {
    name = "zope.browser-2.0.2";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.browser/${name}.zip";
      sha256 = "0f9r5rn9lzgi4hvkhgb6vgw8kpz9sv16jsfb9ws4am8gbqcgv2iy";
    };

    propagatedBuildInputs = with self; [ zope_interface ];

    meta = {
        maintainers = with maintainers; [ goibhniu ];
    };
  };

  zope_browserresource = buildPythonPackage rec {
    name = "zope.browserresource-4.0.1";

    propagatedBuildInputs = with self; [
      zope_component zope_configuration zope_contenttype zope_i18n
      zope_interface zope_location zope_publisher zope_schema zope_traversing
    ];

    # all tests fail
    doCheck = false;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/z/zope.browserresource/zope.browserresource-4.0.1.zip";
      sha256 = "d580184562e7098950ae377b5b37fbb88becdaa2256ac2a6760b69a3e86a99b2";
    };
  };



  zope_component = buildPythonPackage rec {
    name = "zope.component-4.2.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.component/zope.component-4.2.1.tar.gz";
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
      url = "http://pypi.python.org/packages/source/z/zope.configuration/zope.configuration-4.0.3.tar.gz";
      sha256 = "1x9dfqypgympnlm25p9m43xh4qv3p7d75vksv9pzqibrb4cggw5n";
    };

    propagatedBuildInputs = with self; [ zope_i18nmessageid zope_schema ];

    meta = {
        maintainers = with maintainers; [ goibhniu ];
    };
  };


  zope_container = buildPythonPackage rec {
    name = "zope.container-4.0.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.container/${name}.tar.gz";
      sha256 = "5c04e61b52fd04d8b7103476532f557c2278c86281aae30d44f88a5fbe888940";
    };

    # a test is failing
    doCheck = false;

    propagatedBuildInputs = with self; [
      zodb3 zope_broken zope_dottedname zope_publisher
      zope_filerepresentation zope_lifecycleevent zope_size
      zope_traversing
    ];

    meta = {
        maintainers = with maintainers; [ goibhniu ];
    };
  };


  zope_contenttype = buildPythonPackage rec {
    name = "zope.contenttype-4.0.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.contenttype/${name}.tar.gz";
      sha256 = "9decc7531ad6925057f1a667ac0ef9d658577a92b0b48dafa7daa97b78a02bbb";
    };

    meta = {
        maintainers = with maintainers; [ goibhniu ];
    };
  };


  zope_dottedname = buildPythonPackage rec {
    name = "zope.dottedname-3.4.6";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.dottedname/${name}.tar.gz";
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
      url = "http://pypi.python.org/packages/source/z/zope.event/${name}.tar.gz";
      sha256 = "1w858k9kmgzfj36h65kp27m9slrmykvi5cjq6c119xqnaz5gdzgm";
    };

    meta = {
      description = "An event publishing system";
      homepage = http://pypi.python.org/pypi/zope.event;
      license = licenses.zpt20;
      maintainers = with maintainers; [ goibhniu ];
    };
  };


  zope_exceptions = buildPythonPackage rec {
     name = "zope.exceptions-${version}";
     version = "4.0.8";

     src = pkgs.fetchurl {
       url = "http://pypi.python.org/packages/source/z/zope.exceptions/${name}.tar.gz";
       sha256 = "0zwxaaa66sqxg5k7zcrvs0fbg9ym1njnxnr28dfmchzhwjvwnfzl";
     };

     propagatedBuildInputs = with self; [ zope_interface ];

     # circular deps
     doCheck = false;

     meta = {
       description = "Exception interfaces and implementations";
       homepage = http://pypi.python.org/pypi/zope.exceptions;
       license = licenses.zpt20;
       maintainers = with maintainers; [ goibhniu ];
     };
   };


  zope_filerepresentation = buildPythonPackage rec {
    name = "zope.filerepresentation-3.6.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.filerepresentation/${name}.tar.gz";
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
      url = "http://pypi.python.org/packages/source/z/zope.i18n/${name}.tar.gz";
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
      url = "http://pypi.python.org/packages/source/z/zope.i18nmessageid/zope.i18nmessageid-4.0.3.tar.gz";
      sha256 = "1rslyph0klk58dmjjy4j0jxy21k03azksixc3x2xhqbkv97cmzml";
    };

    meta = {
        maintainers = with maintainers; [ goibhniu ];
    };
  };


  zope_lifecycleevent = buildPythonPackage rec {
    name = "zope.lifecycleevent-3.7.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.lifecycleevent/${name}.tar.gz";
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
      url = "http://pypi.python.org/packages/source/z/zope.location/zope.location-4.0.3.tar.gz";
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
      url = "http://pypi.python.org/packages/source/z/zope.proxy/${name}.tar.gz";
      sha256 = "0pqwwmvm1prhwv1ziv9lp8iirz7xkwb6n2kyj36p2h0ppyyhjnm4";
    };

    propagatedBuildInputs = with self; [ zope_interface ];

    # circular deps
    doCheck = false;

    meta = {
        maintainers = with maintainers; [ goibhniu ];
    };
  };


  zope_publisher = buildPythonPackage rec {
    name = "zope.publisher-3.12.6";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.publisher/${name}.tar.gz";
      sha256 = "d994d8eddfba504841492115032a9a7d86b1713ebc96d0ca16fbc6ee93168ba4";
    };

    propagatedBuildInputs = with self; [
      zope_browser zope_contenttype zope_i18n zope_security
    ];

    meta = {
        maintainers = with maintainers; [ goibhniu ];
    };
  };


  zope_schema = buildPythonPackage rec {
    name = "zope.schema-4.4.2";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.schema/${name}.tar.gz";
      sha256 = "1p943jdxb587dh7php4vx04qvn7b2877hr4qs5zyckvp5afhhank";
    };

    propagatedBuildInputs = with self; [ zope_location zope_event zope_interface zope_testing ] ++ optional isPy26 ordereddict;

    meta = {
        maintainers = with maintainers; [ goibhniu ];
    };
  };


  zope_security = buildPythonPackage rec {
    name = "zope.security-4.0.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.security/${name}.tar.gz";
      sha256 = "8da30b03d5491464d59397e03b88192f31f587325ee6c6eb1ca596a1e487e2ec";
    };

    propagatedBuildInputs = with self; [
      zope_component zope_configuration zope_i18nmessageid zope_schema
      zope_proxy zope_testrunner
    ];

    meta = {
      maintainers = with maintainers; [ goibhniu ];
    };
  };


  zope_size = buildPythonPackage rec {
    name = "zope.size-3.5.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.size/${name}.tar.gz";
      sha256 = "006xfkhvmypwd3ww9gbba4zly7n9w30bpp1h74d53la7l7fiqk2f";
    };

    propagatedBuildInputs = with self; [ zope_i18nmessageid zope_interface ];

    meta = {
        maintainers = with maintainers; [ goibhniu ];
    };
  };


  zope_sqlalchemy = buildPythonPackage rec {
    name = "zope.sqlalchemy-0.7.5";

    doCheck = !isPyPy; # https://github.com/zopefoundation/zope.sqlalchemy/issues/12

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.sqlalchemy/${name}.zip";
      sha256 = "e196d1b2cf796f46e2c6127717e359ddd35d8d084a8ba059f0f0fabff245b9e1";
    };

    buildInputs = with self; [ zope_testing zope_interface ];
    propagatedBuildInputs = with self; [ sqlalchemy9 transaction ];

    meta = {
      maintainers = with maintainers; [ garbas iElectric ];
      platforms = platforms.all;
    };
  };


  zope_testing = buildPythonPackage rec {
    name = "zope.testing-${version}";
    version = "4.5.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.testing/${name}.tar.gz";
      sha256 = "1yvglxhzvhl45mndvn9gskx2ph30zz1bz7rrlyfs62fv2pvih90s";
    };

    doCheck = !isPyPy;

    propagatedBuildInputs = with self; [ zope_interface zope_exceptions zope_location ];

    meta = {
      description = "Zope testing helpers";
      homepage =  http://pypi.python.org/pypi/zope.testing;
      license = licenses.zpt20;
      maintainers = with maintainers; [ goibhniu ];
    };
  };


  zope_testrunner = buildPythonPackage rec {
    name = "zope.testrunner-${version}";
    version = "4.4.10";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.testrunner/${name}.zip";
      sha256 = "1w09wbqiqmq6hvrammi4fzc7fr129v63gdnzlk4qi2b1xy5qpqab";
    };

    propagatedBuildInputs = with self; [ zope_interface zope_exceptions zope_testing six ] ++ optional (!python.is_py3k or false) subunit;

    meta = {
      description = "A flexible test runner with layer support";
      homepage = http://pypi.python.org/pypi/zope.testrunner;
      license = licenses.zpt20;
      maintainers = with maintainers; [ goibhniu ];
    };
  };


  zope_traversing = buildPythonPackage rec {
    name = "zope.traversing-4.0.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.traversing/${name}.zip";
      sha256 = "79d38b92ec1d9a2467966ee954b792d83ac66f22e45e928113d4b5dc1f5e74eb";
    };

    propagatedBuildInputs = with self; [ zope_location zope_security zope_publisher transaction zope_tales ];

    # circular dependency on zope_browserresource
    doCheck = false;

    meta = {
        maintainers = with maintainers; [ goibhniu ];
    };
  };


  zope_interface = buildPythonPackage rec {
    name = "zope.interface-4.1.3";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.interface/${name}.tar.gz";
      sha256 = "0ks8h73b2g4bkad821qbv0wzjppdrwys33i7ka45ik3wxjg1l8if";
    };

    propagatedBuildInputs = with self; [ zope_event ];

    meta = {
      description = "Zope.Interface";
      homepage = http://zope.org/Products/ZopeInterface;
      license = licenses.zpt20;
      maintainers = with maintainers; [ goibhniu ];
    };
  };

  hgsvn = buildPythonPackage rec {
    name = "hgsvn-0.3.11";
    src = pkgs.fetchurl rec {
      url = "https://pypi.python.org/packages/source/h/hgsvn/${name}-hotfix.zip";
      sha256 = "0yvhwdh8xx8rvaqd3pnnyb99hfa0zjdciadlc933p27hp9rf880p";
    };
    disabled = isPy3k || isPyPy;
    doCheck = false;  # too many assumptions

    buildInputs = with self; [ nose ];
    propagatedBuildInputs = with self; [ hglib ];

    meta = {
      homepage = http://pypi.python.org/pypi/hgsvn;
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
      description = "black box tests Unix command line tools";
    };
  };

  tornado = buildPythonPackage rec {
    name = "tornado-${version}";
    version = "4.2.1";

    propagatedBuildInputs = with self; [ backports_ssl_match_hostname_3_4_0_2 certifi ];

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/t/tornado/${name}.tar.gz";
      sha256 = "a16fcdc4f76b184cb82f4f9eaeeacef6113b524b26a2cb331222e4a7fa6f2969";
    };
  };

  tornado_4_0_1 = buildPythonPackage rec {
    name = "tornado-${version}";
    version = "4.0.1";

    propagatedBuildInputs = with self; [ backports_ssl_match_hostname_3_4_0_2 certifi ];

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/t/tornado/${name}.tar.gz";
      sha256 = "00crp5vnasxg7qyjv89qgssb69vd7qr13jfghdryrcbnn9l8c1df";
    };
  };

  tokenlib = buildPythonPackage rec {
    name = "tokenlib-${version}";
    version = "0.3.1";
    src = pkgs.fetchgit {
      url = https://github.com/mozilla-services/tokenlib.git;
      rev = "refs/tags/${version}";
      sha256 = "0dmq41sy64jmkj7n49jgbpii5n5d41ci263lyhqbff5slr289m51";
    };

    propagatedBuildInputs = with self; [ requests webob ];
  };

  tunigo = buildPythonPackage rec {
    name = "tunigo-${version}";
    version = "0.1.3";
    propagatedBuildInputs = with self; [ requests2 ];

    src = pkgs.fetchFromGitHub {
      owner = "trygveaa";
      repo = "python-tunigo";
      rev = "v${version}";
      sha256 = "02ili37dbs5mk5f6v3fmi1sji39ymc4zyq44x0abxzr88nc8nh97";
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
        sha256 = "eb754917e98e03cb9d528eb5f57a08c88fa7a8172f92325a9fe796b2daf14db0";
    };

    meta = {
      homepage = https://github.com/scs3jb/screenkey;
      description = "A screencast tool to show your keys";
      license = licenses.gpl3Plus;
      maintainers = with maintainers; [ DamienCassou ];
      platforms = platforms.linux;
    };
  };

  tarman = buildPythonPackage rec {
    version = "0.1.3";
    name = "tarman-${version}";

    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/t/tarman/tarman-${version}.zip";
      sha256 = "0ri6gj883k042xaxa2d5ymmhbw2bfcxdzhh4bz7700ibxwxxj62h";
    };

    buildInputs = with self; [ unittest2 nose mock ];
    propagatedBuildInputs = with self; [ modules.curses libarchive ];

    # tests are still failing
    doCheck = false;
  };


  libarchive = buildPythonPackage rec {
    version = "3.1.2-1";
    name = "libarchive-${version}";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "http://python-libarchive.googlecode.com/files/python-libarchive-${version}.tar.gz";
      sha256 = "0j4ibc4mvq64ljya9max8832jafi04jciff9ia9qy0xhhlwkcx8x";
    };

    propagatedBuildInputs = with self; [ pkgs.libarchive ];
  };

  libarchive-c = buildPythonPackage rec {
    name = "libarchive-c-2.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/l/libarchive-c/${name}.tar.gz";
      sha256 = "089lrz6xyrfnk55v35vis6jyqyyl77w093057djyspnd2744wi2n";
    };

    patchPhase = ''
      substituteInPlace libarchive/ffi.py --replace \
        "find_library('archive')" "'${pkgs.libarchive}/lib/libarchive.so'"
    '';

    buildInputs = [ pkgs.libarchive ];
  };

  pybrowserid = buildPythonPackage rec {
    name = "PyBrowserID-${version}";
    version = "0.9.2";
    disabled = isPy3k; # Errors in the test suite.

    src = pkgs.fetchgit {
      url = https://github.com/mozilla/PyBrowserID.git;
      rev = "refs/tags/${version}";
      sha256 = "0nyqb0v8yrkqnrqsh1hlhvzr2pyvkxvkw701p3gpsvk29c0gb5n6";
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
    name = "pyzmq-15.2.0";
    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyzmq/${name}.tar.gz";
      sha256 = "2dafa322670a94e20283aba2a44b92134d425bd326419b68ad4db8d0831a26ec";
    };
    buildInputs = with self; [ pkgs.zeromq3 pytest tornado ];
    propagatedBuildInputs = [ self.py ];

    # Disable broken test
    # https://github.com/zeromq/pyzmq/issues/799
    checkPhase = ''
      py.test $out/${python.sitePackages}/zmq/ -k "not test_large_send"
    '';
  };

  tokenserver = buildPythonPackage rec {
    name = "tokenserver-${version}";
    version = "1.2.11";

    src = pkgs.fetchgit {
      url = https://github.com/mozilla-services/tokenserver.git;
      rev = "refs/tags/${version}";
      sha256 = "1pjrw7xhhqx7h4s08h1lsaa499r2ymc41zdknjimn6zlqdjdk1fb";
    };

    doCheck = false;
    buildInputs = [ self.testfixtures ];
    propagatedBuildInputs = with self; [ cornice mozsvc pybrowserid tokenlib ];

    meta = {
      platforms = platforms.all;
    };
  };

  testfixtures = buildPythonPackage rec {
    name = "testfixtures-${version}";
    version = "4.5.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/t/testfixtures/testfixtures-${version}.tar.gz";
      sha256 = "0my8zq9d27mc7j78pz9971cn5wz6zi4vxlqa50szr2vq9j2xxkll";
    };

    buildInputs = with self; [ nose mock manuel ];

    checkPhase = ''
      nosetests -v
    '';

    # Test suite seems broken
    # TypeError: TestSuite() missing 1 required positional argument: 'm'
    # Haven't checked with newer version
    doCheck = false;

    meta = with stdenv.lib; {
      homepage = "https://github.com/Simplistix/testfixtures";
    };
  };

  tissue = buildPythonPackage rec {
    name = "tissue-0.9.2";
    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/t/tissue/${name}.tar.gz";
      sha256 = "7e34726c3ec8fae358a7faf62de172db15716f5582e5192a109e33348bd76c2e";
    };

    buildInputs = with self; [ nose ];
    propagatedBuildInputs = with self; [ pep8 ];

    meta = {
      maintainers = with maintainers; [ garbas iElectric ];
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
      url = "http://pypi.python.org/packages/source/t/translationstring/${name}.tar.gz";
      sha256 = "4ee44cfa58c52ade8910ea0ebc3d2d84bdcad9fa0422405b1801ec9b9a65b72d";
    };

    meta = {
      maintainers = with maintainers; [ garbas iElectric ];
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
    name = "websocket_client-0.32.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/w/websocket-client/${name}.tar.gz";
      sha256 = "cb3ab95617ed2098d24723e3ad04ed06c4fde661400b96daa1859af965bfe040";
    };

    propagatedBuildInputs = with self; [ six backports_ssl_match_hostname_3_4_0_2 unittest2 argparse ];

    meta = {
      homepage = https://github.com/liris/websocket-client;
      description = "Websocket client for python";
      license = licenses.lgpl2;
    };
  };


  webhelpers = buildPythonPackage rec {
    name = "WebHelpers-1.3";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/W/WebHelpers/${name}.tar.gz";
      sha256 = "ea86f284e929366b77424ba9a89341f43ae8dee3cbeb8702f73bcf86058aa583";
    };

    buildInputs = with self; [ routes markupsafe webob nose ];

    # TODO: failing tests https://bitbucket.org/bbangert/webhelpers/pull-request/1/fix-error-on-webob-123/diff
    doCheck = false;

    meta = {
      maintainers = with maintainers; [ garbas iElectric ];
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

    meta = {
      homepage = https://github.com/pydanny/whichcraft;
      description = "Cross-platform cross-python shutil.which functionality";
      license = licenses.bsd3;
    };
  };


  whisper = buildPythonPackage rec {
    name = "whisper-${version}";
    version = "0.9.15";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/w/whisper/${name}.tar.gz";
      sha256 = "1chkphxwnwvy2cs7jc2h2i0lqqvi9jx6vqj3ly88lwk7m35r4ss2";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://graphite.wikidot.com/;
      description = "Fixed size round-robin style database";
      maintainers = with maintainers; [ rickynils offline ];
    };
  };

  carbon = buildPythonPackage rec {
    name = "carbon-${version}";
    version = "0.9.15";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/c/carbon/${name}.tar.gz";
      sha256 = "f01db6d37726c6fc0a8aaa66a7bf14436b0dd0d62ef3c20ecb31605a4d365d2e";
    };

    propagatedBuildInputs = with self; [ whisper txamqp zope_interface twisted ];

    meta = {
      homepage = http://graphite.wikidot.com/;
      description = "Backend data caching and persistence daemon for Graphite";
      maintainers = with maintainers; [ rickynils offline ];
    };
  };


  ujson = buildPythonPackage rec {
    name = "ujson-1.33";

    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/u/ujson/${name}.zip";
      sha256 = "68cf825f227c82e1ac61e423cfcad923ff734c27b5bdd7174495d162c42c602b";
    };

    meta = {
      homepage = http://pypi.python.org/pypi/ujson;
      description = "Ultra fast JSON encoder and decoder for Python";
      license = licenses.bsd3;
    };
  };


  unidecode = buildPythonPackage rec {
    name = "Unidecode-0.04.18";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/U/Unidecode/${name}.tar.gz";
      sha256 = "12hhblqy1ajvidm38im4171x4arg83pfmziyn53nizp29p3m14gi";
    };

    LC_ALL="en_US.UTF-8";

    buildInputs = [ pkgs.glibcLocales ];

    meta = {
      homepage = http://pypi.python.org/pypi/Unidecode/;
      description = "ASCII transliterations of Unicode text";
      license = licenses.gpl2;
      maintainers = with maintainers; [ iElectric ];
    };
  };


  pyusb = buildPythonPackage rec {
    name = "pyusb-1.0.0b2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pyusb/${name}.tar.gz";
      sha256 = "14ec66077bdcd6f1aa9e892a0a35a54bb3c1ec56aa740ead64349c18f0186d19";
    };

    # Fix the USB backend library lookup
    postPatch = ''
      libusb=${pkgs.libusb1}/lib/libusb-1.0.so
      test -f $libusb || { echo "ERROR: $libusb doesn't exist, please update/fix this build expression."; exit 1; }
      sed -i -e "s|libname = .*|libname = \"$libusb\"|" usb/backend/libusb1.py
    '';

    meta = {
      description = "Python USB access module (wraps libusb 1.0)";  # can use other backends
      homepage = http://pyusb.sourceforge.net/;
      license = licenses.bsd3;
      maintainers = with maintainers; [ bjornfor ];
    };
  };


  BlinkStick = buildPythonPackage rec {
    name = "BlinkStick-${version}";
    version = "1.1.8";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/B/BlinkStick/${name}.tar.gz";
      sha256 = "3edf4b83a3fa1a7bd953b452b76542d54285ff6f1145b6e19f9b5438120fa408";
    };

    propagatedBuildInputs = with self; [ pyusb ];

    meta = {
      description = "Python package to control BlinkStick USB devices";
      homepage = http://pypi.python.org/pypi/BlinkStick/;
      license = licenses.bsd3;
      maintainers = with maintainers; [ np ];
    };
  };


  usbtmc = buildPythonPackage rec {
    name = "usbtmc-${version}";
    version = "0.6";

    src = pkgs.fetchurl {
      url = "https://github.com/python-ivi/python-usbtmc/archive/v${version}.tar.gz";
      sha256 = "1wnw6ndc3s1i8zpbikz5zc40ijvpraqdb0xn8zmqlyn95xxfizw2";
    };

    propagatedBuildInputs = with self; [ pyusb ];

    meta = {
      description = "Python implementation of the USBTMC instrument control protocol";
      homepage = http://alexforencich.com/wiki/en/python-usbtmc/start;
      license = licenses.mit;
      maintainers = with maintainers; [ bjornfor ];
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
      url = "https://pypi.python.org/packages/source/v/versiontools/${name}.tar.gz";
      sha256 = "1xhl6kl7f4srgnw6zw4lr8j2z5vmrbaa83nzn2c9r2m1hwl36sd9";
    };

  };

  veryprettytable = buildPythonPackage rec {
    name = "veryprettytable-${version}";
    version = "0.8.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/v/veryprettytable/${name}.tar.gz";
      sha256 = "1k1rifz8x6qcicmx2is9vgxcj0qb2f5pvzrp7zhmvbmci3yack3f";
    };

    propagatedBuildInputs = [ self.termcolor self.colorama ];

    meta = {
      description = "A simple Python library for easily displaying tabular data in a visually appealing ASCII table format";
      homepage = https://github.com/smeggingsmegger/VeryPrettyTable;
      license = licenses.free;
    };
  };

  graphite_web = buildPythonPackage rec {
    name = "graphite-web-${version}";
    version = "0.9.15";

    src = pkgs.fetchurl rec {
      url = "https://pypi.python.org/packages/source/g/graphite-web/${name}.tar.gz";
      sha256 = "472a4403fd5b5364939aee10e78f171b1489e5f6bfe6f150ed9cae8476410114";
    };

    propagatedBuildInputs = with self; [ django_1_5 django_tagging pysqlite whisper cairocffi ldap memcached pytz ];

    postInstall = ''
      wrapProgram $out/bin/run-graphite-devel-server.py \
        --prefix PATH : ${pkgs.which}/bin
    '';

    preConfigure = ''
      substituteInPlace webapp/graphite/thirdparty/pytz/__init__.py --replace '/usr/share/zoneinfo' '/etc/zoneinfo'
      substituteInPlace webapp/graphite/settings.py --replace "join(WEBAPP_DIR, 'content')" "join('$out', 'webapp', 'content')"
      cp webapp/graphite/manage.py bin/manage-graphite.py
      substituteInPlace bin/manage-graphite.py --replace 'settings' 'graphite.settings'
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
      sha256 = "41b90d5f35e99a020a6b1b77938690652521d1841b3165574fcfcee807ce4e6a";
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

    LD_LIBRARY_PATH = "${pkgs.cairo}/lib";

    meta = {
      description = "Graphite-web, without the interface. Just the rendering HTTP API";
      homepage = https://github.com/brutasse/graphite-api;
      license = licenses.asl20;
    };
  };

  graphite_beacon = buildPythonPackage rec {
    name = "graphite_beacon-0.22.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/g/graphite_beacon/${name}.tar.gz";
      sha256 = "ebde1aba8030c8aeffaeea39f9d44a2be464b198583ad4a390a2bff5f4172543";
    };

    propagatedBuildInputs = [ self.tornado ];

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
      sha256 = "e386eaf190793d3ad0a42a74b9e137a968a51fc3806f602ff756e09c0c0648a8";
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
      sha256 = "aa932f941efe4ed89971fe7572218b020d1a144259739ef78db6397b968eef62";
      rev = version;
    };

    buildInputs = with self; [ nose mock ];
    propagatedBuildInputs = with self; [
      jinja2 pyyaml redis requests pagerduty
      python_simple_hipchat pushbullet
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
    buildInputs = [ pkgs.libspotify ]
      ++ stdenv.lib.optional stdenv.isDarwin pkgs.install_name_tool;

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
      sha256 = "17vv2q636zp2fvxrp7ckgnz1ifaffcj5vdxvfb4isd1d32c49amb";
    };

    # There are no tests
    doCheck = false;

    meta = {
      homepage = http://www.pykka.org;
      description = "A Python implementation of the actor model";
      maintainers = with maintainers; [ rickynils ];
    };
  };

  ws4py = buildPythonPackage rec {
    name = "ws4py-${version}";

    version = "git-20130303";

    src = pkgs.fetchgit {
      url = "https://github.com/Lawouach/WebSocket-for-Python.git";
      rev = "ace276500ca7e4c357595e3773be151d37bcd6e2";
      sha256 = "04m4m3ncn7g4rb81xg5n28imns7rsq8d2w98gjpaib6vlmyly3g1";
    };

    # python zip complains about old timestamps
    preConfigure = ''
      find -print0 | xargs -0 touch
    '';

    # Tests depend on other packages
    doCheck = false;

    meta = {
      homepage = https://ws4py.readthedocs.org;
      description = "A WebSocket package for Python";
      maintainers = with maintainers; [ rickynils ];
    };
  };

  gdata = buildPythonPackage rec {
    name = "gdata-${version}";
    version = "2.0.18";

    src = pkgs.fetchurl {
      url = "https://gdata-python-client.googlecode.com/files/${name}.tar.gz";
      # sha1 = "d2d9f60699611f95dd8c328691a2555e76191c0c";
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
    version = "0.11";
    disabled = isPy34 || isPy35;

    src = pkgs.fetchurl {
      url = "http://freshfoo.com/projects/IMAPClient/${name}.tar.gz";
      sha256 = "1w54h8gz25qf6ggazzp6xf7kvsyiadsjfkkk17gm0p6pmzvvccbn";
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
    version = "0.11.3";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/L/Logbook/${name}.tar.gz";
      sha256 = "0bchn00jj0y4dmrmqsm29ffcx37g79jcxjihadmgz2aj0z6dbsrc";
    };

    buildInputs = [ self.pytest ];

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
    version = "1.3.2";
  in assert version == pkgs.libvirt.version; pkgs.stdenv.mkDerivation rec {
    name = "libvirt-python-${version}";

    src = pkgs.fetchurl {
      url = "http://libvirt.org/sources/python/${name}.tar.gz";
      sha256 = "1y0b2sglc6q43pw1sr0by5wx8037kvrp2969p69k6mq1g2gawdbd";
    };

    buildInputs = with self; [ python pkgs.pkgconfig pkgs.libvirt lxml ];

    buildPhase = "${python.interpreter} setup.py build";

    installPhase = "${python.interpreter} setup.py install --prefix=$out";

    meta = {
      homepage = http://www.libvirt.org/;
      description = "libvirt Python bindings";
      license = licenses.lgpl2;
      maintainers = [ maintainers.fpletz ];
    };
  };

  searx = buildPythonPackage rec {
    name = "searx-0.8.1";

    src = pkgs.fetchurl {
      url = "https://github.com/asciimoo/searx/archive/v0.8.1.tar.gz";
      sha256 = "0z0s9n8iblrw7y5xrh2apzsazkgm4vzmxn0ckw4yfiya9am8zk32";
    };

    propagatedBuildInputs = with self; [
      pyyaml lxml grequests flaskbabel flask requests2
      gevent speaklater Babel pytz dateutil pygments
      pyasn1 pyasn1-modules ndg-httpsclient certifi
    ];

    meta = {
      homepage = https://github.com/asciimoo/searx;
      description = "A privacy-respecting, hackable metasearch engine";
      license = licenses.agpl3Plus;
      maintainers = with maintainers; [ matejc fpletz ];
    };
  };

  rpdb = buildPythonPackage rec {
    name = "rpdb-0.1.5";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/r/rpdb/${name}.tar.gz";
      sha256 = "0rql1hq3lziwcql0h3dy05w074cn866p397ng9bv6qbz85ifw1bk";
    };

    meta = {
      description = "pdb wrapper with remote access via tcp socket";
      homepage = https://github.com/tamentis/rpdb;
      license = licenses.bsd2;
    };
  };


  grequests = buildPythonPackage rec {
    name = "grequests-0.2.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/g/grequests/${name}.tar.gz";
      sha256 = "0lafzax5igbh8y4x0krizr573wjsxz7bhvwygiah6qwrzv83kv5c";
    };

    buildInputs = with self; [ requests gevent ];

    meta = {
      description = "Asynchronous HTTP requests";
      homepage = https://github.com/kennethreitz/grequests;
      license = "bsd";
      maintainers = with maintainers; [ matejc ];
    };
  };

  flaskbabel = buildPythonPackage rec {
    name = "Flask-Babel-0.9";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/F/Flask-Babel/${name}.tar.gz";
      sha256 = "0k7vk4k54y55ma0nx2k5s0phfqbriwslhy5shh3b0d046q7ibzaa";
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
      url = "http://pypi.python.org/packages/source/s/speaklater/${name}.tar.gz";
      sha256 = "1ab5dbfzzgz6cnz4xlwx79gz83id4bhiw67k1cgqrlzfs0va7zjr";
    };

    meta = {
      description = "implements a lazy string for python useful for use with gettext";
      homepage = https://github.com/mitsuhiko/speaklater;
      license = "bsd";
      maintainers = with maintainers; [ matejc ];
    };
  };

  pushbullet = buildPythonPackage rec {
    name = "pushbullet.py-${version}";
    version = "0.10.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pushbullet.py/pushbullet.py-0.10.0.tar.gz";
      sha256 = "537d3132e1dbc91e31ade4cccf4c7def6f9d48e904a67f341d35b8a54a9be74d";
    };

    propagatedBuildInputs = with self; [requests websocket_client python_magic ];
  };

  power = buildPythonPackage rec {
    name = "power-1.4";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/power/${name}.tar.gz";
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

  udiskie = buildPythonPackage rec {
    version = "1.4.8";
    name = "udiskie-${version}";

    src = pkgs.fetchurl {
      url = "https://github.com/coldfix/udiskie/archive/${version}.tar.gz";
      sha256 = "0fj1kh6pmwyyy54ybc5fa625lhrxzhzmfx1nwz2lym5cpm4b21fl";
    };

    preConfigure = ''
      export XDG_RUNTIME_DIR=/tmp
    '';

    buildInputs = [
      pkgs.asciidoc-full        # For building man page.
    ];

    propagatedBuildInputs = with self; [ pkgs.gobjectIntrospection pkgs.gtk3 pyyaml pygobject3 pkgs.libnotify pkgs.udisks2 pkgs.gettext self.docopt ];

    postBuild = "make -C doc";

    postInstall = ''
      mkdir -p $out/share/man/man8
      cp -v doc/udiskie.8 $out/share/man/man8/
    '';

    preFixup = ''
        wrapProgram "$out/bin/"* \
          --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH"
    '';

    # tests require dbusmock
    doCheck = false;

    meta = {
      description = "Removable disk automounter for udisks";
      license = licenses.mit;
      homepage = https://github.com/coldfix/udiskie;
      maintainers = with maintainers; [ AndersonTorres ];
    };
  };

  # Should be bumped along with EFL!
  pythonefl = buildPythonPackage rec {
    name = "python-efl-${version}";
    version = "1.17.0";
    src = pkgs.fetchurl {
      url = "http://download.enlightenment.org/rel/bindings/python/${name}.tar.xz";
      sha256 = "0yciffcgmyfmy95gidg9jhczv96jyi38zcdj0q19fjmx704zx84y";
    };

    preConfigure = ''
      export NIX_CFLAGS_COMPILE="$(pkg-config --cflags efl) -I${self.dbus}/include/dbus-1.0 $NIX_CFLAGS_COMPILE"
    '';
    preBuild = "${python}/bin/${python.executable} setup.py build_ext";
    installPhase= "${python}/bin/${python.executable} setup.py install --prefix=$out";

    buildInputs = with self; [ pkgs.pkgconfig pkgs.enlightenment.efl pkgs.enlightenment.elementary ];
    doCheck = false;

    meta = {
      description = "Python bindings for EFL and Elementary";
      homepage = http://enlightenment.org/;
      maintainers = with maintainers; [ matejc tstrobel ftrvxmtrx ];
      platforms = platforms.linux;
      license = licenses.gpl3;
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
      url = "https://pypi.python.org/packages/source/t/toposort/toposort-1.1.tar.gz";
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

    propagatedBuildInputs = with self; [ pygobject3 dbus ];

    meta = {
      homepage = https://github.com/ricardomv/snapper-gui;
      description = "Graphical frontend for snapper";
      license = licenses.gpl2;
      maintainers = with maintainers; [ tstrobel ];
    };
  };


  redNotebook = buildPythonPackage rec {
    name = "rednotebook-1.8.1";

    src = pkgs.fetchurl {
      url = "mirror://sourceforge/rednotebook/${name}.tar.gz";
      sha256 = "00b7s4xpqpxsbzjvjx9qsx5d84m9pvn383c5di1nsfh35pig0rzn";
    };

    # no tests available
    doCheck = false;

    propagatedBuildInputs = with self; [ pygtk pywebkitgtk pyyaml chardet ];

    meta = {
      homepage = http://rednotebook.sourceforge.net/index.html;
      description = "A modern journal that includes a calendar navigation, customizable templates, export functionality and word clouds";
      license = licenses.gpl2;
      maintainers = with maintainers; [ tstrobel ];
    };
  };


  moreItertools = buildPythonPackage rec {
    name = "more-itertools-2.2";

    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "https://github.com/erikrose/more-itertools/archive/2.2.tar.gz";
      sha256 = "4606417182e0a1289e23fb7f964a64ca9fdaafb7c1999034dc4fa0cc5850c478";
    };

    propagatedBuildInputs = with self; [ nose ];

    meta = {
      homepage = https://more-itertools.readthedocs.org;
      description = "Expansion of the itertools module";
      license = licenses.mit;
    };
  };


  uncertainties = buildPythonPackage rec {
    name = "uncertainties-2.4.6.1";

    src = pkgs.fetchurl {
       url = "https://github.com/lebigot/uncertainties/archive/2.4.6.1.tar.gz";
       sha256 = "993ad1a380185ff9548510401ed89fe96cf1f18ca48b44657356c8dcd3ad5032";
    };

    buildInputs = with self; [ nose numpy ];

    meta = {
      homepage = "http://pythonhosted.org/uncertainties/";
      description = "Transparent calculations with uncertainties on the quantities involved (aka error propagation)";
      license = licenses.bsd3;
    };

    # No tests included
    doCheck = false;
  };


  funcy = buildPythonPackage rec {
    name = "funcy-1.6";

    src = pkgs.fetchurl {
        url = "https://pypi.python.org/packages/source/f/funcy/${name}.tar.gz";
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

  boto-230 = buildPythonPackage rec {
    name = "boto-2.30.0";
    disabled = ! isPy27;
    src = pkgs.fetchurl {
      url = https://pypi.python.org/packages/source/b/boto/boto-2.30.0.tar.gz;
      sha256 = "12gl8azmx1vv8dbv9jhnsbhjpc2dd1ng0jlbcg734k6ggwq1h6hh";
    };
    doCheck = false;
    meta = {
      homepage = https://github.com/boto/boto;
      license = licenses.mit;
      description = "Python interface to Amazon Web Services";
    };
  };

  gcs-oauth2-boto-plugin = buildPythonPackage rec {
    name = "gcs-oauth2-boto-plugin-1.8";
    disabled = ! isPy27;
    src = pkgs.fetchurl {
      url = https://pypi.python.org/packages/source/g/gcs-oauth2-boto-plugin/gcs-oauth2-boto-plugin-1.8.tar.gz;
      sha256 = "0jy62y5bmaf1mb735lqwry1s5nx2qqrxvl5sxip9yg4miih3qkyb";
    };
    propagatedBuildInputs = with self; [ boto-230 httplib2 google_api_python_client retry_decorator pkgs.pyopenssl socksipy-branch ];
    meta = {
      homepage = https://developers.google.com/storage/docs/gspythonlibrary;
      description = "Provides OAuth 2.0 credentials that can be used with Google Cloud Storage";
      license = licenses.asl20;
    };
  };

  gsutil = buildPythonPackage rec {
    name = "gsutil-4.6";
    disabled = ! isPy27;
    meta = {
      homepage = https://developers.google.com/storage/docs/gsutil;
      description = "Google Cloud Storage Tool";
      maintainers = [ "Russell O'Connor <oconnorr@google.com>" ];
      license = licenses.asl20;
    };
    doCheck = false;

    src = pkgs.fetchurl {
      url = https://pypi.python.org/packages/source/g/gsutil/gsutil-4.6.tar.gz;
      sha256 = "1i0clm60162rbk45ljr8nsw4ndkzjnwb7r440shcqjrvw8jq49mn";
    };

    propagatedBuildInputs = with self; [ boto-230 crcmod httplib2 gcs-oauth2-boto-plugin google_api_python_client gflags
                                         retry_decorator pkgs.pyopenssl socksipy-branch crcmod ];
  };

  pypi2nix = self.buildPythonPackage rec {
    rev = "04a68d8577acbceb88bdf51b1231a9dbdead7003";
    name = "pypi2nix-1.0_${rev}";
    disabled = ! isPy27;

    src = pkgs.fetchurl {
      url = "https://github.com/garbas/pypi2nix/tarball/${rev}";
      name = "${name}.tar.bz";
      sha256 = "1fv85x2bz442iyxsvka2g75zibjcq48gp2fc7szaqcfqxq42syy9";
    };

    doCheck = false;

    meta = {
      homepage = https://github.com/garbas/pypi2nix;
      description = "";
      maintainers = with maintainers; [ garbas ];
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
    version = "1.5.0";
    disabled = ! isPy27;

    src = pkgs.fetchgit {
      url = https://github.com/mozilla-services/syncserver.git;
      rev = "refs/tags/${version}";
      sha256 = "1xljylycxg7351hmqh7aa6fvvsjg06zvd4r7hcjqyd0k0sxvk7y6";
    };

    buildInputs = with self; [ unittest2 ];
    propagatedBuildInputs = with self; [
      cornice gunicorn pyramid requests simplejson sqlalchemy9 mozsvc tokenserver
      serversyncstorage configparser
    ];

    meta = {
      maintainers = [ ];
      platforms = platforms.all;
    };
  };

  serversyncstorage = buildPythonPackage rec {
    name = "serversyncstorage-${version}";
    version = "1.5.11";
    disabled = !isPy27;

    src = pkgs.fetchgit {
      url = https://github.com/mozilla-services/server-syncstorage.git;
      rev = "refs/tags/${version}";
      sha256 = "1byq2k2f36f1jli9599ygfm2qsb4adl9140sxjpgfjbznb74q90q";
    };

    propagatedBuildInputs = with self; [
      pyramid sqlalchemy9 simplejson mozsvc cornice pyramid_hawkauth pymysql
      pymysqlsa umemcache WSGIProxy requests pybrowserid
    ];
    buildInputs = with self; [ testfixtures unittest2  ];

    #doCheck = false; # lazy packager
  };

  WSGIProxy = buildPythonPackage rec {
    name = "WSGIProxy-${version}";
    version = "0.2.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/W/WSGIProxy/WSGIProxy-${version}.tar.gz";
      sha256 = "0wqz1q8cvb81a37gb4kkxxpv4w7k8192a08qzyz67rn68ln2wcig";
    };

    propagatedBuildInputs = with self; [
      paste six
    ];

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
      url = "https://pypi.python.org/packages/source/b/blist/blist-${version}.tar.gz";
      sha256 = "1hqz9pqbwx0czvq9bjdqjqh5bwfksva1is0anfazig81n18c84is";
    };
  };

  canonicaljson = buildPythonPackage rec {
    name = "canonicaljson-${version}";
    version = "1.0.0";

    src = pkgs.fetchgit {
      url = "https://github.com/matrix-org/python-canonicaljson.git";
      rev = "refs/tags/v${version}";
      sha256 = "29802d0effacd26ca1d6eccc8d4c7e4f543a194754ba89263861e87f44a83f0c";
    };

    propagatedBuildInputs = with self; [
      frozendict simplejson
    ];
  };

  daemonize = buildPythonPackage rec {
    name = "daemonize-${version}";
    version = "2.4.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/daemonize/daemonize-${version}.tar.gz";
      sha256 = "0y139sq657bpzfv6k0aqm4071z4s40i6ybpni9qvngvdcz6r86n2";
    };
  };

  pydenticon = buildPythonPackage rec {
    name = "pydenticon-${version}";
    version = "0.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pydenticon/pydenticon-0.2.tar.gz";
      sha256 = "035dawcspgjw2rksbnn863s7b0i9ac8cc1nshshvd1l837ir1czp";
    };
    propagatedBuildInputs = with self; [
      pillow mock
    ];
  };

  pymacaroons-pynacl = buildPythonPackage rec {
    name = "pymacaroons-pynacl-${version}";
    version = "0.9.3";

    src = pkgs.fetchgit {
      url = "https://github.com/matrix-org/pymacaroons.git";
      rev = "refs/tags/v${version}";
      sha256 = "481a486520f5a3ad2761c3cd3954d2b08f456a94fb080aaa4ad1e68ddc705b52";
    };

    propagatedBuildInputs = with self; [ pynacl six ];
  };

  pynacl = buildPythonPackage rec {
    name = "pynacl-${version}";
    version = "0.3.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/P/PyNaCl/PyNaCl-0.3.0.tar.gz";
      sha256 = "1hknxlp3a3f8njn19w92p8nhzl9jkfwzhv5fmxhmyq2m8hqrfj8j";
    };

    propagatedBuildInputs = with self; [pkgs.libsodium six cffi pycparser pytest];
  };

  service-identity = buildPythonPackage rec {
    name = "service-identity-${version}";
    version = "14.0.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/s/service_identity/service_identity-${version}.tar.gz";
      sha256 = "0njg9bklkkp4rl2b9vsfh9aasxy3w2dmjkv9cq34jn65lwcs619i";
    };

    propagatedBuildInputs = with self; [
      characteristic pyasn1 pyasn1-modules pyopenssl idna
    ];

    buildInputs = with self; [
      pytest
    ];
  };

  signedjson = buildPythonPackage rec {
    name = "signedjson-${version}";
    version = "1.0.0";

    src = pkgs.fetchgit {
      url = "https://github.com/matrix-org/python-signedjson.git";
      rev = "refs/tags/v${version}";
      sha256 = "4ef1c89ea85846632d711a37a2e6aae1348c62b9d62ed0e80428b4a00642e9df";
    };

    propagatedBuildInputs = with self; [
      canonicaljson unpaddedbase64 pynacl
    ];
  };

  unpaddedbase64 = buildPythonPackage rec {
    name = "unpaddedbase64-${version}";
    version = "1.0.1";

    src = pkgs.fetchgit {
      url = "https://github.com/matrix-org/python-unpaddedbase64.git";
      rev = "refs/tags/v${version}";
      sha256 = "f221240a6d414c4244ab906b1dc8983c4d1114acb778cb857f6fc50d710be502";
    };
  };


  thumbor = buildPythonPackage rec {
    name = "thumbor-${version}";
    version = "5.2.1";

    disabled = ! isPy27;

    buildInputs = with self; [ statsd nose ];

    propagatedBuildInputs = with self; [
      tornado
      pycrypto
      pycurl
      pillow
      derpconf
      python_magic
      # thumborPexif
      pexif
      libthumbor
      (pkgs.opencv.override {
        gtk = null;
        glib = null;
        xineLib = null;
        gstreamer = null;
        ffmpeg = null;
      })
    ] ++ optionals (!isPy3k) [ futures ];

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/t/thumbor/${name}.tar.gz";
      sha256 = "57b0d7e261e792b2e2c53a79c3d8c722964003d1828331995dc3491dc67db7d8";
    };

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
      url = "https://pypi.python.org/packages/source/t/thumbor-pexif/${name}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/p/${baseName}/${name}.tar.gz";
      md5 = "5cc79077f386a17b539f1e51c05a3650";
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

    propagatedBuildInputs = with self; [ pillow prettytable pyyaml dateutil gdata requests2 mechanize feedparser lxml pkgs.gnupg pyqt4 pkgs.libyaml simplejson cssselect futures pdfminer termcolor ];

    meta = {
      homepage = http://weboob.org;
      description = "Collection of applications and APIs to interact with websites without requiring the user to open a browser";
      license = licenses.agpl3;
      maintainers = with maintainers; [ DamienCassou ];
    };
  };

  datadiff = buildPythonPackage rec {
    name = "datadiff-1.1.6";
    disabled = ! isPy27;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/datadiff/datadiff-1.1.6.zip";
      sha256 = "f1402701063998f6a70609789aae8dc05703f3ad0a34882f6199653654c55543";
    };

    buildInputs = with self; [ nose ];

    meta = {
      description = "DataDiff";
      homepage = http://sourceforge.net/projects/datadiff/;
      license = licenses.asl20;
    };
  };

  termcolor = buildPythonPackage rec {
    name = "termcolor-1.1.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/t/termcolor/termcolor-1.1.0.tar.gz";
      sha256 = "1d6d69ce66211143803fbc56652b41d73b4a400a2891d7bf7a1cdf4c02de613b";
    };

    meta = {
      description = "Termcolor";
      homepage = http://pypi.python.org/pypi/termcolor;
      license = licenses.mit;
    };
  };

  html2text = buildPythonPackage rec {
    name = "html2text-2015.11.4";
    disabled = ! isPy27;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/h/html2text/${name}.tar.gz";
      sha256 = "021pqcshxajhdy4whkawz95v98m8njv5lknzgac0sp8jzl01qls4";
    };

    meta = {
      homepage = https://github.com/Alir3z4/html2text/;
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
    name = "parsimonious-0.6.0";
    disabled = ! isPy27;
    src = pkgs.fetchurl {
      url = "https://github.com/erikrose/parsimonious/archive/0.6.tar.gz";
      sha256 = "7ad992448b69a3f3d943bac0be132bced3f13937c8ca150ba2fd1d7b6534f846";
    };

    propagatedBuildInputs = with self; [ nose ];

    meta = {
      homepage = "https://github.com/erikrose/parsimonious";
      description = "Fast arbitrary-lookahead packrat parser written in pure Python";
      license = licenses.mit;
    };
  };

  networkx = buildPythonPackage rec {
    version = "1.10";
    name = "networkx-${version}";

    # Currently broken on PyPy.
    # https://github.com/networkx/networkx/pull/1361
    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/n/networkx/${name}.tar.gz";
      sha256 = "ced4095ab83b7451cec1172183eff419ed32e21397ea4e1971d92a5808ed6fb8";
    };

    propagatedBuildInputs = with self; [ nose decorator ];

    meta = {
      homepage = "https://networkx.github.io/";
      description = "Library for the creation, manipulation, and study of the structure, dynamics, and functions of complex networks";
      license = licenses.bsd3;
    };
  };

  ofxclient = buildPythonPackage rec {
    name = "ofxclient-1.3.8";
	src = pkgs.fetchurl {
	  url = "https://pypi.python.org/packages/source/o/ofxclient/${name}.tar.gz";
	  sha256 = "99ab03bffdb30d9ec98724898f428f8e73129483417d5892799a0f0d2249f233";
	};

	# ImportError: No module named tests
	doCheck = false;

	propagatedBuildInputs = with self; [ ofxhome ofxparse beautifulsoup keyring argparse ];
  };

  ofxhome = buildPythonPackage rec {
	name = "ofxhome-0.3.1";
	src = pkgs.fetchurl {
	  url = "https://pypi.python.org/packages/source/o/ofxhome/${name}.tar.gz";
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
	  url = "https://pypi.python.org/packages/source/o/ofxparse/${name}.tar.gz";
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
	  url = "https://pypi.python.org/packages/source/o/ofxtools/${name}.tar.gz";
	  sha256 = "88f289a60f4312a1599c38a8fb3216e2b46d10cc34476f9a16a33ac8aac7ec35";
	};
    meta = {
      homepage = "https://github.com/csingley/ofxtools";
      description = "Library for working with Open Financial Exchange (OFX) formatted data used by financial institutions";
      license = licenses.mit;
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

    # The installer does not support the '--old-and-unmanageable' option
    installPhase = ''
      ${python.interpreter} setup.py install --prefix $out
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
      url = "https://pypi.python.org/packages/source/d/dicttoxml/dicttoxml-1.6.4.tar.gz";
      sha256 = "5f29e95fec56680823dc41911c04c2af08727ee53c1b60e83c489212bab71161";
    };

    propagatedBuildInputs = with self; [  ];

    meta = {
      description = "Summary";
      homepage = https://github.com/quandyfactory/dicttoxml;
    };
  };


  markdown2 = buildPythonPackage rec {
    name = "markdown2-${version}";
    version = "2.3.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/m/markdown2/${name}.zip";
      sha256 = "073zyx3caqa9zlzxa82k9k2nhhn8c5imqpgp5nwqnh0fgaj9pqn8";
    };
    propagatedBuildInputs = with self; [];
    meta = {
      description = "A fast and complete Python implementation of Markdown";
      homepage =  https://github.com/trentm/python-markdown2;
      license = licenses.mit;
      maintainers = with maintainers; [ hbunke ];
    };
  };


  evernote = buildPythonPackage rec {
    name = "evernote-${version}";
    version = "1.25.0";
    disabled = ! isPy27; #some dependencies do not work with py3

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/e/evernote/${name}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/s/setproctitle/setproctitle-${version}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/t/thrift/${name}.tar.gz";
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
    version = "2015-03-02";
    name = "geeknote-${version}";
    disabled = ! isPy27;

    src = pkgs.fetchFromGitHub {
      owner = "VitaliyRodnenko";
      repo = "geeknote";
      rev = "7ea2255bb6";
      sha256 = "0lw3m8g7r8r7dxhqih08x0i6agd201q2ig35a59rd4vygr3xqw2j";
    };

    /* build with tests fails with "Can not create application dirictory :
     /homeless-shelter/.geeknotebuilder". */
    doCheck = false;

    propagatedBuildInputs = with self; [
        thrift
        beautifulsoup4
        markdown2
        sqlalchemy7
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

  trollius = buildPythonPackage rec {
    version = "1.0.4";
    name = "trollius-${version}";
    disabled = isPy34;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/t/trollius/${name}.tar.gz";
      sha256 = "8884cae4ec6a2d593abcffd5e700626ad4618f42b11beb2b75998f2e8247de76";
    };

    buildInputs = with self; [ mock ]
      ++ optional isPy26 unittest2;

    propagatedBuildInputs = with self; []
      ++ optional isPy26 ordereddict
      ++ optional (isPy26 || isPy27 || isPyPy) futures;

    # Some of the tests fail on darwin with `error: AF_UNIX path too long'
    # because of the *long* path names for sockets
    patchPhase = optionalString stdenv.isDarwin ''
      sed -i -e "s|test_create_ssl_unix_connection|skip_test_create_ssl_unix_connection|" tests/test_events.py
      sed -i -e "s|test_create_unix_connection|skip_test_create_unix_connection|" tests/test_events.py
      sed -i -e "s|test_create_unix_connection|skip_test_create_unix_connection|" tests/test_events.py
      sed -i -e "s|test_create_unix_connection|skip_test_create_unix_connection|" tests/test_events.py
      sed -i -e "s|test_create_unix_server_existing_path_nonsock|skip_test_create_unix_server_existing_path_nonsock|" tests/test_unix_events.py
      sed -i -e "s|test_create_unix_server_existing_path_sock|skip_test_create_unix_server_existing_path_sock|" tests/test_unix_events.py
      sed -i -e "s|test_create_unix_server_ssl_verified|skip_test_create_unix_server_ssl_verified|" tests/test_events.py
      sed -i -e "s|test_create_unix_server_ssl_verified|skip_test_create_unix_server_ssl_verified|" tests/test_events.py
      sed -i -e "s|test_create_unix_server_ssl_verified|skip_test_create_unix_server_ssl_verified|" tests/test_events.py
      sed -i -e "s|test_create_unix_server_ssl_verify_failed|skip_test_create_unix_server_ssl_verify_failed|" tests/test_events.py
      sed -i -e "s|test_create_unix_server_ssl_verify_failed|skip_test_create_unix_server_ssl_verify_failed|" tests/test_events.py
      sed -i -e "s|test_create_unix_server_ssl_verify_failed|skip_test_create_unix_server_ssl_verify_failed|" tests/test_events.py
      sed -i -e "s|test_create_unix_server_ssl|skip_test_create_unix_server_ssl|" tests/test_events.py
      sed -i -e "s|test_create_unix_server_ssl|skip_test_create_unix_server_ssl|" tests/test_events.py
      sed -i -e "s|test_create_unix_server_ssl|skip_test_create_unix_server_ssl|" tests/test_events.py
      sed -i -e "s|test_create_unix_server|skip_test_create_unix_server|" tests/test_events.py
      sed -i -e "s|test_create_unix_server|skip_test_create_unix_server|" tests/test_events.py
      sed -i -e "s|test_create_unix_server|skip_test_create_unix_server|" tests/test_events.py
      sed -i -e "s|test_open_unix_connection_error|skip_test_open_unix_connection_error|" tests/test_streams.py
      sed -i -e "s|test_open_unix_connection_no_loop_ssl|skip_test_open_unix_connection_no_loop_ssl|" tests/test_streams.py
      sed -i -e "s|test_open_unix_connection|skip_test_open_unix_connection|" tests/test_streams.py
      sed -i -e "s|test_read_pty_output|skip_test_read_pty_output|" tests/test_events.py
      sed -i -e "s|test_write_pty|skip_test_write_pty|" tests/test_events.py
      sed -i -e "s|test_start_unix_server|skip_test_start_unix_server|" tests/test_streams.py
      sed -i -e "s|test_unix_sock_client_ops|skip_test_unix_sock_client_ops|" tests/test_events.py
      sed -i -e "s|test_unix_sock_client_ops|skip_test_unix_sock_client_ops|" tests/test_events.py
      sed -i -e "s|test_unix_sock_client_ops|skip_test_unix_sock_client_ops|" tests/test_events.py
    '' + optionalString isPy26 ''
      sed -i -e "s|test_env_var_debug|skip_test_env_var_debug|" tests/test_tasks.py
    '';

    meta = {
      description = "Port of the Tulip project (asyncio module, PEP 3156) on Python 2";
      homepage = "https://bitbucket.org/enovance/trollius";
      license = licenses.asl20;
      maintainers = with maintainers; [ garbas ];
    };
  };

  neovim = buildPythonPackage rec {
    version = "0.0.38";
    name = "neovim-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/n/neovim/${name}.tar.gz";
      sha256 = "93f475d5583a053af919ba0729b32b3fefef1dbde4717b5657d806bdc69b76b3";
    };

    propagatedBuildInputs = with self; [ msgpack ]
      ++ optional (!isPyPy) greenlet
      ++ optional (!isPy34) trollius;

    meta = {
      description = "Python client for Neovim";
      homepage = "https://github.com/neovim/python-client";
      license = licenses.asl20;
      maintainers = with maintainers; [ garbas ];
    };
  };

  neovim_gui = buildPythonPackage rec {
    name = "neovim-pygui-${self.neovim.version}";
    disabled = !isPy27;

    src = self.neovim.src;

    propagatedBuildInputs = [
      self.msgpack
      self.greenlet
      self.trollius
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
      url = "https://pypi.python.org/packages/source/g/ghp-import/${name}.tar.gz";
      sha256 = "6058810e1c46dd3b5b1eee87e203bdfbd566e10cfc77566edda7aa4dbf6a3053";
    };
    disabled = isPyPy;
    buildInputs = [ pkgs.glibcLocales ];

    LC_ALL="en_US.UTF-8";

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
      url = "https://pypi.python.org/packages/source/t/typogrify/${name}.tar.gz";
      sha256 = "8be4668cda434163ce229d87ca273a11922cb1614cb359970b7dc96eed13cb38";
    };
    disabled = isPyPy;
    # Wants to set up Django
    doCheck = false;
    propagatedBuildInputs = with self; [ django_1_9 smartypants jinja2 ];
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
    version = "2.15.1";
    name = "pypeg2-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pyPEG2/pyPEG2-${version}.tar.gz";
      sha256 = "f4814a5f9c84bbb0794bef8d2a5871f4aed25366791c55e2162681873ad8bd21";
    };

    meta = {
      description = "PEG parser interpreter in Python";
      homepage = http://fdik.org/pyPEG;
      license = licenses.gpl2;
    };
  };

  jenkins-job-builder = buildPythonPackage rec {
    name = "jenkins-job-builder-1.4.0";
    disabled = ! (isPy26 || isPy27);

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/j/jenkins-job-builder/${name}.tar.gz";
      sha256 = "10zipq3dyyfhwvrcyk70zky07b0fssiahwig2h8daw977aszsfqb";
    };

    patchPhase = ''
      sed -i '/ordereddict/d' requirements.txt
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
      url = "https://pypi.python.org/packages/source/d/dot2tex/dot2tex-2.9.0.tar.gz";
      sha256 = "7d3e54add7dccdaeb6cc9e61ceaf7b587914cf8ebd6821cfea008acdc1e50d4a";
    };

    propagatedBuildInputs = with self; [
      pyparsing
    ];

    meta = {
      description = "Convert graphs generated by Graphviz to LaTeX friendly formats";
      homepage = "https://github.com/kjellmf/dot2tex";
      license = licenses.mit;
    };
  };

  poezio = buildPythonPackage rec {
    name = "poezio-${version}";
    version = "0.9";

    namePrefix = "";
    disabled = (!isPy34);

    buildInputs = with self; [ pytest ];
    propagatedBuildInputs = with self ; [ aiodns slixmpp pyinotify potr ];

    checkPhase = ''
      PYTHONPATH="$PYTHONPATH:$out/${python.sitePackages}/poezio" make test
    '';

    patches =
      let patch_base = ../development/python-modules/poezio;
      in [ "${patch_base}/make_default_config_writable.patch" ];

    src = pkgs.fetchurl {
      url = "http://dev.louiz.org/attachments/download/91/${name}.tar.xz";
      sha256 = "1vc7zn4rp0ds0cdh1xcmbwx6w2qh4pnpzi5mdnj3rpl7xdr6jqzi";
    };

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
      url = "https://pypi.python.org/packages/source/p/python-potr/python-${name}.zip";
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
      url = "https://pypi.python.org/packages/source/p/pluggy/${name}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/x/xcffib/${name}.tar.gz";
      sha256 = "a84eecd5a1bb7570e26c83aca87a2016578ca4e353e1fa56189e95bdef063e6a";
    };

    patchPhase = ''
      # Hardcode cairo library path
      sed -e 's,ffi\.dlopen(,&"${pkgs.xorg.libxcb}/lib/" + ,' -i xcffib/__init__.py
    '';

    propagatedBuildInputs = [ self.cffi self.six ];

    meta = {
      description = "A drop in replacement for xpyb, an XCB python binding";
      homepage = "https://github.com/tych0/xcffib";
      license = licenses.asl20;
      maintainers = with maintainers; [ kamilchm ];
    };
  };

  pafy = buildPythonPackage rec {
    name = "pafy-${version}";
    version = "0.4.3";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pafy/${name}.tar.gz";
      sha256 = "1la4nn4n66p6dmcf1dyxw7i5j0xprmq82gwmxjv1jjis7vsnk254";
    };

    propagatedBuildInputs = with self; [ youtube-dl ];

    meta = with stdenv.lib; {
      description = "A library to download YouTube content and retrieve metadata";
      homepage = http://np1.github.io/pafy/;
      license = licenses.lgpl3Plus;
      maintainers = with maintainers; [ odi ];
    };
  };

  suds = buildPythonPackage rec {
    name = "suds-0.4";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/s/suds/suds-0.4.tar.gz";
      sha256 = "1w4s9051iv90c0gs73k80c3d51y2wbx1xgfdgg2hk7mv4gjlllnm";
    };

    patches = [ ../development/python-modules/suds-0.4-CVE-2013-2217.patch ];

    meta = with stdenv.lib; {
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
      url = "https://pypi.python.org/packages/source/s/suds-jurko/${name}.zip";
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

  maildir-deduplicate = buildPythonPackage rec {
    name = "maildir-deduplicate-${version}";
    version = "1.0.2";

    disabled = !isPy27;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/m/maildir-deduplicate/${name}.tar.gz";
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
    version = "0.2.6";

    disabled = (!isPy3k);

    src = pkgs.fetchFromGitHub {
      owner = "mps-youtube";
      repo = "mps-youtube";
      rev = "v${version}";
      sha256 = "1vbf60z2birbm7wc9irxy0jf5x3y32ncl8fw52v19xyx7fq10jrm";
    };

    propagatedBuildInputs = with self; [ pafy ];

    meta = with stdenv.lib; {
      description = "Terminal based YouTube player and downloader";
      homepage = http://github.com/np1/mps-youtube;
      license = licenses.gpl3;
      maintainers = with maintainers; [ odi ];
    };
  };

  d2to1 = buildPythonPackage rec {
    name = "d2to1-${version}";
    version = "0.2.11";

    buildInputs = with self; [ nose ];
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/d2to1/d2to1-${version}.tar.gz";
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
    version = "0.3.5";
    doCheck = false; #test needs packages too explicit
    buildInputs = with self; [ d2to1 ];
    propagatedBuildInputs = with self; [ requests2 ];

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/o/ovh/ovh-${version}.tar.gz";
      sha256 = "1y74lrdlgbb786mwas7ynphimfi00dgr67ncjq20kdf31jg5415n";
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
      url = "https://pypi.python.org/packages/source/W/Willow/Willow-${version}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/i/${simpleName}/${name}.tar.gz";
      sha256 = "194bl8l8sc2ibwi6g5kz6xydkbngdqpaj6r2gcsaw1fc73iswwrj";
    };

    propagatedBuildInputs = with self; [ six ];

    meta = {
      description = "Python Import Magic - automagically add, remove and manage imports";
      homepage = http://github.com/alecthomas/importmagic;
      license = "bsd";
    };
  };

  bepasty-server = buildPythonPackage rec {
    name = "bepasty-server-${version}";
    version = "0.4.0";
    propagatedBuildInputs = with self;[
      flask
      pygments
      xstatic
      xstatic-bootbox
      xstatic-bootstrap
      xstatic-jquery
      xstatic-jquery-file-upload
      xstatic-jquery-ui
      xstatic-pygments
    ];
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/b/bepasty/bepasty-${version}.tar.gz";
      sha256 = "0bs79pgrjlnkmjfyj2hllbx3rw757va5w2g2aghi9cydmsl7gyi4";
    };

    meta = {
      homepage = http://github.com/bepasty/bepasty-server;
      description = "binary pastebin server";
      license = licenses.mit;
      maintainers = [ maintainers.makefu ];
    };
  };

  xkcdpass = buildPythonPackage rec {
    name = "xkcdpass-${version}";
    version = "1.4.2";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/x/xkcdpass/xkcdpass-1.4.2.tar.gz";
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
      url = "https://pypi.python.org/packages/source/X/XStatic/XStatic-${version}.tar.gz";
      sha256 = "09npcsyf1ccygjs0qc8kdsv4qqy8gm1m6iv63g9y1fgbcry3vj8f";
    };
    meta = {
      homepage = http://bitbucket.org/thomaswaldmann/xstatic;
      description = "base packaged static files for python";
      license = licenses.mit;
      maintainers = [ maintainers.makefu ];
    };
  };

  xlsx2csv = buildPythonPackage rec {
    name = "xlsx2csv-${version}";
    version = "0.7.2";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/x/xlsx2csv/${name}.tar.gz";
      sha256 = "7c6c8fa6c2774224d03a6a96049e116822484dccfa3634893397212ebcd23866";
    };
    meta = {
      homepage = https://github.com/bitprophet/alabaster;
      description = "convert xlsx to csv";
      license = licenses.bsd3;
      maintainers = with maintainers; [ jb55 ];
    };
  };

  xmpppy = buildPythonPackage rec {
    name = "xmpp.py-${version}";
    version = "0.5.0rc1";

    src = pkgs.fetchurl {
      url = "mirror://sourceforge/xmpppy/xmpppy-${version}.tar.gz";
      sha256 = "16hbh8kwc5n4qw2rz1mrs8q17rh1zq9cdl05b1nc404n7idh56si";
    };

    preInstall = ''
      mkdir -p $out/bin $out/lib $out/share $(toPythonPath $out)
      export PYTHONPATH=$PYTHONPATH:$(toPythonPath $out)
    '';

    disabled = isPy3k;

    meta = {
      description = "XMPP python library";
    };
  };

  xstatic-bootbox = buildPythonPackage rec {
    name = "XStatic-Bootbox-${version}";
    version = "4.3.0.1";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/X/XStatic-Bootbox/XStatic-Bootbox-${version}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/X/XStatic-Bootstrap/XStatic-Bootstrap-${version}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/X/XStatic-jQuery/XStatic-jQuery-${version}.tar.gz";
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
      url = "https://pypi.python.org/packages/source/X/XStatic-jQuery-File-Upload/XStatic-jQuery-File-Upload-${version}.tar.gz";
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
    version = "1.11.0.1";
    propagatedBuildInputs = with self; [ xstatic-jquery ];
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/X/XStatic-jquery-ui/XStatic-jquery-ui-${version}.tar.gz";
      sha256 = "0n6sgg9jxrqfz4zg6iqdmx1isqx2aswadf7mk3fbi48dxcv1i6q9";
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
      url = "https://pypi.python.org/packages/source/X/XStatic-Pygments/XStatic-Pygments-${version}.tar.gz";
      sha256 = "0fjqgg433wfdnswn7fad1g6k2x6mf24wfnay2j82j0fwgkdxrr7m";
    };

    meta = {
      homepage = http://pygments.org;
      description = "pygments packaged static files for python";
      license = licenses.bsd2;
      maintainers = [ maintainers.makefu ];
    };
  };

  hidapi = buildPythonPackage rec{
    version = "0.7.99.post12";
    name = "hidapi-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/h/hidapi/${name}.tar.gz";
      sha256 = "1jaj0y5vn5yk033q01wacsz379mf3sy66d6gz072ycfr5rahcp59";
    };

    propagatedBuildInputs = with self; [ pkgs.libusb1 pkgs.udev cython ];

    # Fix the USB backend library lookup
    postPatch = ''
      libusb=${pkgs.libusb1}/include/libusb-1.0
      test -d $libusb || { echo "ERROR: $libusb doesn't exist, please update/fix this build expression."; exit 1; }
      sed -i -e "s|/usr/include/libusb-1.0|$libusb|" setup.py
    '';

    meta = {
      description = "A Cython interface to the hidapi from https://github.com/signal11/hidapi";
      homepage = https://github.com/trezor/cython-hidapi;
      # license can actually be either bsd3 or gpl3
      # see https://github.com/trezor/cython-hidapi/blob/master/LICENSE-orig.txt
      license = licenses.bsd3;
      maintainers = with maintainers; [ np ];
    };
  };

  mnemonic = buildPythonPackage rec{
    version = "0.12";
    name = "mnemonic-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/m/mnemonic/${name}.tar.gz";
      sha256 = "0j5jm4v54135qqw455fw4ix2mhxhzjqvxji9gqkpxagk31cvbnj4";
    };

    propagatedBuildInputs = with self; [ pbkdf2 ];

    meta = {
      description = "Implementation of Bitcoin BIP-0039";
      homepage = https://github.com/trezor/python-mnemonic;
      license = licenses.mit;
      maintainers = with maintainers; [ np ];
    };
  };

  trezor = buildPythonPackage rec{
    version = "0.6.11";
    name = "trezor-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/t/trezor/${name}.tar.gz";
      sha256 = "0nqbjj0mvkp314hpq36px12hxbyidmhsdflq3121l4g9y3scfbnx";
    };

    propagatedBuildInputs = with self; [ protobuf2_6 hidapi ];

    buildInputs = with self; [ ecdsa mnemonic ];

    # There are no actual tests: "ImportError: No module named tests"
    doCheck = false;

    meta = {
      description = "Python library for communicating with TREZOR Bitcoin Hardware Wallet";
      homepage = https://github.com/trezor/python-trezor;
      license = licenses.gpl3;
      maintainers = with maintainers; [ np ];
    };
  };

  keepkey = buildPythonPackage rec{
    version = "0.7.0";
    name = "keepkey-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/k/keepkey/${name}.tar.gz";
      sha256 = "1ikyp4jpydskznsrlwmxh9sn7b64aldwj2lf0phmb19r5kk06qmp";
    };

    propagatedBuildInputs = with self; [ protobuf2_6 hidapi ];

    buildInputs = with self; [ ecdsa mnemonic ];

    # There are no actual tests: "ImportError: No module named tests"
    doCheck = false;

    meta = {
      description = "KeepKey Python client";
      homepage = https://github.com/keepkey/python-keepkey;
      license = licenses.gpl3;
      maintainers = with maintainers; [ np ];
    };
  };

  semver = buildPythonPackage rec {
    name = "semver-${version}";
    version = "2.2.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/s/semver/${name}.tar.gz";
      sha256 = "161gvsfpw0l8lnf1v19rvqc8b9f8n70cc8ppya4l0n6rwc1c1n4m";
    };

    meta = {
      description = "Python package to work with Semantic Versioning (http://semver.org/)";
      homepage = "https://github.com/k-bx/python-semver";
      license = licenses.bsd3;
      maintainers = with maintainers; [ np ];
    };
  };

  ed25519 = buildPythonPackage rec {
    name = "ed25519-${version}";
    version = "1.4";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/e/ed25519/${name}.tar.gz";
      sha256 = "0ahx1nkxa0xis3cw0h5c4fpgv8mq4znkq7kajly33lc3317bk499";
    };

    meta = {
      description = "Ed25519 public-key signatures";
      homepage = "https://github.com/warner/python-ed25519";
      license = licenses.mit;
      maintainers = with maintainers; [ np ];
    };
  };

  trezor_agent = buildPythonPackage rec{
    version = "0.6.1";
    name = "trezor_agent-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/t/trezor_agent/${name}.tar.gz";
      sha256 = "0wpppxzld7kqqxdvy80qc8629n047vm3m3nk171i7hijfw285p0b";
    };

    propagatedBuildInputs = with self; [ trezor ecdsa ed25519 mnemonic keepkey semver ];

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
      url = "https://pypi.python.org/packages/source/x/x11_hash/${name}.tar.gz";
      sha256 = "172skm9xbbrivy1p4xabxihx9lsnzi53hvzryfw64m799k2fmp22";
    };

    meta = {
      description = "Binding for X11 proof of work hashing";
      homepage = https://github.com/mazaclub/x11_hash;
      license = licenses.mit;
      maintainers = with maintainers; [ np ];
    };
  };

}
