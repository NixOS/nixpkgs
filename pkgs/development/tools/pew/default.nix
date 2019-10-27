{ stdenv, python3Packages }:
with python3Packages; buildPythonApplication rec {
    pname = "pew";
    version = "1.1.2";

    src = fetchPypi {
      inherit pname version;
      sha256 = "04anak82p4v9w0lgfs55s7diywxil6amq8c8bhli143ca8l2fcdq";
    };

    propagatedBuildInputs = [ virtualenv virtualenv-clone setuptools ];

    LC_ALL = "en_US.UTF-8";

    postFixup = ''
      set -euo pipefail
      PEW_SITE="$out/lib/${python.libPrefix}/site-packages"
      SETUPTOOLS="${setuptools}/lib/${python.libPrefix}/site-packages"
      SETUPTOOLS_SITE=$SETUPTOOLS/$(cat $SETUPTOOLS/setuptools.pth)
      CLONEVENV_SITE="${virtualenv-clone}/lib/${python.libPrefix}/site-packages"
      SITE_PACKAGES="[\'$PEW_SITE\',\'$SETUPTOOLS_SITE\',\'$CLONEVENV_SITE\']"
      substituteInPlace $PEW_SITE/pew/pew.py \
        --replace "from pew.pew" "import sys; sys.path.extend($SITE_PACKAGES); from pew.pew" \
        --replace 'sys.executable, "-m", "virtualenv"' "'${virtualenv}/bin/virtualenv'"
    '';

    meta = with stdenv.lib; {
      homepage = https://github.com/berdario/pew;
      description = "Tools to manage multiple virtualenvs written in pure python";
      license = licenses.mit;
      platforms = platforms.all;
      maintainers = with maintainers; [ berdario ];
    };
  }
