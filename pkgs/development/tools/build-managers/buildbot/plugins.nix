{ stdenv
, fetchurl
, pythonPackages
}:

let
  buildbot-pkg = pythonPackages.buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "buildbot-pkg";
    version = "0.9.0rc3";

    src = fetchurl {
      url = "mirror://pypi/b/${pname}/${name}.tar.gz";
      sha256 = "0a05dgc5nn6sx3nicfvqwar9iy8yxhq92688dhs5p6mzjxaprlxm";
    };

    propagatedBuildInputs = with pythonPackages; [ setuptools ];

    meta = with stdenv.lib; {
      homepage = http://buildbot.net/;
      description = "Buildbot Packaging Helper";
      maintainers = with maintainers; [ nand0p ryansydnor ];
      platforms = platforms.all;
    };
  };

in {

  www = pythonPackages.buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "buildbot_www";
    version = "0.9.0rc3";

    # NOTE: wheel is used due to buildbot circular dependency
    format = "wheel";
    src = fetchurl {
      url = "https://pypi.python.org/packages/93/1e/09e329fc831ae4f5be05eb3363c9028ab7e26e9c7e5d89e3aa66c3f25d9d/${name}-py2-none-any.whl";
      sha256 = "0fy2v7y1kc53zm67ddx85yz5qh4b7hmcbfzmsziiv9n83a0qh1i6";
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
    name = "${pname}-${version}";
    pname = "buildbot-console-view";
    version = "0.9.0rc3";

    src = fetchurl {
      url = "mirror://pypi/b/${pname}/${name}.tar.gz";
      sha256 = "09yfqrnwfambg1j4x7ywnjg4xfhvv6f242zzh35fwj64cnqmqx07";
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
    name = "${pname}-${version}";
    pname = "buildbot-waterfall-view";
    version = "0.9.0rc3";

    src = fetchurl {
      url = "mirror://pypi/b/${pname}/${name}.tar.gz";
      sha256 = "0xpqxj3mmwl5xdhm3p52shl24d85qapdk4v66f9hrb9pnk5k4a81";
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
