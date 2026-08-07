{
  lib,
  stdenv,
  mkKdeDerivation,
  qttools,
}:
mkKdeDerivation {
  pname = "kglobalaccel";

  extraNativeBuildInputs = [ qttools ];

  extraCmakeFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    (lib.cmakeBool "KF_IGNORE_PLATFORM_CHECK" true)
    (lib.cmakeBool "WITH_X11" false)
  ];

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    KF_IGNORE_PLATFORM_CHECK = "1";
  };
}
