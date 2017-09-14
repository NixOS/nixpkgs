{ lib, fetchurl, buildPythonPackage, numpy }:

buildPythonPackage rec {
  name = "sphfile-${version}";
  version = "1.0.0";

  src = fetchurl {
    url = "mirror://pypi/s/sphfile/${name}.tar.gz";
    sha256 = "1ly9746xrzbiax9cxr5sxlg0wvf6fdxcrgwsqqxckk3wnqfypfrd";
  };

  propagatedBuildInputs = [ numpy ];

  doCheck = false;

  meta = with lib; {
    description = "Numpy-based NIST SPH audio-file reader";
    homepage    = "https://github.com/mcfletch/sphfile";
    license     = licenses.mit;
    maintainers = with maintainers; [ abbradar ];
    platforms   = platforms.unix;
  };
}
