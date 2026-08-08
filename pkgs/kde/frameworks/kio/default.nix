{
  mkKdeDerivation,
  qt5compat,
  qttools,
  kauth,
  acl,
  attr,
  lib,
  stdenv,
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
    kauth
  ]
  ++ lib.filter (lib.meta.availableOn stdenv.hostPlatform) [
    acl
    attr
  ];
}
