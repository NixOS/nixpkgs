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
    "-DKF_IGNORE_PLATFORM_CHECK=ON"
    "-DWITH_X11=OFF"
  ];

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    KF_IGNORE_PLATFORM_CHECK = "1";
  };
}
