{
  lib,
  toPythonModule,
  python,
  vigra,
  sphinx,
  boost,
  numpy,
  pythonImportsCheckHook,
}:

toPythonModule (
  (vigra.override {
    python3 = python;
    inherit boost;
  }).overrideAttrs
    (
      finalAttrs: previousAttrs: {
        cmakeFlags = previousAttrs.cmakeFlags or [ ] ++ [
          (lib.cmakeBool "WITH_VIGRANUMPY" true)
          "-DVIGRANUMPY_INSTALL_DIR=${placeholder "out"}/${python.sitePackages}"
        ];

        buildInputs = previousAttrs.buildInputs or [ ] ++ finalAttrs.passthru.dependencies;

        nativeInstallCheckInputs = previousAttrs.nativeInstallCheckInputs ++ [
          pythonImportsCheckHook
        ];

        pythonImportsCheckHook = [
          "vigra"
        ];

        passthru = previousAttrs.passthru or { } // {
          dependencies = [
            boost
            numpy
          ];
          doc = previousAttrs.passthru.tests.check.overrideAttrs (previousAttrs: {
            nativeBuildInputs = previousAttrs.nativeBuildInputs ++ [
              sphinx
            ];
            dontUsePytestCheck = true;
            dontPythonImportsCheck = true;
          });
        };
      }
    )
)
