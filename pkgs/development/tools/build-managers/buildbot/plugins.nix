{ stdenv
, fetchurl
, pythonPackages
}:

let
  buildbot-pkg = pythonPackages.buildPythonPackage rec {
    name = "buildbot-pkg-${version}";
    version = "0.9.0rc2";

    src = fetchurl {
      url = "https://pypi.python.org/packages/95/47/1fef931d410cc24127564c2e193e7c1c184f5c5f481930f77c6d6840cfab/${name}.tar.gz";
      sha256 = "01wc9bmqq1rfayqnjm7rkjhbcj7h6ah4vv10s6hglnq9s4axvxp6";
    };

    propagatedBuildInputs = with pythonPackages; [ setuptools ];

    # doesn't seem to break without this...
    patchPhase = ''
      sed -i.bak -e '/"setuptools >= 21.2.1",/d' setup.py
    '';

    meta = with stdenv.lib; {
      homepage = http://buildbot.net/;
      description = "Buildbot Packaging Helper";
      maintainers = with maintainers; [ nand0p ryansydnor ];
      platforms = platforms.all;
    };
  };

in {

  www = pythonPackages.buildPythonPackage rec {
    name = "buildbot_www-${version}";
    version = "0.9.0rc2";

    # NOTE: wheel is used due to buildbot circular dependency
    format = "wheel";
    src = fetchurl {
      url = "https://pypi.python.org/packages/e0/d7/f1023cdb7340a15ee1fc9916e87c4d634405a87164a051e2c59bf9d51ef1/${name}-py2-none-any.whl";
      sha256 = "1006x56x4w4p2mbrzm7jy51c0xxz48lzhdwvx7j4hrjs07mapndj";
    };

    propagatedBuildInputs = [ buildbot-pkg ];

    meta = with stdenv.lib; {
      homepage = http://buildbot.net/;
      description = "Buildbot UI";
      maintainers = with maintainers; [ nand0p ryansydnor ];
      platforms = platforms.all;
    };
  };

  console-view = pythonPackages.buildPythonPackage rec {
    name = "buildbot-console-view-${version}";
    version = "0.9.0rc2";

    src = fetchurl {
      url = "https://pypi.python.org/packages/f4/51/e24cc1b596e5b262a272cba3687476a13ec7d9ea24bf1f4fd0cd72902bb6/${name}.tar.gz";
      sha256 = "0970gq1sxnfd0nlrnd3mj25i3cginlw2pj5ffqsd57n5hlqg48ib";
    };

    propagatedBuildInputs = [ buildbot-pkg ];

    meta = with stdenv.lib; {
      homepage = http://buildbot.net/;
      description = "Buildbot Console View Plugin";
      maintainers = with maintainers; [ nand0p ryansydnor ];
      platforms = platforms.all;
    };
  };

  waterfall-view = pythonPackages.buildPythonPackage rec {
    name = "buildbot-waterfall-view-${version}";
    version = "0.9.0rc2";

    src = fetchurl {
      url = "https://pypi.python.org/packages/c2/21/3895355b05f91977a8b8e5435f85354e927c2ef547a25432a6bacf792a67/${name}.tar.gz";
      sha256 = "1zybrbbsyplv93zkin8cb3z1bqqr6px4p203ldcpn7lds5s9vk00";
    };

    propagatedBuildInputs = [ buildbot-pkg ];

    meta = with stdenv.lib; {
      homepage = http://buildbot.net/;
      description = "Buildbot Waterfall View Plugin";
      maintainers = with maintainers; [ nand0p ryansydnor ];
      platforms = platforms.all;
    };
  };
}
