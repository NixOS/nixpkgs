{ stdenv, fetchurl, python2Packages }:

python2Packages.buildPythonApplication rec {
  name = "grin-1.2.1";
  namePrefix = "";

  src = fetchurl {
    url = "mirror://pypi/g/grin/${name}.tar.gz";
    sha256 = "1swzwb17wibam8jszdv98h557hlx44pg6psv6rjz7i33qlxk0fdz";
  };

  buildInputs = with python2Packages; [ nose ];
  propagatedBuildInputs = with python2Packages; [ argparse ];

  meta = {
    homepage = https://pypi.python.org/pypi/grin;
    description = "A grep program configured the way I like it";
    platform = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.sjagoe ];
  };
}
