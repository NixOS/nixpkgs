{ stdenv, python3Packages, pew }:
with python3Packages; buildPythonApplication rec {
    name = "${pname}-${version}";
    pname = "pipenv";
    version = "2018.5.18";

    src = fetchPypi {
      inherit pname version;
      sha256 = "1knyknmykjj7gixdpfyns77sv4mizl68addk09ajmw9z5aqaif84";
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
