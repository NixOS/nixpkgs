{ stdenv
, buildPythonPackage
, fetchPypi
, markupsafe
}:

buildPythonPackage rec {
  version = "2.3.1";
  pname = "WTForms";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0whrd9cqhlibm31yqhvhp9illddxf0cpgcn3v806f7ajmsri66l6";
  };

  propagatedBuildInputs = [ markupsafe ];

  # Django tests are broken "django.core.exceptions.AppRegistryNotReady: Apps aren't loaded yet."
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A flexible forms validation and rendering library for Python";
    homepage = "https://github.com/wtforms/wtforms";
    changelog = "https://github.com/wtforms/wtforms/blob/${version}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = [ maintainers.bhipple ];
  };

}
