{ lib
, fetchFromGitHub
, buildPythonPackage
, dm-haiku
, poetry
, einops
, flax
, pyyaml
, rich
, treeo
}:

buildPythonPackage rec {
  pname = "treex";
  version = "0.6.7";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "cgarciae";
    repo = "${pname}";
    rev = "${version}";
    sha256 = "1hl3wj71c7cp7jzkhyjy7xgs2vc8c89icq0bgfr49y4pwv69n43m";
  };

  patches = [
    ./relax-deps.patch
  ];

  buildInputs = [
    poetry
  ];

  propagatedBuildInputs = [
    einops
    flax
    pyyaml
    rich
    treeo
  ];

  checkInputs = [
    dm-haiku
  ];

  pythonImportsCheck = [
    "treex"
  ];

  meta = with lib; {
    description = "A Pytree Module system for Deep Learning in JAX.";
    homepage = "https://github.com/cgarciae/treex";
    license = licenses.mit;
    maintainers = with maintainers; [ ndl ];
  };
}
