{ pkgs, stdenv, python, self }:

with pkgs.lib;

let
  isPy26 = python.majorVersion == "2.6";
  isPy27 = python.majorVersion == "2.7";
  isPy33 = python.majorVersion == "3.3";
  isPy34 = python.majorVersion == "3.4";
  isPyPy = python.executable == "pypy";
  isPy3k = strings.substring 0 1 python.majorVersion == "3";

  callPackage = pkgs.newScope self;

  buildPythonPackage = makeOverridable (callPackage ../development/python-modules/generic { });

  # Unique python version identifier
  pythonName =
    if isPy26 then "python26" else
    if isPy27 then "python27" else
    if isPy33 then "python33" else
    if isPy34 then "python34" else
    if isPyPy then "pypy" else "";

  modules = python.modules or {
    readline = null;
    sqlite3 = null;
    curses = null;
    curses_panel = null;
    crypt = null;
  };

  # glibcLocales doesn't build on Darwin
  localePath = optionalString (! stdenv.isDarwin) "${pkgs.glibcLocales}/lib/locale/locale-archive";

  pythonPackages = modules // import ./python-packages-generated.nix {
    inherit pkgs python;
    inherit (pkgs) stdenv fetchurl;
    self = pythonPackages;
  }
# Python packages for all python versions
// {

  inherit python isPy26 isPy27 isPy33 isPy34 isPyPy isPy3k pythonName buildPythonPackage;

  # helpers

  # global distutils config used by buildPythonPackage
  distutils-cfg = callPackage ../development/python-modules/distutils-cfg { };

  wrapPython = pkgs.makeSetupHook
    { deps = pkgs.makeWrapper;
      substitutions.libPrefix = python.libPrefix;
      substitutions.executable = "${python}/bin/${python.executable}";
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

    meta = with stdenv.lib; {
      description = "Python binding of libdiscid";
      homepage    = "https://python-discid.readthedocs.org/";
      license     = licenses.lgpl3Plus;
      platforms   = platforms.linux;
      maintainer  = with maintainers; [ iyzsong ];
    };

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/discid/${name}.tar.gz";
      md5 = "2ad2141452dd10b03ad96ccdad075235";
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

  ipython = callPackage ../shells/ipython {
    inherit pythonPackages;

    qtconsoleSupport = !pkgs.stdenv.isDarwin; # qt is not supported on darwin
    pylabQtSupport = !pkgs.stdenv.isDarwin;
    pylabSupport = !pkgs.stdenv.isDarwin; # cups is not supported on darwin
  };

  ipythonLight = lowPrio (self.ipython.override {
    qtconsoleSupport = false;
    pylabSupport = false;
    pylabQtSupport = false;
  });

  mpi4py = callPackage ../development/python-modules/mpi4py {
    mpi = pkgs.openmpi;
  };

  nixpart = callPackage ../tools/filesystems/nixpart { };

  # This is used for NixOps to make sure we won't break it with the next major
  # version of nixpart.
  nixpart0 = callPackage ../tools/filesystems/nixpart/0.4 { };

  pitz = callPackage ../applications/misc/pitz { };

  pycairo = callPackage ../development/python-modules/pycairo {
  };

  pycrypto = callPackage ../development/python-modules/pycrypto { };

  pygobject = callPackage ../development/python-modules/pygobject { };

  pygobject3 = callPackage ../development/python-modules/pygobject/3.nix { };

  pygtk = callPackage ../development/python-modules/pygtk { libglade = null; };

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
  };

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
      md5 = "5322888a21eb0bb2e749fbf98eddf574";
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

    meta = with stdenv.lib; {
      description = "ASCII art to image converter";
      homepage = https://launchpad.net/aafigure/;
      license = licenses.bsd2;
      platforms = platforms.linux;
      maintainers = [ maintainers.bjornfor ];
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

    meta = with stdenv.lib; {
      description = "Generate activity-diagram image from spec-text file (similar to Graphviz)";
      homepage = http://blockdiag.com/;
      license = licenses.asl20;
      platforms = platforms.linux;
      maintainers = [ maintainers.bjornfor ];
    };
  };


  afew = buildPythonPackage rec {
    rev = "9744c18c4d6b0a3e7f57b01e5fe145a60fc82a47";
    name = "afew-1.0_${rev}";

    src = pkgs.fetchurl {
      url = "https://github.com/teythoon/afew/tarball/${rev}";
      name = "${name}.tar.bz";
      sha256 = "1qyban022aji2hl91dh0j3xa6ikkxl5argc6w71yp2x8b02kp3mf";
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
      maintainers = [ stdenv.lib.maintainers.garbas ];
    };
  };


  alembic = buildPythonPackage rec {
    name = "alembic-0.6.6";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/a/alembic/${name}.tar.gz";
      md5 = "71e4a8f6849e1527abfc4ea33d51f37c";
    };

    buildInputs = with self; [ nose mock ];
    propagatedBuildInputs = with self; [ Mako sqlalchemy9 ];

    meta = {
      homepage = http://bitbucket.org/zzzeek/alembic;
      description = "A database migration tool for SQLAlchemy";
      license = stdenv.lib.licenses.mit;
    };
  };


  almir = buildPythonPackage rec {
    name = "almir-0.1.8";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/a/almir/${name}.zip";
      md5 = "9a1f3c72a039622ca72b74be7a1cd37e";
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
      self.sqlalchemy
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
      maintainers = [ stdenv.lib.maintainers.iElectric ];
      platforms = stdenv.lib.platforms.all;
    };
  };


  alot = buildPythonPackage rec {
    rev = "fa4ddf000dc2ac4933852b210901b649634a5f86";
    name = "alot-0.3.5_${rev}";

    src = pkgs.fetchurl {
      url = "https://github.com/pazz/alot/tarball/${rev}";
      name = "${name}.tar.bz";
      sha256 = "0h11lqyxg0xbkc9y1xqjvd0kmfm5pdwnmv9chmlsi1614dxn08n0";
    };

    # error: invalid command 'test'
    doCheck = false;

    propagatedBuildInputs =
      [ self.notmuch
        self.urwid
        self.twisted
        self.magic
        self.configobj
        self.pygpgme
      ];

    postInstall = ''
      wrapProgram $out/bin/alot \
        --prefix LD_LIBRARY_PATH : ${pkgs.notmuch}/lib:${pkgs.file}/lib:${pkgs.gpgme}/lib
    '';

    meta = {
      homepage = https://github.com/pazz/alot;
      description = "Terminal MUA using notmuch mail";
      maintainers = [ stdenv.lib.maintainers.garbas ];
    };
  };


  anyjson = buildPythonPackage rec {
    name = "anyjson-0.3.3";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/a/anyjson/${name}.tar.gz";
      md5 = "2ea28d6ec311aeeebaf993cb3008b27c";
    };

    buildInputs = with self; [ self.nose ];

    meta = {
      homepage = http://pypi.python.org/pypi/anyjson/;
      description = "Wrapper that selects the best available JSON implementation";
    };
  };


  amqplib = buildPythonPackage rec {
    name = "amqplib-0.6.1";

    src = pkgs.fetchurl {
      url = "http://py-amqplib.googlecode.com/files/${name}.tgz";
      sha1 = "f124e5e4a6644bf6d1734032a01ac44db1b25a29";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://code.google.com/p/py-amqplib/;
      description = "Python client for the Advanced Message Queuing Procotol (AMQP)";
    };
  };


  application = buildPythonPackage rec {
    name = "python-application-${version}";
    version = "1.4.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/python-application/${name}.tar.gz";
      sha256 = "3ae188e9dfd4bd63c9b43aebbf1d9de5df03fb5ac01e72f3bff5b41007570275";
    };
  };


  apsw = buildPythonPackage rec {
    name = "apsw-3.7.6.2-r1";
    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "http://apsw.googlecode.com/files/${name}.zip";
      sha1 = "fa4aec08e59fa5964197f59ba42408d64031675b";
    };

    buildInputs = with self; [ pkgs.sqlite ];

    # python: double free or corruption (fasttop): 0x0000000002fd4660 ***
    doCheck = false;

    meta = {
      description = "A Python wrapper for the SQLite embedded relational database engine";
      homepage = http://code.google.com/p/apsw/;
    };
  };


  apscheduler = buildPythonPackage rec {
    name = "APScheduler-3.0.1";

    propagatedBuildInputs = with self; [ futures tzlocal six pytest mock sqlalchemy9 ];

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/A/APScheduler/${name}.tar.gz";
      sha256 = "1dcyk58svhhd7flpq0fbyzcp0z3a1as4ddmdv1rxqvqng0sxhwaf";
    };

    meta = with pkgs.stdenv.lib; {
      description = "Advanced Python Scheduler (APScheduler) is a Python library that lets you schedule your Python code to be executed";
      homepage = http://pypi.python.org/pypi/APScheduler/;
      license = licenses.mit;
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
    version = "0.4.4";

    src = pkgs.fetchurl {
      url    = "https://pypi.python.org/packages/source/a/arrow/${name}.tar.gz";
      sha256 = "1sdr4gyjgvz86yr0ll0i11mgy8l1slndr7f0ngam87rpy78gp052";
    };

    doCheck = false;

    meta = {
      description = "Twitter API library";
      license     = "apache";
      maintainers = [ maintainers.thoughtpolice ];
    };
  };

  async = buildPythonPackage rec {
    name = "async-0.6.1";
    disabled = isPy3k;
    meta.maintainers = [ stdenv.lib.maintainers.mornfall ];

    buildInputs = with self; [ pkgs.zlib ];
    doCheck = false;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/a/async/${name}.tar.gz";
      sha256 = "1lfmjm8apy9qpnpbq8g641fd01qxh9jlya5g2d6z60vf8p04rla1";
    };
  };

  argparse = buildPythonPackage (rec {
    name = "argparse-1.2.1";

    src = pkgs.fetchurl {
      url = "http://argparse.googlecode.com/files/${name}.tar.gz";
      sha256 = "192174mys40m0bwk6l5jlfnzps0xi81sxm34cqms6dc3c454pbyx";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://code.google.com/p/argparse/;

      license = stdenv.lib.licenses.asl20;

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

  astroid = buildPythonPackage (rec {
    name = "astroid-1.3.2";
    propagatedBuildInputs = with self; [ logilab_common six ];
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/a/astroid/${name}.tar.gz";
      md5 = "2ab96129a977b6eba27765a15d1a9bf2";
    };
  });

  audioread = buildPythonPackage rec {
    name = "audioread-1.2.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/a/audioread/${name}.tar.gz";
      md5 = "01a80357f38dbd9bf8d7403802df89ac";
    };

    meta = {
      description = "Cross-platform audio decoding";
      homepage = "https://github.com/sampsyo/audioread";
      license = stdenv.lib.licenses.mit;
    };
  };

  audiotools = buildPythonPackage rec {
    name = "audiotools-2.22";

    src = pkgs.fetchurl {
      url = "mirror://sourceforge/audiotools/${name}.tar.gz";
      sha256 = "1c52pggsbxdbj8h92njf4h0jgfndh4yv58ad723pidys47nw1y71";
    };

    meta = {
      description = "Utilities and Python modules for handling audio.";
      homepage = "http://audiotools.sourceforge.net/";
      license = stdenv.lib.licenses.gpl2Plus;
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

    meta = with stdenv.lib; {
      description = "A tool that automatically formats Python code to conform to the PEP 8 style guide";
      homepage = https://pypi.python.org/pypi/autopep8/;
      license = licenses.mit;
      platforms = platforms.all;
      maintainers = [ maintainers.bjornfor ];
    };
  });

  avro = buildPythonPackage (rec {
    name = "avro-1.7.6";

    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/a/avro/${name}.tar.gz";
      md5 = "7f4893205e5ad69ac86f6b44efb7df72";
    };

    meta = with stdenv.lib; {
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

    meta = with stdenv.lib; {
      description = "A serialization and RPC framework";
      homepage = "https://pypi.python.org/pypi/avro3k/";
    };
  }));

  azure = buildPythonPackage rec {
    version = "0.9.0";
    name = "azure-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/a/azure/${name}.zip";
      md5 = "9616767cf45c1c00794624e2a0889f23";
    };

    propagatedBuildInputs = with self; [ dateutil ];

    meta = with stdenv.lib; {
      description = "Microsoft Azure SDK for Python";
      homepage = "http://azure.microsoft.com/en-us/develop/python/";
      license = licenses.asl20;
    };
  };

  backports_ssl_match_hostname_3_4_0_2 = self.buildPythonPackage rec {
    name = "backports.ssl_match_hostname-3.4.0.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/b/backports.ssl_match_hostname/backports.ssl_match_hostname-3.4.0.2.tar.gz";
      md5 = "788214f20214c64631f0859dc79f23c6";
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
      md5 = "c3d109746aefa86268e500c07d7e8e0f";
    };

    buildInputs = [ pkgs.lzma ];

    meta = {
      describe = "Backport of Python 3.3's 'lzma' module for XZ/LZMA compressed files.";
      homepage = https://github.com/peterjc/backports.lzma;
      license = stdenv.lib.licenses.bsd3;
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
      description = "A module to work with countries and languages.";
      license = stdenv.lib.licenses.bsd3;
    };
  };

  batinfo = buildPythonPackage rec {
    version = "0.1.9";
    name = "batinfo-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/b/batinfo/${name}.tar.gz";
      sha256 = "0ppzbh8lii16xfq5piczn82hwps1fnbq9rbwwl3rdpdx0n86l560";
    };

    meta = with stdenv.lib; {
      homepage = https://github.com/nicolargo/batinfo;
      description = "A simple Python lib to retrieve battery information";
      license = licenses.lgpl3;
      platforms = platforms.all;
      maintainers = [ maintainers.koral ];
    };
  };

  bcdoc = buildPythonPackage rec {
    name = "bcdoc-0.12.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/b/bcdoc/bcdoc-0.12.1.tar.gz";
      md5 = "7c8617347c294ea4d36ec73fb5b2c26e";
    };

    buildInputs = with self; [ self.docutils self.six ];

    meta = {
      homepage = https://github.com/botocore/bcdoc;
      license = stdenv.lib.licenses.asl20;
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
    name = "beautifulsoup4-4.1.3";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/b/beautifulsoup4/${name}.tar.gz";
      md5 = "f1481ed77336de77a2d8e5b061b6ad62";
    };

    # invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://crummy.com/software/BeautifulSoup/bs4/;
      description = "HTML and XML parser";
      license = stdenv.lib.licenses.mit;
      maintainers = [ stdenv.lib.maintainers.iElectric ];
    };
  });


  beaker = buildPythonPackage rec {
    name = "Beaker-1.6.4";

    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/B/Beaker/${name}.tar.gz";
      md5 = "c2e102870ed4c53104dec48ceadf8e9d";
    };

    buildInputs =
      [ self.sqlalchemy
        self.pycryptopp
        self.nose
        self.mock
        self.webtest
      ];

    # http://hydra.nixos.org/build/4511591/log/raw
    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.iElectric
      ];
      platforms = stdenv.lib.platforms.all;
    };
  };


  bedup = buildPythonPackage rec {
    name = "bedup-20140413";

    src = pkgs.fetchgit {
      url = "https://github.com/g2p/bedup.git";
      rev = "5189e166145b8954ac41883f81ef3c3b50dc96ab";
      sha256 = "e61768fa19934bd176799f90bda3ea9f49a5def21fa2523a8e47df8a48e730e9";
    };

    buildInputs = with self; [ pkgs.btrfsProgs ];
    propagatedBuildInputs = with self; [ contextlib2 sqlalchemy9 pyxdg pycparser alembic ]
      ++ optionals (!isPyPy) [ cffi ];

    meta = {
      description = "Deduplication for Btrfs";
      longDescription = ''
        Deduplication for Btrfs. bedup looks for new and changed files, making sure that multiple
        copies of identical files share space on disk. It integrates deeply with btrfs so that scans
        are incremental and low-impact.
      '';
      homepage = https://github.com/g2p/bedup;
      license = stdenv.lib.licenses.gpl2;

      platforms = stdenv.lib.platforms.linux;

      maintainers = [ stdenv.lib.maintainers.bluescreen303 ];
    };
  };

  circus = buildPythonPackage rec {
    name = "circus-0.11.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/c/circus/${name}.tar.gz";
      md5 = "5c07cdbe9bb4a9b82e52737ad590617b";
    };

    doCheck = false; # weird error

    propagatedBuildInputs = with self; [ iowait psutil pyzmq tornado mock ];
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
    buildInputs = with pkgs; [ liblapack blas ];
    meta = with stdenv.lib; {
      homepage = "http://cvxopt.org/";
      description = "Python Software for Convex Optimization";
      maintainers = with maintainers; [ edwtjo ];
      license = licenses.gpl3Plus;
    };
  };

  iowait = buildPythonPackage rec {
    name = "iowait-0.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/i/iowait/${name}.tar.gz";
      md5 = "f49ca7766fe4a67e03a731e575614f87";
    };

    meta = with stdenv.lib; {
      description = "Platform-independent module for I/O completion events";
      homepage = https://launchpad.net/python-iowait;
    };
  };

  responses = self.buildPythonPackage rec {
    name = "responses-0.2.2";

    propagatedBuildInputs = with self; [ requests mock six pytest flake8 ];

    doCheck = false;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/r/responses/responses-0.2.2.tar.gz";
      md5 = "5d79fd425cf8d858dfc8afa6475395d3";
    };

  };

  rarfile = self.buildPythonPackage rec {
    name = "rarfile-2.6";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/r/rarfile/rarfile-2.6.tar.gz";
      md5 = "50ce3f3fdb9196a00059a5ea7b3739fd";
    };

    meta = with stdenv.lib; {
      description = "rarfile - RAR archive reader for Python";
      homepage = https://github.com/markokr/rarfile;
    };
  };

  pyechonest = self.buildPythonPackage rec {
    name = "pyechonest-8.0.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pyechonest/pyechonest-8.0.2.tar.gz";
      md5 = "5586fe8ece7af4e24f71ea740185127e";
    };

    meta = with stdenv.lib; {
      description = "Tap into The Echo Nest's Musical Brain for the best music search, information, recommendations and remix tools on the web";
      homepage = https://github.com/echonest/pyechonest;
    };
  };


  bitbucket_api = buildPythonPackage rec {
    name = "bitbucket-api-0.4.4";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/b/bitbucket-api/${name}.tar.gz";
      md5 = "6f3cee3586c4aad9c0b2e04fce9704fb";
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
       md5 = "79cdbdc6c95dfa313d12cbdef406c9f2";
    };

    pythonPath = [ self.requests ];

    meta = with stdenv.lib; {
      description = "Bitbucket command line interface";
      homepage = "https://bitbucket.org/zhemao/bitbucket-cli";
      maintainers = [ maintainers.refnil ];
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

    meta = with stdenv.lib; {
      description = "Module for binary data manipulation";
      homepage = https://code.google.com/p/python-bitstring/;
      license = licenses.mit;
      platforms = platforms.linux;
      maintainers = [ maintainers.bjornfor ];
    };
  };

  bleach = buildPythonPackage rec {
    version = "v1.4";
    name = "bleach-${version}";

    src = pkgs.fetchurl {
      url = "http://github.com/jsocol/bleach/archive/${version}.tar.gz";
      sha256 = "19v0zhvchz89w179rwkc4ah3cj2gbcng9alwa2yla89691g8b0b0";
    };

    propagatedBuildInputs = with self; [ six html5lib ];

    meta = with stdenv.lib; {
      description = "An easy, HTML5, whitelisting HTML sanitizer.";
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
      md5 = "66e9688f2d287593a0e698cd8a5fbc57";
    };

    meta = with stdenv.lib; {
      homepage = http://pythonhosted.org/blinker/;
      description = "Fast, simple object-to-object and broadcast signaling";
      license = licenses.mit;
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

    meta = with stdenv.lib; {
      description = "Generate block-diagram image from spec-text file (similar to Graphviz)";
      homepage = http://blockdiag.com/;
      license = licenses.asl20;
      platforms = platforms.linux;
      maintainers = [ maintainers.bjornfor ];
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
       maintainers = [
         stdenv.lib.maintainers.iElectric
       ];
     };
   };


  boto = buildPythonPackage rec {
    name = "boto-${version}";
    version = "2.34.0";

    src = pkgs.fetchurl {
      url = "https://github.com/boto/boto/archive/${version}.tar.gz";
      sha256 = "08zavyn02qng9y0251a9mrlkb3aw33m7gx5kc97hwngl3xk3s777";
    };

    # The tests seem to require AWS credentials.
    doCheck = false;

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

  botocore = buildPythonPackage rec {
    version = "0.80.0";
    name = "botocore-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/b/botocore/${name}.tar.gz";
      sha256 = "1zmsg0n21wq25v1dgnmf3hvw8yszxyryiylmp4alybcsg8nkg5fz";
    };

    propagatedBuildInputs =
      [ self.dateutil
        self.requests
        self.jmespath
      ];

    meta = {
      homepage = https://github.com/boto/botocore;

      license = "bsd";

      description = "A low-level interface to a growing number of Amazon Web Services";

    };
  };

  bottle = buildPythonPackage rec {
    version = "0.12.7";
    name = "bottle-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/b/bottle/${name}.tar.gz";
      sha256 = "0wr0gfz0bqlzhxk691x0xnf80b8v5pnl3jpnbgs1m9bcy28j3sp3";
    };

    propagatedBuildInputs = with self; [ setuptools ];

    meta = with stdenv.lib; {
      homepage = http://bottlepy.org;
      description = "A fast and simple micro-framework for small web-applications";
      license = licenses.mit;
      platforms = platforms.all;
      maintainers = [ maintainers.koral ];
    };
  };

  box2d = buildPythonPackage rec {
    name = "box2d-${version}";
    version = "2.3b0";
    disabled = (!isPy27);

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/B/Box2D/Box2D-2.3b0.zip";
      md5="25fc4f69cd580bdca0022ac3ace53865";
    };

    patches = [ ../development/python-modules/box2d/disable-test.patch ];

    propagatedBuildInputs = [ pkgs.swig pkgs.box2d ];

    meta = with stdenv.lib; {
      homepage = https://code.google.com/p/pybox2d/;
      description = ''
        A 2D game physics library for Python under
        the very liberal zlib license
      '';
      license = licenses.zlib;
      platforms = platforms.all;
      maintainers = [ maintainers.sepi ];
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

    meta = with stdenv.lib; {
      homepage =  http://github.com/ralphbean/bugwarrior;
      description = "Sync github, bitbucket, bugzilla, and trac issues with taskwarrior";
      license = licenses.gpl3Plus;
      platforms = platforms.all;
      maintainers = [ maintainers.pierron ];
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

    meta = with stdenv.lib; {
      homepage = https://fedorahosted.org/python-bugzilla/;
      description = "Bugzilla XMLRPC access module";
      license = licenses.gpl2;
      platforms = platforms.all;
      maintainers = [ maintainers.pierron ];
    };
  };

  buildout = self.zc_buildout;
  buildout152 = self.zc_buildout152;

  # A patched version of buildout, useful for buildout based development on Nix
  zc_buildout_nix = callPackage ../development/python-modules/buildout-nix { };

  zc_recipe_egg = self.zc_recipe_egg_buildout171;
  zc_buildout = self.zc_buildout171;
  zc_buildout2 = self.zc_buildout221;
  zc_buildout221 = buildPythonPackage rec {
    name = "zc.buildout-2.2.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zc.buildout/${name}.tar.gz";
      md5 = "476a06eed08506925c700109119b6e41";
    };

   meta = {
      homepage = "http://www.buildout.org";
      description = "A software build and configuration system";
      license = licenses.zpt21;
      maintainers = [ stdenv.lib.maintainers.garbas ];
    };
  };

  zc_buildout171 = buildPythonPackage rec {
    name = "zc.buildout-1.7.1";

    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zc.buildout/${name}.tar.gz";
      md5 = "8834a21586bf2be53dc412002241a996";
    };

   meta = {
      homepage = "http://www.buildout.org";
      description = "A software build and configuration system";
      license = licenses.zpt21;
      maintainers = [ stdenv.lib.maintainers.garbas ];
    };
  };

  zc_buildout152 = buildPythonPackage rec {
    name = "zc.buildout-1.5.2";

    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zc.buildout/${name}.tar.gz";
      md5 = "87f7b3f8d13926c806242fd5f6fe36f7";
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
      maintainers = [ stdenv.lib.maintainers.garbas ];
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
  };
  zc_recipe_egg_buildout171 = self.zc_recipe_egg_fun {
    buildout = self.zc_buildout171;
    version = "1.3.2";
    md5 = "1cb6af73f527490dde461d3614a36475";
  };
  zc_recipe_egg_buildout2 = self.zc_recipe_egg_fun {
    buildout = self.zc_buildout2;
    version = "2.0.1";
    md5 = "5e81e9d4cc6200f5b1abcf7c653dd9e3";
  };

  bunch = buildPythonPackage (rec {
    name = "bunch-1.0.1";
    meta.maintainers = [ stdenv.lib.maintainers.mornfall ];

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/b/bunch/${name}.tar.gz";
      sha256 = "1akalx2pd1fjlvrq69plvcx783ppslvikqdm93z2sdybq07pmish";
    };
    doCheck = false;
  });


  cairocffi = buildPythonPackage rec {
    name = "cairocffi-0.5.4";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/c/cairocffi/${name}.tar.gz";
      md5 = "e3fa4002583bfaa88b156e1af9c75bde";
    };

    propagatedBuildInputs = with self; [ cffi ];

    meta = {
      homepage = https://github.com/SimonSapin/cairocffi;
      license = "bsd";
      description = "cffi-based cairo bindings for Python";
    };
  };


  carrot = buildPythonPackage rec {
    name = "carrot-0.10.7";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/c/carrot/${name}.tar.gz";
      md5 = "530a0614de3a669314c3acd4995c54d5";
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

  certifi = buildPythonPackage rec {
    name = "certifi-${version}";
    version = "14.05.14";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/c/certifi/${name}.tar.gz";
      sha256 = "0s8vxzfz6s4m6fvxc7z25k9j35w0rh6jkw3wwcd1az1mssncn6qy";
    };

    meta = with stdenv.lib; {
      homepage = http://certifi.io/;
      description = "Python package for providing Mozilla's CA Bundle";
      license = licenses.isc;
      maintainers = [ maintainers.koral ];
    };
  };

  characteristic = buildPythonPackage rec {
    name = "characteristic-14.1.0";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/c/characteristic/${name}.tar.gz";
      md5 = "68ea7e28997fc57d3631791ec0567a05";
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
      md5 = "853917116e731afbc8c8a43c37e6ddba";
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

    meta = with stdenv.lib; {
      description = "This module implements a very fast JSON encoder/decoder for Python.";
      homepage    = "http://ag-projects.com/";
      license     = licenses.lgpl2;
      platforms   = platforms.all;
    };
  };


  click = buildPythonPackage {
    name = "click-2.1";
    src = pkgs.fetchurl {
      url = https://pypi.python.org/packages/source/c/click/click-2.1.tar.gz;
      md5 = "0ba97ba09af82c56e2d35f3412d0aa6e";
    };
    meta = {
      homepage = "http://click.pocoo.org/";
      description = "A Python package for creating beautiful command line interfaces in a composable way with as little code as necessary";
      license = stdenv.lib.licenses.bsd3;
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


  cogapp = buildPythonPackage rec {
    version = "2.3";
    name    = "cogapp-${version}";

    src = pkgs.fetchurl {
      url    = "https://pypi.python.org/packages/source/c/cogapp/${name}.tar.gz";
      sha256 = "0gzmzbsk54r1qa6wd0yg4zzdxvn2f19ciprr2acldxaknzrpllnn";
    };

    # there are no tests
    doCheck = false;

    meta = with stdenv.lib; {
      description = "A code generator for executing Python snippets in source files";
      homepage    = http://nedbatchelder.com/code/cog;
      license     = licenses.mit;
      maintainers = with maintainers; [ lovek323 ];
      platforms   = platforms.unix;
    };
  };


  colorama = buildPythonPackage rec {
    name = "colorama-0.2.5";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/c/colorama/colorama-0.2.5.tar.gz";
      md5 = "308c6e38917bdbfc4d3b0783c614897d";
    };

    propagatedBuildInputs = with self; [ self.clientform ];

    doCheck = false;

    meta = {
      homepage = http://code.google.com/p/colorama/;
      license = "bsd";
      description = "Cross-platform colored terminal text";
    };
  };


  coilmq = buildPythonPackage (rec {
    name = "coilmq-0.6.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/C/CoilMQ/CoilMQ-0.6.1.tar.gz";
      md5 = "5f39727415b837abd02651eeb2721749";
    };

    propagatedBuildInputs = with self; [ self.stompclient ];

    preConfigure = ''
      sed -i '/distribute/d' setup.py
    '';

    buildInputs = with self; [ self.coverage self.sqlalchemy ];

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
    name = "colander-1.0b1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/c/colander/${name}.tar.gz";
      md5 = "89f2cf4b5c87d43f7917d6a0d4872e6a";
    };

    propagatedBuildInputs = with self; [ self.translationstring ];

    meta = {
      maintainers = [
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.iElectric
      ];
      platforms = stdenv.lib.platforms.all;
    };
  };


  ColanderAlchemy = buildPythonPackage rec {
    name = "ColanderAlchemy-0.2.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/C/ColanderAlchemy/${name}.tar.gz";
      md5 = "b054837bd2753cbf15f7d5028cba421b";
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
      md5 = "e472a3a1c2a67bb0ec9b5d54c13a47d6";
    };

    # error: invalid command 'test'
    doCheck = false;

    propagatedBuildInputs = with self; [ six ];

    meta = {
      description = "Config file reading, writing and validation";
      homepage = http://pypi.python.org/pypi/configobj;
      license = licenses.bsd3;
      maintainers = [ stdenv.lib.maintainers.garbas ];
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
      platforms = stdenv.lib.platforms.linux;
    };
  };


  construct = buildPythonPackage rec {
    name = "construct-2.5.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/c/construct/${name}.tar.gz";
      sha256 = "084h02p0m8lhmlywlwjdg0kd0hd6sz481c96qwcm5wddxrqn4nv6";
    };

    propagatedBuildInputs = with self; [ six ];

    meta = with stdenv.lib; {
      description = "Powerful declarative parser (and builder) for binary data";
      homepage = http://construct.readthedocs.org/;
      license = licenses.mit;
      platforms = platforms.linux;
      maintainers = [ maintainers.bjornfor ];
    };
  };


  contextlib2 = buildPythonPackage rec {
    name = "contextlib2-0.4.0";

    src = pkgs.fetchurl rec {
      url = "https://pypi.python.org/packages/source/c/contextlib2/${name}.tar.gz";
      md5 = "ea687207db25f65552061db4a2c6727d";
    };
  };

  coverage = buildPythonPackage rec {
    name = "coverage-3.6";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/c/coverage/${name}.tar.gz";
      md5 = "67d4e393f4c6a5ffc18605409d2aa1ac";
    };

    meta = {
      description = "Code coverage measurement for python";
      homepage = http://nedbatchelder.com/code/coverage/;
      license = licenses.bsd3;
    };
  };

  covCore = buildPythonPackage rec {
    name = "cov-core-1.7";
    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/c/cov-core/cov-core-1.7.tar.gz";
      md5 = "59c1e22e636633e10120beacbf45b28c";
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
      license = stdenv.lib.licenses.mit;
    };
  };

  cython = buildPythonPackage rec {
    name = "Cython-0.20.1";

    src = pkgs.fetchurl {
      url = "http://www.cython.org/release/${name}.tar.gz";
      sha256 = "0v3nc9z5ynnnjdgcgkyy5g9wazmkjv53nnpjal1v3mr199s6799i";
    };

    setupPyBuildFlags = ["--build-base=$out"];

    buildInputs = with self; [ pkgs.pkgconfig ];

    meta = {
      description = "An interpreter to help writing C extensions for Python 2";
      platforms = stdenv.lib.platforms.all;
    };
  };

  cryptacular = buildPythonPackage rec {
    name = "cryptacular-1.4.1";

    buildInputs = with self; [ coverage nose ];
    propagatedBuildInputs = with self; [ pbkdf2 modules.crypt ];

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/c/cryptacular/${name}.tar.gz";
      md5 = "fe12232ac660185186dd8057d8ca7b0e";
    };

    # TODO: tests fail: TypeError: object of type 'NoneType' has no len()
    doCheck = false;

    meta = {
      maintainers = [ stdenv.lib.maintainers.iElectric ];
    };
  };

  cryptography = buildPythonPackage rec {
    name = "cryptography-0.6.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/c/cryptography/${name}.tar.gz";
      sha256 = "17ij2acy28ryxahiq64lpf71d5z3sa9xhr4pjv7a1v81189i0j82";
    };

    buildInputs = [ pkgs.openssl self.pretend self.cryptography_vectors
                    self.iso8601 self.pyasn1 self.pytest ];
    propagatedBuildInputs = [ self.six self.cffi  ];
  };

  cryptography_vectors = buildPythonPackage rec {
    name = "cryptography_vectors-0.6.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/c/cryptography-vectors/${name}.tar.gz";
      sha256 = "1ks1xdb1ff74qmjdzqcfvkrwsbnwpsjgg3cy18zh37p8985cvl3r";
    };
  };

  pretend = buildPythonPackage rec {
    name = "pretend-1.0.8";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pretend/pretend-1.0.8.tar.gz";
      sha256 = "0r5r7ygz9m6d2bklflbl84cqhjkc2q12xgis8268ygjh30g2q3wk";
    };

    meta = with stdenv.lib; {
      homepage = https://github.com/alex/pretend;
      license = licenses.bsd3;
    };
  };


  detox = self.buildPythonPackage rec {
    name = "detox-0.9.3";

    propagatedBuildInputs = with self; [ tox py eventlet ];

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/detox/detox-0.9.3.tar.gz";
      md5 = "b52588ec61cd4c2d33e419677a5eac8c";
    };

    meta = with stdenv.lib; {
      description = "What is detox?";
      homepage = http://bitbucket.org/hpk42/detox;
    };
  };


  pbkdf2 = buildPythonPackage rec {
    name = "pbkdf2-1.3";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pbkdf2/${name}.tar.gz";
      md5 = "40cda566f61420490206597243dd869f";
    };

    # ImportError: No module named test
    doCheck = false;

    meta = {
      maintainers = [ stdenv.lib.maintainers.iElectric ];
    };
  };

  bcrypt = buildPythonPackage rec {
    name = "bcrypt-1.0.2";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/b/bcrypt/${name}.tar.gz";
      md5 = "c5df008669d17dd6eeb5e2042d5e136f";
    };

    buildInputs = with self; [ pycparser mock pytest py ] ++ optionals (!isPyPy) [ cffi ];

    meta = {
      maintainers = [ stdenv.lib.maintainers.iElectric ];
    };
  };

  cffi = buildPythonPackage rec {
    name = "cffi-0.8.6";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/c/cffi/${name}.tar.gz";
      sha256 = "0406j3sgndmx88idv5zxkkrwfqxmjl18pj8gf47nsg4ymzixjci5";
    };

    propagatedBuildInputs = with self; [ pkgs.libffi pycparser ];

    meta = {
      maintainers = [ stdenv.lib.maintainers.iElectric ];
    };
  };

  pycollada = buildPythonPackage rec {
    name = "pycollada-0.4.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pycollada/${name}.tar.gz";
      sha256 = "0i50lh98550pwr95zgzrgiqzsspm09wl52xlv83y5nrsz4mblylv";
    };

    # pycollada-0.4 needs python-dateutil==1.5
    buildInputs = with self; [ dateutil_1_5 numpy ];

    # Some tests fail because they refer to test data files that don't exist
    # (upstream packaging issue)
    doCheck = false;

    meta = with stdenv.lib; {
      description = "Python library for reading and writing collada documents";
      homepage = http://pycollada.github.io/;
      license = "BSD"; # they don't specify which BSD variant
      platforms = with platforms; linux ++ darwin;
      maintainers = [ maintainers.bjornfor ];
    };
  };

  pycparser = buildPythonPackage rec {
    name = "pycparser-2.10";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pycparser/${name}.tar.gz";
      md5 = "d87aed98c8a9f386aa56d365fe4d515f";
    };

    # ImportError: No module named test
    doCheck = false;

    meta = {
      maintainers = [ stdenv.lib.maintainers.iElectric ];
    };
  };

  pytest = buildPythonPackage rec {
    name = "pytest-2.6.2";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pytest/${name}.tar.gz";
      md5 = "0a1735fb1d481ef3864f34678607ba85";
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

    meta = with stdenv.lib; {
      maintainers = with maintainers; [ iElectric lovek323 madjar ];
      platforms = platforms.unix;
    };
  };

  pytest_xdist = buildPythonPackage rec {
    name = "pytest-xdist-1.8";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pytest-xdist/pytest-xdist-1.8.zip";
      md5 = "9c0b8efe9d43b460f8cf049fa46ce14d";
    };

    buildInputs = with self; [ pytest ];
    propagatedBuildInputs = with self; [ execnet ];

    meta = {
      description = "py.test xdist plugin for distributed testing and loop-on-failing modes";
      homepage = http://bitbucket.org/hpk42/pytest-xdist;
    };
  };

  cssselect = buildPythonPackage rec {
    name = "cssselect-0.7.1";
    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/c/cssselect/cssselect-0.7.1.tar.gz";
      md5 = "c6c5e9a2e7ca226ce03f6f67a771379c";
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

      license = stdenv.lib.licenses.lgpl3Plus;
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


  dateutil = buildPythonPackage (rec {
    name = "dateutil-2.2";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/python-dateutil/python-${name}.tar.gz";
      sha256 = "0s74ad6r789810s10dxgvaf48ni6adac2icrdad34zxygqq6bj7f";
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

    preBuild = ''
      export LOCALE_ARCHIVE=${localePath}
      export LC_ALL="en_US.UTF-8"
    '';

    meta = {
      description = "Powerful extensions to the standard datetime module";
      homepage = http://pypi.python.org/pypi/python-dateutil;
      license = "BSD-style";
    };
  });


  decorator = buildPythonPackage rec {
    name = "decorator-3.4.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/d/decorator/${name}.tar.gz";
      md5 = "1e8756f719d746e2fc0dd28b41251356";
    };

    meta = {
      homepage = http://pypi.python.org/pypi/decorator;
    };
  };


  deform = buildPythonPackage rec {
    name = "deform-0.9.9";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/d/deform/${name}.tar.gz";
      sha256 = "0ympsjhxz5v8h4hi1mv811h064221bh26d68l9hv1x6m7sxbxpd0";
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
      maintainers = [
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.iElectric
      ];
      platforms = stdenv.lib.platforms.all;
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
      maintainers = [
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.iElectric
      ];
      platforms = stdenv.lib.platforms.all;
    };
  };


  deform_bootstrap = buildPythonPackage rec {
    name = "deform_bootstrap-0.2.9";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/d/deform_bootstrap/${name}.tar.gz";
      sha256 = "1hgq3vqsfqdmlyahnlc40w13viawhpzqf4jzigsggdb41x545fda";
    };

    propagatedBuildInputs = with self; [ deform ];

    meta = {
      maintainers = [ stdenv.lib.maintainers.iElectric ];
      platforms = stdenv.lib.platforms.all;
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
      license = stdenv.lib.licenses.lgpl3Plus;
      maintainers = with stdenv.lib.maintainers; [ bjornfor ];
      platforms = stdenv.lib.platforms.all;
    };
  };

  derpconf = self.buildPythonPackage rec {
    name = "derpconf-0.4.9";

    propagatedBuildInputs = with self; [ six ];

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/derpconf/${name}.tar.gz";
      md5 = "a164807d7bf0c4adf1de781305f29b82";
    };

    meta = {
      description = "derpconf abstracts loading configuration files for your app";
      homepage = https://github.com/globocom/derpconf;
      license = licenses.mit;
    };
  };

  discogs_client = buildPythonPackage rec {
    name = "discogs-client-2.0.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/discogs-client/${name}.tar.gz";
      md5 = "2cc57e1d134aa93404e779b9311676fa";
    };

    propagatedBuildInputs = with self; [ oauth2 requests ];

    meta = {
      description = "Official Python API client for Discogs";
      license = licenses.bsd2;
      homepage = "https://github.com/discogs/discogs_client";
    };
  };

  dns = buildPythonPackage rec {
    name = "dnspython-${version}";
    version = "1.12.0";

    src = pkgs.fetchurl {
      url = "http://www.dnspython.org/kits/1.12.0/dnspython-1.12.0.tar.gz";
      sha256 = "0kvjlkp96qzh3j31szpjlzqbp02brixh4j4clnpw80b0hspq5yq3";
    };
  };

  docker = buildPythonPackage rec {
    name = "docker-py-0.4.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/docker-py/${name}.tar.gz";
      md5 = "21ab8fd729105487e6423b654d6c0860";
    };

    propagatedBuildInputs = with self; [ six requests websocket_client ];

    # Version conflict
    doCheck = false;

    meta = {
      description = "An API client for docker written in Python";
      homepage = https://github.com/docker/docker-py;
      license = licenses.asl20;
    };
  };

  dockerpty = buildPythonPackage rec {
    name = "dockerpty-0.3.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/dockerpty/${name}.tar.gz";
      md5 = "1f97b24d2f4b2c345f176f91655002dd";
    };

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
      md5 = "610ef9395f2e9a2f91c68d13325fce7b";
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
    name = "docker-registry-0.9.0";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/docker-registry/${name}.tar.gz";
      md5 = "65eb9fd05b94f7f9fbbb5e2e8ca62912";
    };

    DEPS = "loose";

    doCheck = false; # requires redis server
    propagatedBuildInputs = with self; [
      setuptools docker_registry_core blinker flask gevent gunicorn pyyaml
      requests2 rsa sqlalchemy setuptools backports_lzma pyasn1
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
      md5 = "4bc74561b37fad5d3e7d037f82a4c3b1";
    };

    meta = {
      description = "Pythonic argument parser, that will make you smile";
      homepage = http://docopt.org/;
      license = licenses.mit;
    };
  };

  dogpile_cache = buildPythonPackage rec {
    name = "dogpile.cache-0.5.4";

    propagatedBuildInputs = with self; [ dogpile_core ];

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/dogpile.cache/dogpile.cache-0.5.4.tar.gz";
      md5 = "513b77ba1bd0c31bb15dd9dd0d8471af";
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
      md5 = "01cb19f52bba3e95c9b560f39341f045";
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
      md5 = "95a0792eb92a8fc0db8a7e59389470fe";
    };

    doCheck = true;

    meta = {
      description = "Easily manage your dotfiles";
      homepage = https://github.com/jbernard/dotfiles;
      license = licenses.isc;
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

    meta = with stdenv.lib; {
      description = "Fast, simple packet creation / parsing, with definitions for the basic TCP/IP protocols";
      homepage = https://code.google.com/p/dpkt/;
      license = licenses.bsd3;
      maintainers = [ maintainers.bjornfor ];
      platforms = stdenv.lib.platforms.all;
    };
  };

  urllib3 = buildPythonPackage rec {
    name = "urllib3-1.8";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/u/urllib3/${name}.tar.gz";
      sha256 = "0pdigfxkq8mhzxxsn6isx8c4h9azqywr1k18yanwyxyj8cdzm28s";
    };

    preConfigure = ''
      substituteInPlace test-requirements.txt --replace 'nose==1.3' 'nose'
    '';

    checkPhase = ''
      nosetests --cover-min-percentage 70
    '';

    buildInputs = with self; [ coverage tornado mock nose ];

    meta = with stdenv.lib; {
      description = "A Python library for Dropbox's HTTP-based Core and Datastore APIs";
      homepage = https://www.dropbox.com/developers/core/docs;
      license = licenses.mit;
    };
  };


  dropbox = buildPythonPackage rec {
    name = "dropbox-2.2.0";
    doCheck = false; # python 2.7.9 does verify ssl certificates

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/dropbox/${name}.zip";
      sha256 = "069jrwb67brqh0sics8fgqdf2mv5y5jl9k5729x8vf80pq2c9p36";
    };

    propagatedBuildInputs = with self; [ urllib3 mock setuptools ];

    meta = with stdenv.lib; {
      description = "A Python library for Dropbox's HTTP-based Core and Datastore APIs";
      homepage = https://www.dropbox.com/developers/core/docs;
      license = licenses.mit;
    };
  };


  evdev = buildPythonPackage rec {
    version = "0.4.6";
    name = "evdev-${version}";
    disabled = isPy34;  # see http://bugs.python.org/issue21121

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/e/evdev/${name}.tar.gz";
      sha256 = "08bzyr3zc8ijnv25bysmmvzircblh42ja15f6ijdzmqqw8vfaij8";
    };

    buildInputs = with self; [ pkgs.linuxHeaders ];

    patchPhase = "sed -e 's#/usr/include/linux/input.h#${pkgs.linuxHeaders}/include/linux/input.h#' -i setup.py";

    doCheck = false;

    meta = with stdenv.lib; {
      description = "Provides bindings to the generic input event interface in Linux";
      homepage = http://pythonhosted.org/evdev;
      license = licenses.bsd3;
      maintainers = [ maintainers.goibhniu ];
      platforms = stdenv.lib.platforms.linux;
    };
  };


  eventlib = buildPythonPackage rec {
    name = "python-eventlib-${version}";
    version = "0.2.0";

    src = pkgs.fetchurl {
      url = "http://download.ag-projects.com/SipClient/${name}.tar.gz";
      sha256 = "0fld5lb85ql4a5bgc38sdxi5pgzqljysp1p8f7abxnd6vymh4rgi";
    };

    propagatedBuildInputs = with self; [ greenlet ];

    meta = with stdenv.lib; {
      description = "Eventlib bindings for python.";
      homepage    = "http://ag-projects.com/";
      license     = licenses.lgpl2;
      platforms   = platforms.all;
    };
  };


  eyeD3 = buildPythonPackage rec {
    version = "0.7.4";
    name    = "eyeD3-${version}";
    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "http://eyed3.nicfit.net/releases/${name}.tgz";
      sha256 = "001hzgqqnf2ig432mq78jsxidpky2rl2ilm28xwjp32vzphycf51";
    };

    buildInputs = with self; [ paver ];

    postInstall = ''
      for prog in "$out/bin/"*; do
        wrapProgram "$prog" --prefix PYTHONPATH : "$PYTHONPATH"
      done
    '';

    meta = with stdenv.lib; {
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
      md5 = "be885ccd9612966bb81839670d2da099";
    };

    doCheck = !isPy3k;  # failures..

    meta = {
      description = "rapid multi-Python deployment";
      license = stdenv.lib.licenses.gpl2;
    };
  };

  facebook-sdk = buildPythonPackage rec {
    name = "facebook-sdk-0.4.0";

    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/f/facebook-sdk/facebook-sdk-0.4.0.tar.gz";
      md5 = "ac9f38e197e54b8ba9f3a61988cc33b7";
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
    meta = with stdenv.lib; {
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
    meta = with stdenv.lib; {
      description = "A Python package that generates fake data for you";
      homepage    = https://pypi.python.org/pypi/fake-factory;
      license     = licenses.mit;
      maintainers = with maintainers; [ lovek323 ];
      platforms   = platforms.unix;
    };
  };

  fabric = buildPythonPackage rec {
    name = "fabric-${version}";
    version = "1.10.0";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/F/Fabric/Fabric-${version}.tar.gz";
      sha256 = "0nikc05iz1fx2c9pvxrhrs819cpmg566azm99450yq2m8qmp1cpd";
    };
    disabled = isPy3k;
    doCheck = (!isPyPy);  # https://github.com/fabric/fabric/issues/11891
    propagatedBuildInputs = with self; [ paramiko pycrypto ];
    buildInputs = with self; [ fudge nose ];
  };

  fedora_cert = stdenv.mkDerivation (rec {
    name = "fedora-cert-0.5.9.2";
    meta.maintainers = [ stdenv.lib.maintainers.mornfall ];

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
    meta.maintainers = [ stdenv.lib.maintainers.mornfall ];

    src = pkgs.fetchurl {
      url = "https://fedorahosted.org/releases/f/e/fedpkg/fedpkg-1.14.tar.bz2";
      sha256 = "0rj60525f2sv34g5llafnkmpvbwrfbmfajxjc14ldwzymp8clc02";
    };

    patches = [ ../development/python-modules/fedpkg-buildfix.diff ];
    propagatedBuildInputs = with self; [ rpkg offtrac urlgrabber fedora_cert ];
  });

  fudge = buildPythonPackage rec {
    name = "fudge-0.9.6";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/f/fudge/${name}.tar.gz";
      sha256 = "185ia3vr3qk4f2s1a9hdxb8ci4qc0x0xidrad96pywg8j930qs9l";
    };
    buildInputs = with self; [ nose nosejs ];
    propagatedBuildInputs = with self; [ sphinx ];
  };


  funcparserlib = buildPythonPackage rec {
    name = "funcparserlib-0.3.6";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/f/funcparserlib/${name}.tar.gz";
      md5 = "3aba546bdad5d0826596910551ce37c0";
    };

    meta = with stdenv.lib; {
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
      md5 = "af2fc6a3d6cc5a02d0bf54d909785fcb";
    };

    meta = with stdenv.lib; {
      homepage = http://docs.python.org/3/library/functools.html;
    };
  };

  gcutil = buildPythonPackage rec {
    name = "gcutil-1.16.1";
    meta.maintainers = [ stdenv.lib.maintainers.phreedom ];

    src = pkgs.fetchurl {
      url = https://dl.google.com/dl/cloudsdk/release/artifacts/gcutil-1.16.1.tar.gz;
      sha256 = "00jaf7x1ji9y46fbkww2sg6r6almrqfsprydz3q2swr4jrnrsx9x";
    };

    patchPhase = ''
      substituteInPlace setup.py \
        --replace "httplib2==0.8" "httplib2" \
        --replace "iso8601==0.1.4" "iso8601"
    '';

    propagatedBuildInputs = with self; [ gflags iso8601 ipaddr httplib2 google_apputils google_api_python_client ];
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
    name = "gitdb-0.5.4";
    meta.maintainers = [ stdenv.lib.maintainers.mornfall ];
    doCheck = false;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/g/gitdb/${name}.tar.gz";
      sha256 = "10rpmmlln59aq44cd5vkb77hslak5pa1rbmigg6ski5f1nn2spfy";
    };

    propagatedBuildInputs = with self; [ smmap async ];
  };

  GitPython = buildPythonPackage rec {
    name = "GitPython-0.3.2";
    meta.maintainers = [ stdenv.lib.maintainers.mornfall ];

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/G/GitPython/GitPython-0.3.2.RC1.tar.gz";
      sha256 = "1q4lc2ps12l517mmrxc8iq6gxyhj6d77bnk1p7mxf38d99l8crzx";
    };

    buildInputs = with self; [ nose ];
    propagatedBuildInputs = with self; [ gitdb ];
  };

  googlecl = buildPythonPackage rec {
    version = "0.9.14";
    name    = "googlecl-${version}";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url    = "https://googlecl.googlecode.com/files/${name}.tar.gz";
      sha256 = "0nnf7xkr780wivr5xnchfcrahlzy9bi2dxcs1w1bh1014jql0iha";
    };

    meta = with stdenv.lib; {
      description = "Brings Google services to the command line";
      homepage    = https://code.google.com/p/googlecl/;
      license     = licenses.asl20;
      maintainers = with maintainers; [ lovek323 ];
      platforms   = platforms.unix;
    };

    propagatedBuildInputs = with self; [ gdata ];
  };

  gtimelog = buildPythonPackage rec {
    name = "gtimelog-${version}";
    version = "0.9.1";

    disabled = isPy26;

    src = pkgs.fetchurl {
      url = "https://github.com/gtimelog/gtimelog/archive/${version}.tar.gz";
      sha256 = "0qk8fv8cszzqpdi3wl9vvkym1jil502ycn6sic4jrxckw5s9jsfj";
    };

    preBuild = ''
      export LOCALE_ARCHIVE=${localePath}
      export LC_ALL="en_US.UTF-8"
    '';

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

    meta = with stdenv.lib; {
      description = "A small Gtk+ app for keeping track of your time. It's main goal is to be as unintrusive as possible";
      homepage = http://mg.pov.lt/gtimelog/;
      license = licenses.gpl2Plus;
      maintainers = [ maintainers.ocharles ];
      platforms = platforms.unix;
    };
  };

  itsdangerous = buildPythonPackage rec {
    name = "itsdangerous-0.24";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/i/itsdangerous/${name}.tar.gz";
      sha256 = "06856q6x675ly542ig0plbqcyab6ksfzijlyf1hzhgg3sgwgrcyb";
    };

    meta = with stdenv.lib; {
      description = "helpers to pass trusted data to untrusted environments and back";
      homepage = "https://pypi.python.org/pypi/itsdangerous/";
    };
  };

  jsonpatch = buildPythonPackage rec {
    name = "jsonpatch-1.8";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/j/jsonpatch/jsonpatch-1.8.tar.gz";
      sha256 = "0xhp6prvk219vnzixbj231wymd458nqbnmsf5fn4252092prvig5";
    };

    propagatedBuildInputs = with self; [ six jsonpointer ];

    meta = {
      description = "Apply JSON-Patches (RFC 6902)";
      homepage = "https://github.com/stefankoegl/python-json-patch";
      license = stdenv.lib.licenses.bsd3;
      platforms = stdenv.lib.platforms.all;
    };
  };

  jsonpointer = buildPythonPackage rec {
    name = "jsonpointer-1.4";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/j/jsonpointer/jsonpointer-1.4.tar.gz";
      sha256 = "1d0555smqwdbi0nm48hyqzywb9m2jlz5izgv56ll3zk7viz3b7fb";
    };

    #propagatedBuildInputs = with self; [ six jsonpointer ];

    meta = {
      description = "Identify specific nodes in a JSON document (RFC 6901)";
      homepage = "https://github.com/stefankoegl/python-json-pointer";
      license = stdenv.lib.licenses.bsd3;
      platforms = stdenv.lib.platforms.all;
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
      license = stdenv.lib.licenses.mit;
      platforms = stdenv.lib.platforms.all;
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


  logster = buildPythonPackage {
    name = "logster-7475c53822";
    src = pkgs.fetchgit {
      url = git://github.com/etsy/logster;
      rev = "7475c53822";
      sha256 = "1ls007qmziwb50c5iikxhqin0xbn673gbd25m5k09861435cknvr";
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

    meta = with stdenv.lib; {
      description = "A Python-based build/distribution/deployment scripting tool";
      homepage    = http://github.com/paver/paver;
      matinainers = with maintainers; [ lovek323 ];
      platforms   = platforms.unix;
    };
  };


  peppercorn = buildPythonPackage rec {
    name = "peppercorn-0.4";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/peppercorn/${name}.tar.gz";
      md5 = "464d6f2342eaf704dfb52046c1f5c320";
    };

    meta = {
      maintainers = [
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.iElectric
      ];
      platforms = stdenv.lib.platforms.all;
    };
  };

  pew = buildPythonPackage rec {
    name = "pew-0.1.9";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pew/${name}.tar.gz";
      md5 = "90a82400074b50a9e73c3045ed9ac217";
    };

    propagatedBuildInputs = with self; [ virtualenv virtualenv-clone ];

    meta = with stdenv.lib; {
      description = "Tools to manage multiple virtualenvs written in pure python, a virtualenvwrapper rewrite";
      license = licenses.mit;
      platforms = platforms.all;
    };
  };

  poppler-qt4 = buildPythonPackage rec {
    name = "poppler-qt4-${version}";
    version = "0.18.1";
    disabled = isPy3k || isPyPy;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/python-poppler-qt4/" +
            "python-poppler-qt4-${version}.tar.gz";
      md5 = "9c4c5a59b878aed78e96a6ae58c6c185";
    };

    propagatedBuildInputs = [ pkgs.pyqt4 pkgs.pkgconfig pkgs.popplerQt4 ];

    preBuild = "${python}/bin/${python.executable} setup.py build_ext" +
               " --include-dirs=${pkgs.popplerQt4}/include/poppler/";

    meta = with stdenv.lib; {
      description = "A Python binding to Poppler-Qt4";
      longDescription = ''
        A Python binding to Poppler-Qt4 that aims for completeness
        and for being actively maintained.
      '';
      license = licenses.lgpl21Plus;
      maintainers = [ maintainers.sepi ];
      platforms = platforms.all;
    };
  };

  pudb = buildPythonPackage rec {
    name = "pudb-2013.3.6";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pudb/${name}.tar.gz";
      md5 = "063030763bf914166a0b2bc8c011143b";
    };

    propagatedBuildInputs = with self; [ self.pygments self.urwid ];

    meta = with stdenv.lib; {
      description = "A full-screen, console-based Python debugger";
      license = licenses.mit;
      platforms = platforms.all;
    };
  };


  pyramid = buildPythonPackage rec {
    name = "pyramid-1.5.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyramid/${name}.tar.gz";
      md5 = "8a1ab3b773d8e22437828f7df22852c1";
    };

    preCheck = ''
      # test is failing, see https://github.com/Pylons/pyramid/issues/1405
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
      paste_deploy
      repoze_lru
      repoze_sphinx_autointerface
      translationstring
      venusian
      webob
      zope_deprecation
      zope_interface
    ];

    meta = {
      maintainers = [
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.iElectric
      ];
      platforms = stdenv.lib.platforms.all;
    };
  };


  pyramid_beaker = buildPythonPackage rec {
    name = "pyramid_beaker-0.7";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyramid_beaker/${name}.tar.gz";
      md5 = "acb863517a98b90b5f29648ce55dd563";
    };

    propagatedBuildInputs = with self; [ beaker pyramid ];

    meta = {
      maintainers = [ stdenv.lib.maintainers.iElectric ];
      platforms = stdenv.lib.platforms.all;
    };
  };


  pyramid_chameleon = buildPythonPackage rec {
    name = "pyramid_chameleon-0.3";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pyramid_chameleon/${name}.tar.gz";
      md5 = "5bb5938356dfd13fce06e095f132e137";
    };

    propagatedBuildInputs = with self; [
      chameleon
      pyramid
      zope_interface
      setuptools
    ];

    meta = with stdenv.lib; {
      maintainers = [ maintainers.iElectric ];
    };
  };


  pyramid_jinja2 = buildPythonPackage rec {
    name = "pyramid_jinja2-1.9";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyramid_jinja2/${name}.zip";
      md5 = "a6728117cad24749ddb39d2827cd9033";
    };

    buildInputs = with self; [ webtest ];
    propagatedBuildInputs = with self; [ jinja2 pyramid ];

    meta = {
      maintainers = [ stdenv.lib.maintainers.iElectric ];
      platforms = stdenv.lib.platforms.all;
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
      md5 = "05df86758b0d30ee6f8339ff36cef7a0";
    };

    propagatedBuildInputs = with self; [ pyramid ];

    meta = {
      maintainers = [
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.iElectric
      ];
      platforms = stdenv.lib.platforms.all;
    };
  };


  pyramid_tm = buildPythonPackage rec {
    name = "pyramid_tm-0.7";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyramid_tm/${name}.tar.gz";
      md5 = "6dc917d262c69366630c542bd21859a3";
    };

    # tests are failing in version 0.7 but are fixed in trunk
    doCheck = false;

    propagatedBuildInputs = with self; [ transaction pyramid ];
    meta = {
      maintainers = [
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.iElectric
        stdenv.lib.maintainers.matejc
      ];
      platforms = stdenv.lib.platforms.all;
    };
  };


  pyramid_multiauth = buildPythonPackage rec {
    name = "pyramid_multiauth-${version}";
    version = "0.3.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pyramid_multiauth/${name}.tar.gz";
      md5 = "044e423abc4fb76937ac0c21c1205e9c";
    };

    propagatedBuildInputs = with self; [ pyramid ];

    meta = with stdenv.lib; {
      description = "Authentication policy for Pyramid that proxies to a stack of other authentication policies";
      homepage = https://github.com/mozilla-services/pyramid_multiauth;
    };
  };

  radicale = buildPythonPackage rec {
    name = "radicale-${version}";
    namePrefix = "";
    version = "0.9";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/R/Radicale/Radicale-${version}.tar.gz";
      sha256 = "77bf813fd26f0d359c1a7b7bcce9b842b4503c5516989a4a0a4f648e299e41f7";
    };

    propagatedBuildInputs = with self; [
      flup
      ldap
      sqlalchemy
    ];

    doCheck = false;

    meta = {
      homepage = "http://www.radicale.org/";
      description = "CalDAV CardDAV server";
      longDescription = ''
        The Radicale Project is a complete CalDAV (calendar) and CardDAV
        (contact) server solution. Calendars and address books are available for
        both local and remote access, possibly limited through authentication
        policies. They can be viewed and edited by calendar and contact clients
        on mobile phones or computers.
      '';
      license = stdenv.lib.licenses.gpl3Plus;
      maintainers = [ stdenv.lib.maintainers.edwtjo ];
    };
  };

  raven = buildPythonPackage rec {
    name = "raven-3.4.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/r/raven/${name}.tar.gz";
      md5 = "6a9264133bf646149ffb9118d81445be";
    };

    # way too many dependencies to run tests
    # see https://github.com/getsentry/raven-python/blob/master/setup.py
    doCheck = false;

    meta = {
      maintainers = [ stdenv.lib.maintainers.iElectric ];
    };
  };


  hypatia = buildPythonPackage rec {
    name = "hypatia-0.3";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/h/hypatia/${name}.tar.gz";
      md5 = "d74c6dda31ff459a39fa5da9e98f2425";
    };

    buildInputs = with self; [ zope_interface zodb ];

    meta = {
      maintainers = [ stdenv.lib.maintainers.iElectric ];
    };
  };


  zope_copy = buildPythonPackage rec {
    name = "zope.copy-4.0.2";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.copy/${name}.zip";
      md5 = "36aa2c96dec4cfeea57f54da2b733eb9";
    };

    buildInputs = with self; [ zope_interface zope_location zope_schema ];

    meta = {
      maintainers = [ stdenv.lib.maintainers.iElectric ];
    };
  };


  statsd = buildPythonPackage rec {
    name = "statsd-2.0.2";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/s/statsd/${name}.tar.gz";
      md5 = "476ef5b9004f6e2cb25c7da440bb53d0";
    };

    buildInputs = with self; [ ];

    meta = {
      maintainers = [ stdenv.lib.maintainers.iElectric ];
    };
  };


  pyramid_zodbconn = buildPythonPackage rec {
    name = "pyramid_zodbconn-0.7";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyramid_zodbconn/${name}.tar.gz";
      md5 = "3c7746a227fbcda3e138ab8bfab7700b";
    };

    # should be fixed in next release
    doCheck = false;

    buildInputs = with self; [ pyramid mock ];
    propagatedBuildInputs = with self; [ zodb zodburi ];

    meta = {
      maintainers = [ stdenv.lib.maintainers.iElectric ];
    };
  };


  pyramid_mailer = buildPythonPackage rec {
    name = "pyramid_mailer-0.13";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyramid_mailer/${name}.tar.gz";
      md5 = "43800c7c894097a23140da58e3638c93";
    };

    buildInputs = with self; [ pyramid transaction ];
    propagatedBuildInputs = with self; [ repoze_sendmail ];

    meta = {
      maintainers = [ stdenv.lib.maintainers.iElectric ];
    };
  };

  pyrtlsdr = buildPythonPackage rec {
    name = "pyrtlsdr-0.2.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyrtlsdr/${name}.zip";
      md5 = "646336675a00d38e6f54e77a17011b95";
    };

    postPatch = ''
      sed "s|driver_files =.*|driver_files = ['${pkgs.rtl-sdr}/lib/librtlsdr.so']|" -i rtlsdr/librtlsdr.py
    '';

    meta = with stdenv.lib; {
      description = "Python wrapper for librtlsdr (a driver for Realtek RTL2832U based SDR's)";
      homepage = https://github.com/roger-/pyrtlsdr;
      license = licenses.gpl3;
      platforms = platforms.linux;
      maintainers = [ maintainers.bjornfor ];
    };
  };


  repoze_sendmail = buildPythonPackage rec {
    name = "repoze.sendmail-4.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/r/repoze.sendmail/${name}.tar.gz";
      md5 = "81d15f1f03cc67d6f56f2091c594ef57";
    };

    buildInputs = with self; [ transaction ];

    meta = {
      maintainers = [ stdenv.lib.maintainers.iElectric ];
    };
  };


  zodburi = buildPythonPackage rec {
    name = "zodburi-2.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zodburi/${name}.tar.gz";
      md5 = "7876893829c2f784506c80d49f861b67";
    };

    buildInputs = with self; [ zodb mock ZEO ];

    meta = {
      maintainers = [ stdenv.lib.maintainers.iElectric ];
    };
  };

  ZEO = self.buildPythonPackage rec {
    name = "ZEO-4.0.0";

    propagatedBuildInputs = with self; [ random2 zodb six transaction persistent zc_lockfile zconfig zdaemon zope_interface ];

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/Z/ZEO/${name}.tar.gz";
      md5 = "494d8320549185097ba4a6b6b76017d6";
    };

    meta = with stdenv.lib; {
      homepage = https://pypi.python.org/pypi/ZEO;
    };
  };

  random2 = self.buildPythonPackage rec {
    name = "random2-1.0.1";

    doCheck = !isPyPy;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/r/random2/${name}.zip";
      md5 = "48a0a86fe00e447212d0095de8cf3e21";
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

    meta = with stdenv.lib; {
      maintainers = [ maintainers.iElectric ];
    };
  };


  repoze_lru = buildPythonPackage rec {
    name = "repoze.lru-0.6";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/r/repoze.lru/${name}.tar.gz";
      md5 = "2c3b64b17a8e18b405f55d46173e14dd";
    };

    meta = {
      maintainers = [
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.iElectric
      ];
      platforms = stdenv.lib.platforms.all;
    };
  };



  repoze_sphinx_autointerface = buildPythonPackage rec {
    name = "repoze.sphinx.autointerface-0.7.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/r/repoze.sphinx.autointerface/${name}.tar.gz";
      md5 = "f2fee996ae28dc16eb48f1a3e8f64801";
    };

    propagatedBuildInputs = with self; [ zope_interface sphinx ];

    meta = {
      maintainers = [ stdenv.lib.maintainers.iElectric ];
      platforms = stdenv.lib.platforms.all;
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

    buildInputs = with self; [ pkgs.alsaLib pkgs.jack2 ];

    meta = with stdenv.lib; {
      description = "A Python wrapper for the RtMidi C++ library written with Cython";
      homepage = http://trac.chrisarndt.de/code/wiki/python-rtmidi;
      license = licenses.mit;
      maintainers = [ maintainers.goibhniu ];
    };
  };

  zope_tales = buildPythonPackage rec {
    name = "zope.tales-4.0.2";

    propagatedBuildInputs = with self; [ zope_interface six zope_testrunner ];

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/z/zope.tales/${name}.zip";
      md5 = "902b03a5f9774f6e2decf3f06d18a09d";
    };
  };


  zope_deprecation = buildPythonPackage rec {
    name = "zope.deprecation-3.5.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.deprecation/${name}.tar.gz";
      md5 = "836cfea5fad548cd5a0d9af1300ec05e";
    };

    buildInputs = with self; [ zope_testing ];

    meta = {
      maintainers = [
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.iElectric
      ];
      platforms = stdenv.lib.platforms.all;
    };
  };


  venusian = buildPythonPackage rec {
    name = "venusian-1.0a7";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/v/venusian/${name}.tar.gz";
      md5 = "6f67506dd3cf77116f1c01682a6c3f27";
    };

    # TODO: https://github.com/Pylons/venusian/issues/23
    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.iElectric
      ];
      platforms = stdenv.lib.platforms.all;
    };
  };


  chameleon = buildPythonPackage rec {
    name = "Chameleon-2.15";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/C/Chameleon/${name}.tar.gz";
      md5 = "0214647152fcfcb9ce357624f8f9f203";
    };

    buildInputs = with self; [] ++ optionals isPy26 [ ordereddict unittest2 ];

    # TODO: https://github.com/malthe/chameleon/issues/139
    doCheck = false;

    meta = {
       maintainers = [
         stdenv.lib.maintainers.garbas
         stdenv.lib.maintainers.iElectric
      ];
      platforms = stdenv.lib.platforms.all;
    };
  };

  distutils_extra = buildPythonPackage rec {
    name = "distutils-extra-2.26";

    src = pkgs.fetchurl {
      url = "http://launchpad.net/python-distutils-extra/trunk/2.26/+download/python-${name}.tar.gz";
      md5 = "7caded30a45907b5cdb10ac4182846eb";
    };

    meta = {
      homepage = https://launchpad.net/python-distutils-extra;
      description = "Enhancements to Python's distutils";
    };
  };

  deluge = buildPythonPackage rec {
    name = "deluge-1.3.11";

    src = pkgs.fetchurl {
      url = "http://download.deluge-torrent.org/source/${name}.tar.bz2";
      sha256 = "16681sg7yi03jqyifhalnw4vavb8sj94cisldal7nviai8dz9qc3";
    };

    propagatedBuildInputs = with self; [
      pyGtkGlade pkgs.libtorrentRasterbar twisted Mako chardet pyxdg self.pyopenssl modules.curses
    ];

    postInstall = ''
       cp -R deluge/data/share $out/share
       cp -R deluge/data/pixmaps $out/share/
       cp -R deluge/data/icons $out/share/
    '';

    meta = {
      homepage = http://deluge-torrent.org;
      description = "Torrent client";
      license = stdenv.lib.licenses.gpl3Plus;
      maintainers = [ stdenv.lib.maintainers.iElectric ];
      platforms = stdenv.lib.platforms.all;
    };
  };

  pyxdg = buildPythonPackage rec {
    name = "pyxdg-0.25";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyxdg/${name}.tar.gz";
      md5 = "bedcdb3a0ed85986d40044c87f23477c";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://freedesktop.org/wiki/Software/pyxdg;
      description = "Contains implementations of freedesktop.org standards";
      license = stdenv.lib.licenses.lgpl2;
      maintainers = [ stdenv.lib.maintainers.iElectric ];
    };
  };

  chardet = buildPythonPackage rec {
    name = "chardet-2.1.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/c/chardet/${name}.tar.gz";
      md5 = "295367fd210d20f3febda615a88e1ef0";
    };

    meta = {
      homepage = https://github.com/erikrose/chardet;
      description = "Universal encoding detector";
      license = stdenv.lib.licenses.lgpl2;
      maintainers = [ stdenv.lib.maintainers.iElectric ];
    };
  };

  django = self.django_1_6;

  django_1_6 = buildPythonPackage rec {
    name = "Django-${version}";
    version = "1.6.6";

    src = pkgs.fetchurl {
      url = "http://www.djangoproject.com/m/releases/1.6/${name}.tar.gz";
      sha256 = "143yp984n8a2bs1dflxjp1s7skmji0cwkw05s9ikbfikwmabsv2k";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      description = "A high-level Python Web framework";
      homepage = https://www.djangoproject.com/;
    };
  };

  django_1_5 = buildPythonPackage rec {
    name = "Django-${version}";
    version = "1.5.9";

    src = pkgs.fetchurl {
      url = "http://www.djangoproject.com/m/releases/1.5/${name}.tar.gz";
      sha256 = "1lm0pa6m9f4cd6pv239lqj32z1snf8xjbvlbh8bqihs6a1f51kj7";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      description = "A high-level Python Web framework";
      homepage = https://www.djangoproject.com/;
    };
  };

  django_1_4 = buildPythonPackage rec {
    name = "Django-${version}";
    version = "1.4.14";

    src = pkgs.fetchurl {
      url = "http://www.djangoproject.com/m/releases/1.4/${name}.tar.gz";
      sha256 = "173ci9ml2vs1z2x51wahssfn8mrmhd02varmg9kibm8z460svvc1";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      description = "A high-level Python Web framework";
      homepage = https://www.djangoproject.com/;
    };
  };

  django_1_3 = buildPythonPackage rec {
    name = "Django-1.3.7";

    src = pkgs.fetchurl {
      url = "http://www.djangoproject.com/m/releases/1.3/${name}.tar.gz";
      sha256 = "12pv8y2x3fhrcrjayfm6z40r57iwchfi5r19ajs8q8z78i3z8l7f";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      description = "A high-level Python Web framework";
      homepage = https://www.djangoproject.com/;
    };
  };


  django_evolution = buildPythonPackage rec {
    name = "django_evolution-0.6.9";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "http://downloads.reviewboard.org/releases/django-evolution/${name}.tar.gz";
      md5 = "c0d7d10bc41898c88b14d434c48766ff";
    };

    propagatedBuildInputs = with self; [ django_1_5 ];

    meta = {
      description = "A database schema evolution tool for the Django web framework";
      homepage = http://code.google.com/p/django-evolution/;
    };
  };


  django_tagging = buildPythonPackage rec {
    name = "django-tagging-0.3.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/d/django-tagging/${name}.tar.gz";
      md5 = "a0855f2b044db15f3f8a025fa1016ddf";
    };

    # error: invalid command 'test'
    doCheck = false;

    propagatedBuildInputs = with self; [ django_1_3 ];

    meta = {
      description = "A generic tagging application for Django projects";
      homepage = http://code.google.com/p/django-tagging/;
    };
  };


  djblets = buildPythonPackage rec {
    name = "Djblets-0.6.28";

    src = pkgs.fetchurl {
      url = "http://downloads.reviewboard.org/releases/Djblets/0.6/${name}.tar.gz";
      sha256 = "11fsi911cqkjgv9j7646ljc2fgxsdfyq44kzmv01xhysm50fn6xx";
    };

    propagatedBuildInputs = with self; [ pil django_1_3 feedparser ];

    meta = {
      description = "A collection of useful extensions for Django";
      homepage = https://github.com/djblets/djblets;
    };
  };


  dulwich = buildPythonPackage rec {
    name = "dulwich-${version}";
    version = "0.9.7";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/dulwich/${name}.tar.gz";
      sha256 = "1wq083g9b1xsk89kb0wwpi4mxy63x6760vn9x5sk1fx36h27prqj";
    };

    # Only test dependencies
    buildInputs = with self; [ pkgs.git gevent geventhttpclient mock fastimport ];

    meta = with stdenv.lib; {
      description = "Simple Python implementation of the Git file formats and protocols.";
      homepage = http://samba.org/~jelmer/dulwich/;
      license = licenses.gpl2Plus;
      maintainers = [ maintainers.koral ];
    };
  };


  hg-git = buildPythonPackage rec {
    name = "hg-git-${version}";
    version = "0.6.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/h/hg-git/${name}.tar.gz";
      sha256 = "136kz4w377ldcjdg865azi8aym0xnxzxl3rycnflgay26ar1309s";
    };

    propagatedBuildInputs = with self; [ pkgs.mercurial dulwich ];

    meta = with stdenv.lib; {
      description = "Push and pull from a Git server using Mercurial.";
      homepage = http://hg-git.github.com/;
      maintainers = [ maintainers.koral ];
    };
  };


  docutils = buildPythonPackage rec {
    name = "docutils-0.11";

    src = pkgs.fetchurl {
      url = "mirror://sourceforge/docutils/${name}.tar.gz";
      sha256 = "1jbybs5a396nrjy9m13pgvsxdwaj7jw7nsawkhl4fi1nvxm1dx4s";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://docutils.sourceforge.net/;
      description = "An open-source text processing system for processing plaintext documentation into useful formats, such as HTML or LaTeX";
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
      md5 = "9a41317149e926fcc408086aedee6bab";
    };

    meta = {
      description = "Add options to doctest examples while they are running";
      homepage = http://pypi.python.org/pypi/dtopt;
    };
  };


  ecdsa = buildPythonPackage rec {
    name = "ecdsa-${version}";
    version = "0.11";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/e/ecdsa/${name}.tar.gz";
      md5 = "8ef586fe4dbb156697d756900cb41d7c";
    };

    # Only needed for tests
    buildInputs = with self; [ pkgs.openssl ];

    meta = {
      description = "ECDSA cryptographic signature library";
      homepage = "https://github.com/warner/python-ecdsa";
      license = stdenv.lib.licenses.mit;
      maintainers = [ stdenv.lib.maintainers.aszlig ];
    };
  };


  elpy = buildPythonPackage rec {
    name = "elpy-1.0.1";
    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/e/elpy/elpy-1.0.1.tar.gz";
      md5 = "5453f085f7871ed8fc11d51f0b68c785";
    };
    propagatedBuildInputs = with self; [ flake8 ];

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
      md5 = "ce75c7c3c86741175a84456cc5bd531e";
    };

    doCheck = !isPyPy;

    buildInputs = with self; [ ];

    propagatedBuildInputs = with self; [ ];

    meta = {
      homepage = http://pypi.python.org/pypi/enum/;
      description = "Robust enumerated type support in Python";
    };
  };

  enum34 = buildPythonPackage rec {
    name = "enum34-1.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/e/enum34/${name}.tar.gz";
      md5 = "9d57f5454c70c11707998ea26c1b0a7c";
    };

  };

  epc = buildPythonPackage rec {
    name = "epc-0.0.3";
    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/e/epc/${name}.tar.gz";
      md5 = "04a93c0cd32b496969ead09f414dac74";
    };

    propagatedBuildInputs = with self; [ sexpdata ];
    doCheck = false;

    meta = {
      description = "EPC (RPC stack for Emacs Lisp) implementation in Python";
      homepage = "https://github.com/tkf/python-epc";
    };
  };


  eventlet = buildPythonPackage rec {
    name = "eventlet-0.15.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/e/eventlet/${name}.tar.gz";
      md5 = "7155780824bb6344651a573838416f21";
    };

    buildInputs = with self; [ nose httplib2  ];

    propagatedBuildInputs = optionals (!isPyPy) [ self.greenlet ];

    PYTHON_EGG_CACHE = "`pwd`/.egg-cache";

    doCheck = false; # !!! fix; tests access the network

    meta = {
      homepage = http://pypi.python.org/pypi/eventlet/;
      description = "A concurrent networking library for Python";
    };
  };

  fastimport = buildPythonPackage rec {
    name = "fastimport-${version}";
    version = "0.9.4";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/f/fastimport/${name}.tar.gz";
      sha256 = "0k8x7552ypx9rc14vbsvg2lc6z0r8pv9laah28pdwyynbq10825d";
    };

    meta = with stdenv.lib; {
      homepage = https://launchpad.net/python-fastimport;
      description = "VCS fastimport/fastexport parser";
      maintainers = [ maintainers.koral ];
      license = licenses.gpl2Plus;
    };
  };

  feedgenerator = buildPythonPackage (rec {
    name = "feedgenerator-1.7";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/f/feedgenerator/${name}.tar.gz";
      md5 = "92978492871342ad64e8ae0ccfcf200c";
    };

    preConfigure = ''
      export LOCALE_ARCHIVE=${pkgs.glibcLocales}/lib/locale/locale-archive
      export LC_ALL="en_US.UTF-8"
    '';

    propagatedBuildInputs = with self; [ six pytz ];

    meta = {
      homepage = https://github.com/dmdm/feedgenerator-py3k.git;
      description = "Standalone version of django.utils.feedgenerator,  compatible with Py3k";
    };
  });

  feedparser = buildPythonPackage (rec {
    name = "feedparser-5.1.3";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/f/feedparser/${name}.tar.gz";
      md5 = "f2253de78085a1d5738f626fcc1d8f71";
    };

    meta = {
      homepage = http://code.google.com/p/feedparser/;
      description = "Universal feed parser";
      license = stdenv.lib.licenses.bsd2;
      maintainers = [ stdenv.lib.maintainers.iElectric ];
    };
  });

  fig = buildPythonPackage rec {
    name = "fig-1.0.1";
    disabled = isPy3k || isPyPy;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/f/fig/${name}.tar.gz";
      md5 = "e1c82296fe2362fae21b3cb0dfee8cb2";
    };

    propagatedBuildInputs = with self; [
      six requests2 pyyaml texttable docopt
      (dockerpty.override {
        src = pkgs.fetchurl {
          url = "https://pypi.python.org/packages/source/d/dockerpty/dockerpty-0.3.2.tar.gz";
          md5 = "1f97b24d2f4b2c345f176f91655002dd";
        };
      })
      (docker.override {
        src = pkgs.fetchurl {
          url = "https://pypi.python.org/packages/source/d/docker-py/docker-py-0.5.3.tar.gz";
          md5 = "809b7b8c144f5e37787e72b030ee353f";
        };
      })
      (websocket_client.override {
        src = pkgs.fetchurl {
          url = "https://pypi.python.org/packages/source/w/websocket-client/websocket-client-0.11.0.tar.gz";
          md5 = "fcffbb5ac10941d9ace416d14d1e3ec8";
        };
      })
    ];

    doCheck = false;

    meta = {
      homepage = http://www.fig.sh/;
      description = "Fast, isolated development environments using Docker";
      license = stdenv.lib.licenses.asl20;
    };
  };

  filebrowser_safe = buildPythonPackage rec {
    version = "0.3.6";
    name = "filebrowser_safe-${version}";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/f/filebrowser_safe/${name}.tar.gz";
      md5 = "12a1ad3a1ed6a9377e758c4fa7fee570";
    };

    meta = with stdenv.lib; {
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

  flake8 = buildPythonPackage (rec {
    name = "flake8-2.1.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/f/flake8/${name}.tar.gz";
      md5 = "cf326cfb88a1db6c5b29a3a6d9efb257";
    };

    buildInputs = with self; [ nose mock ];
    propagatedBuildInputs = with self; [ pyflakes pep8 mccabe ];

    # 3 failing tests
    #doCheck = false;

    meta = {
      description = "Code checking using pep8 and pyflakes";
      homepage = http://pypi.python.org/pypi/flake8;
      license = licenses.mit;
      maintainers = [ stdenv.lib.maintainers.garbas ];
    };
  });


  flask = buildPythonPackage {
    name = "flask-0.10.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/F/Flask/Flask-0.10.1.tar.gz";
      md5 = "378670fe456957eb3c27ddaef60b2b24";
    };

    propagatedBuildInputs = with self; [ werkzeug jinja2 ];

    meta = {
      homepage = http://flask.pocoo.org/;
      description = "A microframework based on Werkzeug, Jinja 2, and good intentions";
      license = "BSD";
    };
  };

  flask_cache = buildPythonPackage rec {
    name = "Flask-Cache-0.13.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/F/Flask-Cache/${name}.tar.gz";
      md5 = "ab82a9cd0844891ccdb54fbb93fd6c59";
    };

    propagatedBuildInputs = with self; [ werkzeug flask ];

    meta = {
      homepage = https://github.com/thadeusb/flask-cache;
      description = "Adds cache support to your Flask application";
      license = "BSD";
    };
  };

  flexget = buildPythonPackage rec {
    version = "1.2.234";
    name = "FlexGet-${version}";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/F/FlexGet/${name}.tar.gz";
      md5 = "0897b6db25e8a28e809d131a8ad017e4";
    };

    doCheck = false;

    buildInputs = with self; [ nose ];
    propagatedBuildInputs = with self; [ paver feedparser sqlalchemy9 pyyaml rpyc
	    beautifulsoup4 html5lib pyrss2gen pynzb progressbar jinja2 flask
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
      license = stdenv.lib.licenses.mit;
      maintainers = [ stdenv.lib.maintainers.iElectric ];
    };
  };

  grappelli_safe = buildPythonPackage rec {
    version = "0.3.13";
    name = "grappelli_safe-${version}";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/g/grappelli_safe/${name}.tar.gz";
      md5 = "5c8c681a0b1df94ecd6dc0b3a8b80892";
    };

    meta = with stdenv.lib; {
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
      md5 = "cdfec252158c5047b626861900186dfb";
    };

    # has mostly networking dependent tests
    doCheck = false;
    propagatedBuildInputs = with self; [ beautifulsoup ];

    meta = {
      homepage = https://github.com/ckreutzer/python-tvrage;
      description = "Client interface for tvrage.com's XML-based api feeds";
      license = stdenv.lib.licenses.bsd3;
      maintainers = [ stdenv.lib.maintainers.iElectric ];
    };
  });

  jsonschema = buildPythonPackage (rec {
    version = "2.4.0";
    name = "jsonschema-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/j/jsonschema/jsonschema-${version}.tar.gz";
      md5 = "661f85c3d23094afbb9ac3c0673840bf";
    };

    buildInputs = with self; [ nose mock ];

    patchPhase = ''
      substituteInPlace jsonschema/tests/test_jsonschema_test_suite.py --replace "python" "${python}/bin/${python.executable}"
    '';

    checkPhase = ''
      nosetests
    '';

    meta = {
      homepage = https://github.com/Julian/jsonschema;
      description = "An implementation of JSON Schema validation for Python";
      license = stdenv.lib.licenses.mit;
      maintainers = [ stdenv.lib.maintainers.iElectric ];
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
    version = "2.4";
    name = "fonttools-${version}";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/F/FontTools/FontTools-${version}.tar.gz";
      sha256 = "13ggkzcj34kcca6bsxjkaqsxkp2bvxxf6ijiyhq1xlyb0z37z4qa";
    };

    buildInputs = with self; [
      numpy
    ];

    meta = {
      homepage = "http://sourceforge.net/projects/fonttools/";
      description = "Font file processing tools";
    };
  });

  foolscap = buildPythonPackage (rec {
    name = "foolscap-0.6.4";

    src = pkgs.fetchurl {
      url = "http://foolscap.lothar.com/releases/${name}.tar.gz";
      sha256 = "16cddyk5is0gjfn0ia5n2l4lhdzvbjzlx6sfpy7ddjd3d3fq7ckl";
    };

    propagatedBuildInputs = with self; [ twisted self.pyopenssl ];

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
      license = stdenv.lib.licenses.mit;

      maintainers = [ ];
    };
  });

  fs = buildPythonPackage rec {
    name = "fs-0.5.0";

    src = pkgs.fetchurl {
      url    = "https://pypi.python.org/packages/source/f/fs/${name}.tar.gz";
      sha256 = "144f4yn2nvnxh2vrnmiabpwx3s637np0d1j1w95zym790d66shir";
    };

    meta = with stdenv.lib; {
      description = "Filesystem abstraction";
      homepage    = http://pypi.python.org/pypi/fs;
      license     = licenses.bsd3;
      maintainers = with maintainers; [ lovek323 ];
      platforms   = platforms.unix;
    };

    # Fails: "error: invalid command 'test'"
    doCheck = false;
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
      license = stdenv.lib.licenses.lgpl21;
    };
  });

  future = buildPythonPackage rec {
    version = "v0.14.3";
    name = "future-${version}";

    src = pkgs.fetchurl {
      url = "http://github.com/PythonCharmers/python-future/archive/${version}.tar.gz";
      sha256 = "0hgp9kq7h4ipw8ax5xvvkyh3bkqw361d3rndvb9xix01h9j9mi3p";
    };

    propagatedBuildInputs = with self; optionals isPy26 [ importlib argparse ];
    doCheck = false;

    meta = with stdenv.lib; {
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
    name = "futures-2.1.6";


    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/f/futures/futures-2.1.6.tar.gz";
      md5 = "cfab9ac3cd55d6c7ddd0546a9f22f453";
    };

    meta = with pkgs.stdenv.lib; {
      description = "Backport of the concurrent.futures package from Python 3.2";
      homepage = http://code.google.com/p/pythonfutures;
      license = licenses.bsd2;
    };
  };

  gcovr = buildPythonPackage rec {
    name = "gcovr-2.4";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/g/gcovr/${name}.tar.gz";
      md5 = "672db629469882b93c40016aebff50ac";
    };

    meta = {
      description = "A Python script for summarizing gcov data";
      license = "BSD";
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
    name = "gevent-1.0.1";
    disabled = isPy3k || isPyPy;  # see https://github.com/surfly/gevent/issues/248

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/g/gevent/${name}.tar.gz";
      sha256 = "0hyzfb0gcx9pm5c2igan8y57hqy2wixrwvdjwsaivxsqs0ay49s6";
    };

    buildInputs = with self; [ pkgs.libev ];
    propagatedBuildInputs = optionals (!isPyPy) [ self.greenlet ];

    meta = with stdenv.lib; {
      description = "Coroutine-based networking library";
      homepage = http://www.gevent.org/;
      license = licenses.mit;
      platforms = platforms.linux;
      maintainers = [ maintainers.bjornfor ];
    };
  };

  geventhttpclient = buildPythonPackage rec {
    name = "geventhttpclient-${version}";
    version = "1.1.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/g/geventhttpclient/${name}.tar.gz";
      sha256 = "1k7s4dnkmcfqqkmbqi0vvb2ns53r9cl2652mq20bgg65zj26j2l6";
    };

    propagatedBuildInputs = with self; [ gevent certifi backports_ssl_match_hostname_3_4_0_2 ];

    meta = with stdenv.lib; {
      homepage = http://github.com/gwik/geventhttpclient;
      description = "HTTP client library for gevent";
      license = licenses.mit;
      maintainers = [ maintainers.koral ];
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
      md5 = "7a954f1835875002e9044fe55ed1b488";
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


  glance = buildPythonPackage rec {
    name = "glance-0.1.7";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/g/glance/${name}.tar.gz";
      md5 = "e733713ccd23e4a6253386a47971cfb5";
    };

    buildInputs = with self; [ nose mox ];

    # tests fail for python2.6
    doCheck = python.majorVersion != "2.6";

    propagatedBuildInputs = with self; [ gflags sqlalchemy webob routes eventlet ];

    PYTHON_EGG_CACHE = "`pwd`/.egg-cache";

    meta = {
      homepage = https://launchpad.net/glance;
      description = "Services for discovering, registering, and retrieving virtual machine images";
    };
  };

  glances = buildPythonPackage rec {
    name = "glances-${version}";
    version = "2.1";
    disabled = isPyPy;

    src = pkgs.fetchFromGitHub {
      owner = "nicolargo";
      repo = "glances";
      rev = "v${version}";
      sha256 = "1bgr7lif0bpnz39arcdrsfdy7ra4c3ay2pxz1lvh4fqxyxwp3gm6";
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

  goobook = buildPythonPackage rec {
    name = "goobook-1.5";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url    = "https://pypi.python.org/packages/source/g/goobook/${name}.tar.gz";
      sha256 = "05vpriy391l5i05ckl5ja5bswqyvl3rwrbmks9pi46w1813j7p5z";
    };

    buildInputs = with self; [ six ];

    preConfigure = ''
      sed -i '/distribute/d' setup.py
    '';

    meta = with stdenv.lib; {
      description = "Search your google contacts from the command-line or mutt";
      homepage    = https://pypi.python.org/pypi/goobook;
      license     = licenses.gpl3;
      maintainers = with maintainers; [ lovek323 ];
      platforms   = platforms.unix;
    };

    propagatedBuildInputs = with self; [ gdata hcs_utils keyring simplejson ];
  };

  google_api_python_client = buildPythonPackage rec {
    name = "google-api-python-client-1.2";

    src = pkgs.fetchurl {
      url = "https://google-api-python-client.googlecode.com/files/google-api-python-client-1.2.tar.gz";
      sha256 = "0xd619w71xk4ldmikxqhaaqn985rc2hy4ljgwfp50jb39afg7crw";
    };

    propagatedBuildInputs = with self; [ httplib2 ];

    meta = with stdenv.lib; {
      description = "The core Python library for accessing Google APIs";
      homepage = "https://code.google.com/p/google-api-python-client/";
      license = licenses.asl20;
      platforms = platforms.unix;
    };
  };

   google_apputils = buildPythonPackage rec {
    name = "google-apputils-0.4.0";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = http://pypi.python.org/packages/source/g/google-apputils/google-apputils-0.4.0.tar.gz;
      sha256 = "18wlivnqxvx1wsw177lckpl32nmr6cq7f5nhk8r72fvjy8wynq5j";
    };

    propagatedBuildInputs = with self; [ pytz gflags dateutil_1_5 mox ];

    meta = with stdenv.lib; {
      description = "Google Application Utilities for Python";
      homepage = http://code.google.com/p/google-apputils-python;
    };
  };


  greenlet = buildPythonPackage rec {
    name = "greenlet-${version}";
    version = "0.4.5";
    disabled = isPyPy;  # builtin for pypy

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/g/greenlet/${name}.zip";
      sha256 = "1gidivqcpn6i6k01bf3hgcn0m68h4b9srhpff9kgnk0c287z145r";
    };

    meta = with stdenv.lib; {
      homepage = http://pypi.python.org/pypi/greenlet;
      description = "Module for lightweight in-process concurrent programming";
      license     = licenses.lgpl2;
      platforms   = platforms.all;
    };
  };


  gyp = buildPythonPackage rec {
    rev = "1977";
    name = "gyp-r${rev}";

    src = pkgs.fetchsvn {
      url = "http://gyp.googlecode.com/svn/trunk";
      inherit rev;
      sha256 = "0vnr75yd3bidysiwl9lljvf1dv6v9m9xqdnx0hdgyl92w689n9j8";
    };

    patches = optionals pkgs.stdenv.isDarwin [
      ../development/python-modules/gyp/no-darwin-cflags.patch
    ];

    meta = {
      homepage = http://code.google.com/p/gyp;
      license = stdenv.lib.licenses.bsd3;
      description = "Generate Your Projects";
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
      license = stdenv.lib.licenses.lgpl3;
      description = "A library for guessing information from video files.";
    };
  };

  gunicorn = buildPythonPackage rec {
    name = "gunicorn-19.1.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/g/gunicorn/${name}.tar.gz";
      md5 = "3d759bec3c46a680ff010775258c4c56";
    };

    buildInputs = with self; [ pytest ];

    meta = {
      homepage = http://pypi.python.org/pypi/gunicorn;
      description = "WSGI HTTP Server for UNIX";
    };
  };

  hcs_utils = buildPythonPackage rec {
    name = "hcs_utils-1.5";

    src = pkgs.fetchurl {
      url    = "https://pypi.python.org/packages/source/h/hcs_utils/${name}.tar.gz";
      sha256 = "1d2za9crkgzildx610w3zif2i8phcqhh6n8nzg3yvy2mg0s18mkl";
    };

    preBuild = ''
      export LOCALE_ARCHIVE=${localePath}
      export LC_ALL="en_US.UTF-8"
    '';

    buildInputs = with self; [ six ];

    meta = with stdenv.lib; {
      description = "Library collecting some useful snippets";
      homepage    = https://pypi.python.org/pypi/hcs_utils/1.3;
      license     = licenses.isc;
      maintainers = with maintainers; [ lovek323 ];
      platforms   = platforms.unix;
    };
  };


  hetzner = buildPythonPackage rec {
    name = "hetzner-${version}";
    version = "0.7.2";

    src = pkgs.fetchurl {
      url = "https://github.com/RedMoonStudios/hetzner/archive/"
          + "v${version}.tar.gz";
      sha256 = "07jnrgy9fkh1hwgsa8491ljz9spazmifqsg92m3xnamja1536qfl";
    };

    # not there yet, but coming soon.
    doCheck = false;

    meta = {
      homepage = "https://github.com/RedMoonStudios/hetzner";
      description = "High-level Python API for accessing the Hetzner robot";
      license = stdenv.lib.licenses.bsd3;
      maintainers = [ stdenv.lib.maintainers.aszlig ];
    };
  };


  htmllaundry = buildPythonPackage rec {
    name = "htmllaundry-2.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/h/htmllaundry/${name}.tar.gz";
      md5 = "6db6909de76c4b259e65d90b5debdbda";
    };

    buildInputs = with self; [ nose ];
    propagatedBuildInputs = with self; [ six lxml ];

    # some tests fail, probably because of changes in lxml
    # not relevant for me, if releavnt for you, fix it...
    doCheck = false;

    meta = {
      description = "Simple HTML cleanup utilities";
      license = stdenv.lib.licenses.bsd3;
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

    meta = with stdenv.lib; {
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
      md5 = "015061846254bd5d8c5dbc2913985153";
    };

    propagatedBuildInputs = with self; [pycrypto];

    meta = {
      homepage = https://github.com/atl/py-http-signature;
      description = "";
      license = stdenv.lib.licenses.mit;
    };
  });

  httpbin = buildPythonPackage rec {
    name = "httpbin-0.2.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/h/httpbin/${name}.tar.gz";
      md5 = "9b2bb2fab45f5fa839e9a776a64d6089";
    };

    propagatedBuildInputs = with self; [ flask markupsafe decorator itsdangerous six ];

    meta = {
      homepage = https://github.com/kennethreitz/httpbin;
      description = "HTTP Request & Response Service";
      license = licenses.mit;
    };

  };

  httplib2 = buildPythonPackage rec {
    name = "httplib2-0.9";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/h/httplib2/${name}.tar.gz";
      sha256 = "1asi5wpncnc6ki3bz33mhb9xh2lrkb24y4qng8bmqnczdmm8rsir";
    };

    meta = {
      homepage = http://code.google.com/p/httplib2;
      description = "A comprehensive HTTP client library";
      license = licenses.mit;
      maintainers = [ stdenv.lib.maintainers.garbas ];
    };
  };

  httpretty = buildPythonPackage rec {
    name = "httpretty-${version}";
    version = "0.8.3";
    disabled = isPy3k;
    doCheck = !isPyPy;

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/h/httpretty/${name}.tar.gz";
      md5 = "50b02560a49fe928c90c53a49791f621";
    };

    buildInputs = with self; [ tornado requests httplib2 sure nose coverage ];

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
    version = "3.8.4";
    name = "icalendar-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/i/icalendar/${name}.zip";
      md5 = "d700e6e75613fd1ee882c4b11c58940c";
    };

    buildInputs = with self; [ setuptools ];
    propagatedBuildInputs = with self; [ pytz ];

    meta = with stdenv.lib; {
      description = "A parser/generator of iCalendar files";
      homepage = "http://icalendar.readthedocs.org/";
      license = licenses.bsd2;
      maintainers = [ maintainers.olcai ];
    };
  };

  importlib = if isPy26 then (buildPythonPackage {
    name = "importlib-1.0.2";
    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/i/importlib/importlib-1.0.2.tar.gz";
      md5 = "4aa23397da8bd7c7426864e88e4db7e1";
    };
    doCheck = false;
  }) else null;

  influxdb = buildPythonPackage rec {
    name = "influxdb-0.1.12";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/i/influxdb/${name}.tar.gz";
      md5 = "6c975058ccc4df41dad8d8234c52d754";
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

  iptools = buildPythonPackage rec {
    version = "0.6.1";
    name = "iptools-${version}";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/i/iptools/iptools-${version}.tar.gz";
      md5 = "aed4045638fd40c16f8d9bb04606f700";
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
      md5 = "f4f7ddc7c5e55a47222a5cc6c0a87b6d";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      description = "Class and tools for handling of IPv4 and IPv6 addresses and networks";
      homepage = http://pypi.python.org/pypi/IPy;
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

  ipdb = buildPythonPackage rec {
    name = "ipdb-0.8";
    disabled = isPyPy;  # setupterm: could not find terminfo database
    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/i/ipdb/${name}.zip";
      md5 = "96dca0712efa01aa5eaf6b22071dd3ed";
    };
    propagatedBuildInputs = with self; [ self.ipythonLight ];
  };

  ipdbplugin = buildPythonPackage {
    name = "ipdbplugin-1.4";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/i/ipdbplugin/ipdbplugin-1.4.tar.gz";
      md5 = "f9a41512e5d901ea0fa199c3f648bba7";
    };
    propagatedBuildInputs = with self; [ self.nose self.ipythonLight ];
  };

  iso8601 = buildPythonPackage {
    name = "iso8601-0.1.10";
    src = pkgs.fetchurl {
      url = https://pypi.python.org/packages/source/i/iso8601/iso8601-0.1.10.tar.gz;
      sha256 = "1qf01afxh7j4gja71vxv345if8avg6nnm0ry0zsk6j3030xgy4p7";
    };

    meta = {
      homepage = https://bitbucket.org/micktwomey/pyiso8601/;
      description = "Simple module to parse ISO 8601 dates";
      maintainers = [ stdenv.lib.maintainers.phreedom ];
    };
  };

  jedi = buildPythonPackage (rec {
    name = "jedi-0.8.0-final0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/j/jedi/${name}.tar.gz";
      sha256 = "0jnhwh0b1hy5cssi3n5a4j7z9pgpcckyv5s52ba4jnq5bwgdpbcf";
    };

    meta = {
      homepage = https://github.com/davidhalter/jedi;
      description = "An autocompletion tool for Python that can be used for text editors";
      license = licenses.lgpl3Plus;
      maintainers = [ stdenv.lib.maintainers.garbas ];
    };
  });

  jinja2 = buildPythonPackage rec {
    name = "Jinja2-2.7.3";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/J/Jinja2/${name}.tar.gz";
      # md5 = "b9dffd2f3b43d673802fe857c8445b1a"; # provided by pypi website.
      sha256 = "2e24ac5d004db5714976a04ac0e80c6df6e47e98c354cb2c0d82f8879d4f8fdb";
    };

    propagatedBuildInputs = with self; [ self.markupsafe ];

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
      maintainers = [ maintainers.pierron ];
    };
  };


  jmespath = buildPythonPackage rec {
    name = "jmespath-0.5.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/j/jmespath/${name}.tar.gz";
      sha256 = "1hiqqaz1a9qv1j8n02r9c2c010krr0ar2sf35j2z2kci7ywky963";
    };

    propagatedBuildInputs = with self; [ ply ];

    meta = {
      homepage = "https://github.com/boto/jmespath";
      description = "JMESPath allows you to declaratively specify how to extract elements from a JSON document";
      license = "BSD";
    };
  };


  jrnl = buildPythonPackage rec {
    name = "jrnl-1.9.7";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/j/jrnl/${name}.tar.gz";
      md5 = "395faff36de8a08a5bfeedbf123e9067";
    };

    propagatedBuildInputs = with self; [
      pytz six tzlocal keyring modules.readline argparse dateutil_1_5
      parsedatetime
    ];

    meta = with stdenv.lib; {
      homepage = http://maebert.github.io/jrnl/;
      description = "A simple command line journal application that stores your journal in a plain text file.";
      license = licenses.mit;
    };
  };


  keyring = buildPythonPackage rec {
    name = "keyring-3.3";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/k/keyring/${name}.zip";
      md5 = "81291e0c7337affb71442e6c7671e77f";
    };

    buildInputs = with self;
      [ fs gdata python_keyczar mock pyasn1 pycrypto pytest six ];

    meta = with stdenv.lib; {
      description = "Store and access your passwords safely";
      homepage    = "https://pypi.python.org/pypi/keyring";
      license     = licenses.psfl;
      maintainers = with maintainers; [ lovek323 ];
      platforms   = platforms.unix;
    };
  };

  kitchen = buildPythonPackage (rec {
    name = "kitchen-1.1.1";
    disabled = isPy3k;

    meta.maintainers = [ stdenv.lib.maintainers.mornfall ];

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
      md5 = "506cf1b13020b3ed2f3c845ea0c9830e";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://code.google.com/p/pylast/;
      description = "A python interface to last.fm (and compatibles)";
      license = licenses.asl20;
    };
  };


  libcloud = buildPythonPackage (rec {
    name = "libcloud-0.14.1";

    src = pkgs.fetchurl {
      url = https://pypi.python.org/packages/source/a/apache-libcloud/apache-libcloud-0.14.1.tar.bz2;
      sha256 = "1l6190pjv54c7y8pzr089ij727qv7bqhhaznr2mkvimgr1wzsql5";
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


  limnoria = buildPythonPackage (rec {
    name = "limnoria-20130327";

    src = pkgs.fetchurl {
      url = https://pypi.python.org/packages/source/l/limnoria/limnoria-2013-06-01T10:32:51+0200.tar.gz;
      name = "limnoria-2013-06-01.tar.gz";
      sha256 = "1i8q9zzf43sr3n1q4h6h1z8nz31g4aa8dq94ywvfbh7hklmchq6n";
    };

    buildInputs = with self; [ pkgs.git ];
    propagatedBuildInputs = with self; [ modules.sqlite3 ];

    doCheck = false;

    meta = with stdenv.lib; {
      description = "A modified version of Supybot, an IRC bot";
      homepage = http://supybot.fr.cr;
      license = licenses.bsd3;
      maintainers = [ maintainers.goibhniu ];
    };
  });


  linode = buildPythonPackage rec {
    name = "linode-${version}";
    version = "0.4";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/l/linode/linode-${version}.tar.gz";
      md5 = "03a306575cf274719b3206ecee0bda9e";
    };

    propagatedBuildInputs = with self; [ requests2 ];

    meta = with stdenv.lib; {
      homepage = "https://github.com/ghickman/linode";
      description = "A thin python wrapper around Linode's API";
      license = licenses.mit;
      maintainers = [ maintainers.nslqqq ];
    };
  };

  llfuse = buildPythonPackage rec {
    name = "llfuse-0.40";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/l/llfuse/${name}.tar.bz2";
      sha256 = "0mx87n6j2g63mgiimjqn0gj6jgqfdkc04xkxc56r1azjlqji32zf";
    };

    buildInputs = [ pkgs.pkgconfig pkgs.fuse pkgs.attr ];

    meta = with stdenv.lib; {
      description = "Python bindings for the low-level FUSE API";
      homepage = https://code.google.com/p/python-llfuse/;
      license = licenses.lgpl2Plus;
      platforms = platforms.unix;
      maintainers = [ maintainers.bjornfor ];
    };
  };

  locustio = buildPythonPackage rec {
    name = "locustio-0.7.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/l/locustio/${name}.tar.gz";
      md5 = "90cf4d029d58ad58d19ea17a16e59c34";
    };

    propagatedBuildInputs = [ self.msgpack self.requests2 self.flask self.gevent self.pyzmq ];
    buildInputs = [ self.mock self.unittest2 ];

    meta = {
      homepage = http://locust.io/;
      description = "A load testing tool";
    };
  };

  lockfile = buildPythonPackage rec {
    name = "lockfile-0.9.1";

    src = pkgs.fetchurl {
      url = "http://pylockfile.googlecode.com/files/${name}.tar.gz";
      sha1 = "1eebaee375641c9f29aeb21768f917dd2b985752";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://code.google.com/p/pylockfile/;
      description = "Platform-independent advisory file locking capability for Python applications";
    };
  };

  logilab_common = buildPythonPackage rec {
    name = "logilab-common-0.61.0";

    src = pkgs.fetchurl {
      url = "http://download.logilab.org/pub/common/${name}.tar.gz";
      sha256 = "09apsrcvjliawbxmfrmi1l8hlbaj87mb7n4lrlivy5maxs6yg4hd";
    };

    propagatedBuildInputs = with self; [ unittest2 ];
  };

  lxml = buildPythonPackage ( rec {
    name = "lxml-3.3.6";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/l/lxml/${name}.tar.gz";
      md5 = "a804b36864c483fe7abdd7f493a0c379";
    };

    buildInputs = with self; [ pkgs.libxml2 pkgs.libxslt ];

    meta = {
      description = "Pythonic binding for the libxml2 and libxslt libraries";
      homepage = http://codespeak.net/lxml/index.html;
      license = "BSD";
    };
  });


  python_magic = buildPythonPackage rec {
    name = "python-magic-0.4.6";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/python-magic/${name}.tar.gz";
      md5 = "07e7a0fea78dd81ed609414c3484df58";
    };

    propagatedBuildInputs = with self; [ pkgs.file ];

    patchPhase = ''
      substituteInPlace magic.py --replace "ctypes.CDLL(dll)" "ctypes.CDLL('${pkgs.file}/lib/libmagic.so')"
    '';

    doCheck = false;

    # TODO: tests are failing
    #checkPhase = ''
    #  ${python}/bin/${python.executable} ./test.py
    #'';

    meta = {
      description = "python-magic is a python interface to the libmagic file type identification library";
      homepage = https://github.com/ahupp/python-magic;
    };
  };

  magic = buildPythonPackage rec {
    name = "${pkgs.file.name}";

    src = pkgs.file.src;

    patches = [ ../tools/misc/file/python.patch ];
    buildInputs = with self; [ python pkgs.file ];

    preConfigure = "cd python";

    meta = {
      description = "A Python wrapper around libmagic";
      homepage = http://www.darwinsys.com/file/;
    };
  };


  m2crypto = buildPythonPackage rec {
    version = "0.21.1";
    name = "m2crypto-${version}";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/M/M2Crypto/M2Crypto-${version}.tar.gz";
      md5 = "f93d8462ff7646397a9f77a2fe602d17";
    };

    buildInputs = with self; [ pkgs.swig pkgs.openssl ];

    preBuild = "${python}/bin/${python.executable} setup.py build_ext --openssl=${pkgs.openssl}";

    doCheck = false; # another test that depends on the network.

    meta = {
      description = "A Python crypto and SSL toolkit";
      homepage = http://chandlerproject.org/Projects/MeTooCrypto;
    };
  };


  Mako = buildPythonPackage rec {
    name = "Mako-0.9.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/M/Mako/${name}.tar.gz";
      md5 = "fe3f394ef714776d09ec6133923736a7";
    };

    buildInputs = with self; [ markupsafe nose ];
    propagatedBuildInputs = with self; [ markupsafe ];

    meta = {
      description = "Super-fast templating language";
      homepage = http://www.makotemplates.org;
      license = stdenv.lib.licenses.mit;
      maintainers = [ stdenv.lib.maintainers.iElectric ];
    };
  };


  markupsafe = buildPythonPackage rec {
    name = "markupsafe-0.15";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/M/MarkupSafe/${name}.tar.gz";
      md5 = "4e7c4d965fe5e033fa2d7bb7746bb186";
    };

    meta = {
      description = "Implements a XML/HTML/XHTML Markup safe string";
      homepage = http://dev.pocoo.org;
      license = "BSD";
      maintainers = [ stdenv.lib.maintainers.iElectric ];
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
      license = stdenv.lib.licenses.zpt20;
    };
  };

  markdown = buildPythonPackage rec {
    version = "2.3.1";
    name = "markdown-${version}";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/M/Markdown/Markdown-${version}.tar.gz";
      sha256 = "147j9hznv2r187a86d28glmg3pckfrdp0nz9yh7s1aqpawwdkszz";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://www.freewisdom.org/projects/python-markdown;
    };
  };


  matplotlib = buildPythonPackage rec {
    name = "matplotlib-1.4.2";

    src = pkgs.fetchurl {
      url = "mirror://sourceforge/matplotlib/${name}.tar.gz";
      sha256 = "0m6v9nwdldlwk22gcd339zg6mny5m301fxgks7z8sb8m9wawg8qp";
    };

    buildInputs = with self; [ python pkgs.which pkgs.ghostscript ] ++
        (if stdenv.isDarwin then [ pkgs.clangStdenv ] else [ pkgs.stdenv ]);

    propagatedBuildInputs = with self;
      [ dateutil nose numpy pyparsing tornado pkgs.freetype pkgs.libpng pkgs.pkgconfig
        mock pytz
      ];

    meta = with stdenv.lib; {
      description = "python plotting library, making publication quality plots";
      homepage    = "http://matplotlib.sourceforge.net/";
      maintainers = with maintainers; [ lovek323 ];
      platforms   = platforms.unix;
    };
  };


  mccabe = buildPythonPackage (rec {
    name = "mccabe-0.2.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/m/mccabe/${name}.tar.gz";
      md5 = "5a3f3fa6a4bad126c88aaaa7dab682f5";
    };

    buildInputs = with self; [ ];

    meta = {
      description = "McCabe checker, plugin for flake8";
      homepage = "https://github.com/flintwork/mccabe";
      license = licenses.mit;
      maintainers = [ stdenv.lib.maintainers.garbas ];
    };
  });


  mechanize = buildPythonPackage (rec {
    name = "mechanize-0.1.11";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "http://wwwsearch.sourceforge.net/mechanize/src/${name}.tar.gz";
      sha256 = "1h62mwy4iz09jqz17nrb9j8y0djd500zdfqwrz9xmdwqzqwixkj2";
    };

    propagatedBuildInputs = with self; [ clientform ];

    meta = {
      description = "Stateful programmatic web browsing in Python";

      homepage = http://wwwsearch.sourceforge.net/;

      license = "BSD-style";
    };
  });


  meld3 = buildPythonPackage rec {
    name = "meld3-1.0.0";

    src = pkgs.fetchurl {
      url = https://pypi.python.org/packages/source/m/meld3/meld3-1.0.0.tar.gz;
      md5 = "ca270506dd4ecb20ae26fa72fbd9b0be";
    };

    doCheck = false;

    meta = {
      description = "An HTML/XML templating engine used by supervisor";
      homepage = https://github.com/supervisor/meld3;
      license = stdenv.lib.licenses.free;
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
    name = "memory_profiler-0.27";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/m/memory_profiler/memory_profiler-0.27.tar.gz";
      md5 = "212c0d7452dbaffb6b09474ac07b0668";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      description = "A module for monitoring memory usage of a python program";
      homepage = http://pypi.python.org/pypi/memory_profiler;
    };
  };

  mezzanine = buildPythonPackage rec {
    version = "3.1.10";
    name = "mezzanine-${version}";

    src = pkgs.fetchurl {
      url = "https://github.com/stephenmcd/mezzanine/archive/${version}.tar.gz";
      sha256 = "1cd7d3dji8q4mvcnf9asxn8j109pd5g5d5shr6xvn0iwr35qprgi";
    };

    buildInputs = with self; [ pyflakes pep8 ];
    propagatedBuildInputs = with self; [
      django_1_6 filebrowser_safe grappelli_safe bleach tzlocal beautifulsoup4
      requests2 requests_oauthlib future pillow modules.sqlite3
    ];

    # Tests Fail Due to Syntax Warning, Fixed for v3.1.11+
    doCheck = false;
    # sed calls will be unecessary in v3.1.11+
    preConfigure = ''
      sed -i 's/future == 0.9.0/future>=0.9.0/' setup.py
      sed -i 's/tzlocal == 1.0/tzlocal>=1.0/' setup.py
      sed -i 's/pep8==1.4.1/pep8>=1.4.1/' setup.py
      sed -i 's/pyflakes==0.6.1/pyflakes>=0.6.1/' setup.py
      export LC_ALL="en_US.UTF-8"
    '';

    meta = with stdenv.lib; {
      description = ''
        A content management platform built using the Django framework.
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

  rainbowstream = buildPythonPackage rec {
    name = "rainbowstream-${version}";
    version = "1.1.6";

    src = pkgs.fetchurl {
      url    = "https://pypi.python.org/packages/source/r/rainbowstream/${name}.tar.gz";
      sha256 = "04i2a8a5k6n6lgfpa9bzzbkhvywgd4bn3qlspl97pn8ply9kgszm";
    };

    doCheck = false;

    preBuild = ''
      export LOCALE_ARCHIVE=${localePath}
      export LC_ALL="en_US.UTF-8"
    '';

    postInstall = ''
      for prog in "$out/bin/"*; do
        wrapProgram "$prog" \
          --prefix PYTHONPATH : "$PYTHONPATH"
      done
    '';

    buildInputs = with self; [
      pkgs.libjpeg pkgs.freetype pkgs.zlib
      pillow twitter pyfiglet requests arrow dateutil modules.readline pysocks
    ];

    meta = {
      description = "Streaming command-line twitter client";
      homepage    = "http://www.rainbowstream.org/";
      license     = licenses.mit;
      maintainers = [ maintainers.thoughtpolice ];
    };
  };

  mitmproxy = buildPythonPackage rec {
    baseName = "mitmproxy";
    name = "${baseName}-${meta.version}";

    src = pkgs.fetchurl {
      url = "${meta.homepage}/download/${name}.tar.gz";
      sha256 = "0mpyw8iw4l4jv175qlbn0rrlgiz1k79m44jncbdxfj8ddvvvyz2j";
    };

    buildInputs = with self; [
      pyopenssl pyasn1 urwid pil lxml flask protobuf netlib
    ];

    doCheck = false;

    postInstall = ''
      for prog in "$out/bin/"*; do
        wrapProgram "$prog" \
          --prefix PYTHONPATH : "$PYTHONPATH"
      done
    '';

    meta = {
      version = "0.10.1";
      description = ''Man-in-the-middle proxy'';
      homepage = "http://mitmproxy.org/";
      license = licenses.mit;
    };
  };

  mock = buildPythonPackage (rec {
    name = "mock-1.0.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/m/mock/${name}.tar.gz";
      md5 = "c3971991738caa55ec7c356bbc154ee2";
    };

    buildInputs = with self; [ unittest2 ];

    meta = {
      description = "Mock objects for Python";

      homepage = http://python-mock.sourceforge.net/;

      license = "mBSD";
    };
  });

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

      license = stdenv.lib.licenses.gpl2Plus;
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

    meta = with stdenv.lib; {
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
      sha1 = "b71aeaacf31898c3b38d8b9ca5bcc0664499c0de";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://code.google.com/p/pymox/;
      description = "A mock object framework for Python";
    };
  };


  mpmath = buildPythonPackage rec {
    name = "mpmath-0.17";

    src = pkgs.fetchurl {
      url    = "https://mpmath.googlecode.com/files/${name}.tar.gz";
      sha256 = "1blgzwq4irzaf8abb4z0d2r48903n9zxf51fhnv3gv09bgxjqzxh";
    };

    meta = with stdenv.lib; {
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
      md5 = "5b3849b131e2fb12f251434597d65635";
    };

    meta = with pkgs.stdenv.lib; {
      description = "An MPD (Music Player Daemon) client library written in pure Python";
      homepage = http://jatreuman.indefero.net/p/python-mpd/;
      license = licenses.gpl3;
    };
  };

  mrbob = buildPythonPackage rec {
    name = "mrbob-${version}";
    version = "0.1.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/m/mr.bob/mr.bob-${version}.zip";
      md5 = "84a117c9a75b86842b0fa5f5c9c767f3";
    };

    # some files in tests dir include unicode names
    preBuild = ''
      export LOCALE_ARCHIVE=${localePath}
      export LC_ALL="en_US.UTF-8"
    '';

    propagatedBuildInputs = with self; [ argparse jinja2 six modules.readline ] ++
                            (optionals isPy26 [ importlib ordereddict ]);

    meta = {
      homepage = https://github.com/iElectric/mr.bob.git;
      description = "A tool to generate code skeletons from templates";
    };
  };

  msgpack = buildPythonPackage rec {
    name = "msgpack-python-${version}";
    version = "0.4.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/m/msgpack-python/${name}.tar.gz";
      md5 = "e3a0fdfd864c72c958bb501d39b39caf";
    };

    propagatedBuildInputs = with self; [ ];
  };

  msrplib = buildPythonPackage rec {
    name = "python-msrplib-${version}";
    version = "0.15.0";

    src = pkgs.fetchurl {
      url = "http://download.ag-projects.com/SipClient/${name}.tar.gz";
      sha256 = "1sm03jcz663xkbhfmrk7rr5l3wlkydn8xs56fvqjxyapx0m5sw6f";
    };

    propagatedBuildInputs = with self; [ eventlib application gnutls ];
  };


  munkres = buildPythonPackage rec {
    name = "munkres-1.0.6";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/m/munkres/${name}.tar.gz";
      md5 = "d7ba3b8c5001578ae229a2d5a655872f";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://bmc.github.com/munkres/;
      description = "Munkres algorithm for the Assignment Problem";
      license = licenses.bsd3;
      maintainers = [ stdenv.lib.maintainers.iElectric ];
    };
  };


  musicbrainzngs = buildPythonPackage rec {
    name = "musicbrainzngs-0.5";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/m/musicbrainzngs/${name}.tar.gz";
      md5 = "9e17a181af72d04a291c9a960bc73d44";
    };

    preCheck = ''
      export LOCALE_ARCHIVE=${localePath}
      export LC_ALL="en_US.UTF-8"
    '';

    meta = {
      homepage = http://alastair/python-musicbrainz-ngs;
      description = "Python bindings for musicbrainz NGS webservice";
      license = licenses.bsd2;
      maintainers = [ stdenv.lib.maintainers.iElectric ];
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
      license = stdenv.lib.licenses.gpl3;
      maintainers = [ stdenv.lib.maintainers.DamienCassou ];
    };
  };

  mutagen = buildPythonPackage (rec {
    name = "mutagen-1.27";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/m/mutagen/${name}.tar.gz";
      md5 = "6a9bb5cc33214add35348f1bb3448340";
    };

    # Needed for tests only
    buildInputs = [ pkgs.faad2 pkgs.flac pkgs.vorbisTools pkgs.liboggz ];

    meta = {
      description = "Python multimedia tagging library";
      homepage = http://code.google.com/p/mutagen;
      license = stdenv.lib.licenses.lgpl2;
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
      license = stdenv.lib.licenses.gpl2Plus;
    };
  });


  MySQL_python = buildPythonPackage {
    name = "MySQL-python-1.2.3";

    disabled = isPy3k;

    # plenty of failing tests
    doCheck = false;

    src = pkgs.fetchurl {
      url = mirror://sourceforge/mysql-python/MySQL-python-1.2.3.tar.gz;
      sha256 = "0vkyg9dmj29hzk7fy77f42p7bfj28skyzsjsjry4wqr3z6xnzrkx";
    };

    buildInputs = with self; [ nose ];

    propagatedBuildInputs = with self; [ pkgs.mysql pkgs.zlib ];

    meta = {
      description = "MySQL database binding for Python";

      homepage = http://sourceforge.net/projects/mysql-python;
    };
  };


  mysql_connector_repackaged = buildPythonPackage rec {
    name = "mysql-connector-repackaged-0.3.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/m/mysql-connector-repackaged/${name}.tar.gz";
      md5 = "0b17ad1cb3fe763fd44487cb97cf45b2";
    };

    meta = {
      maintainers = [
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.iElectric
      ];
      platforms = stdenv.lib.platforms.linux;
    };
  };


  namebench = buildPythonPackage (rec {
    name = "namebench-1.0.5";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "http://namebench.googlecode.com/files/${name}.tgz";
      sha256 = "6cbde35ce94d1f31e7d48f5d8eec13238b4dbc505675a33f1e183e600c1482c3";
    };

    # No support of GUI yet.

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://namebench.googlecode.com/;
      description = "Find fastest DNS servers available";
      license = [
        "Apache-2.0"
        # third-party program licenses (embedded in the sources)
        "LGPL" # Crystal_Clear
        "free" # dns
        "Apache-2.0" # graphy
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


  nbxmpp = buildPythonPackage rec {
    name = "nbxmpp-0.5.1";

    src = pkgs.fetchurl {
      name = "${name}.tar.gz";
      url = "https://python-nbxmpp.gajim.org/downloads/6";
      sha256 = "0agr0ikfdmna5rjvm7lm0mx52cdwqp5b2xbx3inagp70whmdv219";
    };

    meta = {
      homepage = "https://python-nbxmpp.gajim.org/";
      description = "Non-blocking Jabber/XMPP module";
      license = stdenv.lib.licenses.gpl3;
    };
  };


  netaddr = buildPythonPackage rec {
    name = "netaddr-0.7.5";

    src = pkgs.fetchurl {
      url = "https://github.com/downloads/drkjam/netaddr/${name}.tar.gz";
      sha256 = "0ssxic389rdc79zkz8dxcjpqdi5qs80h12khkag410cl9cwk11f2";
    };

    # error: invalid command 'test'
    doCheck = false;

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

  netlib = buildPythonPackage rec {
    baseName = "netlib";
    name = "${baseName}-${meta.version}";
    disabled = (!isPy27);

    src = pkgs.fetchurl {
      url = "https://github.com/cortesi/netlib/archive/v${meta.version}.tar.gz";
      name = "${name}.tar.gz";
      sha256 = "1x2n126b7fal64fb5fzkp4by7ym0iswn3w9mh6pm4c1vjdpnk592";
    };

    buildInputs = with self; [
      pyopenssl pyasn1
    ];

    doCheck = false;

    meta = {
      version = "0.10";
      description = ''Man-in-the-middle proxy'';
      homepage = "https://github.com/cortesi/netlib";
      license = licenses.mit;
    };
  };

  nevow = buildPythonPackage (rec {
    name = "nevow-${version}";
    version = "0.10.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/N/Nevow/Nevow-${version}.tar.gz";
      sha256 = "90631f68f626c8934984908d3df15e7c198939d36be7ead1305479dfc67ff6d0";
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

  nose = buildPythonPackage rec {
    version = "1.3.4";
    name = "nose-${version}";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/n/nose/${name}.tar.gz";
      sha256 = "00qymfgwg4iam4xi0w9bnv7lcb3fypq1hzfafzgs1rfmwaj67g3n";
    };

    buildInputs = with self; [ coverage ];

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
    name = "nose2-0.4.5";
    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/n/nose2/${name}.tar.gz";
      md5 = "d7e51c848227488e3cc0424faf5511cd";
    };
    meta = {
      description = "nose2 is the next generation of nicer testing for Python";
    };
    propagatedBuildInputs = with self; [ six ];
    # AttributeError: 'module' object has no attribute 'collector'
    doCheck = false;
  });

  nosejs = buildPythonPackage {
    name = "nosejs-0.9.4";
    src = pkgs.fetchurl {
      url = https://pypi.python.org/packages/source/N/NoseJS/NoseJS-0.9.4.tar.gz;
      sha256 = "0qrhkd3sga56qf6k0sqyhwfcladwi05gl6aqmr0xriiq1sgva5dy";
    };
    buildInputs = with self; [ nose ];
  };

  nose-cprof = buildPythonPackage rec {
    name = "nose-cprof-0.1-0";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/n/nose-cprof/${name}.tar.gz";
      md5 = "5db27c3b8f01915335ae6fc5fd3afd44";
    };

    meta = {
      description = "A python nose plugin to profile using cProfile rather than the default Hotshot profiler";
    };

    buildInputs = with self; [ nose ];
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

    sourceRoot = "${pkgs.notmuch.name}/bindings/python";

    buildInputs = with self; [ python pkgs.notmuch ];

    meta = {
      description = "A Python wrapper around notmuch";
      homepage = http://notmuchmail.org/;
      maintainers = [ stdenv.lib.maintainers.garbas ];
    };
  };

  ntplib = buildPythonPackage rec {
    name = "ntplib-0.3.2";
    src = pkgs.fetchurl {
      url = https://pypi.python.org/packages/source/n/ntplib/ntplib-0.3.2.tar.gz;
      md5 = "0f386dc00c0056ac4d77af0b4c21bb8e";
    };

    meta = {
      description = "Python NTP library";
    };
  };

  numexpr = buildPythonPackage rec {
    version = "2.4";
    name = "numexpr-${version}";

    src = pkgs.fetchgit {
      url = https://github.com/pydata/numexpr.git;
      rev = "606cc9a110711e947d35ac2770749c00dab184c8";
      sha256 = "1gxgkg7ncgjhnifn444iha5nrjhyr8sr6w5yp204186a1ysz858g";
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

  numpy = buildPythonPackage ( rec {
    name = "numpy-1.8.2";

    src = pkgs.fetchurl {
      url = "mirror://sourceforge/numpy/${name}.tar.gz";
      sha256 = "1gcxlk3mf43pzpxvbw8kcfg173g4105j9szsfc1kxwablail6myf";
    };

    disabled = isPyPy;  # WIP

    preConfigure = ''
      sed -i 's/-faltivec//' numpy/distutils/system_info.py
      sed -i '0,/from numpy.distutils.core/s//import setuptools;from numpy.distutils.core/' setup.py
    '';

    preBuild = ''
      export BLAS=${pkgs.blas} LAPACK=${pkgs.liblapack}
    '';

    setupPyBuildFlags = ["--fcompiler='gnu95'"];

    # error: invalid command 'test'
    doCheck = false;

    buildInputs = with self; [ pkgs.gfortran ];
    propagatedBuildInputs = with self; [ pkgs.liblapack pkgs.blas ];

    meta = {
      description = "Scientific tools for Python";
      homepage = "http://numpy.scipy.org/";
    };
  });


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

    meta = with stdenv.lib; {
      description = "Generate network-diagram image from spec-text file (similar to Graphviz)";
      homepage = http://blockdiag.com/;
      license = licenses.asl20;
      platforms = platforms.linux;
      maintainers = [ maintainers.bjornfor ];
    };
  };

  livestreamer = buildPythonPackage rec {
    version = "1.11.1";
    name = "livestreamer-${version}";
    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "https://github.com/chrippa/livestreamer/archive/v${version}.tar.gz";
      sha256 = "1hic3z5any64gn2b0gs1b7m34bzgzv71inr8wgjq59pwf8mbrqk9";
    };

    buildInputs = with self; [ pkgs.makeWrapper ];
    propagatedBuildInputs = with self; [ requests2 pkgs.rtmpdump pycrypto singledispatch futures ];
    postInstall = ''
      wrapProgram $out/bin/livestreamer --prefix PATH : ${pkgs.rtmpdump}/bin
    '';

    meta = {
      homepage = http://livestreamer.tanuki.se;
      description = ''
        Livestreamer is CLI program that extracts streams from various
        services and pipes them into a video player of choice.
      '';
      license = stdenv.lib.licenses.bsd2;
    };
  };

  oauth = buildPythonPackage (rec {
    name = "oauth-1.0.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/o/oauth/oauth-1.0.1.tar.gz";
      sha256 = "0pdgi35hczsslil4890xqawnbpdazkgf2v1443847h5hy2gq2sg7";
    };

    meta = {
      homepage = "http://code.google.com/p/oauth";
      description = "Library for OAuth version 1.0a.";
      license = licenses.mit;
      platforms = stdenv.lib.platforms.all;
    };
  });

  oauth2 = buildPythonPackage (rec {
    name = "oauth2-1.5.211";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/o/oauth2/oauth2-1.5.211.tar.gz";
      sha256 = "82a38f674da1fa496c0fc4df714cbb058540bed72a30c50a2e344b0d984c4d21";
    };

    propagatedBuildInputs = with self; [ httplib2 ];

    buildInputs = with self; [ mock coverage ];

    # ServerNotFoundError: Unable to find the server at oauth-sandbox.sevengoslings.net
    doCheck = false;

    meta = {
      homepage = "https://github.com/simplegeo/python-oauth2";
      description = "library for OAuth version 1.0";
      license = licenses.mit;
      maintainers = [ stdenv.lib.maintainers.garbas ];
      platforms = stdenv.lib.platforms.linux;
    };
  });


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
    version = "0.2.12";

    src = pkgs.fetchgit {
      url = meta.repositories.git;
      rev = "refs/tags/${name}";
      sha256 = "82d694aa7f3de7327fc4dc517fb262ab076f536ed6d4377573c76df8cf019dcf";
    };

    propagatedBuildInputs = with self;
      [ pyptlib argparse twisted pycrypto pyyaml ];

    meta = {
      description = "a pluggable transport proxy";
      homepage = https://www.torproject.org/projects/obfsproxy;
      repositories.git = https://git.torproject.org/pluggable-transports/obfsproxy.git;
      maintainers = with stdenv.lib.maintainers; [ phreedom thoughtpolice ];
    };
  });

  offtrac = buildPythonPackage rec {
    name = "offtrac-0.1.0";
    meta.maintainers = [ stdenv.lib.maintainers.mornfall ];

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/o/offtrac/${name}.tar.gz";
      sha256 = "06vd010pa1z7lyfj1na30iqzffr4kzj2k2sba09spik7drlvvl56";
    };
    doCheck = false;
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

  ordereddict = if isPy26 then (buildPythonPackage {
    name = "ordereddict-1.1";
    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/o/ordereddict/ordereddict-1.1.tar.gz";
      md5 = "a0ed854ee442051b249bfad0f638bbec";
    };
    doCheck = false;
  }) else null;

  ply = buildPythonPackage (rec {
    name = "ply-3.4";

    src = pkgs.fetchurl {
      url = "http://www.dabeaz.com/ply/${name}.tar.gz";
      sha256 = "0sslnbpws847r1j1f41fjpn76w0asywfqgxwzyjrvmmxnw8myhxg";
    };

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

      license = "revised-BSD";

      maintainers = [ ];
    };
  });

  osc = buildPythonPackage (rec {
    name = "osc-0.133+git";
    disabled = isPy3k;

    src = pkgs.fetchgit {
      url = git://gitorious.org/opensuse/osc.git;
      rev = "6cd541967ee2fca0b89e81470f18b97a3ffc23ce";
      sha256 = "a39ce0e321e40e9758bf7b9128d316c71b35b80eabc84f13df492083bb6f1cc6";
    };

    buildPhase = "${python}/bin/${python.executable} setup.py build";
    doCheck = false;
    postInstall = "ln -s $out/bin/osc-wrapper.py $out/bin/osc";

    propagatedBuildInputs = with self; [ self.m2crypto ];

  });

  pagerduty = buildPythonPackage rec {
    name = "pagerduty-${version}";
    version = "0.2.1";
    disabled = isPy3k;

    src = pkgs.fetchurl {
        url = "https://pypi.python.org/packages/source/p/pagerduty/pagerduty-${version}.tar.gz";
        md5 = "8109a330d16751a7f4041c0ccedec787";
    };
  };

  pandas = buildPythonPackage rec {
    name = "pandas-0.15.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pandas/${name}.tar.gz";
      sha256 = "1w3wjnn3v37hf3hrd24lfgk6vpykarv9mihhpcfq6y7rg586bgjk";
    };

    buildInputs = with self; [ nose ];
    propagatedBuildInputs = with self; [ dateutil numpy pytz modules.sqlite3 ];

    # Tests require networking to pass
    doCheck = false;

    meta = {
      homepage = "http://pandas.pydata.org/";
      description = "Python Data Analysis Library";
      license = stdenv.lib.licenses.bsd3;
      maintainers = [ stdenv.lib.maintainers.raskin ];
      platforms = stdenv.lib.platforms.linux;
    };
  };

  parsedatetime = buildPythonPackage rec {
    name = "parsedatetime-${version}";
    version = "1.4";

    src = pkgs.fetchurl {
        url = "https://pypi.python.org/packages/source/p/parsedatetime/${name}.tar.gz";
        md5 = "3aca729761be5259a508ed184df73c68";
    };
  };

  paramiko = buildPythonPackage rec {
    name = "paramiko-1.15.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/paramiko/${name}.tar.gz";
      md5 = "48c274c3f9b1282932567b21f6acf3b5";
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
      license = stdenv.lib.licenses.lgpl21Plus;
      maintainers = [ stdenv.lib.maintainers.aszlig ];

      longDescription = ''
        This is a library for making SSH2 connections (client or server).
        Emphasis is on using SSH2 as an alternative to SSL for making secure
        connections between python scripts. All major ciphers and hash methods
        are supported. SFTP client and server mode are both supported too.
      '';
    };
  };


  paste = buildPythonPackage rec {
    name = "paste-1.7.5.1";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = http://pypi.python.org/packages/source/P/Paste/Paste-1.7.5.1.tar.gz;
      md5 = "7ea5fabed7dca48eb46dc613c4b6c4ed";
    };

    buildInputs = with self; [ nose ];

    doCheck = false; # some files required by the test seem to be missing

    meta = {
      description = "Tools for using a Web Server Gateway Interface stack";
      homepage = http://pythonpaste.org/;
    };
  };


  paste_deploy = buildPythonPackage rec {
    version = "1.5.2";
    name = "paste-deploy-${version}";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/P/PasteDeploy/PasteDeploy-${version}.tar.gz";
      md5 = "352b7205c78c8de4987578d19431af3b";
    };

    buildInputs = with self; [ nose ];

    meta = {
      description = "Load, configure, and compose WSGI applications and servers";
      homepage = http://pythonpaste.org/deploy/;
      platforms = stdenv.lib.platforms.all;
    };
  };

  pathpy = buildPythonPackage rec {
    name = "path.py-5.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/path.py/${name}.zip";
      sha256 = "0n1kpbbm1dg5f484yzxr7gb3ak6vjp92j70nw3bgjzsj9fh26afq";
    };

    meta = with stdenv.lib; {
      description = "A module wrapper for os.path";
      homepage = http://github.com/jaraco/path.py;
      license = licenses.mit;
      platforms = platforms.linux;
    };
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
    name = "pbr-0.9.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pbr/${name}.tar.gz";
      sha256 = "e5a57c434b1faa509a00bf458d2c7af965199d9cced3d05a547bff9880f7e8cb";
    };

    # pip depend on $HOME setting
    preConfigure = "export HOME=$TMPDIR";

    doCheck = false;

    buildInputs = with self; [ pip ];

    meta = {
      description = "Python Build Reasonableness";
      homepage = "http://docs.openstack.org/developer/pbr/";
      license = licenses.asl20;
    };
  };

  pelican = buildPythonPackage rec {
    name = "pelican-${version}";
    version = "3.5.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pelican/${name}.tar.gz";
      sha256 = "0dl8i26sa20iijlg3z9gxn3p6f1d9v44b9742929xfaqwj4amvdp";
    };

    preConfigure = ''
      export LOCALE_ARCHIVE=${pkgs.glibcLocales}/lib/locale/locale-archive
      export LC_ALL="en_US.UTF-8"
    '';

    # Test data not provided
    #buildInputs = [nose mock];
    doCheck = false;

    propagatedBuildInputs = with self; [
      jinja2 pygments docutils pytz unidecode six dateutil feedgenerator
      blinker pillow beautifulsoup4
    ];

    meta = {
      homepage = http://getpelican.com/;
      description = "A tool to generate a static blog from reStructuredText or Markdown input files";
      license = licenses.agpl3;
      maintainers = with stdenv.lib.maintainers; [ offline prikhi ];
    };
  };

  pep8 = buildPythonPackage rec {
    name = "pep8-${version}";
    version = "1.5.7";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pep8/${name}.tar.gz";
      md5 = "f6adbdd69365ecca20513c709f9b7c93";
    };

    meta = {
      homepage = "http://pep8.readthedocs.org/";
      description = "Python style guide checker";
      license = licenses.mit;
      maintainers = [ stdenv.lib.maintainers.garbas ];
    };
  };

  percol = buildPythonPackage rec {
    name = "percol-${version}";
    version = "0.0.7";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/percol/${name}.tar.gz";
      sha256 = "01444z62clvx9rms9aiqx47s0fbvsfgbp6hlfff344xl7kc4l2gj";
    };

    propagatedBuildInputs = with self; [ modules.curses ];

    meta = {
      homepage = https://github.com/mooz/percol;
      description = "Adds flavor of interactive filtering to the traditional pipe concept of shell";
      license = licenses.mit;
      maintainers = with stdenv.lib.maintainers; [ koral ];
    };
  };


  pexpect = buildPythonPackage {
    name = "pexpect-2.3";

    src = pkgs.fetchurl {
      url = "mirror://sourceforge/pexpect/pexpect-2.3.tar.gz";
      sha256 = "0x8bfjjqygriry1iyygm5048ykl5qpbpzqfp6i8dhkslm3ryf5fk";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://www.noah.org/wiki/Pexpect;
      description = "Automate interactive console applications such as ssh, ftp, etc";
      license = stdenv.lib.licenses.mit;

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
    name = "pg8000-1.9.14";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pg8000/${name}.tar.gz";
      sha256 = "1vandvfaf1m3a1fbc7nbm6syfqr9bazhzsnmai0jpjkbmb349izs";
    };

    propagatedBuildInputs = with self; [ pytz ];

    meta = {
      maintainers = [
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.iElectric
      ];
      platforms = stdenv.lib.platforms.linux;
    };
  };

  pip = buildPythonPackage rec {
    version = "1.5.6";
    name = "pip-${version}";
    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pip/pip-${version}.tar.gz";
      md5 = "01026f87978932060cc86c1dc527903e";
    };
    buildInputs = with self; [ mock scripttest virtualenv pytest ];
  };


  pika = buildPythonPackage {
    name = "pika-0.9.12";
    disabled = isPy3k;
    src = pkgs.fetchurl {
      url = https://pypi.python.org/packages/source/p/pika/pika-0.9.12.tar.gz;
      md5 = "7174fc7cc5570314fa3cfaa729106482";
    };
    buildInputs = with self; [ nose mock pyyaml ];

    propagatedBuildInputs = with self; [ unittest2 ];
  };

  pil = buildPythonPackage rec {
    name = "PIL-${version}";
    version = "1.1.7";

    src = pkgs.fetchurl {
      url = "http://effbot.org/downloads/Imaging-${version}.tar.gz";
      sha256 = "04aj80jhfbmxqzvmq40zfi4z3cw6vi01m3wkk6diz3lc971cfnw9";
    };

    buildInputs = with self; [ python pkgs.libjpeg pkgs.zlib pkgs.freetype ];

    disabled = isPy3k;
    doCheck = true;

    postInstall = "ln -s $out/lib/${python.libPrefix}/site-packages $out/lib/${python.libPrefix}/site-packages/PIL";

    preConfigure = ''
      sed -i "setup.py" \
          -e 's|^FREETYPE_ROOT =.*$|FREETYPE_ROOT = libinclude("${pkgs.freetype}")|g ;
              s|^JPEG_ROOT =.*$|JPEG_ROOT = libinclude("${pkgs.libjpeg}")|g ;
              s|^ZLIB_ROOT =.*$|ZLIB_ROOT = libinclude("${pkgs.zlib}")|g ;'
    '';

    checkPhase = "${python}/bin/${python.executable} selftest.py";
    buildPhase = "${python}/bin/${python.executable} setup.py build_ext -i";

    meta = {
      homepage = http://www.pythonware.com/products/pil/;
      description = "The Python Imaging Library (PIL)";
      longDescription = ''
        The Python Imaging Library (PIL) adds image processing
        capabilities to your Python interpreter.  This library
        supports many file formats, and provides powerful image
        processing and graphics capabilities.
      '';
      license = "http://www.pythonware.com/products/pil/license.htm";
    };
  };


  pillow = buildPythonPackage rec {
    name = "Pillow-2.3.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/P/Pillow/${name}.zip";
      md5 = "56b6614499aacb7d6b5983c4914daea7";
    };

    buildInputs = with self; [
      pkgs.freetype pkgs.libjpeg pkgs.zlib pkgs.libtiff pkgs.libwebp pkgs.tcl ]
      ++ optionals (isPy26 || isPyPy) [ pkgs.lcms2 ]
      ++ optionals (isPyPy) [ pkgs.tk pkgs.xlibs.libX11 ];

    # NOTE: we use LCMS_ROOT as WEBP root since there is not other setting for webp.
    preConfigure = ''
      sed -i "setup.py" \
          -e 's|^FREETYPE_ROOT =.*$|FREETYPE_ROOT = _lib_include("${pkgs.freetype}")|g ;
              s|^JPEG_ROOT =.*$|JPEG_ROOT = _lib_include("${pkgs.libjpeg}")|g ;
              s|^ZLIB_ROOT =.*$|ZLIB_ROOT = _lib_include("${pkgs.zlib}")|g ;
              s|^LCMS_ROOT =.*$|LCMS_ROOT = _lib_include("${pkgs.libwebp}")|g ;
              s|^TIFF_ROOT =.*$|TIFF_ROOT = _lib_include("${pkgs.libtiff}")|g ;
              s|^TCL_ROOT=.*$|TCL_ROOT = _lib_include("${pkgs.tcl}")|g ;'
    '';

    meta = {
      homepage = http://python-imaging.github.com/Pillow;

      description = "Fork of The Python Imaging Library (PIL)";

      longDescription = ''
        The Python Imaging Library (PIL) adds image processing
        capabilities to your Python interpreter.  This library
        supports many file formats, and provides powerful image
        processing and graphics capabilities.
      '';

      license = "http://www.pythonware.com/products/pil/license.htm";

      maintainers = with stdenv.lib.maintainers; [ goibhniu prikhi ];
    };
  };

  plumbum = buildPythonPackage rec {
    name = "plumbum-1.4.2";

    buildInputs = with self; [ self.six ];

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/plumbum/${name}.tar.gz";
      md5 = "38b526af9012a5282ae91dfe372cefd3";
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
    rev  = "db80fc95ed01d2c559c4bdc7da8514ed3cc7fcd9";
    name = "powerline-beta_${rev}";

    src = pkgs.fetchurl {
      url    = "https://github.com/Lokaltog/powerline/tarball/${rev}";
      name   = "${name}.tar.bz";
      sha256 = "1csd4vasy0avwfxrpdr61plj6k1nzf36f6qvd9kl15s3lnspsfaz";
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

    meta = with stdenv.lib; {
      homepage    = https://github.com/Lokaltog/powerline;
      description = "The ultimate statusline/prompt utility";
      license     = licenses.mit;
      maintainers = with maintainers; [ lovek323 ];
      platforms   = platforms.all;
    };
  };


  prettytable = buildPythonPackage rec {
    name = "prettytable-0.7.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/P/PrettyTable/${name}.tar.bz2";
      sha1 = "ad346a18d92c1d95f2295397c7a8a4f489e48851";
    };

    preCheck = ''
      export LANG="en_US.UTF-8"
      export LOCALE_ARCHIVE=${localePath}
    '';

    meta = {
      description = "Simple Python library for easily displaying tabular data in a visually appealing ASCII table format";
      homepage = http://code.google.com/p/prettytable/;
    };
  };


  protobuf = buildPythonPackage rec {
    inherit (pkgs.protobuf) name src;

    propagatedBuildInputs = with self; [ pkgs.protobuf google_apputils  ];
    sourceRoot = "${name}/python";


    meta = {
      description = "Protocol Buffers are Google's data interchange format";
      homepage = http://code.google.com/p/protobuf/;
    };
  };


  psutil = buildPythonPackage rec {
    name = "psutil-${version}";
    version = "2.1.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/psutil/${name}.tar.gz";
      sha256 = "14smqj57yjrm6hjz5n2annkgv0kmxckdhqvfx784f4d4lr52m0dz";
    };

    # failed tests: https://code.google.com/p/psutil/issues/detail?id=434
    doCheck = false;

    meta = {
      description = "Process and system utilization information interface for python";
      homepage = http://code.google.com/p/psutil/;
    };
  };


  psycopg2 = buildPythonPackage rec {
    name = "psycopg2-2.5.3";
    disabled = isPyPy;

    # error: invalid command 'test'
    doCheck = false;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/psycopg2/${name}.tar.gz";
      sha256 = "02h33barxigsczpympnwa0yvw9hgdv8d63bxm5x251ri26xz6b9s";
    };

    propagatedBuildInputs = with self; [ pkgs.postgresql ];

    meta = {
      description = "PostgreSQL database adapter for the Python programming language";
      license = with stdenv.lib.licenses; [ gpl2 zpt20 ];
    };
  };


  publicsuffix = buildPythonPackage rec {
    name = "publicsuffix-${version}";
    version = "1.0.2";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/publicsuffix/${name}.tar.gz";
      md5 = "f86babf56f6e58b564d3853adebcf37a";
    };

    meta = {
      description = "Allows to get the public suffix of a domain name";
      homepage = "http://pypi.python.org/pypi/publicsuffix/";
      license = licenses.mit;
    };
  };


  py = buildPythonPackage rec {
    name = "py-1.4.24";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/py/${name}.tar.gz";
      md5 = "8f32ee0cd1e01472a255fe1d28d81217";
    };
  };


  pyacoustid = buildPythonPackage rec {
    name = "pyacoustid-1.1.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pyacoustid/${name}.tar.gz";
      md5 = "b27c714d530300b917eb869726334226";
    };

    propagatedBuildInputs = with self; [ requests audioread ];

    postPatch = ''
      sed -i \
          -e '/^FPCALC_COMMAND *=/s|=.*|= "${pkgs.chromaprint}/bin/fpcalc"|' \
          acoustid.py
    '';

    meta = {
      description = "Bindings for Chromaprint acoustic fingerprinting";
      homepage = "https://github.com/sampsyo/pyacoustid";
      license = stdenv.lib.licenses.mit;
    };
  };


  pyalgotrade = buildPythonPackage {
    name = "pyalogotrade-0.16";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/P/PyAlgoTrade/PyAlgoTrade-0.16.tar.gz";
      md5 = "01d70583ab15eb3bad21027bdeb30ae5";
    };

    propagatedBuildInputs = with self; [ numpy scipy pytz ];

    meta = {
      description = "Python Algorithmic Trading";
      homepage = http://gbeced.github.io/pyalgotrade/;
      license = stdenv.lib.licenses.asl20;
    };
  };


  pyasn1 = buildPythonPackage ({
    name = "pyasn1-0.1.7";

    src = pkgs.fetchurl {
      url = "mirror://sourceforge/pyasn1/0.1.7/pyasn1-0.1.7.tar.gz";
      sha256 = "1aqy21fb564gmnkw2fbkn55c40diyx3z0ixh4savvxikqm9ivy74";
    };

    meta = {
      description = "ASN.1 tools for Python";
      homepage = http://pyasn1.sourceforge.net/;
      license = "mBSD";
      platforms = stdenv.lib.platforms.unix;  # arbitrary choice
    };
  });


  pyaudio = pkgs.stdenv.mkDerivation rec {
    name = "python-pyaudio-${version}";
    version = "0.2.4";

    src = pkgs.fetchurl {
      url = "http://people.csail.mit.edu/hubert/pyaudio/packages/pyaudio-${version}.tar.gz";
      md5 = "623809778f3d70254a25492bae63b575";
    };

    buildInputs = with self; [ python pkgs.portaudio ];

    buildPhase = if stdenv.isDarwin then ''
      PORTAUDIO_PATH="${pkgs.portaudio}" ${python}/bin/${python.executable} setup.py build --static-link
    '' else ''
      ${python}/bin/${python.executable} setup.py build
    '';

    installPhase = "${python}/bin/${python.executable} setup.py install --prefix=$out";

    meta = {
      description = "Python bindings for PortAudio";
      homepage = "http://people.csail.mit.edu/hubert/pyaudio/";
      license = stdenv.lib.licenses.mit;
    };
  };

  pycosat = pythonPackages.buildPythonPackage rec {
    name = "pycosat-0.6.0";

    propagatedBuildInputs = with pythonPackages; [  ];

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pycosat/${name}.tar.gz";
      sha256 = "02sdn2998jlrm35smn1530hix3kzwyc1jv49cjdcnvfvrqqi3rww";
    };

    meta = with stdenv.lib; {
      description = ''PicoSAT is a popular SAT solver written by Armin
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
    name = "pygit2-0.21.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pygit2/${name}.tar.gz";
      sha256 = "0lya4v91d4y5fwrb55n8m8avgmz0l81jml2spvx6r7j1czcx3zic";
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
      license = with stdenv.lib.licenses; gpl2;
      platforms = with stdenv.lib.platforms; all;
    };
  };


  Babel = buildPythonPackage (rec {
    name = "Babel-1.3";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/B/Babel/${name}.tar.gz";
      sha256 = "0bnin777lc53nxd1hp3apq410jj5wx92n08h7h4izpl4f4sx00lz";
    };

    propagatedBuildInputs = with self; [ pytz ];

    meta = {
      homepage = http://babel.edgewall.org;
      description = "A collection of tools for internationalizing Python applications";
      license = "BSD";
      maintainers = [ stdenv.lib.maintainers.garbas ];
      platforms = stdenv.lib.platforms.linux;
    };
  });

  pybfd = buildPythonPackage rec {
    name = "pybfd-0.1.1";

    disabled = isPyPy || isPy3k;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pybfd/${name}.tar.gz";
      md5 = "79dd6e12c90ad0515d0ad7fb1bd2f571";
    };

    preConfigure = ''
      substituteInPlace setup.py \
        --replace '"/usr/include"' '"${pkgs.gdb}/include"' \
        --replace '"/usr/lib"' '"${pkgs.binutils}/lib"'
    '';

    # --old-and-unmanageable not supported by this setup.py
    installPhase = ''
      mkdir -p "$out/lib/${python.libPrefix}/site-packages"

      export PYTHONPATH="$out/lib/${python.libPrefix}/site-packages:$PYTHONPATH"

      ${python}/bin/${python.executable} setup.py install \
        --install-lib=$out/lib/${python.libPrefix}/site-packages \
        --prefix="$out"
    '';

    meta = with stdenv.lib; {
      homepage = https://github.com/Groundworkstech/pybfd;
      description = "A Python interface to the GNU Binary File Descriptor (BFD) library";
      license = licenses.gpl2;
      platforms = platforms.linux;
    };
  };

  pyblock = stdenv.mkDerivation rec {
    name = "pyblock-${version}";
    version = "0.53";

    src = pkgs.fetchurl rec {
      url = "http://pkgs.fedoraproject.org/repo/pkgs/python-pyblock/"
          + "${name}.tar.bz2/${md5}/${name}.tar.bz2";
      md5 = "f6d33a8362dee358517d0a9e2ebdd044";
    };

    postPatch = ''
      sed -i -e 's|/usr/include/python|${python}/include/python|' \
             -e 's/-Werror *//' -e 's|/usr/|'"$out"'/|' Makefile
    '';

    buildInputs = with self; [ python pkgs.lvm2 pkgs.dmraid ];

    makeFlags = [
      "USESELINUX=0"
      "SITELIB=$(out)/lib/${python.libPrefix}/site-packages"
    ];

    meta = {
      description = "Interface for working with block devices";
      license = stdenv.lib.licenses.gpl2Plus;
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

    meta = with stdenv.lib; {
      maintainers = with maintainers; [ cstrahan ];
      license = stdenv.lib.licenses.bsd2;
      platforms = stdenv.lib.platforms.all;
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

    meta = with stdenv.lib; {
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

      license = stdenv.lib.licenses.gpl2Plus;

      maintainers = [ ];
      platforms = stdenv.lib.platforms.linux;
    };
  });


  pycurl = buildPythonPackage (rec {
    name = "pycurl-7.19.5";
    disabled = isPyPy; # https://github.com/pycurl/pycurl/issues/208

    src = pkgs.fetchurl {
      url = "http://pycurl.sourceforge.net/download/${name}.tar.gz";
      sha256 = "0hqsap82zklhi5fxhc69kxrwzb0g9566f7sdpz7f9gyxkmyam839";
    };

    propagatedBuildInputs = with self; [ pkgs.curl pkgs.openssl ];

    # error: invalid command 'test'
    doCheck = false;

    preConfigure = ''
      substituteInPlace setup.py --replace '--static-libs' '--libs'
      export PYCURL_SSL_LIBRARY=openssl
    '';

    meta = {
      homepage = http://pycurl.sourceforge.net/;
      description = "Python wrapper for libcurl";
      platforms = stdenv.lib.platforms.linux;
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
      platforms = stdenv.lib.platforms.linux;
    };
  });


  pydot = buildPythonPackage rec {
    name = "pydot-1.0.2";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pydot/${name}.tar.gz";
      md5 = "cd739651ae5e1063a89f7efd5a9ec72b";
    };
    propagatedBuildInputs = with self; [pyparsing pkgs.graphviz];
    meta = {
      homepage = http://code.google.com/p/pydot/;
      description = "Allows to easily create both directed and non directed graphs from Python";
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
      maintainers = [ maintainers.thoughtpolice ];
    };
  };

  pyflakes = buildPythonPackage rec {
    name = "pyflakes-0.8.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyflakes/${name}.tar.gz";
      md5 = "905fe91ad14b912807e8fdc2ac2e2c23";
    };

    buildInputs = with self; [ unittest2 ];

    doCheck = !isPyPy;

    meta = {
      homepage = https://launchpad.net/pyflakes;
      description = "A simple program which checks Python source files for errors";
      license = licenses.mit;
      maintainers = [ stdenv.lib.maintainers.garbas ];
    };
  };

  pyglet = buildPythonPackage rec {
    name = "pyglet-1.1.4";

    src = pkgs.fetchurl {
      url = "http://pyglet.googlecode.com/files/${name}.tar.gz";
      sha256 = "048n20d606i3njnzhajadnznnfm8pwchs43hxs50da9p79g2m6qx";
    };

    patchPhase = let
      libs = [ pkgs.mesa pkgs.xlibs.libX11 pkgs.freetype pkgs.fontconfig ];
      paths = concatStringsSep "," (map (l: "\"${l}/lib\"") libs);
    in "sed -i -e 's|directories\.extend.*lib[^]]*|&,${paths}|' pyglet/lib.py";

    doCheck = false;

    meta = {
      homepage = "http://www.pyglet.org/";
      description = "A cross-platform windowing and multimedia library";
      license = stdenv.lib.licenses.bsd3;
      platforms = stdenv.lib.platforms.mesaPlatforms;
    };
  };

  pygments = buildPythonPackage rec {
    name = "Pygments-1.6";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/P/Pygments/${name}.tar.gz";
      md5 = "a18feedf6ffd0b0cc8c8b0fbdb2027b1";
    };

    meta = {
      homepage = http://pygments.org/;
      description = "A generic syntax highlighter";
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
      description = "A Python wrapper for the GPGME library.";
      license = licenses.lgpl21;
      maintainers = [ stdenv.lib.maintainers.garbas ];
    };
  };


  pyinotify = pkgs.stdenv.mkDerivation rec {
    name = "python-pyinotify-${version}";
    version = "0.9.3";

    src = pkgs.fetchgit {
      url = "git://github.com/seb-m/pyinotify.git";
      rev = "refs/tags/${version}";
      sha256 = "d38ce95e4af00391e58246a8d7fe42bdb51d63054b09809600b2faef2a803472";
    };

    buildInputs = with self; [ python ];

    installPhase = ''
      ${python}/bin/${python.executable} setup.py install --prefix=$out
    '';

    meta = {
      homepage = https://github.com/seb-m/pyinotify/wiki;
      description = "Monitor filesystems events on Linux platforms with inotify";
      license = licenses.mit;
    };
  };

  pyjwt = buildPythonPackage rec {
    version = "0.3.2";
    name = "pyjwt-${version}";

    src = pkgs.fetchurl {
      url = "http://github.com/progrium/pyjwt/archive/${version}.tar.gz";
      sha256 = "118rzhpyvx1h4hslms4fdizyv6mnyd4g34fv089lvs116pj08k9c";
    };

    propagatedBuildInputs = with self; [ pycrypto ecdsa ];

    meta = with stdenv.lib; {
      description = "JSON Web Token implementation in Python";
      longDescription = "A Python implementation of JSON Web Token draft 01.";
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

    src = pkgs.fetchurl rec {
      url = "http://pkgs.fedoraproject.org/repo/pkgs/pykickstart/"
          + "${name}.tar.gz/${md5}/${name}.tar.gz";
      md5 = "d249f60aa89b1b4facd63f776925116d";
    };

    postPatch = ''
      sed -i -e "s/for tst in tstList/for tst in sorted(tstList, \
                 key=lambda m: m.__name__)/" tests/baseclass.py
    '';

    propagatedBuildInputs = with self; [ urlgrabber ];

    checkPhase = ''
      export PYTHONPATH="$PYTHONPATH:."
      ${python}/bin/${python.executable} tests/baseclass.py -vv
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

    meta = with stdenv.lib; {
      description = "Python ODBC module to connect to almost any database";
      homepage = https://code.google.com/p/pyodbc/;
      license = licenses.mit;
      platforms = platforms.linux;
      maintainers = [ maintainers.bjornfor ];
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
      description = "The pyparsing module is an alternative approach to creating and executing simple grammars, vs. the traditional lex/yacc approach, or the use of regular expressions.";
    };
  };


  pyparted = buildPythonPackage rec {
    name = "pyparted-${version}";
    version = "3.10";
    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "https://fedorahosted.org/releases/p/y/pyparted/${name}.tar.gz";
      sha256 = "17wq4invmv1nfazaksf59ymqyvgv3i8h4q03ry2az0s9lldyg3dv";
    };

    patches = singleton (pkgs.fetchurl {
      url = "https://www.redhat.com/archives/pyparted-devel/"
          + "2014-April/msg00000.html";
      postFetch = ''
        sed -i -ne '/<!--X-Body-of-Message-->/,/<!--X-Body-of-Message-End-->/ {
          s/^<[^>]*>//; /^$/!p
        }' "$downloadedFile"
      '';
      sha256 = "1lakhz3nvx0qacn90bj1nq13zqxphiw4d9dsc44gwa8nj24j2zws";
    });

    postPatch = ''
      sed -i -e 's|/sbin/mke2fs|${pkgs.e2fsprogs}&|' tests/baseclass.py
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
      license = stdenv.lib.licenses.gpl2Plus;
      platforms = stdenv.lib.platforms.linux;
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
      license = stdenv.lib.licenses.bsd2;
    };
  });

  pyqtgraph = buildPythonPackage rec {
    name = "pyqtgraph-${version}";
    version = "0.9.8";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pyqtgraph/${name}.tar.gz";
      sha256 = "1fnhj26d9qrqqmjx092m1qspclh3mia3vag7rji5wciw0plpszi5";
    };

    propagatedBuildInputs = with self; [ scipy pyqt4 pyopengl ];

    meta = with stdenv.lib; {
      description = "Scientific Graphics and GUI Library for Python";
      homepage = http://www.pyqtgraph.org/;
      license = licenses.mit;
      platforms = platforms.unix;
      maintainers = [ maintainers.koral ];
    };
  };

  pyro3 = buildPythonPackage (rec {
    name = "Pyro-3.16";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/P/Pyro/${name}.tar.gz";
      md5 = "59d4d3f4a8786776c9d7f9051b8f1a69";
    };

    meta = with stdenv.lib; {
      description = "Distributed object middleware for Python (IPC/RPC)";
      homepage = http://pythonhosted.org/Pyro/;
      license = licenses.mit;
      platforms = platforms.unix;
      maintainers = [ maintainers.bjornfor ];
    };
  });

  pyrss2gen = buildPythonPackage (rec {
    name = "PyRSS2Gen-1.0.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/P/PyRSS2Gen/${name}.tar.gz";
      md5 = "eae2bc6412c5679c287ecc1a59588f75";
    };

    meta = {
      homepage = http://www.dalkescientific.om/Python/PyRSS2Gen.html;
      description = "Library for generating RSS 2.0 feeds";
      license = stdenv.lib.licenses.bsd2;
      maintainers = [ stdenv.lib.maintainers.iElectric ];
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

    meta = with stdenv.lib; {
      homepage = http://pysnmp.sf.net;
      description = "A pure-Python SNMPv1/v2c/v3 library";
      license = licenses.bsd2;
      platforms = platforms.all;
      maintainers = [ maintainers.koral ];
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
      maintainers = [ maintainers.thoughtpolice ];
    };
  };

  python_fedora = buildPythonPackage (rec {
    name = "python-fedora-0.3.33";
    meta.maintainers = [ stdenv.lib.maintainers.mornfall ];

    src = pkgs.fetchurl {
      url = "https://fedorahosted.org/releases/p/y/python-fedora/${name}.tar.gz";
      sha256 = "1g05bh7d5d0gzrlnhpnca7jpqbgs2rgnlzzbvzzxmdbmlkqi3mws";
    };
    propagatedBuildInputs = with self; [ kitchen requests bunch paver ];
    doCheck = false;
  });

  python_simple_hipchat = buildPythonPackage rec {
    name = "python-simple-hipchat-${version}";
    version = "0.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/python-simple-hipchat/python-simple-hipchat-${version}.zip";
      md5 = "3806b3729a021511bac065360832f197";
    };

    buildInputs = [ pkgs.unzip ];
  };

  python_keyczar = buildPythonPackage rec {
    name = "python-keyczar-0.71c";

    src = pkgs.fetchurl {
      url    = "https://pypi.python.org/packages/source/p/python-keyczar/${name}.tar.gz";
      sha256 = "18mhiwqq6vp65ykmi8x3i5l3gvrvrrr8z2kv11z1rpixmyr7sw1p";
    };

    meta = with stdenv.lib; {
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
      md5 = "4034de584b6d9efcbfc590a047c63285";
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
      license = stdenv.lib.licenses.lgpl21Plus;
      platforms = stdenv.lib.platforms.linux;
    };
  };


  pynzb = buildPythonPackage (rec {
    name = "pynzb-0.1.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pynzb/${name}.tar.gz";
      md5 = "63c74a36348ac28aa99732dcb8be8c59";
    };

    meta = {
      homepage = http://github.com/ericflo/pynzb;
      description = "Unified API for parsing NZB files";
      license = stdenv.lib.licenses.bsd3;
      maintainers = [ stdenv.lib.maintainers.iElectric ];
    };
  });

  progressbar = buildPythonPackage (rec {
    name = "progressbar-2.2";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/progressbar/${name}.tar.gz";
      md5 = "8ea4e2c17a8ec9e7d153767c5f2a7b28";
    };

    # invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://code.google.com/p/python-progressbar/;
      description = "Text progressbar library for python";
      license = stdenv.lib.licenses.lgpl3Plus;
      maintainers = [ stdenv.lib.maintainers.iElectric ];
    };
  });

  ldap = buildPythonPackage rec {
    name = "ldap-2.4.15";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/python-ldap/python-${name}.tar.gz";
      sha256 = "0w0nn5yj0nbbkvpbqgfni56v7sjx6jf6s6zvp9zmahyrvqrsrg1h";
    };

    NIX_CFLAGS_COMPILE = "-I${pkgs.cyrus_sasl}/include/sasl";
    propagatedBuildInputs = with self; [pkgs.openldap pkgs.cyrus_sasl pkgs.openssl];
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
      license = stdenv.lib.licenses.lgpl21Plus;
    };
  });


  pymacs = buildPythonPackage rec {
    version = "0.25";
    name = "pymacs-${version}";
    disabled = isPy3k || isPyPy;

    src = pkgs.fetchurl {
      url = "https://github.com/pinard/Pymacs/tarball/v${version}";
      name = "${name}.tar.gz";
      sha256 = "1hmy76c5igm95rqbld7gvk0az24smvc8hplfwx2f5rhn6frj3p2i";
    };

    configurePhase =  "make";

    # Doesn't work with --old-and-unmanagable
    installPhase = ''
      ${python}/bin/${python.executable} setup.py install \
        --install-lib=$out/lib/${python.libPrefix}/site-packages \
        --prefix="$out"
    '';

    doCheck = false;

    meta = with stdenv.lib; {
      description = "Emacs Lisp to Python interface";
      homepage = http://pymacs.progiciels-bpi.ca;
      license = licenses.gpl2;
      maintainers = [ maintainers.goibhniu ];
    };
  };


  pyopengl = buildPythonPackage rec {
    name = "pyopengl-${version}";
    version = "3.0.2";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/P/PyOpenGL/PyOpenGL-${version}.tar.gz";
      sha256 = "9ef93bbea2c193898341f574e281c3ca0dfe87c53aa25fbec4b03581f6d1ba03";
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
      platforms = stdenv.lib.platforms.mesaPlatforms;
    };
  };

  pyopenssl = buildPythonPackage rec {
    name = "pyopenssl-${version}";
    version = "0.14";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pyOpenSSL/pyOpenSSL-0.14.tar.gz";
      sha256 = "0vpfqhng4cky7chliknkxv910iabqbfcxvkjiankh08jkkjvi7d9";
    };

    # 17 tests failing
    doCheck = false;

    propagatedBuildInputs = [ self.cryptography ];
  };


  pyquery = buildPythonPackage rec {
    name = "pyquery-1.2.4";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyquery/${name}.tar.gz";
      md5 = "268f08258738d21bc1920d7522f2a63b";
    };

    propagatedBuildInputs = with self; [ cssselect lxml ];
  };

  pyrax = buildPythonPackage rec {
    name = "pyrax-1.8.2";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyrax/${name}.tar.gz";
      sha256 = "0hvim60bhgfj91m7pp8jfmb49f087xqlgkqa505zw28r7yl0hcfp";
    };

    meta = {
      homepage    = "https://github.com/rackspace/pyrax";
      license     = "MIT";
      description = "Python API to interface with Rackspace";
    };

    doCheck = false;
  };


  pyreport = buildPythonPackage (rec {
    name = "pyreport-0.3.4c";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyreport/${name}.tar.gz";
      md5 = "3076164a7079891d149a23f9435581db";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://pypi.python.org/pypi/pyreport;
      license = "BSD";
      description = "Pyreport makes notes out of a python script";
    };
  });


  pyserial = buildPythonPackage rec {
    name = "pyserial-2.7";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyserial/${name}.tar.gz";
      sha256 = "3542ec0838793e61d6224e27ff05e8ce4ba5a5c5cc4ec5c6a3e8d49247985477";
    };

    doCheck = false;

    meta = {
      homepage = "http://pyserial.sourceforge.net/";
      license = stdenv.lib.licenses.psfl;
      description = "Python serial port extension";
    };
  };

  pysphere = buildPythonPackage rec {
    name = "pysphere-0.1.8";

    src = pkgs.fetchurl {
      url = "http://pysphere.googlecode.com/files/${name}.zip";
      md5 = "c57cba33626ac4b1e3d1974923d59232";
    };

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

      license = "revised BSD";

      maintainers = [ ];
    };
  });


  pysvn = pkgs.stdenv.mkDerivation {
    name = "pysvn-1.7.8";

    src = pkgs.fetchurl {
      url = "http://pysvn.barrys-emacs.org/source_kits/pysvn-1.7.8.tar.gz";
      sha256 = "1qk7af0laby1f79bd07l9p0dxn5xmcmfwlcb9l1hk29zwwq6x4v0";
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


  pytz = buildPythonPackage rec {
    name = "pytz-2013.9";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pytz/${name}.tar.bz2";
      md5 = "ec7076947a46a8a3cb33cbf2983a562c";
    };

    meta = {
      description = "World timezone definitions, modern and historical";
      homepage = http://pytz.sourceforge.net/;
    };
  };


  pyutil = buildPythonPackage (rec {
    name = "pyutil-1.7.9";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyutil/${name}.tar.gz";
      sha256 = "c303bb779f96073820e2eb7c9692fe15a57df491eb356839f3cb3377ed03b844";
    };

    buildInputs = with self; [ setuptoolsDarcs setuptoolsTrial ] ++ (if doCheck then [ simplejson ] else []);
    propagatedBuildInputs = with self; [ zbase32 argparse twisted ];
    # Tests fail because they try to write new code into the twisted
    # package, apparently some kind of plugin.
    doCheck = false;

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

      license = stdenv.lib.licenses.gpl2Plus;
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
      license = stdenv.lib.licenses.lgpl2Plus;
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
      license = stdenv.lib.licenses.lgpl21Plus;
    };
  });


  pyyaml = buildPythonPackage (rec {
    name = "PyYAML-3.10";

    src = pkgs.fetchurl {
      url = "http://pyyaml.org/download/pyyaml/${name}.zip";
      sha256 = "1r127fa354ppb667f4acxlzwxixap1jgzjrr790bw8mcpxv2hqaa";
    };

    buildInputs = with self; [ pkgs.pyrex ];
    propagatedBuildInputs = with self; [ pkgs.libyaml ];

    meta = {
      description = "The next generation YAML parser and emitter for Python";
      homepage = http://pyyaml.org;
      license = stdenv.lib.licenses.free; # !?
    };
  });


  recaptcha_client = buildPythonPackage rec {
    name = "recaptcha-client-1.0.6";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/r/recaptcha-client/${name}.tar.gz";
      md5 = "74228180f7e1fb76c4d7089160b0d919";
    };

    meta = {
      description = "A CAPTCHA for Python using the reCAPTCHA service";
      homepage = http://recaptcha.net/;
    };
  };


  reportlab =
   let freetype = overrideDerivation pkgs.freetype (args: { configureFlags = "--enable-static --enable-shared"; });
   in buildPythonPackage rec {
    name = "reportlab-3.1.8";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/r/reportlab/${name}.tar.gz";
      md5 = "820a9fda647078503597b85cdba7ed7f";
    };

    buildInputs = with self; [freetype];

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      description = "An Open Source Python library for generating PDFs and graphics";
      homepage = http://www.reportlab.com/;
    };
  };


  requests = buildPythonPackage rec {
    name = "requests-1.2.3";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/r/requests/${name}.tar.gz";
      md5 = "adbd3f18445f7fe5e77f65c502e264fb";
    };

    meta = {
      description = "An Apache2 licensed HTTP library, written in Python, for human beings";
      homepage = http://docs.python-requests.org/en/latest/;
    };
  };


  requests2 = buildPythonPackage rec {
    name = "requests-2.4.3";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/r/requests/${name}.tar.gz";
      md5 = "02214b3a179e445545de4b7a98d3dd17";
    };

    meta = {
      description = "An Apache2 licensed HTTP library, written in Python, for human beings";
      homepage = http://docs.python-requests.org/en/latest/;
    };
  };


  requests_oauthlib = buildPythonPackage rec {
    version = "v0.4.1";
    name = "requests-oauthlib-${version}";

    src = pkgs.fetchurl {
      url = "http://github.com/requests/requests-oauthlib/archive/${version}.tar.gz";
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

  retry_decorator = buildPythonPackage rec {
    name = "retry_decorator-1.0.0";
    src = pkgs.fetchurl {
      url = https://pypi.python.org/packages/source/r/retry_decorator/retry_decorator-1.0.0.tar.gz;
      sha256 = "086zahyb6yn7ggpc58909c5r5h3jz321i1694l1c28bbpaxnlk88";
    };
    meta = {
      homepage = https://github.com/pnpnpn/retry-decorator;
      license = stdenv.lib.licenses.mit;
    };
  };

  quantities = buildPythonPackage rec {
    name = "quantities-0.10.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/q/quantities/quantities-0.10.1.tar.gz";
      md5 = "e924e21c0a5ddc9ebcdacbbe511b8ec7";
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
      sha1 = "76ba4991322a991d580e78a197adc80d58bd5fb3";
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

  redis = buildPythonPackage rec {
    name = "redis-2.9.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/r/redis/${name}.tar.gz";
      sha256 = "1r7lrh4kxccyhr4pyp13ilymmvh22pi7aa9514dmnhi74zn4g5xg";
    };

    doCheck = false;

    meta = {
      description = "Python client for Redis key-value store";
      homepage = "https://pypi.python.org/pypi/redis/";
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
    version = "2.1.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/r/restview/${name}.tar.gz";
      sha256 = "07scf80hhr9rijrbfrplyi3gwkx74knnzfhvlg6yf1cd0x2yiy8v";
    };

    propagatedBuildInputs = with self; [ docutils mock pygments ];

    meta = with stdenv.lib; {
      description = "ReStructuredText viewer";
      homepage = http://mg.pov.lt/restview/;
      license = licenses.gpl2;
      platforms = platforms.all;
      maintainers = [ maintainers.koral ];
    };
  };


  reviewboard = buildPythonPackage rec {
    name = "ReviewBoard-1.6.16";

    src = pkgs.fetchurl {
      url = "http://downloads.reviewboard.org/releases/ReviewBoard/1.6/${name}.tar.gz";
      sha256 = "0vg3ypm57m43bscv8vswjdllv3d2j8lxqwwvpd65cl7jd1in0yr1";
    };

    propagatedBuildInputs = with self;
      [ django_1_3 recaptcha_client pytz memcached dateutil_1_5 paramiko flup pygments
        djblets django_evolution pycrypto modules.sqlite3
        pysvn pil psycopg2
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

    propagatedBuildInputs = with self; [ isodate ];

    meta = {
      description = "A Python library for working with RDF, a simple yet powerful language for representing information";
      homepage = http://www.rdflib.net/;
    };
  });

  isodate = buildPythonPackage rec {
    name = "isodate-0.5.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/i/isodate/${name}.tar.gz";
      md5 = "9a267e9327feb3d021cae26002ba6e0e";
    };

    meta = with stdenv.lib; {
      description = "ISO 8601 date/time parser";
      homepage = http://cheeseshop.python.org/pypi/isodate;
    };
  };

  robomachine = buildPythonPackage rec {
    name = "robomachine-0.6";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/R/RoboMachine/RoboMachine-0.6.tar.gz";
      md5 = "4e95eaa43afda0f363c78a88e9da7159";
    };

    propagatedBuildInputs = with self; [ pyparsing argparse robotframework ];

    # Remove Windows .bat files
    postInstall = ''
      rm "$out"/bin/*.bat
    '';

    meta = with stdenv.lib; {
      description = "Test data generator for Robot Framework";
      homepage = https://github.com/mkorpela/RoboMachine;
      license = licenses.asl20;
      maintainers = [ maintainers.bjornfor ];
    };
  };

  robotframework = buildPythonPackage rec {
    version = "2.8.6";
    name = "robotframework-${version}";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/r/robotframework/${name}.tar.gz";
      sha256 = "0hl44pwfkagr5272s90y0bkfllj0q1l4yw4rvkdrc6ikn6l61d9v";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = with stdenv.lib; {
      description = "Generic test automation framework";
      homepage = http://robotframework.org/;
      license = licenses.asl20;
      platforms = platforms.linux;
      maintainers = [ maintainers.bjornfor ];
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

    meta = with stdenv.lib; {
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

    meta = with stdenv.lib; {
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

    meta = with stdenv.lib; {
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

    meta = with stdenv.lib; {
      description = "Light-weight and intuitive editor for Robot Framework test case files";
      homepage = https://code.google.com/p/robotframework-ride/;
      license = licenses.asl20;
      platforms = platforms.linux;
      maintainers = [ maintainers.bjornfor ];
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

    meta = with stdenv.lib; {
      description = "python refactoring library";
      homepage = http://rope.sf.net;
      maintainers = [ maintainers.goibhniu ];
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

     meta = with stdenv.lib; {
       description = "a plugin for performing python refactorings in emacs";
       homepage = http://rope.sf.net/ropemacs.html;
       maintainers = [ maintainers.goibhniu ];
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

     meta = with stdenv.lib; {
       description = "a plugin for performing python refactorings in emacs";
       homepage = http://rope.sf.net;
       maintainers = [ maintainers.goibhniu ];
       license = licenses.gpl2;
     };
  };



  routes = buildPythonPackage rec {
    name = "routes-1.12.3";

    src = pkgs.fetchurl {
      url = http://pypi.python.org/packages/source/R/Routes/Routes-1.12.3.tar.gz;
      md5 = "9740ff424ff6b841632c784a38fb2be3";
    };

    propagatedBuildInputs = with self; [ paste webtest ];

    meta = {
      description = "A Python re-implementation of the Rails routes system for mapping URLs to application actions";
      homepage = http://routes.groovie.org/;
    };
  };

  rpkg = buildPythonPackage (rec {
    name = "rpkg-1.14";
    meta.maintainers = [ stdenv.lib.maintainers.mornfall ];

    src = pkgs.fetchurl {
      url = "https://fedorahosted.org/releases/r/p/rpkg/rpkg-1.14.tar.gz";
      sha256 = "0d053hdjz87aym1sfm6c4cxmzmy5g0gkrmrczly86skj957r77a7";
    };

    patches = [ ../development/python-modules/rpkg-buildfix.diff ];

    # buildPhase = "python setup.py build";
    # doCheck = false;
    propagatedBuildInputs = with self; [ pycurl pkgs.koji GitPython pkgs.git
                              pkgs.rpm pkgs.pyopenssl ];

  });

  rpyc = buildPythonPackage rec {
    name = "rpyc-${version}";
    version = "3.3.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/r/rpyc/${name}.tar.gz";
      md5 = "6931cb92c41f547591b525142ccaeef1";
    };

    propagatedBuildInputs = with self; [ nose plumbum ];

    meta = {
      description = "Remote Python Call (RPyC), a transparent and symmetric RPC library";
      homepage = http://rpyc.readthedocs.org;
      license = stdenv.lib.licenses.mit;
    };
  };

  rsa = buildPythonPackage rec {
    name = "rsa-3.1.2";

    src = pkgs.fetchurl {
      url = "https://bitbucket.org/sybren/python-rsa/get/version-3.1.2.tar.bz2";
      sha256 = "0ag2q4gaapi74x47q74xhcjzs4b7r2bb6zrj2an4sz5d3yd06cgf";
    };

    buildInputs = with self; [ self.pyasn1 ];

    meta = {
      homepage = http://stuvel.eu/rsa;
      license = stdenv.lib.licenses.asl20;
      description = "A pure-Python RSA implementation";
    };
  };

  squaremap = buildPythonPackage rec {
    name = "squaremap-1.0.4";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/S/SquareMap/SquareMap-1.0.4.tar.gz";
      md5 = "e36a453baddb97c19af6f79d5ba51f38";
    };

    meta = with stdenv.lib; {
      description = "Hierarchic visualization control for wxPython";
      homepage = https://launchpad.net/squaremap;
      license = licenses.bsd3;
    };
  };

  runsnakerun = buildPythonPackage rec {
    name = "runsnakerun-2.0.4";


    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/R/RunSnakeRun/RunSnakeRun-2.0.4.tar.gz";
      md5 = "3220b5b89994baee70b1c24d7e42a306";
    };

    propagatedBuildInputs = [ self.squaremap self.wxPython28 ];

    meta = with stdenv.lib; {
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
      platforms = stdenv.lib.platforms.linux;
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

    meta = with stdenv.lib; {
      description = "Generate sequence-diagram image from spec-text file (similar to Graphviz)";
      homepage = http://blockdiag.com/;
      license = licenses.asl20;
      platforms = platforms.linux;
      maintainers = [ maintainers.bjornfor ];
    };
  };


  scapy = buildPythonPackage rec {
    name = "scapy-2.2.0";

    disabled = isPy3k || isPyPy;

    src = pkgs.fetchurl {
      url = "http://www.secdev.org/projects/scapy/files/${name}.tar.gz";
      sha256 = "1bqmp0xglkndrqgmybpwmzkv462mir8qlkfwsxwbvvzh9li3ndn5";
    };

    propagatedBuildInputs = [ modules.readline ];

    meta = with stdenv.lib; {
      description = "Powerful interactive network packet manipulation program";
      homepage = http://www.secdev.org/projects/scapy/;
      license = licenses.gpl2;
      platforms = platforms.linux;
      maintainers = [ maintainers.bjornfor ];
    };
  };


  scipy = buildPythonPackage rec {
    name = "scipy-0.14.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/s/scipy/${name}.tar.gz";
      md5 = "d7c7f4ccf8b07b08d6fe49d5cd51f85d";
    };

    buildInputs = [ pkgs.gfortran ];
    propagatedBuildInputs = with self; [ numpy ];

    # TODO: add ATLAS=${pkgs.atlas}
    preConfigure = ''
      export BLAS=${pkgs.blas} LAPACK=${pkgs.liblapack}
      sed -i '0,/from numpy.distutils.core/s//import setuptools;from numpy.distutils.core/' setup.py
    '';

    setupPyBuildFlags = [ "--fcompiler='gnu95'" ];

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      description = "SciPy (pronounced 'Sigh Pie') is open-source software for mathematics, science, and engineering. ";
      homepage = http://www.scipy.org/;
    };
  };


  scikitlearn = buildPythonPackage {
    name = "scikit-learn-0.15.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/s/scikit-learn/scikit-learn-0.15.2.tar.gz";
      md5 = "d9822ad0238e17b382a3c756ea94fe0d";
    };

    buildInputs = with self; [ nose pillow pkgs.gfortran ];
    propagatedBuildInputs = with self; [ numpy scipy pkgs.atlas ];

    buildPhase = ''
      export ATLAS=${pkgs.atlas}
      ${self.python.executable} setup.py build_ext -i --fcompiler='gnu95'
    '';

    checkPhase = ''
      LOCALE_ARCHIVE=${localePath} LC_ALL="en_US.UTF-8" HOME=$TMPDIR ATLAS="" nosetests
    '';

    meta = {
      description = "A set of python modules for machine learning and data mining";
      homepage = http://scikit-learn.org;
      license = stdenv.lib.licenses.bsd3;
    };
  };


  scripttest = buildPythonPackage rec {
    version = "1.3";
    name = "scripttest-${version}";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/s/scripttest/scripttest-${version}.tar.gz";
      md5 = "1d1c5117ccfc7b5961cae6c1020c0848";
    };

    buildInputs = with self; [ nose pytest ];

    meta = {
      description = "A library for testing interactive command-line applications";
      homepage = http://pypi.python.org/pypi/ScriptTest/;
    };
  };

  selenium = buildPythonPackage rec {
    name = "selenium-2.44.0";
    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/s/selenium/${name}.tar.gz";
      sha256 = "0l70pqwg88imbylcd831vg8nj8ipy4zr331f6qjccss7vn56i2h5";
    };

    buildInputs = with self; [pkgs.xlibs.libX11];

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
      substituteInPlace x_ignore_nofocus.c --replace "/usr/lib/libX11.so.6" "${pkgs.xlibs.libX11}/lib/libX11.so.6"
      gcc -c -fPIC x_ignore_nofocus.c -o x_ignore_nofocus.o
      gcc -shared \
        -Wl,${if stdenv.isDarwin then "-install_name" else "-soname"},x_ignore_nofocus.so \
        -o x_ignore_nofocus.so \
        x_ignore_nofocus.o
      cp -v x_ignore_nofocus.so py/selenium/webdriver/firefox/${if pkgs.stdenv.is64bit then "amd64" else "x86"}/
    '';
  };

  setuptoolsDarcs = buildPythonPackage {
    name = "setuptools-darcs-1.2.9";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/s/setuptools_darcs/setuptools_darcs-1.2.9.tar.gz";
      sha256 = "d37ce11030addbd729284c441facd0869cdc6e5c888dc5fa0a6f1edfe3c3e617";
    };

    # In order to break the dependency on darcs -> ghc, we don't add
    # darcs as a propagated build input.
    propagatedBuildInputs = with self; [ darcsver ];

    meta = {
      description = "setuptools plugin for the Darcs version control system";

      homepage = http://allmydata.org/trac/setuptools_darcs;

      license = "BSD";
    };
  };


  setuptoolsTrial = buildPythonPackage {
    name = "setuptools-trial-0.5.12";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/s/setuptools_trial/setuptools_trial-0.5.12.tar.gz";
      md5 = "f16f4237c9ee483a0cd13208849d96ad";
    };

    propagatedBuildInputs = with self; [ twisted ];

    meta = {
      description = "setuptools plug-in that helps run unit tests built with the \"Trial\" framework (from Twisted)";

      homepage = http://allmydata.org/trac/setuptools_trial;

      license = "unspecified"; # !
    };
  };


  simplejson = buildPythonPackage (rec {
    name = "simplejson-3.3.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/s/simplejson/${name}.tar.gz";
      md5 = "0e29b393bceac8081fa4e93ff9f6a001";
    };

    meta = {
      description = "simplejson is a simple, fast, extensible JSON encoder/decoder for Python";

      longDescription = ''
        simplejson is compatible with Python 2.4 and later with no
        external dependencies.  It covers the full JSON specification
        for both encoding and decoding, with unicode support.  By
        default, encoding is done in an encoding neutral fashion (plain
        ASCII with \uXXXX escapes for unicode characters).
      '';

      homepage = http://code.google.com/p/simplejson/;

      license = stdenv.lib.licenses.mit;
    };
  });

  sigal = buildPythonPackage rec {
    name = "sigal-0.7.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/s/sigal/${name}.tar.gz";
      md5 = "d2386706ac8543378aebde1ea4edeba4";
    };

    propagatedBuildInputs = with self; [ jinja2 markdown pillow pilkit clint argh pytest ];

    meta = with stdenv.lib; {
      description = "Yet another simple static gallery generator";
      homepage = http://sigal.saimon.org/en/latest/index.html;
      license = licenses.mit;
      maintainers = [ maintainers.iElectric ];
    };
  };

  pgpdump = self.buildPythonPackage rec {
    name = "pgpdump-1.5";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pgpdump/pgpdump-1.5.tar.gz";
      md5 = "040a451c8e63de3e61fc5b66efa7fca5";
    };

    meta = with stdenv.lib; {
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

    meta = with stdenv.lib; {
      description = "Statistical anti-spam filter, initially based on the work of Paul Graham";
      homepage = http://spambayes.sourceforge.net/;
    };
  };

  shapely = buildPythonPackage rec {
    name = "Shapely-1.3.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/S/Shapely/${name}.tar.gz";
      sha256 = "099sc7ajpp6hbgrx3c0bl6hhkz1mhnr0ahvc7s4i3f3b7q1zfn7l";
    };

    buildInputs = with self; [ pkgs.geos ];

    preConfigure = ''
      export LANG="en_US.UTF-8";
      export LOCALE_ARCHIVE=${localePath}
    '';

    patchPhase = ''
      sed -i "s|_lgeos = load_dll('geos_c', fallbacks=.*)|_lgeos = load_dll('geos_c', fallbacks=['${pkgs.geos}/lib/libgeos_c.so'])|" shapely/geos.py
    '';

    doCheck = false; # won't suceed for unknown reasons that look harmless, though

    meta = with stdenv.lib; {
      description = "Geometric objects, predicates, and operations";
      homepage = "https://pypi.python.org/pypi/Shapely/";
    };
  };

  stevedore = buildPythonPackage rec {
    name = "stevedore-0.15";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/s/stevedore/${name}.tar.gz";
      sha256 = "bec9269cbfa58de4f0849ec79bb7d54eeeed9df8b5fbfa1637fbc68062822847";
    };

    buildInputs = with self; [ pbr pip ] ++ optional isPy26 argparse;

    propagatedBuildInputs = with self; [ setuptools ];

    meta = {
      description = "Manage dynamic plugins for Python applications";
      homepage = "https://pypi.python.org/pypi/stevedore";
      license = licenses.asl20;
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
    name = "sympy-0.7.4";
    disabled = isPy34;  # some tests fail

    src = pkgs.fetchurl {
      url    = "https://pypi.python.org/packages/source/s/sympy/${name}.tar.gz";
      sha256 = "0h1b9mx0snyyybj1x1ga69qssgjzkkgx2rw6nddjhyz1fknf8ywh";
    };

    preCheck = ''
      export LANG="en_US.UTF-8"
      export LOCALE_ARCHIVE=${localePath}
    '';

    meta = with stdenv.lib; {
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
      md5 = "659dd67440f4b576889f2cd350f43d7b";
    };

    preConfigure = ''
      substituteInPlace setup.py --replace 'nose==1.2.1' 'nose'
    '';

    # tests fail, see https://github.com/matthewwithanm/pilkit/issues/9
    doCheck = false;

    buildInputs = with self; [ pillow nose_progressive nose mock blessings ];

    meta = with stdenv.lib; {
      maintainers = [ maintainers.iElectric ];
    };
  };

  clint = buildPythonPackage rec {
    name = "clint-0.3.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/c/clint/${name}.tar.gz";
      md5 = "7dcd43fb08bfb84c7d63e9356ada7b73";
    };

    checkPhase = ''
      nosetests
    '';

    buildInputs = with self; [ pillow nose_progressive nose mock blessings nose ];

    meta = with stdenv.lib; {
      maintainers = [ maintainers.iElectric ];
    };
  };

  argh = buildPythonPackage rec {
    name = "argh-0.23.3";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/a/argh/${name}.tar.gz";
      md5 = "25bb02c6552b42875f2c36714e0ff16c";
    };

    preCheck = ''
      export LANG="en_US.UTF-8"
      export LOCALE_ARCHIVE=${localePath}
    '';

    buildInputs = with self; [ pytest py mock ];

    meta = with stdenv.lib; {
      maintainers = [ maintainers.iElectric ];
    };
  };

  nose_progressive = buildPythonPackage rec {
    name = "nose-progressive-1.3";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/n/nose-progressive/${name}.tar.gz";
      md5 = "180be93929c5962044a35489f193259d";
    };

    buildInputs = with self; [ pillow blessings nose ];
    propagatedBuildInputs = with self; [ modules.curses ];

    meta = with stdenv.lib; {
      maintainers = [ maintainers.iElectric ];
    };
  };

  blessings = buildPythonPackage rec {
    name = "blessings-1.5.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/b/blessings/${name}.tar.gz";
      md5 = "fbbddbf20b1f9a13e3fa612b1e086fd8";
    };

    # 4 failing tests
    doCheck = false;

    buildInputs = with self; [ nose modules.curses ];

    meta = with stdenv.lib; {
      maintainers = [ maintainers.iElectric ];
    };
  };

  semantic = buildPythonPackage rec {
    name = "semantic-1.0.3";

    disabled = isPy3k;

    propagatedBuildInputs = with self; [ quantities numpy ];

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/s/semantic/semantic-1.0.3.tar.gz";
      md5 = "78a150190e3e7d0f6f357b4c828e5f0d";
    };

    # strange setuptools error (can not import semantic.test)
    doCheck = false;

    meta = with pkgs.stdenv.lib; {
      description = "Common Natural Language Processing Tasks for Python";
      homepage = https://github.com/crm416/semantic;
      license = licenses.mit;
    };
  };

  sexpdata = buildPythonPackage rec {
    name = "sexpdata-0.0.2";
    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/s/sexpdata/${name}.tar.gz";
      md5 = "efc44265bc27cb3d6ffed4fbf5733fc1";
    };

    doCheck = false;

    meta = {
      description = "S-expression parser for Python";
      homepage = "https://github.com/tkf/sexpdata";
    };
  };


  sh = buildPythonPackage rec {
    name = "sh-1.08";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/s/sh/${name}.tar.gz";
      md5 = "4028bcba85daa0aef579ed24261e88a3";
    };

    doCheck = false;

    meta = {
      description = "Python subprocess interface";
      homepage = http://pypi.python.org/pypi/sh/;
    };
  };


  sipsimple = buildPythonPackage rec {
    name = "sipsimple-${version}";
    version = "1.4.2";
    disabled = isPy3k;

    configurePhase = "find -name 'configure' -exec chmod a+x {} \\; ; find -name 'aconfigure' -exec chmod a+x {} \\; ; ${python}/bin/${python.executable} setup.py build_ext --pjsip-clean-compile";

    src = pkgs.fetchurl {
      url = "http://download.ag-projects.com/SipClient/python-${name}.tar.gz";
      sha256 = "f6e6de7ab5f20e8ae08966b8811462e4271833db4f7fbab58ffba4e5c07ab114";
    };

    propagatedBuildInputs = with self; [ cython pkgs.openssl dns dateutil xcaplib msrplib];

    buildInputs = with self; [ pkgs.alsaLib ];

    installPhase = "${python}/bin/${python.executable} setup.py install --prefix=$out";

    doCheck = false;
  };


  six = buildPythonPackage rec {
    name = "six-1.8.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/s/six/${name}.tar.gz";
      md5 = "1626eb24cc889110c38f7e786ec69885";
    };

    # error: invalid command 'test'
    doCheck = false;

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

    propagatedBuildInputs = with self; [ pkgs.xlibs.libX11 pkgs.pythonDBus pygobject ];

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
      md5 = "b960f61facafc879142b699050f6d8b4";
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
      license = stdenv.lib.licenses.bsd3;
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
      license = stdenv.lib.licenses.bsd3;
    };
  };

  supervisor = buildPythonPackage rec {
    name = "supervisor-3.1.1";

    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/s/supervisor/${name}.tar.gz";
      md5 = "8c9714feaa63902f03871317e3ebf62e";
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
      md5 = "754c5ab9f533e764f931136974b618f1";
    };

    buildInputs = [ pkgs.bash ];

    doCheck = !isPyPy;

    preConfigure = ''
      substituteInPlace test_subprocess32.py \
        --replace '/usr/' '${pkgs.bash}/'
    '';

    checkPhase = ''
      TMP_PREFIX=`pwd`/tmp/$name
      TMP_INSTALL_DIR=$TMP_PREFIX/lib/${pythonPackages.python.libPrefix}/site-packages
      PYTHONPATH="$TMP_INSTALL_DIR:$PYTHONPATH"
      mkdir -p $TMP_INSTALL_DIR
      python setup.py develop --prefix $TMP_PREFIX
      python test_subprocess32.py
    '';

    meta = {
      homepage = https://pypi.python.org/pypi/subprocess32;
      description = "Backport of the subprocess module from Python 3.2.5 for use on 2.x";
      maintainers = [ stdenv.lib.maintainers.garbas ];
    };
  };


  sphinx = buildPythonPackage (rec {
    name = "Sphinx-1.2.3";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/S/Sphinx/${name}.tar.gz";
      md5 = "a98c93124035b4cd7183604aec656cb3";
    };

    propagatedBuildInputs = with self; [docutils jinja2 pygments];

    meta = {
      description = "Sphinx is a tool that makes it easy to create intelligent and beautiful documentation for Python projects.";

      homepage = http://sphinx.pocoo.org/;

      license = "BSD";
    };
  });


  sphinxcontrib_httpdomain = buildPythonPackage (rec {
    name = "sphinxcontrib-httpdomain-1.1.9";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/s/sphinxcontrib-httpdomain/${name}.tar.gz";
      md5 = "0f63aea612cc9e0b55a6c39e5b0f87b7";
    };

    propagatedBuildInputs = with self; [sphinx];

    meta = {
      description = "Provides a Sphinx domain for describing RESTful HTTP APIs";

      homepage = http://bitbucket.org/birkenfeld/sphinx-contrib;

      license = "BSD";
    };
  });


  sphinx_pypi_upload = buildPythonPackage (rec {
    name = "Sphinx-PyPI-upload-0.2.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/S/Sphinx-PyPI-upload/${name}.tar.gz";
      md5 = "b9f1df5c8443197e4d49abbba1cfddc4";
    };

    meta = {
      description = "Setuptools command for uploading Sphinx documentation to PyPI";

      homepage = http://bitbucket.org/jezdez/sphinx-pypi-upload/;

      license = "BSD";
    };
  });

  sqlalchemy = self.sqlalchemy9.override rec {
    name = "SQLAlchemy-0.7.10";
    disabled = isPy34;
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
  };

  sqlalchemy8 = self.sqlalchemy9.override rec {
    name = "SQLAlchemy-0.8.7";
    disabled = isPy34;
    doCheck = !isPyPy;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/S/SQLAlchemy/${name}.tar.gz";
      md5 = "4f3377306309e46739696721b1785335";
    };
    preConfigure = optionalString isPy3k ''
      python3 sa2to3.py --no-diffs -w lib test examples
    '';
  };

  sqlalchemy9 = buildPythonPackage rec {
    name = "SQLAlchemy-0.9.4";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/S/SQLAlchemy/${name}.tar.gz";
      md5 = "c008ea5e2565ec1418ee8461393a99b1";
    };

    buildInputs = with self; [ nose mock ];

    propagatedBuildInputs = with self; [ modules.sqlite3 ];

    checkPhase = ''
      ${python.executable} sqla_nose.py
    '';

    meta = {
      homepage = http://www.sqlalchemy.org/;
      description = "A Python SQL toolkit and Object Relational Mapper";
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


  sqlalchemy_migrate = buildPythonPackage rec {
    name = "sqlalchemy-migrate-0.6.1";

    src = pkgs.fetchurl {
      url = "http://sqlalchemy-migrate.googlecode.com/files/${name}.tar.gz";
      sha1 = "17168b5fa066bd56fd93f26345525377e8a83d8a";
    };

    buildInputs = with self; [ nose unittest2 scripttest ];

    propagatedBuildInputs = with self; [ tempita decorator sqlalchemy ];

    preCheck =
      ''
        echo sqlite:///__tmp__ > test_db.cfg
      '';

    # Some tests fail with "unexpected keyword argument 'script_path'".
    doCheck = false;

    meta = {
      homepage = http://code.google.com/p/sqlalchemy-migrate/;
      description = "Schema migration tools for SQLAlchemy";
    };
  };


  python_statsd = buildPythonPackage rec {
    name = "python-statsd-${version}";
    version = "1.6.0";
    disabled = isPy3k;  # next release will be py3k compatible

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/python-statsd/${name}.tar.gz";
      md5 = "3a0c71a160b504b843703c3041c7d7fb";
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
      md5 = "af0a314b6106dd80da24a918c24a1eab";
    };

    buildInputs = with self; [ mock nose ];

    # XXX: Ran 0 tests in 0.217s

    meta = {
      description = "Lightweight and extensible STOMP messaging client";
      homepage = http://bitbucket.org/hozn/stompclient;
      license = licenses.asl20;
    };
  });


  subunit = stdenv.mkDerivation rec {
    name = "subunit-${version}";
    version = "1.0.0";

    src = pkgs.fetchurl {
      url = "https://launchpad.net/subunit/trunk/${version}/+download/${name}.tar.gz";
      sha256 = "1fnhrrwww90746an2nz2kn9qdf9pklmaf5lm22gssl6648f2rp2m";
    };

    buildInputs = (with pkgs; [ pkgconfig check cppunit perl ]) ++ [ self.wrapPython ];

    propagatedBuildInputs = with self; [ testtools testscenarios ];

    postFixup = "wrapPythonPrograms";

    meta = {
      description = "A streaming protocol for test results";
      homepage = https://launchpad.net/subunit;
      license = licenses.asl20;
    };
  };


  sure = buildPythonPackage rec {
    name = "sure-${version}";
    version = "1.2.8";

    preBuild = ''
      export LOCALE_ARCHIVE=${localePath}
      export LC_ALL="en_US.UTF-8"
    '';

    # https://github.com/gabrielfalcao/sure/issues/71
    doCheck = !isPy3k;
    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/s/sure/${name}.tar.gz";
      sha256 = "0pgi9xg00wcw0m1pv5qp7jv53q38yffcmkf2fj1zlfi2b9c3njid";
    };

    buildInputs = with self; [ nose ];

    propagatedBuildInputs = with self; [ six mock ];

    meta = {
      description = "Utility belt for automated testing";
      homepage = "http://falcao.it/sure/";
      license = licenses.gpl3Plus;
    };
  };


  structlog = buildPythonPackage rec {
    name = "structlog-0.4.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/s/structlog/${name}.tar.gz";
      md5 = "062cda36069e8573e00c265f451f899e";
    };

    meta = {
      description = "Painless structural logging";
      homepage = http://www.structlog.org/;
      license = licenses.asl20;
    };
  };


  # XXX: ValueError: ZIP does not support timestamps before 1980
  # svneverever =  buildPythonPackage rec {
  #   name = "svneverever-778489a8";
  #
  #   src = pkgs.fetchgit {
  #     url = git://git.goodpoint.de/svneverever.git;
  #     rev = "778489a8c6f07825fb18c9da3892a781c3d659ac";
  #     sha256 = "41c9da1dab2be7b60bff87e618befdf5da37c0a56287385cb0cbd3f91e452bb6";
  #   };
  #
  #   propagatedBuildInputs = with self; [ pysvn argparse ];
  #
  #   doCheck = false;
  # };

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
      platforms = stdenv.lib.platforms.linux;
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
      libspaths=${pkgs.xlibs.libSM}/lib:${pkgs.xlibs.libXScrnSaver}/lib
      wrapProgram $out/bin/taskcoach.py \
        --prefix LD_LIBRARY_PATH : $libspaths
    '';

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://taskcoach.org/;
      description = "Todo manager to keep track of personal tasks and todo lists";
      license = stdenv.lib.licenses.gpl3Plus;
    };
  };

  taskw = buildPythonPackage rec {
    version = "0.8.6";
    name = "taskw-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/t/taskw/${name}.tar.gz";
      # md5 = "9f3ce2eaff9a3986d04632547168894d"; # provided by pypi website.
      sha256 = "341a165a1c2ef94fb1c2a49a785357377f04a0d55cabe9563179849497e47146";
    };

    patches = [ ../development/python-modules/taskw/use-template-for-taskwarrior-install-path.patch ];
    postPatch = ''
      substituteInPlace taskw/warrior.py \
        --replace '@@taskwarrior@@' '${pkgs.taskwarrior}'
    '';

    buildInputs = with self; [ nose pkgs.taskwarrior ];
    propagatedBuildInputs = with self; [ six dateutil pytz ];

    meta = {
      homepage =  http://github.com/ralphbean/taskw;
      description = "Python bindings for your taskwarrior database";
      license = licenses.gpl3Plus;
      platforms = platforms.all;
      maintainers = [ maintainers.pierron ];
    };
  };

  tempita = buildPythonPackage rec {
    version = "0.5.2";
    name = "tempita-${version}";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/T/Tempita/Tempita-${version}.tar.gz";
      md5 = "4c2f17bb9d481821c41b6fbee904cea1";
    };

    disabled = isPy3k;

    buildInputs = with self; [ nose ];

    meta = {
      homepage = http://pythonpaste.org/tempita/;
      description = "A very small text templating language";
    };
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


  testtools = buildPythonPackage rec {
    name = "testtools-${version}";
    version = "0.9.34";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/t/testtools/${name}.tar.gz";
      sha256 = "0s6sn9h26dif2c9sayf875x622kq8jb2f4qbc6if7gwh2sssgicn";
    };

    propagatedBuildInputs = with self; [ self.python_mimeparse self.extras lxml ];

    meta = {
      description = "A set of extensions to the Python standard library's unit testing framework";
      homepage = http://pypi.python.org/pypi/testtools;
      license = licenses.mit;
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
    name = "texttable-0.8.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/t/texttable/${name}.tar.gz";
      md5 = "4fe37704f16ecf424b91e122defedd7e";
    };

    meta = with stdenv.lib; {
      description = "A module to generate a formatted text table, using ASCII characters";
      homepage = http://foutaise.org/code/;
      license = licenses.lgpl2;
    };
  };

  tmdb3 = buildPythonPackage rec {
    name = "tmdb3-${version}";
    version = "0.6.17";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/t/tmdb3/${name}.zip";
      md5 = "cd259427454472164c9a2479504c9cbb";
    };

    meta = {
      description = "Python implementation of the v3 API for TheMovieDB.org, allowing access to movie and cast information";
      homepage = http://pypi.python.org/pypi/tmdb3;
      license = stdenv.lib.licenses.bsd3;
    };
  };

  # TODO
  # Installs correctly but fails tests that involve simple things like:
  # cmd.run("tox", "-h")
  # also, buildPythonPackage needs to supply the tox.ini correctly for projects that use tox for their tests
  #

  tox = buildPythonPackage rec {
    name = "tox-1.7.2";

    propagatedBuildInputs = with self; [ py virtualenv ];

    doCheck = false;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/t/tox/${name}.tar.gz";
      md5 = "0d9b3acb1a9252659d753b0ae6b9b264";
    };
  };

  smmap = buildPythonPackage rec {
    name = "smmap-0.8.2";
    disabled = isPy3k || isPyPy;  # next release will have py3k/pypy support
    meta.maintainers = [ stdenv.lib.maintainers.mornfall ];

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/s/smmap/${name}.tar.gz";
      sha256 = "0vrdgr6npmajrv658fv8bij7zgm5jmz2yxkbv8kmbv25q1f9b8ny";
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


  transaction = buildPythonPackage rec {
    name = "transaction-${version}";
    version = "1.4.3";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/t/transaction/${name}.tar.gz";
      md5 = "b4ca5983c9e3a0808ff5ff7648092c76";
    };

    propagatedBuildInputs = with self; [ zope_interface ];

    meta = {
      description = "Transaction management";
      homepage = http://pypi.python.org/pypi/transaction;
      license = stdenv.lib.licenses.zpt20;
    };
  };

  transmissionrpc = buildPythonPackage rec {
    name = "transmissionrpc-${version}";
    version = "0.11";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/t/transmissionrpc/${name}.tar.gz";
      md5 = "b2f918593e509f0e66e2e643291b436d";
    };

    propagatedBuildInputs = with self; [ six ];

    meta = {
      description = "Python implementation of the Transmission bittorent client RPC protocol";
      homepage = http://pypi.python.org/pypi/transmissionrpc/;
      license = stdenv.lib.licenses.mit;
    };
  };

  eggdeps  = buildPythonPackage rec {
     name = "eggdeps-${version}";
     version = "0.4";

     src = pkgs.fetchurl {
       url = "http://pypi.python.org/packages/source/t/tl.eggdeps/tl.${name}.tar.gz";
       md5 = "2472204a2abd0d8cd4d11ff0fbf36ae7";
     };

     # tests fail, see http://hydra.nixos.org/build/4316603/log/raw
     doCheck = false;

     propagatedBuildInputs = with self; [ zope_interface zope_testing ];
     meta = {
       description = "A tool which computes a dependency graph between active Python eggs";
       homepage = http://thomas-lotze.de/en/software/eggdeps/;
       license = stdenv.lib.licenses.zpt20;
     };
   };


  turses = buildPythonPackage (rec {
    name = "turses-0.2.22";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/t/turses/${name}.tar.gz";
      sha256 = "1dqgvdqly4c4d6819mbkqy4g8r7zch4dkmxicfwck7q8h96wmyx3";
    };

    propagatedBuildInputs = with self; [ oauth2 urwid tweepy ] ++ optional isPy26 argparse;

    #buildInputs = [ tox ];
    # needs tox
    doCheck = false;

    meta = {
      homepage = https://github.com/alejandrogomez/turses;
      description = "A Twitter client for the console";
      license = licenses.gpl3;
      maintainers = [ stdenv.lib.maintainers.garbas ];
      platforms = stdenv.lib.platforms.linux;
    };
  });

  tweepy = buildPythonPackage (rec {
    name = "tweepy-2.3.0";
    disabled = isPy3k;

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/t/tweepy/${name}.tar.gz";
      sha256 = "0wcj5g21brcqr1g7m4by4rs72lfiib4scg19qynn2wz1x77jyrzp";
    };

    meta = {
      homepage = "https://github.com/tweepy/tweepy";
      description = "Twitter library for python";
      license = licenses.mit;
      maintainers = [ stdenv.lib.maintainers.garbas ];
      platforms = stdenv.lib.platforms.linux;
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
      maintainers = [ maintainers.pierron ];
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
      maintainers = [ maintainers.thoughtpolice ];
    };
  };

  twisted = buildPythonPackage rec {
    # NOTE: When updating please check if new versions still cause issues
    # to packages like carbon (http://stackoverflow.com/questions/19894708/cant-start-carbon-12-04-python-error-importerror-cannot-import-name-daem)
    disabled = isPy3k;

    name = "Twisted-11.1.0";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/T/Twisted/${name}.tar.bz2";
      sha256 = "05agfp17cndhv2w0p559lvknl7nv0xqkg10apc47fm53m8llbfvz";
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
      md5 = "56c2a04501b98f2a1188d003fd6d3dba";
    };

     # test fail (timezone test fail)
     doCheck = false;

    meta = with pkgs.stdenv.lib; {
      description = "Tzinfo object for the local timezone";
      homepage = https://github.com/regebro/tzlocal;
      license = licenses.cddl;
    };
  };

  unittest2 = buildPythonPackage rec {
    version = "0.5.1";
    name = "unittest2-${version}";

    src = if python.is_py3k or false
       then pkgs.fetchurl {
           url = "http://pypi.python.org/packages/source/u/unittest2py3k/unittest2py3k-${version}.tar.gz";
           sha256 = "00yl6lskygcrddx5zspkhr0ibgvpknl4678kkm6s626539grq93q";
         }
       else pkgs.fetchurl {
           url = "http://pypi.python.org/packages/source/u/unittest2/unittest2-${version}.tar.gz";
           md5 = "a0af5cac92bbbfa0c3b0e99571390e0f";
         };

    preConfigure = ''
      sed -i 's/unittest2py3k/unittest2/' setup.py
    '';

    meta = {
      description = "A backport of the new features added to the unittest testing framework in Python 2.7";
      homepage = http://pypi.python.org/pypi/unittest2;
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
      license = stdenv.lib.licenses.lgpl2Plus;
      description = "Python module for downloading files";
      maintainers = [ stdenv.lib.maintainers.qknight ];
    };
  };


  urwid = buildPythonPackage (rec {
    name = "urwid-1.2.1";

    # multiple:  NameError: name 'evl' is not defined
    doCheck = false;

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/u/urwid/${name}.tar.gz";
      md5 = "6a05ada11b87e7b026b01fc5150855b0";
    };

    meta = {
      description = "A full-featured console (xterm et al.) user interface library";
      homepage = http://excess.org/urwid;
      repositories.git = git://github.com/wardi/urwid.git;
      license = licenses.lgpl21;
      maintainers = [ stdenv.lib.maintainers.garbas ];
    };
  });

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

  virtualenv = buildPythonPackage rec {
    name = "virtualenv-1.11.6";
    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/v/virtualenv/${name}.tar.gz";
      md5 = "f61cdd983d2c4e6aeabb70b1060d6f49";
    };

    pythonPath = [ self.recursivePthLoader ];

    patches = [ ../development/python-modules/virtualenv-change-prefix.patch ];

    propagatedBuildInputs = with self; [ modules.readline modules.sqlite3 modules.curses ];

    buildInputs = with self; [ mock nose ];

    # XXX: Ran 0 tests in 0.003s

    meta = with stdenv.lib; {
      description = "a tool to create isolated Python environments";
      homepage = http://www.virtualenv.org;
      license = licenses.mit;
      maintainers = [ maintainers.goibhniu ];
    };
  };

  virtualenv-clone = buildPythonPackage rec {
    name = "virtualenv-clone-0.2.4";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/v/virtualenv-clone/${name}.tar.gz";
      md5 = "71168b975eaaa91e65559bcc79290b3b";
    };

    buildInputs = with self; [pytest];
    propagatedBuildInputs = with self; [virtualenv];

    # needs tox to run the tests
    doCheck = false;

    meta = with stdenv.lib; {
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

  waitress = buildPythonPackage rec {
    name = "waitress-0.8.7";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/w/waitress/${name}.tar.gz";
      md5 = "714f3d458d82a47f12fb168460de8366";
    };

    doCheck = false;

    meta = {
       maintainers = [
         stdenv.lib.maintainers.garbas
         stdenv.lib.maintainers.iElectric
       ];
       platforms = stdenv.lib.platforms.all;
    };
  };


  webcolors = buildPythonPackage rec {
    name = "webcolors-1.4";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/w/webcolors/${name}.tar.gz";
      md5 = "35de9d785b5c04a9cc66a2eae0519254";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = with stdenv.lib; {
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
      md5 = "10bab03bf86ce8da2a95a3b15197ae2e";
    };

    buildInputs = with self; [ pkgs.imagemagick pytest psutil memory_profiler pytest_xdist ];

    meta = {
      description = "Ctypes-based simple MagickWand API binding for Python";
      homepage = http://wand-py.org/;
      platforms = stdenv.lib.platforms.all;
    };
  };


  webob = buildPythonPackage rec {
    version = "1.4";
    name = "webob-${version}";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/W/WebOb/WebOb-${version}.tar.gz";
      md5 = "8437607c0cc00c35f658f972516ffb55";
    };

    propagatedBuildInputs = with self; [ nose ];

    meta = {
      description = "WSGI request and response object";
      homepage = http://pythonpaste.org/webob/;
      platforms = stdenv.lib.platforms.all;
    };
  };


  websockify = buildPythonPackage rec {
    version = "0.3.0";
    name = "websockify-${version}";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/w/websockify/websockify-${version}.tar.gz";
      md5 = "29b6549d3421907de4bbd881ecc2e1b1";
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
      md5 = "49314bdba23f4d0bd807facb2a6d3f90";
    };

    preConfigure = ''
      substituteInPlace setup.py --replace "nose<1.3.0" "nose"
    '';

    # XXX: skipping two tests fails in python2.6
    doCheck = ! isPy26;

    buildInputs = optionals isPy26 [ self.ordereddict unittest2 ];

    propagatedBuildInputs = with self; [
      nose
      webob
      six
      beautifulsoup4
      waitress
      mock
      pyquery
      wsgiproxy2
      paste_deploy
      coverage
    ];

    meta = {
      description = "Helper to test WSGI applications";
      homepage = http://webtest.readthedocs.org/en/latest/;
      platforms = stdenv.lib.platforms.all;
    };
  };


  werkzeug = buildPythonPackage rec {
    name = "Werkzeug-0.9.6";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/W/Werkzeug/${name}.tar.gz";
      md5 = "f7afcadc03b0f2267bdc156c34586043";
    };

    propagatedBuildInputs = with self; [ itsdangerous ];

    doCheck = false;            # tests fail, not sure why

    meta = {
      homepage = http://werkzeug.pocoo.org/;
      description = "A WSGI utility library for Python";
      license = "BSD";
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
      license = stdenv.lib.licenses.mit;
    };
  });


  wsgiproxy2 = buildPythonPackage rec {
    name = "WSGIProxy2-0.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/W/WSGIProxy2/${name}.tar.gz";
      md5 = "157049212f1c81a8790efa31146fbabf";
    };

    propagatedBuildInputs = with self; [ six webob ];

    meta = {
       maintainers = [
         stdenv.lib.maintainers.garbas
         stdenv.lib.maintainers.iElectric
      ];
      platforms = stdenv.lib.platforms.all;
    };
  };

  wxPython = self.wxPython28;

  wxPython28 = callPackage ../development/python-modules/wxPython/2.8.nix {
    wxGTK = pkgs.wxGTK28;
  };

  wxPython30 = callPackage ../development/python-modules/wxPython/3.0.nix {
    wxGTK = pkgs.wxGTK30;
  };

  xcaplib = buildPythonPackage rec {
    name = "python-xcaplib-${version}";
    version = "1.0.17";

    src = pkgs.fetchurl {
      url = "http://download.ag-projects.com/SipClient/${name}.tar.gz";
      sha256 = "1bf8n9ghmgxz8kjgnwy4y7ajijy5hi7viabgh0pvzkhz9gfvck86";
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

    propagatedBuildInputs = with self; [ pkgs.xlibs.libX11 ];

    meta = {
      description = "Fully functional X client library for Python programs";

      homepage = http://python-xlib.sourceforge.net/;

      license = stdenv.lib.licenses.gpl2Plus;
    };
  });

  zbase32 = buildPythonPackage (rec {
    name = "zbase32-1.1.2";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zbase32/${name}.tar.gz";
      sha256 = "2f44b338f750bd37b56e7887591bf2f1965bfa79f163b6afcbccf28da642ec56";
    };

    # Tests require `pyutil' so disable them to avoid circular references.
    doCheck = false;

    buildInputs = with self; [ setuptoolsDarcs ];

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
      md5 = "60a107c5857c3877368dfe5930559804";
    };

    propagatedBuildInputs = with self; [ zope_testrunner ];

    meta = {
      description = "Structured Configuration Library";
      homepage = http://pypi.python.org/pypi/ZConfig;
      license = stdenv.lib.licenses.zpt20;
      maintainers = [ stdenv.lib.maintainers.goibhniu ];
    };
  };


  zc_lockfile = buildPythonPackage rec {
    name = "zc.lockfile-${version}";
    version = "1.0.2";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zc.lockfile/${name}.tar.gz";
      md5 = "f099d4cf2583a0c7bea0146a44dc4d59";
    };

    meta = {
      description = "Inter-process locks";
      homepage =  http://www.python.org/pypi/zc.lockfile;
      license = stdenv.lib.licenses.zpt20;
      maintainers = [ stdenv.lib.maintainers.goibhniu ];
    };
  };


  zdaemon = buildPythonPackage rec {
    name = "zdaemon-${version}";
    version = "4.0.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zdaemon/${name}.tar.gz";
      md5 = "4056e2ea35855695ed15389d9c168b92";
    };

    propagatedBuildInputs = [ self.zconfig ];

    # too many deps..
    doCheck = false;

    meta = {
      description = "A daemon process control library and tools for Unix-based systems";
      homepage = http://pypi.python.org/pypi/zdaemon;
      license = stdenv.lib.licenses.zpt20;
      maintainers = [ stdenv.lib.maintainers.goibhniu ];
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

      license = stdenv.lib.licenses.gpl2Plus;
    };
  });

  zodb3 = buildPythonPackage rec {
    name = "zodb3-${version}";
    version = "3.11.0";
    disabled = isPyPy;

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/Z/ZODB3/ZODB3-${version}.tar.gz";
      md5 = "21975c1609296e7834e8cf4025af3039";
    };

    propagatedBuildInputs = with self; [ manuel transaction zc_lockfile zconfig zdaemon zope_interface zope_event BTrees persistent ZEO ];

    meta = {
      description = "An object-oriented database for Python";
      homepage = http://pypi.python.org/pypi/ZODB3;
      license = stdenv.lib.licenses.zpt20;
      maintainers = [ stdenv.lib.maintainers.goibhniu ];
    };
  };

  zodb = buildPythonPackage rec {
    name = "zodb-${version}";
    disabled = isPyPy;

    version = "4.0.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/Z/ZODB/ZODB-${version}.tar.gz";
      md5 = "092d787524b095164231742c96b32f50";
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
      license = stdenv.lib.licenses.zpt20;
      maintainers = [ stdenv.lib.maintainers.goibhniu ];
    };
  };

  zodbpickle = self.buildPythonPackage rec {
    name = "zodbpickle-0.5.2";
    disabled = isPyPy; # https://github.com/zopefoundation/zodbpickle/issues/10

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/z/zodbpickle/${name}.tar.gz";
      md5 = "d401bd89f99ec8d56c22493e6f8c0443";
    };

    # fails..
    doCheck = false;

    meta = with stdenv.lib; {
      homepage = http://pypi.python.org/pypi/zodbpickle;
    };
  };


  BTrees = self.buildPythonPackage rec {
    name = "BTrees-4.0.8";

    patches = [ ./../development/python-modules/btrees_interger_overflow.patch ];

    propagatedBuildInputs = with self; [ persistent zope_interface transaction ];

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/B/BTrees/${name}.tar.gz";
      md5 = "7f5df4cf8dd50fb0c584c0929a406c92";
    };

    meta = with stdenv.lib; {
      description = "scalable persistent components";
      homepage = http://packages.python.org/BTrees;
    };
  };


  persistent = self.buildPythonPackage rec {
    name = "persistent-4.0.8";

    propagatedBuildInputs = with self; [ zope_interface ];

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/persistent/${name}.tar.gz";
      md5 = "2942f1ca7764b1bef8d48fa0d9a236b7";
    };

    meta = with stdenv.lib; {
      description = "automatic persistence for Python objects";
      homepage = http://www.zope.org/Products/ZODB;
    };
  };

  xdot = buildPythonPackage rec {
    name = "xdot-0.6";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/x/xdot/xdot-0.6.tar.gz";
      md5 = "a8e5fc5208657b03ad1bd4c46de75724";
    };

    propagatedBuildInputs = with self; [ pygtk pygobject pkgs.graphviz ];

    meta = with stdenv.lib; {
      description = "xdot.py is an interactive viewer for graphs written in Graphviz's dot";
      homepage = https://github.com/jrfonseca/xdot.py;
      license = licenses.lgpl3Plus;
    };
  };

  zope_broken = buildPythonPackage rec {
    name = "zope.broken-3.6.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.broken/${name}.zip";
      md5 = "eff24d7918099a3e899ee63a9c31bee6";
    };

    buildInputs = with self; [ zope_interface ];

    meta = {
        maintainers = [ stdenv.lib.maintainers.goibhniu ];
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
        maintainers = [ stdenv.lib.maintainers.goibhniu ];
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
      md5 = "81bbe92c1f04725561470f89d73222c5";
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
        maintainers = [ stdenv.lib.maintainers.goibhniu ];
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
        maintainers = [ stdenv.lib.maintainers.goibhniu ];
    };
  };


  zope_container = buildPythonPackage rec {
    name = "zope.container-4.0.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.container/${name}.tar.gz";
      md5 = "b24d2303ece65a2d9ce23a5bd074c335";
    };

    # a test is failing
    doCheck = false;

    propagatedBuildInputs = with self; [
      zodb3 zope_broken zope_dottedname zope_publisher
      zope_filerepresentation zope_lifecycleevent zope_size
      zope_traversing
    ];

    meta = {
        maintainers = [ stdenv.lib.maintainers.goibhniu ];
    };
  };


  zope_contenttype = buildPythonPackage rec {
    name = "zope.contenttype-4.0.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.contenttype/${name}.tar.gz";
      md5 = "171be44753e86742da8c81b3ad008ce0";
    };

    meta = {
        maintainers = [ stdenv.lib.maintainers.goibhniu ];
    };
  };


  zope_dottedname = buildPythonPackage rec {
    name = "zope.dottedname-3.4.6";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.dottedname/${name}.tar.gz";
      md5 = "62d639f75b31d2d864fe5982cb23959c";
    };
    meta = {
        maintainers = [ stdenv.lib.maintainers.goibhniu ];
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
      license = stdenv.lib.licenses.zpt20;
      maintainers = [ stdenv.lib.maintainers.goibhniu ];
    };
  };


  zope_exceptions = buildPythonPackage rec {
     name = "zope.exceptions-${version}";
     version = "4.0.5";

     src = pkgs.fetchurl {
       url = "http://pypi.python.org/packages/source/z/zope.exceptions/${name}.tar.gz";
       md5 = "c95569fcb444ae541777de7ae5297492";
     };

     propagatedBuildInputs = with self; [ zope_interface ];

     meta = {
       description = "Exception interfaces and implementations";
       homepage = http://pypi.python.org/pypi/zope.exceptions;
       license = stdenv.lib.licenses.zpt20;
       maintainers = [ stdenv.lib.maintainers.goibhniu ];
     };
   };


  zope_filerepresentation = buildPythonPackage rec {
    name = "zope.filerepresentation-3.6.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.filerepresentation/${name}.tar.gz";
      md5 = "4a7a434094f4bfa99a7f22e75966c359";
    };

    propagatedBuildInputs = with self; [ zope_schema ];

    meta = {
        maintainers = [ stdenv.lib.maintainers.goibhniu ];
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
        maintainers = [ stdenv.lib.maintainers.goibhniu ];
    };
  };


  zope_i18nmessageid = buildPythonPackage rec {
    name = "zope.i18nmessageid-4.0.3";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.i18nmessageid/zope.i18nmessageid-4.0.3.tar.gz";
      sha256 = "1rslyph0klk58dmjjy4j0jxy21k03azksixc3x2xhqbkv97cmzml";
    };

    meta = {
        maintainers = [ stdenv.lib.maintainers.goibhniu ];
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
        maintainers = [ stdenv.lib.maintainers.goibhniu ];
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
        maintainers = [ stdenv.lib.maintainers.goibhniu ];
    };
  };


  zope_proxy = buildPythonPackage rec {
    name = "zope.proxy-4.1.4";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.proxy/${name}.tar.gz";
      md5 = "3bcaf8b8512a99649ecf2f158c11d05b";
    };

    propagatedBuildInputs = with self; [ zope_interface ];

    meta = {
        maintainers = [ stdenv.lib.maintainers.goibhniu ];
    };
  };


  zope_publisher = buildPythonPackage rec {
    name = "zope.publisher-3.12.6";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.publisher/${name}.tar.gz";
      md5 = "495131970cc7cb14de8e517fb3857ade";
    };

    propagatedBuildInputs = with self; [
      zope_browser zope_contenttype zope_i18n zope_security
    ];

    meta = {
        maintainers = [ stdenv.lib.maintainers.goibhniu ];
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
        maintainers = [ stdenv.lib.maintainers.goibhniu ];
    };
  };


  zope_security = buildPythonPackage rec {
    name = "zope.security-4.0.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.security/${name}.tar.gz";
      md5 = "27d1f2873a0ee9c1f485f7b8f22d8e1c";
    };

    propagatedBuildInputs = with self; [
      zope_component zope_configuration zope_i18nmessageid zope_schema
      zope_proxy zope_testrunner
    ];

    meta = {
      maintainers = [ stdenv.lib.maintainers.goibhniu ];
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
        maintainers = [ stdenv.lib.maintainers.goibhniu ];
    };
  };


  zope_sqlalchemy = buildPythonPackage rec {
    name = "zope.sqlalchemy-0.7.5";

    doCheck = !isPyPy; # https://github.com/zopefoundation/zope.sqlalchemy/issues/12

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.sqlalchemy/${name}.zip";
      md5 = "0a468bd5b8884cd29fb71acbf7eaa31e";
    };

    buildInputs = with self; [ zope_testing zope_interface ];
    propagatedBuildInputs = with self; [ sqlalchemy9 transaction ];

    meta = {
      maintainers = [
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.iElectric
      ];
      platforms = stdenv.lib.platforms.all;
    };
  };


  zope_testing = buildPythonPackage rec {
    name = "zope.testing-${version}";
    version = "4.1.3";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.testing/${name}.tar.gz";
      md5 = "6c73c5b668a67fdc116a25b884058ed9";
    };

    doCheck = !(python.isPypy or false);

    propagatedBuildInputs = with self; [ zope_interface zope_exceptions zope_location ];

    meta = {
      description = "Zope testing helpers";
      homepage =  http://pypi.python.org/pypi/zope.testing;
      license = stdenv.lib.licenses.zpt20;
      maintainers = [ stdenv.lib.maintainers.goibhniu ];
    };
  };


  zope_testrunner = buildPythonPackage rec {
    name = "zope.testrunner-${version}";
    version = "4.4.3";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.testrunner/${name}.zip";
      sha256 = "1dwk35kg0bmj2lzp4fd2bgp6dv64q5sda09bf0y8j63y53vqbsw8";
    };

    propagatedBuildInputs = with self; [ zope_interface zope_exceptions zope_testing six ] ++ optional (!python.is_py3k or false) subunit;

    doCheck = true;

    meta = {
      description = "A flexible test runner with layer support";
      homepage = http://pypi.python.org/pypi/zope.testrunner;
      license = stdenv.lib.licenses.zpt20;
      maintainers = [ stdenv.lib.maintainers.goibhniu ];
    };
  };


  zope_traversing = buildPythonPackage rec {
    name = "zope.traversing-4.0.0";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.traversing/${name}.zip";
      md5 = "5cc40c552f953939f7c597ebbedd586f";
    };

    propagatedBuildInputs = with self; [ zope_location zope_security zope_publisher transaction zope_tales ];

    # circular dependency on zope_browserresource
    doCheck = false;

    meta = {
        maintainers = [ stdenv.lib.maintainers.goibhniu ];
    };
  };


  zope_interface = buildPythonPackage rec {
    name = "zope.interface-4.1.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.interface/${name}.tar.gz";
      md5 = "edcd5f719c5eb2e18894c4d06e29b6c6";
    };

    propagatedBuildInputs = with self; [ zope_event ];

    meta = {
      description = "Zope.Interface";
      homepage = http://zope.org/Products/ZopeInterface;
      license = stdenv.lib.licenses.zpt20;
      maintainers = [ stdenv.lib.maintainers.goibhniu ];
    };
  };

  hgsvn = buildPythonPackage rec {
    name = "hgsvn-0.3.5";
    src = pkgs.fetchurl rec {
      url = "http://pypi.python.org/packages/source/h/hgsvn/${name}.zip";
      sha256 = "043yvkjf9hgm0xzhmwj1qk3fsmbgwm39f4wsqkscib9wfvxs8wbg";
    };
    disabled = isPy3k || isPyPy;

    buildInputs = with self; [ pkgs.setuptools ];
    doCheck = false;

      meta = {
      description = "HgSVN";
      homepage = http://pypi.python.org/pypi/hgsvn;
    };
  };

  cliapp = buildPythonPackage rec {
    name = "cliapp-${version}";
    version = "1.20140719";
    disabled = isPy3k;

    src = pkgs.fetchurl rec {
      url = "http://code.liw.fi/debian/pool/main/p/python-cliapp/python-cliapp_${version}.orig.tar.gz";
      sha256 = "0kxl2q85n4ggvbw2m8crl11x8n637mx6y3a3b5ydw8nhlsiqijgp";
    };

    buildInputs = with self; [ sphinx ];

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://liw.fi/cliapp/;
      description = "Python framework for Unix command line programs";
      maintainers = [ stdenv.lib.maintainers.rickynils ];
    };
  };


  tornado = buildPythonPackage rec {
    name = "tornado-3.2";

    propagatedBuildInputs = with self; [ backports_ssl_match_hostname_3_4_0_2 ];

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/t/tornado/${name}.tar.gz";
      md5 = "bd83cee5f1a5c5e139e87996d00b251b";
    };

    doCheck = false;
  };


  tornadokick = buildPythonPackage rec {
    name = "tornadokick-0.2.1";

    propagatedBuildInputs = with self; [ tornado ];

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/t/tornadokick/${name}.tar.gz";
      md5 = "95ee5a295ce3f361c6f843c4f39cbb8c";
    };

    meta = {
      description = "A Toolkit for the Tornado Web Framework";
      homepage = http://github.com/multoncore/tornadokick;
      license = stdenv.lib.licenses.asl20;
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

    meta = with stdenv.lib; {
      homepage = https://github.com/scs3jb/screenkey;
      description = "A screencast tool to show your keys";
      license = stdenv.lib.licenses.gpl3Plus;
      maintainers = [ maintainers.DamienCassou ];
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


  pyzmq = buildPythonPackage rec {
    name = "pyzmq-13.0.0";
    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyzmq/pyzmq-13.0.0.zip";
      md5 = "fa2199022e54a393052d380c6e1a0934";
    };
    buildInputs = with self; [ pkgs.zeromq3 ];
    doCheck = false;
  };


  tissue = buildPythonPackage rec {
    name = "tissue-0.9.2";
    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/t/tissue/${name}.tar.gz";
      md5 = "87dbcdafff41bfa1b424413f79aa9153";
    };

    buildInputs = with self; [ nose ];
    propagatedBuildInputs = with self; [ pep8 ];

    meta = {
      maintainers = [
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.iElectric
      ];
      platforms = stdenv.lib.platforms.all;
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
      maintainers = [ stdenv.lib.maintainers.rickynils ];
    };
  };

  translationstring = buildPythonPackage rec {
    name = "translationstring-1.1";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/t/translationstring/${name}.tar.gz";
      md5 = "0979b46d8f0f852810c8ec4be5c26cf2";
    };

    meta = {
      maintainers = [
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.iElectric
      ];
      platforms = stdenv.lib.platforms.all;
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
      maintainers = [ stdenv.lib.maintainers.rickynils ];
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
      maintainers = [ stdenv.lib.maintainers.rickynils ];
    };
  };


  websocket_client = buildPythonPackage rec {
    name = "websocket-client-0.17.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/w/websocket-client/${name}.tar.gz";
      md5 = "c86591719085eaf4a01c2275e0c834fc";
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
      md5 = "32749ffadfc40fea51075a7def32588b";
    };

    buildInputs = with self; [ routes markupsafe webob nose ];

    # TODO: failing tests https://bitbucket.org/bbangert/webhelpers/pull-request/1/fix-error-on-webob-123/diff
    doCheck = false;

    meta = {
      maintainers = [
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.iElectric
      ];
      platforms = stdenv.lib.platforms.all;
    };
  };

  whisper = buildPythonPackage rec {
    name = "whisper-${version}";
    version = "0.9.12";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/w/whisper/${name}.tar.gz";
      md5 = "5fac757cc4822ab0678dbe0d781d904e";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = with stdenv.lib; {
      homepage = http://graphite.wikidot.com/;
      description = "Fixed size round-robin style database";
      maintainers = with maintainers; [ rickynils offline ];
    };
  };

  carbon = buildPythonPackage rec {
    name = "carbon-${version}";
    version = "0.9.12";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/c/carbon/${name}.tar.gz";
      md5 = "66967d5a622fd29973838fcd10eb34f3";
    };

    propagatedBuildInputs = with self; [ whisper txamqp zope_interface twisted ];

    # error: invalid command 'test'
    doCheck = false;

    meta = with stdenv.lib; {
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
      md5 = "8148a2493fff78940feab1e11dc0a893";
    };

    meta = {
      homepage = http://pypi.python.org/pypi/ujson;
      description = "Ultra fast JSON encoder and decoder for Python";
      license = licenses.bsd3;
    };
  };


  unidecode = buildPythonPackage rec {
    name = "Unidecode-0.04.12";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/U/Unidecode/${name}.tar.gz";
      md5 = "351dc98f4512bdd2e93f7a6c498730eb";
    };

    meta = {
      homepage = http://pypi.python.org/pypi/Unidecode/;
      description = "ASCII transliterations of Unicode text";
      license = licenses.gpl2;
      maintainers = [ stdenv.lib.maintainers.iElectric ];
    };
  };


  pyusb = buildPythonPackage rec {
    name = "pyusb-1.0.0b1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pyusb/${name}.tar.gz";
      md5 = "5cc9c7dd77b4d12fcc22fee3b39844bc";
    };

    # Fix the USB backend library lookup
    postPatch = ''
      libusb=${pkgs.libusb1}/lib/libusb-1.0.so
      test -f $libusb || { echo "ERROR: $libusb doesn't exist, please update/fix this build expression."; exit 1; }
      sed -i -e "s|libname = .*|libname = \"$libusb\"|" usb/backend/libusb1.py
    '';

    meta = with stdenv.lib; {
      description = "Python USB access module (wraps libusb 1.0)";  # can use other backends
      homepage = http://pyusb.sourceforge.net/;
      license = "BSD";
      maintainers = [ maintainers.bjornfor ];
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
      maintainers = [ maintainers.bjornfor ];
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
      maintainers = [ stdenv.lib.maintainers.rickynils ];
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

  graphite_web = buildPythonPackage rec {
    name = "graphite-web-${version}";
    version = "0.9.12";

    src = pkgs.fetchurl rec {
      url = "https://pypi.python.org/packages/source/g/graphite-web/${name}.tar.gz";
      md5 = "8edbb61f1ffe11c181bd2cb9ec977c72";
    };

    propagatedBuildInputs = with self; [ django_1_3 django_tagging modules.sqlite3 whisper pkgs.pycairo ldap memcached ];

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

    meta = with stdenv.lib; {
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
      description = "Graphite-web, without the interface. Just the rendering HTTP API.";
      homepage = https://github.com/brutasse/graphite-api;
      license = licenses.asl20;
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
      maintainers = [ maintainers.offline ];
      license = licenses.bsd2;
    };
  };


  pyspotify = buildPythonPackage rec {
    name = "pyspotify-${version}";

    version = "1.11";

    src = pkgs.fetchurl {
      url = "https://github.com/mopidy/pyspotify/archive/v1.11.tar.gz";
      sha256 = "089ml6pqr3f2d15n70jpzbaqjp5pjgqlyv4algkxw92xscjw2izg";
    };

    buildInputs = with self; [ pkgs.libspotify ]
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

    meta = with stdenv.lib; {
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

    meta = with stdenv.lib; {
      homepage = http://www.pykka.org;
      description = "A Python implementation of the actor model";
      maintainers = [ maintainers.rickynils ];
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
      maintainers = [ stdenv.lib.maintainers.rickynils ];
    };
  };

  gdata = buildPythonPackage rec {
    name = "gdata-${version}";
    version = "2.0.17";

    src = pkgs.fetchurl {
      url = "https://gdata-python-client.googlecode.com/files/${name}.tar.gz";
      # sha1 = "d2d9f60699611f95dd8c328691a2555e76191c0c";
      sha256 = "0bdaqmicpbj9v3p0swvyrqs7m35bzwdw1gy56d3k09np692jfwmd";
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
    disabled = isPy34;

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
    version = "0.4.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/L/Logbook/${name}.tar.gz";
      # md5 = "143cb15af4c4a784ca785a1546ad1b93";
      sha256 = "1g2pnhxh7m64qsrs0ifwcmpfk7gqjvrawd8z66i001rsdnq778v0";
    };

    meta = {
      homepage = http://pythonhosted.org/Logbook/;
      description = "A logging replacement for Python";
      license = licenses.bsd3;
    };
  };

  libvirt = pkgs.stdenv.mkDerivation rec {
    name = "libvirt-python-${version}";
    version = "1.2.9";

    src = pkgs.fetchurl {
      url = "http://libvirt.org/sources/python/${name}.tar.gz";
      sha256 = "1vbrkwvsvcfgibdw4drcypg2n6zcpi3zv23zw20nkk5fjfp26w4g";
    };

    buildInputs = with self; [ python pkgs.pkgconfig pkgs.libvirt lxml ];

    buildPhase = "python setup.py build";

    installPhase = "python setup.py install --prefix=$out";

    meta = {
      homepage = http://www.libvirt.org/;
      description = "libvirt Python bindings";
      license = pkgs.lib.licenses.lgpl2;
    };
  };

  searx = buildPythonPackage rec {
    name = "searx-${rev}";
    rev = "44d3af9fb2482cd0df1a8ababbe2fdf27ab33172";

    src = pkgs.fetchgit {
      url = "git://github.com/asciimoo/searx";
      inherit rev;
      sha256 = "1w505pzdkkcglq782wg7f5fxrw9i5jzp7px20c2xz18pps2m3rsm";
    };

    propagatedBuildInputs = with self; [ pyyaml lxml grequests flaskbabel flask requests
      gevent speaklater Babel pytz dateutil ];

    meta = {
      homepage = https://github.com/asciimoo/searx;
      description = "A privacy-respecting, hackable metasearch engine";
      license = stdenv.lib.licenses.agpl3Plus;
      maintainers = [ stdenv.lib.maintainers.matejc ];
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
      description = "GRequests allows you to use Requests with Gevent to make asynchronous HTTP Requests easily.";
      homepage = https://github.com/kennethreitz/grequests;
      license = "bsd";
      maintainers = [ stdenv.lib.maintainers.matejc ];
    };
  };

  flaskbabel = buildPythonPackage rec {
    name = "Flask-Babel-0.9";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/F/Flask-Babel/${name}.tar.gz";
      sha256 = "0k7vk4k54y55ma0nx2k5s0phfqbriwslhy5shh3b0d046q7ibzaa";
    };

    buildInputs = with self; [ flask jinja2 speaklater Babel pytz ];

    meta = {
      description = "Adds i18n/l10n support to Flask applications";
      homepage = https://github.com/mitsuhiko/flask-babel;
      license = "bsd";
      maintainers = [ stdenv.lib.maintainers.matejc ];
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
      maintainers = [ stdenv.lib.maintainers.matejc ];
    };
  };

  pushbullet = buildPythonPackage rec {
    name = "pushbullet.py-${version}";
    version = "0.5.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pushbullet.py/pushbullet.py-0.5.0.tar.gz";
      md5 = "36c83ba5f7d5208bb86c00eba633f921";
    };

    propagatedBuildInputs = with self; [requests websocket_client python_magic ];
  };

  power = buildPythonPackage rec {
    name = "power-1.2";

    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/p/power/${name}.tar.gz";
      sha256 = "09a00af8357f63dbb1a1eb13b82e39ccc0a14d6d2e44e5b235afe60ce8ee8195";
    };

    meta = {
      description = "Cross-platform system power status information";
      homepage = https://github.com/Kentzo/Power;
      license = stdenv.lib.licenses.mit;
    };
  };

  udiskie = buildPythonPackage rec {
    version = "1.1.2";
    name = "udiskie-${version}";

    src = pkgs.fetchurl {
      url = "https://github.com/coldfix/udiskie/archive/${version}.tar.gz";
      sha256 = "07fyvwp4rga47ayfsmb79p2784sqrih0sglwnd9c4x6g63xgljvb";
    };

    preConfigure = ''
      export XDG_RUNTIME_DIR=/tmp
    '';

    propagatedBuildInputs = with self; [ pkgs.gobjectIntrospection pkgs.gtk3 pyyaml pygobject3 pkgs.libnotify pkgs.udisks2 pkgs.gettext self.docopt ];

    preFixup = ''
        wrapProgram $out/bin/* \
          --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH"
    '';

    # tests require dbusmock
    doCheck = false;

    meta = with stdenv.lib; {
      description = "Removable disk automounter for udisks";
      license = licenses.mit;
      homepage = https://github.com/coldfix/udiskie;
      maintainers = [ maintainers.AndersonTorres ];
    };
  };

  pythonefl_1_12 = buildPythonPackage rec {
    name = "python-efl-${version}";
    version = "1.12.0";
    src = pkgs.fetchurl {
      url = "http://download.enlightenment.org/rel/bindings/python/${name}.tar.gz";
      sha256 = "0rxv5nrqg5c2l93ns2k6gjil1y7qq6amfh5slkarm3kv8fzk17xv";
    };
    preConfigure = ''
      export NIX_CFLAGS_COMPILE="-I${pkgs.e19.efl}/include/eo-1 -I${pkgs.e19.efl}/include/eina-1 -I${pkgs.e19.efl}/include/eina-1/eina -I${pkgs.e19.efl}/include/evas-1 -I${self.dbus}/include/dbus-1.0 -I${pkgs.e19.efl}/include/efl-1 -I${pkgs.e19.efl}/include/eet-1 -I${pkgs.e19.efl}/include/ecore-1 -I${pkgs.e19.efl}/include/ecore-evas-1 -I${pkgs.e19.efl}/include/ecore-file-1 -I${pkgs.e19.efl}/include/ecore-input-1 -I${pkgs.e19.efl}/include/ecore-imf-1 -I${pkgs.e19.efl}/include/ecore-con-1 -I${pkgs.e19.efl}/include/edje-1 -I${pkgs.e19.efl}/include/eldbus-1 -I${pkgs.e19.efl}/include/efreet-1 -I${pkgs.e19.efl}/include/ethumb-client-1 -I${pkgs.e19.efl}/include/ethumb-1 -I${pkgs.e19.efl}/include/ecore-x-1 $NIX_CFLAGS_COMPILE"
    '';
    buildInputs = with self; [ pkgs.pkgconfig pkgs.e19.efl pkgs.e19.elementary ];
    meta = {
      description = "Python bindings for EFL and Elementary.";
      homepage = http://enlightenment.org/;
      maintainers = [ stdenv.lib.maintainers.matejc ];
      platforms = stdenv.lib.platforms.linux;
      license = stdenv.lib.licenses.gpl3;
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
      maintainers = [ stdenv.lib.maintainers.tstrobel ];
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
      maintainers = [ stdenv.lib.maintainers.tstrobel ];
    };
  };



# python2.7 specific packages
} // optionalAttrs isPy27 (
  with self;

{
  boto-230 = buildPythonPackage rec {
    name = "boto-2.30.0";
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
    src = pkgs.fetchurl {
      url = https://pypi.python.org/packages/source/g/gcs-oauth2-boto-plugin/gcs-oauth2-boto-plugin-1.8.tar.gz;
      sha256 = "0jy62y5bmaf1mb735lqwry1s5nx2qqrxvl5sxip9yg4miih3qkyb";
    };
    propagatedBuildInputs = with self; [ boto-230 httplib2 google_api_python_client retry_decorator pkgs.pyopenssl socksipy-branch ];
    meta = {
      homepage = https://developers.google.com/storage/docs/gspythonlibrary;
      description = "Provides OAuth 2.0 credentials that can be used with Google Cloud Storage";
      license = stdenv.lib.licenses.asl20;
    };
  };

  gsutil = buildPythonPackage rec {
    name = "gsutil-4.6";
    meta = {
      homepage = https://developers.google.com/storage/docs/gsutil;
      description = "Google Cloud Storage Tool";
      maintainers = [ "Russell O'Connor <oconnorr@google.com>" ];
      license = stdenv.lib.licenses.asl20;
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

    src = pkgs.fetchurl {
      url = "https://github.com/garbas/pypi2nix/tarball/${rev}";
      name = "${name}.tar.bz";
      sha256 = "1fv85x2bz442iyxsvka2g75zibjcq48gp2fc7szaqcfqxq42syy9";
    };

    doCheck = false;

    meta = {
      homepage = https://github.com/garbas/pypi2nix;
      description = "";
      maintainers = [ pkgs.stdenv.lib.maintainers.garbas ];
    };
  };

  svg2tikz = self.buildPythonPackage {
    name = "svg2tikz-1.0.0";

    propagatedBuildInputs = with self; [lxml];

    src = pkgs.fetchgit {
      url = "https://github.com/kjellmf/svg2tikz";
      sha256 = "429428ec435e53672b85cdfbb89bb8af0ff9f8238f5d05970729e5177d252d5f";
      rev = "ad36f2c3818da13c4136d70a0fd8153acf8daef4";
    };

    meta = {
      homepage = https://github.com/kjellmf/svg2tikz;
      description = "An SVG to TikZ converter";
      license = stdenv.lib.licenses.gpl2Plus;
      maintainers =  with pkgs.stdenv.lib.maintainers; [gal_bolle];
    };
  };

  thumbor = self.buildPythonPackage rec {
    name = "thumbor-4.0.4";

    propagatedBuildInputs = with self; [
                    tornado
                    pycrypto
                    pycurl
                    pillow
                    derpconf
                    python_magic
                    thumborPexif
                    (pkgs.opencv.override {
                        gtk = null;
                        glib = null;
                        xineLib = null;
                        gstreamer = null;
                        ffmpeg = null;
                    }) ];

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/t/thumbor/${name}.tar.gz";
      md5 = "cf639a1cc57ee287b299ace450444408";
    };

    meta = {
      description = "Thumbor is a smart imaging service. It enables on-demand crop, resizing and flipping of images.";
      homepage = https://github.com/globocom/thumbor/wiki;
      license = licenses.mit;
    };
  };

  thumborPexif = self.buildPythonPackage rec {
    name = "thumbor-pexif-0.14";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/t/thumbor-pexif/${name}.tar.gz";
      md5 = "fb4cdb60f4a0bead5193fb483ccd3430";
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

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/${baseName}/${name}.tar.gz";
      md5 = "5cc79077f386a17b539f1e51c05a3650";
    };

    buildInputs = with self; [ pkgs.coreutils ];

    propagatedBuildInputs = with self; [ dateutil ];

    preInstall = stdenv.lib.optionalString stdenv.isDarwin ''
      sed -i 's|^\([ ]*\)self.bin_path.*$|\1self.bin_path = "${pkgs.rubyLibs.terminal_notifier}/bin/terminal-notifier"|' build/lib/pync/TerminalNotifier.py
    '';

    meta = with stdenv.lib; {
      description = "Python Wrapper for Mac OS 10.8 Notification Center";
      homepage    = https://pypi.python.org/pypi/pync/1.4;
      license     = licenses.mit;
      platforms   = platforms.darwin;
      maintainers = [ maintainers.lovek323 ];
    };
  };

  weboob = buildPythonPackage rec {
    name = "weboob-1.0";

    src = pkgs.fetchurl {
      url = "https://symlink.me/attachments/download/289/${name}.tar.gz";
      md5 = "38f832f1b8654441adafe8558faa7109";
    };

    setupPyBuildFlags = ["--qt" "--xdg"];

    propagatedBuildInputs = with self; [ pillow prettytable pyyaml dateutil gdata requests2 mechanize feedparser lxml pkgs.gnupg pyqt4 pkgs.libyaml simplejson cssselect futures ];

    meta = {
      homepage = http://weboob.org;
      description = "Collection of applications and APIs to interact with websites without requiring the user to open a browser";
      license = stdenv.lib.licenses.agpl3;
      maintainers = [ stdenv.lib.maintainers.DamienCassou ];
    };
  };

  datadiff = buildPythonPackage rec {
    name = "datadiff-1.1.6";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/d/datadiff/datadiff-1.1.6.zip";
      md5 = "c34a690db75eead148aa5fa89e575d1e";
    };

    buildInputs = with self; [ nose ];

    meta = with stdenv.lib; {
      description = "DataDiff";
      homepage = http://sourceforge.net/projects/datadiff/;
      license = licenses.asl20;
    };
  };

  termcolor = buildPythonPackage rec {
    name = "termcolor-1.1.0";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/t/termcolor/termcolor-1.1.0.tar.gz";
      md5 = "043e89644f8909d462fbbfa511c768df";
    };

    meta = with stdenv.lib; {
      description = "Termcolor";
      homepage = http://pypi.python.org/pypi/termcolor;
      license = licenses.mit;
    };
  };

}); in pythonPackages
