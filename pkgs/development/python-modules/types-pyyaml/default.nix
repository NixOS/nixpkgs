{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "types-pyyaml";
  version = "5.4.10";

  src = fetchPypi {
    pname = "types-PyYAML";
    inherit version;
    sha256 = "1d9e431e9f1f78a65ea957c558535a3b15ad67ea4912bce48a6c1b613dcf81ad";
  };

  meta = with lib; {
    description = "Typing stubs for PyYAML";
    longDescription = ''
      This is a PEP 561 type stub package for the PyYAML package. It can be used by type-checking tools like mypy, PyCharm, pytype etc. to check code that uses PyYAML. The source for this package can be found at https://github.com/python/typeshed/tree/master/stubs/PyYAML. All fixes for types and metadata should be contributed there.
    '';
    downloadPage = "https://pypi.org/project/types-PyYAML/";
    homepage = "https://github.com/python/typeshed/tree/master/stubs/PyYAML";
    license = licenses.asl20;
    maintainers = with maintainers; [ superherointj ];
  };
}
