{ stdenv, fetchurl, python35Packages }:

python35Packages.buildPythonApplication rec {
  name = "mypy-lang-${version}";
  version = "0.4.2";

  # Tests not included in pip package.
  doCheck = false;

  src = fetchurl {
    url = "mirror://pypi/m/mypy-lang/${name}.tar.gz";
    sha256 = "12vwgzbpv0n403dvzas5ckw0f62slqk5j3024y65hi9n95r34rws";
  };

  meta = with stdenv.lib; {
    description = "Optional static typing for Python";
    homepage    = "http://www.mypy-lang.org";
    license     = licenses.mit;
    maintainers = with maintainers; [ martingms ];
  };
}
