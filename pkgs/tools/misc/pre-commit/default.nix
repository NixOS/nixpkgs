{ lib, python3Packages }:

with python3Packages;
buildPythonPackage rec {
  pname = "pre-commit";
  version = "2.16.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit version;
    pname = "pre_commit";
    sha256 = "sha256-/piXysgwqnFk29AqTnuQyuSWMEUc6IRkvKc9tIa6n2U=";
  };

  patches = [
    ./languages-use-the-hardcoded-path-to-python-binaries.patch
    ./hook-tmpl.patch
  ];

  propagatedBuildInputs = [
    cfgv
    identify
    nodeenv
    pyyaml
    toml
    virtualenv
  ] ++ lib.optional (pythonOlder "3.8") [
    importlib-metadata
  ] ++ lib.optional (pythonOlder "3.7") [
    importlib-resources
  ];

  # slow and impure
  doCheck = false;

  preFixup = ''
    substituteInPlace $out/${python.sitePackages}/pre_commit/resources/hook-tmpl \
      --subst-var-by pre-commit $out
    substituteInPlace $out/${python.sitePackages}/pre_commit/languages/python.py \
      --subst-var-by virtualenv ${virtualenv}
    substituteInPlace $out/${python.sitePackages}/pre_commit/languages/node.py \
      --subst-var-by nodeenv ${nodeenv}
  '';

  pythonImportsCheck = [
    "pre_commit"
  ];

  meta = with lib; {
    description = "A framework for managing and maintaining multi-language pre-commit hooks";
    homepage = "https://pre-commit.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ borisbabic ];
  };
}
