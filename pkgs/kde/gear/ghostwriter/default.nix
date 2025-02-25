{
  lib,
  mkKdeDerivation,
  pkg-config,
  hunspell,
  kdePackages,
  pandoc,
  multimarkdown,
  cmark,
}:
mkKdeDerivation {
  pname = "ghostwriter";

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = with kdePackages; [
    qtsvg
    qttools
    qtwebchannel
    qtwebengine
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
