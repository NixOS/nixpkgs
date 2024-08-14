{
  mkKdeDerivation,
  _7zz,
}:
mkKdeDerivation {
  pname = "klickety";

  extraNativeBuildInputs = [_7zz];

  meta.mainProgram = "klickety";
}
