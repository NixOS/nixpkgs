{
  mkKdeDerivation,
  pkg-config,
  qtmultimedia,
  qtsvg,
  qtwebsockets,
  qtwebview,
  sonnet,
}:
mkKdeDerivation {
  pname = "tokodon";

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    qtmultimedia
    qtsvg
    qtwebsockets
    qtwebview
    sonnet
  ];

  extraCmakeFlags = [ "-DUSE_QTMULTIMEDIA=1" ];

  meta.mainProgram = "tokodon";
}
