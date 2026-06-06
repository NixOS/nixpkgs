{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
}:

buildPythonPackage (finalAttrs: {
  pname = "whichcraft";
  version = "0.6.1";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    sha256 = "11yfkzyplizdgndy34vyd5qlmr1n5mxis3a3svxmx8fnccdvknxc";
  };

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  meta = {
    homepage = "https://github.com/pydanny/whichcraft";
    description = "Cross-platform cross-python shutil.which functionality";
    license = lib.licenses.bsd3;
  };
})
