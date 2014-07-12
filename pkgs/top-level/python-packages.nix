{ pkgs, python }:
  with pkgs.lib;

let
  isPy26 = python.majorVersion == "2.6";
  isPy27 = python.majorVersion == "2.7";
  isPy33 = python.majorVersion == "3.3";
  isPy34 = python.majorVersion == "3.4";
  isPyPy = python.executable == "pypy";

  # Unique python version identifier
  pythonName =
    if isPy26 then "python26" else
    if isPy27 then "python27" else
    if isPy33 then "python33" else
    if isPy34 then "python34" else
    if isPyPy then "pypy" else "";

  modules = python.modules or { readline = null; sqlite3 = null; curses = null; curses_panel = null; ssl = null; crypt = null; };

pythonPackages = modules // import ./python-packages-generated.nix {
  inherit pkgs python;
  inherit (pkgs) stdenv fetchurl;
  self = pythonPackages;
} //

# Python packages for all python versions
rec {

  inherit python isPy26 isPy27 isPy33 isPy34 isPyPy pythonName;
  inherit (pkgs) fetchurl fetchsvn fetchgit stdenv unzip;

  # helpers

  callPackage = callPackageWith (pkgs // pythonPackages);

  # global distutils config used by buildPythonPackage
  distutils-cfg = callPackage ../development/python-modules/distutils-cfg { };

  buildPythonPackage = callPackage ../development/python-modules/generic { };

  wrapPython = pkgs.makeSetupHook
    { deps = pkgs.makeWrapper;
      substitutions.libPrefix = python.libPrefix;
      substitutions.executable = "${python}/bin/${python.executable}";
    }
   ../development/python-modules/generic/wrap.sh;

  # specials

  recursivePthLoader = import ../development/python-modules/recursive-pth-loader {
    inherit (pkgs) stdenv;
    inherit python;
  };

  setuptools = import ../development/python-modules/setuptools {
    inherit (pkgs) stdenv fetchurl;
    inherit python wrapPython distutils-cfg;
  };

  # packages defined elsewhere

  blivet = callPackage ../development/python-modules/blivet { };

  dbus = import ../development/python-modules/dbus {
    inherit (pkgs) stdenv fetchurl pkgconfig dbus dbus_glib dbus_tools;
    inherit python;
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

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/d/discid/${name}.tar.gz";
      md5 = "2ad2141452dd10b03ad96ccdad075235";
    };

    patchPhase = ''
      substituteInPlace discid/libdiscid.py \
        --replace '_open_library(_LIB_NAME)' "_open_library('${pkgs.libdiscid}/lib/libdiscid.so.0')"
    '';
  };

  ipython = import ../shells/ipython {
    inherit (pkgs) stdenv fetchurl sip pyqt4;
    inherit buildPythonPackage pythonPackages;
    qtconsoleSupport = !pkgs.stdenv.isDarwin; # qt is not supported on darwin
    pylabQtSupport = !pkgs.stdenv.isDarwin;
    pylabSupport = !pkgs.stdenv.isDarwin; # cups is not supported on darwin
  };

  ipythonLight = lowPrio (import ../shells/ipython {
    inherit (pkgs) stdenv fetchurl;
    inherit buildPythonPackage pythonPackages;
    qtconsoleSupport = false;
    pylabSupport = false;
    pylabQtSupport = false;
  });

  nixpart = callPackage ../tools/filesystems/nixpart { };

  # This is used for NixOps to make sure we won't break it with the next major
  # version of nixpart.
  nixpart0 = nixpart;

  pil = import ../development/python-modules/pil {
    inherit (pkgs) fetchurl stdenv libjpeg zlib freetype;
    inherit python buildPythonPackage;
  };

  pitz = import ../applications/misc/pitz {
    inherit (pkgs) stdenv fetchurl;
    inherit buildPythonPackage tempita jinja2 pyyaml clepy mock nose decorator docutils;
  };

  pycairo = import ../development/python-modules/pycairo {
    inherit (pkgs) stdenv fetchurl fetchpatch pkgconfig cairo x11;
    inherit python;
  };

  pycrypto = import ../development/python-modules/pycrypto {
    inherit (pkgs) fetchurl stdenv gmp;
    inherit python buildPythonPackage;
  };

  pygobject = import ../development/python-modules/pygobject {
    inherit (pkgs) stdenv fetchurl pkgconfig glib;
    inherit python;
  };

  pygobject3 = import ../development/python-modules/pygobject/3.nix {
    inherit (pkgs) stdenv fetchurl pkgconfig glib gobjectIntrospection cairo;
    inherit python pycairo;
  };

  pygtk = import ../development/python-modules/pygtk {
    inherit (pkgs) fetchurl stdenv pkgconfig gtk;
    inherit python buildPythonPackage pygobject pycairo;
  };

  # XXX: how can we get an override here?
  #pyGtkGlade = pygtk.override {
  #  inherit (pkgs.gnome) libglade;
  #};
  pyGtkGlade = import ../development/python-modules/pygtk {
    inherit (pkgs) fetchurl stdenv pkgconfig gtk;
    inherit (pkgs.gnome) libglade;
    inherit python buildPythonPackage pygobject pycairo;
  };

  pyqt4 = import ../development/python-modules/pyqt/4.x.nix {
    inherit (pkgs) stdenv fetchurl pkgconfig qt4 makeWrapper;
    inherit (pkgs.xorg) lndir;
    inherit python sip;
    pythonDBus = dbus;
  };

  sip = import ../development/python-modules/sip {
    inherit (pkgs) stdenv fetchurl;
    inherit python;
  };

  tables = import ../development/python-modules/tables {
    inherit (pkgs) stdenv fetchurl bzip2 lzo;
    inherit python buildPythonPackage cython numpy numexpr;
    hdf5 = pkgs.hdf5.override { zlib = pkgs.zlib; };
  };

  # packages defined here

  aafigure = buildPythonPackage rec {
    name = "aafigure-0.5";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/a/aafigure/${name}.tar.gz";
      md5 = "5322888a21eb0bb2e749fbf98eddf574";
    };

    propagatedBuildInputs = [ pillow ];

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
    name = "actdiag-0.5.1";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/a/actdiag/${name}.tar.gz";
      md5 = "171c47bc1f70e5fadfffd9df0c3157be";
    };

    buildInputs = [ pep8 nose unittest2 docutils ];

    propagatedBuildInputs = [ blockdiag ];

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

    src = fetchurl {
      url = "https://github.com/teythoon/afew/tarball/${rev}";
      name = "${name}.tar.bz";
      sha256 = "1qyban022aji2hl91dh0j3xa6ikkxl5argc6w71yp2x8b02kp3mf";
    };

    buildInputs = [ pkgs.dbacl ];

    propagatedBuildInputs = [
      pythonPackages.notmuch
      pythonPackages.subprocess32
      pythonPackages.chardet
    ];

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
      description = "afew is an initial tagging script for notmuch mail.";
      maintainers = [ stdenv.lib.maintainers.garbas ];
    };
  };


  alembic = buildPythonPackage rec {
    name = "alembic-0.6.0";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/a/alembic/${name}.tar.gz";
      md5 = "084fe81b48ebae43b0f6031af68a03d6";
    };

    buildInputs = [ nose ];
    propagatedBuildInputs = [ Mako sqlalchemy ];

    meta = {
      homepage = http://bitbucket.org/zzzeek/alembic;
      description = "A database migration tool for SQLAlchemy.";
      license = stdenv.lib.licenses.mit;
    };
  };


  almir = buildPythonPackage rec {
    name = "almir-0.1.8";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/a/almir/${name}.zip";
      md5 = "9a1f3c72a039622ca72b74be7a1cd37e";
    };

    buildInputs = [
      pkgs.which
      pythonPackages.coverage
      pythonPackages.mock
      pythonPackages.tissue
      pythonPackages.unittest2
      pythonPackages.webtest
    ];

    propagatedBuildInputs = [
      pkgs.makeWrapper
      pkgs.bacula
      pythonPackages.colander
      pythonPackages.deform
      pythonPackages.deform_bootstrap
      pythonPackages.docutils
      pythonPackages.nose
      pythonPackages.mysql_connector_repackaged
      pythonPackages.pg8000
      pythonPackages.pyramid
      pythonPackages.pyramid_beaker
      pythonPackages.pyramid_exclog
      pythonPackages.pyramid_jinja2
      pythonPackages.pyramid_tm
      pythonPackages.pytz
      pythonPackages.sqlalchemy
      pythonPackages.transaction
      pythonPackages.waitress
      pythonPackages.webhelpers
      pythonPackages.zope_sqlalchemy
      pythonPackages.psycopg2
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

    src = fetchurl {
      url = "https://github.com/pazz/alot/tarball/${rev}";
      name = "${name}.tar.bz";
      sha256 = "0h11lqyxg0xbkc9y1xqjvd0kmfm5pdwnmv9chmlsi1614dxn08n0";
    };

    # error: invalid command 'test'
    doCheck = false;

    propagatedBuildInputs =
      [ pythonPackages.notmuch
        pythonPackages.urwid
        pythonPackages.twisted
        pythonPackages.magic
        pythonPackages.configobj
        pythonPackages.pygpgme
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
    name = "anyjson-0.3.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/a/anyjson/${name}.tar.gz";
      md5 = "2b53b5d53fc40af4da7268d3c3e35a50";
    };

    buildInputs = [ pythonPackages.nose ];

    meta = {
      homepage = http://pypi.python.org/pypi/anyjson/;
      description = "Wrapper that selects the best available JSON implementation";
    };
  };


  amqplib = buildPythonPackage rec {
    name = "amqplib-0.6.1";

    src = fetchurl {
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


  apsw = buildPythonPackage rec {
    name = "apsw-3.7.6.2-r1";

    src = fetchurl {
      url = "http://apsw.googlecode.com/files/${name}.zip";
      sha1 = "fa4aec08e59fa5964197f59ba42408d64031675b";
    };

    buildInputs = [ pkgs.sqlite ];

    # python: double free or corruption (fasttop): 0x0000000002fd4660 ***
    doCheck = false;

    meta = {
      description = "A Python wrapper for the SQLite embedded relational database engine";
      homepage = http://code.google.com/p/apsw/;
    };
  };


  area53 = buildPythonPackage (rec {
    name = "area53-b2c9cdcabd";

    src = fetchgit {
      url = git://github.com/bigmlcom/Area53.git;
      rev = "b2c9cdcabd";
      sha256 = "b0c12b8c48ed9180c7475fab18de50d63e1b517cfb46da4d2c66fc406fe902bc";
    };

    # error: invalid command 'test'
    doCheck = false;

    propagatedBuildInputs = [ pythonPackages.boto ];

  });


  async = buildPythonPackage rec {
    name = "async-0.6.1";
    meta.maintainers = [ stdenv.lib.maintainers.mornfall ];

    buildInputs = [ pkgs.zlib ];
    doCheck = false;

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/a/async/${name}.tar.gz";
      sha256 = "1lfmjm8apy9qpnpbq8g641fd01qxh9jlya5g2d6z60vf8p04rla1";
    };
  };

  argparse = buildPythonPackage (rec {
    name = "argparse-1.2.1";

    src = fetchurl {
      url = "http://argparse.googlecode.com/files/${name}.tar.gz";
      sha256 = "192174mys40m0bwk6l5jlfnzps0xi81sxm34cqms6dc3c454pbyx";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://code.google.com/p/argparse/;

      license = "Apache License 2.0";

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
    name = "astroid-1.1.1";
    propagatedBuildInputs = [ logilab_common ];
    src = fetchurl {
      url = "https://pypi.python.org/packages/source/a/astroid/${name}.tar.gz";
      sha256 = "1x7103mlzndgg66yas6xrfwkwpihcq4bi9m8py1fjnhz8p5ka1vq";
    };
  });

  autopep8 = buildPythonPackage (rec {
    name = "autopep8-1.0";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/a/autopep8/${name}.tar.gz";
      md5 = "41782e66efcbaf9d761bb45a2d2929bb";
    };

    propagatedBuildInputs = [ pep8 ];

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

    src = fetchurl {
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

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/a/avro3k/${name}.tar.gz";
      sha256 = "15ahl0irwwj558s964abdxg4vp6iwlabri7klsm2am6q5r0ngsky";
    };

    doCheck = false;        # No such file or directory: './run_tests.py

    meta = with stdenv.lib; {
      description = "A serialization and RPC framework";
      homepage = "https://pypi.python.org/pypi/avro3k/";
    };
  }));

  backports_ssl_match_hostname_3_4_0_2 = pythonPackages.buildPythonPackage rec {
    name = "backports.ssl_match_hostname-3.4.0.2";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/b/backports.ssl_match_hostname/backports.ssl_match_hostname-3.4.0.2.tar.gz";
      md5 = "788214f20214c64631f0859dc79f23c6";
    };

    meta = {
      description = "The Secure Sockets layer is only actually *secure*";
      homepage = http://bitbucket.org/brandon/backports.ssl_match_hostname;
    };
  };

  bcdoc = buildPythonPackage rec {
    name = "bcdoc-0.12.1";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/b/bcdoc/bcdoc-0.12.1.tar.gz";
      md5 = "7c8617347c294ea4d36ec73fb5b2c26e";
    };

    buildInputs = [ pythonPackages.docutils pythonPackages.six ];

    meta = {
      homepage = https://github.com/botocore/bcdoc;
      license = "Apache License 2.0";
      description = "ReST document generation tools for botocore";
    };
  };

  beautifulsoup = buildPythonPackage (rec {
    name = "beautifulsoup-3.2.1";

    src = fetchurl {
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

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/b/beautifulsoup4/${name}.tar.gz";
      md5 = "c012adc06217b8532c446d181cc56586";
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

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/B/Beaker/${name}.tar.gz";
      md5 = "c2e102870ed4c53104dec48ceadf8e9d";
    };

    buildInputs =
      [ pythonPackages.sqlalchemy
        pythonPackages.pycryptopp
        pythonPackages.nose
        pythonPackages.mock
        pythonPackages.webtest
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
    name = "bedup-20140206";

    src = fetchgit {
      url = "https://github.com/g2p/bedup.git";
      rev = "80cb217d4819a03e159e42850a9a3f14e2b278a3";
      sha256 = "1rik7a62v708ivfcy0pawhfnrb84b7gm3qr54x6jsxl0iqz078h6";
    };

    buildInputs = [ pkgs.btrfsProgs ];
    propagatedBuildInputs = with pkgs; [ contextlib2 sqlalchemy pyxdg pycparser cffi alembic ];

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

  beets = buildPythonPackage rec {
    name = "beets-1.3.6";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/b/beets/${name}.tar.gz";
      md5 = "59615a54b3ac3983159e77ff9dda373e";
    };

    # tests depend on $HOME setting
    preConfigure = "export HOME=$TMPDIR";

    propagatedBuildInputs =
      [ pythonPackages.pyyaml
        pythonPackages.unidecode
        pythonPackages.mutagen
        pythonPackages.munkres
        pythonPackages.musicbrainzngs
        pythonPackages.enum34
        pythonPackages.pylast
        pythonPackages.rarfile
        pythonPackages.flask
        modules.sqlite3
        modules.readline
      ];
      
    buildInputs = with pythonPackages; [ mock pyechonest six responses nose ];
    
    # 10 tests are failing
    doCheck = false;

    meta = {
      homepage = http://beets.radbox.org;
      description = "Music tagger and library organizer";
      license = licenses.mit;
      maintainers = [ stdenv.lib.maintainers.iElectric ];
    };
  };
  
  responses = pythonPackages.buildPythonPackage rec {
    name = "responses-0.2.2";

    propagatedBuildInputs = with pythonPackages; [ requests mock six pytest flake8 ];
    
    doCheck = false;

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/r/responses/responses-0.2.2.tar.gz";
      md5 = "5d79fd425cf8d858dfc8afa6475395d3";
    };

  };
 
  rarfile = pythonPackages.buildPythonPackage rec {
    name = "rarfile-2.6";

    propagatedBuildInputs = with pythonPackages; [  ];

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/r/rarfile/rarfile-2.6.tar.gz";
      md5 = "50ce3f3fdb9196a00059a5ea7b3739fd";
    };

    meta = with stdenv.lib; {
      description = "rarfile - RAR archive reader for Python";
      homepage = https://github.com/markokr/rarfile;
    };
  };
  
  pyechonest = pythonPackages.buildPythonPackage rec {
    name = "pyechonest-8.0.2";

    propagatedBuildInputs = with pythonPackages; [  ];

    src = fetchurl {
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

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/b/bitbucket-api/${name}.tar.gz";
      md5 = "6f3cee3586c4aad9c0b2e04fce9704fb";
    };

    propagatedBuildInputs = [ requests_oauth2 nose sh ];

    doCheck = false;

    meta = {
      homepage = https://github.com/Sheeprider/BitBucket-api;
      description = "Python library to interact with BitBucket REST API";
      license = licenses.mit;
    };
  };

  bitbucket-cli = buildPythonPackage rec {
    name = "bitbucket-cli-0.4.1";
    src = fetchurl {
       url = "https://pypi.python.org/packages/source/b/bitbucket-cli/${name}.tar.gz";
       md5 = "79cdbdc6c95dfa313d12cbdef406c9f2";
    };

    pythonPath = [ requests ];

    meta = with stdenv.lib; {
      description = "Bitbucket command line interface";
      homepage = "https://bitbucket.org/zhemao/bitbucket-cli";
      maintainers = [ maintainers.refnil ];
    };
  };


  bitstring = buildPythonPackage rec {
    name = "bitstring-3.1.2";

    src = fetchurl {
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


  blockdiag = buildPythonPackage rec {
    name = "blockdiag-1.3.2";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/b/blockdiag/${name}.tar.gz";
      md5 = "602a8750f312eeee84d6d138055dfae7";
    };

    buildInputs = [ pep8 nose unittest2 docutils ];

    propagatedBuildInputs = [ pillow webcolors funcparserlib ];

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
     src = fetchurl {
       url = "http://www.bpython-interpreter.org/releases/bpython-0.12.tar.gz";
       sha256 = "1ilf58qq7sazmcgg4f1wswbhcn2gb8qbbrpgm6gf0j2lbm60gabl";
     };

     propagatedBuildInputs = [ modules.curses pygments ];
     doCheck = false;

     meta = {
       description = "UNKNOWN";
       homepage = "UNKNOWN";
       maintainers = [
         stdenv.lib.maintainers.iElectric
       ];
     };
   };


  # euca2ools (and maybe Nova) needs boto 1.9, 2.0 doesn't work.
  boto_1_9 = buildPythonPackage (rec {
    name = "boto-1.9b";

    src = fetchurl {
      url = "http://boto.googlecode.com/files/${name}.tar.gz";
      sha1 = "00a033b0a593c3ca82927867950f73d88b831155";
    };

    patches = [ ../development/python-modules/boto-1.9-python-2.7.patch ];

    meta = {
      homepage = http://code.google.com/p/boto/;

      license = "bsd";

      description = "Python interface to Amazon Web Services";

      longDescription = ''
        The boto module is an integrated interface to current and
        future infrastructural services offered by Amazon Web
        Services.  This includes S3, SQS, EC2, among others.
      '';
    };
  });


  boto = buildPythonPackage rec {
    name = "boto-${version}";
    version = "2.9.9";

    src = fetchurl {
      url = "https://github.com/boto/boto/archive/${version}.tar.gz";
      sha256 = "18wqpzd1zf8nivcn2rl1wnladf7hhyy5p75b5l6kafynm4l9j6jq";
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
    version = "0.33.0";
    name = "botocore-${version}";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/b/botocore/${name}.tar.gz";
      md5 = "6743c73a2e148abaa9c487a6e2ee53a3";
    };

    propagatedBuildInputs =
      [ pythonPackages.dateutil
        pythonPackages.requests
        pythonPackages.jmespath
      ];

    meta = {
      homepage = https://github.com/boto/botocore;

      license = "bsd";

      description = "A low-level interface to a growing number of Amazon Web Services";

    };
  };


  # bugz = buildPythonPackage (rec {
  #   name = "bugz-0.9.3";
  #
  #   src = fetchgit {
  #     url = "https://github.com/williamh/pybugz.git";
  #     rev = "refs/tags/0.9.3";
  #   };
  #
  #   propagatedBuildInputs = [ pythonPackages.argparse modules.ssl ];
  #
  #   doCheck = false;
  #
  #   meta = {
  #     homepage = http://www.liquidx.net/pybugz/;
  #     description = "Command line interface for Bugzilla";
  #   };
  # });


  buildout = zc_buildout;
  buildout152 = zc_buildout152;

  # A patched version of buildout, useful for buildout based development on Nix
  zc_buildout_nix = callPackage ../development/python-modules/buildout-nix { };

  zc_recipe_egg = zc_recipe_egg_buildout171;
  zc_buildout = zc_buildout171;
  zc_buildout2 = zc_buildout221;
  zc_buildout221 = buildPythonPackage rec {
    name = "zc.buildout-2.2.1";

    src = fetchurl {
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

    src = fetchurl {
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

    src = fetchurl {
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

    buildInputs = [ buildout ];
    doCheck = false;

    src = fetchurl {
      inherit md5;
      url = "https://pypi.python.org/packages/source/z/zc.recipe.egg/zc.recipe.egg-${version}.tar.gz";
    };
  };
  zc_recipe_egg_buildout171 = zc_recipe_egg_fun {
    buildout = zc_buildout171;
    version = "1.3.2";
    md5 = "1cb6af73f527490dde461d3614a36475";
  };
  zc_recipe_egg_buildout2 = zc_recipe_egg_fun {
    buildout = zc_buildout2;
    version = "2.0.1";
    md5 = "5e81e9d4cc6200f5b1abcf7c653dd9e3";
  };

  bunch = buildPythonPackage (rec {
    name = "bunch-1.0.1";
    meta.maintainers = [ stdenv.lib.maintainers.mornfall ];

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/b/bunch/${name}.tar.gz";
      sha256 = "1akalx2pd1fjlvrq69plvcx783ppslvikqdm93z2sdybq07pmish";
    };
    doCheck = false;
  });


  carrot = buildPythonPackage rec {
    name = "carrot-0.10.7";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/c/carrot/${name}.tar.gz";
      md5 = "530a0614de3a669314c3acd4995c54d5";
    };

    buildInputs = [ pythonPackages.nose ];

    propagatedBuildInputs =
      [ pythonPackages.amqplib
        pythonPackages.anyjson
      ];

    doCheck = false; # depends on the network

    meta = {
      homepage = http://pypi.python.org/pypi/carrot;
      description = "AMQP Messaging Framework for Python";
    };
  };


  cheetah = buildPythonPackage rec {
    version = "2.4.4";
    name = "cheetah-${version}";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/C/Cheetah/Cheetah-${version}.tar.gz";
      md5 = "853917116e731afbc8c8a43c37e6ddba";
    };

    propagatedBuildInputs = [ pythonPackages.markdown ];

    meta = {
      homepage = http://www.cheetahtemplate.org/;
      description = "A template engine and code generation tool";
    };
  };


  cherrypy = buildPythonPackage (rec {
    name = "cherrypy-${version}";
    version = "3.2.2";

    src = fetchurl {
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


  click = buildPythonPackage {
    name = "click-2.1";
    src = fetchurl {
      url = https://pypi.python.org/packages/source/c/click/click-2.1.tar.gz;
      md5 = "0ba97ba09af82c56e2d35f3412d0aa6e";
    };
    meta = {
      homepage = "http://click.pocoo.org/";
      description = "Click is a Python package for creating beautiful command line interfaces in a composable way with as little code as necessary.";
      license = "bsd, 3-clause";
    };
  };


  clepy = buildPythonPackage rec {
    name = "clepy-0.3.20";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/c/clepy/${name}.tar.gz";
      sha256 = "16vibfxms5z4ld8gbkra6dkhqm2cc3jnn0fwp7mw70nlwxnmm51c";
    };

    buildInputs = [ pythonPackages.mock pythonPackages.nose pythonPackages.decorator ];

    meta = {
      homepage = http://code.google.com/p/clepy/;
      description = "Utilities created by the Cleveland Python users group";
    };
  };


  clientform = buildPythonPackage (rec {
    name = "clientform-0.2.10";

    src = fetchurl {
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

    src = fetchurl {
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

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/c/colorama/colorama-0.2.5.tar.gz";
      md5 = "308c6e38917bdbfc4d3b0783c614897d";
    };

    propagatedBuildInputs = [ pythonPackages.clientform ];

    doCheck = false;

    meta = {
      homepage = http://code.google.com/p/colorama/;
      license = "bsd";
      description = "Cross-platform colored terminal text";
    };
  };


  coilmq = buildPythonPackage (rec {
    name = "coilmq-0.6.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/C/CoilMQ/CoilMQ-0.6.1.tar.gz";
      md5 = "5f39727415b837abd02651eeb2721749";
    };

    propagatedBuildInputs = [ pythonPackages.stompclient ];

    preConfigure = ''
      sed -i '/distribute/d' setup.py
    '';

    buildInputs = [ pythonPackages.coverage pythonPackages.sqlalchemy ];

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

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/c/colander/${name}.tar.gz";
      md5 = "89f2cf4b5c87d43f7917d6a0d4872e6a";
    };

    propagatedBuildInputs = [ pythonPackages.translationstring ];

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

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/C/ColanderAlchemy/${name}.tar.gz";
      md5 = "b054837bd2753cbf15f7d5028cba421b";
    };

    buildInputs = [ unittest2 ];
    propagatedBuildInputs = [ colander sqlalchemy8 ];

    # string: argument name cannot be overridden via info kwarg.
    doCheck = false;

    meta = {
      description = "Autogenerate Colander schemas based on SQLAlchemy models.";
      homepage = https://github.com/stefanofontanelli/ColanderAlchemy;
      license = licenses.mit;
    };
  };


  configobj = buildPythonPackage (rec {
    name = "configobj-4.7.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/c/configobj/${name}.tar.gz";
      md5 = "201dbaa732a9049c839f9bb6c27fc7b5";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      description = "Config file reading, writing and validation.";
      homepage = http://pypi.python.org/pypi/configobj;
      license = licenses.bsd3;
      maintainers = [ stdenv.lib.maintainers.garbas ];
    };
  });


  configshell_fb = buildPythonPackage rec {
    version = "1.1.fb10";
    name = "configshell-fb-${version}";

    src = fetchurl {
      url = "https://github.com/agrover/configshell-fb/archive/v${version}.tar.gz";
      sha256 = "1dd87xvm98nk3jzybb041gjdahi2z9b53pwqhyxcfj4a91y82ndy";
    };

    propagatedBuildInputs = [
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
    name = "construct-2.5.1";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/c/construct/${name}.tar.gz";
      sha256 = "08qksl87vr6g2wjxwsyrjh4w6v8bfmcgrcgln7irqvw5vv7qgqss";
    };

    propagatedBuildInputs = [ six ];

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

    src = fetchurl rec {
      url = "https://pypi.python.org/packages/source/c/contextlib2/${name}.tar.gz";
      md5 = "ea687207db25f65552061db4a2c6727d";
    };
  };

  coverage = buildPythonPackage rec {
    name = "coverage-3.6";

    src = fetchurl {
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
    src = fetchurl {
      url = "http://pypi.python.org/packages/source/c/cov-core/cov-core-1.7.tar.gz";
      md5 = "59c1e22e636633e10120beacbf45b28c";
    };
    meta = {
      description = "plugin core for use by pytest-cov, nose-cov and nose2-cov";
    };
    propagatedBuildInputs = [ pythonPackages.coverage ];
  };

  cython = buildPythonPackage rec {
    name = "Cython-0.20.1";

    src = fetchurl {
      url = "http://www.cython.org/release/${name}.tar.gz";
      sha256 = "0v3nc9z5ynnnjdgcgkyy5g9wazmkjv53nnpjal1v3mr199s6799i";
    };

    setupPyBuildFlags = ["--build-base=$out"];

    buildInputs = [ pkgs.pkgconfig ];

    meta = {
      description = "An interpreter to help writing C extensions for Python 2";
      platforms = stdenv.lib.platforms.all;
    };
  };

  cryptacular = buildPythonPackage rec {
    name = "cryptacular-1.4.1";

    buildInputs = [ coverage nose ];
    propagatedBuildInputs = [ pbkdf2 modules.crypt ];

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/c/cryptacular/${name}.tar.gz";
      md5 = "fe12232ac660185186dd8057d8ca7b0e";
    };

    # TODO: tests fail: TypeError: object of type 'NoneType' has no len()
    doCheck = false;

    meta = {
      maintainers = [ stdenv.lib.maintainers.iElectric ];
    };
  };

  pbkdf2 = buildPythonPackage rec {
    name = "pbkdf2-1.3";

    src = fetchurl {
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

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/b/bcrypt/${name}.tar.gz";
      md5 = "c5df008669d17dd6eeb5e2042d5e136f";
    };

    buildInputs = [ cffi pycparser mock pytest py ];

    meta = {
      maintainers = [ stdenv.lib.maintainers.iElectric ];
    };
  };

  cffi = buildPythonPackage rec {
    name = "cffi-0.7.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/c/cffi/${name}.tar.gz";
      md5 = "d329f5cb2053fd31dafc02e2c9ef0299";
    };

    buildInputs = [ pkgs.libffi pycparser ];

    meta = {
      maintainers = [ stdenv.lib.maintainers.iElectric ];
    };
  };

  pycollada = buildPythonPackage rec {
    name = "pycollada-0.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/pycollada/${name}.tar.gz";
      md5 = "5d0f00c035491b945cdccdfd8a698ad2";
    };

    # pycollada-0.4 needs python-dateutil==1.5
    buildInputs = [ dateutil_1_5 numpy ];

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

    src = fetchurl {
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
    name = "pytest-2.5.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/pytest/${name}.tar.gz";
      md5 = "4e155a0134e6757b37cc6698c20f3e9f";
    };

    preCheck = ''
      # broken on python3, fixed in master, remove in next release
      rm doc/en/plugins_index/test_plugins_index.py

      # don't test bash builtins
      rm testing/test_argcomplete.py

      # yaml test are failing
      rm doc/en/example/nonpython/test_simple.yml
    '';

    propagatedBuildInputs = [ py ]
      ++ (optional isPy26 argparse)
      ++ stdenv.lib.optional
        pkgs.config.pythonPackages.pytest.selenium or false
        pythonPackages.selenium;

    meta = with stdenv.lib; {
      maintainers = with maintainers; [ iElectric lovek323 ];
      platforms = platforms.unix;
    };
  };

  pytest_xdist = buildPythonPackage rec {
    name = "pytest-xdist-1.8";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/p/pytest-xdist/pytest-xdist-1.8.zip";
      md5 = "9c0b8efe9d43b460f8cf049fa46ce14d";
    };

    buildInputs = [ pytest ];
    propagatedBuildInputs = [ execnet ];

    meta = {
      description = "py.test xdist plugin for distributed testing and loop-on-failing modes";
      homepage = http://bitbucket.org/hpk42/pytest-xdist;
    };
  };

  cssselect = buildPythonPackage rec {
    name = "cssselect-0.7.1";
    src = fetchurl {
      url = "http://pypi.python.org/packages/source/c/cssselect/cssselect-0.7.1.tar.gz";
      md5 = "c6c5e9a2e7ca226ce03f6f67a771379c";
    };
    # AttributeError: 'module' object has no attribute 'tests'
    doCheck = false;
  };

  cssutils = buildPythonPackage (rec {
    name = "cssutils-0.9.9";

    src = fetchurl {
      url = http://pypi.python.org/packages/source/c/cssutils/cssutils-0.9.9.zip;
      sha256 = "139yfm9yz9k33kgqw4khsljs10rkhhxyywbq9i82bh2r31cil1pp";
    };

    buildInputs = [ pythonPackages.mock ];

    # couple of failing tests
    doCheck = false;

    meta = {
      description = "A Python package to parse and build CSS";

      homepage = http://code.google.com/p/cssutils/;

      license = "LGPLv3+";
    };
  });

  darcsver = buildPythonPackage (rec {
    name = "darcsver-1.7.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/d/darcsver/${name}.tar.gz";
      sha256 = "1yb1c3jxqvy4r3qiwvnb86qi5plw6018h15r3yk5ji3nk54qdcb6";
    };

    buildInputs = [ pythonPackages.mock ];

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

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/python-dateutil/python-${name}.tar.gz";
      sha256 = "0s74ad6r789810s10dxgvaf48ni6adac2icrdad34zxygqq6bj7f";
    };

    propagatedBuildInputs = [ pythonPackages.six ];

    meta = {
      description = "Powerful extensions to the standard datetime module";
      homepage = http://pypi.python.org/pypi/python-dateutil;
      license = "BSD-style";
    };
  });

  # Buildbot 0.8.7p1 needs dateutil==1.5
  dateutil_1_5 = buildPythonPackage (rec {
    name = "dateutil-1.5";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/python-dateutil/python-${name}.tar.gz";
      sha256 = "02dhw57jf5kjcp7ng1if7vdrbnlpb9yjmz7wygwwvf3gni4766bg";
    };

    propagatedBuildInputs = [ pythonPackages.six ];

    meta = {
      description = "Powerful extensions to the standard datetime module";
      homepage = http://pypi.python.org/pypi/python-dateutil;
      license = "BSD-style";
    };
  });


  decorator = buildPythonPackage rec {
    name = "decorator-3.4.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/d/decorator/${name}.tar.gz";
      md5 = "1e8756f719d746e2fc0dd28b41251356";
    };

    meta = {
      homepage = http://pypi.python.org/pypi/decorator;
    };
  };


  deform = buildPythonPackage rec {
    name = "deform-0.9.9";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/d/deform/${name}.tar.gz";
      sha256 = "0ympsjhxz5v8h4hi1mv811h064221bh26d68l9hv1x6m7sxbxpd0";
    };

    buildInputs = [] ++ optional isPy26 unittest2;

    propagatedBuildInputs =
      [ pythonPackages.beautifulsoup4
        pythonPackages.peppercorn
        pythonPackages.colander
        pythonPackages.translationstring
        pythonPackages.chameleon
        pythonPackages.zope_deprecation
        pythonPackages.coverage
        pythonPackages.nose
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

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/d/deform_bootstrap/${name}.tar.gz";
      sha256 = "1hgq3vqsfqdmlyahnlc40w13viawhpzqf4jzigsggdb41x545fda";
    };

    propagatedBuildInputs = [ deform ];

    meta = {
      maintainers = [ stdenv.lib.maintainers.iElectric ];
      platforms = stdenv.lib.platforms.all;
    };
  };


  demjson = buildPythonPackage rec {
    name = "demjson-1.6";

    src = fetchurl {
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

  derpconf = pythonPackages.buildPythonPackage rec {
    name = "derpconf-0.4.9";

    propagatedBuildInputs = [ six ];

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/d/derpconf/${name}.tar.gz";
      md5 = "a164807d7bf0c4adf1de781305f29b82";
    };

    meta = {
      description = "derpconf abstracts loading configuration files for your app";
      homepage = https://github.com/globocom/derpconf;
      license = licenses.mit;
    };
  };

  dpkt = buildPythonPackage rec {
    name = "dpkt-1.8";

    src = fetchurl {
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

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/u/urllib3/${name}.tar.gz";
      sha256 = "0pdigfxkq8mhzxxsn6isx8c4h9azqywr1k18yanwyxyj8cdzm28s";
    };

    preConfigure = ''
      substituteInPlace test-requirements.txt --replace 'nose==1.3' 'nose'
    '';

    checkPhase = ''
      nosetests --cover-min-percentage 70
    '';

    buildInputs = [ coverage tornado mock nose ];

    meta = with stdenv.lib; {
      description = "A Python library for Dropbox's HTTP-based Core and Datastore APIs";
      homepage = https://www.dropbox.com/developers/core/docs;
      license = licenses.mit;
    };
  };


  dropbox = buildPythonPackage rec {
    name = "dropbox-2.0.0";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/d/dropbox/${name}.zip";
      sha256 = "1bi2z1lql6ryylfflmizhqn98ab55777vn7n5krhqz40pdcjilkx";
    };

    propagatedBuildInputs = [ urllib3 mock setuptools ];

    meta = with stdenv.lib; {
      description = "A Python library for Dropbox's HTTP-based Core and Datastore APIs";
      homepage = https://www.dropbox.com/developers/core/docs;
      license = licenses.mit;
    };
  };


  evdev = buildPythonPackage rec {
    version = "0.3.2";
    name = "evdev-${version}";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/e/evdev/${name}.tar.gz";
      sha256 = "07gmynz764sln2sq18aafx13yawkv5nkqrkk06rj71sq71fsr9h9";
    };

    buildInputs = [ pkgs.linuxHeaders ];

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


  eyeD3 = buildPythonPackage rec {
    version = "0.7.2";
    name    = "eyeD3-${version}";

    src = fetchurl {
      url = http://eyed3.nicfit.net/releases/eyeD3-0.7.2.tgz;
      sha256 = "1r0vxdflrj83s8jc5f2qg4p00k37pskn3djym0w73bvq167vkxar";
    };

    buildInputs = [ paver ];

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

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/e/execnet/${name}.zip";
      md5 = "be885ccd9612966bb81839670d2da099";
    };

    meta = {
      description = "rapid multi-Python deployment";
      license = stdenv.lib.licenses.gpl2;
    };
  };

  faker = buildPythonPackage rec {
    name = "faker-0.0.4";
    src = fetchurl {
      url = https://pypi.python.org/packages/source/F/Faker/Faker-0.0.4.tar.gz;
      sha256 = "09q5jna3j8di0gw5yjx0dvlndkrk2x9vvqzwyfsvg3nlp8h38js1";
    };
    buildInputs = [ nose ];
    meta = with stdenv.lib; {
      description = "A Python library for generating fake user data.";
      homepage    = http://pypi.python.org/pypi/Faker;
      license     = licenses.mit;
      maintainers = with maintainers; [ lovek323 ];
      platforms   = platforms.unix;
    };
  };

  fake_factory = buildPythonPackage rec {
    name = "fake-factory-0.2";
    src = fetchurl {
      url = https://pypi.python.org/packages/source/f/fake-factory/fake-factory-0.2.tar.gz;
      sha256 = "0qdmk8p4anrj9mf95dh9v7bkhv1pz69hvhlw380kj4iz7b44b6zn";
    };
    meta = with stdenv.lib; {
      description = "A Python package that generates fake data for you.";
      homepage    = https://pypi.python.org/pypi/fake-factory;
      license     = licenses.mit;
      maintainers = with maintainers; [ lovek323 ];
      platforms   = platforms.unix;
    };
  };

  fabric = buildPythonPackage rec {
    name = "fabric-1.6.1";
    src = fetchurl {
      url = https://pypi.python.org/packages/source/F/Fabric/Fabric-1.6.1.tar.gz;
      sha256 = "058psbhqbfm3n214wkyfpgm069yqmdqw1hql9bac1yv9pza3bzx1";
    };
    propagatedBuildInputs = [ paramiko pycrypto ];
    buildInputs = [ fudge nose ];
  };

  fedora_cert = stdenv.mkDerivation (rec {
    name = "fedora-cert-0.5.9.2";
    meta.maintainers = [ stdenv.lib.maintainers.mornfall ];

    src = fetchurl {
      url = "https://fedorahosted.org/releases/f/e/fedora-packager/fedora-packager-0.5.9.2.tar.bz2";
      sha256 = "105swvzshgn3g6bjwk67xd8pslnhpxwa63mdsw6cl4c7cjp2blx9";
    };

    propagatedBuildInputs = [ python python_fedora wrapPython ];
    postInstall = "mv $out/bin/fedpkg $out/bin/fedora-cert-fedpkg";
    doCheck = false;

    postFixup = "wrapPythonPrograms";
  });

  fedpkg = buildPythonPackage (rec {
    name = "fedpkg-1.14";
    meta.maintainers = [ stdenv.lib.maintainers.mornfall ];

    src = fetchurl {
      url = "https://fedorahosted.org/releases/f/e/fedpkg/fedpkg-1.14.tar.bz2";
      sha256 = "0rj60525f2sv34g5llafnkmpvbwrfbmfajxjc14ldwzymp8clc02";
    };

    patches = [ ../development/python-modules/fedpkg-buildfix.diff ];
    propagatedBuildInputs = [ rpkg offtrac urlgrabber fedora_cert ];
  });

  fudge = buildPythonPackage rec {
    name = "fudge-0.9.4";
    src = fetchurl {
      url = https://pypi.python.org/packages/source/f/fudge/fudge-0.9.4.tar.gz;
      sha256 = "03sj2x6mpzm48swpa4hnn1gi6yilgniyjfg1ylz95wm1ijggi33w";
    };
    buildInputs = [ nose nosejs ];
    propagatedBuildInputs = [ sphinx ];
  };


  funcparserlib = buildPythonPackage rec {
    name = "funcparserlib-0.3.6";

    src = fetchurl {
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

  gcutil = buildPythonPackage rec {
    name = "gcutil-1.15.0";
    meta.maintainers = [ stdenv.lib.maintainers.phreedom ];

    src = fetchurl {
      url = https://dl.google.com/dl/cloudsdk/release/artifacts/gcutil-1.15.0.tar.gz;
      sha256 = "12c98ivhjr01iz6lkga574xm8p0bsil6arydvpblyw8sjkgim5sq";
    };

    propagatedBuildInputs = [ gflags iso8601_0_1_4 ipaddr httplib2 google_apputils google_api_python_client ];
  };

  gitdb = buildPythonPackage rec {
    name = "gitdb-0.5.4";
    meta.maintainers = [ stdenv.lib.maintainers.mornfall ];
    doCheck = false;

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/g/gitdb/${name}.tar.gz";
      sha256 = "10rpmmlln59aq44cd5vkb77hslak5pa1rbmigg6ski5f1nn2spfy";
    };

    propagatedBuildInputs = [ smmap async ];
  };

  GitPython = buildPythonPackage rec {
    name = "GitPython-0.3.2";
    meta.maintainers = [ stdenv.lib.maintainers.mornfall ];

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/G/GitPython/GitPython-0.3.2.RC1.tar.gz";
      sha256 = "1q4lc2ps12l517mmrxc8iq6gxyhj6d77bnk1p7mxf38d99l8crzx";
    };

    buildInputs = [ nose ];
    propagatedBuildInputs = [ gitdb ];
  };

  googlecl = buildPythonPackage rec {
    version = "0.9.14";
    name    = "googlecl-${version}";

    src = fetchurl {
      url    = "https://googlecl.googlecode.com/files/${name}.tar.gz";
      sha256 = "0nnf7xkr780wivr5xnchfcrahlzy9bi2dxcs1w1bh1014jql0iha";
    };

    meta = with stdenv.lib; {
      description = "Brings Google services to the command line.";
      homepage    = "https://code.google.com/p/googlecl/";
      license     = licenses.asl20;
      maintainers = with maintainers; [ lovek323 ];
      platforms   = platforms.unix;
    };

    propagatedBuildInputs = [ gdata ];
  };

  gtimelog = buildPythonPackage rec {
    name = "gtimelog-${version}";
    version = "0.8.1";

    src = fetchurl {
      url = "https://github.com/gtimelog/gtimelog/archive/${version}.tar.gz";
      sha256 = "0nwpfv284b26q97mfpagqkqb4n2ilw46cx777qsyi3plnywk1xa0";
    };

    propagatedBuildInputs = [ pygtk ];

    checkPhase = ''
      patchShebangs ./runtests
      ./runtests
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

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/i/itsdangerous/${name}.tar.gz";
      sha256 = "06856q6x675ly542ig0plbqcyab6ksfzijlyf1hzhgg3sgwgrcyb";
    };

    meta = with stdenv.lib; {
      description = "helpers to pass trusted data to untrusted environments and back";
      homepage = "https://pypi.python.org/pypi/itsdangerous/";
    };
  };

  # TODO: this shouldn't use a buildPythonPackage
  koji = buildPythonPackage (rec {
    name = "koji-1.8";
    meta.maintainers = [ stdenv.lib.maintainers.mornfall ];

    src = fetchurl {
      url = "https://fedorahosted.org/released/koji/koji-1.8.0.tar.bz2";
      sha256 = "10dph209h4jgajb5jmbjhqy4z4hd22i7s2d93vm3ikdf01i8iwf1";
    };

    configurePhase = ":";
    buildPhase = ":";
    installPhase = "make install DESTDIR=$out/ && cp -R $out/nix/store/*/* $out/ && rm -rf $out/nix";
    doCheck = false;
    propagatedBuildInputs = [ pythonPackages.pycurl ];

  });

  logilab_astng = buildPythonPackage rec {
    name = "logilab-astng-0.24.3";

    src = fetchurl {
      url = "http://download.logilab.org/pub/astng/${name}.tar.gz";
      sha256 = "0np4wpxyha7013vkkrdy54dvnil67gzi871lg60z8lap0l5h67wn";
    };

    propagatedBuildInputs = [ logilab_common ];
  };


  paver = buildPythonPackage rec {
    version = "1.2.2";
    name    = "Paver-${version}";

    src = fetchurl {
      url    = "https://pypi.python.org/packages/source/P/Paver/Paver-${version}.tar.gz";
      sha256 = "0lix9d33ndb3yk56sm1zlj80fbmxp0w60yk0d9pr2xqxiwi88sqy";
    };

    buildInputs = [ cogapp mock virtualenv ];

    propagatedBuildInputs = [ nose ];

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

    src = fetchurl {
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

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/p/pew/${name}.tar.gz";
      md5 = "90a82400074b50a9e73c3045ed9ac217";
    };

    propagatedBuildInputs = [ virtualenv virtualenv-clone ];

    meta = with stdenv.lib; {
      description = "Tools to manage multiple virtualenvs written in pure python, a virtualenvwrapper rewrite";
      license = licenses.mit;
      platforms = platforms.all;
    };
  };


  pudb = buildPythonPackage rec {
    name = "pudb-2013.3.6";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/p/pudb/${name}.tar.gz";
      md5 = "063030763bf914166a0b2bc8c011143b";
    };

    propagatedBuildInputs = [ pythonPackages.pygments pythonPackages.urwid ];

    meta = with stdenv.lib; {
      description = "A full-screen, console-based Python debugger";
      license = licenses.mit;
      platforms = platforms.all;
    };
  };


  pyramid = buildPythonPackage rec {
    name = "pyramid-1.5";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyramid/${name}.tar.gz";
      md5 = "8747658dcbab709a9c491e43d3b0d58b";
    };

    buildInputs = [
      docutils
      virtualenv
      webtest
      zope_component
      zope_interface
    ] ++ optional isPy26 unittest2;

    propagatedBuildInputs = [
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

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyramid_beaker/${name}.tar.gz";
      md5 = "acb863517a98b90b5f29648ce55dd563";
    };

    propagatedBuildInputs = [ beaker pyramid ];

    meta = {
      maintainers = [ stdenv.lib.maintainers.iElectric ];
      platforms = stdenv.lib.platforms.all;
    };
  };


  pyramid_chameleon = buildPythonPackage rec {
    name = "pyramid_chameleon-0.1";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pyramid_chameleon/${name}.tar.gz";
      md5 = "39b1327a9890f382200bbfde943833d7";
    };

    propagatedBuildInputs = [
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

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyramid_jinja2/${name}.zip";
      md5 = "a6728117cad24749ddb39d2827cd9033";
    };

    buildInputs = [ webtest ];
    propagatedBuildInputs = [ jinja2 pyramid ];

    meta = {
      maintainers = [ stdenv.lib.maintainers.iElectric ];
      platforms = stdenv.lib.platforms.all;
    };
  };


  pyramid_debugtoolbar = buildPythonPackage rec {
    name = "pyramid_debugtoolbar-1.0.9";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyramid_debugtoolbar/${name}.tar.gz";
      sha256 = "1vnzg1qnnyisv7znxg7pasayfyr3nz7rrs5nqr4fmdgwj9q2pyv0";
    };

    buildInputs = [ ];
    propagatedBuildInputs = [ pyramid pyramid_mako ];
  };


  pyramid_mako = buildPythonPackage rec {
    name = "pyramid_mako-0.3.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyramid_mako/${name}.tar.gz";
      sha256 = "00811djmsc4rz20kpy2paam05fbx6dmrv2i5jf90f6xp6zw4isy6";
    };

    buildInputs = [ webtest ];
    propagatedBuildInputs = [ pyramid Mako ];
  };


  pyramid_exclog = buildPythonPackage rec {
    name = "pyramid_exclog-0.7";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyramid_exclog/${name}.tar.gz";
      md5 = "05df86758b0d30ee6f8339ff36cef7a0";
    };

    propagatedBuildInputs = [ pyramid ];

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

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyramid_tm/${name}.tar.gz";
      md5 = "6dc917d262c69366630c542bd21859a3";
    };

    # tests are failing in version 0.7 but are fixed in trunk
    doCheck = false;

    propagatedBuildInputs = [ transaction pyramid ];
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

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/p/pyramid_multiauth/${name}.tar.gz";
      md5 = "044e423abc4fb76937ac0c21c1205e9c";
    };

    propagatedBuildInputs = [ pyramid ];

    meta = with stdenv.lib; {
      description = "Authentication policy for Pyramid that proxies to a stack of other authentication policies";
      homepage = https://github.com/mozilla-services/pyramid_multiauth;
    };
  };

  radicale = buildPythonPackage rec {
    name = "radicale-${version}";
    namePrefix = "";
    version = "0.9b1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/R/Radicale/Radicale-${version}.tar.gz";
      sha256 = "3a8451909de849f173f577ddec0a085f19040dbb6aa13d5256208a0f8e11d88d";
    };

    propagatedBuildInputs = with pythonPackages; [
      flup
      ldap
      sqlalchemy
    ];

    doCheck = false;

    meta = {
      homepage = "http://www.radicale.org/";
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

    src = fetchurl {
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
    name = "hypatia-0.1a6";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/h/hypatia/${name}.tar.gz";
      md5 = "3a67683c578754cd8f23317db6d28ffd";
    };

    buildInputs = [ zope_interface zodb3 ];

    meta = {
      maintainers = [ stdenv.lib.maintainers.iElectric ];
    };
  };


  zope_copy = buildPythonPackage rec {
    name = "zope.copy-4.0.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.copy/${name}.zip";
      md5 = "36aa2c96dec4cfeea57f54da2b733eb9";
    };

    buildInputs = [ zope_interface zope_location zope_schema ];

    meta = {
      maintainers = [ stdenv.lib.maintainers.iElectric ];
    };
  };


  statsd = buildPythonPackage rec {
    name = "statsd-2.0.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/s/statsd/${name}.tar.gz";
      md5 = "476ef5b9004f6e2cb25c7da440bb53d0";
    };

    buildInputs = [ ];

    meta = {
      maintainers = [ stdenv.lib.maintainers.iElectric ];
    };
  };


  pyramid_zodbconn = buildPythonPackage rec {
    name = "pyramid_zodbconn-0.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyramid_zodbconn/${name}.tar.gz";
      md5 = "22e88cc82cafbbe00274e7378434e5fe";
    };

    buildInputs = [ pyramid mock ];
    propagatedBuildInputs = [ zodb3 zodburi ];

    meta = {
      maintainers = [ stdenv.lib.maintainers.iElectric ];
    };
  };


  pyramid_mailer = buildPythonPackage rec {
    name = "pyramid_mailer-0.13";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyramid_mailer/${name}.tar.gz";
      md5 = "43800c7c894097a23140da58e3638c93";
    };

    buildInputs = [ pyramid transaction ];
    propagatedBuildInputs = [ repoze_sendmail ];

    meta = {
      maintainers = [ stdenv.lib.maintainers.iElectric ];
    };
  };

  pyrtlsdr = buildPythonPackage rec {
    name = "pyrtlsdr-0.2.0";

    src = fetchurl {
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

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/r/repoze.sendmail/${name}.tar.gz";
      md5 = "81d15f1f03cc67d6f56f2091c594ef57";
    };

    buildInputs = [ transaction ];

    meta = {
      maintainers = [ stdenv.lib.maintainers.iElectric ];
    };
  };


  zodburi = buildPythonPackage rec {
    name = "zodburi-2.0b1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zodburi/${name}.tar.gz";
      md5 = "52cc13c32ffe4ee7b5f5abc79f70f3c2";
    };

    buildInputs = [ zodb3 mock ];

    meta = {
      maintainers = [ stdenv.lib.maintainers.iElectric ];
    };
  };


  substanced = buildPythonPackage rec {
    # no release yet
    rev = "bd8822be62f0f356e4e44d5c614fe14d3fa08f45";
    name = "substanced-${rev}";

    src = fetchgit {
      inherit rev;
      url = "https://github.com/Pylons/substanced.git";
      sha256 = "eded6468563328af37a07aeb88ef81ed78ccaff2ab687cac34ad2b36e19abcb4";
    };

    buildInputs = [ mock ];

    propagatedBuildInputs = [
      pyramid
      pytz
      zodb3
      venusian
      colander
      deform
      deform_bootstrap
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
    ];

    meta = with stdenv.lib; {
      maintainers = [ maintainers.iElectric ];
    };
  };


  repoze_lru = buildPythonPackage rec {
    name = "repoze.lru-0.6";

    src = fetchurl {
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

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/r/repoze.sphinx.autointerface/${name}.tar.gz";
      md5 = "f2fee996ae28dc16eb48f1a3e8f64801";
    };

    propagatedBuildInputs = [ zope_interface sphinx ];

    meta = {
      maintainers = [ stdenv.lib.maintainers.iElectric ];
      platforms = stdenv.lib.platforms.all;
    };
  };


  rtmidi = buildPythonPackage rec {
    version = "0.3a";
    name = "rtmidi-${version}";

    src = fetchurl {
      url = "http://chrisarndt.de/projects/python-rtmidi/download/python-${name}.tar.bz2";
      sha256 = "0d2if633m3kbiricd5hgn1csccd8xab6lnab1bq9prdr9ks9i8h6";
    };

    preConfigure = ''
      sed -i "/use_setuptools/d" setup.py
    '';

    buildInputs = [ pkgs.alsaLib pkgs.jackaudio ];

    meta = with stdenv.lib; {
      description = "A Python wrapper for the RtMidi C++ library written with Cython";
      homepage = http://trac.chrisarndt.de/code/wiki/python-rtmidi;
      license = licenses.mit;
      maintainers = [ maintainers.goibhniu ];
    };
  };




  zope_deprecation = buildPythonPackage rec {
    name = "zope.deprecation-3.5.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.deprecation/${name}.tar.gz";
      md5 = "836cfea5fad548cd5a0d9af1300ec05e";
    };

    buildInputs = [ zope_testing ];

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

    src = fetchurl {
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

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/C/Chameleon/${name}.tar.gz";
      md5 = "0214647152fcfcb9ce357624f8f9f203";
    };

    buildInputs = [] ++ optionals isPy26 [ ordereddict unittest2 ];

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

    src = fetchurl {
      url = "http://launchpad.net/python-distutils-extra/trunk/2.26/+download/python-${name}.tar.gz";
      md5 = "7caded30a45907b5cdb10ac4182846eb";
    };

    meta = {
      homepage = https://launchpad.net/python-distutils-extra;
      description = "Enhancements to Python's distutils";
    };
  };

  deluge = buildPythonPackage rec {
    name = "deluge-1.3.6";

    src = fetchurl {
      url = "http://download.deluge-torrent.org/source/${name}.tar.gz";
      md5 = "33557678bf2f320de670ddaefaea009d";
    };

    propagatedBuildInputs = with pkgs; [
      pyGtkGlade libtorrentRasterbar twisted Mako chardet pyxdg pyopenssl modules.curses
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

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyxdg/${name}.tar.gz";
      md5 = "bedcdb3a0ed85986d40044c87f23477c";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://freedesktop.org/wiki/Software/pyxdg;
      description = "Contains implementations of freedesktop.org standards";
      license = "LGPLv2";
      maintainers = [ stdenv.lib.maintainers.iElectric ];
    };
  };

  chardet = buildPythonPackage rec {
    name = "chardet-2.1.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/c/chardet/${name}.tar.gz";
      md5 = "295367fd210d20f3febda615a88e1ef0";
    };

    meta = {
      homepage = https://github.com/erikrose/chardet;
      description = "Universal encoding detector";
      license = "LGPLv2";
      maintainers = [ stdenv.lib.maintainers.iElectric ];
    };
  };

  django = django_1_6;

  django_1_6 = buildPythonPackage rec {
    name = "Django-${version}";
    version = "1.6.3";

    src = fetchurl {
      url = "http://www.djangoproject.com/m/releases/1.6/${name}.tar.gz";
      sha256 = "1wdqb2x0w0c10annbyz7rrrgrv9mpa9f8pz8006lf2csix33r7bd";
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
    version = "1.5.6";

    src = fetchurl {
      url = "http://www.djangoproject.com/m/releases/1.5/${name}.tar.gz";
      sha256 = "1bxzz71sfvh0zgdzv4x3wdr4ffzd5cfnvq7iq2g1i282sacwnzwv";
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
    version = "1.4.11";

    src = fetchurl {
      url = "http://www.djangoproject.com/m/releases/1.4/${name}.tar.gz";
      sha256 = "00f2jlls3fhddrg7q4sjkwj6dmclh28n0vqm1m7kzcq5fjrxh6a8";
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

    src = fetchurl {
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

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/d/django_evolution/${name}.tar.gz";
      md5 = "c0d7d10bc41898c88b14d434c48766ff";
    };

    propagatedBuildInputs = [ django_1_3 ];

    meta = {
      description = "A database schema evolution tool for the Django web framework";
      homepage = http://code.google.com/p/django-evolution/;
    };
  };


  django_tagging = buildPythonPackage rec {
    name = "django-tagging-0.3.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/d/django-tagging/${name}.tar.gz";
      md5 = "a0855f2b044db15f3f8a025fa1016ddf";
    };

    # error: invalid command 'test'
    doCheck = false;

    propagatedBuildInputs = [ django_1_3 ];

    meta = {
      description = "A generic tagging application for Django projects";
      homepage = http://code.google.com/p/django-tagging/;
    };
  };


  djblets = buildPythonPackage rec {
    name = "Djblets-0.6.28";

    src = fetchurl {
      url = "http://downloads.reviewboard.org/releases/Djblets/0.6/${name}.tar.gz";
      sha256 = "11fsi911cqkjgv9j7646ljc2fgxsdfyq44kzmv01xhysm50fn6xx";
    };

    propagatedBuildInputs = [ pil django_1_3 feedparser ];

    meta = {
      description = "A collection of useful extensions for Django";
      homepage = https://github.com/djblets/djblets;
    };
  };


  dulwich = buildPythonPackage rec {
    name = "dulwich-0.8.7";

    src = fetchurl {
      url = "http://samba.org/~jelmer/dulwich/${name}.tar.gz";
      sha256 = "041qp5v2x8fbwkmws6hwwiny74lavkz723dj8gwbm40b2383d8vv";
    };

    buildPhase = "make build";

    # For some reason "python setup.py test" doesn't work with Python 2.6.
    # pretty sure that is about import behaviour.
    doCheck = python.majorVersion != "2.6";

    meta = {
      description = "Simple Python implementation of the Git file formats and protocols.";
      homepage = http://samba.org/~jelmer/dulwich/;
    };
  };


  hggit = buildPythonPackage rec {
    name = "hg-git-0.3.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/h/hg-git/${name}.tar.gz";
      md5 = "4b15867a07abb0be985177581ce64cee";
    };

    propagatedBuildInputs = [ dulwich ];

    meta = {
      description = "Push and pull from a Git server using Mercurial.";
      homepage = http://hg-git.github.com/;
    };
  };


  docutils = buildPythonPackage rec {
    name = "docutils-0.11";

    src = fetchurl {
      url = "mirror://sourceforge/docutils/${name}.tar.gz";
      sha256 = "1jbybs5a396nrjy9m13pgvsxdwaj7jw7nsawkhl4fi1nvxm1dx4s";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://docutils.sourceforge.net/;
      description = "Docutils is an open-source text processing system for processing plaintext documentation into useful formats, such as HTML or LaTeX.";
    };
  };

  doxypy = buildPythonPackage rec {
    name = "doxypy-0.4.2";

    src = fetchurl {
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

    src = fetchurl {
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
    version = "0.10";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/e/ecdsa/${name}.tar.gz";
      md5 = "e95941b3bcbf1726472bb724d7478551";
    };

    # Only needed for tests
    buildInputs = [ pkgs.openssl ];

    meta = {
      description = "ECDSA cryptographic signature library";
      homepage = "https://github.com/warner/python-ecdsa";
      license = stdenv.lib.licenses.mit;
      maintainers = [ stdenv.lib.maintainers.aszlig ];
    };
  };


  elpy = buildPythonPackage rec {
    name = "elpy-1.0.1";
    src = fetchurl {
      url = "http://pypi.python.org/packages/source/e/elpy/elpy-1.0.1.tar.gz";
      md5 = "5453f085f7871ed8fc11d51f0b68c785";
    };
    buildInputs = [  ];
    propagatedBuildInputs = [ flake8 ];

    doCheck = false; # there are no tests

    meta = {
      description = "Backend for the elpy Emacs mode";
      homepage = "https://github.com/jorgenschaefer/elpy";
    };
  };


  enum = buildPythonPackage rec {
    name = "enum-0.4.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/e/enum/${name}.tar.gz";
      md5 = "ce75c7c3c86741175a84456cc5bd531e";
    };

    buildInputs = [ ];

    propagatedBuildInputs = [ ];

    meta = {
      homepage = http://pypi.python.org/pypi/enum/;
      description = "Robust enumerated type support in Python.";
    };
  };

  enum34 = buildPythonPackage rec {
    name = "enum34-1.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/e/enum34/${name}.tar.gz";
      md5 = "9d57f5454c70c11707998ea26c1b0a7c";
    };

  };

  epc = buildPythonPackage rec {
    name = "epc-0.0.3";
    src = fetchurl {
      url = "http://pypi.python.org/packages/source/e/epc/${name}.tar.gz";
      md5 = "04a93c0cd32b496969ead09f414dac74";
    };

    propagatedBuildInputs = [ sexpdata ];
    doCheck = false;

    meta = {
      description = "EPC (RPC stack for Emacs Lisp) implementation in Python";
      homepage = "https://github.com/tkf/python-epc";
    };
  };


  eventlet = buildPythonPackage rec {
    name = "eventlet-0.9.16";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/e/eventlet/${name}.tar.gz";
      md5 = "4728e3bd7f72763c1e5dccac0296f8ea";
    };

    buildInputs = [ nose httplib2  ];

    propagatedBuildInputs = [ greenlet ];

    PYTHON_EGG_CACHE = "`pwd`/.egg-cache";

    doCheck = false; # !!! fix; tests access the network

    meta = {
      homepage = http://pypi.python.org/pypi/eventlet/;
      description = "A concurrent networking library for Python";
    };
  };


  feedparser = buildPythonPackage (rec {
    name = "feedparser-5.1.3";

    src = fetchurl {
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


  flake8 = buildPythonPackage (rec {
    name = "flake8-2.1.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/f/flake8/${name}.tar.gz";
      md5 = "cf326cfb88a1db6c5b29a3a6d9efb257";
    };

    buildInputs = [ nose mock ];
    propagatedBuildInputs = [ pyflakes pep8 mccabe ];

    # 3 failing tests
    #doCheck = false;

    meta = {
      description = "code checking using pep8 and pyflakes.";
      homepage = http://pypi.python.org/pypi/flake8;
      license = licenses.mit;
      maintainers = [ stdenv.lib.maintainers.garbas ];
    };
  });


  flask = buildPythonPackage {
    name = "flask-0.10.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/F/Flask/Flask-0.10.1.tar.gz";
      md5 = "378670fe456957eb3c27ddaef60b2b24";
    };

    propagatedBuildInputs = [ werkzeug jinja2 ];

    meta = {
      homepage = http://flask.pocoo.org/;
      description = "A microframework based on Werkzeug, Jinja 2, and good intentions";
      license = "BSD";
    };
  };

  flexget = buildPythonPackage rec {
    name = "FlexGet-1.1.121";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/F/FlexGet/${name}.tar.gz";
      md5 = "44521bcbc2c1e941b656ecfa358adcaa";
    };

    buildInputs = [ nose ];
    propagatedBuildInputs = [ beautifulsoup4 pyrss2gen feedparser pynzb html5lib dateutil
        beautifulsoup flask jinja2 requests sqlalchemy pyyaml cherrypy progressbar deluge
        python_tvrage jsonschema ];

    meta = {
      homepage = http://flexget.com/;
      description = "Multipurpose automation tool for content like torrents, ...";
      license = stdenv.lib.licenses.mit;
      maintainers = [ stdenv.lib.maintainers.iElectric ];
    };
  };

  python_tvrage = buildPythonPackage (rec {
    version = "0.4.1";
    name = "tvrage-${version}";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/p/python-tvrage/python-tvrage-${version}.tar.gz";
      md5 = "cdfec252158c5047b626861900186dfb";
    };

    # has mostly networking dependent tests
    doCheck = false;
    propagatedBuildInputs = [ beautifulsoup ];

    meta = {
      homepage = https://github.com/ckreutzer/python-tvrage;
      description = "Client interface for tvrage.com's XML-based api feeds";
      license = stdenv.lib.licenses.bsd3;
      maintainers = [ stdenv.lib.maintainers.iElectric ];
    };
  });

  jsonschema = buildPythonPackage (rec {
    version = "2.0.0";
    name = "jsonschema-${version}";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/j/jsonschema/jsonschema-${version}.tar.gz";
      md5 = "1793d97a668760ef540fadd342aa08e5";
    };

    buildInputs = [ nose mock ];

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

    src = fetchurl {
      url = "http://www.saddi.com/software/flup/dist/${name}.tar.gz";
      sha256 = "1nbx174g40l1z3a8arw72qz05a1qxi3didp9wm7kvkn1bxx33bab";
    };

    meta = {
      homepage = "http://trac.saddi.com/flup";
      description = "FastCGI Python module set";
    };
  });


  foolscap = buildPythonPackage (rec {
    name = "foolscap-0.6.4";

    src = fetchurl {
      url = "http://foolscap.lothar.com/releases/${name}.tar.gz";
      sha256 = "16cddyk5is0gjfn0ia5n2l4lhdzvbjzlx6sfpy7ddjd3d3fq7ckl";
    };

    propagatedBuildInputs = [ twisted pkgs.pyopenssl ];

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
      license = "MIT";

      maintainers = [ ];
    };
  });

  fs = buildPythonPackage rec {
    name = "fs-0.4.0";

    src = fetchurl {
      url    = "https://pyfilesystem.googlecode.com/files/fs-0.4.0.tar.gz";
      sha256 = "1fk7ilwd01qgj4anw9k1vjp0amxswzzxbp6bk4nncp7210cxp3vz";
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

    src = fetchurl {
      url = "mirror://sourceforge/fuse/fuse-python-${version}.tar.gz";
      sha256 = "06rmp1ap6flh64m81j0n3a357ij2vj9zwcvvw0p31y6hz1id9shi";
    };

    buildInputs = [ pkgs.pkgconfig pkgs.fuse ];

    meta = {
      description = "Python bindings for FUSE.";
      license = stdenv.lib.licenses.lgpl21;
    };
  });

  gcovr = buildPythonPackage rec {
    name = "gcovr-2.4";

    src = fetchurl {
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

    src = fetchurl {
      url = http://ftp.edgewall.com/pub/genshi/Genshi-0.7.tar.gz;
      sha256 = "0lkkbp6fbwzv0zda5iqc21rr7rdldkwh3hfabfjl9i4bwq14858x";
    };

    # FAIL: test_sanitize_remove_script_elem (genshi.filters.tests.html.HTMLSanitizerTestCase)
    # FAIL: test_sanitize_remove_src_javascript (genshi.filters.tests.html.HTMLSanitizerTestCase)
    doCheck = false;

    buildInputs = [ pkgs.setuptools ];

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
    name = "gevent-0.13.8";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/g/gevent/${name}.tar.gz";
      sha256 = "0plmxnb53qbxxf6macq84dvclsiyrpv3xrm32q4qqh6f01ix5f2l";
    };

    buildInputs = [ pkgs.libevent ];
    propagatedBuildInputs = [ greenlet ];

    meta = with stdenv.lib; {
      description = "Coroutine-based networking library";
      homepage = http://www.gevent.org/;
      license = licenses.mit;
      platforms = platforms.linux;
      maintainers = [ maintainers.bjornfor ];
    };
  };


  gevent-socketio = buildPythonPackage rec {
    name = "gevent-socketio-0.3.6";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/g/gevent-socketio/${name}.tar.gz";
      sha256 = "1zra86hg2l1jcpl9nsnqagy3nl3akws8bvrbpgdxk15x7ywllfak";
    };

    buildInputs = [ versiontools gevent-websocket mock pytest ];
    propagatedBuildInputs = [ gevent ];

  };

  gevent-websocket = buildPythonPackage rec {
    name = "gevent-websocket-0.9.3";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/g/gevent-websocket/${name}.tar.gz";
      sha256 = "07rqwfpbv13mk6gg8mf0bmvcf6siyffjpgai1xd8ky7r801j4xb4";
    };

    propagatedBuildInputs = [ gevent ];

  };

  genzshcomp = buildPythonPackage {
    name = "genzshcomp-0.5.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/g/genzshcomp/genzshcomp-0.5.1.tar.gz";
      md5 = "7a954f1835875002e9044fe55ed1b488";
    };

    buildInputs = [ pkgs.setuptools ] ++ (optional isPy26 argparse);

    meta = {
      description = "automatically generated zsh completion function for Python's option parser modules";
      license = "BSD";
    };
  };


  gflags = buildPythonPackage rec {
    name = "gflags-2.0";

    src = fetchurl {
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

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/g/glance/${name}.tar.gz";
      md5 = "e733713ccd23e4a6253386a47971cfb5";
    };

    buildInputs = [ nose mox ];

    # tests fail for python2.6
    doCheck = python.majorVersion != "2.6";

    propagatedBuildInputs = [ gflags sqlalchemy webob routes eventlet ];

    PYTHON_EGG_CACHE = "`pwd`/.egg-cache";

    meta = {
      homepage = https://launchpad.net/glance;
      description = "Services for discovering, registering, and retrieving virtual machine images";
    };
  };

  glances = buildPythonPackage rec {
    name = "glances-${meta.version}";

    src = fetchurl {
      url = "https://github.com/nicolargo/glances/archive/v${meta.version}.tar.gz";
      sha256 = "19pin04whc1z4gmwv2rqa7mh08d6007r8dyrhihnxj0v35ghp5i0";
    };

    buildInputs = [ pkgs.hddtemp ];

    propagatedBuildInputs = [ psutil jinja2 modules.curses modules.curses_panel];

    doCheck = false;

    preConfigure = ''
      sed -i -r -e '/data_files.append[(][(](conf|etc)_path/ietc_path="etc/glances"; conf_path="etc/glances"' setup.py;
    '';

    meta = {
      version = "1.7.4";
      homepage = "http://nicolargo.github.io/glances/";
      description = "Cross-platform curses-based monitoring tool";
    };
  };

  goobook = buildPythonPackage rec {
    name = "goobook-1.5";

    src = fetchurl {
      url    = "https://pypi.python.org/packages/source/g/goobook/${name}.tar.gz";
      sha256 = "05vpriy391l5i05ckl5ja5bswqyvl3rwrbmks9pi46w1813j7p5z";
    };

    preConfigure = ''
      sed -i '/distribute/d' setup.py
    '';

    meta = with stdenv.lib; {
      description = "Search your google contacts from the command-line or mutt.";
      homepage    = "https://pypi.python.org/pypi/goobook";
      license     = licenses.gpl3;
      maintainers = with maintainers; [ lovek323 ];
      platforms   = platforms.unix;
    };

    propagatedBuildInputs = [ gdata hcs_utils keyring simplejson ];
  };

  google_api_python_client = buildPythonPackage rec {
    name = "google-api-python-client-1.2";

    src = fetchurl {
      url = "https://google-api-python-client.googlecode.com/files/google-api-python-client-1.2.tar.gz";
      sha256 = "0xd619w71xk4ldmikxqhaaqn985rc2hy4ljgwfp50jb39afg7crw";
    };

    propagatedBuildInputs = [ httplib2 ];

    meta = with stdenv.lib; {
      description = "The core Python library for accessing Google APIs";
      homepage = "https://code.google.com/p/google-api-python-client/";
      license = licenses.asl20;
      platforms = platforms.unix;
    };
  };

   google_apputils = buildPythonPackage rec {
    name = "google-apputils-0.4.0";

    src = fetchurl {
      url = http://pypi.python.org/packages/source/g/google-apputils/google-apputils-0.4.0.tar.gz;
      sha256 = "18wlivnqxvx1wsw177lckpl32nmr6cq7f5nhk8r72fvjy8wynq5j";
    };

    propagatedBuildInputs = [ pytz gflags dateutil_1_5 mox ];

    meta = with stdenv.lib; {
      description = "Google Application Utilities for Python";
      homepage = http://code.google.com/p/google-apputils-python;
    };
  };

  greenlet = buildPythonPackage rec {
    name = "greenlet-0.3.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/g/greenlet/${name}.tar.gz";
      md5 = "8d75d7f3f659e915e286e1b0fa0e1c4d";
    };

    meta = {
      homepage = http://pypi.python.org/pypi/greenlet;
      description = "Module for lightweight in-process concurrent programming";
    };
  };


  gyp = buildPythonPackage rec {
    rev = "1944";
    name = "gyp-r${rev}";

    src = fetchsvn {
      url = "http://gyp.googlecode.com/svn/trunk";
      inherit rev;
      sha256 = "15k3ivk3jyhx4rwdf1mn6qpyrwixvy01jpkir8d14c4g9hax1dx1";
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

  gunicorn = buildPythonPackage rec {
    name = "gunicorn-18.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/g/gunicorn/${name}.tar.gz";
      md5 = "c7138b9ac7515a42066922d2b6120fbe";
    };

    buildInputs = [ pytest ];

    meta = {
      homepage = http://pypi.python.org/pypi/gunicorn;
      description = "WSGI HTTP Server for UNIX";
    };
  };

  hcs_utils = buildPythonPackage rec {
    name = "hcs_utils-1.3";

    src = fetchurl {
      url    = "https://pypi.python.org/packages/source/h/hcs_utils/hcs_utils-1.3.tar.gz";
      sha256 = "0mcjfc0ssil86i74dg323z7mikkw1xazqyr92347x1y33zyffgxh";
    };

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
    version = "0.7.0";

    src = fetchurl {
      url = "https://github.com/RedMoonStudios/hetzner/archive/"
          + "v${version}.tar.gz";
      sha256 = "1ldbhwy6yk18frv6n9znvdsrqfnpch4mfvc70jrpq3f9fw236src";
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

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/h/htmllaundry/${name}.tar.gz";
      md5 = "6db6909de76c4b259e65d90b5debdbda";
    };

    buildInputs = [ nose ];
    propagatedBuildInputs = [ six lxml ];

    # some tests fail, probably because of changes in lxml
    # not relevant for me, if releavnt for you, fix it...
    doCheck = false;

    meta = {
      description = "Simple HTML cleanup utilities";
      license = stdenv.lib.licenses.bsd3;
    };
  };


  html5lib = buildPythonPackage (rec {
    name = "html5lib-0.95";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/h/html5lib/${name}.tar.gz";
      md5 = "fe607f9917d81763e842f818f23464ee";
    };

    meta = {
      homepage = http://code.google.com/p/html5lib/;
      description = "HTML parser based on WHAT-WG HTML5 specification";
      license = stdenv.lib.licenses.mit;
      maintainers = [ stdenv.lib.maintainers.iElectric ];
    };
  });

  http_signature = buildPythonPackage (rec {
    name = "http_signature-0.1.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/h/http_signature/${name}.tar.gz";
      md5 = "015061846254bd5d8c5dbc2913985153";
    };

    propagatedBuildInputs = [pycrypto];

    meta = {
      homepage = https://github.com/atl/py-http-signature;
      description = "";
      license = stdenv.lib.licenses.mit;
    };
  });

  httplib2 = buildPythonPackage rec {
    name = "httplib2-0.9";

    src = fetchurl {
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

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/h/httpretty/${name}.tar.gz";
      md5 = "50b02560a49fe928c90c53a49791f621";
    };

    buildInputs = [ tornado requests httplib2 sure nose coverage ];

    propagatedBuildInputs = [ urllib3 ];

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

  importlib = if isPy26 then (buildPythonPackage {
    name = "importlib-1.0.2";
    src = fetchurl {
      url = "http://pypi.python.org/packages/source/i/importlib/importlib-1.0.2.tar.gz";
      md5 = "4aa23397da8bd7c7426864e88e4db7e1";
    };
    doCheck = false;
  }) else null;

  iptools = buildPythonPackage rec {
    version = "0.4.0";
    name = "iptools-${version}";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/i/iptools/iptools-${version}.tar.gz";
      md5 = "de60e5fab861f29dbf5f4446f8576532";
    };

    meta = {
      description = "Utilities for manipulating IP addresses including a class that can be used to include CIDR network blocks in Django's INTERNAL_IPS setting.";
      homepage = http://pypi.python.org/pypi/iptools;
    };
  };


  ipy = buildPythonPackage rec {
    version = "0.74";
    name = "ipy-${version}";

    src = fetchurl {
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


  ipaddr = buildPythonPackage {
    name = "ipaddr-2.1.10";
    src = fetchurl {
      url = "http://ipaddr-py.googlecode.com/files/ipaddr-2.1.10.tar.gz";
      sha256 = "18ycwkfk3ypb1yd09wg20r7j7zq2a73d7j6j10qpgra7a7abzhyj";
    };

    meta = {
      description = "Google's IP address manipulation library";
      homepage = http://code.google.com/p/ipaddr-py/;
      license = licenses.asl20;
    };
  };

  ipdb = buildPythonPackage {
    name = "ipdb-0.7";
    src = fetchurl {
      url = "http://pypi.python.org/packages/source/i/ipdb/ipdb-0.7.tar.gz";
      md5 = "d879f9b2b0f26e0e999809585dcaec61";
    };
    propagatedBuildInputs = [ pythonPackages.ipythonLight ];
  };

  ipdbplugin = buildPythonPackage {
    name = "ipdbplugin-1.4";
    src = fetchurl {
      url = "https://pypi.python.org/packages/source/i/ipdbplugin/ipdbplugin-1.4.tar.gz";
      md5 = "f9a41512e5d901ea0fa199c3f648bba7";
    };
    propagatedBuildInputs = [ pythonPackages.nose pythonPackages.ipythonLight ];
  };

  iso8601_0_1_4 = buildPythonPackage {
    name = "iso8601-0.1.4";
    src = fetchurl {
      url = https://pypi.python.org/packages/source/i/iso8601/iso8601-0.1.4.tar.gz;
      sha256 = "03gnjxpfq0wwimqnsvz32xcngq0hrdqryn3zm8qh95hnnggwqa3s";
    };

    meta = {
      homepage = https://bitbucket.org/micktwomey/pyiso8601/;
      description = "Simple module to parse ISO 8601 dates";
      maintainers = [ stdenv.lib.maintainers.phreedom ];
    };
  };

  jedi = buildPythonPackage (rec {
    name = "jedi-0.8.0-final0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/j/jedi/${name}.tar.gz";
      sha256 = "0jnhwh0b1hy5cssi3n5a4j7z9pgpcckyv5s52ba4jnq5bwgdpbcf";
    };

    meta = {
      homepage = "https://github.com/davidhalter/jedi";
      description = "An autocompletion tool for Python that can be used for text editors.";
      license = licenses.lgpl3Plus;
      maintainers = [ stdenv.lib.maintainers.garbas ];
    };
  });

  jinja2 = buildPythonPackage rec {
    name = "Jinja2-2.7.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/J/Jinja2/${name}.tar.gz";
      sha256 = "12scn3zmmj76rzyc0axjzf6dsazyj9xgp0l46q41rjhxm23s1h2w";
    };

    propagatedBuildInputs = [ pythonPackages.markupsafe ];

    meta = {
      homepage = http://jinja.pocoo.org/;
      description = "Stand-alone template engine";
      license = "BSD";
      longDescription = ''
        Jinja2 is a template engine written in pure Python. It provides a
        Django inspired non-XML syntax but supports inline expressions and
        an optional sandboxed environment.
      '';
    };
  };


  jmespath = buildPythonPackage rec {
    name = "jmespath-0.2.1";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/j/jmespath/jmespath-0.2.1.tar.gz";
      md5 = "7800775aa12c6303f9ad597b6a8fa03c";
    };

    propagatedBuildInputs = [ ply ];

    meta = {
      homepage = "https://github.com/boto/jmespath";
      description = "JMESPath allows you to declaratively specify how to extract elements from a JSON document";
      license = "BSD";
    };
  };

  keyring = buildPythonPackage rec {
    name = "keyring-3.2";

    src = fetchurl {
      url    = "https://pypi.python.org/packages/source/k/keyring/${name}.zip";
      sha256 = "1flccphpyrb8y8dra2fq2s2v3fg615d77kjjmzl0gmiidabkkdqf";
    };

    meta = with stdenv.lib; {
      description = "Store and access your passwords safely";
      homepage    = "https://pypi.python.org/pypi/keyring";
      license     = licenses.psfl;
      maintainers = with maintainers; [ lovek323 ];
      platforms   = platforms.unix;
    };

    buildInputs =
      [ fs gdata python_keyczar mock pyasn1 pycrypto pytest ];
  };

  kitchen = buildPythonPackage (rec {
    name = "kitchen-1.1.1";
    meta.maintainers = [ stdenv.lib.maintainers.mornfall ];

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/k/kitchen/kitchen-1.1.1.tar.gz";
      sha256 = "0ki840hjk1q19w6icv0dj2jxb00966nwy9b1jib0dgdspj00yrr5";
    };
  });

  pylast = buildPythonPackage rec {
    name = "pylast-${version}";
    version = "0.5.11";

    src = fetchurl {
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

    src = fetchurl {
      url = https://pypi.python.org/packages/source/a/apache-libcloud/apache-libcloud-0.14.1.tar.bz2;
      sha256 = "1l6190pjv54c7y8pzr089ij727qv7bqhhaznr2mkvimgr1wzsql5";
    };

    buildInputs = [  mock ];

    propagatedBuildInputs = [ pycrypto ];
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

    src = fetchurl {
      url = https://pypi.python.org/packages/source/l/limnoria/limnoria-2013-06-01T10:32:51+0200.tar.gz;
      name = "limnoria-2013-06-01.tar.gz";
      sha256 = "1i8q9zzf43sr3n1q4h6h1z8nz31g4aa8dq94ywvfbh7hklmchq6n";
    };

    buildInputs = [ pkgs.git ];
    propagatedBuildInputs = [ modules.sqlite3 ];

    doCheck = false;

    meta = with stdenv.lib; {
      description = "A modified version of Supybot, an IRC bot";
      homepage = http://supybot.fr.cr;
      license = licenses.bsd3;
      maintainers = [ maintainers.goibhniu ];
    };
  });


  lockfile = buildPythonPackage rec {
    name = "lockfile-0.9.1";

    src = fetchurl {
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

    src = fetchurl {
      url = "http://download.logilab.org/pub/common/${name}.tar.gz";
      sha256 = "09apsrcvjliawbxmfrmi1l8hlbaj87mb7n4lrlivy5maxs6yg4hd";
    };

    propagatedBuildInputs = [ unittest2 ];
  };

  "lxml-2.3.6" = buildPythonPackage rec {
    name = "lxml-2.3.6";
    src = fetchurl {
      url = "http://pypi.python.org/packages/source/l/lxml/lxml-2.3.6.tar.gz";
      md5 = "d5d886088e78b1bdbfd66d328fc2d0bc";
    };
    buildInputs = [ pkgs.libxml2 pkgs.libxslt ];
    propagatedBuildInputs = [  ];
    doCheck = false;

    meta = {
      description = "Pythonic binding for the libxml2 and libxslt libraries";
      homepage = http://codespeak.net/lxml/index.html;
      license = "BSD";
    };
  };

  lxml = buildPythonPackage ( rec {
    name = "lxml-3.0.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/l/lxml/${name}.tar.gz";
      md5 = "38b15b0dd5e9292cf98be800e84a3ce4";
    };

    buildInputs = [ pkgs.libxml2 pkgs.libxslt ];

    meta = {
      description = "Pythonic binding for the libxml2 and libxslt libraries";
      homepage = http://codespeak.net/lxml/index.html;
      license = "BSD";
    };
  });


  python_magic = buildPythonPackage rec {
    name = "python-magic-0.4.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/python-magic/${name}.tar.gz";
      md5 = "eec9e2b1bcaf43308b7dacb3f2ecd8c1";
    };

    propagatedBuildInputs = [ pkgs.file ];

    patchPhase = ''
      substituteInPlace magic.py --replace "ctypes.CDLL(dll)" "ctypes.CDLL('${pkgs.file}/lib/libmagic.so')"
    '';

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
    buildInputs = [ python pkgs.file ];

    preConfigure = "cd python";

    meta = {
      description = "A Python wrapper around libmagic";
      homepage = http://www.darwinsys.com/file/;
    };
  };


  m2crypto = buildPythonPackage rec {
    version = "0.21.1";
    name = "m2crypto-${version}";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/M/M2Crypto/M2Crypto-${version}.tar.gz";
      md5 = "f93d8462ff7646397a9f77a2fe602d17";
    };

    buildInputs = [ pkgs.swig pkgs.openssl ];

    preBuild = "${python}/bin/${python.executable} setup.py build_ext --openssl=${pkgs.openssl}";

    doCheck = false; # another test that depends on the network.

    meta = {
      description = "A Python crypto and SSL toolkit";
      homepage = http://chandlerproject.org/Projects/MeTooCrypto;
    };
  };


  Mako = buildPythonPackage rec {
    name = "Mako-0.9.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/M/Mako/${name}.tar.gz";
      md5 = "fe3f394ef714776d09ec6133923736a7";
    };

    buildInputs = [ markupsafe nose ];
    propagatedBuildInputs = [ markupsafe ];

    meta = {
      description = "Super-fast templating language.";
      homepage = http://www.makotemplates.org;
      license = "MIT";
      maintainers = [ stdenv.lib.maintainers.iElectric ];
    };
  };


  markupsafe = buildPythonPackage rec {
    name = "markupsafe-0.15";

    src = fetchurl {
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
    version = "1.6.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/m/manuel/${name}.tar.gz";
      sha256 = "1h35ys31zkjd9jssqn9lzwmw8s17ikr4jn2xp5zby1v771ibbbqr";
    };

    propagatedBuildInputs = [ six zope_testing ];

    meta = {
      description = "A documentation builder";
      homepage = http://pypi.python.org/pypi/manuel;
      license = "ZPL";
    };
  };

  markdown = buildPythonPackage rec {
    version = "2.3.1";
    name = "markdown-${version}";

    src = fetchurl {
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
    name = "matplotlib-1.3.1";

    src = fetchurl {
      url = "mirror://sourceforge/matplotlib/${name}.tar.gz";
      sha256 = "0smgpn7lwbn02nbyhawyn0n6r3pb65zk501f21bjgavnjjfnf5pa";
    };

    buildInputs = [ python pkgs.which pkgs.ghostscript ] ++
        (if stdenv.isDarwin then [ pkgs.clangStdenv ] else [ pkgs.stdenv ]);

    propagatedBuildInputs =
      [ dateutil nose numpy pyparsing tornado pkgs.freetype pkgs.libpng pkgs.pkgconfig
        pygtk ];

    meta = with stdenv.lib; {
      description = "python plotting library, making publication quality plots";
      homepage    = "http://matplotlib.sourceforge.net/";
      maintainers = with maintainers; [ lovek323 ];
      platforms   = platforms.unix;
    };
  };


  mccabe = buildPythonPackage (rec {
    name = "mccabe-0.2.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/m/mccabe/${name}.tar.gz";
      md5 = "5a3f3fa6a4bad126c88aaaa7dab682f5";
    };

    buildInputs = [ ];

    meta = {
      description = "McCabe checker, plugin for flake8";
      homepage = "https://github.com/flintwork/mccabe";
      license = licenses.mit;
      maintainers = [ stdenv.lib.maintainers.garbas ];
    };
  });


  mechanize = buildPythonPackage (rec {
    name = "mechanize-0.1.11";

    src = fetchurl {
      url = "http://wwwsearch.sourceforge.net/mechanize/src/${name}.tar.gz";
      sha256 = "1h62mwy4iz09jqz17nrb9j8y0djd500zdfqwrz9xmdwqzqwixkj2";
    };

    propagatedBuildInputs = [ clientform ];

    meta = {
      description = "Stateful programmatic web browsing in Python";

      homepage = http://wwwsearch.sourceforge.net/;

      license = "BSD-style";
    };
  });


  meld3 = buildPythonPackage rec {
    name = "meld3-0.6.10";

    src = fetchurl {
      url = https://pypi.python.org/packages/source/m/meld3/meld3-0.6.10.tar.gz;
      md5 = "42e58624e9d427be7659d7a28e2b0b6f";
    };

    doCheck = false;

    meta = {
      description = "An HTML/XML templating engine used by supervisor";
      homepage = https://github.com/supervisor/meld3;
      license = "ZPL";
    };
  };


  memcached = buildPythonPackage rec {
    name = "memcached-1.48";

    src = fetchurl {
      url = "ftp://ftp.tummy.com/pub/python-memcached/old-releases/python-memcached-1.48.tar.gz";
      sha256 = "1i0h05z9j0zl65rgvw86p4f54pigkxynhzppn4qxby8rjlnwdfv6";
    };

    meta = {
      description = "Python API for communicating with the memcached distributed memory object cache daemon";
      homepage = http://www.tummy.com/Community/software/python-memcached/;
    };
  };


  memory_profiler = buildPythonPackage rec {
    name = "memory_profiler-0.27";

    src = fetchurl {
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


  mitmproxy = buildPythonPackage rec {
    baseName = "mitmproxy";
    name = "${baseName}-${meta.version}";

    src = fetchurl {
      url = "${meta.homepage}/download/${name}.tar.gz";
      sha256 = "0mpyw8iw4l4jv175qlbn0rrlgiz1k79m44jncbdxfj8ddvvvyz2j";
    };

    buildInputs = [
      pkgs.pyopenssl pyasn1 urwid pil lxml flask protobuf netlib
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

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/m/mock/${name}.tar.gz";
      md5 = "c3971991738caa55ec7c356bbc154ee2";
    };

    buildInputs = [ unittest2 ];

    meta = {
      description = "Mock objects for Python";

      homepage = http://python-mock.sourceforge.net/;

      license = "mBSD";
    };
  });

  moinmoin = let ver="1.9.7"; in buildPythonPackage (rec {
    name = "moinmoin-${ver}";

    src = fetchurl {
      url = "http://static.moinmo.in/files/moin-${ver}.tar.gz";
      sha256 = "f4ba1b5c956bd96d2a61e27e68d297aa63d1afbc80d5740e139dcdf0affb4db5";
    };

    meta = {
      description = "Advanced, easy to use and extensible WikiEngine";

      homepage = http://moinmo.in/;

      license = "GPLv2+";
    };
  });


  mox = buildPythonPackage rec {
    name = "mox-0.5.3";

    src = fetchurl {
      url = "http://pymox.googlecode.com/files/${name}.tar.gz";
      sha1 = "b71aeaacf31898c3b38d8b9ca5bcc0664499c0de";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://code.google.com/p/pymox/;
      description = "A mock object framework for Python.";
    };
  };


  mpmath = buildPythonPackage rec {
    name = "mpmath-0.17";

    src = fetchurl {
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


  mrbob = buildPythonPackage rec {
    name = "mrbob-${version}";
    version = "0.1.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/m/mr.bob/mr.bob-${version}.zip";
      md5 = "84a117c9a75b86842b0fa5f5c9c767f3";
    };

    # some files in tests dir include unicode names
    preBuild = ''
      export LOCALE_ARCHIVE=${pkgs.glibcLocales}/lib/locale/locale-archive
      export LC_ALL="en_US.UTF-8"
    '';

    propagatedBuildInputs = [ argparse jinja2 six modules.readline ] ++
                            (optionals isPy26 [ importlib ordereddict ]);

    meta = {
      homepage = https://github.com/iElectric/mr.bob.git;
      description = "A tool to generate code skeletons from templates";
    };
  };


  munkres = buildPythonPackage rec {
    name = "munkres-1.0.5.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/m/munkres/${name}.tar.gz";
      md5 = "cb9d114fb523428bab4742e88bc83696";
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

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/m/musicbrainzngs/${name}.tar.gz";
      md5 = "9e17a181af72d04a291c9a960bc73d44";
    };

    meta = {
      homepage = http://alastair/python-musicbrainz-ngs;
      description = "Python bindings for musicbrainz NGS webservice";
      license = licenses.bsd2;
      maintainers = [ stdenv.lib.maintainers.iElectric ];
    };
  };


  mutagen = buildPythonPackage (rec {
    name = "mutagen-1.23";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/m/mutagen/${name}.tar.gz";
      sha256 = "12f70aaf5ggdzll76bhhkn64b27xy9s1acx417dbsaqnnbis8s76";
    };
    
    # one unicode test fails
    doCheck = false;

    meta = {
      description = "Python multimedia tagging library";
      homepage = http://code.google.com/p/mutagen;
      license = "LGPLv2";
    };
  });


  muttils = buildPythonPackage (rec {
    name = "muttils-1.3";

    src = fetchurl {
      url = http://www.blacktrash.org/hg/muttils/archive/8bb26094df06.tar.bz2;
      sha256 = "1a4kxa0fpgg6rdj5p4kggfn8xpniqh8v5kbiaqc6wids02m7kag6";
    };

    # Tests don't work
    doCheck = false;

    meta = {
      description = "Utilities for use with console mail clients, like mutt";
      homepage = http://www.blacktrash.org/hg/muttils;
      license = "GPLv2+";
    };
  });


  MySQL_python = buildPythonPackage {
    name = "MySQL-python-1.2.3";

    # plenty of failing tests
    doCheck = false;

    src = fetchurl {
      url = mirror://sourceforge/mysql-python/MySQL-python-1.2.3.tar.gz;
      sha256 = "0vkyg9dmj29hzk7fy77f42p7bfj28skyzsjsjry4wqr3z6xnzrkx";
    };

    buildInputs = [ nose ];

    propagatedBuildInputs = [ pkgs.mysql pkgs.zlib ];

    meta = {
      description = "MySQL database binding for Python";

      homepage = http://sourceforge.net/projects/mysql-python;
    };
  };


  mysql_connector_repackaged = buildPythonPackage rec {
    name = "mysql-connector-repackaged-0.3.1";

    src = fetchurl {
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

    src = fetchurl {
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


  netaddr = buildPythonPackage rec {
    name = "netaddr-0.7.5";

    src = fetchurl {
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
    version = "0.8";
    name = "netifaces-${version}";

    src = fetchurl {
      url = "http://alastairs-place.net/projects/netifaces/${name}.tar.gz";
      sha256 = "1v5i39kx4yz1pwgjfbzi63w55l2z318zgmi9f77ybmmkil1i39sk";
    };

    meta = {
      homepage = http://alastairs-place.net/projects/netifaces/;
      description = "Portable access to network interfaces from Python";
    };
  };

  netlib = buildPythonPackage rec {
    baseName = "netlib";
    name = "${baseName}-${meta.version}";

    src = fetchurl {
      url = "https://github.com/cortesi/netlib/archive/v${meta.version}.tar.gz";
      name = "${name}.tar.gz";
      sha256 = "1x2n126b7fal64fb5fzkp4by7ym0iswn3w9mh6pm4c1vjdpnk592";
    };

    buildInputs = [
      pkgs.pyopenssl pyasn1
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

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/N/Nevow/Nevow-${version}.tar.gz";
      sha256 = "90631f68f626c8934984908d3df15e7c198939d36be7ead1305479dfc67ff6d0";
      name = "${name}.tar.gz";
    };

    propagatedBuildInputs = [ twisted ];

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
    version = "1.3.3";
    name = "nose-${version}";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/n/nose/${name}.tar.gz";
      sha256 = "09h3a74hzw1cfx4ic19ibxq8kg6sl1n64px2mmb57f5yd3r2y35l";
    };

    buildInputs = [ coverage ];

    doCheck = ! stdenv.isDarwin;
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

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/n/nose-selecttests/${name}.zip";
      sha256 = "0lgrfgp3sq8xi8d9grrg0z8jsyk0wl8a3rxw31hb7vdncin5b7n5";
    };

    propagatedBuildInputs = [ nose ];

    meta = {
      description = "Simple nose plugin that enables developers to run subset of collected tests to spare some waiting time for better things";
    };
  };


  nose2 = if isPy26 then null else (buildPythonPackage rec {
    name = "nose2-0.4.5";
    src = fetchurl {
      url = "http://pypi.python.org/packages/source/n/nose2/${name}.tar.gz";
      md5 = "d7e51c848227488e3cc0424faf5511cd";
    };
    meta = {
      description = "nose2 is the next generation of nicer testing for Python";
    };
    propagatedBuildInputs = [ six ];
    # AttributeError: 'module' object has no attribute 'collector'
    doCheck = false;
  });

  nose2Cov = if isPy26 then null else (buildPythonPackage rec {
    name = "nose2-cov-1.0a4";
    src = fetchurl {
      url = "http://pypi.python.org/packages/source/n/nose2-cov/nose2-cov-1.0a4.tar.gz";
      md5 = "6442f03e2ea732b0e38eb5b00fbe0b31";
    };
    meta = {
      description = "nose2 plugin for coverage reporting, including subprocesses and multiprocessing";
    };
    propagatedBuildInputs = [ covCore nose2 ];
  });

  nosejs = buildPythonPackage {
    name = "nosejs-0.9.4";
    src = fetchurl {
      url = https://pypi.python.org/packages/source/N/NoseJS/NoseJS-0.9.4.tar.gz;
      sha256 = "0qrhkd3sga56qf6k0sqyhwfcladwi05gl6aqmr0xriiq1sgva5dy";
    };
    buildInputs = [ nose ];
  };

  nose-cprof = buildPythonPackage rec {
    name = "nose-cprof-0.1-0";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/n/nose-cprof/${name}.tar.gz";
      md5 = "5db27c3b8f01915335ae6fc5fd3afd44";
    };

    meta = {
      description = "A python nose plugin to profile using cProfile rather than the default Hotshot profiler.";
    };

    buildInputs = [ nose ];
  };


  notify = pkgs.stdenv.mkDerivation (rec {
    name = "python-notify-0.1.1";

    src = fetchurl {
      url = http://www.galago-project.org/files/releases/source/notify-python/notify-python-0.1.1.tar.bz2;
      sha256 = "1kh4spwgqxm534qlzzf2ijchckvs0pwjxl1irhicjmlg7mybnfvx";
    };

    patches = singleton (fetchurl {
      name = "libnotify07.patch";
      url = "http://pkgs.fedoraproject.org/cgit/notify-python.git/plain/"
          + "libnotify07.patch?id2=289573d50ae4838a1658d573d2c9f4c75e86db0c";
      sha256 = "1lqdli13mfb59xxbq4rbq1f0znh6xr17ljjhwmzqb79jl3dig12z";
    });

    postPatch = ''
      sed -i -e '/^PYGTK_CODEGEN/s|=.*|="${pygtk}/bin/pygtk-codegen-2.0"|' \
        configure
    '';

    buildInputs = [ python pkgs.pkgconfig pkgs.libnotify pygobject pygtk pkgs.glib pkgs.gtk pkgs.dbus_glib ];

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

    buildInputs = [ python pkgs.notmuch ];

    meta = {
      description = "A Python wrapper around notmuch";
      homepage = http://notmuchmail.org/;
      maintainers = [ stdenv.lib.maintainers.garbas ];
    };
  };

  numexpr = buildPythonPackage rec {
    version = "2.4";
    name = "numexpr-${version}";

    src = fetchgit {
      url = https://github.com/pydata/numexpr.git;
      rev = "606cc9a110711e947d35ac2770749c00dab184c8";
      sha256 = "1gxgkg7ncgjhnifn444iha5nrjhyr8sr6w5yp204186a1ysz858g";
    };

    propagatedBuildInputs = with pkgs; [ numpy ];

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
    name = "numpy-1.7.1";

    src = fetchurl {
      url = "mirror://sourceforge/numpy/${name}.tar.gz";
      sha256 = "0jh832j439jj2b7m1z5a4rv5cpdn1yiw1r6gwrhdihw562d029am";
    };

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

    buildInputs = [ pkgs.gfortran ];
    propagatedBuildInputs = [ pkgs.liblapack pkgs.blas ];

    meta = {
      description = "Scientific tools for Python";
      homepage = "http://numpy.scipy.org/";
    };
  });


  nwdiag = buildPythonPackage rec {
    name = "nwdiag-1.0.0";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/n/nwdiag/${name}.tar.gz";
      md5 = "d81581a028840f8f7362ab21bf73e941";
    };

    buildInputs = [ pep8 nose unittest2 docutils ];

    propagatedBuildInputs = [ blockdiag ];

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

  livestreamer = if isPy34 then null else (buildPythonPackage rec {
    version = "1.8.2";
    name = "livestreamer-${version}";

    src = fetchurl {
      url = "https://github.com/chrippa/livestreamer/archive/v${version}.tar.gz";
      sha256 = "130h97qdb7qx8xg0gz54p5a6cb2zbffi5hsi305xf0ah9nf4rbrc";
    };

    buildInputs = [ pkgs.makeWrapper ];
    propagatedBuildInputs = [ requests pkgs.rtmpdump pycrypto ];
    postInstall = ''
      wrapProgram $out/bin/livestreamer --prefix PATH : ${pkgs.rtmpdump}/bin
    '';

    meta = {
      homepage = http://livestreamer.tanuki.se;
      description = ''
        Livestreamer is CLI program that extracts streams from various
        services and pipes them into a video player of choice.
      '';
      license = "bsd";
    };
  });

  oauth2 = buildPythonPackage (rec {
    name = "oauth2-1.5.211";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/o/oauth2/oauth2-1.5.211.tar.gz";
      sha256 = "82a38f674da1fa496c0fc4df714cbb058540bed72a30c50a2e344b0d984c4d21";
    };

    propagatedBuildInputs = [ httplib2 ];

    buildInputs = [ mock coverage ];

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
    name = "oauthlib-0.5.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/o/oauthlib/${name}.tar.gz";
      md5 = "d12c507de33403ebdf290fbffdb98213";
    };

    buildInputs = [ mock nose unittest2 ];

    propagatedBuildInputs = [ pycrypto ];

    meta = {
      homepage = https://github.com/idan/oauthlib;
      description = "A generic, spec-compliant, thorough implementation of the OAuth request-signing logic";
    };
  };


  obfsproxy = buildPythonPackage ( rec {
    name = "obfsproxy-0.2.2";
    src = fetchgit {
      url = https://git.torproject.org/pluggable-transports/obfsproxy.git;
      rev = "3c4e843a30c430aec1de03e0e09ef654072efc03";
      sha256 = "8fd1e63a37bc42add7609d97d50ecd81da81881bcf7015a9e2958531dbf39018";
    };

    propagatedBuildInputs = [ pyptlib argparse twisted pycrypto ];

    meta = {
      description = "a pluggable transport proxy";
      homepage = https://www.torproject.org/projects/obfsproxy;
    };
  });

  offtrac = buildPythonPackage rec {
    name = "offtrac-0.1.0";
    meta.maintainers = [ stdenv.lib.maintainers.mornfall ];

    src = fetchurl {
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
    src = fetchurl {
      url = "http://pypi.python.org/packages/source/o/ordereddict/ordereddict-1.1.tar.gz";
      md5 = "a0ed854ee442051b249bfad0f638bbec";
    };
    doCheck = false;
  }) else null;

  ply = buildPythonPackage (rec {
    name = "ply-3.4";

    src = fetchurl {
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

    src = fetchgit {
      url = git://gitorious.org/opensuse/osc.git;
      rev = "6cd541967ee2fca0b89e81470f18b97a3ffc23ce";
      sha256 = "a39ce0e321e40e9758bf7b9128d316c71b35b80eabc84f13df492083bb6f1cc6";
    };

    buildPhase = "python setup.py build";
    doCheck = false;
    postInstall = "ln -s $out/bin/osc-wrapper.py $out/bin/osc";

    propagatedBuildInputs = [ pythonPackages.m2crypto ];

  });

  pandas = buildPythonPackage rec {
    name = "pandas-0.14.0";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/p/pandas/${name}.tar.gz";
      sha256 = "f7997debca756c4dd5ccdf5a010dfe3d1c7dac98ee706b715d994cf7c9d35528";
    };

    buildInputs = [ nose ];
    propagatedBuildInputs = [ dateutil numpy pytz modules.sqlite3 ];

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

  paramiko = buildPythonPackage rec {
    name = "paramiko-1.12.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/paramiko/${name}.tar.gz";
      md5 = "ae4544dc0a1419b141342af89fcf0dd9";
    };

    propagatedBuildInputs = [ pycrypto ecdsa ];

    checkPhase = "python test.py";

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

    src = fetchurl {
      url = http://pypi.python.org/packages/source/P/Paste/Paste-1.7.5.1.tar.gz;
      md5 = "7ea5fabed7dca48eb46dc613c4b6c4ed";
    };

    buildInputs = [ nose ];

    doCheck = false; # some files required by the test seem to be missing

    meta = {
      description = "Tools for using a Web Server Gateway Interface stack";
      homepage = http://pythonpaste.org/;
    };
  };


  paste_deploy = buildPythonPackage rec {
    version = "1.5.0";
    name = "paste-deploy-${version}";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/PasteDeploy/PasteDeploy-${version}.tar.gz";
      md5 = "f1a068a0b680493b6eaff3dd7690690f";
    };

    buildInputs = [ nose ];

    meta = {
      description = "Load, configure, and compose WSGI applications and servers";
      homepage = http://pythonpaste.org/deploy/;
      platforms = stdenv.lib.platforms.all;
    };
  };

  paypalrestsdk = buildPythonPackage rec {
    name = "paypalrestsdk-0.7.0";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/p/paypalrestsdk/${name}.tar.gz";
      sha256 = "117kfipzfahf9ysv414bh1mmm5cc9ck5zb6rhpslx1f8gk3frvd6";
    };

    propagatedBuildInputs = [ httplib2 ];

    meta = {
      homepage = https://developer.paypal.com/;
      description = "Python APIs to create, process and manage payment";
      license = "PayPal SDK License";
    };
  };

  pep8 = buildPythonPackage rec {
    name = "pep8-${version}";
    version = "1.5.7";

    src = fetchurl {
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


  pexpect = buildPythonPackage {
    name = "pexpect-2.3";

    src = fetchurl {
      url = "mirror://sourceforge/pexpect/pexpect-2.3.tar.gz";
      sha256 = "0x8bfjjqygriry1iyygm5048ykl5qpbpzqfp6i8dhkslm3ryf5fk";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = "http://www.noah.org/wiki/Pexpect";
      description = "Automate interactive console applications such as ssh, ftp, etc.";
      license = "MIT";

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
    name = "pg8000-1.09";

    src = fetchurl {
      url = "http://pg8000.googlecode.com/files/${name}.zip";
      sha256 = "0kdc4rg47k1qkq22inghd50xlxjdkfcilym8mxff8wy4h091xykw";
    };

    propagatedBuildInputs = [ pytz ];

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
    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/pip/pip-${version}.tar.gz";
      md5 = "01026f87978932060cc86c1dc527903e";
    };
    buildInputs = [ mock scripttest virtualenv pytest ];
  };


  pika = buildPythonPackage {
    name = "pika-0.9.12";
    src = fetchurl {
      url = https://pypi.python.org/packages/source/p/pika/pika-0.9.12.tar.gz;
      md5 = "7174fc7cc5570314fa3cfaa729106482";
    };
    buildInputs = [ nose mock pyyaml ];

    propagatedBuildInputs = [ unittest2 ];
  };


  pillow = buildPythonPackage rec {
    name = "Pillow-2.3.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Pillow/${name}.zip";
      md5 = "56b6614499aacb7d6b5983c4914daea7";
    };

    buildInputs = [ pkgs.freetype pkgs.libjpeg pkgs.zlib pkgs.libtiff pkgs.libwebp ];

    # NOTE: we use LCMS_ROOT as WEBP root since there is not other setting for webp.
    preConfigure = ''
      sed -i "setup.py" \
          -e 's|^FREETYPE_ROOT =.*$|FREETYPE_ROOT = _lib_include("${pkgs.freetype}")|g ;
              s|^JPEG_ROOT =.*$|JPEG_ROOT = _lib_include("${pkgs.libjpeg}")|g ;
              s|^ZLIB_ROOT =.*$|ZLIB_ROOT = _lib_include("${pkgs.zlib}")|g ;
              s|^LCMS_ROOT =.*$|LCMS_ROOT = _lib_include("${pkgs.libwebp}")|g ;
              s|^TIFF_ROOT =.*$|TIFF_ROOT = _lib_include("${pkgs.libtiff}")|g ;'
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

      maintainers = [ stdenv.lib.maintainers.goibhniu ];
    };
  };

  plumbum = buildPythonPackage rec {
    name = "plumbum-1.4.2";

    buildInputs = [ pythonPackages.six ];

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/p/plumbum/${name}.tar.gz";
      md5 = "38b526af9012a5282ae91dfe372cefd3";
    };
  };


  polib = buildPythonPackage rec {
    name = "polib-${version}";
    version = "1.0.1";

    src = fetchurl {
      url = "http://bitbucket.org/izi/polib/downloads/${name}.tar.gz";
      sha256 = "1sr2bb3g7rl7gr6156j5qv71kg06q1x01r1lbps9ksnyz37djn2q";
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

    src = fetchurl {
      url    = "https://github.com/Lokaltog/powerline/tarball/${rev}";
      name   = "${name}.tar.bz";
      sha256 = "1csd4vasy0avwfxrpdr61plj6k1nzf36f6qvd9kl15s3lnspsfaz";
    };

    propagatedBuildInputs = [ pkgs.git pkgs.mercurial pkgs.bazaar pythonPackages.psutil pythonPackages.pygit2 ];

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
      description = "The ultimate statusline/prompt utility.";
      license     = licenses.mit;
      maintainers = with maintainers; [ lovek323 ];
      platforms   = platforms.all;
    };
  };


  prettytable = buildPythonPackage rec {
    name = "prettytable-0.7.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/PrettyTable/${name}.tar.bz2";
      sha1 = "ad346a18d92c1d95f2295397c7a8a4f489e48851";
    };

    meta = {
      description = "Simple Python library for easily displaying tabular data in a visually appealing ASCII table format";
      homepage = http://code.google.com/p/prettytable/;
    };
  };


  protobuf = buildPythonPackage rec {
    inherit (pkgs.protobuf) name src;

    propagatedBuildInputs = [pkgs.protobuf];
    sourceRoot = "${name}/python";

    meta = {
      description = "Protocol Buffers are Google's data interchange format.";
      homepage = http://code.google.com/p/protobuf/;
    };
  };


  psutil = buildPythonPackage rec {
    name = "psutil-1.0.1";

    src = fetchurl {
      url = "http://psutil.googlecode.com/files/${name}.tar.gz";
      sha256 = "1zrzh7hi0f79sf9axwrw3c2kl86qs72kvx8xbbrdwlp39rfa1i1f";
    };

    # failed tests: https://code.google.com/p/psutil/issues/detail?id=434
    doCheck = false;

    meta = {
      description = "Process and system utilization information interface for python";
      homepage = http://code.google.com/p/psutil/;
    };
  };


  psycopg2 = buildPythonPackage rec {
    name = "psycopg2-2.5.2";

    # error: invalid command 'test'
    doCheck = false;

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/p/psycopg2/${name}.tar.gz";
      sha256 = "0bmxlmi9k995n6pz16awjaap0y02y1v2d31jbxhkqv510f3jsf2h";
    };

    propagatedBuildInputs = [ pkgs.postgresql ];

    meta = {
      description = "PostgreSQL database adapter for the Python programming language";
      license = "GPLv2/ZPL";
    };
  };


  publicsuffix = buildPythonPackage rec {
    name = "publicsuffix-${version}";
    version = "1.0.2";

    src = fetchurl {
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
    name = "py-1.4.20";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/p/py/${name}.tar.gz";
      md5 = "5f1708be5482f3ff6711dfd6cafd45e0";
    };
  };


  pyasn1 = buildPythonPackage ({
    name = "pyasn1-0.1.7";

    src = fetchurl {
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

    src = fetchurl {
      url = "http://people.csail.mit.edu/hubert/pyaudio/packages/pyaudio-${version}.tar.gz";
      md5 = "623809778f3d70254a25492bae63b575";
    };

    buildInputs = [ python pkgs.portaudio ];

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


  pygit2 = buildPythonPackage rec {
    name = "pygit2-0.20.0";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/p/pygit2/${name}.tar.gz";
      sha256 = "04132q7bn8k7q7ky7nj3bkza8r9xkzkdpfv462b6rgjsd1x6h340";
    };

    preConfigure = ( if stdenv.isDarwin then ''
      export DYLD_LIBRARY_PATH="${pkgs.libgit2}/lib"
    '' else "" );

    propagatedBuildInputs = [ pkgs.libgit2 ];

    meta = {
      homepage = https://pypi.python.org/pypi/pygit2;
      description = "Pygit2 is a set of Python bindings to the libgit2 shared library.";
      license = with stdenv.lib.licenses; gpl2;
      platforms = with stdenv.lib.platforms; all;
    };
  };


  Babel = buildPythonPackage (rec {
    name = "Babel-1.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/B/Babel/${name}.tar.gz";
      sha256 = "0bnin777lc53nxd1hp3apq410jj5wx92n08h7h4izpl4f4sx00lz";
    };

    propagatedBuildInputs = [ pytz ];

    meta = {
      homepage = http://babel.edgewall.org;
      description = "A collection of tools for internationalizing Python applications.";
      license = "BSD";
      maintainers = [ stdenv.lib.maintainers.garbas ];
      platforms = stdenv.lib.platforms.linux;
    };
  });


  pyblock = stdenv.mkDerivation rec {
    name = "pyblock-${version}";
    version = "0.53";

    src = fetchurl rec {
      url = "http://pkgs.fedoraproject.org/repo/pkgs/python-pyblock/"
          + "${name}.tar.bz2/${md5}/${name}.tar.bz2";
      md5 = "f6d33a8362dee358517d0a9e2ebdd044";
    };

    postPatch = ''
      sed -i -e 's|/usr/include/python|${python}/include/python|' \
             -e 's/-Werror *//' -e 's|/usr/|'"$out"'/|' Makefile
    '';

    buildInputs = [ python pkgs.lvm2 pkgs.dmraid ];

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
    name = "pycapnp-0.4.4";
    homepage = "http://jparyani.github.io/pycapnp/index.html";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/p/pycapnp/${name}.tar.gz";
      sha256 = "33b2b79438bb9bf37097966e1c90403c34ab49be1eb647ee251b62f362ee3537";
    };

    buildInputs = with pkgs; [ capnproto cython ];

    # import setuptools as soon as possible, to minimize monkeypatching mayhem.
    postConfigure = ''
      sed -i '2iimport setuptools' setup.py
    '';

    meta = with stdenv.lib; {
      maintainers = with maintainers; [ cstrahan ];
      license = stdenv.lib.licenses.bsd2;
      platforms = stdenv.lib.platforms.all;
    };
  };


  pycryptopp = buildPythonPackage (rec {
    name = "pycryptopp-0.6.0.1206569328141510525648634803928199668821045408958";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/pycryptopp/${name}.tar.gz";
      sha256 = "0n90h1yg7bfvlbhnc54xb6dbqm286ykaksyg04kxlhyjgf8mhq8i";
    };

    # Prefer crypto++ library from the Nix store over the one that's included
    # in the pycryptopp distribution.
    preConfigure = "export PYCRYPTOPP_DISABLE_EMBEDDED_CRYPTOPP=1";

    buildInputs = [ setuptoolsDarcs darcsver pkgs.cryptopp ];

    meta = {
      homepage = http://allmydata.org/trac/pycryptopp;

      description = "Python wrappers for the Crypto++ library";

      license = "GPLv2+";

      maintainers = [ ];
      platforms = stdenv.lib.platforms.linux;
    };
  });


  pycurl = buildPythonPackage (rec {
    name = "pycurl-7.19.0";

    src = fetchurl {
      url = "http://pycurl.sourceforge.net/download/${name}.tar.gz";
      sha256 = "0hh6icdbp7svcq0p57zf520ifzhn7jw64x07k99j7h57qpy2sy7b";
    };

    buildInputs = [ pkgs.curl ];

    # error: invalid command 'test'
    doCheck = false;

    preConfigure = ''
      substituteInPlace setup.py --replace '--static-libs' '--libs'
    '';

    meta = {
      homepage = http://pycurl.sourceforge.net/;
      description = "Python wrapper for libcurl";
      platforms = stdenv.lib.platforms.linux;
    };
  });


  pycurl2 = buildPythonPackage (rec {
    name = "pycurl2-7.20.0";

    src = fetchgit {
      url = "https://github.com/Lispython/pycurl.git";
      rev = "0f00109950b883d680bd85dc6e8a9c731a7d0d13";
      sha256 = "0mhg7f9y5zl0m2xgz3rf1yqjd6l8n0qhfk7bpf36r44jfnhj75ld";
    };

    # error: (6, "Couldn't resolve host 'h.wrttn.me'")
    doCheck = false;

    buildInputs = [ pkgs.curl simplejson unittest2 nose ];

    meta = {
      homepage = https://pypi.python.org/pypi/pycurl2;
      description = "A fork from original PycURL library that no maintained from 7.19.0";
      platforms = stdenv.lib.platforms.linux;
    };
  });


  pydot = buildPythonPackage rec {
    name = "pydot-1.0.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/pydot/${name}.tar.gz";
      md5 = "cd739651ae5e1063a89f7efd5a9ec72b";
    };
    propagatedBuildInputs = [pyparsing pkgs.graphviz];
    meta = {
      homepage = http://code.google.com/p/pydot/;
      description = "pydot allows to easily create both directed and non directed graphs from Python.";
    };
  };

  pyfeed = buildPythonPackage rec {
    url = "http://www.blarg.net/%7Esteveha/pyfeed-0.7.4.tar.gz";
    name = stdenv.lib.nameFromURL url ".tar";
    src = fetchurl {
      inherit url;
      sha256 = "1h4msq573m7wm46h3cqlx4rsn99f0l11rhdqgf50lv17j8a8vvy1";
    };
    propagatedBuildInputs = [xe];

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = "http://home.blarg.net/~steveha/pyfeed.html";
      description = "Tools for syndication feeds";
    };
  };

  pyflakes = buildPythonPackage rec {
    name = "pyflakes-0.8.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyflakes/${name}.tar.gz";
      md5 = "905fe91ad14b912807e8fdc2ac2e2c23";
    };

    buildInputs = [ unittest2 ];

    meta = {
      homepage = "https://launchpad.net/pyflakes";
      description = "A simple program which checks Python source files for errors.";
      license = licenses.mit;
      maintainers = [ stdenv.lib.maintainers.garbas ];
    };
  };

  pyglet = buildPythonPackage rec {
    name = "pyglet-1.1.4";

    src = fetchurl {
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

    src = fetchurl {
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

    src = fetchurl {
      url = "https://launchpad.net/pygpgme/trunk/${version}/+download/${name}.tar.gz";
      sha256 = "5fd887c407015296a8fd3f4b867fe0fcca3179de97ccde90449853a3dfb802e1";
    };

    # error: invalid command 'test'
    doCheck = false;

    propagatedBuildInputs = [ pkgs.gpgme ];

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

    src = fetchgit {
      url = "git://github.com/seb-m/pyinotify.git";
      rev = "refs/tags/${version}";
      sha256 = "d38ce95e4af00391e58246a8d7fe42bdb51d63054b09809600b2faef2a803472";
    };

    buildInputs = [ python ];

    installPhase = ''
      ${python}/bin/${python.executable} setup.py install --prefix=$out
    '';

    meta = {
      homepage = https://github.com/seb-m/pyinotify/wiki;
      description = "Monitor filesystems events on Linux platforms with inotify";
      license = licenses.mit;
    };
  };


  pykickstart = buildPythonPackage rec {
    name = "pykickstart-${version}";
    version = "1.99.39";

    src = fetchurl rec {
      url = "http://pkgs.fedoraproject.org/repo/pkgs/pykickstart/"
          + "${name}.tar.gz/${md5}/${name}.tar.gz";
      md5 = "d249f60aa89b1b4facd63f776925116d";
    };

    postPatch = ''
      sed -i -e "s/for tst in tstList/for tst in sorted(tstList, \
                 key=lambda m: m.__name__)/" tests/baseclass.py
    '';

    propagatedBuildInputs = [ urlgrabber ];

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

    src = fetchurl {
      url = "https://pyodbc.googlecode.com/files/${name}.zip";
      sha256 = "0ldkm8xws91j7zbvpqb413hvdz8r66bslr451q3qc0xi8cnmydfq";
    };

    buildInputs = [ pkgs.libiodbc ];

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

    src = fetchurl {
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

    src = fetchurl {
      url = "https://fedorahosted.org/releases/p/y/pyparted/${name}.tar.gz";
      sha256 = "17wq4invmv1nfazaksf59ymqyvgv3i8h4q03ry2az0s9lldyg3dv";
    };

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

    buildInputs = [ pkgs.pkgconfig ];

    propagatedBuildInputs = [ pkgs.parted ];

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
    version = "0.0.3";
    src = fetchurl {
      url = "https://pypi.python.org/packages/source/p/pyptlib/pyptlib-${version}.tar.gz";
      sha256 = "0mklak456jqifx57j9jmpb69h3ybxc880qk86pg4g8jk0i14pxh3";
    };
    meta = {
      description = "A python implementation of the Pluggable Transports for Circumvention specification for Tor";
      license = stdenv.lib.licenses.bsd2;
    };
  });

  pyrss2gen = buildPythonPackage (rec {
    name = "PyRSS2Gen-1.0.0";

    src = fetchurl {
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

  python_fedora = buildPythonPackage (rec {
    name = "python-fedora-0.3.33";
    meta.maintainers = [ stdenv.lib.maintainers.mornfall ];

    src = fetchurl {
      url = "https://fedorahosted.org/releases/p/y/python-fedora/${name}.tar.gz";
      sha256 = "1g05bh7d5d0gzrlnhpnca7jpqbgs2rgnlzzbvzzxmdbmlkqi3mws";
    };
    propagatedBuildInputs = [ kitchen requests bunch paver ];
    doCheck = false;
  });

  python_keyczar = buildPythonPackage rec {
    name = "python-keyczar-0.71c";

    src = fetchurl {
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

    buildInputs = [ pyasn1 pycrypto ];
  };

  pyudev = buildPythonPackage rec {
    name = "pyudev-${version}";
    version = "0.16.1";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/p/pyudev/${name}.tar.gz";
      md5 = "4034de584b6d9efcbfc590a047c63285";
    };

    postPatch = ''
      sed -i -e '/udev_library_name/,/^ *libudev/ {
        s|CDLL([^,]*|CDLL("${pkgs.udev}/lib/libudev.so.1"|p; d
      }' pyudev/_libudev.py
    '';

    propagatedBuildInputs = [ pkgs.udev ];

    meta = {
      homepage = "http://pyudev.readthedocs.org/";
      description = "Pure Python libudev binding";
      license = stdenv.lib.licenses.lgpl21Plus;
      platforms = stdenv.lib.platforms.linux;
    };
  };


  pynzb = buildPythonPackage (rec {
    name = "pynzb-0.1.0";

    src = fetchurl {
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

    src = fetchurl {
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

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/python-ldap/python-${name}.tar.gz";
      sha256 = "0w0nn5yj0nbbkvpbqgfni56v7sjx6jf6s6zvp9zmahyrvqrsrg1h";
    };

    NIX_CFLAGS_COMPILE = "-I${pkgs.cyrus_sasl}/include/sasl";
    propagatedBuildInputs = [pkgs.openldap pkgs.cyrus_sasl pkgs.openssl];
  };


  pylibacl = buildPythonPackage (rec {
    name = "pylibacl-0.5.1";

    src = fetchurl {
      url = "https://github.com/downloads/iustin/pylibacl/${name}.tar.gz";
      sha256 = "1idks7j9bn62xzsaxkvhl7bdq6ws8kv8aa0wahfh7724qlbbcf1k";
    };

    # ERROR: testExtended (tests.test_acls.AclExtensions)
    # IOError: [Errno 0] Error
    doCheck = false;

    buildInputs = [ pkgs.acl ];

    meta = {
      description = "A Python extension module for POSIX ACLs. It can be used to query, list, add, and remove ACLs from files and directories under operating systems that support them.";
      license = stdenv.lib.licenses.lgpl21Plus;
    };
  });


  pymacs = pkgs.stdenv.mkDerivation rec {
    version = "0.25";
    name = "Pymacs-${version}";

    src = fetchurl {
      url = "https://github.com/pinard/Pymacs/tarball/v${version}";
      name = "${name}.tar.gz";
      sha256 = "1hmy76c5igm95rqbld7gvk0az24smvc8hplfwx2f5rhn6frj3p2i";
    };

    buildInputs = [ python ];

    patchPhase = ''
      sed -e "s@ install@ install --prefix=$out@g" -i Makefile
    '';

    meta = with stdenv.lib; {
      description = "Emacs Lisp to Python interface";
      homepage = http://pymacs.progiciels-bpi.ca;
      license = licenses.gpl2;
      maintainers = [ maintainers.goibhniu ];
    };
  };

  pyopengl =
    let version = "3.0.2";
    in
      buildPythonPackage {
        name = "pyopengl-${version}";

        src = fetchurl {
          url = "http://pypi.python.org/packages/source/P/PyOpenGL/PyOpenGL-${version}.tar.gz";
          sha256 = "9ef93bbea2c193898341f574e281c3ca0dfe87c53aa25fbec4b03581f6d1ba03";
        };

        propagatedBuildInputs = with pkgs; [ mesa freeglut pil ];

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


  pyquery = buildPythonPackage rec {
    name = "pyquery-1.2.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyquery/${name}.tar.gz";
      md5 = "268f08258738d21bc1920d7522f2a63b";
    };

    propagatedBuildInputs = [ cssselect lxml ];
  };

  pyrax = buildPythonPackage rec {
    name = "pyrax-1.8.2";

    src = fetchurl {
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

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyreport/${name}.tar.gz";
      md5 = "3076164a7079891d149a23f9435581db";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://pypi.python.org/pypi/pyreport;
      license = "BSD";
      description = "Pyreport makes notes out of a python script.";
    };
  });


  pyserial = buildPythonPackage rec {
    name = "pyserial-2.7";

    src = fetchurl {
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

    src = fetchurl {
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

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/p/pysqlite/${name}.tar.gz";
      sha256 = "13djzgnbi71znjjyaw4nybg6smilgszcid646j5qav7mdchkb77y";
    };

    # Since the `.egg' file is zipped, the `NEEDED' of the `.so' files
    # it contains is not taken into account.  Thus, we must explicitly make
    # it a propagated input.
    propagatedBuildInputs = [ pkgs.sqlite ];

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

    src = fetchurl {
      url = "http://pysvn.barrys-emacs.org/source_kits/pysvn-1.7.8.tar.gz";
      sha256 = "1qk7af0laby1f79bd07l9p0dxn5xmcmfwlcb9l1hk29zwwq6x4v0";
    };

    buildInputs = [ python pkgs.subversion pkgs.apr pkgs.aprutil pkgs.expat pkgs.neon pkgs.openssl ]
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

    src = fetchurl {
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

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyutil/${name}.tar.gz";
      sha256 = "c303bb779f96073820e2eb7c9692fe15a57df491eb356839f3cb3377ed03b844";
    };

    buildInputs = [ setuptoolsDarcs setuptoolsTrial ] ++ (if doCheck then [ simplejson ] else []);
    propagatedBuildInputs = [ zbase32 argparse twisted ];
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

      license = "GPLv2+";
    };
  });


  pywebkitgtk = stdenv.mkDerivation rec {
    name = "pywebkitgtk-${version}";
    version = "1.1.8";

    src = fetchurl {
      url = "http://pywebkitgtk.googlecode.com/files/${name}.tar.bz2";
      sha256 = "1svlwyl61rvbqbcbalkg6pbf38yjyv7qkq9sx4x35yk69lscaac2";
    };

    buildInputs = with pkgs; [
      pkgconfig python gtk2 pygtk libxml2 libxslt libsoup webkitgtk2 icu
    ];

    meta = {
      homepage = "https://code.google.com/p/pywebkitgtk/";
      description = "Python bindings for the WebKit GTK+ port";
      license = stdenv.lib.licenses.lgpl2Plus;
    };
  };


  pyxattr = buildPythonPackage (rec {
    name = "pyxattr-0.5.1";

    src = fetchurl {
      url = "https://github.com/downloads/iustin/pyxattr/${name}.tar.gz";
      sha256 = "0jmkffik6hdzs7ng8c65bggss2ai40nm59jykswdf5lpd36cxddq";
    };

    # error: invalid command 'test'
    doCheck = false;

    buildInputs = [ pkgs.attr ];

    meta = {
      description = "A Python extension module which gives access to the extended attributes for filesystem objects available in some operating systems.";
      license = stdenv.lib.licenses.lgpl21Plus;
    };
  });


  pyyaml = buildPythonPackage (rec {
    name = "PyYAML-3.10";

    src = fetchurl {
      url = "http://pyyaml.org/download/pyyaml/${name}.zip";
      sha256 = "1r127fa354ppb667f4acxlzwxixap1jgzjrr790bw8mcpxv2hqaa";
    };

    buildInputs = [ pkgs.pyrex ];
    propagatedBuildInputs = [ pkgs.libyaml ];

    meta = {
      description = "The next generation YAML parser and emitter for Python";
      homepage = http://pyyaml.org;
      license = "free"; # !?
    };
  });


  recaptcha_client = buildPythonPackage rec {
    name = "recaptcha-client-1.0.6";

    src = fetchurl {
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
    name = "reportlab-2.5";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/r/reportlab/${name}.tar.gz";
      md5 = "cdf8b87a6cf1501de1b0a8d341a217d3";
    };

    buildInputs = [freetype];

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      description = "The ReportLab Toolkit. An Open Source Python library for generating PDFs and graphics.";
      homepage = http://www.reportlab.com/;
    };
  };


  requests = buildPythonPackage rec {
    name = "requests-1.2.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/r/requests/${name}.tar.gz";
      md5 = "22af2682233770e5468a986f451c51c0";
    };

    meta = {
      description = "Requests is an Apache2 Licensed HTTP library, written in Python, for human beings..";
      homepage = http://docs.python-requests.org/en/latest/;
    };
  };


  requests2 = buildPythonPackage rec {
    name = "requests-2.2.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/r/requests/${name}.tar.gz";
      md5 = "ac27081135f58d1a43e4fb38258d6f4e";
    };

    meta = {
      description = "Requests is an Apache2 Licensed HTTP library, written in Python, for human beings..";
      homepage = http://docs.python-requests.org/en/latest/;
    };
  };


  requests_oauthlib = buildPythonPackage rec {
    name = "requests-oauthlib-0.3.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/r/requests-oauthlib/${name}.tar.gz";
      md5 = "35b3b750493c231145c39db0216813e7";
    };

    propagatedBuildInputs = [ oauthlib requests ];

    meta = {
      description = "OAuthlib authentication support for Requests";
      homepage = https://github.com/requests/requests-oauthlib;
    };
  };


  qutip = buildPythonPackage rec {
    name = "qutip-2.2.0";

    src = fetchurl {
      url = "https://qutip.googlecode.com/files/QuTiP-2.2.0.tar.gz";
      sha1 = "76ba4991322a991d580e78a197adc80d58bd5fb3";
    };

    propagatedBuildInputs = [ numpy scipy matplotlib pkgs.pyqt4
      pkgs.cython ];

    buildInputs = with pkgs; [ gcc qt4 blas ] ++ [ nose ];

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

    src = fetchurl {
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

    src = fetchurl {
      url = https://github.com/maraujop/requests-oauth2/archive/0.1.1.tar.gz;
      sha256 = "1aij66qg9j5j4vzyh64nbg72y7pcafgjddxsi865racsay43xfqg";
    };

    propagatedBuildInputs = [ requests_oauthlib ];

    meta = {
      description = "Python's Requests OAuth2 (Open Authentication) plugin";
      homepage = https://github.com/maraujop/requests-oauth2;
    };
  };


  reviewboard = buildPythonPackage rec {
    name = "ReviewBoard-1.6.16";

    src = fetchurl {
      url = "http://downloads.reviewboard.org/releases/ReviewBoard/1.6/${name}.tar.gz";
      sha256 = "0vg3ypm57m43bscv8vswjdllv3d2j8lxqwwvpd65cl7jd1in0yr1";
    };

    propagatedBuildInputs =
      [ recaptcha_client pytz memcached dateutil_1_5 paramiko flup pygments
        djblets django_1_3 django_evolution pycrypto modules.sqlite3
        pysvn pil psycopg2
      ];
  };


  rdflib = buildPythonPackage (rec {
    name = "rdflib-3.0.0";

    src = fetchurl {
      url = "http://www.rdflib.net/${name}.tar.gz";
      sha256 = "1c7ipk5vwqnln83rmai5jzyxkjdajdzbk5cgy1z83nyr5hbkgkqr";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      description = "RDFLib is a Python library for working with RDF, a simple yet powerful language for representing information.";
      homepage = http://www.rdflib.net/;
    };
  });


  robotframework = buildPythonPackage rec {
    version = "2.8.4";
    name = "robotframework-${version}";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/r/robotframework/${name}.tar.gz";
      sha256 = "0rxk135c1051cwv45219ib3faqvi5rl50l98ncb83c7qxy92jg2n";
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
    version = "1.5.0";
    name = "robotframework-selenium2library-${version}";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/r/robotframework-selenium2library/${name}.tar.gz";
      sha256 = "0hjmar9766jqfpbckac8zncyal546vm059wnkbn33f68djdcnwz1";
    };

    # error: invalid command 'test'
    #doCheck = false;

    propagatedBuildInputs = [ robotframework selenium docutils decorator ];

    meta = with stdenv.lib; {
      description = "";
      homepage = http://robotframework.org/;
      license = licenses.asl20;
    };
  };


  robotsuite = buildPythonPackage rec {
    version = "1.4.2";
    name = "robotsuite-${version}";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/r/robotsuite/${name}.zip";
      sha256 = "0sw09vrvwv3gzqb6jvhbrz09l6nzzj3i9av34qjddqfwq7cr1bla";
    };

    # error: invalid command 'test'
    #doCheck = false;

    buildInputs = [ unittest2 ];
    propagatedBuildInputs = [ robotframework lxml ];

    meta = with stdenv.lib; {
      description = "Python unittest test suite for Robot Framework";
      homepage = http://github.com/collective/robotsuite/;
      license = licenses.gpl3;
    };
  };


  robotframework-ride = buildPythonPackage rec {
    version = "1.2.3";
    name = "robotframework-ride-${version}";

    src = fetchurl {
      url = "https://robotframework-ride.googlecode.com/files/${name}.tar.gz";
      sha256 = "1lf5f4x80f7d983bmkx12sxcizzii21kghs8kf63a1mj022a5x5j";
    };

    propagatedBuildInputs = [ pygments wxPython modules.sqlite3 ];

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
    version = "0.9.4";
    name = "rope-${version}";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/r/rope/${name}.tar.gz";
      sha256 = "1fm6ahff50b10mlnc0ar4x1fv9sxmcp1g651myyqy7c50hk39h1d";
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

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/r/ropemacs/${name}.tar.gz";
      sha256 = "1x5qf1drcdz9jfiiakc60kzqkb3ahsg9j902c5byf3gjfacdrmqj";
    };

    propagatedBuildInputs = [ ropemode ];

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

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/r/ropemode/${name}.tar.gz";
      sha256 = "0jw6h1wvk6wk0wknqdf7s9pw76m8472jv546lqdd88jbl2scgcjl";
    };

    propagatedBuildInputs = [ rope ];

     meta = with stdenv.lib; {
       description = "a plugin for performing python refactorings in emacs";
       homepage = http://rope.sf.net;
       maintainers = [ maintainers.goibhniu ];
       license = licenses.gpl2;
     };
  };



  routes = buildPythonPackage rec {
    name = "routes-1.12.3";

    src = fetchurl {
      url = http://pypi.python.org/packages/source/R/Routes/Routes-1.12.3.tar.gz;
      md5 = "9740ff424ff6b841632c784a38fb2be3";
    };

    propagatedBuildInputs = [ paste webtest ];

    meta = {
      description = "A Python re-implementation of the Rails routes system for mapping URLs to application actions";
      homepage = http://routes.groovie.org/;
    };
  };

  rpkg = buildPythonPackage (rec {
    name = "rpkg-1.14";
    meta.maintainers = [ stdenv.lib.maintainers.mornfall ];

    src = fetchurl {
      url = "https://fedorahosted.org/releases/r/p/rpkg/rpkg-1.14.tar.gz";
      sha256 = "0d053hdjz87aym1sfm6c4cxmzmy5g0gkrmrczly86skj957r77a7";
    };

    patches = [ ../development/python-modules/rpkg-buildfix.diff ];

    # buildPhase = "python setup.py build";
    # doCheck = false;
    propagatedBuildInputs = [ pycurl koji GitPython pkgs.git
                              pkgs.rpm pkgs.pyopenssl ];

  });

  rsa = buildPythonPackage rec {
    name = "rsa-3.1.2";

    src = fetchurl {
      url = "https://bitbucket.org/sybren/python-rsa/get/version-3.1.2.tar.bz2";
      sha256 = "0ag2q4gaapi74x47q74xhcjzs4b7r2bb6zrj2an4sz5d3yd06cgf";
    };

    buildInputs = [ pythonPackages.pyasn1 ];

    meta = {
      homepage = http://stuvel.eu/rsa;
      license = "Apache License 2.0";
      description = "A pure-Python RSA implementation";
    };
  };

  rtslib_fb = buildPythonPackage rec {
    version = "2.1.fb43";
    name = "rtslib-fb-${version}";

    src = fetchurl {
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
    name = "seqdiag-0.9.0";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/s/seqdiag/${name}.tar.gz";
      md5 = "92946555ce219df18002e6c88b4055d3";
    };

    buildInputs = [ pep8 nose unittest2 docutils ];

    propagatedBuildInputs = [ blockdiag ];

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


  scipy = buildPythonPackage rec {
    name = "scipy-0.12.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/s/scipy/${name}.tar.gz";
      md5 = "8fb4da324649f655e8557ea92b998786";
    };

    buildInputs = [pkgs.gfortran];
    propagatedBuildInputs = [ numpy ];

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


  scripttest = buildPythonPackage rec {
    version = "1.3";
    name = "scripttest-${version}";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/s/scripttest/scripttest-${version}.tar.gz";
      md5 = "1d1c5117ccfc7b5961cae6c1020c0848";
    };

    buildInputs = [ nose pytest ];

    meta = {
      description = "A library for testing interactive command-line applications";
      homepage = http://pypi.python.org/pypi/ScriptTest/;
    };
  };

  selenium = buildPythonPackage rec {
    name = "selenium-2.39.0";
    src = pkgs.fetchurl {
      url = "http://pypi.python.org/packages/source/s/selenium/${name}.tar.gz";
      sha256 = "1kisndzl9s0vs0a5paqx35hxq28id3xyi1gfsjaixsi6rs0ibhhh";
    };

    buildInputs = [pkgs.xlibs.libX11];

    # Recompiling x_ignore_nofocus.so as the original one dlopen's libX11.so.6 by some
    # absolute paths. Replaced by relative path so it is found when used in nix.
    x_ignore_nofocus =
      pkgs.fetchsvn {
        url = http://selenium.googlecode.com/svn/tags/selenium-2.25.0/cpp/linux-specific;
        rev = 17641;
        sha256 = "1wif9r6307qhlcp2zbg6n05yvxxn9ppkxh8gpsplcbyh22zi7bcd";
      };

    preInstall = ''
      cp "${x_ignore_nofocus}/"* .
      sed -i 's|dlopen(library,|dlopen("libX11.so.6",|' x_ignore_nofocus.c
      gcc -c -fPIC x_ignore_nofocus.c -o x_ignore_nofocus.o
      gcc -shared \
        -Wl,${if stdenv.isDarwin then "-install_name" else "-soname"},x_ignore_nofocus.so \
        -o x_ignore_nofocus.so \
        x_ignore_nofocus.o \
        ${if stdenv.isDarwin then "-lx11" else ""}
      cp -v x_ignore_nofocus.so py/selenium/webdriver/firefox/${if pkgs.stdenv.is64bit then "amd64" else "x86"}/
    '';
  };

  setuptoolsDarcs = buildPythonPackage {
    name = "setuptools-darcs-1.2.9";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/s/setuptools_darcs/setuptools_darcs-1.2.9.tar.gz";
      sha256 = "d37ce11030addbd729284c441facd0869cdc6e5c888dc5fa0a6f1edfe3c3e617";
    };

    # In order to break the dependency on darcs -> ghc, we don't add
    # darcs as a propagated build input.
    propagatedBuildInputs = [ darcsver ];

    meta = {
      description = "setuptools plugin for the Darcs version control system";

      homepage = http://allmydata.org/trac/setuptools_darcs;

      license = "BSD";
    };
  };


  setuptoolsTrial = buildPythonPackage {
    name = "setuptools-trial-0.5.12";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/s/setuptools_trial/setuptools_trial-0.5.12.tar.gz";
      md5 = "f16f4237c9ee483a0cd13208849d96ad";
    };

    propagatedBuildInputs = [ twisted ];

    meta = {
      description = "setuptools plug-in that helps run unit tests built with the \"Trial\" framework (from Twisted)";

      homepage = http://allmydata.org/trac/setuptools_trial;

      license = "unspecified"; # !
    };
  };


  simplejson = buildPythonPackage (rec {
    name = "simplejson-3.3.0";

    src = fetchurl {
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

      license = "MIT";
    };
  });

  sigal = buildPythonPackage rec {
    name = "sigal-0.5.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/s/sigal/${name}.tar.gz";
      md5 = "93c93725674c0702583a638f5a09c9e4";
    };

    propagatedBuildInputs = [ jinja2 markdown pillow pilkit clint argh pytest ];

    meta = with stdenv.lib; {
      description = "Yet another simple static gallery generator";
      homepage = http://sigal.saimon.org/en/latest/index.html;
      license = licenses.mit;
      maintainers = [ maintainers.iElectric ];
    };
  };

  spambayes = buildPythonPackage rec {
    name = "spambayes-1.1a6";

    src = fetchurl {
      url = "mirror://sourceforge/spambayes/${name}.tar.gz";
      sha256 = "0lqhn2v0avgwxmk4dq9lkwr2g39ls2p6x8hqk5w07wd462cjsx8l";
    };

    propagatedBuildInputs = [ pydns lockfile ];

    meta = with stdenv.lib; {
      description = "Statistical anti-spam filter, initially based on the work of Paul Graham";
      homepage = http://spambayes.sourceforge.net/;
    };
  };

  shapely = buildPythonPackage rec {
    name = "Shapely-1.3.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/S/Shapely/${name}.tar.gz";
      sha256 = "099sc7ajpp6hbgrx3c0bl6hhkz1mhnr0ahvc7s4i3f3b7q1zfn7l";
    };

    buildInputs = [ pkgs.geos ];

    preConfigure = ''
      export LANG="en_US.UTF-8";
    '' + stdenv.lib.optionalString stdenv.isLinux ''
      export LOCALE_ARCHIVE="${pkgs.glibcLocales}/lib/locale/locale-archive";
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

  pydns = buildPythonPackage rec {
    name = "pydns-2.3.6";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/p/pydns/${name}.tar.gz";
      sha256 = "0qnv7i9824nb5h9psj0rwzjyprwgfiwh5s5raa9avbqazy5hv5pi";
    };

    doCheck = false;

    meta = with stdenv.lib; {
    };
  };

  sympy = buildPythonPackage rec {
    name = "sympy-0.7.3";

    src = fetchurl {
      url    = "https://github.com/sympy/sympy/releases/download/${name}/${name}.tar.gz";
      sha256 = "081g9gs2d1d41ipn8zr034d98cnrxvc4zsmihqmfwzirwzpcii5x";
    };

    meta = with stdenv.lib; {
      description = "A Python library for symbolic mathematics";
      homepage    = http://www.sympy.org/;
      license     = "free";
      maintainers = with maintainers; [ lovek323 ];
      platforms   = platforms.unix;
    };
  };

  pilkit = buildPythonPackage rec {
    name = "pilkit-1.1.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/pilkit/${name}.tar.gz";
      md5 = "659dd67440f4b576889f2cd350f43d7b";
    };

    preConfigure = ''
      substituteInPlace setup.py --replace 'nose==1.2.1' 'nose'
    '';

    # tests fail, see https://github.com/matthewwithanm/pilkit/issues/9
    doCheck = false;

    buildInputs = [ pillow nose_progressive nose mock blessings ];

    meta = with stdenv.lib; {
      maintainers = [ maintainers.iElectric ];
    };
  };

  clint = buildPythonPackage rec {
    name = "clint-0.3.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/c/clint/${name}.tar.gz";
      md5 = "7dcd43fb08bfb84c7d63e9356ada7b73";
    };

    checkPhase = ''
      nosetests
    '';

    buildInputs = [ pillow nose_progressive nose mock blessings nose ];

    meta = with stdenv.lib; {
      maintainers = [ maintainers.iElectric ];
    };
  };

  argh = buildPythonPackage rec {
    name = "argh-0.23.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/a/argh/${name}.tar.gz";
      md5 = "25bb02c6552b42875f2c36714e0ff16c";
    };

    preCheck = ''
      export LANG="en_US.UTF-8"
      export LOCALE_ARCHIVE=${pkgs.glibcLocales}/lib/locale/locale-archive
    '';

    buildInputs = [ pytest py mock ];

    meta = with stdenv.lib; {
      maintainers = [ maintainers.iElectric ];
    };
  };

  nose_progressive = buildPythonPackage rec {
    name = "nose-progressive-1.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/n/nose-progressive/${name}.tar.gz";
      md5 = "180be93929c5962044a35489f193259d";
    };

    buildInputs = [ pillow blessings nose ];
    propagatedBuildInputs = [ modules.curses ];

    meta = with stdenv.lib; {
      maintainers = [ maintainers.iElectric ];
    };
  };

  blessings = buildPythonPackage rec {
    name = "blessings-1.5.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/b/blessings/${name}.tar.gz";
      md5 = "fbbddbf20b1f9a13e3fa612b1e086fd8";
    };

    # 4 failing tests
    doCheck = false;

    buildInputs = [ nose modules.curses ];

    meta = with stdenv.lib; {
      maintainers = [ maintainers.iElectric ];
    };
  };

  sexpdata = buildPythonPackage rec {
    name = "sexpdata-0.0.2";
    src = fetchurl {
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

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/s/sh/${name}.tar.gz";
      md5 = "4028bcba85daa0aef579ed24261e88a3";
    };

    doCheck = false;

    meta = {
      description = "Python subprocess interface";
      homepage = http://pypi.python.org/pypi/sh/;
    };
  };


  six = buildPythonPackage rec {
    name = "six-1.7.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/s/six/${name}.tar.gz";
      md5 = "784c6e5541c3c4952de9c0a966a0a80b";
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

    src = fetchurl {
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

    propagatedBuildInputs = [ pkgs.xlibs.libX11 pkgs.pythonDBus pygobject ];

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

    src = fetchurl {
      url = https://pypi.python.org/packages/source/s/smartdc/smartdc-0.1.12.tar.gz;
      md5 = "b960f61facafc879142b699050f6d8b4";
    };

    propagatedBuildInputs = [ requests http_signature ];

    meta = {
      description = "Joyent SmartDataCenter CloudAPI connector using http-signature authentication via Requests";
      homepage = https://github.com/atl/py-smartdc;
      license = licenses.mit;
    };
  };

  sorl_thumbnail = buildPythonPackage rec {
    name = "sorl-thumbnail-11.12";

    src = fetchurl {
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
    name = "supervisor-3.0";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/s/supervisor/${name}.tar.gz";
      md5 = "94ff3cf09618c36889425a8e002cd51a";
    };

    buildInputs = [ mock ];
    propagatedBuildInputs = [ meld3 ];

    # failing tests when building under chroot as root user doesn't exist
    doCheck = false;

    meta = {
      description = "A system for controlling process state under UNIX";
      homepage = http://supervisord.org/;
    };
  };

  subprocess32 = buildPythonPackage rec {
    name = "subprocess32-3.2.6";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/s/subprocess32/${name}.tar.gz";
      md5 = "754c5ab9f533e764f931136974b618f1";
    };

    doCheck = false;

    meta = {
      homepage = "https://pypi.python.org/pypi/subprocess32";
      description = "Backport of the subprocess module from Python 3.2.5 for use on 2.x.";
      maintainers = [ stdenv.lib.maintainers.garbas ];
    };
  };


  sphinx = buildPythonPackage (rec {
    name = "Sphinx-1.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/S/Sphinx/${name}.tar.gz";
      md5 = "8516046aad73fe46dedece4e8e434328";
    };

    propagatedBuildInputs = [docutils jinja2 pygments];

    meta = {
      description = "Sphinx is a tool that makes it easy to create intelligent and beautiful documentation for Python projects.";

      homepage = http://sphinx.pocoo.org/;

      license = "BSD";
    };
  });


  sphinxcontrib_httpdomain = buildPythonPackage (rec {
    name = "sphinxcontrib-httpdomain-1.1.9";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/s/sphinxcontrib-httpdomain/${name}.tar.gz";
      md5 = "0f63aea612cc9e0b55a6c39e5b0f87b7";
    };

    propagatedBuildInputs = [sphinx];

    meta = {
      description = "Provides a Sphinx domain for describing RESTful HTTP APIs";

      homepage = http://bitbucket.org/birkenfeld/sphinx-contrib;

      license = "BSD";
    };
  });


  sphinx_pypi_upload = buildPythonPackage (rec {
    name = "Sphinx-PyPI-upload-0.2.1";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/S/Sphinx-PyPI-upload/${name}.tar.gz";
      md5 = "b9f1df5c8443197e4d49abbba1cfddc4";
    };

    meta = {
      description = "Setuptools command for uploading Sphinx documentation to PyPI";

      homepage = http://bitbucket.org/jezdez/sphinx-pypi-upload/;

      license = "BSD";
    };
  });

  sqlalchemy = pkgs.lib.overrideDerivation sqlalchemy9 (args: rec {
    name = "SQLAlchemy-0.7.10";
    src = fetchurl {
      url = "http://pypi.python.org/packages/source/S/SQLAlchemy/${name}.tar.gz";
      sha256 = "0rhxgr85xdhjn467qfs0dkyj8x46zxcv6ad3dfx3w14xbkb3kakp";
    };
    patches = [
      # see https://groups.google.com/forum/#!searchin/sqlalchemy/module$20logging$20handlers/sqlalchemy/ukuGhmQ2p6g/2_dOpBEYdDYJ
      # waiting for 0.7.11 release
      ../development/python-modules/sqlalchemy-0.7.10-test-failures.patch
    ];
  });


  sqlalchemy8 = pkgs.lib.overrideDerivation sqlalchemy9 (args: rec {
    name = "SQLAlchemy-0.8.5";
    src = fetchurl {
      url = "https://pypi.python.org/packages/source/S/SQLAlchemy/${name}.tar.gz";
      md5 = "ecf0738eaf1229bae27ad2be0f9978a8";
    };
  });

  sqlalchemy9 = buildPythonPackage rec {
    name = "SQLAlchemy-0.9.3";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/S/SQLAlchemy/${name}.tar.gz";
      md5 = "a27989b9d4b3f14ea0b1600aa45559c4";
    };

    buildInputs = [ nose mock ];

    propagatedBuildInputs = [ modules.sqlite3 ];

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
    version = "0.8.1";

    src = fetchgit {
      url = https://github.com/crosspop/sqlalchemy-imageattach.git;
      rev = "refs/tags/${version}";
      md5 = "051dd9de0757714d33c3ecd5ab37b97d";
    };

    buildInputs = [ pytest webob pkgs.imagemagick nose ];
    propagatedBuildInputs = [ sqlalchemy8 wand ];

    checkPhase = ''
      cd tests
      export MAGICK_HOME="${pkgs.imagemagick}"
      export PYTHONPATH=$PYTHONPATH:../
      py.test
      cd ..
    '';

    meta = {
      homepage = https://github.com/crosspop/sqlalchemy-imageattach;
      description = "SQLAlchemy extension for attaching images to entity objects";
      license = licenses.mit;
    };
  };


  sqlalchemy_migrate = buildPythonPackage rec {
    name = "sqlalchemy-migrate-0.6.1";

    src = fetchurl {
      url = "http://sqlalchemy-migrate.googlecode.com/files/${name}.tar.gz";
      sha1 = "17168b5fa066bd56fd93f26345525377e8a83d8a";
    };

    buildInputs = [ nose unittest2 scripttest ];

    propagatedBuildInputs = [ tempita decorator sqlalchemy ];

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


  statd = buildPythonPackage rec {
    name = "python-statsd-${version}";
    version = "1.6.0";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/p/python-statsd/${name}.tar.gz";
      md5 = "3a0c71a160b504b843703c3041c7d7fb";
    };

    buildInputs = [ mock nose coverage ];

    meta = {
      description = "A client for Etsy's node-js statsd server";
      homepage = https://github.com/WoLpH/python-statsd;
      license = licenses.bsd3;
    };
  };


  stompclient = buildPythonPackage (rec {
    name = "stompclient-0.3.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/s/stompclient/${name}.tar.gz";
      md5 = "af0a314b6106dd80da24a918c24a1eab";
    };

    buildInputs = [ mock nose ];

    # XXX: Ran 0 tests in 0.217s

    meta = {
      description = "Lightweight and extensible STOMP messaging client";
      homepage = http://bitbucket.org/hozn/stompclient;
      license = licenses.asl20;
    };
  });


  subunit = buildPythonPackage rec {
    name = "subunit-${version}";
    version = "0.0.16";

    src = fetchurl {
      url = "https://launchpad.net/subunit/trunk/${version}/+download/python-${name}.tar.gz";
      sha256 = "1ylla1wlmv29vdr76r5kgr7y21bz4ahi3v26mxsys42w90rfkahi";
    };

    propagatedBuildInputs = [ testtools ];

    meta = {
      description = "A streaming protocol for test results";
      homepage = https://launchpad.net/subunit;
      license = licenses.asl20;
    };
  };


  sure = buildPythonPackage rec {
    name = "sure-${version}";
    version = "1.2.7";

    # Not picking up from PyPI because it doesn't contain tests.
    src = fetchgit {
      url = "git://github.com/gabrielfalcao/sure.git";
      rev = "86ab9faa97aa9c1720c7d090deac2be385ed3d7a";
      sha256 = "02vffcdgr6vbj80lhl925w7zqy6cqnfvs088i0rbkjs5lxc511b3";
    };

    buildInputs = [ nose ];

    propagatedBuildInputs = [ six mock ];

    meta = {
      description = "Utility belt for automated testing";
      homepage = "http://falcao.it/sure/";
      license = licenses.gpl3Plus;
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
  #   propagatedBuildInputs = [ pysvn argparse ];
  #
  #   doCheck = false;
  # };

  targetcli_fb = buildPythonPackage rec {
    version = "2.1.fb33";
    name = "targetcli-fb-${version}";

    src = fetchurl {
      url = "https://github.com/agrover/targetcli-fb/archive/v${version}.tar.gz";
      sha256 = "1zcm0agdpf866020b43fl8zyyyzz6r74mn1sz4xpaa0pinpwjk42";
    };

    propagatedBuildInputs = [
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

    src = fetchgit {
      url = https://github.com/miracle2k/tarsnapper.git;
      rev = "620439bca68892f2ffaba1079a34b18496cc6596";
      sha256 = "06pp499qm2dxpja2jgmmq2jrcx3m4nq52x5hhil9r1jxvyiq962p";
    };

    propagatedBuildInputs = [ argparse pyyaml ];

    patches = [ ../development/python-modules/tarsnapper-path.patch ];

    preConfigure = ''
      substituteInPlace src/tarsnapper/script.py \
        --replace '@NIXTARSNAPPATH@' '${pkgs.tarsnap}/bin/tarsnap'
    '';
  };

  taskcoach = buildPythonPackage rec {
    name = "TaskCoach-1.3.22";

    src = fetchurl {
      url = "mirror://sourceforge/taskcoach/${name}.tar.gz";
      sha256 = "1ddx56bqmh347synhgjq625ijv5hqflr0apxg0nl4jqdsqk1zmxh";
    };

    propagatedBuildInputs = [ wxPython ];

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
      license = "GPLv3+";
    };
  };

  tempita = buildPythonPackage rec {
    version = "0.4";
    name = "tempita-${version}";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/T/Tempita/Tempita-${version}.tar.gz";
      md5 = "0abe015a72e748d0c6284679a497426c";
    };

    buildInputs = [ nose ];

    meta = {
      homepage = http://pythonpaste.org/tempita/;
      description = "A very small text templating language";
    };
  };


  testtools = buildPythonPackage rec {
    name = "testtools-${version}";
    version = "0.9.34";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/t/testtools/${name}.tar.gz";
      sha256 = "0s6sn9h26dif2c9sayf875x622kq8jb2f4qbc6if7gwh2sssgicn";
    };

    propagatedBuildInputs = [ pythonPackages.python_mimeparse pythonPackages.extras lxml ];

    meta = {
      description = "A set of extensions to the Python standard library's unit testing framework";
      homepage = http://pypi.python.org/pypi/testtools;
      license = licenses.mit;
    };
  };


  python_mimeparse = buildPythonPackage rec {
    name = "python-mimeparse-${version}";
    version = "0.1.4";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/p/python-mimeparse/${name}.tar.gz";
      sha256 = "1hyxg09kaj02ri0rmwjqi86wk4nd1akvv7n0dx77azz76wga4s9w";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      description = "A module provides basic functions for parsing mime-type names and matching them against a list of media-ranges.";
      homepage = https://code.google.com/p/mimeparse/;
      license = licenses.mit;
    };
  };


  extras = buildPythonPackage rec {
    name = "extras-${version}";
    version = "0.0.3";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/e/extras/extras-${version}.tar.gz";
      sha256 = "1h7zx4dfyclalg0fqnfjijpn0f793a9mx8sy3b27gd31nr6dhq3s";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      description = "A module provides basic functions for parsing mime-type names and matching them against a list of media-ranges.";
      homepage = https://code.google.com/p/mimeparse/;
      license = licenses.mit;
    };
  };


  # TODO
  # Installs correctly but fails tests that involve simple things like:
  # cmd.run("tox", "-h")
  # also, buildPythonPackage needs to supply the tox.ini correctly for projects that use tox for their tests
  #
  # tox = buildPythonPackage rec {
  #   name = "tox-1.7.0";
  #
  #   propagatedBuildInputs = [ py virtualenv ];
  #
  #   src = fetchurl {
  #     url = "https://pypi.python.org/packages/source/t/tox/${name}.tar.gz";
  #     md5 = "5314ceca2b179ad4a9c79f4d817b8a99";
  #   };
  # };

  smmap = buildPythonPackage rec {
    name = "smmap-0.8.2";
    meta.maintainers = [ stdenv.lib.maintainers.mornfall ];

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/s/smmap/${name}.tar.gz";
      sha256 = "0vrdgr6npmajrv658fv8bij7zgm5jmz2yxkbv8kmbv25q1f9b8ny";
    };
  };

  trac = buildPythonPackage {
    name = "trac-1.0.1";

    src = fetchurl {
      url = http://ftp.edgewall.com/pub/trac/Trac-1.0.1.tar.gz;
      sha256 = "1nqa95fcnkpyq4jk6az7l7sqgm3b3pjq3bx1n7y4v3bad5jr1m4x";
    };

    # couple of failing tests
    doCheck = false;

    PYTHON_EGG_CACHE = "`pwd`/.egg-cache";

    propagatedBuildInputs = [ genshi pkgs.setuptools modules.sqlite3 ];

    meta = {
      description = "Enhanced wiki and issue tracking system for software development projects";

      license = "BSD";
    };
  };


  transaction = buildPythonPackage rec {
    name = "transaction-${version}";
    version = "1.4.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/t/transaction/${name}.tar.gz";
      md5 = "b7c2ff135939f605a8c54e1c13cd5d66";
    };

    propagatedBuildInputs = [ zope_interface ];

    meta = {
      description = "Transaction management";
      homepage = http://pypi.python.org/pypi/transaction;
      license = "ZPL";
    };
  };


  eggdeps  = buildPythonPackage rec {
     name = "eggdeps-${version}";
     version = "0.4";

     src = fetchurl {
       url = "http://pypi.python.org/packages/source/t/tl.eggdeps/tl.${name}.tar.gz";
       md5 = "2472204a2abd0d8cd4d11ff0fbf36ae7";
     };

     # tests fail, see http://hydra.nixos.org/build/4316603/log/raw
     doCheck = false;

     propagatedBuildInputs = [ zope_interface zope_testing ];
     meta = {
       description = "A tool which computes a dependency graph between active Python eggs";
       homepage = http://thomas-lotze.de/en/software/eggdeps/;
       license = "ZPL";
     };
   };


  turses = buildPythonPackage (rec {
    name = "turses-0.2.22";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/t/turses/${name}.tar.gz";
      sha256 = "1dqgvdqly4c4d6819mbkqy4g8r7zch4dkmxicfwck7q8h96wmyx3";
    };

    propagatedBuildInputs = [ oauth2 urwid tweepy ] ++ optional isPy26 argparse;

    #buildInputs = [ tox ];
    # needs tox
    doCheck = false;

    meta = {
      homepage = "https://github.com/alejandrogomez/turses";
      description = "A Twitter client for the console.";
      license = licenses.gpl3;
      maintainers = [ stdenv.lib.maintainers.garbas ];
      platforms = stdenv.lib.platforms.linux;
    };
  });

  tweepy = buildPythonPackage (rec {
    name = "tweepy-2.3.0";

    src = fetchurl {
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

  twisted = buildPythonPackage rec {
    # NOTE: When updating please check if new versions still cause issues
    # to packages like carbon (http://stackoverflow.com/questions/19894708/cant-start-carbon-12-04-python-error-importerror-cannot-import-name-daem)

    name = "Twisted-11.1.0";
    src = fetchurl {
      url = "https://pypi.python.org/packages/source/T/Twisted/${name}.tar.bz2";
      sha256 = "05agfp17cndhv2w0p559lvknl7nv0xqkg10apc47fm53m8llbfvz";
    };

    propagatedBuildInputs = [ zope_interface ];

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


  unittest2 = buildPythonPackage rec {
    version = "0.5.1";
    name = "unittest2-${version}";

    src = if python.is_py3k or false
       then fetchurl {
           url = "http://pypi.python.org/packages/source/u/unittest2py3k/unittest2py3k-${version}.tar.gz";
           sha256 = "00yl6lskygcrddx5zspkhr0ibgvpknl4678kkm6s626539grq93q";
         }
       else fetchurl {
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

    src = fetchurl {
      url = "http://urlgrabber.baseurl.org/download/${name}.tar.gz";
      sha256 = "4437076c8708e5754ea04540e46c7f4f233734ee3590bb8a96389264fb0650d0";
    };

    # error: invalid command 'test'
    doCheck = false;

    propagatedBuildInputs = [ pycurl ];

    meta = {
      homepage = "urlgrabber.baseurl.org";
      license = "LGPLv2+";
      description = "Python module for downloading files";
      maintainers = [ stdenv.lib.maintainers.qknight ];
    };
  };


  urwid = buildPythonPackage (rec {
    name = "urwid-1.2.1";

    # multiple:  NameError: name 'evl' is not defined
    doCheck = false;

    src = fetchurl {
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

  virtualenv = buildPythonPackage rec {
    name = "virtualenv-1.11.4";
    src = fetchurl {
      url = "http://pypi.python.org/packages/source/v/virtualenv/${name}.tar.gz";
      md5 = "9accc2d3f0ec1da479ce2c3d1fdff06e";
    };

    inherit recursivePthLoader;
    pythonPath = [ recursivePthLoader ];

    patches = [ ../development/python-modules/virtualenv-change-prefix.patch ];

    propagatedBuildInputs = [ modules.readline modules.sqlite3 modules.curses ];

    buildInputs = [ mock nose ];

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

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/v/virtualenv-clone/${name}.tar.gz";
      md5 = "71168b975eaaa91e65559bcc79290b3b";
    };

    buildInputs = [pytest];
    propagatedBuildInputs = [virtualenv];

    # needs tox to run the tests
    doCheck = false;

    meta = with stdenv.lib; {
      description = "Script to clone virtualenvs";
      license = licenses.mit;
      platforms = platforms.all;
    };
  };

  waitress = buildPythonPackage rec {
    name = "waitress-0.8.7";

    src = fetchurl {
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

    src = fetchurl {
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

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/W/Wand/${name}.tar.gz";
      md5 = "10bab03bf86ce8da2a95a3b15197ae2e";
    };

    buildInputs = [ pkgs.imagemagick pytest psutil memory_profiler pytest_xdist ];

    meta = {
      description = "Ctypes-based simple MagickWand API binding for Python";
      homepage = http://wand-py.org/;
      platforms = stdenv.lib.platforms.all;
    };
  };


  webob = buildPythonPackage rec {
    version = "1.3.1";
    name = "webob-${version}";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/W/WebOb/WebOb-${version}.tar.gz";
      md5 = "20918251c5726956ba8fef22d1556177";
    };

    propagatedBuildInputs = [ nose modules.ssl ];

    meta = {
      description = "WSGI request and response object";
      homepage = http://pythonpaste.org/webob/;
      platforms = stdenv.lib.platforms.all;
    };
  };


  websockify = buildPythonPackage rec {
    version = "0.3.0";
    name = "websockify-${version}";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/w/websockify/websockify-${version}.tar.gz";
      md5 = "29b6549d3421907de4bbd881ecc2e1b1";
    };

    propagatedBuildInputs = [ numpy ];

    meta = {
      description = "WebSockets support for any application/server";
      homepage = https://github.com/kanaka/websockify;
    };
  };


  webtest = buildPythonPackage rec {
    version = "2.0.11";
    name = "webtest-${version}";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/W/WebTest/WebTest-${version}.zip";
      md5 = "e51da21da8815cef07f543d8688effea";
    };

    # XXX: skipping two tests fails in python2.6
    doCheck = ! isPy26;

    buildInputs = optionals isPy26 [ pythonPackages.ordereddict unittest2 ];

    propagatedBuildInputs = [
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


  werkzeug = buildPythonPackage {
    name = "werkzeug-0.9.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/W/Werkzeug/Werkzeug-0.9.4.tar.gz";
      md5 = "670fad41f57c13b71a6816765765a3dd";
    };

    propagatedBuildInputs = [ itsdangerous ];

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
    src = fetchurl {
      inherit url;
      sha256 = "0rnshrzw8605x05mpd8ndrx3ri8h6cx713mp8sl4f04f4gcrz8ml";
    };

    propagatedBuildInputs = [twisted dateutil];

    meta = {
      description = "Some (mainly XMPP-related) additions to twisted";
      homepage = "http://wokkel.ik.nu/";
      license = stdenv.lib.licenses.mit;
    };
  });


  wsgiproxy2 = buildPythonPackage rec {
    name = "WSGIProxy2-0.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/W/WSGIProxy2/${name}.tar.gz";
      md5 = "157049212f1c81a8790efa31146fbabf";
    };

    propagatedBuildInputs = [ six webob ];

    meta = {
       maintainers = [
         stdenv.lib.maintainers.garbas
         stdenv.lib.maintainers.iElectric
      ];
      platforms = stdenv.lib.platforms.all;
    };
  };


  wxPython = wxPython28;


  wxPython28 = import ../development/python-modules/wxPython/2.8.nix {
    inherit (pkgs) stdenv fetchurl pkgconfig;
    inherit pythonPackages;
    wxGTK = pkgs.wxGTK28;
  };

  wxPython30 = import ../development/python-modules/wxPython/3.0.nix {
    inherit (pkgs) stdenv fetchurl pkgconfig;
    inherit pythonPackages;
    wxGTK = pkgs.wxGTK30;
  };

  xe = buildPythonPackage rec {
    url = "http://www.blarg.net/%7Esteveha/xe-0.7.4.tar.gz";
    name = stdenv.lib.nameFromURL url ".tar";
    src = fetchurl {
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

    src = fetchurl {
      url = "mirror://sourceforge/python-xlib/python-${name}.tar.bz2";
      sha256 = "0mvzz605pxzj7lfp2w6z4qglmr4rjza9xrb7sl8yn12cklzfky0m";
    };

    # Tests require `pyutil' so disable them to avoid circular references.
    doCheck = false;

    propagatedBuildInputs = [ pkgs.xlibs.libX11 ];

    meta = {
      description = "Fully functional X client library for Python programs";

      homepage = http://python-xlib.sourceforge.net/;

      license = "GPLv2+";
    };
  });

  zbase32 = buildPythonPackage (rec {
    name = "zbase32-1.1.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zbase32/${name}.tar.gz";
      sha256 = "2f44b338f750bd37b56e7887591bf2f1965bfa79f163b6afcbccf28da642ec56";
    };

    # Tests require `pyutil' so disable them to avoid circular references.
    doCheck = false;

    buildInputs = [ setuptoolsDarcs ];

    meta = {
      description = "zbase32, a base32 encoder/decoder";

      homepage = http://pypi.python.org/pypi/zbase32;

      license = "BSD";
    };
  });


  zconfig = buildPythonPackage rec {
    name = "zconfig-${version}";
    version = "3.0.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/Z/ZConfig/ZConfig-${version}.tar.gz";
      md5 = "60a107c5857c3877368dfe5930559804";
    };

    propagatedBuildInputs = [ zope_testrunner ];

    meta = {
      description = "Structured Configuration Library";
      homepage = http://pypi.python.org/pypi/ZConfig;
      license = "ZPL";
      maintainers = [ stdenv.lib.maintainers.goibhniu ];
    };
  };


  zc_lockfile = buildPythonPackage rec {
    name = "zc.lockfile-${version}";
    version = "1.0.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zc.lockfile/${name}.tar.gz";
      md5 = "f099d4cf2583a0c7bea0146a44dc4d59";
    };

    meta = {
      description = "Inter-process locks";
      homepage =  http://www.python.org/pypi/zc.lockfile;
      license = "ZPL";
      maintainers = [ stdenv.lib.maintainers.goibhniu ];
    };
  };


  zdaemon = buildPythonPackage rec {
    name = "zdaemon-${version}";
    version = "3.0.5";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zdaemon/${name}.tar.gz";
      md5 = "975f770544bb4352c5cf32fec22e63c9";
    };

    propagatedBuildInputs  = [ zconfig ];

    meta = {
      description = "A daemon process control library and tools for Unix-based systems";
      homepage = http://pypi.python.org/pypi/zdaemon;
      license = "ZPL";
      maintainers = [ stdenv.lib.maintainers.goibhniu ];
    };
  };


  zfec = buildPythonPackage (rec {
    name = "zfec-1.4.24";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zfec/${name}.tar.gz";
      sha256 = "1ks94zlpy7n8sb8380gf90gx85qy0p9073wi1wngg6mccxp9xsg3";
    };

    buildInputs = [ setuptoolsDarcs ];
    propagatedBuildInputs = [ pyutil argparse ];

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

      license = "GPLv2+";
    };
  });


  zodb3 = buildPythonPackage rec {
    name = "zodb3-${version}";
    version = "3.10.5";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/Z/ZODB3/ZODB3-${version}.tar.gz";
      md5 = "6f180c6897a1820948fee2a6290503cd";
    };

    propagatedBuildInputs = [ manuel transaction zc_lockfile zconfig zdaemon zope_interface zope_event ];

    meta = {
      description = "An object-oriented database for Python";
      homepage = http://pypi.python.org/pypi/ZODB3;
      license = "ZPL";
      maintainers = [ stdenv.lib.maintainers.goibhniu ];
    };
  };


  zope_broken = buildPythonPackage rec {
    name = "zope.broken-3.6.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.broken/${name}.zip";
      md5 = "eff24d7918099a3e899ee63a9c31bee6";
    };

    buildInputs = [ zope_interface ];

    meta = {
        maintainers = [ stdenv.lib.maintainers.goibhniu ];
    };
  };


  zope_browser = buildPythonPackage rec {
    name = "zope.browser-1.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.browser/${name}.zip";
      md5 = "4ff0ddbf64c45bfcc3189e35f4214ded";
    };

    propagatedBuildInputs = [ zope_interface ];

    meta = {
        maintainers = [ stdenv.lib.maintainers.goibhniu ];
    };
  };


  zope_component = buildPythonPackage rec {
    name = "zope.component-4.0.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.component/zope.component-4.0.2.tar.gz";
      md5 = "8c2fd4414ca23cbbe014dcaf911acebc";
    };

    propagatedBuildInputs = [
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
    name = "zope.configuration-4.0.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.configuration/zope.configuration-4.0.2.tar.gz";
      md5 = "40b3c7ad0b748ede532d8cfe2544e44e";
    };

    propagatedBuildInputs = [ zope_i18nmessageid zope_schema ];

    meta = {
        maintainers = [ stdenv.lib.maintainers.goibhniu ];
    };
  };


  zope_container = buildPythonPackage rec {
    name = "zope.container-3.11.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.container/${name}.tar.gz";
      md5 = "fc66d85a17b8ffb701091c9328983dcc";
    };

    propagatedBuildInputs = [
      zodb3 zope_broken zope_dottedname zope_publisher
      zope_filerepresentation zope_lifecycleevent zope_size
      zope_traversing
    ];

    meta = {
        maintainers = [ stdenv.lib.maintainers.goibhniu ];
    };
  };


  zope_contenttype = buildPythonPackage rec {
    name = "zope.contenttype-3.5.5";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.contenttype/${name}.zip";
      md5 = "c6ac80e6887de4108a383f349fbdf332";
    };

    meta = {
        maintainers = [ stdenv.lib.maintainers.goibhniu ];
    };
  };


  zope_dottedname = buildPythonPackage rec {
    name = "zope.dottedname-3.4.6";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.dottedname/${name}.tar.gz";
      md5 = "62d639f75b31d2d864fe5982cb23959c";
    };
    meta = {
        maintainers = [ stdenv.lib.maintainers.goibhniu ];
    };
  };


  zope_event = buildPythonPackage rec {
    name = "zope.event-${version}";
    version = "4.0.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.event/${name}.tar.gz";
      md5 = "e08dd299d428d77a1cfcbfe841b81872";
    };

    meta = {
      description = "An event publishing system";
      homepage = http://pypi.python.org/pypi/zope.event;
      license = "ZPL";
      maintainers = [ stdenv.lib.maintainers.goibhniu ];
    };
  };


  zope_exceptions = buildPythonPackage rec {
     name = "zope.exceptions-${version}";
     version = "4.0.5";

     src = fetchurl {
       url = "http://pypi.python.org/packages/source/z/zope.exceptions/${name}.tar.gz";
       md5 = "c95569fcb444ae541777de7ae5297492";
     };

     propagatedBuildInputs = [ zope_interface ];

     meta = {
       description = "Exception interfaces and implementations";
       homepage = http://pypi.python.org/pypi/zope.exceptions;
       license = "ZPL";
       maintainers = [ stdenv.lib.maintainers.goibhniu ];
     };
   };


  zope_filerepresentation = buildPythonPackage rec {
    name = "zope.filerepresentation-3.6.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.filerepresentation/${name}.tar.gz";
      md5 = "4a7a434094f4bfa99a7f22e75966c359";
    };

    propagatedBuildInputs = [ zope_schema ];

    meta = {
        maintainers = [ stdenv.lib.maintainers.goibhniu ];
    };
  };


  zope_i18n = buildPythonPackage rec {
    name = "zope.i18n-3.7.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.i18n/${name}.tar.gz";
      md5 = "a6fe9d9ad53dd7e94e87cd58fb67d3b7";
    };

    propagatedBuildInputs = [ pytz zope_component ];

    meta = {
        maintainers = [ stdenv.lib.maintainers.goibhniu ];
    };
  };


  zope_i18nmessageid = buildPythonPackage rec {
    name = "zope.i18nmessageid-4.0.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.i18nmessageid/zope.i18nmessageid-4.0.2.tar.gz";
      md5 = "c4550f7a0b4a736186e6e0fa3b2471f7";
    };

    meta = {
        maintainers = [ stdenv.lib.maintainers.goibhniu ];
    };
  };


  zope_lifecycleevent = buildPythonPackage rec {
    name = "zope.lifecycleevent-3.6.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.lifecycleevent/${name}.tar.gz";
      md5 = "3ba978f3ba7c0805c81c2c79ea3edb33";
    };

    propagatedBuildInputs = [ zope_event zope_component ];

    meta = {
        maintainers = [ stdenv.lib.maintainers.goibhniu ];
    };
  };


  zope_location = buildPythonPackage rec {
    name = "zope.location-4.0.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.location/zope.location-4.0.0.tar.gz";
      md5 = "cd0e10d5923c95e352bcde505cc11324";
    };

    propagatedBuildInputs = [ zope_proxy ];

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
    name = "zope.proxy-4.1.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.proxy/zope.proxy-4.1.1.tar.gz";
      md5 = "c36691f0abee7573f4ddcc378603cefd";
    };

    propagatedBuildInputs = [ zope_interface ];

    meta = {
        maintainers = [ stdenv.lib.maintainers.goibhniu ];
    };
  };


  zope_publisher = buildPythonPackage rec {
    name = "zope.publisher-3.12.6";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.publisher/${name}.tar.gz";
      md5 = "495131970cc7cb14de8e517fb3857ade";
    };

    propagatedBuildInputs = [
      zope_browser zope_contenttype zope_i18n zope_security
    ];

    meta = {
        maintainers = [ stdenv.lib.maintainers.goibhniu ];
    };
  };


  zope_schema = buildPythonPackage rec {
    name = "zope.schema-4.2.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.schema/zope.schema-4.2.2.tar.gz";
      md5 = "e7e581af8193551831560a736a53cf58";
    };

    propagatedBuildInputs = [ zope_location zope_event zope_interface zope_testing ] ++ optional isPy26 ordereddict;

    meta = {
        maintainers = [ stdenv.lib.maintainers.goibhniu ];
    };
  };


  zope_security = buildPythonPackage rec {
    name = "zope.security-3.7.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.security/zope.security-3.7.4.tar.gz";
      md5 = "072ab8d11adc083eace11262da08630c";
    };

    propagatedBuildInputs = [
      zope_component zope_configuration zope_i18nmessageid zope_schema
      zope_proxy
    ];

    meta = {
        maintainers = [ stdenv.lib.maintainers.goibhniu ];
    };
  };


  zope_size = buildPythonPackage rec {
    name = "zope.size-3.4.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.size/${name}.tar.gz";
      md5 = "55d9084dfd9dcbdb5ad2191ceb5ed03d";
    };

    propagatedBuildInputs = [ zope_i18nmessageid zope_interface ];

    meta = {
        maintainers = [ stdenv.lib.maintainers.goibhniu ];
    };
  };


  zope_sqlalchemy = buildPythonPackage rec {
    name = "zope.sqlalchemy-0.7.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.sqlalchemy/${name}.zip";
      md5 = "8b317b41244fc2e67f2f286890ba59a0";
    };

    buildInputs = [ sqlalchemy zope_testing zope_interface setuptools ];
    propagatedBuildInputs = [ sqlalchemy transaction ];

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
    version = "4.1.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.testing/${name}.zip";
      md5 = "01c30c342c6a18002a762bd5d320a6e9";
    };

    propagatedBuildInputs = [ zope_interface zope_exceptions zope_location ];

    meta = {
      description = "Zope testing helpers";
      homepage =  http://pypi.python.org/pypi/zope.testing;
      license = "ZPL";
      maintainers = [ stdenv.lib.maintainers.goibhniu ];
    };
  };


  zope_testrunner = buildPythonPackage rec {
    name = "zope.testrunner-${version}";
    version = "4.4.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.testrunner/${name}.zip";
      md5 = "1d689abad000419891494b30dd7d8190";
    };

    propagatedBuildInputs = [ zope_interface zope_exceptions zope_testing six ] ++ optional (!python.is_py3k or false) subunit;

    # a test is failing
    doCheck = false;

    meta = {
      description = "A flexible test runner with layer support";
      homepage = http://pypi.python.org/pypi/zope.testrunner;
      license = "ZPL";
      maintainers = [ stdenv.lib.maintainers.goibhniu ];
    };
  };


  zope_traversing = buildPythonPackage rec {
    name = "zope.traversing-3.13.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.traversing/${name}.zip";
      md5 = "eaad8fc7bbef126f9f8616b074ec00aa";
    };

    propagatedBuildInputs = [ zope_location zope_security zope_publisher ];

    meta = {
        maintainers = [ stdenv.lib.maintainers.goibhniu ];
    };
  };


  zope_interface = buildPythonPackage rec {
    name = "zope.interface-4.0.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.interface/${name}.tar.gz";
      md5 = "1ddd308f2c83703accd1696158c300eb";
    };

    propagatedBuildInputs = [ zope_event ];

    meta = {
      description = "Zope.Interface";
      homepage = http://zope.org/Products/ZopeInterface;
      license = "ZPL";
      maintainers = [ stdenv.lib.maintainers.goibhniu ];
    };
  };


  # XXX: link broken
  # hgsvn = buildPythonPackage rec {
  #   name = "hgsvn-0.1.8";
  #   src = fetchurl rec {
  #     name = "hgsvn-0.1.8.tar.gz";
  #     url = "http://pypi.python.org/packages/source/h/hgsvn/${name}.tar.gz#md5=56209eae48b955754e09185712123428";
  #     sha256 = "18a7bj1i0m4shkxmdvw1ci5i0isq5vqf0bpwgrhnk305rijvbpch";
  #   };
  #
  #   buildInputs = [ pkgs.setuptools ];
  #   doCheck = false;
  #
  #     meta = {
  #     description = "HgSVN";
  #     homepage = http://pypi.python.org/pypi/hgsvn;
  #   };
  # };

  cliapp = buildPythonPackage rec {
    name = "cliapp-${version}";
    version = "1.20130808";

    src = fetchurl rec {
      url = "http://code.liw.fi/debian/pool/main/p/python-cliapp/python-cliapp_${version}.orig.tar.gz";
      sha256 = "0i9fqkahrc16mnxjw8fcr4hwrq3ibfrj2lzzbzzb7v5yk5dlr532";
    };

    buildInputs = [ sphinx ];

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://liw.fi/cliapp/;
      description = "Python framework for Unix command line programs.";
      maintainers = [ stdenv.lib.maintainers.rickynils ];
    };
  };


  tornado = buildPythonPackage rec {
    name = "tornado-3.2";

    propagatedBuildInputs = [ backports_ssl_match_hostname_3_4_0_2 ];

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/t/tornado/${name}.tar.gz";
      md5 = "bd83cee5f1a5c5e139e87996d00b251b";
    };

    doCheck = false;
  };


  tarman = buildPythonPackage rec {
    version = "0.1.3";
    name = "tarman-${version}";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/t/tarman/tarman-${version}.zip";
      sha256 = "0ri6gj883k042xaxa2d5ymmhbw2bfcxdzhh4bz7700ibxwxxj62h";
    };

    buildInputs = [ unittest2 nose mock ];
    propagatedBuildInputs = [ modules.curses libarchive ];

    # tests are still failing
    doCheck = false;
  };


  libarchive = buildPythonPackage rec {
    version = "3.1.2-1";
    name = "libarchive-${version}";

    src = fetchurl {
      url = "http://python-libarchive.googlecode.com/files/python-libarchive-${version}.tar.gz";
      sha256 = "0j4ibc4mvq64ljya9max8832jafi04jciff9ia9qy0xhhlwkcx8x";
    };

    propagatedBuildInputs = [ pkgs.libarchive ];
  };


  pyzmq = buildPythonPackage rec {
    name = "pyzmq-13.0.0";
    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyzmq/pyzmq-13.0.0.zip";
      md5 = "fa2199022e54a393052d380c6e1a0934";
    };
    buildInputs = [ pkgs.zeromq3 ];
    propagatedBuildInputs = [  ];
    doCheck = false;
  };


  tissue = buildPythonPackage rec {
    name = "tissue-0.9.2";
    src = fetchurl {
      url = "http://pypi.python.org/packages/source/t/tissue/${name}.tar.gz";
      md5 = "87dbcdafff41bfa1b424413f79aa9153";
    };

    buildInputs = [ nose ];
    propagatedBuildInputs = [ pep8 ];

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

    src = fetchurl rec {
      url = "http://code.liw.fi/debian/pool/main/p/python-tracing/python-tracing_${version}.orig.tar.gz";
      sha256 = "1l4ybj5rvrrcxf8csyq7qx52izybd502pmx70zxp46gxqm60d2l0";
    };

    buildInputs = [ sphinx ];

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://liw.fi/tracing/;
      description = "Python debug logging helper.";
      maintainers = [ stdenv.lib.maintainers.rickynils ];
    };
  };

  translationstring = buildPythonPackage rec {
    name = "translationstring-1.1";

    src = fetchurl {
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

    src = fetchurl rec {
      url = "http://code.liw.fi/debian/pool/main/p/python-ttystatus/python-ttystatus_${version}.orig.tar.gz";
      sha256 = "0ymimviyjyh2iizqilg88g4p26f5vpq1zm3cvg7dr7q4y3gmik8y";
    };

    buildInputs = [ sphinx ];

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://liw.fi/ttystatus/;
      description = "Progress and status updates on terminals for Python.";
      maintainers = [ stdenv.lib.maintainers.rickynils ];
    };
  };

  larch = buildPythonPackage rec {
    name = "larch-${version}";
    version = "1.20131130";

    src = fetchurl rec {
      url = "http://code.liw.fi/debian/pool/main/p/python-larch/python-larch_${version}.orig.tar.gz";
      sha256 = "1hfanp9l6yc5348i3f5sb8c5s4r43y382hflnbl6cnz4pm8yh5r7";
    };

    buildInputs = [ sphinx ];
    propagatedBuildInputs = [ tracing ttystatus cliapp ];

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://liw.fi/larch/;
      description = "Python B-tree library.";
      maintainers = [ stdenv.lib.maintainers.rickynils ];
    };
  };


  webhelpers = buildPythonPackage rec {
    name = "WebHelpers-1.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/W/WebHelpers/${name}.tar.gz";
      md5 = "32749ffadfc40fea51075a7def32588b";
    };

    buildInputs = [ routes markupsafe webob nose ];

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

    src = fetchurl {
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

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/c/carbon/${name}.tar.gz";
      md5 = "66967d5a622fd29973838fcd10eb34f3";
    };

    propagatedBuildInputs = [ whisper txamqp zope_interface twisted ];

    # error: invalid command 'test'
    doCheck = false;

    meta = with stdenv.lib; {
      homepage = http://graphite.wikidot.com/;
      description = "Backend data caching and persistence daemon for Graphite";
      maintainers = with maintainers; [ rickynils offline ];
    };
  };


  unidecode = buildPythonPackage rec {
    name = "Unidecode-0.04.12";

    src = fetchurl {
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

    src = fetchurl {
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
    version = "0.5";

    src = fetchurl {
      url = "https://github.com/python-ivi/python-usbtmc/archive/v${version}.tar.gz";
      sha256 = "0xn8whjcdn8wgs9j1gj7sw7fh425akdmq3hi448m36fywldbhryg";
    };

    propagatedBuildInputs = [ pyusb ];

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

    src = fetchurl rec {
      url = "https://launchpad.net/txamqp/trunk/${version}/+download/python-txamqp_${version}.orig.tar.gz";
      sha256 = "1r2ha0r7g14i4b5figv2spizjrmgfpspdbl1m031lw9px2hhm463";
    };

    buildInputs = [ twisted ];

    meta = {
      homepage = https://launchpad.net/txamqp;
      description = "Library for communicating with AMQP peers and brokers using Twisted";
      maintainers = [ stdenv.lib.maintainers.rickynils ];
    };
  };

  versiontools = buildPythonPackage rec {
    name = "versiontools-1.9.1";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/v/versiontools/${name}.tar.gz";
      sha256 = "1xhl6kl7f4srgnw6zw4lr8j2z5vmrbaa83nzn2c9r2m1hwl36sd9";
    };

  };

  graphite_web = buildPythonPackage rec {
    name = "graphite-web-${version}";
    version = "0.9.12";

    src = fetchurl rec {
      url = "https://pypi.python.org/packages/source/g/graphite-web/${name}.tar.gz";
      md5 = "8edbb61f1ffe11c181bd2cb9ec977c72";
    };

    propagatedBuildInputs = [ django_1_3 django_tagging modules.sqlite3 whisper pkgs.pycairo ldap memcached ];

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

  pyspotify = buildPythonPackage rec {
    name = "pyspotify-${version}";

    version = "1.11";

    src = fetchurl {
      url = "https://github.com/mopidy/pyspotify/archive/v1.11.tar.gz";
      sha256 = "089ml6pqr3f2d15n70jpzbaqjp5pjgqlyv4algkxw92xscjw2izg";
    };

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

    src = fetchgit {
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

    src = fetchgit {
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

    src = fetchurl {
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
    version = "0.9.2";

    src = fetchurl {
      url = "http://freshfoo.com/projects/IMAPClient/${name}.tar.gz";
      sha256 = "10alpj7074djs048xjc4j7ggd1nrqdqpy0fzl7fj9hddp0rbchs9";
    };

    preConfigure = ''
      sed -i '/distribute_setup/d' setup.py
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

    src = fetchurl {
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
    version = "1.2.5";

    src = fetchurl {
      url = "http://libvirt.org/sources/python/${name}.tar.gz";
      sha256 = "0r0v48nkkxfagckizbcf67xkmyd1bnq36d30b58zmhvl0abryz7p";
    };

    buildInputs = [ python pkgs.pkgconfig pkgs.libvirt lxml ];

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

    src = fetchgit {
      url = "git://github.com/asciimoo/searx";
      inherit rev;
      sha256 = "1w505pzdkkcglq782wg7f5fxrw9i5jzp7px20c2xz18pps2m3rsm";
    };

    propagatedBuildInputs = [ pyyaml lxml grequests flaskbabel flask requests
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

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/g/grequests/${name}.tar.gz";
      sha256 = "0lafzax5igbh8y4x0krizr573wjsxz7bhvwygiah6qwrzv83kv5c";
    };

    buildInputs = [ requests gevent ];

    meta = {
      description = "GRequests allows you to use Requests with Gevent to make asyncronous HTTP Requests easily.";
      homepage = https://github.com/kennethreitz/grequests;
      license = "bsd";
      maintainers = [ stdenv.lib.maintainers.matejc ];
    };
  };

  flaskbabel = buildPythonPackage rec {
    name = "Flask-Babel-0.9";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/F/Flask-Babel/${name}.tar.gz";
      sha256 = "0k7vk4k54y55ma0nx2k5s0phfqbriwslhy5shh3b0d046q7ibzaa";
    };

    buildInputs = [ flask jinja2 speaklater Babel pytz ];

    meta = {
      description = "Adds i18n/l10n support to Flask applications";
      homepage = https://github.com/mitsuhiko/flask-babel;
      license = "bsd";
      maintainers = [ stdenv.lib.maintainers.matejc ];
    };
  };

  speaklater = buildPythonPackage rec {
    name = "speaklater-1.3";

    src = fetchurl {
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

  power = buildPythonPackage rec {
    name = "power-1.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/power/${name}.tar.gz";
      sha256 = "09a00af8357f63dbb1a1eb13b82e39ccc0a14d6d2e44e5b235afe60ce8ee8195";
    };

    meta = {
      description = "Cross-platform system power status information";
      homepage = https://github.com/Kentzo/Power;
      license = "mit";
    };
  };

  udiskie = buildPythonPackage rec {
    name = "udiskie-0.8.0";

    src = fetchurl {
      url = "https://github.com/coldfix/udiskie/archive/0.8.0.tar.gz";
      sha256 = "0yzrnl7bq0dkcd3wh55kbf41c4dbh7dky0mqx0drvnpxlrvzhvp2";
    };

    propagatedBuildInputs = with pythonPackages; [ pygtk pyyaml dbus notify pkgs.udisks2 ];

    # tests require dbusmock
    doCheck = false;

    meta = with stdenv.lib; {
      description = "Removable disk automounter for udisks.";
      license = licenses.mit;
      homepage = https://github.com/coldfix/udiskie;
    };
  };

# python2.7 specific packages
} // optionalAttrs isPy27 (
  with pythonPackages;

{

  pypi2nix = pythonPackages.buildPythonPackage rec {
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


  thumbor = pythonPackages.buildPythonPackage rec {
    name = "thumbor-4.0.4";

    propagatedBuildInputs = [
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

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/t/thumbor/${name}.tar.gz";
      md5 = "cf639a1cc57ee287b299ace450444408";
    };

    meta = {
      description = "Thumbor is a smart imaging service. It enables on-demand crop, resizing and flipping of images.";
      homepage = https://github.com/globocom/thumbor/wiki;
      license = licenses.mit;
    };
  };

  thumborPexif = pythonPackages.buildPythonPackage rec {
    name = "thumbor-pexif-0.14";

    src = fetchurl {
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

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/p/${baseName}/${name}.tar.gz";
      md5 = "5cc79077f386a17b539f1e51c05a3650";
    };

    buildInputs = [ pkgs.coreutils ];

    propagatedBuildInputs = [ dateutil ];

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



}); in pythonPackages
