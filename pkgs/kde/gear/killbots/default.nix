{
  mkKdeDerivation,
  _7zz,
}:
mkKdeDerivation {
  pname = "killbots";

  extraNativeBuildInputs = [_7zz];
  meta.mainProgram = "killbots";
}
