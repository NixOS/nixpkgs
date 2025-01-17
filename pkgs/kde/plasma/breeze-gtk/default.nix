{
  mkKdeDerivation,
  sass,
  python3,
  python3Packages,
}:
mkKdeDerivation {
  pname = "breeze-gtk";

  # FIXME(later): upstream
  patches = [ ./0001-fix-add-executable-bit.patch ];

  extraNativeBuildInputs = [
    sass
    python3
    python3Packages.pycairo
  ];
}
