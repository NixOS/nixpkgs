{ buildPythonPackage
, fetchFromGitHub
, jax
, jaxlib
, lib
, poetry-core
}:

buildPythonPackage rec {
  pname = "treeo";
  version = "0.4.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "cgarciae";
    repo = pname;
    rev = version;
    sha256 = "176r1kgsdlylvdrxmhnzni81p8m9cfnsn4wwn6fnmsgam2qbp76j";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  # These deps are not needed for the wheel, but required during the import.
  propagatedBuildInputs = [
    jax
    jaxlib
  ];

  pythonImportsCheck = [
    "treeo"
  ];

  meta = with lib; {
    description = "A small library for creating and manipulating custom JAX Pytree classes.";
    homepage = "https://github.com/cgarciae/treeo";
    license = licenses.mit;
    maintainers = with maintainers; [ ndl ];
  };
}
