{ lib
, fetchurl
, buildPythonPackage
, isPyPy
, packaging
, toml
, pythonOlder
, python
}:

buildPythonPackage rec {
  pname = "sip";
  # Latest stable. No idea why they call it "dev".
  version = "5.5.0.dev2010041444";

  disabled = pythonOlder "3.5" || isPyPy;

  src = fetchurl {
    url = "https://www.riverbankcomputing.com/static/Downloads/sip/sip-${version}.tar.gz";
    sha256 = "sha256-MNUzjRIuVVTZmRzjCAQwvcSZtlyfJ6W+ZacHfBv9c7g=";
  };

  propagatedBuildInputs = [
    packaging
    toml
  ];

  pythonImportsCheck = [
    "sipbuild"
  ];

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    description = "Creates C++ bindings for Python modules";
    homepage    = "http://www.riverbankcomputing.co.uk/";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ lovek323 sander ];
  };
}
