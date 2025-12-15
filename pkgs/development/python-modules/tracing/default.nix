{
  lib,
  buildPythonPackage,
  fetchurl,
  sphinx,
}:

buildPythonPackage rec {
  pname = "tracing";
  version = "0.8";
  format = "setuptools";

  src = fetchurl {
    url = "https://debian.mcc.ac.uk/debian/pool/main/p/python-tracing/python-tracing_${version}.orig.tar.gz";
    hash = "sha256-Mx8pvaE/HgLYfjcX9BeiRqUKdHNRjt57ZC/Zm35vhW4";
  };

  buildInputs = [ sphinx ];

  # error: invalid command 'test'
  doCheck = false;

  meta = {
    homepage = "https://liw.fi/tracing/";
    description = "Python debug logging helper";
    license = lib.licenses.gpl3;
    maintainers = [ ];
  };
}
