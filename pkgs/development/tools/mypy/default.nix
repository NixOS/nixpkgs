{ stdenv, fetchurl, python35Packages }:
python35Packages.buildPythonApplication rec {
  name = "mypy-${version}";
  version = "0.501";

  # Tests not included in pip package.
  doCheck = false;

  src = fetchurl {
    url = "mirror://pypi/m/mypy/${name}.tar.gz";
    sha256 = "164g3dq2vzxa53n9lgvmbapg41qiwcxk1w9mvzmnqksvql5vm60h";
  };

  propagatedBuildInputs = with python35Packages; [ lxml typed-ast ];

  meta = with stdenv.lib; {
    description = "Optional static typing for Python";
    homepage    = "http://www.mypy-lang.org";
    license     = licenses.mit;
    maintainers = with maintainers; [ martingms ];
  };
}
