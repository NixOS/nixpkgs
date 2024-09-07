{
  lib,
  mkKdeDerivation,
  qtwebengine,
  qttools,
  kdevelop-pg-qt,
  pkg-config,
  shared-mime-info,
  apr,
  aprutil,
  boost,
  libastyle,
  libclang,
  libllvm,
  subversion,
}:
mkKdeDerivation {
  pname = "kdevelop";

  extraNativeBuildInputs = [
    kdevelop-pg-qt
    pkg-config
    shared-mime-info
  ];

  extraPropagatedBuildInputs = [
    qtwebengine
  ];

  extraBuildInputs = [
    qttools
    apr
    aprutil
    boost
    libastyle
    libclang
    libllvm
    subversion
  ];

  extraCmakeFlags = [
    "-DCLANG_BUILTIN_DIR=${libclang.lib}/lib/clang/${lib.versions.major libclang.version}/include"
    "-DAPR_CONFIG_PATH=${apr.dev}/bin"
    "-DAPU_CONFIG_PATH=${aprutil.dev}/bin"
  ];
}
