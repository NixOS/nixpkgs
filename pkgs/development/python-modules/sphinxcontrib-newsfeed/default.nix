{ lib
, buildPythonPackage
, fetchPypi
, setuptoolsLegacyNamespaceHook
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-newsfeed";
  version = "0.1.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Bdz4fCWTRRYqUEzj3+4PcTifUHw3l3mNxTHHdImVtOs=";
  };

  nativeBuildInputs = [
    setuptoolsLegacyNamespaceHook
  ];

  propagatedBuildInputs = [ sphinx ];

  meta = with lib; {
    description = "Extension for adding a simple Blog, News or Announcements section to a Sphinx website";
    homepage = "https://github.com/prometheusresearch/sphinxcontrib-newsfeed";
    license = licenses.bsd2;
  };
}
