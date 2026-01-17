{
  lib,
  stdenv,
  mkKdeDerivation,
  qt5compat,
  qttools,
  kauth,
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
    kauth
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    acl
    attr
  ];
}
