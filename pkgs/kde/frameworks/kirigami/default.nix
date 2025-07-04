{
  stdenv,
  fetchpatch,
  mkKdeDerivation,
  qtsvg,
  qttools,
  qtdeclarative,
  qt5compat,
  qqc2-desktop-style,
}:
# Kirigami has a runtime dependency on qqc2-desktop-style,
# which has a build time dependency on Kirigami.
# So, build qqc2-desktop-style against unwrapped Kirigami,
# and replace all the other Kirigami with a wrapper that
# propagates both Kirigami and qqc2-desktop-style.
# This is a hack, but what can you do.
let
  unwrapped = mkKdeDerivation {
    pname = "kirigami";

    # Backport patch recommended by upstream
    # FIXME: remove in next update
    patches = [
      (fetchpatch {
        url = "https://invent.kde.org/frameworks/kirigami/-/commit/21788be688de90d4f12edb9f45967a481801bd5e.patch";
        hash = "sha256-BNp1Sc0qSXBJkyKSYW6sq0s2yN959iwnSxaZtOTmaNc=";
      })
    ];

    extraNativeBuildInputs = [
      qtsvg
      qttools
    ];
    extraBuildInputs = [ qtdeclarative ];
    extraPropagatedBuildInputs = [ qt5compat ];
  };
in
stdenv.mkDerivation {
  pname = "kirigami-wrapped";
  inherit (unwrapped) version;

  propagatedBuildInputs = [
    unwrapped
    qqc2-desktop-style
  ];

  dontUnpack = true;
  dontWrapQtApps = true;

  passthru = {
    inherit unwrapped;
  };
}
