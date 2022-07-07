{ buildPythonPackage
, fetchFromGitHub
, fetchpatch
, jax
, jaxlib
, lib
, poetry-core
}:

buildPythonPackage rec {
  pname = "treeo";
  # Note that there is a version 0.4.0, but it was released in error. At the
  # time of writing (2022-03-29), v0.0.11 is the latest as reported on GitHub
  # and PyPI.
  version = "0.0.11";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "cgarciae";
    repo = pname;
    rev = version;
    hash = "sha256-zs3F8i+G5OX/A9wOO60xVuvnm2QqrL+dHIrC0qwH37o=";
  };

  # See https://github.com/cgarciae/treex/issues/68.
  patches = [
    (fetchpatch {
      url = "https://github.com/cgarciae/treeo/pull/14/commits/022915da2b3bf76406a7c79d1b4593bee7956f16.patch";
      hash = "sha256-WGxJqqrf2g0yZe30RyG1xxbloiqj1awuf1Y4eh5y+z0=";
    })
    (fetchpatch {
      url = "https://github.com/cgarciae/treeo/pull/14/commits/99f9488bd0c977780844fd79743167b0010d359b.patch";
      hash = "sha256-oKDYs+Ah0QXkhiJysIudQ6VLIiUiIcnQisxYp6GJuTc=";
    })
  ];

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
