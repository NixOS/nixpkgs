{ buildPythonPackage
, fetchFromGitHub
, jax
, jaxlib
, lib
, poetry-core
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "treeo";
  version = "0.0.9";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "cgarciae";
    repo = pname;
    rev = version;
    hash = "sha256-Yk4KNE5BncYoEHWZSEeSgoNb0TLMRbs8kSovUEKR2Ek=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  # jax is not declared in the dependencies, but is necessary.
  propagatedBuildInputs = [
    jax
    jaxlib
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "treeo"
  ];

  meta = with lib; {
    description = "A small library for creating and manipulating custom JAX Pytree classes";
    homepage = "https://github.com/cgarciae/treeo";
    license = licenses.mit;
    maintainers = with maintainers; [ ndl ];
  };
}
