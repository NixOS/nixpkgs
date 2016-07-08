{ pkgs, stdenv }:

with pkgs;

let

  interpreters = rec {
    cpython26 = callPackage ../development/interpreters/python/cpython/2.6 {
      inherit (darwin) CF configd;
      self = cpython26;
    };
    cpython27 = callPackage ../development/interpreters/python/cpython/2.7 {
      inherit (darwin) CF configd;
      self = cpython27;
    };
    cpython33 = callPackage ../development/interpreters/python/cpython/3.3 {
      inherit (darwin) CF configd;
      self = cpython33;
    };
    cpython34 = callPackage ../development/interpreters/python/cpython/3.4 {
      inherit (darwin) CF configd;
      self = cpython34;
    };
    cpython35 = callPackage ../development/interpreters/python/cpython/3.5 {
      inherit (darwin) CF configd;
      self = cpython35;
    };
    pypy27 = callPackage ../development/interpreters/python/pypy/2.7 {
      self = pypy27;
    };
  };

in rec {

  cpython26 = callPackage ../development/python-modules {
    interpreter = interpreters.cpython26;
  };
  cpython27 = callPackage ../development/python-modules {
    interpreter = interpreters.cpython27;
  };
  cpython33 = callPackage ../development/python-modules {
    interpreter = interpreters.cpython33;
  };
  cpython34 = callPackage ../development/python-modules {
    interpreter = interpreters.cpython34;
  };
  cpython35 = callPackage ../development/python-modules {
    interpreter = interpreters.cpython35;
  };

}
