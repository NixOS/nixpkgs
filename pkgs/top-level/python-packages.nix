{ pkgs, python }:

let pythonPackages = python.modules // rec {

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
    inherit (pkgs) stdenv fetchurl;
    inherit buildPythonPackage pythonPackages;
  };

  pil = import ../development/python-modules/pil {
    inherit (pkgs) fetchurl stdenv libjpeg zlib freetype;
    inherit python buildPythonPackage;
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
      platforms = python.meta.platforms;
    };
  };


  alot = buildPythonPackage rec {
    rev = "5b5dbecb5a03840b751219db90bcf4dcffda315e";
    name = "alot-0.3.3_${rev}";

    src = fetchurl {
      url = "https://github.com/pazz/alot/tarball/${rev}";
      name = "${name}.tar.bz";
      sha256 = "156q7x4wilhcgmaap7rjci3cgwm5ia85ddgx6xm6lfp5hkf5300v";
    };

    # error: invalid command 'test'
    doCheck = false;

    propagatedBuildInputs = [ notmuch urwid twisted magic configobj pygpgme ];

    postInstall = ''
      wrapProgram $out/bin/alot \
        --prefix LD_LIBRARY_PATH : ${pkgs.notmuch}/lib:${pkgs.file511}/lib:${pkgs.gpgme}/lib
    '';

    meta = {
      homepage = https://github.com/pazz/alot;
      description = "Terminal MUA using notmuch mail";
      maintainers = [ stdenv.lib.maintainers.garbas ];
      platforms = python.meta.platforms;
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


  logilab_astng = buildPythonPackage rec {
    name = "logilab-astng-0.24.1";

    src = fetchurl {
      url = "http://download.logilab.org/pub/astng/${name}.tar.gz";
      sha256 = "00qxaxsax80sknwv25xl1r49lc4gbhkxs1kjywji4ad8y1npax0s";
    };

    propagatedBuildInputs = [ logilab_common ];
  };

  beautifulsoup = buildPythonPackage (rec {
    name = "beautifulsoup-3.0.8";

    src = fetchurl {
      url = "http://www.crummy.com/software/BeautifulSoup/download/3.x/BeautifulSoup-3.0.8.tar.gz";
      sha256 = "1gasiy5lwbhsxw27g36d88n36xbj52434klisvqhljgckd4xqcy7";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://www.crummy.com/software/BeautifulSoup/;

      license = "bsd";

      description = "Undemanding HTML/XML parser";
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
      platforms = python.meta.platforms;
    };
  });

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
      platforms = python.meta.platforms;
    };
  });

  coverage = buildPythonPackage rec {
    name = "coverage-3.5.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/c/coverage/${name}.tar.gz";
      md5 = "5f1f523940c473faa8a9f6ca29f78efc";
    };

    meta = {
      description = "Code coverage measurement for python";
      homepage = http://nedbatchelder.com/code/coverage/;
      license = pkgs.lib.licenses.bsd3;
      maintainers = [ stdenv.lib.maintainers.shlevy ];
      platforms = python.meta.platforms;
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
    name = "dateutil-1.5";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/python-dateutil/python-${name}.tar.gz";
      sha256 = "02dhw57jf5kjcp7ng1if7vdrbnlpb9yjmz7wygwwvf3gni4766bg";
    };

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

  distribute = buildPythonPackage (rec {
    name = "distribute-0.6.26";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/d/distribute/distribute-0.6.26.tar.gz";
      md5 = "841f4262a70107f85260362f5def8206"; #"ecd75ea629fee6d59d26f88c39b2d291";

    };

    buildInputs = [ pkgs.unzip ];

    installCommand =
      ''
        # ehm, YES, the --verbose flags needs to be there, otherwise it tries to patch setuptools!
        easy_install --verbose --prefix=$out .
      '';

    # test for 27 fails
    doCheck = false;

    meta = {
      description = "Easily download, build, install, upgrade, and uninstall Python packages";
      homepage = http://packages.python.org/distribute;
      license = "PSF or ZPL";
      platforms = python.meta.platforms;
    };
  });


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


  flake8 = buildPythonPackage (rec {
    name = "flake8-1.6.2";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/f/flake8/${name}.tar.gz";
      md5 = "abfdbb25d37c28e9da05f1b5c3596d1a";
    };

    buildInputs = [ nose ];

    # 3 failing tests
    doCheck = false;

    meta = {
      description = "code checking using pep8 and pyflakes.";
      homepage = http://pypi.python.org/pypi/flake8;
      license = pkgs.lib.licenses.mit;
      maintainers = [ stdenv.lib.maintainers.garbas ];
      platforms = python.meta.platforms;
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
      platforms = python.meta.platforms;
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

    buildInputs = [ pkgs.setuptools ] ++
                  (if python.majorVersion == "2.6" then [ argparse ] else []);

    meta = {
      description = "automatically generated zsh completion function for Python's option parser modules";
      license = "BSD";
      maintainers = [ stdenv.lib.maintainers.simons ];
      platforms = python.meta.platforms;
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


  httplib2 = buildPythonPackage rec {
    name = "httplib2-0.7.7";

    src = fetchurl {
      url = "http://httplib2.googlecode.com/files/${name}.tar.gz";
      sha256 = "2e2ce18092c32d1ec54f8a447e14e33585e30f240b883bfeeca65f12b3bcfaf6";
    };

    meta = {
      homepage = "http://code.google.com/p/httplib2";
      description = "A comprehensive HTTP client library";
      license = pkgs.lib.licenses.mit;
      maintainers = [ stdenv.lib.maintainers.garbas ];
      platforms = python.meta.platforms;
    };
  };


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
      platforms = python.meta.platforms;
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

    buildInputs = [ zopeInterface mock ];

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
    name = "lxml-2.2.2";

    src = fetchurl {
      url = http://pypi.python.org/packages/source/l/lxml/lxml-2.2.2.tar.gz;
      sha256 = "0zjpsy67wcs69qhb06ficl3a5z229hmczpr8h84rkk05vaagj8qv";
    };

    buildInputs = [ pkgs.libxml2 pkgs.libxslt ];

    meta = {
      description = "Pythonic binding for the libxml2 and libxslt libraries";
      homepage = http://codespeak.net/lxml/index.html;
      license = "BSD";
    };
  });


  magic = pkgs.stdenv.mkDerivation rec {
    name = "python-${pkgs.file511.name}";

    src = pkgs.file511.src;

    patches = [ ../tools/misc/file/python.patch ];
    buildInputs = [ python pkgs.file511 ];

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
    name = "mock-0.7.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/m/mock/${name}.tar.gz";
      md5 = "be029f8c963c55250a452c400e10cf42";
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
  };

  notify = pkgs.stdenv.mkDerivation (rec {
    name = "python-notify-0.1.1";

    src = fetchurl {
      url = http://www.galago-project.org/files/releases/source/notify-python/notify-python-0.1.1.tar.bz2;
      sha256 = "1kh4spwgqxm534qlzzf2ijchckvs0pwjxl1irhicjmlg7mybnfvx";
    };

    buildInputs = [ python pkgs.pkgconfig pkgs.libnotify pkgs.pygobject pkgs.pygtk pkgs.glib pkgs.gtk pkgs.dbus_glib ];

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
      platforms = python.meta.platforms;
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
      platforms = python.meta.platforms;
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

      platforms = python.meta.platforms;
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
    version = "1.3.4";
    name = "paste-deploy-${version}";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/PasteDeploy/PasteDeploy-${version}.tar.gz";
      md5 = "eb4b3e2543d54401249c2cbd9f2d014f";
    };

    buildInputs = [ nose ];

    doCheck = false; # can't find "FakeEgg.app", apparently missing from the tarball

    meta = {
      description = "Load, configure, and compose WSGI applications and servers";
      homepage = http://pythonpaste.org/deploy/;
    };
  };


  pep8 = buildPythonPackage rec {
    name = "pep8-${version}";
    version = "1.3.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/pep8/${name}.tar.gz";
      md5 = "093a99ced0cc3b58c01549d7350f5a73";
    };

    meta = {
      homepage = http://pypi.python.org/pypi/pep8/;
      description = "Python style guide checker";
      license = pkgs.lib.licenses.mit;
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
      platforms = python.meta.platforms;
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
    name = "prettytable-0.5";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/PrettyTable/${name}.tar.gz";
      md5 = "13a6930d775395f393afd86948afa4fa";
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
      platforms = python.meta.platforms;
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


  ldap = buildPythonPackage rec {
    name = "python-ldap-2.4.3";
    namePrefix = "";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/python-ldap/${name}.tar.gz";
      sha256 = "17aysa9b4zjw00ikjirf4m37xbp2ifj1g0zjs14xzqqib3nh1yw8";
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
      url = "http://pypi.python.org/packages/source/p/pyquery/pyquery-1.2.4.tar.gz";
      md5 = "268f08258738d21bc1920d7522f2a63b";
    };
    buildInputs = [ cssselect lxml ];
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
      platforms = python.meta.platforms;
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

    propagatedBuildInputs = [ pkgs.xlibs.libX11 pkgs.pythonDBus pkgs.pygobject ];

    meta = {
      description = "High-level, platform independent Skype API wrapper for Python";

      # The advertisement says https://developer.skype.com/wiki/Skype4Py
      # but that url does not work. This following web page points to the
      # download link and has some information about the package.
      homepage = http://pypi.python.org/pypi/Skype4Py/1.0.32.0;

      license = "BSD";
    };
  });

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
    name = "sqlalchemy-0.6.6";

    src = fetchurl {
      url = mirror://sourceforge/sqlalchemy/0.6.6/SQLAlchemy-0.6.6.tar.gz;
      sha256 = "0inj9b66pi447cw500mqn7d09dij20ic3k5bnyhj6rpdl2l83a0l";
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
      platforms = python.meta.platforms;
    };
  });


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
    name = "TaskCoach-1.3.8";

    src = fetchurl {
      url = "mirror://sourceforge/taskcoach/${name}.tar.gz";
      sha256 = "0gc277cgnw6f167lrbxlf7rmgyjxwzgkmi77qz9xwvnwcj2l94xn";
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

  turses = buildPythonPackage (rec {
    name = "turses-0.2.9";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/t/turses/${name}.tar.gz";
      sha256 = "c0f32fa31e2c5fa42f5cc19f3dba4e73f0438bf36bf756ba137f2423c0ac4637";
    };

    propagatedBuildInputs = [ oauth2 urwid tweepy ] ++
                            (if python.majorVersion == "2.6" then [ argparse ]
                                                             else []);

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
    name = "tweepy-1.12";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/t/tweepy/${name}.tar.gz";
      sha256 = "66d728527ab3d5f5e4d6725654783f99169172678105f609d14353f6626c1315";
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

    propagatedBuildInputs = [ zopeInterface ];

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
      platforms = python.meta.platforms;
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
      platforms = python.meta.platforms;
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


  webob = buildPythonPackage rec {
    version = "1.0.6";
    name = "webob-${version}";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/W/WebOb/WebOb-${version}.zip";
      md5 = "8e46dd755f6998d471bfbcb4def897ff";
    };

    buildInputs = [ pkgs.unzip ];

    # The test requires "webtest", which is a cyclic dependency.  (WTF?)
    doCheck = false;

    meta = {
      description = "WSGI request and response object";
      homepage = http://pythonpaste.org/webob/;
    };
  };


  webtest = buildPythonPackage rec {
    version = "1.2.3";
    name = "webtest-${version}";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/W/WebTest/WebTest-${version}.tar.gz";
      md5 = "585f9331467e6d99acaba4051c1c5878";
    };

    propagatedBuildInputs = [ nose webob dtopt ];

    meta = {
      description = "Helper to test WSGI applications";
      homepage = http://pythonpaste.org/webtest/;
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

  zopeInterface = buildPythonPackage {
    name = "zope-interface-3.6.1";
    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zope.interface/zope.interface-3.6.1.tar.gz";
      sha256 = "294c3c0529e84169177bce78d616c768fa1c028a2fbc1854f615d32ed88dbc6c";
    };

    meta = {
      description = "Zope.Interface";
      homepage = http://zope.org/Products/ZopeInterface;
      license = "ZPL";
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
      platforms = python.meta.platforms;
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
      platforms = python.meta.platforms;
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
      platforms = python.meta.platforms;
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
      platforms = python.meta.platforms;
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
      platforms = python.meta.platforms;
    };
  };

  carbon = buildPythonPackage rec {
    name = "carbon-${version}";
    version = "0.9.10";

    src = fetchurl rec {
      url = "https://launchpad.net/graphite/0.9/${version}/+download/${name}.tar.gz";
      sha256 = "0wjhd87pvpcpvaj3wql2d92g8lpp33iwmxdkp7npic5mjl2y0dsg";
    };

    buildInputs = [ txamqp zopeInterface twisted ];
    propagatedBuildInputs = [ whisper ];

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = http://graphite.wikidot.com/;
      description = "Backend data caching and persistence daemon for Graphite";
      maintainers = [ stdenv.lib.maintainers.rickynils ];
      platforms = python.meta.platforms;
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
      platforms = python.meta.platforms;
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
      platforms = python.meta.platforms;
    };
  };

}; in pythonPackages
