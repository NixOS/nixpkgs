{ mkKdeDerivation }:
mkKdeDerivation {
  pname = "akonadi-calendar";

  extraCmakeFlags = [
    # FIXME: depends on kcoreaddons typesystem info, we need
    # a Shiboken wrapper to propagate this properly.
    "-DBUILD_PYTHON_BINDINGS=OFF"
  ];

  meta.mainProgram = "kalendarac";
}
