{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python ? null,
  swig,
  llvmPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "plfit";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "ntamas";
    repo = "plfit";
    rev = finalAttrs.version;
    hash = "sha256-XRl6poEdgPNorFideQmEJHCU+phs4rIhMYa8iAOtL1A=";
  };

  postPatch = lib.optionalString (python != null) ''
    substituteInPlace src/CMakeLists.txt \
      --replace-fail ' ''${Python3_SITEARCH}' ' ${placeholder "out"}/${python.sitePackages}' \
      --replace-fail ' ''${Python3_SITELIB}' ' ${placeholder "out"}/${python.sitePackages}'
  '';

  nativeBuildInputs =
    [
      cmake
    ]
    ++ lib.optionals (python != null) [
      python
      swig
    ];

  cmakeFlags =
    [
      "-DPLFIT_USE_OPENMP=ON"
    ]
    ++ lib.optionals (python != null) [
      "-DPLFIT_COMPILE_PYTHON_MODULE=ON"
    ];

  buildInputs = lib.optionals stdenv.cc.isClang [
    llvmPackages.openmp
  ];

  doCheck = true;

  meta = with lib; {
    description = "Fitting power-law distributions to empirical data";
    homepage = "https://github.com/ntamas/plfit";
    changelog = "https://github.com/ntamas/plfit/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
})
