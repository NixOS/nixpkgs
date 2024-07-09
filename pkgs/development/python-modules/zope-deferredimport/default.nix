{
  lib,
  buildPythonPackage,
  fetchPypi,
  zope-proxy,
  zope-testrunner,
}:

buildPythonPackage rec {
  pname = "zope-deferredimport";
  version = "5.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "zope.deferredimport";
    inherit version;
    sha256 = "sha256-Orvw4YwfF2WRTs0dQbVJ5NBFshso5AZfsMHeCtc2ssM=";
  };

  propagatedBuildInputs = [ zope-proxy ];

  nativeCheckInputs = [ zope-testrunner ];

  checkPhase = ''
    zope-testrunner --test-path=src []
  '';

  doCheck = false;

  meta = with lib; {
    description = "Allows you to perform imports names that will only be resolved when used in the code";
    homepage = "https://github.com/zopefoundation/zope.deferredimport";
    license = licenses.zpl21;
  };
}
