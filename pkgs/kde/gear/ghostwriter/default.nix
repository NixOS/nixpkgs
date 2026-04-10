{
  lib,
  mkKdeDerivation,
  qtsvg,
  qttools,
  qtwebchannel,
  qtwebengine,
  qt5compat,
  pkg-config,
  hunspell,
  kdoctools,
  pandoc,
  multimarkdown,
  cmark,
}:
mkKdeDerivation {
  pname = "ghostwriter";

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    qtsvg
    qttools
    qtwebchannel
    qtwebengine
    qt5compat
    kdoctools
    hunspell
  ];

  qtWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      cmark
      multimarkdown
      pandoc
    ])
  ];

  meta.mainProgram = "ghostwriter";
}
