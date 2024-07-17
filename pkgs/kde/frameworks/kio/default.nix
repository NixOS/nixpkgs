{
  mkKdeDerivation,
  qt5compat,
  qttools,
  acl,
  attr,
}:
mkKdeDerivation {
  pname = "kio";

  patches = [
    # Remove hardcoded smbd search path
    # FIXME(later): discuss with upstream?
    ./0001-Remove-impure-smbd-search-path.patch
  ];

  extraBuildInputs = [
    qt5compat
    qttools
    acl
    attr
  ];
}
