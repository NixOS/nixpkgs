{ pkgs }:

rec {
  inherit (pkgs) buildPythonPackage fetchurl fetchsvn stdenv python;

  foolscap = buildPythonPackage (rec {
    name = "foolscap-0.3.2";

    src = fetchurl {
      url = "http://foolscap.lothar.com/releases/${name}.tar.gz";
      sha256 = "1wkqgm6anlxvz8dnqx7ki008255nm1mlhak5n9xy6g1yf31fn3l0";
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

  setuptoolsDarcs = buildPythonPackage {
    name = "setuptools-darcs-1.2.8";

    src = fetchurl {
      url = "http://pypi.python.org/packages/source/s/setuptools_darcs/setuptools_darcs-1.2.8.tar.gz";
      sha256 = "0jg9q9mhsky444mm7lpmmlxai8hmjg4pc71viv4kni8gls0gk9n8";
    };

    propagatedBuildInputs = [ pkgs.darcs ];

    meta = {
      description = "setuptools plugin for the Darcs version control system";

      homepage = http://allmydata.org/trac/setuptools_darcs;

      license = "BSD";
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

  twisted = buildPythonPackage {
    name = "twisted-8.1.0";

    src = fetchurl {
      url = http://tmrc.mit.edu/mirror/twisted/Twisted/8.1/Twisted-8.1.0.tar.bz2;
      sha256 = "0q25zbr4xzknaghha72mq57kh53qw1bf8csgp63pm9sfi72qhirl";
    };

    propagatedBuildInputs = [ pkgs.ZopeInterface ];

    meta = {
      homepage = http://twistedmatrix.com/;

      description = "Twisted, an event-driven networking engine written in Python";

      longDescription = ''
        Twisted is an event-driven networking engine written in Python
        and licensed under the MIT license.
      '';

      license = "MIT";
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

}
