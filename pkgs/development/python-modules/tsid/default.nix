{
  lib,

  toPythonModule,
  pythonImportsCheckHook,

  tsid,

  pinocchio,
  python,
}:
toPythonModule (
  tsid.overrideAttrs (super: {
    pname = "py-${super.pname}";

    cmakeFlags = super.cmakeFlags ++ [
      (lib.cmakeBool "BUILD_PYTHON_INTERFACE" true)
      (lib.cmakeBool "BUILD_STANDALONE_PYTHON_INTERFACE" true)
    ];

    # those are used by CMake at configure/build time
    nativeBuildInputs = super.nativeBuildInputs ++ [
      python
    ];

    propagatedBuildInputs = super.propagatedBuildInputs ++ [
      pinocchio
      tsid
    ];

    nativeCheckInputs = [
      pythonImportsCheckHook
    ];

    pythonImportsCheck = [
      "tsid"
    ];
  })
)
