{ stdenv, pythonPackages }:

with stdenv.lib;
with pythonPackages;

let
  # Get rid of this when pants 1.3.0 is released and make 0.5 the default
  pathspec = buildPythonApplication rec {
    pname   = "pathspec";
    version = "0.3.4";
    name    = "${pname}-${version}";

    src = fetchPypi {
      inherit pname version;
      sha256 = "0a37yrr2jhlg8aiynxivh2xqani7l9j725qxzrm7cm7m4rfcl1bn";
    };

    meta = {
      description = "Utility library for gitignore-style pattern matching of file paths";
      homepage = "https://github.com/cpburnz/python-path-specification";
      license = licenses.mpl20;
     maintainers = with maintainers; [ copumpkin ];
    };
  };
in {
  pants =
    pythonPackages.buildPythonPackage rec {
    pname   = "pantsbuild.pants";
    version = "1.2.1";
    name    = "${pname}-${version}";

    src = fetchPypi {
      inherit pname version;
      sha256 = "1bnzhhd2acwk7ckv56xzg2d9vxacl3k5bh13bsjxymnq3spm962w";
    };

    prePatch = ''
      sed -E -i "s/'([[:alnum:].-]+)[=><][^']*'/'\\1'/g" setup.py
    '';

    # Unnecessary, and causes some really weird behavior around .class files, which
    # this package bundles. See https://github.com/NixOS/nixpkgs/issues/22520.
    dontStrip = true;

    propagatedBuildInputs = [
      ansicolors beautifulsoup4 cffi coverage docutils fasteners futures
      isort lmdb markdown mock packaging pathspec pep8 pex psutil pyflakes
      pygments pystache pytestcov pytest pywatchman requests scandir
      setproctitle setuptools six thrift wheel twitter-common-dirutil
      twitter-common-confluence twitter-common-collections
    ];

    meta = {
      description = "A build system for software projects in a variety of languages";
      homepage    = "http://www.pantsbuild.org/";
      license     = licenses.asl20;
      maintainers = with maintainers; [ copumpkin ];
      platforms   = platforms.unix;
    };
  };

  pants13-pre = buildPythonApplication rec {
    pname   = "pantsbuild.pants";
    version = "1.3.0.dev19";
    name    = "${pname}-${version}";

    src = fetchPypi {
      inherit pname version;
      sha256 = "07gxx8kzkcx3pm2qd5sz2xb3nw9khvbapiqdzgjvzbvai2gsd5qq";
    };

    prePatch = ''
      sed -E -i "s/'([[:alnum:].-]+)[=><][[:digit:]=><.,]*'/'\\1'/g" setup.py
    '';

    # Unnecessary, and causes some really weird behavior around .class files, which
    # this package bundles. See https://github.com/NixOS/nixpkgs/issues/22520.
    dontStrip = true;

    propagatedBuildInputs = [
      twitter-common-collections setproctitle setuptools six ansicolors
      packaging pathspec scandir twitter-common-dirutil psutil requests
      pystache pex docutils markdown pygments twitter-common-confluence
      fasteners coverage pywatchman futures cffi
    ];

    meta = {
      description = "A build system for software projects in a variety of languages";
      homepage    = "http://www.pantsbuild.org/";
      license     = licenses.asl20;
      maintainers = with maintainers; [ copumpkin ];
      platforms   = platforms.unix;
    };
  };
}
