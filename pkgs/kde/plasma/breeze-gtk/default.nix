{
  mkKdeDerivation,
  sass,
  python3,
  python3Packages,
}:
mkKdeDerivation {
  pname = "breeze-gtk";

  # FIXME(later): upstream
  patches = [./0001-fix-add-executable-bit.patch];

  # FIXME: hack to fix build, remove for 6.0.2
  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail "ECM 6.0.1" "ECM 6.0.0"
  '';

  extraNativeBuildInputs = [sass python3 python3Packages.pycairo];
}
