{ lib
, stdenv
, fetchFromGitHub
, cmake
, python ? null
, swig
, llvmPackages
}:

stdenv.mkDerivation rec {
  pname = "plfit";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "ntamas";
    repo = "plfit";
    rev = version;
    hash = "sha256-hnmP/56P2anR0S8zQyQqN1lbge5GgK+P8Lx8bRkwSxA=";
  };

  nativeBuildInputs = [
    cmake
  ] ++ lib.optionals (!isNull python) [
    python
    swig
  ];

  cmakeFlags = [
    "-DPLFIT_USE_OPENMP=ON"
  ] ++ lib.optionals (!isNull python) [
    "-DPLFIT_COMPILE_PYTHON_MODULE=ON"
  ];

  buildInputs = lib.optionals stdenv.cc.isClang [
    llvmPackages.openmp
  ];

  meta = with lib; {
    description = "Fitting power-law distributions to empirical data";
    homepage = "https://github.com/ntamas/plfit";
    changelog = "https://github.com/ntamas/plfit/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
