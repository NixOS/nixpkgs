{
  mkKdeDerivation,
  qttools,
  qtsvg,
}:
mkKdeDerivation {
  pname = "kuserfeedback";

  # Disable server-side stuff we don't care about
  extraCmakeFlags = [
    "-DENABLE_CONSOLE=0"
    "-DENABLE_CLI=0"
  ];
  extraNativeBuildInputs = [
    qttools
    qtsvg
  ];
}
