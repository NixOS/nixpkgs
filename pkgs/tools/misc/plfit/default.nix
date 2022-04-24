{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, python ? null
, swig
, llvmPackages
}:

stdenv.mkDerivation rec {
  pname = "plfit";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "ntamas";
    repo = "plfit";
    rev = version;
    hash = "sha256-y4n6AlGtuuUuA+33oF7lGOYuKSqea4GMSJlv9PaSpQ8=";
  };

  patches = [
    # https://github.com/ntamas/plfit/pull/41
    (fetchpatch {
      name = "use-cmake-install-full-dir.patch";
      url = "https://github.com/ntamas/plfit/commit/d0e77c80e6e899298240e6be465cf580603f6ee2.patch";
      hash = "sha256-wi3qCp6ZQtrKuM7XDA6xCXunCiqsyhnkxmg2eSmxjYM=";
    })
  ];

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
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
