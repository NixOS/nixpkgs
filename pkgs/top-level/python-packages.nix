{ pkgs }:

rec {
  inherit (pkgs) buildPythonPackage fetchurl fetchsvn stdenv python;

  foolscap = buildPythonPackage (rec {
    name = "foolscap-0.3.2";

    src = fetchurl {
      url = "http://foolscap.lothar.com/releases/${name}.tar.gz";
      sha256 = "1wkqgm6anlxvz8dnqx7ki008255nm1mlhak5n9xy6g1yf31fn3l0";
    };

    propagatedBuildInputs = [ pkgs.twisted pkgs.pyopenssl ];

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

    propagatedBuildInputs = [ pkgs.twisted ];

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

}
