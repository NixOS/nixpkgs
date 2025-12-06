{
  lib,

  toPythonModule,
  pythonImportsCheckHook,

  tsid,

  pinocchio,
  python,

  standalone ? true,
}:
toPythonModule (
  tsid.overrideAttrs (super: {
    pname = "py-${super.pname}";

    cmakeFlags = super.cmakeFlags ++ [
      (lib.cmakeBool "BUILD_PYTHON_INTERFACE" true)
      (lib.cmakeBool "BUILD_STANDALONE_PYTHON_INTERFACE" standalone)
    ];

    # those are used by CMake at configure/build time
    nativeBuildInputs = super.nativeBuildInputs ++ [
      python
    ];

    propagatedBuildInputs = [
      pinocchio
    ]
    ++ super.propagatedBuildInputs
    ++ lib.optional standalone tsid;

    nativeCheckInputs = [
      pythonImportsCheckHook
    ];

    pythonImportsCheck = [
      "tsid"
    ];
  })
)
