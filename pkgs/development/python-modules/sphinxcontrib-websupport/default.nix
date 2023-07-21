{ lib
, buildPythonPackage
, fetchPypi
, setuptoolsLegacyNamespaceHook
, sphinxcontrib-serializinghtml
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-websupport";
  version = "1.2.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Tt8CI6BoWnxIWuWhVrb1Kboe5IGhQXgXk1sgveGVYjI=";
  };

  nativeBuildInputs = [
    setuptoolsLegacyNamespaceHook
  ];

  propagatedBuildInputs = [
    sphinxcontrib-serializinghtml
  ];

  doCheck = false;

  meta = {
    description = "Sphinx API for Web Apps";
    homepage = "https://github.com/sphinx-doc/sphinxcontrib-websupport";
    license = lib.licenses.bsd2;
  };
}
