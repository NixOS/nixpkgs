{
  stdenv,
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

    extraNativeBuildInputs = [qtsvg qttools];
    extraBuildInputs = [qtdeclarative];
    extraPropagatedBuildInputs = [qt5compat];
  };
in stdenv.mkDerivation {
  pname = "kirigami-wrapped";
  inherit (unwrapped) version;

  propagatedBuildInputs = [ unwrapped qqc2-desktop-style ];

  dontUnpack = true;
  dontWrapQtApps = true;

  passthru = { inherit unwrapped; };
}
