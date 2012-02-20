{ pkgs, python }:

let pythonPackages = python.modules // rec {

  inherit python;

  inherit (pkgs) fetchurl fetchsvn stdenv;


  buildPythonPackage = import ../development/python-modules/generic {
    inherit (pkgs) lib;
    inherit python wrapPython setuptools;
  };


  setuptools = import ../development/python-modules/setuptools {
    inherit (pkgs) stdenv fetchurl;
    inherit python wrapPython;
  };


  ipython = import ../shells/ipython {
    inherit (pkgs) stdenv fetchurl;
    inherit buildPythonPackage pythonPackages;
  };


  wrapPython = pkgs.makeSetupHook
    { deps = pkgs.makeWrapper;
      substitutions.libPrefix = python.libPrefix;
    }
    ../development/python-modules/generic/wrap.sh;


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

    doCheck = false;

    meta = {
      description = "A Python wrapper for the SQLite embedded relational database engine";
      homepage = http://code.google.com/p/apsw/;
    };
  };


  argparse = buildPythonPackage (rec {
    name = "argparse-1.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/a/argparse/${name}.zip";
      sha256 = "ee6da1aaad8b08a74a33eb82264b1a2bf12a7d5aefc7e9d7d40a8f8fa9912e62";
    };

    buildInputs = [ pkgs.unzip ];

    # How do we run the tests?
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

  astng = buildPythonPackage rec {
    name = "logilab-astng-0.21.1";

    src = fetchurl {
      url = "http://ftp.logilab.org/pub/astng/${name}.tar.gz";
      sha256 = "0rqp2vwrnv6gkzdd96j078h1sz26plh49cmnyswy2wb6l4wans67";
    };
    propagatedBuildInputs = [logilabCommon];
  };

  beautifulsoap = buildPythonPackage (rec {
    name = "beautifulsoap-3.0.8";

    src = fetchurl {
      url = "http://www.crummy.com/software/BeautifulSoup/download/3.x/BeautifulSoup-3.0.8.tar.gz";
      sha256 = "1gasiy5lwbhsxw27g36d88n36xbj52434klisvqhljgckd4xqcy7";
    };

    # No tests implemented
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


  boto = buildPythonPackage (rec {
    name = "boto-2.0b4";

    src = fetchurl {
      url = "http://boto.googlecode.com/files/${name}.tar.gz";
      sha1 = "3e1deab58b8432d01baef1d37f17cbf6fa999f8d";
    };

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

  cssutils = buildPythonPackage (rec {
    name = "cssutils-0.9.7a6";

    src = fetchurl {
      url = http://cssutils.googlecode.com/files/cssutils-0.9.7a6.zip;
      sha256 = "1i5n97l20kn2w9v6x8ybcdnl323vy8lcc5qlxz5l89di36a2skgw";
    };

    buildInputs = [ pkgs.unzip ];

    # The tests fail - I don't know why
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

    # Gives "ValueError: Empty module name" with no clue as to why.
    doCheck = false;

    meta = {
      description = "Darcsver, generate a version number from Darcs history";

      homepage = http://pypi.python.org/pypi/darcsver;

      license = "BSD-style";
    };
  });

  dateutil = buildPythonPackage (rec {
    name = "dateutil-1.4.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/python-dateutil/python-${name}.tar.gz";
      sha256 = "0mrkh932k8s74h4rpgksvpmwbrrkq8zn78gbgwc22i2vlp31bdkl";
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


  docutils = buildPythonPackage rec {
    name = "docutils-0.8.1";

    src = fetchurl {
      url = "mirror://sourceforge/docutils/${name}.tar.gz";
      sha256 = "0wfz4nxl95jcr2f2mc5gijgighavcghg33plzbz5jyi531jpffss";
    };

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

    # For some reason "python setup.py test" doesn't work with Python 2.6.
    doCheck = false;

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

  genshi = buildPythonPackage {
    name = "genshi-0.6";

    src = fetchurl {
      url = http://ftp.edgewall.com/pub/genshi/Genshi-0.6.tar.gz;
      sha256 = "0jrajyppdzb3swcxv3w1mpp88vcy7400gy1v2h2gm3pq0dmggaij";
    };

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

    buildInputs = [ pkgs.setuptools ];

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

    propagatedBuildInputs = [ gflags sqlalchemy webob routes eventlet python.modules.ssl ];

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


  httplib2 = buildPythonPackage rec {
    name = "httplib2-0.6.0";

    src = fetchurl {
      url = "http://httplib2.googlecode.com/files/${name}.tar.gz";
      sha256 = "134pldyxayc0x4akzzvkciz2kj1w2dsim1xvd9b1qrpmba70dpjq";
    };

    doCheck = false; # doesn't have a test

    meta = {
      homepage = http://code.google.com/p/httplib2/;
      description = "A comprehensive HTTP client library";
    };
  };


  ipy = buildPythonPackage rec {
    version = "0.74";
    name = "ipy-${version}";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/I/IPy/IPy-${version}.tar.gz";
      md5 = "f4f7ddc7c5e55a47222a5cc6c0a87b6d";
    };

    doCheck = false;

    meta = {
      description = "Class and tools for handling of IPv4 and IPv6 addresses and networks";
      homepage = http://pypi.python.org/pypi/IPy;
    };
  };


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


  libcloud = buildPythonPackage (rec {
    name = "libcloud-0.3.1";

    src = fetchurl {
      url = mirror://apache/incubator/libcloud/apache-libcloud-incubating-0.3.1.tar.bz2;
      sha256 = "11qilrs4sd4c1mkd64ikrjsc2vwrshhc54n5mh4xrark9c7ayp0y";
    };

    buildInputs = [ zopeInterface ];

    preConfigure = "cp test/secrets.py-dist test/secrets.py";

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

    doCheck = false; # no tests

    meta = {
      homepage = http://code.google.com/p/pylockfile/;
      description = "Platform-independent advisory file locking capability for Python applications";
    };
  };

  logilabCommon = buildPythonPackage rec {
    name = "logilab-common-0.56.0";

    src = fetchurl {
      url = "http://ftp.logilab.org/pub/common/${name}.tar.gz";
      sha256 = "14p557nqypbd10d8k7qs6jlm58pksiwh86wvvl0axyki00hj6971";
    };
    propagatedBuildInputs = [unittest2];
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
    name = "python-${pkgs.file.name}";

    src = pkgs.file.src;

    buildInputs = [ python pkgs.file ];

    configurePhase = "cd python";

    buildPhase = "python setup.py build";

    installPhase = "python setup.py install --prefix=$out";

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

    doCheck = false;

    src = fetchurl {
      url = mirror://sourceforge/mysql-python/MySQL-python-1.2.3.tar.gz;
      sha256 = "0vkyg9dmj29hzk7fy77f42p7bfj28skyzsjsjry4wqr3z6xnzrkx";
    };

    propagatedBuildInputs = [ pkgs.mysql pkgs.zlib nose ];

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

    doCheck = false; # there is no test command

    meta = {
      homepage = https://github.com/drkjam/netaddr/;
      description = "A network address manipulation library for Python";
    };
  };


  nevow = buildPythonPackage (rec {
    name = "nevow-${version}";
    version = "0.10.0";

    src = fetchurl {
      url = "http://divmod.org/trac/attachment/wiki/SoftwareReleases/Nevow-${version}.tar.gz?format=raw";
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
    name = "nose-1.0.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/n/nose/${name}.tar.gz";
      md5 = "47a4784c817afa6ef11a505b574584ed";
    };

    # Fails with ‘This platform lacks a functioning sem_open
    # implementation, therefore, the required synchronization
    # primitives needed will not function, see issue 3770.’ However,
    # our Python does seem to be built with the necessary
    # functionality.
    doCheck = false;

    meta = {
      description = "A unittest-based testing framework for python that makes writing and running tests easier";
    };
  };

  notify = pkgs.stdenv.mkDerivation (rec {
    name = "python-notify-0.1.1";

    src = fetchurl {
      url = http://www.galago-project.org/files/releases/source/notify-python/notify-python-0.1.1.tar.bz2;
      sha256 = "1kh4spwgqxm534qlzzf2ijchckvs0pwjxl1irhicjmlg7mybnfvx";
    };

    buildInputs = [ python pkgs.pkgconfig pkgs.libnotify pkgs.pygobject pkgs.pygtk pkgs.gtkLibs.glib pkgs.gtkLibs.gtk pkgs.dbus_glib ];

    postInstall = "cd $out/lib/python*/site-packages && ln -s gtk-*/pynotify .";

    meta = {
      description = "Python bindings for libnotify";
      homepage = http://www.galago-project.org/;
    };
  });

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
    doCheck = false;

    buildInputs = [ pkgs.gfortran ];
    propagatedBuildInputs = [ pkgs.liblapack pkgs.blas ];

    meta = {
      description = "Scientific tools for Python";
      homepage = "http://numpy.scipy.org/";
    };
  });

  optfunc = buildPythonPackage ( rec {
    name = "optfunc-git";

    src = pkgs.fetchgit {
      url = "http://github.com/simonw/optfunc.git";
      rev = "e3fa034a545ed94ac5a039cf5b170c7d0ee21b7b";
    };

    installCommand = ''
      dest=$(toPythonPath $out)/optfunc
      ensureDir $dest
      cp * $dest/
    '';

    doCheck = false;

    meta = {
      description = "A new experimental interface to optparse which works by introspecting a function definition";
      homepage = "http://simonwillison.net/2009/May/28/optfunc/";
    };
  });

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

  paramiko = buildPythonPackage {
    name = "paramiko-1.7.6";

    src = fetchurl {
      url = "http://www.lag.net/paramiko/download/paramiko-1.7.6.tar.gz";
      sha256 = "00jhzl3s9xdkbj32h1kq1swk8wpx9zky7qfda40n8mb204xjcn9h";
    };

    buildInputs = [ pkgs.pycrypto ];

    doCheck = false;

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


  pexpect = buildPythonPackage {
    name = "pexpect-2.3";

    src = fetchurl {
      url = "http://pexpect.sourceforge.net/pexpect-2.3.tar.gz";
      sha256 = "0x8bfjjqygriry1iyygm5048ykl5qpbpzqfp6i8dhkslm3ryf5fk";
    };

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


  pycurl =
    let libcurl = pkgs.stdenv.lib.overrideDerivation pkgs.curl
      (oldAttrs: {
        configureFlags =
          (if oldAttrs ? configureFlags then oldAttrs.configureFlags else "" )
          + " --enable-static";
      });
    in
  buildPythonPackage (rec {
    name = "pycurl-7.19.0";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/pycryptopp/${name}.tar.gz";
      sha256 = "0hh6icdbp7svcq0p57zf520ifzhn7jw64x07k99j7h57qpy2sy7b";
    };

    buildInputs = [ libcurl ];

    doCheck = false;

    postInstall = ''
      find $out -name easy-install.pth | xargs rm -v
      find $out -name 'site.py*' | xargs rm -v
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


  pygments = buildPythonPackage rec {
    name = "Pygments-1.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/P/Pygments/${name}.tar.gz";
      md5 = "d77ac8c93a7fb27545f2522abe9cc462";
    };
    meta = {
      homepage = http://pygments.org/;
      description = "Pygments is a generic syntax highlighter for general use in all kinds of software such as forum systems, wikis or other applications that need to prettify source code.";
    };
  };


  pyparsing = buildPythonPackage rec {
    name = "pyparsing-1.5.6";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyparsing/${name}.tar.gz";
      md5 = "1e41cb219dae9fc353bd4cd47636b283";
    };
    doCheck = false;
    meta = {
      homepage = http://pyparsing.wikispaces.com/;
      description = "The pyparsing module is an alternative approach to creating and executing simple grammars, vs. the traditional lex/yacc approach, or the use of regular expressions.";
    };
  };

  ldap = buildPythonPackage rec {
    name = "python-ldap-2.4.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/python-ldap/${name}.tar.gz";
      sha256 = "17aysa9b4zjw00ikjirf4m37xbp2ifj1g0zjs14xzqqib3nh1yw8";
    };

    NIX_CFLAGS_COMPILE = "-I${pkgs.cyrus_sasl}/include/sasl";
    propagatedBuildInputs = [pkgs.openldap pkgs.cyrus_sasl pkgs.openssl];
  };

  pylint = buildPythonPackage rec {
    name = "pylint-0.23.0";

    src = fetchurl {
      url = "http://ftp.logilab.org/pub/pylint/${name}.tar.gz";
      sha256 = "07091avcc2b374i5f3blszmawjcin8xssjfryz91qbxybb8r7c6d";
    };
    propagatedBuildInputs = [astng];
  };

  pymacs = pkgs.stdenv.mkDerivation rec {
    version = "v0.24-beta2";
    name = "Pymacs-${version}";

    src = fetchurl {
      url = "https://github.com/pinard/Pymacs/tarball/${version}";
      name = "${name}.tar.gz";
      sha256 = "0nzb3wrxwy0cmmj087pszkwgj2v22x0y5m4vxb6axz94zfl02r8j";
    };

    buildInputs = [ python ];

    configurePhase = ''
      python p4 -C p4config.py *.in Pymacs contrib tests
    '';

    installPhase = ''
      python setup.py install --prefix=$out
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

  pyreport = buildPythonPackage (rec {
    name = "pyreport-0.3.4c";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyreport/${name}.tar.gz";
      md5 = "3076164a7079891d149a23f9435581db";
    };

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

    # FIXME: How do we run the tests?
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
    name = "pysvn-1.7.2";

    src = fetchurl {
      url = "http://pysvn.barrys-emacs.org/source_kits/pysvn-1.7.2.tar.gz";
      sha256 = "2b2980d200515e754e00a12d99dbce25c1ea90fddf8cba2bfa354c9305c5e455";
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
        --apr-lib-dir=${pkgs.apr}/lib \
        --svn-root-dir=${pkgs.subversion}
    '' + (if !stdenv.isDarwin then "" else ''
      sed -i -e 's|libpython2.7.dylib|lib/libpython2.7.dylib|' Makefile
    '');

    # The regression test suite expects locale support, which our glibc
    # doesn't have by default.
    doCheck = false;
    checkPhase = "make -C ../Tests";

    installPhase = ''
      dest=$(toPythonPath $out)/pysvn
      ensureDir $dest
      cp pysvn/__init__.py $dest/
      cp pysvn/_pysvn*.so $dest/
      ensureDir $out/share/doc
      mv -v ../Docs $out/share/doc/pysvn-1.7.2
      rm -v $out/share/doc/pysvn-1.7.2/generate_cpp_docs_from_html_docs.py
    '';

    meta = {
      description = "Python bindings for Subversion";
      homepage = "http://pysvn.tigris.org/";
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

  reportlab =
   let freetype = pkgs.lib.overrideDerivation pkgs.freetype (args: { configureFlags = "--enable-static --enable-shared"; });
   in buildPythonPackage rec {
    name = "reportlab-2.5";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/r/reportlab/${name}.tar.gz";
      md5 = "cdf8b87a6cf1501de1b0a8d341a217d3";
    };

    buildInputs = [freetype];
    doCheck = false;

    meta = {
      description = "The ReportLab Toolkit. An Open Source Python library for generating PDFs and graphics.";
      homepage = http://www.reportlab.com/;
    };
  };

  rdflib = buildPythonPackage (rec {
    name = "rdflib-3.0.0";

    src = fetchurl {
      url = "http://www.rdflib.net/${name}.tar.gz";
      sha256 = "1c7ipk5vwqnln83rmai5jzyxkjdajdzbk5cgy1z83nyr5hbkgkqr";
    };

    doCheck = false;

    postInstall = ''
      find $out -name easy-install.pth | xargs rm -v
      find $out -name 'site.py*' | xargs rm -v
    '';

    meta = {
      description = "RDFLib is a Python library for working with RDF, a simple yet powerful language for representing information.";
      homepage = http://www.rdflib.net/;
    };
  });

  rope = pkgs.stdenv.mkDerivation rec {
    version = "0.9.3";
    name = "rope-${version}";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/r/rope/${name}.tar.gz";
      sha256 = "1092rlsfna7rm1jkdanilsmw7rr3hlkgyji02xfd02wfcm8xa2i7";
    };

    buildInputs = [ python ];

    installPhase = ''
      python setup.py install --prefix=$out
    '';

    meta = with stdenv.lib; {
      description = "python refactoring library";
      homepage = http://rope.sf.net;
      maintainers = [ maintainers.goibhniu ];
      license = licenses.gpl2;
    };
  };

  ropemacs = pkgs.stdenv.mkDerivation rec {
    version = "0.6";
    name = "ropemacs-${version}";

    src = fetchurl {
      url = "mirror://sourceforge/rope/${name}.tar.gz";
      sha256 = "1afqybmjn7fqkwx8y8kx1kfx181ix73cbq3a0d5n7ryjm7k1r0s4";
    };

    buildInputs = [ python ];

    installPhase = ''
      python setup.py install --prefix=$out
    '';

     meta = with stdenv.lib; {
       description = "a plugin for performing python refactorings in emacs";
       homepage = http://rope.sf.net/ropemacs.html;
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
    name = "Sphinx-1.0.7";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/S/Sphinx/${name}.tar.gz";
      md5 = "42c722d48e52d4888193965dd473adb5";
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

    doCheck = false;

    PYTHON_EGG_CACHE = "`pwd`/.egg-cache";

    propagatedBuildInputs = [ genshi pkgs.setuptools python.modules.sqlite3 ];

    meta = {
      description = "Enhanced wiki and issue tracking system for software development projects";

      license = "BSD";
    };
  };

  twisted = buildPythonPackage rec {
    name = "twisted-10.2.0";

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

  virtualenv = buildPythonPackage rec {
    name = "virtualenv-1.6.4";
    src = fetchurl {
      url = "http://pypi.python.org/packages/source/v/virtualenv/${name}.tar.gz";
      md5 = "1072b66d53c24e019a8f1304ac9d9fc5";
    };

    doCheck = false;

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


  wxPython = wxPython28;


  wxPython28 = import ../development/python-modules/wxPython/2.8.nix {
    inherit (pkgs) stdenv fetchurl pkgconfig;
    inherit pythonPackages;
    wxGTK = pkgs.wxGTK28;
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

    doCheck = false;

    meta = {
      description = "Zope.Interface";
      homepage = http://zope.org/Products/ZopeInterface;
      license = "ZPL";
    };
  };

  hgsvn = buildPythonPackage rec {
    name = "hgsvn-0.1.8";
    src = fetchurl rec {
      name = "hgsvn-0.1.8.tar.gz";
      url = "http://pypi.python.org/packages/source/h/hgsvn/${name}.tar.gz#md5=56209eae48b955754e09185712123428";
      sha256 = "18a7bj1i0m4shkxmdvw1ci5i0isq5vqf0bpwgrhnk305rijvbpch";
    };

    buildInputs = [ pkgs.setuptools ];
    doCheck = false;

    meta = {
      description = "HgSVN";
      homepage = http://pypi.python.org/pypi/hgsvn;
    };
  };

}; in pythonPackages
