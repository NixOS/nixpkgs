{
  lib,
  mkKdeDerivation,
  replaceVars,
  kwin,
  pkg-config,
  qttools,
  pam,
}:
mkKdeDerivation {
  pname = "plasma-login-manager";

  patches = [
    ./config-mtime.patch
    ./config-path.patch

    (replaceVars ./kwin-path.patch {
      kwin_wayland = lib.getExe' kwin "kwin_wayland";
      CMAKE_INSTALL_FULL_BINDIR = null;
    })
  ];

  extraNativeBuildInputs = [
    pkg-config
    qttools
  ];

  extraBuildInputs = [ pam ];

  extraCmakeFlags = [
    "-DUID_MIN=1000"
    "-DUID_MAX=29999"
    "-DINSTALL_PAM_CONFIGURATION=OFF"
  ];
}
