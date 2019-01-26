{ stdenv, python3Packages, pew }:
with python3Packages; buildPythonApplication rec {
    name = "${pname}-${version}";
    pname = "pipenv";
    version = "2018.11.26";

    src = fetchPypi {
      inherit pname version;
      sha256 = "0ip8zsrwmhrankrix0shig9g8q2knmr7b63sh7lqa8a5x03fcwx6";
    };

    LC_ALL = "en_US.UTF-8";

    propagatedBuildInputs = [ pew pip requests flake8 parver invoke ];

    doCheck = false;

    meta = with stdenv.lib; {
      description = "Python Development Workflow for Humans";
      license = licenses.mit;
      platforms = platforms.all;
      maintainers = with maintainers; [ berdario ];
    };
  }
