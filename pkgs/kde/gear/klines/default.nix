{
  mkKdeDerivation,
  _7zz,
}:
mkKdeDerivation {
  pname = "klines";

  extraNativeBuildInputs = [ _7zz ];

  meta.mainProgram = "klines";
}
