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
  version = "1.4.1";

  src = fetchPypi {
    inherit version;
    pname = "Trac";
    sha256 = "0d61ypn0j9wb8119bj3pj7s8swfjykdl0sz398p92k9bvxh4dayz";
  };

  prePatch = ''
    # Removing the date format tests as they are outdated
    substituteInPlace trac/util/tests/__init__.py \
      --replace "suite.addTest(datefmt.test_suite())" ""
    # Removing Pygments tests as per https://trac.edgewall.org/ticket/13229
    substituteInPlace trac/mimeview/tests/__init__.py \
      --replace "suite.addTest(pygments.test_suite())" ""
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
