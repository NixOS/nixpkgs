{
  lib,
  fetchpatch,
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

    # Fix greeter and wallpaper recovery after display reconnect.
    (fetchpatch {
      url = "https://invent.kde.org/plasma/plasma-login-manager/-/commit/1c99b3b1f161ca880f8a8154d9258ced26ba7a7a.patch";
      hash = "sha256-g3L7djHpdH6lECT+Of4RYeBzHRUmXxUjyO6oYwD22I8=";
    })
    (fetchpatch {
      url = "https://invent.kde.org/plasma/plasma-login-manager/-/commit/0b4ea53ad4e31a49587199683ba0a6aca21caeea.patch";
      hash = "sha256-4Ad5g/2z1nOdKTVhYQIpC0ORnMG8VW2xa8v4elbuGRQ=";
    })

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

  postInstall = ''
    install -Dm444 ${./defaults.conf} $out/lib/plasmalogin/defaults.conf
  '';
}
