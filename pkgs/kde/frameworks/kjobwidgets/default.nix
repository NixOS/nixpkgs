{
  mkKdeDerivation,
  qttools,
}:
mkKdeDerivation {
  pname = "kjobwidgets";

  extraNativeBuildInputs = [ qttools ];

  # FIXME: depends on kcoreaddons typesystem info, we need
  # a Shiboken wrapper to propagate this properly.
  extraCmakeFlags = [ "-DBUILD_PYTHON_BINDINGS=OFF" ];
}
