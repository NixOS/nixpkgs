{ lib
, buildPythonApplication
, fetchPypi
, Babel
, docutils
, pygments
, pytz
, jinja2
, pysqlite
, psycopg2
, pymysql
, git
, setuptools
}:


buildPythonApplication rec {
  pname = "trac";
  version = "1.4";

  src = fetchPypi {
    inherit version;
    pname = "Trac";
    sha256 = "1cg51rg0vb9vf23wgn28z3szlxhwnxprj5m0mvibqyypi123bvx1";
  };

  prePatch = ''
    # Removing the date format tests as they are outdated
    substituteInPlace trac/util/tests/__init__.py \
      --replace "suite.addTest(datefmt.test_suite())" ""
  '';

  propagatedBuildInputs = [
    Babel
    docutils
    pygments
    pytz
    jinja2
    pysqlite
    psycopg2
    pymysql
    git
    setuptools
  ];

  meta = with lib; {
    description = "Integrated SCM, wiki, issue tracker and project environment";
    homepage = "https://trac.edgewall.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmahut ];
    platforms = platforms.linux;
  };
}
