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

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'typing-extensions = "^3.10.0"' 'typing-extensions = "*"'
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  # jax is not declared in the dependencies, but is necessary.
  propagatedBuildInputs = [
    jax
  ];

  checkInputs = [ jaxlib ];
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
