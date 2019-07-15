{ buildPythonPackage
, fetchPypi
, lib
, setuptools
}:

buildPythonPackage rec {
  pname = "z3-solver";
  version = "4.8.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0qpfhpdvlmif94ckbf5lwqfn0jv9j8f5ph38pqlzp60w4lh80xpj";
  };

  propagatedBuildInputs = [ setuptools ];

  setupPyBuildFlags = [
     "--plat-name x86_64-linux"
   ];

  # tests require other angr related components
  doCheck = false;

  meta = with lib; {
    description = "angr's version of the python binding for the Z3 theorem prover";
    homepage = "https://github.com/angr/z3";
    license = licenses.mit;
    maintainers = [ maintainers.pamplemousse ];
  };
}
