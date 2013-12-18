{ pkgs, python, lowPrio }:

let
isPy26 = python.majorVersion == "2.6";
isPy27 = python.majorVersion == "2.7";
optional = pkgs.lib.optional;
optionals = pkgs.lib.optionals;
modules = python.modules or { readline = null; sqlite3 = null; curses = null; curses_panel = null; ssl = null; crypt = null; };

pythonPackages = modules // import ./python-packages-generated.nix {
  inherit pkgs python;
  inherit (pkgs) stdenv fetchurl;
  self = pythonPackages;
} // rec {

  inherit python;
  inherit (pkgs) fetchurl fetchsvn fetchgit stdenv;

  # helpers

  callPackage = pkgs.lib.callPackageWith (pkgs // pythonPackages);

  buildPythonPackage = import ../development/python-modules/generic {
    inherit (pkgs) lib;
    inherit python wrapPython setuptools recursivePthLoader offlineDistutils;
  };

  wrapPython = pkgs.makeSetupHook
    { deps = pkgs.makeWrapper;
      substitutions.libPrefix = python.libPrefix;
    }
   ../development/python-modules/generic/wrap.sh;

  # specials

  offlineDistutils = import ../development/python-modules/offline-distutils {
    inherit (pkgs) stdenv;
    inherit python;
  };

  recursivePthLoader = import ../development/python-modules/recursive-pth-loader {
    inherit (pkgs) stdenv;
    inherit python;
  };

  setuptools = import ../development/python-modules/setuptools {
    inherit (pkgs) stdenv fetchurl;
    inherit python wrapPython;
  };

  setuptoolsSite = import ../development/python-modules/setuptools/site.nix {
    inherit (pkgs) stdenv;
    inherit python setuptools;
  };

  # packages defined elsewhere

  blivet = callPackage ../development/python-modules/blivet { };

  ipython = import ../shells/ipython {
    inherit (pkgs) stdenv fetchurl sip pyqt4;
    inherit buildPythonPackage pythonPackages;
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
    inherit (pkgs) stdenv fetchurl pkgconfig cairo x11;
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
    rev = "d5d0ddeae0c5758a3f6cf5de77913804d88e906a";
    name = "afew-1.0_${rev}";

    src = fetchurl {
      url = "https://github.com/teythoon/afew/tarball/${rev}";
      name = "${name}.tar.bz";
      sha256 = "0al7hz994sh0yrpixqafr25acglvniq4zsbs9aj89zr7yzq1g1j0";
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
      pkgs.unzip
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
    ];

    postInstall = ''
      ln -s ${pyramid}/bin/pserve $out/bin
      ln -s ${pkgs.bacula}/bin/bconsole $out/bin
      wrapProgram "$out/bin/pserve" \
        --suffix PYTHONPATH : "$out/lib/python2.7/site-packages"
    '';

    meta = {
      maintainers = [ stdenv.lib.maintainers.iElectric ];
      platforms = stdenv.lib.platforms.all;
    };
  };


  alot = buildPythonPackage rec {
    rev = "fa10bfc2de105da819c8e11e913a44c3c1ac60a4";
    name = "alot-0.3.5_${rev}";

    src = fetchurl {
      url = "https://github.com/pazz/alot/tarball/${rev}";
      name = "${name}.tar.bz";
      sha256 = "0zd4jiwxqb7m672xkr5jcqkfpk9jx1kmkllyvjjvswkgjjqdrhax";
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

    buildInputs = [ pkgs.unzip pkgs.sqlite ];

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


  argparse = buildPythonPackage (rec {
    name = "argparse-1.2.1";

    src = fetchurl {
      url = "http://argparse.googlecode.com/files/${name}.tar.gz";
      sha256 = "192174mys40m0bwk6l5jlfnzps0xi81sxm34cqms6dc3c454pbyx";
    };

    buildInputs = [ pkgs.unzip ];

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


  beets = buildPythonPackage rec {
    name = "beets-1.0.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/b/beets/${name}.tar.gz";
      md5 = "88ad09a93aa0d69ce813205cf23b2a6c";
    };

    # tests depend on $HOME setting
    configurePhase = "export HOME=$TMPDIR";

    propagatedBuildInputs =
      [ pythonPackages.pyyaml
        pythonPackages.unidecode
        pythonPackages.mutagen
        pythonPackages.munkres
        pythonPackages.musicbrainzngs
        modules.sqlite3
        modules.readline
      ];

    meta = {
      homepage = http://beets.radbox.org;
      description = "Music tagger and library organizer";
      license = pkgs.lib.licenses.mit;
      maintainers = [ stdenv.lib.maintainers.iElectric ];
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
      license = pkgs.lib.licenses.mit;
    };
  };


  bitstring = buildPythonPackage rec {
    name = "bitstring-3.1.2";

    src = fetchurl {
      url = "https://python-bitstring.googlecode.com/files/${name}.zip";
      sha256 = "1i1p3rkj4ad108f23xyib34r4rcy571gy65paml6fk77knh0k66p";
    };

    buildInputs = [ pkgs.unzip ];

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
    version = "0.13.1";
    name = "botocore-${version}";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/b/botocore/${name}.tar.gz";
      sha256 = "192kxgw76b22zmk5mxjkij5rskibb9jfaggvpznzy3ggsgja7yy8";
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
      license = pkgs.lib.licenses.zpt21;
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
      license = pkgs.lib.licenses.zpt21;
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
      license = pkgs.lib.licenses.zpt21;
      maintainers = [ stdenv.lib.maintainers.garbas ];
    };
  };


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

    propagatedBuildInputs = [ pythonPackages.stompclient pythonPackages.distribute ];

    buildInputs = [ pythonPackages.coverage pythonPackages.sqlalchemy ];

    # ValueError: Could not parse auth file:
    # /tmp/nix-build-.../CoilMQ-0.6.1/coilmq/tests/resources/auth.ini
    doCheck = false;

    meta = {
      description = "Simple, lightweight, and easily extensible STOMP message broker";
      homepage = http://code.google.com/p/coilmq/;
      license = pkgs.lib.licenses.asl20;
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
      license = pkgs.lib.licenses.mit;
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
      license = pkgs.lib.licenses.bsd3;
      maintainers = [ stdenv.lib.maintainers.garbas ];
    };
  });


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


  coverage = buildPythonPackage rec {
    name = "coverage-3.6";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/c/coverage/${name}.tar.gz";
      md5 = "67d4e393f4c6a5ffc18605409d2aa1ac";
    };

    meta = {
      description = "Code coverage measurement for python";
      homepage = http://nedbatchelder.com/code/coverage/;
      license = pkgs.lib.licenses.bsd3;
      maintainers = [ stdenv.lib.maintainers.shlevy ];
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
    name = "pytest-2.3.5";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/pytest/${name}.tar.gz";
      md5 = "18f150e7be96b5fe3c388b0e817b8087";
    };

    propagatedBuildInputs = [ pythonPackages.py ]
      ++ stdenv.lib.optional
        pkgs.config.pythonPackages.pytest.selenium or false
        pythonPackages.selenium;

    meta = with stdenv.lib; {
      maintainers = with maintainers; [ iElectric lovek323 ];
      platforms   = platforms.unix;
    };
  };

  pytest_xdist = buildPythonPackage rec {
    name = "pytest-xdist-1.8";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/p/pytest-xdist/pytest-xdist-1.8.zip";
      md5 = "9c0b8efe9d43b460f8cf049fa46ce14d";
    };

    buildInputs = [ pkgs.unzip pytest ];
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

    buildInputs = [ pkgs.unzip pythonPackages.mock ];

    # couple of failing tests
    doCheck = false;

    meta = {
      description = "A Python package to parse and build CSS";

      homepage = http://code.google.com/p/cssutils/;

      license = "LGPLv3+";
    };
  });

  darcsver = buildPythonPackage (rec {
    name = "darcsver-1.7.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/d/darcsver/${name}.tar.gz";
      md5 = "94ca7e8c9ea0f69c0f3fc6f9fc88f65a";
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
    name = "dateutil-2.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/python-dateutil/python-${name}.tar.gz";
      sha256 = "1vlx0lpsxjxz64pz87csx800cwfqznjyr2y7nk3vhmzhkwzyqi2c";
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
    name = "decorator-3.3.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/d/decorator/${name}.tar.gz";
      md5 = "a8fc62acd705f487a71bc406e19e0cc6";
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

    buildInputs = [ pkgs.unzip ];

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
    name = "gtimelog-0.8.1";
    src = fetchurl {
      url = https://launchpad.net/gtimelog/devel/0.8.1/+download/gtimelog-0.8.1.tar.gz;
      sha256 = "010sbw4rmslf5ifg9bgicn0f6mgsy76v8218xi0jndi9z6pva7y6";
    };
    propagatedBuildInputs = [ pygtk ];
    meta = with stdenv.lib; {
      description = "A small Gtk+ app for keeping track of your time. It's main goal is to be as unintrusive as possible.";
      homepage = http://mg.pov.lt/gtimelog/;
      license = licenses.gpl2Plus;
      maintainers = [ maintainers.ocharles ];
      platforms = platforms.unix;
    };
  };

  logilab_astng = buildPythonPackage rec {
    name = "logilab-astng-0.24.1";

    src = fetchurl {
      url = "http://download.logilab.org/pub/astng/${name}.tar.gz";
      sha256 = "00qxaxsax80sknwv25xl1r49lc4gbhkxs1kjywji4ad8y1npax0s";
    };

    propagatedBuildInputs = [ logilab_common ];
  };


  paver = buildPythonPackage rec {
    version = "1.2.1";
    name    = "Paver-${version}";

    src = fetchurl {
      url    = "https://pypi.python.org/packages/source/P/Paver/Paver-${version}.tar.gz";
      sha256 = "1b1023jks1gi1rwphdy3y2zx7dh4bvwk2050kclp95j7xym1ya0y";
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
    name = "pyramid-1.4.5";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyramid/${name}.tar.gz";
      md5 = "321731aad69e9788b7819e257a50be1a";
    };

    buildInputs = [
      docutils
      virtualenv
      webtest
      zope_component
      zope_interface
    ] ++ optional isPy26 unittest2;

    propagatedBuildInputs = [
      chameleon
      Mako
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


  pyramid_jinja2 = buildPythonPackage rec {
    name = "pyramid_jinja2-1.6";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyramid_jinja2/${name}.zip";
      md5 = "b7df1ab97f90f39529d27ba6da1f6b1c";
    };

    buildInputs = [ pkgs.unzip webtest ];
    propagatedBuildInputs = [ jinja2 pyramid ];

    meta = {
      maintainers = [ stdenv.lib.maintainers.iElectric ];
      platforms = stdenv.lib.platforms.all;
    };
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

    propagatedBuildInputs = [ transaction pyramid ];
    meta = {
      maintainers = [
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.iElectric
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
 
    buildInputs = [ pkgs.unzip zope_interface zope_location zope_schema ];

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
    name = "Chameleon-2.11";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/C/Chameleon/${name}.tar.gz";
      md5 = "df72458bf3dd26a744dcff5ad555c34b";
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


  distribute = stdenv.mkDerivation rec {
    name = "distribute-0.6.34";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/d/distribute/distribute-0.6.34.tar.gz";
      md5 = "4576ab843a6db5100fb22a72deadf56d";
    };

    buildInputs = [ python wrapPython offlineDistutils ];

    pythonPath = [ recursivePthLoader ];

    installPhase=''
      dst="$out/lib/${python.libPrefix}/site-packages"
      mkdir -p $dst
      PYTHONPATH="${offlineDistutils}/lib/${python.libPrefix}/site-packages:$PYTHONPATH"
      export PYTHONPATH="$dst:$PYTHONPATH"

      ${python}/bin/${python.executable} setup.py install --prefix="$out"

      eapth="$out/lib/${python.libPrefix}"/site-packages/easy-install.pth
      if [ -e "$eapth" ]; then
          # move colliding easy_install.pth to specifically named one
          mv "$eapth" $(dirname "$eapth")/${name}.pth
      fi

      rm -f "$out/lib/${python.libPrefix}"/site-packages/site.py*

      wrapPythonPrograms
    '';

    meta = {
      description = "Easily download, build, install, upgrade, and uninstall Python packages";
      homepage = http://packages.python.org/distribute;
      license = "PSF or ZPL";
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
      pyGtkGlade libtorrentRasterbar twisted Mako chardet pyxdg pyopenssl
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
    version = "1.6";

    src = fetchurl {
      url = "http://www.djangoproject.com/m/releases/1.6/${name}.tar.gz";
      sha256 = "165bd5wmv2an9h365d12k0112z0l375dxsy7dlxa7r8kyg4gvnfk";
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
    version = "1.5.5";

    src = fetchurl {
      url = "http://www.djangoproject.com/m/releases/1.5/${name}.tar.gz";
      sha256 = "07fp8ycx76q2nz96mxld1svvpfsrivjgpql0mr20r7gwzcfrrrka";
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
    version = "1.4.10";

    src = fetchurl {
      url = "http://www.djangoproject.com/m/releases/1.4/${name}.tar.gz";
      sha256 = "1pi9mi14f19xlp29j2c8dz8rs749c1m41d9j1i0b3nlz0cy0h7rx";
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
    name = "dulwich-0.8.1";

    src = fetchurl {
      url = "http://samba.org/~jelmer/dulwich/${name}.tar.gz";
      sha256 = "1a1619e9c7e63fe9bdc93356ee893be1016b7ea12ad953f4e1f1f5c0c5056ee8";
    };

    buildPhase = "make build";
    installCommand = ''
      ${python}/bin/${python.executable} setup.py install --prefix="$out" --root=/ --record="$out/lib/${python.libPrefix}/site-packages/dulwich/list.txt" --single-version-externally-managed
    '';

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
    name = "docutils-0.8.1";

    src = fetchurl {
      url = "mirror://sourceforge/docutils/${name}.tar.gz";
      sha256 = "0wfz4nxl95jcr2f2mc5gijgighavcghg33plzbz5jyi531jpffss";
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
      license = pkgs.lib.licenses.mit;
      maintainers = [ stdenv.lib.maintainers.garbas ];
    };
  });


  flask = buildPythonPackage {
    name = "flask-0.9";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/F/Flask/Flask-0.9.tar.gz";
      md5 = "4a89ef2b3ab0f151f781182bd0cc8933";
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
    name = "gflags-1.5.1";

    src = fetchurl {
      url = "http://python-gflags.googlecode.com/files/python-${name}.tar.gz";
      sha256 = "1p8blsc3z1wasi9dhbjij7m2czps17dll3cpj37v97fv5ww7al9v";
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
      sha256 = "0g2yg9qf7qgjwv13x0rx51rzhn99pcmjpb3vk0g3gmmdsqyqi0d6";
    };

    buildInputs = [ pkgs.hddtemp ];

    propagatedBuildInputs = [ psutil jinja2 modules.curses modules.curses_panel];

    doCheck = false;

    preConfigure = ''
      sed -i -r -e '/data_files.append[(][(](conf|etc)_path/ietc_path="etc/glances"; conf_path="etc/glances"' setup.py;
    '';

    meta = {
      version = "1.7.1";
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

    meta = with stdenv.lib; {
      description = "Search your google contacts from the command-line or mutt.";
      homepage    = "https://pypi.python.org/pypi/goobook";
      license     = licenses.gpl3;
      maintainers = with maintainers; [ lovek323 ];
      platforms   = platforms.unix;
    };

    propagatedBuildInputs = [ distribute gdata hcs_utils keyring simplejson ];
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
    rev = "1738";
    name = "gyp-r${rev}";

    src = fetchsvn {
      url = "http://gyp.googlecode.com/svn/trunk";
      inherit rev;
      sha256 = "155k7v6453j2kg02xqfqbkzkbaqc8aynxs2k462jmrp638vxia9s";
    };

    patches = optionals pkgs.stdenv.isDarwin [
      ../development/python-modules/gyp/no-xcode.patch
      ../development/python-modules/gyp/no-darwin-cflags.patch
    ];

    meta = {
      homepage = http://code.google.com/p/gyp;
      license = stdenv.lib.licenses.bsd3;
      description = "Generate Your Projects";
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
    version = "0.6.0";

    src = fetchurl {
      url = "https://github.com/RedMoonStudios/hetzner/archive/"
          + "v${version}.tar.gz";
      sha256 = "1cgi77f453ahw3ad6hvqwbyp6fwnh90rlzfgl9cp79wg58wyar4w";
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
    name = "httplib2-0.8";

    src = fetchurl {
      url = "http://httplib2.googlecode.com/files/${name}.tar.gz";
      sha256 = "0gww8axb4j1vysbk9kfsk5vrws9a403gh30dxchmga8hrg1rns5g";
    };

    meta = {
      homepage = http://code.google.com/p/httplib2;
      description = "A comprehensive HTTP client library";
      license = pkgs.lib.licenses.mit;
      maintainers = [ stdenv.lib.maintainers.garbas ];
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
    name = "ipaddr-2.1.7";
    src = fetchurl {
      url = "http://ipaddr-py.googlecode.com/files/ipaddr-2.1.7.tar.gz";
      md5 = "71a2be9f1d528d9a945ef555de312685";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      description = "Google's IP address manipulation library";
      homepage = http://code.google.com/p/ipaddr-py/;
      license = pkgs.lib.licenses.asl20;
    };
  };

  ipdb = buildPythonPackage {
    name = "ipdb-0.7";
    src = fetchurl {
      url = "http://pypi.python.org/packages/source/i/ipdb/ipdb-0.7.tar.gz";
      md5 = "d879f9b2b0f26e0e999809585dcaec61";
    };
    propagatedBuildInputs = [ pythonPackages.ipython ];
  };

  ipdbplugin = buildPythonPackage {
    name = "ipdbplugin-1.4";
    src = fetchurl {
      url = "https://pypi.python.org/packages/source/i/ipdbplugin/ipdbplugin-1.4.tar.gz";
      md5 = "f9a41512e5d901ea0fa199c3f648bba7";
    };
    propagatedBuildInputs = [ pythonPackages.nose pythonPackages.ipython ];
  };


  jedi = buildPythonPackage (rec {
    name = "jedi-0.7.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/j/jedi/${name}.tar.gz";
      sha256 = "1afs06k1j6raasdps1fvdqywyk3if1qchdpl4mivnliqzxqd1w01";
    };

    meta = {
      homepage = "https://github.com/davidhalter/jedi";
      description = "An autocompletion tool for Python that can be used for text editors.";
      license = pkgs.lib.licenses.lgpl3Plus;
      maintainers = [ stdenv.lib.maintainers.garbas ];
    };
  });

  jinja2 = buildPythonPackage rec {
    name = "Jinja2-2.7";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/J/Jinja2/${name}.tar.gz";
      sha256 = "0kgsd7h27jl2jpqa1ks88h93z50bsg0yr7qkicqpxbl9s4c1aks7";
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
    name = "jmespath-0.0.2";

    src = fetchurl {
      url = "https://github.com/boto/jmespath/archive/0.0.2.tar.gz";
      sha256 = "0wr1gq3gdyn3n21pvj62csdm095512zxd10gkg5ai1vvxh0mbn3r";
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
      [ pkgs.unzip fs gdata python_keyczar mock pyasn1 pycrypto pytest ];
  };

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
      license = pkgs.lib.licenses.asl20;
    };
  };


  libcloud = buildPythonPackage (rec {
    name = "libcloud-0.3.1";

    src = fetchurl {
      url = mirror://apache/incubator/libcloud/apache-libcloud-incubating-0.3.1.tar.bz2;
      sha256 = "11qilrs4sd4c1mkd64ikrjsc2vwrshhc54n5mh4xrark9c7ayp0y";
    };

    buildInputs = [ zope_interface mock ];

    preConfigure = "cp test/secrets.py-dist test/secrets.py";

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
    name = "logilab-common-0.58.2";

    src = fetchurl {
      url = "http://download.logilab.org/pub/common/${name}.tar.gz";
      sha256 = "0qfdyj2is0scpnkgpnqm12lh4yl27617l0irlilhk25cpgbbfbf9";
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
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
    '';

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

  magic = pkgs.stdenv.mkDerivation rec {
    name = "python-${pkgs.file.name}";

    src = pkgs.file.src;

    patches = [ ../tools/misc/file/python.patch ];
    buildInputs = [ python pkgs.file ];

    configurePhase = "cd python";

    buildPhase = "${python}/bin/${python.executable} setup.py build";

    installPhase = ''
      ${python}/bin/${python.executable} setup.py install --prefix=$out
    '';

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

    buildPhase = "${python}/bin/${python.executable} setup.py build_ext --openssl=${pkgs.openssl}";

    doCheck = false; # another test that depends on the network.

    meta = {
      description = "A Python crypto and SSL toolkit";
      homepage = http://chandlerproject.org/Projects/MeTooCrypto;
    };
  };


  Mako = buildPythonPackage rec {
    name = "Mako-0.8.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/M/Mako/${name}.tar.gz";
      md5 = "96d962464ce6316004af0cc48495d73e";
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


  # not sure if this is the best way to accomplish this -- needed to provide
  # objective-c compiler on darwin
  matplotlibStdenv = if stdenv.isDarwin
    then pkgs.clangStdenv
    else pkgs.stdenv;

  matplotlib = matplotlibStdenv.mkDerivation (rec {
    name = "matplotlib-1.2.1";

    src = fetchurl {
      url = "http://downloads.sourceforge.net/matplotlib/${name}.tar.gz";
      sha256 = "16x2ksdxx5p92v98qngh29hdz1bnqy77fhggbjq30pyqmrr8kqaj";
    };

    # error: invalid command 'test'
    doCheck = false;

    buildInputs = [ python pkgs.which pkgs.ghostscript ];

    propagatedBuildInputs =
      [ dateutil numpy pkgs.freetype pkgs.libpng pkgs.pkgconfig pkgs.tcl
        pkgs.tk pkgs.xlibs.libX11 ];

    buildPhase = "python setup.py build";

    installPhase = "python setup.py install --prefix=$out";

    meta = with stdenv.lib; {
      description = "python plotting library, making publication quality plots";
      homepage    = "http://matplotlib.sourceforge.net/";
      maintainers = with maintainers; [ lovek323 ];
      platforms   = platforms.unix;
    };
  });


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
      license = pkgs.lib.licenses.mit;
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
      sha256 = "1ddqni6d4kc8ypl6yig4nc00izvbk359sz6hykb9g0lfcpfqlngj";
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
      version = "0.9";
      description = ''Man-in-the-middle proxy'';
      homepage = "http://mitmproxy.org/";
      license = pkgs.lib.licenses.mit;
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
    version = "0.1a9";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/m/mr.bob/mr.bob-${version}.zip";
      md5 = "2d27d9bd1fc6269a3ecfd1a1ae47cd8a";
    };

    buildInputs = [ pkgs.unzip ];

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
      license = pkgs.lib.licenses.bsd3;
      maintainers = [ stdenv.lib.maintainers.iElectric ];
    };
  };


  musicbrainzngs = buildPythonPackage rec {
    name = "musicbrainzngs-0.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/m/musicbrainzngs/${name}.tar.gz";
      md5 = "bc32aa1cf121f29c3ca1c06e9668865f";
    };

    meta = {
      homepage = http://alastair/python-musicbrainz-ngs;
      description = "Python bindings for musicbrainz NGS webservice";
      license = pkgs.lib.licenses.bsd2;
      maintainers = [ stdenv.lib.maintainers.iElectric ];
    };
  };


  mutagen = buildPythonPackage (rec {
    name = "mutagen-1.20";

    src = fetchurl {
      url = "http://mutagen.googlecode.com/files/${name}.tar.gz";
      sha256 = "1rz63nh7r6qj3zsidf8d3a7ih647prvvqzi51p8dqkqmvrwc8mky";
    };

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
      sha256 = "1y8lx2j1jrr93mqfb06zg1x5jm9lllw744sb61ib8dagw43nnq3v";
    };

    buildInputs = [
      pkgs.pyopenssl pyasn1
    ];

    doCheck = false;

    meta = {
      version = "0.9";
      description = ''Man-in-the-middle proxy'';
      homepage = "https://github.com/cortesi/netlib";
      license = pkgs.lib.licenses.mit;
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
    version = "1.3.0";
    name = "nose-${version}";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/n/nose/${name}.tar.gz";
      sha256 = "0q2j9zz39h3liwbp6lb94kl3sxb9z9rbwh5dzyccyxfy4lrwqqsf";
    };

    buildInputs = [ coverage ];

    doCheck = ! stdenv.isDarwin;
    checkPhase = if python.is_py3k or false then ''
      ${python}/bin/${python.executable} setup.py build_tests
    '' else "" + ''
      ${python}/bin/${python.executable} selftest.py
    '';

    meta = {
      description = "A unittest-based testing framework for python that makes writing and running tests easier";
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

    patches = pkgs.lib.singleton (fetchurl {
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

  notmuch = pkgs.stdenv.mkDerivation rec {
    name = "python-${pkgs.notmuch.name}";

    src = pkgs.notmuch.src;

    buildInputs = [ python pkgs.notmuch ];
    #propagatedBuildInputs = [ python pkgs.notmuch ];

    configurePhase = "cd bindings/python";

    buildPhase = "python setup.py build";

    installPhase = "python setup.py install --prefix=$out";

    meta = {
      description = "A Python wrapper around notmuch";
      homepage = http://notmuchmail.org/;
      maintainers = [ stdenv.lib.maintainers.garbas ];
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
    '';

    # TODO: add ATLAS=${pkgs.atlas}
    installCommand = ''
      export BLAS=${pkgs.blas} LAPACK=${pkgs.liblapack}
      ${python}/bin/${python.executable} setup.py build --fcompiler="gnu95"
      ${python}/bin/${python.executable} setup.py install --prefix=$out
    '';

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
      license = pkgs.lib.licenses.mit;
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

  pandas = buildPythonPackage rec {
    name = "pandas-0.12.0";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/p/pandas/${name}.tar.gz";
      sha256 = "0vf865wh1kcq33189ykqgngb25nxhxxch6skfdl3c6w024v4r6xy";
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
    name = "paramiko-1.12.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/paramiko/${name}.tar.gz";
      md5 = "4187f77b1a5a313c899993930e30c321";
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


  pep8 = buildPythonPackage rec {
    name = "pep8-${version}";
    version = "1.4.6";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/pep8/${name}.tar.gz";
      md5 = "a03bb494859e87b42601b61b1b043a0c";
    };

    #======================================================================
    #FAIL: test_check_simple (testsuite.test_shell.ShellTestCase)
    #----------------------------------------------------------------------
    #Traceback (most recent call last):
    #  File "/tmp/nix-build-python-pep8-1.4.5.drv-0/pep8-1.4.5/testsuite/test_shell.py", line 84, in test_check_simple
    #    self.assertTrue(config_filename.endswith('tox.ini'))
    #AssertionError: False is not true
    #
    #----------------------------------------------------------------------
    #Ran 21 tests in 0.711s
    #
    #FAILED (failures=1)
    doCheck = false;

    meta = {
      homepage = "http://pep8.readthedocs.org/";
      description = "Python style guide checker";
      license = pkgs.lib.licenses.mit;
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

    buildInputs = [ pkgs.unzip ];

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
    version = "1.4.1";
    name = "pip-${version}";
    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/pip/pip-${version}.tar.gz";
      sha256 = "0knhj3c1nqqzxgqin8l0gzy6nzsbcxinyr0cbp1j99hi8xahcyjf";
    };
    buildInputs = [ mock scripttest virtualenv nose ];
    # ValueError: Working directory tests not found, or not a directory
    # see https://github.com/pypa/pip/issues/92
    doCheck = false;
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
    name = "Pillow-2.2.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Pillow/${name}.zip";
      md5 = "d1d20d3db5d1ab312da0951ff061e6bf";
    };

    buildInputs = [ pkgs.freetype pkgs.libjpeg pkgs.unzip pkgs.zlib pkgs.libtiff pkgs.libwebp ];

    # NOTE: we use LCMS_ROOT as WEBP root since there is not other setting for webp.
    configurePhase = ''
      sed -i "setup.py" \
          -e 's|^FREETYPE_ROOT =.*$|FREETYPE_ROOT = _lib_include("${pkgs.freetype}")|g ;
              s|^JPEG_ROOT =.*$|JPEG_ROOT = _lib_include("${pkgs.libjpeg}")|g ;
              s|^ZLIB_ROOT =.*$|ZLIB_ROOT = _lib_include("${pkgs.zlib}")|g ;
              s|^LCMS_ROOT =.*$|LCMS_ROOT = _lib_include("${pkgs.libwebp}")|g ;
              s|^TIFF_ROOT =.*$|TIFF_ROOT = _lib_include("${pkgs.libtiff}")|g ;'
    '';

    doCheck = true;

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
    name = "plumbum-1.2.0";

    buildInputs = [ pythonPackages.six ];

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/p/plumbum/plumbum-1.2.0.tar.gz";
      md5 = "18b7f888dfaf62a48df937abffe07897";
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
      license = pkgs.lib.licenses.mit;
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

    buildPhase = ''
      python setup.py build
    '';

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
    name = "psycopg2-2.5.1";

    # error: invalid command 'test'
    doCheck = false;

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/p/psycopg2/psycopg2-2.5.1.tar.gz";
      sha256 = "1v7glzzzykbaqj7dhpr0qds9cf4maxmn7f5aazpqnbg0ly40r9v5";
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
      license = pkgs.lib.licenses.mit;
    };
  };


  py = buildPythonPackage rec {
    name = "py-1.4.13";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/p/py/py-1.4.13.tar.gz";
      md5 = "3857dc8309d5f284669b81184253c2bb";
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

      platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
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
    name = "pygit2-0.18.1";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/p/pygit2/${name}.tar.gz";
      md5 = "8d27f84509a96d6791a6c393ae67d7c8";
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
    name = "Babel-0.9.6";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/B/Babel/${name}.tar.gz";
      sha256 = "4a3a085ecf1fcd2736573538ffa114f1f4331b3bbbdd69381e6e172c49c9750f";
    };

    buildInputs = [ pytz ];

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


  pycryptopp = buildPythonPackage (rec {
    name = "pycryptopp-0.5.29";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/pycryptopp/${name}.tar.gz";
      sha256 = "d504775b73d30fb05a3237f83c4e9e1ff3312cbba90a4a23e6cbb7d32219502b";
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
    name = "pyflakes-0.7.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyflakes/${name}.tar.gz";
      md5 = "ec94ac11cb110e6e72cca23c104b66b1";
    };

    buildInputs = [ unittest2 ];

    meta = {
      homepage = "https://launchpad.net/pyflakes";
      description = "A simple program which checks Python source files for errors.";
      license = pkgs.lib.licenses.mit;
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
      paths = pkgs.lib.concatStringsSep "," (map (l: "\"${l}/lib\"") libs);
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
    name = "Pygments-1.5";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Pygments/${name}.tar.gz";
      md5 = "ef997066cc9ee7a47d01fb4f3da0b5ff";
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
      license = pkgs.lib.licenses.lgpl21;
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
      license = pkgs.lib.licenses.mit;
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
      ${python}/bin/${python.executable} tests/baseclass.py -vv
    '';

    meta = {
      homepage = "http://fedoraproject.org/wiki/Pykickstart";
      description = "Read and write Fedora kickstart files";
      license = pkgs.lib.licenses.gpl2Plus;
    };
  };


  pyodbc = buildPythonPackage rec {
    name = "pyodbc-3.0.7";

    src = fetchurl {
      url = "https://pyodbc.googlecode.com/files/${name}.zip";
      sha256 = "0ldkm8xws91j7zbvpqb413hvdz8r66bslr451q3qc0xi8cnmydfq";
    };

    buildInputs = [ pkgs.unzip pkgs.libiodbc ];

    meta = with stdenv.lib; {
      description = "Python ODBC module to connect to almost any database";
      homepage = https://code.google.com/p/pyodbc/;
      license = licenses.mit;
      platforms = platforms.linux;
      maintainers = [ maintainers.bjornfor ];
    };
  };


  pyparsing = buildPythonPackage rec {
    name = "pyparsing-1.5.6";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyparsing/${name}.tar.gz";
      md5 = "1e41cb219dae9fc353bd4cd47636b283";
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
    '' + pkgs.lib.optionalString stdenv.isi686 ''
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
      ${python}/bin/${python.executable} -m unittest discover -v
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
    name = "ldap-2.4.10";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/python-ldap/${name}.tar.gz";
      sha256 = "0m6fm2alcb5v9xdcjv2nw2lhz9nnd3mnr5lrmf397hi4pw0pik37";
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
    version = "v0.25";
    name = "Pymacs-${version}";

    src = fetchurl {
      url = "https://github.com/pinard/Pymacs/tarball/${version}";
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
    let version = "3.0.0b5";
    in
      buildPythonPackage {
        name = "pyopengl-${version}";

        src = fetchurl {
          url = "mirror://sourceforge/pyopengl/PyOpenGL-${version}.tar.gz";
          sha256 = "1rjpl2qdcqn4wamkik840mywdycd39q8dn3wqfaiv35jdsbifxx3";
        };

        propagatedBuildInputs = with pkgs; [ mesa freeglut pil ];

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
    name = "pyserial-2.6";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyserial/${name}.tar.gz";
      md5 = "cde799970b7c1ce1f7d6e9ceebe64c98";
    };

    doCheck = false;

    meta = {
      homepage = "http://pyserial.sourceforge.net/";
      license = stdenv.lib.licenses.psfl;
      description = "Python serial port extension";
    };
  };


  pysqlite = buildPythonPackage (rec {
    name = "pysqlite-2.5.5";

    src = fetchurl {
      url = "http://pysqlite.googlecode.com/files/${name}.tar.gz";
      sha256 = "ef7ca7f44893790e1a7084b10ea083770e138689406fddc7076d12d6bff4d44f";
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
    name = "pysvn-1.7.6";

    src = fetchurl {
      url = "http://pysvn.barrys-emacs.org/source_kits/pysvn-1.7.6.tar.gz";
      sha256 = "0wwb9h3rw2r8hzqya8mv5z8pgjpa6y3i15a3cccdv2mil44289a7";
    };

    buildInputs = [ python pkgs.subversion pkgs.apr pkgs.aprutil pkgs.expat pkgs.neon pkgs.openssl ]
      ++ (if stdenv.isLinux then [pkgs.e2fsprogs] else []);

    # There seems to be no way to pass that path to configure.
    NIX_CFLAGS_COMPILE="-I${pkgs.aprutil}/include/apr-1";

    configurePhase = ''
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
    name = "pytz-2012c";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/pytz/${name}.tar.bz2";
      md5 = "660e0cee7f6c419ca2665db460f65131";
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
      pkgconfig python gtk2 pygtk libxml2 libxslt libsoup webkit_gtk2 icu
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
    name = "PyYAML-3.09";

    src = fetchurl {
      url = "http://pyyaml.org/download/pyyaml/PyYAML-3.09.zip";
      sha256 = "204aca8b42dbe90e460794d743dd16182011da85507bfd4f092f9f76e0688040";
    };

    buildInputs = [ pkgs.unzip pkgs.pyrex ];
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
   let freetype = pkgs.lib.overrideDerivation pkgs.freetype (args: { configureFlags = "--enable-static --enable-shared"; });
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
    version = "2.8.1";
    name = "robotframework-${version}";

    src = fetchurl {
      url = "https://robotframework.googlecode.com/files/${name}.tar.gz";
      sha256 = "04zwjri1j5py3fpbhy1xlc18bhbmdm2gbd58fwa2jnhmrha5dgnw";
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


  robotframework-ride = buildPythonPackage rec {
    version = "1.2.2";
    name = "robotframework-ride-${version}";

    src = fetchurl {
      url = "https://robotframework-ride.googlecode.com/files/${name}.tar.gz";
      sha256 = "1yfvl0hdjjkwk90w3f3i23dxxk3yiyv4pbvnp4l7yd6cmxsia8f3";
    };

    propagatedBuildInputs = [ pygments wxPython modules.sqlite3 ];

    # Stop copying (read-only) permission bits from the nix store into $HOME,
    # because that leads to this:
    #   IOError: [Errno 13] Permission denied: '/home/bfo/.robotframework/ride/settings.cfg'
    postPatch = ''
      sed -i "s|shutil\.copy(|shutil.copyfile(|" src/robotide/preferences/settings.py
    '';

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

    # error: invalid command 'test'
    doCheck = false;

    # TODO: add ATLAS=${pkgs.atlas}
    installCommand = ''
      export BLAS=${pkgs.blas} LAPACK=${pkgs.liblapack}
      ${python}/bin/${python.executable} setup.py build --fcompiler="gnu95"
      ${python}/bin/${python.executable} setup.py install --prefix=$out
    '';

    meta = {
      description = "SciPy (pronounced 'Sigh Pie') is open-source software for mathematics, science, and engineering. ";
      homepage = http://www.scipy.org/;
    };
  };


  scripttest = buildPythonPackage rec {
    version = "1.1.1";
    name = "scripttest-${version}";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/S/ScriptTest/ScriptTest-${version}.tar.gz";
      md5 = "592ce890764c3f546d35b4d7c40c32ef";
    };

    buildInputs = [ nose ];

    meta = {
      description = "A library for testing interactive command-line applications";
      homepage = http://pypi.python.org/pypi/ScriptTest/;
    };
  };

  selenium =
    buildPythonPackage rec {
      name = "selenium-2.35.0";
      src = pkgs.fetchurl {
        url = "http://pypi.python.org/packages/source/s/selenium/${name}.tar.gz";
        sha256 = "0c8apd538ji8kmryvcdiz0dndf33mnf8wzpp9k8zmkpmfdfcwnk0";
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

    propagatedBuildInputs = [ jinja2 markdown pillow pilkit clint argh ];

    meta = with stdenv.lib; {
      description = "Yet another simple static gallery generator";
      homepage = http://sigal.saimon.org/en/latest/index.html;
      license = licenses.mit;
      maintainers = [ maintainers.iElectric ];
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
    name = "six-1.3.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/s/six/${name}.tar.gz";
      md5 = "ec47fe6070a8a64c802363d2c2b1e2ee";
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
      license = pkgs.lib.licenses.mit;
    };
  };


  supervisor = buildPythonPackage rec {
    name = "supervisor-3.0";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/s/supervisor/${name}.tar.gz";
      md5 = "94ff3cf09618c36889425a8e002cd51a";
    };

    buildInputs = [ mock ];
    propagatedBuildInputs = [ meld3  ];

    meta = {
      description = "A system for controlling process state under UNIX";
      homepage = http://supervisord.org/;
    };
  };

  subprocess32 = buildPythonPackage rec {
    name = "subprocess32-3.2.5rc1";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/s/subprocess32/${name}.tar.gz";
      md5 = "f5f46106368be6336b54af95d048fea9";
    };

    doCheck = false;

    meta = {
      homepage = "https://pypi.python.org/pypi/subprocess32";
      description = "Backport of the subprocess module from Python 3.2.5 for use on 2.x.";
      maintainers = [ stdenv.lib.maintainers.garbas ];
    };
  };


  sphinx = buildPythonPackage (rec {
    name = "Sphinx-1.1.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/S/Sphinx/${name}.tar.gz";
      md5 = "8f55a6d4f87fc6d528120c5d1f983e98";
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


  sqlalchemy = buildPythonPackage rec {
    name = "sqlalchemy-${version}";
    version = "0.7.10";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/S/SQLAlchemy/SQLAlchemy-${version}.tar.gz";
      sha256 = "0rhxgr85xdhjn467qfs0dkyj8x46zxcv6ad3dfx3w14xbkb3kakp";
    };

    patches = [
      # see https://groups.google.com/forum/#!searchin/sqlalchemy/module$20logging$20handlers/sqlalchemy/ukuGhmQ2p6g/2_dOpBEYdDYJ
      # waiting for 0.7.11 release
      ../development/python-modules/sqlalchemy-0.7.10-test-failures.patch
    ];

    buildInputs = [ nose ];

    propagatedBuildInputs = [ modules.sqlite3 ];

    meta = {
      homepage = http://www.sqlalchemy.org/;
      description = "A Python SQL toolkit and Object Relational Mapper";
    };
  };


  sqlalchemy8 = buildPythonPackage rec {
    name = "SQLAlchemy-${version}";
    version = "0.8.2";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/S/SQLAlchemy/${name}.tar.gz";
      md5 = "5a33fb43dea93468dbb2a6562ee80b54";
    };

    buildInputs = [ nose mock ];

    propagatedBuildInputs = [ modules.sqlite3 ];

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

    buildInputs = [ pytest webob pkgs.imagemagick ];
    propagatedBuildInputs = [ sqlalchemy8 wand ];

    checkPhase = "cd tests && LD_LIBRARY_PATH=${pkgs.imagemagick}/lib py.test";

    meta = {
      homepage = https://github.com/crosspop/sqlalchemy-imageattach;
      description = "SQLAlchemy extension for attaching images to entity objects";
      license = pkgs.lib.licenses.mit;
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
      license = pkgs.lib.licenses.bsd3;
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
      license = pkgs.lib.licenses.asl20;
    };
  });


  subunit = buildPythonPackage rec {
    name = "subunit-${version}";
    version = "0.0.13";

    src = fetchurl {
      url = "https://launchpad.net/subunit/trunk/${version}/+download/python-${name}.tar.gz";
      sha256 = "0f3xni4z1hbmg4dqxak85ibpf9pajxn6qzw1xj79gwnr8xxb66zj";
    };

    propagatedBuildInputs = [ testtools ];

    meta = {
      description = "A streaming protocol for test results";
      homepage = https://launchpad.net/subunit;
      license = pkgs.lib.licenses.asl20;
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
    version = "0.9.32";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/t/testtools/${name}.tar.gz";
      sha256 = "1smgk3y7xfzh5xk5wydb6n5lx4g5i6y4w8ajrdnskx1jqr67wyyq";
    };

    propagatedBuildInputs = [ pythonPackages.python_mimeparse pythonPackages.extras ];

    meta = {
      description = "A set of extensions to the Python standard library's unit testing framework";
      homepage = http://pypi.python.org/pypi/testtools;
      license = pkgs.lib.licenses.mit;
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
      license = pkgs.lib.licenses.mit;
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
      license = pkgs.lib.licenses.mit;
    };
  };


  # TODO
  # py.error.EACCES: [Permission denied]: mkdir('/homeless-shelter',)
  # builder for `/nix/store/0czwg0n3pfkmpjphqv1jxfjlgkbziwsx-python-tox-1.4.3.drv' failed with exit code 1
  # tox = buildPythonPackage rec {
  #   name = "tox-1.4.3";
  #
  #   buildInputs = [ py virtualenv ];
  #
  #   src = fetchurl {
  #     url = "https://pypi.python.org/packages/source/t/tox/tox-1.4.3.tar.gz";
  #     md5 = "3727d5b0600d92edf2229a7ce6a0f752";
  #   };
  # };


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

     propagatedBuildInputs = [ zope_interface zope_testing ];
     meta = {
       description = "A tool which computes a dependency graph between active Python eggs";
       homepage = http://thomas-lotze.de/en/software/eggdeps/;
       license = "ZPL";
     };
   };


  turses = buildPythonPackage (rec {
    name = "turses-0.2.19";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/t/turses/${name}.tar.gz";
      sha256 = "1g58ahxpaf0wqn6gg5a2n3fkvc3vbx6jpylwqncxnl16qcczmjxn";
    };

    propagatedBuildInputs = [ oauth2 urwid tweepy ] ++ optional isPy26 argparse;

    #buildInputs = [ tox ];
    # needs tox
    doCheck = false;

    meta = {
      homepage = "https://github.com/alejandrogomez/turses";
      description = "A Twitter client for the console.";
      license = pkgs.lib.licenses.gpl3;
      maintainers = [ stdenv.lib.maintainers.garbas ];
      platforms = stdenv.lib.platforms.linux;
    };
  });

  tweepy = buildPythonPackage (rec {
    name = "tweepy-2.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/t/tweepy/${name}.tar.gz";
      sha256 = "1irzwfva7g1k7db708mlxy2qribd6938zwn5xzjzn6i43j5mjysm";
    };

    meta = {
      homepage = "https://github.com/tweepy/tweepy";
      description = "Twitter library for python";
      license = pkgs.lib.licenses.mit;
      maintainers = [ stdenv.lib.maintainers.garbas ];
      platforms = stdenv.lib.platforms.linux;
    };
  });

  twisted = buildPythonPackage rec {
    name = "twisted-10.2.0";

    src = fetchurl {
      url = http://tmrc.mit.edu/mirror/twisted/Twisted/10.2/Twisted-10.2.0.tar.bz2;
      sha256 = "110c30z622jn14yany1sxfaqj5qx20n9rc9zqacxlwma30fdcbjn";
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

      license = "MIT";

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
    name = "urwid-1.1.1";

    # multiple:  NameError: name 'evl' is not defined
    doCheck = false;

    src = fetchurl {
      url = "http://excess.org/urwid/${name}.tar.gz";
      md5 = "eca2e0413cf7216b01c84b99e0f2576d";
    };

    meta = {
      description = "A full-featured console (xterm et al.) user interface library";
      homepage = http://excess.org/urwid;
      license = pkgs.lib.licenses.lgpl21;
      maintainers = [ stdenv.lib.maintainers.garbas ];
    };
  });

  virtualenv = buildPythonPackage rec {
    name = "virtualenv-1.10";
    src = fetchurl {
      url = "http://pypi.python.org/packages/source/v/virtualenv/${name}.tar.gz";
      md5 = "9745c28256c70c76d36adb3767a00212";
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
    version = "1.2.3";
    name = "webob-${version}";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/W/WebOb/WebOb-${version}.tar.gz";
      md5 = "11825b7074ba7043e157805e4e6e0f55";
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
    version = "2.0.3";
    name = "webtest-${version}";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/W/WebTest/WebTest-${version}.zip";
      md5 = "a1266d4db421963fd3deb172c6689e4b";
    };

    buildInputs = [ pkgs.unzip ] ++ optionals isPy26 [ pythonPackages.ordereddict ];

    # XXX: skipping two tests fails in python2.6
    doCheck = ! isPy26;

    propagatedBuildInputs = [
      nose
      webob
      six
      beautifulsoup4
      waitress
      unittest2
      mock
      pyquery
      wsgiproxy2
      paste_deploy
      coverage
    ];

    meta = {
      description = "Helper to test WSGI applications";
      homepage = http://pythonpaste.org/webtest/;
      platforms = stdenv.lib.platforms.all;
    };
  };


  werkzeug = buildPythonPackage {
    name = "werkzeug-0.8.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/W/Werkzeug/Werkzeug-0.8.3.tar.gz";
      md5 = "12aa03e302ce49da98703938f257347a";
    };

    meta = {
      homepage = http://werkzeug.pocoo.org/;
      description = "A WSGI utility library for Python";
      license = "BSD";
    };
  };


  wokkel = buildPythonPackage (rec {
    url = "http://wokkel.ik.nu/releases/0.7.0/wokkel-0.7.0.tar.gz";
    name = pkgs.lib.nameFromURL url ".tar";
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
    version = "2.9.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/Z/ZConfig/ZConfig-${version}.tar.gz";
      md5 = "2c5f73c216140a705be3d9c44b988722";
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
    name = "zfec-1.4.7";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zfec/${name}.tar.gz";
      sha256 = "3335c9054f45e2c59188400e892634b68761b29d06f3cafe525c60484902d379";
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

    buildInputs = [ pkgs.unzip zope_interface ];

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

    buildInputs = [ pkgs.unzip ];

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

    buildInputs = [ pkgs.unzip ];

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
    installCommand = ''
      easy_install --always-unzip --no-deps --prefix="$out" .
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

    propagatedBuildInputs = [ zope_event zope_interface zope_testing ] ++ optional isPy26 ordereddict;

    # ignore circular dependency on zope_location
    installCommand = ''
      easy_install  --no-deps --prefix="$out" .
    '';

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

    buildInputs = [ pkgs.unzip sqlalchemy zope_testing zope_interface setuptools ];
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

    buildInputs = [ pkgs.unzip ];
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

    buildInputs = [ pkgs.unzip ];

    propagatedBuildInputs = [ subunit zope_interface zope_exceptions zope_testing six ];

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

    buildInputs = [ pkgs.unzip ];

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
    version = "1.20130313";

    src = fetchurl rec {
      url = "http://code.liw.fi/debian/pool/main/p/python-cliapp/python-cliapp_${version}.orig.tar.gz";
      sha256 = "0rk13a68668gsrv6yqgzqxskffqnlyjar4qav6k5iyrp77amn7qm";
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
    name = "tornado-2.4";
    src = fetchurl {
      url = "http://pypi.python.org/packages/source/t/tornado/tornado-2.4.tar.gz";
      md5 = "c738af97c31dd70f41f6726cf0968941";
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

    buildInputs = [ pkgs.unzip unittest2 nose mock ];
    propagatedBuildInputs = [ modules.curses libarchive ];

    # tests are still failing
    doCheck = false;
  };


  libarchive = buildPythonPackage rec {
    version = "3.0.4-5";
    name = "libarchive-${version}";

    src = fetchurl {
      url = "http://python-libarchive.googlecode.com/files/python-libarchive-${version}.tar.gz";
      sha256 = "141yx9ym8gvybn67mw0lmgafzsd79rmd9l77lk0k6m2fzclqx1j5";
    };

    propagatedBuildInputs = [ pkgs.libarchive ];
  };


  pyzmq = buildPythonPackage rec {
    name = "pyzmq-13.0.0";
    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyzmq/pyzmq-13.0.0.zip";
      md5 = "fa2199022e54a393052d380c6e1a0934";
    };
    buildInputs = [ pkgs.unzip pkgs.zeromq3 ];
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
    name = "tracing-0.7";

    src = fetchurl rec {
      url = "http://code.liw.fi/debian/pool/main/p/python-tracing/python-tracing_0.7.orig.tar.gz";
      sha256 = "9954a1b0cc6b957d15975b048f929bbdd46766d397a6fa51bf8f6498b9459276";
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
    version = "0.22";

    src = fetchurl rec {
      url = "http://code.liw.fi/debian/pool/main/p/python-ttystatus/python-ttystatus_${version}.orig.tar.gz";
      sha256 = "1hzv0sbrvgcmafflhvzh7plci0dg7wcjlk39i8kqdasg6rw0ag6f";
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
    version = "1.20130316";

    src = fetchurl rec {
      url = "http://code.liw.fi/debian/pool/main/p/python-larch/python-larch_${version}.orig.tar.gz";
      sha256 = "1mkvmy0jdzd7dlvdx2a75wsbj5qw1clawcgndx9jwl816a9iy225";
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
    version = "0.9.10";

    src = fetchurl rec {
      url = "https://launchpad.net/graphite/0.9/${version}/+download/${name}.tar.gz";
      sha256 = "1zy4z4hrbiqj4ipcv2m9197hf03d4xphllqav9w4c8i6fn8zmd9n";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://graphite.wikidot.com/;
      description = "Fixed size round-robin style database";
      maintainers = [ stdenv.lib.maintainers.rickynils ];
    };
  };

  carbon = buildPythonPackage rec {
    name = "carbon-${version}";
    version = "0.9.10";

    src = fetchurl rec {
      url = "https://launchpad.net/graphite/0.9/${version}/+download/${name}.tar.gz";
      sha256 = "0wjhd87pvpcpvaj3wql2d92g8lpp33iwmxdkp7npic5mjl2y0dsg";
    };

    propagatedBuildInputs = [ whisper txamqp zope_interface twisted ];

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://graphite.wikidot.com/;
      description = "Backend data caching and persistence daemon for Graphite";
      maintainers = [ stdenv.lib.maintainers.rickynils ];
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
      license = pkgs.lib.licenses.gpl2;
      maintainers = [ stdenv.lib.maintainers.iElectric ];
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

  graphite_web = buildPythonPackage rec {
    name = "graphite-web-${version}";
    version = "0.9.11";

    src = fetchurl rec {
      url = "https://pypi.python.org/packages/source/g/graphite-web/${name}.tar.gz";
      md5 = "1499b5dded3d1054d598760fd450a6f9";
    };

    propagatedBuildInputs = [ django_1_3 django_tagging modules.sqlite3 whisper pkgs.pycairo ldap memcached ];

    postInstall = ''
      wrapProgram $out/bin/run-graphite-devel-server.py \
        --prefix PATH : ${pkgs.which}/bin
    '';

    preConfigure = ''
      substituteInPlace webapp/graphite/thirdparty/pytz/__init__.py --replace '/usr/share/zoneinfo' '/etc/zoneinfo'
      substituteInPlace webapp/graphite/settings.py --replace "join(WEBAPP_DIR, 'content')" "join(WEBAPP_DIR, 'webapp', 'content')"
      cp webapp/graphite/manage.py bin/manage-graphite.py
      substituteInPlace bin/manage-graphite.py --replace 'settings' 'graphite.settings'
    '';

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://graphite.wikidot.com/;
      description = "Enterprise scalable realtime graphing";
      maintainers = [ stdenv.lib.maintainers.rickynils ];
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

    version = "1.1.0";

    src = fetchgit {
      url = "https://github.com/jodal/pykka.git";
      rev = "refs/tags/v${version}";
      sha256 = "0w6bcaqkzwmd9habszlgjkp3kkhkna08s9aivnmna5hddsghfqmz";
    };

    # python zip complains about old timestamps
    preConfigure = ''
      find -print0 | xargs -0 touch
    '';

    # There are no tests
    doCheck = false;

    meta = {
      homepage = http://www.pykka.org;
      description = "A Python implementation of the actor model";
      maintainers = [ stdenv.lib.maintainers.rickynils ];
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
      license = pkgs.lib.licenses.asl20;
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
      license = pkgs.lib.licenses.bsd3;
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
      license = pkgs.lib.licenses.bsd3;
    };
 };

# python2.7 specific eggs
} // pkgs.lib.optionalAttrs (python.majorVersion == "2.7") {

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

}; in pythonPackages
