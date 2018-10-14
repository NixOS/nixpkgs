{ stdenv, python3Packages, pew }:
with python3Packages; buildPythonApplication rec {
    name = "${pname}-${version}";
    pname = "pipenv";
    version = "2018.10.9";

    src = fetchPypi {
      inherit pname version;
      sha256 = "0b0safavjxq6malmv44acmgds21m2sp1wqa7gs0qz621v6gcgq4j";
    };

    LC_ALL = "en_US.UTF-8";

    propagatedBuildInputs = [ pew pip certifi ];

    doCheck = false;

    meta = with stdenv.lib; {
      description = "Python Development Workflow for Humans";
      license = licenses.mit;
      platforms = platforms.all;
      maintainers = with maintainers; [ berdario ];
    };
  }
