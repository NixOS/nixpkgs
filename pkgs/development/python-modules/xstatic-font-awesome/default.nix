{
  buildPythonPackage,
  lib,
  fetchPypi,
  setuptools_80,
}:

buildPythonPackage rec {
  pname = "xstatic-font-awesome";
  version = "6.2.1.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "XStatic-Font-Awesome";
    inherit version;
    hash = "sha256-8HWHEJYShjjy4VOQINgid1TD2IXdaOfubemgEjUHaCg=";
  };

  # xstatic uses pkg_resources.declare_namespace, removed in setuptools 83.
  build-system = [ setuptools_80 ];

  # no tests implemented
  doCheck = false;

  meta = {
    homepage = "https://github.com/python-xstatic/font-awesome";
    description = "Font Awesome packaged for python";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ aither64 ];
  };
}
