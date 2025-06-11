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
    ./0001-Remove-impure-smbd-search-path.patch
    # Allow loading kio-admin from the store
    ./allow-admin-from-store.patch
  ];

  extraBuildInputs = [
    qt5compat
    qttools
    acl
    attr
  ];
}
