{
  lib,

  toPythonModule,
  pythonImportsCheckHook,

  tsid,

  pinocchio,
  python,
<<<<<<< HEAD

  buildStandalone ? true,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:
toPythonModule (
  tsid.overrideAttrs (super: {
    pname = "py-${super.pname}";

    cmakeFlags = super.cmakeFlags ++ [
      (lib.cmakeBool "BUILD_PYTHON_INTERFACE" true)
<<<<<<< HEAD
      (lib.cmakeBool "BUILD_STANDALONE_PYTHON_INTERFACE" buildStandalone)
=======
      (lib.cmakeBool "BUILD_STANDALONE_PYTHON_INTERFACE" true)
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    ];

    # those are used by CMake at configure/build time
    nativeBuildInputs = super.nativeBuildInputs ++ [
      python
    ];

<<<<<<< HEAD
    propagatedBuildInputs = [
      pinocchio
    ]
    ++ super.propagatedBuildInputs
    ++ lib.optional buildStandalone tsid;
=======
    propagatedBuildInputs = super.propagatedBuildInputs ++ [
      pinocchio
      tsid
    ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    nativeCheckInputs = [
      pythonImportsCheckHook
    ];

    pythonImportsCheck = [
      "tsid"
    ];
  })
)
