{ lib, fetchurl, buildPythonPackage, numpy }:

buildPythonPackage rec {
  pname = "sphfile";
  version = "1.0.1";
  name = pname + "-" + version;

  src = fetchurl {
    url = "mirror://pypi/s/sphfile/${name}.tar.gz";
    sha256 = "422b0704107b02ef3ca10e55ccdc80b0bb5ad8e2613b6442f8e2ea372c7cf5d8";
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
