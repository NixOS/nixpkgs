{ lib, fetchurl, buildPythonPackage, numpy }:

buildPythonPackage rec {
  pname = "sphfile";
  version = "1.0.0";
  name = pname + "-" + version;

  src = fetchurl {
    url = "mirror://pypi/s/sphfile/${name}.tar.gz";
    sha256 = "1ly9746xrzbiax9cxr5sxlg0wvf6fdxcrgwsqqxckk3wnqfypfrd";
  };

  propagatedBuildInputs = [ numpy ];

  doCheck = false;

  meta = with lib; {
    description = "Numpy-based NIST SPH audio-file reader";
    homepage    = https://github.com/mcfletch/sphfile;
    license     = licenses.mit;
    maintainers = with maintainers; [ abbradar ];
    platforms   = platforms.unix;
  };
}
