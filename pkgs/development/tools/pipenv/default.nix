{ stdenv, python3Packages, pew }:
with python3Packages; buildPythonApplication rec {
    name = "${pname}-${version}";
    pname = "pipenv";
    version = "11.9.0";

    src = fetchPypi {
      inherit pname version;
      sha256 = "0s291ayiszqg4ia0fiya2g3ra6m6bf7mrds1c4dscz71azxm4g3v";
    };

    LC_ALL = "en_US.UTF-8";

    propagatedBuildInputs = [ pew pip requests flake8 ];

    doCheck = false;

    meta = with stdenv.lib; {
      description = "Python Development Workflow for Humans";
      license = licenses.mit;
      platforms = platforms.all;
      maintainers = with maintainers; [ berdario ];
    };
  }
