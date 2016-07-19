{ stdenv, fetchurl, python35Packages }:

python35Packages.buildPythonApplication rec {
  name = "mypy-lang-${version}";
  version = "0.4.3";

  # Tests not included in pip package.
  doCheck = false;

  src = fetchurl {
    url = "mirror://pypi/m/mypy-lang/${name}.tar.gz";
    sha256 = "11d8195xg8hksyh2qapbv66jvjgfpjwkc61nwljcfq9si144f2nb";
  };

  propagatedBuildInputs = with python35Packages; [ lxml ];

  meta = with stdenv.lib; {
    description = "Optional static typing for Python";
    homepage    = "http://www.mypy-lang.org";
    license     = licenses.mit;
    maintainers = with maintainers; [ martingms ];
  };
}
