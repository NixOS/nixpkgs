{ stdenv, fetchurl, python35Packages }:

python35Packages.buildPythonApplication rec {
  name = "mypy-lang-${version}";
  version = "0.4.5";

  # Tests not included in pip package.
  doCheck = false;

  src = fetchurl {
    url = "mirror://pypi/m/mypy-lang/${name}.tar.gz";
    sha256 = "0x1n6r5in57zv4s75r22smpqxrz7xxp84fnrhkwzbpjnafa3y81f";
  };

  propagatedBuildInputs = with python35Packages; [ lxml ];

  meta = with stdenv.lib; {
    description = "Optional static typing for Python";
    homepage    = "http://www.mypy-lang.org";
    license     = licenses.mit;
    maintainers = with maintainers; [ martingms ];
  };
}
