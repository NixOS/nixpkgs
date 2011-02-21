{ pkgs, python, buildPythonPackage }:

rec {
  inherit (pkgs) fetchurl fetchsvn stdenv;

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
    name = "darcsver-1.5.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/d/darcsver/${name}.tar.gz";
      sha256 = "e643d607f27e4b8cc96565432ff1abdc2af5e9061c70798e2f33e78c07b66b3a";
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
    name = "foolscap-0.5.1";

    src = fetchurl {
      url = "http://foolscap.lothar.com/releases/${name}.tar.gz";
      sha256 = "c7dfb6f9331e05a8d9553730493b4740c7bf4b4cd68ba834061f0ca0d455492d";
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

  mock060 = pkgs.lowPrio (buildPythonPackage (rec {
    # TODO: This appears to be an unofficially hacked version of 'mock'
    #       from above. This could probably replace the previous
    #       package, but I don't have time to test that right now.
    name = "mock-0.6.0";

    src = fetchurl {
      url = "http://tahoe-lafs.org/source/tahoe-lafs/deps/tahoe-dep-sdists/${name}.tar.bz2";
      sha256 = "1vwxzr2sjyl3x5jqgz9swpmp6cyhmwmab65akysfglf6acmn3czf";
    };
    doCheck = false;            # Package doesn't have any tests.

    meta = {
      description = "Mock objects for Python, provided by tahoe-lafs.org";
      homepage = "http://python-mock.sourceforge.net/";
      license = "mBSD";
    };
  }));

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

  nose = buildPythonPackage {
    name = "nose-0.11.3";

    src = fetchurl {
      url = http://python-nose.googlecode.com/files/nose-0.11.3.tar.gz;
      sha256 = "1hl3lbwdfl2a64q3dxc73kbiks4iwx5cixlbavyryd8xdr7iziww";
    };

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

    # TODO: add ATLAS=${pkgs.atlas}
    installCommand = ''
      export BLAS=${pkgs.blas} LAPACK=${pkgs.liblapack}
      python setup.py build --fcompiler="gnu95"
      python setup.py install --root="$out"
    '';
    doCheck = false;

    buildInputs = [ pkgs.gfortran ];
    propagatedBuildInputs = [ pkgs.liblapack pkgs.blas ];

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
    name = "pycryptopp-0.5.19";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/p/pycryptopp/${name}.tar.gz";
      sha256 = "6b610b3e5742d366d4fbe96b5f20d8459db9aba4fb802e6e5aab547f22ad04b9";
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
    name = "setuptools-trial-0.5.9";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/s/setuptools_trial/setuptools_trial-0.5.9.tar.gz";
      sha256 = "4e3b5a183b9cf6ff637777c9852dfe8eaab156289e7a578525d68b1cfb3c9f29";
    };

    propagatedBuildInputs = [ twisted ];

    meta = {
      description = "setuptools plug-in that helps run unit tests built with the \"Trial\" framework (from Twisted)";

      homepage = http://allmydata.org/trac/setuptools_trial;

      license = "unspecified"; # !
    };
  };

  simplejson = buildPythonPackage (rec {
    name = "simplejson-2.1.1";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/s/simplejson/${name}.tar.gz";
      sha256 = "8c1c833c5b997bf7b75bf9a02a2d2884b8427816228eac0fb84791be44d2f612";
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
    name = "twisted-10.1.0";

    src = fetchurl {
      url = http://tmrc.mit.edu/mirror/twisted/Twisted/10.1/Twisted-10.1.0.tar.bz2;
      sha256 = "eda6e0e9e5ef6f6c19ab75bcb094f83a12ee25fe589fbcddf946e8a655c8070b";
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
}
