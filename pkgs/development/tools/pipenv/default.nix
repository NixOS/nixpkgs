{ stdenv, python3Packages, pew }:
with python3Packages; buildPythonApplication rec {
    name = "${pname}-${version}";
    pname = "pipenv";
    version = "2018.10.13";

    src = fetchPypi {
      inherit pname version;
      sha256 = "0qwflq00rwk3pnldndb30f3avnbi4hvv6c8mm6l5xxnxy9dj71d7";
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
