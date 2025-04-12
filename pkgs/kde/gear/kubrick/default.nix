{
  mkKdeDerivation,
  qtsvg,
  _7zz,
  libGLU,
}:
mkKdeDerivation {
  pname = "kubrick";

  extraNativeBuildInputs = [ _7zz ];
  extraBuildInputs = [
    qtsvg
    libGLU
  ];

  meta.mainProgram = "kubrick";
}
