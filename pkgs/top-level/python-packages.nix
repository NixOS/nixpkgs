{ pkgs, python, buildPythonPackage }:

rec {
  inherit (pkgs) fetchurl fetchsvn stdenv;

  argparse = buildPythonPackage (rec {
    name = "argparse-0.9.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/a/argparse/${name}.zip";
      sha256 = "00jw32wwccpf9smraywjk869b93w7f99rw8gi63yfhw6379fnq6m";
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

  boto = buildPythonPackage (rec {
    name = "boto-1.9b";

    src = fetchurl {
      url = "http://boto.googlecode.com/files/${name}.tar.gz";
      sha256 = "0kir3ddm79rxdf7wb5czmxpbnqzgj3j966q4mach29kkb98p48wz";
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
    name = "darcsver-1.3.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/d/darcsver/${name}.tar.gz";
      sha256 = "1a5cl2yhnd88a4vkc9r381cbjkcvga87dp9zx5av68857q1nvvvq";
    };

    # Note: We don't actually need to provide Darcs as a build input.
    # Darcsver will DTRT when Darcs isn't available.  See news.gmane.org
    # http://thread.gmane.org/gmane.comp.file-systems.tahoe.devel/3200 for a
    # discussion.

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

  foolscap = buildPythonPackage (rec {
    name = "foolscap-0.4.2";

    src = fetchurl {
      url = "http://foolscap.lothar.com/releases/${name}.tar.gz";
      sha256 = "14g89kjxxci3ssl9jgvpkyrcq62g361aw8pamlkclk8nnrh4f776";
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
    name = "genshi-0.5.1";

    src = fetchurl {
      url = http://ftp.edgewall.com/pub/genshi/Genshi-0.5.1.tar.bz2;
      sha256 = "1g2xw3zvgz59ilv7mrdlnvfl6ph8lwflwd4jr6zwrca2zhj7d8rs";
    };

    patches =
      [ # Fix `make check' (http://bugs.gentoo.org/276299)
        (fetchurl {
          url = "http://sources.gentoo.org/viewcvs.py/*checkout*/gentoo-x86/dev-python/genshi/files/genshi-0.5.1_test_fix.patch?rev=1.1";
          sha256 = "019skkas07lc2kjy5br5jhhf9dqfy4fs389m5f4ws3fc62fklwhk";
        })
      ];

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

  jinja2 = buildPythonPackage {
    name = "jinja2-2.2.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/J/Jinja2/Jinja2-2.2.1.tar.gz";
      md5 = "fea849d68891218eb0b21c170f1c32d5";
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

  matplotlib = buildPythonPackage ( rec {
    name = "matplotlib-0.99.1.2";

    src = fetchurl {
      url = "http://downloads.sourceforge.net/matplotlib/${name}.tar.gz";
      sha256 = "12lhwgkahck795946hb8wp605c912zq9ds8067ybbifqs56q24b9";
    };

    doCheck = false;

    buildInputs = [ dateutil numpy pkgs.freetype pkgs.libpng pkgs.pkgconfig pkgs.tcl pkgs.tk pkgs.xlibs.libX11 ];

    meta = {
      description = "python plotting library, making publication quality plots";
      homepage = "http://matplotlib.sourceforge.net/";
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
    name = "mock-0.1.0";

    src = fetchurl {
      url = "mirror://sourceforge/python-mock/pythonmock-0.1.0.zip";
      sha256 = "0r17f8sjq6pjlfh2sq2x80bd5r6y9sb3n5l05x5sf25iaba7sg9z";
    };

    buildInputs = [ pkgs.unzip ];

    phases = "unpackPhase";

    unpackPhase =
      '' mkdir "${name}"
         unzip "$src"

         ensureDir "$out/lib/${python.libPrefix}/site-packages"
         cp -v mock.py "$out/lib/${python.libPrefix}/site-packages"
      '';

    meta = {
      description = "Mock objects for Python";

      homepage = http://python-mock.sourceforge.net/;

      license = "mBSD";
    };
  });

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

  nevow = buildPythonPackage (rec {
    name = "nevow-0.9.33";

    src = fetchurl {
      url = "http://divmod.org/trac/attachment/wiki/SoftwareReleases/Nevow-0.9.33.tar.gz?format=raw";
      sha256 = "1b6zhfxx247b60n1qi2hrawhiaah88v8igg37pf7rjkmvy2z1c6c";
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

  notify = pkgs.stdenv.mkDerivation (rec {
    name = "python-notify-0.1.1";

    src = fetchurl {
      url = http://www.galago-project.org/files/releases/source/notify-python/notify-python-0.1.1.tar.bz2;
      sha256 = "1kh4spwgqxm534qlzzf2ijchckvs0pwjxl1irhicjmlg7mybnfvx";
    };

    buildInputs = [ python pkgs.pkgconfig pkgs.libnotify pkgs.pygobject pkgs.pygtk pkgs.gtkLibs.glib pkgs.gtkLibs.gtk pkgs.dbus_glib ];

    meta = {
      description = "Python bindings for libnotify";
      homepage = http://www.galago-project.org/;
    };
  });

  numpy = buildPythonPackage ( rec {
    name = "numpy-1.4.1";

    src = fetchurl {
      url = "mirror://sourceforge/numpy/${name}.tar.gz";
      sha256 = "01lf3nc2lp1qkrqnnar50vb7i6y07d1zs6f9yc3kw4p5fd2vhyrf";
    };

    doCheck = false;

    buildInputs = [ pkgs.liblapack pkgs.blas pkgs.gfortran ];

    # The build should be run as follows:
    #
    #   python setup.py config_fc --fcompiler=gnu95 build
    #   python setup.py config_fc --fcompiler=gnu95 install
    #
    # But I con't figure out how to pass the extra flags to setuptools.

    meta = {
      description = "Scientific tools for Python";
      homepage = "http://numpy.scipy.org/";
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
    name = "pycryptopp-0.5.15";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/pycryptopp/${name}.tar.gz";
      sha256 = "0f8v3cs8vjpj423yx3ikj7qjvljrm86x0qpkckidv69kah8kndxa";
    };

    # Use our own copy of Crypto++.
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

  pyutil = buildPythonPackage (rec {
    name = "pyutil-1.3.30";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/pyutil/${name}.tar.gz";
      sha256 = "1ksb4gn8x53wcyddmjv1ma8cvvhjlmfxc6kpszyhb838i7xzla19";
    };

    buildInputs = [ setuptoolsDarcs ];
    propagatedBuildInputs = [ zbase32 argparse ];

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

  setuptoolsDarcs = buildPythonPackage {
    name = "setuptools-darcs-1.2.8";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/s/setuptools_darcs/setuptools_darcs-1.2.8.tar.gz";
      sha256 = "0jg9q9mhsky444mm7lpmmlxai8hmjg4pc71viv4kni8gls0gk9n8";
    };

    # In order to break the dependency on darcs -> ghc, we don't add
    # darcs as a propagated build input.

    meta = {
      description = "setuptools plugin for the Darcs version control system";

      homepage = http://allmydata.org/trac/setuptools_darcs;

      license = "BSD";
    };
  };

  setuptoolsTrial = buildPythonPackage {
    name = "setuptools-trial-0.5.3";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/s/setuptools_trial/setuptools_trial-0.5.3.tar.gz";
      sha256 = "0h3mgjsz3z1sjl9j0b6bv4bss8d0przamj4gnjmpyazc633hhlyi";
    };

    propagatedBuildInputs = [ twisted ];

    meta = {
      description = "setuptools plug-in that helps run unit tests built with the \"Trial\" framework (from Twisted)";

      homepage = http://allmydata.org/trac/setuptools_trial;

      license = "unspecified"; # !
    };
  };

  simplejson = buildPythonPackage (rec {
    name = "simplejson-2.0.9";

    src = fetchsvn {
      url = "http://simplejson.googlecode.com/svn/tags/${name}";
      sha256 = "a48d5256fdb4f258c33da3dda110ecf3c786f086dcb08a01309acde6d1ddb921";
      rev = "172";  # to be on the safe side
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

  trac = buildPythonPackage {
    name = "trac-0.11.5";

    src = fetchurl {
      url = http://ftp.edgewall.com/pub/trac/Trac-0.11.5.tar.gz;
      sha256 = "cc3362ecc533abc1755dd78e2d096d1413bc975abc3185318f4821458cd6a8ac";
    };

    doCheck = false;

    PYTHON_EGG_CACHE = "`pwd`/.egg-cache";

    propagatedBuildInputs = [ genshi pkgs.setuptools ];

    meta = {
      description = "Enhanced wiki and issue tracking system for software development projects";

      license = "BSD";
    };
  };

  twisted = buildPythonPackage {
    name = "twisted-10.0.0";

    src = fetchurl {
      url = http://tmrc.mit.edu/mirror/twisted/Twisted/10.0/Twisted-10.0.0.tar.bz2;
      sha256 = "1cbqpvwdwsc2av43fyqqdyyxs2j3drbagnl9m5vk7fl9k5q8q4fv";
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

  zbase32 = buildPythonPackage (rec {
    name = "zbase32-1.1.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zbase32/${name}.tar.gz";
      sha256 = "0n59l4rs26vrhxpsfrwybjjir68aj23f09k1yjnbxqy5n0khp8gm";
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
    name = "zfec-1.4.4";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/z/zfec/${name}.tar.gz";
      sha256 = "0rgg7nsvbr4f9xmiclzypc39fnivg23kldv5aa8si0bgsxn6mh6w";
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
    name = "zope-interface-3.3.0";
    src = fetchurl {
      url = http://www.zope.org/Products/ZopeInterface/3.3.0/zope.interface-3.3.0.tar.gz;
      sha256 = "0xahg9cmagn4j3dbifvgzbjliw2jdrbf27fhqwkdp8j80xpyyjf0";
    };

    doCheck = false;

    meta = {
      description = "Zope.Interface";
      homepage = http://zope.org/Products/ZopeInterface;
      license = "ZPL";
    };
  };
}
