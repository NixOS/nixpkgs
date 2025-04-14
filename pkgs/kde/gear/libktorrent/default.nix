{
  mkKdeDerivation,
  doxygen,
  qt5compat,
  boost,
  gmp,
  libgcrypt,
  fetchpatch,
}:
mkKdeDerivation {
  pname = "libktorrent";

  # Backport patches to fix build with Qt 6.9
  # FIXME: remove in 25.04
  patches = [
    (fetchpatch {
      url = "https://invent.kde.org/network/libktorrent/-/commit/4bcf7eb1e0cb781286eae33751acd8e827080ec5.patch";
      includes = [ "src/utp/connection.cpp" ];
      hash = "sha256-gj5jLViuzttfzCrx/izmajJiH3vE9TkfsXS+1r/qGNc=";
    })
    (fetchpatch {
      url = "https://invent.kde.org/network/libktorrent/-/commit/4f73038c74b5d72b2f7f1377c7bf037f111e965d.patch";
      hash = "sha256-dQeZLmnagxBOUR2hnxF65jIRSAntTrEggxdUf3NNzDE=";
    })
  ];

  extraNativeBuildInputs = [ doxygen ];
  extraBuildInputs = [ qt5compat ];
  extraPropagatedBuildInputs = [
    boost
    gmp
    libgcrypt
  ];
}
