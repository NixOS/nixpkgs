{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  boost,
  tbb,
  gmp,
  llvm,
  clang,
  sqlite,
  python3,
  ocamlPackages,
  mpfr,
  ppl,
  doxygen,
  graphviz,
}:

stdenv.mkDerivation rec {
  pname = "ikos";
  version = "3.5";

  src = fetchFromGitHub {
    owner = "NASA-SW-VnV";
    repo = "ikos";
    rev = "v${version}";
    hash = "sha256-kqgGD0plTW0N30kD7Y8xOvGODplJbi37Wh6yYAkzNKI=";
  };

  nativeBuildInputs = [
    cmake
    python3.pkgs.setuptools
    python3.pkgs.wheel
    python3.pkgs.build
    python3.pkgs.installer
    python3.pkgs.wrapPython
  ];

  buildInputs = [
    boost
    tbb
    gmp
    clang
    llvm
    sqlite
    python3
    ocamlPackages.apron
    mpfr
    ppl
    doxygen
    graphviz
  ];

  propagatedBuildInputs = [
    python3.pkgs.pygments
  ];

  cmakeFlags = [
    "-DAPRON_ROOT=${ocamlPackages.apron}"
    "-DINSTALL_PYTHON_VIRTUALENV=off"
    "-DPYTHON_VENV_EXECUTABLE=${python3}/bin/python"
  ];

  postBuild = ''
    make doc
    ${python3}/bin/python -m build --no-isolation --outdir dist/ --wheel analyzer/python
  '';

  postInstall = ''
    ${python3}/bin/python -m installer --prefix "$out" dist/*.whl
  '';

  postFixup = ''
    wrapPythonPrograms
  '';

  meta = with lib; {
    homepage = "https://github.com/NASA-SW-VnV/ikos";
    description = "Static analyzer for C/C++ based on the theory of Abstract Interpretation";
    license = licenses.nasa13;
    maintainers = with maintainers; [ atnnn ];
  };
}
