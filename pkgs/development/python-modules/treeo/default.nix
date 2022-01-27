{ buildPythonPackage
, fetchFromGitHub
, jax
, jaxlib
, lib
, poetry-core
}:

buildPythonPackage rec {
  pname = "treeo";
  version = "0.0.9";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "cgarciae";
    repo = pname;
    rev = version;
    sha256 = "0jfqj5150braj4ybnifc6b8mp0w2j93li6bm20lcd7a19qs0lkk2";
  };

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
