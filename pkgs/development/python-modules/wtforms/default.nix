{ lib
, buildPythonPackage
, fetchPypi
, markupsafe
}:

buildPythonPackage rec {
  version = "2.3.3";
  pname = "WTForms";

  src = fetchPypi {
    inherit pname version;
    sha256 = "81195de0ac94fbc8368abbaf9197b88c4f3ffd6c2719b5bf5fc9da744f3d829c";
  };

  propagatedBuildInputs = [ markupsafe ];

  # Django tests are broken "django.core.exceptions.AppRegistryNotReady: Apps aren't loaded yet."
  doCheck = false;

  meta = with lib; {
    description = "A flexible forms validation and rendering library for Python";
    homepage = "https://github.com/wtforms/wtforms";
    changelog = "https://github.com/wtforms/wtforms/blob/${version}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = [ maintainers.bhipple ];
  };

}
