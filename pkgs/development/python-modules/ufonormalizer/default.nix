{ lib, buildPythonPackage, fetchPypi, pythonOlder, setuptools_scm }:

buildPythonPackage rec {
  pname = "ufonormalizer";
  version = "0.5.2";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03k9dndnv3p3ysfq5wq8bnaijvqip61fh79d5gz2zk284vc47mgj";
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
