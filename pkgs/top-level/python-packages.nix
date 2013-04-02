{ pkgs, python }:

let
isPy26 = python.majorVersion == "2.6";
isPy27 = python.majorVersion == "2.7";
optional = pkgs.lib.optional;
optionals = pkgs.lib.optionals;

pythonPackages = python.modules // rec {

  inherit python;
  inherit (pkgs) fetchurl fetchsvn fetchgit stdenv;

  # helpers

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

  offlineDistutils = import ../development/python-modules/offline-distutils {
    inherit (pkgs) stdenv;
    inherit python;
  };

  # packages defined elsewhere

  ipython = import ../shells/ipython {
    inherit (pkgs) stdenv fetchurl sip pyqt4;
    inherit buildPythonPackage pythonPackages;
  };

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

  pycrypto25 = import ../development/python-modules/pycrypto/2.5.nix {
    inherit (pkgs) fetchurl stdenv gmp;
    inherit python buildPythonPackage;
  };

  pygobject = import ../development/python-modules/pygobject {
    inherit (pkgs) stdenv fetchurl pkgconfig glib;
    inherit python;
  };

  pygtk = import ../development/python-modules/pygtk {
    inherit (pkgs) fetchurl stdenv pkgconfig glib gtk;
    inherit python buildPythonPackage pygobject pycairo;
  };

  # XXX: how can we get an override here?
  #pyGtkGlade = pygtk.override {
  #  inherit (pkgs.gnome) libglade;
  #};
  pyGtkGlade = import ../development/python-modules/pygtk {
    inherit (pkgs) fetchurl stdenv pkgconfig glib gtk;
    inherit (pkgs.gnome) libglade;
    inherit python buildPythonPackage pygobject pycairo;
  };

  # packages defined here

  afew = buildPythonPackage rec {
    rev = "6bb3915636aaf86f046a017ffffd9a4ef395e199";
    name = "afew-1.0_${rev}";

    src = fetchurl {
      url = "https://github.com/teythoon/afew/tarball/${rev}";
      name = "${name}.tar.bz";
      sha256 = "74926d9ddfa69534cfbd08a82f0acccab2c649558062654d5d2ff2999d201384";
    };

    propagatedBuildInputs = [ notmuch pkgs.dbacl ];

    # error: invalid command 'test'
    doCheck = false;

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


  almir = buildPythonPackage rec {
    name = "almir-0.1.7";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/a/almir/${name}.zip";
      md5 = "daea15c898487a2bded1ae6ef78633e5";
    };

    buildInputs = [
      pkgs.which
      pkgs.unzip
      coverage
      mock
      tissue
      unittest2
      webtest
    ];

    propagatedBuildInputs = [ 
      pkgs.makeWrapper
      pkgs.bacula
      colander
      deform
      deform_bootstrap
      docutils
      nose
      mysql_connector_repackaged
      pg8000
      pyramid
      pyramid_beaker
      pyramid_exclog
      pyramid_jinja2
      pyramid_tm
      pytz
      sqlalchemy
      transaction
      waitress
      webhelpers
      zope_sqlalchemy
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
    rev = "d3c1880a60ddd8ded397d92cddf310a948b97fdc";
    name = "alot-0.3.4_${rev}";

    src = fetchurl {
      url = "https://github.com/pazz/alot/tarball/${rev}";
      name = "${name}.tar.bz";
      sha256 = "049fzxs83zry5xr3al5wjvh7bcjq63wilf9wxh2c6sjmg96kpvvl";
    };

    # error: invalid command 'test'
    doCheck = false;

    propagatedBuildInputs = [ notmuch urwid twisted magic configobj pygpgme ];

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

    buildInputs = [ nose ];

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
      url = git://github.com/mariusv/Area53.git;
      rev = "b2c9cdcabd";
      sha256 = "b0c12b8c48ed9180c7475fab18de50d63e1b517cfb46da4d2c66fc406fe902bc";
    };

    installCommand = "python setup.py install --prefix=$out";

    # error: invalid command 'test'
    doCheck = false;

    propagatedBuildInputs = [ boto ];

  });


  argparse = buildPythonPackage (rec {
    name = "argparse-1.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/a/argparse/${name}.zip";
      sha256 = "ee6da1aaad8b08a74a33eb82264b1a2bf12a7d5aefc7e9d7d40a8f8fa9912e62";
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

  awscli = buildPythonPackage rec {
    name = "awscli-0.5.0";
    namePrefix = "";

    src = fetchurl {
      url = https://github.com/aws/aws-cli/archive/0.5.0.tar.gz;
      sha256 = "0smgcisl2p7p2y2i299x7g271kdmgs0hnzngw5030phvh0lq202i";
    };

    propagatedBuildInputs = [ argparse botocore ];

  };

  logilab_astng = buildPythonPackage rec {
    name = "logilab-astng-0.24.1";

    src = fetchurl {
      url = "http://download.logilab.org/pub/astng/${name}.tar.gz";
      sha256 = "00qxaxsax80sknwv25xl1r49lc4gbhkxs1kjywji4ad8y1npax0s";
    };

    propagatedBuildInputs = [ logilab_common ];
  };


  beets = buildPythonPackage rec {
    name = "beets-1.0.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/b/beets/${name}.tar.gz";
      md5 = "88ad09a93aa0d69ce813205cf23b2a6c";
    };

    # tests depend on $HOME setting
    configurePhase = "export HOME=$TMPDIR";

    propagatedBuildInputs = [ pyyaml unidecode mutagen munkres musicbrainzngs python.modules.sqlite3 python.modules.readline ];

    meta = {
      homepage = http://beets.radbox.org;
      description = "Music tagger and library organizer";
      license = pkgs.lib.licenses.mit;
      maintainers = [ stdenv.lib.maintainers.iElectric ];
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
    name = "boto-2.6.0";

    src = fetchurl {
      url = "https://github.com/downloads/boto/boto/${name}.tar.gz";
      sha256 = "1wnzs9frf44mrnw7l2vijc5anbcvcqqrv7237gjn27v0ja76slff";
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
    name = "botocore-0.5.2";

    src = fetchurl {
      url = https://github.com/boto/botocore/archive/0.5.2.tar.gz;
      sha256 = "18073mydin0mwk1d7vdlmsiz3rvhjzxkaaqrmxw440acbipnngq2";
    };

    propagatedBuildInputs = [ dateutil requests014 ];

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
  #   propagatedBuildInputs = [ argparse python.modules.ssl ];
  #
  #   doCheck = false;
  #
  #   meta = {
  #     homepage = http://www.liquidx.net/pybugz/;
  #     description = "Command line interface for Bugzilla";
  #   };
  # });


  buildout = buildPythonPackage rec {
    name = "buildout-${version}";
    version = "1.7.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zc.buildout/zc.${name}.tar.gz";
      md5 = "4e3b521600e475c56a0a66459a5fc7bb";
    };

   # TODO: consider if this patch should be an option
   # It makes buildout useful in a nix profile, but this alters the default functionality
   patchPhase = ''
     sed -i "s/return (stdlib, site_paths)/return (stdlib, sys.path)/g" src/zc/buildout/easy_install.py
   '';

   meta = {
      homepage = http://www.buildout.org/;
      description = "A software build and configuration system";
    };
  };


  buildout152 = buildPythonPackage rec {
    name = "buildout-${version}";
    version = "1.5.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zc.buildout/zc.${name}.tar.gz";
      md5 = "87f7b3f8d13926c806242fd5f6fe36f7";
    };

   # TODO: consider if this patch should be an option
   # It makes buildout useful in a nix profile, but this alters the default functionality
   patchPhase = ''
     sed -i "s/return (stdlib, site_paths)/return (stdlib, sys.path)/g" src/zc/buildout/easy_install.py
   '';

   meta = {
      homepage = http://www.buildout.org/;
      description = "A software build and configuration system";
    };
  };


  carrot = buildPythonPackage rec {
    name = "carrot-0.10.7";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/c/carrot/${name}.tar.gz";
      md5 = "530a0614de3a669314c3acd4995c54d5";
    };

    buildInputs = [ nose ];

    propagatedBuildInputs = [ amqplib anyjson ];

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

    propagatedBuildInputs = [ markdown ];

    meta = {
      homepage = http://www.cheetahtemplate.org/;
      description = "A template engine and code generation tool";
    };
  };


  cherrypy = buildPythonPackage (rec {
    name = "cherrypy-3.1.2";

    src = fetchurl {
      url = "http://download.cherrypy.org/cherrypy/3.1.2/CherryPy-3.1.2.tar.gz";
      sha256 = "1xlvanhnxgvwd7vvypbafyl6yqfkpnwa9rs9k3058z84gd86bz8d";
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

    buildInputs = [ mock nose decorator ];

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

  coilmq = buildPythonPackage (rec {
    name = "coilmq-0.6.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/C/CoilMQ/CoilMQ-0.6.1.tar.gz";
      md5 = "5f39727415b837abd02651eeb2721749";
    };

    propagatedBuildInputs = [ stompclient distribute ];

    buildInputs = [ coverage sqlalchemy ];

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
    name = "colander-0.9.6";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/c/colander/${name}.tar.gz";
      md5 = "2d9f65a64cb6b7f35d6a0d7b607ce4c6";
    };

    propagatedBuildInputs = [ translationstring ];

    meta = {
      maintainers = [
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.iElectric
      ];
      platforms = stdenv.lib.platforms.all;
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
    propagatedBuildInputs = [ coverage ];
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

    buildInputs = [ pkgs.unzip mock ];

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

    buildInputs = [ mock ];

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

    propagatedBuildInputs = [ six ];

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
    name = "deform-0.9.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/d/deform/${name}.tar.gz";
      md5 = "2ed7b69644a6d8f4e1404e1892329240";
    };

    propagatedBuildInputs = [ beautifulsoup4 peppercorn colander translationstring chameleon ];

    meta = {
      maintainers = [
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.iElectric
      ];
      platforms = stdenv.lib.platforms.all;
    };
  };


  deform_bootstrap = buildPythonPackage rec {
    name = "deform_bootstrap-0.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/d/deform_bootstrap/${name}.tar.gz";
      md5 = "57812251f327367761f32d49a8286aa4";
    };

    propagatedBuildInputs = [ deform ];

    meta = {
      maintainers = [ stdenv.lib.maintainers.iElectric ];
      platforms = stdenv.lib.platforms.all;
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


  pyramid = buildPythonPackage rec {
    name = "pyramid-1.3.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyramid/${name}.tar.gz";
      md5 = "967a04fcb2143b31b279c3013a778a2b";
    };

    buildInputs = [ 
      docutils 
      virtualenv 
      webtest 
      zope_component 
      zope_interface 
    ];

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


  pyramid_exclog = buildPythonPackage rec {
    name = "pyramid_exclog-0.6";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyramid_exclog/${name}.tar.gz";
      md5 = "5c18706f5500605416afff311120c933";
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


  beaker = buildPythonPackage rec {
    name = "Beaker-1.6.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/B/Beaker/${name}.tar.gz";
      md5 = "c2e102870ed4c53104dec48ceadf8e9d";
    };

    buildInputs = [ sqlalchemy pycryptopp nose mock webtest ];

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


  repoze_lru = buildPythonPackage rec {
    name = "repoze.lru-0.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/r/repoze.lru/${name}.tar.gz";
      md5 = "9f6ab7a4ff871ba795cadf56c20fb0f0";
    };

    meta = {
      maintainers = [
        stdenv.lib.maintainers.garbas
        stdenv.lib.maintainers.iElectric
      ];
      platforms = stdenv.lib.platforms.all;
    };
  };


  zope_deprecation = buildPythonPackage rec {
    name = "zope.deprecation-3.5.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.deprecation/${name}.tar.gz";
      md5 = "1e7db82583013127aab3e7e790b1f2b6";
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

      python setup.py install --prefix="$out"

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


  distutils2  = buildPythonPackage rec {
    name = "distutils2-${version}";
    version = "1.0a4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/D/Distutils2/Distutils2-${version}.tar.gz";
      md5 = "52bc9dffb394970c27e02853ae3a3241";
    };

    patchPhase = ''
      sed -e "s#html.entities#htmlentitydefs#g" -i distutils2/pypi/simple.py
    '';

    doCheck = false;

    meta = {
      description = "A Python Packaging Library";
      homepage = http://pypi.python.org/pypi/Distutils2;
      license = "PSF";
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

  django = buildPythonPackage rec {
    name = "Django-${version}";
    version = "1.4.1";

    src = fetchurl {
      url = "http://www.djangoproject.com/m/releases/1.4/${name}.tar.gz";
      sha256 = "16s0anvpaccbqmdrhl71z73k0dy2sl166nnc2fbd5lshlgmj13ad";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      description = "A high-level Python Web framework";
      homepage = https://www.djangoproject.com/;
    };
  };


  django_1_3 = buildPythonPackage rec {
    name = "Django-1.3.3";

    src = fetchurl {
      url = "http://www.djangoproject.com/m/releases/1.3/${name}.tar.gz";
      sha256 = "0snlrcvk92qj1v0n9dpycn6sw56w4zns4mpc30837q6yi7ylrx4f";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      description = "A high-level Python Web framework";
      homepage = https://www.djangoproject.com/;
    };
  };


  django_evolution = buildPythonPackage rec {
    name = "django_evolution-0.6.7";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/d/django_evolution/${name}.tar.gz";
      md5 = "24b8373916f53f74d701b99a6cf41409";
    };

    propagatedBuildInputs = [ django_1_3 ];

    meta = {
      description = "A database schema evolution tool for the Django web framework";
      homepage = http://code.google.com/p/django-evolution/;
    };
  };


  djblets = buildPythonPackage rec {
    name = "Djblets-0.6.23";

    src = fetchurl {
      url = "http://downloads.reviewboard.org/releases/Djblets/0.6/${name}.tar.gz";
      sha256 = "1d8vg5a9q2ldnbxqap1893lqb66jwcsli2brbjx7mcnqrzcz449x";
    };

    propagatedBuildInputs = [ pil django_1_3 ];

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
      python setup.py install --prefix="$out" --root=/ --record="$out/lib/${python.libPrefix}/site-packages/dulwich/list.txt" --single-version-externally-managed
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
    name = "flake8-2.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/f/flake8/${name}.tar.gz";
      md5 = "176c6b3613777122721db181560aa1e3";
    };

    buildInputs = [ nose ];
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


  flexget = buildPythonPackage (rec {
    name = "FlexGet-1.0.3353";

    src = fetchurl {
      url = "http://download.flexget.com/archive/${name}.tar.gz";
      md5 = "cffc4e51b5c5efddb339d265524e46b8";
    };

    buildInputs = [ nose ];
    propagatedBuildInputs = [ beautifulsoup4 pyrss2gen feedparser pynzb html5lib dateutil beautifulsoup flask jinja2 requests sqlalchemy pyyaml cherrypy progressbar deluge ];

    meta = {
      homepage = http://flexget.com/;
      description = "Multipurpose automation tool for content like torrents, ...";
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
    name = "foolscap-0.6.1";

    src = fetchurl {
      url = "http://foolscap.lothar.com/releases/${name}.tar.gz";
      sha256 = "8b3e4fc678c5c41483b3130666583a1c3909713adcd325204daded7b67171ed5";
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

      maintainers = [ stdenv.lib.maintainers.ludo ];
    };
  });

  fuse = buildPythonPackage (rec {
    baseName = "fuse";
    version = "0.2.1";
    name = "${baseName}-${version}";

    src = fetchurl {
      url = "http://downloads.sourceforge.net/sourceforge/fuse/fuse-python-${version}.tar.gz";
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
    name = "genshi-0.6";

    src = fetchurl {
      url = http://ftp.edgewall.com/pub/genshi/Genshi-0.6.tar.gz;
      sha256 = "0jrajyppdzb3swcxv3w1mpp88vcy7400gy1v2h2gm3pq0dmggaij";
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

  genzshcomp = buildPythonPackage {
    name = "genzshcomp-0.2.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/g/genzshcomp/genzshcomp-0.2.2.tar.gz";
      sha256 = "0bhiyx41kilvy04cgjbvjy2r4b6l7zz31fbrg3l6lvnqm26nihb0";
    };

    buildInputs = [ pkgs.setuptools ] ++ (optional isPy26 argparse);

    meta = {
      description = "automatically generated zsh completion function for Python's option parser modules";
      license = "BSD";
      maintainers = [ stdenv.lib.maintainers.simons ];
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
    rev = "1435";
    name = "gyp-r${rev}";

    src = fetchsvn {
      url = "http://gyp.googlecode.com/svn/trunk";
      inherit rev;
      sha256 = "1wmd1svx5344alb8ff9vzdam1ccqdl0h7shp1xnsk843hqwc0fz0";
    };

    # error: invalid command 'test'
    doCheck = false;

    postUnpack = "find . -print0 | xargs -0 touch";

    meta = {
      homepage = http://code.google.com/p/gyp;
      description = "Generate Your Projects";
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
      homepage = "http://code.google.com/p/httplib2";
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

  ipdb = buildPythonPackage {
    name = "ipdb-0.7";
    src = fetchurl {
      url = "http://pypi.python.org/packages/source/i/ipdb/ipdb-0.7.tar.gz";
      md5 = "d879f9b2b0f26e0e999809585dcaec61";
    };
    propagatedBuildInputs = [ ipython ];
  };

  ipdbplugin = buildPythonPackage {
    name = "ipdbplugin-1.2";
    src = fetchurl {
      url = "https://pypi.python.org/packages/source/i/ipdbplugin/ipdbplugin-1.2.tar.gz";
      md5 = "39169b00a2186b99469249c5b0613753";
    };
    propagatedBuildInputs = [ nose ipython ];
  };


  jedi = buildPythonPackage (rec {
    name = "jedi-0.5b5";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/j/jedi/${name}.tar.gz";
      sha256 = "10xqdhda9kdbc22h4dphxqjncpdb80s1crxsirr5h016rw9czsa4";
    };

    meta = {
      homepage = "https://github.com/davidhalter/jedi";
      description = "An autocompletion tool for Python that can be used for text editors.";
      license = pkgs.lib.licenses.lgpl3Plus;
      maintainers = [ stdenv.lib.maintainers.garbas ];
    };
  });

  jinja2 = buildPythonPackage {
    name = "jinja2-2.6";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/J/Jinja2/Jinja2-2.6.tar.gz";
      md5 = "1c49a8825c993bfdcf55bb36897d28a2";
    };

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


  magic = pkgs.stdenv.mkDerivation rec {
    name = "python-${pkgs.file.name}";

    src = pkgs.file.src;

    patches = [ ../tools/misc/file/python.patch ];
    buildInputs = [ python pkgs.file ];

    configurePhase = "cd python";

    buildPhase = "python setup.py build";

    installPhase = ''
      python setup.py install --prefix=$out
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

    buildPhase = "python setup.py build_ext --openssl=${pkgs.openssl}";

    doCheck = false; # another test that depends on the network.

    meta = {
      description = "A Python crypto and SSL toolkit";
      homepage = http://chandlerproject.org/Projects/MeTooCrypto;
    };
  };


  Mako = buildPythonPackage rec {
    name = "Mako-0.7.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/M/Mako/${name}.tar.gz";
      md5 = "daf7cc50f997533b573f9b40193139a2";
    };

    buildInputs = [ MarkupSafe nose ];
    propagatedBuildInputs = [ MarkupSafe ];

    meta = {
      description = "Super-fast templating language.";
      homepage = http://www.makotemplates.org;
      license = "MIT";
      maintainers = [ stdenv.lib.maintainers.iElectric ];
    };
  };


  MarkupSafe = buildPythonPackage rec {
    name = "MarkupSafe-0.15";

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
    version = "1.6.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/m/manuel/${name}.tar.gz";
      md5 = "53d6a6905301a20f6095e41d11968fff";
    };

    propagatedBuildInputs = [ six zope_testing ];

    meta = {
      description = "A documentation builder";
      homepage = http://pypi.python.org/pypi/manuel;
      license = "ZPL";
    };
  };

  markdown = buildPythonPackage rec {
    version = "2.0.3";
    name = "markdown-${version}";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/M/Markdown/Markdown-2.0.3.tar.gz";
      md5 = "751e8055be2433dfd1a82e0fb1b12f13";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://www.freewisdom.org/projects/python-markdown;
    };
  };


  matplotlib = buildPythonPackage ( rec {
    name = "matplotlib-1.1.0";
    src = fetchurl {
      url = "http://downloads.sourceforge.net/matplotlib/${name}.tar.gz";
      sha256 = "be37e1d86c65ecacae6683f8805e051e9904e5f2e02bf2b7a34262c46a6d06a7";
    };

    # error: invalid command 'test'
    doCheck = false;

    propagatedBuildInputs = [ dateutil numpy pkgs.freetype pkgs.libpng pkgs.pkgconfig pkgs.tcl pkgs.tk pkgs.xlibs.libX11 ];

    meta = {
      description = "python plotting library, making publication quality plots";
      homepage = "http://matplotlib.sourceforge.net/";
      platforms = stdenv.lib.platforms.linux;
      maintainers = [ stdenv.lib.maintainers.simons ];
    };
  });


  mccabe = buildPythonPackage (rec {
    name = "mccabe-0.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/m/mccabe/${name}.tar.gz";
      md5 = "c1012c7c24081471f45aab864d4e3805";
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


  mrbob = buildPythonPackage rec {
    name = "mrbob-${version}";
    version = "0.1a6";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/m/mr.bob/mr.bob-${version}.zip";
      md5 = "361c8ac7a31953ab94a95cf34d9a0b2b";
    };

    buildInputs = [ pkgs.unzip six ] ++ (optionals isPy26 [ importlib ordereddict ]);

    propagatedBuildInputs = [ argparse jinja2 ];

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
    name = "nose-1.2.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/n/nose/${name}.tar.gz";
      md5 = "735e3f1ce8b07e70ee1b742a8a53585a";
    };

    meta = {
      description = "A unittest-based testing framework for python that makes writing and running tests easier";
    };

    buildInputs = [ coverage ];

    doCheck = ! stdenv.isDarwin;
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

  notify = pkgs.stdenv.mkDerivation (rec {
    name = "python-notify-0.1.1";

    src = fetchurl {
      url = http://www.galago-project.org/files/releases/source/notify-python/notify-python-0.1.1.tar.bz2;
      sha256 = "1kh4spwgqxm534qlzzf2ijchckvs0pwjxl1irhicjmlg7mybnfvx";
    };

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
    name = "numpy-1.6.1";

    src = fetchurl {
      url = "mirror://sourceforge/numpy/${name}.tar.gz";
      sha256 = "1pawfmf7j7pd3mjzhmmw9hkglc2qdirrkvv29m5nsmpf2b3ip2vq";
    };

    # TODO: add ATLAS=${pkgs.atlas}
    installCommand = ''
      export BLAS=${pkgs.blas} LAPACK=${pkgs.liblapack}
      python setup.py build --fcompiler="gnu95"
      python setup.py install --prefix=$out
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
    name = "ply-3.2";

    src = fetchurl {
      url = "http://www.dabeaz.com/ply/${name}.tar.gz";
      sha256 = "10z4xq8lc8c21v4g7z3zpnvpqbc0vidigrck1kqhwgkqi4gh0kfj";
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

      maintainers = [ stdenv.lib.maintainers.ludo ];
    };
  });


  paramiko = buildPythonPackage rec {
    name = "paramiko-1.7.7.1";

    src = fetchurl {
      url = "http://www.lag.net/paramiko/download/${name}.tar.gz";
      sha256 = "1bjy4jn51c50mpq51jbwk0glzd8bxz83gxdfkr9p95dmrd17c7hh";
    };

    buildInputs = [ pycrypto ];

    meta = {
      homepage = "http://www.lag.net/paramiko/";
      description = "SSH2 protocol for python";
      license = "LGPL";

      longDescription = ''
        paramiko is a module for python 2.2 (or higher) that implements the
        SSH2 protocol for secure (encrypted and authenticated) connections to
        remote machines. unlike SSL (aka TLS), SSH2 protocol does not require
        heirarchical certificates signed by a powerful central authority. you
        may know SSH2 as the protocol that replaced telnet and rsh for secure
        access to remote shells, but the protocol also includes the ability
        to open arbitrary channels to remote services across the encrypted
        tunnel -- this is how sftp works, for example.  it is written
        entirely in python (no C or platform-dependent code) and is released
        under the GNU LGPL (lesser GPL).  '';
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
    version = "1.4.5";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/pep8/${name}.tar.gz";
      md5 = "055dbd22ac5669232fdba752612e9686";
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
      url = "http://pexpect.sourceforge.net/pexpect-2.3.tar.gz";
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

      maintainers = [ stdenv.lib.maintainers.simons ];
    };
  };


  pg8000 = buildPythonPackage rec {
    name = "pg8000-1.08";

    src = fetchurl {
      url = "http://pybrary.net/pg8000/dist/${name}.tar.gz";
      md5 = "2e8317a22d0e09a6f12e98ddf3bb75fd";
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

  pip = buildPythonPackage {
    name = "pip-1.2.1";
    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/pip/pip-1.2.1.tar.gz";
      md5 = "db8a6d8a4564d3dc7f337ebed67b1a85";
    };
    buildInputs = [ mock scripttest virtualenv nose ];
    # ValueError: Working directory tests not found, or not a directory
    doCheck = false;
  };


  pillow = buildPythonPackage rec {
    name = "Pillow-1.7.8";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Pillow/${name}.zip";
      md5 = "41d8688d4db72673069a6dc63b5289d6";
    };

    buildInputs = [ pkgs.freetype pkgs.libjpeg pkgs.unzip pkgs.zlib ];

    configurePhase = ''
      sed -i "setup.py" \
          -e 's|^FREETYPE_ROOT =.*$|FREETYPE_ROOT = _lib_include("${pkgs.freetype}")|g ;
              s|^JPEG_ROOT =.*$|JPEG_ROOT = _lib_include("${pkgs.libjpeg}")|g ;
              s|^ZLIB_ROOT =.*$|ZLIB_ROOT = _lib_include("${pkgs.zlib}")|g ;'
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
    name = "psutil-0.6.1";

    src = fetchurl {
      url = "http://psutil.googlecode.com/files/${name}.tar.gz";
      sha256 = "0vqarv63jqzghr4fi1fqdbvg847fq2gqdj8dzc3x59f9b36a8rfn";
    };

    meta = {
      description = "Process and system utilization information interface for python";
      homepage = http://code.google.com/p/psutil/;
    };
  };


  psycopg2 = buildPythonPackage rec {
    name = "psycopg2-2.0.13";

    # error: invalid command 'test'
    doCheck = false;

    src = fetchurl {
      url = "http://initd.org/pub/software/psycopg/PSYCOPG-2-0/${name}.tar.gz";
      sha256 = "0arkaa1nbbd3pyn4l1bc75wi7nff3vxxh4s8sj5al5hv20p64pm1";
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


  pyasn1 = buildPythonPackage ({
    name = "pyasn1-0.0.11a";

    src = fetchurl {
      url = "mirror://sourceforge/pyasn1/pyasn1-devel/0.0.11a/pyasn1-0.0.11a.tar.gz";
      sha256 = "0b7q67ygdk48zn07pyhyg7r0b74gds50652ndpzfw4vs8l3vjg0b";
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

    installPhase = ''
      python setup.py install --prefix=$out
    '';

    meta = {
      description = "Python bindings for PortAudio";
      homepage = "http://people.csail.mit.edu/hubert/pyaudio/";
      license = stdenv.lib.licenses.mit;
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

      maintainers = [ stdenv.lib.maintainers.ludo ];
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
    name = "pyflakes-0.6.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyflakes/${name}.tar.gz";
      md5 = "00debd2280b962e915dfee552a675915";
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
      python setup.py install --prefix=$out
    '';

    meta = {
      homepage = https://github.com/seb-m/pyinotify/wiki;
      description = "Monitor filesystems events on Linux platforms with inotify";
      license = pkgs.lib.licenses.mit;
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
    name = "python-ldap-2.4.10";
    namePrefix = "";

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


  pylint = buildPythonPackage rec {
    name = "pylint-0.26.0";
    namePrefix = "";

    src = fetchurl {
      url = "http://download.logilab.org/pub/pylint/${name}.tar.gz";
      sha256 = "1mg1ywpj0klklv63s2hwn5xwxi3wfwgnyz9d4pz32hzb53azq835";
    };

    propagatedBuildInputs = [ logilab_astng ];

    meta = {
      homepage = http://www.logilab.org/project/pylint;
      description = "A bug and style checker for Python";
    };
  };


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

      maintainers = [ stdenv.lib.maintainers.ludo ];
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


  RBTools = buildPythonPackage rec {
    name = "rbtools-0.4.1";
    namePrefix = "";

    src = fetchurl {
      url = "http://downloads.reviewboard.org/releases/RBTools/0.4/RBTools-0.4.1.tar.gz";
      sha256 = "1v0r7rfzrasj56s53mib51wl056g7ykh2y1c6dwv12r6hzqsycgv";
    };

    propagatedBuildInputs = [ setuptools ];
  };


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
    name = "requests-1.1.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/r/requests/${name}.tar.gz";
      md5 = "a0158815af244c32041a3147ee09abf3";
    };

    meta = {
      description = "Requests is an Apache2 Licensed HTTP library, written in Python, for human beings..";
      homepage = http://docs.python-requests.org/en/latest/;
    };
  };

  requests014 = buildPythonPackage rec {
    name = "requests-0.14.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/r/requests/${name}.tar.gz";
      md5 = "3de30600072cbc7214ae342d1d08aa46";
    };

    meta = {
      description = "Requests is an Apache2 Licensed HTTP library, written in Python, for human beings..";
      homepage = http://docs.python-requests.org/en/latest/;
    };
  };


  reviewboard = buildPythonPackage rec {
    name = "ReviewBoard-1.6.13";

    src = fetchurl {
      url = "http://downloads.reviewboard.org/releases/ReviewBoard/1.6/${name}.tar.gz";
      sha256 = "06q9vgvmmwiyqj6spw6sbhrcxwds02pvqir50psbpps74nxn2mph";
    };

    propagatedBuildInputs =
      [ recaptcha_client pytz memcached dateutil paramiko flup pygments
        djblets django_1_3 django_evolution pycrypto python.modules.sqlite3
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


  scipy = buildPythonPackage rec {
    name = "scipy-0.9.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/s/scipy/${name}.tar.gz";
      md5 = "ebfef6e8e82d15c875a4ee6a46d4e1cd";
    };

    buildInputs = [pkgs.gfortran];
    propagatedBuildInputs = [ numpy ];

    # error: invalid command 'test'
    doCheck = false;

    # TODO: add ATLAS=${pkgs.atlas}
    installCommand = ''
      export BLAS=${pkgs.blas} LAPACK=${pkgs.liblapack}
      python setup.py build --fcompiler="gnu95"
      python setup.py install --prefix=$out
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
      name = "selenium-2.25.0";
      src = pkgs.fetchurl {
        url = http://pypi.python.org/packages/source/s/selenium/selenium-2.25.0.tar.gz;
        sha256 = "0iinpry1vr4dydh44sc0ny22sa9fqhy2302hf56pf8fakvza9m0a";
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
        cp ${x_ignore_nofocus}/* .
        sed -i 's|dlopen(library,|dlopen("libX11.so.6",|' x_ignore_nofocus.c
        gcc -c -fPIC x_ignore_nofocus.c -o x_ignore_nofocus.o
        gcc -shared -Wl,-soname,x_ignore_nofocus.so -o x_ignore_nofocus.so  x_ignore_nofocus.o
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
    name = "simplejson-2.1.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/s/simplejson/${name}.tar.gz";
      md5 = "58d9b1d8fa17ea4ce205cea088607e02";
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


  six = buildPythonPackage rec {
    name = "six-1.1.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/s/six/${name}.tar.gz";
      md5 = "9e8099b57cd27493a6988e9c9b313e23";
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


  sqlalchemy = buildPythonPackage {
    name = "sqlalchemy-0.7.9";

    src = fetchurl {
      url = mirror://sourceforge/sqlalchemy/0.7.9/SQLAlchemy-0.7.9.tar.gz;
      md5 = "c4852d586d95a59fbc9358f4467875d5";
    };

    buildInputs = [ nose ];

    propagatedBuildInputs = [ python.modules.sqlite3 ];

    meta = {
      homepage = http://www.sqlalchemy.org/;
      description = "A Python SQL toolkit and Object Relational Mapper";
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
    version = "0.0.9";

    src = fetchurl {
      url = "https://launchpad.net/subunit/trunk/0.0.9/+download/python-${name}.tar.gz";
      sha256 = "0g3bk8lfd52zjzg43h47h2kckchm3xyv1gcr85nca2i50rcrpj56";
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
    version = "0.9.24";

    src = fetchurl {
      url = "https://launchpad.net/testtools/0.9/0.9.24/+download/${name}.tar.gz";
      sha256 = "0mgkvd7c1aw34nlnz2nmll5k01aqhixxiikbs2nfyk3xfa4221x7";
    };

    meta = {
      description = "A set of extensions to the Python standard library's unit testing framework";
      homepage = http://pypi.python.org/pypi/testtools;
      license = pkgs.lib.licenses.mit;
    };
  };


  trac = buildPythonPackage {
    name = "trac-0.12.2";

    src = fetchurl {
      url = http://ftp.edgewall.com/pub/trac/Trac-0.12.2.tar.gz;
      sha256 = "1ihf5031pc1wpwbxpfzzz2bcpwww795n5y22baglyim1lalivd65";
    };

    # couple of failing tests
    doCheck = false;

    PYTHON_EGG_CACHE = "`pwd`/.egg-cache";

    propagatedBuildInputs = [ genshi pkgs.setuptools python.modules.sqlite3 ];

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
    name = "turses-0.2.13";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/t/turses/${name}.tar.gz";
      sha256 = "0sygm40z04zifcfqwby8wwwnj3i1bpl41r7xgnjcipxwirjmnp2k";
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
    name = "tweepy-2.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/t/tweepy/${name}.tar.gz";
      sha256 = "1b95xcw11b5871gd4br78hxbvcq8y9f0i0sqga85dgg9hnmvdcx0";
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
    name = "twisted-12.3.0";

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

      maintainers = [ stdenv.lib.maintainers.ludo ];
    };
  };


  unittest2 = buildPythonPackage rec {
    name = "unittest2-0.5.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/u/unittest2/${name}.tar.gz";
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
    name = "virtualenv-1.8.4";
    src = fetchurl {
      url = "http://pypi.python.org/packages/source/v/virtualenv/${name}.tar.gz";
      md5 = "1c7e56a7f895b2e71558f96e365ee7a7";
    };

    patches = [ ../development/python-modules/virtualenv-change-prefix.patch ];

    propagatedBuildInputs = [ python.modules.readline python.modules.sqlite3 ];

    buildInputs = [ mock nose ];

    # XXX: Ran 0 tests in 0.003s

    meta = with stdenv.lib; {
      description = "a tool to create isolated Python environments";
      homepage = http://www.virtualenv.org;
      license = licenses.mit;
      maintainers = [ maintainers.goibhniu ];
    };
  };

  vnc2flv = buildPythonPackage rec {
    name = "vnc2flv-20100207";
    namePrefix = "";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/v/vnc2flv/${name}.tar.gz";
      md5 = "8492e46496e187b49fe5569b5639804e";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      description = "Tool to record VNC sessions to Flash Video";
      homepage = http://www.unixuser.org/~euske/python/vnc2flv/;
    };
  };

  waitress = buildPythonPackage rec {
    name = "waitress-0.8.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/w/waitress/${name}.tar.gz";
      md5 = "aadfc692b780fc42eb05ac819102d336";
    };

    meta = {
       maintainers = [
         stdenv.lib.maintainers.garbas
         stdenv.lib.maintainers.iElectric
       ];
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

    propagatedBuildInputs = [ nose ];

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

    buildInputs = [ pkgs.unzip ];

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

    propagatedBuildInputs = [ zope_event zope_interface zope_testing ];

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
    name = "zope.sqlalchemy-0.7.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.sqlalchemy/${name}.zip";
      md5 = "b654e5d144ed141e13b42591a21a4868";
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
    version = "4.1.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.testing/${name}.tar.gz";
      md5 = "2e3829841090d6adff718b8b73c87b6b";
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
    version = "4.0.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.testrunner/${name}.zip";
      md5 = "cd648fc865a79aa0950e73342836dd4c";
    };

    buildInputs = [ pkgs.unzip ];

    propagatedBuildInputs = [ subunit zope_interface zope_exceptions zope_testing ];

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
    version = "1.20121216";

    src = fetchurl rec {
      url = "http://code.liw.fi/debian/pool/main/p/python-cliapp/python-cliapp_${version}.orig.tar.gz";
      sha256 = "1bzvc4aj3w8g85qycwz1jxa73jj8rl6zrgd4hi78kr4dgslcfns5";
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
    name = "tissue-0.7";
    src = fetchurl {
      url = "http://pypi.python.org/packages/source/t/tissue/${name}.tar.gz";
      md5 = "c9f3772407eb7499a949daaa9b859fdf";
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
    name = "translationstring-0.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/t/translationstring/${name}.tar.gz";
      md5 = "392287923c475b660b7549b2c2f03dbc";
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
    name = "ttystatus-0.21";

    src = fetchurl rec {
      url = "http://code.liw.fi/debian/pool/main/p/python-ttystatus/python-ttystatus_0.21.orig.tar.gz";
      sha256 = "4a1f3a41c9bd3b5d2bd8e6f093890857301e590aa1d428fc9a6dca591227244c";
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
    version = "1.20121216";

    src = fetchurl rec {
      url = "http://code.liw.fi/debian/pool/main/p/python-larch/python-larch_${version}.orig.tar.gz";
      sha256 = "0w4hirs8wkp1hji6nxfmq4rahkd5rgw4cavvdhpdfr4mddycbis3";
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

    buildInputs = [ routes MarkupSafe webob nose ];

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

    buildInputs = [ txamqp zope_interface twisted ];
    propagatedBuildInputs = [ whisper ];

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
    version = "0.9.10";

    src = fetchurl rec {
      url = "https://launchpad.net/graphite/0.9/${version}/+download/${name}.tar.gz";
      sha256 = "1gj8i6j2i172cldqw98395235bn78ciagw6v17fgv01rmind3lag";
    };

    buildInputs = [ django pkgs.pycairo ldap memcached python.modules.sqlite3 ];

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
  
    version = "1.10";
  
    src = fetchgit {
      url = "https://github.com/mopidy/pyspotify.git";
      rev = "refs/tags/v${version}";
      sha256 = "1rvgrviwn6f037m8vq395chz6a1119dbsdhfwdbv5ambi0bak6ll";
    };
  
    buildInputs = [ pkgs.libspotify ];
  
    # python zip complains about old timestamps
    preConfigure = ''
      find -print0 | xargs -0 touch
    '';
  
    # There are no tests
    doCheck = false;
  
    meta = {
      homepage = http://pyspotify.mopidy.com;
      description = "A Python interface to Spotify’s online music streaming service";
      maintainers = [ stdenv.lib.maintainers.rickynils ];
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

}; in pythonPackages
