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
