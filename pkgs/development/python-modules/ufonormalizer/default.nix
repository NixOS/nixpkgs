{ lib, buildPythonPackage, fetchPypi, pythonOlder, setuptools_scm }:

buildPythonPackage rec {
  pname = "ufonormalizer";
  version = "0.5.4";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "11l8475p3nq7azim35l5lck8vrgjgd01plnji6gg1hf9ckswr2pb";
    extension = "zip";
  };

  nativeBuildInputs = [ setuptools_scm ];

  meta = with lib; {
    description = "Script to normalize the XML and other data inside of a UFO";
    homepage = "https://github.com/unified-font-object/ufoNormalizer";
    license = licenses.bsd3;
    maintainers = [ maintainers.sternenseemann ];
  };
}
